# frozen_string_literal: true

require 'user/user_manager'
require 'model/user'
require 'bcrypt'

module User # rubocop:disable Metrics/ModuleLength
  describe UserManager do
    subject { user_manager }

    let(:user_manager) do
      described_class.new(user_model, password_encryptor, registration_validator)
    end
    let(:registration_validator) { instance_double(User::RegistrationValidator) }
    let(:user_model) do
      user_model = class_double(Model::User)
      allow(user_model).to receive(:create)
      allow(user_model).to receive(:exists?)
      user_model
    end

    let(:password_encryptor) do
      password_encryptor = class_double(BCrypt::Password)
      allow(password_encryptor).to receive(:create).with(valid_password).and_return(password_hash)
      password_encryptor
    end

    let(:password_hash) do
      password_hash = instance_double(BCrypt::Password)
      allow(password_hash).to receive(:to_s).and_return(expected_hashed_password)
      password_hash
    end

    let(:expected_hashed_password) { 'hashed_password' }

    let(:valid_email) { 'asd_elganob@yahoo.com' }
    let(:valid_password) { 'password1' }
    let(:valid_password2) { 'password2' }
    let(:invalid_password) { 'pass' }

    let(:invalid_email_error) { 'Email is invalid.' }
    let(:email_in_use_error) { 'Email is already in use.' }
    let(:invalid_password_error) { 'Password must be alphanumeric of minimum length 7 characters.' }
    let(:password_mismatch_error) { "Password and confirmation don't match" }

    context 'when a user logs in' do
      let(:invalid_login_error) { 'The provided credentials are invalid' }

      let(:invalid_email) { 'bad@email.com' }
      let(:valid_password) { 'valid_password1' }
      let(:mismatching_password) { 'invalid_password1' }
      let(:valid_user) { { email: valid_email, password: valid_password } }

      let(:valid_encrypted_password) do
        valid_encrypted_password = instance_double(BCrypt::Password)
        allow(valid_encrypted_password).to receive(:==).with(valid_password).and_return true
        valid_encrypted_password
      end

      before do
        allow(password_encryptor)
          .to receive(:new).with(valid_password).and_return valid_encrypted_password
      end

      context 'when both email and password are invalid' do
        before do
          allow(user_model).to receive(:find_by).with(email: invalid_email).and_return nil
        end

        it 'returns invalid login error message' do
          expect(user_manager.login(email: invalid_email, password: mismatching_password))
            .to eq(invalid_login_error)
        end
      end

      context 'when the email is valid but the password is invalid' do
        before do
          allow(user_model).to receive(:find_by).with(email: valid_email).and_return valid_user
          allow(valid_encrypted_password).to receive(:==)
            .with(mismatching_password).and_return false
        end

        it 'returns invalid login error message' do
          expect(user_manager.login(email: valid_email, password: mismatching_password))
            .to eq(invalid_login_error)
        end
      end

      context 'when both email and password are valid' do
        before do
          allow(user_model).to receive(:find_by).with(email: valid_email).and_return valid_user
        end

        it 'returns nil' do
          expect(user_manager.login(email: valid_email, password: valid_password)).to be_nil
        end
      end

      context 'when registering a new user' do
        context 'when user params are valid' do
          let(:first_name) { 'first' }
          let(:last_name) { 'last' }

          let(:valid_params) do
            {
              firstName: first_name,
              lastName: last_name,
              password: valid_password,
              email: valid_email
            }
          end

          let(:expected_registeration_params) do
            {
              email: valid_email,
              password: expected_hashed_password,
              first_name: first_name,
              last_name: last_name
            }
          end

          before do
            allow(registration_validator).to receive(:valid_params?)
              .with(valid_params).and_return({})
          end

          it 'returns empty errors hash' do
            expect(user_manager.register(valid_params)).to be_empty
            expect(user_model).to have_received(:create).with(expected_registeration_params).once
          end
        end

        context 'when user params are invalid' do
          let(:invalid_params) { { key1: 'val1' } }
          let(:expected_errors) { { firstName: 'errors' } }

          before do
            allow(registration_validator).to receive(:valid_params?)
              .with(invalid_params).and_return(expected_errors)
          end

          it 'does not create a new email and returns the errors hash' do
            expect(user_manager.register(invalid_params)).to eq(expected_errors)
            expect(user_model).not_to have_received(:create)
          end
        end
      end
    end
  end
end

require './lib/user_registeration'
require './lib/model/user'
require 'bcrypt'

describe UserRegistration do
  subject { user_registeration }

  let(:user_registration) { described_class.new(user_model, password_encryptor) }
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

  context "when there's an error with the params" do
    let(:invalid_email) { 'asd.com' }

    context 'when an already used email is used' do
      before do
        allow(user_model).to receive(:exists?).with(email: valid_email).and_return(true)
      end

      it 'returns an already used email error' do
        expect(user_registration
          .register(
            email: valid_email,
            password: valid_password,
            passwordConfirmation: valid_password
          ))
          .to eq(email_in_use_error)
      end

      it 'does not use the database' do
        user_registration
          .register(
            email: valid_email,
            password: valid_password,
            passwordConfirmation: valid_password
          )
        expect(user_model).not_to have_received(:create)
        expect(user_model).to have_received(:exists?).with(email: valid_email)
      end
    end

    context 'when an invalid email is used' do
      it 'returns an invald email error' do
        expect(user_registration
          .register(
            email: invalid_email,
            password: valid_password,
            passwordConfirmation: valid_password
          ))
          .to eq(invalid_email_error)
        expect(user_model).not_to have_received(:exists?)
        expect(user_model).not_to have_received(:create)
      end
    end

    context "when password doesn't match the expected pattern" do
      before do
        allow(user_model).to receive(:exists?).with(email: valid_email).and_return(false)
      end

      it 'returns an invald password error' do
        expect(user_registration
          .register(
            email: valid_email,
            password: invalid_password,
            passwordConfirmation: invalid_password
          ))
          .to eq(invalid_password_error)
        expect(user_model).not_to have_received(:create)
      end
    end

    context "when password and confirmation don't match" do
      before do
        allow(user_model).to receive(:exists?).with(email: valid_email).and_return(false)
      end

      it 'returns an invald password error' do
        expect(user_registration
          .register(
            email: valid_email,
            password: valid_password,
            passwordConfirmation: valid_password2
          ))
          .to eq(password_mismatch_error)
        expect(user_model).not_to have_received(:create)
      end
    end
  end

  context 'when the parameters are valid' do
    before do
      allow(user_model).to receive(:exists?).with(email: valid_email).and_return(false)
    end

    it 'returns an invald password error' do
      expect(user_registration
        .register(
          email: valid_email,
          password: valid_password,
          passwordConfirmation: valid_password
        ))
        .to eq(nil)
      expect(user_model).to have_received(:create)
        .with(email: valid_email, password: expected_hashed_password).once
    end
  end
end

require 'user/registration_validator'
require 'model/user'

module User
  describe RegistrationValidator do
    subject { registration_validator }

    let(:registration_validator) { described_class.new(user_model) }
    let(:user_model) do
      user_model = class_double(Model::User)
      allow(user_model).to receive(:exists?)
      user_model
    end

    let(:valid_email) { 'mado@gmail.com' }
    let(:valid_password) { 'valid_password1' }
    let(:valid_password_confirmation) { 'valid_password1' }
    let(:valid_first_name) { 'first' }
    let(:valid_last_name) { 'lastn' }

    let(:invalid_email) { 'madogmail.com' }
    let(:invalid_password) { 'valid' }
    let(:invalid_password_confirmation) { 'valid_password' }
    let(:invalid_first_name) { 'fir' }
    let(:invalid_last_name) { 'lastdfdfdfdfdfdfdfdfdfdfdfn' }

    let(:invalid_email_error) { 'Email is invalid.' }
    let(:email_in_use_error) { 'Email is already in use.' }
    let(:invalid_password_error) { 'Password must be alphanumeric of minimum length 7 characters.' }
    let(:password_mismatch_error) { "Password and confirmation don't match" }
    let(:invalid_name_error) { 'Name must be between 5 and 20 characters with no space.' }

    context 'when passing a correct parameters' do
      let(:params) do
        {
          email: valid_email,
          password: valid_password,
          passwordConfirmation: valid_password_confirmation,
          firstName: valid_first_name,
          lastName: valid_last_name
        }
      end

      it 'returns an empty hash' do
        expect(registration_validator.valid_params?(params)).to be_empty
      end
    end

    context 'when all items are missing' do
      let(:expected_errors) do
        {
          email: invalid_email_error,
          firstName: invalid_name_error,
          lastName: invalid_name_error,
          password: invalid_password_error
        }
      end

      it 'returns an error for each item' do
        expect(registration_validator.valid_params?({})).to eq(expected_errors)
      end
    end

    context 'when invalid parameters are used' do
      let(:params) do
        {
          email: invalid_email,
          password: invalid_password,
          passwordConfirmation: invalid_password_confirmation,
          firstName: invalid_first_name,
          lastName: invalid_last_name
        }
      end

      let(:expected_errors) do
        {
          email: invalid_email_error,
          firstName: invalid_name_error,
          lastName: invalid_name_error,
          password: invalid_password_error,
          passwordConfirmation: password_mismatch_error
        }
      end

      it 'returns an error message for each item specifying the reason of failure' do
        expect(registration_validator.valid_params?(params)).to eq(expected_errors)
      end
    end
  end
end

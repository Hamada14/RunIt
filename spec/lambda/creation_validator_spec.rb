# frozen_string_literal: true

require 'lambda/creation_validator'
require 'model/lambda'

module Lambda
  describe CreationValidator do
    subject { validator }

    let(:validator) { described_class.new(lambda_model).valid_params?(params, user_id) }
    let(:lambda_model) do
      lambda_model = class_double(Model::Lambda)
      allow(lambda_model).to receive(:joins)
      lambda_model
    end
    let(:lambda_user_join) { class_double(ActiveRecord::Base) }

    let(:user_id) { 1 }

    before do
      allow(lambda_model).to receive(:joins).with(:user).and_return(lambda_user_join)
    end

    context 'when passing a valid data' do
      let(:params) { { lambdaName: valid_lambda_name } }
      let(:valid_lambda_name) { 'lambdaname' }

      before do
        allow(lambda_user_join)
          .to receive(:find_by)
          .with('users.id' => user_id, 'lambdas.name' => valid_lambda_name)
          .and_return nil
      end

      it { is_expected.to be_empty }
    end

    context 'when passing an invalid lambda' do
      context 'when the lambda name is short' do
        let(:invalid_lambda_name) { '123456789' }
        let(:params) { { lambda_name: invalid_lambda_name } }
        let(:invalid_lambda_name_error) { 'Invalid Lambda name format' }
        let(:expected_errors) { { lambdaName: invalid_lambda_name_error } }

        before do
          allow(lambda_user_join)
            .to receive(:find_by)
            .with('users.id' => user_id, 'lambdas.name' => invalid_lambda_name)
            .and_return nil
        end

        it 'returns an error regarding the name format' do
          is_expected.to eq expected_errors
        end
      end

      context 'when the lambda name is duplicate' do
        let(:duplicate_lambda_name_error) { 'Duplicate Lambda name' }
        let(:duplicate_lambda_name) { 'duplicatelambda' }
        let(:params) { { lambdaName: duplicate_lambda_name } }
        let(:expected_errors) { { lambdaName: duplicate_lambda_name_error } }

        before do
          allow(lambda_user_join)
            .to receive(:find_by)
            .with('users.id' => user_id, 'lambdas.name' => duplicate_lambda_name)
            .and_return ['lambda']
        end

        it 'returns an error regarding the name format' do
          is_expected.to eq expected_errors
        end
      end

      context 'when passing a short name' do
        let(:short_lambda_name) { 'lambda' }
        let(:params) { { lambda_name: short_lambda_name } }
        let(:invalid_lambda_name_error) { 'Invalid Lambda name format' }
        let(:expected_errors) { { lambdaName: invalid_lambda_name_error } }

        before do
          allow(lambda_user_join)
            .to receive(:find_by)
            .with('users.id' => user_id, 'lambdas.name' => short_lambda_name)
            .and_return nil
        end

        it 'returns an error regarding the name format' do
          is_expected.to eq expected_errors
        end
      end
    end
  end
end

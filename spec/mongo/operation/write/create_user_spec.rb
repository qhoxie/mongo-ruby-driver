require 'spec_helper'

describe Mongo::Operation::Write::CreateUser do

  describe '#execute' do

    let(:user) do
      Mongo::Auth::User.new(
        user: 'durran',
        password: 'password',
        roles: [ Mongo::Auth::Roles::READ_WRITE ]
      )
    end

    let(:operation) do
      described_class.new(user: user, db_name: TEST_DB)
    end

    let!(:response) do
      operation.execute(authorized_primary.context)
    end

    after do
      authorized_client.database.users.remove('durran')
    end

    context 'when user creation was successful' do

      it 'saves the user in the database' do
        expect(response).to be_ok
      end
    end

    context 'when creation was not successful' do

      it 'raises an exception' do
        expect {
          operation.execute(authorized_primary.context)
        }.to raise_error(Mongo::Operation::Write::Failure)
      end
    end
  end
end

module Api
  module V1
    module Account
      module Base
        def self.schema # rubocop:disable Metrics/MethodLength
          {
            id: {
              type: :number,
              desc: 'Account id',
              required: { on_create: false, on_update: true }
            },
            name: {
              type: String,
              desc: 'Account name',
              required: { on_create: false, on_update: false }
            },
            description: {
              type: String,
              desc: 'Account description',
              required: { on_create: false, on_update: false }
            },
            account_type: {
              type: ::Account.account_types.keys,
              desc: 'Account Type',
              required: { on_create: true, on_update: false }
            },
            financial_institution_id: {
              type: :number,
              desc: 'Account related financial_institution id',
              required: { on_create: true, on_update: false }
            }
          }
        end
      end
    end
  end
end

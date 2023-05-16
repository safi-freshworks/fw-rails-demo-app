
class NameValidator < ActiveModel::Validator
    def validate(record)
        if record.name.present? && record.name.length < 3
            record.errors.add(:name, "must be greater than 3")
        end

        # & - ?
    end
end
module InvoiceNumbers
  module InvoiceNumbers
    def self.included( base )
      base.send( :extend, ClassMethods )
    end

    module ClassMethods
      def has_invoice_number( field_name, options = {} )
        invoice_number_field         = field_name
        invoice_number_sequence      = options[:invoice_number_sequence]
        invoice_number_sequence    ||= self.name.to_s.underscore
        invoice_number_assign_if     = options[:assign_if]
        invoice_number_prefix        = options[:prefix]
	invoice_number_scope = options[:scope] ||= nil

        if invoice_number_assign_if
          before_save :"assign_#{invoice_number_field}"
        end

        send(:define_method, :assign_invoice_number) do
          send("assign_#{invoice_number_field}")
        end

        send(:define_method, "assign_#{invoice_number_field}") do
          do_assign = Proc.new do

	    field = read_attribute( invoice_number_field )
	    sequence_is_lambda = invoice_number_sequence.respond_to?(:call)
	    if invoice_number_scope
	      scope_field = read_attribute(invoice_number_scope)
	      scope_changed = self.send("#{invoice_number_scope}_changed?")
	      change_number = scope_field && scope_changed
	    end

	    if field.blank? || change_number
              if invoice_number_assign_if.nil? or invoice_number_assign_if.call(self)
                sequence = sequence_is_lambda ? invoice_number_sequence.call(self) : invoice_number_sequence
		if invoice_number_scope && self.send(invoice_number_scope).nil?
		  write_attribute(invoice_number_field,nil) 
		  return 
		end
                write_attribute( invoice_number_field, "#{invoice_number_prefix || '' }#{Generator.next_invoice_number( sequence )}" )
              end
            end
          end

          if respond_to?(:transaction)
            transaction do
              do_assign.call
            end
          else
            do_assign.call
          end
        end
      end
    end
  end
end

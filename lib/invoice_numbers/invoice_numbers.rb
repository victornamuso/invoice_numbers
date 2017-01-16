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
	invoice_number_scope         = options[:invoice_number_scope]

        if invoice_number_assign_if
          before_save :"assign_#{invoice_number_field}"
        end

        send(:define_method, :assign_invoice_number) do
          send("assign_#{invoice_number_field}")
        end

        send(:define_method, "assign_#{invoice_number_field}") do
          do_assign = Proc.new do
	    scope =  read_attribute(invoice_number_scope) if invoice_number_scope
            if read_attribute( invoice_number_field ).blank? || (scope && read_attribute("#{invoice_number_scope}_changed?"))
              if invoice_number_assign_if.nil? or invoice_number_assign_if.call(self)
                sequence = invoice_number_sequence.respond_to?(:call) ? invoice_number_sequence.call(self) : invoice_number_sequence
		return if scope.nil? && invoice_number_scope
		sequence = scope if scope
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

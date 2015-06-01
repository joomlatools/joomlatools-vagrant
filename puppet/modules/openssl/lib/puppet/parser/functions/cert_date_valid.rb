#
# Function: cert_date_valid()
#
# Checks SSL cetificate date validity.
#
# Returns false if the certificate is expired or not yet valid, or the number
# of seconds the certificate is still valid for.
#
# Parameter: path to ssl certificate
#
module Puppet::Parser::Functions
    newfunction(:cert_date_valid, :type => :rvalue) do |args|

        require 'time'

        certfile = args[0]
        dates = `openssl x509 -dates -noout < #{certfile}`.gsub("\n", '')

        raise "No date found in certificate" unless dates.match(/not(Before|After)=/)

        certbegin = Time.parse(dates.gsub(/.*notBefore=(.+? GMT).*/, '\1'))
        certend   = Time.parse(dates.gsub(/.*notAfter=(.+? GMT).*/, '\1'))
        now       = Time.now

        if (now > certend)
            # certificate is expired
            false
        elsif (now < certbegin)
            # certificate is not yet valid
            false
        elsif (certend <= certbegin)
            # certificate will never be valid
            false
        else
            # return number of seconds certificate is still valid for
            (certend - now).to_i
        end

    end
end

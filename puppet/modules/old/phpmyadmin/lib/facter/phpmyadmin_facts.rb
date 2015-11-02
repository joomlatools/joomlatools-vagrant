# taken from: http://nuknad.com/2011/02/11/self-classifying-puppet-nodes/
#
# The following is a facter plugin that will parse the file /etc/phpmyadmin.facts
# and append them to the existing facts.
# Given the following facts file:
#
# mysql_root_password=foo
# controluser_password=bar
#
# We will get the following from facter:
#
# pma_mysql_root_password=foo
# pma_controluser_password=bar
#
require 'facter'

if File.exist?("/etc/phpmyadmin.facts")
    File.readlines("/etc/phpmyadmin.facts").each do |line|
        if line =~ /^(.+)=(.+)$/
            var = "pma_"+$1.strip;
            val = $2.strip

            Facter.add(var) do
                setcode { val }
            end
        end
    end
end


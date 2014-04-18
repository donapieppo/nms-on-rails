module NmsOnRails
  # example.com
  REGEXP_FOR_DOMAIN     = Regexp.new '\A(([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\.)*([a-z]|[a-z][a-z0-9\-]*[a-z0-9])\z'
  # tester.example.com. 39600 IN  A 137.204.134.31
  REGEXP_FOR_HOST_ENTRY = Regexp.new '\A(.*?)\s+\d+\s+IN\s+A\s+(\d+\.\d+\.\d+\.\d+)'
  # 192.168.1.12
  REGEXP_FOR_IP         = Regexp.new '\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z'
end

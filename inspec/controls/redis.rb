control 'redis-rules-01' do
    impact 1.0
    title 'Redis user and group check'
    desc 'Redis user and group should exist'

    describe user('redis') do
        it { should exist }
        its('shell') { should eq '/sbin/nologin' }
    end

    describe group('redis') do
        it { should exist }
    end
end

control 'redis-rules-02' do
    impact 1.0
    title 'Redis file and permissions check'
    desc 'Redis dile and permissions should be valid'

    describe file('/var/log/redis') do
        it { should exist }
        its('owner') { should eq 'redis' }
        its('group') { should eq 'redis' }
        its('mode') { should cmp '0755' }
    end

    describe file('/etc/systemd/system/redis.service') do
        it { should exist }
        its('owner') { should eq 'root' }
        its('group') { should eq 'root' }
        its('mode') { should cmp '0644' }
    end

    describe file('/etc/redis/cluster') do
        it { should exist }
        its('owner') { should eq 'redis' }
        its('group') { should eq 'redis' }
        its('mode') { should cmp '0644' }
    end
end

control 'redis-rules-03' do
    impact 1.0
    title 'Redis service status'
    desc 'Redis service should be up and running'

    describe service('redis') do
        it { should be_installed }
        it { should be_enabled }
        it { should be_running }
      end
end

control 'redis-rules-04' do
    impact 1.0
    title 'Redis port status'
    desc 'Redis port should be listening on 0.0.0.0'

    describe port(6379) do
        its('protocols') { should include 'tcp' }
        its('addresses') { should include '0.0.0.0' }
    end
end

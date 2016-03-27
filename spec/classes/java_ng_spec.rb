require 'spec_helper'

describe 'java_ng' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "java_ng class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('java_ng') }
          it { is_expected.to contain_class('java_ng::params') }
          it { is_expected.to contain_class('java_ng::install') }

          case os
          when 'debian-6-x86_64'
            it { is_expected.to contain_package('openjdk-7-jre-headless')}
          when 'debian-7-x86_64', 'debian-8-x86_64', 'ubuntu-14-x86_64'
            it { is_expected.to contain_package('openjdk-7-jre-headless')}
          when /(centos|scientific|redhat)-(5|6|7)-x86_64/
            it { is_expected.to contain_package('java-1.8.0-openjdk-headless')}
          end
        end

        context "java_ng class with Java 8" do
          let(:params) do
            {
              :version => 8,
            }
          end
          it { is_expected.to compile.with_all_deps }
          case os
          when /debian-(6|7)-x86_64/
            # openjdk 8 from trusty ppa:openjdk-r incompatible
            it { is_expected.to contain_package('oracle-java8-installer')}
            it { is_expected.to contain_package('oracle-java8-unlimited-jce-policy')}
          when 'debian-8-x86_64', 'ubuntu-14-x86_64'
            it { is_expected.to contain_package('openjdk-8-jre-headless')}
          when /(centos|scientific|redhat)-(5|6|7)-x86_64/
            it { is_expected.to contain_package('java-1.8.0-openjdk-headless')}
          end
        end

        context "java_ng class with Oracle Java 8" do
          let(:params) do
            {
              :repo    => ['ppa:oracle', 'native'],
              :version => 8,
            }
          end
          it { is_expected.to compile.with_all_deps }
          case os
          when 'debian-6-x86_64'
            it { is_expected.to contain_package('oracle-java8-installer')}
            it { is_expected.to contain_package('oracle-java8-unlimited-jce-policy')}
          when 'debian-7-x86_64', 'debian-8-x86_64', 'ubuntu-14-x86_64'
            it { is_expected.to contain_package('oracle-java8-installer')}
            it { is_expected.to contain_package('oracle-java8-unlimited-jce-policy')}
          when /(centos|scientific|redhat)-(5|6|7)-x86_64/
            it { is_expected.to contain_package('java-1.8.0-openjdk-headless')}
          end
        end

      end
    end
  end

  context 'unsupported operating system' do
    describe 'java_ng class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_class('java_ng::install') }.to raise_error(Puppet::Error, /Solaris.Nexenta not supported/) }
    end
  end
end

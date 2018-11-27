require 'spec_helper'
 
describe 'adopt_openjdk', :type => 'class' do

  context "Should install openJdk 9" do
  let(:facts) { { 
    :host => Hash.new,
    :osfamily => 'RedHat',
    :kernel => 'Linux',
    :architecture => 'x86_64' } }
  
    it do
      should contain_adopt_openjdk__java_install('9')
    end
  end

  context "Should install openJdk 9 and 10" do

    let(:params) { { :versions => ['9','10'] } }
    let(:facts) { { :host => Hash.new, :osfamily => 'RedHat',
    :kernel => 'Linux',
    :architecture => 'x86_64' } }
    it do
      should contain_adopt_openjdk__java_install('9')
      should contain_adopt_openjdk__java_install('10')
    end
  end

  context "Should install jdk 9 and 11, setting 11 as the default" do

    let(:params) { { :versions => ['9','11'], :default_ver => '11' } }
    let(:facts) { { :host => Hash.new, :osfamily => 'RedHat',
    :kernel => 'Linux',
    :architecture => 'x86_64' } }
    it do
      should contain_adopt_openjdk__java_install('9')
      should contain_adopt_openjdk__java_install('11')
      should contain_exec('Set default Java version: jdk-11')
    end
  end

end

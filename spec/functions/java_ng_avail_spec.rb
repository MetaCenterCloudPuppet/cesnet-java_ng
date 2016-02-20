require 'spec_helper'

describe 'java_ng_avail' do
  let(:facts) do
    {
      :osfamily => 'Debian',
      :operatingsystem => 'Debian',
    }
  end

  # two versions
  let(:ja) do
    {
      'native' => ["6", "7"],
      'ppa'    => ["7", "8"],
    }
  end
  # three versions
  let(:ja2) do
    {
      'native' => ["6", "7", "8"],
      'ppa'    => ["7", "8"],
    }
  end
  # puppet 4 and integers
  let(:ja3) do
    {
      'native' => [6, 7, 8],
      'ppa'    => [7, 8],
    }
  end

   it { should run.with_params([7, 8], ['native', 'ppa'], false, ja).and_return({'repo' => 'native', 'version' => "7"}) }
   it { should run.with_params([7, 8], ['native', 'ppa'], true, ja).and_return({'repo' => 'native', 'version' => "7"}) }
   it { should run.with_params([8, 7], ['native', 'ppa'], false, ja).and_return({'repo' => 'native', 'version' => "7"}) }
   it { should run.with_params([8, 7], ['native', 'ppa'], true, ja).and_return({'repo' => 'ppa', 'version' => "8"}) }

   it { should run.with_params(8, ['native', 'ppa'], false, ja).and_return({'repo' => 'ppa', 'version' => "8"}) }
   it { should run.with_params([7, 8], 'native', false, ja).and_return({'repo' => 'native', 'version' => "7"}) }

   it { should run.with_params([9], ['native', 'ppa'], false, ja).and_return({'repo' => nil, 'version' => nil}) }
   it { should run.with_params([9], ['native', 'ppa'], true, ja).and_return({'repo' => nil, 'version' => nil}) }

  it { should run.with_params([8, 7], ['native', 'ppa'], false, ja2).and_return({'repo' => 'native', 'version' => "8"})}

  it { should run.with_params([8, 7], ['native', 'ppa'], false, ja3).and_return({'repo' => 'native', 'version' => "8"})}

end

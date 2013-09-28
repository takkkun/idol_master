require 'pathname'

ROOT    = Pathname.new(__FILE__).dirname.expand_path
lib_dir = ROOT.join('lib')
$LOAD_PATH.unshift(lib_dir.to_s) unless $LOAD_PATH.include?(lib_dir.to_s)

require 'idol_master'

namespace :cg do
  task :load do
    user_name = ENV['USER'] || 'default'
    user_path = ROOT.join('users', "#{user_name}.yaml")
    @user = IdolMaster::CinderellaGirls::User.new(user_path, idol_store: {cache_path: ROOT.join('.cache', 'idols.yaml')})
  end

  task :ensure_offensive_idols => 'cg:load' do
    @offensive_idols = @user.ensure_idols(:offence)
  end

  task :ensure_defensive_idols => 'cg:load' do
    @defensive_idols = @user.ensure_idols(:defence)
  end

  task :rank do
    Rake::Task['cg:rank:offence'].invoke
    Rake::Task['cg:rank:separate'].execute
    Rake::Task['cg:rank:defence'].invoke
    Rake::Task['cg:rank:separate'].execute
    Rake::Task['cg:rank:outcast'].invoke
  end

  namespace :rank do
    task :offence => 'cg:ensure_offensive_idols' do
      puts 'Offensive idols:'
      puts @offensive_idols.output.lines.map { |line| "  #{line}" }
      puts "  Total: #{@offensive_idols.value}"
    end

    task :defence => 'cg:ensure_defensive_idols' do
      puts 'Defensive idols:'
      puts @defensive_idols.output.lines.map { |line| "  #{line}" }
      puts "  Total: #{@defensive_idols.value}"
    end

    task :outcast => %w(cg:ensure_offensive_idols cg:ensure_defensive_idols) do
      puts 'Outcast idols:'
      puts (@user.idols - @offensive_idols - @defensive_idols).map { |idol| "  #{idol}" }
    end

    task :separate do
      puts
    end
  end
end

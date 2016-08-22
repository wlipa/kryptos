namespace :kryptos do

  desc 'Deploy key file for kryptos'
  task :deploy_key do
    on roles(:app) do
      puts "#{fetch(:deploy_to)}/config/kryptos.key"
      upload! 'config/kryptos.key', "#{fetch(:release_path)}/config/kryptos.key"
    end
  end


  after "deploy:updating",  "kryptos:deploy_key"

end

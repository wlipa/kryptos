namespace :kryptos do

  desc 'Deploy key file for kryptos'
  task :deploy_key do
    on roles(:app) do
      upload! 'config/kryptos.key', "#{fetch(:release_path)}/config/kryptos.key"
    end
  end


  after "deploy:updating",  "kryptos:deploy_key"

end

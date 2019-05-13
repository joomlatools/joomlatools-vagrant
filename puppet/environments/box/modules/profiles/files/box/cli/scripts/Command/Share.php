<?php
namespace Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use \Twig\Environment;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class Share extends Command
{
    protected $site;
    protected $www;
    protected $vhost_dir;
    protected $vhost_file;
    protected $tmp_dir;

    protected function configure()
    {
        $this->setName('share:site')
             ->setDescription('Share a local site with a colleague')
            ->addArgument('site',
                InputArgument::REQUIRED,
                'provide the site name')
            ->addOption(
                'www',
                null,
                InputOption::VALUE_REQUIRED,
                "Web server root",
                '/var/www'
            );

        //add optional run in background
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $this->vhost_dir = '/etc/apache2/sites-available';
        $this->vhost_file = '2-ngrok.conf';
        $this->tmp_dir = '/tmp';

        $this->www = $input->getOption('www');
        $this->site = $input->getArgument('site');

        //going to need to port anything www or site related

        //going to need to check (site exists)

        $loader = new \Twig\Loader\FilesystemLoader('Command/templates/');
        $this->twig = new \Twig\Environment($loader);

        if (file_exists($this->vhost_dir . '/' . $this->vhost_file))
        {
            `sudo rm -f $this->vhost_dir/$this->vhost_file`;
            `sudo /etc/init.d/apache2 restart > /dev/null 2>&1`;
        }

        $template = $this->twig->load('ngrok_vhost.twig');

        $vhost_config = $template->render(['path_to_site' => $this->www . "/" . $this->site, 'site' => $this->site]);

        file_put_contents($this->tmp_dir . "/" . $this->vhost_file, $vhost_config);

        `sudo tee /etc/apache2/sites-available/$this->vhost_file < $this->tmp_dir/$this->vhost_file`;

        `sudo a2ensite $this->vhost_file`;
        `sudo /etc/init.d/apache2 restart > /dev/null 2>&1`;
        `rm -f $this->tmp_dir/$this->vhost_file`;


        //so launch in the background
        `screen -d -m ngrok http $this->site.test:80`;

        //wait for the api to return connection details
        do
        {
            $result = shell_exec("curl -s localhost:4040/api/tunnels");
            $json = json_decode($result);
        } while (!isset($json->tunnels[0]->public_url));


        //then switch screens for the user
        `screen -r`;
    }
}
<?php
namespace Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;

class Share extends Command
{
    protected $site;
    protected $www;
    protected $vhost_dir;
    protected $vhost_file;
    protected $tmp_dir;

    protected function configure()
    {
        $this->setName('share')
             ->setDescription('Share a local site with a colleague')
            ->addArgument(
                'site',
                InputArgument::OPTIONAL,
            'Provide the site name of the website you wish to share',
                ''
            )
            ->addOption(
                'www',
                'd',
                InputOption::VALUE_REQUIRED,
                "Web server root",
                '/var/www'
            );
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $this->vhost_dir = '/etc/apache2/sites-available';
        $this->vhost_file = '2-ngrok.conf';
        $this->tmp_dir = '/tmp';

        $this->www = $input->getOption('www');
        $this->site = $input->getArgument('site');

        $this->_check();

        //in order to share joomla.box there can't be a vhost override
        $this->_removeVhostOverride();

        //so as long we are dealing with a site name we create the override
        if (strlen($this->site)){
            $this->_generateVhost();
        }

        $this->_launchNgrok();
    }

    protected function _check()
    {
        if (strlen($this->site) && !file_exists($this->www . "/" . $this->site)) {
            throw new \RuntimeException(sprintf('Site not found: %s', $this->site));
        }

        if (file_exists($this->vhost_dir . '/' . $this->vhost_file))
        {
            `sudo rm -f $this->vhost_dir/$this->vhost_file`;
            `sudo /etc/init.d/apache2 restart > /dev/null 2>&1`;
        }
    }

    protected function _removeVhostOverride()
    {
        $site_enabled = '/etc/apache2/sites-enabled/2-ngrok.conf';
        $site_available = '/etc/apache2/sites-available/2-ngrok.conf';
        $restart = false;

        if (file_exists($site_enabled))
        {
            `sudo rm /etc/apache2/sites-enabled/2-ngrok.conf`;
            $restart = true;
        }

        if (file_exists($site_available))
        {
            `sudo rm /etc/apache2/sites-available/2-ngrok.conf`;
            $restart = true;
        }

        if ($restart){
            `sudo /etc/init.d/apache2 restart > /dev/null 2>&1`;
        }
    }

    protected function _generateVhost()
    {
        $loader = new \Twig\Loader\FilesystemLoader(realpath(__DIR__ .'/../templates'));
        $this->twig = new \Twig\Environment($loader);

        $template = $this->twig->load('ngrok_vhost.twig');

        //now render the template with full variables inserted
        $vhost_config = $template->render(['path_to_site' => $this->www . "/" . $this->site, 'site' => $this->site]);

        //create the writable tmp file
        file_put_contents($this->tmp_dir . "/" . $this->vhost_file, $vhost_config);

        `sudo tee /etc/apache2/sites-available/$this->vhost_file < $this->tmp_dir/$this->vhost_file`;

        `rm -f $this->tmp_dir/$this->vhost_file`;

        `sudo a2ensite $this->vhost_file`;
        `sudo /etc/init.d/apache2 restart > /dev/null 2>&1`;
    }

    protected function _launchNgrok()
    {
        $ngrok_command = "ngrok http joomla.box:80";

        if (strlen($this->site)){
            $ngrok_command = "ngrok http $this->site.test:80";
        }

        //launch ngrok and create a new screen to keep the user on the foreground
        `screen -d -m $ngrok_command`;

        //wait for the api to return connection details
        do
        {
            $results = @file_get_contents('http://localhost:4040/api/tunnels');
            $json = json_decode($results);
        } while (!isset($json->tunnels[0]->public_url));

        //then switch screens for the user
        `screen -r`;
    }
}
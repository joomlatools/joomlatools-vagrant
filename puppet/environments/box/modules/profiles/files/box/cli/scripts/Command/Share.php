<?php
namespace Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Input\InputOption;
use Symfony\Component\Console\Output\OutputInterface;
use \Twig\Environment;

class Share extends Command
{
    protected function configure()
    {
        $this->setName('share:site')
             ->setDescription('Share a local site with a colleague')
            ->addArgument('site',
                InputArgument::REQUIRED,
                'provide the site name');

        //add optional run in background
    }

    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $site = $input->getArgument('site');

        //going to need to port anything www or site related

        //going to need to check (site exists)

        $loader = new \Twig\Loader\FilesystemLoader('Command/templates/');
        $this->twig = new \Twig\Environment($loader);



        //remove existing 2-ngrok.conf override
            //restart apache

        if (file_exists('/etc/apache2/sites-available/2-ngrok.conf')){
            //unlink('/etc/apache2/sites-available/2-ngrok.conf');
        }


        //create new 2-ngrok.conf override
            //restart apache

        $template = $this->twig->load('ngrok_vhost.twig');


        var_dump($template->render(['path_to_site' => '/var/www/testing/']));
        exit();

        $archive = $input->getOption('archive');

        if ((file_exists($archive) && !is_writable($archive)) || !is_writable(dirname($archive))) {
            throw new \RuntimeException('Backup destination ' . $archive . ' is not writable.');
        }

        $output->writeln('Creating backup archive <comment>' . basename($archive) . '</comment>');

        passthru("/bin/bash /home/vagrant/backup/backup.sh $archive");
    }
}
<?php

class JoomlaSymlinker extends RecursiveIteratorIterator
{
    protected $_srcdir;
    protected $_tgtdir;

    public function __construct($srcdir, $tgtdir)
    {
        $this->_srcdir = $srcdir;
        $this->_tgtdir = $tgtdir;

        parent::__construct(new RecursiveDirectoryIterator($this->_srcdir));
    }

    public static function fromInput()
    {
        $parser = new Console_CommandLine();
        $parser->description = "Make symlinks for Joomla extensions.";

        $parser->addArgument('source', array(
            'description' => 'The source dir (usually from an IDE workspace)',
            'help_name'   => 'SOURCE'
        ));

        $parser->addArgument('target', array(
            'description' => "the target dir (usually where a joomla installation resides)",
            'help_name'   => 'TARGET'
        ));

        try {
            $result = $parser->parse();
            $source = realpath($result->args['source']);
            $target = realpath($result->args['target']);
        } catch (Exception $exc) {
            $parser->displayError($exc->getMessage());
            die;
        }

        if(file_exists($source))
        {
            $it = new self($source, $target);
            while($it->valid()) {
                $it->next();
            }
        }
    }

    public function callHasChildren()
    {
        $filename = $this->getFilename();
        if($filename[0] == '.') {
            return false;
        }

        $src = $this->key();

        $tgt = str_replace($this->_srcdir, '', $src);
        $tgt = str_replace('/site', '', $tgt);
        $tgt = $this->_tgtdir.$tgt;

        if(is_link($tgt)) {
            unlink($tgt);
        }

        if(!is_dir($tgt)) {
            $this->createLink($src, $tgt);
            return false;
        }

        return parent::callHasChildren();
    }

    public function createLink($src, $tgt)
    {
        if(!file_exists($tgt)) {
            `ln -sf $src $tgt`;
        }
    }
}
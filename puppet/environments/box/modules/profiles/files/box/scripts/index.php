<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link rel="icon" href="../assets/images/favicon.ico">

    <title>Joomlatools Vagrant</title>

    <link href="assets/css/dashboard.css" rel="stylesheet">
</head>

<body>
<div class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <span class="navbar-brand"><img class="logo" src="assets/images/logo.svg" alt="">Joomlatools Vagrant</span>
    </div>
</div>
<div class="container">
    <div class="sidebar">
        <ul>
            <?php include_once 'data/navigation.php' ?>
            <?php foreach ($navigation as $key => $item) : ?>
                <?php if ($item['type'] == 'separator') : ?>
                    <li role="presentation" class="dropdown-header"><?php echo $item['title'] ?></li>
                <?php elseif($item['status'] == 'disabled') : ?>
                    <li class="disabled">
                        <a href="#"><?php echo $item['title'] ?></a>
                    </li>
                <?php elseif(in_array($item['type'], array('iframe', 'include'))) : ?>
                    <li<?php echo $key == 'dashboard' ? ' class="active"' : '' ?><?php echo $item['status'] == 'disabled' ? ' class="disabled"' : '' ?>>
                        <a href="#<?php echo $key ?>" aria-controls="<?php echo $key ?>" role="tab"
                           data-toggle="tab"><?php echo $item['title'] ?></a>
                    </li>
                <?php else: ?>
                    <?php $isPage = ($item['type'] == 'page'); ?>
                    <li<?php echo $item['status'] == 'disabled' ? ' class="disabled"' : '' ?>>
                        <a href="<?php echo $item['source'] ?>" aria-controls="<?php echo $key ?>" <?php if ($isPage): ?>target="_blank"<?php endif; ?>>
                            <?php echo $item['title'] ?>
                            <?php if ($isPage): ?>
                                <span class="glyphicon glyphicon-new-window" style="font-size: 0.95rem;"></span>
                            <?php endif; ?>
                        </a>
                    </li>
                <?php endif; ?>
            <?php endforeach ?>
        </ul>
    </div>
    <div class="main">
        <!-- Tab panes -->
        <div class="tab-content">
            <?php foreach ($navigation as $key => $item) : ?>
                <?php if ($item['type'] != 'separator' && $item['status'] == 'active') : ?>
                    <div role="tabpanel" class="tab-pane<?php echo $key == 'dashboard' ? ' active' : '' ?>"
                         id="<?php echo $key ?>">
                        <?php if ($item['type'] == 'include') : ?>
                            <?php include $item['source']; ?>
                        <?php elseif ($item['type'] == 'iframe') : ?>
                            <iframe src="<?php echo $item['source'] ?>"></iframe>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
            <?php endforeach ?>
        </div>

        <!-- Embedded terminal -->
        <div class="terminal">
            <iframe src="http://joomla.box:3000/wetty/ssh/vagrant"></iframe>
            <script>
                var terminal = document.querySelector(".terminal");
                var resizer = document.createElement("div");
                resizer.className = "resizer";
                terminal.appendChild(resizer);
                resizer.addEventListener("mousedown", initDrag, false);
                var startY, startHeight;

                function initDrag(e) {
                    startY = e.clientY;
                    startHeight = parseInt(document.defaultView.getComputedStyle(terminal).height, 10);
                    document.documentElement.addEventListener("mousemove", doDrag, false);
                    document.documentElement.addEventListener("mouseup", stopDrag, false);
                }

                function doDrag(e) {
                    document.body.classList.add("is-unresponsive");
                    terminal.style.height = startHeight - e.clientY + startY + "px";
                }

                function stopDrag(e) {
                    document.documentElement.removeEventListener("mousemove", doDrag, false);
                    document.documentElement.removeEventListener("mouseup", stopDrag, false);
                    document.body.classList.remove("is-unresponsive");
                }
            </script>
        </div>

    </div>
</div>

<div class="footer">
    <ul class="nav">
        <li><a href="https://www.joomlatools.com/developer/tools/vagrant/" target="_blank">Documentation</a></li>
        <li><a href="https://gitter.im/joomlatools/dev" target="_blank">Gitter Chat</a></li>
        <li><a href="https://github.com/joomlatools/joomlatools-vagrant" target="_blank">Contribute on GitHub</a></li>
    </ul>
</div>

<!-- Bootstrap core JavaScript
================================================== -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="assets/js/bootstrap.js"></script>
<script>
    $('a[data-toggle="tab"]').click(function (e) {
        var href = $(e.target).attr("href");

        if (jQuery.inArray(href, ['#phpinfo', '#webgrind', '#apc-dashboard', '#dashboard']) !== -1)
        {
            var selector = href + ' iframe';
            $(selector).attr('src', function(i, val) { return val; });
        }
    });
</script>
</body>
</html>
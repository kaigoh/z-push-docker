<?php

foreach(glob("/config/*.php") as $c)
{
    // Is this a Z-Push config file?
    $matches = [];
    if($config = preg_match("/(?<dir>\/config\/)(?<category>.+).(?<filename>config.php)/", $c, $matches))
    {
        $destination = "/usr/share/nginx/z-push/backend/".$matches["category"]."/".$matches["filename"];
        if(!copy($c, $destination))
        {
            echo "Warning! Failed to copy '".$c."' to '".$destination."'...\r\n";
        }
    }
}
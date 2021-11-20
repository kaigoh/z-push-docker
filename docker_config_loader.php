<?php

foreach(glob("/config/*.php") as $c)
{
    // Is this a Z-Push config file?
    $matches = [];
    $destination = null;
    if($config = preg_match("/(?<dir>\/config\/)(?<category>.+).(?<filename>config.php)/", $c, $matches))
    {
        switch($matches["category"])
        {
            case "z-push":
            case "zpush":
                $destination = "/usr/share/nginx/z-push/".$matches["filename"];
                break;

            default:
                $destination = "/usr/share/nginx/z-push/backend/".$matches["category"]."/".$matches["filename"];
                break;
        }

        if(!copy($c, $destination))
        {
            echo "Warning! Failed to copy '".$c."' to '".$destination."'...\r\n";
        }

    }
}
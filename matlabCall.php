<?php
if(isset($_POST['filepath'])) {
    $filename  = $_POST['filepath'];
    $inputDir  = "C:\\output";
    $outputDir = "C:\\output";
    $command = "matlab -sd ".$inputDir." -r phpcreatefile('".$outputDir."\\".$filename."')";
    exec($command);
    echo "The following command was run: ".$command."<br/>";
    echo $filename." was created in ".$outputDir."<br/>";
}
?>
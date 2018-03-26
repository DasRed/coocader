<?php
$cacheId = 0;
$directory = new \RecursiveDirectoryIterator(__DIR__);
$iterator = new \RecursiveIteratorIterator($directory);
$regex = new \RegexIterator($iterator, '/^.+\.clpf$/i', \RecursiveRegexIterator::GET_MATCH);
$files = [];
foreach ($regex as $file)
{
	$files[] = str_replace([__DIR__ . DIRECTORY_SEPARATOR, '\\'], ['', '/'], realpath($file[0]));
	$cacheId += filemtime($file[0]);
}
header("Content-type: json/application");
echo json_encode(['version' => 1.0, 'cacheId' => $cacheId, 'files' => $files], JSON_PRETTY_PRINT);
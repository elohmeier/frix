<?php 
 	//eval ("echo ".$_REQUEST["nr"].";"); 
 	header('Content-type: application/json');
	$array = array(491575551127 => 'Jens', 491625552270 => 'Armin', 491555558272 => 'Horst', 491625556301 => 'Markus', 491625557331 => 'Olaf', 491605551802 => 'Heiko', 491755554742 => 'Angela', 491575552023 => 'Niels', 491725554243 => 'Ursula', 491575551546 => 'Andreas');
 	
	if (isset($_GET['name']))
	{
		$req_name = $_REQUEST["name"];
		eval("\$name = '$req_name';");

		$number = array_search($name, $array);
 
 
		if ($number === false)
			echo 'The number could not be found.';
		else
			$array = [$name => $number];
			$b = json_encode($array);
			echo($b);
	}
	else if (isset($_GET['nr']))
	{
		echo 'The name is ' . $array[$_GET['nr']];
	}
?>

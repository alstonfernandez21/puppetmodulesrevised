class custom {

#if has_key($my_hash, 'key_two') {
#          notice('we will not reach here')
#}
#if has_key($my_hash, 'key_one') {
#          notice('this will be printed')
#}


$web_conf = { 'technology' => "php", 'b' => 2, 'c' => 3 }

    if has_value($web_conf, "rails") {
	notice('this does have rails')
    }
    else {
 	notice('it does not have rails')
    }


}


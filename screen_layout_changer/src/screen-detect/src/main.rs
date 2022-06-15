use std::collections::HashMap;
use std::process::Command;
use std::{env, fs, vec};

use dirs::home_dir;


use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
struct XProfiles {
    profiles: Vec<XProfile>
}

#[derive(Debug, Deserialize, Serialize)]
struct XProfile {
    identifier: Vec<String>,
    profile: String
}

fn parse_profiles(filename:&str) -> Vec<XProfile>{
    let contents = fs::read_to_string(filename).expect("Something went wrong reading the file");
    let x_profiles: XProfiles = ron::from_str(&contents).unwrap();
    //println!("RON: {}", ron::to_string(&x_profiles).unwrap());
    return x_profiles.profiles;
}

fn parse_cmd_args_conf() -> HashMap<String, String>{
    let mut config: HashMap<String, String> = HashMap::new();
    config.insert("config_file".to_string(), "$HOME/.config/xprofiles-rs/rc.ron".to_string());

    let args: Vec<String> = env::args().collect();
    
    for (i, arg) in args.iter().enumerate() {
        match arg.as_str() {
            "config"=> {
                config.insert( "config_file".to_string(), args.get(i+1).expect("pls add a path").to_string());
            }
            _ => {}
        }
    }
    return config;
}


fn parse_output(outstr: String){
    let mut fin_screens:Vec<String> = vec![];
    let out = outstr.replace("\n", "").replace("EDID:", "").replace("\t", "").replace(" ", "");
    //println!("{:?}", out);
    let screens:Vec<&str> = out.split("--").collect();
    for s in screens {
        let (f,e) = s.split_at(32);
        println!("{:#?}",f);
        println!("{:#?}",e);
        let combined = format!("{}-{}", f,e);
        fin_screens.push(combined);
    }

    let mut conf_file = parse_cmd_args_conf().get("config_file").expect("msg").to_owned();
    //println!("{}", conf_file);

    //println!("{}", conf_file);
    conf_file = parse_path(conf_file);

    let profiles:Vec<XProfile> = parse_profiles(conf_file.as_str());
    for profile in profiles{
        let mut ids = profile.identifier;
        if ids.sort().eq(&fin_screens.sort()) {
            println!("true");
            let run = parse_path(profile.profile.to_string());
            //print!("{:#?}",run);
            Command::new("sh").args([&run]).spawn();
        } else {
            println!("false");
        }
    }
    ;
}

fn parse_path(mut path:String) -> String{
    if path.starts_with("~") {
        path = path.replace("~", home_dir().unwrap().to_str().unwrap());
    
    }
    if path.starts_with("$HOME") {
        path = path.replace("$HOME", home_dir().unwrap().to_str().unwrap());
    }

    return path;
}


fn main() {
    let output = Command::new("sh")
            .args(["-c","xrandr --prop | grep -A2 EDID"])
            .output()
            .expect("failed to execute process: Do you have installed xrandr and grep?");

    let outstr = String::from_utf8(output.stdout).unwrap();
    //print!("{}", outstr);
    parse_output(outstr)
}

extern crate hello_rusty_worlds;

fn main() {
  let argument: String;
  let planet_num: u8;
  
  match std::env::args().nth(1) {
    None => {
      println!("Usage: hello-world PLANET_NUMBER");
      std::process::exit(0);
    },
    Some(val) => argument = val
  };
  
  match argument.parse::<u8>() {
    Err(err) => {
      println!("Error parsing argument: {}\nArgument should be a number", err);
      std::process::exit(1);
    },
    Ok(val) => planet_num = val
  }
  
  match hello_rusty_worlds::hello_world(planet_num) {
    None => println!("Planet {} not found. Have you lost a planet? How embarrassing!", planet_num),
    Some(val) => println!("{}", val)
  }
}

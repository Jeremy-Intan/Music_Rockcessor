extern crate regex;
use regex::Regex;
use std::io::{self, Read};

fn main() {
    let mut buf = String::new();
    let re1 = Regex::new(r"^ *\s+ +bm\d,bm\d,r\d+ *")

    io::stdin().read_to_string(&mut buf).unwrap();

    for ln in buf.lines() {
      
    }
}

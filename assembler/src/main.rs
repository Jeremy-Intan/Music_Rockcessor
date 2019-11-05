extern crate regex;
extern crate lazy_static;
use regex::Regex;
use std::io::{self, Read};

fn cnv_bitmap_reg(s: &String) -> Option<String> {
    match s {
        "0"  => Some(String::new("00")),
        "1"  => Some(String::new("01")),
        "2"  => Some(String::new("10")),
        "3"  => Some(String::new("11")),
        None => None,
    }
}

fn cnv_normal_reg(s: &String) -> Option<String> {
    match s {
        "0"   => Some(String::new("0000")),
        "1"   => Some(String::new("0001")),
        "2"   => Some(String::new("0010")),
        "3"   => Some(String::new("0011")),
        "4"   => Some(String::new("0100")),
        "5"   => Some(String::new("0101")),
        "6"   => Some(String::new("0110")),
        "7"   => Some(String::new("0111")),
        "8"   => Some(String::new("1000")),
        "9"   => Some(String::new("1001")),
        "10"  => Some(String::new("1010")),
        "11"  => Some(String::new("1011")),
        "12"  => Some(String::new("1100")),
        "13"  => Some(String::new("1101")),
        "14"  => Some(String::new("1110")),
        "15"  => Some(String::new("1111")),
        None => None,
    }
}

fn cnv_val_6(s: &String) -> Option<String> {
}

fn cnv_val_8(s: &String) -> Option<String> {
}

fn main() {
    let mut buf = String::new();
    
    lazy_static::lazy_static! {
        //static ref REOP: Regex = Regex::new(r"^[ ]*([LDBSTERHLMVPAUNO]+)").unwrap();
        //let re1 = Regex::new(r"^ *\s+ +bm\d,bm\d,r\d+ *")
        static ref RELC   : Regex = Regex::new(r"([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELAB  : REGEX = Regex::new(r"[ \t]*([a-zA-Z]+[0-9]*)[ \t]*:([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELDB  : Regex = Regex::new(r"^[ \t]*LDB[ \t]+b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESTB  : Regex = Regex::new(r"^[ \t]*STB[ \t]+b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESES  : Regex = Regex::new(r"^[ \t]*SES[ \t]+b([0-3])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RERET  : Regex = Regex::new(r"^[ \t]*RET([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBSH  : Regex = Regex::new(r"^[ \t]*BSH[ \t]+b([0-3])[ \t]*,[ \t]*b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBSL  : Regex = Regex::new(r"^[ \t]*BSL[ \t]+b([0-3])[ \t]*,[ \t]*b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REMV   : Regex = Regex::new(r"^[ \t]*MV[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*([a-zA-Z0-9]+)([ \t]*|[ \t]*#.*)$").unwrap(); //instruction wtf
        static ref REPLY  : Regex = Regex::new(r"^[ \t]*PLY[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*b([0-3])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REST   : Regex = Regex::new(r"^[ \t]*ST[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELD   : Regex = Regex::new(r"^[ \t]*LD[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBR   : Regex = Regex::new(r"^[ \t]*BR[ \t]+([01][01][01])[ \t]*,[ \t]*([a-zA-Z]+[0-9]*)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBRR  : Regex = Regex::new(r"^[ \t]*BRR[ \t]+([01][01][01])[ \t]*,[ \t]*([a-zA-Z]+[0-9]*)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref READD  : Regex = Regex::new(r"^[ \t]*ADD[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESUB  : Regex = Regex::new(r"^[ \t]*SUB[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REHALT : Regex = Regex::new(r"^[ \t]*HALT([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RENOP  : Regex = Regex::new(r"^[ \t]*NOP([ \t]*|[ \t]*#.*)$").unwrap();
    }

    io::stdin().read_to_string(&mut buf).unwrap();

    let mut pc:i64 = -1;

    for ln in buf.lines() {
        //match RELDB.captures(ln) {
        //    Some(vals) => println!("bitmatp {} reg {} value {}", &vals[1], &vals[2], &vals[3]),
        //    None => println!("line {} not recognized", ln),
        //};
        //match REHALT.captures(ln) {
        //    Some(_) => println!("halt found"),
        //    None => println!("halt not found"),
        //}
        match RELC.captures(ln) {
            Some(_) => continue,
            None => 
        match RELAB.captures(ln) {
            Some(vlab) => label = &vlab[1],
            None => 
        match RELDB.captures(ln) {
            Some(vldb) => {
                
            },
            None =>
        match RESTB.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match RESES.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match RERET.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REBSH.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REBSL.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REMV.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REPLY.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REST.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match RELD.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REBR.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REBRR.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match READD.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match RESUB.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match REHALT.captures(ln) {
            Some(vldb) => {
            },
            None =>
        match RENOP.captures(ln) {
            Some(vldb) => {
            },
            None =>
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        },
        }
    }
}

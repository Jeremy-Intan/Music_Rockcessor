extern crate regex;
extern crate lazy_static;
use regex::Regex;
use std::io::{self, Read};
use std::collections::{HashMap};

fn cnv_bitmap_reg(s: &str) -> Option<String> {
    match s {
        "0"  => Some(String::from("00")),
        "1"  => Some(String::from("01")),
        "2"  => Some(String::from("10")),
        "3"  => Some(String::from("11")),
        _ => None,
    }
}

fn cnv_normal_reg(s: &str) -> Option<String> {
    match s {
        "0"   => Some(String::from("0000")),
        "1"   => Some(String::from("0001")),
        "2"   => Some(String::from("0010")),
        "3"   => Some(String::from("0011")),
        "4"   => Some(String::from("0100")),
        "5"   => Some(String::from("0101")),
        "6"   => Some(String::from("0110")),
        "7"   => Some(String::from("0111")),
        "8"   => Some(String::from("1000")),
        "9"   => Some(String::from("1001")),
        "10"  => Some(String::from("1010")),
        "11"  => Some(String::from("1011")),
        "12"  => Some(String::from("1100")),
        "13"  => Some(String::from("1101")),
        "14"  => Some(String::from("1110")),
        "15"  => Some(String::from("1111")),
        _ => None,
    }
}

fn cnv_val_4(s: &str) -> Option<String> {
    match s {
        "0"   => Some(String::from("0000")),
        "1"   => Some(String::from("0001")),
        "2"   => Some(String::from("0010")),
        "3"   => Some(String::from("0011")),
        "4"   => Some(String::from("0100")),
        "5"   => Some(String::from("0101")),
        "6"   => Some(String::from("0110")),
        "7"   => Some(String::from("0111")),
        "-8"   => Some(String::from("1000")),
        "-7"   => Some(String::from("1001")),
        "-6"  => Some(String::from("1010")),
        "-5"  => Some(String::from("1011")),
        "-4"  => Some(String::from("1100")),
        "-3"  => Some(String::from("1101")),
        "-2"  => Some(String::from("1110")),
        "-1"  => Some(String::from("1111")),
        _ => None,
    }
}
fn cnv_val_6(s: &str) -> Option<String> {
    match s.parse::<i32>() {
        Ok(val) => {
            if val > 31 { None }
            else if val < -32 { None }
            else {
                let mut finalval = String::from("");
                let mut valtrans = (val + 64) % 64;
                if valtrans >= 32 {
                    finalval.push_str("1");
                    valtrans -= 32;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 16 {
                    finalval.push_str("1");
                    valtrans -= 16;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 8 {
                    finalval.push_str("1");
                    valtrans -= 8;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 4 {
                    finalval.push_str("1");
                    valtrans -= 4;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 2 {
                    finalval.push_str("1");
                    valtrans -= 2;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 1 {
                    finalval.push_str("1");
                }
                else {
                    finalval.push_str("0");
                }
                Some(finalval)
            }
        }
        Err(_) => None,
    }
}

fn cnv_val_8(s: &str) -> Option<String> {
    match s.parse::<i32>() {
        Ok(val) => {
            if val > 127 { None }
            else if val < -128 { None }
            else {
                let mut finalval = String::from("");
                let mut valtrans = (val + 256) % 256;
                if valtrans >= 128 {
                    finalval.push_str("1");
                    valtrans -= 128;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 64 {
                    finalval.push_str("1");
                    valtrans -= 64;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 32 {
                    finalval.push_str("1");
                    valtrans -= 32;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 16 {
                    finalval.push_str("1");
                    valtrans -= 16;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 8 {
                    finalval.push_str("1");
                    valtrans -= 8;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 4 {
                    finalval.push_str("1");
                    valtrans -= 4;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 2 {
                    finalval.push_str("1");
                    valtrans -= 2;
                }
                else {
                    finalval.push_str("0");
                }
                if valtrans >= 1 {
                    finalval.push_str("1");
                }
                else {
                    finalval.push_str("0");
                }
                Some(finalval)
            }
        }
        Err(_) => None,
    }
}

fn cnv_dec_9 (val: i64) -> Option<String> {
    if val > 127 { None }
    else if val < -128 { None }
    else {
        let mut finalval = String::from("");
        let mut valtrans = (val + 512) % 512;
        if valtrans >= 256 {
            finalval.push_str("1");
            valtrans -= 256;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 128 {
            finalval.push_str("1");
            valtrans -= 128;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 64 {
            finalval.push_str("1");
            valtrans -= 64;
        }
            else {
        finalval.push_str("0");
        }
        if valtrans >= 32 {
            finalval.push_str("1");
            valtrans -= 32;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 16 {
            finalval.push_str("1");
            valtrans -= 16;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 8 {
            finalval.push_str("1");
            valtrans -= 8;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 4 {
            finalval.push_str("1");
            valtrans -= 4;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 2 {
            finalval.push_str("1");
            valtrans -= 2;
        }
        else {
            finalval.push_str("0");
        }
        if valtrans >= 1 {
            finalval.push_str("1");
        }
        else {
            finalval.push_str("0");
        }
        Some(finalval)
    }
}

fn main() {
    let mut buf = String::new();
    
    lazy_static::lazy_static! {
        //static ref REOP: Regex = Regex::new(r"^[ ]*([LDBSTERHLMVPAUNO]+)").unwrap();
        //let re1 = Regex::new(r"^ *\s+ +bm\d,bm\d,r\d+ *")
        static ref RELC   : Regex = Regex::new(r"^([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELAB  : Regex = Regex::new(r"^[ \t]*([a-zA-Z]+[0-9]*)[ \t]*:([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELDB  : Regex = Regex::new(r"^[ \t]*LDB[ \t]+b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESTB  : Regex = Regex::new(r"^[ \t]*STB[ \t]+b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESES  : Regex = Regex::new(r"^[ \t]*SES[ \t]+b([0-3])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RERET  : Regex = Regex::new(r"^[ \t]*RET([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBSH  : Regex = Regex::new(r"^[ \t]*BSH[ \t]+b([0-3])[ \t]*,[ \t]*b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBSL  : Regex = Regex::new(r"^[ \t]*BSL[ \t]+b([0-3])[ \t]*,[ \t]*b([0-3])[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REMV   : Regex = Regex::new(r"^[ \t]*MV[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*([a-zA-Z0-9]+)([ \t]*|[ \t]*#.*)$").unwrap(); //instruction wtf
        static ref REPLY  : Regex = Regex::new(r"^[ \t]*PLY[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*b([0-3])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REST   : Regex = Regex::new(r"^[ \t]*ST[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RELD   : Regex = Regex::new(r"^[ \t]*LD[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*(-?[0-9])([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBR   : Regex = Regex::new(r"^[ \t]*BR[ \t]+([01][01][01])[ \t]*,[ \t]*([a-zA-Z]+[0-9]*)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REBRR  : Regex = Regex::new(r"^[ \t]*BRR[ \t]+([01][01][01])[ \t]*,[ \t]*([a-zA-Z]+[0-9]*)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref READD  : Regex = Regex::new(r"^[ \t]*ADD[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RESUB  : Regex = Regex::new(r"^[ \t]*SUB[ \t]+r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)[ \t]*,[ \t]*r([0-9][0-9]?)([ \t]*|[ \t]*#.*)$").unwrap();
        static ref REHALT : Regex = Regex::new(r"^[ \t]*HALT([ \t]*|[ \t]*#.*)$").unwrap();
        static ref RENOP  : Regex = Regex::new(r"^[ \t]*NOP([ \t]*|[ \t]*#.*)$").unwrap();
    }

    io::stdin().read_to_string(&mut buf).unwrap();

    let mut pc:i64 = 0;
    let mut lnno:usize = 0;

    let mut prog:Vec<String> = Vec::new();

    let mut label_pc = HashMap::new();
    let mut pc_jump_lab = HashMap::new();
    let mut pc_jump_ln = HashMap::new();

    for ln in buf.lines() {
        match RELC.captures(ln) {
            Some(_) => continue,
            None => 
        match RELAB.captures(ln) {
            Some(vlab) => {
                if let Some(_lb) = label_pc.insert(String::from(&vlab[1]).into_boxed_str(), pc) {
                    panic!("{}:{}\nLabel {} is defined twice", lnno, ln, &vlab[1]);
                }
            },
            None => 
        match RELDB.captures(ln) {
            Some(vldb) => {
                let mut inst = String::from("1111");
                match cnv_bitmap_reg(&vldb[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vldb[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_val_6(&vldb[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{},\nValue is out of range", lnno, ln),
                };
                println!("{}", inst);
                pc += 1;
            },
            None =>
        match RESTB.captures(ln) {
            Some(vstb) => {
                let mut inst = String::from("1110");
                match cnv_bitmap_reg(&vstb[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vstb[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_val_6(&vstb[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{},\nValue is out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match RESES.captures(ln) {
            Some(vses) => {
                let mut inst = String::from("1101");
                match cnv_bitmap_reg(&vses[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                inst += "0000000000";
                prog.push(inst);
                pc += 1;
            },
            None =>
        match RERET.captures(ln) {
            Some(_) => {
                prog.push(String::from("1100000000000000"));
                pc += 1;
            },
            None =>
        match REBSH.captures(ln) {
            Some(vbsh) => {
                let mut inst = String::from("1011");
                match cnv_bitmap_reg(&vbsh[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_bitmap_reg(&vbsh[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vbsh[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                inst += "0000";
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REBSL.captures(ln) {
            Some(vbsl) => {
                let mut inst = String::from("1010");
                match cnv_bitmap_reg(&vbsl[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_bitmap_reg(&vbsl[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vbsl[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                inst += "0000";
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REMV.captures(ln) {
            Some(vmv) => {
                let mut inst = String::from("1001");
                match cnv_normal_reg(&vmv[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_val_8(&vmv[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{},\nValue is out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REPLY.captures(ln) {
            Some(vply) => {
                let mut inst = String::from("1000");
                match cnv_normal_reg(&vply[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vply[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_bitmap_reg(&vply[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nBitmap register out of range", lnno, ln),
                };
                inst += "00";
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REST.captures(ln) {
            Some(vst) => {
                let mut inst = String::from("0111");
                match cnv_normal_reg(&vst[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vst[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_val_4(&vst[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nValue out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match RELD.captures(ln) {
            Some(vld) => {
                let mut inst = String::from("0110");
                match cnv_normal_reg(&vld[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vld[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_val_4(&vld[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nValue out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REBR.captures(ln) {
            Some(vbr) => {
                let mut inst = String::from("0101");
                inst.push_str(&vbr[1]);
                prog.push(inst);
                let mut errln = lnno.to_string();
                errln.push_str(ln);
                pc_jump_lab.insert(pc, String::from(&vbr[2]).into_boxed_str());
                pc_jump_ln.insert(pc, String::from(&errln).into_boxed_str());
                pc += 1;
            },
            None =>
        match REBRR.captures(ln) {
            Some(vbrr) => {
                let mut inst = String::from("0100");
                inst.push_str(&vbrr[1]);
                prog.push(inst);
                let mut errln = lnno.to_string();
                errln.push_str(&vbrr[2]);
                pc_jump_lab.insert(pc, String::from(&vbrr[2]).into_boxed_str());
                pc_jump_ln.insert(pc, String::from(&errln).into_boxed_str());
                pc += 1;
            },
            None =>
        match READD.captures(ln) {
            Some(vadd) => {
                let mut inst = String::from("0011");
                match cnv_normal_reg(&vadd[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vadd[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vadd[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match RESUB.captures(ln) {
            Some(vsub) => {
                let mut inst = String::from("0010");
                match cnv_normal_reg(&vsub[1]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vsub[2]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                match cnv_normal_reg(&vsub[3]) {
                    Some(bits) => inst.push_str(&bits),
                    None => panic!("{}:{}\nNormal register out of range", lnno, ln),
                };
                prog.push(inst);
                pc += 1;
            },
            None =>
        match REHALT.captures(ln) {
            Some(_) => {
                prog.push(String::from("0001000000000000"));
                pc += 1;
            },
            None =>
        match RENOP.captures(ln) {
            Some(_) => {
                prog.push(String::from("0000000000000000"));
                pc += 1;
            },
            None => panic!("{}:{}\nInstruction not found or not parsable", lnno, ln),
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

        lnno += 1;
    }

    for (pcbr, lab) in pc_jump_lab.into_iter() {
        let dif;
        match label_pc.get(&lab) {
            Some(lab_pc) => dif = lab_pc - pcbr, 
            None => {
                match pc_jump_ln.get(&pcbr) {
                    Some(errln) => panic!("{}\nThe label is not found", errln),
                    None => panic!("Some unknown line, label is not found"),
                };
            }
        }
        if let Some(jump_val) = cnv_dec_9(dif) {
            prog[pcbr as usize].push_str(&jump_val);
        }
        else {
            match pc_jump_ln.get(&pcbr) {
                Some(errln) => panic!("{}\nThe jump label is too far", errln),
                None => panic!("Some unknown line, the jump label is too far"),
            };
        }
    }

    for inst in prog {
        println!("{}", inst);
    }
}

extern crate pcsc;

use pcsc::*;
use std::str;

fn main() {
    // Establish a PC/SC context.
    let ctx = Context::establish(Scope::User)
        .expect("failed to establish context");

    // List available readers.
    let mut readers_buf = [0; 2048];
    let mut readers = ctx.list_readers(&mut readers_buf)
        .expect("failed to list readers");

    // Use the first reader.
    let reader = readers.next().ok_or(())
        .expect("no readers are connected");
    println!("Using reader: {:?}", reader);

    // Connect to the card.
    let card = ctx.connect(reader, ShareMode::Shared, Protocols::T1)
        .expect("failed to connect to card");

    // Send an SELECT APDU command.
    let apdu = b"\x00\xA4\x04\x00\x0A\xA0\x00\x00\x00\x62\x03\x01\x0C\x06\x01";
    let mut rapdu_buf = [0; MAX_BUFFER_SIZE];
    let rapdu = card.transmit(apdu, &mut rapdu_buf)
        .expect("failed to transmit APDU to card");
    println!("{:?}", rapdu);

    // Send an COMMAND APDU command.
    let apdu = b"\x00\x00\x00\x00";
    let mut rapdu_buf = [0; MAX_BUFFER_SIZE];
    let rapdu = card.transmit(apdu, &mut rapdu_buf)
        .expect("failed to transmit APDU to card");
    println!("{:?}", rapdu);

    // remove the extra 2 SW bytes at the end
    let text = &rapdu[0 .. rapdu.len()-2];

    // convert to UTF-8 (ASCII in fact)
    println!("{}", str::from_utf8(&text).unwrap());
}

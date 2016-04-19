SerialPort.listDevices;
( s.waitForBoot{ fork{
	a = ArduinoSMS("/dev/ttyUSB0", 38400);
	k = {Bus.control(s)}!3;
	~xmap = 60.0;
	5.wait;

	a.send($a);

	1.wait;
	a.action = { |msg|
		var msgsplit = split(msg, $:);
		var header = msgsplit[0].asSymbol;
		var data = msgsplit[1].asFloat;
		switch(header,
			\accx, {
				var datamapped = data.linlin(-90.0, 90.0, 0.4, -0.4);
				~xmap = (~xmap + datamapped).max(30).min(80);
				~xmap.postln;
				k[0].set(~xmap);
			},
			\accy, {},
			\accz,{}
		);
	};
	SynthDef(\tsine, {
		arg plo = 30.0, phi=80.0;
		var pitch = \pitch.kr(60, 0.005);
		Out.ar(0, SinOsc.ar(pitch.midicps));
	}).add;
}})

//send arduino any character to start
//start synth
b = Synth(\tsine);
b.map(\pitch, k[0]);
b.free;
k[0].getSynchronous
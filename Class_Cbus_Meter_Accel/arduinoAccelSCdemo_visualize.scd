SerialPort.listDevices;
( s.waitForBoot{ fork{
	a = ArduinoSMS("/dev/ttyUSB0", 115200);
	k = {Bus.control(s)}!6;
	~dgate = 0;
	~xmap = 60.0;
	~xnorm = 0.5;
	~ymap = 60.0;
	~ynorm = 0.5;
	~proc = NetAddr("127.0.0.1", 12321);
	5.wait;

	a.send($a);

	1.wait;
	a.action = { |msg|
		var msgsplit = split(msg, $:);
		var header = msgsplit[0].asSymbol;
		var data = msgsplit[1].asFloat;
		switch(header,
			\accx, {
				var datamapped = data.linlin(-90.0, 90.0, -0.4, 0.4);
				var ndata;
				if(~dgate == 1,{
				~xmap = (~xmap + datamapped).max(30).min(80);
				//~xmap.postln;
				k[0].set(~xmap);
				~xnorm = ~xmap.linlin(30.0, 80.0, 0.0, 1.0);
				k[3].set(~xnorm);
			//~xnorm.postln;
				});
			},
			\accy, {
				var datamapped = data.linlin(-90.0, 90.0, 0.4, -0.4);
				var ndata;
				if(~dgate == 1,{
				~ymap = (~ymap + datamapped).max(30).min(80);
				k[1].set(~ymap);
				~ynorm = ~ymap.linlin(30.0, 80.0, 0.0, 1.0);
				k[4].set(~ynorm);
				//data.postln;
				});
			},
			\accz,{},
			\b0,{~dgate = data.asInteger;}
		);
	};
	SynthDef(\tsine, {
		arg plo = 30.0, phi=80.0;
		var pitch = \pitch.kr(60, 0.005);
		Out.ar(0, SinOsc.ar(pitch.midicps));
	}).add;
	//OSCdef to send to processing
	OSCdef(\getkdat,{ |msg|
		var bus = msg[1].asInteger;
		var datx = k[3].getSynchronous;
		var daty = k[4].getSynchronous;
		~proc.sendMsg("/kdat", bus, datx, daty);
	}, "/getkdat");
}})

//send arduino any character to start
//start synth
b = Synth(\tsine);
b.map(\pitch, k[0]);
b.free;
k[0].getSynchronous
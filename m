From: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: mount.cifs multiuser w/o =?UTF-8?Q?krb5=3F_How=3F?=
Date: Wed, 11 Jul 2012 21:05:31 +0200
Message-ID: <cone.1342033531.608672.10432.1000@athlon>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed	delsp=yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

sorry, sent from a wrong email address and probably silently rejected b=
y =20
Majordomo...
-------- P=C5=99eposlan=C3=A1 zpr=C3=A1va --------
P=C5=99edm=C4=9Bt: Re: mount.cifs multiuser w/o krb5? How?
Datum: Tue, 10 Jul 2012 23:01:32 +0200

Jeff Layton writes:

>> cifscreds add is more or less equivalent to a command like this:
>
>     $ keyctl add logon cifs:a:ip_address 'username:password' @s
>

There seems to be a general problem with adding keys (@s) to the defaul=
t =20
"session" keyring. Adding user type keys (@u) works.

$ keyctl add logon description data @s
does not add anything to the _uid_ses:UID keyring, which is automatical=
ly =20
created after login.

Interestingly, when a new session keyring is added, then it works:

[root@client ~]# su - zmrzlinka
[zmrzlinka@client ~]$ keyctl show
Session Keyring
1037083570 --alswrv   1001    -1  keyring: _uid_ses.1001
 578017679 --alswrv   1001    -1   \_ keyring: _uid.1001
[zmrzlinka@client ~]$ cifscreds add toillet
Password:
[zmrzlinka@client ~]$ keyctl show
Session Keyring
1037083570 --alswrv   1001    -1  keyring: _uid_ses.1001
 578017679 --alswrv   1001    -1   \_ keyring: _uid.1001
[zmrzlinka@client ~]$ keyctl session new-session
Joined session keyring: 871855811
[zmrzlinka@client ~]$ keyctl show
Session Keyring
 871855811 --alswrv   1001   100  keyring: new-session
[zmrzlinka@client ~]$ cifscreds add toillet
Password:
[zmrzlinka@client ~]$ keyctl show
Session Keyring
 871855811 --alswrv   1001   100  keyring: new-session
 244698182 ----sw-v   1001   100   \_ logon: cifs:a:192.168.1.3

Milan

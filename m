From: knizek-VIXq6x/3rUk@public.gmane.org
Subject: Re: mount.cifs multiuser w/o =?UTF-8?Q?krb5=3F_How=3F?=
Date: Tue, 10 Jul 2012 23:01:32 +0200
Message-ID: <cone.1341954092.296868.13606.1000@athlon>
References: <1341427937.3252.6.camel@athlon.garagome> <20120706141543.1b564c11@tlielax.poochiereds.net> <1341612593.26748.9.camel@athlon.garagome> <20120709062608.3a67445f@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Milan =?UTF-8?B?S27DrcW+ZWs=?= <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Jeff Layton writes:

>> cifscreds add is more or less equivalent to a command like this:
>
>     $ keyctl add logon cifs:a:ip_address 'username:password' @s
>

There seems to be a general problem with adding keys (@s) to the default  
"session" keyring. Adding user type keys (@u) works.

$ keyctl add logon description data @s
does not add anything to the _uid_ses:UID keyring, which is automatically  
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

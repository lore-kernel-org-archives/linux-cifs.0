From: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS VFS: Send error in Flush = -9
Date: Wed, 5 Feb 2014 01:21:45 -0800 (PST)
Message-ID: <1391592105.31475.YahooMailNeo@web140306.mail.bf1.yahoo.com>
References: <loom.20140131T193830-201@post.gmane.org> <CADT32e+5whrPysC+8JmNupP1WPS1dT6hbb8O+DrH=SYSpsLk4w@mail.gmail.com>
Reply-To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+5whrPysC+8JmNupP1WPS1dT6hbb8O+DrH=SYSpsLk4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> To: Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Sent: Friday, January 31, 2014 12:07 PM
> Subject: Re: CIFS VFS: Send error in Flush =3D -9
>=20
> -9 is EBADF.
>=20
> If you can send a wireshark trace of traffic between client and serve=
r
> that would be helpful.
>=20
>=20
>=20
> On Fri, Jan 31, 2014 at 1:20 PM, Jeff Berman <spamact-/E1597aS9LQAvxtiuMwx3w@public.gmane.org> wrot=
e:
>>  Hi there,
>>=20
>>  I'm getting lots of CIFS errors in my system log:
>>=20
>>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send erro=
r
>> =A0 in Flush =3D -9
>>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send erro=
r
>> =A0 in Flush =3D -9
>>  Jan 30 08:46:05 Server1 kernel: [747319.264235] CIFS VFS: Send erro=
r
>> =A0 in Flush =3D -9


Ok, I think I did the wireshark trace correctly. =A0It's attached to bu=
g 10417 (https://bugzilla.samba.org/show_bug.cgi?id=3D10417).

Thank you!

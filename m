From: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [cifs-protocol] cifs client timeouts and hard/soft mounts
Date: Mon, 06 Dec 2010 16:45:29 -0600
Message-ID: <4CFD6789.10000@samba.org>
References: <20101203212811.17594274@tlielax.poochiereds.net>	<E1POnFL-00BKfp-6h@intern.SerNet.DE>	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>	<20101205210634.602b076b@corrin.poochiereds.net>	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>	<4CFD16D8.4090207@samba.org>	<20101206124255.7ea8a8a9@tlielax.poochiereds.net>	<4CFD3166.4000800@samba.org>	<E1PPhWb-00EZX7-6F@intern.SerNet.DE>	<4CFD49CD.5010002@samba.org>	<AANLkTim1-m=d-A6yp4bWpYrEeqN_t49aHnAGPQEjrob_@mail.gmail.com> <4CFD4D15.60103@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD4D15.60103-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Christopher R. Hertel wrote:
> Steve French wrote:
> :
>> Now that I have experimented with smb2,  it does seem better (and th=
e
>> alternatives are worse)
>=20
> Yeah... but they're already headed down the same road that they took =
with
> SMB.  Let's see where SMB2 is in 5, 10, 20 years.

I want to apologize for the above comment.  It is much more negative
sounding than I had intended when I sent it off without double-checking=
 it.

I agree with Steve that SMB2 is much better than SMB, and better than m=
any
other alternatives.  The improved communication with Microsoft that
third-party developers have seen over the past three years or so will, =
I
hope, go a long way toward keeping it clean and avoiding the build-up o=
f
obsolescent commands and subcommands that SMB experienced.

Now, if we could just get a little momentum behind the UNIXSMB2 effort.=
=2E.

> I'll see what I can do to get Jos=E9 ready to take over for us when w=
e're
> shipped off to the home.

I'll still do this.  We have a fresh generation coming up, and I think
that's something to encourage.

Chrudz -)-----

--=20
"Implementing CIFS - the Common Internet FileSystem" ISBN: 013047116X
Samba Team -- http://www.samba.org/     -)-----   Christopher R. Hertel
jCIFS Team -- http://jcifs.samba.org/   -)-----   ubiqx development, un=
inq.
ubiqx Team -- http://www.ubiqx.org/     -)-----   crh-jFlgvBokg3lg9hUCZPvPmw@public.gmane.org
OnLineBook -- http://ubiqx.org/cifs/    -)-----   crh-zuGDro9SezXYtjvyW6yDsg@public.gmane.org

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs client timeouts and hard/soft mounts
Date: Mon, 6 Dec 2010 14:44:09 -0600
Message-ID: <AANLkTim1-m=d-A6yp4bWpYrEeqN_t49aHnAGPQEjrob_@mail.gmail.com>
References: <20101203212811.17594274@tlielax.poochiereds.net>
	<E1POnFL-00BKfp-6h@intern.SerNet.DE>
	<AANLkTi=MCgZb=we2OEtxJ4DZ==sVmRLd8aQKeMU7vvKt@mail.gmail.com>
	<20101205210634.602b076b@corrin.poochiereds.net>
	<AANLkTik4Vh5hqWwVngjCC7v1ST1YxAP9LvQbcqKDhWHp@mail.gmail.com>
	<E1PPSnw-00DDbs-Va@intern.SerNet.DE>
	<AANLkTinPw8M6XaMvMQ_VMxdk7j8PDqdpjzKLgDMxPf1n@mail.gmail.com>
	<4CFD16D8.4090207@samba.org>
	<20101206124255.7ea8a8a9@tlielax.poochiereds.net>
	<4CFD3166.4000800@samba.org>
	<E1PPhWb-00EZX7-6F@intern.SerNet.DE>
	<4CFD49CD.5010002@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	cifs-protocol-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Christopher R. Hertel" <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD49CD.5010002-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Dec 6, 2010 at 2:38 PM, Christopher R. Hertel <crh-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> w=
rote:
> Volker Lendecke wrote:
>> On Mon, Dec 06, 2010 at 12:54:30PM -0600, Christopher R. Hertel wrot=
e:
>>> There are a lot of companies out there that do WAN acceleration and=
 each of
>>> them do things differently, so there is no good answer to your quit=
e
>>> rational question. =A0Some of the vendors are very focused on "just=
 like the
>>> real thing" behavior while others are willing to compromise behavio=
r in
>>> favor of acceleration.
>>>
>>> The best-known product in this market would be Riverbed. =A0BlueCoa=
t is
>>> another, I think.
>>
>> Sorry, but if a WAN accelerator does not have the smarts to
>> see that if a client sends smbechos, it is in trouble, then
>> that WAN accelerator is just broken. It does not necessarily
>> need to send these echos across the WAN link, but it must
>> trigger its own server liveliness check at this point.
>
> I agree.
>
> That's why these companies hire me, though. =A0They have *no clue* wh=
en it
> comes to CIFS and they run into brick walls at full speed.
>
> When it comes down to it, though, anyone with smarts and half a clue =
would
> avoid SMB/CIFS if at all possible. =A0Most of what we do with Samba a=
nd the
> CIFS client is mitigate stupidity. =A0:)
>
> ...and we're good at it too!

Now that I have experimented with smb2,  it does seem better (and the
alternatives are worse)



--=20
Thanks,

Steve

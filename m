From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [3.0-rc1] CIFS ACL build failure without CONFIG_KEYS
Date: Mon, 6 Jun 2011 11:58:33 -0500
Message-ID: <BANLkTimRFJoo3rrU7fLriu1L-xt5MCmymQ@mail.gmail.com>
References: <51E1844698%linux@youmustbejoking.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Darren Salt <linux-Ym6Ivm/Ks7B65+NM0QMiFAbYiX8G1TQY9dF7HbQ/qKg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51E1844698%linux-Ym6Ivm/Ks7B65+NM0QMiFAbYiX8G1TQY9dF7HbQ/qKg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I merged the 2nd of the two.

On Tue, May 31, 2011 at 12:23 PM, Darren Salt
<linux-Ym6Ivm/Ks7B65+NM0QMiFAbYiX8G1TQY9dF7HbQ/qKg@public.gmane.org> wrote:
> In 3.0-rc1, without CONFIG_KEYS, cifs-acl.c compilation fails with va=
rious
> errors, including one about trying to dereference an incomplete type =
(struct
> keys, defined in <linux/key.h>).
>
> I'm including two patches for this since I don't know which way to go=
 on this
> one: pick whichever is more correct :-)
>
> --
> | Darren Salt =A0| linux or ds at =A0| nr. Ashington, | =A0_ =A0ASCII=
 ribbon
> | using Debian | youmustbejoking | Northumberland | ( ) campaign agai=
nst
> | GNU/Linux =A0 =A0| ,demon,co,uk =A0 =A0| =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0| =A0X =A0HTML e-mail
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/ \ www.asciiribbon.org
> Live every day like it's your last, because one day you'll be right.
>
>



--=20
Thanks,

Steve

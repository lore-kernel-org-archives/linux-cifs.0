From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Linux CIFS corruption bug in kernel 3.0.4 and 3.1
Date: Tue, 1 Nov 2011 13:37:04 -0400
Message-ID: <20111101133704.3c7335fb@tlielax.poochiereds.net>
References: <CAGc=Oh8GGXw6itfAo5-x6CpbwtK1TQeZrerx_zPrC4qABR2m6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGc=Oh8GGXw6itfAo5-x6CpbwtK1TQeZrerx_zPrC4qABR2m6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Nov 2011 10:09:26 -0500
Nick Davis <nick-fUoCq3+lmYBnK6aPwh9DPQ@public.gmane.org> wrote:

> Hello,
>=20
> I've recently noticed a corruption bug in the Linux kernel CIFS clien=
t
> that ships with Ubuntu 11.10 (kernel 3.0, based on upstream 3.0.4).
> I've filed a bug report with the details on Launchpad
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/879228
>=20
> As suggested in the Launchpad bug comments, I installed a custom
> kernel based on the upstream 3.1, but after testing the bug is still
> present. =C2=A0It was then suggested that I file a bug report with th=
e
> upstream subsystem maintainer.
>=20
> Let me know if I can provide any further information, or if I should
> report this issue somewhere else.
>=20

This is the right place to report it, but as we're not all ubuntu users
it would be helpful for you to outline the problem in your mail to the
list.

Looking over the launchpad report, it looks like this is something
you're able to reproduce at will. Is it possible to share that
reproducer? That would help us to be able to track down the problem and
verify that it's fixed once we understand it.

What may be best is to open a bug at bugzilla.samba.org so we have a
place to track info relating to this. If you do that, please cc me on
the bug and I'll plan to take a look.

Thanks,
--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

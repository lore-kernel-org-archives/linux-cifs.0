From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [linux-cifs-client] problems with signing and new crypto code
Date: Fri, 17 Jun 2011 10:13:21 -0400
Message-ID: <20110617101321.23ee627e@tlielax.poochiereds.net>
References: <20110617090656.35e508a5@tlielax.poochiereds.net>
	<BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Jun 2011 08:58:40 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jun 17, 2011 at 8:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > Hi Shirish,
> >
> > I've been working on some backports of some upstream patch series a=
nd
> > have run into what I think is a problem with the new crypto code. T=
he
> > problem mainly seems to manifest itself as bad signatures in write
> > calls. This causes a win2k8 server (at least) to reject the call wi=
th
> > STATUS_ACCESS_DENIED and stop responding to other calls on the sock=
et.
> >
> > I did a bisect of sorts, and got to this patch:
> >
> > commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Date: =C2=A0 Tue Apr 12 09:13:44 2011 -0400
> >
> > =C2=A0 =C2=A0cifs: don't allow mmap'ed pages to be dirtied while un=
der writeback (try #3)
> >
> > My original thought was that something was altering these pages whi=
le
> > they were under writeback, but I did some instrumentation and found
> > that not to be the case. The signature is the same before and after
> > the send when this occurs. A key change in this patch is that when
> > signing is enabled, the code started using CIFSSMBWrite2(), which
> > marshals up the send buffer in an array of kvecs.
> >
> > That leads me to believe that the cifs_sign_smb2 codepath is busted=
=2E
> >
> > I'll see if I can come up with a testcase, but I'm not that familia=
r
> > with the kernel crypto code. Is this something you've seen in your
> > testing? Any immediate thoughts as to where the problem may be?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20

(fixing cc list since I goofed it earlier...)

> Jeff, no I have not seen this. You think some iozone testing against
> a Windows server with the latest cifs code might expose this problem?
> I will try both Windows 2003 server and Windows 2008 server.
>=20

I'm using fsstress against win2k8, and it seems to fail on the initial
write calls.

> cifs_sign_smb and cifs_sign_smb2 do the same exact thing except that
> the messages that gets used in signature calculation are different in=
 these
> routines.
>=20
> My initial thought was/is the same as yours, the content of message
> used in calculating signature is different at the server and client r=
esulting
> in different signatures hence dropped smb connection by the server.
> But it is possible cifs_sign_smb2 and/or cifs_calc_signature2 have a =
bug!
>=20

I did a test where I recalculated the signature after calling smb_sendv
and then compared it to the original signature and they matched, but
the server rejected it. I'm still trying to nail down the problem, so
the bug could be anywhere really.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

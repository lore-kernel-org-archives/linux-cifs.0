From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [linux-cifs-client] problems with signing and new crypto code
Date: Fri, 17 Jun 2011 11:58:32 -0400
Message-ID: <20110617115832.035cd603@tlielax.poochiereds.net>
References: <20110617090656.35e508a5@tlielax.poochiereds.net>
	<BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ@mail.gmail.com>
	<20110617101321.23ee627e@tlielax.poochiereds.net>
	<BANLkTimnh92is9yu6fECaZyg=uEoPmMb4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimnh92is9yu6fECaZyg=uEoPmMb4Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Jun 2011 10:40:21 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jun 17, 2011 at 9:13 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 17 Jun 2011 08:58:40 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Jun 17, 2011 at 8:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > Hi Shirish,
> >> >
> >> > I've been working on some backports of some upstream patch serie=
s and
> >> > have run into what I think is a problem with the new crypto code=
=2E The
> >> > problem mainly seems to manifest itself as bad signatures in wri=
te
> >> > calls. This causes a win2k8 server (at least) to reject the call=
 with
> >> > STATUS_ACCESS_DENIED and stop responding to other calls on the s=
ocket.
> >> >
> >> > I did a bisect of sorts, and got to this patch:
> >> >
> >> > commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
> >> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> > Date: =C2=A0 Tue Apr 12 09:13:44 2011 -0400
> >> >
> >> > =C2=A0 =C2=A0cifs: don't allow mmap'ed pages to be dirtied while=
 under writeback (try #3)
> >> >
> >> > My original thought was that something was altering these pages =
while
> >> > they were under writeback, but I did some instrumentation and fo=
und
> >> > that not to be the case. The signature is the same before and af=
ter
> >> > the send when this occurs. A key change in this patch is that wh=
en
> >> > signing is enabled, the code started using CIFSSMBWrite2(), whic=
h
> >> > marshals up the send buffer in an array of kvecs.
> >> >
> >> > That leads me to believe that the cifs_sign_smb2 codepath is bus=
ted.
> >> >
> >> > I'll see if I can come up with a testcase, but I'm not that fami=
liar
> >> > with the kernel crypto code. Is this something you've seen in yo=
ur
> >> > testing? Any immediate thoughts as to where the problem may be?
> >> >
> >> > --
> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >
> >>
> >
> > (fixing cc list since I goofed it earlier...)
> >
> >> Jeff, no I have not seen this. You think some iozone testing again=
st
> >> a Windows server with the latest cifs code might expose this probl=
em?
> >> I will try both Windows 2003 server and Windows 2008 server.
> >>
> >
> > I'm using fsstress against win2k8, and it seems to fail on the init=
ial
> > write calls.
> >
> >> cifs_sign_smb and cifs_sign_smb2 do the same exact thing except th=
at
> >> the messages that gets used in signature calculation are different=
 in these
> >> routines.
> >>
> >> My initial thought was/is the same as yours, the content of messag=
e
> >> used in calculating signature is different at the server and clien=
t resulting
> >> in different signatures hence dropped smb connection by the server=
=2E
> >> But it is possible cifs_sign_smb2 and/or cifs_calc_signature2 have=
 a bug!
> >>
> >
> > I did a test where I recalculated the signature after calling smb_s=
endv
> > and then compared it to the original signature and they matched, bu=
t
> > the server rejected it. I'm still trying to nail down the problem, =
so
> > the bug could be anywhere really.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> Strange, iozone just hangs when I issue a command against a file on
> a Windows 2003 server
>=20
>         Run began: Fri Jun 17 10:34:13 2011
>=20
>         Auto Mode
>         Command line used:
> /usr/src/iozone/iozone3_323/src/current/iozone -a -f /mnt/smb_a/nfile=
1
>         Output is in Kbytes/sec
>         Time Resolution =3D 0.000001 seconds.
>         Processor cache size set to 1024 Kbytes.
>         Processor cache line size set to 32 bytes.
>         File stride size set to 17 * record size.
>                                                             random
> random    bkwd   record   stride
>               KB  reclen   write rewrite    read    reread    read
> write    read  rewrite     read   fwrite frewrite   fread  freread
>               64       4
>=20
> The last packets 9n wireshark trace on the server is
>=20
> write andx response: status access denied
> locking andx request fid: xyz
>=20
> and then cifs client reconnects.
>=20
> (may be this is the dropping/locking smb connection because signature
> in the write andx request is invalid).

Right, that's basically what I see. win2k8 just replies with status
access denied. I suspect that that's because the signature is incorrect=
=2E

I've noticed too that it only happens with larger writes. Right now,
I'm trying to figure out the size where it breaks.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

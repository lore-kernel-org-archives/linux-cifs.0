From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [linux-cifs-client] problems with signing and new crypto code
Date: Mon, 20 Jun 2011 07:48:56 -0400
Message-ID: <20110620074856.728b10f0@corrin.poochiereds.net>
References: <20110617090656.35e508a5@tlielax.poochiereds.net>
	<BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ@mail.gmail.com>
	<20110617101321.23ee627e@tlielax.poochiereds.net>
	<BANLkTimnh92is9yu6fECaZyg=uEoPmMb4Q@mail.gmail.com>
	<20110617115832.035cd603@tlielax.poochiereds.net>
	<BANLkTikwfFqMDPU4wt0J_K41GZcwZGJgLw@mail.gmail.com>
	<20110618063502.06de3361@corrin.poochiereds.net>
	<BANLkTim+-OGxUYCax31G=uqGJrfET8q56g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTim+-OGxUYCax31G=uqGJrfET8q56g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 18 Jun 2011 20:53:21 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Jun 18, 2011 at 5:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 17 Jun 2011 12:20:08 -0500
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Jun 17, 2011 at 10:58 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
> >> > On Fri, 17 Jun 2011 10:40:21 -0500
> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Fri, Jun 17, 2011 at 9:13 AM, Jeff Layton <jlayton-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >> >> > On Fri, 17 Jun 2011 08:58:40 -0500
> >> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >
> >> >> >> On Fri, Jun 17, 2011 at 8:06 AM, Jeff Layton <jlayton@redhat=
=2Ecom> wrote:
> >> >> >> > Hi Shirish,
> >> >> >> >
> >> >> >> > I've been working on some backports of some upstream patch=
 series and
> >> >> >> > have run into what I think is a problem with the new crypt=
o code. The
> >> >> >> > problem mainly seems to manifest itself as bad signatures =
in write
> >> >> >> > calls. This causes a win2k8 server (at least) to reject th=
e call with
> >> >> >> > STATUS_ACCESS_DENIED and stop responding to other calls on=
 the socket.
> >> >> >> >
> >> >> >> > I did a bisect of sorts, and got to this patch:
> >> >> >> >
> >> >> >> > commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
> >> >> >> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> >> > Date: =C2=A0 Tue Apr 12 09:13:44 2011 -0400
> >> >> >> >
> >> >> >> > =C2=A0 =C2=A0cifs: don't allow mmap'ed pages to be dirtied=
 while under writeback (try #3)
> >> >> >> >
> >> >> >> > My original thought was that something was altering these =
pages while
> >> >> >> > they were under writeback, but I did some instrumentation =
and found
> >> >> >> > that not to be the case. The signature is the same before =
and after
> >> >> >> > the send when this occurs. A key change in this patch is t=
hat when
> >> >> >> > signing is enabled, the code started using CIFSSMBWrite2()=
, which
> >> >> >> > marshals up the send buffer in an array of kvecs.
> >> >> >> >
> >> >> >> > That leads me to believe that the cifs_sign_smb2 codepath =
is busted.
> >> >> >> >
> >> >> >> > I'll see if I can come up with a testcase, but I'm not tha=
t familiar
> >> >> >> > with the kernel crypto code. Is this something you've seen=
 in your
> >> >> >> > testing? Any immediate thoughts as to where the problem ma=
y be?
> >> >> >> >
> >> >> >> > --
> >> >> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> >> >
> >> >> >>
> >> >> >
> >> >> > (fixing cc list since I goofed it earlier...)
> >> >> >
> >> >> >> Jeff, no I have not seen this. You think some iozone testing=
 against
> >> >> >> a Windows server with the latest cifs code might expose this=
 problem?
> >> >> >> I will try both Windows 2003 server and Windows 2008 server.
> >> >> >>
> >> >> >
> >> >> > I'm using fsstress against win2k8, and it seems to fail on th=
e initial
> >> >> > write calls.
> >> >> >
> >> >> >> cifs_sign_smb and cifs_sign_smb2 do the same exact thing exc=
ept that
> >> >> >> the messages that gets used in signature calculation are dif=
ferent in these
> >> >> >> routines.
> >> >> >>
> >> >> >> My initial thought was/is the same as yours, the content of =
message
> >> >> >> used in calculating signature is different at the server and=
 client resulting
> >> >> >> in different signatures hence dropped smb connection by the =
server.
> >> >> >> But it is possible cifs_sign_smb2 and/or cifs_calc_signature=
2 have a bug!
> >> >> >>
> >> >> >
> >> >> > I did a test where I recalculated the signature after calling=
 smb_sendv
> >> >> > and then compared it to the original signature and they match=
ed, but
> >> >> > the server rejected it. I'm still trying to nail down the pro=
blem, so
> >> >> > the bug could be anywhere really.
> >> >> >
> >> >> > --
> >> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> >
> >> >>
> >> >> Strange, iozone just hangs when I issue a command against a fil=
e on
> >> >> a Windows 2003 server
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Run began: Fri Jun 17 10:34:13 2011
> >> >>
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Auto Mode
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Command line used:
> >> >> /usr/src/iozone/iozone3_323/src/current/iozone -a -f /mnt/smb_a=
/nfile1
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Output is in Kbytes/sec
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Time Resolution =3D 0.000001 second=
s.
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Processor cache size set to 1024 Kb=
ytes.
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 Processor cache line size set to 32=
 bytes.
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 File stride size set to 17 * record=
 size.
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 random
> >> >> random =C2=A0 =C2=A0bkwd =C2=A0 record =C2=A0 stride
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 KB =C2=A0recle=
n =C2=A0 write rewrite =C2=A0 =C2=A0read =C2=A0 =C2=A0reread =C2=A0 =C2=
=A0read
> >> >> write =C2=A0 =C2=A0read =C2=A0rewrite =C2=A0 =C2=A0 read =C2=A0=
 fwrite frewrite =C2=A0 fread =C2=A0freread
> >> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 64 =C2=A0 =C2=A0=
 =C2=A0 4
> >> >>
> >> >> The last packets 9n wireshark trace on the server is
> >> >>
> >> >> write andx response: status access denied
> >> >> locking andx request fid: xyz
> >> >>
> >> >> and then cifs client reconnects.
> >> >>
> >> >> (may be this is the dropping/locking smb connection because sig=
nature
> >> >> in the write andx request is invalid).
> >> >
> >> > Right, that's basically what I see. win2k8 just replies with sta=
tus
> >> > access denied. I suspect that that's because the signature is in=
correct.
> >> >
> >> > I've noticed too that it only happens with larger writes. Right =
now,
> >> > I'm trying to figure out the size where it breaks.
> >> >
> >> > --
> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >
> >>
> >> Jeff, no problems with the dd commands
> >>
> >> # ls -l /mnt/smb_a/largefle
> >> -rw-r--r-- 1 root root 16641 Jun 17 12:22 /mnt/smb_a/largefile
> >>
> >> =C2=A0# dd if=3D/tmp/largefile of/mnt/smb_a/largefile bs=3D16641 c=
ount=3D100
> >> 100+0 records in
> >> 100+0 records out
> >> 1664100 bytes (1.7 MB) copied, 0.0350296 s, 47.5 MB/s
> >>
> >> =C2=A0# ls -l /mnt/smb_a/largefle
> >> -rw-r--r-- 1 root root 1664100 Jun 17 12:22 /mnt/smb_a/largefile
> >>
> >> =C2=A0# dd if=3D/tmp/largefile of=3D/mnt/smb_a/largefile bs=3D1664=
1 count=3D1000
> >> 1000+0 records in
> >> 1000+0 records out
> >> 16641000 bytes (17 MB) copied, 0.241208 s, 69.0 MB/s
> >>
> >> =C2=A0# ls -l /mnt/smb_a/largefile
> >> -rw-r--r-- 1 root root 16641000 Jun 17 12:23 /mnt/smb_a/largefile
> >
> > Interesting, I've been able to consistently get this to fail with:
> >
> > =C2=A0 =C2=A0# dd if=3D/dev/urandom of=3D/mnt/win2k8/file bs=3D1664=
1 count=3D1
> >
> > ...but if I write 16640 bytes, it works.
> >
> > In any case, I've opened a bug at samba.org:
> >
> > =C2=A0 =C2=A0https://bugzilla.samba.org/show_bug.cgi?id=3D8245
> >
> > ...so we can track this problem. At this point, I'm still trying to
> > nail down what the problem actually is.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> Could it be that Windows server sets a limit of max byte size
> when signing is used?
> I copied a 70,000 bytes file from Windows 2003 server (client) to
> a Windows 2008 server (server) with signing enabled and
> max bytes written are 16580 bytes.
>=20
> Perhaps Samba server has no such limitation and so signature
> at the client and server match for any write size.

I think you may be correct here. I had originally thought that the old
crypto code didn't have this problem, but I think I made a mistake in
my testing before. When I went back and tested a RHEL6.1 kernel (which
has the old crypto code) and set /proc/fs/cifs/Experimental to 1, I hit
the same problem against win2k8.

So, I think the conclusion we have to draw here is that win2k8 (and
probably other versions of windows) can't handle signed packets that
are "too large", and that we don't have a bug in the crypto code at all=
=2E

I'll go back over the MS docs to see if there is mention of this
limitation that I missed before and if not, I'll request clarification
from MS.

The next question we have to answer is whether we ought to try and
predict this situation somehow, and negotiate down the wsize when it
occurs. If so, what criteria should we base that decision on? Maybe MS
can shed some light on this...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

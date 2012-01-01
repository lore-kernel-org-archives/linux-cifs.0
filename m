From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Sun, 1 Jan 2012 06:44:49 -0500
Message-ID: <20120101064449.50277028@tlielax.poochiereds.net>
References: <4EFBAF99.3010208@gmail.com>
	<20111228210420.2a422d11@corrin.poochiereds.net>
	<4EFC413A.80302@gmail.com>
	<20111229083930.77fafba8@tlielax.poochiereds.net>
	<4EFC7124.3060900@gmail.com>
	<4EFD7EBB.2060708@gmail.com>
	<20111230081120.3f7710f1@tlielax.poochiereds.net>
	<4EFDFC4E.30102@gmail.com>
	<20111231065922.05727805@tlielax.poochiereds.net>
	<4EFF04E3.70200@gmail.com>
	<4EFF110C.7010302@gmail.com>
	<20111231202331.2a03bb35@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111231202331.2a03bb35-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 31 Dec 2011 20:23:31 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Sat, 31 Dec 2011 15:41:32 +0200
> Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>=20
> > On 31/12/2011 2:49 =CE=BC=CE=BC, Konstantinos Skarlatos wrote:
> > > On =CE=A3=CE=AC=CE=B2=CE=B2=CE=B1=CF=84=CE=BF, 31 =CE=94=CE=B5=CE=
=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 1:59:22 =CE=BC=CE=BC=
, Jeff Layton wrote:
> > >> On Fri, 30 Dec 2011 20:00:46 +0200
> > >> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >>
> > >>> On 30/12/2011 3:11 =CE=BC=CE=BC, Jeff Layton wrote:
> > >>>> On Fri, 30 Dec 2011 11:04:59 +0200
> > >>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >>>>
> > >>>>> On 29/12/2011 3:54 =CE=BC=CE=BC, Konstantinos Skarlatos wrote=
:
> > >>>>>> On =CE=A0=CE=AD=CE=BC=CF=80=CF=84=CE=B7, 29 =CE=94=CE=B5=CE=BA=
=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 3:39:30 =CE=BC=CE=BC, J=
eff Layton wrote:
> > >>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
> > >>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >>>>>>>
> > >>>>>>>> On 29/12/2011 4:04 =CF=80=CE=BC, Jeff Layton wrote:
> > >>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
> > >>>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> > >>>>>>>>>
> > >>>>>>>>>> I mount via cifs a windows XP share, df gives me correct=
 sizes,
> > >>>>>>>>>> but when
> > >>>>>>>>>> I ls the mount point i get input/output error.
> > >>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
> > >>>>>>>>>>
> > >>>>>>>>>> mount --verbose -t cifs -o
> > >>>>>>>>>> username=3Dadministrator,password=3Dblahblah
> > >>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
> > >>>>>>>>>> mount.cifs kernel mount options:
> > >>>>>>>>>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,use=
r=3Dadministrator,pass=3D********
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>>>
> > >>>>>>>>>> df
> > >>>>>>>>>> //192.168.0.11/jobs 114464
> > >>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
> > >>>>>>>>>>
> > >>>>>>>>>> ls /mnt/backups/montaz/jobs/
> > >>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/o=
utput
> > >>>>>>>>>> error
> > >>>>>>>>>> total 0
> > >>>>>>>>>>
> > >>>>>>>>>> the fun thing is that i can cd to a lower level director=
y, and ls
> > >>>>>>>>>> works
> > >>>>>>>>>> fine there! only the mount point has the problem
> > >>>>>>>>>>
> > >>>>>>>>>> ls /mnt/backups/montaz/jobs/test
> > >>>>>>>>>> total 44K
> > >>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
> > >>>>>>>>>> ......
> > >>>>>>>>>>
> > >>>>>>>>>> kernel version 3.2rc7
> > >>>>>>>>>>
> > >>>>>>>>>> this seems to be related to :
> > >>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
> > >>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() brok=
en for
> > >>>>>>>>>> large dirs
> > >>>>>>>>>>
> > >>>>>>>>> Hmmm, maybe. What makes you think that it's related? What=
 sort of
> > >>>>>>>>> server are you seeing this against?
> > >>>>>>>> Windows XP service pack 2 (greek)
> > >>>>>>>
> > >>>>>>> How many files are in the directory?
> > >>>>>>>
> > >>>>>> 140 folders and 20 files
> > >>>>>>
> > >>>>> Attached is a tcp dump of my session.
> > >>>> I tried reproducing this here, but wasn't able to. Testing aga=
inst my
> > >>>> xp box worked fine.
> > >>>>
> > >>>> Most likely, the FIND_FILE responses are falling afoul of the =
code in
> > >>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
> > >>>> complicated and I'm not certain what the problem actually is..=
=2E
> > >>>>
> > >>>> One thing that's interesting is that the total data being sent=
 in the
> > >>>> request is rather large (16336 bytes). I think that's legit, b=
ut maybe
> > >>>> it's exceeding the end of the buffer once we try to coalesce i=
t.
> > >>>>
> > >>>> Would it be possible to get the cFYI output from this test?
> > >>> I did not get a cFYI output from that test, but i redid a
> > >>> mount-ls-umount and am attaching the tcpdump
> > >>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI=
 and the
> > >>> contents of /proc/fs/cifs/DebugData form the same test
> > >>>>
> > >>>> Is this a regression? Did it work with earlier kernels and onl=
y
> > >>>> recently start failing?
> > >>>>
> > >>> I do not know, and i am a bit afraid to downgrade this machine =
below 3.0
> > >>> due to some changes arch linux has introduced recently. I can a=
lways set
> > >>> up a few virtual machines though, and i can even request permis=
sion from
> > >>> my company to give you shell access if you like. Which kernel v=
ersions
> > >>> would you like me to test?
> > >>
> > >>
> > >> Ok, that tells us a little:
> > >>
> > >> -------------------[snip]---------------------
> > >> [96268.787078] fs/cifs/cifssmb.c: In FindFirst for
> > >> [96268.787083] fs/cifs/transport.c: For smb_command 50
> > >> [96268.787086] fs/cifs/transport.c: Sending smb: total_len 88
> > >>
> > >> ...FIND_FIRST command is sent
> > >>
> > >> [96268.787690] fs/cifs/connect.c: RFC1002 header 0x1104
> > >> [96268.787697] fs/cifs/connect.c: missing 12048 bytes from trans=
act2,
> > >> check next response
> > >> [96268.787865] fs/cifs/connect.c: RFC1002 header 0x1104
> > >> [96268.787870] fs/cifs/connect.c: missing 12036 bytes from trans=
act2,
> > >> check next response
> > >> [96268.788037] fs/cifs/connect.c: RFC1002 header 0x1104
> > >> [96268.788042] fs/cifs/connect.c: missing 12036 bytes from trans=
act2,
> > >> check next response
> > >> [96268.788371] fs/cifs/connect.c: RFC1002 header 0xdb0
> > >> [96268.788375] fs/cifs/connect.c: missing 12888 bytes from trans=
act2,
> > >> check next response
> > >>
> > >> ...all four parts of the response are collected here
> > >>
> > >> [96268.788391] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D=
50
> > >> mid=3D12 state=3D16
> > >>
> > >> ...but the state at this point is MID_RESPONSE_MALFORMED
> > >>
> > >> [96268.788395] fs/cifs/cifssmb.c: Error in FindFirst =3D -5
> > >> [96268.788397] fs/cifs/readdir.c: initiate cifs search rc -5
> > >> [96268.788398] fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir=
 (xid
> > >> =3D 737644) rc =3D -5
> > >>
> > >> ...which makes readdir return -EIO
> > >>
> > >> -------------------[snip]---------------------
> > >>
> > >> Based on that, it looks like something in one of these frames ca=
used
> > >> coalesce_t2() to return an error. I don't see the problem right =
offhand
> > >> in the capture, but T2 response handling is pretty complex so it=
 can be
> > >> hard to see.
> > >>
> > >> Would it be possible for you to rebuild your kernel (or just cif=
s.ko)
> > >> with this patch? Once you do that, rerun the test with cFYI turn=
ed up,
> > >> and it should help point out what the problem is.
> > >>
> > >> Thanks,
> > >
> > > Ok i am now rebuilding the kernel and will report when i have res=
ults.
> > http://pastebin.com/scgyDjhT and attached tcpdump
>=20
> Very helpful -- I think I see the bug now. Can you test this patch an=
d
> let me know if it fixes the problem? You'll need to back out the debu=
g
> patch first, and then apply this one. If it works, I'll plan to clean
> this up and send to Steve for inclusion.
>=20
> Thanks...
>=20

Actually...that patch is off by 4 bytes. Since we're so late in the
cycle too, we should probably keep extraneous changes to a minimum.
I'll probably propose this patch for 3.2 once you've tested it, and
will spin up a patch to clean up coalesce_t2 for 3.3.

If you're already testing the other one, then it's probably good enough
to verify the fix. If you haven't tested it yet though, then you should
probably test this one instead. Either way, let me know soon if you can
so we can get this into 3.2.

---------------------------[snip]----------------------------


[PATCH] cifs: fix bad buffer length check in coalesce_t2

The current check looks to see if the RFC1002 length is larger than
CIFSMaxBufSize and fails if it is. The buffer is actually larger than
that by MAX_CIFS_HDR_SIZE. Fix the check so that it doesn't fail due
to this.

This bug has been around for a long time, but the fact that we used to
cap the clients MaxBufferSize at the same level as the server tended
to paper over it. Commit c974befa changed that however.

Reported-by: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8cd4b52..27c4f25 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -282,7 +282,7 @@ static int coalesce_t2(struct smb_hdr *psecond, str=
uct smb_hdr *pTargetSMB)
 	byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_length);
 	byte_count +=3D total_in_buf2;
 	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize)
+	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE - 4)
 		return -ENOBUFS;
 	pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_count);
=20
--=20
1.7.7.4

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Sun, 1 Jan 2012 06:13:07 -0500
Message-ID: <20120101061307.2e2e66b8@tlielax.poochiereds.net>
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
	<CADT32eKo0nD9DebA3-UX_DuM6pe_fj5k9hL8PsOs780P6aWG9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKo0nD9DebA3-UX_DuM6pe_fj5k9hL8PsOs780P6aWG9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 1 Jan 2012 01:22:59 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Sat, Dec 31, 2011 at 7:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Sat, 31 Dec 2011 15:41:32 +0200
> > Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On 31/12/2011 2:49 =CE=BC=CE=BC, Konstantinos Skarlatos wrote:
> >> > On =CE=A3=CE=AC=CE=B2=CE=B2=CE=B1=CF=84=CE=BF, 31 =CE=94=CE=B5=CE=
=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 1:59:22 =CE=BC=CE=BC=
, Jeff Layton wrote:
> >> >> On Fri, 30 Dec 2011 20:00:46 +0200
> >> >> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >>
> >> >>> On 30/12/2011 3:11 =CE=BC=CE=BC, Jeff Layton wrote:
> >> >>>> On Fri, 30 Dec 2011 11:04:59 +0200
> >> >>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >>>>
> >> >>>>> On 29/12/2011 3:54 =CE=BC=CE=BC, Konstantinos Skarlatos wrot=
e:
> >> >>>>>> On =CE=A0=CE=AD=CE=BC=CF=80=CF=84=CE=B7, 29 =CE=94=CE=B5=CE=
=BA=CE=AD=CE=BC=CE=B2=CF=81=CE=B9=CE=BF=CF=82 2011 3:39:30 =CE=BC=CE=BC=
, Jeff Layton wrote:
> >> >>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
> >> >>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >>>>>>>
> >> >>>>>>>> On 29/12/2011 4:04 =CF=80=CE=BC, Jeff Layton wrote:
> >> >>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
> >> >>>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >>>>>>>>>
> >> >>>>>>>>>> I mount via cifs a windows XP share, df gives me correc=
t sizes,
> >> >>>>>>>>>> but when
> >> >>>>>>>>>> I ls the mount point i get input/output error.
> >> >>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
> >> >>>>>>>>>>
> >> >>>>>>>>>> mount --verbose -t cifs -o
> >> >>>>>>>>>> username=3Dadministrator,password=3Dblahblah
> >> >>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
> >> >>>>>>>>>> mount.cifs kernel mount options:
> >> >>>>>>>>>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,us=
er=3Dadministrator,pass=3D********
> >> >>>>>>>>>>
> >> >>>>>>>>>>
> >> >>>>>>>>>>
> >> >>>>>>>>>> df
> >> >>>>>>>>>> //192.168.0.11/jobs 114464
> >> >>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
> >> >>>>>>>>>>
> >> >>>>>>>>>> ls /mnt/backups/montaz/jobs/
> >> >>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/=
output
> >> >>>>>>>>>> error
> >> >>>>>>>>>> total 0
> >> >>>>>>>>>>
> >> >>>>>>>>>> the fun thing is that i can cd to a lower level directo=
ry, and ls
> >> >>>>>>>>>> works
> >> >>>>>>>>>> fine there! only the mount point has the problem
> >> >>>>>>>>>>
> >> >>>>>>>>>> ls /mnt/backups/montaz/jobs/test
> >> >>>>>>>>>> total 44K
> >> >>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
> >> >>>>>>>>>> ......
> >> >>>>>>>>>>
> >> >>>>>>>>>> kernel version 3.2rc7
> >> >>>>>>>>>>
> >> >>>>>>>>>> this seems to be related to :
> >> >>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
> >> >>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() bro=
ken for
> >> >>>>>>>>>> large dirs
> >> >>>>>>>>>>
> >> >>>>>>>>> Hmmm, maybe. What makes you think that it's related? Wha=
t sort of
> >> >>>>>>>>> server are you seeing this against?
> >> >>>>>>>> Windows XP service pack 2 (greek)
> >> >>>>>>>
> >> >>>>>>> How many files are in the directory?
> >> >>>>>>>
> >> >>>>>> 140 folders and 20 files
> >> >>>>>>
> >> >>>>> Attached is a tcp dump of my session.
> >> >>>> I tried reproducing this here, but wasn't able to. Testing ag=
ainst my
> >> >>>> xp box worked fine.
> >> >>>>
> >> >>>> Most likely, the FIND_FILE responses are falling afoul of the=
 code in
> >> >>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
> >> >>>> complicated and I'm not certain what the problem actually is.=
=2E.
> >> >>>>
> >> >>>> One thing that's interesting is that the total data being sen=
t in the
> >> >>>> request is rather large (16336 bytes). I think that's legit, =
but maybe
> >> >>>> it's exceeding the end of the buffer once we try to coalesce =
it.
> >> >>>>
> >> >>>> Would it be possible to get the cFYI output from this test?
> >> >>> I did not get a cFYI output from that test, but i redid a
> >> >>> mount-ls-umount and am attaching the tcpdump
> >> >>> Also here http://pastebin.com/J20uC6kU you can find the cifsFY=
I and the
> >> >>> contents of /proc/fs/cifs/DebugData form the same test
> >> >>>>
> >> >>>> Is this a regression? Did it work with earlier kernels and on=
ly
> >> >>>> recently start failing?
> >> >>>>
> >> >>> I do not know, and i am a bit afraid to downgrade this machine=
 below 3.0
> >> >>> due to some changes arch linux has introduced recently. I can =
always set
> >> >>> up a few virtual machines though, and i can even request permi=
ssion from
> >> >>> my company to give you shell access if you like. Which kernel =
versions
> >> >>> would you like me to test?
> >> >>
> >> >>
> >> >> Ok, that tells us a little:
> >> >>
> >> >> -------------------[snip]---------------------
> >> >> [96268.787078] fs/cifs/cifssmb.c: In FindFirst for
> >> >> [96268.787083] fs/cifs/transport.c: For smb_command 50
> >> >> [96268.787086] fs/cifs/transport.c: Sending smb: total_len 88
> >> >>
> >> >> ...FIND_FIRST command is sent
> >> >>
> >> >> [96268.787690] fs/cifs/connect.c: RFC1002 header 0x1104
> >> >> [96268.787697] fs/cifs/connect.c: missing 12048 bytes from tran=
sact2,
> >> >> check next response
> >> >> [96268.787865] fs/cifs/connect.c: RFC1002 header 0x1104
> >> >> [96268.787870] fs/cifs/connect.c: missing 12036 bytes from tran=
sact2,
> >> >> check next response
> >> >> [96268.788037] fs/cifs/connect.c: RFC1002 header 0x1104
> >> >> [96268.788042] fs/cifs/connect.c: missing 12036 bytes from tran=
sact2,
> >> >> check next response
> >> >> [96268.788371] fs/cifs/connect.c: RFC1002 header 0xdb0
> >> >> [96268.788375] fs/cifs/connect.c: missing 12888 bytes from tran=
sact2,
> >> >> check next response
> >> >>
> >> >> ...all four parts of the response are collected here
> >> >>
> >> >> [96268.788391] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D=
50
> >> >> mid=3D12 state=3D16
> >> >>
> >> >> ...but the state at this point is MID_RESPONSE_MALFORMED
> >> >>
> >> >> [96268.788395] fs/cifs/cifssmb.c: Error in FindFirst =3D -5
> >> >> [96268.788397] fs/cifs/readdir.c: initiate cifs search rc -5
> >> >> [96268.788398] fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdi=
r (xid
> >> >> =3D 737644) rc =3D -5
> >> >>
> >> >> ...which makes readdir return -EIO
> >> >>
> >> >> -------------------[snip]---------------------
> >> >>
> >> >> Based on that, it looks like something in one of these frames c=
aused
> >> >> coalesce_t2() to return an error. I don't see the problem right=
 offhand
> >> >> in the capture, but T2 response handling is pretty complex so i=
t can be
> >> >> hard to see.
> >> >>
> >> >> Would it be possible for you to rebuild your kernel (or just ci=
fs.ko)
> >> >> with this patch? Once you do that, rerun the test with cFYI tur=
ned up,
> >> >> and it should help point out what the problem is.
> >> >>
> >> >> Thanks,
> >> >
> >> > Ok i am now rebuilding the kernel and will report when i have re=
sults.
> >> http://pastebin.com/scgyDjhT and attached tcpdump
> >
> > Very helpful -- I think I see the bug now. Can you test this patch =
and
> > let me know if it fixes the problem? You'll need to back out the de=
bug
> > patch first, and then apply this one. If it works, I'll plan to cle=
an
> > this up and send to Steve for inclusion.
> >
> > Thanks...
> >
> > ----------------------[snip]---------------------
> >
> > [PATCH] cifs: fix buffer length check and better instrumentation fo=
r coalesce_t2
> >
> > Fix the buffer length check in coalesce_t2. The current one checks =
to
> > see that the rfc1002 length is not larger than the buffer that will
> > hold it. It gets the check wrong though. The buffer is MAX_CIFS_HDR=
_SIZE
> > larger than the current check allows for.
> >
> > Also, to make it easier to debug problems of this sort, when coales=
ce_t2
> > returns an error, have it throw a cFYI message that explains the re=
ason.
> >
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> > =C2=A0fs/cifs/connect.c | =C2=A0 29 +++++++++++++++++++++--------
> > =C2=A01 files changed, 21 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8cd4b52..0b033ff 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -243,16 +243,21 @@ static int coalesce_t2(struct smb_hdr *psecon=
d, struct smb_hdr *pTargetSMB)
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0remaining =3D total_data_size - total_in=
_buf;
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (remaining < 0)
> > + =C2=A0 =C2=A0 =C2=A0 if (remaining < 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "Server =
sent too much data. total_data_size=3D%hu "
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 "total_in_buf=3D%hu", total_data_size, total_in_buf);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EPRO=
TO;
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > - =C2=A0 =C2=A0 =C2=A0 if (remaining =3D=3D 0) /* nothing to do, ig=
nore */
> > + =C2=A0 =C2=A0 =C2=A0 if (remaining =3D=3D 0) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* nothing to do=
, ignore */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "no more=
 data remains");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;
> > + =C2=A0 =C2=A0 =C2=A0 }
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0total_in_buf2 =3D get_unaligned_le16(&pS=
MB2->t2_rsp.DataCount);
> > - =C2=A0 =C2=A0 =C2=A0 if (remaining < total_in_buf2) {
> > + =C2=A0 =C2=A0 =C2=A0 if (remaining < total_in_buf2)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "tra=
nsact2 2nd response contains too much data");
> > - =C2=A0 =C2=A0 =C2=A0 }
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* find end of first SMB data area */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0data_area_of_target =3D (char *)&pSMBt->=
hdr.Protocol +
> > @@ -267,23 +272,29 @@ static int coalesce_t2(struct smb_hdr *psecon=
d, struct smb_hdr *pTargetSMB)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* copy second buffer into end of first =
buffer */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0total_in_buf +=3D total_in_buf2;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* is the result too big for the field? =
*/
> > - =C2=A0 =C2=A0 =C2=A0 if (total_in_buf > USHRT_MAX)
> > + =C2=A0 =C2=A0 =C2=A0 if (total_in_buf > USHRT_MAX) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesc=
ed total_in_buf too large (%u)", total_in_buf);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EPRO=
TO;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0put_unaligned_le16(total_in_buf, &pSMBt-=
>t2_rsp.DataCount);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* fix up the BCC */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count =3D get_bcc(pTargetSMB);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count +=3D total_in_buf2;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* is the result too big for the field? =
*/
> > - =C2=A0 =C2=A0 =C2=A0 if (byte_count > USHRT_MAX)
> > + =C2=A0 =C2=A0 =C2=A0 if (byte_count > USHRT_MAX) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesc=
ed BCC too large (%u)", byte_count);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -EPRO=
TO;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0put_bcc(byte_count, pTargetSMB);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count =3D be32_to_cpu(pTargetSMB->s=
mb_buf_length);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0byte_count +=3D total_in_buf2;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* don't allow buffer to overflow */
> > - =C2=A0 =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize)
> > + =C2=A0 =C2=A0 =C2=A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_H=
DR_SIZE) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "coalesc=
ed BCC exceeds buffer size (%u)", byte_count);
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOB=
UFS;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0pTargetSMB->smb_buf_length =3D cpu_to_be=
32(byte_count);
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0memcpy(data_area_of_target, data_area_of=
_buf2, total_in_buf2);
> > @@ -291,8 +302,10 @@ static int coalesce_t2(struct smb_hdr *psecond=
, struct smb_hdr *pTargetSMB)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (remaining =3D=3D total_in_buf2) {
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0cFYI(1, "fou=
nd the last secondary response");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0; /*=
 we are done */
> > - =C2=A0 =C2=A0 =C2=A0 } else /* more responses to go */
> > + =C2=A0 =C2=A0 =C2=A0 } else {/* more responses to go */
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "waiting=
 for more secondary responses");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;
> > + =C2=A0 =C2=A0 =C2=A0 }
> > =C2=A0}
> >
> > =C2=A0static void
> > --
> > 1.7.7.4
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
>=20
> what I do not understand is,
>=20
> a)
> Why does Windows XP send different search counts to a findfirst2 requ=
est.
>=20
> b)
> This bug also does not manifest against a Windows 2003 server,
> Windows 2008 server and Windows 7.
>=20
> c)
> As per this document,
> http://msdn.microsoft.com/en-us/library/cc246806(v=3Dprot.13).aspx
>=20
> "<66> Section 2.2.8.1.2: The SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO
> Information Level was introduced in Windows Server 2003 and is not
> present in Windows 2000 Server and Windows XP."
>=20
> then why does Windows XP respond to
> trans2/find first2/SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO request
> with an error.

I've not personally seen the behavior you describe. I think you're
talking about a different problem altogether.

This bug was probably due to commit c974befa. Prior to that, the client
would artificially cap the MaxDataCount for the FindFirst at the same
level as that of the server. That papered over this bug in coalesce_t2.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

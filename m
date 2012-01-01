From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Sun, 1 Jan 2012 01:22:59 -0600
Message-ID: <CADT32eKo0nD9DebA3-UX_DuM6pe_fj5k9hL8PsOs780P6aWG9w@mail.gmail.com>
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
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111231202331.2a03bb35-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Dec 31, 2011 at 7:23 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Sat, 31 Dec 2011 15:41:32 +0200
> Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On 31/12/2011 2:49 =EC=EC, Konstantinos Skarlatos wrote:
>> > On =D3=DC=E2=E2=E1=F4=EF, 31 =C4=E5=EA=DD=EC=E2=F1=E9=EF=F2 2011 1=
:59:22 =EC=EC, Jeff Layton wrote:
>> >> On Fri, 30 Dec 2011 20:00:46 +0200
>> >> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >>> On 30/12/2011 3:11 =EC=EC, Jeff Layton wrote:
>> >>>> On Fri, 30 Dec 2011 11:04:59 +0200
>> >>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>
>> >>>>> On 29/12/2011 3:54 =EC=EC, Konstantinos Skarlatos wrote:
>> >>>>>> On =D0=DD=EC=F0=F4=E7, 29 =C4=E5=EA=DD=EC=E2=F1=E9=EF=F2 2011=
 3:39:30 =EC=EC, Jeff Layton wrote:
>> >>>>>>> On Thu, 29 Dec 2011 12:30:18 +0200
>> >>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>>>>
>> >>>>>>>> On 29/12/2011 4:04 =F0=EC, Jeff Layton wrote:
>> >>>>>>>>> On Thu, 29 Dec 2011 02:08:57 +0200
>> >>>>>>>>> Konstantinos Skarlatos<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>>>>>>>>
>> >>>>>>>>>> I mount via cifs a windows XP share, df gives me correct =
sizes,
>> >>>>>>>>>> but when
>> >>>>>>>>>> I ls the mount point i get input/output error.
>> >>>>>>>>>> strace: http://pastebin.com/WXf8M1nu
>> >>>>>>>>>>
>> >>>>>>>>>> mount --verbose -t cifs -o
>> >>>>>>>>>> username=3Dadministrator,password=3Dblahblah
>> >>>>>>>>>> //192.168.0.11/jobs /mnt/backups/montaz/jobs
>> >>>>>>>>>> mount.cifs kernel mount options:
>> >>>>>>>>>> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,user=
=3Dadministrator,pass=3D********
>> >>>>>>>>>>
>> >>>>>>>>>>
>> >>>>>>>>>>
>> >>>>>>>>>> df
>> >>>>>>>>>> //192.168.0.11/jobs 114464
>> >>>>>>>>>> 105196 9268 92% /mnt/backups/montaz/jobs
>> >>>>>>>>>>
>> >>>>>>>>>> ls /mnt/backups/montaz/jobs/
>> >>>>>>>>>> ls: reading directory /mnt/backups/montaz/jobs/: Input/ou=
tput
>> >>>>>>>>>> error
>> >>>>>>>>>> total 0
>> >>>>>>>>>>
>> >>>>>>>>>> the fun thing is that i can cd to a lower level directory=
, and ls
>> >>>>>>>>>> works
>> >>>>>>>>>> fine there! only the mount point has the problem
>> >>>>>>>>>>
>> >>>>>>>>>> ls /mnt/backups/montaz/jobs/test
>> >>>>>>>>>> total 44K
>> >>>>>>>>>> drwxr-xr-x 1 root root 0 Apr 30 2010 blah blah/
>> >>>>>>>>>> ......
>> >>>>>>>>>>
>> >>>>>>>>>> kernel version 3.2rc7
>> >>>>>>>>>>
>> >>>>>>>>>> this seems to be related to :
>> >>>>>>>>>> https://lkml.org/lkml/2011/8/1/427
>> >>>>>>>>>> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broke=
n for
>> >>>>>>>>>> large dirs
>> >>>>>>>>>>
>> >>>>>>>>> Hmmm, maybe. What makes you think that it's related? What =
sort of
>> >>>>>>>>> server are you seeing this against?
>> >>>>>>>> Windows XP service pack 2 (greek)
>> >>>>>>>
>> >>>>>>> How many files are in the directory?
>> >>>>>>>
>> >>>>>> 140 folders and 20 files
>> >>>>>>
>> >>>>> Attached is a tcp dump of my session.
>> >>>> I tried reproducing this here, but wasn't able to. Testing agai=
nst my
>> >>>> xp box worked fine.
>> >>>>
>> >>>> Most likely, the FIND_FILE responses are falling afoul of the c=
ode in
>> >>>> coalesce_t2 or check2ndT2. Unfortunately that code is pretty
>> >>>> complicated and I'm not certain what the problem actually is...
>> >>>>
>> >>>> One thing that's interesting is that the total data being sent =
in the
>> >>>> request is rather large (16336 bytes). I think that's legit, bu=
t maybe
>> >>>> it's exceeding the end of the buffer once we try to coalesce it=
=2E
>> >>>>
>> >>>> Would it be possible to get the cFYI output from this test?
>> >>> I did not get a cFYI output from that test, but i redid a
>> >>> mount-ls-umount and am attaching the tcpdump
>> >>> Also here http://pastebin.com/J20uC6kU you can find the cifsFYI =
and the
>> >>> contents of /proc/fs/cifs/DebugData form the same test
>> >>>>
>> >>>> Is this a regression? Did it work with earlier kernels and only
>> >>>> recently start failing?
>> >>>>
>> >>> I do not know, and i am a bit afraid to downgrade this machine b=
elow 3.0
>> >>> due to some changes arch linux has introduced recently. I can al=
ways set
>> >>> up a few virtual machines though, and i can even request permiss=
ion from
>> >>> my company to give you shell access if you like. Which kernel ve=
rsions
>> >>> would you like me to test?
>> >>
>> >>
>> >> Ok, that tells us a little:
>> >>
>> >> -------------------[snip]---------------------
>> >> [96268.787078] fs/cifs/cifssmb.c: In FindFirst for
>> >> [96268.787083] fs/cifs/transport.c: For smb_command 50
>> >> [96268.787086] fs/cifs/transport.c: Sending smb: total_len 88
>> >>
>> >> ...FIND_FIRST command is sent
>> >>
>> >> [96268.787690] fs/cifs/connect.c: RFC1002 header 0x1104
>> >> [96268.787697] fs/cifs/connect.c: missing 12048 bytes from transa=
ct2,
>> >> check next response
>> >> [96268.787865] fs/cifs/connect.c: RFC1002 header 0x1104
>> >> [96268.787870] fs/cifs/connect.c: missing 12036 bytes from transa=
ct2,
>> >> check next response
>> >> [96268.788037] fs/cifs/connect.c: RFC1002 header 0x1104
>> >> [96268.788042] fs/cifs/connect.c: missing 12036 bytes from transa=
ct2,
>> >> check next response
>> >> [96268.788371] fs/cifs/connect.c: RFC1002 header 0xdb0
>> >> [96268.788375] fs/cifs/connect.c: missing 12888 bytes from transa=
ct2,
>> >> check next response
>> >>
>> >> ...all four parts of the response are collected here
>> >>
>> >> [96268.788391] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3D5=
0
>> >> mid=3D12 state=3D16
>> >>
>> >> ...but the state at this point is MID_RESPONSE_MALFORMED
>> >>
>> >> [96268.788395] fs/cifs/cifssmb.c: Error in FindFirst =3D -5
>> >> [96268.788397] fs/cifs/readdir.c: initiate cifs search rc -5
>> >> [96268.788398] fs/cifs/readdir.c: CIFS VFS: leaving cifs_readdir =
(xid
>> >> =3D 737644) rc =3D -5
>> >>
>> >> ...which makes readdir return -EIO
>> >>
>> >> -------------------[snip]---------------------
>> >>
>> >> Based on that, it looks like something in one of these frames cau=
sed
>> >> coalesce_t2() to return an error. I don't see the problem right o=
ffhand
>> >> in the capture, but T2 response handling is pretty complex so it =
can be
>> >> hard to see.
>> >>
>> >> Would it be possible for you to rebuild your kernel (or just cifs=
=2Eko)
>> >> with this patch? Once you do that, rerun the test with cFYI turne=
d up,
>> >> and it should help point out what the problem is.
>> >>
>> >> Thanks,
>> >
>> > Ok i am now rebuilding the kernel and will report when i have resu=
lts.
>> http://pastebin.com/scgyDjhT and attached tcpdump
>
> Very helpful -- I think I see the bug now. Can you test this patch an=
d
> let me know if it fixes the problem? You'll need to back out the debu=
g
> patch first, and then apply this one. If it works, I'll plan to clean
> this up and send to Steve for inclusion.
>
> Thanks...
>
> ----------------------[snip]---------------------
>
> [PATCH] cifs: fix buffer length check and better instrumentation for =
coalesce_t2
>
> Fix the buffer length check in coalesce_t2. The current one checks to
> see that the rfc1002 length is not larger than the buffer that will
> hold it. It gets the check wrong though. The buffer is MAX_CIFS_HDR_S=
IZE
> larger than the current check allows for.
>
> Also, to make it easier to debug problems of this sort, when coalesce=
_t2
> returns an error, have it throw a cFYI message that explains the reas=
on.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 29 +++++++++++++++++++++--------
> =A01 files changed, 21 insertions(+), 8 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 8cd4b52..0b033ff 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -243,16 +243,21 @@ static int coalesce_t2(struct smb_hdr *psecond,=
 struct smb_hdr *pTargetSMB)
>
> =A0 =A0 =A0 =A0remaining =3D total_data_size - total_in_buf;
>
> - =A0 =A0 =A0 if (remaining < 0)
> + =A0 =A0 =A0 if (remaining < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Server sent too much data. tot=
al_data_size=3D%hu "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "total_in_buf=3D%hu", t=
otal_data_size, total_in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPROTO;
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (remaining =3D=3D 0) /* nothing to do, ignore */
> + =A0 =A0 =A0 if (remaining =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* nothing to do, ignore */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "no more data remains");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0total_in_buf2 =3D get_unaligned_le16(&pSMB2->t2_rsp.Da=
taCount);
> - =A0 =A0 =A0 if (remaining < total_in_buf2) {
> + =A0 =A0 =A0 if (remaining < total_in_buf2)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "transact2 2nd response contai=
ns too much data");
> - =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* find end of first SMB data area */
> =A0 =A0 =A0 =A0data_area_of_target =3D (char *)&pSMBt->hdr.Protocol +
> @@ -267,23 +272,29 @@ static int coalesce_t2(struct smb_hdr *psecond,=
 struct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0/* copy second buffer into end of first buffer */
> =A0 =A0 =A0 =A0total_in_buf +=3D total_in_buf2;
> =A0 =A0 =A0 =A0/* is the result too big for the field? */
> - =A0 =A0 =A0 if (total_in_buf > USHRT_MAX)
> + =A0 =A0 =A0 if (total_in_buf > USHRT_MAX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced total_in_buf too lar=
ge (%u)", total_in_buf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPROTO;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0put_unaligned_le16(total_in_buf, &pSMBt->t2_rsp.DataCo=
unt);
>
> =A0 =A0 =A0 =A0/* fix up the BCC */
> =A0 =A0 =A0 =A0byte_count =3D get_bcc(pTargetSMB);
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0/* is the result too big for the field? */
> - =A0 =A0 =A0 if (byte_count > USHRT_MAX)
> + =A0 =A0 =A0 if (byte_count > USHRT_MAX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced BCC too large (%u)",=
 byte_count);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EPROTO;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0put_bcc(byte_count, pTargetSMB);
>
> =A0 =A0 =A0 =A0byte_count =3D be32_to_cpu(pTargetSMB->smb_buf_length)=
;
> =A0 =A0 =A0 =A0byte_count +=3D total_in_buf2;
> =A0 =A0 =A0 =A0/* don't allow buffer to overflow */
> - =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize)
> + =A0 =A0 =A0 if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "coalesced BCC exceeds buffer s=
ize (%u)", byte_count);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOBUFS;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0pTargetSMB->smb_buf_length =3D cpu_to_be32(byte_count)=
;
>
> =A0 =A0 =A0 =A0memcpy(data_area_of_target, data_area_of_buf2, total_i=
n_buf2);
> @@ -291,8 +302,10 @@ static int coalesce_t2(struct smb_hdr *psecond, =
struct smb_hdr *pTargetSMB)
> =A0 =A0 =A0 =A0if (remaining =3D=3D total_in_buf2) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "found the last secondary resp=
onse");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0; /* we are done */
> - =A0 =A0 =A0 } else /* more responses to go */
> + =A0 =A0 =A0 } else {/* more responses to go */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "waiting for more secondary res=
ponses");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> + =A0 =A0 =A0 }
> =A0}
>
> =A0static void
> --
> 1.7.7.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

what I do not understand is,

a)
Why does Windows XP send different search counts to a findfirst2 reques=
t.

b)
This bug also does not manifest against a Windows 2003 server,
Windows 2008 server and Windows 7.

c)
As per this document,
http://msdn.microsoft.com/en-us/library/cc246806(v=3Dprot.13).aspx

"<66> Section 2.2.8.1.2: The SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO
Information Level was introduced in Windows Server 2003 and is not
present in Windows 2000 Server and Windows XP."

then why does Windows XP respond to
trans2/find first2/SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO request
with an error.

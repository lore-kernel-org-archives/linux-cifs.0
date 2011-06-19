From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client] problems with signing and new crypto code
Date: Sat, 18 Jun 2011 20:53:21 -0500
Message-ID: <BANLkTim+-OGxUYCax31G=uqGJrfET8q56g@mail.gmail.com>
References: <20110617090656.35e508a5@tlielax.poochiereds.net>
	<BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ@mail.gmail.com>
	<20110617101321.23ee627e@tlielax.poochiereds.net>
	<BANLkTimnh92is9yu6fECaZyg=uEoPmMb4Q@mail.gmail.com>
	<20110617115832.035cd603@tlielax.poochiereds.net>
	<BANLkTikwfFqMDPU4wt0J_K41GZcwZGJgLw@mail.gmail.com>
	<20110618063502.06de3361@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110618063502.06de3361-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Jun 18, 2011 at 5:35 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 17 Jun 2011 12:20:08 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Jun 17, 2011 at 10:58 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>> > On Fri, 17 Jun 2011 10:40:21 -0500
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Fri, Jun 17, 2011 at 9:13 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>=
 wrote:
>> >> > On Fri, 17 Jun 2011 08:58:40 -0500
>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> On Fri, Jun 17, 2011 at 8:06 AM, Jeff Layton <jlayton@redhat.c=
om> wrote:
>> >> >> > Hi Shirish,
>> >> >> >
>> >> >> > I've been working on some backports of some upstream patch s=
eries and
>> >> >> > have run into what I think is a problem with the new crypto =
code. The
>> >> >> > problem mainly seems to manifest itself as bad signatures in=
 write
>> >> >> > calls. This causes a win2k8 server (at least) to reject the =
call with
>> >> >> > STATUS_ACCESS_DENIED and stop responding to other calls on t=
he socket.
>> >> >> >
>> >> >> > I did a bisect of sorts, and got to this patch:
>> >> >> >
>> >> >> > commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
>> >> >> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >> > Date: =A0 Tue Apr 12 09:13:44 2011 -0400
>> >> >> >
>> >> >> > =A0 =A0cifs: don't allow mmap'ed pages to be dirtied while u=
nder writeback (try #3)
>> >> >> >
>> >> >> > My original thought was that something was altering these pa=
ges while
>> >> >> > they were under writeback, but I did some instrumentation an=
d found
>> >> >> > that not to be the case. The signature is the same before an=
d after
>> >> >> > the send when this occurs. A key change in this patch is tha=
t when
>> >> >> > signing is enabled, the code started using CIFSSMBWrite2(), =
which
>> >> >> > marshals up the send buffer in an array of kvecs.
>> >> >> >
>> >> >> > That leads me to believe that the cifs_sign_smb2 codepath is=
 busted.
>> >> >> >
>> >> >> > I'll see if I can come up with a testcase, but I'm not that =
familiar
>> >> >> > with the kernel crypto code. Is this something you've seen i=
n your
>> >> >> > testing? Any immediate thoughts as to where the problem may =
be?
>> >> >> >
>> >> >> > --
>> >> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >> >
>> >> >>
>> >> >
>> >> > (fixing cc list since I goofed it earlier...)
>> >> >
>> >> >> Jeff, no I have not seen this. You think some iozone testing a=
gainst
>> >> >> a Windows server with the latest cifs code might expose this p=
roblem?
>> >> >> I will try both Windows 2003 server and Windows 2008 server.
>> >> >>
>> >> >
>> >> > I'm using fsstress against win2k8, and it seems to fail on the =
initial
>> >> > write calls.
>> >> >
>> >> >> cifs_sign_smb and cifs_sign_smb2 do the same exact thing excep=
t that
>> >> >> the messages that gets used in signature calculation are diffe=
rent in these
>> >> >> routines.
>> >> >>
>> >> >> My initial thought was/is the same as yours, the content of me=
ssage
>> >> >> used in calculating signature is different at the server and c=
lient resulting
>> >> >> in different signatures hence dropped smb connection by the se=
rver.
>> >> >> But it is possible cifs_sign_smb2 and/or cifs_calc_signature2 =
have a bug!
>> >> >>
>> >> >
>> >> > I did a test where I recalculated the signature after calling s=
mb_sendv
>> >> > and then compared it to the original signature and they matched=
, but
>> >> > the server rejected it. I'm still trying to nail down the probl=
em, so
>> >> > the bug could be anywhere really.
>> >> >
>> >> > --
>> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >
>> >>
>> >> Strange, iozone just hangs when I issue a command against a file =
on
>> >> a Windows 2003 server
>> >>
>> >> =A0 =A0 =A0 =A0 Run began: Fri Jun 17 10:34:13 2011
>> >>
>> >> =A0 =A0 =A0 =A0 Auto Mode
>> >> =A0 =A0 =A0 =A0 Command line used:
>> >> /usr/src/iozone/iozone3_323/src/current/iozone -a -f /mnt/smb_a/n=
file1
>> >> =A0 =A0 =A0 =A0 Output is in Kbytes/sec
>> >> =A0 =A0 =A0 =A0 Time Resolution =3D 0.000001 seconds.
>> >> =A0 =A0 =A0 =A0 Processor cache size set to 1024 Kbytes.
>> >> =A0 =A0 =A0 =A0 Processor cache line size set to 32 bytes.
>> >> =A0 =A0 =A0 =A0 File stride size set to 17 * record size.
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 random
>> >> random =A0 =A0bkwd =A0 record =A0 stride
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 KB =A0reclen =A0 write rewrite =A0 =A0=
read =A0 =A0reread =A0 =A0read
>> >> write =A0 =A0read =A0rewrite =A0 =A0 read =A0 fwrite frewrite =A0=
 fread =A0freread
>> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 64 =A0 =A0 =A0 4
>> >>
>> >> The last packets 9n wireshark trace on the server is
>> >>
>> >> write andx response: status access denied
>> >> locking andx request fid: xyz
>> >>
>> >> and then cifs client reconnects.
>> >>
>> >> (may be this is the dropping/locking smb connection because signa=
ture
>> >> in the write andx request is invalid).
>> >
>> > Right, that's basically what I see. win2k8 just replies with statu=
s
>> > access denied. I suspect that that's because the signature is inco=
rrect.
>> >
>> > I've noticed too that it only happens with larger writes. Right no=
w,
>> > I'm trying to figure out the size where it breaks.
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>>
>> Jeff, no problems with the dd commands
>>
>> # ls -l /mnt/smb_a/largefle
>> -rw-r--r-- 1 root root 16641 Jun 17 12:22 /mnt/smb_a/largefile
>>
>> =A0# dd if=3D/tmp/largefile of/mnt/smb_a/largefile bs=3D16641 count=3D=
100
>> 100+0 records in
>> 100+0 records out
>> 1664100 bytes (1.7 MB) copied, 0.0350296 s, 47.5 MB/s
>>
>> =A0# ls -l /mnt/smb_a/largefle
>> -rw-r--r-- 1 root root 1664100 Jun 17 12:22 /mnt/smb_a/largefile
>>
>> =A0# dd if=3D/tmp/largefile of=3D/mnt/smb_a/largefile bs=3D16641 cou=
nt=3D1000
>> 1000+0 records in
>> 1000+0 records out
>> 16641000 bytes (17 MB) copied, 0.241208 s, 69.0 MB/s
>>
>> =A0# ls -l /mnt/smb_a/largefile
>> -rw-r--r-- 1 root root 16641000 Jun 17 12:23 /mnt/smb_a/largefile
>
> Interesting, I've been able to consistently get this to fail with:
>
> =A0 =A0# dd if=3D/dev/urandom of=3D/mnt/win2k8/file bs=3D16641 count=3D=
1
>
> ...but if I write 16640 bytes, it works.
>
> In any case, I've opened a bug at samba.org:
>
> =A0 =A0https://bugzilla.samba.org/show_bug.cgi?id=3D8245
>
> ...so we can track this problem. At this point, I'm still trying to
> nail down what the problem actually is.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Could it be that Windows server sets a limit of max byte size
when signing is used?
I copied a 70,000 bytes file from Windows 2003 server (client) to
a Windows 2008 server (server) with signing enabled and
max bytes written are 16580 bytes.

Perhaps Samba server has no such limitation and so signature
at the client and server match for any write size.

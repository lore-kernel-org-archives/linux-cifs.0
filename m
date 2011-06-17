From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [linux-cifs-client] problems with signing and new crypto code
Date: Fri, 17 Jun 2011 10:40:21 -0500
Message-ID: <BANLkTimnh92is9yu6fECaZyg=uEoPmMb4Q@mail.gmail.com>
References: <20110617090656.35e508a5@tlielax.poochiereds.net>
	<BANLkTikmKEHSKFNczSwNUvSeFZSubiNyoQ@mail.gmail.com>
	<20110617101321.23ee627e@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110617101321.23ee627e-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 17, 2011 at 9:13 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 17 Jun 2011 08:58:40 -0500
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Jun 17, 2011 at 8:06 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > Hi Shirish,
>> >
>> > I've been working on some backports of some upstream patch series =
and
>> > have run into what I think is a problem with the new crypto code. =
The
>> > problem mainly seems to manifest itself as bad signatures in write
>> > calls. This causes a win2k8 server (at least) to reject the call w=
ith
>> > STATUS_ACCESS_DENIED and stop responding to other calls on the soc=
ket.
>> >
>> > I did a bisect of sorts, and got to this patch:
>> >
>> > commit ca83ce3d5b9ad321ee24f5870a77f0b21ac5a5de
>> > Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > Date: =A0 Tue Apr 12 09:13:44 2011 -0400
>> >
>> > =A0 =A0cifs: don't allow mmap'ed pages to be dirtied while under w=
riteback (try #3)
>> >
>> > My original thought was that something was altering these pages wh=
ile
>> > they were under writeback, but I did some instrumentation and foun=
d
>> > that not to be the case. The signature is the same before and afte=
r
>> > the send when this occurs. A key change in this patch is that when
>> > signing is enabled, the code started using CIFSSMBWrite2(), which
>> > marshals up the send buffer in an array of kvecs.
>> >
>> > That leads me to believe that the cifs_sign_smb2 codepath is buste=
d.
>> >
>> > I'll see if I can come up with a testcase, but I'm not that famili=
ar
>> > with the kernel crypto code. Is this something you've seen in your
>> > testing? Any immediate thoughts as to where the problem may be?
>> >
>> > --
>> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >
>>
>
> (fixing cc list since I goofed it earlier...)
>
>> Jeff, no I have not seen this. You think some iozone testing against
>> a Windows server with the latest cifs code might expose this problem=
?
>> I will try both Windows 2003 server and Windows 2008 server.
>>
>
> I'm using fsstress against win2k8, and it seems to fail on the initia=
l
> write calls.
>
>> cifs_sign_smb and cifs_sign_smb2 do the same exact thing except that
>> the messages that gets used in signature calculation are different i=
n these
>> routines.
>>
>> My initial thought was/is the same as yours, the content of message
>> used in calculating signature is different at the server and client =
resulting
>> in different signatures hence dropped smb connection by the server.
>> But it is possible cifs_sign_smb2 and/or cifs_calc_signature2 have a=
 bug!
>>
>
> I did a test where I recalculated the signature after calling smb_sen=
dv
> and then compared it to the original signature and they matched, but
> the server rejected it. I'm still trying to nail down the problem, so
> the bug could be anywhere really.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Strange, iozone just hangs when I issue a command against a file on
a Windows 2003 server

        Run began: Fri Jun 17 10:34:13 2011

        Auto Mode
        Command line used:
/usr/src/iozone/iozone3_323/src/current/iozone -a -f /mnt/smb_a/nfile1
        Output is in Kbytes/sec
        Time Resolution =3D 0.000001 seconds.
        Processor cache size set to 1024 Kbytes.
        Processor cache line size set to 32 bytes.
        File stride size set to 17 * record size.
                                                            random
random    bkwd   record   stride
              KB  reclen   write rewrite    read    reread    read
write    read  rewrite     read   fwrite frewrite   fread  freread
              64       4

The last packets 9n wireshark trace on the server is

write andx response: status access denied
locking andx request fid: xyz

and then cifs client reconnects.

(may be this is the dropping/locking smb connection because signature
in the write andx request is invalid).

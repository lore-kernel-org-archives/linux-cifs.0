From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS is slooow, gvfs is fast
Date: Fri, 29 Oct 2010 19:54:24 -0500
Message-ID: <AANLkTin-tXH-Q5wDGs9ZCQGdEZkm7w=AEdegDjV0mn6S@mail.gmail.com>
References: <20101022013544.0fdab0e0@werewolf.home>
	<4CC16B1E.4060709@suse.de>
	<20101023004636.1acdd81c@werewolf.home>
	<20101024013038.057442c0@werewolf.home>
	<4CC55894.5040509@suse.de>
	<20101030003357.029b4e02@werewolf.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Linux CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?ISO-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon-sh/6fXdz2Rs@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101030003357.029b4e02-BIo4oXGMtDgJmsy6czSMtA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 29, 2010 at 5:33 PM, J.A. Magall=C3=B3n <jamagallon-sh/6fXdz2Rs@public.gmane.org=
> wrote:
> On Mon, 25 Oct 2010 15:44:44 +0530, Suresh Jayaraman <sjayaraman@suse=
=2Ede> wrote:
>
>> On 10/24/2010 05:00 AM, J.A. Magall=C3=B3n wrote:
>> > On Sat, 23 Oct 2010 00:46:36 +0200, "J.A. Magall=EF=BF=BDn" <jamag=
allon-sh/6fXdz2Rs@public.gmane.org> wrote:
>> >
>> >>
>> >> If you mean hardware network path (cabling, router), yes.
>> >> For file paths, CIFS fs is under /net/htpc/media, and gvfs uses a=
 mount
>> >> point on '~/.gvfs/media on htpc'.
>> >>
>> >> And here comes the weird part. To rule out the desktop environmen=
t factor,
>> >> I tried a dd in both paths. On /net, I get 16.6 MB/s, and on
>> >> ~/.gvfs/xxx, I just get 5.5 MB/s. I really don't understand anyth=
ing...
>> >> things get reversed depending if you use a gui or commandline.
>> >>update
>> >> Weird, really weird...
>> >>
>> >
>> > Well, to sort things out, I did some more tests (this does not mea=
n things
>> > get any closer to be clear for me at least...).
>> >
>> > Can anybody tell me whats going here...??
>> > It looks just like gui tools behave just in reverse of cli, and th=
at a plain
>> > smbclient is faster that cifs. I'm really confused...
>> >
>>
>> Could you try mounting from commandline with something like
>> =C2=A0 `mount -t cifs //server/share /mnt/point -o user=3Duser1`
>> (commenting out the fstab entry) and try copying the file?
>>
>>
>
> Same results, cli copy takes about 7.5 seconds (thats around 40MB/s),=
 and
> gui copy says it runs at 7.8 MB/s.
> This could be the normal behaviour I could expect, gui is slower as i=
t has to
> update progress bars, move flying sheets, or even does a sync from ti=
me to
> time.
>
> The misbehaviour I see is the other way aroung, FUSE/GVFS is fast fro=
m GUI
> and slow from CLI. And, the best, why are there any difference ???

The obvious thing to check is actual cifs write sizes on the network
(with wireshark e.g.)
and how much parallelism.   We know cifs kernel client will send 56K
writes, but only one at
a time for any particular file.  (thanks to Pavel the smb2 kernel
client will send more
in parallel and get about two to three times better performance).   cif=
s kernel
client can send less than 56K if the dirty pages are scattered of cours=
e
(writepages won't be called with contiguous dirty pages) and cifs clien=
t can
send more than 56K when mounting with "directio" cifs mount option
but only if the application tries to write more than 56K for each user =
space
write operation (mounting with directio might be a nice comparison poin=
t).


--=20
Thanks,

Steve

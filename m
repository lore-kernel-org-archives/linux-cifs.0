From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: VS: DM800 Linux client use CIFS/SMB to connect to Windows 2008 R2 Share
Date: Sun, 29 Aug 2010 20:16:05 -0500
Message-ID: <AANLkTinh4r8pdPdvyTT__mYRsz9EDdN6DKF70TnNTCqP@mail.gmail.com>
References: <B1837CC6F2D935468F8A9E98BA0E8BCC0109D5D0@MAILMAN.pconline.no>
	<AANLkTimQ-ZGMUO=vcYNeVeHK5eS1hDv27yKMSZ=bXvgY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?ISO-8859-1?Q?Rolf_G=2E_=D8kland?= <Rolf-xckQ04E5ShYXWF+eFR7m5Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimQ-ZGMUO=vcYNeVeHK5eS1hDv27yKMSZ=bXvgY-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You can enable more detailed error messages by enabling cifs debug
messages (before the mount) by "echo 7 > /proc/fs/cifs/cifsFYI"

posix error 13 is the same as "access denied"

One possible reason is that the domain of the server is not specified
and that the default domain for that user differs from what you think
(add something like "domain=3Dyourserversdomain")

On Sun, Aug 29, 2010 at 4:14 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Sun, Aug 29, 2010 at 3:52 PM, Rolf G. =D8kland <Rolf-xckQ04E5ShYXWF+eFR7m5Q@public.gmane.org> =
wrote:
>> Hi
>>
>> I got an annoying problem, when I'm trying to mount my Dreambox DM80=
0 (Linux client) to a windows server 2008 R2 share I get access denied =
for some reason.
>> This have been working like a charm on my old Windows 2003 Server, b=
ut not a chance in h. to my new 2008R2 server.
>> I'm using this script on my DM800:=A0 "mount -t cifs //192.168.0.5/x=
db.tv-serier -o udp,rw,nolock,wsize=3D8192,rsize=3D8192,user=3Dmyuser,p=
ass=3Dmypass /media/net/tv/"
>>
>> I also got a QNAP NMP-1000 that does mount to the same share on the =
windows 2008R2 without any issues what so ever.
>
> Various reasons reasons for access denied are possible. =A0 Looking a=
t
> the log =A0(dmesg) might give you more information.
>
> Note that your mount options are a little strange (udp is meaningless
> for cifs - cifs uses reliable connections via tcp only, and shrinking
> rsize and wsize to 8192 (they default to 16K and 56K respectively for
> Linux cifs.ko) usually degrades performance. =A0In addition the mount
> target (/media/net/tv) is harder to read when the mount options are
> put in the middle between //server/share and the mount target.
>
> It is possible that your Windows 2008R2 share defaulted to ntlmv2, an=
d
> required packed signing (while your Windows 2003 was not configured
> that way) - and that you have hit an old bug (it is hard to tell what
> cifs version and kernel version you are running on the two systems).
>
> --
> Thanks,
>
> Steve
>



--=20
Thanks,

Steve

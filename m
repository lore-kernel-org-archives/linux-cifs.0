From: "Roger Brooks" <r.s.brooks-EkmVulN54Sk@public.gmane.org>
Subject: RE: Unable to mount using credentials file
Date: Mon, 3 Nov 2014 08:34:41 +0100
Message-ID: <000c01cff738$a265e610$e731b230$@ieee.org>
References: <loom.20141101T124621-513@post.gmane.org> <CANzfOVLmYUWPoTD8zF7oDFJ-XR57sPTBH=yJQ4mzPd2zgapFog@mail.gmail.com> <00bc01cff5ef$e5361770$afa24650$@ieee.org> <CAH2r5mupp47fyNw7t_EEvdQSzk-oNPNm8C9vfdNSvbMqr6GcPA@mail.gmail.com> <000001cff685$0d849630$288dc290$@ieee.org> <CAH2r5mur=q=nJhpYWRRK_6CQgxYF067pxpiCtnHWQ3y9NiXX5A@mail.gmail.com> <001501cff6bd$292e5d70$7b8b1850$@ieee.org> <5456C316.90308@kukkukk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5456C316.90308-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Content-Language: de-ch
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Sorry, Gunter, I don't have strace:

-ash: strace: not found

mount.cifs is located at:

/usr/syno/bin/mount.cifs

I suspect that the installed version of mount (from BusyBox 1.16) is to=
o old to correctly handle "-o credentials=3D<file>".
I will try installing a newer version (BusyBox 1.21) and report back la=
ter.

However, this no longer has a high priority for me, as I can live with =
calling mount.cifs directly.

@Steve,
mount.cifs is only v5.5 in my installation, but since calling it direct=
ly works fine, I presume that the problem lies with the BusyBox version=
 of mount and not with mount.cifs.
Since mount works with "-o username=3D<user>,password=3D<password>", I =
presume that it is finding mount.cifs, but is not passing "-o credentia=
ls=3D<file>" correctly.

Thanks for all of your help!

-----Original Message-----
=46rom: G=C3=BCnter Kukkukk [mailto:linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org]=20
Sent: Monday, November 3, 2014 12:50 AM
To: Roger Brooks; linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Unable to mount using credentials file

Am 02.11.2014 um 17:50 schrieb Roger Brooks:
> Here is the output from mount -t cifs --verbose -o ... for the failin=
g case:
> mount: mounting //<IP address>/<share> on /mnt/<mountpoint>/ failed:=20
> Invalid argument There is still no output when I add --verbose to the=
 successful case.
> There is no verbose option listed for mount --help.
> Thanks for your help.

you can also try strace (hopefully available) like:

strace -f mount -t cifs --verbose //server/share /mnt -o .....

look, whether mount.cifs is found or not.

Btw - where is your mount.cifs installed (absolute path)?

Cheers, G=C3=BCnter

>=20
> -----Original Message-----
> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Sunday, November 2, 2014 5:30 PM
> To: Roger Brooks
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Unable to mount using credentials file
>=20
> mount with call mount.cifs (if it is present in /sbin) when you speci=
fy "mount -t cifs"
>=20
> You can specify --verbose before the -o (see
> http://linux.die.net/man/8/mount.cifs) and it will show the mount=20
> options being passed in to the kernel syscall so it would be useful=20
> for debugging to compare the exact parameters being passed in to the=20
> kernel in the working vs. failing case by specifying --verbose before=
=20
> the -o
>=20
> On Sun, Nov 2, 2014 at 4:09 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> wr=
ote:
>> P.S. To answer my own question below, experimentation shows that mou=
nt and umount still fulfill their normal functions for volumes mounted =
directly with mount.cifs.
>> So, much as it irritates me not to know why mount -o credentials doe=
sn't work, I can live with using mount.cifs instead.
>> Thanks to all who responded!
>>
>> Thanks for the tips, Steve!
>>
>> My version of mount:
>> BusyBox v1.16.1 (2014-10-10 08:37:09 CST) multi-call binary.
>> does not appear to have a verbose option. At least:
>> mount --help
>> does not list any such option, and mount does not return any informa=
tion to the console when it succeeds, regardless of whether or not I sp=
ecify -v.
>>
>> The failure message is also unchanged with the -v option:
>> mount: mounting //<IP address>/<share> on /mnt/<mountpoint> failed:=20
>> Invalid argument
>>
>> Also, I have read that mount maintains /etc/mtab.
>> Does that mean that mount will not list volumes which I mounted dire=
ctly with mount.cifs, and that I cannot use umount to unmount volumes m=
ounted directly with mount.cifs?
>>
>> -----Original Message-----
>> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Saturday, November 1, 2014 5:24 PM
>> To: Roger Brooks
>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: Unable to mount using credentials file
>>
>> using /sbin/mount.cifs directly should be fine.   When you mount wit=
h
>> verbose mount option does it show any useful differences between the=
=20
>> two cases (working vs. failing)
>>
>> On Sat, Nov 1, 2014 at 11:21 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> =
wrote:
>>> P.S.
>>> There was a non-printing character in the directory name under /roo=
t.
>>> After correcting that, mount.cifs -o credentials=3D<filename> works=
=2E
>>> However, mount -t cifs -o credentials=3D<filename> still returns "I=
nvalid argument".
>>> Can I just use mount.cifs directly, or does mount perform some addi=
tional needed housekeeping?
>>> If mount is needed, how can I get -o credentials to work?
>>> TIA for any tips!
>>>
>>> Hi Benjamin,
>>>
>>> Thanks for responding.
>>>
>>> The credentials file is a simple text file created with vi containi=
ng the lines:
>>>>>
>>> username=3D<user>
>>> password=3D<password>
>>> <<
>>> I have tried this both with and without trailing newline at the end=
 of the second line.
>>>
>>> I have also tried the variant:
>>>>>
>>> username=3D<user>
>>> password=3D<password>
>>> domain=3D<domain>
>>> <<
>>>
>>> The results are always the same.
>>> If there is a problem with the *content* of the file, why would the=
 error message say that the file could not be opened?
>>>
>>> Thanks for your help!
>>> Best Regards,
>>> Roger
>>>
>>> From: Benjamin Bellec [mailto:b.bellec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>>> Sent: Saturday, November 1, 2014 1:34 PM
>>> To: Roger Brooks
>>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: Re: Unable to mount using credentials file
>>>
>>> Hi,
>>> Does your credential file is correctly formatted ?
>>>
>>> 2014-11-01 13:03 GMT+01:00 Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>:
>>> I am attempting to mount Windows volumes on a Synology DS (running =
DSM 5.0, a Debian-based distribution).
>>> Command lines of the form:
>>> mount -t cifs -o username=3D<user>,password=3D<pass> //<IP address>=
/share/ /mnt/<mountpoint> succeed.
>>> However, command lines of the form:
>>> mount -t cifs -o credentials=3D<filename> //<IP address>/share/ /mn=
t/<mountpoint> fail with the error "Invalid argument".
>>> For diagnostic purposes, I have attempted to mount the volumes dire=
ctly using mount.cifs (v5.5).
>>> Once again, commands of the form:
>>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o=20
>>> username=3D<user>,password=3D<password>
>>> succeed.
>>> However, commands of the form:
>>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=
=3D<file> fail with the error message:
>>> error -1 (Unknown error 4294967295) opening credential file <file>=20
>>> This is the case regardless of the location of the file (see=20
>>> http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file=
-
>>> t
>>> d
>>> 2518214.html) or its privileges.  The error persists, even when the=
=20
>>> command is executed from a root session and the credentials file ha=
s permissions 0777 and is in a subdirectory of /root.
>>> How can I get mount to work using a credentials file?
>>>
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordom=
o=20
>>> info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s"
>>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordom=
o=20
>>> info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
"=20
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=
=20
>> info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20
> --
> Thanks,
>=20
> Steve
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
=20
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=20
> info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20

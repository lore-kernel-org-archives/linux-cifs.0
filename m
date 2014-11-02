From: =?UTF-8?B?R8O8bnRlciBLdWtrdWtr?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: Re: Unable to mount using credentials file
Date: Sun, 02 Nov 2014 16:59:15 +0100
Message-ID: <545654D3.6060304@kukkukk.com>
References: <loom.20141101T124621-513@post.gmane.org> <CANzfOVLmYUWPoTD8zF7oDFJ-XR57sPTBH=yJQ4mzPd2zgapFog@mail.gmail.com> <00bc01cff5ef$e5361770$afa24650$@ieee.org> <CAH2r5mupp47fyNw7t_EEvdQSzk-oNPNm8C9vfdNSvbMqr6GcPA@mail.gmail.com> <000001cff685$0d849630$288dc290$@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000001cff685$0d849630$288dc290$@ieee.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Am 02.11.2014 um 11:09 schrieb Roger Brooks:
> P.S. To answer my own question below, experimentation shows that moun=
t and umount still fulfill their normal functions for volumes mounted d=
irectly with mount.cifs.
> So, much as it irritates me not to know why mount -o credentials does=
n't work, I can live with using mount.cifs instead.
> Thanks to all who responded!
>=20
> Thanks for the tips, Steve!
>=20
> My version of mount:
> BusyBox v1.16.1 (2014-10-10 08:37:09 CST) multi-call binary.
> does not appear to have a verbose option. At least:
> mount --help
> does not list any such option, and mount does not return any informat=
ion to the console when it succeeds, regardless of whether or not I spe=
cify -v.
>=20
> The failure message is also unchanged with the -v option:
> mount: mounting //<IP address>/<share> on /mnt/<mountpoint> failed: I=
nvalid argument
>=20
> Also, I have read that mount maintains /etc/mtab.
> Does that mean that mount will not list volumes which I mounted direc=
tly with mount.cifs, and that I cannot use umount to unmount volumes mo=
unted directly with mount.cifs?
>=20

Hi Roger,

to be able to use very different mount options, the "mount" command
looks for installed *mount helpers* and executes them:
When you e.g. specify
   mount -t nfs ....   it looks for a mount helper "mount.nfs" in $PATH
   mount -t cifs ....  it looks for a mount helper "mount.cifs" in $PAT=
H

Here with opensuse 13.1:
ls -al /sbin/mount.*
-rwxr-xr-x 1 root root  39736 Oct 11  2013 /sbin/mount.cifs
-rwxr-xr-x 1 root root    556 Sep 28  2013 /sbin/mount.crypt
lrwxrwxrwx 1 root root     11 Dec  3  2013 /sbin/mount.crypt_LUKS -> mo=
unt.crypt
lrwxrwxrwx 1 root root     11 Dec  3  2013 /sbin/mount.crypto_LUKS -> m=
ount.crypt
lrwxrwxrwx 1 root root     20 Nov 20  2013 /sbin/mount.fuse -> /usr/sbi=
n/mount.fuse
lrwxrwxrwx 1 root root     19 Nov  6  2013 /sbin/mount.lowntfs-3g -> /u=
sr/bin/lowntfs-3g
-rwsr-xr-x 1 root root 114856 May  6 11:06 /sbin/mount.nfs
lrwxrwxrwx 1 root root      9 May 18 05:57 /sbin/mount.nfs4 -> mount.nf=
s
lrwxrwxrwx 1 root root     28 Nov  6  2013 /sbin/mount.ntfs -> /etc/alt=
ernatives/mount.ntfs
lrwxrwxrwx 1 root root     16 Nov  6  2013 /sbin/mount.ntfs-3g -> /usr/=
bin/ntfs-3g
-r-xr-xr-x 1 root root  55264 May 30 04:00 /sbin/mount.vmhgfs

When mounting a cifs share, _only_ the mount helper "mount.cifs"
is able to open and parse the credentials file!
So mount must be able to find that helper inside $PATH.

=2E..

Whether from /etc/fstab or mounted manually with mount.cifs, the "mount=
" command
lists _all_ currently active mounts and can also be used to de-activate=
 mounts.

Cheers, G=C3=BCnter




> -----Original Message-----
> From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Saturday, November 1, 2014 5:24 PM
> To: Roger Brooks
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Unable to mount using credentials file
>=20
> using /sbin/mount.cifs directly should be fine.   When you mount with
> verbose mount option does it show any useful differences between the =
two cases (working vs. failing)
>=20
> On Sat, Nov 1, 2014 at 11:21 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> w=
rote:
>> P.S.
>> There was a non-printing character in the directory name under /root=
=2E
>> After correcting that, mount.cifs -o credentials=3D<filename> works.
>> However, mount -t cifs -o credentials=3D<filename> still returns "In=
valid argument".
>> Can I just use mount.cifs directly, or does mount perform some addit=
ional needed housekeeping?
>> If mount is needed, how can I get -o credentials to work?
>> TIA for any tips!
>>
>> Hi Benjamin,
>>
>> Thanks for responding.
>>
>> The credentials file is a simple text file created with vi containin=
g the lines:
>>>>
>> username=3D<user>
>> password=3D<password>
>> <<
>> I have tried this both with and without trailing newline at the end =
of the second line.
>>
>> I have also tried the variant:
>>>>
>> username=3D<user>
>> password=3D<password>
>> domain=3D<domain>
>> <<
>>
>> The results are always the same.
>> If there is a problem with the *content* of the file, why would the =
error message say that the file could not be opened?
>>
>> Thanks for your help!
>> Best Regards,
>> Roger
>>
>> From: Benjamin Bellec [mailto:b.bellec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
>> Sent: Saturday, November 1, 2014 1:34 PM
>> To: Roger Brooks
>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: Unable to mount using credentials file
>>
>> Hi,
>> Does your credential file is correctly formatted ?
>>
>> 2014-11-01 13:03 GMT+01:00 Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>:
>> I am attempting to mount Windows volumes on a Synology DS (running D=
SM 5.0, a Debian-based distribution).
>> Command lines of the form:
>> mount -t cifs -o username=3D<user>,password=3D<pass> //<IP address>/=
share/ /mnt/<mountpoint> succeed.
>> However, command lines of the form:
>> mount -t cifs -o credentials=3D<filename> //<IP address>/share/ /mnt=
/<mountpoint> fail with the error "Invalid argument".
>> For diagnostic purposes, I have attempted to mount the volumes direc=
tly using mount.cifs (v5.5).
>> Once again, commands of the form:
>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o=20
>> username=3D<user>,password=3D<password>
>> succeed.
>> However, commands of the form:
>> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=3D=
<file> fail with the error message:
>> error -1 (Unknown error 4294967295) opening credential file <file>=20
>> This is the case regardless of the location of the file (see=20
>> http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file-=
td
>> 2518214.html) or its privileges.  The error persists, even when the=20
>> command is executed from a root session and the credentials file has=
 permissions 0777 and is in a subdirectory of /root.
>> How can I get mount to work using a credentials file?
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs=
"=20
>> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo=
=20
>> info at  http://vger.kernel.org/majordomo-info.html
>>
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
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20

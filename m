From: "Roger Brooks" <r.s.brooks-EkmVulN54Sk@public.gmane.org>
Subject: RE: Unable to mount using credentials file
Date: Sun, 2 Nov 2014 11:09:12 +0100
Message-ID: <000001cff685$0d849630$288dc290$@ieee.org>
References: <loom.20141101T124621-513@post.gmane.org> <CANzfOVLmYUWPoTD8zF7oDFJ-XR57sPTBH=yJQ4mzPd2zgapFog@mail.gmail.com> <00bc01cff5ef$e5361770$afa24650$@ieee.org> <CAH2r5mupp47fyNw7t_EEvdQSzk-oNPNm8C9vfdNSvbMqr6GcPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: de-ch
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

P.S. To answer my own question below, experimentation shows that mount and umount still fulfill their normal functions for volumes mounted directly with mount.cifs.
So, much as it irritates me not to know why mount -o credentials doesn't work, I can live with using mount.cifs instead.
Thanks to all who responded!

Thanks for the tips, Steve!

My version of mount:
BusyBox v1.16.1 (2014-10-10 08:37:09 CST) multi-call binary.
does not appear to have a verbose option. At least:
mount --help
does not list any such option, and mount does not return any information to the console when it succeeds, regardless of whether or not I specify -v.

The failure message is also unchanged with the -v option:
mount: mounting //<IP address>/<share> on /mnt/<mountpoint> failed: Invalid argument

Also, I have read that mount maintains /etc/mtab.
Does that mean that mount will not list volumes which I mounted directly with mount.cifs, and that I cannot use umount to unmount volumes mounted directly with mount.cifs?

-----Original Message-----
From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Saturday, November 1, 2014 5:24 PM
To: Roger Brooks
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Unable to mount using credentials file

using /sbin/mount.cifs directly should be fine.   When you mount with
verbose mount option does it show any useful differences between the two cases (working vs. failing)

On Sat, Nov 1, 2014 at 11:21 AM, Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org> wrote:
> P.S.
> There was a non-printing character in the directory name under /root.
> After correcting that, mount.cifs -o credentials=<filename> works.
> However, mount -t cifs -o credentials=<filename> still returns "Invalid argument".
> Can I just use mount.cifs directly, or does mount perform some additional needed housekeeping?
> If mount is needed, how can I get -o credentials to work?
> TIA for any tips!
>
> Hi Benjamin,
>
> Thanks for responding.
>
> The credentials file is a simple text file created with vi containing the lines:
>>>
> username=<user>
> password=<password>
> <<
> I have tried this both with and without trailing newline at the end of the second line.
>
> I have also tried the variant:
>>>
> username=<user>
> password=<password>
> domain=<domain>
> <<
>
> The results are always the same.
> If there is a problem with the *content* of the file, why would the error message say that the file could not be opened?
>
> Thanks for your help!
> Best Regards,
> Roger
>
> From: Benjamin Bellec [mailto:b.bellec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
> Sent: Saturday, November 1, 2014 1:34 PM
> To: Roger Brooks
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Unable to mount using credentials file
>
> Hi,
> Does your credential file is correctly formatted ?
>
> 2014-11-01 13:03 GMT+01:00 Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>:
> I am attempting to mount Windows volumes on a Synology DS (running DSM 5.0, a Debian-based distribution).
> Command lines of the form:
> mount -t cifs -o username=<user>,password=<pass> //<IP address>/share/ /mnt/<mountpoint> succeed.
> However, command lines of the form:
> mount -t cifs -o credentials=<filename> //<IP address>/share/ /mnt/<mountpoint> fail with the error "Invalid argument".
> For diagnostic purposes, I have attempted to mount the volumes directly using mount.cifs (v5.5).
> Once again, commands of the form:
> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o 
> username=<user>,password=<password>
> succeed.
> However, commands of the form:
> mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=<file> fail with the error message:
> error -1 (Unknown error 4294967295) opening credential file <file> 
> This is the case regardless of the location of the file (see 
> http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file-td
> 2518214.html) or its privileges.  The error persists, even when the 
> command is executed from a root session and the credentials file has permissions 0777 and is in a subdirectory of /root.
> How can I get mount to work using a credentials file?
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve

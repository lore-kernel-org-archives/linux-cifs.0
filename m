From: "Roger Brooks" <r.s.brooks-EkmVulN54Sk@public.gmane.org>
Subject: RE: Unable to mount using credentials file
Date: Sat, 1 Nov 2014 17:21:29 +0100
Message-ID: <00bc01cff5ef$e5361770$afa24650$@ieee.org>
References: <loom.20141101T124621-513@post.gmane.org> <CANzfOVLmYUWPoTD8zF7oDFJ-XR57sPTBH=yJQ4mzPd2zgapFog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: de-ch
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

P.S.
There was a non-printing character in the directory name under /root.
After correcting that, mount.cifs -o credentials=<filename> works.
However, mount -t cifs -o credentials=<filename> still returns "Invalid argument".
Can I just use mount.cifs directly, or does mount perform some additional needed housekeeping?
If mount is needed, how can I get -o credentials to work?
TIA for any tips!

Hi Benjamin,

Thanks for responding.

The credentials file is a simple text file created with vi containing the lines:
>>
username=<user>
password=<password>
<<
I have tried this both with and without trailing newline at the end of the second line.

I have also tried the variant:
>>
username=<user>
password=<password>
domain=<domain>
<<

The results are always the same.
If there is a problem with the *content* of the file, why would the error message say that the file could not be opened?

Thanks for your help!
Best Regards,
Roger

From: Benjamin Bellec [mailto:b.bellec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org]
Sent: Saturday, November 1, 2014 1:34 PM
To: Roger Brooks
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: Unable to mount using credentials file

Hi,
Does your credential file is correctly formatted ?

2014-11-01 13:03 GMT+01:00 Roger Brooks <r.s.brooks-EkmVulN54Sk@public.gmane.org>:
I am attempting to mount Windows volumes on a Synology DS (running DSM 5.0, a Debian-based distribution).
Command lines of the form:
mount -t cifs -o username=<user>,password=<pass> //<IP address>/share/ /mnt/<mountpoint> succeed.
However, command lines of the form:
mount -t cifs -o credentials=<filename> //<IP address>/share/ /mnt/<mountpoint> fail with the error "Invalid argument".
For diagnostic purposes, I have attempted to mount the volumes directly using mount.cifs (v5.5).
Once again, commands of the form:
mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o username=<user>,password=<password>
succeed.
However, commands of the form:
mount.cifs //<IP address>/<share> /mnt/<mountpoint>/ -o credentials=<file> fail with the error message:
error -1 (Unknown error 4294967295) opening credential file <file> This is the case regardless of the location of the file (see
http://samba.2283325.n4.nabble.com/Error-s-opening-credentials-file-td2518214.html)
or its privileges.  The error persists, even when the command is executed from a root session and the credentials file has permissions 0777 and is in a subdirectory of /root.
How can I get mount to work using a credentials file?



--
To unsubscribe from this list: send the line "unsubscribe linux-cifs" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: CIFS: Rename bug on servers not supporting inode numbers
Date: Thu, 3 Nov 2011 15:20:17 +0000
Message-ID: <9A609E6D-DF91-4AF9-855A-6D28E9B95D15@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Unix Support <unix-support-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Our CIFS server problems seem to have no end=85  The Novell CIFS server=
 does not support server inode numbers (when I try the mount option I g=
et the message it is being turned off as server does not support it) an=
d thus each inode gets a different number each time it is accessed and =
it gets a different number again for each readdir call.

The fun happens with rename() when the rename source and target only di=
ffer in case, e.g.

	touch foo
	mv foo Foo

The result?  Because of the difference in inode numbers, the request ge=
ts through to the CIFS module which promptly does:

	cifs_unlink(target_dir, target_dentry)
	rc =3D cifs_do_rename(=85)

And because the cifs_unlink() just removed the source of the rename (as=
 it is the same as the target), "rc" comes back as -ENOENT.

And indeed the file is gone so we just lost the user's file for ever.  =
)-:

We are tossing around ideas how to fix this but we would be interested =
in your input as to what you think the fix should be.

In any case this probably should be fixed in the standard kernel CIFS m=
odule, too, and not just for us locally as this presumably affects anyo=
ne who is using the CIFS module against case-insensitive, non-server-in=
ode-number-supporting CIFS servers...

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

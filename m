From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: CIFS  kernel module bug
Date: Fri, 30 Sep 2011 14:58:58 +0100
Message-ID: <A904EFBF-CBC1-4842-9E50-2A556103B8AA@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v1244.3)
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	PWF Linux <pwf-linux-IE+S/cj2AuA2EctHIo1CcQ@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Looking at the current kernel (in Linus' repository on github) there is=
 a silly logic bug in the cifs module in fs/cifs/cifsfs.c::cifs_llseek(=
) there is this bit of code:

	/*
	 * origin =3D=3D SEEK_END || SEEK_DATA || SEEK_HOLE =3D> we must reval=
idate
	 * the cached file length
	 */
	if (origin !=3D SEEK_SET || origin !=3D SEEK_CUR) {

The logical or should be a logical and, i.e. this should be:

	if (origin !=3D SEEK_SET && origin !=3D SEEK_CUR) {

As the code is at present that line is ALWAYS true because origin is AL=
WAYS either !=3D SEEK_SET or !=3D SEEK_CUR as if it equals one it canno=
t equal the other and vice versa=85

So at the moment it always does the revalidation instead of only for SE=
EK_END, SEEK_DATA, and SEEK_HOLE.

Best regards,

	Anton
--=20
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

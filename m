From: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>
Subject: Patch: Fix return value in cifsConvertToUTF16().
Date: Tue, 12 Jun 2012 23:32:40 +0100
Message-ID: <AA265B63-A9D7-4A21-A279-88894DEF46C4@cam.ac.uk>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

Please apply the below patch which fixes the return value in cifsConvertToUTF16().  At the moment it is returning the number of bytes in the input string which is not the same as returning the number of returned UTF16 characters!  (Note the mount is done using "iocharset=utf8".)

This causes rename system call with source being a Unicode name to fail because in UTF8 the unicode characters are more than one byte long thus cifsConvertToUTF16() returns a number larger than the actual number of returned UTF16 characters thus CIFSSMBRename() ends up constructing one or more NULL characters at the end of the source filename thus it sends a rename command like this to the server: "source_name\0 target_name" which the server presumably interprets as just "source_name" which is obviously bogus for a rename call and thus the rename fails.

The simple and obviously correct fix is the below patch which changes the cifsConvertToUTF16() function to return variable "j" instead of "i" which is the index into the destination UTF16 array which is the correct thing to do and fixes the rename bug.

Signed-off-by: Anton Altaparmakov <aia21-KWPb1pKIrIJaa/9Udqfwiw@public.gmane.org>

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/
---

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index fbb9da9..33ef60d 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -328,6 +328,6 @@ cifsConvertToUTF16(__le16 *target, const char *source, int s
 	}
 
 ctoUTF16_out:
-	return i;
+	return j;
 }
 
 

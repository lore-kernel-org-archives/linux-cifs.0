From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: manpages - Add contents for mount option  cifsacl
Date: Wed, 13 Jul 2011 11:34:35 -0500
Message-ID: <1310574875-22079-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Manpage contents for cifs mount option  cifsacl


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.8 |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 7e0f117..6c67b4a 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -272,6 +272,25 @@ Do not allow POSIX ACL operations even if server would support them\&.
 The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs requires enabling both XATTR and then POSIX support in the CIFS configuration options when building the cifs module\&. POSIX ACL support can be disabled on a per mount basis by specifying "noacl" on mount\&.
 .RE
 .PP
+cifsacl
+.RS 4
+Allow operations with file objects which posses CIFS/NTFS ACL and Security Descriptors\&.
+.sp
+This option is used to work with file objects which posses CIFS/NTFS ACL
+instead of POSIX ACL and Security Descriptors on shares mounted from
+servers such as Windows which do not support unix extensions.
+
+It is used in conjuction with files /etc/nsswitch.conf and smb.conf
+and utilities cifs.idmap and winbindd.  Please refer to the manpages
+for utilities cifs.idmap and winbindd for the usage.
+
+For commands which either display or modify unix mode and permissions
+such as ls, stat, and chmod or commands which modify owner and group
+such as chown and chgrp, to work on file system objects that belong
+to shares mounted from servers such as Windows, this mount option
+is necessary.
+.RE
+.PP
 nocase
 .RS 4
 Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
-- 
1.6.0.2

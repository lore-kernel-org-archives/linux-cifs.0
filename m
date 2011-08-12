From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: manpage content for the mount option named   backup
Date: Fri, 12 Aug 2011 11:33:45 -0500
Message-ID: <1313166825-9195-1-git-send-email-shirishpargonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, manoj-6kx38NOBMPqrIzol8Bc5pA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


manpage content for new mount option  backup 
which works in conjunction with mount option cifsacl.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.8 |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 95933e5..6494886 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -282,6 +282,13 @@ See sections on
 for more information\&.
 .RE
 .PP
+backup
+.RS 4
+Access files with the intent to back them up\&.
+.sp
+This option works with the option cifsacl. It allows an authenticated user to access files with the intent to back them up including their ACLs, who may not have access permission but has "Backup files and directories user right" on them (by virtue of being part of the built-in group Backup Operators.
+.RE
+.PP
 nocase
 .RS 4
 Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
-- 
1.6.0.2

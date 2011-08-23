From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 6/8] cifs-utils: cifsacl utilities: Change contents of mount.cifs manpage (try #2)
Date: Tue, 23 Aug 2011 14:04:18 -0500
Message-ID: <1314126258-12084-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


State getcifsacl and setcifsacl utilities to manipulate get/set xattr blob
respectively.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mount.cifs.8 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 95933e5..64a8b64 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -532,7 +532,7 @@ winbind support configured via nsswitch.conf(5) and smb.conf(5)
 .RE
 Please refer to the respective manpages of cifs.idmap(8) and winbindd(8) for more information.
 
-Security descriptors for a file object can be retrieved and set directly using extended attribute named system.cifs_acl. The security descriptors presented via this interface are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it.
+Security descriptors for a file object can be retrieved and set directly using extended attribute named system.cifs_acl. The security descriptors presented via this interface are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it such as getcifsacl(8) and setcifsacl(8) respectively.
 
 Some of the things to consider while using this mount option:
 .sp
-- 
1.6.0.2

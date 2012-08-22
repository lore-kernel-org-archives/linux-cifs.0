From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifs-utils: fix up references to getcifsacl and setcifsacl files
Date: Wed, 22 Aug 2012 15:08:32 -0400
Message-ID: <1345662512-26393-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When I moved the manpages for this to section 1, I missed some references
to them. Also, get rid of the unneeded clean-local-aclprogs makefile target.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am  | 8 +-------
 getcifsacl.c | 2 +-
 mount.cifs.8 | 6 +++---
 setcifsacl.c | 2 +-
 4 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 0d0b599..73f756f 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -10,7 +10,7 @@ man_MANS = mount.cifs.8
 
 bin_PROGRAMS =
 sbin_PROGRAMS =
-clean-local: clean-local-upcall clean-local-idmap clean-local-aclprogs
+clean-local: clean-local-upcall clean-local-idmap
 
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS += cifs.upcall
@@ -66,12 +66,6 @@ setcifsacl_SOURCES = setcifsacl.c
 setcifsacl_LDADD = $(WBCLIENT_LIBS)
 setcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
 man_MANS += setcifsacl.1
-
-endif
-
-clean-local-aclprogs:
-if CONFIG_CIFSACL
-	rm -f getcifsacl.8 getcifsacl.8-t setcifsacl.8 setcifsacl.8-t
 endif
 
 SUBDIRS = contrib
diff --git a/getcifsacl.c b/getcifsacl.c
index 19b1fec..8cbdb1d 100644
--- a/getcifsacl.c
+++ b/getcifsacl.c
@@ -322,7 +322,7 @@ getcifsacl_usage(void)
 	fprintf(stderr, "\t-v	Version of the program\n");
 	fprintf(stderr, "\n");
 	fprintf(stderr, "\t-r	Display raw values of the ACE fields\n");
-	fprintf(stderr, "\nRefer to getcifsacl(8) manpage for details\n");
+	fprintf(stderr, "\nRefer to getcifsacl(1) manpage for details\n");
 }
 
 int
diff --git a/mount.cifs.8 b/mount.cifs.8
index b2a0936..cca6048 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -677,7 +677,7 @@ winbind support configured via nsswitch.conf(5) and smb.conf(5)
 .RE
 Please refer to the respective manpages of cifs.idmap(8) and winbindd(8) for more information.
 
-Security descriptors for a file object can be retrieved and set directly using extended attribute named system.cifs_acl. The security descriptors presented via this interface are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it such as getcifsacl(8) and setcifsacl(8) respectively.
+Security descriptors for a file object can be retrieved and set directly using extended attribute named system.cifs_acl. The security descriptors presented via this interface are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it such as \fBgetcifsacl\fR(1) and \fBsetcifsacl\fR(1) respectively.
 
 Some of the things to consider while using this mount option:
 .sp
@@ -785,9 +785,9 @@ Note that the typical response to a bug report is a suggestion to try the latest
 This man page is correct for version 1\&.74 of the cifs vfs filesystem (roughly Linux kernel 3\&.0)\&.
 .SH "SEE ALSO"
 .PP
-Documentation/filesystems/cifs\&.txt and fs/cifs/README in the linux kernel source tree may contain additional options and information\&.
+\fBcifs.upcall\fR(8), \fBgetcifsacl\fR(1), \fBsetcifsacl\fR(1)
 .PP
-\fBcifs.upcall\fR(8)
+Documentation/filesystems/cifs\&.txt and fs/cifs/README in the linux kernel source tree may contain additional options and information\&.
 .SH "AUTHOR"
 .PP
 Steve French
diff --git a/setcifsacl.c b/setcifsacl.c
index 502c839..29b7b93 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -765,7 +765,7 @@ setcifsacl_usage(void)
 	"\n\t-S	Replace existing ACL with ACE(s), separated by a comma\n");
 	fprintf(stderr,
 	"\tsetcifsacl -S \"ACL:Administrator:ALLOWED/0x0/D\" <file_name>\n");
-	fprintf(stderr, "\nRefer to setcifsacl(8) manpage for details\n");
+	fprintf(stderr, "\nRefer to setcifsacl(1) manpage for details\n");
 }
 
 int
-- 
1.7.11.4

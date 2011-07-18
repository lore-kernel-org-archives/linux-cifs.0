From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: corrections and cleanups to the cifsacl option sections
Date: Mon, 18 Jul 2011 12:28:20 -0400
Message-ID: <1311006500-9862-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

..also update the part that describes what kernel version this manpage
is accurate against.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 725e88d..ab525af 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -277,8 +277,8 @@ cifsacl
 This option is used to map CIFS/NTFS ACLs to/from Linux permission bits,
 map SIDs to/from UIDs and GIDs, and get and set Security Descriptors\&.
 .sp
-See section
-\fICIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS\fR
+See sections on
+\fICIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRIPTORS\fR
 for more information\&.
 .RE
 .PP
@@ -488,12 +488,12 @@ When Unix Extensions are enabled, we use the actual inode number provided by the
 When Unix Extensions are disabled and "serverino" mount option is enabled there is no way to get the server inode number\&. The client typically maps the server\-assigned "UniqueID" onto an inode number\&.
 .PP
 Note that the UniqueID is a different value from the server inode number\&. The UniqueID value is unique over the scope of the entire server and is often greater than 2 power 32\&. This value often makes programs that are not compiled with LFS (Large File Support), to trigger a glibc EOVERFLOW error as this won\'t fit in the target structure field\&. It is strongly recommended to compile your programs with LFS support (i\&.e\&. with \-D_FILE_OFFSET_BITS=64) to prevent this problem\&. You can also use "noserverino" mount option to generate inode numbers smaller than 2 power 32 on the client\&. But you may not be able to detect hardlinks properly\&.
-.SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS
+.SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRIPTORS
 This option is used to work with file objects which posses Security Descriptors and CIFS/NTFS ACL instead of UID, GID, file permission bits, and POSIX ACL as user authentication model. This is the most common authentication model for CIFS servers and is the one used by Windows.
 .sp
-It needs both XATTR and CIFS_ACL support in the CIFS configuration options when building the cifs module.
+Support for this requires both XATTR and CIFS_ACL support in the CIFS configuration options when building the cifs module.
 
-A CIFS/NTFS ACL is mapped to file permission bits using an algorithm specified here
+A CIFS/NTFS ACL is mapped to file permission bits using an algorithm specified in the following Microsoft TechNet document:
 .sp
 .RS 4
 .ie n \{\
@@ -506,7 +506,7 @@ A CIFS/NTFS ACL is mapped to file permission bits using an algorithm specified h
 http://technet.microsoft.com/en-us/library/bb463216.aspx
 .RE
 .sp
-Mapping SIDs to/from UIDs and GIDs needs
+In order to map SIDs to/from UIDs and GIDs, the following is required:
 .sp
 .RS 4
 .ie n \{\
@@ -516,7 +516,7 @@ Mapping SIDs to/from UIDs and GIDs needs
 .sp -1
 .IP \(bu 2.3
 .\}
-a kernel upcall to the cifs.idmap utility set up via file /etc/request-key.conf
+a kernel upcall to the cifs.idmap utility set up via request-key.conf(5)
 .RE
 .sp
 .RS 4
@@ -527,12 +527,12 @@ a kernel upcall to the cifs.idmap utility set up via file /etc/request-key.conf
 .sp -1
 .IP \(bu 2.3
 .\}
-winbind configured via files /etc/nsswitch.conf and smb.conf
+winbind support configured via nsswitch.conf(5) and smb.conf(5)
 .PP
-Please refer to the respective manpages of cifs.idmap(8) and winbindd(8) for usage.
 .RE
+Please refer to the respective manpages of cifs.idmap(8) and winbindd(8) for more information.
 
-Security Descriptors for a file object can be get and set using extended attribute named system.cifs_acl. The Security Descriptors are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it.
+Security descriptors for a file object can be retrieved and set directly using extended attribute named system.cifs_acl. The security descriptors presented via this interface are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it.
 
 Some of the things to consider while using this mount option:
 .sp
@@ -614,7 +614,7 @@ The credentials file does not handle usernames or passwords with leading space\&
 Note that the typical response to a bug report is a suggestion to try the latest version first\&. So please try doing that first, and always include which versions you use of relevant software when reporting bugs (minimum: mount\&.cifs (try mount\&.cifs \-V), kernel (see /proc/version) and server type you are trying to contact\&.
 .SH "VERSION"
 .PP
-This man page is correct for version 1\&.52 of the cifs vfs filesystem (roughly Linux kernel 2\&.6\&.24)\&.
+This man page is correct for version 1\&.74 of the cifs vfs filesystem (roughly Linux kernel 3\&.0)\&.
 .SH "SEE ALSO"
 .PP
 Documentation/filesystems/cifs\&.txt and fs/cifs/README in the linux kernel source tree may contain additional options and information\&.
-- 
1.7.6

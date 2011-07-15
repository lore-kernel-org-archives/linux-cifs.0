From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs-utils: manpages - Add contents for mount option  cifsacl (try #3)
Date: Fri, 15 Jul 2011 15:20:44 -0500
Message-ID: <1310761244-24287-1-git-send-email-shirishpargaonkar@gmail.com>
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
 mount.cifs.8 |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 90 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 7e0f117..725e88d 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -272,6 +272,16 @@ Do not allow POSIX ACL operations even if server would support them\&.
 The CIFS client can get and set POSIX ACLs (getfacl, setfacl) to Samba servers version 3\&.0\&.10 and later\&. Setting POSIX ACLs requires enabling both XATTR and then POSIX support in the CIFS configuration options when building the cifs module\&. POSIX ACL support can be disabled on a per mount basis by specifying "noacl" on mount\&.
 .RE
 .PP
+cifsacl
+.RS 4
+This option is used to map CIFS/NTFS ACLs to/from Linux permission bits,
+map SIDs to/from UIDs and GIDs, and get and set Security Descriptors\&.
+.sp
+See section
+\fICIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS\fR
+for more information\&.
+.RE
+.PP
 nocase
 .RS 4
 Request case insensitive path name matching (case sensitive is the default if the server suports it)\&.
@@ -478,6 +488,86 @@ When Unix Extensions are enabled, we use the actual inode number provided by the
 When Unix Extensions are disabled and "serverino" mount option is enabled there is no way to get the server inode number\&. The client typically maps the server\-assigned "UniqueID" onto an inode number\&.
 .PP
 Note that the UniqueID is a different value from the server inode number\&. The UniqueID value is unique over the scope of the entire server and is often greater than 2 power 32\&. This value often makes programs that are not compiled with LFS (Large File Support), to trigger a glibc EOVERFLOW error as this won\'t fit in the target structure field\&. It is strongly recommended to compile your programs with LFS support (i\&.e\&. with \-D_FILE_OFFSET_BITS=64) to prevent this problem\&. You can also use "noserverino" mount option to generate inode numbers smaller than 2 power 32 on the client\&. But you may not be able to detect hardlinks properly\&.
+.SH CIFS/NTFS ACL, SID/UID/GID MAPPING, SECURITY DESCRRIPTORS
+This option is used to work with file objects which posses Security Descriptors and CIFS/NTFS ACL instead of UID, GID, file permission bits, and POSIX ACL as user authentication model. This is the most common authentication model for CIFS servers and is the one used by Windows.
+.sp
+It needs both XATTR and CIFS_ACL support in the CIFS configuration options when building the cifs module.
+
+A CIFS/NTFS ACL is mapped to file permission bits using an algorithm specified here
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+http://technet.microsoft.com/en-us/library/bb463216.aspx
+.RE
+.sp
+Mapping SIDs to/from UIDs and GIDs needs
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+a kernel upcall to the cifs.idmap utility set up via file /etc/request-key.conf
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+winbind configured via files /etc/nsswitch.conf and smb.conf
+.PP
+Please refer to the respective manpages of cifs.idmap(8) and winbindd(8) for usage.
+.RE
+
+Security Descriptors for a file object can be get and set using extended attribute named system.cifs_acl. The Security Descriptors are "raw" blobs of data and need a userspace utility to either parse and format or to assemble it.
+
+Some of the things to consider while using this mount option:
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+There may be an increased latency when handling metadata due to additional requests to get and set security descriptors.
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+The mapping between a CIFS/NTFS ACL and POSIX file permission bits is imperfect and some ACL information may be lost in the translation.
+.RE
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+If either upcall to cifs.idmap is not setup correctly or winbind is not configured and running, ID mapping will fail. In that case uid and gid will default to either to those values of the share or to the values of uid and/or gid mount options if specified.
+.RE
 .SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
 .PP
 The core CIFS protocol does not provide unix ownership information or mode for files and directories\&. Because of this, files and directories will generally appear to be owned by whatever values the uid= or gid= options are set, and will have permissions set to the default file_mode and dir_mode for the mount\&. Attempting to change these values via chmod/chown will return success but have no effect\&.
-- 
1.6.0.2

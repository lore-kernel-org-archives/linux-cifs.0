From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: document the mount.cifs vers= option
Date: Tue, 19 Mar 2013 10:35:10 -0400
Message-ID: <1363703710-23683-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/mount.cifs.8 b/mount.cifs.8
index a4fdd98..6f105ad 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -539,6 +539,57 @@ prefixpath=
 It's possible to mount a subdirectory of a share. The preferred way to do this is to append the path to the UNC when mounting. However, it's also possible to do the same by setting this option and providing the path there.
 .RE
 .PP
+vers=
+.RS 4
+SMB protocol version. Allowed values are:
+.sp
+.RS 4
+.ie n \{\
+\h'-04'\(bu\h'+03'\c
+.\}
+.el \{\
+.sp -1
+.IP \(bu 2.3
+.\}
+1.0 - SMBv1.0: The classic SMB/CIFS protocol. This is the default.
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
+2.0 - SMBv2.0: The SMB2.0 protocol which was introduced in Microsoft Windows Vista.
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
+2.1 - SMBv2.1: The SMB2.1 protocol that was introduced in Microsoft Windows 7.
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
+3.0 - SMBv3.0: The SMB3.0 protocol that was introduced in Microsoft Windows 8 and Server 2012.
+.RE
+.PP
+Note too that while this option governs the protocol version used, not all features of each version are available.
+.RE
+.PP
 \-\-verbose
 .RS 4
 Print additional debugging information for the mount\&. Note that this parameter must be specified before the \-o\&. For example:
-- 
1.7.11.7

From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: add an entry for prefixpath= to the mount.cifs manpage
Date: Mon,  5 Dec 2011 11:41:04 -0500
Message-ID: <1323103264-27748-1-git-send-email-jlayton@samba.org>
Cc: sbose-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, asn-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-by: Sumit Bose <sbose-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index 09df430..74aa061 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -506,6 +506,11 @@ posixpaths
 Inverse of \fInoposixpaths\fR.
 .RE
 .PP
+prefixpath=
+.RS 4
+It's possible to mount a subdirectory of a share. The preferred way to do this is to append the path to the UNC when mounting. However, it's also possible to do the same by setting this option and providing the path there.
+.RE
+.PP
 \-\-verbose
 .RS 4
 Print additional debugging information for the mount\&. Note that this parameter must be specified before the \-o\&. For example:
-- 
1.7.7.3

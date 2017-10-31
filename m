From: Jeff Layton <jlayton-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [cifs-utils PATCH v2] manpage: update mount.cifs manpage with info about default version being mounted
Date: Tue, 31 Oct 2017 12:02:24 -0400
Message-ID: <20171031160224.12523-1-jlayton@kernel.org>
Cc: lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, aaptel-IBi9RG/b67k@public.gmane.org, pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.rst | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Thanks Aurelien. I dropped Ronnie's Reviewed-by since this is a bit different.
Let me know if you'd like me to add it back.

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 9714f795fe76..01305df60651 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -517,7 +517,7 @@ prefixpath=arg
 vers=arg
   SMB protocol version. Allowed values are:
 
-  - 1.0 - The classic CIFS/SMBv1 protocol. This is the default.
+  - 1.0 - The classic CIFS/SMBv1 protocol.
   - 2.0 - The SMBv2.002 protocol. This was initially introduced in
     Windows Vista Service Pack 1, and Windows Server 2008. Note that
     the initial release version of Windows Vista spoke a slightly
@@ -529,6 +529,9 @@ vers=arg
   Note too that while this option governs the protocol version used, not
   all features of each version are available.
 
+  In kernels v4.13 and later, the client and server negotiate a version greater
+  than or equal to ``2.1``. In kernels prior to v4.13, the default is ``1.0``.
+
 --verbose
   Print additional debugging information for the mount. Note that this
   parameter must be specified before the ``-o`` . For example::
@@ -857,4 +860,3 @@ Steve French
 The maintainer of the Linux cifs vfs and the userspace tool mount.cifs
 is Steve French. The Linux CIFS Mailing list is the preferred place to
 ask questions regarding these programs.
-
\ No newline at end of file
-- 
2.13.6

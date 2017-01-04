From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Document mfsymlinks in the mount.cifs man page
Date: Wed,  4 Jan 2017 13:18:19 +0530
Message-ID: <1483516099-24421-1-git-send-email-sprabhu@redhat.com>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Information from the cifs README in the kernel sources is used.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mount.cifs.8 | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mount.cifs.8 b/mount.cifs.8
index af6b097..01579f6 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -450,6 +450,11 @@ sfu
 When the CIFS Unix Extensions are not negotiated, attempt to create device files and fifos in a format compatible with Services for Unix (SFU)\&. In addition retrieve bits 10\-12 of the mode via the SETFILEBITS extended attribute (as SFU does)\&. In the future the bottom 9 bits of the mode mode also will be emulated using queries of the security descriptor (ACL)\&. [NB: requires version 1\&.39 or later of the CIFS VFS\&. To recognize symlinks and be able to create symlinks in an SFU interoperable form requires version 1\&.40 or later of the CIFS VFS kernel module\&.
 .RE
 .PP
+mfsymlinks
+.RS 4
+Enable support for Minshall+French symlinks(see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks). This option is ignored when specified together with the 'sfu' option. Minshall+French symlinks are used even if the server supports the CIFS Unix Extensions.
+.RE
+.PP
 serverino
 .RS 4
 Use inode numbers (unique persistent file identifiers) returned by the server instead of automatically generating temporary inode numbers on the client\&. Although server inode numbers make it easier to spot hardlinked files (as they will have the same inode numbers) and inode numbers may be persistent (which is userful for some sofware), the server does not guarantee that the inode numbers are unique if multiple server side mounts are exported under a single share (since inode numbers on the servers might not be unique if multiple filesystems are mounted under the same shared higher level directory)\&. Note that not all servers support returning server inode numbers, although those that support the CIFS Unix Extensions, and Windows 2000 and later servers typically do support this (althou
 gh not necessarily on every local server filesystem)\&. Parameter has no effect if the server lacks support for returning inode numbers or equivalent\&. This behavior is enabled by default\!
 &.
-- 
2.7.4

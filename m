From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: smb2_clone_range() - exit on unhandled error
Date: Wed,  4 Feb 2015 13:10:26 +0000
Message-ID: <1423055426-22242-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While attempting to clone a file on a samba server, we receive a
STATUS_INVALID_DEVICE_REQUEST. This is mapped to -EOPNOTSUPP which
isn't handled in smb2_clone_range(). We end up looping in the while loop
making same call to the samba server over and over again.

The proposed fix is to exit and return the error value when encountered
with an unhandled error.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 96b5d40..eab05e1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -684,7 +684,8 @@ smb2_clone_range(const unsigned int xid,
 
 			/* No need to change MaxChunks since already set to 1 */
 			chunk_sizes_updated = true;
-		}
+		} else
+			goto cchunk_out;
 	}
 
 cchunk_out:
-- 
2.1.0

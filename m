From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] Fix warning
Date: Mon, 30 Mar 2015 22:10:02 -0500
Message-ID: <CAH2r5mvUSDKF5bhM1VdjjuEp+CrqLKfgHC=Y+HjU+GZivYtTMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Coverity reports a warning due to uninitialized attr structure in one
code path.

Reported by Coverity (CID 728535)

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2d4f372..3e126d7 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -771,6 +771,8 @@ cifs_get_inode_info(struct inode **inode, const
char *full_path,
                 cifs_buf_release(srchinf->ntwrk_buf_start);
             }
             kfree(srchinf);
+            if (rc)
+                goto cgii_exit;
     } else
         goto cgii_exit;


-- 
Thanks,

Steve

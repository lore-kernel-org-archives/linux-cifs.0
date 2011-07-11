From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: eliminate unneeded cast of cifs_demultiplex_thread
Date: Mon, 11 Jul 2011 10:17:43 -0400
Message-ID: <1310393863-12531-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 729514c..ceab134 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1791,8 +1791,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run((void *)(void *)cifs_demultiplex_thread,
-				  tcp_ses, "cifsd");
+	tcp_ses->tsk = kthread_run(cifs_demultiplex_thread, tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
 		rc = PTR_ERR(tcp_ses->tsk);
 		cERROR(1, "error %d create cifsd thread", rc);
-- 
1.7.6

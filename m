From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix cast on cifs_demultiplex_thread
Date: Wed, 20 Jul 2011 11:09:26 -0400
Message-ID: <1311174566-7172-1-git-send-email-jlayton@redhat.com>
References: <1310393863-12531-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1310393863-12531-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

My initial pass at doing this just eliminated the cast altogether. When
I played with it today though, that caused a compiler warning. So, just
fix the cast instead.

Reported-by: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 1507ada..dc52872 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1791,7 +1791,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	 * this will succeed. No need for try_module_get().
 	 */
 	__module_get(THIS_MODULE);
-	tcp_ses->tsk = kthread_run((void *)(void *)cifs_demultiplex_thread,
+	tcp_ses->tsk = kthread_run((int(*)(void *))cifs_demultiplex_thread,
 				  tcp_ses, "cifsd");
 	if (IS_ERR(tcp_ses->tsk)) {
 		rc = PTR_ERR(tcp_ses->tsk);
-- 
1.7.6

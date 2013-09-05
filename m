From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 1/8] CIFS: Fix memory leak when a lease break comes
Date: Fri,  6 Sep 2013 00:14:56 +0400
Message-ID: <1378412103-29047-2-git-send-email-pshilovsky@samba.org>
References: <1378412103-29047-1-git-send-email-pshilovsky@samba.org>
Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1378412103-29047-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This happens when we receive a lease break from a server, then
find an appropriate lease key in opened files and schedule the
oplock_break slow work. lw pointer isn't freed in this case.

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2misc.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 6103359..38c93c3 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -477,6 +477,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 
 				queue_work(cifsiod_wq, &cfile->oplock_break);
 
+				kfree(lw);
 				spin_unlock(&cifs_file_list_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
 				return true;
-- 
1.7.10.4

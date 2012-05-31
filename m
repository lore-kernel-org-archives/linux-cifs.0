From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v4 1/7] CIFS: Make accessing is_valid_oplock/dump_detail ops struct field safe
Date: Thu, 31 May 2012 16:50:51 +0400
Message-ID: <1338468657-29742-3-git-send-email-pshilovsky@samba.org>
References: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338468657-29742-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/connect.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ccafded..3647b1a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1058,13 +1058,15 @@ cifs_demultiplex_thread(void *p)
 		if (mid_entry != NULL) {
 			if (!mid_entry->multiRsp || mid_entry->multiEnd)
 				mid_entry->callback(mid_entry);
-		} else if (!server->ops->is_oplock_break(buf, server)) {
+		} else if (!server->ops->is_oplock_break ||
+			   !server->ops->is_oplock_break(buf, server)) {
 			cERROR(1, "No task to wake, unknown frame received! "
 				   "NumMids %d", atomic_read(&midCount));
 			cifs_dump_mem("Received Data is: ", buf,
 				      HEADER_SIZE(server));
 #ifdef CONFIG_CIFS_DEBUG2
-			server->ops->dump_detail(buf);
+			if (server->ops->dump_detail)
+				server->ops->dump_detail(buf);
 			cifs_dump_mids(server);
 #endif /* CIFS_DEBUG2 */
 
-- 
1.7.1

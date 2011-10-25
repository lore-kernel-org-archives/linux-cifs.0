From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 10/53] CIFS: Add routines to free SMB2 mids
Date: Tue, 25 Oct 2011 10:11:43 +0400
Message-ID: <1319523146-2859-11-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

Add smb2_mid_entry_free and free_smb2_mid.
These are straightforward and generally similarly
to cifs's DeleteMidQEntry and delete_mid.

Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/smb2transport.c |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 94b277e..59aa1c0 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -191,4 +191,66 @@ static int get_smb2_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
 	spin_unlock(&GlobalMid_Lock);
 	return 0;
 }
+
+static void
+smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
+{
+#ifdef CONFIG_CIFS_STATS2
+	unsigned long now;
+#endif
+	mid_entry->mid_state = MID_FREE;
+	atomic_dec(&midCount);
+
+	/*
+	 * the large buf free will eventually use a different
+	 * pool (the cifs size is not optimal for smb2) but
+	 * it makes the initial conversion simpler to leave
+	 * it using the cifs large buf pool
+	 */
+	if (mid_entry->large_buf)
+		cifs_buf_release(mid_entry->resp_buf);
+	else
+		cifs_small_buf_release(mid_entry->resp_buf);
+#ifdef CONFIG_CIFS_STATS2
+	now = jiffies;
+	/*
+	 * commands taking longer than one second are indications that
+	 * something is wrong, unless it is quite a slow link or server
+	 */
+	/*
+	 * BB eventually add a mid flag to allow us to indicate other ops such
+	 * as SMB2 reads or writes to "offline" files which are ok to be slow
+	 */
+	if ((now - mid_entry->when_alloc) > HZ) {
+		if ((cifsFYI & CIFS_TIMER) &&
+		   (mid_entry->command != SMB2_LOCK)) {
+			printk(KERN_DEBUG " SMB2 slow rsp: cmd %d mid %lld",
+			       mid_entry->command, mid_entry->mid);
+			printk(" A: 0x%lx S: 0x%lx R: 0x%lx\n",
+			       now - mid_entry->when_alloc,
+			       now - mid_entry->when_sent,
+			       now - mid_entry->when_received);
+		}
+	}
+#endif
+
+	/*
+	 * The next two lines or equivalent will be needed when pagebuf support
+	 * added back in:
+	if (mid_entry->is_kmap_buf && mid_entry->pagebuf_list)
+		kfree(mid_entry->pagebuf_list);
+	*/
+
+	mempool_free(mid_entry, smb2_mid_poolp);
+}
+
+static void
+free_smb2_mid(struct smb2_mid_entry *mid)
+{
+	spin_lock(&GlobalMid_Lock);
+	list_del(&mid->qhead);
+	spin_unlock(&GlobalMid_Lock);
+
+	smb2_mid_entry_free(mid);
+}
 /* BB add missing functions here */
-- 
1.7.1

From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Add routines to free SMB2 mids
Date: Fri, 11 Mar 2011 22:12:03 -0600
Message-ID: <AANLkTi=LkuHJq_z1dngTG5xYA2TbWfeiZYNvgL80nONx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

    [CIFS] Add routines to free SMB2 mids

    Add smb2_mid_entry_free and free_smb2_mid.
    These are straightforward and generally similarly
    to cifs's DeleteMidQEntry and delete_mid but
    handle the differences in the mids, and
    attempt to use cleaner, non-camelCase names.

    Next patch will add the transport routine needed
    by SMB2 Negotiate which will be the first users
    of the get_smb2_mid/free_smb2_mid

    Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>

diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 9d33cd2..c62070a 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -206,5 +206,59 @@ static int get_smb2_mid(struct cifs_ses *ses,
struct smb2_hdr *in_buf,
 	return 0;
 }

+static void
+smb2_mid_entry_free(struct smb2_mid_entry *mid_entry)
+{
+#ifdef CONFIG_CIFS_STATS2
+	unsigned long now;
+#endif
+	mid_entry->mid_state = MID_FREE;
+	atomic_dec(&midCount);
+
+	/* the large buf free will eventually use a different
+	   pool (the cifs size is not optimal for smb2) but
+	   it makes the initial conversion simpler to leave
+	   it using the cifs large buf pool */
+	if (mid_entry->large_buf)
+		cifs_buf_release(mid_entry->resp_buf);
+	else
+		cifs_small_buf_release(mid_entry->resp_buf);
+#ifdef CONFIG_CIFS_STATS2
+	now = jiffies;
+	/* commands taking longer than one second are indications that
+	   something is wrong, unless it is quite a slow link or server */
+	/* BB eventually add a mid flag to allow us to indicate other ops such
+	   as SMB2 reads or writes to "offline" files which are ok to be slow */
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
+/*	The next two lines or equivalent will be needed when pagebuf support
+	added back in:
+	if (mid_entry->is_kmap_buf && mid_entry->pagebuf_list)
+		kfree(mid_entry->pagebuf_list); */
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
+

 /* BB add missing functions here */

-- 
Thanks,

Steve

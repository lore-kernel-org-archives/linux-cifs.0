From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v3 18/19] CIFS: SMBD: Deregister memory when finishing SMB read
Date: Tue, 29 Aug 2017 12:29:14 -0700
Message-ID: <20170829192915.26251-19-longli@exchange.microsoft.com>
References: <20170829192915.26251-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829192915.26251-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

When SMB read is finished, deregister the memory regions if RDMA write is used
for this SMB read. smbd_deregister_mr may need to do local invalidation and
sleep, if server remote invalidation is not used.

There are situations where the MID may not be created on I/O failure, under
which memory region is deregistered when read data context is released.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/file.c    |  5 +++++
 fs/cifs/smb2pdu.c | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 41460a5..5a6df25 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2910,6 +2910,11 @@ cifs_readdata_release(struct kref *refcount)
 	struct cifs_readdata *rdata = container_of(refcount,
 					struct cifs_readdata, refcount);
 
+	if (rdata->mr) {
+		smbd_deregister_mr(rdata->mr);
+		rdata->mr = NULL;
+	}
+
 	if (rdata->cfile)
 		cifsFileInfo_put(rdata->cfile);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1f08c75..43a7b60 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2504,6 +2504,16 @@ smb2_readv_callback(struct mid_q_entry *mid)
 			rdata->result = -EIO;
 	}
 
+	/*
+	 * If this rdata has a memmory registered, the MR can be freed
+	 * MR needs to be freed as soon as I/O finishes to prevent deadlock
+	 * because they have limited number and are used for future I/Os
+	 */
+	if (rdata->mr) {
+		smbd_deregister_mr(rdata->mr);
+		rdata->mr = NULL;
+	}
+
 	if (rdata->result)
 		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
 
-- 
2.7.4

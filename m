From: Long Li <longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Subject: [Patch v4 05/22] CIFS: SMBD: Implement function to create a SMBDirect connection
Date: Sun,  1 Oct 2017 19:30:13 -0700
Message-ID: <20171002023030.3582-6-longli@exchange.microsoft.com>
References: <20171002023030.3582-1-longli@exchange.microsoft.com>
Cc: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
        Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171002023030.3582-1-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>

The upper layer calls this function to connect to peer through SMBDirect.
Each SMBDirect connection is based on a RC Queue Pair.

Signed-off-by: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smbdirect.c | 17 +++++++++++++++++
 fs/cifs/smbdirect.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index e8f976f..34f73e2 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1675,3 +1675,20 @@ struct smbd_connection *_smbd_get_connection(
 	kfree(info);
 	return NULL;
 }
+
+struct smbd_connection *smbd_get_connection(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
+{
+	struct smbd_connection *ret;
+	int port = SMBD_PORT;
+
+try_again:
+	ret = _smbd_get_connection(server, dstaddr, port);
+
+	/* Try SMB_PORT if SMBD_PORT doesn't work */
+	if (!ret && port == SMBD_PORT) {
+		port = SMB_PORT;
+		goto try_again;
+	}
+	return ret;
+}
diff --git a/fs/cifs/smbdirect.h b/fs/cifs/smbdirect.h
index ca60700..42a9338 100644
--- a/fs/cifs/smbdirect.h
+++ b/fs/cifs/smbdirect.h
@@ -245,6 +245,10 @@ struct smbd_response {
 	u8 packet[];
 };
 
+/* Create a SMBDirect session */
+struct smbd_connection *smbd_get_connection(
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
+
 void profiling_display_histogram(
 	struct seq_file *m, unsigned long long array[]);
 #endif
-- 
2.7.4

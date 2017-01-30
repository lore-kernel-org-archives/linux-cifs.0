From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH v2 10/15] CIFS: Add transform header handling callbacks
Date: Mon, 30 Jan 2017 13:39:39 -0800
Message-ID: <1485812384-28870-11-git-send-email-pshilov@microsoft.com>
References: <1485812384-28870-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485812384-28870-1-git-send-email-pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We need to recognize and parse transformed packets in demultiplex
thread to find a corresponsing mid and process it further.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +++
 fs/cifs/connect.c  | 17 ++++++++++++-----
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 9433a9b..1d1cdea 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -440,6 +440,9 @@ struct smb_version_operations {
 				 struct smb_rqst *);
 	/* free transform request */
 	void (*free_transform_rq)(struct smb_rqst *);
+	int (*is_transform_hdr)(void *buf);
+	int (*receive_transform)(struct TCP_Server_Info *,
+				 struct mid_q_entry **);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 46124a0..3a2183a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -869,12 +869,19 @@ cifs_demultiplex_thread(void *p)
 			continue;
 		server->total_read += length;
 
-		mid_entry = server->ops->find_mid(server, buf);
+		if (server->ops->is_transform_hdr &&
+		    server->ops->receive_transform &&
+		    server->ops->is_transform_hdr(buf)) {
+			length = server->ops->receive_transform(server,
+								&mid_entry);
+		} else {
+			mid_entry = server->ops->find_mid(server, buf);
 
-		if (!mid_entry || !mid_entry->receive)
-			length = standard_receive3(server, mid_entry);
-		else
-			length = mid_entry->receive(server, mid_entry);
+			if (!mid_entry || !mid_entry->receive)
+				length = standard_receive3(server, mid_entry);
+			else
+				length = mid_entry->receive(server, mid_entry);
+		}
 
 		if (length < 0)
 			continue;
-- 
2.7.4

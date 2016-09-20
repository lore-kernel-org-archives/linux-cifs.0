From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Limit the overall credit acquired
Date: Tue, 20 Sep 2016 13:37:13 +0100
Message-ID: <1474375033-19895-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The kernel client requests 2 credits for many operations even though
they only use 1 credit (presumably to build up a buffer of credit).
Some servers seem to give the client as much credit as is requested.  In
this case, the amount of credit the client has continues increasing to
the point where (server->credits * MAX_BUFFER_SIZE) overflows in
smb2_wait_mtu_credits().

Fix this by throttling the credit requests if an set limit is reached.
For async requests where the credit charge may be > 1, request as much
credit as what is charged.
The limit is chosen somewhat arbitrarily. The Windows client
defaults to 128 credits, the Windows server allows clients up to
512 credits, and the NetApp server does not limit clients at all.
Choose a high enough value such that the client shouldn't limit
performance.

This behavior was seen with a NetApp filer (NetApp Release 9.0RC2).

Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2glob.h | 10 ++++++++++
 fs/cifs/smb2pdu.c  | 18 +++++++++++++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 0ffa180..0e1d788 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -61,4 +61,14 @@
 /* Maximum buffer size value we can send with 1 credit */
 #define SMB2_MAX_BUFFER_SIZE 65536
 
+/*
+ * Maximum number of credits to keep available.
+ * This value is chosen somewhat arbitrarily. The Windows client
+ * defaults to 128 credits, the Windows server allows clients up to
+ * 512 credits, and the NetApp server does not limit clients at all.
+ * Choose a high enough value such that the client shouldn't limit
+ * performance.
+ */
+#define SMB2_MAX_CREDITS_AVAILABLE 1024
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 29e06db..967a790 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -100,7 +100,21 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	hdr->ProtocolId = SMB2_PROTO_NUMBER;
 	hdr->StructureSize = cpu_to_le16(64);
 	hdr->Command = smb2_cmd;
-	hdr->CreditRequest = cpu_to_le16(2); /* BB make this dynamic */
+	if (tcon && tcon->ses && tcon->ses->server) {
+		struct TCP_Server_Info *server = tcon->ses->server;
+
+		spin_lock(&server->req_lock);
+		/* Request up to 2 credits but don't go over the limit. */
+		if (server->credits >= SMB2_MAX_CREDITS_AVAILABLE)
+			hdr->CreditRequest = cpu_to_le16(0);
+		else
+			hdr->CreditRequest = cpu_to_le16(
+				min_t(int, SMB2_MAX_CREDITS_AVAILABLE -
+						server->credits, 2));
+		spin_unlock(&server->req_lock);
+	} else {
+		hdr->CreditRequest = cpu_to_le16(2);
+	}
 	hdr->ProcessId = cpu_to_le32((__u16)current->tgid);
 
 	if (!tcon)
@@ -2057,6 +2071,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rdata->credits) {
 		buf->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
 						SMB2_MAX_BUFFER_SIZE));
+		buf->CreditRequest = buf->CreditCharge;
 		spin_lock(&server->req_lock);
 		server->credits += rdata->credits -
 						le16_to_cpu(buf->CreditCharge);
@@ -2243,6 +2258,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (wdata->credits) {
 		req->hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
+		req->hdr.CreditRequest = req->hdr.CreditCharge;
 		spin_lock(&server->req_lock);
 		server->credits += wdata->credits -
 					le16_to_cpu(req->hdr.CreditCharge);
-- 
2.7.4

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 43/53] CIFS: Process STATUS_PENDING responses for SMB2
Date: Tue, 25 Oct 2011 10:12:16 +0400
Message-ID: <1319523146-2859-44-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |   19 +++++++++++++++++--
 fs/cifs/nterr.h   |    1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f8d5023..0e188b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -827,10 +827,10 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	 * into the payload for debugging purposes.
 	 */
 #ifdef CONFIG_CIFS_SMB2
-	if (server->is_smb2)
+	if (server->is_smb2) {
 		length = checkSMB2(smb2_buffer, smb2_buffer->MessageId,
 				   server->total_read);
-	else
+	} else
 #endif
 		length = checkSMB(smb_buffer, smb_buffer->Mid,
 				  server->total_read);
@@ -838,6 +838,21 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dump_mem("Bad SMB: ", buf,
 			min_t(unsigned int, server->total_read, 48));
 
+#ifdef CONFIG_CIFS_SMB2
+	/*
+	* If we negotiate SMB2 protocol and get STATUS_PENDING - update
+	* the number of credits and skip it.
+	*/
+	if (server->is_smb2 &&
+			le32_to_cpu(smb2_buffer->Status) == STATUS_PENDING) {
+		if (!length)
+			atomic_add(le16_to_cpu(smb2_buffer->CreditRequest),
+				   &server->credits);
+		cERROR(1, "STATUS PENDING");
+		return -1;
+	}
+#endif
+
 	if (mid)
 		handle_mid(mid, server, buf, length);
 
diff --git a/fs/cifs/nterr.h b/fs/cifs/nterr.h
index 2572673..e80c0ef 100644
--- a/fs/cifs/nterr.h
+++ b/fs/cifs/nterr.h
@@ -40,6 +40,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define ERROR_INSUFFICIENT_BUFFER	  0x007a
 #define STATUS_1804	                  0x070c
 #define STATUS_NOTIFY_ENUM_DIR            0x010c
+#define STATUS_PENDING			  0x00000103
 
 /* Win32 Error codes extracted using a loop in smbclient then printing a
    netmon sniff to a file. */
-- 
1.7.1

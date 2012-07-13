From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 28/32] CIFS: Add SMB2 support for async requests
Date: Fri, 13 Jul 2012 11:53:41 +0400
Message-ID: <1342166025-29377-29-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/smb2ops.c       |    1 +
 fs/cifs/smb2proto.h     |    4 ++++
 fs/cifs/smb2transport.c |   23 ++++++++++++++++++++++-
 3 files changed, 27 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2f9950e..8672e49 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -209,6 +209,7 @@ smb2_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 
 struct smb_version_operations smb21_operations = {
 	.setup_request = smb2_setup_request,
+	.setup_async_request = smb2_setup_async_request,
 	.check_receive = smb2_check_receive,
 	.add_credits = smb2_add_credits,
 	.set_credits = smb2_set_credits,
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 1517b4c..1a17955 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -43,6 +43,10 @@ extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 			      unsigned int nvec, struct mid_q_entry **ret_mid);
+extern int smb2_setup_async_request(struct TCP_Server_Info *server,
+				    struct kvec *iov, unsigned int nvec,
+				    struct mid_q_entry **ret_mid);
+extern void smb2_echo_request(struct work_struct *work);
 
 extern int smb2_query_path_info(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index b4b6b9a..31f5d42 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -148,4 +148,25 @@ smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 	return rc;
 }
 
-/* BB add missing functions here */
+int
+smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
+			 unsigned int nvec, struct mid_q_entry **ret_mid)
+{
+	int rc = 0;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+	struct mid_q_entry *mid;
+
+	smb2_seq_num_into_buf(server, hdr);
+
+	mid = smb2_mid_entry_alloc(hdr, server);
+	if (mid == NULL)
+		return -ENOMEM;
+
+	/* rc = smb2_sign_smb2(iov, nvec, server);
+	if (rc) {
+		DeleteMidQEntry(mid);
+		return rc;
+	}*/
+	*ret_mid = mid;
+	return rc;
+}
-- 
1.7.1

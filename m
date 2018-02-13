From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/14] cifs: update __smb_send_rqst() to take an array of requests
Date: Tue, 13 Feb 2018 15:42:25 +1100
Message-ID: <20180213044234.18364-6-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Also create a new method set_next_header() which we will start using
in the next few patches.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |  1 +
 fs/cifs/smb2ops.c   | 15 ++++++++++
 fs/cifs/smb2proto.h |  1 +
 fs/cifs/transport.c | 84 +++++++++++++++++++++++++++++------------------------
 4 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 18a961d32e0c..51d0d29dceed 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -450,6 +450,7 @@ struct smb_version_operations {
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
 	int (*next_header)(char *);
+	void (*set_next_header)(char *, int);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6a2e33fa3b3a..be1cb6aaa19c 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2717,6 +2717,17 @@ smb2_next_header(char *buf)
 	return le32_to_cpu(hdr->NextCommand);
 }
 
+static void
+smb2_set_next_header(char *buf, int offset)
+{
+	struct smb2_sync_hdr *hdr = (struct smb2_sync_hdr *)buf;
+
+	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM)
+		return;
+
+	hdr->NextCommand = cpu_to_le32(offset);
+}
+
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -2809,6 +2820,7 @@ struct smb_version_operations smb20_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
+	.set_next_header = smb2_set_next_header,
 };
 
 struct smb_version_operations smb21_operations = {
@@ -2904,6 +2916,7 @@ struct smb_version_operations smb21_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
+	.set_next_header = smb2_set_next_header,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -3009,6 +3022,7 @@ struct smb_version_operations smb30_operations = {
 	.set_acl = set_smb2_acl,
 #endif /* CIFS_ACL */
 	.next_header = smb2_next_header,
+	.set_next_header = smb2_set_next_header,
 };
 
 #ifdef CONFIG_CIFS_SMB311
@@ -3110,6 +3124,7 @@ struct smb_version_operations smb311_operations = {
 	.set_EA = smb2_set_ea,
 #endif /* CIFS_XATTR */
 	.next_header = smb2_next_header,
+	.set_next_header = smb2_set_next_header,
 };
 #endif /* CIFS_SMB311 */
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 089a6ef936b8..d35e6bfa079d 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -204,4 +204,5 @@ extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
 extern enum securityEnum smb2_select_sectype(struct TCP_Server_Info *,
 					enum securityEnum);
+extern int smb3_encryption_required(const struct cifs_tcon *tcon);
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 35ef3f7e7ab0..b2af2341f6b8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -200,7 +200,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 }
 
 static unsigned long
-rqst_len(struct smb_rqst *rqst)
+smb2_rqst_len(struct smb_rqst *rqst)
 {
 	unsigned int i;
 	struct kvec *iov = rqst->rq_iov;
@@ -220,13 +220,14 @@ rqst_len(struct smb_rqst *rqst)
 }
 
 static int
-__smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
+__smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
+		struct smb_rqst *rqst)
 {
-	int rc;
-	struct kvec *iov = rqst->rq_iov;
-	int n_vec = rqst->rq_nvec;
-	unsigned int send_length;
-	unsigned int i;
+	int rc = 0;
+	struct kvec *iov;
+	int n_vec;
+	unsigned int send_length = 0;
+	unsigned int i, j;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
 	struct msghdr smb_msg;
@@ -236,14 +237,14 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
-	send_length = rqst_len(rqst);
-	rfc1002_marker = cpu_to_be32(send_length);
-
 	/* cork the socket */
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
 
-	size = 0;
+	for (j = 0; j < num_rqst; j++)
+		send_length += smb2_rqst_len(&rqst[j]);
+	rfc1002_marker = cpu_to_be32(send_length);
+
 	/* Generate a rfc1002 marker for SMB2+ */
 	if (server->vals->header_preamble_size == 0) {
 		struct kvec hiov = {
@@ -260,37 +261,44 @@ __smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 		send_length += 4;
 	}
 
-	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
-	dump_smb(iov[0].iov_base, iov[0].iov_len);
-	dump_smb(iov[1].iov_base, iov[1].iov_len);
+	for (j = 0; j < num_rqst; j++) {
+		iov = rqst[j].rq_iov;
+		n_vec = rqst[j].rq_nvec;
 
-	for (i = 0; i < n_vec; i++)
-		size += iov[i].iov_len;
+		cifs_dbg(FYI, "Sending smb: smb_len=%u\n", send_length);
+		dump_smb(iov[0].iov_base, iov[0].iov_len);
+		dump_smb(iov[1].iov_base, iov[1].iov_len);
 
-	iov_iter_kvec(&smb_msg.msg_iter, WRITE | ITER_KVEC, iov, n_vec, size);
+		size = 0;
+		for (i = 0; i < n_vec; i++)
+			size += iov[i].iov_len;
+
+		iov_iter_kvec(&smb_msg.msg_iter, WRITE | ITER_KVEC,
+			      iov, n_vec, size);
 
-	rc = smb_send_kvec(server, &smb_msg, &sent);
-	if (rc < 0)
-		goto uncork;
-
-	total_len += sent;
-
-	/* now walk the page array and send each page in it */
-	for (i = 0; i < rqst->rq_npages; i++) {
-		size_t len = i == rqst->rq_npages - 1
-				? rqst->rq_tailsz
-				: rqst->rq_pagesz;
-		struct bio_vec bvec = {
-			.bv_page = rqst->rq_pages[i],
-			.bv_len = len
-		};
-		iov_iter_bvec(&smb_msg.msg_iter, WRITE | ITER_BVEC,
-			      &bvec, 1, len);
 		rc = smb_send_kvec(server, &smb_msg, &sent);
 		if (rc < 0)
-			break;
+			goto uncork;
 
 		total_len += sent;
+
+		/* now walk the page array and send each page in it */
+		for (i = 0; i < rqst[j].rq_npages; i++) {
+			size_t len = i == rqst[j].rq_npages - 1
+				? rqst[j].rq_tailsz
+				: rqst[j].rq_pagesz;
+			struct bio_vec bvec = {
+				.bv_page = rqst[j].rq_pages[i],
+				.bv_len = len
+			};
+			iov_iter_bvec(&smb_msg.msg_iter, WRITE | ITER_BVEC,
+				      &bvec, 1, len);
+			rc = smb_send_kvec(server, &smb_msg, &sent);
+			if (rc < 0)
+				break;
+
+			total_len += sent;
+		}
 	}
 
 uncork:
@@ -326,7 +334,7 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst, int flags)
 	int rc;
 
 	if (!(flags & CIFS_TRANSFORM_REQ))
-		return __smb_send_rqst(server, rqst);
+		return __smb_send_rqst(server, 1, rqst);
 
 	if (!server->ops->init_transform_rq ||
 	    !server->ops->free_transform_rq) {
@@ -338,7 +346,7 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst, int flags)
 	if (rc)
 		return rc;
 
-	rc = __smb_send_rqst(server, &cur_rqst);
+	rc = __smb_send_rqst(server, 1, &cur_rqst);
 	server->ops->free_transform_rq(&cur_rqst);
 	return rc;
 }
@@ -356,7 +364,7 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 	iov[1].iov_base = (char *)smb_buffer + 4;
 	iov[1].iov_len = smb_buf_length;
 
-	return __smb_send_rqst(server, &rqst);
+	return __smb_send_rqst(server, 1, &rqst);
 }
 
 static int
-- 
2.13.3

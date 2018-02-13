From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/14] cifs: remove smb2_send_recv()
Date: Tue, 13 Feb 2018 15:42:24 +1100
Message-ID: <20180213044234.18364-5-lsahlber@redhat.com>
References: <20180213044234.18364-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213044234.18364-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we have the plumbing to pass request without an rfc1002
header all the way down to the point we write to the socket we no
longer need the smb2_send_recv() function.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |   4 --
 fs/cifs/smb2pdu.c   | 137 ++++++++++++++++++++++++++++++++++++++++++++--------
 fs/cifs/transport.c |  17 -------
 3 files changed, 116 insertions(+), 42 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 93d565186698..4143c9dec463 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -106,10 +106,6 @@ extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */, const int flags,
 			struct kvec * /* resp vec */);
-extern int smb2_send_recv(const unsigned int xid, struct cifs_ses *pses,
-			  struct kvec *pkvec, int nvec_to_send,
-			  int *pbuftype, const int flags,
-			  struct kvec *presp);
 extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct cifs_tcon *ptcon,
 			struct smb_hdr *in_buf ,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a1a25b46cc2e..ac6b1d8d0c88 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -428,6 +428,7 @@ static void assemble_neg_contexts(struct smb2_negotiate_req *req,
 int
 SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 {
+	struct smb_rqst rqst;
 	struct smb2_negotiate_req *req;
 	struct smb2_negotiate_rsp *rsp;
 	struct kvec iov[1];
@@ -495,7 +496,11 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_negotiate_rsp *)rsp_iov.iov_base;
 	/*
@@ -818,6 +823,7 @@ static int
 SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 {
 	int rc;
+	struct smb_rqst rqst;
 	struct smb2_sess_setup_req *req = sess_data->iov[0].iov_base;
 	struct kvec rsp_iov = { NULL, 0 };
 
@@ -826,10 +832,13 @@ SMB2_sess_sendreceive(struct SMB2_sess_data *sess_data)
 		cpu_to_le16(sizeof(struct smb2_sess_setup_req) - 1 /* pad */);
 	req->SecurityBufferLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
-	/* BB add code to build os and lm fields */
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = sess_data->iov;
+	rqst.rq_nvec = 2;
 
-	rc = smb2_send_recv(sess_data->xid, sess_data->ses,
-			    sess_data->iov, 2,
+	/* BB add code to build os and lm fields */
+	rc = cifs_send_recv(sess_data->xid, sess_data->ses,
+			    &rqst,
 			    &sess_data->buf0_type,
 			    CIFS_LOG_ERROR | CIFS_NEG_OP, &rsp_iov);
 	cifs_small_buf_release(sess_data->iov[0].iov_base);
@@ -1158,6 +1167,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 int
 SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 {
+	struct smb_rqst rqst;
 	struct smb2_logoff_req *req; /* response is also trivial struct */
 	int rc = 0;
 	struct TCP_Server_Info *server;
@@ -1195,7 +1205,11 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	/*
 	 * No tcon so can't do
@@ -1225,6 +1239,7 @@ int
 SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	  struct cifs_tcon *tcon, const struct nls_table *cp)
 {
+	struct smb_rqst rqst;
 	struct smb2_tree_connect_req *req;
 	struct smb2_tree_connect_rsp *rsp = NULL;
 	struct kvec iov[2];
@@ -1285,7 +1300,11 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	iov[1].iov_base = unc_path;
 	iov[1].iov_len = unc_path_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 2;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
 
@@ -1354,6 +1373,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 int
 SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 {
+	struct smb_rqst rqst;
 	struct smb2_tree_disconnect_req *req; /* response is trivial */
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
@@ -1384,7 +1404,11 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc)
 		cifs_stats_fail_inc(tcon, SMB2_TREE_DISCONNECT_HE);
@@ -1681,6 +1705,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	  __u8 *oplock, struct smb2_file_all_info *buf,
 	  struct kvec *err_iov)
 {
+	struct smb_rqst rqst;
 	struct smb2_create_req *req;
 	struct smb2_create_rsp *rsp;
 	struct TCP_Server_Info *server;
@@ -1808,7 +1833,11 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		dhc_buf = iov[n_iov-1].iov_base;
 	}
 
-	rc = smb2_send_recv(xid, ses, iov, n_iov, &resp_buftype, flags,
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = n_iov;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
 			    &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
@@ -1855,6 +1884,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	   char *in_data, u32 indatalen,
 	   char **out_data, u32 *plen /* returned data len */)
 {
+	struct smb_rqst rqst;
 	struct smb2_ioctl_req *req;
 	struct smb2_ioctl_rsp *rsp;
 	struct cifs_ses *ses;
@@ -1955,7 +1985,11 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
 		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	rc = smb2_send_recv(xid, ses, iov, n_iov, &resp_buftype, flags,
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = n_iov;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
 			    &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
@@ -2037,6 +2071,7 @@ int
 SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	   u64 persistent_fid, u64 volatile_fid)
 {
+	struct smb_rqst rqst;
 	struct smb2_close_req *req;
 	struct smb2_close_rsp *rsp;
 	struct cifs_ses *ses = tcon->ses;
@@ -2065,7 +2100,11 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
 
@@ -2142,6 +2181,7 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	   u32 additional_info, size_t output_len, size_t min_len, void **data,
 		u32 *dlen)
 {
+	struct smb_rqst rqst;
 	struct smb2_query_info_req *req;
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov[2];
@@ -2182,7 +2222,11 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	/* 1 for Buffer */
 	iov[0].iov_len = total_len - 1;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
@@ -2379,6 +2423,7 @@ int
 SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	   u64 volatile_fid)
 {
+	struct smb_rqst rqst;
 	struct smb2_flush_req *req;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[1];
@@ -2406,7 +2451,11 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc != 0)
@@ -2614,6 +2663,7 @@ int
 SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	  unsigned int *nbytes, char **buf, int *buf_type)
 {
+	struct smb_rqst rqst;
 	int resp_buftype, rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
 	struct smb2_read_rsp *rsp = NULL;
@@ -2634,7 +2684,11 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	rsp = (struct smb2_read_rsp *)rsp_iov.iov_base;
@@ -2816,6 +2870,7 @@ int
 SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	   unsigned int *nbytes, struct kvec *iov, int n_vec)
 {
+	struct smb_rqst rqst;
 	int rc = 0;
 	struct smb2_write_req *req = NULL;
 	struct smb2_write_rsp *rsp = NULL;
@@ -2857,7 +2912,11 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	/* 1 for Buffer */
 	iov[0].iov_len = total_len - 1;
 
-	rc = smb2_send_recv(xid, io_parms->tcon->ses, iov, n_vec + 1,
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = n_vec + 1;
+
+	rc = cifs_send_recv(xid, io_parms->tcon->ses, &rqst,
 			    &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
@@ -2920,6 +2979,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, int index,
 		     struct cifs_search_info *srch_inf)
 {
+	struct smb_rqst rqst;
 	struct smb2_query_directory_req *req;
 	struct smb2_query_directory_rsp *rsp = NULL;
 	struct kvec iov[2];
@@ -2992,7 +3052,11 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_base = (char *)(req->Buffer);
 	iov[1].iov_len = len;
 
-	rc = smb2_send_recv(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 2;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
 
@@ -3051,6 +3115,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	       u8 info_type, u32 additional_info, unsigned int num,
 		void **data, unsigned int *size)
 {
+	struct smb_rqst rqst;
 	struct smb2_set_info_req *req;
 	struct smb2_set_info_rsp *rsp = NULL;
 	struct kvec *iov;
@@ -3106,7 +3171,11 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 		iov[i].iov_len = size[i];
 	}
 
-	rc = smb2_send_recv(xid, ses, iov, num, &resp_buftype, flags,
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = num;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags,
 			    &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;
@@ -3258,6 +3327,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  const u64 persistent_fid, const u64 volatile_fid,
 		  __u8 oplock_level)
 {
+	struct smb_rqst rqst;
 	int rc;
 	struct smb2_oplock_break *req = NULL;
 	struct cifs_ses *ses = tcon->ses;
@@ -3286,7 +3356,11 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
@@ -3346,6 +3420,7 @@ int
 SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
 {
+	struct smb_rqst rqst;
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov;
 	struct kvec rsp_iov;
@@ -3364,7 +3439,11 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = smb2_send_recv(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = &iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -3389,6 +3468,7 @@ int
 SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, int level)
 {
+	struct smb_rqst rqst;
 	struct smb2_query_info_rsp *rsp = NULL;
 	struct kvec iov;
 	struct kvec rsp_iov;
@@ -3420,7 +3500,11 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = smb2_send_recv(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = &iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -3459,6 +3543,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	   const __u64 persist_fid, const __u64 volatile_fid, const __u32 pid,
 	   const __u32 num_lock, struct smb2_lock_element *buf)
 {
+	struct smb_rqst rqst;
 	int rc = 0;
 	struct smb2_lock_req *req = NULL;
 	struct kvec iov[2];
@@ -3491,7 +3576,12 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_len = count;
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
-	rc = smb2_send_recv(xid, tcon->ses, iov, 2, &resp_buf_type, flags,
+
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 2;
+
+	rc = cifs_send_recv(xid, tcon->ses, &rqst, &resp_buf_type, flags,
 			    &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc) {
@@ -3523,6 +3613,7 @@ int
 SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 		 __u8 *lease_key, const __le32 lease_state)
 {
+	struct smb_rqst rqst;
 	int rc;
 	struct smb2_lease_ack *req = NULL;
 	struct cifs_ses *ses = tcon->ses;
@@ -3553,7 +3644,11 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
 
-	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
+	memset(&rqst, 0, sizeof(struct smb_rqst));
+	rqst.rq_iov = iov;
+	rqst.rq_nvec = 1;
+
+	rc = cifs_send_recv(xid, ses, &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index d6f26fc3e6f5..35ef3f7e7ab0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -844,23 +844,6 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-/* Like SendReceive2 but iov[0] does not contain an rfc1002 header */
-int
-smb2_send_recv(const unsigned int xid, struct cifs_ses *ses,
-	       struct kvec *iov, int n_vec, int *resp_buf_type /* ret */,
-	       const int flags, struct kvec *resp_iov)
-{
-	struct smb_rqst rqst;
-	int rc;
-
-	memset(&rqst, 0, sizeof(struct smb_rqst));
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = n_vec;
-
-	rc = cifs_send_recv(xid, ses, &rqst, resp_buf_type, flags, resp_iov);
-	return rc;
-}
-
 int
 SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
-- 
2.13.3

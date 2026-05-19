Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7774B8DF5
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186201; cv=none; b=VEakLEqiEYtBkr48MC2Pu0G/T6VeVr8Px9aYxJb3yLJWC+exUMocfWSoHiMZtlO8b50dpebMVvYS7W25X46WwvD6CSkFdD1oXIa+F2ldusT6OqQBLMNQnBo2cLNge7R/Cl6IdsrZjfiOOMtnfLIclOflwkTts4WGLvbILI67tek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186201; c=relaxed/simple;
	bh=WpMPvBXRpRlyaFOIn7pGROjWpXLTkwH63VnXk7H4SmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g5boRfWGHgvIoKMxrcyvkEoTk08qizEnlbEgNqlHyQswUqXCtuVgFThkeigCB1mbkzIZEdc3KinPuRWtxI0lgR5qhbrKYJ5mkGSqYGYbfqVfOVXd5Tw3/qcqr5BEL/LQIRE3yDvuWvHQ4LFGFtpHvmNSCNS1n9FX4xzYgWB0Msg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iUmkz2Ye; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iUmkz2Ye"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1QLUiNP479wpDDQvLt9kbWq0kp4zn1TXVy2Kv7wqRYg=;
	b=iUmkz2YeVPumzRY1DYW0ByIzMcvLl4xdqsfaH17lZD7oQD+rLg/ukgXCnCnqeEoxA1tUNV
	RoaUccWCwKCfobdHpPe8m8QK7LDKMu840Yz7HrwQCb0t7Bn//15vh7wWWeSaDOt1uuE+yG
	Fc0dQjBaiozC+KES0bcoGei6+K0Srl0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-6tebxjjxMWSTDV6lh2lAbg-1; Tue,
 19 May 2026 06:23:07 -0400
X-MC-Unique: 6tebxjjxMWSTDV6lh2lAbg-1
X-Mimecast-MFC-AGG-ID: 6tebxjjxMWSTDV6lh2lAbg_1779186185
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DA2019560A2;
	Tue, 19 May 2026 10:23:05 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6A9851955D84;
	Tue, 19 May 2026 10:23:01 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>,
	Mina Almasry <almasrymina@google.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 12/36] cifs: [WIP] Rewrite base Rx to put data off the socket into a bvecq
Date: Tue, 19 May 2026 11:21:30 +0100
Message-ID: <20260519102158.592165-13-dhowells@redhat.com>
In-Reply-To: <20260519102158.592165-1-dhowells@redhat.com>
References: <20260519102158.592165-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

[!] Note: This patch is a WIP and doesn't support RDMA yet

Rewrite base Rx to splice incoming data buffers directly the socket into a
bvec-queue based receive queue and then use iov_iter functions to take it
apart.  It can also be decrypted within those buffers.

Non-blocking splice is used to get as many data segments as are available
and can be spliced into the empty slots of the bvecq passed to TCP.  Since
the splice doesn't wait, ->sk_data_ready() is used to sense new PDUs
becoming available.

For the case of RDMA, the smbdirect reassembly should just add buffers to
the receive queue.

We can then offer the iterator to the individual PDU decoders and they can
use copy_from_iter() to extract data.

Special handling is provided for any smb_message that wants it
(e.g. unencrypted READs), such that the headers are copied into heap
objects and then the rest is copied directly from the receive queue into
the target buffer.  This is done incrementally so that reads aren't held up
whilst until all the data is received; further, spent receive buffers are
discarded as soon as possible to prevent holding on to DMA buffer space.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifs_debug.c    |   38 +-
 fs/smb/client/cifs_debug.h    |    3 +-
 fs/smb/client/cifsglob.h      |  106 ++--
 fs/smb/client/cifsproto.h     |   21 +-
 fs/smb/client/cifssmb.c       |   35 +-
 fs/smb/client/connect.c       |  616 ++++++++-----------
 fs/smb/client/smb1debug.c     |   55 +-
 fs/smb/client/smb1encrypt.c   |  111 ++++
 fs/smb/client/smb1maperror.c  |    7 +-
 fs/smb/client/smb1misc.c      |   20 +-
 fs/smb/client/smb1ops.c       |   44 +-
 fs/smb/client/smb1pdu.h       |   62 +-
 fs/smb/client/smb1proto.h     |   43 +-
 fs/smb/client/smb1transport.c | 1042 ++++++++++++++++++++++++++-------
 fs/smb/client/smb2inode.c     |    2 +-
 fs/smb/client/smb2maperror.c  |    3 +-
 fs/smb/client/smb2misc.c      |  358 +++++------
 fs/smb/client/smb2ops.c       |  908 ++++------------------------
 fs/smb/client/smb2pdu.c       |   67 ++-
 fs/smb/client/smb2proto.h     |   25 +-
 fs/smb/client/smb2transport.c |  633 +++++++++++++++++++-
 fs/smb/client/trace.h         |   63 ++
 fs/smb/client/transport.c     |  221 +------
 fs/smb/common/smb2pdu.h       |   30 +
 24 files changed, 2473 insertions(+), 2040 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 2d0d26ee57ce..47dadab67440 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -28,49 +28,13 @@
 #include "cached_dir.h"
 
 void
-cifs_dump_mem(char *label, void *data, int length)
+cifs_dump_mem(const char *label, void *data, int length)
 {
 	pr_debug("%s: dump of %d bytes of data at 0x%p\n", label, length, data);
 	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
 		       data, length, true);
 }
 
-void cifs_dump_mids(struct TCP_Server_Info *server)
-{
-#ifdef CONFIG_CIFS_DEBUG2
-	struct smb_message *smb;
-
-	if (server == NULL)
-		return;
-
-	cifs_dbg(VFS, "Dump pending requests:\n");
-	spin_lock(&server->mid_queue_lock);
-	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
-		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
-			 smb->mid_state,
-			 le16_to_cpu(smb->command),
-			 smb->pid,
-			 smb->callback_data,
-			 smb->mid);
-#ifdef CONFIG_CIFS_STATS2
-		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
-			 smb->large_buf,
-			 smb->resp_buf,
-			 smb->when_received,
-			 jiffies);
-#endif /* STATS2 */
-		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
-			 smb->multiRsp, smb->multiEnd);
-		if (smb->resp_buf) {
-			server->ops->dump_detail(smb->resp_buf,
-						 smb->response_pdu_len, server);
-			cifs_dump_mem("existing buf: ", smb->resp_buf, 62);
-		}
-	}
-	spin_unlock(&server->mid_queue_lock);
-#endif /* CONFIG_CIFS_DEBUG2 */
-}
-
 #ifdef CONFIG_PROC_FS
 static void cifs_debug_tcon(struct seq_file *m, struct cifs_tcon *tcon)
 {
diff --git a/fs/smb/client/cifs_debug.h b/fs/smb/client/cifs_debug.h
index 00650929a133..fbc3ab351e5c 100644
--- a/fs/smb/client/cifs_debug.h
+++ b/fs/smb/client/cifs_debug.h
@@ -14,8 +14,7 @@
 
 #define pr_fmt(fmt) "CIFS: " fmt
 
-void cifs_dump_mem(char *label, void *data, int length);
-void cifs_dump_mids(struct TCP_Server_Info *server);
+void cifs_dump_mem(const char *label, void *data, int length);
 extern bool traceSMB;		/* flag which enables the function below */
 void dump_smb(void *buf, int smb_buf_length);
 #define CIFS_INFO	0x01
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 0f876feb0dbf..7187e304c42e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -35,6 +35,9 @@
 #define CIFS_PORT 445
 #define RFC1001_PORT 139
 
+/* Drop the connection to not overload the server */
+#define MAX_STATUS_IO_TIMEOUT   5
+
 /*
  * The sizes of various internal tables and strings
  */
@@ -331,35 +334,16 @@ struct smb_version_operations {
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	void (*revert_current_mid)(struct TCP_Server_Info *server,
 				   const unsigned int val);
-	/* data offset from read response message */
-	unsigned int (*read_data_offset)(char *);
-	/*
-	 * Data length from read response message
-	 * When in_remaining is true, the returned data length is in
-	 * message field DataRemaining for out-of-band data read (e.g through
-	 * Memory Registration RDMA write in SMBD).
-	 * Otherwise, the returned data length is in message field DataLength.
-	 */
-	unsigned int (*read_data_length)(char *, bool in_remaining);
-	/* map smb to linux error */
-	int (*map_error)(char *, bool);
-	/* find mid corresponding to the response message */
-	struct smb_message *(*find_mid)(struct TCP_Server_Info *server, char *buf);
-	void (*dump_detail)(void *buf, size_t buf_len, struct TCP_Server_Info *ptcp_info);
+	/* Finish receiving a PDU and decrypt and decompress and parse it. */
+	int (*receive_pdu)(struct TCP_Server_Info *server, unsigned int len);
 	void (*clear_stats)(struct cifs_tcon *);
 	void (*print_stats)(struct seq_file *m, struct cifs_tcon *);
 	void (*dump_share_caps)(struct seq_file *, struct cifs_tcon *);
 	/* verify the message */
-	int (*check_message)(char *buf, unsigned int pdu_len, unsigned int len,
-			     struct TCP_Server_Info *server);
-	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
 	int (*handle_cancelled_mid)(struct smb_message *smb, struct TCP_Server_Info *server);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
 				 __u16 epoch, bool *purge_cache);
-	/* process transaction2 response */
-	bool (*check_trans2)(struct smb_message *smb, struct TCP_Server_Info *server,
-			     char *buf, int malformed);
 	/* check if we need to negotiate */
 	bool (*need_neg)(struct TCP_Server_Info *);
 	/* negotiate to the server */
@@ -508,10 +492,6 @@ struct smb_version_operations {
 			 struct cifs_fid *);
 	/* calculate a size of SMB message */
 	unsigned int (*calc_smb_size)(void *buf);
-	/* check for STATUS_PENDING and process the response if yes */
-	bool (*is_status_pending)(char *buf, struct TCP_Server_Info *server);
-	/* check for STATUS_NETWORK_SESSION_EXPIRED */
-	bool (*is_session_expired)(char *);
 	/* send oplock break response */
 	int (*oplock_response)(struct cifs_tcon *tcon, __u64 persistent_fid,
 			       __u64 volatile_fid, __u16 net_fid,
@@ -593,9 +573,6 @@ struct smb_version_operations {
 	/* init transform (compress/encrypt) request */
 	int (*init_transform_rq)(struct TCP_Server_Info *, int num_rqst,
 				 struct smb_rqst *, struct smb_rqst *);
-	int (*is_transform_hdr)(void *buf);
-	int (*receive_transform)(struct TCP_Server_Info *,
-				 struct smb_message **smb, char **, int *);
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
 	int (*next_header)(struct TCP_Server_Info *server, char *buf,
@@ -619,10 +596,6 @@ struct smb_version_operations {
 		      struct fiemap_extent_info *, u64, u64);
 	/* version specific llseek implementation */
 	loff_t (*llseek)(struct file *, struct cifs_tcon *, loff_t, int);
-	/* Check for STATUS_IO_TIMEOUT */
-	bool (*is_status_io_timeout)(char *buf);
-	/* Check for STATUS_NETWORK_NAME_DELETED */
-	bool (*is_network_name_deleted)(char *buf, struct TCP_Server_Info *srv);
 	struct reparse_data_buffer * (*get_reparse_point_buffer)(const struct kvec *rsp_iov,
 								 u32 *plen);
 	struct inode * (*create_reparse_inode)(struct cifs_open_info_data *data,
@@ -690,6 +663,15 @@ struct TCP_Server_Info {
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
 	struct sockaddr_storage srcaddr; /* locally bind to this IP */
+	void (*rx_old_data_ready)(struct sock *sock);
+	void (*rx_old_error_report)(struct sock *sock);
+	wait_queue_head_t	rx_waitq;	/* Wait for data ready */
+	struct netfs_rxqueue	rx_queue;	/* Rx queue grabbed from socket */
+	atomic_t		num_io_timeout;	/* Number of I/O timeout responses received */
+	unsigned long		flags;
+#define SMB_SERVER_NEED_RECONNECT	0	/* Reconnect required */
+#define SMB_SERVER_SESSION_RECONNECT	1	/* Session reconnect required */
+#define SMB_SERVER_DATA_READY		2	/* Data ready notification given */
 #ifdef CONFIG_NET_NS
 	struct net *net;
 #endif
@@ -755,7 +737,6 @@ struct TCP_Server_Info {
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	bool	sec_iakerb;		/* supports pass-through auth for Kerberos (krb5 proxy) */
-	bool	large_buf;		/* is current buffer large? */
 	/* use SMBD connection instead of socket */
 	bool	rdma;
 	/* point to the SMBD connection if RDMA is used instead of socket */
@@ -763,9 +744,6 @@ struct TCP_Server_Info {
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
-	/* Total size of this PDU. Only valid from cifs_demultiplex_thread */
-	unsigned int pdu_size;
-	unsigned int total_read; /* total amount of data read in this pass */
 	atomic_t in_send; /* requests trying to send */
 	atomic_t num_waiters;   /* blocked waiting to get in sendrecv */
 #ifdef CONFIG_CIFS_STATS2
@@ -1669,21 +1647,6 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
 }
 
 
-/*
- * This is the prototype for the mid receive function. This function is for
- * receiving the rest of the SMB frame, starting with the WordCount (which is
- * just after the MID in struct smb_hdr). Note:
- *
- * - This will be called by cifsd, with no locks held.
- * - The mid will still be on the pending_mid_q.
- * - mid->resp_buf will point to the current buffer.
- *
- * Returns zero on a successful receive, or an error. The receive state in
- * the TCP_Server_Info will also be updated.
- */
-typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
-			     struct smb_message *msg);
-
 /*
  * This is the prototype for the mid callback function. This is called once the
  * mid has been received off of the socket. When creating one, take special
@@ -1694,13 +1657,6 @@ typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
  */
 typedef void (*mid_callback_t)(struct TCP_Server_Info *srv, struct smb_message *smb);
 
-/*
- * This is the protopyte for mid handle function. This is called once the mid
- * has been recognized after decryption of the message.
- */
-typedef int (*mid_handle_t)(struct TCP_Server_Info *server,
-			    struct smb_message *smb);
-
 /*
  * Definition of an SMB request message to be transmitted.  These may be
  * chained together and will automatically be turned into compound messages if
@@ -1748,13 +1704,9 @@ struct smb_message {
 	unsigned long		when_sent;	/* time when smb send finished */
 	unsigned long		when_received;	/* when demux complete (taken off wire) */
 #endif
-	mid_receive_t		receive;	/* call receive callback */
 	mid_callback_t		callback;	/* call completion callback */
-	mid_handle_t		handle;		/* call handle mid callback */
 	void			*callback_data;	/* general purpose pointer for callback */
 	struct task_struct	*creator;
-	void			*resp_buf;	/* pointer to received SMB header */
-	unsigned int		resp_buf_size;
 	int			mid_state;	/* wish this were enum but can not pass to wait_event */
 	int			mid_rc;		/* rc for MID_RC */
 	unsigned int		optype;		/* operation type */
@@ -1765,6 +1717,8 @@ struct smb_message {
 	bool			multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool			multiEnd:1;	/* both received */
 	bool			decrypted:1;	/* decrypted entry */
+	bool			sig_checked:1;	/* T if sig already checked */
+	bool			copy_to_bufs:1;	/* Copy to prepared buffer in response_iter */
 
 	/* Request details */
 	u8			command_trace;	/* enum smb_command_trace - Command trace ID */
@@ -1772,11 +1726,17 @@ struct smb_message {
 	s16			pre_offset;	/* Offset of pre-headers from ->body (negative) */
 	unsigned int		total_len;	/* Total length of from hdr_offset onwards */
 	/* Response */
-	u32			response_pdu_len; /* Size of response PDU */
+	//u32			response_pdu_len; /* Size of response PDU */
+	void			*response;	/* Protocol part of response */
+	u32			resp_len;	/* Size of response */
+	u32			resp_data_len;	/* Length of response data */
+	u32			resp_data_offset; /* Offset of response data (or 0) */
+	__le32			status;		/* Completion status */
+	short			error;		/* Linux error */
+	struct iov_iter		response_iter;	/* Data part of response */
+	struct bvecq		*response_data;	/* Storage for response data (or NULL) */
 	/* Compat with old code */
 	struct smb_rqst		rqst;
-	int			*resp_buf_type;
-	struct kvec		*resp_iov;
 };
 
 struct close_cancelled_open {
@@ -2436,4 +2396,20 @@ static inline int cifs_open_create_options(unsigned int oflags, int opts)
 
 #define ALIGN8(x) ALIGN((x), 8)
 
+/*
+ * Received message handling context.
+ */
+struct cifs_receive {
+	void		*response;	/* Response buffer */
+	unsigned char	resp_buf_type;	/* Type of response buffer (CIFS_*_BUFFER) */
+	bool		malformed:1;	/* Message is malformed */
+	short		error;		/* Error code */
+	unsigned int	msg_len;	/* Size of current (sub-)message */
+	unsigned int	hdr_len;	/* Length of header */
+	unsigned int	data_offset;	/* Offset of data part */
+	unsigned int	data_len;	/* Length of data part */
+	unsigned int	calc_len;	/* Calculated length */
+	unsigned int	extracted;	/* How much of msg_len had been extracted */
+};
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 9c60fffcf53d..8dedfd677f8d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -88,17 +88,14 @@ void smb_put_messages(struct smb_message *smb);
 void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 void cifs_wake_up_task(struct TCP_Server_Info *server,
 		       struct smb_message *smb);
-int cifs_handle_standard(struct TCP_Server_Info *server,
-			 struct smb_message *smb);
 char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
 bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
-int cifs_discard_remaining_data(struct TCP_Server_Info *server);
 int cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		    mid_receive_t receive, mid_callback_t callback,
-		    mid_handle_t handle, void *cbdata, const int flags,
-		    const struct cifs_credits *exist_credits);
+		    mid_callback_t callback, void *cbdata, const int flags,
+		    const struct cifs_credits *exist_credits,
+		    struct iov_iter *resp_buf);
 struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
 int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   struct TCP_Server_Info *server, struct smb_rqst *rqst,
@@ -227,12 +224,7 @@ unsigned int setup_special_user_owner_ACE(struct smb_ace *pntace);
 
 void dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb,
 		 bool malformed);
-int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
-			  unsigned int to_read);
-ssize_t cifs_discard_from_socket(struct TCP_Server_Info *server,
-				 size_t to_read);
-int cifs_read_iter_from_socket(struct TCP_Server_Info *server,
-			       struct iov_iter *iter, unsigned int to_read);
+bool allocate_buffers(struct TCP_Server_Info *server);
 int cifs_setup_cifs_sb(struct cifs_sb_info *cifs_sb);
 void cifs_mount_put_conns(struct cifs_mount_ctx *mnt_ctx);
 int cifs_mount_get_session(struct cifs_mount_ctx *mnt_ctx);
@@ -609,4 +601,9 @@ find_readable_file(struct cifsInodeInfo *cinode, unsigned int find_flags)
 	return __find_readable_file(cinode, find_flags, 0);
 }
 
+int smb_rxqueue_refill(struct TCP_Server_Info *server, struct netfs_rxqueue *rxq,
+		       size_t min_size);
+int smb_rxqueue_consume(struct TCP_Server_Info *server, struct netfs_rxqueue *rxq,
+			size_t amount);
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 25f6289ee72f..c537cc3e66c8 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -336,6 +336,8 @@ static int validate_t2(struct smb_t2_rsp *pSMB)
 {
 	unsigned int total_size;
 
+	return 0; /* Checking now done in reception routine. */
+
 	/* check for plausible wct */
 	if (pSMB->hdr.WordCount < 10)
 		goto vt2_err;
@@ -428,7 +430,7 @@ CIFSSMBNegotiate(const unsigned int xid,
 	SMB_NEGOTIATE_RSP *pSMBr;
 	unsigned int in_len;
 	int rc = 0;
-	int bytes_returned;
+	int bytes_returned = 0;
 	int i;
 	u16 count;
 
@@ -768,8 +770,8 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov[0].iov_len = in_len;
 	iov[0].iov_base = smb;
 
-	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
-			     server, CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL);
+	rc = cifs_call_async(server, &rqst, cifs_echo_callback, server,
+			     CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL, NULL);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
@@ -1466,8 +1468,11 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct inode *inode = &ictx->inode;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = 1};
+	struct kvec iov = {
+		.iov_base = smb->response,
+		.iov_len  = smb->resp_len,
+	};
+	struct smb_rqst rqst = { .rq_iov = &iov, .rq_nvec = 1 };
 	struct cifs_credits credits = {
 		.value = 1,
 		.instance = 0,
@@ -1489,12 +1494,13 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
+		rdata->got_bytes = smb->resp_data_len;
 		if (server->sign) {
 			int rc = 0;
 
-			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
+			iov_iter_truncate(&rqst.rq_iter, smb->resp_data_len);
 			rc = cifs_verify_signature(&rqst, server,
-						  smb->sequence_number);
+						   smb->sequence_number);
 			if (rc)
 				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
 					 rc);
@@ -1585,6 +1591,7 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 1 };
+	struct iov_iter iter;
 	unsigned int in_len;
 
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%zu\n",
@@ -1636,8 +1643,12 @@ cifs_async_readv(struct cifs_io_subrequest *rdata)
 			      tcon->tid, tcon->ses->Suid,
 			      rdata->subreq.start, rdata->subreq.len);
 
-	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
-			     cifs_readv_callback, NULL, rdata, 0, NULL);
+	iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
+			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
+			    rdata->subreq.content.offset, rdata->subreq.len);
+
+	rc = cifs_call_async(tcon->ses->server, &rqst,
+			     cifs_readv_callback, rdata, 0, NULL, &iter);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
@@ -1889,7 +1900,7 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	struct cifs_io_subrequest *wdata = smb->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
-	WRITE_RSP *rsp = (WRITE_RSP *)smb->resp_buf;
+	WRITE_RSP *rsp = (WRITE_RSP *)smb->response;
 	struct cifs_credits credits = {
 		.value = 1,
 		.instance = 0,
@@ -2030,8 +2041,8 @@ cifs_async_writev(struct cifs_io_subrequest *wdata)
 		iov[0].iov_len += 4; /* pad bigger by four bytes */
 	}
 
-	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
-			     cifs_writev_callback, NULL, wdata, 0, NULL);
+	rc = cifs_call_async(tcon->ses->server, &rqst,
+			     cifs_writev_callback, wdata, 0, NULL, NULL);
 	/* Can't touch wdata if rc == 0 */
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3d7e279ba149..4a3ebbd6d71b 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -29,8 +29,10 @@
 #include <linux/module.h>
 #include <keys/user-type.h>
 #include <net/ipv6.h>
+#include <net/tcp.h>
 #include <linux/parser.h>
 #include <linux/bvec.h>
+#include <trace/events/sock.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_unicode.h"
@@ -54,9 +56,6 @@
 #define TLINK_ERROR_EXPIRE	(1 * HZ)
 #define TLINK_IDLE_EXPIRE	(600 * HZ)
 
-/* Drop the connection to not overload the server */
-#define MAX_STATUS_IO_TIMEOUT   5
-
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
@@ -66,6 +65,33 @@ static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
 static void mchan_mount_free(struct mchan_mount *mchan_mount);
 static void mchan_mount_work_fn(struct work_struct *work);
 
+static void smb_tcp_data_ready(struct sock *sk)
+{
+	struct TCP_Server_Info *server = READ_ONCE(sk->sk_user_data);
+
+	trace_sk_data_ready(sk);
+	trace_smb3_data_ready(0);
+	if (!server)
+		return;
+
+	set_bit(SMB_SERVER_DATA_READY, &server->flags);
+	smp_mb__after_atomic();
+	wake_up(&server->rx_waitq);
+	server->rx_old_data_ready(sk);
+}
+
+static void smb_tcp_error_report(struct sock *sk)
+{
+	struct TCP_Server_Info *server = READ_ONCE(sk->sk_user_data);
+
+	if (!server)
+		return;
+	set_bit(SMB_SERVER_DATA_READY, &server->flags);
+	smp_mb__after_atomic();
+	wake_up(&server->rx_waitq);
+	server->rx_old_error_report(sk);
+}
+
 /*
  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
  * get their ip addresses changed at some point.
@@ -310,6 +336,15 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
 		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n", server->ssocket->state,
 			 server->ssocket->flags);
+
+		kernel_sock_shutdown(server->ssocket, SHUT_RD);
+		wake_up(&server->rx_waitq);
+
+		server->ssocket->sk->sk_data_ready   = server->rx_old_data_ready;
+		server->ssocket->sk->sk_error_report = server->rx_old_error_report;
+		smp_wmb();
+		server->ssocket->sk->sk_user_data = NULL;
+
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	} else if (cifs_rdma_enabled(server)) {
@@ -322,6 +357,8 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	server->session_key.len = 0;
 	server->lstrp = jiffies;
 
+	netfs_rxqueue_discard(&server->rx_queue, server->rx_queue.qsize);
+
 	/* mark submitted MIDs for retry and issue callback */
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
@@ -638,7 +675,7 @@ cifs_echo_request(struct work_struct *work)
 	queue_delayed_work(cifsiod_wq, &server->echo, server->echo_interval);
 }
 
-static bool
+bool
 allocate_buffers(struct TCP_Server_Info *server)
 {
 	if (!server->bigbuf) {
@@ -649,9 +686,6 @@ allocate_buffers(struct TCP_Server_Info *server)
 			/* retry will check if exiting */
 			return false;
 		}
-	} else if (server->large_buf) {
-		/* we are reusing a dirty large buf, clear its start */
-		memset(server->bigbuf, 0, HEADER_SIZE(server));
 	}
 
 	if (!server->smallbuf) {
@@ -662,10 +696,6 @@ allocate_buffers(struct TCP_Server_Info *server)
 			/* retry will check if exiting */
 			return false;
 		}
-		/* beginning of smb buffer is cleared in our buf_get */
-	} else {
-		/* if existing small buf clear beginning */
-		memset(server->smallbuf, 0, HEADER_SIZE(server));
 	}
 
 	return true;
@@ -728,103 +758,10 @@ zero_credits(struct TCP_Server_Info *server)
 	return false;
 }
 
-static int
-cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
-{
-	int length = 0;
-	int total_read;
-
-	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
-		try_to_freeze();
-
-		/* reconnect if no credits and no requests in flight */
-		if (zero_credits(server)) {
-			cifs_reconnect(server, false);
-			return -ECONNABORTED;
-		}
-
-		if (server_unresponsive(server))
-			return -ECONNABORTED;
-		if (cifs_rdma_enabled(server) && server->smbd_conn)
-			length = smbd_recv(server->smbd_conn, smb_msg);
-		else
-			length = sock_recvmsg(server->ssocket, smb_msg, 0);
-
-		spin_lock(&server->srv_lock);
-		if (server->tcpStatus == CifsExiting) {
-			spin_unlock(&server->srv_lock);
-			return -ESHUTDOWN;
-		}
-
-		if (server->tcpStatus == CifsNeedReconnect) {
-			spin_unlock(&server->srv_lock);
-			cifs_reconnect(server, false);
-			return -ECONNABORTED;
-		}
-		spin_unlock(&server->srv_lock);
-
-		if (length == -ERESTARTSYS ||
-		    length == -EAGAIN ||
-		    length == -EINTR) {
-			/*
-			 * Minimum sleep to prevent looping, allowing socket
-			 * to clear and app threads to set tcpStatus
-			 * CifsNeedReconnect if server hung.
-			 */
-			usleep_range(1000, 2000);
-			length = 0;
-			continue;
-		}
-
-		if (length <= 0) {
-			cifs_dbg(FYI, "Received no data or error: %d\n", length);
-			cifs_reconnect(server, false);
-			return -ECONNABORTED;
-		}
-	}
-	return total_read;
-}
-
-int
-cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
-		      unsigned int to_read)
-{
-	struct msghdr smb_msg = {};
-	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
-
-	iov_iter_kvec(&smb_msg.msg_iter, ITER_DEST, &iov, 1, to_read);
-
-	return cifs_readv_from_socket(server, &smb_msg);
-}
-
-ssize_t
-cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
-{
-	struct msghdr smb_msg = {};
-
-	/*
-	 *  iov_iter_discard already sets smb_msg.type and count and iov_offset
-	 *  and cifs_readv_from_socket sets msg_control and msg_controllen
-	 *  so little to initialize in struct msghdr
-	 */
-	iov_iter_discard(&smb_msg.msg_iter, ITER_DEST, to_read);
-
-	return cifs_readv_from_socket(server, &smb_msg);
-}
-
-int
-cifs_read_iter_from_socket(struct TCP_Server_Info *server, struct iov_iter *iter,
-			   unsigned int to_read)
+static bool smb_decode_rfc1002(struct TCP_Server_Info *server, u32 rfc1002_hdr)
 {
-	struct msghdr smb_msg = { .msg_iter = *iter };
+	u8 type = rfc1002_hdr >> 24;
 
-	iov_iter_truncate(&smb_msg.msg_iter, to_read);
-	return cifs_readv_from_socket(server, &smb_msg);
-}
-
-static bool
-is_smb_response(struct TCP_Server_Info *server, unsigned char type)
-{
 	/*
 	 * The first byte big endian of the length field,
 	 * is actually not part of the length but the type
@@ -850,7 +787,8 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		 * exclusively in ip_rfc1001_connect() function.
 		 */
 		cifs_server_dbg(VFS, "RFC 1002 positive session response (unexpected)\n");
-		cifs_reconnect(server, true);
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		set_bit(SMB_SERVER_SESSION_RECONNECT, &server->flags);
 		break;
 	case RFC1002_NEGATIVE_SESSION_RESPONSE:
 		/*
@@ -934,16 +872,20 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 				msleep(2000);
 		} else {
 			cifs_server_dbg(VFS, "RFC 1002 negative session response (unexpected)\n");
-			cifs_reconnect(server, true);
+			set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+			set_bit(SMB_SERVER_SESSION_RECONNECT, &server->flags);
 		}
 		break;
 	case RFC1002_RETARGET_SESSION_RESPONSE:
 		cifs_server_dbg(VFS, "RFC 1002 retarget session response (unexpected)\n");
-		cifs_reconnect(server, true);
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		set_bit(SMB_SERVER_SESSION_RECONNECT, &server->flags);
 		break;
 	default:
 		cifs_server_dbg(VFS, "RFC 1002 unknown response type 0x%x\n", type);
-		cifs_reconnect(server, true);
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		set_bit(SMB_SERVER_SESSION_RECONNECT, &server->flags);
+		break;
 	}
 
 	return false;
@@ -974,41 +916,6 @@ dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb, bool malfor
 	}
 }
 
-static unsigned int
-smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
-{
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
-
-	/*
-	 * SMB1 does not use credits.
-	 */
-	if (is_smb1(server))
-		return 0;
-
-	return le16_to_cpu(shdr->CreditRequest);
-}
-
-static void
-handle_mid(struct smb_message *smb, struct TCP_Server_Info *server,
-	   char *buf, int malformed)
-{
-	if (server->ops->check_trans2 &&
-	    server->ops->check_trans2(smb, server, buf, malformed))
-		return;
-	smb->credits_received = smb2_get_credits_from_hdr(buf, server);
-	smb->resp_buf = buf;
-	smb->large_buf = server->large_buf;
-	/* Was previous buf put in mpx struct for multi-rsp? */
-	if (!smb->multiRsp) {
-		/* smb buffer will be freed by user thread */
-		if (server->large_buf)
-			server->bigbuf = NULL;
-		else
-			server->smallbuf = NULL;
-	}
-	dequeue_mid(server, smb, malformed);
-}
-
 int
 cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 {
@@ -1090,6 +997,14 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	if (cifs_rdma_enabled(server))
 		smbd_destroy(server);
 	if (server->ssocket) {
+		kernel_sock_shutdown(server->ssocket, SHUT_RD);
+		wake_up(&server->rx_waitq);
+
+		server->ssocket->sk->sk_data_ready   = server->rx_old_data_ready;
+		server->ssocket->sk->sk_error_report = server->rx_old_error_report;
+		smp_wmb();
+		server->ssocket->sk->sk_user_data = NULL;
+
 		sock_release(server->ssocket);
 		server->ssocket = NULL;
 	}
@@ -1149,120 +1064,210 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		mempool_resize(cifs_req_poolp, length + cifs_min_rcv);
 }
 
-static int
-standard_receive3(struct TCP_Server_Info *server, struct smb_message *smb)
+/*
+ * Splice buffers from a socket.
+ */
+static int smb_splice_from_socket(struct TCP_Server_Info *server, struct bvecq *bq)
 {
 	int length;
-	char *buf = server->smallbuf;
-	unsigned int pdu_length = server->pdu_size;
 
-	/* make sure this will fit in a large buffer */
-	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
-		cifs_server_dbg(VFS, "SMB response too long (%u bytes)\n", pdu_length);
-		cifs_reconnect(server, true);
-		return -ECONNABORTED;
-	}
+	try_to_freeze();
 
-	/* switch to large buffer if too big for a small one */
-	if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE) {
-		server->large_buf = true;
-		memcpy(server->bigbuf, buf, server->total_read);
-		buf = server->bigbuf;
+#if 0
+	/* reconnect if no credits and no requests in flight */
+	if (zero_credits(server)) {
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		return -ECONNABORTED;
 	}
+#endif
 
-	/* now read the rest */
-	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				       pdu_length - MID_HEADER_SIZE(server));
+	if (server_unresponsive(server))
+		return -ECONNABORTED;
 
-	if (length < 0)
-		return length;
-	server->total_read += length;
+#if 0
+	if (cifs_rdma_enabled(server) && server->smbd_conn)
+		length = smbd_recv(server->smbd_conn, smb_msg);
+	else
+#endif
+		length = netfs_tcp_splice_to_bvecq(server->ssocket, bq, INT_MAX);
+	trace_smb3_tcp_splice(length);
 
-	dump_smb(buf, server->total_read);
+	spin_lock(&server->srv_lock);
+	if (server->tcpStatus == CifsExiting) {
+		spin_unlock(&server->srv_lock);
+		return -ESHUTDOWN;
+	}
 
-	return cifs_handle_standard(server, smb);
+	if (server->tcpStatus == CifsNeedReconnect) {
+		spin_unlock(&server->srv_lock);
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		return -ECONNABORTED;
+	}
+	spin_unlock(&server->srv_lock);
+	return length;
 }
 
-int
-cifs_handle_standard(struct TCP_Server_Info *server, struct smb_message *smb)
+/*
+ * Refill the receive queue.  Whilst the peer may send PDUs in separate TCP
+ * packets, it's possible that the local NIC may join them back together if
+ * doing receive offload.
+ *
+ * If min_size is 0, it will splice anything it can quickly and immediately
+ * grab out of the queue, but it will not wait.
+ */
+int smb_rxqueue_refill(struct TCP_Server_Info *server, struct netfs_rxqueue *rxq,
+		       size_t min_size)
 {
-	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
-	int rc;
-
-	/*
-	 * We know that we received enough to get to the MID as we
-	 * checked the pdu_length earlier. Now check to see
-	 * if the rest of the header is OK.
-	 *
-	 * 48 bytes is enough to display the header and a little bit
-	 * into the payload for debugging purposes.
-	 */
-	rc = server->ops->check_message(buf, server->pdu_size,
-					server->total_read, server);
-	if (rc)
-		cifs_dump_mem("Bad SMB: ", buf,
-			min_t(unsigned int, server->total_read, 48));
+	struct bvecq *add_to = rxq->add_to;
+	unsigned int got = 0;
+	size_t qsize = rxq->qsize;
+	int rc = 0;
 
-	if (server->ops->is_session_expired &&
-	    server->ops->is_session_expired(buf)) {
-		cifs_reconnect(server, true);
-		return -1;
+	if (!rxq->refillable) {
+		WARN_ON(min_size > qsize);
+		return 0;
 	}
+	if (qsize >= min_size && min_size > 0)
+		return 0;
 
-	if (server->ops->is_status_pending &&
-	    server->ops->is_status_pending(buf, server))
-		return -1;
+	do {
+		if (!add_to || add_to->nr_slots == add_to->max_slots) {
+			struct bvecq *b;
+			unsigned int nr_bv = (2048 - sizeof(*add_to)) / sizeof(add_to->bv[0]);
+
+			b = netfs_alloc_rx_bvecq(nr_bv);
+			b->prev = add_to;
+			if (!add_to)
+				rxq->take_from = b;
+			else
+				add_to->next = b;
+			add_to = b;
+		}
 
-	if (!smb)
-		return rc;
+		rc = smb_splice_from_socket(server, add_to);
+		if (rc > 0) {
+			qsize += rc;
+			got += rc;
+			rc = 0;
+			continue;
+		}
 
-	handle_mid(smb, server, buf, rc);
+		switch (rc) {
+		case -EAGAIN:
+		case -EINTR:
+		case -ERESTARTSYS:
+			wait_event_killable(server->rx_waitq,
+					    test_bit(SMB_SERVER_DATA_READY, &server->flags));
+			clear_bit(SMB_SERVER_DATA_READY, &server->flags);
+			rc = 0;
+			continue;
+		default:
+			cifs_dbg(FYI, "Received no data or error: %d\n", rc);
+			set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+			rc = -ECONNABORTED;
+			goto out;
+		}
+	} while (qsize < min_size);
+
+out:
+	rxq->add_to = add_to;
+	rxq->qsize = qsize;
+	if (min_size == 0)
+		rc = got > 0 ? 0 : rc;
+	else
+		rc = qsize >= min_size ? 0 : rc;
+	return rc;
+}
+
+/*
+ * Consume received data by receiving it and then discarding it.
+ */
+int smb_rxqueue_consume(struct TCP_Server_Info *server,
+			struct netfs_rxqueue *rxq, size_t amount)
+{
+	while (amount) {
+		size_t part = umin(amount, rxq->qsize);
+		int rc;
+
+		amount -= part;
+		netfs_rxqueue_discard(rxq, part);
+
+		if (!amount)
+			break;
+
+		rc = smb_rxqueue_refill(server, rxq, 1);
+		if (rc < 0)
+			return rc;
+	}
 	return 0;
 }
 
-static void
-smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
+/*
+ * Receive a PDU from a socket and place it into a bvec queue.  This is then
+ * decrypted and handed off for distribution to the reply decoders.
+ */
+static void smb_receive_pdu(struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
-	int scredits, in_flight;
+	struct netfs_rxqueue *rxq = &server->rx_queue;
+	unsigned int pdu_len;
+	__be32 rfc1002_be32;
+	u32 rfc1002_hdr;
+	int rc;
 
-	/*
-	 * SMB1 does not use credits.
-	 */
-	if (is_smb1(server))
+	/* TODO: If smbdirect, decant the reassembly queue into the bvecq. */
+
+	rxq->refillable = true;
+	rxq->pdu_remain = 4;
+	rxq->msg_id = 0;
+
+	/* Read the RFC1002 header. */
+	rc = smb_rxqueue_refill(server, rxq, 4);
+	if (rc < 0)
 		return;
 
-	if (shdr->CreditRequest) {
-		spin_lock(&server->req_lock);
-		server->credits += le16_to_cpu(shdr->CreditRequest);
-		scredits = server->credits;
-		in_flight = server->in_flight;
-		spin_unlock(&server->req_lock);
-		wake_up(&server->request_q);
+	/* Extract the RFC1002 header. */
+	if (netfs_rxqueue_read(rxq, &rfc1002_be32, 0, sizeof(rfc1002_be32)) !=
+	    sizeof(rfc1002_be32)) {
+		cifs_dbg(FYI, "copy_from_iter() failed\n");
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		return;
+	}
+
+	rfc1002_hdr = be32_to_cpu(rfc1002_be32);
+	pdu_len = rfc1002_hdr & 0xffffff;
+	netfs_rxqueue_discard(rxq, 4);
+
+	rxq->pdu_remain = pdu_len;
 
-		trace_smb3_hdr_credits(server->current_mid,
-				server->conn_id, server->hostname, scredits,
-				le16_to_cpu(shdr->CreditRequest), in_flight);
-		cifs_server_dbg(FYI, "%s: added %u credits total=%d\n",
-				__func__, le16_to_cpu(shdr->CreditRequest),
-				scredits);
+	trace_smb3_rx_pdu(rxq);
+
+	if (smb_decode_rfc1002(server, rfc1002_hdr)) {
+		/* Normal session message. */
+		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_len);
+
+		rc = server->ops->receive_pdu(server, pdu_len);
+		if (rc < 0)
+			cifs_dbg(FYI, "->receive_pdu() = %d\n", rc);
+
+		if (rxq->pdu_remain)
+			cifs_dbg(FYI, "PDU not wholly consumed (%x)\n",
+				 rxq->pdu_remain);
 	}
-}
 
+	if (rxq->pdu_remain)
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+}
 
+/*
+ * TCP message receive loop.
+ */
 static int
 cifs_demultiplex_thread(void *p)
 {
-	int i, num_smbs, length;
 	struct TCP_Server_Info *server = p;
-	unsigned int pdu_length;
-	unsigned int next_offset;
-	char *buf = NULL;
 	struct task_struct *task_to_wake = NULL;
-	struct smb_message *smbs[MAX_COMPOUND];
-	char *bufs[MAX_COMPOUND];
-	unsigned int noreclaim_flag, num_io_timeout = 0;
-	bool pending_reconnect = false;
+	unsigned int noreclaim_flag;
+	int length;
 
 	noreclaim_flag = memalloc_noreclaim_save();
 	cifs_dbg(FYI, "Demultiplex PID: %d\n", task_pid_nr(current));
@@ -1280,152 +1285,15 @@ cifs_demultiplex_thread(void *p)
 		if (!allocate_buffers(server))
 			continue;
 
-		server->large_buf = false;
-		buf = server->smallbuf;
-		pdu_length = 4; /* enough to get RFC1001 header */
-
-		length = cifs_read_from_socket(server, buf, pdu_length);
-		if (length < 0)
-			continue;
-
-		server->total_read = 0;
-
-		/*
-		 * The right amount was read from socket - 4 bytes,
-		 * so we can now interpret the length field.
-		 */
-		pdu_length = be32_to_cpup(((__be32 *)buf)) & 0xffffff;
-
-		cifs_dbg(FYI, "RFC1002 header 0x%x\n", pdu_length);
-		if (!is_smb_response(server, buf[0]))
-			continue;
-
-		pending_reconnect = false;
-next_pdu:
-		server->pdu_size = pdu_length;
-
-		/* make sure we have enough to get to the MID */
-		if (server->pdu_size < MID_HEADER_SIZE(server)) {
-			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
-				 server->pdu_size);
-			cifs_reconnect(server, true);
-			continue;
-		}
-
-		/* read down to the MID */
-		length = cifs_read_from_socket(server, buf,
-					       MID_HEADER_SIZE(server));
-		if (length < 0)
-			continue;
-		server->total_read += length;
-
-		if (server->ops->next_header) {
-			if (server->ops->next_header(server, buf, &next_offset)) {
-				cifs_dbg(VFS, "%s: malformed response (next_offset=%u)\n",
-					 __func__, next_offset);
-				cifs_reconnect(server, true);
-				continue;
-			}
-			if (next_offset)
-				server->pdu_size = next_offset;
-		}
-
-		memset(smbs, 0, sizeof(smbs));
-		memset(bufs, 0, sizeof(bufs));
-		num_smbs = 0;
-
-		if (server->ops->is_transform_hdr &&
-		    server->ops->receive_transform &&
-		    server->ops->is_transform_hdr(buf)) {
-			length = server->ops->receive_transform(server,
-								smbs,
-								bufs,
-								&num_smbs);
-		} else {
-			smbs[0] = server->ops->find_mid(server, buf);
-			bufs[0] = buf;
-			num_smbs = 1;
-
-			if (smbs[0])
-				smbs[0]->response_pdu_len = pdu_length;
-			if (!smbs[0] || !smbs[0]->receive)
-				length = standard_receive3(server, smbs[0]);
-			else
-				length = smbs[0]->receive(server, smbs[0]);
-		}
-
-		if (length < 0) {
-			for (i = 0; i < num_smbs; i++)
-				if (smbs[i])
-					release_mid(server, smbs[i]);
-			continue;
-		}
-
-		if (server->ops->is_status_io_timeout &&
-		    server->ops->is_status_io_timeout(buf)) {
-			num_io_timeout++;
-			if (num_io_timeout > MAX_STATUS_IO_TIMEOUT) {
-				cifs_server_dbg(VFS,
-						"Number of request timeouts exceeded %d. Reconnecting",
-						MAX_STATUS_IO_TIMEOUT);
-
-				pending_reconnect = true;
-				num_io_timeout = 0;
-			}
-		}
-
-		server->lstrp = jiffies;
-
-		for (i = 0; i < num_smbs; i++) {
-			if (smbs[i] != NULL) {
-				smbs[i]->resp_buf_size = server->pdu_size;
-
-				if (bufs[i] != NULL) {
-					if (server->ops->is_network_name_deleted &&
-					    server->ops->is_network_name_deleted(bufs[i],
-										 server)) {
-						cifs_server_dbg(FYI,
-								"Share deleted. Reconnect needed");
-					}
-				}
-
-				if (!smbs[i]->multiRsp || smbs[i]->multiEnd)
-					mid_execute_callback(server, smbs[i]);
-
-				release_mid(server, smbs[i]);
-			} else if (server->ops->is_oplock_break &&
-				   server->ops->is_oplock_break(bufs[i],
-								server)) {
-				smb2_add_credits_from_hdr(bufs[i], server);
-				cifs_dbg(FYI, "Received oplock break\n");
-			} else {
-				cifs_server_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
-						atomic_read(&mid_count));
-				cifs_dump_mem("Received Data is: ", bufs[i],
-					      HEADER_SIZE(server));
-				smb2_add_credits_from_hdr(bufs[i], server);
-#ifdef CONFIG_CIFS_DEBUG2
-				if (server->ops->dump_detail)
-					server->ops->dump_detail(bufs[i], pdu_length,
-								 server);
-				cifs_dump_mids(server);
-#endif /* CIFS_DEBUG2 */
-			}
-		}
-
-		if (pdu_length > server->pdu_size) {
-			if (!allocate_buffers(server))
-				continue;
-			pdu_length -= server->pdu_size;
-			server->total_read = 0;
-			server->large_buf = false;
-			buf = server->smallbuf;
-			goto next_pdu;
-		}
+		smb_receive_pdu(server);
 
 		/* do this reconnect at the very end after processing all MIDs */
-		if (pending_reconnect)
-			cifs_reconnect(server, true);
+		if (test_and_clear_bit(SMB_SERVER_NEED_RECONNECT, &server->flags)) {
+			bool mark_sess = test_and_clear_bit(SMB_SERVER_SESSION_RECONNECT,
+							    &server->flags);
+			cifs_reconnect(server, mark_sess);
+		}
+		cond_resched();
 
 	} /* end while !EXITING */
 
@@ -1800,6 +1668,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		spin_unlock(&cifs_tcp_ses_lock);
 		tcp_ses->primary_server = primary_server;
 	}
+	init_waitqueue_head(&tcp_ses->rx_waitq);
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
 	INIT_LIST_HEAD(&tcp_ses->pending_mid_q);
@@ -3425,6 +3294,13 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	}
 	trace_smb3_connect_done(server->hostname, server->conn_id, &server->dstaddr);
 
+	server->ssocket->sk->sk_user_data = server;
+	smp_wmb();
+	server->rx_old_data_ready   = server->ssocket->sk->sk_data_ready;
+	server->rx_old_error_report = server->ssocket->sk->sk_error_report;
+	server->ssocket->sk->sk_data_ready   = smb_tcp_data_ready;
+	server->ssocket->sk->sk_error_report = smb_tcp_error_report;
+
 	/*
 	 * Establish RFC1001 NetBIOS session when it was explicitly requested
 	 * by mount option -o nbsessinit, or when connecting to default RFC1001
diff --git a/fs/smb/client/smb1debug.c b/fs/smb/client/smb1debug.c
index e2d013e751e5..048fe6303bc1 100644
--- a/fs/smb/client/smb1debug.c
+++ b/fs/smb/client/smb1debug.c
@@ -9,17 +9,58 @@
 #include "smb1proto.h"
 #include "cifs_debug.h"
 
-void cifs_dump_detail(void *buf, size_t buf_len, struct TCP_Server_Info *server)
-{
 #ifdef CONFIG_CIFS_DEBUG2
-	struct smb_hdr *smb = buf;
+void cifs_dump_detail(struct TCP_Server_Info *server, const struct cifs_receive *recv)
+{
+	const union smb1_response_hdr *h = recv->response;
+	const struct smb_hdr *smb = &h->hdr;
 
 	cifs_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Flgs2: 0x%x Mid: %d Pid: %d Wct: %d\n",
 		 smb->Command, smb->Status.CifsError, smb->Flags,
 		 smb->Flags2, smb->Mid, smb->Pid, smb->WordCount);
-	if (!server->ops->check_message(buf, buf_len, server->total_read, server)) {
-		cifs_dbg(VFS, "smb buf %p len %u\n", smb,
-			 server->ops->calc_smb_size(smb));
+	if (recv->malformed)
+		cifs_dbg(VFS, "smb buf %p len %u\n", smb, recv->calc_len);
+}
+
+void cifs_dump_mids(struct TCP_Server_Info *server)
+{
+	struct smb_message *smb;
+
+	if (server == NULL)
+		return;
+
+	cifs_dbg(VFS, "Dump pending requests:\n");
+	spin_lock(&server->mid_queue_lock);
+	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
+		struct cifs_receive recv = {
+			.response	= smb->response,
+			.msg_len	= smb->resp_len,
+			.error		= smb->error,
+			.data_len	= smb->resp_data_len,
+			.data_offset	= smb->resp_data_offset,
+		};
+
+		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
+			 smb->mid_state,
+			 le16_to_cpu(smb->command),
+			 smb->pid,
+			 smb->callback_data,
+			 smb->mid);
+#ifdef CONFIG_CIFS_STATS2
+		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
+			 smb->large_buf,
+			 smb->response,
+			 smb->when_received,
+			 jiffies);
+#endif /* STATS2 */
+		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
+			 smb->multiRsp, smb->multiEnd);
+		if (recv.response) {
+			cifs_dump_detail(server, &recv);
+			cifs_dump_mem("existing buf: ", recv.response, 62);
+		}
 	}
-#endif /* CONFIG_CIFS_DEBUG2 */
+	spin_unlock(&server->mid_queue_lock);
 }
+
+#endif /* CONFIG_CIFS_DEBUG2 */
diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
index bf10fdeeedca..819c736c26e9 100644
--- a/fs/smb/client/smb1encrypt.c
+++ b/fs/smb/client/smb1encrypt.c
@@ -10,12 +10,34 @@
  */
 
 #include <linux/fips.h>
+#include <linux/iov_iter.h>
 #include <crypto/md5.h>
 #include <crypto/utils.h>
 #include "cifsproto.h"
 #include "smb1proto.h"
 #include "cifs_debug.h"
 
+static size_t cifs_md5_step(void *iter_base, size_t progress, size_t len,
+			    void *priv, void *priv2)
+{
+	struct md5_ctx *ctx = priv;
+
+	md5_update(ctx, iter_base, len);
+	return 0;
+}
+
+static int cifs_md5_iter(struct iov_iter *iter, size_t maxsize,
+			 struct md5_ctx *ctx)
+{
+	size_t did;
+
+	did = iterate_and_advance_kernel(iter, maxsize, ctx, NULL,
+					 cifs_md5_step);
+	if (did != maxsize)
+		return smb_EIO2(smb_eio_trace_md5_iter, did, maxsize);
+	return 0;
+}
+
 /*
  * Calculate and return the CIFS signature based on the mac key and SMB PDU.
  * The 16 byte signature must be allocated by the caller. Note we only use the
@@ -138,3 +160,92 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 		return 0;
 
 }
+
+/*
+ * Calculate and return the CIFS signature based on the mac key and SMB PDU.
+ * The 16 byte signature must be allocated by the caller. Note we only use the
+ * 1st eight bytes and that the smb header signature field on input contains
+ * the sequence number before this function is called. Also, this function
+ * should be called with the server->srv_mutex held.
+ */
+static int cifs_calc_trans_signature(struct TCP_Server_Info *server,
+				     struct cifs_receive *recv,
+				     struct iov_iter *message,
+				     char *signature)
+{
+	struct iov_iter iter;
+	struct md5_ctx ctx;
+	struct kvec kv[1] = {
+		[0].iov_len  = recv->extracted,
+		[0].iov_base = recv->response,
+	};
+	size_t did;
+	int rc;
+
+	md5_init(&ctx);
+	md5_update(&ctx, server->session_key.response, server->session_key.len);
+
+	iov_iter_kvec(&iter, ITER_SOURCE, kv, 3, recv->extracted);
+
+	did = iterate_kvec(&iter, recv->extracted, &ctx, NULL, cifs_md5_step);
+	if (did != recv->extracted)
+		return smb_EIO2(smb_eio_trace_md5_iter, did, recv->extracted);
+
+	iter = *message;
+	rc = cifs_md5_iter(&iter, recv->msg_len - recv->extracted, &ctx);
+	if (rc < 0)
+		return rc;
+
+	md5_final(&ctx, signature);
+	return 0;
+}
+
+/*
+ * Verify the signature on a Trans/Trans2/NTTrans packet that's incompletely
+ * extracted from the Rx queue.  We need to do this in the I/O thread unless we
+ * want to punt the entire reassembly process to cifs_check_receive() as
+ * reassembly will corrupt the signatures.
+ */
+int cifs_verify_trans_signature(struct TCP_Server_Info *server,
+				struct cifs_receive *recv,
+				struct netfs_rxqueue *rxq,
+				__u32 expected_sequence_number)
+{
+	union smb1_response_hdr *h = recv->response;
+	struct iov_iter iter;
+	struct smb_hdr *cifs_pdu = &h->hdr;
+	char what_we_think_sig_should_be[20];
+	char server_response_sig[8];
+	int rc;
+
+	/* BB what if signatures are supposed to be on for session but
+	   server does not send one? BB */
+
+	/* Do not need to verify session setups with signature "BSRSPYL "  */
+	if (memcmp(cifs_pdu->Signature.SecuritySignature, "BSRSPYL ", 8) == 0)
+		cifs_dbg(FYI, "dummy signature received for smb command 0x%x\n",
+			 cifs_pdu->Command);
+
+	/* save off the original signature so we can modify the smb and check
+		its signature against what the server sent */
+	memcpy(server_response_sig, cifs_pdu->Signature.SecuritySignature, 8);
+	cifs_pdu->Signature.Sequence.SequenceNumber =
+					cpu_to_le32(expected_sequence_number);
+	cifs_pdu->Signature.Sequence.Reserved = 0;
+
+	iov_iter_bvec_queue(&iter, ITER_SOURCE, rxq->take_from,
+			    rxq->take_slot, rxq->take_offset,
+			    umin(rxq->qsize, rxq->pdu_remain));
+
+	cifs_server_lock(server);
+	rc = cifs_calc_trans_signature(server, recv, &iter,
+				       what_we_think_sig_should_be);
+	cifs_server_unlock(server);
+
+	if (rc)
+		return rc;
+
+	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8) != 0)
+		return -EACCES;
+	return 0;
+}
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index c84f6256e146..e44a51039776 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -97,9 +97,8 @@ search_mapping_table_ERRSRV(__u16 smb_err)
 }
 
 int
-map_smb_to_linux_error(char *buf, bool logErr)
+map_smb_to_linux_error(const struct smb_hdr *smb, bool logErr)
 {
-	struct smb_hdr *smb = (struct smb_hdr *)buf;
 	int rc = -EIO;	/* if transport error smb error may not be set */
 	__u8 smberrclass;
 	__u16 smberrcode;
@@ -175,9 +174,9 @@ map_and_check_smb_error(struct TCP_Server_Info *server,
 			struct smb_message *smb, bool logErr)
 {
 	int rc;
-	struct smb_hdr *rhdr = (struct smb_hdr *)smb->resp_buf;
+	struct smb_hdr *rhdr = (struct smb_hdr *)smb->response;
 
-	rc = map_smb_to_linux_error((char *)rhdr, logErr);
+	rc = map_smb_to_linux_error(rhdr, logErr);
 	if (rc == -EACCES && !(rhdr->Flags2 & SMBFLG2_ERR_STATUS)) {
 		/* possible ERRBaduid */
 		__u8 class = rhdr->Status.DosError.ErrorClass;
diff --git a/fs/smb/client/smb1misc.c b/fs/smb/client/smb1misc.c
index ba56023010d8..357850e9691f 100644
--- a/fs/smb/client/smb1misc.c
+++ b/fs/smb/client/smb1misc.c
@@ -63,10 +63,11 @@ header_assemble(struct smb_hdr *buffer, char smb_command,
 }
 
 bool
-is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
+smb1_is_valid_oplock_break(union smb1_response_hdr *buf, unsigned int pdu_len,
+			   struct TCP_Server_Info *srv)
 {
-	struct smb_hdr *buf = (struct smb_hdr *)buffer;
-	struct smb_com_lock_req *pSMB = (struct smb_com_lock_req *)buf;
+	struct smb_hdr *hdr = &buf->hdr;
+	struct smb_com_lock_req *pSMB = &buf->oplock_break;
 	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -76,13 +77,12 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 	cifs_dbg(FYI, "Checking for oplock break or dnotify response\n");
 	if ((pSMB->hdr.Command == SMB_COM_NT_TRANSACT) &&
 	   (pSMB->hdr.Flags & SMBFLG_RESPONSE)) {
-		struct smb_com_transaction_change_notify_rsp *pSMBr =
-			(struct smb_com_transaction_change_notify_rsp *)buf;
+		struct smb_com_transaction_change_notify_rsp *pSMBr = &buf->change;
 		struct file_notify_information *pnotify;
 		__u32 data_offset = 0;
-		size_t len = srv->total_read - srv->pdu_size;
+		size_t len = pdu_len;
 
-		if (get_bcc(buf) > sizeof(struct file_notify_information)) {
+		if (get_bcc(hdr) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
 			if (data_offset >
@@ -141,7 +141,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 		if (cifs_ses_exiting(ses))
 			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
-			if (tcon->tid != buf->Tid)
+			if (tcon->tid != hdr->Tid)
 				continue;
 
 			cifs_stats_inc(&tcon->stats.cifs_stats.num_oplock_brks);
@@ -183,7 +183,7 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
 unsigned int
 smbCalcSize(void *buf)
 {
-	struct smb_hdr *ptr = buf;
-	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
+	const struct smb_hdr *ptr = buf;
+	return (sizeof(*ptr) + (2 * ptr->WordCount) +
 		2 /* size of the bcc field */ + get_bcc(ptr));
 }
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index df74975374ee..042d44788321 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -175,7 +175,7 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "issued NT_CANCEL for mid %u, rc = %d\n",
-		 get_mid(in_buf), rc);
+		 le16_to_cpu(in_buf->Mid), rc);
 
 	return rc;
 }
@@ -226,34 +226,17 @@ cifs_compare_fids(struct cifsFileInfo *ob1, struct cifsFileInfo *ob2)
 	return ob1->fid.netfid == ob2->fid.netfid;
 }
 
-static unsigned int
-cifs_read_data_offset(char *buf)
-{
-	READ_RSP *rsp = (READ_RSP *)buf;
-	return le16_to_cpu(rsp->DataOffset);
-}
-
-static unsigned int
-cifs_read_data_length(char *buf, bool in_remaining)
+struct smb_message *
+cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr)
 {
-	READ_RSP *rsp = (READ_RSP *)buf;
-	/* It's a bug reading remaining data for SMB1 packets */
-	WARN_ON(in_remaining);
-	return (le16_to_cpu(rsp->DataLengthHigh) << 16) +
-	       le16_to_cpu(rsp->DataLength);
-}
-
-static struct smb_message *
-cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
-{
-	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct smb_message *smb;
+	u16 mid = le16_to_cpu(shdr->Mid);
 
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
-		if (compare_mid(smb->mid, buf) &&
+		if (smb->mid == mid &&
 		    smb->mid_state == MID_REQUEST_SUBMITTED &&
-		    le16_to_cpu(smb->command) == buf->Command) {
+		    smb->command == shdr->Command) {
 			smb_get_message(smb);
 			spin_unlock(&server->mid_queue_lock);
 			return smb;
@@ -1342,10 +1325,9 @@ cifs_make_node(unsigned int xid, struct inode *inode,
 	}
 }
 
-static bool
-cifs_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
+bool
+cifs_is_network_name_deleted(const struct smb_hdr *shdr, struct TCP_Server_Info *server)
 {
-	struct smb_hdr *shdr = (struct smb_hdr *)buf;
 	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -1388,6 +1370,7 @@ struct smb_version_operations smb1_operations = {
 	.compare_fids = cifs_compare_fids,
 	.setup_request = cifs_setup_request,
 	.setup_async_request = cifs_setup_async_request,
+	.receive_pdu = smb1_receive_pdu,
 	.check_receive = cifs_check_receive,
 	.add_credits = cifs_add_credits,
 	.set_credits = cifs_set_credits,
@@ -1395,17 +1378,9 @@ struct smb_version_operations smb1_operations = {
 	.get_credits = cifs_get_credits,
 	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = cifs_get_next_mid,
-	.read_data_offset = cifs_read_data_offset,
-	.read_data_length = cifs_read_data_length,
-	.map_error = map_smb_to_linux_error,
-	.find_mid = cifs_find_mid,
-	.check_message = checkSMB,
-	.dump_detail = cifs_dump_detail,
 	.clear_stats = cifs_clear_stats,
 	.print_stats = cifs_print_stats,
-	.is_oplock_break = is_valid_oplock_break,
 	.downgrade_oplock = cifs_downgrade_oplock,
-	.check_trans2 = cifs_check_trans2,
 	.need_neg = cifs_need_neg,
 	.negotiate = cifs_negotiate,
 	.negotiate_wsize = smb1_negotiate_wsize,
@@ -1468,7 +1443,6 @@ struct smb_version_operations smb1_operations = {
 	.get_acl_by_fid = get_cifs_acl_by_fid,
 	.set_acl = set_cifs_acl,
 	.make_node = cifs_make_node,
-	.is_network_name_deleted = cifs_is_network_name_deleted,
 };
 
 struct smb_version_values smb1_values = {
diff --git a/fs/smb/client/smb1pdu.h b/fs/smb/client/smb1pdu.h
index 7584e94d9b2b..afd857e9e6ce 100644
--- a/fs/smb/client/smb1pdu.h
+++ b/fs/smb/client/smb1pdu.h
@@ -424,7 +424,7 @@ typedef struct smb_negotiate_rsp {
 #define CAP_EXTENDED_SECURITY  0x80000000
 
 typedef union smb_com_session_setup_andx {
-	struct {		/* request format */
+	struct smb1_session_req {	/* request format */
 		struct smb_hdr hdr;	/* wct = 12 */
 		__u8 AndXCommand;
 		__u8 AndXReserved;
@@ -443,7 +443,7 @@ typedef union smb_com_session_setup_andx {
 	} __packed req;	/* NTLM request format (with
 					extended security */
 
-	struct {		/* request format */
+	struct smb1_session_no_secext_req {	/* request format */
 		struct smb_hdr hdr;	/* wct = 13 */
 		__u8 AndXCommand;
 		__u8 AndXReserved;
@@ -466,7 +466,7 @@ typedef union smb_com_session_setup_andx {
 	} __packed req_no_secext; /* NTLM request format (without
 							extended security */
 
-	struct {		/* default (NTLM) response format */
+	struct smb1_session_rsp {		/* default (NTLM) response format */
 		struct smb_hdr hdr;	/* wct = 4 */
 		__u8 AndXCommand;
 		__u8 AndXReserved;
@@ -481,7 +481,7 @@ typedef union smb_com_session_setup_andx {
 	} __packed resp;	/* NTLM response
 					   (with or without extended sec) */
 
-	struct {		/* request format */
+	struct smb1_old_session_req {		/* request format */
 		struct smb_hdr hdr;	/* wct = 10 */
 		__u8 AndXCommand;
 		__u8 AndXReserved;
@@ -500,7 +500,7 @@ typedef union smb_com_session_setup_andx {
 		/* STRING NativeLanMan */
 	} __packed old_req; /* pre-NTLM (LANMAN2.1) req format */
 
-	struct {		/* default (NTLM) response format */
+	struct smb1_old_session_rsp {		/* default (NTLM) response format */
 		struct smb_hdr hdr;	/* wct = 3 */
 		__u8 AndXCommand;
 		__u8 AndXReserved;
@@ -668,7 +668,7 @@ typedef union smb_com_tree_disconnect {	/* as an alternative can use flag on
 		struct smb_hdr hdr;	/* wct = 0 */
 		__u16 ByteCount;	/* bcc = 0 */
 	} __packed req;
-	struct {
+	struct smb1_tree_disconnect_rsp {
 		struct smb_hdr hdr;	/* wct = 0 */
 		__u16 ByteCount;	/* bcc = 0 */
 	} __packed resp;
@@ -2342,4 +2342,54 @@ typedef struct file_chattr_info {
 } __packed FILE_CHATTR_INFO;  /* ext attributes (chattr, chflags) level 0x206 */
 #endif				/* POSIX */
 
+union smb1_response_hdr {
+	__be32						rfc1002;
+	struct smb_hdr					hdr;
+	struct {
+		struct smb_hdr				hdr;
+		union {
+			u8				short_bcc;
+			__le16				bcc;
+		};
+	} __packed trivial_rsp;
+	struct smb_negotiate_rsp			neg;
+	struct smb1_session_rsp				session;
+	struct smb1_old_session_rsp			old_session;
+	struct smb_com_tconx_rsp			tconx;
+	struct smb_com_tconx_rsp_ext			tconx_ext;
+	struct smb_com_echo_rsp				echo;
+	struct smb_com_logoff_andx_rsp			logoff;
+	struct smb1_tree_disconnect_rsp			tdis;
+	struct smb_com_close_rsp			close;
+	struct smb_com_open_rsp				open;
+	struct smb_com_open_rsp_ext			open_ext;
+	struct smb_com_openx_rsp			openx;
+	struct smb_com_write_rsp			write;
+	struct smb_com_read_rsp				read;
+	struct smb_com_lock_rsp				lock;
+	struct smb_com_copy_rsp				copy;
+	struct smb_com_rename_rsp			rename;
+	struct smb_com_delete_file_rsp			del_file;
+	struct smb_com_delete_directory_rsp		rmdir;
+	struct smb_com_create_directory_rsp		mkdir;
+	struct smb_com_query_information_rsp		qinfo;
+	struct smb_com_setattr_rsp			setattr;
+	struct smb_com_ntransact_rsp			ntransact;
+	struct smb_com_transaction_ioctl_rsp		ioctl;
+	struct smb_com_transaction_change_notify_rsp	change;
+	struct smb_t2_rsp				trans2;
+	struct smb_com_transaction2_qpi_rsp		qpi;
+	struct smb_com_transaction2_spi_rsp		spi;
+	struct smb_com_transaction2_sfi_rsp		sfi;
+	struct smb_t2_qfi_rsp				qfi;
+	struct smb_com_transaction2_ffirst_rsp		ffirst;
+	struct smb_com_transaction2_ffirst_rsp_parms	ffirst_parms;
+	struct smb_com_transaction2_fnext_rsp		fnext;
+	struct smb_com_transaction2_fnext_rsp_parms	fnext_parms;
+	struct smb_com_transaction_qfsi_rsp		qfsi;
+	struct smb_com_transaction2_setfsi_rsp		setfsi;
+	struct smb_com_transaction_get_dfs_refer_rsp	get_dfs_referral;
+	struct smb_com_lock_req				oplock_break;
+};
+
 #endif /* _SMB1PDU_H */
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 4ecf50b0922c..b2ad0ef64051 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -218,8 +218,9 @@ int CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 /*
  * smb1debug.c
  */
-void cifs_dump_detail(void *buf, size_t buf_len,
-		      struct TCP_Server_Info *server);
+void cifs_dump_detail(struct TCP_Server_Info *server,
+		      const struct cifs_receive *recv);
+void cifs_dump_mids(struct TCP_Server_Info *server);
 
 /*
  * smb1encrypt.c
@@ -229,11 +230,15 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 int cifs_verify_signature(struct smb_rqst *rqst,
 			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number);
+int cifs_verify_trans_signature(struct TCP_Server_Info *server,
+				struct cifs_receive *recv,
+				struct netfs_rxqueue *rxq,
+				__u32 expected_sequence_number);
 
 /*
  * smb1maperror.c
  */
-int map_smb_to_linux_error(char *buf, bool logErr);
+int map_smb_to_linux_error(const struct smb_hdr *smb, bool logErr);
 int smb1_init_maperror(void);
 int map_and_check_smb_error(struct TCP_Server_Info *server,
 			    struct smb_message *smb, bool logErr);
@@ -257,7 +262,9 @@ search_mapping_table_ERRSRV_test(__u16 smb_err);
  */
 unsigned int header_assemble(struct smb_hdr *buffer, char smb_command,
 			     const struct cifs_tcon *treeCon, int word_count);
-bool is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv);
+bool
+smb1_is_valid_oplock_break(union smb1_response_hdr *buf, unsigned int pdu_len,
+			   struct TCP_Server_Info *srv);
 unsigned int smbCalcSize(void *buf);
 
 /*
@@ -284,6 +291,7 @@ struct smb_message *cifs_setup_async_request(struct TCP_Server_Info *server,
 					     struct smb_rqst *rqst);
 int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 		     char *in_buf, unsigned int in_len, int flags);
+int checkSMB(const struct TCP_Server_Info *server, struct cifs_receive *recv);
 int cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		       bool log_error);
 struct smb_message *cifs_setup_request(struct cifs_ses *ses,
@@ -296,30 +304,13 @@ int SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		struct smb_hdr *in_buf, unsigned int in_len,
 		struct smb_hdr *out_buf, int *pbytes_returned,
 		const int flags);
-bool cifs_check_trans2(struct smb_message *smb, struct TCP_Server_Info *server,
-		       char *buf, int malformed);
-int checkSMB(char *buf, unsigned int pdu_len, unsigned int total_read,
-	     struct TCP_Server_Info *server);
-
-
-static inline __u16
-get_mid(const struct smb_hdr *smb)
-{
-	return le16_to_cpu(smb->Mid);
-}
-
-static inline bool
-compare_mid(__u16 mid, const struct smb_hdr *smb)
-{
-	return mid == le16_to_cpu(smb->Mid);
-}
 
 #define GETU16(var)  (*((__u16 *)var))	/* BB check for endian issues */
 #define GETU32(var)  (*((__u32 *)var))	/* BB check for endian issues */
 
 /* given a pointer to an smb_hdr, retrieve a void pointer to the ByteCount */
 static inline void *
-BCC(struct smb_hdr *smb)
+BCC(const struct smb_hdr *smb)
 {
 	return (void *)smb + sizeof(*smb) + 2 * smb->WordCount;
 }
@@ -329,9 +320,9 @@ BCC(struct smb_hdr *smb)
 
 /* get the unconverted ByteCount for a SMB packet and return it */
 static inline __u16
-get_bcc(struct smb_hdr *hdr)
+get_bcc(const struct smb_hdr *hdr)
 {
-	__le16 *bc_ptr = (__le16 *)BCC(hdr);
+	const __le16 *bc_ptr = (__le16 *)BCC(hdr);
 
 	return get_unaligned_le16(bc_ptr);
 }
@@ -345,6 +336,10 @@ put_bcc(__u16 count, struct smb_hdr *hdr)
 	put_unaligned_le16(count, bc_ptr);
 }
 
+struct smb_message *cifs_find_mid(struct TCP_Server_Info *server, const struct smb_hdr *shdr);
+bool cifs_is_network_name_deleted(const struct smb_hdr *shdr, struct TCP_Server_Info *server);
+int smb1_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
+
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 #endif /* _SMB1PROTO_H */
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index f38fe262c7ea..776d615f69d3 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -34,7 +34,7 @@
 #define CIFS_MAX_IOV_SIZE 8
 
 static struct smb_message *
-alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
+alloc_mid(const struct smb_hdr *shdr, struct TCP_Server_Info *server)
 {
 	struct smb_message *smb;
 
@@ -47,13 +47,13 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	memset(smb, 0, sizeof(struct smb_message));
 	refcount_set(&smb->ref, 1);
 	spin_lock_init(&smb->mid_lock);
-	smb->mid = get_mid(smb_buffer);
-	smb->pid = current->pid;
-	smb->command = cpu_to_le16(smb_buffer->Command);
-	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
+	smb->mid	= le16_to_cpu(shdr->Mid);
+	smb->pid	= current->pid;
+	smb->command	= cpu_to_le16(shdr->Command);
+	cifs_dbg(FYI, "For smb_command %d\n", shdr->Command);
 	/* easier to use jiffies */
 	/* when mid allocated can be before when sent */
-	smb->when_alloc = jiffies;
+	smb->when_alloc	= jiffies;
 
 	/*
 	 * The default is for the mid to be synchronous, so the
@@ -156,18 +156,18 @@ int
 cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = smb->response_pdu_len;
+	unsigned int len = smb->resp_len;
 
-	dump_smb(smb->resp_buf, min_t(u32, 92, len));
+	dump_smb(smb->response, min_t(u32, 92, len));
 
 	/* convert the length into a more usable form */
-	if (server->sign) {
+	if (server->sign && !smb->sig_checked) {
 		struct kvec iov[1];
 		int rc = 0;
 		struct smb_rqst rqst = { .rq_iov = iov,
 					 .rq_nvec = ARRAY_SIZE(iov) };
 
-		iov[0].iov_base = smb->resp_buf;
+		iov[0].iov_base = smb->response;
 		iov[0].iov_len = len;
 
 		rc = cifs_verify_signature(&rqst, server,
@@ -270,194 +270,447 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
+struct smb1_reassembly_section {
+	u32	asm_off;	/* Offset within reassembled PDU */
+	u16	asm_dis;	/* Offset within reassembly section */
+	u16	asm_cnt;	/* Filled amount of reassembly section */
+	u16	asm_len;	/* Fully reassembled length */
+	u16	seg_off;	/* Segment offset within PDU */
+	u16	seg_len;	/* Segment len */
+	char	type;
+};
+
+struct smb1_reassembly {
+	u16	area_offset;
+	struct smb1_reassembly_section params, data;
+};
+
 /*
-	return codes:
-		0	not a transact2, or all data present
-		>0	transact2 with that much data missing
-		-EINVAL	invalid transact2
+ * Check the basic structure of a trans2-class message.
+ *
+ *  | SMB1 hdr
+ *  | Trans2 resp hdr	} Accounted in WCT
+ *  | Setup words[]	}
+ *  | BCC
+ *  | Padding/Reserved2	} Accounted in BCC
+ *  | content[]		}
  */
-static int
-check2ndT2(char *buf)
+static bool smb1_trans2_check(const union smb1_response_hdr *h,
+			      const struct cifs_receive *recv,
+			      struct smb1_reassembly *t2)
 {
-	struct smb_hdr *pSMB = (struct smb_hdr *)buf;
-	struct smb_t2_rsp *pSMBt;
-	int remaining;
-	__u16 total_data_size, data_in_this_rsp;
-
-	if (pSMB->Command != SMB_COM_TRANSACTION2)
-		return 0;
-
-	/* check for plausible wct, bcc and t2 data and parm sizes */
-	/* check for parm and data offset going beyond end of smb */
-	if (pSMB->WordCount != 10) { /* coalesce_t2 depends on this */
-		cifs_dbg(FYI, "Invalid transact2 word count\n");
-		return -EINVAL;
+	const struct trans2_resp *t2_rsp = &h->trans2.t2_rsp;
+	const struct smb_hdr *shdr = &h->trans2.hdr;
+	unsigned int expected_bcc;
+	unsigned int area_offset = recv->hdr_len;
+	unsigned int area_len = get_bcc(shdr);
+	unsigned int area_top = area_offset + area_len;
+
+	t2->area_offset    = area_offset;
+	t2->params.asm_len = get_unaligned_le16(&t2_rsp->TotalParameterCount);
+	t2->params.asm_dis = get_unaligned_le16(&t2_rsp->ParameterDisplacement);
+	t2->params.seg_len = get_unaligned_le16(&t2_rsp->ParameterCount);
+	t2->params.seg_off = get_unaligned_le16(&t2_rsp->ParameterOffset);
+	t2->data.asm_len   = get_unaligned_le16(&t2_rsp->TotalDataCount);
+	t2->data.asm_dis   = get_unaligned_le16(&t2_rsp->DataDisplacement);
+	t2->data.seg_len   = get_unaligned_le16(&t2_rsp->DataCount);
+	t2->data.seg_off   = get_unaligned_le16(&t2_rsp->DataOffset);
+
+	t2->params.asm_off = 0;
+	t2->params.asm_cnt = 0;
+	t2->params.type    = 'P';
+	t2->data.asm_off   = 0;
+	t2->data.asm_cnt   = 0;
+	t2->data.type      = 'D';
+
+	if (t2->params.seg_len + t2->data.seg_len > area_len)
+		goto bad;
+
+	if (t2->params.seg_len > 0) {
+		if (t2->params.seg_off < t2->area_offset ||
+		    t2->params.seg_off + t2->params.seg_len > area_top ||
+		    t2->params.asm_dis + t2->params.seg_len > t2->params.asm_len)
+			goto bad;
 	}
 
-	pSMBt = (struct smb_t2_rsp *)pSMB;
+	if (t2->data.seg_len > 0) {
+		if (t2->data.seg_off < t2->area_offset ||
+		    t2->data.seg_off + t2->data.seg_len > area_top ||
+		    t2->data.asm_dis + t2->data.seg_len > t2->data.asm_len)
+			goto bad;
+	}
+	if (t2->data.seg_len > 0 &&
+	    t2->params.seg_len > 0) {
+		/* Must not overlap. */
+		if (t2->params.seg_off == t2->data.seg_off)
+			goto bad;
+		if (t2->params.seg_off < t2->data.seg_off &&
+		    t2->params.seg_off + t2->params.seg_len > t2->data.seg_off)
+			goto bad;
+		if (t2->data.seg_off < t2->params.seg_off &&
+		    t2->data.seg_off + t2->data.seg_len > t2->params.seg_off)
+			goto bad;
+	}
+	expected_bcc = t2->params.asm_len + t2->data.asm_len;
+	if (expected_bcc > USHRT_MAX) {
+		cifs_dbg(FYI, "trans2: Expected BCC too large (%u)\n", expected_bcc);
+		return false;
+	}
+	if (t2->data.asm_len > CIFSMaxBufSize) {
+		cifs_dbg(VFS, "trans2: TotalDataSize %u is over maximum buffer %u\n",
+			 t2->data.asm_len, CIFSMaxBufSize);
+		return false;
+	}
+	return true;
 
-	total_data_size = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
-	data_in_this_rsp = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+bad:
+	cifs_dbg(FYI, "trans2: Bad resp layout: area %x-%x\n",
+		 t2->area_offset, area_top);
+	cifs_dbg(FYI, "trans2: Params: len=%x/%x off=%x dis=%x\n",
+		 t2->params.seg_len, t2->params.asm_len,
+		 t2->params.seg_off, t2->params.asm_dis);
+	cifs_dbg(FYI, "trans2: Data: len=%x/%x off=%x dis=%x\n",
+		 t2->data.seg_len, t2->data.asm_len,
+		 t2->data.seg_off, t2->data.asm_dis);
+	return false;
+}
 
-	if (total_data_size == data_in_this_rsp)
-		return 0;
-	else if (total_data_size < data_in_this_rsp) {
-		cifs_dbg(FYI, "total data %d smaller than data in frame %d\n",
-			 total_data_size, data_in_this_rsp);
-		return -EINVAL;
+/*
+ * Check follow-on messages for a Trans2 message.
+ */
+static int smb1_trans2_check2(struct TCP_Server_Info *server,
+			      struct smb_message *smb,
+			      struct cifs_receive *recv,
+			      struct smb1_reassembly *t2)
+{
+	union smb1_response_hdr *target_h = smb->response;
+	struct smb_t2_rsp *target = &target_h->trans2;
+	int remaining_params, remaining_data;
+	unsigned int total_params, total_data;
+
+	total_params       = get_unaligned_le16(&target->t2_rsp.TotalParameterCount);
+	total_data         = get_unaligned_le16(&target->t2_rsp.TotalDataCount);
+	t2->params.asm_cnt = get_unaligned_le16(&target->t2_rsp.ParameterCount);
+	t2->data.asm_cnt   = get_unaligned_le16(&target->t2_rsp.DataCount);
+
+	cifs_dbg(FYI, "trans2: params=%x/%x/%x data=%x/%x/%x\n",
+		 t2->params.seg_len, t2->params.asm_cnt, t2->params.asm_len,
+		 t2->data.seg_len,   t2->data.asm_cnt,   t2->data.asm_len);
+
+	if (t2->params.asm_len != total_params)
+		cifs_dbg(FYI, "trans2: Inconsistent TotalParameterCount %u!=%u\n",
+			 t2->params.asm_len, total_params);
+
+	if (t2->data.asm_len != total_data)
+		cifs_dbg(FYI, "trans2: Inconsistent TotalDataCount %u!=%u\n",
+			 t2->params.asm_len, total_data);
+
+	remaining_params = t2->params.asm_len - t2->params.asm_cnt;
+	remaining_data   = t2->data.asm_len   - t2->data.asm_cnt;
+
+	if (remaining_params < 0 || remaining_data < 0) {
+		pr_warn("trans2: Server sent too much: params=%u/%u data=%u/%u\n",
+			t2->params.asm_cnt, t2->params.asm_len,
+			t2->data.asm_cnt, t2->data.asm_len);
+		return -EPROTO;
 	}
 
-	remaining = total_data_size - data_in_this_rsp;
-
-	cifs_dbg(FYI, "missing %d bytes from transact2, check next response\n",
-		 remaining);
-	if (total_data_size > CIFSMaxBufSize) {
-		cifs_dbg(VFS, "TotalDataSize %d is over maximum buffer %d\n",
-			 total_data_size, CIFSMaxBufSize);
-		return -EINVAL;
+	if (t2->params.seg_len > remaining_params ||
+	    t2->data.seg_len   > remaining_data) {
+		pr_warn("trans2: Excessive addition: params=%u/%u/%u data=%u/%u/%u\n",
+			t2->params.seg_len, t2->params.asm_cnt, t2->params.asm_len,
+			t2->data.seg_len,   t2->data.asm_cnt,   t2->data.asm_len);
+		return -EPROTO;
 	}
-	return remaining;
+
+	return 0;
 }
 
-static int
-coalesce_t2(char *second_buf, struct smb_hdr *target_hdr, unsigned int *pdu_len)
+/*
+ * Allocate an appropriately sized buffer for a reassembled Trans2 reply.
+ */
+static int smb1_trans2_alloc(struct TCP_Server_Info *server,
+			     struct smb_message *smb,
+			     struct cifs_receive *recv,
+			     struct smb1_reassembly *t2)
 {
-	struct smb_t2_rsp *pSMBs = (struct smb_t2_rsp *)second_buf;
-	struct smb_t2_rsp *pSMBt  = (struct smb_t2_rsp *)target_hdr;
-	char *data_area_of_tgt;
-	char *data_area_of_src;
-	int remaining;
-	unsigned int byte_count, total_in_tgt;
-	__u16 tgt_total_cnt, src_total_cnt, total_in_src;
+	union smb1_response_hdr *h = recv->response;
+	struct trans2_resp *rsp = &h->trans2.t2_rsp;
+	struct smb_hdr *shdr = &h->trans2.hdr;
+	unsigned int reasm_len;
+	u16 bcc;
+
+	reasm_len  = t2->area_offset;
+	/* Might need 1 byte of padding before the params */
+	reasm_len += t2->params.asm_len;
+	/* Might need 2 bytes of padding before the data */
+	reasm_len += t2->data.asm_len;
+
+	if (reasm_len <= MAX_CIFS_SMALL_BUFFER_SIZE) {
+		/* Stick with the small buffer we're already using. */
+		smb->response = server->smallbuf;
+		smb->resp_len = reasm_len;
+		server->smallbuf = NULL;
+	} else if (reasm_len <= CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
+		/* Switch to a large buffer. */
+		smb->response = server->bigbuf;
+		smb->resp_len = reasm_len;
+		smb->large_buf = true;
+		memcpy(server->bigbuf, server->smallbuf, recv->extracted);
+		server->bigbuf = NULL;
+		recv->resp_buf_type = CIFS_LARGE_BUFFER;
+	} else {
+		/* Too big - could decant into a list of pages. */
+		smb->error = -EMSGSIZE;
+		cifs_dbg(FYI, "%s: Message too big\n", __func__);
+		return -EMSGSIZE;
+	}
 
-	src_total_cnt = get_unaligned_le16(&pSMBs->t2_rsp.TotalDataCount);
-	tgt_total_cnt = get_unaligned_le16(&pSMBt->t2_rsp.TotalDataCount);
+	h = smb->response;
+	shdr = &h->trans2.hdr;
+	rsp = &h->trans2.t2_rsp;
 
-	if (tgt_total_cnt != src_total_cnt)
-		cifs_dbg(FYI, "total data count of primary and secondary t2 differ source=%hu target=%hu\n",
-			 src_total_cnt, tgt_total_cnt);
+	/* Fix up the BCC to the anticipated full amount. */
+	bcc = t2->params.asm_len + t2->data.asm_len;
+	put_bcc(bcc, shdr);
 
-	total_in_tgt = get_unaligned_le16(&pSMBt->t2_rsp.DataCount);
+	/* Lay out the parameter and data blocks appropriately. */
+	rsp->ParameterOffset = cpu_to_le16(recv->hdr_len);
+	rsp->DataOffset      = cpu_to_le16(recv->hdr_len + t2->params.asm_len);
 
-	remaining = tgt_total_cnt - total_in_tgt;
+	recv->msg_len = reasm_len;
+	return 0;
+}
 
-	if (remaining < 0) {
-		cifs_dbg(FYI, "Server sent too much data. tgt_total_cnt=%hu total_in_tgt=%u\n",
-			 tgt_total_cnt, total_in_tgt);
-		return -EPROTO;
-	}
+static bool smb1_trans2_extract(struct smb_message *smb,
+				struct cifs_receive *recv,
+				struct smb1_reassembly_section *a,
+				struct netfs_rxqueue *rxq)
+{
+	size_t got;
 
-	if (remaining == 0) {
-		/* nothing to do, ignore */
-		cifs_dbg(FYI, "no more data remains\n");
-		return 0;
-	}
+	if (a->seg_len == 0)
+		return true;
 
-	total_in_src = get_unaligned_le16(&pSMBs->t2_rsp.DataCount);
-	if (remaining < total_in_src)
-		cifs_dbg(FYI, "transact2 2nd response contains too much data\n");
+	got = netfs_rxqueue_read(rxq, smb->response + a->asm_off,
+				 a->seg_off, a->seg_len);
+	if (got != a->seg_len) {
+		cifs_dbg(FYI, "trans2: copy_from_iter failed (%u bytes)\n",
+			 rxq->qsize);
+		return false;
+	}
+	return true;
+}
 
-	/* find end of first SMB data area */
-	data_area_of_tgt = (char *)&pSMBt->hdr.Protocol +
-				get_unaligned_le16(&pSMBt->t2_rsp.DataOffset);
+/*
+ * Receive a Trans2-class message.  These are potentially multipart and may
+ * need assembly.
+ *
+ * Returns 0 if the message is complete (for good or bad), 1 if further data is
+ * expected and a negative error code otherwise.
+ */
+static int smb1_trans2_receive(struct TCP_Server_Info *server,
+			       struct smb_message *smb,
+			       struct cifs_receive *recv,
+			       struct netfs_rxqueue *rxq)
+{
+	union smb1_response_hdr *target_h;
+	union smb1_response_hdr *h = recv->response;
+	struct smb1_reassembly t2;
+	struct trans2_resp *target;
+	int rc;
 
-	/* validate target area */
-	data_area_of_src = (char *)&pSMBs->hdr.Protocol +
-				get_unaligned_le16(&pSMBs->t2_rsp.DataOffset);
+	if (server->sign) {
+		rc = cifs_verify_trans_signature(server, recv, rxq,
+						 smb->sequence_number);
+		if (rc < 0) {
+			cifs_dbg(FYI, "Signature check failed\n");
+		}
+		smb->sig_checked = true;
+	}
 
-	data_area_of_tgt += total_in_tgt;
+	if (h->hdr.Status.CifsError != 0 &&
+	    h->hdr.WordCount == 0) {
+		smb->response = server->smallbuf;
+		smb->resp_len = recv->msg_len;
+		server->smallbuf = NULL;
+		return 0;
+	}
 
-	total_in_tgt += total_in_src;
-	/* is the result too big for the field? */
-	if (total_in_tgt > USHRT_MAX) {
-		cifs_dbg(FYI, "coalesced DataCount too large (%u)\n",
-			 total_in_tgt);
-		return -EPROTO;
+	if (!smb1_trans2_check(h, recv, &t2)) {
+		cifs_dbg(FYI, "Invalid transact2 layout\n");
+		return -EINVAL;
 	}
-	put_unaligned_le16(total_in_tgt, &pSMBt->t2_rsp.DataCount);
 
-	/* fix up the BCC */
-	byte_count = get_bcc(target_hdr);
-	byte_count += total_in_src;
-	/* is the result too big for the field? */
-	if (byte_count > USHRT_MAX) {
-		cifs_dbg(FYI, "coalesced BCC too large (%u)\n", byte_count);
-		return -EPROTO;
+	if (t2.params.seg_len < t2.params.asm_len ||
+	    t2.data.seg_len   < t2.data.asm_len) {
+		smb->multiRsp = true;
+		cifs_dbg(FYI, "Trans2 incomplete (%u/%u, %u/%u), check next response\n",
+			 t2.params.seg_len, t2.params.asm_len,
+			 t2.data.seg_len, t2.data.asm_len);
 	}
-	put_bcc(byte_count, target_hdr);
 
-	byte_count = *pdu_len;
-	byte_count += total_in_src;
-	/* don't allow buffer to overflow */
-	if (byte_count > CIFSMaxBufSize + MAX_CIFS_HDR_SIZE) {
-		cifs_dbg(FYI, "coalesced BCC exceeds buffer size (%u)\n",
-			 byte_count);
-		return -ENOBUFS;
+	if (!smb->response) {
+		rc = smb1_trans2_alloc(server, smb, recv, &t2);
+		if (rc < 0)
+			return rc;
+	} else {
+		/* Check follow-on message. */
+		rc = smb1_trans2_check2(server, smb, recv, &t2);
+		if (rc < 0)
+			return rc;
 	}
-	*pdu_len = byte_count;
 
-	/* copy second buffer into end of first buffer */
-	memcpy(data_area_of_tgt, data_area_of_src, total_in_src);
+	/* Perform the reassembly. */
+	target_h = smb->response;
+	target = &target_h->trans2.t2_rsp;
+	t2.params.asm_off = le16_to_cpup(&target->ParameterOffset) + t2.params.asm_dis;
+	t2.data.asm_off   = le16_to_cpup(&target->DataOffset)      + t2.data.asm_dis;
 
-	if (remaining != total_in_src) {
-		/* more responses to go */
-		cifs_dbg(FYI, "waiting for more secondary responses\n");
-		return 1;
-	}
+	if (!smb1_trans2_extract(smb, recv, &t2.params, rxq) ||
+	    !smb1_trans2_extract(smb, recv, &t2.data,   rxq))
+		return smb_EIO(smb_eio_trace_rx_trans2_extract);
 
-	/* we are done */
-	cifs_dbg(FYI, "found the last secondary response\n");
-	return 0;
+	t2.params.asm_cnt += t2.params.seg_len;
+	t2.data.asm_cnt   += t2.data.seg_len;
+	target->ParameterCount = cpu_to_le16(t2.params.asm_cnt);
+	target->DataCount      = cpu_to_le16(t2.data.asm_cnt);
+
+	/* All parts received or packet is malformed. */
+	if (t2.params.asm_cnt == t2.params.asm_len &&
+	    t2.data.asm_cnt   == t2.data.asm_len) {
+		smb->multiEnd = true;
+		return 0;
+	}
+	return 1;
 }
 
-bool
-cifs_check_trans2(struct smb_message *smb, struct TCP_Server_Info *server,
-		  char *buf, int malformed)
+/*
+ * Check the size of the response header and extract the data area size.
+ */
+static bool smb1_check_response(struct cifs_receive *recv)
 {
-	if (malformed)
-		return false;
-	if (check2ndT2(buf) <= 0)
-		return false;
-	smb->multiRsp = true;
-	if (smb->resp_buf) {
-		/* merge response - fix up 1st*/
-		malformed = coalesce_t2(buf, smb->resp_buf, &smb->response_pdu_len);
-		if (malformed > 0)
-			return true;
-		/* All parts received or packet is malformed. */
-		smb->multiEnd = true;
-		dequeue_mid(server, smb, malformed);
+	const union smb1_response_hdr *h = recv->response;
+	const struct smb_hdr *shdr = &h->hdr;
+	unsigned bcc;
+
+	if (shdr->Status.CifsError != 0)
 		return true;
+
+	/* Assume, by default, that the data area is beyond the BCC-covered area. */
+	bcc = get_bcc(shdr);
+	if (recv->extracted + bcc < recv->msg_len) {
+		recv->data_offset = recv->extracted + bcc;
+		recv->data_len = recv->msg_len;
 	}
-	if (!server->large_buf) {
-		/*FIXME: switch to already allocated largebuf?*/
-		cifs_dbg(VFS, "1st trans2 resp needs bigbuf\n");
-	} else {
-		/* Have first buffer */
-		smb->resp_buf = buf;
-		smb->large_buf = true;
-		server->bigbuf = NULL;
+
+	switch (shdr->Command) {
+		/* Trivial responses with WCT=0 and BCC=0 */
+	case SMB_COM_CREATE_DIRECTORY:
+	case SMB_COM_DELETE_DIRECTORY:
+	case SMB_COM_CLOSE:
+	case SMB_COM_FLUSH:
+	case SMB_COM_DELETE:
+	case SMB_COM_RENAME:
+	case SMB_COM_SETATTR:
+	case SMB_COM_FIND_CLOSE2:
+	case SMB_COM_TREE_DISCONNECT:
+	case SMB_COM_NT_RENAME:
+		if (recv->hdr_len < sizeof(struct smb_hdr) + 2)
+			goto too_short;
+		break;
+		/* Trivial AndX responses with WCT=2 and BCC=0 */
+	case SMB_COM_LOCKING_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_hdr) + 6)
+			goto too_short;
+		break;
+	case SMB_COM_QUERY_INFORMATION:
+		if (recv->hdr_len < sizeof(struct smb_com_query_information_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_COPY:
+		if (recv->hdr_len < sizeof(struct smb_com_copy_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_ECHO:
+		if (recv->hdr_len < sizeof(struct smb_com_echo_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_OPEN_ANDX:
+	case SMB_COM_NT_CREATE_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_com_open_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_READ_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_com_read_rsp))
+			goto too_short;
+		recv->data_offset = le16_to_cpu(h->read.DataOffset);
+		recv->data_len    = le16_to_cpu(h->read.DataLengthHigh) << 16;
+		recv->data_len   += le16_to_cpu(h->read.DataLength);
+		break;
+	case SMB_COM_WRITE_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_com_write_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_NEGOTIATE:
+		if (recv->hdr_len < offsetof(struct smb_negotiate_rsp, ByteCount))
+			goto too_short;
+		break;
+	case SMB_COM_SESSION_SETUP_ANDX:
+		if (recv->hdr_len < sizeof(struct smb1_old_session_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_LOGOFF_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_com_logoff_andx_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_TREE_CONNECT_ANDX:
+		if (recv->hdr_len < sizeof(struct smb_com_tconx_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_TRANSACTION2:
+		if (recv->hdr_len < sizeof(struct smb_t2_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_NT_TRANSACT:
+		if (recv->hdr_len < sizeof(struct smb_com_ntransact_rsp))
+			goto too_short;
+		break;
+	case SMB_COM_TRANSACTION2_SECONDARY:
+	case SMB_COM_NT_TRANSACT_SECONDARY:
+	case SMB_COM_NT_CANCEL:
+	default:
+		cifs_dbg(VFS, "Unsupported command reply (%x)\n", shdr->Command);
+		break;
 	}
+
 	return true;
+too_short:
+	cifs_dbg(VFS, "Header too short (%x) for command (%x)\n",
+		 recv->hdr_len, shdr->Command);
+	return false;
 }
 
-static int
-check_smb_hdr(struct smb_hdr *smb)
+static bool
+check_smb_hdr(struct cifs_receive *recv)
 {
+	union smb1_response_hdr *h = recv->response;
+	struct smb_hdr *smb = &h->hdr;
+
 	/* does it have the right SMB "signature" ? */
 	if (*(__le32 *) smb->Protocol != SMB1_PROTO_NUMBER) {
 		cifs_dbg(VFS, "Bad protocol string signature header 0x%x\n",
 			 *(unsigned int *)smb->Protocol);
-		return 1;
+		return false;
 	}
 
 	/* if it's a response then accept */
 	if (smb->Flags & SMBFLG_RESPONSE)
-		return 0;
+		return true;
 
 	/* only one valid case where server sends us request */
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
-		return 0;
+		return true;
 
 	/*
 	 * Windows NT server returns error response (e.g. STATUS_DELETE_PENDING
@@ -465,90 +718,99 @@ check_smb_hdr(struct smb_hdr *smb)
 	 * for some TRANS2 requests without the RESPONSE flag set in header.
 	 */
 	if (smb->Command == SMB_COM_TRANSACTION2 && smb->Status.CifsError != 0)
-		return 0;
+		return true;
 
 	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
-		 get_mid(smb));
-	return 1;
+		 le16_to_cpu(smb->Mid));
+	return false;
 }
 
-int
-checkSMB(char *buf, unsigned int pdu_len, unsigned int total_read,
-	 struct TCP_Server_Info *server)
+/*
+ * Try and fix up a message that's too short even to contain a full BCC word
+ * and nothing else after the header.
+ */
+static int smb1_fix_up_short_header(struct cifs_receive *recv)
 {
-	struct smb_hdr *smb = (struct smb_hdr *)buf;
-	__u32 rfclen = pdu_len;
-	__u32 clc_len;  /* calculated length */
-	cifs_dbg(FYI, "checkSMB Length: 0x%x, smb_buf_length: 0x%x\n",
-		 total_read, rfclen);
-
-	/* is this frame too small to even get to a BCC? */
-	if (total_read < 2 + sizeof(struct smb_hdr)) {
-		if ((total_read >= sizeof(struct smb_hdr) - 1)
-			    && (smb->Status.CifsError != 0)) {
-			/* it's an error return */
-			smb->WordCount = 0;
-			/* some error cases do not return wct and bcc */
-			return 0;
-		} else if ((total_read == sizeof(struct smb_hdr) + 1) &&
-				(smb->WordCount == 0)) {
-			char *tmp = (char *)smb;
-			/* Need to work around a bug in two servers here */
-			/* First, check if the part of bcc they sent was zero */
-			if (tmp[sizeof(struct smb_hdr)] == 0) {
-				/* some servers return only half of bcc
-				 * on simple responses (wct, bcc both zero)
-				 * in particular have seen this on
-				 * ulogoffX and FindClose. This leaves
-				 * one byte of bcc potentially uninitialized
-				 */
-				/* zero rest of bcc */
-				tmp[sizeof(struct smb_hdr)+1] = 0;
-				return 0;
-			}
-			cifs_dbg(VFS, "rcvd invalid byte count (bcc)\n");
-			return smb_EIO1(smb_eio_trace_rx_inv_bcc, tmp[sizeof(struct smb_hdr)]);
-		} else {
-			cifs_dbg(VFS, "Length less than smb header size\n");
-			return smb_EIO2(smb_eio_trace_rx_too_short,
-					total_read, smb->WordCount);
+	union smb1_response_hdr *h = recv->response;
+
+	cifs_dbg(FYI, "%s: rfc1002 len: 0x%x\n", __func__, recv->msg_len);
+
+	if (recv->msg_len < sizeof(struct smb_hdr) - 1) {
+		cifs_dbg(VFS, "Length less than smb header size\n");
+		return smb_EIO1(smb_eio_trace_rx_too_short, recv->msg_len);
+	}
+
+	if (h->hdr.Status.CifsError != 0) {
+		/* It's an error return (some error cases do not return wct and
+		 * bcc).
+		 */
+		goto reset_wct_and_bcc;
+	}
+
+	if (recv->msg_len == sizeof(struct smb_hdr) + 1 &&
+	    h->hdr.WordCount == 0) {
+		/* Need to work around a bug in two servers here */
+		/* First, check if the part of bcc they sent was zero */
+		if (h->trivial_rsp.short_bcc == 0) {
+			/* some servers return only half of bcc
+			 * on simple responses (wct, bcc both zero)
+			 * in particular have seen this on
+			 * ulogoffX and FindClose. This leaves
+			 * one byte of bcc potentially uninitialized
+			 */
+			goto reset_wct_and_bcc;
 		}
-	} else if (total_read < sizeof(*smb) + 2 * smb->WordCount) {
-		cifs_dbg(VFS, "%s: can't read BCC due to invalid WordCount(%u)\n",
-			 __func__, smb->WordCount);
-		return smb_EIO2(smb_eio_trace_rx_check_rsp,
-				total_read, 2 + sizeof(struct smb_hdr));
+		cifs_dbg(VFS, "rcvd invalid byte count (bcc)\n");
+		return smb_EIO1(smb_eio_trace_rx_inv_bcc, h->trivial_rsp.short_bcc);
 	}
 
-	/* otherwise, there is enough to get to the BCC */
-	if (check_smb_hdr(smb))
-		return smb_EIO1(smb_eio_trace_rx_rfc1002_magic, *(u32 *)smb->Protocol);
-	clc_len = smbCalcSize(smb);
+	cifs_dbg(VFS, "Length less than smb header size\n");
+	return smb_EIO2(smb_eio_trace_rx_too_short,
+			recv->msg_len, le16_to_cpu(h->hdr.WordCount));
+
+reset_wct_and_bcc:
+	h->trivial_rsp.hdr.WordCount = 0;
+	h->trivial_rsp.bcc = 0;
+	recv->msg_len   = sizeof(h->trivial_rsp);
+	recv->hdr_len   = recv->msg_len;
+	recv->extracted = recv->msg_len;
+	return 0;
+}
+
+int
+checkSMB(const struct TCP_Server_Info *server, struct cifs_receive *recv)
+{
+	union smb1_response_hdr *h = recv->response;
+	struct smb_hdr *smb = &h->hdr;
 
-	if (rfclen != total_read) {
-		cifs_dbg(VFS, "Length read does not match RFC1001 length %d/%d\n",
-			 rfclen, total_read);
+	cifs_dbg(FYI, "checkSMB rfc1002 len: 0x%x\n", recv->msg_len);
+
+	/* otherwise, there is enough to get to the BCC */
+	if (!smb1_check_response(recv))
 		return smb_EIO2(smb_eio_trace_rx_check_rsp,
-				total_read, rfclen);
-	}
+				h->hdr.Command,
+				(le16_to_cpu(h->hdr.WordCount) << 16) |
+				h->trivial_rsp.short_bcc);
 
-	if (rfclen != clc_len) {
-		__u16 mid = get_mid(smb);
+	recv->calc_len = smbCalcSize(smb);
+	if (recv->msg_len != recv->calc_len) {
+		__u16 mid = le16_to_cpu(smb->Mid);
 		/* check if bcc wrapped around for large read responses */
-		if ((rfclen > 64 * 1024) && (rfclen > clc_len)) {
+		if ((recv->msg_len > 64 * 1024) &&
+		    (recv->msg_len > recv->calc_len)) {
 			/* check if lengths match mod 64K */
-			if (((rfclen) & 0xFFFF) == (clc_len & 0xFFFF))
+			if ((recv->msg_len & 0xFFFF) == (recv->calc_len & 0xFFFF))
 				return 0; /* bcc wrapped */
 		}
 		cifs_dbg(FYI, "Calculated size %u vs length %u mismatch for mid=%u\n",
-			 clc_len, rfclen, mid);
+			 recv->calc_len, recv->msg_len, mid);
 
-		if (rfclen < clc_len) {
+		if (recv->msg_len < recv->calc_len) {
 			cifs_dbg(VFS, "RFC1001 size %u smaller than SMB for mid=%u\n",
-				 rfclen, mid);
+				 recv->msg_len, mid);
 			return smb_EIO2(smb_eio_trace_rx_calc_len_too_big,
-					rfclen, clc_len);
-		} else if (rfclen > clc_len + 512) {
+					recv->msg_len, recv->calc_len);
+		} else if (recv->msg_len > recv->calc_len + 512) {
 			/*
 			 * Some servers (Windows XP in particular) send more
 			 * data than the lengths in the SMB packet would
@@ -559,10 +821,366 @@ checkSMB(char *buf, unsigned int pdu_len, unsigned int total_read,
 			 * data to 512 bytes.
 			 */
 			cifs_dbg(VFS, "RFC1001 size %u more than 512 bytes larger than SMB for mid=%u\n",
-				 rfclen, mid);
+				 recv->msg_len, mid);
 			return smb_EIO2(smb_eio_trace_rx_overlong,
-					rfclen, clc_len + 512);
+					recv->msg_len, recv->calc_len + 512);
 		}
 	}
 	return 0;
 }
+
+/*
+ * Copy data directly into prepared buffers.
+ *
+ * Ideally, we'd wait for sufficient data to be present in the queue before
+ * doing this, but that causes a performance loss as we don't receive data and
+ * copy in parallel.
+ */
+static void smb1_copy_to_prepped_buffers(struct TCP_Server_Info *server,
+					 struct smb_message *smb,
+					 struct netfs_rxqueue *rxq,
+					 struct cifs_receive *recv)
+{
+	const union smb1_response_hdr *h = recv->response;
+	struct iov_iter dest = smb->response_iter;
+	unsigned int to_copy, skip;
+	int rc;
+
+	switch (h->hdr.Command) {
+	case SMB_COM_READ_ANDX:
+		to_copy = recv->data_len;
+		skip = recv->data_offset;
+		break;
+	default:
+		cifs_dbg(FYI, "%s: Non-Read copy\n", __func__);
+		return;
+	}
+
+	if (skip < recv->hdr_len) {
+		if (skip != 0) {
+			cifs_dbg(FYI, "%s: Read.DataOffset too small\n", __func__);
+			return;
+		}
+		skip = recv->hdr_len;
+	}
+	if (skip > recv->msg_len) {
+		cifs_dbg(FYI, "%s: Read.DataOffset beyond end\n", __func__);
+		return;
+	}
+	if (to_copy > recv->msg_len - skip) {
+		cifs_dbg(FYI, "%s: Read.DataLength beyond end\n", __func__);
+		return;
+	}
+
+	if (!rxq->refillable) {
+		size_t got;
+
+		got = netfs_rxqueue_read_iter(rxq, &dest, 0, to_copy);
+		if (got > 0)
+			netfs_rxqueue_discard(rxq, got);
+		recv->extracted += got;
+		if (got < to_copy) {
+			cifs_dbg(VFS, "Copy to buffer was short %zu/%u\n",
+				 got, to_copy);
+			recv->malformed = true;
+		}
+		return;
+	}
+
+	while (to_copy) {
+		size_t got, part = umin(to_copy, rxq->qsize);
+
+		got = netfs_rxqueue_read_iter(rxq, &dest, 0, part);
+		if (got > 0) {
+			recv->extracted += got;
+			to_copy -= got;
+			netfs_rxqueue_discard(rxq, got);
+		}
+		if (!to_copy)
+			break;
+		if (got < part) {
+			cifs_dbg(VFS, "Copy to buffer was short %zu/%zu\n",
+				 part, to_copy + part);
+			recv->malformed = true;
+			return;
+		}
+
+		rc = smb_rxqueue_refill(server, rxq, 1);
+		if (rc < 0) {
+			recv->malformed = true;
+			return;
+		}
+		if (!rxq->qsize || !rxq->pdu_remain)
+			break;
+	}
+}
+
+/*
+ * Parse an SMB1 message that's at least partially extracted.  For successful
+ * reads, the data part is still in the receive queue or even not yet received.
+ */
+static void smb1_parse_one_message(struct TCP_Server_Info *server,
+				   struct cifs_receive *recv,
+				   struct netfs_rxqueue *rxq)
+{
+	union smb1_response_hdr *h = recv->response;
+	struct smb_message *smb;
+	struct smb_hdr *shdr = &h->hdr;
+	int rc;
+
+	smb = cifs_find_mid(server, shdr);
+	if (!smb) {
+		cifs_dbg(VFS, "%s: Unqueued mid (%x)\n",
+			 __func__, le16_to_cpu(shdr->Mid));
+		rxq->msg_id = 0;
+	} else {
+		rxq->msg_id = 0; /* TODO: smb->debug_id */
+	}
+
+	/* No session expiry check. */
+	/* No status pending check. */
+	/* SMB1 does not use credits. */
+
+	if (cifs_is_network_name_deleted(&h->hdr, server))
+		return;
+
+	if (shdr->Status.CifsError != 0)
+		recv->error = map_smb_to_linux_error(shdr, false);
+
+	if (smb) {
+		size_t resp_len = 0;
+
+		/* handle_mid */
+		smb->status		= shdr->Status.CifsError;
+		smb->error		= recv->error;
+		smb->credits_received	= smb->credits_consumed;
+		smb->resp_data_len	= recv->data_len;
+		smb->resp_data_offset	= recv->data_offset;
+
+		trace_smb3_reply(smb, recv);
+
+		if (h->hdr.Command == SMB_COM_TRANSACTION2 &&
+		    !recv->malformed) {
+			/* Handle multipart trans2-class messages. */
+			rc = smb1_trans2_receive(server, smb, recv, rxq);
+			if (rc == 1) {
+				release_mid(server, smb);
+				return; /* Multipart, incomplete. */
+			}
+			if (rc < 0)
+				recv->malformed = true;
+			smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+			goto extracted;
+		}
+
+		/* For a successful Read, we grab everthing up to the base of
+		 * the read region, but no more.  This may include padding.
+		 */
+		resp_len = recv->msg_len;
+		if (smb->status != 0)
+			smb->copy_to_bufs = false;
+		if (smb->copy_to_bufs) {
+			resp_len = recv->data_offset;
+
+			rc = smb_rxqueue_refill(server, rxq, recv->data_offset);
+			if (rc < 0) {
+				recv->malformed = true;
+				goto extracted;
+			}
+		}
+
+		if (resp_len <= MAX_CIFS_SMALL_BUFFER_SIZE) {
+			server->smallbuf = NULL;
+		} else if (resp_len <= CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
+			memcpy(server->bigbuf, server->smallbuf, recv->extracted);
+			recv->response = server->bigbuf;
+			server->bigbuf = NULL;
+			recv->resp_buf_type = CIFS_LARGE_BUFFER;
+			h = recv->response;
+			shdr = &h->hdr;
+		} else {
+			/* Too big - should parse directly from iterator. */
+			smb->error = -EMSGSIZE;
+			cifs_dbg(FYI, "%s: Message too big\n", __func__);
+		}
+
+		smb->response = recv->response;
+		smb->resp_len = resp_len;
+
+		if (recv->extracted < recv->msg_len) {
+			size_t part = resp_len - recv->extracted, got;
+
+			got = netfs_rxqueue_read(rxq, recv->response + recv->extracted,
+						 recv->extracted, part);
+			recv->extracted += got;
+			netfs_rxqueue_discard(rxq, recv->extracted);
+
+			if (WARN_ON(got != part)) {
+				smb->error = smb_EIO2(smb_eio_trace_rx_b_read_short,
+						      got, part);
+				smb->resp_len = recv->extracted;
+				recv->malformed = true;
+			} else if (smb->copy_to_bufs) {
+				smb1_copy_to_prepped_buffers(server, smb, rxq,
+							     recv);
+			} else if (rxq->pdu_remain) {
+				iov_iter_bvec_queue(&smb->response_iter, ITER_SOURCE,
+						    rxq->take_from, rxq->take_slot,
+						    rxq->take_offset, rxq->pdu_remain);
+				smb->response_data = rxq->take_from;
+				refcount_inc(&smb->response_data->ref);
+			}
+		} else {
+			netfs_rxqueue_discard(rxq, recv->extracted);
+		}
+
+	extracted:
+		dequeue_mid(server, smb, recv->malformed);
+		mid_execute_callback(server, smb);
+
+		release_mid(server, smb);
+	} else if (smb1_is_valid_oplock_break(h, recv->msg_len, server)) {
+		cifs_dbg(FYI, "Received oplock break\n");
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+	} else {
+		cifs_server_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
+				atomic_read(&mid_count));
+		cifs_dump_mem("Received Data is: ", h, HEADER_SIZE(server));
+#ifdef CONFIG_CIFS_DEBUG2
+		cifs_dump_detail(server, recv);
+		cifs_dump_mids(server);
+#endif /* CIFS_DEBUG2 */
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+	}
+}
+
+/*
+ * Receive and parse a received SMB1 PDU.
+ *
+ * At this point all the data has been read, any transformation unapplied,
+ * decompression performed and some of it is stored in the receive queue
+ * (excerpt) without either the rfc1002, transform or compression headers,
+ * though some may yet to be received.
+ */
+static void smb1_parse_pdu(struct TCP_Server_Info *server,
+			   struct netfs_rxqueue *rxq)
+{
+	union smb1_response_hdr *h;
+	struct smb_hdr *shdr;
+	unsigned int advance_get, part, got;
+	int rc;
+
+	server->lstrp = jiffies;
+
+	struct cifs_receive recv = {
+		.resp_buf_type	= CIFS_SMALL_BUFFER,
+		.response	= server->smallbuf,
+		.msg_len	= rxq->pdu_remain,
+	};
+	h = recv.response;
+	shdr = &h->hdr;
+
+	/* We try to grab the header if we can, plus the BCC field, assuming it
+	 * to be trivially placed (ie. WCT==0).
+	 *
+	 * Now, it's possible for buggy servers to return less than the size of
+	 * the header in certain cases, such as error cases, so we grab what
+	 * there is of it and then fix up the short header.
+	 */
+	advance_get = umin(sizeof(h->trivial_rsp), rxq->pdu_remain);
+
+	rc = smb_rxqueue_refill(server, rxq, advance_get);
+	if (rc < 0)
+		goto failed;
+
+	got = netfs_rxqueue_read(rxq, recv.response, 0, advance_get);
+	if (got != advance_get) {
+		cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
+				rxq->qsize);
+		goto failed;
+	}
+	recv.extracted = advance_get;
+
+	/* Validate the header and fix up the message if it's too small due to
+	 * known server bugs.
+	 */
+	recv.hdr_len = umin(sizeof(*shdr), recv.msg_len);
+	if (recv.msg_len < sizeof(h->trivial_rsp)) {
+		rc = smb1_fix_up_short_header(&recv);
+		if (rc < 0)
+			goto bad;
+	}
+
+	if (!check_smb_hdr(&recv))
+		goto bad;
+
+	/* Get the rest of the command-specific response header plus the BCC. */
+	recv.hdr_len += h->hdr.WordCount * 2 + 2;
+	if (recv.hdr_len > sizeof(*h)) {
+		cifs_dbg(VFS, "%s: can't read BCC due to invalid WordCount(%u)\n",
+			 __func__, h->hdr.WordCount);
+		goto bad;
+	}
+
+	/* If it's a successful read, then wait for the header. */
+	if (shdr->Command == SMB_COM_READ_ANDX &&
+	    shdr->Status.CifsError == 0)
+		advance_get = recv.hdr_len;
+	else
+		advance_get = recv.msg_len;
+
+	rc = smb_rxqueue_refill(server, rxq, advance_get);
+	if (rc < 0)
+		goto failed;
+
+	part = recv.hdr_len - recv.extracted;
+	got = netfs_rxqueue_read(rxq, (void *)recv.response + recv.extracted,
+				 recv.extracted, part);
+	if (got != part) {
+		cifs_server_dbg(VFS, "rxqueue_read failed (%u bytes)\n",
+				rxq->qsize);
+		goto failed;
+	}
+	recv.extracted += got;
+
+	/*
+	 * We've got the MID and the BCC.  Now check to see if the rest of the
+	 * header is OK.  Note that we've only extracted up to and including
+	 * the BCC at this point; everything else is either in the receive
+	 * queue or still pending (i.e. for the data in a Read).
+	 */
+	rc = checkSMB(server, &recv);
+	if (rc) {
+		recv.malformed = true;
+		goto bad;
+	}
+
+	smb1_parse_one_message(server, &recv, rxq);
+
+discard:
+	WARN(rxq->pdu_remain > 0, "pdu_remain=%x", rxq->pdu_remain);
+	smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+	return;
+
+bad:
+	/*
+	 * 48 bytes is enough to display the header and a little bit into the
+	 * payload for debugging purposes.
+	 */
+	cifs_dump_mem("Bad SMB: ", h, umin(recv.msg_len, 48));
+failed:
+	set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+	goto discard;
+}
+
+/*
+ * Receive and parse an SMB1 PDU.  We need to wait for data to come in until we
+ * have enough and then we have to reverse transformations and perform
+ * decompression before we can fully parse the message contents.
+ */
+int smb1_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len)
+{
+	/* There are no transformations in SMB1. */
+	smb1_parse_pdu(server, &server->rx_queue);
+	return 0;
+}
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6c9c229b91f6..6789049db053 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -590,7 +590,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 		char *buf = rsp_iov[i + 1].iov_base;
 
 		if (buf && resp_buftype[i + 1] != CIFS_NO_BUFFER)
-			rc = server->ops->map_error(buf, false);
+			rc = map_smb2_to_linux_error((struct smb2_hdr *)buf, false);
 		else
 			rc = tmp_rc;
 		switch (cmds[i]) {
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 9ed21f7b618c..e4ec8c777d78 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -47,9 +47,8 @@ static const struct status_to_posix_error *smb2_get_err_map(__u32 smb2_status)
 }
 
 int
-map_smb2_to_linux_error(char *buf, bool log_err)
+map_smb2_to_linux_error(const struct smb2_hdr *shdr, bool log_err)
 {
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
 	const struct status_to_posix_error *err_map;
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 5c1d41baff7e..249606e5680e 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -20,7 +20,7 @@
 #include "cached_dir.h"
 
 static int
-check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
+check_smb2_hdr(const struct smb2_hdr *shdr, __u64 mid)
 {
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
@@ -58,38 +58,36 @@ check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
  *  Note that commands are defined in smb2pdu.h in le16 but the array below is
  *  indexed by command in host byte order
  */
-static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
-	/* SMB2_NEGOTIATE */ cpu_to_le16(65),
-	/* SMB2_SESSION_SETUP */ cpu_to_le16(9),
-	/* SMB2_LOGOFF */ cpu_to_le16(4),
-	/* SMB2_TREE_CONNECT */ cpu_to_le16(16),
-	/* SMB2_TREE_DISCONNECT */ cpu_to_le16(4),
-	/* SMB2_CREATE */ cpu_to_le16(89),
-	/* SMB2_CLOSE */ cpu_to_le16(60),
-	/* SMB2_FLUSH */ cpu_to_le16(4),
-	/* SMB2_READ */ cpu_to_le16(17),
-	/* SMB2_WRITE */ cpu_to_le16(17),
-	/* SMB2_LOCK */ cpu_to_le16(4),
-	/* SMB2_IOCTL */ cpu_to_le16(49),
+static const u16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
+	[SMB2_NEGOTIATE]	= 65,
+	[SMB2_SESSION_SETUP]	= 9,
+	[SMB2_LOGOFF]		= 4,
+	[SMB2_TREE_CONNECT]	= 16,
+	[SMB2_TREE_DISCONNECT]	= 4,
+	[SMB2_CREATE]		= 89,
+	[SMB2_CLOSE]		= 60,
+	[SMB2_FLUSH]		= 4,
+	[SMB2_READ]		= 17,
+	[SMB2_WRITE]		= 17,
+	[SMB2_LOCK]		= 4,
+	[SMB2_IOCTL]		= 49,
 	/* BB CHECK this ... not listed in documentation */
-	/* SMB2_CANCEL */ cpu_to_le16(0),
-	/* SMB2_ECHO */ cpu_to_le16(4),
-	/* SMB2_QUERY_DIRECTORY */ cpu_to_le16(9),
-	/* SMB2_CHANGE_NOTIFY */ cpu_to_le16(9),
-	/* SMB2_QUERY_INFO */ cpu_to_le16(9),
-	/* SMB2_SET_INFO */ cpu_to_le16(2),
-	/* BB FIXME can also be 44 for lease break */
-	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
+	[SMB2_CANCEL]		= 0,
+	[SMB2_ECHO]		= 4,
+	[SMB2_QUERY_DIRECTORY]	= 9,
+	[SMB2_CHANGE_NOTIFY]	= 9,
+	[SMB2_QUERY_INFO]	= 9,
+	[SMB2_SET_INFO]		= 2,
+	[SMB2_OPLOCK_BREAK]	= 24, /* BB FIXME can also be 44 for lease break */
 };
 
 #define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
-static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
-			      __u32 non_ctxlen)
+static __u32 get_neg_ctxt_len(const struct smb2_negotiate_rsp *pneg_rsp,
+			      __u32 len, __u32 non_ctxlen)
 {
 	__u16 neg_count;
 	__u32 nc_offset, size_of_pad_before_neg_ctxts;
-	struct smb2_negotiate_rsp *pneg_rsp = (struct smb2_negotiate_rsp *)hdr;
 
 	/* Negotiate contexts are only valid for latest dialect SMB3.11 */
 	neg_count = le16_to_cpu(pneg_rsp->NegotiateContextCount);
@@ -133,47 +131,27 @@ static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 	return (len - nc_offset) + size_of_pad_before_neg_ctxts;
 }
 
+/*
+ * Check the sizes of various parts of the message and retrieve the data area
+ * offset and length if there is one.
+ */
 int
-smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
-		   struct TCP_Server_Info *server)
+smb2_check_message(struct TCP_Server_Info *server, struct cifs_receive *recv)
 {
-	struct TCP_Server_Info *pserver;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
+	union smb2_response_hdr *h = recv->response;
+	struct smb2_hdr *shdr = &h->hdr;
+	const unsigned int len = recv->msg_len;
 	int hdr_size = sizeof(struct smb2_hdr);
 	int pdu_size = sizeof(struct smb2_pdu);
-	int command;
 	__u32 calc_len; /* calculated length */
 	__u64 mid;
-
-	/* If server is a channel, select the primary channel */
-	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
+        u16 command;
+	u16 ssize2 = le16_to_cpu(h->StructureSize2);
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
 	 * ie Validate the wct via smb2_struct_sizes table above
 	 */
-	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
-		struct smb2_transform_hdr *thdr =
-			(struct smb2_transform_hdr *)buf;
-		struct cifs_ses *ses = NULL;
-		struct cifs_ses *iter;
-
-		/* decrypt frame now that it is completely read in */
-		spin_lock(&cifs_tcp_ses_lock);
-		list_for_each_entry(iter, &pserver->smb_ses_list, smb_ses_list) {
-			if (iter->Suid == le64_to_cpu(thdr->SessionId)) {
-				ses = iter;
-				break;
-			}
-		}
-		spin_unlock(&cifs_tcp_ses_lock);
-		if (!ses) {
-			cifs_dbg(VFS, "no decryption - session id not found\n");
-			return 1;
-		}
-	}
-
 	mid = le64_to_cpu(shdr->MessageId);
 	if (check_smb2_hdr(shdr, mid))
 		return 1;
@@ -193,7 +171,7 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
-			pdu->StructureSize2 = 0;
+			h->StructureSize2 = 0;
 			/*
 			 * As with SMB/CIFS, on some error cases servers may
 			 * not return wct properly
@@ -204,31 +182,32 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		}
 		return 1;
 	}
-	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
-		cifs_dbg(VFS, "SMB length greater than maximum, mid=%llu\n",
-			 mid);
+	if (len > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE &&
+	    command != SMB2_READ_HE) {
+		cifs_dbg(VFS, "SMB length (%u) greater than maximum (%u), mid=%llu\n",
+			 len, CIFSMaxBufSize + MAX_SMB2_HDR_SIZE, mid);
 		return 1;
 	}
 
-	if (smb2_rsp_struct_sizes[command] != pdu->StructureSize2) {
-		if (command != SMB2_OPLOCK_BREAK_HE && (shdr->Status == 0 ||
-		    pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
+	if (ssize2 != smb2_rsp_struct_sizes[command]) {
+		if (command != SMB2_OPLOCK_BREAK_HE &&
+		    (shdr->Status == 0 || ssize2 != SMB2_ERROR_STRUCTURE_SIZE2)) {
 			/* error packets have 9 byte structure size */
 			cifs_dbg(VFS, "Invalid response size %u for command %d\n",
-				 le16_to_cpu(pdu->StructureSize2), command);
+				 ssize2, command);
 			return 1;
 		} else if (command == SMB2_OPLOCK_BREAK_HE
 			   && (shdr->Status == 0)
-			   && (le16_to_cpu(pdu->StructureSize2) != 44)
-			   && (le16_to_cpu(pdu->StructureSize2) != 36)) {
+			   && (ssize2 != 44)
+			   && (ssize2 != 36)) {
 			/* special case for SMB2.1 lease break message */
 			cifs_dbg(VFS, "Invalid response size %d for oplock break\n",
-				 le16_to_cpu(pdu->StructureSize2));
+				 ssize2);
 			return 1;
 		}
 	}
 
-	calc_len = smb2_calc_size(buf);
+	smb2_calc_size(recv);
 
 	/* For SMB2_IOCTL, OutputOffset and OutputLength are optional, so might
 	 * be 0, and not a real miscalculation */
@@ -236,7 +215,7 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		return 0;
 
 	if (command == SMB2_NEGOTIATE_HE)
-		calc_len += get_neg_ctxt_len(shdr, len, calc_len);
+		calc_len += get_neg_ctxt_len(&h->neg, len, calc_len);
 
 	if (len != calc_len) {
 		/* create failed on symlink */
@@ -288,25 +267,25 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
  * with no variable length info, show an offset of zero for the offset field.
  */
 static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
-	/* SMB2_NEGOTIATE */ true,
-	/* SMB2_SESSION_SETUP */ true,
-	/* SMB2_LOGOFF */ false,
-	/* SMB2_TREE_CONNECT */	false,
-	/* SMB2_TREE_DISCONNECT */ false,
-	/* SMB2_CREATE */ true,
-	/* SMB2_CLOSE */ false,
-	/* SMB2_FLUSH */ false,
-	/* SMB2_READ */	true,
-	/* SMB2_WRITE */ false,
-	/* SMB2_LOCK */	false,
-	/* SMB2_IOCTL */ true,
-	/* SMB2_CANCEL */ false, /* BB CHECK this not listed in documentation */
-	/* SMB2_ECHO */ false,
-	/* SMB2_QUERY_DIRECTORY */ true,
-	/* SMB2_CHANGE_NOTIFY */ true,
-	/* SMB2_QUERY_INFO */ true,
-	/* SMB2_SET_INFO */ false,
-	/* SMB2_OPLOCK_BREAK */ false
+	[SMB2_NEGOTIATE_HE]		= true,
+	[SMB2_SESSION_SETUP_HE]		= true,
+	[SMB2_LOGOFF_HE]		= false,
+	[SMB2_TREE_CONNECT_HE]		= false,
+	[SMB2_TREE_DISCONNECT_HE]	= false,
+	[SMB2_CREATE_HE]		= true,
+	[SMB2_CLOSE_HE]			= false,
+	[SMB2_FLUSH_HE]			= false,
+	[SMB2_READ_HE]			= true,
+	[SMB2_WRITE_HE]			= false,
+	[SMB2_LOCK_HE]			= false,
+	[SMB2_IOCTL_HE]			= true,
+	[SMB2_CANCEL_HE]		= false, /* BB CHECK this not listed in documentation */
+	[SMB2_ECHO_HE]			= false,
+	[SMB2_QUERY_DIRECTORY_HE]	= true,
+	[SMB2_CHANGE_NOTIFY_HE]		= true,
+	[SMB2_QUERY_INFO_HE]		= true,
+	[SMB2_SET_INFO_HE]		= false,
+	[SMB2_OPLOCK_BREAK_HE]		= false,
 };
 
 /*
@@ -314,18 +293,19 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * area and the offset to it (from the beginning of the smb are also returned.
  */
 char *
-smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
+smb2_get_data_area_len(struct cifs_receive *recv)
 {
-	const int max_off = 4096;
-	const int max_len = 128 * 1024;
+	const union smb2_response_hdr *h = recv->response;
+	const struct smb2_hdr *shdr = &h->hdr;
+	u16 command = le16_to_cpu(shdr->Command);
+	int off, len;
 
-	*off = 0;
-	*len = 0;
+	recv->data_offset = 0;
+	recv->data_len = 0;
 
 	/* error responses do not have data area */
 	if (shdr->Status && shdr->Status != STATUS_MORE_PROCESSING_REQUIRED &&
-	    (((struct smb2_err_rsp *)shdr)->StructureSize) ==
-						SMB2_ERROR_STRUCTURE_SIZE2_LE)
+	    h->StructureSize2 == SMB2_ERROR_STRUCTURE_SIZE2_LE)
 		return NULL;
 
 	/*
@@ -333,53 +313,49 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 	 * of the data buffer offset and data buffer length for the particular
 	 * command.
 	 */
-	switch (shdr->Command) {
-	case SMB2_NEGOTIATE:
-		*off = le16_to_cpu(
-		  ((struct smb2_negotiate_rsp *)shdr)->SecurityBufferOffset);
-		*len = le16_to_cpu(
-		  ((struct smb2_negotiate_rsp *)shdr)->SecurityBufferLength);
+	switch (command) {
+	case SMB2_NEGOTIATE_HE:
+		off = le16_to_cpu(h->neg.SecurityBufferOffset);
+		len = le16_to_cpu(h->neg.SecurityBufferLength);
 		break;
-	case SMB2_SESSION_SETUP:
-		*off = le16_to_cpu(
-		  ((struct smb2_sess_setup_rsp *)shdr)->SecurityBufferOffset);
-		*len = le16_to_cpu(
-		  ((struct smb2_sess_setup_rsp *)shdr)->SecurityBufferLength);
+	case SMB2_SESSION_SETUP_HE:
+		off = le16_to_cpu(h->sess.SecurityBufferOffset);
+		len = le16_to_cpu(h->sess.SecurityBufferLength);
 		break;
-	case SMB2_CREATE:
-		*off = le32_to_cpu(
-		    ((struct smb2_create_rsp *)shdr)->CreateContextsOffset);
-		*len = le32_to_cpu(
-		    ((struct smb2_create_rsp *)shdr)->CreateContextsLength);
+	case SMB2_CREATE_HE:
+		off = le32_to_cpu(h->create.CreateContextsOffset);
+		len = le32_to_cpu(h->create.CreateContextsLength);
 		break;
-	case SMB2_QUERY_INFO:
-		*off = le16_to_cpu(
-		    ((struct smb2_query_info_rsp *)shdr)->OutputBufferOffset);
-		*len = le32_to_cpu(
-		    ((struct smb2_query_info_rsp *)shdr)->OutputBufferLength);
+	case SMB2_QUERY_INFO_HE:
+		off = le16_to_cpu(h->qinfo.OutputBufferOffset);
+		len = le32_to_cpu(h->qinfo.OutputBufferLength);
 		break;
-	case SMB2_READ:
+	case SMB2_READ_HE:
 		/* TODO: is this a bug ? */
-		*off = ((struct smb2_read_rsp *)shdr)->DataOffset;
-		*len = le32_to_cpu(((struct smb2_read_rsp *)shdr)->DataLength);
+		off = h->read.DataOffset;
+		len = le32_to_cpu(h->read.DataLength);
+		if (off == 0) {
+			/*
+			 * win2k8 sometimes sends an offset of 0 when
+			 * the read is beyond the EOF. Treat it as if
+			 * the data starts just after the header.
+			 */
+			cifs_dbg(FYI, "%s: data offset (%u) inside read response header\n",
+				 __func__, off);
+			off = sizeof(h->read);
+		}
 		break;
-	case SMB2_QUERY_DIRECTORY:
-		*off = le16_to_cpu(
-		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferOffset);
-		*len = le32_to_cpu(
-		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferLength);
+	case SMB2_QUERY_DIRECTORY_HE:
+		off = le16_to_cpu(h->qdir.OutputBufferOffset);
+		len = le32_to_cpu(h->qdir.OutputBufferLength);
 		break;
-	case SMB2_IOCTL:
-		*off = le32_to_cpu(
-		  ((struct smb2_ioctl_rsp *)shdr)->OutputOffset);
-		*len = le32_to_cpu(
-		  ((struct smb2_ioctl_rsp *)shdr)->OutputCount);
+	case SMB2_IOCTL_HE:
+		off = le32_to_cpu(h->ioctl.OutputOffset);
+		len = le32_to_cpu(h->ioctl.OutputCount);
 		break;
-	case SMB2_CHANGE_NOTIFY:
-		*off = le16_to_cpu(
-		  ((struct smb2_change_notify_rsp *)shdr)->OutputBufferOffset);
-		*len = le32_to_cpu(
-		  ((struct smb2_change_notify_rsp *)shdr)->OutputBufferLength);
+	case SMB2_CHANGE_NOTIFY_HE:
+		off = le16_to_cpu(h->change.OutputBufferOffset);
+		len = le32_to_cpu(h->change.OutputBufferLength);
 		break;
 	default:
 		cifs_dbg(VFS, "no length check for command %d\n", le16_to_cpu(shdr->Command));
@@ -390,19 +366,21 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 	 * Invalid length or offset probably means data area is invalid, but
 	 * we have little choice but to ignore the data area in this case.
 	 */
-	if (unlikely(*off < 0 || *off > max_off ||
-		     *len < 0 || *len > max_len)) {
+	if (unlikely(off < 0 || len < 0)) {
 		cifs_dbg(VFS, "%s: invalid data area (off=%d len=%d)\n",
-			 __func__, *off, *len);
-		*off = 0;
-		*len = 0;
-	} else if (*off == 0) {
-		*len = 0;
+			 __func__, off, len);
+		off = 0;
+		len = 0;
+	} else if (off == 0) {
+		len = 0;
 	}
 
 	/* return pointer to beginning of data area, ie offset from SMB start */
-	if (*off > 0 && *len > 0)
-		return (char *)shdr + *off;
+	if (off > 0 && len > 0) {
+		recv->data_offset = off;
+		recv->data_len = len;
+		return (char *)shdr + off;
+	}
 	return NULL;
 }
 
@@ -410,46 +388,37 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
  * Calculate the size of the SMB message based on the fixed header
  * portion, the number of word parameters and the data portion of the message.
  */
-unsigned int
-smb2_calc_size(void *buf)
+void
+smb2_calc_size(struct cifs_receive *recv)
 {
-	struct smb2_pdu *pdu = buf;
-	struct smb2_hdr *shdr = &pdu->hdr;
-	int offset; /* the offset from the beginning of SMB to data area */
-	int data_length; /* the length of the variable length data area */
-	/* Structure Size has already been checked to make sure it is 64 */
-	int len = le16_to_cpu(shdr->StructureSize);
+	const union smb2_response_hdr *h = recv->response;
+	const struct smb2_hdr *shdr = &h->hdr;
+	u16 command = le16_to_cpu(shdr->Command);
 
-	/*
-	 * StructureSize2, ie length of fixed parameter area has already
-	 * been checked to make sure it is the correct length.
-	 */
-	len += le16_to_cpu(pdu->StructureSize2);
+	recv->calc_len = recv->hdr_len;
+	WARN_ON_ONCE(!recv->calc_len);
 
-	if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
+	if (command >= ARRAY_SIZE(has_smb2_data_area) ||
+	    has_smb2_data_area[command] == false)
 		goto calc_size_exit;
 
-	smb2_get_data_area_len(&offset, &data_length, shdr);
-	cifs_dbg(FYI, "SMB2 data length %d offset %d\n", data_length, offset);
+	smb2_get_data_area_len(recv);
+	cifs_dbg(FYI, "SMB2 data length %d offset %d\n",
+		 recv->data_len, recv->data_offset);
 
-	if (data_length > 0) {
-		/*
-		 * Check to make sure that data area begins after fixed area,
-		 * Note that last byte of the fixed area is part of data area
-		 * for some commands, typically those with odd StructureSize,
-		 * so we must add one to the calculation.
-		 */
-		if (offset + 1 < len) {
+	if (recv->data_len > 0) {
+		/* Check to make sure that data area begins after fixed area. */
+		if (recv->data_offset < recv->hdr_len) {
 			cifs_dbg(VFS, "data area offset %d overlaps SMB2 header %d\n",
-				 offset + 1, len);
-			data_length = 0;
-		} else {
-			len = offset + data_length;
+				 recv->data_offset, recv->hdr_len);
+			recv->data_offset = 0;
+			recv->data_len = 0;
+			goto calc_size_exit;
 		}
+		recv->calc_len = recv->data_offset + recv->data_len;
 	}
 calc_size_exit:
-	cifs_dbg(FYI, "SMB2 len %d\n", len);
-	return len;
+	cifs_dbg(FYI, "SMB2 len %d\n", recv->calc_len);
 }
 
 /* Note: caller must free return buffer */
@@ -598,10 +567,11 @@ smb2_tcon_find_pending_open_lease(struct cifs_tcon *tcon,
 	return found;
 }
 
-static bool
-smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
+static void
+smb2_is_valid_lease_break(struct TCP_Server_Info *server,
+			  union smb2_response_hdr *h)
 {
-	struct smb2_lease_break *rsp = (struct smb2_lease_break *)buffer;
+	struct smb2_lease_break *rsp = &h->lease;
 	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -633,7 +603,7 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 			if (smb2_tcon_has_lease(tcon, rsp)) {
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
-				return true;
+				return;
 			}
 			open = smb2_tcon_find_pending_open_lease(tcon,
 								 rsp);
@@ -649,13 +619,13 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 				smb2_queue_pending_open_break(tlink,
 							      lease_key,
 							      rsp->NewLeaseState);
-				return true;
+				return;
 			}
 			spin_unlock(&tcon->open_file_lock);
 
 			if (cached_dir_lease_break(tcon, rsp->LeaseKey)) {
 				spin_unlock(&cifs_tcp_ses_lock);
-				return true;
+				return;
 			}
 		}
 	}
@@ -669,30 +639,27 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 					   *((u64 *)rsp->LeaseKey),
 					   *((u64 *)&rsp->LeaseKey[8]));
 
-	return false;
 }
 
-bool
-smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
+void
+smb2_is_valid_oplock_break(struct TCP_Server_Info *server,
+			   union smb2_response_hdr *h)
 {
-	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct smb2_oplock_break *rsp = &h->oplock;
 	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 	struct cifsInodeInfo *cinode;
 	struct cifsFileInfo *cfile;
+	u16 ssize2 = le16_to_cpu(h->StructureSize2);
 
 	cifs_dbg(FYI, "Checking for oplock break\n");
 
-	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
-		return false;
-
-	if (rsp->StructureSize !=
-				smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
-		if (le16_to_cpu(rsp->StructureSize) == 44)
-			return smb2_is_valid_lease_break(buffer, server);
-		else
-			return false;
+	if (ssize2 != smb2_rsp_struct_sizes[SMB2_OPLOCK_BREAK_HE]) {
+		if (ssize2 == 44)
+			return smb2_is_valid_lease_break(server, h);
+		WARN(1, "Invalid oplock break 0x%x\n", ssize2);
+		return;
 	}
 
 	cifs_dbg(FYI, "oplock level 0x%x\n", rsp->OplockLevel);
@@ -738,7 +705,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 				spin_unlock(&tcon->open_file_lock);
 				spin_unlock(&cifs_tcp_ses_lock);
-				return true;
+				return;
 			}
 			spin_unlock(&tcon->open_file_lock);
 		}
@@ -748,8 +715,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	trace_smb3_oplock_not_found(0 /* no xid */, rsp->PersistentFid,
 				  le32_to_cpu(rsp->hdr.Id.SyncId.TreeId),
 				  le64_to_cpu(rsp->hdr.SessionId));
-
-	return true;
+	return;
 }
 
 void
@@ -845,8 +811,8 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 int
 smb2_handle_cancelled_mid(struct smb_message *smb, struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *hdr = smb->resp_buf;
-	struct smb2_create_rsp *rsp = smb->resp_buf;
+	struct smb2_hdr *hdr = smb->response;
+	struct smb2_create_rsp *rsp = smb->response;
 	struct cifs_tcon *tcon;
 	int rc;
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 10bb0fe6b77b..3c30417a3ea6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -13,6 +13,7 @@
 #include <linux/sort.h>
 #include <crypto/aead.h>
 #include <linux/fiemap.h>
+#include <linux/iov_iter.h>
 #include <uapi/linux/magic.h>
 #include "cifsfs.h"
 #include "cifsglob.h"
@@ -379,6 +380,28 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 	return 0;
 }
 
+void
+smb2_add_credits_from_hdr(struct smb2_hdr *shdr, struct TCP_Server_Info *server)
+{
+	int scredits, in_flight;
+
+	if (shdr->CreditRequest) {
+		spin_lock(&server->req_lock);
+		server->credits += le16_to_cpu(shdr->CreditRequest);
+		scredits = server->credits;
+		in_flight = server->in_flight;
+		spin_unlock(&server->req_lock);
+		wake_up(&server->request_q);
+
+		trace_smb3_hdr_credits(server->current_mid,
+				server->conn_id, server->hostname, scredits,
+				le16_to_cpu(shdr->CreditRequest), in_flight);
+		cifs_server_dbg(FYI, "%s: added %u credits total=%d\n",
+				__func__, le16_to_cpu(shdr->CreditRequest),
+				scredits);
+	}
+}
+
 static __u64
 smb2_get_next_mid(struct TCP_Server_Info *server)
 {
@@ -399,12 +422,11 @@ smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 	spin_unlock(&server->mid_counter_lock);
 }
 
-static struct smb_message *
-__smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
+struct smb_message *
+smb2_find_mid(struct TCP_Server_Info *server, struct smb2_hdr *shdr, bool dequeue)
 {
 	struct smb_message *smb;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
+	u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
 	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
 		cifs_server_dbg(VFS, "Encrypted frame parsing not supported yet\n");
@@ -429,33 +451,63 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 	return NULL;
 }
 
-static struct smb_message *
-smb2_find_mid(struct TCP_Server_Info *server, char *buf)
+#ifdef CONFIG_CIFS_DEBUG2
+void
+smb2_dump_detail(struct TCP_Server_Info *server, const struct cifs_receive *recv)
 {
-	return __smb2_find_mid(server, buf, false);
-}
+	const union smb2_response_hdr *h = recv->response;
+	const struct smb2_hdr *shdr = &h->hdr;
 
-static struct smb_message *
-smb2_find_dequeue_mid(struct TCP_Server_Info *server, char *buf)
-{
-	return __smb2_find_mid(server, buf, true);
+	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
+		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
+		 shdr->Id.SyncId.ProcessId);
+	if (recv->malformed)
+		cifs_server_dbg(VFS, "smb buf %p len %u\n",
+				recv->response, recv->calc_len);
 }
 
-static void
-smb2_dump_detail(void *buf, size_t buf_len, struct TCP_Server_Info *server)
+void smb2_dump_mids(struct TCP_Server_Info *server)
 {
-#ifdef CONFIG_CIFS_DEBUG2
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	struct smb_message *smb;
 
-	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
-		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
-		 shdr->Id.SyncId.ProcessId);
-	if (!server->ops->check_message(buf, buf_len, server->total_read, server)) {
-		cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
-				server->ops->calc_smb_size(buf));
+	if (server == NULL)
+		return;
+
+	cifs_dbg(VFS, "Dump pending requests:\n");
+	spin_lock(&server->mid_queue_lock);
+	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
+		struct cifs_receive recv = {
+			.response	= smb->response,
+			.msg_len	= smb->resp_len,
+			.error		= smb->error,
+			.data_len	= smb->resp_data_len,
+			.data_offset	= smb->resp_data_offset,
+		};
+
+		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
+			 smb->mid_state,
+			 smb->command,
+			 smb->pid,
+			 smb->callback_data,
+			 smb->mid);
+#ifdef CONFIG_CIFS_STATS2
+		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
+			 smb->large_buf,
+			 smb->response,
+			 smb->when_received,
+			 jiffies);
+#endif /* STATS2 */
+		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
+			 smb->multiRsp, smb->multiEnd);
+		if (recv.response) {
+			smb2_dump_detail(server, &recv);
+			cifs_dump_mem("existing buf: ",
+				      recv.response, umin(recv.msg_len, 62));
+		}
 	}
-#endif
+	spin_unlock(&server->mid_queue_lock);
 }
+#endif /* CONFIG_CIFS_DEBUG2 */
 
 static bool
 smb2_need_neg(struct TCP_Server_Info *server)
@@ -2074,26 +2126,6 @@ smb2_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
 	return SMB2_flush(xid, tcon, fid->persistent_fid, fid->volatile_fid);
 }
 
-static unsigned int
-smb2_read_data_offset(char *buf)
-{
-	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
-
-	return rsp->DataOffset;
-}
-
-static unsigned int
-smb2_read_data_length(char *buf, bool in_remaining)
-{
-	struct smb2_read_rsp *rsp = (struct smb2_read_rsp *)buf;
-
-	if (in_remaining)
-		return le32_to_cpu(rsp->DataRemaining);
-
-	return le32_to_cpu(rsp->DataLength);
-}
-
-
 static int
 smb2_sync_read(const unsigned int xid, struct cifs_fid *pfid,
 	       struct cifs_io_parms *parms, unsigned int *bytes_read,
@@ -2610,15 +2642,11 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
  * If we negotiate SMB2 protocol and get STATUS_PENDING - update
  * the number of credits and return true. Otherwise - return false.
  */
-static bool
-smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
+bool
+smb2_status_pending(struct smb2_hdr *shdr, struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	int scredits, in_flight;
 
-	if (shdr->Status != STATUS_PENDING)
-		return false;
-
 	if (shdr->CreditRequest) {
 		spin_lock(&server->req_lock);
 		server->credits += le16_to_cpu(shdr->CreditRequest);
@@ -2637,46 +2665,13 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 	return true;
 }
 
-static bool
-smb2_is_session_expired(char *buf)
-{
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-
-	if (shdr->Status != STATUS_NETWORK_SESSION_EXPIRED &&
-	    shdr->Status != STATUS_USER_SESSION_DELETED)
-		return false;
-
-	trace_smb3_ses_expired(le32_to_cpu(shdr->Id.SyncId.TreeId),
-			       le64_to_cpu(shdr->SessionId),
-			       le16_to_cpu(shdr->Command),
-			       le64_to_cpu(shdr->MessageId));
-	cifs_dbg(FYI, "Session expired or deleted\n");
-
-	return true;
-}
-
-static bool
-smb2_is_status_io_timeout(char *buf)
-{
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-
-	if (shdr->Status == STATUS_IO_TIMEOUT)
-		return true;
-	else
-		return false;
-}
-
-static bool
-smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
+bool
+smb2_network_name_is_deleted(struct smb2_hdr *shdr, struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct TCP_Server_Info *pserver;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
 
-	if (shdr->Status != STATUS_NETWORK_NAME_DELETED)
-		return false;
-
 	/* If server is a channel, select the primary channel */
 	pserver = SERVER_IS_CHAN(server) ? server->primary_server : server;
 
@@ -4430,7 +4425,7 @@ static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
 	return p;
 }
 
-static int
+int
 smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 {
 	struct TCP_Server_Info *pserver;
@@ -4535,82 +4530,6 @@ encrypt_message(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
-/*
- * Decrypt @rqst message. @rqst[0] has the following format:
- * iov[0]   - transform header (associate data),
- * iov[1-N] - SMB2 header and pages - data to decrypt.
- * On success return encrypted data in iov[1-N] and pages, leave iov[0]
- * untouched.
- */
-static int
-decrypt_message(struct TCP_Server_Info *server, int num_rqst,
-		struct smb_rqst *rqst, struct crypto_aead *tfm)
-{
-	struct smb2_transform_hdr *tr_hdr =
-		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
-	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
-	int rc = 0;
-	struct scatterlist *sg;
-	u8 sign[SMB2_SIGNATURE_SIZE] = {};
-	u8 key[SMB3_ENC_DEC_KEY_SIZE];
-	struct aead_request *req;
-	u8 *iv;
-	DECLARE_CRYPTO_WAIT(wait);
-	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
-	void *creq;
-
-	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), 0, key);
-	if (rc) {
-		cifs_server_dbg(FYI, "%s: Could not get decryption key. sid: 0x%llx\n",
-				__func__, le64_to_cpu(tr_hdr->SessionId));
-		return rc;
-	}
-
-	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
-		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
-	else
-		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
-
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
-		return rc;
-	}
-
-	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
-	if (rc) {
-		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
-		return rc;
-	}
-
-	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg);
-	if (IS_ERR(creq))
-		return PTR_ERR(creq);
-
-	memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
-	crypt_len += SMB2_SIGNATURE_SIZE;
-
-	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
-	else {
-		iv[0] = 3;
-		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
-	}
-
-	aead_request_set_tfm(req, tfm);
-	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
-	aead_request_set_ad(req, assoc_data_len);
-
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  crypto_req_done, &wait);
-
-	rc = crypto_wait_req(crypto_aead_decrypt(req), &wait);
-
-	kfree_sensitive(creq);
-	return rc;
-}
-
 /*
  * Copy data from an iterator to the pages in a bvec queue buffer.
  */
@@ -4701,591 +4620,6 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
 	return rc;
 }
 
-static int
-smb3_is_transform_hdr(void *buf)
-{
-	struct smb2_transform_hdr *trhdr = buf;
-
-	return trhdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM;
-}
-
-static int
-decrypt_raw_data(struct TCP_Server_Info *server, char *buf,
-		 unsigned int buf_data_size, struct iov_iter *iter,
-		 bool is_offloaded)
-{
-	struct crypto_aead *tfm;
-	struct smb_rqst rqst = {NULL};
-	struct kvec iov[2];
-	size_t iter_size = 0;
-	int rc;
-
-	iov[0].iov_base = buf;
-	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
-	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
-	iov[1].iov_len = buf_data_size;
-
-	rqst.rq_iov = iov;
-	rqst.rq_nvec = 2;
-	if (iter) {
-		rqst.rq_iter = *iter;
-		iter_size = iov_iter_count(iter);
-	}
-
-	if (is_offloaded) {
-		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
-		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
-			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
-		else
-			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
-		if (IS_ERR(tfm)) {
-			rc = PTR_ERR(tfm);
-			cifs_server_dbg(VFS, "%s: Failed alloc decrypt TFM, rc=%d\n", __func__, rc);
-
-			return rc;
-		}
-	} else {
-		rc = smb3_crypto_aead_allocate(server);
-		if (unlikely(rc))
-			return rc;
-		tfm = server->secmech.dec;
-	}
-
-	rc = decrypt_message(server, 1, &rqst, tfm);
-	cifs_dbg(FYI, "Decrypt message returned %d\n", rc);
-
-	if (is_offloaded)
-		crypto_free_aead(tfm);
-
-	if (rc)
-		return rc;
-
-	memmove(buf, iov[1].iov_base, buf_data_size);
-
-	if (!is_offloaded)
-		server->total_read = buf_data_size + iter_size;
-
-	return rc;
-}
-
-static int
-cifs_copy_bvecq_to_iter(struct bvecq *bq, size_t data_size,
-			size_t skip, struct iov_iter *iter)
-{
-	for (; bq; bq = bq->next) {
-		for (int s = 0; s < bq->nr_slots; s++) {
-			struct bio_vec *bv = &bq->bv[s];
-			size_t n, len = umin(bv->bv_len - skip, data_size);
-
-			n = copy_page_to_iter(bv->bv_page, bv->bv_offset + skip, len, iter);
-			if (n != len) {
-				cifs_dbg(VFS, "%s: something went wrong\n", __func__);
-				return smb_EIO2(smb_eio_trace_rx_copy_to_iter,
-						n, len);
-			}
-			data_size -= n;
-			skip = 0;
-		}
-	}
-
-	return 0;
-}
-
-static int
-handle_read_data(struct TCP_Server_Info *server, struct smb_message *smb,
-		 char *buf, unsigned int buf_len, struct bvecq *buffer,
-		 unsigned int buffer_len, bool is_offloaded)
-{
-	unsigned int data_offset;
-	unsigned int data_len;
-	unsigned int end_off;
-	unsigned int cur_off;
-	unsigned int cur_page_idx;
-	unsigned int pad_len;
-	struct cifs_io_subrequest *rdata = smb->callback_data;
-	struct iov_iter iter;
-	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
-	size_t copied;
-	bool use_rdma_mr = false;
-
-	if (shdr->Command != SMB2_READ) {
-		cifs_server_dbg(VFS, "only big read responses are supported\n");
-		return -EOPNOTSUPP;
-	}
-
-	if (server->ops->is_session_expired &&
-	    server->ops->is_session_expired(buf)) {
-		if (!is_offloaded)
-			cifs_reconnect(server, true);
-		return -1;
-	}
-
-	if (server->ops->is_status_pending &&
-			server->ops->is_status_pending(buf, server))
-		return -1;
-
-	/* set up first two iov to get credits */
-	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = 0;
-	rdata->iov[1].iov_base = buf;
-	rdata->iov[1].iov_len =
-		min_t(unsigned int, buf_len, server->vals->read_rsp_size);
-	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
-		 rdata->iov[0].iov_base, rdata->iov[0].iov_len);
-	cifs_dbg(FYI, "1: iov_base=%p iov_len=%zu\n",
-		 rdata->iov[1].iov_base, rdata->iov[1].iov_len);
-
-	rdata->result = server->ops->map_error(buf, true);
-	if (rdata->result != 0) {
-		cifs_dbg(FYI, "%s: server returned error %d\n",
-			 __func__, rdata->result);
-		/* normal error on read response */
-		if (is_offloaded)
-			smb->mid_state = MID_RESPONSE_RECEIVED;
-		else
-			dequeue_mid(server, smb, false);
-		return 0;
-	}
-
-	data_offset = server->ops->read_data_offset(buf);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	use_rdma_mr = rdata->mr;
-#endif
-	data_len = server->ops->read_data_length(buf, use_rdma_mr);
-
-	if (data_offset < server->vals->read_rsp_size) {
-		/*
-		 * win2k8 sometimes sends an offset of 0 when the read
-		 * is beyond the EOF. Treat it as if the data starts just after
-		 * the header.
-		 */
-		cifs_dbg(FYI, "%s: data offset (%u) inside read response header\n",
-			 __func__, data_offset);
-		data_offset = server->vals->read_rsp_size;
-	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
-		/* data_offset is beyond the end of smallbuf */
-		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
-			 __func__, data_offset);
-		rdata->result = smb_EIO1(smb_eio_trace_rx_overlong, data_offset);
-		if (is_offloaded)
-			smb->mid_state = MID_RESPONSE_MALFORMED;
-		else
-			dequeue_mid(server, smb, rdata->result);
-		return 0;
-	}
-
-	pad_len = data_offset - server->vals->read_rsp_size;
-
-	iov_iter_bvec_queue(&iter, ITER_DEST,
-			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-			    rdata->subreq.content.offset, rdata->subreq.len);
-
-	if (buf_len <= data_offset) {
-		/* read response payload is in pages */
-		cur_page_idx = pad_len / PAGE_SIZE;
-		cur_off = pad_len % PAGE_SIZE;
-
-		if (cur_page_idx != 0) {
-			/* data offset is beyond the 1st page of response */
-			cifs_dbg(FYI, "%s: data offset (%u) beyond 1st page of response\n",
-				 __func__, data_offset);
-			rdata->result = smb_EIO1(smb_eio_trace_rx_overpage, data_offset);
-			if (is_offloaded)
-				smb->mid_state = MID_RESPONSE_MALFORMED;
-			else
-				dequeue_mid(server, smb, rdata->result);
-			return 0;
-		}
-
-		if (data_len > buffer_len - pad_len) {
-			/* data_len is corrupt -- discard frame */
-			rdata->result = smb_EIO1(smb_eio_trace_rx_bad_datalen, data_len);
-			if (is_offloaded)
-				smb->mid_state = MID_RESPONSE_MALFORMED;
-			else
-				dequeue_mid(server, smb, rdata->result);
-			return 0;
-		}
-
-		/* Copy the data to the output I/O iterator. */
-		rdata->result = cifs_copy_bvecq_to_iter(buffer, buffer_len,
-							cur_off, &iter);
-		if (rdata->result != 0) {
-			if (is_offloaded)
-				smb->mid_state = MID_RESPONSE_MALFORMED;
-			else
-				dequeue_mid(server, smb, rdata->result);
-			return 0;
-		}
-		rdata->got_bytes = buffer_len;
-
-	} else if (!check_add_overflow(data_offset, data_len, &end_off) &&
-		   buf_len >= end_off) {
-		/* read response payload is in buf */
-		WARN_ONCE(buffer, "read data can be either in buf or in buffer");
-		copied = copy_to_iter(buf + data_offset, data_len, &iter);
-		if (copied == 0)
-			return smb_EIO2(smb_eio_trace_rx_copy_to_iter, copied, data_len);
-		rdata->got_bytes = copied;
-	} else {
-		/* read response payload cannot be in both buf and pages */
-		WARN_ONCE(1, "buf can not contain only a part of read data");
-		rdata->result = smb_EIO(smb_eio_trace_rx_both_buf);
-		if (is_offloaded)
-			smb->mid_state = MID_RESPONSE_MALFORMED;
-		else
-			dequeue_mid(server, smb, rdata->result);
-		return 0;
-	}
-
-	if (is_offloaded)
-		smb->mid_state = MID_RESPONSE_RECEIVED;
-	else
-		dequeue_mid(server, smb, false);
-	return 0;
-}
-
-struct smb2_decrypt_work {
-	struct work_struct decrypt;
-	struct TCP_Server_Info *server;
-	struct bvecq *buffer;
-	char *buf;
-	unsigned int len;
-};
-
-
-static void smb2_decrypt_offload(struct work_struct *work)
-{
-	struct smb2_decrypt_work *dw = container_of(work,
-				struct smb2_decrypt_work, decrypt);
-	int rc;
-	struct smb_message *smb;
-	struct iov_iter iter;
-
-	iov_iter_bvec_queue(&iter, ITER_DEST, dw->buffer, 0, 0, dw->len);
-	rc = decrypt_raw_data(dw->server, dw->buf, dw->server->vals->read_rsp_size,
-			      &iter, true);
-	if (rc) {
-		cifs_dbg(VFS, "error decrypting rc=%d\n", rc);
-		goto free_pages;
-	}
-
-	dw->server->lstrp = jiffies;
-	smb = smb2_find_dequeue_mid(dw->server, dw->buf);
-	if (smb == NULL)
-		cifs_dbg(FYI, "mid not found\n");
-	else {
-		smb->decrypted = true;
-		rc = handle_read_data(dw->server, smb, dw->buf,
-				      dw->server->vals->read_rsp_size,
-				      dw->buffer, dw->len,
-				      true);
-		if (rc >= 0) {
-#ifdef CONFIG_CIFS_STATS2
-			smb->when_received = jiffies;
-#endif
-			if (dw->server->ops->is_network_name_deleted)
-				dw->server->ops->is_network_name_deleted(dw->buf,
-									 dw->server);
-
-			mid_execute_callback(dw->server, smb);
-		} else {
-			spin_lock(&dw->server->srv_lock);
-			if (dw->server->tcpStatus == CifsNeedReconnect) {
-				spin_lock(&dw->server->mid_queue_lock);
-				smb->mid_state = MID_RETRY_NEEDED;
-				spin_unlock(&dw->server->mid_queue_lock);
-				spin_unlock(&dw->server->srv_lock);
-				mid_execute_callback(dw->server, smb);
-			} else {
-				spin_lock(&dw->server->mid_queue_lock);
-				smb->mid_state = MID_REQUEST_SUBMITTED;
-				smb->deleted_from_q = false;
-				list_add_tail(&smb->qhead,
-					&dw->server->pending_mid_q);
-				spin_unlock(&dw->server->mid_queue_lock);
-				spin_unlock(&dw->server->srv_lock);
-			}
-		}
-		release_mid(dw->server, smb);
-	}
-
-free_pages:
-	bvecq_put(dw->buffer);
-	cifs_small_buf_release(dw->buf);
-	kfree(dw);
-}
-
-
-static int
-receive_encrypted_read(struct TCP_Server_Info *server, struct smb_message **smb,
-		       int *num_mids)
-{
-	char *buf = server->smallbuf;
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
-	struct iov_iter iter;
-	unsigned int len;
-	unsigned int buflen = server->pdu_size;
-	int rc;
-	struct smb2_decrypt_work *dw;
-
-	dw = kzalloc_obj(struct smb2_decrypt_work);
-	if (!dw)
-		return -ENOMEM;
-	INIT_WORK(&dw->decrypt, smb2_decrypt_offload);
-	dw->server = server;
-
-	*num_mids = 1;
-	len = min_t(unsigned int, buflen, server->vals->read_rsp_size +
-		sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) + 1;
-
-	rc = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1, len);
-	if (rc < 0)
-		goto free_dw;
-	server->total_read += rc;
-
-	if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
-	    server->vals->read_rsp_size) {
-		cifs_server_dbg(VFS, "OriginalMessageSize %u too small for read response (%zu)\n",
-			le32_to_cpu(tr_hdr->OriginalMessageSize),
-			server->vals->read_rsp_size);
-		rc = -EINVAL;
-		goto discard_data;
-	}
-	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
-		server->vals->read_rsp_size;
-	dw->len = len;
-	len = round_up(dw->len, PAGE_SIZE);
-
-	rc = -ENOMEM;
-	dw->buffer = bvecq_alloc_buffer(len, GFP_NOFS);
-	if (!dw->buffer)
-		goto discard_data;
-
-	iov_iter_bvec_queue(&iter, ITER_DEST, dw->buffer, 0, 0, len);
-
-	/* Read the data into the buffer and clear excess bufferage. */
-	rc = cifs_read_iter_from_socket(server, &iter, dw->len);
-	if (rc < 0)
-		goto discard_data;
-
-	server->total_read += rc;
-	if (rc < len) {
-		struct iov_iter tmp = iter;
-
-		iov_iter_advance(&tmp, rc);
-		iov_iter_zero(len - rc, &tmp);
-	}
-	iov_iter_truncate(&iter, dw->len);
-
-	rc = cifs_discard_remaining_data(server);
-	if (rc)
-		goto free_pages;
-
-	/*
-	 * For large reads, offload to different thread for better performance,
-	 * use more cores decrypting which can be expensive
-	 */
-
-	if ((server->min_offload) && (server->in_flight > 1) &&
-	    (server->pdu_size >= server->min_offload)) {
-		dw->buf = server->smallbuf;
-		server->smallbuf = (char *)cifs_small_buf_get();
-
-		queue_work(decrypt_wq, &dw->decrypt);
-		*num_mids = 0; /* worker thread takes care of finding mid */
-		return -1;
-	}
-
-	rc = decrypt_raw_data(server, buf, server->vals->read_rsp_size,
-			      &iter, false);
-	if (rc)
-		goto free_pages;
-
-	*smb = smb2_find_mid(server, buf);
-	if (*smb == NULL) {
-		cifs_dbg(FYI, "mid not found\n");
-	} else {
-		cifs_dbg(FYI, "mid found\n");
-		(*smb)->decrypted = true;
-		rc = handle_read_data(server, *smb, buf,
-				      server->vals->read_rsp_size,
-				      dw->buffer, dw->len, false);
-		if (rc >= 0) {
-			if (server->ops->is_network_name_deleted) {
-				server->ops->is_network_name_deleted(buf,
-								server);
-			}
-		}
-	}
-
-free_pages:
-	bvecq_put(dw->buffer);
-free_dw:
-	kfree(dw);
-	return rc;
-discard_data:
-	cifs_discard_remaining_data(server);
-	goto free_pages;
-}
-
-static int
-receive_encrypted_standard(struct TCP_Server_Info *server,
-			   struct smb_message **mids, char **bufs,
-			   int *num_mids)
-{
-	int ret, length;
-	char *buf = server->smallbuf;
-	struct smb2_hdr *shdr;
-	unsigned int pdu_length = server->pdu_size;
-	unsigned int buf_size;
-	unsigned int next_cmd;
-	struct smb_message *smb;
-	int next_is_large;
-	char *next_buffer = NULL;
-
-	*num_mids = 0;
-
-	/* switch to large buffer if too big for a small one */
-	if (pdu_length > MAX_CIFS_SMALL_BUFFER_SIZE) {
-		server->large_buf = true;
-		memcpy(server->bigbuf, buf, server->total_read);
-		buf = server->bigbuf;
-	}
-
-	/* now read the rest */
-	length = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1,
-				pdu_length - HEADER_SIZE(server) + 1);
-	if (length < 0)
-		return length;
-	server->total_read += length;
-
-	buf_size = pdu_length - sizeof(struct smb2_transform_hdr);
-	length = decrypt_raw_data(server, buf, buf_size, NULL, false);
-	if (length)
-		return length;
-
-	next_is_large = server->large_buf;
-one_more:
-	shdr = (struct smb2_hdr *)buf;
-	next_cmd = le32_to_cpu(shdr->NextCommand);
-	if (next_cmd) {
-		if (WARN_ON_ONCE(next_cmd > pdu_length))
-			return -1;
-		if (next_is_large)
-			next_buffer = (char *)cifs_buf_get();
-		else
-			next_buffer = (char *)cifs_small_buf_get();
-		if (!next_buffer) {
-			cifs_server_dbg(VFS, "No memory for (large) SMB response\n");
-			return -1;
-		}
-		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
-	}
-
-	smb = smb2_find_mid(server, buf);
-	if (smb == NULL)
-		cifs_dbg(FYI, "mid not found\n");
-	else {
-		cifs_dbg(FYI, "mid found\n");
-		smb->decrypted = true;
-		smb->resp_buf_size = server->pdu_size;
-	}
-
-	if (*num_mids >= MAX_COMPOUND) {
-		cifs_server_dbg(VFS, "too many PDUs in compound\n");
-		return -1;
-	}
-	bufs[*num_mids] = buf;
-	mids[(*num_mids)++] = smb;
-
-	if (smb && smb->handle)
-		ret = smb->handle(server, smb);
-	else
-		ret = cifs_handle_standard(server, smb);
-
-	if (ret == 0 && next_cmd) {
-		pdu_length -= next_cmd;
-		server->large_buf = next_is_large;
-		if (next_is_large)
-			server->bigbuf = buf = next_buffer;
-		else
-			server->smallbuf = buf = next_buffer;
-		goto one_more;
-	} else if (ret != 0) {
-		/*
-		 * ret != 0 here means that we didn't get to handle_mid() thus
-		 * server->smallbuf and server->bigbuf are still valid. We need
-		 * to free next_buffer because it is not going to be used
-		 * anywhere.
-		 */
-		if (next_is_large)
-			free_rsp_buf(CIFS_LARGE_BUFFER, next_buffer);
-		else
-			free_rsp_buf(CIFS_SMALL_BUFFER, next_buffer);
-	}
-
-	return ret;
-}
-
-static int
-smb3_receive_transform(struct TCP_Server_Info *server,
-		       struct smb_message **mids, char **bufs, int *num_mids)
-{
-	char *buf = server->smallbuf;
-	unsigned int pdu_length = server->pdu_size;
-	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
-	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
-
-	if (pdu_length < sizeof(struct smb2_transform_hdr) +
-						sizeof(struct smb2_hdr)) {
-		cifs_server_dbg(VFS, "Transform message is too small (%u)\n",
-			 pdu_length);
-		cifs_reconnect(server, true);
-		return -ECONNABORTED;
-	}
-
-	if (pdu_length < orig_len + sizeof(struct smb2_transform_hdr)) {
-		cifs_server_dbg(VFS, "Transform message is broken\n");
-		cifs_reconnect(server, true);
-		return -ECONNABORTED;
-	}
-
-	/* TODO: add support for compounds containing READ. */
-	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
-		return receive_encrypted_read(server, &mids[0], num_mids);
-	}
-
-	return receive_encrypted_standard(server, mids, bufs, num_mids);
-}
-
-int
-smb3_handle_read_data(struct TCP_Server_Info *server, struct smb_message *smb)
-{
-	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
-
-	return handle_read_data(server, smb, buf, server->pdu_size,
-				NULL, 0, false);
-}
-
-static int smb2_next_header(struct TCP_Server_Info *server, char *buf,
-			    unsigned int *noff)
-{
-	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
-	struct smb2_transform_hdr *t_hdr = (struct smb2_transform_hdr *)buf;
-
-	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
-		*noff = le32_to_cpu(t_hdr->OriginalMessageSize);
-		if (unlikely(check_add_overflow(*noff, sizeof(*t_hdr), noff)))
-			return -EINVAL;
-	} else {
-		*noff = le32_to_cpu(hdr->NextCommand);
-	}
-	if (unlikely(*noff && *noff < MID_HEADER_SIZE(server)))
-		return -EINVAL;
-	return 0;
-}
-
 int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 				struct dentry *dentry, struct cifs_tcon *tcon,
 				const char *full_path, umode_t mode, dev_t dev,
@@ -5458,6 +4792,25 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static unsigned int smb2_calc_smb_size(void *buf)
+{
+	const union smb2_response_hdr *h = buf;
+	const struct smb2_hdr *shdr = &h->hdr;
+	struct cifs_receive recv = {
+		.response = buf,
+	};
+
+	/*
+	 * StructureSize2, ie length of fixed parameter area has already
+	 * been checked to make sure it is the correct length.
+	 */
+	recv.hdr_len  = le16_to_cpu(shdr->StructureSize);
+	recv.hdr_len += le16_to_cpu(h->StructureSize2) & ~SMB2_STRUCT_HAS_DYNAMIC_PART;
+
+	smb2_calc_size(&recv);
+	return recv.calc_len;
+}
+
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
@@ -5471,15 +4824,8 @@ struct smb_version_operations smb20_operations = {
 	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
-	.read_data_offset = smb2_read_data_offset,
-	.read_data_length = smb2_read_data_length,
-	.map_error = map_smb2_to_linux_error,
-	.find_mid = smb2_find_mid,
-	.check_message = smb2_check_message,
-	.dump_detail = smb2_dump_detail,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
-	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
@@ -5523,9 +4869,7 @@ struct smb_version_operations smb20_operations = {
 	.query_dir_first = smb2_query_dir_first,
 	.query_dir_next = smb2_query_dir_next,
 	.close_dir = smb2_close_dir,
-	.calc_smb_size = smb2_calc_size,
-	.is_status_pending = smb2_is_status_pending,
-	.is_session_expired = smb2_is_session_expired,
+	.calc_smb_size = smb2_calc_smb_size,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -5550,13 +4894,10 @@ struct smb_version_operations smb20_operations = {
 	.get_acl = get_smb2_acl,
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
-	.next_header = smb2_next_header,
 	.ioctl_query_info = smb2_ioctl_query_info,
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
-	.is_status_io_timeout = smb2_is_status_io_timeout,
-	.is_network_name_deleted = smb2_is_network_name_deleted,
 	.rename_pending_delete = smb2_rename_pending_delete,
 };
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
@@ -5574,15 +4915,9 @@ struct smb_version_operations smb21_operations = {
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
-	.read_data_offset = smb2_read_data_offset,
-	.read_data_length = smb2_read_data_length,
-	.map_error = map_smb2_to_linux_error,
-	.find_mid = smb2_find_mid,
-	.check_message = smb2_check_message,
-	.dump_detail = smb2_dump_detail,
+	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
-	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb2_downgrade_oplock,
 	.need_neg = smb2_need_neg,
@@ -5626,9 +4961,7 @@ struct smb_version_operations smb21_operations = {
 	.query_dir_first = smb2_query_dir_first,
 	.query_dir_next = smb2_query_dir_next,
 	.close_dir = smb2_close_dir,
-	.calc_smb_size = smb2_calc_size,
-	.is_status_pending = smb2_is_status_pending,
-	.is_session_expired = smb2_is_session_expired,
+	.calc_smb_size = smb2_calc_smb_size,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -5655,13 +4988,10 @@ struct smb_version_operations smb21_operations = {
 	.get_acl = get_smb2_acl,
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
-	.next_header = smb2_next_header,
 	.ioctl_query_info = smb2_ioctl_query_info,
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
-	.is_status_io_timeout = smb2_is_status_io_timeout,
-	.is_network_name_deleted = smb2_is_network_name_deleted,
 	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
@@ -5678,16 +5008,10 @@ struct smb_version_operations smb30_operations = {
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
-	.read_data_offset = smb2_read_data_offset,
-	.read_data_length = smb2_read_data_length,
-	.map_error = map_smb2_to_linux_error,
-	.find_mid = smb2_find_mid,
-	.check_message = smb2_check_message,
-	.dump_detail = smb2_dump_detail,
+	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
-	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
@@ -5734,9 +5058,7 @@ struct smb_version_operations smb30_operations = {
 	.query_dir_first = smb2_query_dir_first,
 	.query_dir_next = smb2_query_dir_next,
 	.close_dir = smb2_close_dir,
-	.calc_smb_size = smb2_calc_size,
-	.is_status_pending = smb2_is_status_pending,
-	.is_session_expired = smb2_is_session_expired,
+	.calc_smb_size = smb2_calc_smb_size,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb2_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -5760,8 +5082,6 @@ struct smb_version_operations smb30_operations = {
 	.enum_snapshots = smb3_enum_snapshots,
 	.notify = smb3_notify,
 	.init_transform_rq = smb3_init_transform_rq,
-	.is_transform_hdr = smb3_is_transform_hdr,
-	.receive_transform = smb3_receive_transform,
 	.get_dfs_refer = smb2_get_dfs_refer,
 	.select_sectype = smb2_select_sectype,
 #ifdef CONFIG_CIFS_XATTR
@@ -5771,13 +5091,10 @@ struct smb_version_operations smb30_operations = {
 	.get_acl = get_smb2_acl,
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
-	.next_header = smb2_next_header,
 	.ioctl_query_info = smb2_ioctl_query_info,
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
-	.is_status_io_timeout = smb2_is_status_io_timeout,
-	.is_network_name_deleted = smb2_is_network_name_deleted,
 	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
@@ -5794,16 +5111,10 @@ struct smb_version_operations smb311_operations = {
 	.adjust_credits = smb2_adjust_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.revert_current_mid = smb2_revert_current_mid,
-	.read_data_offset = smb2_read_data_offset,
-	.read_data_length = smb2_read_data_length,
-	.map_error = map_smb2_to_linux_error,
-	.find_mid = smb2_find_mid,
-	.check_message = smb2_check_message,
-	.dump_detail = smb2_dump_detail,
+	.receive_pdu = smb2_receive_pdu,
 	.clear_stats = smb2_clear_stats,
 	.print_stats = smb2_print_stats,
 	.dump_share_caps = smb2_dump_share_caps,
-	.is_oplock_break = smb2_is_valid_oplock_break,
 	.handle_cancelled_mid = smb2_handle_cancelled_mid,
 	.downgrade_oplock = smb3_downgrade_oplock,
 	.need_neg = smb2_need_neg,
@@ -5850,9 +5161,7 @@ struct smb_version_operations smb311_operations = {
 	.query_dir_first = smb2_query_dir_first,
 	.query_dir_next = smb2_query_dir_next,
 	.close_dir = smb2_close_dir,
-	.calc_smb_size = smb2_calc_size,
-	.is_status_pending = smb2_is_status_pending,
-	.is_session_expired = smb2_is_session_expired,
+	.calc_smb_size = smb2_calc_smb_size,
 	.oplock_response = smb2_oplock_response,
 	.queryfs = smb311_queryfs,
 	.mand_lock = smb2_mand_lock,
@@ -5876,8 +5185,6 @@ struct smb_version_operations smb311_operations = {
 	.enum_snapshots = smb3_enum_snapshots,
 	.notify = smb3_notify,
 	.init_transform_rq = smb3_init_transform_rq,
-	.is_transform_hdr = smb3_is_transform_hdr,
-	.receive_transform = smb3_receive_transform,
 	.get_dfs_refer = smb2_get_dfs_refer,
 	.select_sectype = smb2_select_sectype,
 #ifdef CONFIG_CIFS_XATTR
@@ -5887,13 +5194,10 @@ struct smb_version_operations smb311_operations = {
 	.get_acl = get_smb2_acl,
 	.get_acl_by_fid = get_smb2_acl_by_fid,
 	.set_acl = set_smb2_acl,
-	.next_header = smb2_next_header,
 	.ioctl_query_info = smb2_ioctl_query_info,
 	.make_node = smb2_make_node,
 	.fiemap = smb3_fiemap,
 	.llseek = smb3_llseek,
-	.is_status_io_timeout = smb2_is_status_io_timeout,
-	.is_network_name_deleted = smb2_is_network_name_deleted,
 	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d4d2da2846e9..ab193f84c1ab 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -24,6 +24,7 @@
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include <linux/netfs.h>
+#include <linux/iov_iter.h>
 #include <trace/events/netfs.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -1084,7 +1085,6 @@ SMB2_negotiate(const unsigned int xid,
 	struct kvec rsp_iov;
 	int rc;
 	int resp_buftype;
-	int blob_offset, blob_length;
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
 	unsigned int total_len;
@@ -1284,8 +1284,13 @@ SMB2_negotiate(const unsigned int xid,
 	    (server->capabilities & SMB2_GLOBAL_CAP_ENCRYPTION))
 		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
 
-	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
-					       (struct smb2_hdr *)rsp);
+	struct cifs_receive recv = {
+		/* TODO: This should be returned into smb_message */
+		.response = rsp_iov.iov_base,
+		.msg_len = rsp_iov.iov_len,
+	};
+
+	security_blob = smb2_get_data_area_len(&recv);
 	/*
 	 * See MS-SMB2 section 2.2.4: if no blob, client picks default which
 	 * for us will be
@@ -1293,7 +1298,7 @@ SMB2_negotiate(const unsigned int xid,
 	 * but for time being this is our only auth choice so doesn't matter.
 	 * We just found a server which sets blob length to zero expecting raw.
 	 */
-	if (blob_length == 0) {
+	if (recv.data_len == 0) {
 		cifs_dbg(FYI, "missing security blob on negprot\n");
 		server->sec_ntlmssp = true;
 	}
@@ -1301,8 +1306,8 @@ SMB2_negotiate(const unsigned int xid,
 	rc = cifs_enable_signing(server, ses->sign);
 	if (rc)
 		goto neg_exit;
-	if (blob_length) {
-		rc = decode_negTokenInit(security_blob, blob_length, server);
+	if (recv.data_len) {
+		rc = decode_negTokenInit(security_blob, recv.data_len, server);
 		if (rc == 1)
 			rc = 0;
 		else if (rc == 0)
@@ -4174,7 +4179,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 static void
 smb2_echo_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)smb->resp_buf;
+	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)smb->response;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 
 	if (smb->mid_state == MID_RESPONSE_RECEIVED
@@ -4369,8 +4374,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	iov[0].iov_len = total_len;
 	iov[0].iov_base = (char *)req;
 
-	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, NULL,
-			     server, CIFS_ECHO_OP, NULL);
+	rc = cifs_call_async(server, &rqst, smb2_echo_callback, server,
+			     CIFS_ECHO_OP, NULL, NULL);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
@@ -4611,7 +4616,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 	struct cifs_io_subrequest *rdata = smb->callback_data;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
-	struct smb2_hdr *shdr = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	struct smb2_hdr *shdr = smb->response;
 	struct inode *inode = &ictx->inode;
 	struct cifs_credits credits = {
 		.value = 0,
@@ -4619,22 +4624,28 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		.rreq_debug_id = rdata->rreq->debug_id,
 		.rreq_debug_index = rdata->subreq.debug_index,
 	};
-	struct smb_rqst rqst = { .rq_iov = &rdata->iov[0], .rq_nvec = 1 };
+	struct kvec kv = {
+		.iov_base = smb->response,
+		.iov_len  = smb->resp_len,
+	};
+	struct smb_rqst rqst = {
+		.rq_iov  = &kv,
+		.rq_nvec = 1
+	};
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
 
-	if (rdata->got_bytes)
-		iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
-				    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
-				    rdata->subreq.content.offset, rdata->subreq.len);
+	iov_iter_bvec_queue(&rqst.rq_iter, ITER_DEST,
+			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
+			    rdata->subreq.content.offset, rdata->subreq.len);
 
 	WARN_ONCE(rdata->server != server,
 		  "rdata server %p != mid server %p",
 		  rdata->server, server);
 
-	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu/%zu\n",
-		 __func__, smb->mid, smb->mid_state, rdata->result,
-		 rdata->got_bytes, rdata->subreq.len - rdata->subreq.transferred);
+	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%u/%zu\n",
+		 __func__, smb->mid, smb->mid_state, smb->error,
+		 smb->resp_data_len, rdata->subreq.len - rdata->subreq.transferred);
 
 	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
@@ -4644,7 +4655,6 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 		if (server->sign && !smb->decrypted) {
 			int rc;
 
-			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
 			rc = smb2_verify_signature(&rqst, server);
 			if (rc) {
 				cifs_tcon_dbg(VFS, "SMB signature verification returned error = %d\n",
@@ -4660,6 +4670,8 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 			} else
 				trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 		}
+
+		rdata->got_bytes = smb->resp_data_len;
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->got_bytes);
 		cifs_stats_bytes_read(tcon, rdata->got_bytes);
@@ -4768,6 +4780,7 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 1 };
+	struct iov_iter iter;
 	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	unsigned int total_len;
@@ -4776,6 +4789,10 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 	cifs_dbg(FYI, "%s: offset=%llu bytes=%zu\n",
 		 __func__, subreq->start, subreq->len);
 
+	iov_iter_bvec_queue(&iter, ITER_DEST,
+			    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
+			    rdata->subreq.content.offset, rdata->subreq.len);
+
 	if (!rdata->server)
 		rdata->server = cifs_pick_channel(tcon->ses);
 
@@ -4827,10 +4844,8 @@ smb2_async_readv(struct cifs_io_subrequest *rdata)
 		flags |= CIFS_HAS_CREDITS;
 	}
 
-	rc = cifs_call_async(server, &rqst,
-			     cifs_readv_receive, smb2_readv_callback,
-			     smb3_handle_read_data, rdata, flags,
-			     &rdata->credits);
+	rc = cifs_call_async(server, &rqst, smb2_readv_callback, rdata, flags,
+			     &rdata->credits, &iter);
 	if (rc) {
 		cifs_stats_fail_inc(io_parms.tcon, SMB2_READ_HE);
 		trace_smb3_read_err(rdata->rreq->debug_id,
@@ -4950,7 +4965,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	struct cifs_io_subrequest *wdata = smb->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
-	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)smb->resp_buf;
+	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)smb->response;
 	struct cifs_credits credits = {
 		.value = 0,
 		.instance = 0,
@@ -5224,8 +5239,8 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 	if (((flags & CIFS_TRANSFORM_REQ) != CIFS_TRANSFORM_REQ) && should_compress(tcon, &rqst))
 		flags |= CIFS_COMPRESS_REQ;
 
-	rc = cifs_call_async(server, &rqst, NULL, smb2_writev_callback, NULL,
-			     wdata, flags, &wdata->credits);
+	rc = cifs_call_async(server, &rqst, smb2_writev_callback, wdata, flags,
+			     &wdata->credits, NULL);
 	/* Can't touch wdata if rc == 0 */
 	if (rc) {
 		trace_smb3_write_err(wdata->rreq->debug_id,
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 5727e47733c8..0b3df644222b 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -21,7 +21,7 @@ struct smb_rqst;
  * All Prototypes
  *****************************************************************
  */
-int map_smb2_to_linux_error(char *buf, bool log_err);
+int map_smb2_to_linux_error(const struct smb2_hdr *shdr, bool log_err);
 int smb2_init_maperror(void);
 #if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
 const struct status_to_posix_error *smb2_get_err_map_test(__u32 smb2_status);
@@ -29,13 +29,13 @@ extern const struct status_to_posix_error *smb2_error_map_table_test;
 extern unsigned int smb2_error_map_num;
 #endif
 
-int smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
-		       struct TCP_Server_Info *server);
-unsigned int smb2_calc_size(void *buf);
-char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr);
+int smb2_check_message(struct TCP_Server_Info *server, struct cifs_receive *recv);
+void smb2_calc_size(struct cifs_receive *recv);
+char *smb2_get_data_area_len(struct cifs_receive *recv);
 __le16 *cifs_convert_path_to_utf16(const char *from,
 				   struct cifs_sb_info *cifs_sb);
 
+int smb2_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len);
 int smb2_verify_signature(struct smb_rqst *rqst,
 			  struct TCP_Server_Info *server);
 int smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
@@ -48,7 +48,8 @@ struct smb_message *smb2_setup_async_request(struct TCP_Server_Info *server,
 struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 				     __u64 ses_id, __u32  tid);
 __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock);
-bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server);
+void smb2_is_valid_oplock_break(struct TCP_Server_Info *server,
+				union smb2_response_hdr *h);
 int smb3_handle_read_data(struct TCP_Server_Info *server,
 			  struct smb_message *smb);
 struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
@@ -121,6 +122,16 @@ void smb2_set_related(struct smb_rqst *rqst);
 void smb2_set_replay(struct TCP_Server_Info *server, struct smb_rqst *rqst);
 bool smb2_should_replay(struct cifs_tcon *tcon, int *pretries,
 			int *pcur_sleep);
+void smb2_add_credits_from_hdr(struct smb2_hdr *shdr,
+			       struct TCP_Server_Info *server);
+struct smb_message *smb2_find_mid(struct TCP_Server_Info *server,
+				  struct smb2_hdr *shdr, bool dequeue);
+#ifdef CONFIG_CIFS_DEBUG2
+void smb2_dump_detail(struct TCP_Server_Info *server, const struct cifs_receive *recv);
+void smb2_dump_mids(struct TCP_Server_Info *server);
+#endif /* CONFIG_CIFS_DEBUG2 */
+bool smb2_status_pending(struct smb2_hdr *shdr, struct TCP_Server_Info *server);
+bool smb2_network_name_is_deleted(struct smb2_hdr *shdr, struct TCP_Server_Info *server);
 
 /*
  * SMB2 Worker functions - most of protocol specific implementation details
@@ -264,6 +275,8 @@ int smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 			     const char *path, u32 desired_access, u32 class,
 			     u32 type, u32 output_len, struct kvec *rsp,
 			     int *buftype, struct cifs_sb_info *cifs_sb);
+int smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc,
+		     u8 *key);
 /* query path info from the server using SMB311 POSIX extensions*/
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 9df3a0b530e2..1086877e9d84 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -18,6 +18,7 @@
 #include <asm/processor.h>
 #include <linux/mempool.h>
 #include <linux/highmem.h>
+#include <linux/iov_iter.h>
 #include <crypto/aead.h>
 #include <crypto/aes-cbc-macs.h>
 #include <crypto/sha2.h>
@@ -29,6 +30,9 @@
 #include "../common/smb2status.h"
 #include "smb2glob.h"
 
+static void smb2_parse_pdu(struct TCP_Server_Info *server,
+			   struct netfs_rxqueue *rxq);
+
 static
 int smb3_get_sign_key(__u64 ses_id, struct TCP_Server_Info *server, u8 *key)
 {
@@ -545,7 +549,7 @@ smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 int
 smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
-	unsigned int rc;
+	int rc;
 	char server_response_sig[SMB2_SIGNATURE_SIZE];
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
@@ -692,15 +696,15 @@ int
 smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = smb->resp_buf_size;
+	unsigned int len = smb->resp_len;
 	struct kvec iov[1];
 	struct smb_rqst rqst = { .rq_iov = iov,
 				 .rq_nvec = 1 };
 
-	iov[0].iov_base = (char *)smb->resp_buf;
+	iov[0].iov_base = (char *)smb->response;
 	iov[0].iov_len = len;
 
-	dump_smb(smb->resp_buf, min_t(u32, 80, len));
+	dump_smb(smb->response, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
 	if (len > 24 && server->sign && !smb->decrypted) {
 		int rc;
@@ -708,10 +712,10 @@ smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		rc = smb2_verify_signature(&rqst, server);
 		if (rc)
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
-				 rc);
+					rc);
 	}
 
-	return map_smb2_to_linux_error(smb->resp_buf, log_error);
+	return map_smb2_to_linux_error(smb->response, log_error);
 }
 
 struct smb_message *
@@ -881,3 +885,620 @@ static void *smb2_get_aead_req_new(struct crypto_aead *tfm, const struct iov_ite
 	*sgl = sgtable.sgl;
 	return p;
 }
+
+/*
+ * Decrypt the PDU in the iterator.  The PDU begins with the transform header.
+ */
+static int decrypt_pdu(struct TCP_Server_Info *server,
+		       struct smb2_transform_hdr *tr_hdr,
+		       struct netfs_rxqueue *rxq)
+{
+	DECLARE_CRYPTO_WAIT(wait);
+	struct aead_request *req;
+	struct crypto_aead *tfm = server->secmech.dec;
+	struct scatterlist *sg;
+	struct iov_iter iter;
+	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
+	unsigned int crypt_len;
+	size_t sensitive_size;
+	void *creq;
+	int rc = 0;
+	u8 sign[SMB2_SIGNATURE_SIZE] = {};
+	u8 key[SMB3_ENC_DEC_KEY_SIZE];
+	u8 *iv;
+
+	crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+
+	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), 0, key);
+	if (rc) {
+		cifs_server_dbg(FYI, "%s: Could not get decryption key. sid: 0x%llx\n",
+				__func__, le64_to_cpu(tr_hdr->SessionId));
+		return rc;
+	}
+
+	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
+		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
+	else
+		rc = crypto_aead_setkey(tfm, key, SMB3_GCM128_CRYPTKEY_SIZE);
+
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
+		return rc;
+	}
+
+	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
+	if (rc) {
+		cifs_server_dbg(VFS, "%s: Failed to set authsize %d\n", __func__, rc);
+		return rc;
+	}
+
+	netfs_rxqueue_discard(rxq, offsetof(struct smb2_transform_hdr, Nonce));
+
+	iov_iter_bvec_queue(&iter, ITER_DEST, rxq->take_from, rxq->take_slot,
+			    rxq->take_offset, rxq->pdu_remain);
+
+	creq = smb2_get_aead_req_new(tfm, &iter, sign, &iv, &req, &sg,
+				     &sensitive_size);
+	if (IS_ERR(creq))
+		return PTR_ERR(creq);
+
+	memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
+	crypt_len += SMB2_SIGNATURE_SIZE;
+
+	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
+	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
+		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
+	else {
+		iv[0] = 3;
+		memcpy(iv + 1, (char *)tr_hdr->Nonce, SMB3_AES_CCM_NONCE);
+	}
+
+	aead_request_set_tfm(req, tfm);
+	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
+	aead_request_set_ad(req, assoc_data_len);
+
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
+
+	rc = crypto_wait_req(crypto_aead_decrypt(req), &wait);
+
+	netfs_rxqueue_discard(rxq, sizeof(*tr_hdr) - offsetof(struct smb2_transform_hdr, Nonce));
+
+	kvfree_sensitive(creq, sensitive_size);
+	return rc;
+}
+
+struct smb2_decrypt_work {
+	struct work_struct	decrypt;
+	struct TCP_Server_Info	*server;
+	struct netfs_rxqueue	rx_subset;
+};
+
+static void smb2_decrypt_offload(struct work_struct *work)
+{
+	struct smb2_transform_hdr tr_hdr;
+	struct smb2_decrypt_work *dw =
+		container_of(work, struct smb2_decrypt_work, decrypt);
+	struct netfs_rxqueue *rxq = &dw->rx_subset;
+	int rc;
+
+	if (netfs_rxqueue_read(rxq, &tr_hdr, 0, sizeof(tr_hdr)) != sizeof(tr_hdr))
+		goto out;
+
+	rc = decrypt_pdu(dw->server, &tr_hdr, rxq);
+	if (rc < 0) {
+		cifs_dbg(VFS, "error decrypting rc=%d\n", rc);
+		goto out;
+	}
+
+	smb2_parse_pdu(dw->server, rxq);
+out:
+	netfs_put_rx_bvecq(rxq->take_from);
+	kfree(dw);
+}
+
+static bool smb3_offload_decrypt(struct TCP_Server_Info *server,
+				 struct smb2_transform_hdr *tr_hdr,
+				 struct netfs_rxqueue *rxq)
+{
+	struct smb2_decrypt_work *dw;
+	struct bvecq *head_bq;
+	size_t remain = rxq->pdu_remain;
+
+	dw = kzalloc(sizeof(struct smb2_decrypt_work), GFP_KERNEL);
+	if (!dw)
+		return false;
+	INIT_WORK(&dw->decrypt, smb2_decrypt_offload);
+	dw->server = server;
+
+	head_bq = netfs_rxqueue_decant(rxq, remain);
+	if (!head_bq) {
+		kfree(dw);
+		return -ENOMEM;
+	}
+
+	dw->rx_subset.take_from		= head_bq;
+	dw->rx_subset.add_to		= NULL;
+	dw->rx_subset.take_slot		= 0;
+	dw->rx_subset.take_offset	= 0;
+	dw->rx_subset.refillable	= false;
+	dw->rx_subset.qsize		= remain;
+	dw->rx_subset.pdu_remain	= remain;
+
+	queue_work(decrypt_wq, &dw->decrypt);
+	return true;
+}
+
+/*
+ * Reverse the transformation the sender made to a PDU we just received, such
+ * as decrypting it.  The PDU body is currently in residence upon the server
+ * receive queue.
+ */
+static int smb3_reverse_transform(struct TCP_Server_Info *server,
+				  struct netfs_rxqueue *rxq)
+{
+	struct smb2_transform_hdr tr_hdr;
+	unsigned int orig_len;
+	size_t got;
+	int rc;
+
+	if (!server->secmech.dec) {
+		cifs_server_dbg(VFS, "%s: Decryption TFM not allocated\n", __func__);
+		return -EIO;
+	}
+
+	rc = smb_rxqueue_refill(server, rxq, rxq->pdu_remain);
+	if (rc < 0)
+		return rc;
+
+	got = netfs_rxqueue_read(rxq, &tr_hdr, 0, sizeof(tr_hdr));
+	if (got != sizeof(tr_hdr)) {
+		cifs_server_dbg(VFS, "Too short for transform header (%u)\n",
+				rxq->pdu_remain);
+		return -EIO;
+	}
+
+	orig_len = le32_to_cpu(tr_hdr.OriginalMessageSize);
+	if (orig_len > rxq->pdu_remain - sizeof(tr_hdr)) {
+		cifs_server_dbg(VFS, "Transform message is broken\n");
+		return -EIO;
+	}
+
+	/*
+	 * For large reads, offload to different thread for better performance,
+	 * use more cores decrypting which can be expensive
+	 */
+	if (server->min_offload && server->in_flight > 1 &&
+	    rxq->pdu_remain >= server->min_offload &&
+	    smb3_offload_decrypt(server, &tr_hdr, rxq))
+		return 0;
+
+	rxq->refillable = false;
+	decrypt_pdu(server, &tr_hdr, rxq);
+	smb2_parse_pdu(server, rxq);
+	return 0;
+}
+
+/*
+ * Copy data directly into prepared buffers.
+ *
+ * Ideally, we'd wait for sufficient data to be present in the queue before
+ * doing this, but that causes a performance loss as we don't receive data and
+ * copy in parallel.
+ */
+static void smb2_copy_to_prepped_buffers(struct TCP_Server_Info *server,
+					 struct smb_message *smb,
+					 struct netfs_rxqueue *rxq,
+					 struct cifs_receive *recv)
+{
+	const union smb2_response_hdr *h = recv->response;
+	struct iov_iter dest = smb->response_iter;
+	unsigned int to_copy, skip;
+	int rc;
+
+	switch (smb->command) {
+	case SMB2_READ:
+		to_copy = recv->data_len;
+		skip = recv->data_offset;
+
+		switch (h->read.Flags) {
+		case SMB2_READFLAG_RESPONSE_NONE:
+			break;
+		case SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM:
+			if (to_copy)
+				cifs_dbg(FYI, "%s: Read.DataLength != 0 for RDMA\n", __func__);
+			return;
+		default:
+			cifs_dbg(FYI, "%s: Unknown Read.Flags value (%x)\n",
+				 __func__, le32_to_cpu(h->read.Flags));
+			recv->malformed = true;
+			return;
+		}
+		skip -= recv->extracted;
+		break;
+	default:
+		cifs_dbg(FYI, "%s: Non-Read copy\n", __func__);
+		return;
+	}
+
+	if (skip < recv->hdr_len) {
+		if (skip != 0) {
+			cifs_dbg(FYI, "%s: Read.DataOffset too small\n", __func__);
+			return;
+		}
+		skip = recv->hdr_len;
+	}
+	if (skip > recv->msg_len) {
+		cifs_dbg(FYI, "%s: Read.DataOffset beyond end\n", __func__);
+		return;
+	}
+	if (to_copy > recv->msg_len - skip) {
+		cifs_dbg(FYI, "%s: Read.DataLength beyond end\n", __func__);
+		return;
+	}
+
+	if (!rxq->refillable) {
+		size_t got;
+
+		got = netfs_rxqueue_read_iter(rxq, &smb->response_iter, 0, to_copy);
+		if (got > 0)
+			netfs_rxqueue_discard(rxq, got);
+		recv->extracted += got;
+		if (got < to_copy) {
+			cifs_dbg(VFS, "Copy to buffer was short %zu/%u\n",
+				 got, to_copy);
+			recv->malformed = true;
+		}
+		return;
+	}
+
+	while (to_copy) {
+		size_t got, part = umin(to_copy, rxq->qsize);
+
+		got = netfs_rxqueue_read_iter(rxq, &dest, 0, part);
+		if (got > 0) {
+			recv->extracted += got;
+			to_copy -= got;
+			netfs_rxqueue_discard(rxq, got);
+		}
+		if (!to_copy)
+			break;
+		if (got < part) {
+			cifs_dbg(VFS, "Copy to buffer was short %zu/%zu\n",
+				 part, to_copy + part);
+			recv->malformed = true;
+			return;
+		}
+
+		rc = smb_rxqueue_refill(server, rxq, 1);
+		if (rc < 0) {
+			recv->malformed = true;
+			return;
+		}
+		if (!rxq->qsize || !rxq->pdu_remain)
+			break;
+	}
+}
+
+/*
+ * Parse an SMB2/3 message that's at least partially extracted.  For successful
+ * reads, the data part is still in the receive queue or even not yet received.
+ */
+static void smb2_parse_one_message(struct TCP_Server_Info *server,
+				   struct cifs_receive *recv,
+				   struct netfs_rxqueue *rxq)
+{
+	union smb2_response_hdr *h = recv->response;
+	struct smb_message *smb;
+	struct smb2_hdr *shdr = &h->hdr;
+	int rc;
+
+	smb = smb2_find_mid(server, shdr, false);
+	if (!smb) {
+		cifs_dbg(VFS, "%s: Unqueued mid (%llx)\n",
+			 __func__, le64_to_cpu(shdr->MessageId));
+		rxq->msg_id = 0;
+	} else {
+		rxq->msg_id = 0; /* TODO: smb->debug_id */
+	}
+
+	/*
+	 * We know that we received enough to get to the MID as we checked the
+	 * pdu_length earlier. Now check to see if the rest of the header is OK
+	 * and determine the general layout of the message.
+	 *
+	 * 48 bytes is enough to display the header and a little bit into the
+	 * payload for debugging purposes.
+	 */
+	rc = smb2_check_message(server, recv);
+	if (rc) {
+		cifs_dump_mem("Bad SMB: ", h, umin(recv->extracted, 48));
+		recv->malformed = true;
+		recv->error = -EPROTO;
+	}
+
+	/* Check the status codes for server/connection-level information. */
+	switch (shdr->Status) {
+	case 0:
+		trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			      le64_to_cpu(shdr->SessionId),
+			      le16_to_cpu(shdr->Command),
+			      le64_to_cpu(shdr->MessageId));
+		break;
+	case STATUS_NETWORK_SESSION_EXPIRED:
+	case STATUS_USER_SESSION_DELETED:
+		trace_smb3_ses_expired(le32_to_cpu(shdr->Id.SyncId.TreeId),
+				       le64_to_cpu(shdr->SessionId),
+				       le16_to_cpu(shdr->Command),
+				       le64_to_cpu(shdr->MessageId));
+		cifs_dbg(FYI, "Session expired or deleted\n");
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		release_mid(server, smb);
+		return;
+	case STATUS_PENDING:
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+		smb2_status_pending(shdr, server);
+		release_mid(server, smb);
+		return;
+	case STATUS_IO_TIMEOUT:
+		int iotimo = atomic_inc_return(&server->num_io_timeout);
+		if (iotimo > MAX_STATUS_IO_TIMEOUT) {
+			cifs_server_dbg(VFS,
+					"Number of request timeouts exceeded %d. Reconnecting",
+					MAX_STATUS_IO_TIMEOUT);
+
+			set_bit(SMB_SERVER_SESSION_RECONNECT, &server->flags);
+			set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+			atomic_set(&server->num_io_timeout, 0);
+		}
+		break;
+	case STATUS_NETWORK_NAME_DELETED:
+		cifs_server_dbg(FYI, "Share deleted. Reconnect needed");
+		smb2_network_name_is_deleted(shdr, server);
+		break;
+	default:
+		recv->error = map_smb2_to_linux_error(shdr, false);
+		if (recv->error) {
+			cifs_dbg(FYI, "%s: server returned error %d\n",
+				 __func__, recv->error);
+			/* normal error on read response */
+		}
+		break;
+	}
+
+	if (smb) {
+		size_t resp_len;
+
+		/* handle_mid */
+		smb->status		= shdr->Status;
+		smb->error		= recv->error;
+		smb->credits_received	= le16_to_cpu(shdr->CreditRequest);
+		smb->resp_data_len	= recv->data_len;
+		smb->resp_data_offset	= recv->data_offset;
+
+		trace_smb3_reply(smb, recv);
+
+		/* For a successful Read, we only grab the header. */
+		resp_len = recv->msg_len;
+		if (smb->status != 0)
+			smb->copy_to_bufs = false;
+		if (smb->copy_to_bufs)
+			resp_len = recv->hdr_len;
+
+		if (resp_len <= MAX_CIFS_SMALL_BUFFER_SIZE) {
+			server->smallbuf = NULL;
+		} else if (resp_len <= CIFSMaxBufSize + MAX_SMB2_HDR_SIZE) {
+			memcpy(server->bigbuf, server->smallbuf, recv->extracted);
+			recv->response = server->bigbuf;
+			server->bigbuf = NULL;
+			recv->resp_buf_type = CIFS_LARGE_BUFFER;
+			h = recv->response;
+			shdr = &h->hdr;
+		} else {
+			/* Too big - should parse directly from iterator. */
+			smb->error = -EMSGSIZE;
+			cifs_dbg(FYI, "%s: Message too big\n", __func__);
+		}
+
+		smb->response = recv->response;
+		smb->resp_len = resp_len;
+
+		if (recv->extracted < recv->msg_len) {
+			size_t part = resp_len - recv->extracted, got;
+
+			got = netfs_rxqueue_read(rxq, recv->response + recv->extracted,
+						 recv->extracted, part);
+			recv->extracted += got;
+			netfs_rxqueue_discard(rxq, recv->extracted);
+
+			if (WARN_ON(got != part)) {
+				smb->error = -EIO;
+				smb->resp_len = recv->extracted;
+				recv->malformed = true;
+			} else if (smb->copy_to_bufs) {
+				smb2_copy_to_prepped_buffers(server, smb, rxq,
+							     recv);
+			} else if (rxq->pdu_remain) {
+				iov_iter_bvec_queue(&smb->response_iter, ITER_SOURCE,
+						    rxq->take_from, rxq->take_slot,
+						    rxq->take_offset, rxq->pdu_remain);
+				smb->response_data = rxq->take_from;
+				refcount_inc(&smb->response_data->ref);
+			}
+		} else {
+			netfs_rxqueue_discard(rxq, recv->extracted);
+		}
+
+		dequeue_mid(server, smb, recv->malformed);
+		mid_execute_callback(server, smb);
+
+		release_mid(server, smb);
+	} else if (shdr->Command == cpu_to_le32(SMB2_OPLOCK_BREAK)) {
+		smb2_is_valid_oplock_break(server, h);
+		smb2_add_credits_from_hdr(shdr, server);
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+		cifs_dbg(FYI, "Received oplock break\n");
+	} else {
+		cifs_server_dbg(VFS, "No task to wake, unknown frame received! NumMids %d\n",
+				atomic_read(&mid_count));
+		cifs_dump_mem("Received Data is: ", h, HEADER_SIZE(server));
+		smb2_add_credits_from_hdr(shdr, server);
+#ifdef CONFIG_CIFS_DEBUG2
+		smb2_dump_detail(server, recv);
+		smb2_dump_mids(server);
+#endif /* CIFS_DEBUG2 */
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+	}
+}
+
+/*
+ * Receive and parse a received SMB2/3 PDU.
+ *
+ * At this point all the data has been read, any transformation unapplied,
+ * decompression performed and some of it is stored in the receive queue
+ * (excerpt) without either the rfc1002, transform or compression headers,
+ * though some may yet to be received.
+ */
+static void smb2_parse_pdu(struct TCP_Server_Info *server,
+			   struct netfs_rxqueue *rxq)
+{
+	u32 next_command, ssize2, next_len;
+	int rc;
+
+	server->lstrp = jiffies;
+
+	do {
+		union smb2_response_hdr *h;
+		struct smb2_hdr *shdr;
+		size_t want, got;
+
+		while (!allocate_buffers(server))
+			if (server->tcpStatus == CifsExiting)
+				return;
+
+		struct cifs_receive recv = {
+			.resp_buf_type	= CIFS_SMALL_BUFFER,
+			.response	= server->smallbuf,
+			.msg_len	= rxq->pdu_remain,
+			.hdr_len	= sizeof(*shdr) + sizeof(h->StructureSize2),
+		};
+		h = recv.response;
+		shdr = &h->hdr;
+
+		rc = smb_rxqueue_refill(server, rxq, recv.hdr_len);
+		if (rc < 0)
+			goto failed;
+
+		got = netfs_rxqueue_read(rxq, recv.response, 0, recv.hdr_len);
+		if (got != recv.hdr_len) {
+			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
+					rxq->qsize);
+			goto failed;
+		}
+		recv.extracted = recv.hdr_len;
+
+		switch (shdr->ProtocolId) {
+		case SMB2_PROTO_NUMBER:
+			break;
+		case SMB2_TRANSFORM_PROTO_NUM:
+		case SMB2_COMPRESSION_TRANSFORM_ID:
+		default:
+			cifs_server_dbg(VFS, "SMB unsupported ProtocolId (%x)\n",
+					le32_to_cpu(shdr->ProtocolId));
+			goto failed;
+		}
+
+		/* Extract message from a compound. */
+		next_command = le32_to_cpu(shdr->NextCommand);
+		next_len = 0;
+		if (next_command) {
+			if (next_command < sizeof(*shdr) + 4 ||
+			    next_command + sizeof(*shdr) >= rxq->pdu_remain ||
+			    (next_command & 0x7)) {
+				cifs_dbg(VFS, "%s: malformed response (next_command=%u)\n",
+					 __func__, next_command);
+				goto failed;
+			}
+			next_len = rxq->pdu_remain - next_command;
+			rxq->pdu_remain = next_command;
+			recv.msg_len = next_command;
+		}
+
+		/* Get the rest of the command-specific response header. */
+		ssize2 = le16_to_cpu(h->StructureSize2);
+		ssize2 &= ~SMB2_STRUCT_HAS_DYNAMIC_PART;
+		if (ssize2 < 4 ||
+		    ssize2 > sizeof(*h) - sizeof(h->hdr)) {
+			cifs_dbg(VFS, "%s: malformed response (structsize2=%u)\n",
+				 __func__, ssize2);
+			goto failed;
+		}
+		ssize2 -= sizeof(h->StructureSize2);
+
+		/* If it's not a successful read, then wait for the entire message. */
+		if (le16_to_cpu(shdr->Command) != SMB2_READ ||
+		    shdr->Status != 0)
+			want = recv.msg_len;
+		else
+			want = recv.hdr_len + ssize2;
+
+		rc = smb_rxqueue_refill(server, rxq, want);
+		if (rc < 0)
+			goto failed;
+
+		got = netfs_rxqueue_read(rxq, &h->pdu + 1, recv.hdr_len, ssize2);
+		if (got != ssize2) {
+			cifs_server_dbg(VFS, "SMB response too short (%u bytes)\n",
+					rxq->qsize);
+			goto failed;
+		}
+		recv.hdr_len += ssize2;
+		recv.extracted += ssize2;
+
+		smb2_parse_one_message(server, &recv, rxq);
+
+		WARN(rxq->pdu_remain > 0, "MSG=%08x pdu_remain=%x",
+		     rxq->msg_id, rxq->pdu_remain);
+		smb_rxqueue_consume(server, rxq, rxq->pdu_remain);
+		rxq->pdu_remain = next_len;
+	} while (next_command);
+	return;
+
+failed:
+	set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+}
+
+/*
+ * Receive and parse an SMB2/3 PDU.  We need to wait for data to come in until
+ * we have enough and then we have to reverse transformations and perform
+ * decompression before we can fully parse the message contents.
+ */
+int smb2_receive_pdu(struct TCP_Server_Info *server, unsigned int pdu_len)
+{
+	struct netfs_rxqueue *rxq = &server->rx_queue;
+	__le32 protocol_id;
+	size_t got;
+	int rc;
+
+	rc = smb_rxqueue_refill(server, rxq, sizeof(struct smb2_pdu));
+	if (rc < 0)
+		return rc;
+
+	got = netfs_rxqueue_read(rxq, &protocol_id, 0, sizeof(protocol_id));
+	if (got != sizeof(protocol_id)) {
+		cifs_dbg(VFS, "%s: Couldn't extract ProtocolId\n", __func__);
+		set_bit(SMB_SERVER_NEED_RECONNECT, &server->flags);
+		return -EIO;
+	}
+
+	/* Reverse any transformation made to the content.  We set up an
+	 * iterator to define the buffer, but anyone looking at the buffer
+	 * *should not* assume that they can simply poke around in it as it may
+	 * be assembled from raw network packet Rx buffers.
+	 */
+	if (protocol_id == SMB2_TRANSFORM_PROTO_NUM)
+		return smb3_reverse_transform(server, rxq);
+	smb2_parse_pdu(server, rxq);
+	return 0;
+}
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index ede61d8a192c..7bd04ebbce5d 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -47,6 +47,7 @@
 	EM(smb_eio_trace_lock_data_too_small,		"lock_data_too_small") \
 	EM(smb_eio_trace_malformed_ksid_key,		"malformed_ksid_key") \
 	EM(smb_eio_trace_malformed_sid_key,		"malformed_sid_key") \
+	EM(smb_eio_trace_md5_iter,			"md5_iter") \
 	EM(smb_eio_trace_mkdir_no_rsp,			"mkdir_no_rsp") \
 	EM(smb_eio_trace_neg_bad_rsplen,		"neg_bad_rsplen") \
 	EM(smb_eio_trace_neg_decode_token,		"neg_decode_token") \
@@ -1963,6 +1964,68 @@ TRACE_EVENT(smb3_eio,
 		      __entry->info, __entry->info2)
 	    );
 
+TRACE_EVENT(smb3_data_ready,
+	    TP_PROTO(int dummy),
+	    TP_ARGS(dummy),
+	    TP_STRUCT__entry(
+		    __field(unsigned int, dummy)
+			     ),
+	    TP_fast_assign(
+		    __entry->dummy		= dummy;
+			   ),
+	    TP_printk("%d", __entry->dummy)
+	    );
+
+TRACE_EVENT(smb3_tcp_splice,
+	    TP_PROTO(int len),
+	    TP_ARGS(len),
+	    TP_STRUCT__entry(
+		    __field(unsigned int, len)
+			     ),
+	    TP_fast_assign(
+		    __entry->len		= len;
+			   ),
+	    TP_printk("l=%d", __entry->len)
+	    );
+
+TRACE_EVENT(smb3_rx_pdu,
+	    TP_PROTO(const struct netfs_rxqueue *rxq),
+	    TP_ARGS(rxq),
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	len)
+			     ),
+	    TP_fast_assign(
+		    __entry->len	= rxq->pdu_remain;
+			   ),
+	    TP_printk("l=%x",
+		      __entry->len)
+	    );
+
+TRACE_EVENT(smb3_reply,
+	    TP_PROTO(const struct smb_message *smb, const struct cifs_receive *recv),
+	    TP_ARGS(smb, recv),
+	    TP_STRUCT__entry(
+		    __field(unsigned int,	msg_id)
+		    __field(unsigned int,	cmd)
+		    __field(unsigned int,	doff)
+		    __field(unsigned int,	dlen)
+		    __field(unsigned int,	len)
+		    __field(unsigned int,	extr)
+			     ),
+	    TP_fast_assign(
+		    __entry->msg_id	= 0; /* TODO: fill in */
+		    __entry->cmd	= smb->command;
+		    __entry->doff	= recv->data_offset;
+		    __entry->dlen	= recv->data_len;
+		    __entry->len	= recv->msg_len;
+		    __entry->extr	= recv->extracted;
+			   ),
+	    TP_printk("MSG=%08x cmd=%x d=%x-%x l=%x/%x",
+		      __entry->msg_id, __entry->cmd,
+		      __entry->doff, __entry->doff + __entry->dlen,
+		      __entry->extr, __entry->len)
+	    );
+
 #undef EM
 #undef E_
 #endif /* _CIFS_TRACE_H */
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 3ea52cf4a64b..3f4d1a52b45c 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -87,7 +87,7 @@ void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 	unsigned long roundtrip_time;
 #endif
 
-	if (smb->resp_buf && smb->wait_cancelled &&
+	if (smb->response && smb->wait_cancelled &&
 	    (smb->mid_state == MID_RESPONSE_RECEIVED ||
 	     smb->mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
@@ -96,9 +96,11 @@ void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 	smb->mid_state = MID_FREE;
 	atomic_dec(&mid_count);
 	if (smb->large_buf)
-		cifs_buf_release(smb->resp_buf);
+		cifs_buf_release(smb->response);
 	else
-		cifs_small_buf_release(smb->resp_buf);
+		cifs_small_buf_release(smb->response);
+	if (smb->response_data)
+		netfs_put_rx_bvecq(smb->response_data);
 #ifdef CONFIG_CIFS_STATS2
 	now = jiffies;
 	if (now < smb->when_alloc)
@@ -701,9 +703,9 @@ int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb)
  */
 int
 cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
-		mid_receive_t receive, mid_callback_t callback,
-		mid_handle_t handle, void *cbdata, const int flags,
-		const struct cifs_credits *exist_credits)
+		mid_callback_t callback, void *cbdata, const int flags,
+		const struct cifs_credits *exist_credits,
+		struct iov_iter *resp_buf)
 {
 	int rc;
 	struct smb_message *smb;
@@ -743,11 +745,13 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	}
 
 	smb->sr_flags = flags;
-	smb->receive = receive;
 	smb->callback = callback;
 	smb->callback_data = cbdata;
-	smb->handle = handle;
 	smb->mid_state = MID_REQUEST_SUBMITTED;
+	if (resp_buf) {
+		smb->copy_to_bufs = true;
+		smb->response_iter = *resp_buf;
+	}
 
 	/* put it on the pending_mid_q */
 	spin_lock(&server->mid_queue_lock);
@@ -912,7 +916,6 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		{ .value = 0, .instance = 0 }
 	};
 	unsigned int instance;
-	char *buf;
 
 	optype = flags & CIFS_OP_MASK;
 
@@ -1079,7 +1082,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			goto out;
 		}
 
-		if (!smb[i]->resp_buf ||
+		if (!smb[i]->response ||
 		    smb[i]->mid_state != MID_RESPONSE_READY) {
 			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, smb[i]->mid_state);
 			cifs_dbg(FYI, "Bad MID state?\n");
@@ -1088,11 +1091,9 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = server->ops->check_receive(smb[i], server,
 						flags & CIFS_LOG_ERROR);
-
 		if (resp_iov) {
-			buf = (char *)smb[i]->resp_buf;
-			resp_iov[i].iov_base = buf;
-			resp_iov[i].iov_len = smb[i]->resp_buf_size;
+			resp_iov[i].iov_base = smb[i]->response;
+			resp_iov[i].iov_len = smb[i]->resp_len;
 
 			if (smb[i]->large_buf)
 				resp_buf_type[i] = CIFS_LARGE_BUFFER;
@@ -1101,7 +1102,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 			/* mark it so buf will not be freed by delete_mid */
 			if ((flags & CIFS_NO_RSP_BUF) == 0)
-				smb[i]->resp_buf = NULL;
+				smb[i]->response = NULL;
 		}
 	}
 
@@ -1146,193 +1147,3 @@ cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	return compound_send_recv(xid, ses, server, flags, 1,
 				  rqst, resp_buf_type, resp_iov);
 }
-
-
-/*
- * Discard any remaining data in the current SMB. To do this, we borrow the
- * current bigbuf.
- */
-int
-cifs_discard_remaining_data(struct TCP_Server_Info *server)
-{
-	unsigned int rfclen = server->pdu_size;
-	size_t remaining = rfclen - server->total_read;
-
-	while (remaining > 0) {
-		ssize_t length;
-
-		length = cifs_discard_from_socket(server,
-				min_t(size_t, remaining,
-				      CIFSMaxBufSize + MAX_HEADER_SIZE(server)));
-		if (length < 0)
-			return length;
-		server->total_read += length;
-		remaining -= length;
-	}
-
-	return 0;
-}
-
-static int
-__cifs_readv_discard(struct TCP_Server_Info *server, struct smb_message *smb,
-		     bool malformed)
-{
-	int length;
-
-	length = cifs_discard_remaining_data(server);
-	dequeue_mid(server, smb, malformed);
-	smb->resp_buf = server->smallbuf;
-	server->smallbuf = NULL;
-	return length;
-}
-
-static int
-cifs_readv_discard(struct TCP_Server_Info *server, struct smb_message *smb)
-{
-	struct cifs_io_subrequest *rdata = smb->callback_data;
-
-	return  __cifs_readv_discard(server, smb, rdata->result);
-}
-
-int
-cifs_readv_receive(struct TCP_Server_Info *server, struct smb_message *smb)
-{
-	int length, len;
-	unsigned int data_offset, data_len, end_off;
-	struct cifs_io_subrequest *rdata = smb->callback_data;
-	char *buf = server->smallbuf;
-	unsigned int buflen = server->pdu_size;
-	bool use_rdma_mr = false;
-
-	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%zu\n",
-		 __func__, smb->mid, rdata->subreq.start, rdata->subreq.len);
-
-	/*
-	 * read the rest of READ_RSP header (sans Data array), or whatever we
-	 * can if there's not enough data. At this point, we've read down to
-	 * the Mid.
-	 */
-	len = min_t(unsigned int, buflen, server->vals->read_rsp_size) -
-							HEADER_SIZE(server) + 1;
-
-	length = cifs_read_from_socket(server,
-				       buf + HEADER_SIZE(server) - 1, len);
-	if (length < 0)
-		return length;
-	server->total_read += length;
-
-	if (server->ops->is_session_expired &&
-	    server->ops->is_session_expired(buf)) {
-		cifs_reconnect(server, true);
-		return -1;
-	}
-
-	if (server->ops->is_status_pending &&
-	    server->ops->is_status_pending(buf, server)) {
-		cifs_discard_remaining_data(server);
-		return -1;
-	}
-
-	/* set up first two iov for signature check and to get credits */
-	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = server->total_read;
-	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
-		 rdata->iov[0].iov_base, rdata->iov[0].iov_len);
-
-	/* Was the SMB read successful? */
-	rdata->result = server->ops->map_error(buf, false);
-	if (rdata->result != 0) {
-		cifs_dbg(FYI, "%s: server returned error %d\n",
-			 __func__, rdata->result);
-		/* normal error on read response */
-		return __cifs_readv_discard(server, smb, false);
-	}
-
-	/* Is there enough to get to the rest of the READ_RSP header? */
-	if (server->total_read < server->vals->read_rsp_size) {
-		cifs_dbg(FYI, "%s: server returned short header. got=%u expected=%zu\n",
-			 __func__, server->total_read,
-			 server->vals->read_rsp_size);
-		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_short,
-					 server->total_read, server->vals->read_rsp_size);
-		return cifs_readv_discard(server, smb);
-	}
-
-	data_offset = server->ops->read_data_offset(buf);
-	if (data_offset < server->total_read) {
-		/*
-		 * win2k8 sometimes sends an offset of 0 when the read
-		 * is beyond the EOF. Treat it as if the data starts just after
-		 * the header.
-		 */
-		cifs_dbg(FYI, "%s: data offset (%u) inside read response header\n",
-			 __func__, data_offset);
-		data_offset = server->total_read;
-	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
-		/* data_offset is beyond the end of smallbuf */
-		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
-			 __func__, data_offset);
-		rdata->result = smb_EIO1(smb_eio_trace_read_overlarge,
-					 data_offset);
-		return cifs_readv_discard(server, smb);
-	}
-
-	cifs_dbg(FYI, "%s: total_read=%u data_offset=%u\n",
-		 __func__, server->total_read, data_offset);
-
-	len = data_offset - server->total_read;
-	if (len > 0) {
-		/* read any junk before data into the rest of smallbuf */
-		length = cifs_read_from_socket(server,
-					       buf + server->total_read, len);
-		if (length < 0)
-			return length;
-		server->total_read += length;
-		rdata->iov[0].iov_len = server->total_read;
-	}
-
-	/* how much data is in the response? */
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	use_rdma_mr = rdata->mr;
-#endif
-	data_len = server->ops->read_data_length(buf, use_rdma_mr);
-	if (!use_rdma_mr) {
-		if (check_add_overflow(data_offset, data_len, &end_off) ||
-		    end_off > buflen) {
-			/* data_len is corrupt -- discard frame */
-			rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
-						 end_off, buflen);
-			return cifs_readv_discard(server, smb);
-		}
-	}
-
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	if (rdata->mr) {
-		length = data_len; /* An RDMA read is already done. */
-	} else {
-#endif
-		struct iov_iter iter;
-
-		iov_iter_bvec_queue(&iter, ITER_DEST, rdata->subreq.content.bvecq,
-				    rdata->subreq.content.slot, rdata->subreq.content.offset,
-				    data_len);
-		length = cifs_read_iter_from_socket(server, &iter, data_len);
-#ifdef CONFIG_CIFS_SMB_DIRECT
-	}
-#endif
-	if (length > 0)
-		rdata->got_bytes += length;
-	server->total_read += length;
-
-	cifs_dbg(FYI, "total_read=%u buflen=%u remaining=%u\n",
-		 server->total_read, buflen, data_len);
-
-	/* discard anything left over */
-	if (server->total_read < buflen)
-		return cifs_readv_discard(server, smb);
-
-	dequeue_mid(server, smb, false);
-	smb->resp_buf = server->smallbuf;
-	server->smallbuf = NULL;
-	return length;
-}
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index dc5ec2643669..3d69daf8d7ef 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1782,4 +1782,34 @@ struct smb2_lease_ack {
 #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
 				| READ_CONTROL | SYNCHRONIZE)
 
+union smb2_response_hdr {
+	struct {
+		struct smb2_hdr		hdr;
+		 /* size of wct area (varies, request specific) */
+		__le16			StructureSize2;
+	} __packed;
+	struct smb2_pdu			pdu;
+	struct smb2_err_rsp		err;
+	struct smb2_negotiate_rsp	neg;
+	struct smb2_sess_setup_rsp	sess;
+	struct smb2_logoff_rsp		logoff;
+	struct smb2_tree_connect_rsp	tcon;
+	struct smb2_tree_disconnect_rsp	tdis;
+	struct smb2_create_rsp		create;
+	struct smb2_close_rsp		close;
+	struct smb2_flush_rsp		flush;
+	struct smb2_read_rsp		read;
+	struct smb2_write_rsp		write;
+	struct smb2_lock_rsp		lock;
+	struct smb2_ioctl_rsp		ioctl;
+	/* No cancel response */
+	struct smb2_echo_rsp		echo;
+	struct smb2_query_directory_rsp	qdir;
+	struct smb2_change_notify_rsp	change;
+	struct smb2_query_info_rsp	qinfo;
+	struct smb2_set_info_rsp	sinfo;
+	struct smb2_oplock_break	oplock;
+	struct smb2_lease_break		lease;
+};
+
 #endif				/* _COMMON_SMB2PDU_H */


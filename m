Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D373A9DA7
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 10:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779186168; cv=none; b=jWweM0ruphVUCdvDec1xvFas6kxayHzhTv8azIKFWIpPjsNx7nSHliPC3l0BuQVXVnVVDkwCS1exnkv53tssP0eWTkBvxdmKh3QyUpv/gJggdIfGu9AzVBw6hAbsE+f6uZgOnX1OCafni09eKa6tGmx524m3gkXRnNjIGCJwQb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779186168; c=relaxed/simple;
	bh=UnS3WLlEax4aKAQWI/Skfg3/IPLZZ5O+TjEVbib96ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZfkVKhG+QHbY9WSEMLLBcjSRNW5Q6i+uxJx0xQTm3c0OxbFgjId3vM0T+GPXIbkCR8hs/NDOrmym2gICZXyvpV/vyAuEXU9wLhtU5Hngjfms5RT+eRiN3aPXTbKY3rhTvV+cU0OPHktvAbU4odhASRohcdBSK50IYFEgQsyopU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Djb3Rdwn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Djb3Rdwn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779186162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VHv6uzP2cc3lhBUn+FDpH06+8TVfqASFrneWbhS4li8=;
	b=Djb3Rdwn8XL3qGoft+w36aezyiJ7cHJyvUSAkTN0/tIA4wPF2C1h4aCBAxBms9LWvvfzMC
	VayhOLlSyil5Sp3MtWqDp/s78sU5T9PkjdCichTHuxYwitzbiFX2FFSBgoCcuIT3yBgWZv
	5JuCcTdv6yyrOY602BxZ+GdSNJsJKd0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-sC-HbGaPOjq7h7g-SrkiiA-1; Tue,
 19 May 2026 06:22:37 -0400
X-MC-Unique: sC-HbGaPOjq7h7g-SrkiiA-1
X-Mimecast-MFC-AGG-ID: sC-HbGaPOjq7h7g-SrkiiA_1779186155
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C04161800617;
	Tue, 19 May 2026 10:22:35 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.33])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C4621956053;
	Tue, 19 May 2026 10:22:31 +0000 (UTC)
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
Subject: [RFC PATCH 06/36] cifs: Rename mid_q_entry to smb_message
Date: Tue, 19 May 2026 11:21:24 +0100
Message-ID: <20260519102158.592165-7-dhowells@redhat.com>
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

Rename mid_q_entry to smb_message as future development that will allocate
it at a higher level in the marshalling code and then hand it down into the
transport layer.  It will also be used to pass parameters such as the send
and receive data buffers, credits and other things.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/cifs_debug.c    |  44 +++----
 fs/smb/client/cifsfs.c        |  30 ++---
 fs/smb/client/cifsglob.h      |  58 ++++----
 fs/smb/client/cifsproto.h     |  31 +++--
 fs/smb/client/cifssmb.c       |  36 ++---
 fs/smb/client/connect.c       | 150 ++++++++++-----------
 fs/smb/client/smb1maperror.c  |  12 +-
 fs/smb/client/smb1ops.c       |  40 +++---
 fs/smb/client/smb1proto.h     |  10 +-
 fs/smb/client/smb1transport.c |  86 ++++++------
 fs/smb/client/smb2misc.c      |   8 +-
 fs/smb/client/smb2ops.c       | 122 ++++++++---------
 fs/smb/client/smb2pdu.c       |  38 +++---
 fs/smb/client/smb2proto.h     |  10 +-
 fs/smb/client/smb2transport.c |  76 +++++------
 fs/smb/client/transport.c     | 240 +++++++++++++++++-----------------
 16 files changed, 495 insertions(+), 496 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 4ed4f55a0bb7..2d0d26ee57ce 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -38,33 +38,33 @@ cifs_dump_mem(char *label, void *data, int length)
 void cifs_dump_mids(struct TCP_Server_Info *server)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct mid_q_entry *mid_entry;
+	struct smb_message *smb;
 
 	if (server == NULL)
 		return;
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&server->mid_queue_lock);
-	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
-			 mid_entry->mid_state,
-			 le16_to_cpu(mid_entry->command),
-			 mid_entry->pid,
-			 mid_entry->callback_data,
-			 mid_entry->mid);
+			 smb->mid_state,
+			 le16_to_cpu(smb->command),
+			 smb->pid,
+			 smb->callback_data,
+			 smb->mid);
 #ifdef CONFIG_CIFS_STATS2
 		cifs_dbg(VFS, "IsLarge: %d buf: %p time rcv: %ld now: %ld\n",
-			 mid_entry->large_buf,
-			 mid_entry->resp_buf,
-			 mid_entry->when_received,
+			 smb->large_buf,
+			 smb->resp_buf,
+			 smb->when_received,
 			 jiffies);
 #endif /* STATS2 */
 		cifs_dbg(VFS, "IsMult: %d IsEnd: %d\n",
-			 mid_entry->multiRsp, mid_entry->multiEnd);
-		if (mid_entry->resp_buf) {
-			server->ops->dump_detail(mid_entry->resp_buf,
-					 mid_entry->response_pdu_len, server);
-			cifs_dump_mem("existing buf: ", mid_entry->resp_buf, 62);
+			 smb->multiRsp, smb->multiEnd);
+		if (smb->resp_buf) {
+			server->ops->dump_detail(smb->resp_buf,
+						 smb->response_pdu_len, server);
+			cifs_dump_mem("existing buf: ", smb->resp_buf, 62);
 		}
 	}
 	spin_unlock(&server->mid_queue_lock);
@@ -437,7 +437,7 @@ static __always_inline const char *cipher_alg_str(__le16 cipher)
 
 static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 {
-	struct mid_q_entry *mid_entry;
+	struct smb_message *smb;
 	struct TCP_Server_Info *server;
 	struct TCP_Server_Info *chan_server;
 	struct cifs_ses *ses;
@@ -694,13 +694,13 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				seq_printf(m, "\n\tServer ConnectionId: 0x%llx",
 					   chan_server->conn_id);
 				spin_lock(&chan_server->mid_queue_lock);
-				list_for_each_entry(mid_entry, &chan_server->pending_mid_q, qhead) {
+				list_for_each_entry(smb, &chan_server->pending_mid_q, qhead) {
 					seq_printf(m, "\n\t\tState: %d com: %d pid: %d cbdata: %p mid %llu",
-						   mid_entry->mid_state,
-						   le16_to_cpu(mid_entry->command),
-						   mid_entry->pid,
-						   mid_entry->callback_data,
-						   mid_entry->mid);
+						   smb->mid_state,
+						   le16_to_cpu(smb->command),
+						   smb->pid,
+						   smb->callback_data,
+						   smb->mid);
 				}
 				spin_unlock(&chan_server->mid_queue_lock);
 			}
diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index f557eb7875c7..434c6943dd69 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -405,13 +405,13 @@ static int cifs_permission(struct mnt_idmap *idmap,
 
 static struct kmem_cache *cifs_inode_cachep;
 static struct kmem_cache *cifs_req_cachep;
-static struct kmem_cache *cifs_mid_cachep;
+static struct kmem_cache *smb_message_cachep;
 static struct kmem_cache *cifs_sm_req_cachep;
 static struct kmem_cache *cifs_io_request_cachep;
 static struct kmem_cache *cifs_io_subrequest_cachep;
 mempool_t *cifs_sm_req_poolp;
 mempool_t *cifs_req_poolp;
-mempool_t cifs_mid_pool;
+mempool_t smb_message_pool;
 mempool_t cifs_io_request_pool;
 mempool_t cifs_io_subrequest_pool;
 
@@ -1820,27 +1820,27 @@ cifs_destroy_request_bufs(void)
 	kmem_cache_destroy(cifs_sm_req_cachep);
 }
 
-static int init_mids(void)
+static int init_smb_message(void)
 {
-	cifs_mid_cachep = kmem_cache_create("cifs_mpx_ids",
-					    sizeof(struct mid_q_entry), 0,
-					    SLAB_HWCACHE_ALIGN, NULL);
-	if (cifs_mid_cachep == NULL)
+	smb_message_cachep = kmem_cache_create("cifs_smb_message",
+					       sizeof(struct smb_message), 0,
+					       SLAB_HWCACHE_ALIGN, NULL);
+	if (smb_message_cachep == NULL)
 		return -ENOMEM;
 
 	/* 3 is a reasonable minimum number of simultaneous operations */
-	if (mempool_init_slab_pool(&cifs_mid_pool, 3, cifs_mid_cachep) < 0) {
-		kmem_cache_destroy(cifs_mid_cachep);
+	if (mempool_init_slab_pool(&smb_message_pool, 3, smb_message_cachep) < 0) {
+		kmem_cache_destroy(smb_message_cachep);
 		return -ENOMEM;
 	}
 
 	return 0;
 }
 
-static void destroy_mids(void)
+static void destroy_smb_message(void)
 {
-	mempool_exit(&cifs_mid_pool);
-	kmem_cache_destroy(cifs_mid_cachep);
+	mempool_exit(&smb_message_pool);
+	kmem_cache_destroy(smb_message_cachep);
 }
 
 static int cifs_init_netfs(void)
@@ -2015,7 +2015,7 @@ init_cifs(void)
 	if (rc)
 		goto out_destroy_inodecache;
 
-	rc = init_mids();
+	rc = init_smb_message();
 	if (rc)
 		goto out_destroy_netfs;
 
@@ -2072,7 +2072,7 @@ init_cifs(void)
 #endif
 	cifs_destroy_request_bufs();
 out_destroy_mids:
-	destroy_mids();
+	destroy_smb_message();
 out_destroy_netfs:
 	cifs_destroy_netfs();
 out_destroy_inodecache:
@@ -2114,7 +2114,7 @@ exit_cifs(void)
 	dfs_cache_destroy();
 #endif
 	cifs_destroy_request_bufs();
-	destroy_mids();
+	destroy_smb_message();
 	cifs_destroy_netfs();
 	cifs_destroy_inodecache();
 	destroy_workqueue(deferredclose_wq);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 69924b01dd2c..a5e12a2eefdd 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -291,7 +291,7 @@ struct smb_rqst {
 	struct bvecq	*rq_buffer;	/* Buffer for encryption */
 };
 
-struct mid_q_entry;
+struct smb_message;
 struct TCP_Server_Info;
 struct cifsFileInfo;
 struct cifs_ses;
@@ -309,25 +309,25 @@ struct cifs_credits;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct cifs_ses *ses, struct TCP_Server_Info *server,
-			   struct smb_rqst *rqst, struct mid_q_entry *mid,
+			   struct smb_rqst *rqst, struct smb_message *smb,
 			   unsigned int xid);
 	bool (*compare_fids)(struct cifsFileInfo *, struct cifsFileInfo *);
 	/* setup request: allocate mid, sign message */
-	struct mid_q_entry *(*setup_request)(struct cifs_ses *,
-					     struct TCP_Server_Info *,
-					     struct smb_rqst *);
+	struct smb_message *(*setup_request)(struct cifs_ses *ses,
+					     struct TCP_Server_Info *server,
+					     struct smb_rqst *rqst);
 	/* setup async request: allocate mid, sign message */
-	struct mid_q_entry *(*setup_async_request)(struct TCP_Server_Info *,
-						struct smb_rqst *);
+	struct smb_message *(*setup_async_request)(struct TCP_Server_Info *server,
+						   struct smb_rqst *rqst);
 	/* check response: verify signature, map error */
-	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
-			     bool);
+	int (*check_receive)(struct smb_message *mid, struct TCP_Server_Info *server,
+			     bool log_error);
 	void (*add_credits)(struct TCP_Server_Info *server,
 			    struct cifs_credits *credits,
 			    const int optype);
 	void (*set_credits)(struct TCP_Server_Info *, const int);
 	int * (*get_credits_field)(struct TCP_Server_Info *, const int);
-	unsigned int (*get_credits)(struct mid_q_entry *);
+	unsigned int (*get_credits)(struct smb_message *smb);
 	__u64 (*get_next_mid)(struct TCP_Server_Info *);
 	void (*revert_current_mid)(struct TCP_Server_Info *server,
 				   const unsigned int val);
@@ -344,7 +344,7 @@ struct smb_version_operations {
 	/* map smb to linux error */
 	int (*map_error)(char *, bool);
 	/* find mid corresponding to the response message */
-	struct mid_q_entry *(*find_mid)(struct TCP_Server_Info *server, char *buf);
+	struct smb_message *(*find_mid)(struct TCP_Server_Info *server, char *buf);
 	void (*dump_detail)(void *buf, size_t buf_len, struct TCP_Server_Info *ptcp_info);
 	void (*clear_stats)(struct cifs_tcon *);
 	void (*print_stats)(struct seq_file *m, struct cifs_tcon *);
@@ -353,13 +353,13 @@ struct smb_version_operations {
 	int (*check_message)(char *buf, unsigned int pdu_len, unsigned int len,
 			     struct TCP_Server_Info *server);
 	bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
-	int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Server_Info *);
+	int (*handle_cancelled_mid)(struct smb_message *smb, struct TCP_Server_Info *server);
 	void (*downgrade_oplock)(struct TCP_Server_Info *server,
 				 struct cifsInodeInfo *cinode, __u32 oplock,
 				 __u16 epoch, bool *purge_cache);
 	/* process transaction2 response */
-	bool (*check_trans2)(struct mid_q_entry *, struct TCP_Server_Info *,
-			     char *, int);
+	bool (*check_trans2)(struct smb_message *smb, struct TCP_Server_Info *server,
+			     char *buf, int malformed);
 	/* check if we need to negotiate */
 	bool (*need_neg)(struct TCP_Server_Info *);
 	/* negotiate to the server */
@@ -595,7 +595,7 @@ struct smb_version_operations {
 				 struct smb_rqst *, struct smb_rqst *);
 	int (*is_transform_hdr)(void *buf);
 	int (*receive_transform)(struct TCP_Server_Info *,
-				 struct mid_q_entry **, char **, int *);
+				 struct smb_message **smb, char **, int *);
 	enum securityEnum (*select_sectype)(struct TCP_Server_Info *,
 			    enum securityEnum);
 	int (*next_header)(struct TCP_Server_Info *server, char *buf,
@@ -1682,7 +1682,7 @@ static inline void cifs_stats_bytes_read(struct cifs_tcon *tcon,
  * the TCP_Server_Info will also be updated.
  */
 typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
-			    struct mid_q_entry *mid);
+			     struct smb_message *msg);
 
 /*
  * This is the prototype for the mid callback function. This is called once the
@@ -1692,17 +1692,17 @@ typedef int (*mid_receive_t)(struct TCP_Server_Info *server,
  * - it will be called by cifsd, with no locks held
  * - the mid will be removed from any lists
  */
-typedef void (*mid_callback_t)(struct TCP_Server_Info *srv, struct mid_q_entry *mid);
+typedef void (*mid_callback_t)(struct TCP_Server_Info *srv, struct smb_message *smb);
 
 /*
  * This is the protopyte for mid handle function. This is called once the mid
  * has been recognized after decryption of the message.
  */
 typedef int (*mid_handle_t)(struct TCP_Server_Info *server,
-			    struct mid_q_entry *mid);
+			    struct smb_message *smb);
 
 /* one of these for every pending CIFS request to the server */
-struct mid_q_entry {
+struct smb_message {
 	struct list_head qhead;	/* mids waiting on reply from this server */
 	refcount_t refcount;
 	__u64 mid;		/* multiplex id */
@@ -1768,12 +1768,12 @@ static inline void cifs_num_waiters_dec(struct TCP_Server_Info *server)
 }
 
 #ifdef CONFIG_CIFS_STATS2
-static inline void cifs_save_when_sent(struct mid_q_entry *mid)
+static inline void cifs_save_when_sent(struct smb_message *smb)
 {
-	mid->when_sent = jiffies;
+	smb->when_sent = jiffies;
 }
 #else
-static inline void cifs_save_when_sent(struct mid_q_entry *mid)
+static inline void cifs_save_when_sent(struct smb_message *smb)
 {
 }
 #endif
@@ -2141,7 +2141,7 @@ extern __u32 cifs_lock_secret;
 
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
-extern mempool_t cifs_mid_pool;
+extern mempool_t smb_message_pool;
 extern mempool_t cifs_io_request_pool;
 extern mempool_t cifs_io_subrequest_pool;
 
@@ -2300,17 +2300,17 @@ static inline bool cifs_netbios_name(const char *name, size_t namelen)
  * and prevents sleeping in atomic context.
  */
 static inline void mid_execute_callback(struct TCP_Server_Info *server,
-					struct mid_q_entry *mid)
+					struct smb_message *smb)
 {
 	mid_callback_t callback;
 
-	spin_lock(&mid->mid_lock);
-	callback = mid->callback;
-	mid->callback = NULL;  /* Mark as executed, */
-	spin_unlock(&mid->mid_lock);
+	spin_lock(&smb->mid_lock);
+	callback = smb->callback;
+	smb->callback = NULL;  /* Mark as executed, */
+	spin_unlock(&smb->mid_lock);
 
 	if (callback)
-		callback(server, mid);
+		callback(server, smb);
 }
 
 #define CIFS_REPARSE_SUPPORT(tcon) \
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 79d891f7df1a..f88ae04af85d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -80,13 +80,12 @@ char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
 			      struct cifs_sb_info *cifs_sb,
 			      struct cifs_tcon *tcon, int add_treename);
 char *cifs_build_devname(char *nodename, const char *prepath);
-void delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid);
-void __release_mid(struct TCP_Server_Info *server,
-		   struct mid_q_entry *midEntry);
+void delete_mid(struct TCP_Server_Info *server, struct smb_message *smb);
+void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb);
 void cifs_wake_up_task(struct TCP_Server_Info *server,
-		       struct mid_q_entry *mid);
+		       struct smb_message *smb);
 int cifs_handle_standard(struct TCP_Server_Info *server,
-			 struct mid_q_entry *mid);
+			 struct smb_message *smb);
 char *smb3_fs_context_fullpath(const struct smb3_fs_context *ctx, char dirsep);
 int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
 int cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs);
@@ -104,7 +103,7 @@ int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		       struct TCP_Server_Info *server, const int flags,
 		       const int num_rqst, struct smb_rqst *rqst,
 		       int *resp_buf_type, struct kvec *resp_iov);
-int cifs_sync_mid_result(struct mid_q_entry *mid,
+int cifs_sync_mid_result(struct smb_message *mid,
 			 struct TCP_Server_Info *server);
 int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		    struct smb_rqst *rqst);
@@ -115,14 +114,14 @@ int cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 
 static inline int
 send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-	    struct smb_rqst *rqst, struct mid_q_entry *mid,
+	    struct smb_rqst *rqst, struct smb_message *smb,
 	    unsigned int xid)
 {
 	return server->ops->send_cancel ?
-		server->ops->send_cancel(ses, server, rqst, mid, xid) : 0;
+		server->ops->send_cancel(ses, server, rqst, smb, xid) : 0;
 }
 
-int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid);
+int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb);
 
 void smb2_query_server_interfaces(struct work_struct *work);
 void cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
@@ -222,7 +221,7 @@ unsigned int setup_special_mode_ACE(struct smb_ace *pntace, bool posix,
 				    __u64 nmode);
 unsigned int setup_special_user_owner_ACE(struct smb_ace *pntace);
 
-void dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+void dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb,
 		 bool malformed);
 int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 			  unsigned int to_read);
@@ -334,7 +333,7 @@ struct cifs_ses *cifs_get_smb_ses(struct TCP_Server_Info *server,
 				  struct smb3_fs_context *ctx);
 
 int cifs_readv_receive(struct TCP_Server_Info *server,
-		       struct mid_q_entry *mid);
+		       struct smb_message *smb);
 
 int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
@@ -471,15 +470,15 @@ static inline bool dfs_src_pathname_equal(const char *s1, const char *s2)
 	return true;
 }
 
-static inline void smb_get_mid(struct mid_q_entry *mid)
+static inline void smb_get_mid(struct smb_message *smb)
 {
-	refcount_inc(&mid->refcount);
+	refcount_inc(&smb->refcount);
 }
 
-static inline void release_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+static inline void release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	if (refcount_dec_and_test(&mid->refcount))
-		__release_mid(server, mid);
+	if (refcount_dec_and_test(&smb->refcount))
+		__release_mid(server, smb);
 }
 
 static inline void cifs_free_open_info(struct cifs_open_info_data *data)
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 0b1051a17ca8..25f6289ee72f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -727,11 +727,11 @@ CIFSSMBTDis(const unsigned int xid, struct cifs_tcon *tcon)
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-cifs_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_echo_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	struct cifs_credits credits = { .value = 1, .instance = 0 };
 
-	release_mid(server, mid);
+	release_mid(server, smb);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -1460,9 +1460,9 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 }
 
 static void
-cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *rdata = mid->callback_data;
+	struct cifs_io_subrequest *rdata = smb->callback_data;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct inode *inode = &ictx->inode;
@@ -1478,7 +1478,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu\n",
-		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 __func__, smb->mid, smb->mid_state, rdata->result,
 		 rdata->subreq.len);
 
 	if (rdata->got_bytes)
@@ -1486,7 +1486,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 				    rdata->subreq.content.bvecq, rdata->subreq.content.slot,
 				    rdata->subreq.content.offset, rdata->subreq.len);
 
-	switch (mid->mid_state) {
+	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
 		if (server->sign) {
@@ -1494,7 +1494,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
 			rc = cifs_verify_signature(&rqst, server,
-						  mid->sequence_number);
+						  smb->sequence_number);
 			if (rc)
 				cifs_dbg(VFS, "SMB signature verification returned error = %d\n",
 					 rc);
@@ -1525,7 +1525,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	default:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_unknown);
 		rdata->result = smb_EIO1(smb_eio_trace_read_mid_state_unknown,
-					 mid->mid_state);
+					 smb->mid_state);
 		break;
 	}
 
@@ -1568,7 +1568,7 @@ cifs_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	rdata->subreq.transferred += rdata->got_bytes;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
-	release_mid(server, mid);
+	release_mid(server, smb);
 	add_credits(server, &credits, 0);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
@@ -1885,11 +1885,11 @@ CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
  * workqueue completion task.
  */
 static void
-cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *wdata = mid->callback_data;
+	struct cifs_io_subrequest *wdata = smb->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
-	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
+	WRITE_RSP *rsp = (WRITE_RSP *)smb->resp_buf;
 	struct cifs_credits credits = {
 		.value = 1,
 		.instance = 0,
@@ -1899,15 +1899,15 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	ssize_t result;
 	size_t written;
 
-	switch (mid->mid_state) {
+	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		result = cifs_check_receive(mid, tcon->ses->server, 0);
+		result = cifs_check_receive(smb, tcon->ses->server, 0);
 		if (result != 0)
 			break;
 
-		written = le16_to_cpu(smb->CountHigh);
+		written = le16_to_cpu(rsp->CountHigh);
 		written <<= 16;
-		written += le16_to_cpu(smb->Count);
+		written += le16_to_cpu(rsp->Count);
 		/*
 		 * Mask off high 16 bits when bytes written as returned
 		 * by the server is greater than bytes requested by the
@@ -1942,7 +1942,7 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	default:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_unknown);
 		result = smb_EIO1(smb_eio_trace_write_mid_state_unknown,
-				  mid->mid_state);
+				  smb->mid_state);
 		break;
 	}
 
@@ -1952,7 +1952,7 @@ cifs_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			      0, cifs_trace_rw_credits_write_response_clear);
 	wdata->credits.value = 0;
 	cifs_write_subrequest_terminated(wdata, result);
-	release_mid(server, mid);
+	release_mid(server, smb);
 	trace_smb3_rw_credits(credits.rreq_debug_id, credits.rreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468d..97de3ae68d7a 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -295,7 +295,7 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 static void
 cifs_abort_connection(struct TCP_Server_Info *server)
 {
-	struct mid_q_entry *mid, *nmid;
+	struct smb_message *smb, *nsmb;
 	struct list_head retry_list;
 
 	server->maxBuf = 0;
@@ -326,21 +326,21 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
-	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
-		smb_get_mid(mid);
-		if (mid->mid_state == MID_REQUEST_SUBMITTED)
-			mid->mid_state = MID_RETRY_NEEDED;
-		list_move(&mid->qhead, &retry_list);
-		mid->deleted_from_q = true;
+	list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
+		smb_get_mid(smb);
+		if (smb->mid_state == MID_REQUEST_SUBMITTED)
+			smb->mid_state = MID_RETRY_NEEDED;
+		list_move(&smb->qhead, &retry_list);
+		smb->deleted_from_q = true;
 	}
 	spin_unlock(&server->mid_queue_lock);
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
-	list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
-		list_del_init(&mid->qhead);
-		mid_execute_callback(server, mid);
-		release_mid(server, mid);
+	list_for_each_entry_safe(smb, nsmb, &retry_list, qhead) {
+		list_del_init(&smb->qhead);
+		mid_execute_callback(server, smb);
+		release_mid(server, smb);
 	}
 }
 
@@ -870,7 +870,7 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 		    !server->with_rfc1001 &&
 		    server->rfc1001_sessinit != 0) {
 			int rc, mid_rc;
-			struct mid_q_entry *mid, *nmid;
+			struct smb_message *smb, *nsmb;
 			LIST_HEAD(dispose_list);
 
 			cifs_dbg(FYI, "RFC 1002 negative session response during SMB Negotiate, retrying with NetBIOS session\n");
@@ -883,10 +883,10 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 * corresponding to SMB1/SMB2 Negotiate packet.
 			 */
 			spin_lock(&server->mid_queue_lock);
-			list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
-				smb_get_mid(mid);
-				list_move(&mid->qhead, &dispose_list);
-				mid->deleted_from_q = true;
+			list_for_each_entry_safe(smb, nsmb, &server->pending_mid_q, qhead) {
+				smb_get_mid(smb);
+				list_move(&smb->qhead, &dispose_list);
+				smb->deleted_from_q = true;
 			}
 			spin_unlock(&server->mid_queue_lock);
 
@@ -913,12 +913,12 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 * callback. Use MID_RC state which indicates that the
 			 * return code should be read from mid_rc member.
 			 */
-			list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
-				list_del_init(&mid->qhead);
-				mid->mid_rc = mid_rc;
-				mid->mid_state = MID_RC;
-				mid_execute_callback(server, mid);
-				release_mid(server, mid);
+			list_for_each_entry_safe(smb, nsmb, &dispose_list, qhead) {
+				list_del_init(&smb->qhead);
+				smb->mid_rc = mid_rc;
+				smb->mid_state = MID_RC;
+				mid_execute_callback(server, smb);
+				release_mid(server, smb);
 			}
 
 			/*
@@ -950,26 +950,26 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 }
 
 void
-dequeue_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid, bool malformed)
+dequeue_mid(struct TCP_Server_Info *server, struct smb_message *smb, bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
-	mid->when_received = jiffies;
+	smb->when_received = jiffies;
 #endif
 	spin_lock(&server->mid_queue_lock);
 	if (!malformed)
-		mid->mid_state = MID_RESPONSE_RECEIVED;
+		smb->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		mid->mid_state = MID_RESPONSE_MALFORMED;
+		smb->mid_state = MID_RESPONSE_MALFORMED;
 	/*
 	 * Trying to handle/dequeue a mid after the send_recv()
 	 * function has finished processing it is a bug.
 	 */
-	if (mid->deleted_from_q == true) {
+	if (smb->deleted_from_q == true) {
 		spin_unlock(&server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
-		list_del_init(&mid->qhead);
-		mid->deleted_from_q = true;
+		list_del_init(&smb->qhead);
+		smb->deleted_from_q = true;
 		spin_unlock(&server->mid_queue_lock);
 	}
 }
@@ -989,24 +989,24 @@ smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 }
 
 static void
-handle_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+handle_mid(struct smb_message *smb, struct TCP_Server_Info *server,
 	   char *buf, int malformed)
 {
 	if (server->ops->check_trans2 &&
-	    server->ops->check_trans2(mid, server, buf, malformed))
+	    server->ops->check_trans2(smb, server, buf, malformed))
 		return;
-	mid->credits_received = smb2_get_credits_from_hdr(buf, server);
-	mid->resp_buf = buf;
-	mid->large_buf = server->large_buf;
+	smb->credits_received = smb2_get_credits_from_hdr(buf, server);
+	smb->resp_buf = buf;
+	smb->large_buf = server->large_buf;
 	/* Was previous buf put in mpx struct for multi-rsp? */
-	if (!mid->multiRsp) {
+	if (!smb->multiRsp) {
 		/* smb buffer will be freed by user thread */
 		if (server->large_buf)
 			server->bigbuf = NULL;
 		else
 			server->smallbuf = NULL;
 	}
-	dequeue_mid(server, mid, malformed);
+	dequeue_mid(server, smb, malformed);
 }
 
 int
@@ -1095,28 +1095,28 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	}
 
 	if (!list_empty(&server->pending_mid_q)) {
-		struct mid_q_entry *mid_entry;
+		struct smb_message *smb;
 		struct list_head *tmp, *tmp2;
 		LIST_HEAD(dispose_list);
 
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
-			smb_get_mid(mid_entry);
-			mid_entry->mid_state = MID_SHUTDOWN;
-			list_move(&mid_entry->qhead, &dispose_list);
-			mid_entry->deleted_from_q = true;
+			smb = list_entry(tmp, struct smb_message, qhead);
+			cifs_dbg(FYI, "Clearing mid %llu\n", smb->mid);
+			smb_get_mid(smb);
+			smb->mid_state = MID_SHUTDOWN;
+			list_move(&smb->qhead, &dispose_list);
+			smb->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
-			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
-			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
-			list_del_init(&mid_entry->qhead);
-			mid_execute_callback(server, mid_entry);
-			release_mid(server, mid_entry);
+			smb = list_entry(tmp, struct smb_message, qhead);
+			cifs_dbg(FYI, "Callback mid %llu\n", smb->mid);
+			list_del_init(&smb->qhead);
+			mid_execute_callback(server, smb);
+			release_mid(server, smb);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
@@ -1150,7 +1150,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 }
 
 static int
-standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+standard_receive3(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	int length;
 	char *buf = server->smallbuf;
@@ -1180,11 +1180,11 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	dump_smb(buf, server->total_read);
 
-	return cifs_handle_standard(server, mid);
+	return cifs_handle_standard(server, smb);
 }
 
 int
-cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_handle_standard(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
 	int rc;
@@ -1213,10 +1213,10 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	    server->ops->is_status_pending(buf, server))
 		return -1;
 
-	if (!mid)
+	if (!smb)
 		return rc;
 
-	handle_mid(mid, server, buf, rc);
+	handle_mid(smb, server, buf, rc);
 	return 0;
 }
 
@@ -1253,13 +1253,13 @@ smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 static int
 cifs_demultiplex_thread(void *p)
 {
-	int i, num_mids, length;
+	int i, num_smbs, length;
 	struct TCP_Server_Info *server = p;
 	unsigned int pdu_length;
 	unsigned int next_offset;
 	char *buf = NULL;
 	struct task_struct *task_to_wake = NULL;
-	struct mid_q_entry *mids[MAX_COMPOUND];
+	struct smb_message *smbs[MAX_COMPOUND];
 	char *bufs[MAX_COMPOUND];
 	unsigned int noreclaim_flag, num_io_timeout = 0;
 	bool pending_reconnect = false;
@@ -1330,34 +1330,34 @@ cifs_demultiplex_thread(void *p)
 				server->pdu_size = next_offset;
 		}
 
-		memset(mids, 0, sizeof(mids));
+		memset(smbs, 0, sizeof(smbs));
 		memset(bufs, 0, sizeof(bufs));
-		num_mids = 0;
+		num_smbs = 0;
 
 		if (server->ops->is_transform_hdr &&
 		    server->ops->receive_transform &&
 		    server->ops->is_transform_hdr(buf)) {
 			length = server->ops->receive_transform(server,
-								mids,
+								smbs,
 								bufs,
-								&num_mids);
+								&num_smbs);
 		} else {
-			mids[0] = server->ops->find_mid(server, buf);
+			smbs[0] = server->ops->find_mid(server, buf);
 			bufs[0] = buf;
-			num_mids = 1;
+			num_smbs = 1;
 
-			if (mids[0])
-				mids[0]->response_pdu_len = pdu_length;
-			if (!mids[0] || !mids[0]->receive)
-				length = standard_receive3(server, mids[0]);
+			if (smbs[0])
+				smbs[0]->response_pdu_len = pdu_length;
+			if (!smbs[0] || !smbs[0]->receive)
+				length = standard_receive3(server, smbs[0]);
 			else
-				length = mids[0]->receive(server, mids[0]);
+				length = smbs[0]->receive(server, smbs[0]);
 		}
 
 		if (length < 0) {
-			for (i = 0; i < num_mids; i++)
-				if (mids[i])
-					release_mid(server, mids[i]);
+			for (i = 0; i < num_smbs; i++)
+				if (smbs[i])
+					release_mid(server, smbs[i]);
 			continue;
 		}
 
@@ -1376,9 +1376,9 @@ cifs_demultiplex_thread(void *p)
 
 		server->lstrp = jiffies;
 
-		for (i = 0; i < num_mids; i++) {
-			if (mids[i] != NULL) {
-				mids[i]->resp_buf_size = server->pdu_size;
+		for (i = 0; i < num_smbs; i++) {
+			if (smbs[i] != NULL) {
+				smbs[i]->resp_buf_size = server->pdu_size;
 
 				if (bufs[i] != NULL) {
 					if (server->ops->is_network_name_deleted &&
@@ -1389,10 +1389,10 @@ cifs_demultiplex_thread(void *p)
 					}
 				}
 
-				if (!mids[i]->multiRsp || mids[i]->multiEnd)
-					mid_execute_callback(server, mids[i]);
+				if (!smbs[i]->multiRsp || smbs[i]->multiEnd)
+					mid_execute_callback(server, smbs[i]);
 
-				release_mid(server, mids[i]);
+				release_mid(server, smbs[i]);
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 74530088d17d..c84f6256e146 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -172,16 +172,16 @@ map_smb_to_linux_error(char *buf, bool logErr)
 
 int
 map_and_check_smb_error(struct TCP_Server_Info *server,
-			struct mid_q_entry *mid, bool logErr)
+			struct smb_message *smb, bool logErr)
 {
 	int rc;
-	struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
+	struct smb_hdr *rhdr = (struct smb_hdr *)smb->resp_buf;
 
-	rc = map_smb_to_linux_error((char *)smb, logErr);
-	if (rc == -EACCES && !(smb->Flags2 & SMBFLG2_ERR_STATUS)) {
+	rc = map_smb_to_linux_error((char *)rhdr, logErr);
+	if (rc == -EACCES && !(rhdr->Flags2 & SMBFLG2_ERR_STATUS)) {
 		/* possible ERRBaduid */
-		__u8 class = smb->Status.DosError.ErrorClass;
-		__u16 code = le16_to_cpu(smb->Status.DosError.Error);
+		__u8 class = rhdr->Status.DosError.ErrorClass;
+		__u16 code = le16_to_cpu(rhdr->Status.DosError.Error);
 
 		/* switch can be used to handle different errors */
 		if (class == ERRSRV && code == ERRbaduid) {
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index e198e3dda917..c1c16f6346fb 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -139,7 +139,7 @@ void reset_cifs_unix_caps(unsigned int xid, struct cifs_tcon *tcon,
  */
 static int
 send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-	       struct smb_rqst *rqst, struct mid_q_entry *mid,
+	       struct smb_rqst *rqst, struct smb_message *smb,
 	       unsigned int xid)
 {
 	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
@@ -156,7 +156,7 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	iov[0].iov_len  = sizeof(struct smb_hdr) + 2;
 
 	cifs_server_lock(server);
-	rc = cifs_sign_rqst(&crqst, server, &mid->sequence_number);
+	rc = cifs_sign_rqst(&crqst, server, &smb->sequence_number);
 	if (rc) {
 		cifs_server_unlock(server);
 		return rc;
@@ -186,7 +186,7 @@ send_nt_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
  */
 static int
 send_lock_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		 struct smb_rqst *rqst, struct mid_q_entry *mid,
+		 struct smb_rqst *rqst, struct smb_message *smb,
 		 unsigned int xid)
 {
 	struct smb_hdr *in_buf = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
@@ -212,12 +212,12 @@ send_lock_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
 }
 
 static int cifs_send_cancel(struct cifs_ses *ses, struct TCP_Server_Info *server,
-			    struct smb_rqst *rqst, struct mid_q_entry *mid,
+			    struct smb_rqst *rqst, struct smb_message *smb,
 			    unsigned int xid)
 {
-	if (mid->sr_flags & CIFS_WINDOWS_LOCK)
-		return send_lock_cancel(ses, server, rqst, mid, xid);
-	return send_nt_cancel(ses, server, rqst, mid, xid);
+	if (smb->sr_flags & CIFS_WINDOWS_LOCK)
+		return send_lock_cancel(ses, server, rqst, smb, xid);
+	return send_nt_cancel(ses, server, rqst, smb, xid);
 }
 
 static bool
@@ -243,20 +243,20 @@ cifs_read_data_length(char *buf, bool in_remaining)
 	       le16_to_cpu(rsp->DataLength);
 }
 
-static struct mid_q_entry *
+static struct smb_message *
 cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 {
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 
 	spin_lock(&server->mid_queue_lock);
-	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
-		if (compare_mid(mid->mid, buf) &&
-		    mid->mid_state == MID_REQUEST_SUBMITTED &&
-		    le16_to_cpu(mid->command) == buf->Command) {
-			smb_get_mid(mid);
+	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
+		if (compare_mid(smb->mid, buf) &&
+		    smb->mid_state == MID_REQUEST_SUBMITTED &&
+		    le16_to_cpu(smb->command) == buf->Command) {
+			smb_get_mid(smb);
 			spin_unlock(&server->mid_queue_lock);
-			return mid;
+			return smb;
 		}
 	}
 	spin_unlock(&server->mid_queue_lock);
@@ -290,7 +290,7 @@ cifs_get_credits_field(struct TCP_Server_Info *server, const int optype)
 }
 
 static unsigned int
-cifs_get_credits(struct mid_q_entry *mid)
+cifs_get_credits(struct smb_message *smb)
 {
 	return 1;
 }
@@ -343,7 +343,7 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 	 * did not time out).
 	 */
 	while (cur_mid != last_mid) {
-		struct mid_q_entry *mid_entry;
+		struct smb_message *smb;
 		unsigned int num_mids;
 
 		collision = false;
@@ -352,10 +352,10 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 
 		num_mids = 0;
 		spin_lock(&server->mid_queue_lock);
-		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+		list_for_each_entry(smb, &server->pending_mid_q, qhead) {
 			++num_mids;
-			if (mid_entry->mid == cur_mid &&
-			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
+			if (smb->mid == cur_mid &&
+			    smb->mid_state == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
diff --git a/fs/smb/client/smb1proto.h b/fs/smb/client/smb1proto.h
index 5f522d359952..4ecf50b0922c 100644
--- a/fs/smb/client/smb1proto.h
+++ b/fs/smb/client/smb1proto.h
@@ -236,7 +236,7 @@ int cifs_verify_signature(struct smb_rqst *rqst,
 int map_smb_to_linux_error(char *buf, bool logErr);
 int smb1_init_maperror(void);
 int map_and_check_smb_error(struct TCP_Server_Info *server,
-			    struct mid_q_entry *mid, bool logErr);
+			    struct smb_message *smb, bool logErr);
 #if IS_ENABLED(CONFIG_SMB1_KUNIT_TESTS)
 extern const struct ntstatus_to_dos_err *ntstatus_to_dos_map_test;
 extern unsigned int ntstatus_to_dos_num;
@@ -280,13 +280,13 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 /*
  * smb1transport.c
  */
-struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *server,
+struct smb_message *cifs_setup_async_request(struct TCP_Server_Info *server,
 					     struct smb_rqst *rqst);
 int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 		     char *in_buf, unsigned int in_len, int flags);
-int cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+int cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		       bool log_error);
-struct mid_q_entry *cifs_setup_request(struct cifs_ses *ses,
+struct smb_message *cifs_setup_request(struct cifs_ses *ses,
 				       struct TCP_Server_Info *server,
 				       struct smb_rqst *rqst);
 int SendReceive2(const unsigned int xid, struct cifs_ses *ses,
@@ -296,7 +296,7 @@ int SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		struct smb_hdr *in_buf, unsigned int in_len,
 		struct smb_hdr *out_buf, int *pbytes_returned,
 		const int flags);
-bool cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+bool cifs_check_trans2(struct smb_message *smb, struct TCP_Server_Info *server,
 		       char *buf, int malformed);
 int checkSMB(char *buf, unsigned int pdu_len, unsigned int total_read,
 	     struct TCP_Server_Info *server);
diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 53abb29fe71b..c2d211a62577 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -33,44 +33,44 @@
 /* Max number of iovectors we can use off the stack when sending requests. */
 #define CIFS_MAX_IOV_SIZE 8
 
-static struct mid_q_entry *
+static struct smb_message *
 alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 {
-	struct mid_q_entry *temp;
+	struct smb_message *smb;
 
 	if (server == NULL) {
 		cifs_dbg(VFS, "%s: null TCP session\n", __func__);
 		return NULL;
 	}
 
-	temp = mempool_alloc(&cifs_mid_pool, GFP_NOFS);
-	memset(temp, 0, sizeof(struct mid_q_entry));
-	refcount_set(&temp->refcount, 1);
-	spin_lock_init(&temp->mid_lock);
-	temp->mid = get_mid(smb_buffer);
-	temp->pid = current->pid;
-	temp->command = cpu_to_le16(smb_buffer->Command);
+	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
+	memset(smb, 0, sizeof(struct smb_message));
+	refcount_set(&smb->refcount, 1);
+	spin_lock_init(&smb->mid_lock);
+	smb->mid = get_mid(smb_buffer);
+	smb->pid = current->pid;
+	smb->command = cpu_to_le16(smb_buffer->Command);
 	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
 	/* easier to use jiffies */
 	/* when mid allocated can be before when sent */
-	temp->when_alloc = jiffies;
+	smb->when_alloc = jiffies;
 
 	/*
 	 * The default is for the mid to be synchronous, so the
 	 * default callback just wakes up the current task.
 	 */
 	get_task_struct(current);
-	temp->creator = current;
-	temp->callback = cifs_wake_up_task;
-	temp->callback_data = current;
+	smb->creator = current;
+	smb->callback = cifs_wake_up_task;
+	smb->callback_data = current;
 
 	atomic_inc(&mid_count);
-	temp->mid_state = MID_REQUEST_ALLOCATED;
-	return temp;
+	smb->mid_state = MID_REQUEST_ALLOCATED;
+	return smb;
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
-			struct mid_q_entry **ppmidQ)
+			struct smb_message **ppmidQ)
 {
 	spin_lock(&ses->ses_lock);
 	if (ses->ses_status == SES_NEW) {
@@ -101,28 +101,28 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 	return 0;
 }
 
-struct mid_q_entry *
+struct smb_message *
 cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 
 	/* enable signing if server requires it */
 	if (server->sign)
 		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
-	mid = alloc_mid(hdr, server);
-	if (mid == NULL)
+	smb = alloc_mid(hdr, server);
+	if (smb == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
+	rc = cifs_sign_rqst(rqst, server, &smb->sequence_number);
 	if (rc) {
-		release_mid(server, mid);
+		release_mid(server, smb);
 		return ERR_PTR(rc);
 	}
 
-	return mid;
+	return smb;
 }
 
 /*
@@ -153,12 +153,12 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 }
 
 int
-cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+cifs_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = mid->response_pdu_len;
+	unsigned int len = smb->response_pdu_len;
 
-	dump_smb(mid->resp_buf, min_t(u32, 92, len));
+	dump_smb(smb->resp_buf, min_t(u32, 92, len));
 
 	/* convert the length into a more usable form */
 	if (server->sign) {
@@ -167,11 +167,11 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		struct smb_rqst rqst = { .rq_iov = iov,
 					 .rq_nvec = ARRAY_SIZE(iov) };
 
-		iov[0].iov_base = mid->resp_buf;
+		iov[0].iov_base = smb->resp_buf;
 		iov[0].iov_len = len;
 
 		rc = cifs_verify_signature(&rqst, server,
-					   mid->sequence_number);
+					   smb->sequence_number);
 		if (rc) {
 			cifs_server_dbg(VFS, "SMB signature verification returned error = %d\n",
 				 rc);
@@ -184,26 +184,26 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	}
 
 	/* BB special case reconnect tid and uid here? */
-	return map_and_check_smb_error(server, mid, log_error);
+	return map_and_check_smb_error(server, smb, log_error);
 }
 
-struct mid_q_entry *
+struct smb_message *
 cifs_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb_hdr *hdr = (struct smb_hdr *)rqst->rq_iov[0].iov_base;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 
-	rc = allocate_mid(ses, hdr, &mid);
+	rc = allocate_mid(ses, hdr, &smb);
 	if (rc)
 		return ERR_PTR(rc);
-	rc = cifs_sign_rqst(rqst, server, &mid->sequence_number);
+	rc = cifs_sign_rqst(rqst, server, &smb->sequence_number);
 	if (rc) {
-		delete_mid(server, mid);
+		delete_mid(server, smb);
 		return ERR_PTR(rc);
 	}
-	return mid;
+	return smb;
 }
 
 int
@@ -411,22 +411,22 @@ coalesce_t2(char *second_buf, struct smb_hdr *target_hdr, unsigned int *pdu_len)
 }
 
 bool
-cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+cifs_check_trans2(struct smb_message *smb, struct TCP_Server_Info *server,
 		  char *buf, int malformed)
 {
 	if (malformed)
 		return false;
 	if (check2ndT2(buf) <= 0)
 		return false;
-	mid->multiRsp = true;
-	if (mid->resp_buf) {
+	smb->multiRsp = true;
+	if (smb->resp_buf) {
 		/* merge response - fix up 1st*/
-		malformed = coalesce_t2(buf, mid->resp_buf, &mid->response_pdu_len);
+		malformed = coalesce_t2(buf, smb->resp_buf, &smb->response_pdu_len);
 		if (malformed > 0)
 			return true;
 		/* All parts received or packet is malformed. */
-		mid->multiEnd = true;
-		dequeue_mid(server, mid, malformed);
+		smb->multiEnd = true;
+		dequeue_mid(server, smb, malformed);
 		return true;
 	}
 	if (!server->large_buf) {
@@ -434,8 +434,8 @@ cifs_check_trans2(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		cifs_dbg(VFS, "1st trans2 resp needs bigbuf\n");
 	} else {
 		/* Have first buffer */
-		mid->resp_buf = buf;
-		mid->large_buf = true;
+		smb->resp_buf = buf;
+		smb->large_buf = true;
 		server->bigbuf = NULL;
 	}
 	return true;
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 6194d677b0ba..5c1d41baff7e 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -843,14 +843,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 }
 
 int
-smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server)
+smb2_handle_cancelled_mid(struct smb_message *smb, struct TCP_Server_Info *server)
 {
-	struct smb2_hdr *hdr = mid->resp_buf;
-	struct smb2_create_rsp *rsp = mid->resp_buf;
+	struct smb2_hdr *hdr = smb->resp_buf;
+	struct smb2_create_rsp *rsp = smb->resp_buf;
 	struct cifs_tcon *tcon;
 	int rc;
 
-	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || hdr->Command != SMB2_CREATE ||
+	if ((smb->optype & CIFS_CP_CREATE_CLOSE_OP) || hdr->Command != SMB2_CREATE ||
 	    hdr->Status != STATUS_SUCCESS)
 		return 0;
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b0b344724d2e..236eb560bdff 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -236,9 +236,9 @@ smb2_get_credits_field(struct TCP_Server_Info *server, const int optype)
 }
 
 static unsigned int
-smb2_get_credits(struct mid_q_entry *mid)
+smb2_get_credits(struct smb_message *smb)
 {
-	return mid->credits_received;
+	return smb->credits_received;
 }
 
 static int
@@ -399,10 +399,10 @@ smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 	spin_unlock(&server->mid_counter_lock);
 }
 
-static struct mid_q_entry *
+static struct smb_message *
 __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 {
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
@@ -412,30 +412,30 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 	}
 
 	spin_lock(&server->mid_queue_lock);
-	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
-		if ((mid->mid == wire_mid) &&
-		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
-		    (mid->command == shdr->Command)) {
-			smb_get_mid(mid);
+	list_for_each_entry(smb, &server->pending_mid_q, qhead) {
+		if ((smb->mid == wire_mid) &&
+		    (smb->mid_state == MID_REQUEST_SUBMITTED) &&
+		    (smb->command == shdr->Command)) {
+			smb_get_mid(smb);
 			if (dequeue) {
-				list_del_init(&mid->qhead);
-				mid->deleted_from_q = true;
+				list_del_init(&smb->qhead);
+				smb->deleted_from_q = true;
 			}
 			spin_unlock(&server->mid_queue_lock);
-			return mid;
+			return smb;
 		}
 	}
 	spin_unlock(&server->mid_queue_lock);
 	return NULL;
 }
 
-static struct mid_q_entry *
+static struct smb_message *
 smb2_find_mid(struct TCP_Server_Info *server, char *buf)
 {
 	return __smb2_find_mid(server, buf, false);
 }
 
-static struct mid_q_entry *
+static struct smb_message *
 smb2_find_dequeue_mid(struct TCP_Server_Info *server, char *buf)
 {
 	return __smb2_find_mid(server, buf, true);
@@ -4721,7 +4721,7 @@ cifs_copy_bvecq_to_iter(struct bvecq *bq, size_t data_size,
 }
 
 static int
-handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+handle_read_data(struct TCP_Server_Info *server, struct smb_message *smb,
 		 char *buf, unsigned int buf_len, struct bvecq *buffer,
 		 unsigned int buffer_len, bool is_offloaded)
 {
@@ -4731,7 +4731,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int cur_off;
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
-	struct cifs_io_subrequest *rdata = mid->callback_data;
+	struct cifs_io_subrequest *rdata = smb->callback_data;
 	struct iov_iter iter;
 	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	size_t copied;
@@ -4770,9 +4770,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			 __func__, rdata->result);
 		/* normal error on read response */
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_RECEIVED;
+			smb->mid_state = MID_RESPONSE_RECEIVED;
 		else
-			dequeue_mid(server, mid, false);
+			dequeue_mid(server, smb, false);
 		return 0;
 	}
 
@@ -4797,9 +4797,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			 __func__, data_offset);
 		rdata->result = smb_EIO1(smb_eio_trace_rx_overlong, data_offset);
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_MALFORMED;
+			smb->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(server, mid, rdata->result);
+			dequeue_mid(server, smb, rdata->result);
 		return 0;
 	}
 
@@ -4820,9 +4820,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 				 __func__, data_offset);
 			rdata->result = smb_EIO1(smb_eio_trace_rx_overpage, data_offset);
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				smb->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(server, mid, rdata->result);
+				dequeue_mid(server, smb, rdata->result);
 			return 0;
 		}
 
@@ -4830,9 +4830,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			/* data_len is corrupt -- discard frame */
 			rdata->result = smb_EIO1(smb_eio_trace_rx_bad_datalen, data_len);
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				smb->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(server, mid, rdata->result);
+				dequeue_mid(server, smb, rdata->result);
 			return 0;
 		}
 
@@ -4841,9 +4841,9 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 							cur_off, &iter);
 		if (rdata->result != 0) {
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				smb->mid_state = MID_RESPONSE_MALFORMED;
 			else
-				dequeue_mid(server, mid, rdata->result);
+				dequeue_mid(server, smb, rdata->result);
 			return 0;
 		}
 		rdata->got_bytes = buffer_len;
@@ -4861,16 +4861,16 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		WARN_ONCE(1, "buf can not contain only a part of read data");
 		rdata->result = smb_EIO(smb_eio_trace_rx_both_buf);
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_MALFORMED;
+			smb->mid_state = MID_RESPONSE_MALFORMED;
 		else
-			dequeue_mid(server, mid, rdata->result);
+			dequeue_mid(server, smb, rdata->result);
 		return 0;
 	}
 
 	if (is_offloaded)
-		mid->mid_state = MID_RESPONSE_RECEIVED;
+		smb->mid_state = MID_RESPONSE_RECEIVED;
 	else
-		dequeue_mid(server, mid, false);
+		dequeue_mid(server, smb, false);
 	return 0;
 }
 
@@ -4888,7 +4888,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 	struct smb2_decrypt_work *dw = container_of(work,
 				struct smb2_decrypt_work, decrypt);
 	int rc;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 	struct iov_iter iter;
 
 	iov_iter_bvec_queue(&iter, ITER_DEST, dw->buffer, 0, 0, dw->len);
@@ -4900,43 +4900,43 @@ static void smb2_decrypt_offload(struct work_struct *work)
 	}
 
 	dw->server->lstrp = jiffies;
-	mid = smb2_find_dequeue_mid(dw->server, dw->buf);
-	if (mid == NULL)
+	smb = smb2_find_dequeue_mid(dw->server, dw->buf);
+	if (smb == NULL)
 		cifs_dbg(FYI, "mid not found\n");
 	else {
-		mid->decrypted = true;
-		rc = handle_read_data(dw->server, mid, dw->buf,
+		smb->decrypted = true;
+		rc = handle_read_data(dw->server, smb, dw->buf,
 				      dw->server->vals->read_rsp_size,
 				      dw->buffer, dw->len,
 				      true);
 		if (rc >= 0) {
 #ifdef CONFIG_CIFS_STATS2
-			mid->when_received = jiffies;
+			smb->when_received = jiffies;
 #endif
 			if (dw->server->ops->is_network_name_deleted)
 				dw->server->ops->is_network_name_deleted(dw->buf,
 									 dw->server);
 
-			mid_execute_callback(dw->server, mid);
+			mid_execute_callback(dw->server, smb);
 		} else {
 			spin_lock(&dw->server->srv_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
 				spin_lock(&dw->server->mid_queue_lock);
-				mid->mid_state = MID_RETRY_NEEDED;
+				smb->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
-				mid_execute_callback(dw->server, mid);
+				mid_execute_callback(dw->server, smb);
 			} else {
 				spin_lock(&dw->server->mid_queue_lock);
-				mid->mid_state = MID_REQUEST_SUBMITTED;
-				mid->deleted_from_q = false;
-				list_add_tail(&mid->qhead,
+				smb->mid_state = MID_REQUEST_SUBMITTED;
+				smb->deleted_from_q = false;
+				list_add_tail(&smb->qhead,
 					&dw->server->pending_mid_q);
 				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
 			}
 		}
-		release_mid(dw->server, mid);
+		release_mid(dw->server, smb);
 	}
 
 free_pages:
@@ -4947,7 +4947,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 
 
 static int
-receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
+receive_encrypted_read(struct TCP_Server_Info *server, struct smb_message **smb,
 		       int *num_mids)
 {
 	char *buf = server->smallbuf;
@@ -5031,13 +5031,13 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	if (rc)
 		goto free_pages;
 
-	*mid = smb2_find_mid(server, buf);
-	if (*mid == NULL) {
+	*smb = smb2_find_mid(server, buf);
+	if (*smb == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
 	} else {
 		cifs_dbg(FYI, "mid found\n");
-		(*mid)->decrypted = true;
-		rc = handle_read_data(server, *mid, buf,
+		(*smb)->decrypted = true;
+		rc = handle_read_data(server, *smb, buf,
 				      server->vals->read_rsp_size,
 				      dw->buffer, dw->len, false);
 		if (rc >= 0) {
@@ -5060,7 +5060,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 
 static int
 receive_encrypted_standard(struct TCP_Server_Info *server,
-			   struct mid_q_entry **mids, char **bufs,
+			   struct smb_message **mids, char **bufs,
 			   int *num_mids)
 {
 	int ret, length;
@@ -5069,7 +5069,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
 	unsigned int next_cmd;
-	struct mid_q_entry *mid_entry;
+	struct smb_message *smb;
 	int next_is_large;
 	char *next_buffer = NULL;
 
@@ -5112,13 +5112,13 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd);
 	}
 
-	mid_entry = smb2_find_mid(server, buf);
-	if (mid_entry == NULL)
+	smb = smb2_find_mid(server, buf);
+	if (smb == NULL)
 		cifs_dbg(FYI, "mid not found\n");
 	else {
 		cifs_dbg(FYI, "mid found\n");
-		mid_entry->decrypted = true;
-		mid_entry->resp_buf_size = server->pdu_size;
+		smb->decrypted = true;
+		smb->resp_buf_size = server->pdu_size;
 	}
 
 	if (*num_mids >= MAX_COMPOUND) {
@@ -5126,12 +5126,12 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 		return -1;
 	}
 	bufs[*num_mids] = buf;
-	mids[(*num_mids)++] = mid_entry;
+	mids[(*num_mids)++] = smb;
 
-	if (mid_entry && mid_entry->handle)
-		ret = mid_entry->handle(server, mid_entry);
+	if (smb && smb->handle)
+		ret = smb->handle(server, smb);
 	else
-		ret = cifs_handle_standard(server, mid_entry);
+		ret = cifs_handle_standard(server, smb);
 
 	if (ret == 0 && next_cmd) {
 		pdu_length -= next_cmd;
@@ -5159,7 +5159,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 
 static int
 smb3_receive_transform(struct TCP_Server_Info *server,
-		       struct mid_q_entry **mids, char **bufs, int *num_mids)
+		       struct smb_message **mids, char **bufs, int *num_mids)
 {
 	char *buf = server->smallbuf;
 	unsigned int pdu_length = server->pdu_size;
@@ -5189,11 +5189,11 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 }
 
 int
-smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+smb3_handle_read_data(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
 
-	return handle_read_data(server, mid, buf, server->pdu_size,
+	return handle_read_data(server, smb, buf, server->pdu_size,
 				NULL, 0, false);
 }
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2d9fe803682e..d4d2da2846e9 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4172,18 +4172,18 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
  * FIXME: maybe we should consider checking that the reply matches request?
  */
 static void
-smb2_echo_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+smb2_echo_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
+	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)smb->resp_buf;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 
-	if (mid->mid_state == MID_RESPONSE_RECEIVED
-	    || mid->mid_state == MID_RESPONSE_MALFORMED) {
+	if (smb->mid_state == MID_RESPONSE_RECEIVED
+	    || smb->mid_state == MID_RESPONSE_MALFORMED) {
 		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 	}
 
-	release_mid(server, mid);
+	release_mid(server, smb);
 	add_credits(server, &credits, CIFS_ECHO_OP);
 }
 
@@ -4606,9 +4606,9 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 }
 
 static void
-smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+smb2_readv_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *rdata = mid->callback_data;
+	struct cifs_io_subrequest *rdata = smb->callback_data;
 	struct netfs_inode *ictx = netfs_inode(rdata->rreq->inode);
 	struct cifs_tcon *tcon = tlink_tcon(rdata->req->cfile->tlink);
 	struct smb2_hdr *shdr = (struct smb2_hdr *)rdata->iov[0].iov_base;
@@ -4633,15 +4633,15 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		  rdata->server, server);
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu/%zu\n",
-		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 __func__, smb->mid, smb->mid_state, rdata->result,
 		 rdata->got_bytes, rdata->subreq.len - rdata->subreq.transferred);
 
-	switch (mid->mid_state) {
+	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
 		/* result already set, check signature */
-		if (server->sign && !mid->decrypted) {
+		if (server->sign && !smb->decrypted) {
 			int rc;
 
 			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);
@@ -4688,7 +4688,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	default:
 		trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_unknown);
 		rdata->result = smb_EIO1(smb_eio_trace_read_mid_state_unknown,
-					 mid->mid_state);
+					 smb->mid_state);
 		break;
 	}
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -4750,7 +4750,7 @@ smb2_readv_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	rdata->subreq.transferred += rdata->got_bytes;
 	trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_progress);
 	netfs_read_subreq_terminated(&rdata->subreq);
-	release_mid(server, mid);
+	release_mid(server, smb);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_read_response_add);
@@ -4946,11 +4946,11 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
  * workqueue completion task.
  */
 static void
-smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+smb2_writev_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *wdata = mid->callback_data;
+	struct cifs_io_subrequest *wdata = smb->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->req->cfile->tlink);
-	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)mid->resp_buf;
+	struct smb2_write_rsp *rsp = (struct smb2_write_rsp *)smb->resp_buf;
 	struct cifs_credits credits = {
 		.value = 0,
 		.instance = 0,
@@ -4966,11 +4966,11 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		  "wdata server %p != mid server %p",
 		  wdata->server, server);
 
-	switch (mid->mid_state) {
+	switch (smb->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
-		result = smb2_check_receive(mid, server, 0);
+		result = smb2_check_receive(smb, server, 0);
 		if (result != 0) {
 			if (is_replayable_error(result)) {
 				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
@@ -5021,7 +5021,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	default:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_unknown);
 		result = smb_EIO1(smb_eio_trace_write_mid_state_unknown,
-				  mid->mid_state);
+				  smb->mid_state);
 		break;
 	}
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -5070,7 +5070,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		wdata->replay = true;
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
-	release_mid(server, mid);
+	release_mid(server, smb);
 	trace_smb3_rw_credits(rreq_debug_id, subreq_debug_index, 0,
 			      server->credits, server->in_flight,
 			      credits.value, cifs_trace_rw_credits_write_response_add);
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 1ceb95b907e6..5727e47733c8 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -38,19 +38,19 @@ __le16 *cifs_convert_path_to_utf16(const char *from,
 
 int smb2_verify_signature(struct smb_rqst *rqst,
 			  struct TCP_Server_Info *server);
-int smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+int smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		       bool log_error);
-struct mid_q_entry *smb2_setup_request(struct cifs_ses *ses,
+struct smb_message *smb2_setup_request(struct cifs_ses *ses,
 				       struct TCP_Server_Info *server,
 				       struct smb_rqst *rqst);
-struct mid_q_entry *smb2_setup_async_request(struct TCP_Server_Info *server,
+struct smb_message *smb2_setup_async_request(struct TCP_Server_Info *server,
 					     struct smb_rqst *rqst);
 struct cifs_tcon *smb2_find_smb_tcon(struct TCP_Server_Info *server,
 				     __u64 ses_id, __u32  tid);
 __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock);
 bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server);
 int smb3_handle_read_data(struct TCP_Server_Info *server,
-			  struct mid_q_entry *mid);
+			  struct smb_message *smb);
 struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 					struct super_block *sb,
 					const unsigned int xid,
@@ -222,7 +222,7 @@ int SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		      __u8 oplock_level);
 int smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 				__u64 volatile_fid);
-int smb2_handle_cancelled_mid(struct mid_q_entry *mid,
+int smb2_handle_cancelled_mid(struct smb_message *smb,
 			      struct TCP_Server_Info *server);
 void smb2_cancelled_close_fid(struct work_struct *work);
 int SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index e8eeff9e50d6..a28b66ead690 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -605,11 +605,11 @@ smb2_seq_num_into_buf(struct TCP_Server_Info *server,
 		get_next_mid(server);
 }
 
-static struct mid_q_entry *
+static struct smb_message *
 smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 		     struct TCP_Server_Info *server)
 {
-	struct mid_q_entry *temp;
+	struct smb_message *smb;
 	unsigned int credits = le16_to_cpu(shdr->CreditCharge);
 
 	if (server == NULL) {
@@ -617,36 +617,36 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 		return NULL;
 	}
 
-	temp = mempool_alloc(&cifs_mid_pool, GFP_NOFS);
-	memset(temp, 0, sizeof(struct mid_q_entry));
-	refcount_set(&temp->refcount, 1);
-	spin_lock_init(&temp->mid_lock);
-	temp->mid = le64_to_cpu(shdr->MessageId);
-	temp->credits = credits > 0 ? credits : 1;
-	temp->pid = current->pid;
-	temp->command = shdr->Command; /* Always LE */
-	temp->when_alloc = jiffies;
+	smb = mempool_alloc(&smb_message_pool, GFP_NOFS);
+	memset(smb, 0, sizeof(*smb));
+	refcount_set(&smb->refcount, 1);
+	spin_lock_init(&smb->mid_lock);
+	smb->mid = le64_to_cpu(shdr->MessageId);
+	smb->credits = credits > 0 ? credits : 1;
+	smb->pid = current->pid;
+	smb->command = shdr->Command; /* Always LE */
+	smb->when_alloc = jiffies;
 
 	/*
 	 * The default is for the mid to be synchronous, so the
 	 * default callback just wakes up the current task.
 	 */
 	get_task_struct(current);
-	temp->creator = current;
-	temp->callback = cifs_wake_up_task;
-	temp->callback_data = current;
+	smb->creator = current;
+	smb->callback = cifs_wake_up_task;
+	smb->callback_data = current;
 
 	atomic_inc(&mid_count);
-	temp->mid_state = MID_REQUEST_ALLOCATED;
+	smb->mid_state = MID_REQUEST_ALLOCATED;
 	trace_smb3_cmd_enter(le32_to_cpu(shdr->Id.SyncId.TreeId),
 			     le64_to_cpu(shdr->SessionId),
-			     le16_to_cpu(shdr->Command), temp->mid);
-	return temp;
+			     le16_to_cpu(shdr->Command), smb->mid);
+	return smb;
 }
 
 static int
 smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
+		   struct smb2_hdr *shdr, struct smb_message **smb)
 {
 	switch (READ_ONCE(server->tcpStatus)) {
 	case CifsExiting:
@@ -678,31 +678,31 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		break;
 	}
 
-	*mid = smb2_mid_entry_alloc(shdr, server);
-	if (*mid == NULL)
+	*smb = smb2_mid_entry_alloc(shdr, server);
+	if (*smb == NULL)
 		return -ENOMEM;
 	spin_lock(&server->mid_queue_lock);
-	list_add_tail(&(*mid)->qhead, &server->pending_mid_q);
+	list_add_tail(&(*smb)->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
 
 	return 0;
 }
 
 int
-smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
+smb2_check_receive(struct smb_message *smb, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	unsigned int len = mid->resp_buf_size;
+	unsigned int len = smb->resp_buf_size;
 	struct kvec iov[1];
 	struct smb_rqst rqst = { .rq_iov = iov,
 				 .rq_nvec = 1 };
 
-	iov[0].iov_base = (char *)mid->resp_buf;
+	iov[0].iov_base = (char *)smb->resp_buf;
 	iov[0].iov_len = len;
 
-	dump_smb(mid->resp_buf, min_t(u32, 80, len));
+	dump_smb(smb->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
-	if (len > 24 && server->sign && !mid->decrypted) {
+	if (len > 24 && server->sign && !smb->decrypted) {
 		int rc;
 
 		rc = smb2_verify_signature(&rqst, server);
@@ -711,21 +711,21 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 				 rc);
 	}
 
-	return map_smb2_to_linux_error(mid->resp_buf, log_error);
+	return map_smb2_to_linux_error(smb->resp_buf, log_error);
 }
 
-struct mid_q_entry *
+struct smb_message *
 smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 
 	smb2_seq_num_into_buf(server, shdr);
 
-	rc = smb2_get_mid_entry(ses, server, shdr, &mid);
+	rc = smb2_get_mid_entry(ses, server, shdr, &smb);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(rc);
@@ -734,20 +734,20 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		delete_mid(server, mid);
+		delete_mid(server, smb);
 		return ERR_PTR(rc);
 	}
 
-	return mid;
+	return smb;
 }
 
-struct mid_q_entry *
+struct smb_message *
 smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
 	struct smb2_hdr *shdr =
 			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedNegotiate &&
@@ -759,8 +759,8 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 
 	smb2_seq_num_into_buf(server, shdr);
 
-	mid = smb2_mid_entry_alloc(shdr, server);
-	if (mid == NULL) {
+	smb = smb2_mid_entry_alloc(shdr, server);
+	if (smb == NULL) {
 		revert_current_mid_from_hdr(server, shdr);
 		return ERR_PTR(-ENOMEM);
 	}
@@ -768,11 +768,11 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	rc = smb2_sign_rqst(rqst, server);
 	if (rc) {
 		revert_current_mid_from_hdr(server, shdr);
-		release_mid(server, mid);
+		release_mid(server, smb);
 		return ERR_PTR(rc);
 	}
 
-	return mid;
+	return smb;
 }
 
 int
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index be2f6b909c34..622f63779de0 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -31,39 +31,39 @@
 #include "compress.h"
 
 void
-cifs_wake_up_task(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_wake_up_task(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		mid->mid_state = MID_RESPONSE_READY;
-	wake_up_process(mid->callback_data);
+	if (smb->mid_state == MID_RESPONSE_RECEIVED)
+		smb->mid_state = MID_RESPONSE_READY;
+	wake_up_process(smb->callback_data);
 }
 
-void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
+void __release_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 #ifdef CONFIG_CIFS_STATS2
 	__le16 command = server->vals->lock_cmd;
-	__u16 smb_cmd = le16_to_cpu(midEntry->command);
+	__u16 smb_cmd = le16_to_cpu(smb->command);
 	unsigned long now;
 	unsigned long roundtrip_time;
 #endif
 
-	if (midEntry->resp_buf && (midEntry->wait_cancelled) &&
-	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
-	     midEntry->mid_state == MID_RESPONSE_READY) &&
+	if (smb->resp_buf && smb->wait_cancelled &&
+	    (smb->mid_state == MID_RESPONSE_RECEIVED ||
+	     smb->mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
-		server->ops->handle_cancelled_mid(midEntry, server);
+		server->ops->handle_cancelled_mid(smb, server);
 
-	midEntry->mid_state = MID_FREE;
+	smb->mid_state = MID_FREE;
 	atomic_dec(&mid_count);
-	if (midEntry->large_buf)
-		cifs_buf_release(midEntry->resp_buf);
+	if (smb->large_buf)
+		cifs_buf_release(smb->resp_buf);
 	else
-		cifs_small_buf_release(midEntry->resp_buf);
+		cifs_small_buf_release(smb->resp_buf);
 #ifdef CONFIG_CIFS_STATS2
 	now = jiffies;
-	if (now < midEntry->when_alloc)
+	if (now < smb->when_alloc)
 		cifs_server_dbg(VFS, "Invalid mid allocation time\n");
-	roundtrip_time = now - midEntry->when_alloc;
+	roundtrip_time = now - smb->when_alloc;
 
 	if (smb_cmd < NUMBER_OF_SMB2_COMMANDS) {
 		if (atomic_read(&server->num_cmds[smb_cmd]) == 0) {
@@ -89,8 +89,8 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 	 * checks
 	 */
 	if ((slow_rsp_threshold != 0) &&
-	    time_after(now, midEntry->when_alloc + (slow_rsp_threshold * HZ)) &&
-	    (midEntry->command != command)) {
+	    time_after(now, smb->when_alloc + (slow_rsp_threshold * HZ)) &&
+	    (smb->command != command)) {
 		/*
 		 * smb2slowcmd[NUMBER_OF_SMB2_COMMANDS] counts by command
 		 * NB: le16_to_cpu returns unsigned so can not be negative below
@@ -98,35 +98,35 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 		if (smb_cmd < NUMBER_OF_SMB2_COMMANDS)
 			cifs_stats_inc(&server->smb2slowcmd[smb_cmd]);
 
-		trace_smb3_slow_rsp(smb_cmd, midEntry->mid, midEntry->pid,
-			       midEntry->when_sent, midEntry->when_received);
+		trace_smb3_slow_rsp(smb_cmd, smb->mid, smb->pid,
+				    smb->when_sent, smb->when_received);
 		if (cifsFYI & CIFS_TIMER) {
 			pr_debug("slow rsp: cmd %d mid %llu",
-				 midEntry->command, midEntry->mid);
+				 smb->command, smb->mid);
 			cifs_info("A: 0x%lx S: 0x%lx R: 0x%lx\n",
-				  now - midEntry->when_alloc,
-				  now - midEntry->when_sent,
-				  now - midEntry->when_received);
+				  now - smb->when_alloc,
+				  now - smb->when_sent,
+				  now - smb->when_received);
 		}
 	}
 #endif
-	put_task_struct(midEntry->creator);
+	put_task_struct(smb->creator);
 
-	mempool_free(midEntry, &cifs_mid_pool);
+	mempool_free(smb, &smb_message_pool);
 }
 
 void
-delete_mid(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+delete_mid(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	spin_lock(&server->mid_queue_lock);
 
-	if (!mid->deleted_from_q) {
-		list_del_init(&mid->qhead);
-		mid->deleted_from_q = true;
+	if (!smb->deleted_from_q) {
+		list_del_init(&smb->qhead);
+		smb->deleted_from_q = true;
 	}
 	spin_unlock(&server->mid_queue_lock);
 
-	release_mid(server, mid);
+	release_mid(server, smb);
 }
 
 /*
@@ -637,17 +637,17 @@ cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 	return 0;
 }
 
-int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+int wait_for_response(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	unsigned int sleep_state = TASK_KILLABLE;
 	int error;
 
-	if (mid->sr_flags & CIFS_INTERRUPTIBLE_WAIT)
+	if (smb->sr_flags & CIFS_INTERRUPTIBLE_WAIT)
 		sleep_state = TASK_INTERRUPTIBLE;
 
 	error = wait_event_state(server->response_q,
-				 mid->mid_state != MID_REQUEST_SUBMITTED &&
-				 mid->mid_state != MID_RESPONSE_RECEIVED,
+				 smb->mid_state != MID_REQUEST_SUBMITTED &&
+				 smb->mid_state != MID_RESPONSE_RECEIVED,
 				 (sleep_state | TASK_FREEZABLE_UNSAFE));
 	if (error < 0)
 		return -ERESTARTSYS;
@@ -666,7 +666,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		const struct cifs_credits *exist_credits)
 {
 	int rc;
-	struct mid_q_entry *mid;
+	struct smb_message *smb;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	unsigned int instance;
 	int optype;
@@ -695,36 +695,36 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		return -EAGAIN;
 	}
 
-	mid = server->ops->setup_async_request(server, rqst);
-	if (IS_ERR(mid)) {
+	smb = server->ops->setup_async_request(server, rqst);
+	if (IS_ERR(smb)) {
 		cifs_server_unlock(server);
 		add_credits_and_wake_if(server, &credits, optype);
-		return PTR_ERR(mid);
+		return PTR_ERR(smb);
 	}
 
-	mid->sr_flags = flags;
-	mid->receive = receive;
-	mid->callback = callback;
-	mid->callback_data = cbdata;
-	mid->handle = handle;
-	mid->mid_state = MID_REQUEST_SUBMITTED;
+	smb->sr_flags = flags;
+	smb->receive = receive;
+	smb->callback = callback;
+	smb->callback_data = cbdata;
+	smb->handle = handle;
+	smb->mid_state = MID_REQUEST_SUBMITTED;
 
 	/* put it on the pending_mid_q */
 	spin_lock(&server->mid_queue_lock);
-	list_add_tail(&mid->qhead, &server->pending_mid_q);
+	list_add_tail(&smb->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
 
 	/*
 	 * Need to store the time in mid before calling I/O. For call_async,
 	 * I/O response may come back and free the mid entry on another thread.
 	 */
-	cifs_save_when_sent(mid);
+	cifs_save_when_sent(smb);
 	rc = smb_send_rqst(server, 1, rqst, flags);
 
 	if (rc < 0) {
-		revert_current_mid(server, mid->credits);
+		revert_current_mid(server, smb->credits);
 		server->sequence_number -= 2;
-		delete_mid(server, mid);
+		delete_mid(server, smb);
 	}
 
 	cifs_server_unlock(server);
@@ -736,15 +736,15 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 	return rc;
 }
 
-int cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
+int cifs_sync_mid_result(struct smb_message *smb, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
 	cifs_dbg(FYI, "%s: cmd=%d mid=%llu state=%d\n",
-		 __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_state);
+		 __func__, le16_to_cpu(smb->command), smb->mid, smb->mid_state);
 
 	spin_lock(&server->mid_queue_lock);
-	switch (mid->mid_state) {
+	switch (smb->mid_state) {
 	case MID_RESPONSE_READY:
 		spin_unlock(&server->mid_queue_lock);
 		return rc;
@@ -758,52 +758,52 @@ int cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server
 		rc = -EHOSTDOWN;
 		break;
 	case MID_RC:
-		rc = mid->mid_rc;
+		rc = smb->mid_rc;
 		break;
 	default:
-		if (mid->deleted_from_q == false) {
-			list_del_init(&mid->qhead);
-			mid->deleted_from_q = true;
+		if (smb->deleted_from_q == false) {
+			list_del_init(&smb->qhead);
+			smb->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
-			 __func__, mid->mid, mid->mid_state);
-		rc = smb_EIO1(smb_eio_trace_rx_sync_mid_invalid, mid->mid_state);
+			 __func__, smb->mid, smb->mid_state);
+		rc = smb_EIO1(smb_eio_trace_rx_sync_mid_invalid, smb->mid_state);
 		goto sync_mid_done;
 	}
 	spin_unlock(&server->mid_queue_lock);
 
 sync_mid_done:
-	release_mid(server, mid);
+	release_mid(server, smb);
 	return rc;
 }
 
 static void
-cifs_compound_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_compound_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	struct cifs_credits credits = {
-		.value = server->ops->get_credits(mid),
+		.value = server->ops->get_credits(smb),
 		.instance = server->reconnect_instance,
 	};
 
-	add_credits(server, &credits, mid->optype);
+	add_credits(server, &credits, smb->optype);
 
-	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		mid->mid_state = MID_RESPONSE_READY;
+	if (smb->mid_state == MID_RESPONSE_RECEIVED)
+		smb->mid_state = MID_RESPONSE_READY;
 }
 
 static void
-cifs_compound_last_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_compound_last_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	cifs_compound_callback(server, mid);
-	cifs_wake_up_task(server, mid);
+	cifs_compound_callback(server, smb);
+	cifs_wake_up_task(server, smb);
 }
 
 static void
-cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_cancelled_callback(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	cifs_compound_callback(server, mid);
-	release_mid(server, mid);
+	cifs_compound_callback(server, smb);
+	release_mid(server, smb);
 }
 
 /*
@@ -866,8 +866,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
-	struct mid_q_entry *mid[MAX_COMPOUND];
-	bool cancelled_mid[MAX_COMPOUND] = {false};
+	struct smb_message *smb[MAX_COMPOUND];
+	bool cancelled_smb[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
 		{ .value = 0, .instance = 0 }
 	};
@@ -932,36 +932,36 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	for (i = 0; i < num_rqst; i++) {
-		mid[i] = server->ops->setup_request(ses, server, &rqst[i]);
-		if (IS_ERR(mid[i])) {
+		smb[i] = server->ops->setup_request(ses, server, &rqst[i]);
+		if (IS_ERR(smb[i])) {
 			revert_current_mid(server, i);
 			for (j = 0; j < i; j++)
-				delete_mid(server, mid[j]);
+				delete_mid(server, smb[j]);
 			cifs_server_unlock(server);
 
 			/* Update # of requests on wire to server */
 			for (j = 0; j < num_rqst; j++)
 				add_credits(server, &credits[j], optype);
-			return PTR_ERR(mid[i]);
+			return PTR_ERR(smb[i]);
 		}
 
-		mid[i]->sr_flags = flags;
-		mid[i]->mid_state = MID_REQUEST_SUBMITTED;
-		mid[i]->optype = optype;
+		smb[i]->sr_flags = flags;
+		smb[i]->mid_state = MID_REQUEST_SUBMITTED;
+		smb[i]->optype = optype;
 		/*
 		 * Invoke callback for every part of the compound chain
 		 * to calculate credits properly. Wake up this thread only when
 		 * the last element is received.
 		 */
 		if (i < num_rqst - 1)
-			mid[i]->callback = cifs_compound_callback;
+			smb[i]->callback = cifs_compound_callback;
 		else
-			mid[i]->callback = cifs_compound_last_callback;
+			smb[i]->callback = cifs_compound_last_callback;
 	}
 	rc = smb_send_rqst(server, num_rqst, rqst, flags);
 
 	for (i = 0; i < num_rqst; i++)
-		cifs_save_when_sent(mid[i]);
+		cifs_save_when_sent(smb[i]);
 
 	if (rc < 0) {
 		revert_current_mid(server, num_rqst);
@@ -1007,24 +1007,24 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&ses->ses_lock);
 
 	for (i = 0; i < num_rqst; i++) {
-		rc = wait_for_response(server, mid[i]);
+		rc = wait_for_response(server, smb[i]);
 		if (rc != 0)
 			break;
 	}
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
-				 mid[i]->mid, le16_to_cpu(mid[i]->command));
-			send_cancel(ses, server, &rqst[i], mid[i], xid);
-			spin_lock(&mid[i]->mid_lock);
-			mid[i]->wait_cancelled = true;
-			if (mid[i]->mid_state == MID_REQUEST_SUBMITTED ||
-			    mid[i]->mid_state == MID_RESPONSE_RECEIVED) {
-				mid[i]->callback = cifs_cancelled_callback;
-				cancelled_mid[i] = true;
+				 smb[i]->mid, le16_to_cpu(smb[i]->command));
+			send_cancel(ses, server, &rqst[i], smb[i], xid);
+			spin_lock(&smb[i]->mid_lock);
+			smb[i]->wait_cancelled = true;
+			if (smb[i]->mid_state == MID_REQUEST_SUBMITTED ||
+			    smb[i]->mid_state == MID_RESPONSE_RECEIVED) {
+				smb[i]->callback = cifs_cancelled_callback;
+				cancelled_smb[i] = true;
 				credits[i].value = 0;
 			}
-			spin_unlock(&mid[i]->mid_lock);
+			spin_unlock(&smb[i]->mid_lock);
 		}
 	}
 
@@ -1032,36 +1032,36 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		if (rc < 0)
 			goto out;
 
-		rc = cifs_sync_mid_result(mid[i], server);
+		rc = cifs_sync_mid_result(smb[i], server);
 		if (rc != 0) {
 			/* mark this mid as cancelled to not free it below */
-			cancelled_mid[i] = true;
+			cancelled_smb[i] = true;
 			goto out;
 		}
 
-		if (!mid[i]->resp_buf ||
-		    mid[i]->mid_state != MID_RESPONSE_READY) {
-			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, mid[i]->mid_state);
+		if (!smb[i]->resp_buf ||
+		    smb[i]->mid_state != MID_RESPONSE_READY) {
+			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, smb[i]->mid_state);
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
 		}
 
-		rc = server->ops->check_receive(mid[i], server,
+		rc = server->ops->check_receive(smb[i], server,
 						flags & CIFS_LOG_ERROR);
 
 		if (resp_iov) {
-			buf = (char *)mid[i]->resp_buf;
+			buf = (char *)smb[i]->resp_buf;
 			resp_iov[i].iov_base = buf;
-			resp_iov[i].iov_len = mid[i]->resp_buf_size;
+			resp_iov[i].iov_len = smb[i]->resp_buf_size;
 
-			if (mid[i]->large_buf)
+			if (smb[i]->large_buf)
 				resp_buf_type[i] = CIFS_LARGE_BUFFER;
 			else
 				resp_buf_type[i] = CIFS_SMALL_BUFFER;
 
 			/* mark it so buf will not be freed by delete_mid */
 			if ((flags & CIFS_NO_RSP_BUF) == 0)
-				mid[i]->resp_buf = NULL;
+				smb[i]->resp_buf = NULL;
 		}
 	}
 
@@ -1090,8 +1090,8 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * wake this thread except for the very last PDU.
 	 */
 	for (i = 0; i < num_rqst; i++) {
-		if (!cancelled_mid[i])
-			delete_mid(server, mid[i]);
+		if (!cancelled_smb[i])
+			delete_mid(server, smb[i]);
 	}
 
 	return rc;
@@ -1134,38 +1134,38 @@ cifs_discard_remaining_data(struct TCP_Server_Info *server)
 }
 
 static int
-__cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+__cifs_readv_discard(struct TCP_Server_Info *server, struct smb_message *smb,
 		     bool malformed)
 {
 	int length;
 
 	length = cifs_discard_remaining_data(server);
-	dequeue_mid(server, mid, malformed);
-	mid->resp_buf = server->smallbuf;
+	dequeue_mid(server, smb, malformed);
+	smb->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
 }
 
 static int
-cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_readv_discard(struct TCP_Server_Info *server, struct smb_message *smb)
 {
-	struct cifs_io_subrequest *rdata = mid->callback_data;
+	struct cifs_io_subrequest *rdata = smb->callback_data;
 
-	return  __cifs_readv_discard(server, mid, rdata->result);
+	return  __cifs_readv_discard(server, smb, rdata->result);
 }
 
 int
-cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+cifs_readv_receive(struct TCP_Server_Info *server, struct smb_message *smb)
 {
 	int length, len;
 	unsigned int data_offset, data_len, end_off;
-	struct cifs_io_subrequest *rdata = mid->callback_data;
+	struct cifs_io_subrequest *rdata = smb->callback_data;
 	char *buf = server->smallbuf;
 	unsigned int buflen = server->pdu_size;
 	bool use_rdma_mr = false;
 
 	cifs_dbg(FYI, "%s: mid=%llu offset=%llu bytes=%zu\n",
-		 __func__, mid->mid, rdata->subreq.start, rdata->subreq.len);
+		 __func__, smb->mid, rdata->subreq.start, rdata->subreq.len);
 
 	/*
 	 * read the rest of READ_RSP header (sans Data array), or whatever we
@@ -1205,7 +1205,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dbg(FYI, "%s: server returned error %d\n",
 			 __func__, rdata->result);
 		/* normal error on read response */
-		return __cifs_readv_discard(server, mid, false);
+		return __cifs_readv_discard(server, smb, false);
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
@@ -1215,7 +1215,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			 server->vals->read_rsp_size);
 		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_short,
 					 server->total_read, server->vals->read_rsp_size);
-		return cifs_readv_discard(server, mid);
+		return cifs_readv_discard(server, smb);
 	}
 
 	data_offset = server->ops->read_data_offset(buf);
@@ -1234,7 +1234,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			 __func__, data_offset);
 		rdata->result = smb_EIO1(smb_eio_trace_read_overlarge,
 					 data_offset);
-		return cifs_readv_discard(server, mid);
+		return cifs_readv_discard(server, smb);
 	}
 
 	cifs_dbg(FYI, "%s: total_read=%u data_offset=%u\n",
@@ -1262,7 +1262,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			/* data_len is corrupt -- discard frame */
 			rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
 						 end_off, buflen);
-			return cifs_readv_discard(server, mid);
+			return cifs_readv_discard(server, smb);
 		}
 	}
 
@@ -1289,10 +1289,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* discard anything left over */
 	if (server->total_read < buflen)
-		return cifs_readv_discard(server, mid);
+		return cifs_readv_discard(server, smb);
 
-	dequeue_mid(server, mid, false);
-	mid->resp_buf = server->smallbuf;
+	dequeue_mid(server, smb, false);
+	smb->resp_buf = server->smallbuf;
 	server->smallbuf = NULL;
 	return length;
 }


Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6E7C433F5
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338BC60FA0
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Sep 2021 23:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345885AbhIBXi2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:38:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235909AbhIBXi1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 2 Sep 2021 19:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630625848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KoJHHepkuPQ6McRHF3OryQ8JDzgSA9AYcxt1s7H3lNA=;
        b=Ti33u3lVxlpCTVe1zJm+q42a8VJgcGenf9r/PlOl+ukyoMRo4wgz0dDccHvkqUfrqRuUF3
        4tdE+g/NEqyYknPJXF9gA+47d+aX9ZzBgF7kR1i7hEKf4k2Og67M4e6XYn9rRGqzxx3CHy
        fOhinkkib6eBXlN2PrphAcZTI2U5LxI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-rnbMqFXiOt6v59Cpgm0lig-1; Thu, 02 Sep 2021 19:37:27 -0400
X-MC-Unique: rnbMqFXiOt6v59Cpgm0lig-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E693824FA9;
        Thu,  2 Sep 2021 23:37:26 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B381119D9B;
        Thu,  2 Sep 2021 23:37:24 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/3] cifs: rename smb2_sync_hdr to smb2_hdr to harmonize naming with ksmbd
Date:   Fri,  3 Sep 2021 09:37:15 +1000
Message-Id: <20210902233716.1923306-3-lsahlber@redhat.com>
In-Reply-To: <20210902233716.1923306-1-lsahlber@redhat.com>
References: <20210902233716.1923306-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h      |  2 +-
 fs/cifs/connect.c       |  4 +-
 fs/cifs/misc.c          |  2 +-
 fs/cifs/smb2maperror.c  |  2 +-
 fs/cifs/smb2misc.c      | 34 ++++++++--------
 fs/cifs/smb2ops.c       | 56 +++++++++++++-------------
 fs/cifs/smb2pdu.c       | 88 ++++++++++++++++++++---------------------
 fs/cifs/smb2pdu.h       | 82 +++++++++++++++++++-------------------
 fs/cifs/smb2proto.h     |  2 +-
 fs/cifs/smb2transport.c | 26 ++++++------
 10 files changed, 149 insertions(+), 149 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 28409c60b6fe..1c83edf71cee 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -778,7 +778,7 @@ revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 
 static inline void
 revert_current_mid_from_hdr(struct TCP_Server_Info *server,
-			    const struct smb2_sync_hdr *shdr)
+			    const struct smb2_hdr *shdr)
 {
 	unsigned int num = le16_to_cpu(shdr->CreditCharge);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0db344807ef1..63c36527e497 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -678,7 +678,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 static unsigned int
 smb2_get_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buffer;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
 
 	/*
 	 * SMB1 does not use credits.
@@ -879,7 +879,7 @@ cifs_handle_standard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 static void
 smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buffer;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buffer;
 	int scredits, in_flight;
 
 	/*
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 9469f1cf0b46..f340f1c5ed6e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -153,7 +153,7 @@ cifs_buf_get(void)
 	 * SMB2 header is bigger than CIFS one - no problems to clean some
 	 * more bytes for CIFS.
 	 */
-	size_t buf_size = sizeof(struct smb2_sync_hdr);
+	size_t buf_size = sizeof(struct smb2_hdr);
 
 	/*
 	 * We could use negotiated size instead of max_msgsize -
diff --git a/fs/cifs/smb2maperror.c b/fs/cifs/smb2maperror.c
index 181514b8770d..2046966e2ac5 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2439,7 +2439,7 @@ smb2_print_status(__le32 status)
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	unsigned int i;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 668f77108831..f3c6d2b27627 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -20,7 +20,7 @@
 #include "nterr.h"
 
 static int
-check_smb2_hdr(struct smb2_sync_hdr *shdr, __u64 mid)
+check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
 {
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
@@ -82,9 +82,9 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
-#define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_sync_hdr) + sizeof(struct smb2_negotiate_rsp))
+#define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
-static __u32 get_neg_ctxt_len(struct smb2_sync_hdr *hdr, __u32 len,
+static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 			      __u32 non_ctxlen)
 {
 	__u16 neg_count;
@@ -136,13 +136,13 @@ static __u32 get_neg_ctxt_len(struct smb2_sync_hdr *hdr, __u32 len,
 int
 smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct smb2_sync_pdu *pdu = (struct smb2_sync_pdu *)shdr;
 	__u64 mid;
 	__u32 clc_len;  /* calculated length */
 	int command;
 	int pdu_size = sizeof(struct smb2_sync_pdu);
-	int hdr_size = sizeof(struct smb2_sync_hdr);
+	int hdr_size = sizeof(struct smb2_hdr);
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -297,7 +297,7 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * area and the offset to it (from the beginning of the smb are also returned.
  */
 char *
-smb2_get_data_area_len(int *off, int *len, struct smb2_sync_hdr *shdr)
+smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 {
 	*off = 0;
 	*len = 0;
@@ -403,7 +403,7 @@ unsigned int
 smb2_calc_size(void *buf, struct TCP_Server_Info *srvr)
 {
 	struct smb2_sync_pdu *pdu = (struct smb2_sync_pdu *)buf;
-	struct smb2_sync_hdr *shdr = &pdu->sync_hdr;
+	struct smb2_hdr *shdr = &pdu->hdr;
 	int offset; /* the offset from the beginning of SMB to data area */
 	int data_length; /* the length of the variable length data area */
 	/* Structure Size has already been checked to make sure it is 64 */
@@ -670,7 +670,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "Checking for oplock break\n");
 
-	if (rsp->sync_hdr.Command != SMB2_OPLOCK_BREAK)
+	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
 
 	if (rsp->StructureSize !=
@@ -817,23 +817,23 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 int
 smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *sync_hdr = mid->resp_buf;
+	struct smb2_hdr *hdr = mid->resp_buf;
 	struct smb2_create_rsp *rsp = mid->resp_buf;
 	struct cifs_tcon *tcon;
 	int rc;
 
-	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || sync_hdr->Command != SMB2_CREATE ||
-	    sync_hdr->Status != STATUS_SUCCESS)
+	if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || hdr->Command != SMB2_CREATE ||
+	    hdr->Status != STATUS_SUCCESS)
 		return 0;
 
-	tcon = smb2_find_smb_tcon(server, sync_hdr->SessionId,
-				  sync_hdr->TreeId);
+	tcon = smb2_find_smb_tcon(server, hdr->SessionId,
+				  hdr->TreeId);
 	if (!tcon)
 		return -ENOENT;
 
 	rc = __smb2_handle_cancelled_cmd(tcon,
-					 le16_to_cpu(sync_hdr->Command),
-					 le64_to_cpu(sync_hdr->MessageId),
+					 le16_to_cpu(hdr->Command),
+					 le64_to_cpu(hdr->MessageId),
 					 rsp->PersistentFileId,
 					 rsp->VolatileFileId);
 	if (rc)
@@ -857,10 +857,10 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
 {
 	int i, rc;
 	struct sdesc *d;
-	struct smb2_sync_hdr *hdr;
+	struct smb2_hdr *hdr;
 	struct TCP_Server_Info *server = cifs_ses_server(ses);
 
-	hdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	hdr = (struct smb2_hdr *)iov[0].iov_base;
 	/* neg prot are always taken */
 	if (hdr->Command == SMB2_NEGOTIATE)
 		goto ok;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ddc0e8f97872..e1bd39d71034 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -325,7 +325,7 @@ static struct mid_q_entry *
 __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 {
 	struct mid_q_entry *mid;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
 	if (shdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM) {
@@ -367,7 +367,7 @@ static void
 smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
@@ -882,7 +882,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->persistent_fid = o_rsp->PersistentFileId;
 	oparms.fid->volatile_fid = o_rsp->VolatileFileId;
 #ifdef CONFIG_CIFS_DEBUG2
-	oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
+	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
 	tcon->crfid.tcon = tcon;
@@ -2385,7 +2385,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 	/* If the open failed there is nothing to do */
 	op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
-	if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
+	if (op_rsp == NULL || op_rsp->hdr.Status != STATUS_SUCCESS) {
 		cifs_dbg(FYI, "query_dir_first: open failed rc=%d\n", rc);
 		goto qdf_free;
 	}
@@ -2404,7 +2404,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 	atomic_inc(&tcon->num_remote_opens);
 
 	qd_rsp = (struct smb2_query_directory_rsp *)rsp_iov[1].iov_base;
-	if (qd_rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
+	if (qd_rsp->hdr.Status == STATUS_NO_MORE_FILES) {
 		trace_smb3_query_dir_done(xid, fid->persistent_fid,
 					  tcon->tid, tcon->ses->Suid, 0, 0);
 		srch_inf->endOfSearch = true;
@@ -2456,7 +2456,7 @@ smb2_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
 static bool
 smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	int scredits, in_flight;
 
 	if (shdr->Status != STATUS_PENDING)
@@ -2483,7 +2483,7 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 static bool
 smb2_is_session_expired(char *buf)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	if (shdr->Status != STATUS_NETWORK_SESSION_EXPIRED &&
 	    shdr->Status != STATUS_USER_SESSION_DELETED)
@@ -2500,7 +2500,7 @@ smb2_is_session_expired(char *buf)
 static bool
 smb2_is_status_io_timeout(char *buf)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	if (shdr->Status == STATUS_IO_TIMEOUT)
 		return true;
@@ -2511,7 +2511,7 @@ smb2_is_status_io_timeout(char *buf)
 static void
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct list_head *tmp, *tmp1;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -2552,9 +2552,9 @@ smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
 void
 smb2_set_related(struct smb_rqst *rqst)
 {
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 
-	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
 	if (shdr == NULL) {
 		cifs_dbg(FYI, "shdr NULL in smb2_set_related\n");
 		return;
@@ -2567,13 +2567,13 @@ char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
 void
 smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
 {
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct cifs_ses *ses = tcon->ses;
 	struct TCP_Server_Info *server = ses->server;
 	unsigned long len = smb_rqst_len(server, rqst);
 	int i, num_padding;
 
-	shdr = (struct smb2_sync_hdr *)(rqst->rq_iov[0].iov_base);
+	shdr = (struct smb2_hdr *)(rqst->rq_iov[0].iov_base);
 	if (shdr == NULL) {
 		cifs_dbg(FYI, "shdr NULL in smb2_set_next_command\n");
 		return;
@@ -3118,7 +3118,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 				resp_buftype, rsp_iov);
 
 	create_rsp = rsp_iov[0].iov_base;
-	if (create_rsp && create_rsp->sync_hdr.Status)
+	if (create_rsp && create_rsp->hdr.Status)
 		err_iov = rsp_iov[0];
 	ioctl_rsp = rsp_iov[1].iov_base;
 
@@ -4363,8 +4363,8 @@ static void
 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 		   struct smb_rqst *old_rq, __le16 cipher_type)
 {
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)old_rq->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
 
 	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
@@ -4782,7 +4782,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
 	struct cifs_readdata *rdata = mid->callback_data;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct bio_vec *bvec = NULL;
 	struct iov_iter iter;
 	struct kvec iov;
@@ -5111,7 +5111,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 {
 	int ret, length;
 	char *buf = server->smallbuf;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
 	struct mid_q_entry *mid_entry;
@@ -5141,7 +5141,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 
 	next_is_large = server->large_buf;
 one_more:
-	shdr = (struct smb2_sync_hdr *)buf;
+	shdr = (struct smb2_hdr *)buf;
 	if (shdr->NextCommand) {
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
@@ -5207,7 +5207,7 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) +
-						sizeof(struct smb2_sync_hdr)) {
+						sizeof(struct smb2_hdr)) {
 		cifs_server_dbg(VFS, "Transform message is too small (%u)\n",
 			 pdu_length);
 		cifs_reconnect(server);
@@ -5240,7 +5240,7 @@ smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 static int
 smb2_next_header(char *buf)
 {
-	struct smb2_sync_hdr *hdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
 	struct smb2_transform_hdr *t_hdr = (struct smb2_transform_hdr *)buf;
 
 	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM)
@@ -5782,7 +5782,7 @@ struct smb_version_values smb20_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5803,7 +5803,7 @@ struct smb_version_values smb21_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5824,7 +5824,7 @@ struct smb_version_values smb3any_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5845,7 +5845,7 @@ struct smb_version_values smbdefault_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5866,7 +5866,7 @@ struct smb_version_values smb30_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5887,7 +5887,7 @@ struct smb_version_values smb302_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5908,7 +5908,7 @@ struct smb_version_values smb311_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b6d2e3591927..2f902dcc62e0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -85,7 +85,7 @@ int smb3_encryption_required(const struct cifs_tcon *tcon)
 }
 
 static void
-smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
+smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 		  const struct cifs_tcon *tcon,
 		  struct TCP_Server_Info *server)
 {
@@ -342,10 +342,10 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
 	 */
 	memset(buf, 0, 256);
 
-	smb2_hdr_assemble(&spdu->sync_hdr, smb2_command, tcon, server);
+	smb2_hdr_assemble(&spdu->hdr, smb2_command, tcon, server);
 	spdu->StructureSize2 = cpu_to_le16(parmsize);
 
-	*total_len = parmsize + sizeof(struct smb2_sync_hdr);
+	*total_len = parmsize + sizeof(struct smb2_hdr);
 }
 
 /*
@@ -368,7 +368,7 @@ static int __smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 
 	fill_small_buf(smb2_command, tcon, server,
-		       (struct smb2_sync_hdr *)(*request_buf),
+		       (struct smb2_hdr *)(*request_buf),
 		       total_len);
 
 	if (tcon != NULL) {
@@ -858,7 +858,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		return rc;
 
-	req->sync_hdr.SessionId = 0;
+	req->hdr.SessionId = 0;
 
 	memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 	memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
@@ -1019,7 +1019,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
-					       (struct smb2_sync_hdr *)rsp);
+					       (struct smb2_hdr *)rsp);
 	/*
 	 * See MS-SMB2 section 2.2.4: if no blob, client picks default which
 	 * for us will be
@@ -1251,13 +1251,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 		return rc;
 
 	if (sess_data->ses->binding) {
-		req->sync_hdr.SessionId = sess_data->ses->Suid;
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.SessionId = sess_data->ses->Suid;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 		req->PreviousSessionId = 0;
 		req->Flags = SMB2_SESSION_REQ_FLAG_BINDING;
 	} else {
 		/* First session, not a reauthenticate */
-		req->sync_hdr.SessionId = 0;
+		req->hdr.SessionId = 0;
 		/*
 		 * if reconnect, we need to send previous sess id
 		 * otherwise it is 0
@@ -1267,7 +1267,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	}
 
 	/* enough to enable echos and oplocks and one max size write */
-	req->sync_hdr.CreditRequest = cpu_to_le16(130);
+	req->hdr.CreditRequest = cpu_to_le16(130);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -1426,7 +1426,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 	/* keep session id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = rsp->hdr.SessionId;
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1502,7 +1502,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* If true, rc here is expected and not an error */
 	if (sess_data->buf0_type != CIFS_NO_BUFFER &&
-		rsp->sync_hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
+		rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
 		rc = 0;
 
 	if (rc)
@@ -1524,7 +1524,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* keep existing ses id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = rsp->hdr.SessionId;
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1559,7 +1559,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	req = (struct smb2_sess_setup_req *) sess_data->iov[0].iov_base;
-	req->sync_hdr.SessionId = ses->Suid;
+	req->hdr.SessionId = ses->Suid;
 
 	rc = build_ntlmssp_auth_blob(&ntlmssp_blob, &blob_length, ses,
 					sess_data->nls_cp);
@@ -1585,7 +1585,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	/* keep existing ses id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = rsp->hdr.SessionId;
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1716,12 +1716,12 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 		return rc;
 
 	 /* since no tcon, smb2_init can not do this, so do here */
-	req->sync_hdr.SessionId = ses->Suid;
+	req->hdr.SessionId = ses->Suid;
 
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		flags |= CIFS_TRANSFORM_REQ;
 	else if (server->sign)
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	flags |= CIFS_NO_RSP_BUF;
 
@@ -1829,14 +1829,14 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	    !(ses->session_flags &
 		    (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)) &&
 	    ((ses->user_name != NULL) || (ses->sectype == Kerberos)))
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
 
 	/* Need 64 for max size write so ask for more in case not there yet */
-	req->sync_hdr.CreditRequest = cpu_to_le16(64);
+	req->hdr.CreditRequest = cpu_to_le16(64);
 
 	rc = cifs_send_recv(xid, ses, server,
 			    &rqst, &resp_buftype, flags, &rsp_iov);
@@ -1872,7 +1872,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->maximal_access = le32_to_cpu(rsp->MaximalAccess);
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
-	tcon->tid = rsp->sync_hdr.TreeId;
+	tcon->tid = rsp->hdr.TreeId;
 	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
@@ -1893,7 +1893,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	return rc;
 
 tcon_error_exit:
-	if (rsp && rsp->sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 	}
 	goto tcon_exit;
@@ -2609,7 +2609,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, utf16_path);
@@ -2741,7 +2741,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, path);
@@ -2953,7 +2953,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->volatile_fid = rsp->VolatileFileId;
 	oparms->fid->access = oparms->desired_access;
 #ifdef CONFIG_CIFS_DEBUG2
-	oparms->fid->mid = le64_to_cpu(rsp->sync_hdr.MessageId);
+	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
 	if (buf) {
@@ -3053,7 +3053,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	 * response size smaller.
 	 */
 	req->MaxOutputResponse = cpu_to_le32(max_response_size);
-	req->sync_hdr.CreditCharge =
+	req->hdr.CreditCharge =
 		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
 					 SMB2_MAX_BUFFER_SIZE));
 	if (is_fsctl)
@@ -3063,7 +3063,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	return 0;
 }
@@ -3688,7 +3688,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 
 	if (mid->mid_state == MID_RESPONSE_RECEIVED
 	    || mid->mid_state == MID_RESPONSE_MALFORMED) {
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 	}
 
@@ -3788,7 +3788,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	if (rc)
 		return rc;
 
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 
 	iov[0].iov_len = total_len;
 	iov[0].iov_base = (char *)req;
@@ -3892,7 +3892,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 {
 	int rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct TCP_Server_Info *server = io_parms->server;
 
 	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, server,
@@ -3903,7 +3903,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	if (server == NULL)
 		return -ECONNABORTED;
 
-	shdr = &req->sync_hdr;
+	shdr = &req->hdr;
 	shdr->ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
@@ -3986,8 +3986,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = rdata->server;
-	struct smb2_sync_hdr *shdr =
-				(struct smb2_sync_hdr *)rdata->iov[0].iov_base;
+	struct smb2_hdr *shdr =
+				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
 				 .rq_nvec = 1,
@@ -4073,7 +4073,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 {
 	int rc, flags = 0;
 	char *buf;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 1 };
@@ -4106,7 +4106,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_base = buf;
 	rdata->iov[0].iov_len = total_len;
 
-	shdr = (struct smb2_sync_hdr *)buf;
+	shdr = (struct smb2_hdr *)buf;
 
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
@@ -4239,7 +4239,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 		wdata->result = smb2_check_receive(mid, server, 0);
 		if (wdata->result != 0)
@@ -4265,7 +4265,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		wdata->result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 		fallthrough;
 	default:
@@ -4312,7 +4312,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 {
 	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct TCP_Server_Info *server = wdata->server;
 	struct kvec iov[1];
@@ -4330,7 +4330,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	shdr = (struct smb2_sync_hdr *)req;
+	shdr = (struct smb2_hdr *)req;
 	shdr->ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
@@ -4482,7 +4482,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (smb3_encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	req->hdr.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -4867,7 +4867,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		if (rc == -ENODATA &&
-		    rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
+		    rsp->hdr.Status == STATUS_NO_MORE_FILES) {
 			trace_smb3_query_dir_done(xid, persistent_fid,
 				tcon->tid, tcon->ses->Suid, index, 0);
 			srch_inf->endOfSearch = true;
@@ -4915,7 +4915,7 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (rc)
 		return rc;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.ProcessId = cpu_to_le32(pid);
 	req->InfoType = info_type;
 	req->FileInfoClass = info_class;
 	req->PersistentFileId = persistent_fid;
@@ -5075,7 +5075,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFid = volatile_fid;
 	req->PersistentFid = persistent_fid;
 	req->OplockLevel = oplock_level;
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 
 	flags |= CIFS_NO_RSP_BUF;
 
@@ -5377,7 +5377,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.ProcessId = cpu_to_le32(pid);
 	req->LockCount = cpu_to_le16(num_lock);
 
 	req->PersistentFileId = persist_fid;
@@ -5453,7 +5453,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 	req->StructureSize = cpu_to_le16(36);
 	total_len += 12;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 09b4db3af21c..51ae5640228b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -34,7 +34,7 @@
 
 #define SMB2_HEADER_STRUCTURE_SIZE cpu_to_le16(64)
 
-struct smb2_sync_hdr {
+struct smb2_hdr {
 	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
 	__le16 StructureSize;	/* 64 */
 	__le16 CreditCharge;	/* MBZ */
@@ -51,10 +51,10 @@ struct smb2_sync_hdr {
 } __packed;
 
 /* The total header size for SMB2 read and write */
-#define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_sync_hdr))
+#define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_hdr))
 
 struct smb2_sync_pdu {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize2; /* size of wct area (varies, request specific) */
 } __packed;
 
@@ -157,7 +157,7 @@ struct smb2_rdma_crypto_transform {
 #define SMB2_ERROR_STRUCTURE_SIZE2 cpu_to_le16(9)
 
 struct smb2_err_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;
 	__le16 Reserved; /* MBZ */
 	__le32 ByteCount;  /* even if zero, at least one byte follows */
@@ -216,7 +216,7 @@ struct share_redirect_error_context_rsp {
 #define SMB2_CLIENT_GUID_SIZE 16
 
 struct smb2_negotiate_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 DialectCount;
 	__le16 SecurityMode;
@@ -415,7 +415,7 @@ struct smb2_posix_neg_context {
 } __packed;
 
 struct smb2_negotiate_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 65 */
 	__le16 SecurityMode;
 	__le16 DialectRevision;
@@ -438,7 +438,7 @@ struct smb2_negotiate_rsp {
 #define SMB2_SESSION_REQ_FLAG_ENCRYPT_DATA	0x04
 
 struct smb2_sess_setup_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 25 */
 	__u8   Flags;
 	__u8   SecurityMode;
@@ -455,7 +455,7 @@ struct smb2_sess_setup_req {
 #define SMB2_SESSION_FLAG_IS_NULL	0x0002
 #define SMB2_SESSION_FLAG_ENCRYPT_DATA	0x0004
 struct smb2_sess_setup_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 SessionFlags;
 	__le16 SecurityBufferOffset;
@@ -464,13 +464,13 @@ struct smb2_sess_setup_rsp {
 } __packed;
 
 struct smb2_logoff_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
 
 struct smb2_logoff_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -481,7 +481,7 @@ struct smb2_logoff_rsp {
 #define SMB2_TREE_CONNECT_FLAG_EXTENSION_PRESENT cpu_to_le16(0x0004)
 
 struct smb2_tree_connect_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 9 */
 	__le16 Flags; /* Reserved MBZ for dialects prior to SMB3.1.1 */
 	__le16 PathOffset;
@@ -566,7 +566,7 @@ struct smb2_tree_connect_req_extension {
 } __packed;
 
 struct smb2_tree_connect_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 16 */
 	__u8   ShareType;  /* see below */
 	__u8   Reserved;
@@ -612,13 +612,13 @@ struct smb2_tree_connect_rsp {
 #define SMB2_SHARE_CAP_REDIRECT_TO_OWNER cpu_to_le32(0x00000100) /* 3.1.1 */
 
 struct smb2_tree_disconnect_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
 
 struct smb2_tree_disconnect_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -751,7 +751,7 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_CREATE_IOV_SIZE 8
 
 struct smb2_create_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u8   SecurityFlags;
 	__u8   RequestedOplockLevel;
@@ -778,7 +778,7 @@ struct smb2_create_req {
 #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
 
 struct smb2_create_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 89 */
 	__u8   OplockLevel;
 	__u8   Flag;  /* 0x01 if reparse point */
@@ -1153,7 +1153,7 @@ struct duplicate_extents_to_file {
 #define SMB2_IOCTL_IOV_SIZE 2
 
 struct smb2_ioctl_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -1171,7 +1171,7 @@ struct smb2_ioctl_req {
 } __packed;
 
 struct smb2_ioctl_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -1189,7 +1189,7 @@ struct smb2_ioctl_rsp {
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct smb2_close_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -1203,7 +1203,7 @@ struct smb2_close_req {
 #define MAX_SMB2_CLOSE_RESPONSE_SIZE 124
 
 struct smb2_close_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -1217,7 +1217,7 @@ struct smb2_close_rsp {
 } __packed;
 
 struct smb2_flush_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Reserved1;
 	__le32 Reserved2;
@@ -1226,7 +1226,7 @@ struct smb2_flush_req {
 } __packed;
 
 struct smb2_flush_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;
 	__le16 Reserved;
 } __packed;
@@ -1243,7 +1243,7 @@ struct smb2_flush_rsp {
 
 /* SMB2 read request without RFC1001 length at the beginning */
 struct smb2_read_plain_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__u8   Padding; /* offset from start of SMB2 header to place read */
 	__u8   Flags; /* MBZ unless SMB3.02 or later */
@@ -1264,7 +1264,7 @@ struct smb2_read_plain_req {
 #define SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM	0x00000001
 
 struct smb2_read_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -1279,7 +1279,7 @@ struct smb2_read_rsp {
 #define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
 
 struct smb2_write_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__le16 DataOffset; /* offset from start of SMB2 header to write data */
 	__le32 Length;
@@ -1295,7 +1295,7 @@ struct smb2_write_req {
 } __packed;
 
 struct smb2_write_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -1323,7 +1323,7 @@ struct smb2_write_rsp {
 #define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
 
 struct smb2_change_notify_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16	StructureSize;
 	__le16	Flags;
 	__le32	OutputBufferLength;
@@ -1334,7 +1334,7 @@ struct smb2_change_notify_req {
 } __packed;
 
 struct smb2_change_notify_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16	StructureSize;  /* Must be 9 */
 	__le16	OutputBufferOffset;
 	__le32	OutputBufferLength;
@@ -1354,7 +1354,7 @@ struct smb2_lock_element {
 } __packed;
 
 struct smb2_lock_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 48 */
 	__le16 LockCount;
 	/*
@@ -1369,19 +1369,19 @@ struct smb2_lock_req {
 } __packed;
 
 struct smb2_lock_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 4 */
 	__le16 Reserved;
 } __packed;
 
 struct smb2_echo_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__u16  Reserved;
 } __packed;
 
 struct smb2_echo_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__u16  Reserved;
 } __packed;
@@ -1411,7 +1411,7 @@ struct smb2_echo_rsp {
  */
 
 struct smb2_query_directory_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   FileInformationClass;
 	__u8   Flags;
@@ -1425,7 +1425,7 @@ struct smb2_query_directory_req {
 } __packed;
 
 struct smb2_query_directory_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1458,7 +1458,7 @@ struct smb2_query_directory_rsp {
 #define SL_INDEX_SPECIFIED	0x00000004
 
 struct smb2_query_info_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 41 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1474,7 +1474,7 @@ struct smb2_query_info_req {
 } __packed;
 
 struct smb2_query_info_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1491,7 +1491,7 @@ struct smb2_query_info_rsp {
 #define SMB2_SET_INFO_IOV_SIZE 3
 
 struct smb2_set_info_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1505,12 +1505,12 @@ struct smb2_set_info_req {
 } __packed;
 
 struct smb2_set_info_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 2 */
 } __packed;
 
 struct smb2_oplock_break {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 24 */
 	__u8   OplockLevel;
 	__u8   Reserved;
@@ -1522,7 +1522,7 @@ struct smb2_oplock_break {
 #define SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED cpu_to_le32(0x01)
 
 struct smb2_lease_break {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 44 */
 	__le16 Epoch;
 	__le32 Flags;
@@ -1535,7 +1535,7 @@ struct smb2_lease_break {
 } __packed;
 
 struct smb2_lease_ack {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 Reserved;
 	__le32 Flags;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 263767f644f8..c1f4cf82f8f3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -26,7 +26,7 @@ extern int smb2_check_message(char *buf, unsigned int length,
 			      struct TCP_Server_Info *server);
 extern unsigned int smb2_calc_size(void *buf, struct TCP_Server_Info *server);
 extern char *smb2_get_data_area_len(int *off, int *len,
-				    struct smb2_sync_hdr *shdr);
+				    struct smb2_hdr *shdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct cifs_sb_info *cifs_sb);
 
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 6f7952ea4941..3f9b3de76c99 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -214,7 +214,7 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 	struct shash_desc *shash;
 	struct crypto_shash *hash;
@@ -535,7 +535,7 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct shash_desc *shash;
 	struct crypto_shash *hash;
 	struct sdesc *sdesc = NULL;
@@ -612,12 +612,12 @@ static int
 smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct smb2_sess_setup_req *ssr;
 	bool is_binding;
 	bool is_signed;
 
-	shdr = (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	shdr = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	ssr = (struct smb2_sess_setup_req *)shdr;
 
 	is_binding = shdr->Command == SMB2_SESSION_SETUP &&
@@ -643,8 +643,8 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	unsigned int rc;
 	char server_response_sig[SMB2_SIGNATURE_SIZE];
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
@@ -690,7 +690,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
  */
 static inline void
 smb2_seq_num_into_buf(struct TCP_Server_Info *server,
-		      struct smb2_sync_hdr *shdr)
+		      struct smb2_hdr *shdr)
 {
 	unsigned int i, num = le16_to_cpu(shdr->CreditCharge);
 
@@ -701,7 +701,7 @@ smb2_seq_num_into_buf(struct TCP_Server_Info *server,
 }
 
 static struct mid_q_entry *
-smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
+smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 		     struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *temp;
@@ -740,7 +740,7 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 
 static int
 smb2_get_mid_entry(struct cifs_ses *ses, struct TCP_Server_Info *server,
-		   struct smb2_sync_hdr *shdr, struct mid_q_entry **mid)
+		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
 {
 	if (server->tcpStatus == CifsExiting)
 		return -ENOENT;
@@ -808,8 +808,8 @@ smb2_setup_request(struct cifs_ses *ses, struct TCP_Server_Info *server,
 		   struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	smb2_seq_num_into_buf(server, shdr);
@@ -834,8 +834,8 @@ struct mid_q_entry *
 smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
 	int rc;
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 	struct mid_q_entry *mid;
 
 	if (server->tcpStatus == CifsNeedNegotiate &&
-- 
2.30.2


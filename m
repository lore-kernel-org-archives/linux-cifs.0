Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F292BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 02:56:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4DA6109F
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Sep 2021 02:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhIGC5d (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Sep 2021 22:57:33 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32529 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233000AbhIGC5c (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Sep 2021 22:57:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630983387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=H9LUHl994zEjDesacB8KuYQGobeWrXQJrzrkDH8lHiQ=;
        b=GMmxo4c/dTIeyWCjYkXQXPLaU/B5/g9oC0wn4t2VsM64POpSNVQCsDbSIQjXfYfvAO89Po
        6C7q7rxHnCswgr5Q1savsTbAxT98ZEdK0Or4XJi3jpsSzprhvVdBaS/gfQuT4SgIU5hPSq
        nSVWmFyy7S5jWsk5U42q4M82NBmypLQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-MDWFke0-PC6zyVpTSKYSBw-1; Mon, 06 Sep 2021 22:56:25 -0400
X-MC-Unique: MDWFke0-PC6zyVpTSKYSBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82D7E802C88;
        Tue,  7 Sep 2021 02:56:24 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-114.bne.redhat.com [10.64.54.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5851F1001281;
        Tue,  7 Sep 2021 02:56:22 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 1/4] cifs: Create a new shared file holding smb2 pdu definitions
Date:   Tue,  7 Sep 2021 12:56:06 +1000
Message-Id: <20210907025609.2071373-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This file will contain all the definitions we need for SMB2 packets
and will follow the naming convention of MS-SMB2.PDF as closely
as possible to make it easier to cross-reference beween the definitions
and the standard.

The content of this file will mostly consist of migration of existing
definitions in the cifs/smb2.pdu.h and ksmbd/smb2pdu.h files
with some additional tweaks as the the two files have diverged.

This patch introduces the new cifs_common/smb2pdu.h file
and migrates the SMB2 header as well as TREE_CONNECT and TREE_DISCONNECT
to the shared file.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsfs.c         |   1 -
 fs/cifs/cifsglob.h       |   3 +-
 fs/cifs/connect.c        |   4 +-
 fs/cifs/misc.c           |   2 +-
 fs/cifs/smb2maperror.c   |  16 +-
 fs/cifs/smb2misc.c       |  43 +++--
 fs/cifs/smb2ops.c        |  65 +++----
 fs/cifs/smb2pdu.c        | 105 ++++++-----
 fs/cifs/smb2pdu.h        | 373 ++++-----------------------------------
 fs/cifs/smb2proto.h      |   2 +-
 fs/cifs/smb2transport.c  |  36 ++--
 fs/cifs_common/smb2pdu.h | 318 +++++++++++++++++++++++++++++++++
 12 files changed, 493 insertions(+), 475 deletions(-)
 create mode 100644 fs/cifs_common/smb2pdu.h

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 8c20bfa187ac..90681c70ef9c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -39,7 +39,6 @@
 #include <linux/key-type.h>
 #include "cifs_spnego.h"
 #include "fscache.h"
-#include "smb2pdu.h"
 #ifdef CONFIG_CIFS_DFS_UPCALL
 #include "dfs_cache.h"
 #endif
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index c068f7d8d879..207dfe407363 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -21,6 +21,7 @@
 #include <crypto/internal/hash.h>
 #include <linux/scatterlist.h>
 #include <uapi/linux/cifs/cifs_mount.h>
+#include "../cifs_common/smb2pdu.h"
 #include "smb2pdu.h"
 
 #define CIFS_MAGIC_NUMBER 0xFF534D42      /* the first four bytes of SMB PDUs */
@@ -777,7 +778,7 @@ revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 
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
index 181514b8770d..c844bc2ee02e 100644
--- a/fs/cifs/smb2maperror.c
+++ b/fs/cifs/smb2maperror.c
@@ -2439,14 +2439,16 @@ smb2_print_status(__le32 status)
 int
 map_smb2_to_linux_error(char *buf, bool log_err)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	unsigned int i;
 	int rc = -EIO;
 	__le32 smb2err = shdr->Status;
 
 	if (smb2err == 0) {
-		trace_smb3_cmd_done(shdr->TreeId, shdr->SessionId,
-			le16_to_cpu(shdr->Command), le64_to_cpu(shdr->MessageId));
+	  trace_smb3_cmd_done(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			      le64_to_cpu(shdr->SessionId),
+			      le16_to_cpu(shdr->Command),
+			      le64_to_cpu(shdr->MessageId));
 		return 0;
 	}
 
@@ -2470,8 +2472,10 @@ map_smb2_to_linux_error(char *buf, bool log_err)
 	cifs_dbg(FYI, "Mapping SMB2 status code 0x%08x to POSIX err %d\n",
 		 __le32_to_cpu(smb2err), rc);
 
-	trace_smb3_cmd_err(shdr->TreeId, shdr->SessionId,
-			le16_to_cpu(shdr->Command),
-			le64_to_cpu(shdr->MessageId), le32_to_cpu(smb2err), rc);
+	trace_smb3_cmd_err(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			   le64_to_cpu(shdr->SessionId),
+			   le16_to_cpu(shdr->Command),
+			   le64_to_cpu(shdr->MessageId),
+			   le32_to_cpu(smb2err), rc);
 	return rc;
 }
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 668f77108831..1c466d7ad7fd 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -9,7 +9,6 @@
  *
  */
 #include <linux/ctype.h>
-#include "smb2pdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -20,7 +19,7 @@
 #include "nterr.h"
 
 static int
-check_smb2_hdr(struct smb2_sync_hdr *shdr, __u64 mid)
+check_smb2_hdr(struct smb2_hdr *shdr, __u64 mid)
 {
 	__u64 wire_mid = le64_to_cpu(shdr->MessageId);
 
@@ -82,9 +81,9 @@ static const __le16 smb2_rsp_struct_sizes[NUMBER_OF_SMB2_COMMANDS] = {
 	/* SMB2_OPLOCK_BREAK */ cpu_to_le16(24)
 };
 
-#define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_sync_hdr) + sizeof(struct smb2_negotiate_rsp))
+#define SMB311_NEGPROT_BASE_SIZE (sizeof(struct smb2_hdr) + sizeof(struct smb2_negotiate_rsp))
 
-static __u32 get_neg_ctxt_len(struct smb2_sync_hdr *hdr, __u32 len,
+static __u32 get_neg_ctxt_len(struct smb2_hdr *hdr, __u32 len,
 			      __u32 non_ctxlen)
 {
 	__u16 neg_count;
@@ -136,13 +135,13 @@ static __u32 get_neg_ctxt_len(struct smb2_sync_hdr *hdr, __u32 len,
 int
 smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
-	struct smb2_sync_pdu *pdu = (struct smb2_sync_pdu *)shdr;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	struct smb2_pdu *pdu = (struct smb2_pdu *)shdr;
 	__u64 mid;
 	__u32 clc_len;  /* calculated length */
 	int command;
-	int pdu_size = sizeof(struct smb2_sync_pdu);
-	int hdr_size = sizeof(struct smb2_sync_hdr);
+	int pdu_size = sizeof(struct smb2_pdu);
+	int hdr_size = sizeof(struct smb2_hdr);
 
 	/*
 	 * Add function to do table lookup of StructureSize by command
@@ -156,7 +155,7 @@ smb2_check_message(char *buf, unsigned int len, struct TCP_Server_Info *srvr)
 		/* decrypt frame now that it is completely read in */
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(ses, &srvr->smb_ses_list, smb_ses_list) {
-			if (ses->Suid == thdr->SessionId)
+			if (ses->Suid == le64_to_cpu(thdr->SessionId))
 				break;
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
@@ -297,7 +296,7 @@ static const bool has_smb2_data_area[NUMBER_OF_SMB2_COMMANDS] = {
  * area and the offset to it (from the beginning of the smb are also returned.
  */
 char *
-smb2_get_data_area_len(int *off, int *len, struct smb2_sync_hdr *shdr)
+smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 {
 	*off = 0;
 	*len = 0;
@@ -402,8 +401,8 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_sync_hdr *shdr)
 unsigned int
 smb2_calc_size(void *buf, struct TCP_Server_Info *srvr)
 {
-	struct smb2_sync_pdu *pdu = (struct smb2_sync_pdu *)buf;
-	struct smb2_sync_hdr *shdr = &pdu->sync_hdr;
+	struct smb2_pdu *pdu = (struct smb2_pdu *)buf;
+	struct smb2_hdr *shdr = &pdu->hdr;
 	int offset; /* the offset from the beginning of SMB to data area */
 	int data_length; /* the length of the variable length data area */
 	/* Structure Size has already been checked to make sure it is 64 */
@@ -670,7 +669,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 
 	cifs_dbg(FYI, "Checking for oplock break\n");
 
-	if (rsp->sync_hdr.Command != SMB2_OPLOCK_BREAK)
+	if (rsp->hdr.Command != SMB2_OPLOCK_BREAK)
 		return false;
 
 	if (rsp->StructureSize !=
@@ -817,23 +816,23 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
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
+	tcon = smb2_find_smb_tcon(server, le64_to_cpu(hdr->SessionId),
+				  le32_to_cpu(hdr->Id.SyncId.TreeId));
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
@@ -857,10 +856,10 @@ smb311_update_preauth_hash(struct cifs_ses *ses, struct kvec *iov, int nvec)
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
index ddc0e8f97872..c91e64b4dcc4 100644
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
@@ -367,11 +367,11 @@ static void
 smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
 {
 #ifdef CONFIG_CIFS_DEBUG2
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
 		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
-		 shdr->ProcessId);
+		 shdr->Id.SyncId.ProcessId);
 	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
 		 server->ops->calc_smb_size(buf, server));
 #endif
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
@@ -2483,13 +2483,14 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 static bool
 smb2_is_session_expired(char *buf)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	if (shdr->Status != STATUS_NETWORK_SESSION_EXPIRED &&
 	    shdr->Status != STATUS_USER_SESSION_DELETED)
 		return false;
 
-	trace_smb3_ses_expired(shdr->TreeId, shdr->SessionId,
+	trace_smb3_ses_expired(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			       le64_to_cpu(shdr->SessionId),
 			       le16_to_cpu(shdr->Command),
 			       le64_to_cpu(shdr->MessageId));
 	cifs_dbg(FYI, "Session expired or deleted\n");
@@ -2500,7 +2501,7 @@ smb2_is_session_expired(char *buf)
 static bool
 smb2_is_status_io_timeout(char *buf)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 
 	if (shdr->Status == STATUS_IO_TIMEOUT)
 		return true;
@@ -2511,7 +2512,7 @@ smb2_is_status_io_timeout(char *buf)
 static void
 smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 {
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct list_head *tmp, *tmp1;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
@@ -2524,7 +2525,7 @@ smb2_is_network_name_deleted(char *buf, struct TCP_Server_Info *server)
 		ses = list_entry(tmp, struct cifs_ses, smb_ses_list);
 		list_for_each(tmp1, &ses->tcon_list) {
 			tcon = list_entry(tmp1, struct cifs_tcon, tcon_list);
-			if (tcon->tid == shdr->TreeId) {
+			if (tcon->tid == le32_to_cpu(shdr->Id.SyncId.TreeId)) {
 				tcon->need_reconnect = true;
 				spin_unlock(&cifs_tcp_ses_lock);
 				pr_warn_once("Server share %s deleted.\n",
@@ -2552,9 +2553,9 @@ smb2_oplock_response(struct cifs_tcon *tcon, struct cifs_fid *fid,
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
@@ -2567,13 +2568,13 @@ char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
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
@@ -3118,7 +3119,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 				resp_buftype, rsp_iov);
 
 	create_rsp = rsp_iov[0].iov_base;
-	if (create_rsp && create_rsp->sync_hdr.Status)
+	if (create_rsp && create_rsp->hdr.Status)
 		err_iov = rsp_iov[0];
 	ioctl_rsp = rsp_iov[1].iov_base;
 
@@ -4363,8 +4364,8 @@ static void
 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 		   struct smb_rqst *old_rq, __le16 cipher_type)
 {
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)old_rq->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)old_rq->rq_iov[0].iov_base;
 
 	memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
 	tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
@@ -4490,7 +4491,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	struct crypto_aead *tfm;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
-	rc = smb2_get_enc_key(server, tr_hdr->SessionId, enc, key);
+	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
 		cifs_server_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
 			 enc ? "en" : "de");
@@ -4782,7 +4783,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	unsigned int cur_page_idx;
 	unsigned int pad_len;
 	struct cifs_readdata *rdata = mid->callback_data;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
 	struct bio_vec *bvec = NULL;
 	struct iov_iter iter;
 	struct kvec iov;
@@ -5111,7 +5112,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 {
 	int ret, length;
 	char *buf = server->smallbuf;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	unsigned int pdu_length = server->pdu_size;
 	unsigned int buf_size;
 	struct mid_q_entry *mid_entry;
@@ -5141,7 +5142,7 @@ receive_encrypted_standard(struct TCP_Server_Info *server,
 
 	next_is_large = server->large_buf;
 one_more:
-	shdr = (struct smb2_sync_hdr *)buf;
+	shdr = (struct smb2_hdr *)buf;
 	if (shdr->NextCommand) {
 		if (next_is_large)
 			next_buffer = (char *)cifs_buf_get();
@@ -5207,7 +5208,7 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 
 	if (pdu_length < sizeof(struct smb2_transform_hdr) +
-						sizeof(struct smb2_sync_hdr)) {
+						sizeof(struct smb2_hdr)) {
 		cifs_server_dbg(VFS, "Transform message is too small (%u)\n",
 			 pdu_length);
 		cifs_reconnect(server);
@@ -5240,7 +5241,7 @@ smb3_handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 static int
 smb2_next_header(char *buf)
 {
-	struct smb2_sync_hdr *hdr = (struct smb2_sync_hdr *)buf;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)buf;
 	struct smb2_transform_hdr *t_hdr = (struct smb2_transform_hdr *)buf;
 
 	if (hdr->ProtocolId == SMB2_TRANSFORM_PROTO_NUM)
@@ -5782,7 +5783,7 @@ struct smb_version_values smb20_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5803,7 +5804,7 @@ struct smb_version_values smb21_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5824,7 +5825,7 @@ struct smb_version_values smb3any_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5845,7 +5846,7 @@ struct smb_version_values smbdefault_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5866,7 +5867,7 @@ struct smb_version_values smb30_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5887,7 +5888,7 @@ struct smb_version_values smb302_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
@@ -5908,7 +5909,7 @@ struct smb_version_values smb311_values = {
 	.exclusive_lock_type = SMB2_LOCKFLAG_EXCLUSIVE_LOCK,
 	.shared_lock_type = SMB2_LOCKFLAG_SHARED_LOCK,
 	.unlock_lock_type = SMB2_LOCKFLAG_UNLOCK,
-	.header_size = sizeof(struct smb2_sync_hdr),
+	.header_size = sizeof(struct smb2_hdr),
 	.header_preamble_size = 0,
 	.max_header_size = MAX_SMB2_HDR_SIZE,
 	.read_rsp_size = sizeof(struct smb2_read_rsp) - 1,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b6d2e3591927..2077a7436323 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -24,7 +24,6 @@
 #include <linux/uuid.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
-#include "smb2pdu.h"
 #include "cifsglob.h"
 #include "cifsacl.h"
 #include "cifsproto.h"
@@ -85,7 +84,7 @@ int smb3_encryption_required(const struct cifs_tcon *tcon)
 }
 
 static void
-smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
+smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
 		  const struct cifs_tcon *tcon,
 		  struct TCP_Server_Info *server)
 {
@@ -105,7 +104,7 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 	} else {
 		shdr->CreditRequest = cpu_to_le16(2);
 	}
-	shdr->ProcessId = cpu_to_le32((__u16)current->tgid);
+	shdr->Id.SyncId.ProcessId = cpu_to_le32((__u16)current->tgid);
 
 	if (!tcon)
 		goto out;
@@ -116,10 +115,10 @@ smb2_hdr_assemble(struct smb2_sync_hdr *shdr, __le16 smb2_cmd,
 		shdr->CreditCharge = cpu_to_le16(1);
 	/* else CreditCharge MBZ */
 
-	shdr->TreeId = tcon->tid;
+	shdr->Id.SyncId.TreeId = cpu_to_le32(tcon->tid);
 	/* Uid is not converted */
 	if (tcon->ses)
-		shdr->SessionId = tcon->ses->Suid;
+		shdr->SessionId = cpu_to_le64(tcon->ses->Suid);
 
 	/*
 	 * If we would set SMB2_FLAGS_DFS_OPERATIONS on open we also would have
@@ -332,7 +331,7 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
 	       void *buf,
 	       unsigned int *total_len)
 {
-	struct smb2_sync_pdu *spdu = (struct smb2_sync_pdu *)buf;
+	struct smb2_pdu *spdu = (struct smb2_pdu *)buf;
 	/* lookup word count ie StructureSize from table */
 	__u16 parmsize = smb2_req_struct_sizes[le16_to_cpu(smb2_command)];
 
@@ -342,10 +341,10 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
 	 */
 	memset(buf, 0, 256);
 
-	smb2_hdr_assemble(&spdu->sync_hdr, smb2_command, tcon, server);
+	smb2_hdr_assemble(&spdu->hdr, smb2_command, tcon, server);
 	spdu->StructureSize2 = cpu_to_le16(parmsize);
 
-	*total_len = parmsize + sizeof(struct smb2_sync_hdr);
+	*total_len = parmsize + sizeof(struct smb2_hdr);
 }
 
 /*
@@ -368,7 +367,7 @@ static int __smb2_plain_req_init(__le16 smb2_command, struct cifs_tcon *tcon,
 	}
 
 	fill_small_buf(smb2_command, tcon, server,
-		       (struct smb2_sync_hdr *)(*request_buf),
+		       (struct smb2_hdr *)(*request_buf),
 		       total_len);
 
 	if (tcon != NULL) {
@@ -858,7 +857,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		return rc;
 
-	req->sync_hdr.SessionId = 0;
+	req->hdr.SessionId = 0;
 
 	memset(server->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
 	memset(ses->preauth_sha_hash, 0, SMB2_PREAUTH_HASH_SIZE);
@@ -1019,7 +1018,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		server->cipher_type = SMB2_ENCRYPTION_AES128_CCM;
 
 	security_blob = smb2_get_data_area_len(&blob_offset, &blob_length,
-					       (struct smb2_sync_hdr *)rsp);
+					       (struct smb2_hdr *)rsp);
 	/*
 	 * See MS-SMB2 section 2.2.4: if no blob, client picks default which
 	 * for us will be
@@ -1251,13 +1250,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 		return rc;
 
 	if (sess_data->ses->binding) {
-		req->sync_hdr.SessionId = sess_data->ses->Suid;
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.SessionId = cpu_to_le64(sess_data->ses->Suid);
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
@@ -1267,7 +1266,7 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 	}
 
 	/* enough to enable echos and oplocks and one max size write */
-	req->sync_hdr.CreditRequest = cpu_to_le16(130);
+	req->hdr.CreditRequest = cpu_to_le16(130);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
 	if (server->sign)
@@ -1426,7 +1425,7 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	rsp = (struct smb2_sess_setup_rsp *)sess_data->iov[0].iov_base;
 	/* keep session id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = le64_to_cpu(rsp->hdr.SessionId);
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1502,7 +1501,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* If true, rc here is expected and not an error */
 	if (sess_data->buf0_type != CIFS_NO_BUFFER &&
-		rsp->sync_hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
+		rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED)
 		rc = 0;
 
 	if (rc)
@@ -1524,7 +1523,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 
 	/* keep existing ses id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = le64_to_cpu(rsp->hdr.SessionId);
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1559,7 +1558,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	req = (struct smb2_sess_setup_req *) sess_data->iov[0].iov_base;
-	req->sync_hdr.SessionId = ses->Suid;
+	req->hdr.SessionId = cpu_to_le64(ses->Suid);
 
 	rc = build_ntlmssp_auth_blob(&ntlmssp_blob, &blob_length, ses,
 					sess_data->nls_cp);
@@ -1585,7 +1584,7 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 
 	/* keep existing ses id and flags if binding */
 	if (!ses->binding) {
-		ses->Suid = rsp->sync_hdr.SessionId;
+		ses->Suid = le64_to_cpu(rsp->hdr.SessionId);
 		ses->session_flags = le16_to_cpu(rsp->SessionFlags);
 	}
 
@@ -1716,12 +1715,12 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 		return rc;
 
 	 /* since no tcon, smb2_init can not do this, so do here */
-	req->sync_hdr.SessionId = ses->Suid;
+	req->hdr.SessionId = cpu_to_le64(ses->Suid);
 
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		flags |= CIFS_TRANSFORM_REQ;
 	else if (server->sign)
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	flags |= CIFS_NO_RSP_BUF;
 
@@ -1829,14 +1828,14 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
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
@@ -1872,7 +1871,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	tcon->maximal_access = le32_to_cpu(rsp->MaximalAccess);
 	tcon->tidStatus = CifsGood;
 	tcon->need_reconnect = false;
-	tcon->tid = rsp->sync_hdr.TreeId;
+	tcon->tid = le32_to_cpu(rsp->hdr.Id.SyncId.TreeId);
 	strlcpy(tcon->treeName, tree, sizeof(tcon->treeName));
 
 	if ((rsp->Capabilities & SMB2_SHARE_CAP_DFS) &&
@@ -1893,7 +1892,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	return rc;
 
 tcon_error_exit:
-	if (rsp && rsp->sync_hdr.Status == STATUS_BAD_NETWORK_NAME) {
+	if (rsp && rsp->hdr.Status == STATUS_BAD_NETWORK_NAME) {
 		cifs_tcon_dbg(VFS, "BAD_NETWORK_NAME: %s\n", tree);
 	}
 	goto tcon_exit;
@@ -2609,7 +2608,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, utf16_path);
@@ -2741,7 +2740,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (tcon->share_flags & SHI1005_FLAGS_DFS) {
 		int name_len;
 
-		req->sync_hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
+		req->hdr.Flags |= SMB2_FLAGS_DFS_OPERATIONS;
 		rc = alloc_path_with_tree_prefix(&copy_path, &copy_size,
 						 &name_len,
 						 tcon->treeName, path);
@@ -2953,7 +2952,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	oparms->fid->volatile_fid = rsp->VolatileFileId;
 	oparms->fid->access = oparms->desired_access;
 #ifdef CONFIG_CIFS_DEBUG2
-	oparms->fid->mid = le64_to_cpu(rsp->sync_hdr.MessageId);
+	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
 	if (buf) {
@@ -3053,7 +3052,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	 * response size smaller.
 	 */
 	req->MaxOutputResponse = cpu_to_le32(max_response_size);
-	req->sync_hdr.CreditCharge =
+	req->hdr.CreditCharge =
 		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
 					 SMB2_MAX_BUFFER_SIZE));
 	if (is_fsctl)
@@ -3063,7 +3062,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
-		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	return 0;
 }
@@ -3688,7 +3687,7 @@ smb2_echo_callback(struct mid_q_entry *mid)
 
 	if (mid->mid_state == MID_RESPONSE_RECEIVED
 	    || mid->mid_state == MID_RESPONSE_MALFORMED) {
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 	}
 
@@ -3788,7 +3787,7 @@ SMB2_echo(struct TCP_Server_Info *server)
 	if (rc)
 		return rc;
 
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 
 	iov[0].iov_len = total_len;
 	iov[0].iov_base = (char *)req;
@@ -3892,7 +3891,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 {
 	int rc = -EACCES;
 	struct smb2_read_plain_req *req = NULL;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct TCP_Server_Info *server = io_parms->server;
 
 	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, server,
@@ -3903,8 +3902,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	if (server == NULL)
 		return -ECONNABORTED;
 
-	shdr = &req->sync_hdr;
-	shdr->ProcessId = cpu_to_le32(io_parms->pid);
+	shdr = &req->hdr;
+	shdr->Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -3965,8 +3964,8 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 			 * Related requests use info from previous read request
 			 * in chain.
 			 */
-			shdr->SessionId = 0xFFFFFFFFFFFFFFFF;
-			shdr->TreeId = 0xFFFFFFFF;
+			shdr->SessionId = cpu_to_le64(0xFFFFFFFFFFFFFFFF);
+			shdr->Id.SyncId.TreeId = cpu_to_le32(0xFFFFFFFF);
 			req->PersistentFileId = 0xFFFFFFFFFFFFFFFF;
 			req->VolatileFileId = 0xFFFFFFFFFFFFFFFF;
 		}
@@ -3986,8 +3985,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
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
@@ -4073,7 +4072,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 {
 	int rc, flags = 0;
 	char *buf;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = rdata->iov,
 				 .rq_nvec = 1 };
@@ -4106,7 +4105,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	rdata->iov[0].iov_base = buf;
 	rdata->iov[0].iov_len = total_len;
 
-	shdr = (struct smb2_sync_hdr *)buf;
+	shdr = (struct smb2_hdr *)buf;
 
 	if (rdata->credits.value > 0) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(rdata->bytes,
@@ -4239,7 +4238,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 		wdata->result = smb2_check_receive(mid, server, 0);
 		if (wdata->result != 0)
@@ -4265,7 +4264,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		wdata->result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
-		credits.value = le16_to_cpu(rsp->sync_hdr.CreditRequest);
+		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 		fallthrough;
 	default:
@@ -4312,7 +4311,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 {
 	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
-	struct smb2_sync_hdr *shdr;
+	struct smb2_hdr *shdr;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct TCP_Server_Info *server = wdata->server;
 	struct kvec iov[1];
@@ -4330,8 +4329,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	shdr = (struct smb2_sync_hdr *)req;
-	shdr->ProcessId = cpu_to_le32(wdata->cfile->pid);
+	shdr = (struct smb2_hdr *)req;
+	shdr->Id.SyncId.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
 	req->VolatileFileId = wdata->cfile->fid.volatile_fid;
@@ -4482,7 +4481,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (smb3_encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -4867,7 +4866,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (rc) {
 		if (rc == -ENODATA &&
-		    rsp->sync_hdr.Status == STATUS_NO_MORE_FILES) {
+		    rsp->hdr.Status == STATUS_NO_MORE_FILES) {
 			trace_smb3_query_dir_done(xid, persistent_fid,
 				tcon->tid, tcon->ses->Suid, index, 0);
 			srch_inf->endOfSearch = true;
@@ -4915,7 +4914,7 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	if (rc)
 		return rc;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(pid);
 	req->InfoType = info_type;
 	req->FileInfoClass = info_class;
 	req->PersistentFileId = persistent_fid;
@@ -5075,7 +5074,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFid = volatile_fid;
 	req->PersistentFid = persistent_fid;
 	req->OplockLevel = oplock_level;
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 
 	flags |= CIFS_NO_RSP_BUF;
 
@@ -5377,7 +5376,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->hdr.Id.SyncId.ProcessId = cpu_to_le32(pid);
 	req->LockCount = cpu_to_le16(num_lock);
 
 	req->PersistentFileId = persist_fid;
@@ -5453,7 +5452,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->hdr.CreditRequest = cpu_to_le16(1);
 	req->StructureSize = cpu_to_le16(36);
 	total_len += 12;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e9cac7970b66..293bf2a791c2 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -15,156 +15,12 @@
 #include <net/sock.h>
 #include "cifsacl.h"
 
-/*
- * Note that, due to trying to use names similar to the protocol specifications,
- * there are many mixed case field names in the structures below.  Although
- * this does not match typical Linux kernel style, it is necessary to be
- * able to match against the protocol specfication.
- *
- * SMB2 commands
- * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
- * (ie no useful data other than the SMB error code itself) and are marked such.
- * Knowing this helps avoid response buffer allocations and copy in some cases.
- */
-
-/* List of commands in host endian */
-#define SMB2_NEGOTIATE_HE	0x0000
-#define SMB2_SESSION_SETUP_HE	0x0001
-#define SMB2_LOGOFF_HE		0x0002 /* trivial request/resp */
-#define SMB2_TREE_CONNECT_HE	0x0003
-#define SMB2_TREE_DISCONNECT_HE	0x0004 /* trivial req/resp */
-#define SMB2_CREATE_HE		0x0005
-#define SMB2_CLOSE_HE		0x0006
-#define SMB2_FLUSH_HE		0x0007 /* trivial resp */
-#define SMB2_READ_HE		0x0008
-#define SMB2_WRITE_HE		0x0009
-#define SMB2_LOCK_HE		0x000A
-#define SMB2_IOCTL_HE		0x000B
-#define SMB2_CANCEL_HE		0x000C
-#define SMB2_ECHO_HE		0x000D
-#define SMB2_QUERY_DIRECTORY_HE	0x000E
-#define SMB2_CHANGE_NOTIFY_HE	0x000F
-#define SMB2_QUERY_INFO_HE	0x0010
-#define SMB2_SET_INFO_HE	0x0011
-#define SMB2_OPLOCK_BREAK_HE	0x0012
-
-/* The same list in little endian */
-#define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
-#define SMB2_SESSION_SETUP	cpu_to_le16(SMB2_SESSION_SETUP_HE)
-#define SMB2_LOGOFF		cpu_to_le16(SMB2_LOGOFF_HE)
-#define SMB2_TREE_CONNECT	cpu_to_le16(SMB2_TREE_CONNECT_HE)
-#define SMB2_TREE_DISCONNECT	cpu_to_le16(SMB2_TREE_DISCONNECT_HE)
-#define SMB2_CREATE		cpu_to_le16(SMB2_CREATE_HE)
-#define SMB2_CLOSE		cpu_to_le16(SMB2_CLOSE_HE)
-#define SMB2_FLUSH		cpu_to_le16(SMB2_FLUSH_HE)
-#define SMB2_READ		cpu_to_le16(SMB2_READ_HE)
-#define SMB2_WRITE		cpu_to_le16(SMB2_WRITE_HE)
-#define SMB2_LOCK		cpu_to_le16(SMB2_LOCK_HE)
-#define SMB2_IOCTL		cpu_to_le16(SMB2_IOCTL_HE)
-#define SMB2_CANCEL		cpu_to_le16(SMB2_CANCEL_HE)
-#define SMB2_ECHO		cpu_to_le16(SMB2_ECHO_HE)
-#define SMB2_QUERY_DIRECTORY	cpu_to_le16(SMB2_QUERY_DIRECTORY_HE)
-#define SMB2_CHANGE_NOTIFY	cpu_to_le16(SMB2_CHANGE_NOTIFY_HE)
-#define SMB2_QUERY_INFO		cpu_to_le16(SMB2_QUERY_INFO_HE)
-#define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
-#define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
-
-#define SMB2_INTERNAL_CMD	cpu_to_le16(0xFFFF)
-
-#define NUMBER_OF_SMB2_COMMANDS	0x0013
-
 /* 52 transform hdr + 64 hdr + 88 create rsp */
 #define SMB2_TRANSFORM_HEADER_SIZE 52
 #define MAX_SMB2_HDR_SIZE 204
 
-#define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
-#define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
-#define SMB2_COMPRESSION_TRANSFORM_ID cpu_to_le32(0x424d53fc)
-
-/*
- * SMB2 Header Definition
- *
- * "MBZ" :  Must be Zero
- * "BB"  :  BugBug, Something to check/review/analyze later
- * "PDU" :  "Protocol Data Unit" (ie a network "frame")
- *
- */
-
-#define SMB2_HEADER_STRUCTURE_SIZE cpu_to_le16(64)
-
-struct smb2_sync_hdr {
-	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
-	__le16 StructureSize;	/* 64 */
-	__le16 CreditCharge;	/* MBZ */
-	__le32 Status;		/* Error from server */
-	__le16 Command;
-	__le16 CreditRequest;  /* CreditResponse */
-	__le32 Flags;
-	__le32 NextCommand;
-	__le64 MessageId;
-	__le32 ProcessId;
-	__u32  TreeId;		/* opaque - so do not make little endian */
-	__u64  SessionId;	/* opaque - so do not make little endian */
-	__u8   Signature[16];
-} __packed;
-
 /* The total header size for SMB2 read and write */
-#define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_sync_hdr))
-
-struct smb2_sync_pdu {
-	struct smb2_sync_hdr sync_hdr;
-	__le16 StructureSize2; /* size of wct area (varies, request specific) */
-} __packed;
-
-#define SMB3_AES_CCM_NONCE 11
-#define SMB3_AES_GCM_NONCE 12
-
-/* Transform flags (for 3.0 dialect this flag indicates CCM */
-#define TRANSFORM_FLAG_ENCRYPTED	0x0001
-struct smb2_transform_hdr {
-	__le32 ProtocolId;	/* 0xFD 'S' 'M' 'B' */
-	__u8   Signature[16];
-	__u8   Nonce[16];
-	__le32 OriginalMessageSize;
-	__u16  Reserved1;
-	__le16 Flags; /* EncryptionAlgorithm for 3.0, enc enabled for 3.1.1 */
-	__u64  SessionId;
-} __packed;
-
-/* See MS-SMB2 2.2.42 */
-struct smb2_compression_transform_hdr_unchained {
-	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
-	__le32 OriginalCompressedSegmentSize;
-	__le16 CompressionAlgorithm;
-	__le16 Flags;
-	__le16 Length; /* if chained it is length, else offset */
-} __packed;
-
-/* See MS-SMB2 2.2.42.1 */
-#define SMB2_COMPRESSION_FLAG_NONE	0x0000
-#define SMB2_COMPRESSION_FLAG_CHAINED	0x0001
-
-struct compression_payload_header {
-	__le16	CompressionAlgorithm;
-	__le16	Flags;
-	__le32	Length; /* length of compressed playload including field below if present */
-	/* __le32 OriginalPayloadSize; */ /* optional, present when LZNT1, LZ77, LZ77+Huffman */
-} __packed;
-
-/* See MS-SMB2 2.2.42.2 */
-struct smb2_compression_transform_hdr_chained {
-	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
-	__le32 OriginalCompressedSegmentSize;
-	/* struct compression_payload_header[] */
-} __packed;
-
-/* See MS-SMB2 2.2.42.2.2 */
-struct compression_pattern_payload_v1 {
-	__le16	Pattern;
-	__le16	Reserved1;
-	__le16	Reserved2;
-	__le32	Repetitions;
-} __packed;
+#define SMB2_READWRITE_PDU_HEADER_SIZE (48 + sizeof(struct smb2_hdr))
 
 /* See MS-SMB2 2.2.43 */
 struct smb2_rdma_transform {
@@ -190,17 +46,6 @@ struct smb2_rdma_crypto_transform {
 	/* followed by padding */
 } __packed;
 
-/*
- *	SMB2 flag definitions
- */
-#define SMB2_FLAGS_SERVER_TO_REDIR	cpu_to_le32(0x00000001)
-#define SMB2_FLAGS_ASYNC_COMMAND	cpu_to_le32(0x00000002)
-#define SMB2_FLAGS_RELATED_OPERATIONS	cpu_to_le32(0x00000004)
-#define SMB2_FLAGS_SIGNED		cpu_to_le32(0x00000008)
-#define SMB2_FLAGS_PRIORITY_MASK	cpu_to_le32(0x00000070) /* SMB3.1.1 */
-#define SMB2_FLAGS_DFS_OPERATIONS	cpu_to_le32(0x10000000)
-#define SMB2_FLAGS_REPLAY_OPERATION	cpu_to_le32(0x20000000) /* SMB3 & up */
-
 /*
  *	Definitions for SMB2 Protocol Data Units (network frames)
  *
@@ -215,7 +60,7 @@ struct smb2_rdma_crypto_transform {
 #define SMB2_ERROR_STRUCTURE_SIZE2 cpu_to_le16(9)
 
 struct smb2_err_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;
 	__le16 Reserved; /* MBZ */
 	__le32 ByteCount;  /* even if zero, at least one byte follows */
@@ -274,7 +119,7 @@ struct share_redirect_error_context_rsp {
 #define SMB2_CLIENT_GUID_SIZE 16
 
 struct smb2_negotiate_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 DialectCount;
 	__le16 SecurityMode;
@@ -473,7 +318,7 @@ struct smb2_posix_neg_context {
 } __packed;
 
 struct smb2_negotiate_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 65 */
 	__le16 SecurityMode;
 	__le16 DialectRevision;
@@ -496,7 +341,7 @@ struct smb2_negotiate_rsp {
 #define SMB2_SESSION_REQ_FLAG_ENCRYPT_DATA	0x04
 
 struct smb2_sess_setup_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 25 */
 	__u8   Flags;
 	__u8   SecurityMode;
@@ -513,7 +358,7 @@ struct smb2_sess_setup_req {
 #define SMB2_SESSION_FLAG_IS_NULL	0x0002
 #define SMB2_SESSION_FLAG_ENCRYPT_DATA	0x0004
 struct smb2_sess_setup_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 SessionFlags;
 	__le16 SecurityBufferOffset;
@@ -522,161 +367,13 @@ struct smb2_sess_setup_rsp {
 } __packed;
 
 struct smb2_logoff_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
 
 struct smb2_logoff_rsp {
-	struct smb2_sync_hdr sync_hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
-/* Flags/Reserved for SMB3.1.1 */
-#define SMB2_TREE_CONNECT_FLAG_CLUSTER_RECONNECT cpu_to_le16(0x0001)
-#define SMB2_TREE_CONNECT_FLAG_REDIRECT_TO_OWNER cpu_to_le16(0x0002)
-#define SMB2_TREE_CONNECT_FLAG_EXTENSION_PRESENT cpu_to_le16(0x0004)
-
-struct smb2_tree_connect_req {
-	struct smb2_sync_hdr sync_hdr;
-	__le16 StructureSize;	/* Must be 9 */
-	__le16 Flags; /* Reserved MBZ for dialects prior to SMB3.1.1 */
-	__le16 PathOffset;
-	__le16 PathLength;
-	__u8   Buffer[1];	/* variable length */
-} __packed;
-
-/* See MS-SMB2 section 2.2.9.2 */
-/* Context Types */
-#define SMB2_RESERVED_TREE_CONNECT_CONTEXT_ID 0x0000
-#define SMB2_REMOTED_IDENTITY_TREE_CONNECT_CONTEXT_ID cpu_to_le16(0x0001)
-
-struct tree_connect_contexts {
-	__le16 ContextType;
-	__le16 DataLength;
-	__le32 Reserved;
-	__u8   Data[];
-} __packed;
-
-/* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
-struct smb3_blob_data {
-	__le16 BlobSize;
-	__u8   BlobData[];
-} __packed;
-
-/* Valid values for Attr */
-#define SE_GROUP_MANDATORY		0x00000001
-#define SE_GROUP_ENABLED_BY_DEFAULT	0x00000002
-#define SE_GROUP_ENABLED		0x00000004
-#define SE_GROUP_OWNER			0x00000008
-#define SE_GROUP_USE_FOR_DENY_ONLY	0x00000010
-#define SE_GROUP_INTEGRITY		0x00000020
-#define SE_GROUP_INTEGRITY_ENABLED	0x00000040
-#define SE_GROUP_RESOURCE		0x20000000
-#define SE_GROUP_LOGON_ID		0xC0000000
-
-/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
-
-struct sid_array_data {
-	__le16 SidAttrCount;
-	/* SidAttrList - array of sid_attr_data structs */
-} __packed;
-
-struct luid_attr_data {
-
-} __packed;
-
-/*
- * struct privilege_data is the same as BLOB_DATA - see MS-SMB2 2.2.9.2.1.5
- * but with size of LUID_ATTR_DATA struct and BlobData set to LUID_ATTR DATA
- */
-
-struct privilege_array_data {
-	__le16 PrivilegeCount;
-	/* array of privilege_data structs */
-} __packed;
-
-struct remoted_identity_tcon_context {
-	__le16 TicketType; /* must be 0x0001 */
-	__le16 TicketSize; /* total size of this struct */
-	__le16 User; /* offset to SID_ATTR_DATA struct with user info */
-	__le16 UserName; /* offset to null terminated Unicode username string */
-	__le16 Domain; /* offset to null terminated Unicode domain name */
-	__le16 Groups; /* offset to SID_ARRAY_DATA struct with group info */
-	__le16 RestrictedGroups; /* similar to above */
-	__le16 Privileges; /* offset to PRIVILEGE_ARRAY_DATA struct */
-	__le16 PrimaryGroup; /* offset to SID_ARRAY_DATA struct */
-	__le16 Owner; /* offset to BLOB_DATA struct */
-	__le16 DefaultDacl; /* offset to BLOB_DATA struct */
-	__le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
-	__le16 UserClaims; /* offset to BLOB_DATA struct */
-	__le16 DeviceClaims; /* offset to BLOB_DATA struct */
-	__u8   TicketInfo[]; /* variable length buf - remoted identity data */
-} __packed;
-
-struct smb2_tree_connect_req_extension {
-	__le32 TreeConnectContextOffset;
-	__le16 TreeConnectContextCount;
-	__u8  Reserved[10];
-	__u8  PathName[]; /* variable sized array */
-	/* followed by array of TreeConnectContexts */
-} __packed;
-
-struct smb2_tree_connect_rsp {
-	struct smb2_sync_hdr sync_hdr;
-	__le16 StructureSize;	/* Must be 16 */
-	__u8   ShareType;  /* see below */
-	__u8   Reserved;
-	__le32 ShareFlags; /* see below */
-	__le32 Capabilities; /* see below */
-	__le32 MaximalAccess;
-} __packed;
-
-/* Possible ShareType values */
-#define SMB2_SHARE_TYPE_DISK	0x01
-#define SMB2_SHARE_TYPE_PIPE	0x02
-#define	SMB2_SHARE_TYPE_PRINT	0x03
-
-/*
- * Possible ShareFlags - exactly one and only one of the first 4 caching flags
- * must be set (any of the remaining, SHI1005, flags may be set individually
- * or in combination.
- */
-#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
-#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
-#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
-#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
-#define SHI1005_FLAGS_DFS				0x00000001
-#define SHI1005_FLAGS_DFS_ROOT				0x00000002
-#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
-#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
-#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
-#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
-#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
-#define SHI1005_FLAGS_ENABLE_HASH_V1			0x00002000
-#define SHI1005_FLAGS_ENABLE_HASH_V2			0x00004000
-#define SHI1005_FLAGS_ENCRYPT_DATA			0x00008000
-#define SMB2_SHAREFLAG_IDENTITY_REMOTING		0x00040000 /* 3.1.1 */
-#define SMB2_SHAREFLAG_COMPRESS_DATA			0x00100000 /* 3.1.1 */
-#define SHI1005_FLAGS_ALL				0x0014FF33
-
-/* Possible share capabilities */
-#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008) /* all dialects */
-#define SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY cpu_to_le32(0x00000010) /* 3.0 */
-#define SMB2_SHARE_CAP_SCALEOUT	cpu_to_le32(0x00000020) /* 3.0 */
-#define SMB2_SHARE_CAP_CLUSTER	cpu_to_le32(0x00000040) /* 3.0 */
-#define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
-#define SMB2_SHARE_CAP_REDIRECT_TO_OWNER cpu_to_le32(0x00000100) /* 3.1.1 */
-
-struct smb2_tree_disconnect_req {
-	struct smb2_sync_hdr sync_hdr;
-	__le16 StructureSize;	/* Must be 4 */
-	__le16 Reserved;
-} __packed;
-
-struct smb2_tree_disconnect_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
@@ -809,7 +506,7 @@ struct smb2_tree_disconnect_rsp {
 #define SMB2_CREATE_IOV_SIZE 8
 
 struct smb2_create_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u8   SecurityFlags;
 	__u8   RequestedOplockLevel;
@@ -836,7 +533,7 @@ struct smb2_create_req {
 #define MAX_SMB2_CREATE_RESPONSE_SIZE 880
 
 struct smb2_create_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 89 */
 	__u8   OplockLevel;
 	__u8   Flag;  /* 0x01 if reparse point */
@@ -1211,7 +908,7 @@ struct duplicate_extents_to_file {
 #define SMB2_IOCTL_IOV_SIZE 2
 
 struct smb2_ioctl_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -1229,7 +926,7 @@ struct smb2_ioctl_req {
 } __packed;
 
 struct smb2_ioctl_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
@@ -1247,7 +944,7 @@ struct smb2_ioctl_rsp {
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct smb2_close_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -1261,7 +958,7 @@ struct smb2_close_req {
 #define MAX_SMB2_CLOSE_RESPONSE_SIZE 124
 
 struct smb2_close_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* 60 */
 	__le16 Flags;
 	__le32 Reserved;
@@ -1275,7 +972,7 @@ struct smb2_close_rsp {
 } __packed;
 
 struct smb2_flush_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Reserved1;
 	__le32 Reserved2;
@@ -1284,7 +981,7 @@ struct smb2_flush_req {
 } __packed;
 
 struct smb2_flush_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize;
 	__le16 Reserved;
 } __packed;
@@ -1301,7 +998,7 @@ struct smb2_flush_rsp {
 
 /* SMB2 read request without RFC1001 length at the beginning */
 struct smb2_read_plain_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__u8   Padding; /* offset from start of SMB2 header to place read */
 	__u8   Flags; /* MBZ unless SMB3.02 or later */
@@ -1322,7 +1019,7 @@ struct smb2_read_plain_req {
 #define SMB2_READFLAG_RESPONSE_RDMA_TRANSFORM	0x00000001
 
 struct smb2_read_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -1337,7 +1034,7 @@ struct smb2_read_rsp {
 #define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
 
 struct smb2_write_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__le16 DataOffset; /* offset from start of SMB2 header to write data */
 	__le32 Length;
@@ -1353,7 +1050,7 @@ struct smb2_write_req {
 } __packed;
 
 struct smb2_write_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 17 */
 	__u8   DataOffset;
 	__u8   Reserved;
@@ -1381,7 +1078,7 @@ struct smb2_write_rsp {
 #define FILE_NOTIFY_CHANGE_STREAM_WRITE		0x00000800
 
 struct smb2_change_notify_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16	StructureSize;
 	__le16	Flags;
 	__le32	OutputBufferLength;
@@ -1392,7 +1089,7 @@ struct smb2_change_notify_req {
 } __packed;
 
 struct smb2_change_notify_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16	StructureSize;  /* Must be 9 */
 	__le16	OutputBufferOffset;
 	__le32	OutputBufferLength;
@@ -1412,7 +1109,7 @@ struct smb2_lock_element {
 } __packed;
 
 struct smb2_lock_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 48 */
 	__le16 LockCount;
 	/*
@@ -1427,19 +1124,19 @@ struct smb2_lock_req {
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
@@ -1469,7 +1166,7 @@ struct smb2_echo_rsp {
  */
 
 struct smb2_query_directory_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   FileInformationClass;
 	__u8   Flags;
@@ -1483,7 +1180,7 @@ struct smb2_query_directory_req {
 } __packed;
 
 struct smb2_query_directory_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1516,7 +1213,7 @@ struct smb2_query_directory_rsp {
 #define SL_INDEX_SPECIFIED	0x00000004
 
 struct smb2_query_info_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 41 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1532,7 +1229,7 @@ struct smb2_query_info_req {
 } __packed;
 
 struct smb2_query_info_rsp {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 9 */
 	__le16 OutputBufferOffset;
 	__le32 OutputBufferLength;
@@ -1549,7 +1246,7 @@ struct smb2_query_info_rsp {
 #define SMB2_SET_INFO_IOV_SIZE 3
 
 struct smb2_set_info_req {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
@@ -1563,12 +1260,12 @@ struct smb2_set_info_req {
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
@@ -1580,7 +1277,7 @@ struct smb2_oplock_break {
 #define SMB2_NOTIFY_BREAK_LEASE_FLAG_ACK_REQUIRED cpu_to_le32(0x01)
 
 struct smb2_lease_break {
-	struct smb2_sync_hdr sync_hdr;
+	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 44 */
 	__le16 Epoch;
 	__le32 Flags;
@@ -1593,7 +1290,7 @@ struct smb2_lease_break {
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
index 6f7952ea4941..6bc805b7423d 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -20,7 +20,6 @@
 #include <linux/mempool.h>
 #include <linux/highmem.h>
 #include <crypto/aead.h>
-#include "smb2pdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
@@ -214,14 +213,14 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct cifs_ses *ses;
 	struct shash_desc *shash;
 	struct crypto_shash *hash;
 	struct sdesc *sdesc = NULL;
 	struct smb_rqst drqst;
 
-	ses = smb2_find_smb_ses(server, shdr->SessionId);
+	ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
 	if (!ses) {
 		cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
 		return 0;
@@ -535,14 +534,14 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
 	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
 	unsigned char *sigptr = smb3_signature;
 	struct kvec *iov = rqst->rq_iov;
-	struct smb2_sync_hdr *shdr = (struct smb2_sync_hdr *)iov[0].iov_base;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct shash_desc *shash;
 	struct crypto_shash *hash;
 	struct sdesc *sdesc = NULL;
 	struct smb_rqst drqst;
 	u8 key[SMB3_SIGN_KEY_SIZE];
 
-	rc = smb2_get_sign_key(shdr->SessionId, server, key);
+	rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
 	if (rc)
 		return 0;
 
@@ -612,12 +611,12 @@ static int
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
@@ -643,8 +642,8 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	unsigned int rc;
 	char server_response_sig[SMB2_SIGNATURE_SIZE];
-	struct smb2_sync_hdr *shdr =
-			(struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
+	struct smb2_hdr *shdr =
+			(struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((shdr->Command == SMB2_NEGOTIATE) ||
 	    (shdr->Command == SMB2_SESSION_SETUP) ||
@@ -690,7 +689,7 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
  */
 static inline void
 smb2_seq_num_into_buf(struct TCP_Server_Info *server,
-		      struct smb2_sync_hdr *shdr)
+		      struct smb2_hdr *shdr)
 {
 	unsigned int i, num = le16_to_cpu(shdr->CreditCharge);
 
@@ -701,7 +700,7 @@ smb2_seq_num_into_buf(struct TCP_Server_Info *server,
 }
 
 static struct mid_q_entry *
-smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
+smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 		     struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *temp;
@@ -733,14 +732,15 @@ smb2_mid_entry_alloc(const struct smb2_sync_hdr *shdr,
 
 	atomic_inc(&midCount);
 	temp->mid_state = MID_REQUEST_ALLOCATED;
-	trace_smb3_cmd_enter(shdr->TreeId, shdr->SessionId,
-		le16_to_cpu(shdr->Command), temp->mid);
+	trace_smb3_cmd_enter(le32_to_cpu(shdr->Id.SyncId.TreeId),
+			     le64_to_cpu(shdr->SessionId),
+			     le16_to_cpu(shdr->Command), temp->mid);
 	return temp;
 }
 
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
diff --git a/fs/cifs_common/smb2pdu.h b/fs/cifs_common/smb2pdu.h
new file mode 100644
index 000000000000..f191ed64c1ee
--- /dev/null
+++ b/fs/cifs_common/smb2pdu.h
@@ -0,0 +1,318 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+#ifndef _COMMON_SMB2PDU_H
+#define _COMMON_SMB2PDU_H
+
+/*
+ * Note that, due to trying to use names similar to the protocol specifications,
+ * there are many mixed case field names in the structures below.  Although
+ * this does not match typical Linux kernel style, it is necessary to be
+ * able to match against the protocol specfication.
+ *
+ * SMB2 commands
+ * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
+ * (ie no useful data other than the SMB error code itself) and are marked such.
+ * Knowing this helps avoid response buffer allocations and copy in some cases.
+ */
+
+/* List of commands in host endian */
+#define SMB2_NEGOTIATE_HE	0x0000
+#define SMB2_SESSION_SETUP_HE	0x0001
+#define SMB2_LOGOFF_HE		0x0002 /* trivial request/resp */
+#define SMB2_TREE_CONNECT_HE	0x0003
+#define SMB2_TREE_DISCONNECT_HE	0x0004 /* trivial req/resp */
+#define SMB2_CREATE_HE		0x0005
+#define SMB2_CLOSE_HE		0x0006
+#define SMB2_FLUSH_HE		0x0007 /* trivial resp */
+#define SMB2_READ_HE		0x0008
+#define SMB2_WRITE_HE		0x0009
+#define SMB2_LOCK_HE		0x000A
+#define SMB2_IOCTL_HE		0x000B
+#define SMB2_CANCEL_HE		0x000C
+#define SMB2_ECHO_HE		0x000D
+#define SMB2_QUERY_DIRECTORY_HE	0x000E
+#define SMB2_CHANGE_NOTIFY_HE	0x000F
+#define SMB2_QUERY_INFO_HE	0x0010
+#define SMB2_SET_INFO_HE	0x0011
+#define SMB2_OPLOCK_BREAK_HE	0x0012
+
+/* The same list in little endian */
+#define SMB2_NEGOTIATE		cpu_to_le16(SMB2_NEGOTIATE_HE)
+#define SMB2_SESSION_SETUP	cpu_to_le16(SMB2_SESSION_SETUP_HE)
+#define SMB2_LOGOFF		cpu_to_le16(SMB2_LOGOFF_HE)
+#define SMB2_TREE_CONNECT	cpu_to_le16(SMB2_TREE_CONNECT_HE)
+#define SMB2_TREE_DISCONNECT	cpu_to_le16(SMB2_TREE_DISCONNECT_HE)
+#define SMB2_CREATE		cpu_to_le16(SMB2_CREATE_HE)
+#define SMB2_CLOSE		cpu_to_le16(SMB2_CLOSE_HE)
+#define SMB2_FLUSH		cpu_to_le16(SMB2_FLUSH_HE)
+#define SMB2_READ		cpu_to_le16(SMB2_READ_HE)
+#define SMB2_WRITE		cpu_to_le16(SMB2_WRITE_HE)
+#define SMB2_LOCK		cpu_to_le16(SMB2_LOCK_HE)
+#define SMB2_IOCTL		cpu_to_le16(SMB2_IOCTL_HE)
+#define SMB2_CANCEL		cpu_to_le16(SMB2_CANCEL_HE)
+#define SMB2_ECHO		cpu_to_le16(SMB2_ECHO_HE)
+#define SMB2_QUERY_DIRECTORY	cpu_to_le16(SMB2_QUERY_DIRECTORY_HE)
+#define SMB2_CHANGE_NOTIFY	cpu_to_le16(SMB2_CHANGE_NOTIFY_HE)
+#define SMB2_QUERY_INFO		cpu_to_le16(SMB2_QUERY_INFO_HE)
+#define SMB2_SET_INFO		cpu_to_le16(SMB2_SET_INFO_HE)
+#define SMB2_OPLOCK_BREAK	cpu_to_le16(SMB2_OPLOCK_BREAK_HE)
+
+#define SMB2_INTERNAL_CMD	cpu_to_le16(0xFFFF)
+
+#define NUMBER_OF_SMB2_COMMANDS	0x0013
+
+/*
+ * SMB2 Header Definition
+ *
+ * "MBZ" :  Must be Zero
+ * "BB"  :  BugBug, Something to check/review/analyze later
+ * "PDU" :  "Protocol Data Unit" (ie a network "frame")
+ *
+ */
+
+#define __SMB2_HEADER_STRUCTURE_SIZE	64
+#define SMB2_HEADER_STRUCTURE_SIZE				\
+	cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
+
+#define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
+#define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
+#define SMB2_COMPRESSION_TRANSFORM_ID cpu_to_le32(0x424d53fc)
+
+/*
+ *	SMB2 flag definitions
+ */
+#define SMB2_FLAGS_SERVER_TO_REDIR	cpu_to_le32(0x00000001)
+#define SMB2_FLAGS_ASYNC_COMMAND	cpu_to_le32(0x00000002)
+#define SMB2_FLAGS_RELATED_OPERATIONS	cpu_to_le32(0x00000004)
+#define SMB2_FLAGS_SIGNED		cpu_to_le32(0x00000008)
+#define SMB2_FLAGS_PRIORITY_MASK	cpu_to_le32(0x00000070) /* SMB3.1.1 */
+#define SMB2_FLAGS_DFS_OPERATIONS	cpu_to_le32(0x10000000)
+#define SMB2_FLAGS_REPLAY_OPERATION	cpu_to_le32(0x20000000) /* SMB3 & up */
+
+/* See MS-SMB2 section 2.2.1 */
+struct smb2_hdr {
+	__le32 ProtocolId;	/* 0xFE 'S' 'M' 'B' */
+	__le16 StructureSize;	/* 64 */
+	__le16 CreditCharge;	/* MBZ */
+	__le32 Status;		/* Error from server */
+	__le16 Command;
+	__le16 CreditRequest;	/* CreditResponse */
+	__le32 Flags;
+	__le32 NextCommand;
+	__le64 MessageId;
+	union {
+		struct {
+			__le32 ProcessId;
+			__le32  TreeId;
+		} __packed SyncId;
+		__le64  AsyncId;
+	} __packed Id;
+	__le64  SessionId;
+	__u8   Signature[16];
+} __packed;
+
+struct smb2_pdu {
+	struct smb2_hdr hdr;
+	__le16 StructureSize2; /* size of wct area (varies, request specific) */
+} __packed;
+
+#define SMB3_AES_CCM_NONCE 11
+#define SMB3_AES_GCM_NONCE 12
+
+/* Transform flags (for 3.0 dialect this flag indicates CCM */
+#define TRANSFORM_FLAG_ENCRYPTED	0x0001
+struct smb2_transform_hdr {
+	__le32 ProtocolId;	/* 0xFD 'S' 'M' 'B' */
+	__u8   Signature[16];
+	__u8   Nonce[16];
+	__le32 OriginalMessageSize;
+	__u16  Reserved1;
+	__le16 Flags; /* EncryptionAlgorithm for 3.0, enc enabled for 3.1.1 */
+	__le64  SessionId;
+} __packed;
+
+
+/* See MS-SMB2 2.2.42 */
+struct smb2_compression_transform_hdr_unchained {
+	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
+	__le32 OriginalCompressedSegmentSize;
+	__le16 CompressionAlgorithm;
+	__le16 Flags;
+	__le16 Length; /* if chained it is length, else offset */
+} __packed;
+
+/* See MS-SMB2 2.2.42.1 */
+#define SMB2_COMPRESSION_FLAG_NONE	0x0000
+#define SMB2_COMPRESSION_FLAG_CHAINED	0x0001
+
+struct compression_payload_header {
+	__le16	CompressionAlgorithm;
+	__le16	Flags;
+	__le32	Length; /* length of compressed playload including field below if present */
+	/* __le32 OriginalPayloadSize; */ /* optional, present when LZNT1, LZ77, LZ77+Huffman */
+} __packed;
+
+/* See MS-SMB2 2.2.42.2 */
+struct smb2_compression_transform_hdr_chained {
+	__le32 ProtocolId;	/* 0xFC 'S' 'M' 'B' */
+	__le32 OriginalCompressedSegmentSize;
+	/* struct compression_payload_header[] */
+} __packed;
+
+/* See MS-SMB2 2.2.42.2.2 */
+struct compression_pattern_payload_v1 {
+	__le16	Pattern;
+	__le16	Reserved1;
+	__le16	Reserved2;
+	__le32	Repetitions;
+} __packed;
+
+/* See MS-SMB2 section 2.2.9.2 */
+/* Context Types */
+#define SMB2_RESERVED_TREE_CONNECT_CONTEXT_ID 0x0000
+#define SMB2_REMOTED_IDENTITY_TREE_CONNECT_CONTEXT_ID cpu_to_le16(0x0001)
+
+struct tree_connect_contexts {
+	__le16 ContextType;
+	__le16 DataLength;
+	__le32 Reserved;
+	__u8   Data[];
+} __packed;
+
+/* Remoted identity tree connect context structures - see MS-SMB2 2.2.9.2.1 */
+struct smb3_blob_data {
+	__le16 BlobSize;
+	__u8   BlobData[];
+} __packed;
+
+/* Valid values for Attr */
+#define SE_GROUP_MANDATORY		0x00000001
+#define SE_GROUP_ENABLED_BY_DEFAULT	0x00000002
+#define SE_GROUP_ENABLED		0x00000004
+#define SE_GROUP_OWNER			0x00000008
+#define SE_GROUP_USE_FOR_DENY_ONLY	0x00000010
+#define SE_GROUP_INTEGRITY		0x00000020
+#define SE_GROUP_INTEGRITY_ENABLED	0x00000040
+#define SE_GROUP_RESOURCE		0x20000000
+#define SE_GROUP_LOGON_ID		0xC0000000
+
+/* struct sid_attr_data is SidData array in BlobData format then le32 Attr */
+
+struct sid_array_data {
+	__le16 SidAttrCount;
+	/* SidAttrList - array of sid_attr_data structs */
+} __packed;
+
+struct luid_attr_data {
+
+} __packed;
+
+/*
+ * struct privilege_data is the same as BLOB_DATA - see MS-SMB2 2.2.9.2.1.5
+ * but with size of LUID_ATTR_DATA struct and BlobData set to LUID_ATTR DATA
+ */
+
+struct privilege_array_data {
+	__le16 PrivilegeCount;
+	/* array of privilege_data structs */
+} __packed;
+
+struct remoted_identity_tcon_context {
+	__le16 TicketType; /* must be 0x0001 */
+	__le16 TicketSize; /* total size of this struct */
+	__le16 User; /* offset to SID_ATTR_DATA struct with user info */
+	__le16 UserName; /* offset to null terminated Unicode username string */
+	__le16 Domain; /* offset to null terminated Unicode domain name */
+	__le16 Groups; /* offset to SID_ARRAY_DATA struct with group info */
+	__le16 RestrictedGroups; /* similar to above */
+	__le16 Privileges; /* offset to PRIVILEGE_ARRAY_DATA struct */
+	__le16 PrimaryGroup; /* offset to SID_ARRAY_DATA struct */
+	__le16 Owner; /* offset to BLOB_DATA struct */
+	__le16 DefaultDacl; /* offset to BLOB_DATA struct */
+	__le16 DeviceGroups; /* offset to SID_ARRAY_DATA struct */
+	__le16 UserClaims; /* offset to BLOB_DATA struct */
+	__le16 DeviceClaims; /* offset to BLOB_DATA struct */
+	__u8   TicketInfo[]; /* variable length buf - remoted identity data */
+} __packed;
+
+struct smb2_tree_connect_req_extension {
+	__le32 TreeConnectContextOffset;
+	__le16 TreeConnectContextCount;
+	__u8  Reserved[10];
+	__u8  PathName[]; /* variable sized array */
+	/* followed by array of TreeConnectContexts */
+} __packed;
+
+/* Flags/Reserved for SMB3.1.1 */
+#define SMB2_TREE_CONNECT_FLAG_CLUSTER_RECONNECT cpu_to_le16(0x0001)
+#define SMB2_TREE_CONNECT_FLAG_REDIRECT_TO_OWNER cpu_to_le16(0x0002)
+#define SMB2_TREE_CONNECT_FLAG_EXTENSION_PRESENT cpu_to_le16(0x0004)
+
+struct smb2_tree_connect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 9 */
+	__le16 Flags;		/* Flags in SMB3.1.1 */
+	__le16 PathOffset;
+	__le16 PathLength;
+	__u8   Buffer[1];	/* variable length */
+} __packed;
+
+/* Possible ShareType values */
+#define SMB2_SHARE_TYPE_DISK	0x01
+#define SMB2_SHARE_TYPE_PIPE	0x02
+#define	SMB2_SHARE_TYPE_PRINT	0x03
+
+/*
+ * Possible ShareFlags - exactly one and only one of the first 4 caching flags
+ * must be set (any of the remaining, SHI1005, flags may be set individually
+ * or in combination.
+ */
+#define SMB2_SHAREFLAG_MANUAL_CACHING			0x00000000
+#define SMB2_SHAREFLAG_AUTO_CACHING			0x00000010
+#define SMB2_SHAREFLAG_VDO_CACHING			0x00000020
+#define SMB2_SHAREFLAG_NO_CACHING			0x00000030
+#define SHI1005_FLAGS_DFS				0x00000001
+#define SHI1005_FLAGS_DFS_ROOT				0x00000002
+#define SHI1005_FLAGS_RESTRICT_EXCLUSIVE_OPENS		0x00000100
+#define SHI1005_FLAGS_FORCE_SHARED_DELETE		0x00000200
+#define SHI1005_FLAGS_ALLOW_NAMESPACE_CACHING		0x00000400
+#define SHI1005_FLAGS_ACCESS_BASED_DIRECTORY_ENUM	0x00000800
+#define SHI1005_FLAGS_FORCE_LEVELII_OPLOCK		0x00001000
+#define SHI1005_FLAGS_ENABLE_HASH_V1			0x00002000
+#define SHI1005_FLAGS_ENABLE_HASH_V2			0x00004000
+#define SHI1005_FLAGS_ENCRYPT_DATA			0x00008000
+#define SMB2_SHAREFLAG_IDENTITY_REMOTING		0x00040000 /* 3.1.1 */
+#define SMB2_SHAREFLAG_COMPRESS_DATA			0x00100000 /* 3.1.1 */
+#define SHI1005_FLAGS_ALL				0x0014FF33
+
+/* Possible share capabilities */
+#define SMB2_SHARE_CAP_DFS	cpu_to_le32(0x00000008) /* all dialects */
+#define SMB2_SHARE_CAP_CONTINUOUS_AVAILABILITY cpu_to_le32(0x00000010) /* 3.0 */
+#define SMB2_SHARE_CAP_SCALEOUT	cpu_to_le32(0x00000020) /* 3.0 */
+#define SMB2_SHARE_CAP_CLUSTER	cpu_to_le32(0x00000040) /* 3.0 */
+#define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
+#define SMB2_SHARE_CAP_REDIRECT_TO_OWNER cpu_to_le32(0x00000100) /* 3.1.1 */
+
+struct smb2_tree_connect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 16 */
+	__u8   ShareType;	/* see below */
+	__u8   Reserved;
+	__le32 ShareFlags;	/* see below */
+	__le32 Capabilities;	/* see below */
+	__le32 MaximalAccess;
+} __packed;
+
+struct smb2_tree_disconnect_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+struct smb2_tree_disconnect_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+
+#endif				/* _COMMON_SMB2PDU_H */
-- 
2.30.2


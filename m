Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F31C004C9
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 00:00:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD0292082F
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 00:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfEFAAO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 5 May 2019 20:00:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39262 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfEFAAN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sun, 5 May 2019 20:00:13 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3B2AE330272;
        Mon,  6 May 2019 00:00:13 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-90.bne.redhat.com [10.64.54.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 900B51001E8D;
        Mon,  6 May 2019 00:00:12 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: rename and clarify CIFS_ASYNC_OP and CIFS_NO_RESP
Date:   Mon,  6 May 2019 10:00:02 +1000
Message-Id: <20190506000002.32556-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 06 May 2019 00:00:13 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The flags were named confusingly.
CIFS_ASYNC_OP now just means that we will not block waiting for credits
to become available so we thus rename this to be CIFS_NON_BLOCKING.

Change CIFS_NO_RESP to CIFS_NO_RSP_BUF to clarify that we will actually get a
response from the server but we will not get/do not want a response buffer.

Delete CIFSSMBNotify. This is an SMB1 function that is not used.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cifsglob.h  |  4 +--
 fs/cifs/cifssmb.c   | 98 +++--------------------------------------------------
 fs/cifs/smb2pdu.c   | 10 +++---
 fs/cifs/transport.c |  9 ++---
 4 files changed, 14 insertions(+), 107 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index cff7167ffef2..d26a52db1dad 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1690,11 +1690,11 @@ static inline bool is_retryable_error(int error)
 
 /* Type of Request to SendReceive2 */
 #define   CIFS_BLOCKING_OP      1    /* operation can block */
-#define   CIFS_ASYNC_OP         2    /* do not wait for response */
+#define   CIFS_NON_BLOCKING     2    /* do not block waiting for credits */
 #define   CIFS_TIMEOUT_MASK 0x003    /* only one of above set in req */
 #define   CIFS_LOG_ERROR    0x010    /* log NT STATUS if non-zero */
 #define   CIFS_LARGE_BUF_OP 0x020    /* large request buffer */
-#define   CIFS_NO_RESP      0x040    /* no response buffer required */
+#define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
 
 /* Type of request operation */
 #define   CIFS_ECHO_OP      0x080    /* echo request */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 6050851edcb8..1fbd92843a73 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -860,7 +860,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov[1].iov_base = (char *)smb + 4;
 
 	rc = cifs_call_async(server, &rqst, NULL, cifs_echo_callback, NULL,
-			     server, CIFS_ASYNC_OP | CIFS_ECHO_OP, NULL);
+			     server, CIFS_NON_BLOCKING | CIFS_ECHO_OP, NULL);
 	if (rc)
 		cifs_dbg(FYI, "Echo request failed: %d\n", rc);
 
@@ -2508,8 +2508,8 @@ int cifs_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	iov[1].iov_len = (num_unlock + num_lock) * sizeof(LOCKING_ANDX_RANGE);
 
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
-	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_NO_RESP,
-			  &rsp_iov);
+	rc = SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type,
+			  CIFS_NO_RSP_BUF, &rsp_iov);
 	cifs_small_buf_release(pSMB);
 	if (rc)
 		cifs_dbg(FYI, "Send error in cifs_lockv = %d\n", rc);
@@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
 		/* no response expected */
-		flags = CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_OP;
+		flags = CIFS_NO_SRV_RSP | CIFS_NON_BLOCKING | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		flags = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
@@ -6567,93 +6567,3 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 #endif
-
-#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* BB unused temporarily */
-/*
- *	Years ago the kernel added a "dnotify" function for Samba server,
- *	to allow network clients (such as Windows) to display updated
- *	lists of files in directory listings automatically when
- *	files are added by one user when another user has the
- *	same directory open on their desktop.  The Linux cifs kernel
- *	client hooked into the kernel side of this interface for
- *	the same reason, but ironically when the VFS moved from
- *	"dnotify" to "inotify" it became harder to plug in Linux
- *	network file system clients (the most obvious use case
- *	for notify interfaces is when multiple users can update
- *	the contents of the same directory - exactly what network
- *	file systems can do) although the server (Samba) could
- *	still use it.  For the short term we leave the worker
- *	function ifdeffed out (below) until inotify is fixed
- *	in the VFS to make it easier to plug in network file
- *	system clients.  If inotify turns out to be permanently
- *	incompatible for network fs clients, we could instead simply
- *	expose this config flag by adding a future cifs (and smb2) notify ioctl.
- */
-int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
-		  const int notify_subdirs, const __u16 netfid,
-		  __u32 filter, struct file *pfile, int multishot,
-		  const struct nls_table *nls_codepage)
-{
-	int rc = 0;
-	struct smb_com_transaction_change_notify_req *pSMB = NULL;
-	struct smb_com_ntransaction_change_notify_rsp *pSMBr = NULL;
-	struct dir_notify_req *dnotify_req;
-	int bytes_returned;
-
-	cifs_dbg(FYI, "In CIFSSMBNotify for file handle %d\n", (int)netfid);
-	rc = smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
-		      (void **) &pSMBr);
-	if (rc)
-		return rc;
-
-	pSMB->TotalParameterCount = 0 ;
-	pSMB->TotalDataCount = 0;
-	pSMB->MaxParameterCount = cpu_to_le32(2);
-	pSMB->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
-	pSMB->MaxSetupCount = 4;
-	pSMB->Reserved = 0;
-	pSMB->ParameterOffset = 0;
-	pSMB->DataCount = 0;
-	pSMB->DataOffset = 0;
-	pSMB->SetupCount = 4; /* single byte does not need le conversion */
-	pSMB->SubCommand = cpu_to_le16(NT_TRANSACT_NOTIFY_CHANGE);
-	pSMB->ParameterCount = pSMB->TotalParameterCount;
-	if (notify_subdirs)
-		pSMB->WatchTree = 1; /* one byte - no le conversion needed */
-	pSMB->Reserved2 = 0;
-	pSMB->CompletionFilter = cpu_to_le32(filter);
-	pSMB->Fid = netfid; /* file handle always le */
-	pSMB->ByteCount = 0;
-
-	rc = SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
-			 (struct smb_hdr *)pSMBr, &bytes_returned,
-			 CIFS_ASYNC_OP);
-	if (rc) {
-		cifs_dbg(FYI, "Error in Notify = %d\n", rc);
-	} else {
-		/* Add file to outstanding requests */
-		/* BB change to kmem cache alloc */
-		dnotify_req = kmalloc(
-						sizeof(struct dir_notify_req),
-						 GFP_KERNEL);
-		if (dnotify_req) {
-			dnotify_req->Pid = pSMB->hdr.Pid;
-			dnotify_req->PidHigh = pSMB->hdr.PidHigh;
-			dnotify_req->Mid = pSMB->hdr.Mid;
-			dnotify_req->Tid = pSMB->hdr.Tid;
-			dnotify_req->Uid = pSMB->hdr.Uid;
-			dnotify_req->netfid = netfid;
-			dnotify_req->pfile = pfile;
-			dnotify_req->filter = filter;
-			dnotify_req->multishot = multishot;
-			spin_lock(&GlobalMid_Lock);
-			list_add_tail(&dnotify_req->lhead,
-					&GlobalDnotifyReqList);
-			spin_unlock(&GlobalMid_Lock);
-		} else
-			rc = -ENOMEM;
-	}
-	cifs_buf_release(pSMB);
-	return rc;
-}
-#endif /* was needed for dnotify, and will be needed for inotify when VFS fix */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 82e2a27bccc0..85f00edcbd16 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1583,7 +1583,7 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	else if (server->sign)
 		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	flags |= CIFS_NO_RESP;
+	flags |= CIFS_NO_RSP_BUF;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
@@ -1784,7 +1784,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	flags |= CIFS_NO_RESP;
+	flags |= CIFS_NO_RSP_BUF;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
@@ -4211,7 +4211,7 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->OplockLevel = oplock_level;
 	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 
-	flags |= CIFS_NO_RESP;
+	flags |= CIFS_NO_RSP_BUF;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
@@ -4485,7 +4485,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon *tcon,
 	struct kvec rsp_iov;
 	int resp_buf_type;
 	unsigned int count;
-	int flags = CIFS_NO_RESP;
+	int flags = CIFS_NO_RSP_BUF;
 	unsigned int total_len;
 
 	cifs_dbg(FYI, "smb2_lockv num lock %d\n", num_lock);
@@ -4578,7 +4578,7 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(req->LeaseKey, lease_key, 16);
 	req->LeaseState = lease_state;
 
-	flags |= CIFS_NO_RESP;
+	flags |= CIFS_NO_RSP_BUF;
 
 	iov[0].iov_base = (char *)req;
 	iov[0].iov_len = total_len;
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 5573e38b13f3..9a16ff4b9f5e 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -529,7 +529,7 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		return -EAGAIN;
 
 	spin_lock(&server->req_lock);
-	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP) {
+	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_NON_BLOCKING) {
 		/* oplock breaks must not be held up */
 		server->in_flight++;
 		*credits -= 1;
@@ -838,7 +838,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 
 	iov[0].iov_base = in_buf;
 	iov[0].iov_len = get_rfc1002_length(in_buf) + 4;
-	flags |= CIFS_NO_RESP;
+	flags |= CIFS_NO_RSP_BUF;
 	rc = SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
 
@@ -1151,7 +1151,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 						     flags & CIFS_LOG_ERROR);
 
 		/* mark it so buf will not be freed by cifs_delete_mid */
-		if ((flags & CIFS_NO_RESP) == 0)
+		if ((flags & CIFS_NO_RSP_BUF) == 0)
 			midQ[i]->resp_buf = NULL;
 
 	}
@@ -1302,9 +1302,6 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc < 0)
 		goto out;
 
-	if ((flags & CIFS_TIMEOUT_MASK) == CIFS_ASYNC_OP)
-		goto out;
-
 	rc = wait_for_response(ses->server, midQ);
 	if (rc != 0) {
 		send_cancel(ses->server, &rqst, midQ);
-- 
2.13.6


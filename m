Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1763E63BE
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 13:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175181; cv=none; b=ljVJ3+CiRCLP16FYXZ6vsjjcYKgXjfKzRtefFL/YjHm/RHeL7qW3VvjixXNmy6SsxXF8+mnEIVZXSctpM+Ena1bTB4CTngWtXHgz5M4PxkDPvPmnZ03dkXreeFGN8/kOkX7uODl1HqXk4L1m644lNoGTGvE7Z7tUAs2TlrwAp3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175181; c=relaxed/simple;
	bh=g3YXL5FcmZFpCfk3kiuvyTCmHs42eYpGg/8tqgksBH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKJiFN6VBBJtdEydzcf1epwzsKftPSuXEAvJAx8bKbDjUt/rGSqJ/5vcc+sr+6Xo3RJfyWRQUQ5KM9c9ROFU8FqcYIRzHl1UCuspg4HYbN1mWHDGnLXvO2Megz5TlmKWzahzV8VDjORar9TyIiWFawAmWs9HnhGA8ghn2dGKbjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eD3/s3K7; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eD3/s3K7"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2aae146b604so40156745ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 06:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776175175; x=1776779975; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KsASeMOZ5yiQGBruk1f55BCUx00Dy0wjtngHst/RMag=;
        b=eD3/s3K7hnAA834OIZ07RGIWKqZSuCgG3VLZL4D+IXyYxxqdxdAY+SY1mmznZZgEqh
         OusK15lnz6+Em9PycGvvFwkoci6okr/YvvB5W3UUgOxbWpB2EJP7Iq7mmkQSS865mDfo
         UUg9MULpwaOi85RfNigukwdp7rjWm/bOF86xIynecXx6ia2eW6PLpgQABAb99BAjGVW6
         rlky9mYlxJ1lq95cmgCAC7nQ1jNZH6ILkh7GsBZePqmhJt2YHx8j4FECoe+Tt4gUCls7
         AmrxkyddS1pCL/76ksUTxTT2QJWOtBelM4oC2zWkMg4DWK2Ct8h47yRE2opOwyHlf/QT
         1HpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776175175; x=1776779975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KsASeMOZ5yiQGBruk1f55BCUx00Dy0wjtngHst/RMag=;
        b=lkYlHWWhJN8/9YeVilP6h+QGsncMGzUrXqZ8u050FAWvvM1pgZFdyUi8vIpRNfDqsM
         GTmWZ+ZUg5swpLbjk/gsdS5ICCZ6eIHbT6Z43Pfx1ktooyeD8LO1JwsfjN90k4nYPyTQ
         90eaEf9gq2Sg4TB5vL66Q5vGKpH63dDgaJOETVYlYIWjAd222ImArjGB2KkRPOszfTWH
         9Y8e+VSe7iEPt7UArLm8LDz3kiiSYmt7xFN0UgbYK+bVjQxxpDBtYRtIfHwAFf/p3xXU
         SuB6gpEt5SPUtzgCIgkudk0efePc29oH6ru9PEtKzfuM8P2EuOaQS1D5htMlKbfrd896
         Kx7g==
X-Gm-Message-State: AOJu0YzX31FtyAUdBOjKXh6OtVirVRI9Amgsb4E3v8G3zBWU3qd+cHrP
	1ep5P8bza19FlBgzWaOtv/NZLQJzpLXu9FqmFh+OsyHi/ICp7UYYbongxg43fumMpBQ=
X-Gm-Gg: AeBDievQA9CQhqO2B4O39V/RO1jIweBDMrFcZH/qxr4b6OAOAv5o9nxdzBRhBsOs7Ia
	UM86V9sGu43ZzdVy0ng3Ok/IJt0ygcnWoNi/jcQFvPPs0TXfwK6vVq4b4kAG3gLqSF3pkUL0LUa
	zRDAyRfRXIq657O79Jmi1Vd7VSJcY0QTDIiYQZd1Jv56mo0ZHNRcLzSoAsYVciPLGJMn0mNN8N2
	4D0MbeyH8K86m3YuauFmiQrachOAc9llheTZej5rhXkDCeGfjTlq3lbH7ervp5BiQHu4nxNe8qm
	6UuTWk/JnQfIdvy8xuYYYEzrk/SFQhAdFM9f1iMGzp2miNnFRIzWBLOkElBURp0iFL+K+vlyhPp
	S+4c09efgExJ2qVY+zmUORXmye+7tUH6QjwE9r/UUzZGcbftl4H9ISu3Tat34wDgK2aADA3+sib
	3VPyDqti+Z4RQHu+OMyxNGeqe4OuAdLQOnC+wxPke0UdyuVqa89Y1H
X-Received: by 2002:a17:902:b612:b0:2b0:6475:73d0 with SMTP id d9443c01a7336-2b2d5976825mr140931695ad.12.1776175175042;
        Tue, 14 Apr 2026 06:59:35 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.184])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4612e60dasm59779895ad.38.2026.04.14.06.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 06:59:34 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 6/7] cifs: optimize readdir for larger directories
Date: Tue, 14 Apr 2026 19:29:17 +0530
Message-ID: <20260414135918.279802-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260414135918.279802-1-sprasad@microsoft.com>
References: <20260414135918.279802-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Today QueryDirectory uses the compound_send_recv infrastructure
which is limited to 16KB in size. As a result, readdir of large
directories generally take several round trips.

With this change, if the readdir needs a QueryDir after the first
round-trip (meaning that there are more dirents to read), then the
following QueryDirs will now switch to using larger buffers with
MTU credits.

Till now, the only command type that used this flow was SMB2_READ.
In case of encrypted response, it becomes challenging to decide if
the response is for SMB2_READ or SMB2_READDIR. This change reuses
receive_encrypted_read and after decrypting the response decides
the handling function based on the command in the resp header. That
way, care has been taken to ensure that the read code path
modifications on account of this change are kept to a minimum.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h  |  23 +-
 fs/smb/client/cifsproto.h |   3 +
 fs/smb/client/readdir.c   |   2 +-
 fs/smb/client/smb1ops.c   |   4 +-
 fs/smb/client/smb2misc.c  |   7 +-
 fs/smb/client/smb2ops.c   | 452 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2pdu.c   | 182 ++++++++++++++-
 fs/smb/client/smb2pdu.h   |   3 +
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/client/trace.h     |   1 +
 fs/smb/client/transport.c | 184 ++++++++++++++++
 11 files changed, 829 insertions(+), 35 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8d089ba08e3e5..45de35ecc0bd2 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -504,7 +504,7 @@ struct smb_version_operations {
 			       struct cifs_search_info *);
 	/* continue readdir */
 	int (*query_dir_next)(const unsigned int, struct cifs_tcon *,
-			      struct cifs_fid *,
+			      struct cifs_sb_info *, struct cifs_fid *,
 			      __u16, struct cifs_search_info *srch_inf);
 	/* close dir */
 	int (*close_dir)(const unsigned int, struct cifs_tcon *,
@@ -1397,6 +1397,27 @@ struct cifs_search_info {
 	bool is_dynamic_buf:1; /* dynamically allocated buffer - can be variable size */
 };
 
+/* Structure for QueryDirectory with multi-credit support */
+struct cifs_query_dir_io {
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	struct cifs_search_info *srch_inf;
+	unsigned int xid;
+	u64 persistent_fid;
+	u64 volatile_fid;
+	int index;
+	struct kvec combined_iov;	/* Pre-allocated combined header+data buffer;
+					 * iov_len holds total capacity until the receive
+					 * handler fills it in, then actual valid length */
+	struct completion done;
+	int result;
+	struct cifs_credits credits;
+	bool replay;
+	unsigned int retries;
+	unsigned int cur_sleep;
+	struct kvec iov[2];		/* For response handling */
+};
+
 #define ACL_NO_MODE	((umode_t)(-1))
 struct cifs_open_parms {
 	struct cifs_tcon *tcon;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 884bfa1cf0b42..bbbee0ef09443 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -336,6 +336,9 @@ struct cifs_ses *cifs_get_smb_ses(struct TCP_Server_Info *server,
 int cifs_readv_receive(struct TCP_Server_Info *server,
 		       struct mid_q_entry *mid);
 
+int cifs_query_dir_receive(struct TCP_Server_Info *server,
+			    struct mid_q_entry *mid);
+
 int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 			  struct cifs_sb_info *cifs_sb,
 			  const unsigned char *path, char *pbuf,
diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index b50efd9b9e1d2..8a444f97e0ae9 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -760,7 +760,7 @@ find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon, loff_t pos,
 	while ((index_to_find >= cfile->srch_inf.index_of_last_entry) &&
 	       (rc == 0) && !cfile->srch_inf.endOfSearch) {
 		cifs_dbg(FYI, "calling findnext2\n");
-		rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
+		rc = server->ops->query_dir_next(xid, tcon, cifs_sb, &cfile->fid,
 						 search_flags,
 						 &cfile->srch_inf);
 		if (rc)
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 9694117050a6c..860a9b23a2f8d 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1135,8 +1135,8 @@ cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 cifs_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
-		    struct cifs_fid *fid, __u16 search_flags,
-		    struct cifs_search_info *srch_inf)
+		    struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
+		    __u16 search_flags, struct cifs_search_info *srch_inf)
 {
 	return CIFSFindNext(xid, tcon, fid->netfid, search_flags, srch_inf);
 }
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 973fce3c959c4..b7b6ecd5fdaee 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -12,6 +12,7 @@
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "smb2proto.h"
+#include "smb2pdu.h"
 #include "cifs_debug.h"
 #include "cifs_unicode.h"
 #include "../common/smb2status.h"
@@ -316,7 +317,7 @@ char *
 smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 {
 	const int max_off = 4096;
-	const int max_len = 128 * 1024;
+	int max_len = 128 * 1024;
 
 	*off = 0;
 	*len = 0;
@@ -367,6 +368,10 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *shdr)
 		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferOffset);
 		*len = le32_to_cpu(
 		  ((struct smb2_query_directory_rsp *)shdr)->OutputBufferLength);
+		/* Allow larger buffers for query directory (up to 2MB).
+		 * The actual data is handled separately in cifs_query_dir_receive().
+		 */
+		max_len = SMB2_MAX_QD_DATABUF_SIZE;
 		break;
 	case SMB2_IOCTL:
 		*off = le32_to_cpu(
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 5c6fe25204d26..ecbd717f5a5ea 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2703,11 +2703,130 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
 static int
 smb2_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
-		    struct cifs_fid *fid, __u16 search_flags,
-		    struct cifs_search_info *srch_inf)
+		    struct cifs_sb_info *cifs_sb, struct cifs_fid *fid,
+		    __u16 search_flags, struct cifs_search_info *srch_inf)
 {
-	return SMB2_query_directory(xid, tcon, fid->persistent_fid,
-				    fid->volatile_fid, 0, srch_inf);
+	struct cifs_query_dir_io qd_io;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	size_t buf_size;
+	int rc;
+	int resp_buftype = CIFS_DYNAMIC_BUFFER;
+
+	/* Pick server and determine buffer size based on negotiated rsize */
+	server = cifs_pick_channel(ses);
+	if (!server)
+		return smb_EIO(smb_eio_trace_null_pointers);
+
+	/* Negotiate rsize if not already set */
+	if (cifs_sb->ctx->rsize == 0)
+		cifs_negotiate_rsize(server, cifs_sb->ctx, tcon);
+
+	/* Use negotiated rsize for buffer size, with reasonable limits */
+	buf_size = cifs_sb->ctx->rsize;
+
+	cifs_dbg(FYI, "%s: using buffer size %zu (rsize=%u, encrypted=%d)\n",
+		 __func__, buf_size, cifs_sb->ctx->rsize, smb3_encryption_required(tcon));
+
+	/* Initialize qd_io structure */
+	memset(&qd_io, 0, sizeof(qd_io));
+	qd_io.tcon = tcon;
+	qd_io.server = server;
+	qd_io.srch_inf = srch_inf;
+	qd_io.xid = xid;
+	qd_io.persistent_fid = fid->persistent_fid;
+	qd_io.volatile_fid = fid->volatile_fid;
+	qd_io.index = 0;
+	qd_io.result = 0;
+	qd_io.replay = false;
+	qd_io.retries = 0;
+	qd_io.cur_sleep = 0;
+
+	/* Allocate credits for the buffer size */
+	rc = server->ops->wait_mtu_credits(server, buf_size, &buf_size,
+					   &qd_io.credits);
+	if (rc) {
+		cifs_dbg(VFS, "%s: failed to get credits: %d\n", __func__, rc);
+		return rc;
+	}
+
+	cifs_dbg(FYI, "%s: allocated %u credits for %zu bytes\n",
+		 __func__, qd_io.credits.value, buf_size);
+
+	/* Send query directory with large buffer and wait for completion */
+	rc = SMB2_query_directory_large(&qd_io, buf_size);
+	if (rc) {
+		if (rc == -ENODATA) {
+			const struct smb2_hdr *hdr = NULL;
+
+			if (qd_io.combined_iov.iov_base)
+				hdr = (const struct smb2_hdr *)qd_io.combined_iov.iov_base;
+			else if (qd_io.iov[0].iov_base)
+				hdr = (const struct smb2_hdr *)qd_io.iov[0].iov_base;
+
+			/*
+			 * ENODATA from QUERY_DIRECTORY generally means enumeration reached
+			 * the end. Treat it as end-of-search even if the header buffer is
+			 * unavailable in this async path.
+			 */
+			if (!hdr) {
+				cifs_dbg(FYI, "%s: ENODATA but hdr is NULL\n", __func__);
+			} else {
+				cifs_dbg(FYI, "%s: ENODATA with hdr->Status=0x%x (STATUS_NO_MORE_FILES=0x%x)\n",
+					 __func__, le32_to_cpu(hdr->Status), le32_to_cpu(STATUS_NO_MORE_FILES));
+			}
+
+			if (hdr && hdr->Status == STATUS_NO_MORE_FILES) {
+				trace_smb3_query_dir_done(xid, fid->persistent_fid,
+					tcon->tid, tcon->ses->Suid, 0, 0);
+				srch_inf->endOfSearch = true;
+				rc = 0;
+			} else {
+				cifs_dbg(FYI, "%s: ENODATA but Status mismatch - not treating as end-of-search\n", __func__);
+				trace_smb3_query_dir_err(xid, fid->persistent_fid,
+					tcon->tid, tcon->ses->Suid, 0, 0, rc);
+			}
+		} else {
+			trace_smb3_query_dir_err(xid, fid->persistent_fid,
+				tcon->tid, tcon->ses->Suid, 0, 0, rc);
+		}
+		goto qdir_next_exit;
+	}
+
+	/* Parse the response using the combined buffer built in receive handler */
+	if (qd_io.combined_iov.iov_len > 0) {
+		rc = smb2_parse_query_directory(tcon, &qd_io.combined_iov, resp_buftype,
+						srch_inf);
+		if (rc) {
+			trace_smb3_query_dir_err(xid, fid->persistent_fid,
+				tcon->tid, tcon->ses->Suid, 0, 0, rc);
+			kfree(qd_io.combined_iov.iov_base);
+			qd_io.combined_iov.iov_base = NULL;
+			goto qdir_next_exit;
+		}
+
+		/* combined_iov.iov_base ownership transferred to srch_inf->ntwrk_buf_start */
+		qd_io.combined_iov.iov_base = NULL;
+
+		trace_smb3_query_dir_done(xid, fid->persistent_fid,
+			tcon->tid, tcon->ses->Suid, 0,
+			srch_inf->entries_in_buffer);
+	}
+
+qdir_next_exit:
+	/* Free the data buffer if not transferred to srch_inf */
+	kfree(qd_io.combined_iov.iov_base);
+
+	/* Return credits if we still have them (they should have been cleared in callback) */
+	if (qd_io.credits.value != 0) {
+		trace_smb3_rw_credits(0, 0, 0,
+				      server->credits, server->in_flight,
+				      qd_io.credits.value,
+				      cifs_trace_rw_credits_query_dir_done);
+		add_credits(server, &qd_io.credits, 0);
+	}
+
+	return rc;
 }
 
 static int
@@ -4824,6 +4943,247 @@ cifs_copy_folioq_to_iter(struct folio_queue *folioq, size_t data_size,
 	return 0;
 }
 
+static int
+cifs_copy_folioq_to_buf(struct folio_queue *folioq, size_t total_size,
+			size_t skip, char *buf, size_t buf_len)
+{
+	size_t copied = 0;
+
+	if (buf_len > total_size - skip)
+		buf_len = total_size - skip;
+
+	for (; folioq; folioq = folioq->next) {
+		for (int s = 0; s < folioq_count(folioq); s++) {
+			struct folio *folio = folioq_folio(folioq, s);
+			size_t fsize = folio_size(folio);
+			size_t len = umin(fsize - skip, buf_len);
+
+			if (len == 0)
+				break;
+
+			memcpy_from_folio(buf + copied, folio, skip, len);
+			copied += len;
+			buf_len -= len;
+			skip = 0;
+
+			if (buf_len == 0)
+				return 0;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * Handle encrypted QueryDirectory response data.
+ * Called only for encrypted responses where mid->decrypted == true.
+ * For unencrypted responses, cifs_query_dir_receive handles everything.
+ *
+ * This is written in such a way that handle_read_data does not need modification.
+ *
+ * buf: contains read_rsp_size bytes of decrypted response
+ * buffer: contains (total_len - read_rsp_size) bytes of decrypted data
+ *
+ * Since sizeof(struct smb2_query_directory_rsp) < read_rsp_size,
+ * the response header is always fully in buf. Data may be split between
+ * buf and buffer depending on data_offset.
+ */
+static int
+handle_query_dir_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+		      char *buf, unsigned int buf_len, struct folio_queue *buffer,
+		      unsigned int buffer_len, bool is_offloaded)
+{
+	struct cifs_query_dir_io *qd_io = mid->callback_data;
+	struct smb2_query_directory_rsp *rsp;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)buf;
+	unsigned int data_offset, data_len;
+	unsigned int hdr_len;
+
+	cifs_dbg(FYI, "%s: processing encrypted QueryDirectory response\n", __func__);
+
+	if (shdr->Command != SMB2_QUERY_DIRECTORY) {
+		cifs_server_dbg(VFS, "only QueryDirectory responses are supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	if (server->ops->is_session_expired &&
+	    server->ops->is_session_expired(buf)) {
+		if (!is_offloaded)
+			cifs_reconnect(server, true);
+		return -1;
+	}
+
+	if (server->ops->is_status_pending &&
+			server->ops->is_status_pending(buf, server))
+		return -1;
+
+	rsp = (struct smb2_query_directory_rsp *)buf;
+	hdr_len = min_t(unsigned int, buf_len,
+			 sizeof(struct smb2_query_directory_rsp));
+
+	/* Map error code first */
+	qd_io->result = server->ops->map_error(buf, false);
+
+	/* Get data_offset early to set up iov properly */
+	data_offset = le16_to_cpu(rsp->OutputBufferOffset);
+	data_len = le32_to_cpu(rsp->OutputBufferLength);
+
+	/* Set up first iov to point to header portion (needed for credits/signature) */
+	qd_io->iov[0].iov_base = buf;
+	qd_io->iov[0].iov_len = qd_io->result ? hdr_len : data_offset;
+
+	if (qd_io->result != 0) {
+		cifs_dbg(FYI, "%s: server returned error %d (Status=0x%x)\n",
+			 __func__, qd_io->result, le32_to_cpu(rsp->hdr.Status));
+
+		/* Copy header to persistent combined_iov buffer so status
+		 * remains accessible after receive handler returns. buf is temporary
+		 * and will be freed/reused, so we can't leave iov[0] pointing to it. */
+		if (qd_io->combined_iov.iov_base && hdr_len > 0 &&
+		    hdr_len <= qd_io->combined_iov.iov_len) {
+			memcpy(qd_io->combined_iov.iov_base, buf, hdr_len);
+			qd_io->iov[0].iov_base = qd_io->combined_iov.iov_base;
+			qd_io->iov[0].iov_len = hdr_len;
+			cifs_dbg(FYI, "%s: copied error response header to combined_iov\n", __func__);
+		}
+
+		/* Normal error on query_directory response - response received successfully,
+		 * but the command failed. Store error in qd_io->result for callback. */
+		if (is_offloaded)
+			mid->mid_state = MID_RESPONSE_RECEIVED;
+		else
+			dequeue_mid(server, mid, false);
+		return 0;
+	}
+
+	/* Success - parse the response data */
+	cifs_dbg(FYI, "%s: data_offset=%u data_len=%u buf_len=%u buffer_len=%u\n",
+		 __func__, data_offset, data_len, buf_len, buffer_len);
+
+	/* Validate data_offset */
+	if (data_offset < sizeof(struct smb2_query_directory_rsp)) {
+		cifs_dbg(FYI, "%s: data offset (%u) inside response header\n",
+			 __func__, data_offset);
+		data_offset = sizeof(struct smb2_query_directory_rsp);
+	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		cifs_dbg(VFS, "%s: data offset (%u) beyond end of smallbuf\n",
+			 __func__, data_offset);
+		qd_io->result = -EIO;
+		dequeue_mid(server, mid, qd_io->result);
+		return qd_io->result;
+	}
+
+	/* Validate data_offset is within buf_len + buffer_len */
+	if (data_offset > buf_len + buffer_len) {
+		cifs_dbg(VFS, "%s: data offset (%u) beyond response length (%u)\n",
+			 __func__, data_offset, buf_len + buffer_len);
+		qd_io->result = -EIO;
+		dequeue_mid(server, mid, qd_io->result);
+		return qd_io->result;
+	}
+
+	/* Validate response fits in pre-allocated combined buffer */
+	if ((size_t)data_offset + data_len > qd_io->combined_iov.iov_len) {
+		cifs_dbg(VFS, "%s: response (%u + %u) exceeds buffer capacity (%zu)\n",
+			 __func__, data_offset, data_len, qd_io->combined_iov.iov_len);
+		qd_io->result = -EIO;
+		dequeue_mid(server, mid, qd_io->result);
+		return qd_io->result;
+	}
+
+	/* Copy the prefix present in buf into combined_iov, preserving wire layout */
+	memcpy(qd_io->combined_iov.iov_base, buf, min(data_offset, buf_len));
+
+	if (data_offset < buf_len) {
+		/* Data starts in buf, may continue into buffer */
+		unsigned int data_in_buf = buf_len - data_offset;
+		unsigned int data_in_buffer;
+
+		if (data_len <= data_in_buf) {
+			/* All data is in buf */
+			memcpy(qd_io->combined_iov.iov_base + data_offset,
+			       buf + data_offset, data_len);
+		} else {
+			/* Copy from buf first */
+			memcpy(qd_io->combined_iov.iov_base + data_offset,
+			       buf + data_offset, data_in_buf);
+
+			/* Copy remainder from buffer at offset 0 */
+			data_in_buffer = data_len - data_in_buf;
+			if (data_in_buffer > buffer_len) {
+				cifs_dbg(VFS, "%s: data_in_buffer (%u) > buffer_len (%u)\n",
+					 __func__, data_in_buffer, buffer_len);
+				qd_io->result = -EIO;
+				dequeue_mid(server, mid, qd_io->result);
+				return qd_io->result;
+			}
+
+			qd_io->result = cifs_copy_folioq_to_buf(buffer, buffer_len, 0,
+								qd_io->combined_iov.iov_base +
+								data_offset + data_in_buf,
+								data_in_buffer);
+			if (qd_io->result != 0) {
+				cifs_dbg(VFS, "%s: failed to copy from folio_queue: %d\n",
+					 __func__, qd_io->result);
+				dequeue_mid(server, mid, qd_io->result);
+				return qd_io->result;
+			}
+		}
+	} else {
+		/* Padding and data are in buffer starting at offset 0 */
+		unsigned int bytes_in_buffer = data_offset - buf_len + data_len;
+
+		if (bytes_in_buffer > buffer_len) {
+			cifs_dbg(VFS, "%s: data beyond buffer: prefix+len=%u buffer_len=%u\n",
+				 __func__, bytes_in_buffer, buffer_len);
+			qd_io->result = -EIO;
+			dequeue_mid(server, mid, qd_io->result);
+			return qd_io->result;
+		}
+
+		qd_io->result = cifs_copy_folioq_to_buf(buffer, buffer_len, 0,
+							qd_io->combined_iov.iov_base + buf_len,
+							bytes_in_buffer);
+		if (qd_io->result != 0) {
+			cifs_dbg(VFS, "%s: failed to copy from folio_queue: %d\n",
+				 __func__, qd_io->result);
+			dequeue_mid(server, mid, qd_io->result);
+			return qd_io->result;
+		}
+	}
+
+	/* Set up iov[1] pointing into combined buffer, finalize valid length */
+	qd_io->iov[1].iov_base = qd_io->combined_iov.iov_base + data_offset;
+	qd_io->iov[1].iov_len = data_len;
+	qd_io->combined_iov.iov_len = data_offset + data_len;
+
+	dequeue_mid(server, mid, false);
+	return 0;
+}
+
+/*
+ * Handle callback for async QueryDirectory with multi-credit support.
+ * For encrypted responses, extracts decrypted data.
+ * For unencrypted responses, cifs_query_dir_receive already processed everything.
+ */
+int
+smb2_query_dir_handle_data(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	char *buf = server->large_buf ? server->bigbuf : server->smallbuf;
+
+	/* For unencrypted responses, data already processed in cifs_query_dir_receive */
+	if (!mid->decrypted)
+		return 0;
+
+	/*
+	 * For small encrypted responses (< CIFSMaxBufSize), all data is in buf.
+	 * For large encrypted responses, this callback is not used - instead,
+	 * receive_encrypted_read/smb2_decrypt_offload call handle_query_dir_data directly.
+	 */
+	return handle_query_dir_data(server, mid, buf, server->pdu_size,
+				      NULL, 0, false);
+}
+
 static int
 handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		 char *buf, unsigned int buf_len, struct folio_queue *buffer,
@@ -4987,25 +5347,46 @@ static void smb2_decrypt_offload(struct work_struct *work)
 	int rc;
 	struct mid_q_entry *mid;
 	struct iov_iter iter;
+	struct smb2_hdr *shdr;
+	unsigned int read_rsp_size = dw->server->vals->read_rsp_size;
 
+	/* decrypt read_rsp_size in buf + remainder in folio_queue */
 	iov_iter_folio_queue(&iter, ITER_DEST, dw->buffer, 0, 0, dw->len);
-	rc = decrypt_raw_data(dw->server, dw->buf, dw->server->vals->read_rsp_size,
-			      &iter, true);
+	rc = decrypt_raw_data(dw->server, dw->buf, read_rsp_size, &iter, true);
 	if (rc) {
 		cifs_dbg(VFS, "error decrypting rc=%d\n", rc);
 		goto free_pages;
 	}
 
 	dw->server->lstrp = jiffies;
+
+	shdr = (struct smb2_hdr *)(dw->buf + sizeof(struct smb2_transform_hdr));
+
+	/*
+	 * buf now contains read_rsp_size bytes after transform_hdr.
+	 * folio_queue contains (total_len - read_rsp_size) bytes.
+	 * The handle functions will determine where data actually starts based on data_offset.
+	 */
+
 	mid = smb2_find_dequeue_mid(dw->server, dw->buf);
 	if (mid == NULL)
 		cifs_dbg(FYI, "mid not found\n");
 	else {
 		mid->decrypted = true;
-		rc = handle_read_data(dw->server, mid, dw->buf,
-				      dw->server->vals->read_rsp_size,
-				      dw->buffer, dw->len,
-				      true);
+
+		/* Handle based on command type */
+		if (le16_to_cpu(shdr->Command) == SMB2_READ) {
+			rc = handle_read_data(dw->server, mid, dw->buf, read_rsp_size,
+					      dw->buffer, dw->len, true);
+		} else if (le16_to_cpu(shdr->Command) == SMB2_QUERY_DIRECTORY) {
+			rc = handle_query_dir_data(dw->server, mid, dw->buf, read_rsp_size,
+						   dw->buffer, dw->len, true);
+		} else {
+			cifs_dbg(VFS, "Unexpected command %u in decrypt offload\n",
+				 le16_to_cpu(shdr->Command));
+			rc = -EOPNOTSUPP;
+		}
+
 		if (rc >= 0) {
 #ifdef CONFIG_CIFS_STATS2
 			mid->when_received = jiffies;
@@ -5049,9 +5430,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 {
 	char *buf = server->smallbuf;
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
+	struct smb2_hdr *shdr;
 	struct iov_iter iter;
-	unsigned int len;
-	unsigned int buflen = server->pdu_size;
+	unsigned int len, total_len, buflen = server->pdu_size;
+	unsigned int read_rsp_size = server->vals->read_rsp_size;
 	int rc;
 	struct smb2_decrypt_work *dw;
 
@@ -5062,7 +5444,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	dw->server = server;
 
 	*num_mids = 1;
-	len = min_t(unsigned int, buflen, server->vals->read_rsp_size +
+	total_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+
+	/* Read transform_hdr + read_rsp_size into buf */
+	len = min_t(unsigned int, buflen, read_rsp_size +
 		sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) + 1;
 
 	rc = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1, len);
@@ -5070,9 +5455,8 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_dw;
 	server->total_read += rc;
 
-	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
-		server->vals->read_rsp_size;
-	dw->len = len;
+	/* Read remaining data into folio_queue */
+	dw->len = total_len - read_rsp_size;
 	len = round_up(dw->len, PAGE_SIZE);
 
 	size_t cur_size = 0;
@@ -5101,7 +5485,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_pages;
 
 	/*
-	 * For large reads, offload to different thread for better performance,
+	 * For large responses, offload to different thread for better performance,
 	 * use more cores decrypting which can be expensive
 	 */
 
@@ -5115,20 +5499,41 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		return -1;
 	}
 
-	rc = decrypt_raw_data(server, buf, server->vals->read_rsp_size,
-			      &iter, false);
+	/* Decrypt: read_rsp_size in buf + remainder in folio_queue */
+	rc = decrypt_raw_data(server, buf, read_rsp_size, &iter, false);
 	if (rc)
 		goto free_pages;
 
+	shdr = (struct smb2_hdr *) buf;
+
+	/*
+	 * buf now contains the complete response header (read_rsp_size bytes).
+	 * folio_queue contains (total_len - read_rsp_size) bytes.
+	 * The handle functions will determine where data actually starts based on data_offset.
+	 */
+
 	*mid = smb2_find_mid(server, buf);
 	if (*mid == NULL) {
 		cifs_dbg(FYI, "mid not found\n");
 	} else {
-		cifs_dbg(FYI, "mid found\n");
+		cifs_dbg(FYI, "mid found, command=%u\n", le16_to_cpu(shdr->Command));
 		(*mid)->decrypted = true;
-		rc = handle_read_data(server, *mid, buf,
-				      server->vals->read_rsp_size,
-				      dw->buffer, dw->len, false);
+
+		/* Handle based on command type */
+		if (le16_to_cpu(shdr->Command) == SMB2_READ) {
+			rc = handle_read_data(server, *mid, buf, read_rsp_size,
+					      dw->buffer, dw->len, false);
+		} else if (le16_to_cpu(shdr->Command) == SMB2_QUERY_DIRECTORY) {
+			rc = handle_query_dir_data(server, *mid, buf, read_rsp_size,
+						   dw->buffer, dw->len, false);
+		} else {
+			/* For now, other commands not supported in large encrypted path */
+			cifs_server_dbg(VFS,
+					"Large encrypted responses only supported for SMB2_READ and SMB2_QUERY_DIRECTORY (got %u)\n",
+					le16_to_cpu(shdr->Command));
+			rc = -EOPNOTSUPP;
+		}
+
 		if (rc >= 0) {
 			if (server->ops->is_network_name_deleted) {
 				server->ops->is_network_name_deleted(buf,
@@ -5269,7 +5674,6 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 		return -ECONNABORTED;
 	}
 
-	/* TODO: add support for compounds containing READ. */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
 		return receive_encrypted_read(server, &mids[0], num_mids);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2d55246d2851b..b59d99d5e193a 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5496,6 +5496,182 @@ num_entries(int infotype, char *bufstart, char *end_of_buf, char **lastentry,
 	return entrycount;
 }
 
+/*
+ * Callback for async QueryDirectory with multi-credit support
+ */
+static void
+smb2_query_dir_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	struct cifs_query_dir_io *qd_io = mid->callback_data;
+	struct cifs_tcon *tcon = qd_io->tcon;
+	struct smb2_hdr *shdr = (struct smb2_hdr *)qd_io->iov[0].iov_base;
+	struct cifs_credits credits = {
+		.value = 0,
+		.instance = 0,
+	};
+
+	WARN_ONCE(qd_io->server != server,
+		  "qd_io server %p != mid server %p",
+		  qd_io->server, server);
+
+	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d\n",
+		 __func__, mid->mid, mid->mid_state, qd_io->result);
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		credits.value = le16_to_cpu(shdr->CreditRequest);
+		credits.instance = server->reconnect_instance;
+		/* result already set, check signature if needed */
+		if (server->sign && !mid->decrypted) {
+			int rc;
+			struct smb_rqst rqst = { .rq_iov = &qd_io->iov[0], .rq_nvec = 1 };
+
+			rc = smb2_verify_signature(&rqst, server);
+			if (rc) {
+				cifs_tcon_dbg(VFS, "QueryDir signature verification returned error = %d\n",
+					      rc);
+				qd_io->result = rc;
+			}
+		}
+		break;
+	case MID_REQUEST_SUBMITTED:
+	case MID_RETRY_NEEDED:
+		qd_io->result = -EAGAIN;
+		break;
+	case MID_RESPONSE_MALFORMED:
+		credits.value = le16_to_cpu(shdr->CreditRequest);
+		credits.instance = server->reconnect_instance;
+		qd_io->result = smb_EIO(smb_eio_trace_read_rsp_malformed);
+		break;
+	default:
+		qd_io->result = smb_EIO1(smb_eio_trace_read_mid_state_unknown,
+					 mid->mid_state);
+		break;
+	}
+
+	if (qd_io->result && qd_io->result != -ENODATA)
+		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
+
+	trace_smb3_rw_credits(0, 0, qd_io->credits.value,
+			      server->credits, server->in_flight,
+			      0, cifs_trace_rw_credits_read_response_clear);
+	qd_io->credits.value = 0;
+	release_mid(server, mid);
+	trace_smb3_rw_credits(0, 0, 0,
+			      server->credits, server->in_flight,
+			      credits.value, cifs_trace_rw_credits_read_response_add);
+	add_credits(server, &credits, 0);
+
+	complete(&qd_io->done);
+}
+
+/*
+ * QueryDirectory with large buffer and multi-credit support.
+ * Uses async infrastructure but waits for completion synchronously.
+ */
+int
+SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsigned int buf_size)
+{
+	int rc, flags = 0;
+	char *buf;
+	struct smb2_hdr *shdr;
+	struct smb_rqst rqst = { .rq_iov = &qd_io->iov[0],
+				 .rq_nvec = SMB2_QUERY_DIRECTORY_IOV_SIZE };
+	struct TCP_Server_Info *server = qd_io->server;
+	struct cifs_tcon *tcon = qd_io->tcon;
+	unsigned int total_len;
+	int credit_request;
+
+	cifs_dbg(FYI, "%s: buf_size=%u\n", __func__, buf_size);
+
+	/* Cap buffer size to avoid kmalloc failures for very large allocations.
+	 * SMB2_MAX_QD_DATABUF_SIZE is a safe limit that stays well below typical
+	 * kmalloc constraints while still allowing large directory listings.
+	 */
+	if (buf_size > SMB2_MAX_QD_DATABUF_SIZE)
+		buf_size = SMB2_MAX_QD_DATABUF_SIZE;
+
+	/* Allocate response buffer. Since we'll build a combined header+data buffer,
+	 * we need space for both. We'll request a slightly smaller OutputBufferLength
+	 * from the server to ensure the total response fits.
+	 */
+	qd_io->combined_iov.iov_base = kmalloc(buf_size, GFP_KERNEL);
+	if (!qd_io->combined_iov.iov_base)
+		return -ENOMEM;
+	/* Store total capacity in iov_len; updated to actual data length by receive handler */
+	qd_io->combined_iov.iov_len = buf_size;
+
+	/* Initialize completion */
+	init_completion(&qd_io->done);
+
+	/* Request less data from server to leave room for the response header.
+	 * Use MAX_CIFS_SMALL_BUFFER_SIZE as a safety margin.
+	 */
+	rc = SMB2_query_directory_init(qd_io->xid, tcon, server,
+				       &rqst, qd_io->persistent_fid,
+				       qd_io->volatile_fid, qd_io->index,
+				       qd_io->srch_inf->info_level,
+				       buf_size - MAX_CIFS_SMALL_BUFFER_SIZE);
+	if (rc) {
+		kfree(qd_io->combined_iov.iov_base);
+		qd_io->combined_iov.iov_base = NULL;
+		return rc;
+	}
+
+	if (smb3_encryption_required(tcon))
+		flags |= CIFS_TRANSFORM_REQ;
+
+	buf = rqst.rq_iov[0].iov_base;
+	total_len = rqst.rq_iov[0].iov_len;
+
+	shdr = (struct smb2_hdr *)buf;
+
+	if (qd_io->replay) {
+		/* Back-off before retry */
+		if (qd_io->cur_sleep)
+			msleep(qd_io->cur_sleep);
+		smb2_set_replay(server, &rqst);
+	}
+
+	/* Set credit charge based on buffer size */
+	if (qd_io->credits.value > 0) {
+		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(buf_size,
+						SMB2_MAX_BUFFER_SIZE));
+		credit_request = le16_to_cpu(shdr->CreditCharge) + 8;
+		if (server->credits >= server->max_credits)
+			shdr->CreditRequest = cpu_to_le16(0);
+		else
+			shdr->CreditRequest = cpu_to_le16(
+				min_t(int, server->max_credits -
+						server->credits, credit_request));
+
+		flags |= CIFS_HAS_CREDITS;
+	}
+
+	rc = cifs_call_async(server, &rqst,
+			     cifs_query_dir_receive, smb2_query_dir_callback,
+			     smb2_query_dir_handle_data, qd_io, flags,
+			     &qd_io->credits);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2_QUERY_DIRECTORY_HE);
+		trace_smb3_query_dir_err(qd_io->xid, qd_io->persistent_fid,
+					 tcon->tid, tcon->ses->Suid,
+					 qd_io->index, 0, rc);
+		kfree(qd_io->combined_iov.iov_base);
+		qd_io->combined_iov.iov_base = NULL;
+	}
+
+	/* Free request buffer immediately after async call */
+	cifs_small_buf_release(buf);
+
+	if (rc)
+		return rc;
+
+	/* Wait for the async operation to complete */
+	wait_for_completion(&qd_io->done);
+	return qd_io->result;
+}
+
 /*
  * Readdir/FindFirst
  */
@@ -5560,12 +5736,6 @@ int SMB2_query_directory_init(const unsigned int xid,
 	req->FileNameOffset =
 		cpu_to_le16(sizeof(struct smb2_query_directory_req));
 	req->FileNameLength = cpu_to_le16(len);
-	/*
-	 * BB could be 30 bytes or so longer if we used SMB2 specific
-	 * buffer lengths, but this is safe and close enough.
-	 */
-	output_size = min_t(unsigned int, output_size, server->maxBuf);
-	output_size = min_t(unsigned int, output_size, 2 << 15);
 	req->OutputBufferLength = cpu_to_le32(output_size);
 
 	iov[0].iov_base = (char *)req;
diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
index 7b7a864520c68..843e30c1ecc61 100644
--- a/fs/smb/client/smb2pdu.h
+++ b/fs/smb/client/smb2pdu.h
@@ -132,6 +132,9 @@ struct share_redirect_error_context_rsp {
 /* Size of the minimal QueryDir response for checking if more data exists */
 #define SMB2_QD2_RESPONSE_SIZE 4096
 
+/* max query directory data buffer size */
+#define SMB2_MAX_QD_DATABUF_SIZE (2 * 1024 * 1024)
+
 /*
  * Output buffer size for first QueryDir in Create+QD1+QD2 compound.
  * Accounts for shared buffer space needed for all three responses.
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 9de7d2fe8d466..9607e8899f7ff 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -46,6 +46,8 @@ __le32 smb2_get_lease_state(struct cifsInodeInfo *cinode, unsigned int oplock);
 bool smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server);
 int smb3_handle_read_data(struct TCP_Server_Info *server,
 			  struct mid_q_entry *mid);
+int smb2_query_dir_handle_data(struct TCP_Server_Info *server,
+			       struct mid_q_entry *mid);
 struct inode *smb2_create_reparse_inode(struct cifs_open_info_data *data,
 					struct super_block *sb,
 					const unsigned int xid,
@@ -197,6 +199,7 @@ int SMB2_query_directory_init(const unsigned int xid, struct cifs_tcon *tcon,
 			      u64 volatile_fid, int index, int info_level,
 			      unsigned int output_size);
 void SMB2_query_directory_free(struct smb_rqst *rqst);
+int SMB2_query_directory_large(struct cifs_query_dir_io *qd_io, unsigned int buf_size);
 int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 		 u64 persistent_fid, u64 volatile_fid, u32 pid,
 		 loff_t new_eof);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index acfbb63086ea2..54ee1317c5b12 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -165,6 +165,7 @@
 	EM(cifs_trace_rw_credits_write_prepare,		"wr-prepare ") \
 	EM(cifs_trace_rw_credits_write_response_add,	"wr-resp-add") \
 	EM(cifs_trace_rw_credits_write_response_clear,	"wr-resp-clr") \
+	EM(cifs_trace_rw_credits_query_dir_done,	"qd-done    ") \
 	E_(cifs_trace_rw_credits_zero_in_flight,	"ZERO-IN-FLT")
 
 #define smb3_tcon_ref_traces					      \
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 05f8099047e1a..4457b98b9365d 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1154,6 +1154,190 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return  __cifs_readv_discard(server, mid, rdata->result);
 }
 
+static int
+cifs_query_dir_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	int length;
+	struct cifs_query_dir_io *qd_io = mid->callback_data;
+
+	length = cifs_discard_remaining_data(server);
+	dequeue_mid(server, mid, qd_io->result != 0);
+	mid->resp_buf = server->smallbuf;
+	server->smallbuf = NULL;
+	return length;
+}
+
+/*
+ * Receive handler for async QueryDirectory with multi-credit support
+ */
+int
+cifs_query_dir_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	int length, len;
+	unsigned int data_offset, data_len, resp_size;
+	struct cifs_query_dir_io *qd_io = mid->callback_data;
+	char *buf = server->smallbuf;
+	unsigned int buflen = server->pdu_size;
+	struct smb2_query_directory_rsp *rsp;
+
+	cifs_dbg(FYI, "%s: mid=%llu buf_capacity=%zu\n",
+		 __func__, mid->mid, qd_io->combined_iov.iov_len);
+
+	/*
+	 * Read the rest of QUERY_DIRECTORY_RSP header (sans Data array).
+	 * QueryDirectory response structure is 64 bytes (SMB2 header) + 8 bytes (fixed part).
+	 */
+	resp_size = sizeof(struct smb2_query_directory_rsp);
+	len = min_t(unsigned int, buflen, resp_size) - HEADER_SIZE(server) + 1;
+
+	length = cifs_read_from_socket(server,
+				       buf + HEADER_SIZE(server) - 1, len);
+	if (length < 0) {
+		qd_io->result = length;
+		goto discard_and_queue;
+	}
+	server->total_read += length;
+
+	if (server->ops->is_session_expired &&
+	    server->ops->is_session_expired(buf)) {
+		cifs_reconnect(server, true);
+		return -1;
+	}
+
+	if (server->ops->is_status_pending &&
+	    server->ops->is_status_pending(buf, server)) {
+		cifs_discard_remaining_data(server);
+		return -1;
+	}
+
+	/* Is there enough to get to the rest of the QUERY_DIRECTORY_RSP header? */
+	if (server->total_read < resp_size) {
+		cifs_dbg(FYI, "%s: server returned short header. got=%u expected=%u\n",
+			 __func__, server->total_read, resp_size);
+		qd_io->result = smb_EIO2(smb_eio_trace_read_rsp_short,
+					 server->total_read, resp_size);
+		return cifs_query_dir_discard(server, mid);
+	}
+
+	/* Set up first iov for signature check and to get credits */
+	qd_io->iov[0].iov_base = buf;
+	qd_io->iov[0].iov_len = server->total_read;
+	qd_io->iov[1].iov_base = NULL;
+	qd_io->iov[1].iov_len = 0;
+	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
+		 qd_io->iov[0].iov_base, qd_io->iov[0].iov_len);
+
+	/* Parse header early to access status before map_error converts it */
+	rsp = (struct smb2_query_directory_rsp *)buf;
+
+	/* Was the SMB query_directory successful? */
+	qd_io->result = server->ops->map_error(buf, false);
+	if (qd_io->result != 0) {
+		if (qd_io->combined_iov.iov_base && qd_io->iov[0].iov_len > 0 &&
+		    qd_io->iov[0].iov_len <= qd_io->combined_iov.iov_len) {
+			memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_base,
+			       qd_io->iov[0].iov_len);
+			qd_io->iov[0].iov_base = qd_io->combined_iov.iov_base;
+		}
+		cifs_dbg(FYI, "%s: server returned error %d (Status was 0x%x)\n",
+			 __func__, qd_io->result, le32_to_cpu(rsp->hdr.Status));
+		return cifs_query_dir_discard(server, mid);
+	}
+
+	data_offset = le16_to_cpu(rsp->OutputBufferOffset);
+	data_len = le32_to_cpu(rsp->OutputBufferLength);
+
+	cifs_dbg(FYI, "%s: total_read=%u data_offset=%u data_len=%u\n",
+		 __func__, server->total_read, data_offset, data_len);
+
+	/* Validate data_offset and data_len */
+	if (data_offset < server->total_read) {
+		cifs_dbg(FYI, "%s: data offset (%u) inside response header\n",
+			 __func__, data_offset);
+		data_offset = server->total_read;
+		data_len = 0;
+	} else if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
+			 __func__, data_offset);
+		qd_io->result = smb_EIO1(smb_eio_trace_read_overlarge,
+					 data_offset);
+		return cifs_query_dir_discard(server, mid);
+	}
+
+	/* Read any padding between header and data */
+	len = data_offset - server->total_read;
+	if (len > 0) {
+		length = cifs_read_from_socket(server,
+					       buf + server->total_read, len);
+		if (length < 0) {
+			qd_io->result = length;
+			goto discard_and_queue;
+		}
+		server->total_read += length;
+		qd_io->iov[0].iov_len = server->total_read;
+	}
+
+	/* Check if data fits in the pre-allocated combined buffer */
+	if (qd_io->iov[0].iov_len + data_len > qd_io->combined_iov.iov_len) {
+		cifs_dbg(VFS, "%s: response (%zu + %u) exceeds buffer capacity (%zu)\n",
+			 __func__, qd_io->iov[0].iov_len, data_len, qd_io->combined_iov.iov_len);
+		qd_io->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
+					 data_len, (unsigned int)qd_io->combined_iov.iov_len);
+		return cifs_query_dir_discard(server, mid);
+	}
+
+	/*
+	 * Build combined header+data in qd_io->combined_iov.iov_base.
+	 * Layout: [header][data] with no padding between them.
+	 * We update OutputBufferOffset in the header to reflect the new layout.
+	 */
+	if (qd_io->iov[0].iov_len > 0 && qd_io->result == 0) {
+		size_t hdr_len = qd_io->iov[0].iov_len;
+		struct smb2_query_directory_rsp *combined_rsp;
+
+		/* Copy header to beginning of combined buffer */
+		memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_base, hdr_len);
+
+		/* Read directory entries directly after the header, removing any padding */
+		if (data_len > 0) {
+			length = cifs_read_from_socket(server,
+						       qd_io->combined_iov.iov_base + hdr_len,
+						       data_len);
+			if (length < 0) {
+				qd_io->result = length;
+				goto discard_and_queue;
+			}
+			server->total_read += length;
+
+			/* Update OutputBufferOffset and OutputBufferLength to reflect
+			 * the new compact layout (header followed immediately by data).
+			 */
+			combined_rsp = (struct smb2_query_directory_rsp *)qd_io->combined_iov.iov_base;
+			combined_rsp->OutputBufferOffset = cpu_to_le16(hdr_len);
+			combined_rsp->OutputBufferLength = cpu_to_le32(length);
+
+			/* Set up second iov pointing to the directory data within combined buffer */
+			qd_io->iov[1].iov_base = qd_io->combined_iov.iov_base + hdr_len;
+			qd_io->iov[1].iov_len = length;
+		}
+
+		qd_io->combined_iov.iov_len = hdr_len + (data_len > 0 ? length : 0);
+
+		cifs_dbg(FYI, "total_read=%u buflen=%u data_len=%u hdr_len=%zu combined_len=%zu\n",
+			 server->total_read, buflen, data_len, hdr_len, qd_io->combined_iov.iov_len);
+	}
+
+discard_and_queue:
+	/* Discard any remaining data (shouldn't be any) */
+	if (server->total_read < buflen)
+		cifs_discard_remaining_data(server);
+
+	dequeue_mid(server, mid, false);
+	mid->resp_buf = server->smallbuf;
+	server->smallbuf = NULL;
+	return length;
+}
+
 int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-- 
2.43.0


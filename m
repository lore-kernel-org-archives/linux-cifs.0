Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD23A8727
	for <linux-cifs@vger.kernel.org>; Fri,  1 May 2026 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634442; cv=none; b=k50kFb9oBLDoGJ5Wlk9nhsWPudPiQc27tPx2V6tEuAiqU3/ZStOWZTmaUIxgSHDUav28rr/LuvryVBVOfHK1V9bJmEFB0IGTMqx1J8Ke2Fq08xVv1n1flGaAoArTtu4maJ4KdoM9BdYR43YhBgSUSqw762D6TzovhbYmAtX3dsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634442; c=relaxed/simple;
	bh=W5yp2Pp9Nb+ard2MoCdt6b0LeFDqs9y75nQ/MbT6j7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQuG2e0V3i9qeGay8/LG51vWIrWauqJLVUj3BIrS8qXpnY+jsbiyJgixibUcxp+tMmCKrUnDOOQ7n2oG8CnofUDZk0k4jI7xhvqgBK3oxz3LCtnr11n71/3D9VCtMSsE1yZBuN1nytyq0pkFDqh0+lKwaA/dm6iBCpAmXTjDOmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D8z6YFy9; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D8z6YFy9"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82f8893bff3so904191b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 01 May 2026 04:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777634437; x=1778239237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkof2F7I21cEy3enViZwd+2Pk5c/azHa4TYCCMCzlL8=;
        b=D8z6YFy947L7RTG87AJE7y1GYub6LnjhEx5ASiTCO6nTljg8kmpKW404uGRUm/ejRM
         6Tmi4UJT4iDWQ3LEjf4EvG2v8imVxTHIFvRLg7DY5dX/rpVIm/YcUgDgFjFdmERwMCsN
         BDuITdURBU2wSURYGnsCdQw1mq66nq2UCd+wrR7bxdlJMHz27YWtZ5uAQeg6NQmBj/bk
         1udgE/cahL9W7Ou/VszDvzoNOOBFfpnEqBAuSA4L5v6buEIcx2ZCbmmDMnyiZcU6O/8+
         JIq5LbdydZ/sp7e/RcT+PkAGGatQS6aqvrRzuH8iTXn7QNe28cXOCELB3cK/0EWZzsi8
         +Dog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634437; x=1778239237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nkof2F7I21cEy3enViZwd+2Pk5c/azHa4TYCCMCzlL8=;
        b=NRlFaEsa0+KPnjS5DzfPt+PsKKW9w2p+uvLau0EwXCWleIgeGsauXKeWomY5FS+ENy
         VQD0Wu7UdVaJhh0cA/EA52TC7j5XdKk1IvoloDYHbC7ymb3ze5ZV6cJ8Ykg26HxLsMue
         GciarKkPXuXwnvANqb05e7x+dVzhK4YRSr68p8m4jmpGTMRvLigRGdiolOvkErz4Sa73
         FR2slP3CM1rg5RmL59qNyS5aKgnbJLEhbYuLjM5e0vr16dbf5EDQVl9ECthA04FGDLjc
         TtrXzNtNP5sgI90Iuc1dJdpK5BiD3RSoJwATyHfQL63BFGNoVtZ+nNb/3jt9lrqGmIue
         DbCg==
X-Gm-Message-State: AOJu0YwGw2K+hHum9JtHS1mSa98XCZR8FOypcRz2OYv0WXLn7upqfOYI
	LsSnOSVxFkwaBb9SW5W2gm37ny8nzuk4kHZZo83h2j5gQ91FvonLgGNl3+YImKit1GA=
X-Gm-Gg: AeBDieuyl1Dx3MxMaJ7/gO4tUtaOT/69rhdk+83qKM+WoSBuuPLeiLsTbefatzEa/4I
	MOzggfhl4xWJcxn8kDbg1qkDnWSs5EtDXWoqRAtBAMgh/gz2uQVr2soEyPpwwX3VmO7TnbtKAKe
	U4gt99svkEt35ePkm1r35zeYCDdRuICMk1kB8ECE5AKjlHXH0bcQXc8hgbaOPmSfzJ24xukkrHb
	PUTkg00o8xCiBfbTDPRV8MkDrDQen7SpTZg+RAUi3UNtq/LYPYVL5MW2W00PLvHFsGiFkp/FSMA
	lHfK8mDXcLOwG25OUECDRXP450/TS+ES/msfBd7E/zAoh8GQHH7Yq3wesTZWSJlA3C57yvO0omx
	zzPqyptd95lDhcrZrgV/tpjdo/Xz92x/QmeK0hoECpVfegihGuqK0LOL8GwyutDPZ8nCpLGHUIT
	MGB4OEfBuNJEVKHeAIKhJ74t8T+ZE7h+4vIj3NPAvxzZ8ZNyTGYeqoIlRCl7d5XpWR
X-Received: by 2002:a05:6a00:3e22:b0:82c:6f07:299f with SMTP id d2e1a72fcca58-8351a329e40mr2958671b3a.14.1777634436856;
        Fri, 01 May 2026 04:20:36 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.216])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351587db67sm2331922b3a.13.2026.05.01.04.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:20:36 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v4 06/19] cifs: optimize readdir for larger directories
Date: Fri,  1 May 2026 16:50:09 +0530
Message-ID: <20260501112023.338005-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501112023.338005-1-sprasad@microsoft.com>
References: <20260501112023.338005-1-sprasad@microsoft.com>
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

The change also renames the discard function since both read and
query_dir paths will now reuse the same function to discard remaining
data in the socket and dequeue the mid.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h  |  21 +-
 fs/smb/client/cifsproto.h |   3 +
 fs/smb/client/readdir.c   |   2 +-
 fs/smb/client/smb1ops.c   |   4 +-
 fs/smb/client/smb2misc.c  |   7 +-
 fs/smb/client/smb2ops.c   | 458 ++++++++++++++++++++++++++++++++++++--
 fs/smb/client/smb2pdu.c   | 185 ++++++++++++++-
 fs/smb/client/smb2pdu.h   |   3 +
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/client/trace.h     |   1 +
 fs/smb/client/transport.c | 169 +++++++++++++-
 11 files changed, 811 insertions(+), 45 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 8d089ba08e3e5..38d5600efe2c8 100644
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
@@ -1397,6 +1397,25 @@ struct cifs_search_info {
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
+	struct kvec combined_iov;	/* Pre-allocated buffer to hold resp */
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
index f075330f88598..2df4d080e95f0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2713,11 +2713,131 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 
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
+				cifs_dbg(FYI, "%s: ENODATA but Status mismatch - not treating as end-of-search\n",
+					__func__);
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
@@ -4834,6 +4954,252 @@ cifs_copy_folioq_to_iter(struct folio_queue *folioq, size_t data_size,
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
+		/*
+		 * Copy header to persistent combined_iov buffer so status
+		 * remains accessible after receive handler returns. buf is temporary
+		 * and will be freed/reused, so we can't leave iov[0] pointing to it
+		 */
+		if (qd_io->combined_iov.iov_base && hdr_len > 0 &&
+		    hdr_len <= qd_io->combined_iov.iov_len) {
+			memcpy(qd_io->combined_iov.iov_base, buf, hdr_len);
+			qd_io->iov[0].iov_base = qd_io->combined_iov.iov_base;
+			qd_io->iov[0].iov_len = hdr_len;
+			cifs_dbg(FYI, "%s: copied error response header to combined_iov\n",
+				__func__);
+		}
+
+		/*
+		 * Normal error on query_directory response - response received successfully,
+		 * but the command failed. Store error in qd_io->result for callback
+		 */
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
@@ -4997,25 +5363,46 @@ static void smb2_decrypt_offload(struct work_struct *work)
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
@@ -5059,9 +5446,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
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
 
@@ -5072,7 +5460,10 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 	dw->server = server;
 
 	*num_mids = 1;
-	len = min_t(unsigned int, buflen, server->vals->read_rsp_size +
+	total_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
+
+	/* Read transform_hdr + read_rsp_size into buf */
+	len = min_t(unsigned int, buflen, read_rsp_size +
 		sizeof(struct smb2_transform_hdr)) - HEADER_SIZE(server) + 1;
 
 	rc = cifs_read_from_socket(server, buf + HEADER_SIZE(server) - 1, len);
@@ -5080,9 +5471,8 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_dw;
 	server->total_read += rc;
 
-	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
-		server->vals->read_rsp_size;
-	dw->len = len;
+	/* Read remaining data into folio_queue */
+	dw->len = total_len - read_rsp_size;
 	len = round_up(dw->len, PAGE_SIZE);
 
 	size_t cur_size = 0;
@@ -5111,7 +5501,7 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_pages;
 
 	/*
-	 * For large reads, offload to different thread for better performance,
+	 * For large responses, offload to different thread for better performance,
 	 * use more cores decrypting which can be expensive
 	 */
 
@@ -5125,20 +5515,41 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
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
@@ -5279,7 +5690,6 @@ smb3_receive_transform(struct TCP_Server_Info *server,
 		return -ECONNABORTED;
 	}
 
-	/* TODO: add support for compounds containing READ. */
 	if (pdu_length > CIFSMaxBufSize + MAX_HEADER_SIZE(server)) {
 		return receive_encrypted_read(server, &mids[0], num_mids);
 	}
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2d55246d2851b..92724cfb5b3f5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5496,6 +5496,185 @@ num_entries(int infotype, char *bufstart, char *end_of_buf, char **lastentry,
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
+			struct smb_rqst rqst = {
+				.rq_iov = &qd_io->iov[0],
+				.rq_nvec = qd_io->iov[1].iov_len ? 2 : 1,
+			};
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
@@ -5560,12 +5739,6 @@ int SMB2_query_directory_init(const unsigned int xid,
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
index 05f8099047e1a..24ccadb00f568 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1134,7 +1134,7 @@ cifs_discard_remaining_data(struct TCP_Server_Info *server)
 }
 
 static int
-__cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
+__cifs_discard_and_dequeue(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		     bool malformed)
 {
 	int length;
@@ -1146,12 +1146,161 @@ __cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	return length;
 }
 
-static int
-cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+/*
+ * Receive handler for async QueryDirectory with multi-credit support
+ */
+int
+cifs_query_dir_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	struct cifs_io_subrequest *rdata = mid->callback_data;
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
+		return __cifs_discard_and_dequeue(server, mid, false);
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
+		return __cifs_discard_and_dequeue(server, mid, true);
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
+		return __cifs_discard_and_dequeue(server, mid, false);
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
+		return __cifs_discard_and_dequeue(server, mid, true);
+	}
+
+	/* Read any padding between header and data */
+	len = data_offset - server->total_read;
+	if (len > 0) {
+		length = cifs_read_from_socket(server,
+					       buf + server->total_read, len);
+		if (length < 0) {
+			qd_io->result = length;
+			return __cifs_discard_and_dequeue(server, mid, false);
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
+		return __cifs_discard_and_dequeue(server, mid, true);
+	}
+
+	/*
+	 * Build combined header+data in qd_io->combined_iov.iov_base,
+	 * preserving the wire layout so SMB2 signing can be verified against
+	 * the exact on-the-wire bytes.  hdr_len already accounts for the
+	 * header and any padding up to data_offset; data is read at that
+	 * same offset.  OutputBufferOffset/Length are left untouched.
+	 */
+	if (qd_io->iov[0].iov_len > 0 && qd_io->result == 0) {
+		size_t hdr_len = qd_io->iov[0].iov_len;
+
+		/* Copy header+padding to combined buffer, preserving wire layout */
+		memcpy(qd_io->combined_iov.iov_base, qd_io->iov[0].iov_base, hdr_len);
+
+		/* Read directory entries at the wire data_offset position */
+		if (data_len > 0) {
+			length = cifs_read_from_socket(server,
+						       qd_io->combined_iov.iov_base + hdr_len,
+						       data_len);
+			if (length < 0) {
+				qd_io->result = length;
+				return __cifs_discard_and_dequeue(server, mid, false);
+			}
+			server->total_read += length;
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
 
-	return  __cifs_readv_discard(server, mid, rdata->result);
+	return __cifs_discard_and_dequeue(server, mid, false);
 }
 
 int
@@ -1205,7 +1354,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		cifs_dbg(FYI, "%s: server returned error %d\n",
 			 __func__, rdata->result);
 		/* normal error on read response */
-		return __cifs_readv_discard(server, mid, false);
+		return __cifs_discard_and_dequeue(server, mid, false);
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
@@ -1215,7 +1364,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			 server->vals->read_rsp_size);
 		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_short,
 					 server->total_read, server->vals->read_rsp_size);
-		return cifs_readv_discard(server, mid);
+		return __cifs_discard_and_dequeue(server, mid, rdata->result);
 	}
 
 	data_offset = server->ops->read_data_offset(buf);
@@ -1234,7 +1383,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 			 __func__, data_offset);
 		rdata->result = smb_EIO1(smb_eio_trace_read_overlarge,
 					 data_offset);
-		return cifs_readv_discard(server, mid);
+		return __cifs_discard_and_dequeue(server, mid, rdata->result);
 	}
 
 	cifs_dbg(FYI, "%s: total_read=%u data_offset=%u\n",
@@ -1260,7 +1409,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		/* data_len is corrupt -- discard frame */
 		rdata->result = smb_EIO2(smb_eio_trace_read_rsp_malformed,
 					 data_offset + data_len, buflen);
-		return cifs_readv_discard(server, mid);
+		return __cifs_discard_and_dequeue(server, mid, rdata->result);
 	}
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
@@ -1279,7 +1428,7 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 
 	/* discard anything left over */
 	if (server->total_read < buflen)
-		return cifs_readv_discard(server, mid);
+		return __cifs_discard_and_dequeue(server, mid, rdata->result);
 
 	dequeue_mid(server, mid, false);
 	mid->resp_buf = server->smallbuf;
-- 
2.43.0


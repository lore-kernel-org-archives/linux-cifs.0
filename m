Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A7623E342
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789572610; cv=none; b=b7j3gf04d33ZstYIG7yjR+jHkZ270TlYBPTnto9TZJ+UFajM8xgNbbYw00Z0KTI0GHN/whk2bopk3z2NDa6TlimSb1P9GEIfSiLnVDBJMZfGEw7YwwNCu7jPEKJvpBl2FMREtWPV2rEPnwH+Lyeee5A6IVQKsvR31azAC6bTzXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789572610; c=relaxed/simple;
	bh=dPoQu/EJiI3lbwFAZYPM1K/UjH8YJ8YaqVVjL9vMhxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDR9HatJu5O2bgXc4mv8gbyQ93OyJxXEFAorDCKk6EgZ3JXT913VQGKpOjjzzefWPrQuHt0WncnywzViRMXxTsnZ9GVv12ovgdSzjl0CQAC2fwTMCcCv3BS34y/4HGefFyma3Po7OBzHkuYzeXmvvWIYMQElqD+FANwTheqq/ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=BOxKPsp8; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="BOxKPsp8"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb74fso1073986a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789572600; x=1790177400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=II/QOgXCR8Pmc92qeGnjP7S39fXKc8c2bkmA7hj/JSU=;
        b=BOxKPsp8vZa82Yq62Tb8kiMnbpPpep0g8dVZF8Dl3Pk/PmiNUFdNr+OccXUsD4NhJC
         VzWPTOYfZeWMHcCM/dDUukRNvGWj4s9NF/ypM8ARrOBf629Q9YFwtcL3rLkf85PfRvIx
         2UdJsoWIC6S1Qzs26zZut6vOA8r1uJs+83N3HeGlRKqvCmb6D0Z7vz1afjs1hJk8ahSo
         g9Z8wvokzjiqacvmYRMmIY04Y0R2OcQMW3aP37XQiy1y0hHLEUIpLG/CaBoKJlZ5GPCQ
         nYKUY0b5CemLvth4tznXI6Ynd3lEYmY28Pcg7yCOJQp3PWfLIuZSyGSz4FKxKfU44X16
         czvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789572600; x=1790177400;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=II/QOgXCR8Pmc92qeGnjP7S39fXKc8c2bkmA7hj/JSU=;
        b=ihMbq3tods0CcDUsfHSDbpZCPF3r6uJuzB31W8wf03dJUBm/VXf2hJl7TF9xF5xwVf
         pPkbYhuj2puURwny6PRIVlA28WnTBeIijsQas42G43wF8fkcI1FEBh/gDvb3OwI5qBnZ
         l2wNj+UpNWmB62S8Ns1OghARrnn4t4JZizJJfmQp8kkphj427z2LLzfxn5Zajg8lUhHw
         MYT4EB6+ueg6YxSxRxo41ia5IkHc7FyIs/p92d4mnnLuqxM6scRGMAJLaQAkrV423SiB
         tdzanXrrqYoK1P81/kDYmsBNR/31MaKBz39eHErSJscc6wB7NqRlRtFGgL3zkPZ1iE6W
         2fLw==
X-Forwarded-Encrypted: i=1; AKwUvBwEbIknQtsZD2GJt4l3sYq9lwMmQakUq35uSzWbYV55XqG4hGJrovtCv4oVupQbKP0MSEsEkqHW9+rW@vger.kernel.org
X-Gm-Message-State: AFuF++kdWzBKa5W/mk2SiEM73vDyZ4DnZbQmNRx8zZpSktW2hCYenHan
	wKnN6HO9GhqggmHIe58lQisuAIyBvvU+zqM696fmnH2ani/Zg5FII/I2QizWyGHAN9vkGLLdNtL
	DzhQVTkLf
X-Gm-Gg: AYBFou1ua0UBmD1Ufb3489XzZkitofz2NS/aiq9+4RKjeLMTGXGiZwuOALU+6aGO/56
	xoWm4IpPmMkMTcPS7HgiZn0cH+tsrIA/NoVJWGyk7y70Qs+IqoXbb3Y7LdX7KoUn5QjX7wOC5sY
	N7f8Fd18rc/pxG1kXwCRtcHNav/GVLsf0uo1540wA9Pd9wa1w2tAxqixujUqTxw9twOGL/RUG2l
	S7oDI1YEDLjxybTWv87bb8gF5h0GhG58et5X99nHPcwDFOtqrxCTeCtD+df9MT4XOefn/VkDifv
	2mpIWLfPBxSCTa0uN1q3H1LRfKiBeMzFUxx0cpP4Zi8hhJTf5lziTgHay+hZkDHYbfDKWUgE04e
	2Puzu7tqQRwL168XOazRZhtb9klv2T7x02jafYkG0zWTa3vlHLydOWEMX3+iGl+FzARK7U8Hj6+
	XrvmtCTjIcd52XF7QllrDmZzTujfq9Y4AxZUss80wBAoAPdS/ItqLl58lECFEiKsXcAgHC3r1I4
	VPmCVOp18mN9pWoIx3e3ahJeciygHUAaLq/oL11
X-Received: by 2002:a17:90b:5785:b0:39d:ee20:1e2c with SMTP id 98e67ed59e1d1-39e1e5042famr8115244a91.18.1789572600393;
        Wed, 16 Sep 2026 08:30:00 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e35dab2e9sm28214a91.1.2026.09.16.08.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 08:29:59 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: pc@manguebit.org
Cc: linkinjeon@kernel.org,
	zihanx@nebusec.ai,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH v4 5/6] smb: client: close completed creates on compound wait errors
Date: Wed, 16 Sep 2026 15:29:28 +0000
Message-ID: <c9b09095a72006490d1938f778d5c42d19fc5919.1789478666.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

compound_send_recv() waits for responses in order. If a later wait is
interrupted, or if a later MID fails during response synchronization, an
earlier CREATE may already have opened a remote handle. The earlier mid
is then released without invoking handle_cancelled_mid(), leaving the
remote handle open because no FID was copied to the caller.

Mark completed earlier mids as cancelled when a compound wait or MID
synchronization aborts. Keep their response buffers attached while the
MIDs are synchronized, and transfer them only after synchronization of
the processed responses, so the release path can inspect successful
CREATE responses and queue SMB2_close() after a later failure. Account for
a remote open only after the close work is allocated and before it is
queued, since the caller has not yet updated num_remote_opens. Mark the
create+close compound used by smb2_unlink() so it is not closed again.
Non-CREATE responses and compounds that already include a close keep their
existing behavior.

Fixes: e0bba0b85481 ("cifs: add compound_send_recv()")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>

---
changes in v4:
  - Keep response buffers attached while MIDs are synchronized so a later
    MID failure can trigger cancelled-mid cleanup for earlier CREATEs.
  - Cover MID synchronization and unready-state failures, and defer
    num_remote_opens accounting until close work allocation succeeds.
  - Mark smb2_unlink()'s create+close compound to avoid duplicate cleanup.
  - Correct the Fixes tag to e0bba0b85481.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Add cleanup for completed CREATEs when a compound wait is interrupted.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - No counterpart in v2.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

---
 fs/smb/client/smb2inode.c |  2 +-
 fs/smb/client/smb2misc.c  |  9 ++++--
 fs/smb/client/transport.c | 67 +++++++++++++++++++++++++++++++--------
 3 files changed, 61 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 213bc298cdf22..6971496dfe8c2 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1104,7 +1104,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	struct kvec close_iov;
 	int resp_buftype[2];
 	struct cifs_fid fid;
-	int flags = 0;
+	int flags = CIFS_CP_CREATE_CLOSE_OP;
 	__u8 oplock;
 	int rc;
 
diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 9068175e57cd0..596388acb31e7 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -821,7 +821,8 @@ smb2_cancelled_close_fid(struct work_struct *work)
  */
 static int
 __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
-			    __u64 persistent_fid, __u64 volatile_fid)
+			    __u64 persistent_fid, __u64 volatile_fid,
+			    bool account_remote_open)
 {
 	struct close_cancelled_open *cancelled;
 
@@ -835,6 +836,8 @@ __smb2_handle_cancelled_cmd(struct cifs_tcon *tcon, __u16 cmd, __u64 mid,
 	cancelled->cmd = cmd;
 	cancelled->mid = mid;
 	INIT_WORK(&cancelled->work, smb2_cancelled_close_fid);
+	if (account_remote_open)
+		atomic_inc(&tcon->num_remote_opens);
 	WARN_ON(queue_work(cifsiod_wq, &cancelled->work) == false);
 
 	return 0;
@@ -871,7 +874,7 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
 	spin_unlock(&tcon->tc_lock);
 
 	rc = __smb2_handle_cancelled_cmd(tcon, SMB2_CLOSE_HE, 0,
-					 persistent_fid, volatile_fid);
+					 persistent_fid, volatile_fid, false);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_close);
 
@@ -899,7 +902,7 @@ smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Info *serve
 					 le16_to_cpu(hdr->Command),
 					 le64_to_cpu(hdr->MessageId),
 					 rsp->PersistentFileId,
-					 rsp->VolatileFileId);
+					 rsp->VolatileFileId, true);
 	if (rc)
 		cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cancelled_mid);
 
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index fdf4e50c27ceb..14ba8646e5625 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -806,6 +806,18 @@ cifs_cancelled_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	release_mid(server, mid);
 }
 
+static void
+cifs_mark_compound_mids_cancelled(struct mid_q_entry **mid, int count)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		spin_lock(&mid[i]->mid_lock);
+		mid[i]->wait_cancelled = true;
+		spin_unlock(&mid[i]->mid_lock);
+	}
+}
+
 /*
  * cifs_pick_channel - pick an eligible channel for network operations
  *
@@ -866,6 +878,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		   int *resp_buf_type, struct kvec *resp_iov)
 {
 	int i, j, optype, rc = 0;
+	int num_processed = 0;
 	struct mid_q_entry *mid[MAX_COMPOUND];
 	bool cancelled_mid[MAX_COMPOUND] = {false};
 	struct cifs_credits credits[MAX_COMPOUND] = {
@@ -1012,6 +1025,14 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			break;
 	}
 	if (rc != 0) {
+		/*
+		 * A completed CREATE earlier in the compound chain may have
+		 * opened a remote handle even though a later wait was
+		 * interrupted. Mark it cancelled so __release_mid() invokes
+		 * the existing unmatched-open cleanup.
+		 */
+		cifs_mark_compound_mids_cancelled(mid, i);
+
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 mid[i]->mid, le16_to_cpu(mid[i]->command));
@@ -1034,6 +1055,14 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 
 		rc = cifs_sync_mid_result(mid[i], server);
 		if (rc != 0) {
+			/*
+			 * A previous CREATE may have completed before this
+			 * response failed. Mark it cancelled so its remote
+			 * handle is closed when the mid is released.
+			 */
+			cifs_mark_compound_mids_cancelled(mid, i);
+			/* Keep their response buffers for cancelled-mid cleanup. */
+			num_processed = 0;
 			/* mark this mid as cancelled to not free it below */
 			cancelled_mid[i] = true;
 			goto out;
@@ -1043,13 +1072,24 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		    mid[i]->mid_state != MID_RESPONSE_READY) {
 			rc = smb_EIO1(smb_eio_trace_rx_mid_unready, mid[i]->mid_state);
 			cifs_dbg(FYI, "Bad MID state?\n");
+			cifs_mark_compound_mids_cancelled(mid, i);
+			num_processed = 0;
 			goto out;
 		}
 
 		rc = server->ops->check_receive(mid[i], server,
 						flags & CIFS_LOG_ERROR);
+		num_processed = i + 1;
+	}
 
-		if (resp_iov) {
+out:
+	/*
+	 * Delay moving response buffers out of their mids until response
+	 * synchronization completes. This lets cancelled-mid cleanup inspect
+	 * an earlier CREATE response if a later MID fails.
+	 */
+	if (resp_iov) {
+		for (i = 0; i < num_processed; i++) {
 			buf = (char *)mid[i]->resp_buf;
 			resp_iov[i].iov_base = buf;
 			resp_iov[i].iov_len = mid[i]->resp_buf_size;
@@ -1068,21 +1108,22 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	/*
 	 * Compounding is never used during session establish.
 	 */
-	spin_lock(&ses->ses_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
-		struct kvec iov = {
-			.iov_base = resp_iov[0].iov_base,
-			.iov_len = resp_iov[0].iov_len
-		};
-		spin_unlock(&ses->ses_lock);
-		cifs_server_lock(server);
-		smb311_update_preauth_hash(ses, server, &iov, 1);
-		cifs_server_unlock(server);
+	if (num_processed == num_rqst) {
 		spin_lock(&ses->ses_lock);
+		if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+			struct kvec iov = {
+				.iov_base = resp_iov[0].iov_base,
+				.iov_len = resp_iov[0].iov_len
+			};
+			spin_unlock(&ses->ses_lock);
+			cifs_server_lock(server);
+			smb311_update_preauth_hash(ses, server, &iov, 1);
+			cifs_server_unlock(server);
+			spin_lock(&ses->ses_lock);
+		}
+		spin_unlock(&ses->ses_lock);
 	}
-	spin_unlock(&ses->ses_lock);
 
-out:
 	/*
 	 * This will dequeue all mids. After this it is important that the
 	 * demultiplex_thread will not process any of these mids any further.
-- 
2.43.0


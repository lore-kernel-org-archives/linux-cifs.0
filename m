Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93D4363C59
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405455; cv=none; b=ErCXvANOBsdC2IoeT9JIMl/ywTOhy2Jh0XLGnYt8BjidxA69UQSa/M+5gwxq9r9AbHYqst0Qt3LanROCb5S1tlh3IC8ZA87PfSeTMDgEHWkMV3sayFwd+FPWaf6fVr+tXt7T4RPOA1SuQ3/Jpw6NKSRxOnY2L7q3eQ8Q5zv2UMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405455; c=relaxed/simple;
	bh=4dw3Vn9U7kC/yYdw7vp4OAyyRVg5Qnl8bPeOdcmMP6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+WI6en7dsTjV64tZzqsoy44V87yrwohJMSf5cQQslRVwyu7nb/SwlwoQB2kz5AZOgi6c4osumXUFEZGOOIKeV6Bwc2mNuwx9jo5UgYJWkpdwU4ZMN2ednfNrKcT9Du3Xk0etqVY/XYBPjivPyZvySnfxnOhsIbWffvgqtlLiaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=EMs0K/lq; arc=none smtp.client-ip=74.125.228.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="EMs0K/lq"
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc797656e69so334962a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:50:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790405452; x=1791010252; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jwgdT7ZCFoFOSetRLVJnhfziX7YK8CC74lAbtlGrzR0=;
        b=EMs0K/lqoHRPxmJBxSRQcoCB1BP0YiC42G2C+0XUXznh9rQ7H9vfOdVtC/Ow62J+E9
         aqkZGqOCEEaT7AkfjWvJlsOsD2UDnM/tUCEHhozgUz8ywCGTSBLY49Oe0KEyBPKh83Wg
         rxXNs996KzliQwhhG6FRx3Gd7TS9sHuuPCI9ETIrIwg5/eVAcpjn/FVZWXQJyR03Ggky
         O5SioZITGGGNKXaqCec0Ojw18Lzb6sRin6Y2JlAsSdnmUHrIu61lyrqALAlCMAo3YBj+
         vO/KEUgeb2pTMlaTCcJ2ztGdT9oTh9zbv1sooVesB+Pz1Eg4x0KCXek/xKZiMmSjiWvU
         bbJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790405452; x=1791010252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jwgdT7ZCFoFOSetRLVJnhfziX7YK8CC74lAbtlGrzR0=;
        b=Iovb5EF1slUVsezSDiJZgJVhqFLDBl9KrufmP3yVSrAB8LAPDy7fnWrTT+uFvCp01c
         I3aoykmpiJ8waIcLO86uusHauXT5VyJIRoyEH9tfwfT2txV6lLmJETijZcAM/W5E92qD
         C1mBqiSvUOx9WXpA+nwwo73OVc8DjCWOhLimFrloRQQCrKxx9XDYfhGTeiC1KBdaWmfM
         KX1dsSdpoJ7KlUiSROH0q9Oaz5t9Xv5Wm8XQJkXRVeCEbVt0jvJQ3aJWYsc494ZUBmdf
         aH/yg3ERtA1xa/XYpT3tJ+da1X/9Z6IqaGN8V+6dNvcN9/YO1aWplkitCUi6sr92+CP7
         ZoJg==
X-Forwarded-Encrypted: i=1; AKwUvBzivTzofsDAoNUdcRyqqdmdeOZ0V1T/0pt46X2R00bHWpZ+++WYNg0uzbBdAbMM7uLwauvkLyMbgTHB@vger.kernel.org
X-Gm-Message-State: AFq9FYLvKRVqi2D00Dw8tNqObyYa9XuHQqRnmaf+p2/yxAU2nyX8+Po5
	hqfi+ueb2Oek7807T5dP9Tu/SZoaEmvKxSyvwLc46TGyDUoynqful9JyV+IUPQIARBQ1
X-Gm-Gg: AYBFou0GpNgWKETotN7XXA/Q0NY5M2Tf28g7XIhiz9P6gCz5z912/g+QkF9ZTMfd6S4
	RUG2hF94SQCJ9QgBbwRj1vfSRY209SqA341tiXuzV4SZ6ds7wfA6vFtcSY7LhCXPtYqwQbyQfzn
	QZCLn2Ln4bpwt2js5Eb0pxP1Vcyiu2Lk1Z6Qy8bX3ljB82O4ta96EVDxk1/S/Qjw9Tdr+A7R0wJ
	eH9723X0wXG3trVo7JKTzdftrD9o/GfMoMvP6IWD3diu2r7lqRUlI+HQv87i5YDeZL3wkwqRwQq
	pnCavnTLFtIzBr5KkDuZOqI07D6KTyf0Kj86MKddxC0DDsvZfJwUuDYzvYDFYfudveY/To7JEan
	VxWmlkB5b8z2IQExjMsEBamUj0QfOL8A27TIydd0ijIWBvTURroz2hoESiSzS2mP3s/z9S1Qad3
	e/NzbiZlutSe3BZgtG6d8Dn5OUlNLt1gu8a4AP1+2UD+N9buMxvGR6Z7LWRS7jcGy4uIFEcLFST
	tY4oAQTBn0lbrbhLkLnegtpvvrFbJjd3I4Km1su
X-Received: by 2002:a17:90b:2e84:b0:3a0:d79d:b6b8 with SMTP id 98e67ed59e1d1-3a0d79db771mr1532843a91.32.1790405451883;
        Fri, 25 Sep 2026 23:50:51 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b498fb12sm3447327a91.0.2026.09.25.23.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:50:51 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: sfrench@samba.org
Cc: zihanx@nebusec.ai,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilovsky@samba.org,
	aaptel@suse.com,
	pali@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 5/6] smb: client: close completed creates on compound wait errors
Date: Sat, 26 Sep 2026 06:49:25 +0000
Message-ID: <ee4f4836325e9508e2eb45f9e910e748631d5929.1790398755.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1790398755.git.zihanx@nebusec.ai>
References: <cover.1790398755.git.zihanx@nebusec.ai>
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
changes in v5:
  - Guard the final preauth-hash update when resp_iov is NULL, fixing the
    NULL dereference reported by the kernel test robot Smatch analysis:
    https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
  - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@nebusec.ai/
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
index fdf4e50c27ceb..6d25ee126f744 100644
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
+	if (num_processed == num_rqst && resp_iov) {
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


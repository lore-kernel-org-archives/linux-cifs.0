Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794833095;
	b=tn0sxptlqdummxTqKTQR/gQ12Ro0n4kcTARm27UajzUJnnujmo4pFu/W+jtF+CU3G5jQ
	 3W9S1g9iVEk0BLmNO9WEFO2JZva141RUrhICyF9oOGQ+fim8cFAYYun3m5lMm9MTsVPiV
	 EBusHYaeq+zZQO+9d+Rg7dEzEE4fQhLgb0p/VbsHxqAWO210DtskQYJfTL//kKemK04GZ
	 JKuccLbKGE0cMBCVEl77vbiPxuF8k3oiskbri+RmQvjZKlIdv35OfihPTIaoVXiiqAkiP
	 eyipUttRHt+YSBZ71qk8Y74xfYSbbFnAxJE2hxaVkRjAEjVzkQ38O3x/YH6uL4Uk5eA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794833095;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CBTG9XO8hynQExe03zgtJdvux0RZ9OF1uSQtjwSQDOw=;
	b=BcXN2NaWoQ2BQfJwhMJCpmibgzPs/YXdEMdTu3sjnWrEwuZPoLPxRobg0XzMe88AYm35
	 6m17Fwzp0Y1mMZrNOadTR/NpPjEg0OYnc+SaMnXt4uhAIDYL5cENmO3fpfCepaTM++cP+
	 V33kUo3xINuX5QkKdNyMlkXytZWPhC7MKdxZiwDXoZUUy1Ime6iQcvYPq73h+/bb+mLMt
	 lPD3XPkxbrxeBPjPmQ7hANxAbjgx0nchdhz2RvDo2eBeL5ZiV8qya8MIRN5t9w8cJvGNj
	 zo6uNAUtjFoUQbwx7wPiDEGT8aEaiZWvneTMsRs2HBmUeHxj26blbYAe10ZDxrY2BlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=1RwsEUoy;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b="XrhkZX/b";
	arc=none smtp.remote-ip=202.12.124.143
Received: from flow-b8-smtp.messagingengine.com (flow-b8-smtp.messagingengine.com [202.12.124.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8DF606A31C
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A8DF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=1RwsEUoy;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=XrhkZX/b
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id 80DDB130321A
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 07:44:53 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Mon, 16 Nov 2026 07:44:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794833092; x=1794840292; bh=CBTG9XO8hynQExe03zgtJ
	dvux0RZ9OF1uSQtjwSQDOw=; b=1RwsEUoygakGRkvaZu0jXrvEKrVV7zDpGYdZy
	i9p02WDncN/A68jMuVqODYb3xJSnbEW4IaPmgSLhA3XjZKOYrezTu7eovSH67qmF
	XLzFWgXED4AXNDwl/Tq/sNMpX1M8ij8gnlPE7UN/lRLrhPQrA84wBVaWRkwWsGO8
	e4BgGal4CZu0BFq/lBJFFv1aR/xzbK3y/OZn/t8EecfpxumJQGhzH5qapFXGHHj6
	SGI3rAfFCc7mKZQlRJBw0sTvGikVQtucEyvrS/Ldc3+sXqAcdJtmt/Un6vWrZGnt
	DpeO9zxX4TqPZpVDXEQhAuzLLxQK1q+T0qudVN/WoSDVSZ8rA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794833092; x=1794840292; bh=CBTG9XO8hynQExe03zgtJdvux0RZ9OF1uSQ
	tjwSQDOw=; b=XrhkZX/bHTov1PFWI/9LqVfST2ELF+vHwqrKQZfIjLLzV8wcvui
	3/nvDxzjlvIWDac90YfCyyS/osJ7lhK3eJxyzF+cQMw2BWlL9n0AYaS/P/14/9Xx
	P2WnGHrRVLn0ROgSNuXCmbBoqoVFl8b0k1PNPNygx8xWLFecGb45EoSLzROehnYx
	76iReITPkHz//9GjvPurvgAlM9NWqVgDutBsGsn+vxSMvos+38xqbMzcyRpeEv78
	TZmu2Fn8AGqzfzAD0kFKyyG9muAAwrb3i6W2NR06w73LS8O4KPR7LQb4JNXN0t3/
	R4K78YGMmk7HC5UI+RnDHToILaWgFbhriLw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794833092; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:c+RV9r0ymWutx5Yjg+mVWBjEg0VQZLO+vsXgkfhumVYrqin
	fHxlL4rGLOBsHNgS/E8NeKdwIGiERrJ7gmVnc9qZ0yl6ZF24DAntlAn+0e5W0wUV
	JMnUKFr2ZFxXTxJmfzEaTjqSk/HsjCcaAuqqQY/h70QzG0ZZl6hgr/Pe31+SsveT
	p+8cP2FaELgATj4Ogp+WccgCSupCaEG+HondY8I+twYTpJPmKsAeuopgVFguhKOU
	Z31uIUZMV3YUsyYYpdVZ0y1D3rCqcWsaayf+Fo4rqVqJki5PetTufGFxGByDn0ZK
	geBCyJRsfS7OOfcPm7ugDAvkoFssF9Q1mCNQ4Dw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:0oY/pBXbQKvquv1RTT5tHyLwatXa5YD3swtjubGxgj8=:0HozEhzHLgVA0r9j7E4h3L/XZCW98IOZDIM8q/GHO3k=;
X-ME-Sender: <xms:w_r6ahKTtPF_1UB5gIq7ro6Anromk5_0uaeoGPne_Wl6h0GZeMnYzQ>
    <xme:w_r6apLIVDdEkyu4Ej1UA04wBwg99AO0Ml_fThDhk9KtkLzAYDp7HjYVuhFtX5kqG
    i0RQSEtN6z9II6TkL-APbAHw6RNe7QJkdwiMPx--IDyeYJ9fKR69sxx>
X-ME-Received: <xmr:w_r6ar7ip8AjWpKT0TK3HRUg-X2vACRYv-Mrg7QntwWyR4PowaoPrVH2vnNFw6dI>
X-ME-Proxy-Cause: dmFkZTGOySjBYUo1B/JhD/yzmyleGW1OuzjED8GPy471VzQhXLb9eNFZLQxwb6UFphxkRL
    wTOOhzJBg9NM5KPvKTo8Bq1EW6KSwa/VudHHhPZRA6JxQJhssBlD/dU6guPRDGBZ3L58nx
    CfiulJTxysAYJYSsj2UkXcREckeP7jAOauV+kfRXmv4Zm48F8QRmhbnY/12O4vz4owk93i
    OjDXzkeXEOJ9YN/SsMxxOdndmJ05+S0J/KCASAoWBlZeTDUDae1mOKBs78n4exIk9QdcT9
    Qk61QLh3on1tJ+1YkKk+N4Ldqwwh7sqJBOF+7bZafEjqVohRJty0jADSRICylIj6G2M+qV
    ZJdQ3JLBfuS44c94iSPmxy+dynWUkUOsjdxmX3CegKdUA0cqh57CPLHez7DB+AOwLK5Epz
    9nGTXWhhxcxhrMaWd58O5tNW5RKijRGJpX3JF+4XvGHhvKwLFaMSStnwGuRQtgv7lR7ybF
    2jVumaHn4l4c62GuIe4E26PXjDyC27u2oO6R772RK745V5w0JbqSuMwoJWLNC4AM/Hj8U+
    gC3kmNOE5KBhSwN+yAsRueQUeBekRRKOfQa17k3zVaUKyOkiKy8eV3D1KLGW29GI1fSqy+
    QBmL3QTVbFEwqWY7LgOHkdwdj2F1uHC2h1kwEo1ts4svz4qktLJr0+sjRhZA
X-ME-Proxy: <xmx:w_r6ajcfDtu0zmxr5UziUKS4LQYlnqnPboWTVOEFRPTMO9XXPSUxcQ>
    <xmx:w_r6amGJ4PQ96ZD6mgTfZftLamEhud5WTT1-iVkTJf8PRzzbAuUp7A>
    <xmx:w_r6asRZANDjYqlum6cS4jhxkHc7ID2Atbx_-lSEGPYMNTXBhJcFkg>
    <xmx:w_r6akaA_BrGQ3nf1UJZxdpniqDzNHStqnYFUaW4C4vtaRKklbRYng>
    <xmx:xPr6aqybQviil6F0rg-J0zN5gIJmpR4K355Zt18At9TNVLUZNHNuDDQd>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 07:44:49 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: read create context data at its DataOffset
Date: Mon, 16 Nov 2026 06:44:41 -0600
Message-ID: <20261116124441.2521447-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd reads most create context data at a fixed offset instead of the
client's DataOffset. When the data starts later, ksmbd reads padding or
other bytes. For a security descriptor, zero padding can be parsed as
having no DACL, so CREATE succeeds without applying the client's
descriptor.

Use DataOffset for security descriptor, extended attribute, lease,
durable handle, POSIX and allocation size contexts. The context lookup
already validates DataOffset and DataLength. Check each payload's
minimum length and keep the existing parser checks. Add
smb2_context_data() and a structure for the durable reconnect data, and
remove the request structures that no longer have users. Contexts using
the usual offset behave as before.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    Tested on ksmbd-for-next 3bc1fb9c3b20 with KASAN. Moving context
    data 8 or 16 bytes beyond its usual offset now gives the same
    results as the usual layout. At the usual offset, a DataLength
    one byte too short is rejected with and without the patch.
    smbtorture results match the base.

    This fix was developed with LLM assistance.

 fs/smb/server/oplock.c  |  30 +++++-------
 fs/smb/server/oplock.h  |  10 ++++
 fs/smb/server/smb2pdu.c | 102 +++++++++++++++++-----------------------
 fs/smb/server/smb2pdu.h |  20 ++------
 4 files changed, 67 insertions(+), 95 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index c933d1e5f545..7c567180dbe1 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -2321,36 +2321,28 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 		return ERR_PTR(-ENOMEM);
 
 	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
-		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
+		struct lease_context_v2 *lc = smb2_context_data(cc);
 
-		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
-		    sizeof(struct create_lease_v2) - 4)
-			goto err_out;
-
-		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-		lreq->req_state = lc->lcontext.LeaseState;
-		lreq->flags = lc->lcontext.LeaseFlags;
-		lreq->epoch = lc->lcontext.Epoch;
-		lreq->duration = lc->lcontext.LeaseDuration;
+		memcpy(lreq->lease_key, lc->LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->LeaseState;
+		lreq->flags = lc->LeaseFlags;
+		lreq->epoch = lc->Epoch;
+		lreq->duration = lc->LeaseDuration;
 		if (!lease_state_valid(lreq->req_state) ||
 		    !lease_v2_flags_valid(lreq->flags))
 			goto err_out;
 		lreq->req_state = lease_state_grantable(lreq->req_state);
 		if (lreq->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
-			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+			memcpy(lreq->parent_lease_key, lc->ParentLeaseKey,
 			       SMB2_LEASE_KEY_SIZE);
 		lreq->version = 2;
 	} else if (sizeof(struct lease_context) == le32_to_cpu(cc->DataLength)) {
-		struct create_lease *lc = (struct create_lease *)cc;
-
-		if (le16_to_cpu(cc->DataOffset) + le32_to_cpu(cc->DataLength) <
-		    sizeof(struct create_lease))
-			goto err_out;
+		struct lease_context *lc = smb2_context_data(cc);
 
-		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-		lreq->req_state = lc->lcontext.LeaseState;
+		memcpy(lreq->lease_key, lc->LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->LeaseState;
 		lreq->flags = 0;
-		lreq->duration = lc->lcontext.LeaseDuration;
+		lreq->duration = lc->LeaseDuration;
 		if (!lease_state_valid(lreq->req_state))
 			goto err_out;
 		lreq->req_state = lease_state_grantable(lreq->req_state);
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index d81013c514e3..945effd5240a 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -123,6 +123,16 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_file *fp);
 void create_aapl_rsp_buf(char *cc, __u64 vol_caps, __u64 req_bitmap,
 			 bool readdir_attr_v2);
 struct create_context *smb2_find_context_vals(void *open_req, const char *tag, int tag_len);
+
+/*
+ * The data of a context smb2_find_context_vals() returned. It starts at
+ * DataOffset, and its DataLength bytes lie inside the context.
+ */
+static inline void *smb2_context_data(struct create_context *cc)
+{
+	return (char *)cc + le16_to_cpu(cc->DataOffset);
+}
+
 struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key);
 int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 9ef2d086fc4e..df81d5a3b378 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3931,7 +3931,7 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 				 const struct path *path)
 {
 	struct create_context *context;
-	struct create_sd_buf_req *sd_buf;
+	struct smb_ntsd *pntsd;
 
 	if (!req->CreateContextsOffset)
 		return -ENOENT;
@@ -3945,13 +3945,10 @@ static int smb2_create_sd_buffer(struct ksmbd_work *work,
 
 	ksmbd_debug(SMB,
 		    "Set ACLs using SMB2_CREATE_SD_BUFFER context\n");
-	sd_buf = (struct create_sd_buf_req *)context;
-	if (le16_to_cpu(context->DataOffset) +
-	    le32_to_cpu(context->DataLength) <
-	    sizeof(struct create_sd_buf_req))
-		return -EINVAL;
-	return set_info_sec(work->conn, work->tcon, path, &sd_buf->ntsd,
-			    le32_to_cpu(sd_buf->ccontext.DataLength), true, true,
+	/* parse_sec_desc() refuses a length shorter than the SD header */
+	pntsd = smb2_context_data(context);
+	return set_info_sec(work->conn, work->tcon, path, pntsd,
+			    le32_to_cpu(context->DataLength), true, true,
 			    true, true);
 }
 
@@ -4112,7 +4109,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		switch (dh_idx) {
 		case DURABLE_RECONN_V2:
 		{
-			struct create_durable_handle_reconnect_v2 *recon_v2;
+			struct durable_reconnect_context_v2 *recon_v2;
 			u32 flags;
 
 			if (dh_info->type == DURABLE_RECONN ||
@@ -4121,20 +4118,19 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (le32_to_cpu(context->DataLength) <
-			    sizeof(recon_v2->dcontext)) {
+			if (le32_to_cpu(context->DataLength) < sizeof(*recon_v2)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon_v2 = (struct create_durable_handle_reconnect_v2 *)context;
-			flags = le32_to_cpu(recon_v2->dcontext.Flags);
+			recon_v2 = smb2_context_data(context);
+			flags = le32_to_cpu(recon_v2->Flags);
 			if (flags & ~SMB2_DHANDLE_FLAG_PERSISTENT) {
 				err = -EINVAL;
 				goto out;
 			}
 			dh_info->persistent = flags & SMB2_DHANDLE_FLAG_PERSISTENT;
-			persistent_id = recon_v2->dcontext.Fid.PersistentFileId;
+			persistent_id = recon_v2->Fid.PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
 				ksmbd_debug(SMB, "Failed to get durable handle state\n");
@@ -4143,15 +4139,15 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			}
 
 			/* A zero VolatileFileId means that the client did not specify it. */
-			if (recon_v2->dcontext.Fid.VolatileFileId &&
+			if (recon_v2->Fid.VolatileFileId &&
 			    dh_info->fp->durable_volatile_id !=
-			    recon_v2->dcontext.Fid.VolatileFileId) {
+			    recon_v2->Fid.VolatileFileId) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
 				goto out;
 			}
 
-			if (memcmp(dh_info->fp->create_guid, recon_v2->dcontext.CreateGuid,
+			if (memcmp(dh_info->fp->create_guid, recon_v2->CreateGuid,
 				   SMB2_CREATE_GUID_SIZE)) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
@@ -4174,7 +4170,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		}
 		case DURABLE_RECONN:
 		{
-			create_durable_reconn_t *recon;
+			struct durable_reconnect_context *recon;
 
 			if (dh_info->type == DURABLE_RECONN_V2 ||
 			    dh_info->type == DURABLE_REQ_V2) {
@@ -4182,14 +4178,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
-			if (le32_to_cpu(context->DataLength) <
-			    sizeof(recon->Data)) {
+			if (le32_to_cpu(context->DataLength) < sizeof(*recon)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			recon = (create_durable_reconn_t *)context;
-			persistent_id = recon->Data.Fid.PersistentFileId;
+			recon = smb2_context_data(context);
+			persistent_id = recon->PersistentFileId;
 			dh_info->fp = ksmbd_lookup_durable_fd(persistent_id);
 			if (!dh_info->fp) {
 				ksmbd_debug(SMB, "Failed to get durable handle state\n");
@@ -4198,9 +4193,9 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			}
 
 			/* A zero VolatileFileId means that the client did not specify it. */
-			if (recon->Data.Fid.VolatileFileId &&
+			if (recon->VolatileFileId &&
 			    dh_info->fp->durable_volatile_id !=
-			    recon->Data.Fid.VolatileFileId) {
+			    recon->VolatileFileId) {
 				err = -EBADF;
 				ksmbd_put_durable_fd(dh_info->fp);
 				goto out;
@@ -4214,7 +4209,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 		}
 		case DURABLE_REQ_V2:
 		{
-			struct create_durable_req_v2 *durable_v2_blob;
+			struct durable_context_v2_req *durable_v2_blob;
 
 			if (dh_info->type == DURABLE_RECONN ||
 			    dh_info->type == DURABLE_RECONN_V2) {
@@ -4223,24 +4218,23 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			}
 
 			if (le32_to_cpu(context->DataLength) <
-			    sizeof(durable_v2_blob->dcontext)) {
+			    sizeof(*durable_v2_blob)) {
 				err = -EINVAL;
 				goto out;
 			}
 
-			durable_v2_blob =
-				(struct create_durable_req_v2 *)context;
-			if (le32_to_cpu(durable_v2_blob->dcontext.Flags) &
+			durable_v2_blob = smb2_context_data(context);
+			if (le32_to_cpu(durable_v2_blob->Flags) &
 			    ~SMB2_DHANDLE_FLAG_PERSISTENT) {
 				err = -EINVAL;
 				goto out;
 			}
 			ksmbd_debug(SMB, "Request for durable v2 open\n");
-			dh_info->CreateGuid = durable_v2_blob->dcontext.CreateGuid;
+			dh_info->CreateGuid = durable_v2_blob->CreateGuid;
 			dh_info->persistent =
-				le32_to_cpu(durable_v2_blob->dcontext.Flags) &
+				le32_to_cpu(durable_v2_blob->Flags) &
 				SMB2_DHANDLE_FLAG_PERSISTENT;
-			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->dcontext.CreateGuid);
+			dh_info->fp = ksmbd_lookup_fd_cguid(durable_v2_blob->CreateGuid);
 			if (dh_info->fp) {
 				if (!memcmp(conn->ClientGUID, dh_info->fp->client_guid,
 					    SMB2_CLIENT_GUID_SIZE)) {
@@ -4300,7 +4294,7 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 			if ((lc && (lc->req_state & SMB2_LEASE_HANDLE_CACHING_LE)) ||
 			    req_op_level == SMB2_OPLOCK_LEVEL_BATCH) {
 				dh_info->timeout =
-					le32_to_cpu(durable_v2_blob->dcontext.Timeout);
+					le32_to_cpu(durable_v2_blob->Timeout);
 				dh_info->type = dh_idx;
 			}
 			break;
@@ -4514,7 +4508,7 @@ int smb2_open(struct ksmbd_work *work)
 	struct kstat stat;
 	struct create_context *context;
 	struct lease_ctx_info *lc = NULL;
-	struct create_ea_buf_req *ea_buf = NULL;
+	struct create_context *ea_ctx = NULL;
 	struct oplock_info *opinfo;
 	struct durable_info dh_info = {0};
 	__le32 *next_ptr = NULL;
@@ -4557,8 +4551,6 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(context);
 			goto err_out2;
 		} else if (context) {
-			struct create_posix *posix = (struct create_posix *)context;
-
 			if (conn->dialect != SMB311_PROT_ID) {
 				rsp->hdr.Status = STATUS_INVALID_INFO_CLASS;
 				rc = -ENOTTY;
@@ -4572,15 +4564,14 @@ int smb2_open(struct ksmbd_work *work)
 				rc = -EOPNOTSUPP;
 				goto err_out2;
 			}
-			if (le16_to_cpu(context->DataOffset) +
-				le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_posix) - 4) {
+			/* The data starts with the 4-byte Mode */
+			if (le32_to_cpu(context->DataLength) < sizeof(__le32)) {
 				rc = -EINVAL;
 				goto err_out2;
 			}
 			ksmbd_debug(SMB, "get posix context\n");
 
-			posix_mode = le32_to_cpu(posix->Mode);
+			posix_mode = get_unaligned_le32(smb2_context_data(context));
 			posix_ctxt = true;
 		}
 	}
@@ -4800,10 +4791,9 @@ int smb2_open(struct ksmbd_work *work)
 			rc = PTR_ERR(context);
 			goto err_out2;
 		} else if (context) {
-			ea_buf = (struct create_ea_buf_req *)context;
-			if (le16_to_cpu(context->DataOffset) +
-			    le32_to_cpu(context->DataLength) <
-			    sizeof(struct create_ea_buf_req)) {
+			ea_ctx = context;
+			if (le32_to_cpu(context->DataLength) <
+			    sizeof(struct smb2_ea_info)) {
 				rc = -EINVAL;
 				goto err_out2;
 			}
@@ -5073,15 +5063,9 @@ int smb2_open(struct ksmbd_work *work)
 
 		created = true;
 		idmap = mnt_idmap(path.mnt);
-		if (ea_buf) {
-			if (le32_to_cpu(ea_buf->ccontext.DataLength) <
-			    sizeof(struct smb2_ea_info)) {
-				rc = -EINVAL;
-				goto err_out;
-			}
-
-			rc = smb2_set_ea(&ea_buf->ea,
-					 le32_to_cpu(ea_buf->ccontext.DataLength),
+		if (ea_ctx) {
+			rc = smb2_set_ea(smb2_context_data(ea_ctx),
+					 le32_to_cpu(ea_ctx->DataLength),
 					 &path, true);
 			if (rc == -EOPNOTSUPP)
 				rc = 0;
@@ -5411,10 +5395,10 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->CreateContextsOffset) {
-		struct create_alloc_size_req *az_req;
+		struct create_context *az_req;
 
-		az_req = (struct create_alloc_size_req *)smb2_find_context_vals(req,
-					SMB2_CREATE_ALLOCATION_SIZE, 4);
+		az_req = smb2_find_context_vals(req,
+						SMB2_CREATE_ALLOCATION_SIZE, 4);
 		if (IS_ERR(az_req)) {
 			rc = PTR_ERR(az_req);
 			goto err_out1;
@@ -5422,13 +5406,11 @@ int smb2_open(struct ksmbd_work *work)
 			   test_tree_conn_flag(tcon, KSMBD_TREE_CONN_FLAG_WRITABLE)) {
 			int err;
 
-			if (le16_to_cpu(az_req->ccontext.DataOffset) +
-			    le32_to_cpu(az_req->ccontext.DataLength) <
-			    sizeof(struct create_alloc_size_req)) {
+			if (le32_to_cpu(az_req->DataLength) < sizeof(__le64)) {
 				rc = -EINVAL;
 				goto err_out1;
 			}
-			alloc_size = le64_to_cpu(az_req->AllocationSize);
+			alloc_size = get_unaligned_le64(smb2_context_data(az_req));
 			fp->allocation_size_set = true;
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
index 8c6b170c2716..3edd7747b96f 100644
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -140,10 +140,10 @@ struct create_aapl_rsp {
 
 #define DURABLE_HANDLE_MAX_TIMEOUT	300000
 
-struct create_alloc_size_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	__le64 AllocationSize;
+/* See MS-SMB2 2.2.13.2.4, the data of a DHnC create context */
+struct durable_reconnect_context {
+	__u64 PersistentFileId;
+	__u64 VolatileFileId;
 } __packed;
 
 struct create_durable_rsp {
@@ -338,18 +338,6 @@ struct smb2_ea_info {
 	/* optionally followed by value */
 } __packed; /* level 15 Query */
 
-struct create_ea_buf_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct smb2_ea_info ea;
-} __packed;
-
-struct create_sd_buf_req {
-	struct create_context_hdr ccontext;
-	__u8   Name[8];
-	struct smb_ntsd ntsd;
-} __packed;
-
 /* See POSIX-FSCC 2.2.1 */
 struct smb2_posix_info {
 	__le32 NextEntryOffset;
-- 
2.47.3


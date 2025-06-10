Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384622472B9
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 18:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749579584; cv=none; b=GKlKWmZIRL5qCJryplY/Oe5/uikQtg+rmaePwr+TnFV0eH5gb+KODrgDtA1CGmDTUTPxwnNoD/SoFdGx7oCbl9+5xCeC1zqbuCYYhNK5FUkYD3AyqR2vj9O1ax91VmwWpVvWknsDggHU1L6/1OGCIVvg3uYvtxZVYGUjR46EObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749579584; c=relaxed/simple;
	bh=ba76+BU6/MkUaZ9GKzgpisn+hy/KPqdxdiyA+Vl+WSw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BJ+cGBwTR1IhPKVJyFNJadtEsalpS6YdTMwPfAW4pvLXS3ocKIaE1pJSCRuTJc05kxH0NT9VuvSPrVIjV9L73sDzF6oqhiPA0mlTRugLZ0EBaxMvktMcconueE2rR+aELf0a1kbA0ZyUAARm94g7JahDnbYgEV5aIBWr1hzIuWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=A9qGjo9H; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=HcwUHIjV; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=AJgQdOic; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=IgjRysL0; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="A9qGjo9H";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="HcwUHIjV";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="AJgQdOic";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="IgjRysL0"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1168921952;
	Tue, 10 Jun 2025 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749579580; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XI9/jolonswTQ44yxAlRkg/gR45/zOlAdewp11zD7YY=;
	b=A9qGjo9HAwpGl/cwAg19k56JcGhOqVhZElgFFjbCZ/t8f+IdjovtIZDQwtcH1r9BNoooFT
	PDXmcUVwQeOqc96SDnIsaC79JjZ0Y31H0+8A7SWbzq0y0ARn1m5W3c7yAfka3INHOFeBoj
	fO8HO8GJK+NWohCYDzo8KxN4HS3X5jM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749579580;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XI9/jolonswTQ44yxAlRkg/gR45/zOlAdewp11zD7YY=;
	b=HcwUHIjVb+oobVB1wa0O+1a1vWMIFzAk1SF0vbiW3MPoRc5c0dDaguhs2csgyGb2U3S7St
	fvnWmf1yT2DrlRBQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=AJgQdOic;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IgjRysL0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749579579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XI9/jolonswTQ44yxAlRkg/gR45/zOlAdewp11zD7YY=;
	b=AJgQdOicYPvHTmCc4qQ6ZDy+ZmehO2II1xGVyAZAzrXzL6o/+LMh+GGeIdXZN+e8tcfvCl
	DXgZRPifK6CufvKNRzwBA23Lk0MxHve7Jt7QRmlGW++6AKjOgYyIthUd690kf6XZfgektX
	fQJqfR1noOGLzWlUF3FG1Ws8uEPp9Yk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749579579;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=XI9/jolonswTQ44yxAlRkg/gR45/zOlAdewp11zD7YY=;
	b=IgjRysL0UyAoHXDZrFQitL57z0KztMwug0ldn70eHzO7GLN36R1FdLddx/XC+tBawl+xS0
	dVzql9ThUXJrOjAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91111139E2;
	Tue, 10 Jun 2025 18:19:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7yIDFjp3SGiJAwAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 10 Jun 2025 18:19:38 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH] smb: client: fix crypto buffers in non-linear memory
Date: Tue, 10 Jun 2025 15:19:29 -0300
Message-ID: <20250610181929.607075-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Queue-Id: 1168921952
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	DKIM_TRACE(0.00)[suse.de:+];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_TWO(0.00)[2];
	TO_DN_NONE(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:dkim,suse.de:email,qemu.org:url,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Score: -3.01
X-Spam-Level: 

The crypto API, through the scatterlist API, expects input buffers to be
in linear memory.  We handle this with the cifs_sg_set_buf() helper
that converts vmalloc'd memory to their corresponding pages.

However, when we allocate our aead_request buffer (@creq in
smb2ops.c::crypt_message()), we do so with kvzalloc(), which possibly
puts aead_request->__ctx in vmalloc area.

AEAD algorithm then uses ->__ctx for its private/internal data and
operations, and uses sg_set_buf() for such data on a few places.

This works fine as long as @creq falls into kmalloc zone (small
requests) or vmalloc'd memory is still within linear range.

Tasks' stacks are vmalloc'd by default (CONFIG_VMAP_STACK=y), so too
many tasks will increment the base stacks' addresses to a point where
virt_addr_valid(buf) will fail (BUG() in sg_set_buf()) when that
happens.

In practice: too many parallel reads and writes on an encrypted mount
will trigger this bug.

To fix this, allocate @creq with kzalloc() and allocate the input
scatterlist separately with kvcalloc().  To prevent future occurrences
also allocate @iv and @sign with kzalloc().

Also drop smb2_aead_req_alloc() since we no longer need to align a
monolithic pointer.

Backtrace:

[  945.272081] ------------[ cut here ]------------
[  945.272774] kernel BUG at include/linux/scatterlist.h:209!
[  945.273520] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
[  945.274412] CPU: 7 UID: 0 PID: 56 Comm: kworker/u33:0 Kdump: loaded Not tainted 6.15.0-lku-11779-g8e9d6efccdd7-dirty #1 PREEMPT(voluntary)
[  945.275736] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
[  945.276877] Workqueue: writeback wb_workfn (flush-cifs-2)
[  945.277457] RIP: 0010:crypto_gcm_init_common+0x1f9/0x220
[  945.278018] Code: b0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 5c 58 e5 00 e9 58 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 04 24 01 00 00 00 48 8b
[  945.279992] RSP: 0018:ffffc90000a27360 EFLAGS: 00010246
[  945.280578] RAX: 0000000000000000 RBX: ffffc90001d85060 RCX: 0000000000000030
[  945.281376] RDX: 0000000000080000 RSI: 0000000000000000 RDI: ffffc90081d85070
[  945.282145] RBP: ffffc90001d85010 R08: ffffc90001d85000 R09: 0000000000000000
[  945.282898] R10: ffffc90001d85090 R11: 0000000000001000 R12: ffffc90001d85070
[  945.283656] R13: ffff888113522948 R14: ffffc90001d85060 R15: ffffc90001d85010
[  945.284407] FS:  0000000000000000(0000) GS:ffff8882e66cf000(0000) knlGS:0000000000000000
[  945.285262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  945.285884] CR2: 00007fa7ffdd31f4 CR3: 000000010540d000 CR4: 0000000000350ef0
[  945.286683] Call Trace:
[  945.286952]  <TASK>
[  945.287184]  ? crypt_message+0x33f/0xad0 [cifs]
[  945.287719]  crypto_gcm_encrypt+0x36/0xe0
[  945.288152]  crypt_message+0x54a/0xad0 [cifs]
[  945.288724]  smb3_init_transform_rq+0x277/0x300 [cifs]
[  945.289300]  smb_send_rqst+0xa3/0x160 [cifs]
[  945.289944]  cifs_call_async+0x178/0x340 [cifs]
[  945.290514]  ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
[  945.291177]  smb2_async_writev+0x3e3/0x670 [cifs]
[  945.291759]  ? find_held_lock+0x32/0x90
[  945.292212]  ? netfs_advance_write+0xf2/0x310
[  945.292723]  netfs_advance_write+0xf2/0x310
[  945.293210]  netfs_write_folio+0x346/0xcc0
[  945.293689]  ? __pfx__raw_spin_unlock_irq+0x10/0x10
[  945.294250]  netfs_writepages+0x117/0x460
[  945.294724]  do_writepages+0xbe/0x170
[  945.295152]  ? find_held_lock+0x32/0x90
[  945.295600]  ? kvm_sched_clock_read+0x11/0x20
[  945.296103]  __writeback_single_inode+0x56/0x4b0
[  945.296643]  writeback_sb_inodes+0x229/0x550
[  945.297140]  __writeback_inodes_wb+0x4c/0xe0
[  945.297642]  wb_writeback+0x2f1/0x3f0
[  945.298069]  wb_workfn+0x300/0x490
[  945.298472]  process_one_work+0x1fe/0x590
[  945.298949]  worker_thread+0x1ce/0x3c0
[  945.299397]  ? __pfx_worker_thread+0x10/0x10
[  945.299900]  kthread+0x119/0x210
[  945.300285]  ? __pfx_kthread+0x10/0x10
[  945.300729]  ret_from_fork+0x119/0x1b0
[  945.301163]  ? __pfx_kthread+0x10/0x10
[  945.301601]  ret_from_fork_asm+0x1a/0x30
[  945.302055]  </TASK>

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/smb/client/smb2ops.c | 95 +++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1468c16ea9b8..f3ea5ebd89fc 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4185,54 +4185,30 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 	memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
 }
 
-static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
-				 int num_rqst, const u8 *sig, u8 **iv,
-				 struct aead_request **req, struct sg_table *sgt,
-				 unsigned int *num_sgs, size_t *sensitive_size)
-{
-	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
-	unsigned int iv_size = crypto_aead_ivsize(tfm);
-	unsigned int len;
-	u8 *p;
-
-	*num_sgs = cifs_get_num_sgs(rqst, num_rqst, sig);
-	if (IS_ERR_VALUE((long)(int)*num_sgs))
-		return ERR_PTR(*num_sgs);
-
-	len = iv_size;
-	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
-	len = ALIGN(len, crypto_tfm_ctx_alignment());
-	len += req_size;
-	len = ALIGN(len, __alignof__(struct scatterlist));
-	len += array_size(*num_sgs, sizeof(struct scatterlist));
-	*sensitive_size = len;
-
-	p = kvzalloc(len, GFP_NOFS);
-	if (!p)
-		return ERR_PTR(-ENOMEM);
-
-	*iv = (u8 *)PTR_ALIGN(p, crypto_aead_alignmask(tfm) + 1);
-	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
-						crypto_tfm_ctx_alignment());
-	sgt->sgl = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
-						   __alignof__(struct scatterlist));
-	return p;
-}
-
-static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
-			       int num_rqst, const u8 *sig, u8 **iv,
-			       struct aead_request **req, struct scatterlist **sgl,
-			       size_t *sensitive_size)
+/* Caller must free returned aead_request, @sig, @iv, and @sgl. */
+static struct aead_request *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
+					      int num_rqst, u8 **sig, struct scatterlist **sgl)
 {
+	struct aead_request *req;
 	struct sg_table sgtable = {};
 	unsigned int skip, num_sgs, i, j;
 	ssize_t rc;
-	void *p;
 
-	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgtable,
-				&num_sgs, sensitive_size);
-	if (IS_ERR(p))
-		return ERR_CAST(p);
+	*sig = kzalloc(SMB2_SIGNATURE_SIZE, GFP_NOFS);
+	if (!*sig)
+		return NULL;
+
+	num_sgs = cifs_get_num_sgs(rqst, num_rqst, *sig);
+	if (num_sgs <= 0)
+		return NULL;
+
+	req = aead_request_alloc(tfm, GFP_NOFS);
+	if (!req)
+		return NULL;
+
+	sgtable.sgl = kvcalloc(num_sgs, sizeof(struct scatterlist), GFP_NOFS);
+	if (!sgtable.sgl)
+		return NULL;
 
 	sg_init_marker(sgtable.sgl, num_sgs);
 
@@ -4262,10 +4238,11 @@ static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
 		sgtable.orig_nents = sgtable.nents;
 	}
 
-	cifs_sg_set_buf(&sgtable, sig, SMB2_SIGNATURE_SIZE);
+	cifs_sg_set_buf(&sgtable, *sig, SMB2_SIGNATURE_SIZE);
 	sg_mark_end(&sgtable.sgl[sgtable.nents - 1]);
 	*sgl = sgtable.sgl;
-	return p;
+
+	return req;
 }
 
 static int
@@ -4311,14 +4288,11 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc = 0;
-	struct scatterlist *sg;
-	u8 sign[SMB2_SIGNATURE_SIZE] = {};
+	struct scatterlist *sg = NULL;
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
 	struct aead_request *req;
-	u8 *iv;
+	u8 *iv = NULL, *sign = NULL;
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
-	void *creq;
-	size_t sensitive_size;
 
 	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
@@ -4344,16 +4318,23 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg,
-				 &sensitive_size);
-	if (IS_ERR(creq))
-		return PTR_ERR(creq);
+	req = smb2_get_aead_req(tfm, rqst, num_rqst, &sign, &sg);
+	if (!req) {
+		rc = -ENOMEM;
+		goto err_free;
+	}
 
 	if (!enc) {
 		memcpy(sign, &tr_hdr->Signature, SMB2_SIGNATURE_SIZE);
 		crypt_len += SMB2_SIGNATURE_SIZE;
 	}
 
+	iv = kzalloc(crypto_aead_ivsize(tfm), GFP_NOFS);
+	if (!iv) {
+		rc = -ENOMEM;
+		goto err_free;
+	}
+
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
 	    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		memcpy(iv, (char *)tr_hdr->Nonce, SMB3_AES_GCM_NONCE);
@@ -4370,8 +4351,12 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
+err_free:
+	kfree(iv);
+	kfree(sign);
+	kvfree(sg);
+	aead_request_free(req);
 
-	kvfree_sensitive(creq, sensitive_size);
 	return rc;
 }
 
-- 
2.49.0


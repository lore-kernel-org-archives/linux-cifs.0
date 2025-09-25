Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA3A3043C8
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 15:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758813048; cv=none; b=lxsa27ZzPDOBbChdOBZ9OJspSW+zDfBpezuXpt2g0n7sQO7+QyUN82VJl53uqN3a5XZA6CkBgyOBp57Q5d9Itg6FbaXkmr1tIXz5QXhmSPY7EH88WecwBHitIU0hyyHzj5Ipf5PHH/vyH5vqJ3cd/0JbbAPu9LoowMu5c5g78XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758813048; c=relaxed/simple;
	bh=V3g3+kItBN2mOcKQrbQZrWSie/ppOHwC8vJX4p5tJVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=acVYZjA4ohKBw/pZyV70hozY5QnqD+KfX0FV0WVSLdVEYcQguTZdz02yyJ5eE442UyaWeKtPPgKWDGdlEEubUErdZhWpE4VwumK/IbHueRoj5ntWJ0/C7CHUp9kbz/Johr6dDekZofWU/psLt/DeP2Pk9mlBX7I+fScCvnIsgec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=wD7AMoba; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=FtT3xqh4; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=IZqro2tV; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=SbFN1Nel; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wD7AMoba";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="FtT3xqh4";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="IZqro2tV";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="SbFN1Nel"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E2A616BE3C;
	Thu, 25 Sep 2025 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758813044; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=K8u8KJutcrpo0/AE8lCAE6il4cu9IGYj2B0XIsa7Kuw=;
	b=wD7AMobaE/PFlg9HNYaxAlxKWkYU+aY00jntRvBK4weLHS+oHJuqoR9Y54iTTCBq/+qkNY
	l1aXlQaw8DfJzU5RT+xU9vcOB5kp7eqPj0FkCsBXZDTuMpNW41vRJPRUYC3nCBgOgS2H4+
	lXg+pYgWGWWhCwolhSC9fbT3U8PecTY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758813044;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=K8u8KJutcrpo0/AE8lCAE6il4cu9IGYj2B0XIsa7Kuw=;
	b=FtT3xqh4lhDOubf7cMs2X99v2RPH0My6STAig8i5HWGXES2Y4dWSbmcXaVlW7MJBGMZEFY
	jeRsKT3O2RD3BXBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1758813043; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=K8u8KJutcrpo0/AE8lCAE6il4cu9IGYj2B0XIsa7Kuw=;
	b=IZqro2tVRYarAf50iFUyvvp+V14GCHhf9iM6WE2jKT53+6ZFGFqFzEycYhnsh7m4gkLZUP
	NXx315pqf6m6/OVGXXVEMxWPtk1wI/VbYxoFhaS5mD3HWPS4zqLbCT4NyKGKZY3lx/ABe3
	Kwwkd3c+fATWYGHKlx1TdLipcwT1SYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1758813043;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=K8u8KJutcrpo0/AE8lCAE6il4cu9IGYj2B0XIsa7Kuw=;
	b=SbFN1Nele6ttbCxaY/K2VF2mAypo4j4ED+T0b0yF7DKUggG+gCPX7MPS8agHZ++zfgm7SX
	Q2joxlr2etE2vWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F6BC132C9;
	Thu, 25 Sep 2025 15:10:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zbjPDXNb1WjWTgAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Thu, 25 Sep 2025 15:10:43 +0000
From: Enzo Matsumiya <ematsumiya@suse.de>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	henrique.carvalho@suse.com
Subject: [PATCH v2] smb: client: fix crypto buffers in non-linear memory
Date: Thu, 25 Sep 2025 12:10:33 -0300
Message-ID: <20250925151033.620865-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	TO_DN_NONE(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:mid,suse.de:email,imap1.dmz-prg2.suse.org:helo,qemu.org:url];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_SEVEN(0.00)[8];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80

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

To fix this, always alloc @creq with kmalloc() instead.
Also drop the @sensitive_size variable/arguments since
kfree_sensitive() doesn't need it.

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

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
v2:
- Change the fix to Paulo's suggestion.  Update commit message to reflect it.

 fs/smb/client/smb2ops.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e586f3f4b5c9..68286673afc9 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4219,7 +4219,7 @@ fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int orig_len,
 static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst *rqst,
 				 int num_rqst, const u8 *sig, u8 **iv,
 				 struct aead_request **req, struct sg_table *sgt,
-				 unsigned int *num_sgs, size_t *sensitive_size)
+				 unsigned int *num_sgs)
 {
 	unsigned int req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
 	unsigned int iv_size = crypto_aead_ivsize(tfm);
@@ -4236,9 +4236,8 @@ static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst
 	len += req_size;
 	len = ALIGN(len, __alignof__(struct scatterlist));
 	len += array_size(*num_sgs, sizeof(struct scatterlist));
-	*sensitive_size = len;
 
-	p = kvzalloc(len, GFP_NOFS);
+	p = kzalloc(len, GFP_NOFS);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -4252,16 +4251,14 @@ static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst
 
 static void *smb2_get_aead_req(struct crypto_aead *tfm, struct smb_rqst *rqst,
 			       int num_rqst, const u8 *sig, u8 **iv,
-			       struct aead_request **req, struct scatterlist **sgl,
-			       size_t *sensitive_size)
+			       struct aead_request **req, struct scatterlist **sgl)
 {
 	struct sg_table sgtable = {};
 	unsigned int skip, num_sgs, i, j;
 	ssize_t rc;
 	void *p;
 
-	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgtable,
-				&num_sgs, sensitive_size);
+	p = smb2_aead_req_alloc(tfm, rqst, num_rqst, sig, iv, req, &sgtable, &num_sgs);
 	if (IS_ERR(p))
 		return ERR_CAST(p);
 
@@ -4350,7 +4347,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	DECLARE_CRYPTO_WAIT(wait);
 	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	void *creq;
-	size_t sensitive_size;
 
 	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
@@ -4376,8 +4372,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg,
-				 &sensitive_size);
+	creq = smb2_get_aead_req(tfm, rqst, num_rqst, sign, &iv, &req, &sg);
 	if (IS_ERR(creq))
 		return PTR_ERR(creq);
 
@@ -4407,7 +4402,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
 
-	kvfree_sensitive(creq, sensitive_size);
+	kfree_sensitive(creq);
 	return rc;
 }
 
-- 
2.49.0


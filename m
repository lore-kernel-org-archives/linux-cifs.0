Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8CA25F998
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 19:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582337; cv=none; b=ucLbnHJlQ+U4CEANd0b6zld9BFKbjROHSegCzncX0zsJsus7rY1P4+LBuS6Y6O8qacmTE17AB3bxjKHg3m77lBAGTrc5YIGqnJBnE3z1KpHFHL4vMuYRgJlUuYjdAlAlkw88sOG1UiJ9RwmCCqiKPrkmLZohkyAGbRGYEos3u2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582337; c=relaxed/simple;
	bh=AJxxtTbsmwmUQ+XujKv3Wtd+VI4oT+Gc1dfnQmQGZy4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=hdSPSUkshTlH4zTJtuq9Gt/pel27kkQcQnvYRb5zk2sRtDNkH3UpUW0HdMk2boGSenIYIQyupQuz4T6TzWeZBIGkQDU6olgHpNzx6zlz8rZ7Hokc97OES8tw9SKoHrmzAVgNzLGZ4mGcqbh7g9uaXwF1ZpTwsJTlfn6RnPu2obE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=oG2mqpKa; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="oG2mqpKa"
Message-ID: <8fdbb87d839df2f8bdacf5f52a63144c@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1749582328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gwB6m1afM31vJLbLhXMnfTnl7d5DD8cHmH02xro1K9E=;
	b=oG2mqpKa1xXM+db+maCBNF9nGY+oaKdJxGf+s3S+u8JkcCSGUQN9q79G9ZCrqc7L7FBrAh
	lNq91Y9LuKxWLC/6kTR91dibB6dYnUSRQpE7F5y8UlCsLQpDZYGGYdchDkwmZJdZUC+6tF
	Ntr8rv1dd9ptLg0EDSH08BQrvgXt1sfSIPupX3MYAP0L1lWsUz9gQvP5WvfMp1R7kLupHg
	DGk+2/99rY2N3Vx32GsgWDj8D+ugig7pq1OhaKHJdmB+QVEN/ozJagNqKlvrnk5JihkF4n
	owq2RX/l2Qn8e1Rrg7QJd943Qwhxk1YD5cma6yJppPg74rd7KhgVW8ycAdBjRg==
From: Paulo Alcantara <pc@manguebit.com>
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH] smb: client: fix crypto buffers in non-linear memory
In-Reply-To: <20250610181929.607075-1-ematsumiya@suse.de>
References: <20250610181929.607075-1-ematsumiya@suse.de>
Date: Tue, 10 Jun 2025 16:05:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> The crypto API, through the scatterlist API, expects input buffers to be
> in linear memory.  We handle this with the cifs_sg_set_buf() helper
> that converts vmalloc'd memory to their corresponding pages.
>
> However, when we allocate our aead_request buffer (@creq in
> smb2ops.c::crypt_message()), we do so with kvzalloc(), which possibly
> puts aead_request->__ctx in vmalloc area.
>
> AEAD algorithm then uses ->__ctx for its private/internal data and
> operations, and uses sg_set_buf() for such data on a few places.
>
> This works fine as long as @creq falls into kmalloc zone (small
> requests) or vmalloc'd memory is still within linear range.
>
> Tasks' stacks are vmalloc'd by default (CONFIG_VMAP_STACK=y), so too
> many tasks will increment the base stacks' addresses to a point where
> virt_addr_valid(buf) will fail (BUG() in sg_set_buf()) when that
> happens.
>
> In practice: too many parallel reads and writes on an encrypted mount
> will trigger this bug.
>
> To fix this, allocate @creq with kzalloc() and allocate the input
> scatterlist separately with kvcalloc().  To prevent future occurrences
> also allocate @iv and @sign with kzalloc().
>
> Also drop smb2_aead_req_alloc() since we no longer need to align a
> monolithic pointer.
>
> Backtrace:
>
> [  945.272081] ------------[ cut here ]------------
> [  945.272774] kernel BUG at include/linux/scatterlist.h:209!
> [  945.273520] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
> [  945.274412] CPU: 7 UID: 0 PID: 56 Comm: kworker/u33:0 Kdump: loaded Not tainted 6.15.0-lku-11779-g8e9d6efccdd7-dirty #1 PREEMPT(voluntary)
> [  945.275736] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
> [  945.276877] Workqueue: writeback wb_workfn (flush-cifs-2)
> [  945.277457] RIP: 0010:crypto_gcm_init_common+0x1f9/0x220
> [  945.278018] Code: b0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 5c 58 e5 00 e9 58 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 04 24 01 00 00 00 48 8b
> [  945.279992] RSP: 0018:ffffc90000a27360 EFLAGS: 00010246
> [  945.280578] RAX: 0000000000000000 RBX: ffffc90001d85060 RCX: 0000000000000030
> [  945.281376] RDX: 0000000000080000 RSI: 0000000000000000 RDI: ffffc90081d85070
> [  945.282145] RBP: ffffc90001d85010 R08: ffffc90001d85000 R09: 0000000000000000
> [  945.282898] R10: ffffc90001d85090 R11: 0000000000001000 R12: ffffc90001d85070
> [  945.283656] R13: ffff888113522948 R14: ffffc90001d85060 R15: ffffc90001d85010
> [  945.284407] FS:  0000000000000000(0000) GS:ffff8882e66cf000(0000) knlGS:0000000000000000
> [  945.285262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  945.285884] CR2: 00007fa7ffdd31f4 CR3: 000000010540d000 CR4: 0000000000350ef0
> [  945.286683] Call Trace:
> [  945.286952]  <TASK>
> [  945.287184]  ? crypt_message+0x33f/0xad0 [cifs]
> [  945.287719]  crypto_gcm_encrypt+0x36/0xe0
> [  945.288152]  crypt_message+0x54a/0xad0 [cifs]
> [  945.288724]  smb3_init_transform_rq+0x277/0x300 [cifs]
> [  945.289300]  smb_send_rqst+0xa3/0x160 [cifs]
> [  945.289944]  cifs_call_async+0x178/0x340 [cifs]
> [  945.290514]  ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
> [  945.291177]  smb2_async_writev+0x3e3/0x670 [cifs]
> [  945.291759]  ? find_held_lock+0x32/0x90
> [  945.292212]  ? netfs_advance_write+0xf2/0x310
> [  945.292723]  netfs_advance_write+0xf2/0x310
> [  945.293210]  netfs_write_folio+0x346/0xcc0
> [  945.293689]  ? __pfx__raw_spin_unlock_irq+0x10/0x10
> [  945.294250]  netfs_writepages+0x117/0x460
> [  945.294724]  do_writepages+0xbe/0x170
> [  945.295152]  ? find_held_lock+0x32/0x90
> [  945.295600]  ? kvm_sched_clock_read+0x11/0x20
> [  945.296103]  __writeback_single_inode+0x56/0x4b0
> [  945.296643]  writeback_sb_inodes+0x229/0x550
> [  945.297140]  __writeback_inodes_wb+0x4c/0xe0
> [  945.297642]  wb_writeback+0x2f1/0x3f0
> [  945.298069]  wb_workfn+0x300/0x490
> [  945.298472]  process_one_work+0x1fe/0x590
> [  945.298949]  worker_thread+0x1ce/0x3c0
> [  945.299397]  ? __pfx_worker_thread+0x10/0x10
> [  945.299900]  kthread+0x119/0x210
> [  945.300285]  ? __pfx_kthread+0x10/0x10
> [  945.300729]  ret_from_fork+0x119/0x1b0
> [  945.301163]  ? __pfx_kthread+0x10/0x10
> [  945.301601]  ret_from_fork_asm+0x1a/0x30
> [  945.302055]  </TASK>
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/smb2ops.c | 95 +++++++++++++++++------------------------
>  1 file changed, 40 insertions(+), 55 deletions(-)

Nice catch.

What about below changes?  This way, you can keep only a single memory
allocation.  Allocating @sig also doesn't seem necessary.

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1468c16ea9b8..1e43d3e4993e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4207,7 +4207,7 @@ static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst
 	len += array_size(*num_sgs, sizeof(struct scatterlist));
 	*sensitive_size = len;
 
-	p = kvzalloc(len, GFP_NOFS);
+	p = kzalloc(len, GFP_NOFS);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
@@ -4371,7 +4371,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
 
-	kvfree_sensitive(creq, sensitive_size);
+	kfree_sensitive(creq, sensitive_size);
 	return rc;
 }
 

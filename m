Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1204685
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 20:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749589043; cv=none; b=g4LLw1BRwDXtt52yqpKYdEH9v52o5Rzfw+l1nFo+T09OX0DVaQCQOmju0a/5r3bKm7o6FIwGnzLivNNzZ6T8LQFEDKNHu7X5FR0uS4/3m0QHZYZhb/UatHvJ/hwN1Ruzh1QXIXuus8h6lzL15vvCkWkMgNTrcNLHcxE/eIFR8fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749589043; c=relaxed/simple;
	bh=QD/do5HEHsawSx1t1Zu+8fs0Dx8EUzNichGJlUt6gh8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=BjOQpWF5G8nz9nYvdt4uGYo8df+w8xJM84H2cslrpq4UkaGwAwR72WVM8egb936QeDGsp8Cjs2QIcWncVT8mdmqvWq4wyuH9cdFIv7+RBkMdzUAib0zgkWXEgPcgSY+jmsBIwEgLd5/Jrw5fNE9lGSJ5hT6z5rUCQaN+TYc5onM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=PZxqASRe; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="PZxqASRe"
Message-ID: <2c51f9f6a1f2c9536dbf1279af93fd42@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1749589039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zDEibroCDPv2r43p1B3vT/6JMDOEiK4XQv92H9uS4LI=;
	b=PZxqASReLLl9IrlQMgtZ2O7tHo9CvP0yVTU+0DpCsd3Nliwt1yHoy0ecP0K7RWvy9sRbjr
	I65UaJ+eH8Qatej3e3Yr87+dtkVUjsHtYVNxdjX/cq54kV41rCawcSA7312+rWo6aGOE+Y
	AqPEcy81J4tUW0zqFDZ3lAq7vGvkY90hy5F+2NtvBbRt6lseVm5Gl5XI2p36Ww5bs4R/b1
	kND13q4oPV30WMUicTPhuShr78WoJMzhxzHaGJg80fIz/Q63CCF0rvFj3m7ZiQDj1sGr0V
	p3iPbLs3a8GRaD5L2FbYNOCzyuC5b5XpobkN/KFlvO4ILDSjLEscCOekluDycw==
From: Paulo Alcantara <pc@manguebit.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH] smb: client: fix crypto buffers in non-linear memory
In-Reply-To: <55ghdkukynjbfofe5vvzwgpyedk3bspiqnrcapj62p4rgpx4ak@lehqpcw7j53g>
References: <20250610181929.607075-1-ematsumiya@suse.de>
 <8fdbb87d839df2f8bdacf5f52a63144c@manguebit.com>
 <wfjrf2secmx4amn7hc26pgqa2trkntqhibdcc763ciuctoseix@tfunrbu35pio>
 <55ghdkukynjbfofe5vvzwgpyedk3bspiqnrcapj62p4rgpx4ak@lehqpcw7j53g>
Date: Tue, 10 Jun 2025 17:57:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Enzo Matsumiya <ematsumiya@suse.de> writes:

> On 06/10, Enzo Matsumiya wrote:
>>On 06/10, Paulo Alcantara wrote:
>>>Enzo Matsumiya <ematsumiya@suse.de> writes:
>>>
>>>>The crypto API, through the scatterlist API, expects input buffers to be
>>>>in linear memory.  We handle this with the cifs_sg_set_buf() helper
>>>>that converts vmalloc'd memory to their corresponding pages.
>>>>
>>>>However, when we allocate our aead_request buffer (@creq in
>>>>smb2ops.c::crypt_message()), we do so with kvzalloc(), which possibly
>>>>puts aead_request->__ctx in vmalloc area.
>>>>
>>>>AEAD algorithm then uses ->__ctx for its private/internal data and
>>>>operations, and uses sg_set_buf() for such data on a few places.
>>>>
>>>>This works fine as long as @creq falls into kmalloc zone (small
>>>>requests) or vmalloc'd memory is still within linear range.
>>>>
>>>>Tasks' stacks are vmalloc'd by default (CONFIG_VMAP_STACK=y), so too
>>>>many tasks will increment the base stacks' addresses to a point where
>>>>virt_addr_valid(buf) will fail (BUG() in sg_set_buf()) when that
>>>>happens.
>>>>
>>>>In practice: too many parallel reads and writes on an encrypted mount
>>>>will trigger this bug.
>>>>
>>>>To fix this, allocate @creq with kzalloc() and allocate the input
>>>>scatterlist separately with kvcalloc().  To prevent future occurrences
>>>>also allocate @iv and @sign with kzalloc().
>>>>
>>>>Also drop smb2_aead_req_alloc() since we no longer need to align a
>>>>monolithic pointer.
>>>>
>>>>Backtrace:
>>>>
>>>>[  945.272081] ------------[ cut here ]------------
>>>>[  945.272774] kernel BUG at include/linux/scatterlist.h:209!
>>>>[  945.273520] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
>>>>[  945.274412] CPU: 7 UID: 0 PID: 56 Comm: kworker/u33:0 Kdump: loaded Not tainted 6.15.0-lku-11779-g8e9d6efccdd7-dirty #1 PREEMPT(voluntary)
>>>>[  945.275736] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
>>>>[  945.276877] Workqueue: writeback wb_workfn (flush-cifs-2)
>>>>[  945.277457] RIP: 0010:crypto_gcm_init_common+0x1f9/0x220
>>>>[  945.278018] Code: b0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 5c 58 e5 00 e9 58 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 04 24 01 00 00 00 48 8b
>>>>[  945.279992] RSP: 0018:ffffc90000a27360 EFLAGS: 00010246
>>>>[  945.280578] RAX: 0000000000000000 RBX: ffffc90001d85060 RCX: 0000000000000030
>>>>[  945.281376] RDX: 0000000000080000 RSI: 0000000000000000 RDI: ffffc90081d85070
>>>>[  945.282145] RBP: ffffc90001d85010 R08: ffffc90001d85000 R09: 0000000000000000
>>>>[  945.282898] R10: ffffc90001d85090 R11: 0000000000001000 R12: ffffc90001d85070
>>>>[  945.283656] R13: ffff888113522948 R14: ffffc90001d85060 R15: ffffc90001d85010
>>>>[  945.284407] FS:  0000000000000000(0000) GS:ffff8882e66cf000(0000) knlGS:0000000000000000
>>>>[  945.285262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>[  945.285884] CR2: 00007fa7ffdd31f4 CR3: 000000010540d000 CR4: 0000000000350ef0
>>>>[  945.286683] Call Trace:
>>>>[  945.286952]  <TASK>
>>>>[  945.287184]  ? crypt_message+0x33f/0xad0 [cifs]
>>>>[  945.287719]  crypto_gcm_encrypt+0x36/0xe0
>>>>[  945.288152]  crypt_message+0x54a/0xad0 [cifs]
>>>>[  945.288724]  smb3_init_transform_rq+0x277/0x300 [cifs]
>>>>[  945.289300]  smb_send_rqst+0xa3/0x160 [cifs]
>>>>[  945.289944]  cifs_call_async+0x178/0x340 [cifs]
>>>>[  945.290514]  ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
>>>>[  945.291177]  smb2_async_writev+0x3e3/0x670 [cifs]
>>>>[  945.291759]  ? find_held_lock+0x32/0x90
>>>>[  945.292212]  ? netfs_advance_write+0xf2/0x310
>>>>[  945.292723]  netfs_advance_write+0xf2/0x310
>>>>[  945.293210]  netfs_write_folio+0x346/0xcc0
>>>>[  945.293689]  ? __pfx__raw_spin_unlock_irq+0x10/0x10
>>>>[  945.294250]  netfs_writepages+0x117/0x460
>>>>[  945.294724]  do_writepages+0xbe/0x170
>>>>[  945.295152]  ? find_held_lock+0x32/0x90
>>>>[  945.295600]  ? kvm_sched_clock_read+0x11/0x20
>>>>[  945.296103]  __writeback_single_inode+0x56/0x4b0
>>>>[  945.296643]  writeback_sb_inodes+0x229/0x550
>>>>[  945.297140]  __writeback_inodes_wb+0x4c/0xe0
>>>>[  945.297642]  wb_writeback+0x2f1/0x3f0
>>>>[  945.298069]  wb_workfn+0x300/0x490
>>>>[  945.298472]  process_one_work+0x1fe/0x590
>>>>[  945.298949]  worker_thread+0x1ce/0x3c0
>>>>[  945.299397]  ? __pfx_worker_thread+0x10/0x10
>>>>[  945.299900]  kthread+0x119/0x210
>>>>[  945.300285]  ? __pfx_kthread+0x10/0x10
>>>>[  945.300729]  ret_from_fork+0x119/0x1b0
>>>>[  945.301163]  ? __pfx_kthread+0x10/0x10
>>>>[  945.301601]  ret_from_fork_asm+0x1a/0x30
>>>>[  945.302055]  </TASK>
>>>>
>>>>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>---
>>>> fs/smb/client/smb2ops.c | 95 +++++++++++++++++------------------------
>>>> 1 file changed, 40 insertions(+), 55 deletions(-)
>>>
>>>Nice catch.
>>
>>Thanks :)
>>
>>>What about below changes?  This way, you can keep only a single memory
>>>allocation.
>>
>>I had trouble in the past kmalloc'ing > 1MiB (for these tests I was
>>using 4M payloads, which means about 33k sg entries, yielding about 1M
>>buffer).
>
> Ugh I was looking at the wrong numbers... it's 1027 sg entries, ending
> with a 33408 byte buffer.
>
> Now I'm even more curious how this ends up in vmalloc memory...

-ENOCOFFEE probably :-)

Let me know if you find any problems with it.

Do think we should add below to the patch as well

Fixes: d08089f649a0 ("cifs: Change the I/O paths to use an iterator rather than a page list")
Cc: stable@vger.kernel.org

Thanks!

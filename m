Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0441263C91
	for <linux-cifs@vger.kernel.org>; Tue, 10 Jun 2025 20:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749587853; cv=none; b=I1fVzmeBy1K5uBLxamcQso7bSLsKVoJrzBE/g8JzohrApyT3QyEN92ClFAm6T7sVNgxoVUlCWs4Ye+TLrRCRZ+QLz0L9kINVSWqM1zeEEenonGXi49WiIvuxBLWAwGA9Xk0ePH7Umt1G+dI7jz7ducphvBR42o8sXOyjMz+kU1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749587853; c=relaxed/simple;
	bh=+P5/Gtfb07GmXdBhMDKFGVXb3nxXzMlwE8jLl7l/WMg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bwnb3n7XdemhxgAvig8c76oRUlLz0jWniCwfDwsS43+jLlhil2nd1UIp8BCADZJulKzZ/Mjiw/38bAnbwi3ermd8yTCnZlbTsVS/bJTlpSjVmNMj+mo8PVNxbyufk+4aNgBrYP77Hmm2DaSyKNomN/1XHB16U0gJYnEAVfG72S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UYysFeJm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jisGjUT8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=UYysFeJm; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=jisGjUT8; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UYysFeJm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jisGjUT8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="UYysFeJm";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="jisGjUT8"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A09D52128F;
	Tue, 10 Jun 2025 20:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749587848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osaESHoowmo5SGIvwBpJ7jzl6p9QRHANqs+o9pTQzN0=;
	b=UYysFeJmj+eycpaQzEAD173XhoYQY041W06NZz7yCoHfRW4++rPelTRsNdBOiFJA1WQMQv
	/+KADSSrLss6caKwLqaLC9woMW4z76KP1Z5t8ckNXBkoou5v+iKynZ02K8opgNH9NS+H+Y
	WW1LLo1N6P9P0r4/ktBc0Z5Bo4UmJT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749587848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osaESHoowmo5SGIvwBpJ7jzl6p9QRHANqs+o9pTQzN0=;
	b=jisGjUT8A0WDNwdqApMH3WKwUY3a0QyPb7TesPc0zWgaLLSCNAW6QqxZxcZ3Z+MjD/QBIK
	9w49wQWxmHfJZHBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UYysFeJm;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jisGjUT8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1749587848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osaESHoowmo5SGIvwBpJ7jzl6p9QRHANqs+o9pTQzN0=;
	b=UYysFeJmj+eycpaQzEAD173XhoYQY041W06NZz7yCoHfRW4++rPelTRsNdBOiFJA1WQMQv
	/+KADSSrLss6caKwLqaLC9woMW4z76KP1Z5t8ckNXBkoou5v+iKynZ02K8opgNH9NS+H+Y
	WW1LLo1N6P9P0r4/ktBc0Z5Bo4UmJT0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1749587848;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=osaESHoowmo5SGIvwBpJ7jzl6p9QRHANqs+o9pTQzN0=;
	b=jisGjUT8A0WDNwdqApMH3WKwUY3a0QyPb7TesPc0zWgaLLSCNAW6QqxZxcZ3Z+MjD/QBIK
	9w49wQWxmHfJZHBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2D6DF139E2;
	Tue, 10 Jun 2025 20:37:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CWGHOYeXSGjLKQAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Tue, 10 Jun 2025 20:37:27 +0000
Date: Tue, 10 Jun 2025 17:37:25 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH] smb: client: fix crypto buffers in non-linear memory
Message-ID: <wfjrf2secmx4amn7hc26pgqa2trkntqhibdcc763ciuctoseix@tfunrbu35pio>
References: <20250610181929.607075-1-ematsumiya@suse.de>
 <8fdbb87d839df2f8bdacf5f52a63144c@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <8fdbb87d839df2f8bdacf5f52a63144c@manguebit.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,microsoft.com,talpey.com,suse.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FROM_EQ_ENVFROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim,suse.de:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+]
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: A09D52128F
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Score: -4.01

On 06/10, Paulo Alcantara wrote:
>Enzo Matsumiya <ematsumiya@suse.de> writes:
>
>> The crypto API, through the scatterlist API, expects input buffers to be
>> in linear memory.  We handle this with the cifs_sg_set_buf() helper
>> that converts vmalloc'd memory to their corresponding pages.
>>
>> However, when we allocate our aead_request buffer (@creq in
>> smb2ops.c::crypt_message()), we do so with kvzalloc(), which possibly
>> puts aead_request->__ctx in vmalloc area.
>>
>> AEAD algorithm then uses ->__ctx for its private/internal data and
>> operations, and uses sg_set_buf() for such data on a few places.
>>
>> This works fine as long as @creq falls into kmalloc zone (small
>> requests) or vmalloc'd memory is still within linear range.
>>
>> Tasks' stacks are vmalloc'd by default (CONFIG_VMAP_STACK=y), so too
>> many tasks will increment the base stacks' addresses to a point where
>> virt_addr_valid(buf) will fail (BUG() in sg_set_buf()) when that
>> happens.
>>
>> In practice: too many parallel reads and writes on an encrypted mount
>> will trigger this bug.
>>
>> To fix this, allocate @creq with kzalloc() and allocate the input
>> scatterlist separately with kvcalloc().  To prevent future occurrences
>> also allocate @iv and @sign with kzalloc().
>>
>> Also drop smb2_aead_req_alloc() since we no longer need to align a
>> monolithic pointer.
>>
>> Backtrace:
>>
>> [  945.272081] ------------[ cut here ]------------
>> [  945.272774] kernel BUG at include/linux/scatterlist.h:209!
>> [  945.273520] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC NOPTI
>> [  945.274412] CPU: 7 UID: 0 PID: 56 Comm: kworker/u33:0 Kdump: loaded Not tainted 6.15.0-lku-11779-g8e9d6efccdd7-dirty #1 PREEMPT(voluntary)
>> [  945.275736] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-2-gc13ff2cd-prebuilt.qemu.org 04/01/2014
>> [  945.276877] Workqueue: writeback wb_workfn (flush-cifs-2)
>> [  945.277457] RIP: 0010:crypto_gcm_init_common+0x1f9/0x220
>> [  945.278018] Code: b0 00 00 00 48 83 c4 08 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 48 c7 c0 00 00 00 80 48 2b 05 5c 58 e5 00 e9 58 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 c7 04 24 01 00 00 00 48 8b
>> [  945.279992] RSP: 0018:ffffc90000a27360 EFLAGS: 00010246
>> [  945.280578] RAX: 0000000000000000 RBX: ffffc90001d85060 RCX: 0000000000000030
>> [  945.281376] RDX: 0000000000080000 RSI: 0000000000000000 RDI: ffffc90081d85070
>> [  945.282145] RBP: ffffc90001d85010 R08: ffffc90001d85000 R09: 0000000000000000
>> [  945.282898] R10: ffffc90001d85090 R11: 0000000000001000 R12: ffffc90001d85070
>> [  945.283656] R13: ffff888113522948 R14: ffffc90001d85060 R15: ffffc90001d85010
>> [  945.284407] FS:  0000000000000000(0000) GS:ffff8882e66cf000(0000) knlGS:0000000000000000
>> [  945.285262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  945.285884] CR2: 00007fa7ffdd31f4 CR3: 000000010540d000 CR4: 0000000000350ef0
>> [  945.286683] Call Trace:
>> [  945.286952]  <TASK>
>> [  945.287184]  ? crypt_message+0x33f/0xad0 [cifs]
>> [  945.287719]  crypto_gcm_encrypt+0x36/0xe0
>> [  945.288152]  crypt_message+0x54a/0xad0 [cifs]
>> [  945.288724]  smb3_init_transform_rq+0x277/0x300 [cifs]
>> [  945.289300]  smb_send_rqst+0xa3/0x160 [cifs]
>> [  945.289944]  cifs_call_async+0x178/0x340 [cifs]
>> [  945.290514]  ? __pfx_smb2_writev_callback+0x10/0x10 [cifs]
>> [  945.291177]  smb2_async_writev+0x3e3/0x670 [cifs]
>> [  945.291759]  ? find_held_lock+0x32/0x90
>> [  945.292212]  ? netfs_advance_write+0xf2/0x310
>> [  945.292723]  netfs_advance_write+0xf2/0x310
>> [  945.293210]  netfs_write_folio+0x346/0xcc0
>> [  945.293689]  ? __pfx__raw_spin_unlock_irq+0x10/0x10
>> [  945.294250]  netfs_writepages+0x117/0x460
>> [  945.294724]  do_writepages+0xbe/0x170
>> [  945.295152]  ? find_held_lock+0x32/0x90
>> [  945.295600]  ? kvm_sched_clock_read+0x11/0x20
>> [  945.296103]  __writeback_single_inode+0x56/0x4b0
>> [  945.296643]  writeback_sb_inodes+0x229/0x550
>> [  945.297140]  __writeback_inodes_wb+0x4c/0xe0
>> [  945.297642]  wb_writeback+0x2f1/0x3f0
>> [  945.298069]  wb_workfn+0x300/0x490
>> [  945.298472]  process_one_work+0x1fe/0x590
>> [  945.298949]  worker_thread+0x1ce/0x3c0
>> [  945.299397]  ? __pfx_worker_thread+0x10/0x10
>> [  945.299900]  kthread+0x119/0x210
>> [  945.300285]  ? __pfx_kthread+0x10/0x10
>> [  945.300729]  ret_from_fork+0x119/0x1b0
>> [  945.301163]  ? __pfx_kthread+0x10/0x10
>> [  945.301601]  ret_from_fork_asm+0x1a/0x30
>> [  945.302055]  </TASK>
>>
>> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>> ---
>>  fs/smb/client/smb2ops.c | 95 +++++++++++++++++------------------------
>>  1 file changed, 40 insertions(+), 55 deletions(-)
>
>Nice catch.

Thanks :)

>What about below changes?  This way, you can keep only a single memory
>allocation.

I had trouble in the past kmalloc'ing > 1MiB (for these tests I was
using 4M payloads, which means about 33k sg entries, yielding about 1M
buffer).

While your suggestion does seem to fix the bug (briefly tested), I'm
not sure how safe it would be for different scenarios (kernel config,
SMB2 rwsize, arch, host available memory, etc).

Given that the current code evidently ends up using vmalloc memory
(kvzalloc fallthrough) at some point, I wonder how such cases would
behave with kmalloc only -- ENOMEM?  longer wait to alloc?

I'll test and let you know.

> Allocating @sig also doesn't seem necessary.

I actually started this fix by allocating @sig hehe so even after
removing the monolithic @p, I left that as a prevention.


Cheers,

Enzo

>diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>index 1468c16ea9b8..1e43d3e4993e 100644
>--- a/fs/smb/client/smb2ops.c
>+++ b/fs/smb/client/smb2ops.c
>@@ -4207,7 +4207,7 @@ static void *smb2_aead_req_alloc(struct crypto_aead *tfm, const struct smb_rqst
> 	len += array_size(*num_sgs, sizeof(struct scatterlist));
> 	*sensitive_size = len;
>
>-	p = kvzalloc(len, GFP_NOFS);
>+	p = kzalloc(len, GFP_NOFS);
> 	if (!p)
> 		return ERR_PTR(-ENOMEM);
>
>@@ -4371,7 +4371,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
> 	if (!rc && enc)
> 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
>
>-	kvfree_sensitive(creq, sensitive_size);
>+	kfree_sensitive(creq, sensitive_size);
> 	return rc;
> }
>
>

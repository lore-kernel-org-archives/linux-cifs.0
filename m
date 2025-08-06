Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11C42A9D
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754483050; cv=none; b=B/2PLVz/rkv/iPTp4exmo+XYVp4vWaf86ZTbHxy4jbqthJPnoSCWnYEyOp4+dgWbMiydgsaB05/xTyV/RwepZHrUfzFGUcuPrGZcqd8XQWutqqEFpxcUNkY0bUK/o2fAVQmWVC6x03PJCtHNUDOZJU4da4BJwiFnCgGQ37sFtM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754483050; c=relaxed/simple;
	bh=pD8SRkQWG0PIROwHN6tmstHYSP0kqxni6vNqZLKe3Ss=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ieAiVwONkBIhaTCdrUHupnTO/vd102Qw3thzCCcGEiaKNxj6KbhVneQN8zxXB9YopdrI+UhEwKiv3pmrnC2Z7UIq3a+MmxMLMdEXMt4//P94y8/8R9vNUeKpO33rRFNQl8S9OwslJHpFP4Dz6Fv0LlVC8+DXhS4W1Aj0ueXHy8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=huGqT9qA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W3hK9knr; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=huGqT9qA; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=W3hK9knr; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="huGqT9qA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W3hK9knr";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="huGqT9qA";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="W3hK9knr"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 80EF91FE23;
	Wed,  6 Aug 2025 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754483046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVHL1mkr6Rdm1b0S7LAgvuYOe8WtH2iV3uj4ptkG61U=;
	b=huGqT9qAIYCYU0dB6TeAo7Oo01MLibBWb6qUHoKml/95Gh61bpceTLdyoAF5bj7bpNWQJo
	Sj3RR8/QAXyBtOJ11WOPi/hDFTrT5OgRgiT3iMeZqYTJrJy3IdB0t7tTlWqkI5aZN5Ysiq
	IXreATj8t+dLJfz/QzJQFpL1ktnmlR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754483046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVHL1mkr6Rdm1b0S7LAgvuYOe8WtH2iV3uj4ptkG61U=;
	b=W3hK9knr/+X4zwOcamq75cUQGdXDeDzKQvIbNeQEVF5n2DqpP8TexYk5yI+rTFkvOO8fpW
	rLG/l2b/Xa8wkZBQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=huGqT9qA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=W3hK9knr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754483046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVHL1mkr6Rdm1b0S7LAgvuYOe8WtH2iV3uj4ptkG61U=;
	b=huGqT9qAIYCYU0dB6TeAo7Oo01MLibBWb6qUHoKml/95Gh61bpceTLdyoAF5bj7bpNWQJo
	Sj3RR8/QAXyBtOJ11WOPi/hDFTrT5OgRgiT3iMeZqYTJrJy3IdB0t7tTlWqkI5aZN5Ysiq
	IXreATj8t+dLJfz/QzJQFpL1ktnmlR8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754483046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVHL1mkr6Rdm1b0S7LAgvuYOe8WtH2iV3uj4ptkG61U=;
	b=W3hK9knr/+X4zwOcamq75cUQGdXDeDzKQvIbNeQEVF5n2DqpP8TexYk5yI+rTFkvOO8fpW
	rLG/l2b/Xa8wkZBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 08BB113AA8;
	Wed,  6 Aug 2025 12:24:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id x78EMGVJk2gWWAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Wed, 06 Aug 2025 12:24:05 +0000
Date: Wed, 6 Aug 2025 09:24:03 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: Steve French <smfrench@gmail.com>, pshilov@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH V2 0/4] Fix mid_q_entry memory leaks in SMB client
Message-ID: <fk2zvqpxznijk27ourdtyiezi3nl2b6nwsfpjnue4phne5rnqb@d66oqhlwxygs>
References: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
 <CAH2r5mssz19Qr+fmY62BnHOzwjQmWWU=wHXEVFkyTRGaWn-t0g@mail.gmail.com>
 <c980644d-0be1-4a88-890d-349b44ada024@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <c980644d-0be1-4a88-890d-349b44ada024@huaweicloud.com>
X-Spamd-Result: default: False [-4.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,microsoft.com,vger.kernel.org,lists.samba.org,huawei.com];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.de:+];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Spam-Flag: NO
X-Spam-Level: 
X-Rspamd-Queue-Id: 80EF91FE23
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Score: -4.01

On 08/06, Wang Zhaolong wrote:
>>The first three patches (cleanup) look fine and have added to
>>cifs-2.6.git for-next (also added Enzo Acked-by) but the fourth patch
>>("smb: client: fix mid_q_entry memleak leak with per-mid locking")
>>causes xfstest generic/001 to fail with signing enabled.  See
>>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
5/builds/58/steps/34/logs/stdio
>>and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/build=
ers/5/builds/59/steps/34/logs/stdio
>>
>
>I am unable to view any information in the link above. Is this information
>only visible to logged-in users?

That one is publicly visible.

If you're using a Chrome-based browser, you might need to whitelist the
website though as it doesn't use HTTPS.

> ...
>>
>>(it worked without the patch see e.g.
>>http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builders/=
5/builds/60
>>and http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/build=
ers/5/builds/56)
>>
>>On Tue, Aug 5, 2025 at 1:54=E2=80=AFAM Wang Zhaolong
>><wangzhaolong@huaweicloud.com> wrote:
>
>
>It's quite strange that the lock reported in the stack trace is an internal
>lock of the crypto module, which only protects the internal logic of crypt=
o.
>Moreover, I have not yet found a path where the callback for cifs registra=
tion
>is executed within the scope of this lock.
>
>```c
>// crypto/api.c
>static struct crypto_alg *crypto_alg_lookup(const char *name, u32 type,
>					    u32 mask)
>{
>	const u32 fips =3D CRYPTO_ALG_FIPS_INTERNAL;
>	struct crypto_alg *alg;
>	u32 test =3D 0;
>
>	if (!((type | mask) & CRYPTO_ALG_TESTED))
>		test |=3D CRYPTO_ALG_TESTED;
>
>	down_read(&crypto_alg_sem);
>	...
>	up_read(&crypto_alg_sem);
>	return alg;
>```
>More information is needed to confirm this issue. Could you please provide=
 it?

In summary the problem is in mid_execute_callback() when callback is
smb2_writev_callback.

Cleaning it up for clarity:

---- begin ----
     cifsd/24912 is trying to lock crypto_alg_sem at crypto_alg_lookup+0x40=
/0x120
     cifsd/24912 is holding &temp->mid_lock at mid_execute_callback+0x19/0x=
40

     Reversed call trace:
     cifs_demultiplex_thread
       mid_execute_callback
         <lock mid_lock>
         smb2_writev_callback
           smb2_check_receive
             smb2_verify_signature
               smb3_calc_signature
                 cifs_alloc_hash
                   crypto_alloc_tfm_node
                     crypto_alg_mod_lookup
                       crypto_alg_lookup
                         down_read
                           lock_acquire
                             __lock_acquire
                               >>> BUG() here <<<
         ...
         <unlock mid_lock>
---- end ----

Before the patch I sent you privately yesterday, I confirmed this
by locking mid_lock directly only for cifs_compound*callback and
cifs_wake_up_task.

Also you need to make sure to use a reproducer/tester that uses writev,
which your poc.c from original bug report doesn't.

HTH


Cheers,

Enzo

Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56632E36E3
	for <linux-cifs@vger.kernel.org>; Fri,  4 Jul 2025 18:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751654785; cv=none; b=rWB1gj3A+8qv4YhZ5hfvH34ZOumevSd9O905DvWVKAw0e1PDRagkDWqxxXg53N7ccuBxiZATPQ4BLda0SPmigYxqpWZ1nUXrmacTyxx79MGksMO5mFOhvKTOe1lWJ+c1MEbvDGIwEcONQI9VFv3s+O4hqY8QrKZAwR6zQ/8u7/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751654785; c=relaxed/simple;
	bh=r+vsErjR48a2+ziYgB/rgg83cKEN94NGCwy8WIq2bCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LInOVrihWqAjyu/PEXN76FLm5zBkTwUnO7X546LN5p/yryR0SbWyxSg/nfXmDz9ItG4yhmKAx29SJCoyy8gw8JbF87aYXQgPniGfwICu9zgMVNeagRtMO3rwbtRohZlfxpMgMT0SCye/UDxaylvKJ5WBaabP9+XjO4NLm2QhXWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=LznVmqf3; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=V/jfl7m8; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=sL8Lcwh+; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ifbxTH8m; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="LznVmqf3";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="V/jfl7m8";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="sL8Lcwh+";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ifbxTH8m"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 78E521F456;
	Fri,  4 Jul 2025 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751654780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pE1qCT1MPo3KLvSaq3Ca6a4R6hwdHDEB0wC8BXZViPs=;
	b=LznVmqf3PoqKlzaCdrtkETmNdZ75A+cT4Z59a2E27P4mKnOiuauwySgGtt+ky28kbHjagb
	a9ffFYy/GqW0I6AG/IPYlSAaHzeU/N/N2JLydS1VX47b6efLAGOLWfJ/td+BHzQqPgz1Kl
	39SuY+kT34r3NBQQJ+Y8GPds5cyIl2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751654780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pE1qCT1MPo3KLvSaq3Ca6a4R6hwdHDEB0wC8BXZViPs=;
	b=V/jfl7m8fmXhMb9+gueTlZx2J82v53NZ012WXlZV9wGDeMQJm+h6ZcQ0Q2wdgedHCG0B4H
	RNXLQg20UHvfP0DA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1751654779; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pE1qCT1MPo3KLvSaq3Ca6a4R6hwdHDEB0wC8BXZViPs=;
	b=sL8Lcwh+B5Sr8ZteYbZumE1PtVgODEyh2MQJJ9aHV+7Dol9iXRiLfNO0ObAktLyi8JP8Mn
	nGX+aUY/TsWElbZVwjVr7cBo3F2+oLQr4VVYtXHglKdnTBX/q2qUlEi8GULt82Ys8cbMSM
	A4ylelLzVY0S8k2Dg4J27pFA6gUJDXk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1751654779;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pE1qCT1MPo3KLvSaq3Ca6a4R6hwdHDEB0wC8BXZViPs=;
	b=ifbxTH8mZu+WbyYl0K04aPo4dNMCen9wd3RcgmTW1MG9DnkMfdU6sAklxtte9c9UDyZ2So
	JhsfPMaG6LY665Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0396B13757;
	Fri,  4 Jul 2025 18:46:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LxkvL3ohaGidQAAAD6G6ig
	(envelope-from <ematsumiya@suse.de>); Fri, 04 Jul 2025 18:46:18 +0000
Date: Fri, 4 Jul 2025 15:46:16 -0300
From: Enzo Matsumiya <ematsumiya@suse.de>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Subject: Re: [PATCH 1/4] smb: client: fix UAF in async decryption
Message-ID: <tq4kn3v4yfkglc2fivh2nhe2vjdt254uyquoog2tgjo5qlwze5@umefb3bo5iy3>
References: <20240926174616.229666-1-ematsumiya@suse.de>
 <20240926174616.229666-2-ematsumiya@suse.de>
 <da3525d3-5b99-4d90-820c-c5cef3d68613@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <da3525d3-5b99-4d90-820c-c5cef3d68613@huaweicloud.com>
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,manguebit.com,microsoft.com,talpey.com,suse.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -3.80

Hi Wang,

On 07/04, Wang Zhaolong wrote:
>
>Hi Enzo,
>
>I've been testing the CVE-2024-50047 fix (this patch) and encountered
>a NULL pointer dereference when using hardware crypto acceleration.
>I'd like to discuss a potential issue with the patch and propose
>a solution.
>
>When mounting CIFS with encryption enabled and using hardware crypto
>modules, I triggered a NULL pointer dereference in the hardware
>encryption driver.
>
>The patch removed the asynchronous callback mechanism from crypt_message():
>>index 1ee2dd4a1cae..177173072bfa 100644
>>--- a/fs/smb/client/smb2ops.c
>>+++ b/fs/smb/client/smb2ops.c
>>@@ -4309,7 +4309,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>>   */
>>  static int
>>  crypt_message(struct TCP_Server_Info *server, int num_rqst,
>>-	      struct smb_rqst *rqst, int enc)
>>+	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
>>  {
>>  	struct smb2_transform_hdr *tr_hdr =
>>  		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
>>@@ -4320,8 +4320,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>>  	u8 key[SMB3_ENC_DEC_KEY_SIZE];
>>  	struct aead_request *req;
>>  	u8 *iv;
>>-	DECLARE_CRYPTO_WAIT(wait);
>>-	struct crypto_aead *tfm;
>>  	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
>>  	void *creq;
>>  	size_t sensitive_size;
>>@@ -4333,14 +4331,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>>  		return rc;
>>  	}
>>-	rc = smb3_crypto_aead_allocate(server);
>>-	if (rc) {
>>-		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
>>-		return rc;
>>-	}
>>-
>>-	tfm = enc ? server->secmech.enc : server->secmech.dec;
>>-
>>  	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
>>  		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
>>  		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
>>@@ -4380,11 +4370,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>>  	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
>>  	aead_request_set_ad(req, assoc_data_len);
>>-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>>-				  crypto_req_done, &wait);
>>-
>>-	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
>>-				: crypto_aead_decrypt(req), &wait);
>>+	rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
>>  	if (!rc && enc)
>>  		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
>
>
>The patch removed the asynchronous callback mechanism from crypt_message(),
>This will cause the driver to immediately return -115(-EINPROGRESS) when calling
>crypto_aead_encrypt(). And when the function exits, it will call
>kvfree_sensitive(creq, sensitive_size) to free the `creq` buffer, which still
>contains the `req` request. This leads to a crash when the driver
>processes the `req` later.
>
>The commit message states "it's always going to be a synchronous operation",
>but this assumption doesn't hold for hardware crypto implementations.
>According to the kernel's AEAD API documentation[1], crypto_aead_encrypt/decrypt
>operations can be asynchronous:
>
>These functions may return -EINPROGRESS or -EBUSY for async operations
>The API provides aead_request_set_callback() specifically for async handling
>Hardware accelerators commonly implement async operations for performance
>Without crypto_wait_req(), the code immediately frees the request buffer
>with kvfree_sensitive(), leading to use-after-free when the async crypto
>worker accesses it.

The way I see this is all on the HW crypto driver implementation not
respecting the mask in crypto_alloc_aead() -- IIRC, for API users, it must
be either 0 or CRYPTO_ALG_ASYNC.

Even though cifs called crypto_wait_req() with crypto_req_done()
callback, we never allocated AEAD TFM with CRYPTO_ALG_ASYNC, so this has
been always effectivelly a synchronous op.

To fix this correctly, it'd need to be done on the HW crypto driver
itself -- not in crypto API, not in cifs.

If you want to circumvent this particular issue on cifs side, you'd need
to implement the whole mechanism to hold the unencrypted request until
your callback is called, while taking into consideration reconnects,
which can get quite tricky for writes especially (this is not fun,
believe me, I tried).

>Questions:
>
>- What was the specific rationale for assuming synchronous-only operations?

We never allocated AEAD TFMs with CRYPTO_ALG_ASYNC (see above), so it
was not a mere assumption, it was (is) an expectation.

>- Were there concerns about the async mechanism interfering with the CVE fix?

Not really, no -- again, cifs never had async AEAD nor the mechanisms to
handle it.

FWIW the CVE came after my fix, until then it was "just" a bug fix.

>I believe we can restore the async handling without affecting the CVE fix:

Restoring the crypto_wait_req/callback code should fix the particular
crash you get, but the calling thread would still block, completely
invalidating any async benefit that you might be otherwise expecting.


Cheers,

Enzo

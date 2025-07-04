Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904B2F365E
	for <linux-cifs@vger.kernel.org>; Fri,  4 Jul 2025 12:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751633699; cv=none; b=n6i2jv0h0mCHtr3nyd6w7bBJKFkCeP+dJ9JM+u67zIA+0tG7TbjO3sGj0az3vh0TYv/WANAuaAKjEB8YFbqoC2kL4C7AG5TmvZncbhg+yV/SB3d5WRdULn1yWZS4TyAKRsvq9zI+XD4l/MzVp6DOelE6IpLYkB1W0BqsdU+24pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751633699; c=relaxed/simple;
	bh=0eAC4jsJPmO4A83aW1MKa8iRgmyXvBjxxIrZm9pQNak=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UT2P5FmOtqH7Rw45GzsxUBw/EAfgxEd+5WKunFn5uTTn+bCTXjtCWYEEVbfpZ5mcIdfo5ySnj/apYc9F8jQenPLunPJIfRTtnG3w2eZ9ITTsRBRfWG2ZGjiYbZOAzt//JqeeqQY3rGyWByBOMwSdTeD7Mc4VAbxPxkkhU55C90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bYYWL4nl9zKHMfv
	for <linux-cifs@vger.kernel.org>; Fri,  4 Jul 2025 20:54:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1E9A11A0B95
	for <linux-cifs@vger.kernel.org>; Fri,  4 Jul 2025 20:54:53 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP3 (Coremail) with SMTP id _Ch0CgCHNSMYz2doBQCGAg--.2105S3;
	Fri, 04 Jul 2025 20:54:50 +0800 (CST)
Message-ID: <da3525d3-5b99-4d90-820c-c5cef3d68613@huaweicloud.com>
Date: Fri, 4 Jul 2025 20:54:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] smb: client: fix UAF in async decryption
To: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 henrique.carvalho@suse.com
References: <20240926174616.229666-1-ematsumiya@suse.de>
 <20240926174616.229666-2-ematsumiya@suse.de>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <20240926174616.229666-2-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgCHNSMYz2doBQCGAg--.2105S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFyxCF48urWfJFW3WF18uFg_yoWrGFy5pF
	4FyFWYvrs5Jw1vgry8JayrAFyFvrZakw43Gr4kCw17ur9xJr1vvry2kFW5uFy5CF48G34j
	9r4kZw1Sv3W2yFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/


Hi Enzo,

I've been testing the CVE-2024-50047 fix (this patch) and encountered
a NULL pointer dereference when using hardware crypto acceleration.
I'd like to discuss a potential issue with the patch and propose
a solution.

When mounting CIFS with encryption enabled and using hardware crypto
modules, I triggered a NULL pointer dereference in the hardware
encryption driver.

The patch removed the asynchronous callback mechanism from crypt_message():
> index 1ee2dd4a1cae..177173072bfa 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4309,7 +4309,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>    */
>   static int
>   crypt_message(struct TCP_Server_Info *server, int num_rqst,
> -	      struct smb_rqst *rqst, int enc)
> +	      struct smb_rqst *rqst, int enc, struct crypto_aead *tfm)
>   {
>   	struct smb2_transform_hdr *tr_hdr =
>   		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
> @@ -4320,8 +4320,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>   	u8 key[SMB3_ENC_DEC_KEY_SIZE];
>   	struct aead_request *req;
>   	u8 *iv;
> -	DECLARE_CRYPTO_WAIT(wait);
> -	struct crypto_aead *tfm;
>   	unsigned int crypt_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
>   	void *creq;
>   	size_t sensitive_size;
> @@ -4333,14 +4331,6 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>   		return rc;
>   	}
>   
> -	rc = smb3_crypto_aead_allocate(server);
> -	if (rc) {
> -		cifs_server_dbg(VFS, "%s: crypto alloc failed\n", __func__);
> -		return rc;
> -	}
> -
> -	tfm = enc ? server->secmech.enc : server->secmech.dec;
> -
>   	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
>   		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
>   		rc = crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);
> @@ -4380,11 +4370,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
>   	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
>   	aead_request_set_ad(req, assoc_data_len);
>   
> -	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				  crypto_req_done, &wait);
> -
> -	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req)
> -				: crypto_aead_decrypt(req), &wait);
> +	rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
>   
>   	if (!rc && enc)
>   		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);


The patch removed the asynchronous callback mechanism from crypt_message(),
This will cause the driver to immediately return -115(-EINPROGRESS) when calling
crypto_aead_encrypt(). And when the function exits, it will call
kvfree_sensitive(creq, sensitive_size) to free the `creq` buffer, which still
contains the `req` request. This leads to a crash when the driver
processes the `req` later.

The commit message states "it's always going to be a synchronous operation",
but this assumption doesn't hold for hardware crypto implementations.
According to the kernel's AEAD API documentation[1], crypto_aead_encrypt/decrypt
operations can be asynchronous:

These functions may return -EINPROGRESS or -EBUSY for async operations
The API provides aead_request_set_callback() specifically for async handling
Hardware accelerators commonly implement async operations for performance
Without crypto_wait_req(), the code immediately frees the request buffer
with kvfree_sensitive(), leading to use-after-free when the async crypto
worker accesses it.

Questions:

- What was the specific rationale for assuming synchronous-only operations?
- Were there concerns about the async mechanism interfering with the CVE fix?

I believe we can restore the async handling without affecting the CVE fix:

Best regards,
Wang Zhaolong

[1] https://docs.kernel.org/crypto/api-aead.html


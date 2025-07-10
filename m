Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A12749C1;
	Thu, 10 Jul 2025 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752189512; cv=none; b=Dy8v3YKRsJ7IyQVjqMVqjouFmLlcjX3IaauxWk1IxKjQzPwAn3YMCgVVTwkrGAFVoiEiTVux1fdiG7eNl9A0PPru9ctUOtsFL9KLwe0XduY6D0TXr8UEwSQAtOQnOWKtREg8RD1F4kUYcONeIGLMbpO6mGPCSo3ZPdgJKhglHZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752189512; c=relaxed/simple;
	bh=aodGrJ/fTeAXeqty12g3ynGJwycpDTx4HpYmcMWtMl4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=B7cbJ3jmtPiadpODi4KJtCnOuWQNv9PbN3FQD9YZEq5lfqAZfcVhiLqB+/C5A9Ly1Q5S6O5zJdvxDsSF41oY5P/JuGdfTcCeovVuoYwKbD7oBmA2tCUnCEO9C3Nl9fg7znnCAaGN1qTurmL/esvIakSnIubdukcjovWnZ3s0i/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=HLZ0BNO7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="HLZ0BNO7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hkTY2Grgv3lxoA658Ko78kXLgI7Ac/QSzydWzjTrTvM=; b=HLZ0BNO7VxUIIj7URIpk/LQIlv
	Y4DEH0kmjHX5x2lw/7+gV6odgnHKLGjOB1V/tYS6NcE27U7pgwd3sFI064VqV2V6+RXYxnoxz5BG1
	VlsFOfnF5t0p2i0nB0xEuXNJvELanRW0JzQXc0lWEsOzh133dTxdjSm/4D7P7k4GsPfctaowXEfxy
	QQ7vu3FWF60klTZZNyAPe44yTibVRSKwOwdVtPJXxzrvHaM3pLZSPVZNhbf/DPuZJo567SlK8VJGu
	HbhTsxlTE2QrnjByaXQfZoLJxW3hpYde/wIZ4MYAEVOEjOl5xbesU2XvD9p8PuO+Po8IsL2zg/qEV
	10pT5P3A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1ua0Wv-0000000090R-1Prn;
	Thu, 10 Jul 2025 20:18:17 -0300
Message-ID: <bb5dba5b431172ae8b268470d6e37419@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>, sfrench@samba.org,
 ematsumiya@suse.de
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, wangzhaolong1@huawei.com,
 yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com
Subject: Re: [PATCH] smb: client: fix use-after-free in crypt_message when
 using async crypto
In-Reply-To: <20250705025118.48080-1-wangzhaolong@huaweicloud.com>
References: <20250705025118.48080-1-wangzhaolong@huaweicloud.com>
Date: Thu, 10 Jul 2025 20:18:15 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Wang Zhaolong <wangzhaolong@huaweicloud.com> writes:

> The CVE-2024-50047 fix removed asynchronous crypto handling from
> crypt_message(), assuming all crypto operations are synchronous.
> However, when hardware crypto accelerators are used, this can cause
> use-after-free crashes:
>
>   crypt_message()
>     // Allocate the creq buffer containing the req
>     creq = smb2_get_aead_req(..., &req);
>
>     // Async encryption returns -EINPROGRESS immediately
>     rc = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
>
>     // Free creq while async operation is still in progress
>     kvfree_sensitive(creq, ...);
>
> Hardware crypto modules often implement async AEAD operations for
> performance. When crypto_aead_encrypt/decrypt() returns -EINPROGRESS,
> the operation completes asynchronously. Without crypto_wait_req(),
> the function immediately frees the request buffer, leading to crashes
> when the driver later accesses the freed memory.
>
> This results in a use-after-free condition when the hardware crypto
> driver later accesses the freed request structure, leading to kernel
> crashes with NULL pointer dereferences.
>
> The issue occurs because crypto_alloc_aead() with mask=0 doesn't
> guarantee synchronous operation. Even without CRYPTO_ALG_ASYNC in
> the mask, async implementations can be selected.
>
> Fix by restoring the async crypto handling:
> - DECLARE_CRYPTO_WAIT(wait) for completion tracking
> - aead_request_set_callback() for async completion notification
> - crypto_wait_req() to wait for operation completion
>
> This ensures the request buffer isn't freed until the crypto operation
> completes, whether synchronous or asynchronous, while preserving the
> CVE-2024-50047 fix.
>
> Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
> Link: https://lore.kernel.org/all/8b784a13-87b0-4131-9ff9-7a8993538749@huaweicloud.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/smb2ops.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

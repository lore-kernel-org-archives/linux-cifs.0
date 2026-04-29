Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED783A3E95;
	Wed, 29 Apr 2026 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777449664; cv=none; b=rQuN9v8CN8+e3By83oQq9/Wgak+JSDtt4VV6r5kxiSlSF6bual7joB3UdbZ0Diu31NDmwqPaLIFK8KD3ZBdrJoxg3ehjb6fYl0ThhnUNR/q2RpLbpk6vK3FacpzvoRbiqYQCubeq/dpL6lV2y+PiUWpj8n1g7lbxjgHjwYhAolw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777449664; c=relaxed/simple;
	bh=yEt7i/i6qQxwrcm/VnsRChSxkgkfxMYCXYHDNb7d46M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gNH3lT76dHeu3VHVAb1Mcvvytkxx1zNyZ1kw7LeenOVPdDUrPm7s/f+SY4VUYtUMYIz14yoL5xX50HFZVSVab2kCFZWWKmvihm4XNhd/bYA9jxgWJPQbGuy3/BMtztVhxIFMBL09o8YLz02osZQ2vQmdsnsizNLecQb8BZSc7rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=G91JY/j1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="G91JY/j1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Y/0d19yATJB2714W/bcERNSn/ooGpZnVnHvE27liX4c=; b=G91JY/j1f8TdXTUyaJ0qrCcvRx
	kE1mqwckssdaw/yxJvDpm3FthFA6vm/YowY6K/Dds6YH5h27iLc37yNE7jTnl9LVEriM0lGNhsfzU
	JFoizU260h9jripMPFO2dQKwptF+lxy9zxxzAyB526x6Q94RCpyVOFFf3zT6e20LWWmALwb9Dt427
	99vOZ4ropcer/ehwffLbEoti9fFP6SwtcnrBvDEr9vP75QbIPsuA4lkNmvJMxRALbDjaUI6sIZ0wv
	8oe2q1vBUnnwkfYYOqMu08LO5FXTXqdoXIyRWDBfqFjC5agdzwleEplDjYqYOYspcoxycwc1WXIO/
	1ybnIw4rRsemmA9hGnr7+AHtEERn7I2vwI13cCrmCno5E/n2uEQ4dcmpSyaCxPNiB1hqZX4mGQzqk
	YWtXx+NMOoOhDXFvFQsCKBJcfz7tEqnFTCBoi7SnKoz51nVA5y1mr+Wkw4ddDzYYJfU0KfRH76nIM
	WSzar/W0naORLccC6S4+iDR2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wHzqt-00000004wUV-07DY;
	Wed, 29 Apr 2026 08:00:59 +0000
Message-ID: <540e2263-a1f2-4bac-828a-8b83d56f5614@samba.org>
Date: Wed, 29 Apr 2026 10:00:58 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: smbdirect: fix MR registration for coalesced SG
 lists
To: Yi Kuo <yi@yikuo.dev>, smfrench@gmail.com, linkinjeon@kernel.org
Cc: tom@talpey.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <53188517.AWMAAJZSdBsAAAAAAAAABAMtJJkAAYKKIjQAAAAAAC-ZZgBp8Ww0@mailjet.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <53188517.AWMAAJZSdBsAAAAAAAAABAMtJJkAAYKKIjQAAAAAAC-ZZgBp8Ww0@mailjet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Yi,

> ib_dma_map_sg() modifies the provided scatterlist and returns the
> number of mapped entries, which can be fewer than the requested
> mr->sgt.nents if the DMA controller coalesces contiguous memory
> segments. Passing the original, uncoalesced count to ib_map_mr_sg()
> causes memory registration failures if coalescing actually occurs.
> 
> Capture the actual mapped count returned by ib_dma_map_sg() and pass it
> to ib_map_mr_sg() to ensure correct MR registration.
> 
> Also update the ib_dma_map_sg() error logging to drop the error
> pointer formatting, since the return value is an integer count
> rather than an error code.
> 
> Signed-off-by: Yi Kuo <yi@yikuo.dev>
> ---
>   fs/smb/smbdirect/mr.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/smb/smbdirect/mr.c b/fs/smb/smbdirect/mr.c
> index 5228e699cd5d..058dc24bf544 100644
> --- a/fs/smb/smbdirect/mr.c
> +++ b/fs/smb/smbdirect/mr.c
> @@ -269,7 +269,7 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
>   {
>   	const struct smbdirect_socket_parameters *sp = &sc->parameters;
>   	struct smbdirect_mr_io *mr;
> -	int ret, num_pages;
> +	int ret, num_pages, num_mapped;
>   	struct ib_reg_wr *reg_wr;
>   
>   	num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
> @@ -300,19 +300,19 @@ smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
>   		num_pages, iov_iter_count(iter), sp->max_frmr_depth);
>   	smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
>   
> -	ret = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
> -	if (!ret) {
> +	num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
> +	if (!num_mapped) {
>   		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -			"ib_dma_map_sg num_pages=%u dir=%x ret=%d (%1pe)\n",
> -			num_pages, mr->dir, ret, SMBDIRECT_DEBUG_ERR_PTR(ret));
> +			"ib_dma_map_sg num_pages=%u dir=%x num_mapped=%d\n",
> +			num_pages, mr->dir, num_mapped);

While here we should have ret = -EIO;

>   		goto dma_map_error;
>   	}

Thanks! I didn't notice this and tried to fix it with some other logic:
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=11fe681cb8a36a8e48366cc5dd6dff37c1de350e

> -	ret = ib_map_mr_sg(mr->mr, mr->sgt.sgl, mr->sgt.nents, NULL, PAGE_SIZE);
> -	if (ret != mr->sgt.nents) {
> +	ret = ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
> +	if (ret != num_mapped) {
>   		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
> -			"ib_map_mr_sg failed ret = %d nents = %u\n",
> -			ret, mr->sgt.nents);
> +			"ib_map_mr_sg failed ret = %d num_mapped = %u\n",
> +			ret, num_mapped);

I guess we want something like this:

		if (ret >= 0)
			ret = -EIO;

>   		goto map_mr_error;
>   	}

This should also have

Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with client mr code")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221408

Thanks!
metze


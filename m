Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCA82116ED
	for <linux-cifs@vger.kernel.org>; Wed, 19 Mar 2025 09:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742375847; cv=none; b=s09t0GVNhuHSpweLOjfH/7LDFnedV+S1i9gDwfg2U6N49Xc3qPx6isMGvCrFHiCnGJS9bHqAQnJ4bDtFlrV05o2OdxkceKtpG88jCZEWWS9XNmow9kh3peLpDbdKs/1+UOQLP0unbOWsIprsZjQMPWLuqxIPykWRA6L1vpLkECg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742375847; c=relaxed/simple;
	bh=idZoZvkgqrMLG3wv3Plsr2CvT+krKL3Qn7Sru+Jmen4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofj+Qh/drcgcrSO3CxUExmEDwVRNaXkWrNb0OdDySLUDIyD6EHqHeMkvgf0BUr9VFAAQUV5/WmbTvJXyDco3DovBg5V94+UgbRdGaSNNUX0u7CvFA+A7gxNjCaF8xWViX8VWE6ViNzfsXyAQ/NKtY13520z5VCT9hOAPEopgRlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FoQPemPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FoQPemPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D5FC4CEE9;
	Wed, 19 Mar 2025 09:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742375847;
	bh=idZoZvkgqrMLG3wv3Plsr2CvT+krKL3Qn7Sru+Jmen4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FoQPemPCyPhoLwrLoHZQDOMtYWrT2NOwF1atmJOtKv9wmDgp6Q7JZ5mzd8MZPmQEs
	 0o6SWqb63nWEShaDxcsQF/WwBluhvvdGxLdMHNkXWaz0N2yt1j5YqB7RJKcMCOL06l
	 686/oZtatGxf/rqtPc4BqX+Asfdeg7jIyH9lewAadv5K5H0YBIg8aPhIuEfy0LHjos
	 f8T4vSlRWnOFJ6wlZAsVMdRxMXmgWK1yUE4RfJCmLqGP5vr8Jn2JG2/ObMtAfvOn+3
	 Bz7u4kVkIVk5B9dbiQGjEh7buTZMLDHVGbPa6UN2MUt7KpP3h3l1WavO7frj7Bh1aV
	 vM+K+qQ5SoWww==
Date: Wed, 19 Mar 2025 11:17:23 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
	senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com,
	Kangjing Huang <huangkangjing@gmail.com>,
	Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] Revert "ksmbd: fix missing RDMA-capable flag for IPoIB
 device in ksmbd_rdma_capable_netdev()"
Message-ID: <20250319091723.GI1322339@unreal>
References: <20250318123826.5406-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318123826.5406-1-linkinjeon@kernel.org>

On Tue, Mar 18, 2025 at 09:38:26PM +0900, Namjae Jeon wrote:
> This reverts commit ecce70cf17d91c3dd87a0c4ea00b2d1387729701.
> 
> Revert the GUID trick code causing the layering violation.
> I will try to allow the users to turn RDMA-capable on/off via sysfs later
> 
> Cc: Kangjing Huang <huangkangjing@gmail.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/smb/server/transport_rdma.c | 40 +++++++++-------------------------
>  1 file changed, 10 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 1b9f3aee8b4b..9837a41641ce 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -2142,7 +2142,8 @@ static int smb_direct_ib_client_add(struct ib_device *ib_dev)
>  	if (ib_dev->node_type != RDMA_NODE_IB_CA)
>  		smb_direct_port = SMB_DIRECT_PORT_IWARP;
>  
> -	if (!rdma_frwr_is_supported(&ib_dev->attrs))
> +	if (!ib_dev->ops.get_netdev ||
> +	    !rdma_frwr_is_supported(&ib_dev->attrs))

<...>

> +			ndev = smb_dev->ib_dev->ops.get_netdev(smb_dev->ib_dev,
> +							       i + 1);

Can you please use ib_device_get_netdev()?
ULPs are not supposed to call to ops.* directly.

Thanks

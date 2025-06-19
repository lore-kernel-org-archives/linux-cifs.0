Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC31F11712
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 16:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750349310; cv=none; b=m8BbO9q8Dda4Pn9b2AI8y2uTu26g4X1zpxKvawYFKx12qnR0gr5lsB1aXDR48Eh+6C5lzmND35sqteNDLlgDkK2N12x91XHxuWjirAqW64svZWZ1qS406dQ9+eyYvvPYwBvsDntMlW10a4HNa0nl0kmzFnQlZLyO2pcGdQjiocI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750349310; c=relaxed/simple;
	bh=zAG8dAEARDVaRbw9+YZIcTcEYALAoTXvvQkX7/NguqM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=VRum+sRiQv5FcK+3By2NNR/ndEO1HQ/te8ZwQWAgZoZ1cTHuA26CBP8RUD13+u6jl4KRR+U4YBimsi0BdPq9lTZZjlf15hiLDcKZpX2QCWJYqvZGFxWMD4+wgh2yzimACddK4fXMx7nHj0Ujqtx5HJFjRHRYcPakV5Kn043f4FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=vw6kjsHW; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="vw6kjsHW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GVvkmBgGgW0BGrPy57vHmRYY6hkCZ63yhhk+g5swE3Y=; b=vw6kjsHWp1CZWn9pAT03Zhy56t
	sMuivcL7b8hRZPp7b0rgrTUVUJRggYZQ6PZaJxV8l/D3s9S/953nyHvQNAmDP0sgx3DWwI9gmq1eo
	XHSMPhHTT5a82jBK7wcN1L8HndFcWBlkinLPIWMtmYQhCg3rTWYZdkDv358uOi0YnRqz9KMZfSDG8
	9luHm3AdLrbqJSQCqmm8Jyry7CfwEIgpsXgjbFM/1d1I0CIKcLiNxLCQmhJ0+LVcYphDQpGbrA2XD
	EgvXTy21thJMSrjDZWSXaVbiN72xqr/6LLZj0sXx1HRsFPmKe8kDm+khiQbY/wopbab5pLhCK/gH4
	oSBBGcFA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSHoN-00000000Him-3NDX;
	Thu, 19 Jun 2025 13:08:27 -0300
Message-ID: <3563b3a5cccdd0289955fd400b843c25@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 3/7] smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for
 auth_key size
In-Reply-To: <20250619153538.1600500-3-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-3-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 13:08:24 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Replaced hardcoded value 16 with SMB2_NTLMV2_SESSKEY_SIZE
> in the auth_key definition and memcpy call.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_ioctl.h | 2 +-
>  fs/smb/client/ioctl.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
> index 26327442e383..b51ce64fcccf 100644
> --- a/fs/smb/client/cifs_ioctl.h
> +++ b/fs/smb/client/cifs_ioctl.h
> @@ -61,7 +61,7 @@ struct smb_query_info {
>  struct smb3_key_debug_info {
>  	__u64	Suid;
>  	__u16	cipher_type;
> -	__u8	auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> +	__u8	auth_key[SMB2_NTLMV2_SESSKEY_SIZE];
>  	__u8	smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
>  	__u8	smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
>  } __packed;
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index 56439da4f119..0a9935ce05a5 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -506,7 +506,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
>  				le16_to_cpu(tcon->ses->server->cipher_type);
>  			pkey_inf.Suid = tcon->ses->Suid;
>  			memcpy(pkey_inf.auth_key, tcon->ses->auth_key.response,
> -					16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
> +				  SMB2_NTLMV2_SESSKEY_SIZE);
                                  ^ sizeof(pkey_in.auth_key)?

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

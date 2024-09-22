Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED9E273FC
	for <linux-cifs@vger.kernel.org>; Sun, 22 Sep 2024 23:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727046774; cv=none; b=fdHLykDdrD1EdUpSzj+1WKo3mKGRT2Bl4tYm2BY1xOtkyE80YqE2nz1j+xFnz/OOt0Jf0F/TyaCu0/a8oGX1kzyXZc+4akYasopA3y7jg/CruL9z9IYG2gQ30bQNVP92TGpxpXwZer1dwrW4Edz1XEaav955CibwLLsJB8E+FbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727046774; c=relaxed/simple;
	bh=5nkZXYZ6l5wfTL5q8vw9D2SkmlaOrRG59+MURNC0BKw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DqYHwjvNeFsAzre1CKVnPATXecjCUpCG7PAUSuPLo9Qr3NfABiMLEHhxylfahi7LjhjS+La2M9umkiwKOyhUs0Onok8HsEQGD6Rwld9nmY/PAr0d23xqU+zDS9OvKF/CZKdSAIB9UPRWNIlMvE+RGt7Oi6AyhPJD9ZkU5vi1+6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pquXjHTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pquXjHTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AC2C4CEC3;
	Sun, 22 Sep 2024 23:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727046774;
	bh=5nkZXYZ6l5wfTL5q8vw9D2SkmlaOrRG59+MURNC0BKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pquXjHTRrdKrdI/+oNk/7Qnpgdu2uEiy7iKLHGchvXFYYEJdPwFrt9ROY8Rfk8afa
	 ZBZIvIb78zOe4Zv9NWv5yYLOn68xr9Axe6dGhrKrXcQjuobna9Jjwt6lEPAbAQfXXf
	 9+qlpsvzW4YKoBYFn2t9CLHXqoajOzhEY5RKoVjZ4B8oLwj8LUI3VOPHb+iNVh5ZKM
	 zX8fPM8t0wlxtNXzmFp6Za1ocaRfM2ELHrvv/hJnO7BpXfOFxUcIrfBLPpLFeTcOq4
	 GPlEoAfta0awBQshEdD+WjJmGsbDC8bJFzGFQo9mJAjT8BTqTvJ4yAIgZJYj4YS2AX
	 UP26B5kBodVNw==
Date: Sun, 22 Sep 2024 16:12:53 -0700
From: Kees Cook <kees@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com,
	senozhatsky@chromium.org, tom@talpey.com, atteh.mailbox@gmail.com
Subject: Re: [PATCH] ksmbd: Use unsafe_memcpy() for ntlm_negotiate
Message-ID: <202409221559.8410BEC@keescook>
References: <20240814235635.7998-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814235635.7998-1-linkinjeon@kernel.org>

On Thu, Aug 15, 2024 at 08:56:35AM +0900, Namjae Jeon wrote:
> rsp buffer is allocatged larger than spnego_blob from
> smb2_allocate_rsp_buf().
> 
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/smb/server/smb2pdu.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 2df1354288e6..3f4c56a10a86 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -1370,7 +1370,8 @@ static int ntlm_negotiate(struct ksmbd_work *work,
>  	}
>  
>  	sz = le16_to_cpu(rsp->SecurityBufferOffset);
> -	memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
> +	unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len,
> +			/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
>  	rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
>  
>  out:
> @@ -1453,7 +1454,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
>  			return -ENOMEM;
>  
>  		sz = le16_to_cpu(rsp->SecurityBufferOffset);
> -		memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob, spnego_blob_len);
> +		unsafe_memcpy((char *)&rsp->hdr.ProtocolId + sz, spnego_blob,
> +				spnego_blob_len,
> +				/* alloc is larger than blob, see smb2_allocate_rsp_buf() */);
>  		rsp->SecurityBufferLength = cpu_to_le16(spnego_blob_len);
>  		kfree(spnego_blob);
>  	}

Ew, please fix these properly instead of continuing to lie to the compiler
about the struct member sizes. :P

The above, &rsp->hdr.ProtocolId, addresses a single __le32 member, and
then tries to go past the end of it (i.e. "sz" is larger than 4). The
struct layout therefore indicates to memcpy that you have no bytes left
to write ("size 0" in the warning).

It looks to me like you want to be calculating an offset into
rsp->Buffer instead? Try:

	sz = le16_to_cpu(rsp->SecurityBufferOffset) -
		offsetof(*typeof(rsp), Buffer);
	memcpy(&rsp->Buffer[sz], ...)

BTW, what is validating that this:

        sz = le16_to_cpu(rsp->SecurityBufferOffset);
        chgblob =
                (struct challenge_message *)((char *)&rsp->hdr.ProtocolId + sz);

is within the original data buffer? Shouldn't something check that:
	 sz > offsetof(*typeof(rsp), Buffer)
and
	sz <= ...size of the buffer... (maybe that happened already earlier)

-- 
Kees Cook

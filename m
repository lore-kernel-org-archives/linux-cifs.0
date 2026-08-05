Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A703D565A;
	Wed,  5 Aug 2026 21:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785964340; cv=none; b=skB6Ky6NpRqPv8X/QVYJCw8xtXtSh5yAGuC3OCUwlVeNDP1zF1Io4jcRv0AUTDmW4SrhUfV7QZQarEcgnTZThRi6eWVDRtq8oUOSjYQz4jPmEZjSMx6bLIYOuXyz5DYid+jHwoIUiVRwnQKIJbXJei20ZmME3ptLhPgZNkQ8GO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785964340; c=relaxed/simple;
	bh=E3dng9+7HbT6ix+DEr3ITZTgi95DxH+bloya5paO+Gw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcq8vBI9Eg3WZvX0OJrWFQKzDpjx95GOwciRKZVExhVXidnVwqMfpvX/QFbs4SirKqZKU4CnhwSsXspBOPsRWzXDSGMdMF4xc8Klf1wLVixkeBdhLn3hwPUOoftTXkUtRN6Vvb5faMovJgYNScg+EoFuRuzs4R8QxJaHLSE7fTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HWnc7U8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HWnc7U8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81121F000E9;
	Wed,  5 Aug 2026 21:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785964333;
	bh=iioUE17XJTnzklbmYqPXCcf52U6QC+JBXytEKbVNwPc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HWnc7U8CKZ0VQd/DTvhRkELRoQPE41DQt2AnUBxyJ6o/ZTymxAI8sUaBGs6+yvGpZ
	 +emzL4KN+5Eq/uoPtKFYnyaQesNBkrCm07OUKm8Sy46ik6K1hQD3IWASsORqwU8umG
	 DLlZpKDk2H6bLoVREF7zL/LAu/fpDhUMrKEGoxc5sLkQj05LACRjhG9VWGNExFjIZp
	 xTJNZJRheiSp552BW/ZLsf0SgqB9x+Fa2SZG4YZ4MpkhnlP+8OJyGW3pyKx2UsjU8l
	 yCz/DKVz6tgg6mZln2ylXNZesFcF4Jxsy7c1F/9CTndL6rRk4PzLGvWxrAm9zfo9xr
	 suutvUOe/u7hA==
Date: Wed, 5 Aug 2026 14:12:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [PATCH 2/6] smb: clear the aes_cmac_key and aes_cmac_ctx when
 done
Message-ID: <20260805211211.GJ3438@quark>
References: <20260805143611.818559-1-thuth@redhat.com>
 <20260805143611.818559-3-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805143611.818559-3-thuth@redhat.com>

On Wed, Aug 05, 2026 at 04:36:05PM +0200, Thomas Huth wrote:
> From: Thomas Huth <thuth@redhat.com>
> 
> Clear the local crypto-related structures via __cleanup() functions
> when we're done with them to avoid that sensitive data could leak on
> the stack.
> 
> Note: cmac_ctx in ksmbd_sign_smb3_pdu() gets cleared in aes_cmac_final()
> already, so this does not need a __cleanup() marker.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  fs/smb/client/smb2transport.c | 4 ++--
>  fs/smb/server/auth.c          | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
> index 1143ee52470a7..d23566da2ac81 100644
> --- a/fs/smb/client/smb2transport.c
> +++ b/fs/smb/client/smb2transport.c
> @@ -464,8 +464,8 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
>  	unsigned char smb3_signature[SMB2_CMACAES_SIZE];
>  	struct kvec *iov = rqst->rq_iov;
>  	struct smb2_hdr *shdr = (struct smb2_hdr *)iov[0].iov_base;
> -	struct aes_cmac_key cmac_key;
> -	struct aes_cmac_ctx cmac_ctx;
> +	struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
> +	struct aes_cmac_ctx cmac_ctx __cleanup(aes_cmac_zeroize_ctx);
>  	struct smb_rqst drqst;
>  	u8 key[SMB3_SIGN_KEY_SIZE];

This is another example of a driver that has never made much attempt at
key zeroization.  Even considering just this function, the raw key is
still on the stack and not zeroized.  But it is not just this function,
e.g. the smb2 code does the same.  So yes, the '__cleanup' trick makes
zeroizing these structs easy enough that we might as well do it anyway,
but it would be nice to try to be a bit more comprehensive.

- Eric

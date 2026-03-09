Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF6262FDC
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773071529; cv=none; b=EDzDuNrLQyt1JN1Oo18hBuaNWn3nCHGMyic1o42N6y+6xX5UT/sxwxv6ARF4AtuwMufYjEuMtcTKcq0903jhcGEE3oFNHq9ZeJiKw93nZXQ1oRGbVUAp5kE9v2v8SayYqVm3PiMGquwhwzBsh6UdeqlTRYanxqnc5RaYJS6XG1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773071529; c=relaxed/simple;
	bh=HaQEemrQWTgDUwbzmc3Mzj2qY0rDmP4XNo9O9V8u/ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cx3/1o7m5WG2RjpHrVItzK0jNb3eMjJKGhJ83crN8l3RjESRcDWNWo0l2SJ/seWoy9dKUC88tRzq78VrxwVsTaN4XxzFfpXyI3/wWICZoLVEH0/hVNKKyDsahGx6cgqNk9IqrBSQfqw8zRYLunOh/uNL/RioWsKQfuFxKsWhXhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MYc3ge0P; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MYc3ge0P"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4853aec185aso10858015e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 08:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773071524; x=1773676324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ly8aqb2t/EfTDPkW0Kau0FkQv2wta+tzkVJnz2/mqYk=;
        b=MYc3ge0P1i4XreDK6vV1pSVPxULvEgfmbru+ZCnrx/bUuch1/Y/V2f3+wlz4bsFYlO
         PruWVTk0JgMxXy9LRZKAS55cJdgMkNH+uJdPtRpobA3DynmzSOjh4BEUWoEtfpMZMe2k
         wDiUUfG+QmzQpTLLpXaX3Mdoon+/QadMxs8q8MssGesIeJymf1EN7OYtvoxblDX6sg/L
         qHYwxcGwLonTI6NThk/dLP/FT8t7LScfe2kh/FtTJQ0/NRwTqTquhVuBg6NudirG/Nky
         umA4Stpi9TuXRcccCSdnA726NwNMCZNMTcTclJeuqMXhDkv5m17QrIujeUyijOugcnl0
         mlCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071524; x=1773676324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ly8aqb2t/EfTDPkW0Kau0FkQv2wta+tzkVJnz2/mqYk=;
        b=oqmKh/+lWQszmkN0eX8biqKspwHhe80Px3Tx8gipisauAZ+dknBRk7iatvhg2eifA5
         IjoFOPirHjd4AJbZAtvIjRJ2wQxaCj40RRlZit06Dro1x3uEfa2I0H5lXU2PTfVFrylS
         Y3BpJgWMnps+vDN383pXkNjAi/A9JMPP+bBdTQv2N9werCysGRfbHZCTYNOmY0+LtJV2
         KF5FoTsvaf2Z+tLJ8kTDxkwbuU8+bIhcX5Y5+13cOZEJD3pETThIzQ5L9Mw0xcY/llQu
         jaoG3SAMpmuiTGpMA0zHrOs07tzOWecY9mscAyZQDiaa8Qn4cifyLAyCj4Ucl/NizKff
         uGAg==
X-Gm-Message-State: AOJu0YwEpgmHfzCo7EvSCzBjfOd/EI1lK0jOwRgKJ0+H9zqQtJa8VTpJ
	cFgFPGodZLId1ftDOtmSLEkrU9pj0jB9ktuYp4JzyqqHGuTMwkDGbKzTTUoiiWhq+rg=
X-Gm-Gg: ATEYQzy66C9PK4oyUHi8Xt7qq+a5D7W8Chhdmty2ErwyZGGa4ASU3WjAa79StMYSauC
	3QTvlagpuFtTKKW2vY/exJAvAbqY26sl5ZHs2EmDcWidAXZjPR4GcSSXpCSYowKOp91VFSWOq+X
	M6ukAZm8kR3C4pYHa9Pkyd0Ggk//O9NHuS/2ac4OuUhrS5uPbNtX/Q+1+FgY0k3dya7CEOY64nZ
	J7KfhPTn2x83pTBXluHrevLI9DeFRj/xOvkEXdh2qa+4nxLDi/f4lNmhO+ywetNZnE7VBFnkiDE
	l4ysO5vW7qcp7kROJTzqGfr8YA05oRP57x2hfKd9tBqCgPyQxl2bjcaECD1mQWStodYmR85P4Jk
	NZazJ07K1zzxkw5poD4EMC9MXaY9PXxODcou3jOBxpN9KDvyVvO8kdK7BVloKHnh7jNbO28g4oO
	/6O6xHo0hbJc6w3PDhheblbKKBbc/ocq4rUxs1qe6oEdKj/eqCtkoV5uRIC2DUQsmfuw==
X-Received: by 2002:a05:600c:3112:b0:485:3ff1:d5c5 with SMTP id 5b1f17b1804b1-4853ff1d6f2mr28553765e9.7.1773071523783;
        Mon, 09 Mar 2026 08:52:03 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:5e5c:35f2:2762:2c6d:a7fe])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be4f8078c6sm11478341eec.5.2026.03.09.08.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 08:52:02 -0700 (PDT)
Date: Mon, 9 Mar 2026 12:51:58 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
	sprasad@microsoft.com, pc@manguebit.com, ematsumiya@suse.de, bharathsm@microsoft.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix in-place encryption corruption in
 SMB2_write()
Message-ID: <nvmbb2fbm2zkqyk4x254d33llskfldguygq5pfkedv36upems7@jcofwqya42t4>
References: <20260309103049.22169-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309103049.22169-1-bharathsm@microsoft.com>

Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Mon, Mar 09, 2026 at 04:00:49PM +0530, Bharath SM wrote:
> SMB2_write() places write payload in iov[1..n] as part of rq_iov.
> smb3_init_transform_rq() pointer-shares rq_iov, so crypt_message()
> encrypts iov[1] in-place, replacing the original plaintext with
> ciphertext. On a replayable error, the retry sends the same iov[1]
> which now contains ciphertext instead of the original data,
> resulting in corruption.
> 
> The corruption is most likely to be observed when connections are
> unstable, as reconnects trigger write retries that re-send the
> already-encrypted data.
> 
> This affects SFU mknod, MF symlinks, etc. On kernels before
> 6.10 (prior to the netfs conversion), sync writes also used
> this path and were similarly affected. The async write path
> wasn't unaffected as it uses rq_iter which gets deep-copied.
> 
> Fix by moving the write payload into rq_iter via iov_iter_kvec(),
> so smb3_init_transform_rq() deep-copies it before encryption.
> 
> Cc: stable@vger.kernel.org #6.3+
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/smb2pdu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index c43ca74e8704..5188218c25be 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5307,7 +5307,10 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
>  
>  	memset(&rqst, 0, sizeof(struct smb_rqst));
>  	rqst.rq_iov = iov;
> -	rqst.rq_nvec = n_vec + 1;
> +	/* iov[0] is the SMB header; move payload to rq_iter for encryption safety */
> +	rqst.rq_nvec = 1;
> +	iov_iter_kvec(&rqst.rq_iter, ITER_SOURCE, &iov[1], n_vec,
> +		      io_parms->length);
>  
>  	if (retries) {
>  		/* Back-off before retry */
> -- 
> 2.48.1
> 

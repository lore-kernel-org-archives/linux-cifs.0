Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A287AD51;
	Mon,  8 Sep 2025 02:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757299158; cv=none; b=j0ynPlZpg7VVl0SS3/srUGOUSEyti+L3z3juuwlt9x6vpiOcdguaJeqmBRtnTBApb7dzIG2O2sjSZrMIHNKTdbIIiyKlBKarp+oTxeyCpNZePyb5chT7VSS05L3Z9WCNfnKkMTT5/oHtkVctjF6wesCmJEO+FVsanm8dPgMwzeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757299158; c=relaxed/simple;
	bh=erPSr5E2ysuBf+hRtvm3+7BYon2Byrj8kZ0jl3Lwk4M=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=H72J74hAylTYljSmf8keGJxYgG8irhao6wMLQVElpBrnWQrmx+kAyXM0w7RnHgYehfxgAnwLy4wPZt80i38Bb8Ok1mV6lUjFTqYdsijE/ltJxv1MQqe2Hu5Oef0bgflSYAvb89GzchdwDG4eif8mj8FDPtDXzpCk58l389TxSyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hzH2/1c5; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hzH2/1c5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=U66no8ixnDA1zqx5KQeVdw+6wSdnGjQ29/zGvuWRNKo=; b=hzH2/1c52HawTk1SDQdAO5c3YQ
	jF6Ox10CL85aDXkRgjxNxf+g6dUM/8NLe0rrx65HwSmS4FGCMG/C5LB7PY7Fo9dcpnYG9TG2///LX
	NEPr+6r5ohjzflARdRQKrTa72Y2BDO9wdGIu9eZeMHXH/MH74GVYfNTT/jFA4l5Rw6FPEKjwaWPd2
	M5z7MGMShmq+B7ZSJLfsiVNwAeMc6xqkWUmx5LtRRqb0134HROauufAZ11HB34P5U6AmgtZF4pfPk
	0dnkdhIJL3FBIlmk8mscNf8vQAFVyu/YO+sMWRrduyKNXR14ir4fBfv4ggDImsnVBGxEQij0gsQ+8
	LyUTaU2A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uvRmg-00000000zol-1kB3;
	Sun, 07 Sep 2025 23:39:10 -0300
Message-ID: <5ad540512e8527bddcb474bd7c1f9f6b@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Eric Biggers <ebiggers@kernel.org>, linux-cifs@vger.kernel.org, Steve
 French <sfrench@samba.org>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Sergey Senozhatsky <senozhatsky@chromium.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Eric Biggers
 <ebiggers@kernel.org>
Subject: Re: [PATCH] smb: Use arc4 library instead of duplicate arc4 code
In-Reply-To: <20250907032003.386794-1-ebiggers@kernel.org>
References: <20250907032003.386794-1-ebiggers@kernel.org>
Date: Sun, 07 Sep 2025 23:39:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Eric Biggers <ebiggers@kernel.org> writes:

> fs/smb/common/cifs_arc4.c has an implementation of ARC4, but a copy of
> this same code is also present in lib/crypto/arc4.c to serve the other
> users of this legacy algorithm in the kernel.  Remove the duplicate
> implementation in fs/smb/, which seems to have been added because of a
> misunderstanding, and just use the lib/crypto/ one.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/smb/client/Kconfig       |  1 +
>  fs/smb/client/cifsencrypt.c |  8 ++--
>  fs/smb/common/Makefile      |  1 -
>  fs/smb/common/arc4.h        | 23 ------------
>  fs/smb/common/cifs_arc4.c   | 75 -------------------------------------
>  fs/smb/server/Kconfig       |  1 +
>  fs/smb/server/auth.c        |  9 ++---
>  7 files changed, 10 insertions(+), 108 deletions(-)
>  delete mode 100644 fs/smb/common/arc4.h
>  delete mode 100644 fs/smb/common/cifs_arc4.c

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

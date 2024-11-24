Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510472500C2
	for <linux-cifs@vger.kernel.org>; Sun, 24 Nov 2024 22:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732486456; cv=none; b=UZXt0j4sEYMIdmBVeGeID94i+kdczRJhLPiXaagBwtHEH07hMpGGQ8RGbthtBZ0Cn4f5yDbqQuojrTVoJdePSzUWfcgr4JxZCeF5Xd7kZEG2S5ZfBd9F3EH48aElIMAX5j6DBWhtW4jJNHr2eRT1vwKSDtf5q/OUIzp3klfZbJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732486456; c=relaxed/simple;
	bh=w3cONNFeHqWOb1Bwxg/YxP9sBTp9Juk0pnx4yW+f5O0=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=eJorqlu2HKxy7t3jIEaVM+GS8PDwzyLiy5xfjSCDE9aR3F6mt2ZuOYgTQzYT05qm+HNVQiz8QLZn7EWJMi+P3CfaWUR8Xz7C8ibdW3Vip0cbA8OIfaxLFhH2KVBDWlkAM55Aup1Ljsq6zW9sVRxbafMPx0P8DYOT39Zw3scvPEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=LwxVgv1y; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="LwxVgv1y"
Message-ID: <1759723155478fb008c3b36bdd07c63f@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732486444;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iFXfrJvaAkPNsYMpLElnd9y0Wq7/XSSquUZnzsvYosQ=;
	b=LwxVgv1yMdRds07dfoubFCh7afEpGi1dMcmnmZ7p5hVUOrkdpL7A0xmtLpBSvevSujq8lc
	CNhYG2rgWeMfaLlmj2GtlyIalsqmKWICe3xVppvssH5qr111EwcMjiTLm2IvUzGNWCimcl
	mZTuXiHne97WmO4c3dPgs7xPwU4CI6vaOMk0hkt3zE/BHZiLKJFsLN+MNE97va2Unq1UzQ
	o5xFec3u50aLc1+u7ndWwmyVfqSipy+PLhWAA8+/4KNCxTK5wXwEwYBXCYEt7VsNggJyTS
	OuWZr7xvJSTIuV2S4w8i+FyZx5uacSyPnKBG9IPUK/aeBXZx47mmxowN9S1KzQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: ematsumiya@suse.de, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 Henrique Carvalho <henrique.carvalho@suse.com>
Subject: Re: [PATCH v2 1/3] smb: client: disable directory caching when
 dir_cache_timeout is zero
In-Reply-To: <20241123011437.375637-1-henrique.carvalho@suse.com>
References: <20241123011437.375637-1-henrique.carvalho@suse.com>
Date: Sun, 24 Nov 2024 19:14:01 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> Setting dir_cache_timeout to zero should disable the caching of
> directory contents. Currently, even when dir_cache_timeout is zero,
> some caching related functions are still invoked, which is unintended
> behavior.
>
> Fix the issue by setting tcon->nohandlecache to true when
> dir_cache_timeout is zero, ensuring that directory handle caching
> is properly disabled.
>
> Fixes: 238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V1 -> V2: Split patch and addressed review comments
>
>  fs/smb/client/connect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>

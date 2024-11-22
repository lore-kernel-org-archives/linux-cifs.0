Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0DC18A6A0
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 22:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313235; cv=fail; b=nroPmOn0is9U6QIlugZkYIn5igdgnBWgKYS48/wzPFNhsnqhnk8bfn6J/u0HxSfNlw7c+EX313lPQw+T61YxmX4Vre+/pHw9/i//2EK9exNWPNgoXmLeIlZRXxUODMdJyyacwtHeekNVxGipRlZiWfEOgaJTMwGj3n/A3jGKdTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313235; c=relaxed/simple;
	bh=YmVWGjOr+pNAcR7FEQl/V+OkZ0p/8yyE80U7pVE+YfI=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=OoAxbp8mm9dbH80ZND2fpkOT5sZyS5ONoaUskEZenuCsXwJTZk/6rqSXHWtGmBEbk5ST9+zHhrCEeGsdylc1te1eegH4TL9O8qxW6nsAYxwbK0JL/IJuYWEL8m3ThUZEkzJHoaqRbxFSrXsd8qgi5IoRF+MGymdeCntPCZFzNiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=VSivrKi4; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="VSivrKi4"
Message-ID: <7e76e6d3a5a194b87ae98e13c354a4f8@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732313231;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6dySEz3mM+2ePBL3SjdJ0K7c9veOTGK9y9wSrPI4qsk=;
	b=VSivrKi4UOcFoAyNxbFVYHtCViHPkoCqtMfoxtYt+ZH+oARoEZRyJxHCN5FmVsblCyh0nh
	5UXcsA3dxuKbDINwMT5r0TOsi/ORHy/XHWXYfwCgmElD7lGG0bkP5YhRuli5Acb8mbTsfO
	5XFir6Ep3ZC3GPKXxln4+TzDiUKUUJw08IK/iorkkiHU4RouRNjmttI2cqvzqM1iS8skgg
	j8ONsvTr639RV9N2vBuzY6ZvQNiQxLSLhIH9DPrVqslY1ceJXPSUKdFHH6URsmmf7uyXpa
	LdXgB5xhHNooW92sGUFopsDLVWA/frxz+9BbB+ItjEC86CXkzbZSa0Lw1/+ilw==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1732313231; a=rsa-sha256;
	cv=none;
	b=FK4gxnTKo7xkmTh/5tksxnm+yMaRD4wWWQCKYzdky6fzaondOEtph0EJiPrDUTuz2oRGeu
	+AwlyBqeDhuJv3kKif8/eoGPoWGXucffGbf7M0wr3eihaKB5C8n1h2LkBzPbuuKZ3Z+Bt5
	cnMsxzRLvCxVIgm2ptXbzRSfeXByNgMgaUisW4vQe3jumUIG53jJ8Nuf4B5jw1UenLLiIx
	Ggw4kCw28tq6sS6CPeVXt6UZD5B+G5pADHLmvzGZrKnyu3IZAbmJaQdC4TxD0ygeqjYvuD
	RTW2KWQpeaD4hf1LjilVO4Wu1fNpgABLBUEX6yNjOLCMwSyBrF/dF2J8GGidng==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1732313231; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6dySEz3mM+2ePBL3SjdJ0K7c9veOTGK9y9wSrPI4qsk=;
	b=sbBGVClUgwiXq2bGrHWn5Q81aum0YakYWGAJALL7dHAw+lXQfQPmIbvxFfoETvGnyim/cC
	YNHSB+SCvi5efoZjkQcQbyYNQ1H75PVq10FcjKE6oj8HV7NmazMfOJstuVDSAdOvJvRegP
	aZXrKsJ3lsIMWNsqbdlvgoyjaOAHUZADlxV5d/XfnnTLNf4BLIMd2h9ufY22rm45RvV5jh
	i/pwPL+QFqlt23QwFsj2XyHGBfG97QiWZ6Xh8YWl8o2v4J/zSNZj4NNo0ij89gn0gVdd+P
	BdCzzyNYarBgseug+VatSBWhs7neOZ9SUUh7ckdGp7z1MLp3Gj+PktBLRkGfbg==
From: Paulo Alcantara <pc@manguebit.com>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: ematsumiya@suse.de, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org,
 Henrique Carvalho <henrique.carvalho@suse.com>
Subject: Re: [PATCH 1/2] smb: client: disable directory caching when
 dir_cache_timeout is zero
In-Reply-To: <20241122203901.283703-1-henrique.carvalho@suse.com>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
Date: Fri, 22 Nov 2024 19:07:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> According to the dir_cache_timeout description, setting it to zero
> should disable the caching of directory contents. However, even when
> dir_cache_timeout is zero, some caching related functions are still
> invoked, and the worker thread is initiated, which is unintended
> behavior.
>
> Fix the issue by setting tcon->nohandlecache to true when
> dir_cache_timeout is zero, ensuring that directory handle caching
> is properly disabled.
>
> Clean up the code to reflect this change, to improve consistency,
> and to remove other unnecessary checks.
>
> is_smb1_server() check inside open_cached_dir() can be removed because
> dir caching is only enabled for SMB versions >= 2.0.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cached_dir.c | 12 +++++++-----
>  fs/smb/client/cifsproto.h  |  2 +-
>  fs/smb/client/connect.c    | 10 +++++-----
>  fs/smb/client/misc.c       |  4 ++--
>  4 files changed, 15 insertions(+), 13 deletions(-)

The fix could be simply this:

	diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
	index b227d61a6f20..62a29183c655 100644
	--- a/fs/smb/client/connect.c
	+++ b/fs/smb/client/connect.c
	@@ -2614,7 +2614,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
	 
	 	if (ses->server->dialect >= SMB20_PROT_ID &&
	 	    (ses->server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASING))
	-		nohandlecache = ctx->nohandlecache;
	+		nohandlecache = ctx->nohandlecache || !dir_cache_timeout;
	 	else
	 		nohandlecache = true;
	 	tcon = tcon_info_alloc(!nohandlecache, netfs_trace_tcon_ref_new);

and easily backported to -stable kernels that have

        238b351d0935 ("smb3: allow controlling length of time directory entries are cached with dir leases")

And yes, is_smb1_server() check makes no sense as tcon->nohandlecache
would already be set.

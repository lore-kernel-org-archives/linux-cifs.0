Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935783815CE;
	Wed,  2 Sep 2026 17:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788370561; cv=none; b=Q+acm5lTuLqyyRLxeXXOdJX1oGRrcVXTLl9J2d3cA3u3UcFuqSedI+cGweSIognmK9D2Gqu4QKA4O7LYvFmPY+qdv928fqie8KsWrJ+oB03Psv4A3HtktSNuKyTRuQtbIY+Xjannn+1LlX3VpNRqjjV9nsMA/eMAAdl0rk8swoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788370561; c=relaxed/simple;
	bh=cTWNxFcL6QFpDtQdEvB0uGdE7JwDLoFHZ3SOhFRSXkY=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Eyr31yVVJccyw0HEBSEUx4SszkApBpgPqTTSVAzqC/CETVEJQY0wum6wZq0KkyrZvzoKKKJvbNiKzdZo+N+rId4+NSNxPyxazawG6xJEbP7WwKcyLHzvEqepoKt3vV/Vui3YXZJlNhD1xXUUdTp4hmmWOItGfE8wpo/2SrQwT2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=GsvUx0ff; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="GsvUx0ff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/B848+l5fxXKXKpx4J9yfLGAcg5XFBzy/KARNVYEJaw=; b=GsvUx0ffvFqDuAUYngtRv0v2QX
	Gxz1wTjXAxaEJFm4lULgngzKe36rymxnqI7N3D/3orYCtXxWTqqhij0SMfMm5ow5G/Xy3CIaUrCZo
	b120rap0qkR2YNAbRcGEFZ62osVnWPCsATwqqHnWJHT0MUONsZ3kCOamOPIBsSarvUjQu5Dska5Fx
	b7pWDFlGo4rfu6zOTdS3IIx8xLsUciLDYYjIACcj+RfVO4P5dHB+Aj6v/2AqjpEmVoXhrfuPNPXp1
	T3Z9hoQWgaKb4c9l9pFrxD0t6YMj0vffI+9CP00z1/L0ckQqx05aCZ3rYVG/u6TzviMaO6+sYmKaD
	AasRy66A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1osO-00000000WvY-3l8y;
	Wed, 02 Sep 2026 14:35:56 -0300
Message-ID: <7afd24a483fc59d9217cefbab526bccf@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Fredric Cover <fredric.cover.lkernel@gmail.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Tom Talpey
 <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad
 N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, Fredric Cover
 <fredric.cover.lkernel@gmail.com>
Subject: Re: [PATCH 2/2] smb: client: prevent out-of-bounds dfs_info3_param
 access in copy_ref_data()
In-Reply-To: <20260826191033.162320-3-fredric.cover.lkernel@gmail.com>
References: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
 <20260826191033.162320-3-fredric.cover.lkernel@gmail.com>
Date: Wed, 02 Sep 2026 14:35:56 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Fredric Cover <fredric.cover.lkernel@gmail.com> writes:

> Currently, copy_ref_data() assumes that numrefs > 0, and unconditinally
> accesses refs[0]. If copy_ref_data() somehow is passed an empty list,
> this would cause major out-of-bounds write and read problems.
>
> Enforce numrefs > 0.
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/dfs_cache.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> index b0388c460499..b51c8355d73d 100644
> --- a/fs/smb/client/dfs_cache.c
> +++ b/fs/smb/client/dfs_cache.c
> @@ -389,6 +389,9 @@ static int copy_ref_data(const struct dfs_info3_param *refs, int numrefs,
>  	struct cache_dfs_tgt *target;
>  	int i;
>  
> +	if (WARN_ON_ONCE(numrefs <= 0))
> +		return -EINVAL;

I don't understand why this check is necessary.  All target referrals
come from get_dfs_referral(), and in case @numrefs < 0,
parse_dfs_referrals() would have returned -ENOENT and copy_ref_data()
wouldn't be called.

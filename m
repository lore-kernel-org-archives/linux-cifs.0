Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792713756;
	b=FkZf8tK0Azdj/9xr6EXcq4H+WNRvMaeYMmmQsTHUl4nJWqCXgX+LHVWBu9XM60GPSNr5
	 KcwbikAyEvoNkjNp8mq9v74lu9Q7S+d5+WtBjEhuzJWMN+CbJ1HY2hqvoaLAk4Qu0Rn8s
	 XxILcKpnwp5Eu0nCLi43vimJEOMCojrctnoYf7VEteUKczzVAhq+1GslJ5KlsZhOFhhZJ
	 9TaZqM8IUW7Gb8NHU2vVGnOIoXIXSENea+sFQ0VErJrtrQ4o7Is6tvvdxKbQjI5hno3OD
	 gzbjhmIYOY0uDOZIQg6iYvWOphXXT8ISrmgRUiXaY/5CHXFfBX6TdWlplAB2/ME8GMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792713756;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=y0AF2BPwb3zDjVo0qR0UlK7gyXslLzdXypd8m3d7oUI=;
	b=GGT/L7UrSA+hID3pEXiO2HMNvhQ6KG43duV5PN71DNRd5g3ALD7NQamLlqUD61RH/4uy
	 VOX07GSuGJgSvQAsk6pviMRWQsqYjHuN2lGiEkhI0lKkZV1v66YEie4Fq39fkRTHvr8ip
	 PjcUa4QqAhx1zAnen0Q4XFU+CrasuBmOiERJkMv47NXfw/1d+X5n3C6mdACa5sR5SR7Wk
	 bvxfFluj6S1GwNf67eTQ02uUDN16hL2KCGe1Sn3KeREWfbTqmtLw0ALBTLdppDRqvM05P
	 oFOU8p24BNRJFp0Ooj4r4RKxDyBlsph3H6JKcUmye9ArNhzkya93pFjoIrjVzlXa7tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=S+zyM+m3;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28C4B606A31A;
	Fri, 23 Oct 2026 00:02:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 28C4B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=S+zyM+m3
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y0AF2BPwb3zDjVo0qR0UlK7gyXslLzdXypd8m3d7oUI=; b=S+zyM+m3zjhWsG95xrbQrUPREA
	P/8m1wqRYnAARwfDq9kMfz5SF8Ao3kV3eHs9aonDnZOvAdcGGS+NSDuZqBanYHVIG6w6LydgJrI12
	FcoP8Wa7VvNxxC4saD8vgkVHUduH7MuNjSXv5bKsSkZoyV42Ytx5Wvh52kPFjtHPe0i4Yy9OubYhv
	1S2QFXpwXYB9vRhpH3t+XSur6XyeLo9tAarlNK8p6MV2r2UEzme+EwA1RFkY0ueTwoCx/NMwyMdXt
	2cmTdMZ6XxeTnPVUcvUkzjQ1Ahdkz8um6Wcn7e290S8p/m67Z4SQd8Z9m3IaCv0vM3ZNedu/Pg3Wr
	SLkEGrdw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xK2jw-000000002rg-0AQZ;
	Thu, 22 Oct 2026 21:02:32 -0300
Message-ID: <8b7c86a805f36b8556e742c76eaf0a1e@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: NeilBrown <neil@brown.name>, Namjae Jeon <linkinjeon@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner
 <brauner@kernel.org>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] smb/client: Use d_alloc_trylock() in
 cifs_prime_dcache()
In-Reply-To: <20260929024352.1433257-4-neilb@ownmail.net>
References: <20260929024352.1433257-1-neilb@ownmail.net>
 <20260929024352.1433257-4-neilb@ownmail.net>
Date: Thu, 22 Oct 2026 21:02:31 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

NeilBrown <neilb@ownmail.net> writes:

> @@ -77,36 +77,34 @@ cifs_prime_dcache(struct dentry *parent, struct qstr *name,
>  
>  	cifs_dbg(FYI, "%s: for %s\n", __func__, name->name);
>  
> -	dentry = try_lookup_noperm(name, parent);
> -	if (!dentry) {
> -		/*
> -		 * If we know that the inode will need to be revalidated
> -		 * immediately, then don't create a new dentry for it.
> -		 * We'll end up doing an on the wire call either way and
> -		 * this spares us an invalidation.
> -		 */
> -retry:
> -		if (posix) {
> -			switch (fattr->cf_mode & S_IFMT) {
> -			case S_IFLNK:
> -			case S_IFBLK:
> -			case S_IFCHR:
> -				reparse_need_reval = true;
> -				break;
> -			default:
> -				break;
> -			}
> -		} else if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
> +	/*
> +	 * If we know that the inode will need to be revalidated
> +	 * immediately, then don't create a new dentry for it.
> +	 * We'll end up doing an on the wire call either way and
> +	 * this spares us an invalidation.
> +	 */
> +	if (posix) {
> +		switch (fattr->cf_mode & S_IFMT) {
> +		case S_IFLNK:
> +		case S_IFBLK:
> +		case S_IFCHR:
>  			reparse_need_reval = true;
> +			break;
> +		default:
> +			break;
>  		}
> +	} else if (fattr->cf_cifsattrs & ATTR_REPARSE_POINT) {
> +		reparse_need_reval = true;
> +	}
>  
> -		if (reparse_need_reval ||
> -		    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
> -			return;
> +retry:
> +	if (reparse_need_reval ||
> +	    (fattr->cf_flags & CIFS_FATTR_NEED_REVAL))
> +		dentry = try_lookup_noperm(name, parent);
> +	else
> +		dentry = d_alloc_trylock(parent, name);
>  
> -		dentry = d_alloc_parallel(parent, name);
> -	}
> -	if (IS_ERR(dentry))
> +	if (!dentry || IS_ERR(dentry))

nit: IS_ERR_OR_NULL(dentry)

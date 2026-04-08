Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA58359A9F;
	Wed,  8 Apr 2026 06:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775628956; cv=none; b=O5GRGjdG0sEN+7nDV+/usKzOq+tYEyAHOW1sUkIXffQNJ+ElVK4TGq1uH+1aUOrgKg6P8bF0P6ctXatpwkvd7N1bhuLnnaFwkEaYaa3hApzuO/bLY04abU555e0fu/uEqan4wYgkAv3OpOFICql7N6nNEfqJebWep3RvYsjr7Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775628956; c=relaxed/simple;
	bh=DQbMRzTIQItd1odYO0Fm8Amjj0W3G7NcMs8kUqbYEvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eYwdb3/irZt6/JDCVMisB06fGvHgMtyj4h+kbBdJDpVJwOwb6JoOYzZlwZGqbDpPdIV1CEAR93s0DjwtpxPCNPl9UgG1okngJmmw3V9FfAVhjU18Bw+iohDQ6v6gr6mivT6vueHtl53aCzyx5pyIoYp5sx7Rs3gZjvjQGT4fO/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EypEXkgV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EypEXkgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F34EC19424;
	Wed,  8 Apr 2026 06:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775628956;
	bh=DQbMRzTIQItd1odYO0Fm8Amjj0W3G7NcMs8kUqbYEvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EypEXkgV03LCwF7TXZpW3hKHLhu95MXvIKWDD6mWXPJ7TdchDJxbcy7HOR+gepGju
	 mRMGkceI84mR2VEcNASL+snL4RrI2/0ssHSWmz85StE+3xP0E8pGK1gAijWw9D0Vj1
	 zbglMt4y95RBZEHfOD5NF2uD1TmTOv2tBXf8gZx4=
Date: Wed, 8 Apr 2026 08:15:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org, stable <stable@kernel.org>
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
Message-ID: <2026040833-espresso-triangle-425d@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
 <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>

On Wed, Apr 08, 2026 at 01:58:27PM +0800, ChenXiaoSong wrote:
> The for loop does not seem to catch cases where `outlen` is excessively
> large. In such cases, smb2_compound_op() would use this large `outlen` to
> `memcpy()`, which could lead to OOB.
> 
> ```
> smb2_compound_op()
> {
> 	...
> 	size[0] = outlen; // very large
> 	check_wsl_eas()
> 	memcpy(..., outlen) // out-of-bounds
> 	...
> }
> ```

Ah, I missed the caller site.  Yeah, probably a good thing to check as
well, want to make up a patch?

thanks,
greg k-h

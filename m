Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D4C1876
	for <linux-cifs@vger.kernel.org>; Sun, 30 Mar 2025 10:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743330367; cv=none; b=EUeCrW1N1ZdEig4o05lH4TMbLrkD0fkVWCqsbU4L/sV8q1uCyohyKOqUb6x0O/yUMT1LzLmkHyIj9Xv2QUfluUVoKdT8aGgq60WdylwzkaQrCVMw6WiKxWg6BGkW8y7cgDFMiv4xGoLbBRZbeII/nAt0NFINYEvJYv0CrxoPj8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743330367; c=relaxed/simple;
	bh=oTnQqhXdV7QocfWRH+9K2w4bu+IcoXhmiwhwJnkqXlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1U3p2MhxcUpCLC+52TDKtACgh4B/KKH/w492oZ39IaO8+8YC1d/YpUiNI+4sgBehQ3pN3BLLYZ+GU8B+mwlHUxh0HCQOgIcLO6JcNAz06NX2nHU8xefKKGHw0+4Gf+dCZhuBjnwJ/ljgP8/9FHyWylgCugMlcWjlzVGxiG2rCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Olmw94w2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Olmw94w2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E24C4CEDD;
	Sun, 30 Mar 2025 10:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743330366;
	bh=oTnQqhXdV7QocfWRH+9K2w4bu+IcoXhmiwhwJnkqXlo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Olmw94w2da3v3H+gt3vjjWuJQ3LwVc1NzfFkyLW1L963igscoaBtBCa19jgK4nEGQ
	 ES95gnC7cA931CQZ2ArbA/5+kpiqhLlKorq60pTdTlUhubDwgOOorm66YahCXtPDAt
	 6qW19UwcG4eO5EYpHYBP9iSBsFFlKguz6sgEDKsmTxXM0xVGrAo5riZ5CjnXerNPX+
	 6Cb4t0wKLwT+EBvvV0m+zXttUq7KhUAhghOSpO2++FPV9POWiX5SvAFTxccRYhJYyt
	 Rp2Ao07thdlGAJx9p8ZiW2xkB8FnYKGuHNT15s7RCXt2MkKKD7E2mEP3LX48yaaUwF
	 /8YgLNisvaLTA==
Received: by pali.im (Postfix)
	id 266A65DF; Sun, 30 Mar 2025 12:25:51 +0200 (CEST)
Date: Sun, 30 Mar 2025 12:25:51 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: Fix getting DACL-only xattr system.cifs_acl and
 system.smb3_acl
Message-ID: <20250330102551.27wmuly6cy7bpr66@pali>
References: <CAH2r5muyUqkMbDxtPrb1zbQH5TKkaAc4Th-k_Dh7xATv6sEZVw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muyUqkMbDxtPrb1zbQH5TKkaAc4Th-k_Dh7xATv6sEZVw@mail.gmail.com>
User-Agent: NeoMutt/20180716

Ok, thank you for information. I did not know that there is some
failure, I just spotted the DACL processing flags issue in the code and
also I have triggered it against Windows SMB server.

On Saturday 29 March 2025 22:56:42 Steve French wrote:
> Pali,
> I noticed that your patch "cifs: Fix getting DACL-only xattr
> system.cifs_acl and system.smb3_acl" fixed generic/598 (which I run
> with idsfromsid and sfu in my test environment, and was failing with
> mainline) - Good job.   Am working through your large set of cifs.ko
> patches, and have been able to verify more than five of them so far,
> so plan to send some of them upstream ASAP, and continue to work
> through the others for the remainder of the merge window.
> 
> -- 
> Thanks,
> 
> Steve

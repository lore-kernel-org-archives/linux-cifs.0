Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2631459F6
	for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 08:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742804606; cv=none; b=epRGgjPsG6qXmFouLBtMvY83HObaC9XdZ3K6O/htVqOZb3jhNKwiEU/YrLiSDGwtFheWEvS2k5HFDP72LbpM5RoHcsXO7lrlZE5gc3psrbdpgfO6x9Io+LXrS4wIxLpiEHrE1dqjSuoNpt6fSk6WpfJNBTYCc2DYFpKGvoePKkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742804606; c=relaxed/simple;
	bh=7cLNIuWkMtI7/gaYpmvWrbsCrJ9XTcpg0+RdQa6cFQU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ACFJhLs5sFKIDAS68TzKKBnuEKnN1/nj13ndXTjTXku4tERyWD6JXnbARXxynFuYWbdmPEfpcWLE0xPdeIKzjTVquoVfR6ZptH66WYQYGKyLA4lVGRhGuArlt4zmpz1GCUWgq4hYMnqqVwBKOoH1pH4k2W+N4UiHTIoA2LKbw9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rP50tfmz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rP50tfmz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB004C4CEDD;
	Mon, 24 Mar 2025 08:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742804605;
	bh=7cLNIuWkMtI7/gaYpmvWrbsCrJ9XTcpg0+RdQa6cFQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rP50tfmzdNUd9K/gFf8Dn7jQqkdoxOqTJMV+gbGVLQg29f8fHv4QtiQvmjM+2nkOw
	 SrENuE0ABr9LdyJjkV1PVTWGGmjOfgsKtD+WWYpnwSEXEJQXydhYEUjQFyB5Si3P90
	 rz9YKwcOebj/IVw0tNWWC/JZ7Hq7k0ilrxGS5CwNSejfUrDxB1ybAKyjeIi3x2uTRN
	 hlKiwofmGwKeOVwxvNXtyLXMU5B1ByPi4dHwoCm0eMbnOUGQjziEUQXBF7G4+XbSSI
	 rzPMKjAzN2mtqf3rCBFOqtLK86MtOJjgUzABzRd9E08DuVOveiidPvj3YVpwfxiV6m
	 e/zfH4ja2ZXdQ==
Received: by pali.im (Postfix)
	id 943104B3; Mon, 24 Mar 2025 09:23:10 +0100 (CET)
Date: Mon, 24 Mar 2025 09:23:10 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
Message-ID: <20250324082310.fbvnxo6cmuwv2clx@pali>
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali>
 <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali>
 <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
 <20250323103647.rsex63eilfdziqaj@pali>
 <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
User-Agent: NeoMutt/20180716

On Sunday 23 March 2025 21:36:56 Paulo Alcantara wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > Hello, I would like to ask, how you handled this regression? Have you
> > taken this my fix to address it? Or is it going to be addresses in other
> > way?
> 
> It's already fixed in cifs-utils-7.2 by commit 8b4b6e459d2a
> ("getcifsacl: fix return code check for getting full ACL").

Ok, and into kernel is not going to be addressed that regression for
older cifs-utils?

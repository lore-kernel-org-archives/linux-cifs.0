Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F741E25F7
	for <linux-cifs@vger.kernel.org>; Fri, 15 Nov 2024 16:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731688865; cv=none; b=dK1pRRagrIcXFrBZUhV1ORppHyZDfAkoKsOgM9RFXI+TOOnI7yBwgFkix7WfRT4V8TOd2AXOtN14KEJ79Y4HsuaJmir78eOF3uQrnPBQO5/COB4Xgb5S6roMKRCRyBA7nS7X4ngH7SmFq1PhisUCV3k94YmSapsdLDT8SZFw3WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731688865; c=relaxed/simple;
	bh=oJiSQiBIOFK/0xazyFB8d9RY/xxSDA9D/t0e+veFqbI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IxsTqDfVHQUzNYYrUYzPW896kXwdkz2mcihLXVSd17IdxLqA6MMCRBbNFe7KvAVpMhfjxctNn0n/g+XCXjNjU2bry4+nFq8CHAI7ybp3YxQROUmiHRhfGMNAPRDmNVW3abKkVq9dMZBZUt/9BD1lmFAzOxDsCnGqzX4vbLz7y3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7ysG64f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7ysG64f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CCDC4CECF;
	Fri, 15 Nov 2024 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731688864;
	bh=oJiSQiBIOFK/0xazyFB8d9RY/xxSDA9D/t0e+veFqbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C7ysG64fb3Ov/47VvWSgtBWJueze4kp5uSkWEZgW8cV/AvIIIH876YyRmkWv6VaSZ
	 S+m7+V0jrdMlwzlkaoX1tkxj2Yj9obhKtXmgFShPQ6fkteswLZXlRxVYJaoxgLGVfv
	 PR912Asw4N9DWGCcT2WyZJNaKYYytZ0vqfH4gc/kBywXRDOL5DuOXxlvsECmhdOyMZ
	 MLfDOk0pehf3OFdOPEZEcCZZ/DRCiZm0h7ihithlbDIifGXDOwPeEN84iO6pJLoEmm
	 qet0wmxVc5+5ksrJ93yQWHTQhVs2dvR+b2Tgc0ISbIpyxjsxe43zttX6RdHt7fcUWS
	 YQtvPyAts5ZnQ==
Received: by pali.im (Postfix)
	id 49F0C9F1; Fri, 15 Nov 2024 17:40:56 +0100 (CET)
Date: Fri, 15 Nov 2024 17:40:56 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Ralph Boehme <slow@samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	Steven French <Steven.French@microsoft.com>,
	Paulo Alcantara <pc@manguebit.com>, paalcant@redhat.com
Subject: Re: Using file type information from POSIX mode
Message-ID: <20241115164056.tlowict7cmpo6uva@pali>
References: <7ef51654-5fa7-4333-8922-40bae24b18bc@samba.org>
 <af3dab52-562c-439a-abca-b3d742d2716a@samba.org>
 <20241115144631.qkteeweaz44knr4c@pali>
 <8663f904-36b0-4f7a-baf8-576c85b7cbd2@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8663f904-36b0-4f7a-baf8-576c85b7cbd2@samba.org>
User-Agent: NeoMutt/20180716

On Friday 15 November 2024 17:29:49 Ralph Boehme wrote:
> Hi Pali,
> 
> On 11/15/24 3:46 PM, Pali Rohár wrote:
> > I would like to point out about one comment which I already discussed
> > with Ralph privately.
> > 
> > Mode as defined in that spec in section "2.1.1 posix mode" is _not_
> > compatible/same as the UNIX mode used by the Linux, BSD and other UNIX
> > systems.
> > 
> > The reason is that S_IFREG / S_IFDIR / S_IFLNK / S_IFCHR / S_IFBLK /
> > S_IFIFO / S_IFSOCK constants does not match with the values defined in
> > that SMB extension "2.1.1 posix mode".
> 
> it is not binary compatible and I still don't see a reason why we would
> wanna have that given the ugly smelling kitchen sink it is. We can't rely on
> that historic cruft, we MUST implement a sanitized version of this on the
> wire and then parse it into the format used by the OS we're running on.

Well, I just wanted to point out that new SMB format is not compatible.
That is all and to make sure that it is visible for developers who are
going to implement it (as you were asking for Linux cifs.ko
implementation).

One of the reason (except the compatibility) why to use the existing
format is Solaris / illumos support, to allow implementing illumos SMB
client and illumos SMB server and transfer between illumos-illumos all
file types and mode informations.

> When implementing the protocol you'll have to implement a fair bit of wire
> parsing anyway, so having something like these function which implement the
> parsing Samba doesn't seem to be a burden:
> 
> <https://git.samba.org/?p=samba.git;a=blob;f=libcli/smb/util.c;h=473b479a2abf60cb28ee4374b5d90cb6dda82213;hb=HEAD#l198>
> 
> -slow

Of course, but it is important to know about it. That is all.

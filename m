Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9C6254872
	for <linux-cifs@vger.kernel.org>; Tue,  8 Apr 2025 22:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744152193; cv=none; b=mQQhDgeAKkHS7b5hZMKx/UgnN6HJRoCuXEBsHVepouYsiBKGthnVOZTy/Gth1CnTaErf8KPHc7OZE5244ojQQVovm5YBrxctOPOtkmKxKTauyaXGAgXRbWNltxMLX143uoD3Km/9KptNDyre04o2rggOWzzjnTq7jN73440x9EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744152193; c=relaxed/simple;
	bh=cLu5FHYBc/nQWl4l4GviLPMQtV7JFVbTS8r/c7JnRTw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k34ru6i7Z+MV3jyJxXIyC0Gj9xcJeVwXAizvAAgKy6Zti95VAY419n5FgLr8x2f8pU4DM8rT1Sq+WWyuPgPZwgrK8i+ZLibbRakduV8PkK4fCwwdoHvXF77MggU6tBBDM8Z4t93Qh4VXJARhh6DMgkTVbmJeqs3+ERlLHG8MYHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CqF5P50l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CqF5P50l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B540C4CEE5;
	Tue,  8 Apr 2025 22:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744152192;
	bh=cLu5FHYBc/nQWl4l4GviLPMQtV7JFVbTS8r/c7JnRTw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CqF5P50lsbOQb7emC46J7nXmQrRTTNyaLGIsPsIJw9+i2lTLgQP2GVJmPC52/bM9F
	 xsMwMRpmXOWhg6UkD6jvNkKXBE70C7RJwDHAd8x+mkBDkiR2y8xe1KYQXU28t/AaZt
	 v1dszBgbyI55iWTVryyFBGendRzPBdSQ7tJhS9uM8zA3nkUTLqYcKce0tglh24rS0N
	 9PakZGibg3JJo0IUTCrtlxxcoIUJvt/zqXBrv/mrZ4gd/z2bawGhgzk0rqH5OKKBo7
	 vRtWkzXfqdqh5WlkKPHvSPmamQu4vCNdk9uXn15IDfZkSQqKcO/ei/OsEnqLSjolB4
	 hlAX2taDcMhOw==
Received: by pali.im (Postfix)
	id C871D968; Wed,  9 Apr 2025 00:43:09 +0200 (CEST)
Date: Wed, 9 Apr 2025 00:43:09 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: Tom Talpey <tom@talpey.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Namjae Jeon <linkinjeon@kernel.org>, Ralph Boehme <slow@samba.org>
Subject: Re: SMB2 DELETE vs UNLINK
Message-ID: <20250408224309.kscufcpvgiedx27v@pali>
References: <20241006103127.4f3mix7lhbgqgutg@pali>
 <20241225144742.zef64foqrc6752o7@pali>
 <76c28623-b255-4589-8bad-7e576cd1687c@talpey.com>
 <20241227163202.ihp3cxmhe2sehxoh@pali>
 <749690fc-4647-487b-ba21-d208d72f754e@talpey.com>
 <20241227185130.idio6hh7w4pcpqfo@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241227185130.idio6hh7w4pcpqfo@pali>
User-Agent: NeoMutt/20180716

On Friday 27 December 2024 19:51:30 Pali Rohár wrote:
> On Friday 27 December 2024 11:43:58 Tom Talpey wrote:
> > On 12/27/2024 11:32 AM, Pali Rohár wrote:
> > > On Friday 27 December 2024 11:21:49 Tom Talpey wrote:
> > > > Feel free to raise the issue yourself! Simply email "dochelp@microsoft.com".
> > > > Send as much supporting evidence as you have gathered.
> > > > 
> > > > Tom.
> > > 
> > > Ok. I can do it. Should I include somebody else into copy?
> > 
> > Sure, you may include me, tell them I sent you. :)
> > 
> > Tom.
> > 
> 
> Just note for others that I have already sent email to dochelp.

Hello, I have good news!

dochelp on 04/07/2025 updated MS-FSCC documentation and now it contains
the structures to issue the POSIX UNLINK and RENAME operations.

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/f1f88b22-15c6-4081-a899-788511ae2ed9
MS-FSCC 7 Change Tracking

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/2e860264-018a-47b3-8555-565a13b35a45
MS-FSCC 2.4.12 FileDispositionInformationEx has FILE_DISPOSITION_POSIX_SEMANTICS

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/4217551b-d2c0-42cb-9dc1-69a716cf6d0c
MS-FSCC 2.4.43 FileRenameInformationEx has FILE_RENAME_REPLACE_IF_EXISTS + FILE_RENAME_POSIX_SEMANTICS

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/ebc7e6e5-4650-4e54-b17c-cf60f6fbeeaa
MS-FSCC 2.5.1 FileFsAttributeInformation has FILE_SUPPORTS_POSIX_UNLINK_RENAME

So now both classic Windows DELETE and POSIX UNLINK is available and
documented.

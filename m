Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D7D137920
	for <linux-cifs@vger.kernel.org>; Fri, 19 Apr 2024 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713545719; cv=none; b=u+0SUU+rP5lTMhdO0AbDct0TUAEUKIqbATeDEiMxToQueVOb8kgaYSBpZupyURkb6JcJCAMvS44yJlSfxiqYkBjqg6HZtf+OkA2JI7iRsq06Ss2ryR/xpZDzEezzzm68NsRKUCtl9XZMUPKTSoDJOHOUIDO+mWJX5VECI/uCPfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713545719; c=relaxed/simple;
	bh=Qe/EV9/Kqm1qV5Cxnug5Fw4ZZNkZIS115ZGadsREAcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ielJxZAKgzZoR+T/CXtXmGvHyMj6HydWFuyNocx/3d9cKzKcwvjqH/yHXRHr/eKqQVZKR10kHd5YEPPtGviI504cwnFcLlfaqedDoACC3PjXGV40Hpw6GxpcbHEMa1gummyizfySqP4sYXzSha0S7vO1qQLOegeJgcXtVvTPY3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1Gi3dI6L; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1Gi3dI6L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=3Wkhrr08905LBJQuA2p6CC2d4NwSOTYcOSg+PuulNiw=; b=1Gi3dI6LyP8Bj/gxxkUa5b6cZo
	16pxq2S1m1M/DFjR+dt6aa/U6/LbVIqelYJkVJUzoam6JQYMg+f/cYMsJgaOO50frwMRs6qqM7Kkx
	sqEM4D3NaNktvyGkzCev1ob6Q5fpTir/ch35tdgWN+odPfKS0aUZu0guRVk26llz6Tbzxtd2txKnp
	gaCp/og6eK1bObDuZucv9ctRklLAFtVjC4LabIBtoOxUV7TDk25XgFkmwfuAz9QJR8k8xioqHQqbY
	x7TlwrBEZ0wSiF5XEj5aLfcIiQt6x6hF89Necnm82QPfy/AxKeh8iRIZH0wxfWTXMIY4OL77C7N+f
	zKvlQ+JXfbN2cjeX5RKJVH4UK9H98dRnPYpVM9rFV9sTexoeTzhc/TKsbvTtw7kJjBNjqcqmrxPyv
	KrMdu6yo0F7QfhXquEA8b69eySpraaEhwmvsm89pzceeK59G6205QtdDiR2fVGl3wqhygn4gBJZPq
	eHgjU2KVRmpTiOuWlfVmMOcm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxrW4-007I0L-0K;
	Fri, 19 Apr 2024 16:55:13 +0000
Date: Fri, 19 Apr 2024 09:55:09 -0700
From: Jeremy Allison <jra@samba.org>
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>,
	samba-technical <samba-technical@lists.samba.org>,
	CIFS <linux-cifs@vger.kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: Missing protocol features that could help Linux
Message-ID: <ZiKh7cYq5/Z7zwNj@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <CAH2r5mstDacz=gvpjFQeB_nc1kBjyzTZw57tF8UNrXARXkV1rQ@mail.gmail.com>
 <e69bad72-9139-4b01-afe5-5d34edc077a1@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <e69bad72-9139-4b01-afe5-5d34edc077a1@samba.org>

On Fri, Apr 19, 2024 at 06:53:01PM +0200, Ralph Boehme wrote:
>On 4/18/24 22:21, Steve French via samba-technical wrote:
>>Was following up on a recent question about support for Linux features
>>that are missing that could help us pass more xfstests
>>
>>Looking at the standard fstests for Linux (xfstests that are skipped
>>or fail for cifs.ko) to find 'features' that would help, perhaps
>>extending the current POSIX Extensions or adding a couple of SMB3.1.1
>>FSCTLs, I spotted a few obvious ones:
>>
>>  1) renameat2 (RENAME_EXCHANGE) and renameat2(WHITEOUT)  2) FITRIM
>>support 3) trusted namespace (perhaps xattr/EA extension) 4) attr
>>namespace 5) deduplication 6) chattr -i 7) unshare (namespace command)
>>8) delayed allocation 9) dax 10) attr namespace security 11) fstrim
>>12) chattr +s 13) exchange range
>>
>>Any thoughts on which of these which would be 'easy' for samba and/or
>>ksmbd server to implement (e.g. as new fsctls)?
>
>well, I guess none of these will be really "easy".
>
>Iirc when I last brough up file attributes, we vetted towards 
>postponing this kind of stuff until we have full support for the core 
>SMB3 POSIX features in Samba. Iirc the only real thing missing there 
>is symlink/reparse point handling and for that we need to settle on 
>which reparse type to use (WSL vs NFS) as discussed yesterday. It 
>would be a *huge* help Steve, if you can pursue this internally, this 
>has been a blocker for the whole project since quite some time...

renameat2 (RENAME_EXCHANGE) and renameat2(WHITEOUT) need to be
mapped into Windows SMB3 operations. We should not (IMHO) add new
SMB3 operation semantics into POSIX that overlap existing Windows
SMB3 operations.

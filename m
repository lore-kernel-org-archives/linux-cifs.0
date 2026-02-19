Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D5928469B;
	Thu, 19 Feb 2026 09:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771493133; cv=none; b=flKNWNWhXdA/WSYjxNvRqe9weD6CBQpmVWhrbnn+3pjkGOL2yZHGw6M0o/SCKTwmE4PKfU0jraqP2GLM02L0bnkDBGYXSEy21euDCoD6L8pSvMFj31FYTfjqIV3T22ArjKkjD+C1ZWu1BkiQNJkc2CdOwE23UV+uPSrAztQ1cxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771493133; c=relaxed/simple;
	bh=uNYpNSy7IiidzuikeyFCI5WjXpjW/GUJ+SlkMsxnx94=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=JTReElui+MSqYfkcy1uSRcSWgFpN02DOTk8376IBi5uaYKkAUiwHXhifzqMHVuE9KYxhicMBFcinUVbeUht3hMp2Uhgft79vj69e3SJUYKJnt32R9npsE6PqF7biWcy2VYMQY+3peBM2BYaUnEvkm+88mueLjquqr8uN6PRbZlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSxnhAjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSxnhAjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222BEC19424;
	Thu, 19 Feb 2026 09:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771493133;
	bh=uNYpNSy7IiidzuikeyFCI5WjXpjW/GUJ+SlkMsxnx94=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=RSxnhAjngAuhei6JodNl5Iv1VfgY6yl1TBuogqOsx0KwHg3NuwpGkfwjAHkqLqgX3
	 rwSq7nD6MIZPD1WgiIY8pQysDvJIUVOcKiIorkFhdD8J1iIFy/TzsGeCP+9uQJ/DCl
	 jQjOhHCuDKu35VJBJt3bsU6dGxMJdFeGP1jThDqBjJZV/c3hpttqUq4rgbJ2sSr957
	 m61buTPKf/RahM16DfE5JhAfkTwv0HSVeezKEfzgdOWzoUrlqESS7K2m+h8RE15kPg
	 XyXo9FSFtZ7zb4bHljl915nR8LGrcwy8Cob3+B3CDFvhkKPQB17dvMSQABtubhPJUH
	 FgHavGhRyYsDQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F11DFF40068;
	Thu, 19 Feb 2026 04:25:31 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Thu, 19 Feb 2026 04:25:31 -0500
X-ME-Sender: <xms:C9eWaUPj9T4X4_wx3nIgsb9NViIdq9gaLCvZXt4GXyJGKmUyLmwe8w>
    <xme:C9eWaVzJMjCgZEynboFPd9nh3whZX1XdXlqnl2vReOSGI6Pop2vlm6C8IG1lDBKbr
    1Ep39E4sE73DgElca5M5xjGfPhwyO70Au5vvJYRPSDDN9q9mHgIjg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvvdehudehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohephhgvrhgsvghrthesghhonhguoh
    hrrdgrphgrnhgrrdhorhhgrdgruhdprhgtphhtthhopegvsghighhgvghrsheskhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghlsehlihhsth
    hsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtghifhhssehv
    ghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqtghrhihpthhose
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghl
    sehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqfihirhgvlh
    gvshhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrshhonhesiiig
    vdgtgedrtghomh
X-ME-Proxy: <xmx:C9eWafuBjL2m5xFCImGV1qdW-gFM-foL3YqLX6U5MgCq4p2VM0Vhqg>
    <xmx:C9eWaTjbc58azvYA4I7wOKnJlNNf1AJyt0rImxqxeu2mMKORRIVNCg>
    <xmx:C9eWadZ-Bv_h4Txq9-OXSFJml6THmPVIrehNemsko2RESe8VyUTsEQ>
    <xmx:C9eWaaa8Asbz0k1XsBF1D8OFFMD9kRU0O9Fpz5TFSgCAz3lsHlNliQ>
    <xmx:C9eWaazfbzVcIJwddNC7pPMXgQ7t-4OlBb738ixcw-P8rxJ06c3Pjj92>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D354D700065; Thu, 19 Feb 2026 04:25:31 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A8bZvXKbNLQo
Date: Thu, 19 Feb 2026 10:25:11 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-wireless@vger.kernel.org
Message-Id: <3f1a9deb-3e07-4b4c-8b4e-7dfbba30452c@app.fastmail.com>
In-Reply-To: <20260218213501.136844-1-ebiggers@kernel.org>
References: <20260218213501.136844-1-ebiggers@kernel.org>
Subject: Re: [PATCH 00/15] AES-CMAC library
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 18 Feb 2026, at 22:34, Eric Biggers wrote:
> This series can also be retrieved from:
>
>     git fetch 
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git 
> aes-cmac-v1
>
> This series adds support for AES CBC-based MACs to the crypto library,
> specifically AES-CMAC, AES-XCBC-MAC, and AES-CBC-MAC.  The
> implementation is fully optimized with the existing
> architecture-optimized AES code, either single-block AES en/decryption
> or arm64's neon_aes_mac_update() and ce_aes_mac_update().  As usual,
> optimizations are now enabled by default as well.
>
> AES-CMAC support will be useful for at least the SMB client and server,
> and the bluetooth and mac80211 drivers.  Patches 8-15 convert these
> users to use the crypto library API instead of crypto_shash, though
> these patches will likely go in via subsystem trees later.  They result
> in some significant simplifications and performance improvements.
>
> As usual, a KUnit test suite, FIPS self-test, and traditional crypto API
> wrapper algorithms are included as well.
>
> Note that I'm also planning to add additional AES modes to the library.
> This is just an initial set of AES modes to get things started.
> Notably, with the SMB client and server already using the SHA* and MD5
> libraries, "cmac(aes)" was the only remaining use of crypto_shash there.
> So it makes sense to take care of that.
>
> Eric Biggers (15):
>   lib/crypto: aes: Add support for CBC-based MACs
>   crypto: aes - Add cmac, xcbc, and cbcmac algorithms using library
>   crypto: arm64/aes - Fix 32-bit aes_mac_update() arg treated as 64-bit
>   lib/crypto: arm64/aes: Move assembly code for AES modes into libaes
>   lib/crypto: arm64/aes: Migrate optimized CBC-based MACs into library
>   lib/crypto: tests: Add KUnit tests for CBC-based MACs
>   lib/crypto: aes: Add FIPS self-test for CMAC
>   smb: client: Use AES-CMAC library for SMB3 signature calculation
>   smb: client: Remove obsolete cmac(aes) allocation
>   smb: client: Make generate_key() return void
>   smb: client: Drop 'allocate_crypto' arg from smb*_calc_signature()
>   ksmbd: Use AES-CMAC library for SMB3 signature calculation
>   Bluetooth: SMP: Use AES-CMAC library API
>   wifi: mac80211: Use AES-CMAC library in ieee80211_aes_cmac()
>   wifi: mac80211: Use AES-CMAC library in aes_s2v()
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

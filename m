Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080EF27470;
	Tue, 17 Sep 2024 20:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726606513; cv=none; b=Rz03gYfld6tv0D0hn1vmfluWSijH116h61gbqDSShIotbXmEG32U26K1ZjNHXiT9R2WwBipiGAAHjTpZCg1Vilzo16Bd9YWdvbvJwVuphMgVmOuLj3R86KxsSY9gOCNUpiJhER2a6Ms9ykD84Hep+ueNy67pQRZhXkFxa5wzoIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726606513; c=relaxed/simple;
	bh=mjTGlZ163pOCGFSGDD/ozGhwT5Jtnls34lFZ8aDDWrE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iid4g7UHCkZ9ld+dtmsyof3P2otKr0JUBJblYTNMLzL3OwbPMVqaQIz+insA7ZLv6k5qi3bhl5ZXomJy0GqsayUJ2R815ZSzZonpyxBdY/A5JF7zxMbE4XiddxAspRzSqqRjg6Q+PO2LFqQraY4qGRBP2kGrO9F9i7ZPhQYKp5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fAyCLEqR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fAyCLEqR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=mjTGlZ163pOCGFSGDD/ozGhwT5Jtnls34lFZ8aDDWrE=; b=fAyCLEqRx553cMRQM3t0HVQW2O
	nLvoSV9L2m6lpt5fNKuZBwnnWK16tFWDcS04wNomNJweu2dLDR0Pu/xX5bScJMQAz85Wk3qK/8Pf3
	yb80+FrZqwWnUNBO6BxsvFxWEMfwdLI15IJrsEmnkWk385k4bL2Au81RyYX8yiJk9AuXWmHrY67iZ
	dgCkbDj6zKy1MGF0Vg0Zo0XEPAzi0gMuzmtUc7JF3EQPMfJqxDiMDG5uIDa4XvpI2+mSEbGApNnL5
	nqVrL86zxSCoZAWqH/rO9Q6kWHqZpQ4ZcCdDTm5d826nPgnYxEXaO5v4RD9iiwy/SCnfgj4bhZyiJ
	nQ4Q3wugN1NFysGR3eirWvyBArbZwMFadNEBVQFZOYswQp2vic4zahCVX3kT+HF0xLgc0QCwZv4jO
	9tObU+ZvqEBYDxbVLDu49DqvSg5BP7VDziSVctNTbr/G6zHnscaWt0H1jc4Ga7A4fWKDPGy2sUCXG
	MBzsuim/3LfMiTB2AqWx+YD8;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1sqejf-000baw-0k;
	Tue, 17 Sep 2024 20:23:43 +0000
Date: Tue, 17 Sep 2024 13:23:40 -0700
From: Jeremy Allison <jra@samba.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without WSL
 support
Message-ID: <ZunlTDxPLn4yryW3@jeremy-rocky-laptop.localdomain>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
 <20240917200600.6smfxhrppkyjuyku@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240917200600.6smfxhrppkyjuyku@pali>

On Tue, Sep 17, 2024 at 10:06:00PM +0200, Pali Rohár wrote:
>And seems that SMB2_OP_QUERY_WSL_EA is useful not only for reparse
>points, but also for any regular file or directory as it can contain
>UNIX mode and UID/GID ownership.

uid/gid should *never* be exposed over the wire for SMB.

That way lies madness.

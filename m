Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792529982;
	b=BFtLy+QSLP49IUqlXCRtk3vDrZkG9EcyUjOIJftJLE3lcFSqRZ/yFej7tBcUvQhQpCsj
	 XsOaozbVYC+IuJ8WT6ae8ceKGxQTtm4b8VuXSZ0T1xZfIy4SP1HvKp1TeQCFok5DMmb8x
	 LA57tcQchq5QvnILgsGEL1ZnFoLSIaiidACUgI1Q0mFa0PwvDv2VR7HE6+ZSmenmDBkQg
	 psjo8FIr9nX6B7fRARm5OAQ3Bsg1WA7DRXfe9pdgPTI6MJlmBYkDGCDCOYtvnW6IN6XZR
	 Uf5NliJTxn/6PXfFHgDzlG8OOd2xcV4K5Y3XZ+tF0zs7Y3IGG4/zoMolPnL8w/xo32w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529982;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=VE7p/L/3yxTJYwyBjIwtl8Ff79GppXv+KyTupwFY5NQ=;
	b=FGELg1uicMiiTTLi98QE/d47ONABumvsihLzHBQBV3RMvS3LHmAAzt9XvVqz8YicELTX
	 7lzoSiU7wZJ2kuaR7cMLxtX9TgiRQJa2pDmv9obTSGmDcQ1PVepH9g9kVDj8vD+CmjDcg
	 iq/ZQxePx8AG6h4vb1LAJLgQBvFp3D7hRBXEKL4hrd5kdqnHRZfxXe4Ak4myIZvk1SAVg
	 GbzKq7yqBLnj3zagOH5t6HE/fLX7YaMcirUTsOywNrB2C/PDuw4PPMvqdpx1MspIQsFWy
	 ga++pEoJ3q25Xi/H24qLW2e1QpGGcYrSpaGNsU8EBVV1f2NK05KIp48AeTA5fFzBreA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eC+w/Fy/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 8F6D8606A31B;
	Tue, 20 Oct 2026 20:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eC+w/Fy/
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D81731F000CB;
	Tue, 20 Oct 2026 20:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792529982;
	bh=VE7p/L/3yxTJYwyBjIwtl8Ff79GppXv+KyTupwFY5NQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eC+w/Fy/mrlW9xD8B+x5pPjKfTyPP3E4gkMLFXSLVfsqQLqoy3TsXeyotw2GkijzY
	 f8lHAYvJJdOY06x6jRyUUoCzapBT0qRrVyji8pr6SVYHcRCzdqwGfeVClU8fXk1gt6
	 K4Q3tZedy5wQUw0UXy4JH9oK0WtG1/cNOpEWy72b0mgYRYnrnkGAYXMRZh58PCc1YH
	 HcTkyz1sz+8Ig3nOVsWyIYZckm9eejMTiRSko/7nqoghkWHHVCVfV6Rm2VP1w6qRvG
	 gPLJtBiC8qPhcZwFRYJonU2Ma7ndQcnK1GgWQlfTjWoAkK9U6S1KmLTXVR44xezEW3
	 Y/RT+J7gGAksg==
Date: Tue, 20 Oct 2026 23:59:38 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	"open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <linux-cifs@vger.kernel.org>,
	"moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)" <samba-technical@lists.samba.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SECURITY SUBSYSTEM" <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] KEYS: Expand key->{datalen,quotalen} to unsigned
 int
Message-ID: <atfWOitzEIWKJvog@kernel.org>
References: <20261020174325.2229448-1-jarkko@kernel.org>
 <20261020174325.2229448-2-jarkko@kernel.org>
 <atfT5WJU_ldjpQOM@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atfT5WJU_ldjpQOM@kernel.org>

On Tue, Oct 20, 2026 at 11:49:46PM +0300, Jarkko Sakkinen wrote:
> Now that Eric pointed out Sashiko review I was able to look up this
> via web browser:
> 
> https://lore.kernel.org/linux-security-module/20261020174325.2229448-1-jarkko@kernel.org/T/#mccc5900222fdad9d790be343fcec2a32540ed2fb
> 
> This is somewhat inconvenient though that it responds like that, and
> not to the review thread.
> 
> Not actually sure how do you write a Sieve filter that automates
> relevant-to-me Sashiko emails going into some specific folder but
> I'm sure that is somehow possible. I guess I'll start by subscribing
> to linux-security-module.

I.e. nothing against Sashiko per se. It is probably useful but it has
configuration that is worse than eg syzkaller has. I will adapt to that
but this still the case. It is easier to adapt now that it finally
unmasked itself :-)

Br, Jarkko

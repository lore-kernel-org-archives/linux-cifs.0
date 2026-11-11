Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794409882;
	b=j4J4rwrH1vXIIqlFF2ogt8EeXSuMM//WWdNhk+aGeHD1t3Q7jt1RGUfWNzCH94wtns45
	 u9VitTPKW8OIJn+GLhAp43a5wiP3k8NQ+bm6m24FMuM8DXAeUVDZvjpsbJmF2PI/+0fxx
	 VD7WB4x6ut03r7JVIKHjQoCXMbeyK38cAcTSeIU6BlbDGbKkHNrjyV1iIs5L168Er0tRa
	 bZ04vC512t2H+5biRXa4wbGS78Qh26YZua+verrShGnp4FtdeNUQIHdlg2rVAej2LX9lk
	 XZb5GFyrrhhC2PxJ3qjIPukfifqvP39yuvsN/RC7OcjUf2Nw1HmupSsOk4RtgTiT2hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794409882;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=XAlTL2LFGS+9IWqMnhy/DK79P8/59F0LfDfEFvaBgRA=;
	b=NevQvSyEyh8MHa5KmQzngc2GhY978/U6lFEspCajUq0ZBwlOsQFghbWi6xFXfYShZc8C
	 TfNyEpOq28OfIoxSiGox7yByb+Ui8+2MWgCxSvr9UIwy2bJOx1TzrBYro0IYptECIAVn/
	 jDipvU7ahCOXCkTXSX5JsBytoOYYqpd/0AtV1ZYS1O7Ki8QZ8LhM/wvsE5cjjb65W8oMI
	 MY1OSVPucieHa6GTtQu1aEH/Lw+GO9C4vPSjh2t5/D6XWTy24JWQy0B9rK8zqJ3/x9bTE
	 1txQ4WqBPxLOJHx0O1BpRAqXBUDJwuF1d37JBGzk5YbYIisQ2itESCIugH0aXzYHszA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=nHPKQKhh;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FD5606A324;
	Wed, 11 Nov 2026 15:11:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FD5606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=nHPKQKhh
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XAlTL2LFGS+9IWqMnhy/DK79P8/59F0LfDfEFvaBgRA=; b=nHPKQKhhqVAY+6MEVl0t81unc/
	qoFvprAueigA7nrKukqstjy1Z+k6SMohMtJcCRUHX09jM3tU34CDVX80IM77XiFLi2LZEdIJTCYl1
	++ky1seeKPmSnzuLSth+4Atysi4X+X5gi0N6ERSGwgn/9mEWgBNXNmlj9nEMhWj1dtOY5UpxR7DVa
	6EfM9Ge6HfQXcV8oz/kgStPzX9GiN/CsEkQgwLNQcwVEvxE7MpNLmpFqUm+IO8Fqyq7iE1GFMR7PV
	cCp0LVrxlmk0DMRZAMHpK6QgdRdBzSbE83zLl/Sfq656pckFrQa9tOvUVQLlA3B20+VGlCnAR28vx
	USfJw3Hw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xR9yo-00000001TLA-2qqT;
	Wed, 11 Nov 2026 12:11:19 -0300
Message-ID: <3afd9e7768046ad4e444896d3e2b7328@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Namjae Jeon
 <linkinjeon@kernel.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] smb: client: flush deferred handles of other
 names before a hard link open
In-Reply-To: <20261111135324.4028153-2-pc@manguebit.org>
References: <20261111135324.4028153-1-pc@manguebit.org>
 <20261111135324.4028153-2-pc@manguebit.org>
Date: Wed, 11 Nov 2026 12:11:19 -0300
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

Paulo Alcantara <pc@manguebit.org> writes:

> cifs_open() flushes an inode's deferred closes before opening a different
> name (hard link) of it, so the open can take a fresh lease rather than be
> reissued without one (see "smb: client: retry a hard link open without a
> lease").  cifs_get_hardlink_path() only triggered that flush when a cached
> handle had the same open flags as the new open, so a differently accessed
> name - written then read, say - skipped it and opened without a lease.
>
> Match on the name instead: flush when a cached handle for another name of
> the inode is open, so those opens keep lease caching too.
> ...

Sashiko found other potential issues with patch 1/2, which would require
a lot of rework to get it right.  Therefore I've applied this one as it
already fixes the bug reported by Giuseppe Piscitelli.

Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0663B9618;
	Tue, 15 Sep 2026 14:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482593; cv=none; b=MYZwMAV7Ft79fFyvo8mrjdeWv0ZA0vTcf1hfJ7gwOFkmm8NBx83hlHQVPv3ppiXyP5WjhiQKBgSh9OoyhrUsaAKc9h0HXd4VHBWyPgHBTYdTnMaMrr+Op7hoI4h4fgUbxln1NbtNsk8rwaIaB5asxfK5S/W6GHovUvhKHsHa8Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482593; c=relaxed/simple;
	bh=8xdf8gzPyfdJ3OQfppausJ0juVUP81ZfYTEbjqbKSMM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=H0iDceP7DTXwZgTrADrAsLYpFkfNZDksAu0OCr2EpkLtlbAtUCMxmLqLrpCaNh6kdOom7ATFn3mhFVFgX9WfDrcNOZKbSz0acEz9UbqmbBZ8Vosm5WQYgYdiDGAv9gCrh53dX1k/AEw9BfyEA1F13Fu9VTSRFejpvh6HDWZsO5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=eHqHvGm6; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="eHqHvGm6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tdtf8hpCVUEj/TQswvkMJOEPAgNP4pBYCf5P7qniYeo=; b=eHqHvGm61vc390FmgOshp7wgJ0
	B3PKuS7r2ChQ1NuF1+GkkyE+zIxyhY1CN0B2yGwaH0x8swhbpXS6neS+ZQXc5a0JexNK2QJUxmcUJ
	K8qqSBUIU7gCpPoxOCvEcm65Ll2K9AP3tUb4NSw6Z2VFFAT6aZNtKbzcrJQR+5cCeNi9B1s3mT+IE
	RhOwP59v+rPp8p79uVXYMCzglSEaLqaqbCis+5ZSAc5PWfoGz9vRtvyqR7Imr0MjU+MwxBIfzQH2B
	i5b4dhm4W3AHD7SlrmHwVBcW3qREvaF9eeYe/5HBIDeE0wcTWyofR/rVTmJBEi0dEL9OYUh8SFUWW
	r+FUx1xQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x6UAP-00000001UpF-3pgP;
	Tue, 15 Sep 2026 11:29:49 -0300
Message-ID: <5c2bc41d3dac15a5fd153444121c827f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Tom Talpey <tom@talpey.com>, Shyam
 Prasad N <sprasad@microsoft.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Bharath SM <bharathsm@microsoft.com>, Namjae
 Jeon <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: fix fattr leaking on wsl_to_fattr()
 failure
In-Reply-To: <20260914011052.809774-2-pc@manguebit.org>
References: <20260914011052.809774-1-pc@manguebit.org>
 <20260914011052.809774-2-pc@manguebit.org>
Date: Tue, 15 Sep 2026 11:29:49 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> wsl_to_fattr() mutates fattr fields as it parses each WSL EA.  If
> validation later fails, the function returns false with partially
> mutated fattr fields that callers do not reset.
>
> Fix this by parsing into local variables and only committing them to
> fattr on success.
> ...

Applied.

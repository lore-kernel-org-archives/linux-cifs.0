Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA742046B;
	Mon, 24 Aug 2026 12:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787576172; cv=none; b=MsQ0OvvqNqbeerIOt8KPmSW1D35bR1tytglPaqDx0l9n7bWeWIw61ZbPRXECDdOtYsOJO/1/ZUE9/Jedr/hdqg/WyAfDkXY9kcJvdlUbe1g1fefmg8IhI+zvSbBJbjFCDA0NXeKsnU71YTvpz9/iiZsWG74nm9F9TL5nwS4QY3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787576172; c=relaxed/simple;
	bh=wrqhKy562GAHR7e5XZIHxOchJnJQcrFJcxXpfKTZ52s=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ZeuOndumQIW3H2g+Vh17r1cnfVaFyB82tKGaMbHkv9tFl+FzM2PsdzQyZeWWw8g2F4kc3MDAMphfQl90gWrYwak8JDT1TOfniyzgMFonZPeZ5kNX7VTNdP4D8e68oxkjCYWArtJxOZtWBi0oRm9rxAqtOy36iz/0CfXdd4LGfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=NOm+pAAS; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="NOm+pAAS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JmNjsD4g0Ts1wD3Vf9jzJ1CDo7ezTLHe49tpjmt9ijg=; b=NOm+pAASUkqXhelcZas32k/gyP
	UjV4Z89iJ4E8qDCTFe5GezrEpDZTEpMHaRd+0dHNgoGJ06PdyiFoh3MiV1x+gGl7Y6sLRjDqRN3vl
	eNwBREZeLymNcmBrm0+46FaCKlyI5ve9YXfph61pYqtC5BhNjTtFELXiCyoD7LhfUaex5FjpAg9BX
	pCu3HXBTf0g9SU4xfdm8NP1GyDERDb5JKBNAwXHCW8Qm6BBcSiU2CzEpSaDhEz3LLEi+kTwig0toT
	6tloGukwzCb9GaQOXQ68Ul5U2hNO+yDWQbMAUuKtdUI5/VAo3MKNpoIq7nTzkWR01L2EgN8jdCz13
	ucOie94Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wyUDh-00000000YpK-1OC9;
	Mon, 24 Aug 2026 09:56:09 -0300
Message-ID: <a7e552d6083f042e9b5e8cd0b0e93cf8@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cifs: fix loff_t underflow in cifs_remap_file_range()
 when len == 0
In-Reply-To: <20260822215517.2353835-1-sorenson@redhat.com>
References: <20260822215517.2353835-1-sorenson@redhat.com>
Date: Mon, 24 Aug 2026 09:56:09 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> With len == 0 (clone to EOF), the effective length is computed as:
>
>     len = src_inode->i_size - off;
>
> If off > i_size, this is a negative loff_t, corrupting the ByteCount
> in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
> in filemap_write_and_wait_range().  The existing off >= i_size check
> fires only after the ioctl has already been sent.
>
> Snapshot i_size_read() once for both the bounds check and the length
> calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
> off > src_size with -EINVAL.  Treat off == src_size as a no-op,
> consistent with __generic_remap_file_range_prep().
> ...

Applied.

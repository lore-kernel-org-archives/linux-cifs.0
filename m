Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60FC368D62;
	Sun, 13 Sep 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789323992; cv=none; b=uc1N6ipvBLE+kKUh3Lcnm6Hy5OW9ETsFEZtBYqaITLNoJ4rhlRUEKTK4NHSOqyJzfzDq93PdDqZCY44tyAN54zq80rS9Ro9V409/a6zZlgGisprgFintVxN/RX+1TlebZYb1OIlVoJRkXawM6kNxnbguIeWpVW+aZFRwwDTlmLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789323992; c=relaxed/simple;
	bh=b0hw316zayLP5GnJ0lUa+j6Lhq/A43VtmASB+ntKlMM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Z0PuMRf2Azqbel/ZpNYwSqPxpC9U/UT7d8TDvTzx+I7lrdMzyhcIlIfaiV3O9SHLRDXkcEU54XakRF/jPkvxoduoEeLW2p1+B0nm8/L2qkfbjRdI714TZyzgtdf18w214/uHq5MPK9qoIMuwZTVycxWpK8IrNhNspdZhk58aytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=TjzcNGA7; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="TjzcNGA7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=b0hw316zayLP5GnJ0lUa+j6Lhq/A43VtmASB+ntKlMM=; b=TjzcNGA7QPqnhMXAmZABTQoL6D
	ZzEM8Brr5eCBPA+gCacCBVB/B9hQfofm0n2/sluEZKqTufB2YpAGu4FtVTiHyCtS+MxanFmjqjPSA
	v/C6DBRx1WpWiXZmhzq5QhhHvQeEH1HC3TWFvP8uWb9zOdtJCjcxZQBAEErlTwywLtf/BAsxfwEWi
	CebjibFpTuAmlsSB7YpU9rfWagT7qzHis1eiSmZORYBMkmHFq+vE46PsGHhaOrbA3e7cnRDtC744B
	1mJK352jok2VtUQOZ+ehA2/2nuYNkLE79LSDNLzuFpfS08Qv9/jQeHY0LT3fFL1X1lJHh9BMgV0JD
	FADvh64Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5ouK-00000001LCi-2Ua2;
	Sun, 13 Sep 2026 15:26:28 -0300
Message-ID: <fd0f07c2f7ad139211dd364f54df915c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Namjae Jeon
 <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix rlist race and missing initialization
In-Reply-To: <20260912165503.521597-1-pc@manguebit.org>
References: <20260912165503.521597-1-pc@manguebit.org>
Date: Sun, 13 Sep 2026 15:26:28 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> TCP_Server_Info.rlist is allocated via kzalloc which zeros both ->next
> and ->prev to NULL instead of pointing to itself, making list_empty()
> always return false and list_add() dereference a NULL ->prev pointer.
>
> Also, cifs_signal_cifsd_for_reconnect() can be called concurrently
> from multiple cifsd threads, allowing the same server's rlist node to
> be added twice into the local list, corrupting it.
> ...

Applied.

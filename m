Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D97615AAA7
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 22:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712095378; cv=pass; b=jWOrVWpNCxJB2hdZ97FYGGo3/C8Z5gA5HPUD9hO+OjLWXAdM1YcTFFrzdbWvpDQECS2OMfd2bOB8jfYZUjfPUVu1xt000jX0YXtAEkdx3CsibBcVk7U8yrBtoAj5qX1kSCuTrG2h0VJRczn9UDDUaVb9jU7PPJVtQOxqyOPq6Xw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712095378; c=relaxed/simple;
	bh=Ee+0BabI4B+y/axWkfojRsW4oPKrS+5RxuvFXHniJtw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ipHUKkOPlBYlOL+zpPjQFmYP3FhvlGXVxPCjGet4Q/PcHNDulYGY7EgTveKyx5VYbaWulhG0mM7JD8PMqjfSuc3bxijwOkMjlnl0F2gAlKFprodFy95l0pv0CuRODYYKALHz27jx1yPbIaYN+zsBRuUc4onkFFwlUiEkU45+hjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=riJNG9Hn; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="riJNG9Hn"
Message-ID: <c5240855dd942f3c4b56b2932e59eefb@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712095374;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bb6SVeaeX6dc5nTVNzBkqDQAlmqhIu7E9HnZMLKhev4=;
	b=riJNG9HnTHH55WawYaW2SeMCh1bI2jIu3wnUZXRAyT+BjzUqJ2ckNb49jbqrRamB3AxOm7
	rbsUWvtwfkfoomPr07Qcid39e57wArsryKvsnYLA3UNid9gy8h1ayge46U8prr8pCNHmpF
	0Cd76lEJhZBgfSw3Y4+0/VArDokiM9aBVxWjo5B02keTzSgk4uPN7kiG0h84IfmFBXYujK
	S5WbjB0r257cUGhdVrnqCi47sP90JB01DmjxYmOkTC7sk8D519TpiHSKTDNFRGz3BJZutH
	Wpj5bSVC5xl+8PfijrHmtcrK5SqYkHFGMmwNQSVTfPbX8IX/sg8heTPAkmV6Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712095374; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bb6SVeaeX6dc5nTVNzBkqDQAlmqhIu7E9HnZMLKhev4=;
	b=ej/zmixAaYaW6b9/SCNIAllf3AtpxFAlCaPDDW/MW6VaLXLnQgUUuY9ewtVgmtUX/TJv8K
	hUV3M5aupCbax34mw0ByFTYS4U3Q1+9MMJdLnPNE0MwuJGkrHHN6aPv9ta6kCe8TJNSqqd
	yIvMFbYu0Q36nR/TdGZZa1n5UBNLyIOTVgCTwit4VYlsij2p/LExj+xgh7MWbpBmrldO+l
	foNiq8ExScugqZnsleRwyMu6hMuuaWzXwuZYtCPRCstUWudhYruLqPIVykjm5D8q+SsZCu
	PoiDwYHncrjSbEjCmexzNEBZCmZvG4CedOc74qKlCMAYX8Ugci3uIhXzP0BLZg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712095374; a=rsa-sha256;
	cv=none;
	b=d6gsycpMVOERI0ASMWCNNWs1qfiI4F+lXJXVJNrlIqHTCZyQCGMe/j0C3y79XsrsSzVHEs
	4aB43INWBkIr0rxxJVC5PPLff3T7YCf5BG0LmzEJw0HGaIicHX2CFN4CRkQcJaxKQCW7DH
	eX3wxqvcN6Ez/iWgUbNeMl4otI340JXm03AmVS0LJ091ZSkNb93hT1P5PFu0KhxJ/tWgnl
	zPUycmeih0hVKo+X4aM6zorOXYnOYpgJ58ZL8Xz10BSLSaXajyHoN+nELN61c7Z4Z6gnWw
	66mNLq4SfiT8C9BJUiCo2p3q2traAyhFi79JSJKv1n+jUDO5ssVmn5zbcwwaqg==
From: Paulo Alcantara <pc@manguebit.com>
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 09/12] smb: client: fix potential UAF in
 smb2_get_sign_key()
In-Reply-To: <20240402193404.236159-9-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
 <20240402193404.236159-9-pc@manguebit.com>
Date: Tue, 02 Apr 2024 19:02:51 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.com> writes:

> Skip sessions that are being teared down (status == SES_EXITING) to
> avoid UAF.
>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/smb2transport.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Please ignore this one as we still need the signing key for session
logoff in __cifs_put_smb_ses().

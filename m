Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3322011720
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 15:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716478585; cv=pass; b=kqfiLADQqsFYfowzFuqMAnwRHVg27bQ4f0IvuKs6TF4XmOsDdj8+Xvg1lkmXvO0kg7yypCh1g5glhAaqLByfZJ2aASEgL3CpD1JYTWelbQ3lY0Puv83Tnqa9mTZIAI4VVaH7WL9J3ncFJ9lL3LoI+10B9TO8KWKeTbsFmnqmeEk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716478585; c=relaxed/simple;
	bh=Q2TBWptQsyiKZ3C0WFQ7T1Clk2B6/krBvSLH+e91bfc=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=CVGfIwk1db7tcLfPlZI1NaO/cwxH7Eqk4Kf7qkLGBzEzWe1a2ixzOpr6gs75b5fPxfNgaDhE6xmsc6pb8YWW58hmbXIRFgLnkulIgsaeiKOZkjvSzQdzu2lfj+2rsgfw/nyHOHnnA3e6gRRCOSfzzmhg713yQJ/U5XSxBECw/q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=C9PeZmkQ; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="C9PeZmkQ"
Message-ID: <af49124840aa5960107772673f807f88@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1716478118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/r9WDuhyTrYiRJw0w6NNYoWzVyOcM/0aQtOPTYXoD7Y=;
	b=C9PeZmkQ9vvunhij5km1Uzb1b1eWUAV9c/hD9hu8J1Oawd5yw1uBO/8Tv8hO0uYDaYnfvL
	aQgvi+kT3EAk5Nyyf8stnssCFrRx3Cppamye73RTuU92ITUjogI0KXcgHIU7Hu0Cs7iPS/
	2uBuvuz/vz6/2IJK3s69X/sLCZRJQpYpeBwZLr4mdyIn42DRhaEtQVu6jNliT8pYcFqCYk
	hjumdW5d4GokOrL4AQrmlSRDjPBl1KN5PHo1PkDxwofC1ZBfc1gvmxJ0pcJ6AptbLcAle4
	FWOsJt73tcFVGVTugv5ZfnjmGRVGUlaHfGV/jLROKkSuw2hAJwmbYyR9AQkvcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1716478118; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/r9WDuhyTrYiRJw0w6NNYoWzVyOcM/0aQtOPTYXoD7Y=;
	b=fN5w9V3DGsfzgbh2fu2yk9qTJq5U6N8LM7uFd2JUKVJs1mvVVLskWyW2dZ7wDzHlGV+Yqf
	/rjKE+W1G5IPYWHgSzgLbwOx9Zuhm0WUBlbgoO78UtLDB0E+OIjpupgaQ4a9J688GN/lRn
	uX7zcZk4ldcgbxhHqugwPz2eLQ+Nw7dTvfXgBI4EoF9Dn59NV5kWEr5Mlyqdt9zpINooCU
	yNxe4VO3r3ksArHMnBKPkJ4M+8WHICoypHA3T7HZnC4XSyVl4lLqwpTufFWWlM8SVtkYwa
	5CtO0MdP7jp4talzRdgqZMVbn9gcplNyfFI2P5BVhW4Bz+J2lHi2sTZjxDNyww==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1716478118; a=rsa-sha256;
	cv=none;
	b=GW2bf/utuNZP2KnPCVg9yQfjSxYf5JCIdSSvNCRg1zCockNL5LERnxMOAkado7ZnA8WN8L
	WHcb9fT3IkUHWjF2fvSopOaBsPY396F0DTuMq2i69E8u0f2W3JQW0vDRd/HWBFgObFeQO0
	JkAiqhbk4E1UcYKLFCqlG+x47Xzuv803DdUUlyj4GzL/GFgn0WRn5pZ1yf7CjoAyHN4Hgm
	ukTU3Iz/Ec59iCtCmEl8uX5YGWq97zyFeb51ocBSwsirGLjZ6b+qH55IKByJ8Ps0s4hS7t
	gimMTHitn1/k0q/L9u3578gy9LgIie5J/AvwzMbpHhffqcVoRh5d7ZEGFPcSSw==
From: Paulo Alcantara <pc@manguebit.com>
To: Tom Talpey <tom@talpey.com>, David Howells <dhowells@redhat.com>, ronnie
 sahlberg <ronniesahlberg@gmail.com>
Cc: David Disseldorp <ddiss@samba.org>, David Howells via samba-technical
 <samba-technical@lists.samba.org>, Steve French <sfrench@samba.org>,
 Jeremy Allison <jra@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
In-Reply-To: <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
References: <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com>
 <20240522185305.69e04dab@echidna>
 <349671.1716335639@warthog.procyon.org.uk>
 <370800.1716374185@warthog.procyon.org.uk>
 <20240523145420.5bf49110@echidna>
 <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
 <476489.1716445261@warthog.procyon.org.uk>
 <477167.1716446208@warthog.procyon.org.uk>
 <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com>
Date: Thu, 23 May 2024 12:28:35 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Tom Talpey <tom@talpey.com> writes:

> Yeah, I think this is a Samba server issue. Ronnie is right that it
> should return a partial response and a STATUS_BUFFER_OVERFLOW error
> indicating that it's partial. It's not supposed to return
> STATUS_BUFFER_TOO_SMALL unless the entire buffer is less than one
> entry.
>
> MS-FSA section 2.5.10.22
>
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fsa/385dec98-90fe-477f-9789-20a47a7b8467

Yes.  I've just tested it against Windows Server 2022 and it correctly
returns STATUS_BUFFER_OVERFLOW.

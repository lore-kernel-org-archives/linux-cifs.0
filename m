Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793110438;
	b=dr45zXy9feAeRYpeZ1NdnvixwKI1NFOvikSEP/VHpDlbBCBfm+o5uJ3Iogg1S2B1zcGo
	 Q0PMww7CEZwmEBQB4KKRQdt1abEAlidW+qp/Q/kd5Gsh4Zi7i1VthhdtpIXH/0Q1D1eX0
	 y28LDuzX1Jg5dgXWEhjTbS00/K7APxIhomUimIc1PbHCCxWd5PlgwQgPdr+qPUXvJx7n5
	 upOmWYqMbIHgLBANdkEhvyNFibmQA9/8Wg2PMtHFJbZqUlyEbOIUo0qb5BnAwXJIoi+3U
	 igLvCpFEsonEmXd4Wzv3nnnJyBJ+ch5iks4oftAj8AaokCIFmewClek+jis8EGuKULw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793110438;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=okUsW9Hc+c86czM7kU6xb8YrYGBzKDebW7nIsifDtLw=;
	b=VFMbgnQqgQHrYYbsHyQ37giuwJS4q3Ms0qYemJJf/MJT9mCvtIO89OiYIyAaKu4uB3qB
	 dG+Ov6EJAga3dBWwBJ66uNqRdJK6dI+1fF1/Or9eJTsvc3SBbL09Bw/WDZ2BnaeQGTGRu
	 oOhTy/7smohPbx9+yLGeQ4vBFHwF57wDtFQD24eVZezZRxsCqHzAaPRlMPLYQ4spggvfX
	 hD81JLK+o86J3HEPTXzGxTEQnxW5xoiEEf47c5XZ2ApaTAwU4BQeOXR3Qb75SgRJfdk3B
	 hGdt9taL6mcLFjF/hBTBbCTGwcUXuNup72nMjVZ5neJMh4ol0vOz8rYvVjSyUT92rsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=aNs+gWNl;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16015606A32F
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 14:13:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16015606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=aNs+gWNl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=okUsW9Hc+c86czM7kU6xb8YrYGBzKDebW7nIsifDtLw=; b=aNs+gWNl8ZZeC8WngKAS2v4e7z
	AAC2J3cESGFjA1LKqTjPHgk2oZxSAS8N9Y1fcDz7AJeLVKaei3emFpUBf/c9DdBrZVGdnI7J0TKZG
	uh2C+OzSRJ3yl4awEsL9wOb6Q6t6+oIdVotjicEZAtHTk5BQjU9O0BQW6zVRTv0UfonaaMi6aopp+
	ICah3xk6/jSqxQSBDP5oNTmIYiTJKnCap7+pL6872X28x5wJ5thq1mUCFlwTNb89+6bLVfq5e/UCH
	wWfsDvGgYAunYh8D4tCECaqLmq0WIW8/WXU8fVdywJx/Ws5PV1/uKwpHtXw5AQjHUeg4J9XAC4RSq
	AHpLjCOQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xLhw0-000000009NZ-3LAl;
	Tue, 27 Oct 2026 11:13:53 -0300
Message-ID: <405ae6b2f23f0514d3a7f9dbc778a9ea@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH v2] smb: client: validate SMB1 EA list bounds before
 parsing
In-Reply-To: <DB5PR08MB100624D4B388FF7946505BFDEFD632@DB5PR08MB10062.eurprd08.prod.outlook.com>
References: <DB5PR08MB100624D4B388FF7946505BFDEFD632@DB5PR08MB10062.eurprd08.prod.outlook.com>
Date: Tue, 27 Oct 2026 11:13:53 -0300
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

Ratnaker Gautam <ratnaker.gautam@kuleuven.be> writes:

> CIFSSMBQAllEAs() checks the server-provided EA list length by adding it
> to the response pointer. On 32-bit systems, a positive length can wrap
> the pointer and pass the comparison. The parser then walks outside the
> received response while reading the next FEA header.
>
> A response with a list length of 0x40000000 reproduces this as a native
> i386 page fault and kernel panic from listxattr() against an SMB1
> server.
>
> Check that the EA list starts within the SMB byte area before reading
> its header. Keep its length unsigned and compare it with the bytes left
> in the response without pointer addition.
> ...

Applied.

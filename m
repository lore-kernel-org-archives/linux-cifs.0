Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADA2155A5D
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 01:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772500425; cv=none; b=lQfKM2SIjNA5tPHdxciytzIMW3MNHpe3ygUEKSRvAtgHLpmWVbh9bN58HNzK2wxg5PskvYkErlWI1fw5Ax6maLds655YfkHC/WnFF2IU9HooRCKmQtu9Rzumt3NbhC1e3j77ezPAClCzEmxF4d+K9Pf0deCbgC4NfdD9uLx291Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772500425; c=relaxed/simple;
	bh=eRponmqcTvk1MGtgbfb4VS1gslhDfa4P2NIOYsSKO0Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lmnoic7URYoHOkNvqbyyV1uliQ5w9Zp2ZgYnd5q4nKySNoOldQZUvbq/fNJePIVmU6kKZn3VAHteHdu70QG/c8sKpK14jGZ9C7oEQ283GFNviRt+xmK7OnRw0oPnacUceO4AwrndDWK9psZkQuZMB6FtoFQbf5XKO8foth8Uv5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RzCaoouY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RzCaoouY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:To:Date:Message-ID:CC;
	bh=Eb0p1zOkqOidz3QdTp2NQBBfylwIix7q+fbjDxrK6xQ=; b=RzCaoouYU7yRYTqzi6ZdgnU8Rw
	cE/vN1bbMKVWWyowG1V470xJlizlqIB+YADcm3B+iPjQq8yQDl/qHPFV7QJcxXvEDVc9vQF+1CH8I
	Aip1bklXn4/2DouHKrNVhCiPyckqYsovJeNEI9kZH7Hsx2Y2+hlc4bEHEVkQ4Nag53YFBhifCn1qD
	xc58vGm76U9SjTHGijzcV8lXGzQjqC1YS4Hk5Ih7EV1qTIAcGQl80mRMAOtgSq5TyXNCyo6F10DMO
	sMYGNC4BZs7eQBlkUil9kAZzaANVH5g4q69cVtbpKSybGbvb+7GmYdKu4sIF8KCE6INCnSWRgMYhI
	agvwBdOrX/TOQs+NudgExyo3r2xOaQqwQwRhqfm6v+zzRuhL9ANhQnfiMzhdXep4yAlufdSJKs8Ou
	KEAOrT5oGBr0C2x4uQRvv0bDsF/BQKp5VlzHih8EfdlvWeXLcnBa8x8qw7na4A2+wazzs+IDXkgkx
	MgMHOXo1eAJgx6P842wHZmXA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vxEKT-00000009ghv-2Ieg;
	Tue, 03 Mar 2026 01:13:41 +0000
Message-ID: <901186d6-ade6-4949-9a1e-773c082cc5cf@samba.org>
Date: Mon, 2 Mar 2026 17:13:22 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: samba@lists.samba.org, linux-cifs@vger.kernel.org
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org>
 <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
 <4d0f156024f06daf3e0c3794c3fed854@manguebit.org>
 <dbb8e4be-6e90-4ab7-a2d3-52daad3fff2d@ed.ac.uk>
 <b35e6347503b65febbd0cbec69e52ab1@manguebit.org>
 <CAH2r5mt_9GcPqg+v9QLXEroKJ9RQZ1MwtpPgprU+xHOSksiWqw@mail.gmail.com>
 <0e9ebf38-6aa6-4498-a2cc-726b9c84aa4f@ed.ac.uk>
 <1ee7cccb5fc35163cd8d0ed7777b37c0@manguebit.org>
 <DB7PR05MB57711EF45DD1CFC24471B84BB17EA@DB7PR05MB5771.eurprd05.prod.outlook.com>
 <63195a70-5978-4389-8016-6f2591d262d6@math.lsu.edu>
Content-Language: en-US
From: Jeremy Allison <jra@samba.org>
Autocrypt: addr=jra@samba.org; keydata=
 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
In-Reply-To: <63195a70-5978-4389-8016-6f2591d262d6@math.lsu.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/2/26 4:41 PM, Nikkos Svoboda via samba wrote:
> 
>    Jumping in here briefly, I believe the "default" symlink style 
> requested by the client mount options is now "symlink=native", which 
> creates the 0-sized files with extended attributes on the server.
> 
>    I'd also like to know:  Is it intended to allow creation of "actual" 
> symlinks on a supported server filesystem via unix 3.1.1 Extensions? The 
> mount option "symlink=unix" (which creates "actual" symlinks on the 
> server), when used with SMB 3.1.1 unix extensions, causes symlink 
> creation to fail on the client with "Operation not supported" (client 
> kernel 6.17, ubuntu 24.04). That mount option appears to be referred to 
> as "SMB1 unix create symlink command" which I presume means it is 
> limited to the SMB1 unix extensions.
> 
>    The archived e-mail conversation chain here (though it includes some 
> outdated information) helped me to understand some of what the symlink= 
> and reparse= mount options were intended for:
> https://lwn.net/ml/all/20241007183650.aw3skuztljpgk2bs@pali/

The goal (at least when I was involved with this effort) was to
explicitly *ban* SMB3 UNIX extensions ever from creating server-side
symlinks.

Such activities are inherently unsafe and a source of many, many
CVE's.


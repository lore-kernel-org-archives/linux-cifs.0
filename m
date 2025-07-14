Received: from mail.pre-sense.de (mail.pre-sense.de [213.238.39.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B7B24888F
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.238.39.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752497043; cv=none; b=aumd1f7rl26dBP6qRNgwrZprlLXoBjSAquj9k9zYeDL4A2nwulBmWkN2bwawqyyYxXMl6dhv+wrySEW7qLg6ZVHgsoJP7cQAdXtCM6edmvi3zfrvKseOcGJcYhkQrIn7/zKExNxSP1yW0XDly1Hhh6nkwI72UMfutOIFbT2WOYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752497043; c=relaxed/simple;
	bh=g4vWKShiSgAOLA8lqa6hYzoIOp7K+2/F57yTZ1emxtw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=aWBRe5gVhYeng90pwaGLo/Dxp5OWxsVEhhNIez5UxNok8EQaNc5G05KUhbX4iXcUgvgJLH8sG6nmjMk0ZoGy404if6plGoA4NJZUHdly9rwL6qywGlLLA4VD58pGduF4QQ3JvU9Gr7ewcsg57BRyIq9tqEvTFnl4ZRDzfReM4EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pre-sense.de; spf=pass smtp.mailfrom=pre-sense.de; dkim=pass (3072-bit key) header.d=pre-sense.de header.i=@pre-sense.de header.b=EIWXpylE; arc=none smtp.client-ip=213.238.39.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pre-sense.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pre-sense.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=pre-sense.de header.i=@pre-sense.de header.b="EIWXpylE"
Received: from smtp.pre-sense.de (tetris_b.pre-sense.de [10.9.0.76])
	by mail.pre-sense.de (Postfix) with ESMTP id 91E2C5E03A
	for <linux-cifs@vger.kernel.org>; Mon, 14 Jul 2025 14:43:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=pre-sense.de;
	s=202407; t=1752497037;
	bh=g4vWKShiSgAOLA8lqa6hYzoIOp7K+2/F57yTZ1emxtw=;
	h=Date:From:Subject:To;
	b=EIWXpylEtDucH/PoO1NsSUb9mp9EnB+IWCLnH7stocat+yxEac/2ayhnVmz+8930z
	 8/HXWG3UefbemTfsVh/6vzdLYqgjiiJKCjdFQ6souwYpN1+73NChorfQPTB8bqGmfs
	 GMR6MEX+24G58UNzw63/eeWWkzzB40tcltnUtWTJIEyThoWW5HLOnwSk1oERfoztGt
	 mN6mp/j63WvChmqeYrt3gNDXPIw1DI4uq6mfJo3b0f7HCBFmvDF/MAkIKZZldmi0zW
	 OijeDX+C0OGvcJFnrgbhfXxOopindIw75vrmzH0eg63nklyE/xfsrW1fXutiBwdk0H
	 Dyj/NMslMHhvj5dBophAD3eCfHbwEyu97iwQREgh7cW7h85oXLZyz3Uiw83/erz4BD
	 P6Ig9uCHltCXB19boplb3gSTeu31yd5lgYe74+1tEK/+oYyi9GfdaorP5ERKoZwCIR
	 CmSZwup7J96R5FJXg+WFwF6d+n/xZd2IGjAvnAg7muzYO1Atden
Message-ID: <a97b22e8-144e-45ed-8850-c3fd18769a6c@pre-sense.de>
Date: Mon, 14 Jul 2025 14:43:57 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: =?UTF-8?Q?Till_D=C3=B6rges?= <doerges@pre-sense.de>
Subject: Using UPN with mount.cifs?
To: linux-cifs <linux-cifs@vger.kernel.org>
Content-Language: de-DE, en-US
Autocrypt: addr=doerges@pre-sense.de; keydata=
 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
Organization: PRESENSE Technologies GmbH
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello everyone,


I'm wondering whether it is possible to use User Principal Names (UPN) instead of 
accountnames + workgroup/domain, when mounting a share with mount.cifs?


The man page for mount.cifs does not mention UPN. A quick grep through the latest 
sources (cifs-utils-7.4) doesn't mention UPN either.

Searching the ML in particular and the web in general came up emtpy, too.


So, is there a way to do it?


Thanks and regards -- Till

-- 
Dipl.-Inform. Till Dörges                  doerges@pre-sense.de

                                         www.pre-sense.de/fcknzs

PRESENSE Technologies GmbH             Nagelsweg 41, D-20097 HH
Geschäftsführer/Managing Director        AG Hamburg, HRB 107844
Till Dörges                              USt-IdNr.: DE263765024

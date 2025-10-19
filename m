Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82B11482E8;
	Sun, 19 Oct 2025 12:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760877154; cv=none; b=VvAE2u9V4pUGQbQ9QW5+EmpG/GiprBlRRTfF/NyQn1O53W7LUBt23wN+76lIT6ONmmIkgZnLt2Gl9UdxMOIgRJlMTkg+M+uxL+fyA+hbqwPb0xWI2WP33BtdtS7MZC9sq2qWUIa7H0hJn9E2ONqrxSRLwPj8CHdcvrebpFdgVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760877154; c=relaxed/simple;
	bh=g4836HmfxmgqT8WR4IzJZiMcJtQs19xCQ7X9fx5WyrY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=c8wFUD0W2s7ZvLX6FguM8SBY9nIFhYhCfxa5BFAu8yQERhHo8I/lv22AxYwFkV+Hir5zK5fdcR8K2jqnzl3bd7bBayYEp4G84Iovye3Z6yA8+P8QYliX/b11lDEiExF+yc6BCG444Zt5u1TP38McTI++9akODiH/U7WdSytio2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=u479YZ5U; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="u479YZ5U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760877149; x=1761481949; i=markus.elfring@web.de;
	bh=g4836HmfxmgqT8WR4IzJZiMcJtQs19xCQ7X9fx5WyrY=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=u479YZ5UmJtdfc06sw7cN/4G9EdJrJ+ivqBLOOJeu7ujJe3OfqbA6iNTWKYssonA
	 LiXZkmsOvgDj6/J1xMT5onZ305NpDFA7ia2uuKru9Z2BGdMQqHHIVoC29xply0/Jy
	 CdID5NWYpJdisWL6E61H69JZu7mVbvehNquN+iKI89oQVWdpL5W7P1CBe31v/gied
	 NqYiu3zoO4BrCvUQK2ok8cfMZV5JVmo//a3LRTEU1OyJFgTmZjvtQR5NVmmhDwGP4
	 yBZg952jBDMm03DMR6tpvB8zcHaC5zcLuYDUjZHDaDOHVnrtNUyNNibGra/psnAlN
	 vniF1BzAtHPL9AtXRg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.180]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N01ds-1uEUbj2L2M-01860j; Sun, 19
 Oct 2025 14:32:29 +0200
Message-ID: <41eb9050-1886-4d02-9176-0e7f55c7ab1c@web.de>
Date: Sun, 19 Oct 2025 14:32:26 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 1/6] smb/server: fix return value of smb2_read()
To: ChenXiaoSong <chenxiaosong@kylinos.cn>, linux-cifs@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>,
 LKML <linux-kernel@vger.kernel.org>
References: <20251017104613.3094031-2-chenxiaosong.chenxiaosong@linux.dev>
 <d3950582-2e2b-43b9-a86f-8e1d1b48ac30@web.de>
 <CAH2r5mt4X4+k89t9CSqxuF55jooOt=X-BMB9AGR+e9WNEh6Y0g@mail.gmail.com>
 <cc22c66e-9ecb-4aa4-9b38-bd148820269c@web.de>
 <CAH2r5mtiAy7h__rFd9mP-jutx38C9JSpPOPhn9ngqsezeX4_4g@mail.gmail.com>
 <8d9ab96f-b7cf-4ebb-9a1b-4b0f2b94461f@web.de>
 <CAH2r5mvx5+zQwhFRz-_dMmxYDX4PDzY5X9WGEd0M1Xf73bRyLA@mail.gmail.com>
 <3d3fe6c0-b05e-4e36-8b02-0fc16438c781@linux.dev>
 <03707213-395c-4b3f-bf6d-3aca392a8ec1@linux.dev>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <03707213-395c-4b3f-bf6d-3aca392a8ec1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Maun/hYfVxd2RoqfvQYkV43oWLLvmCZnjvaxhW4HB55PikR3frU
 IprM0mYLHNiQe21xiI/hmxUvCdo6wd/8HihR9CZ9z7M35/MEkZlp8FRIgspiztS1B9DcmUh
 Ph6M1XYkiR7n97PxAT5UQ8ZgbCJ11A55loIVBtG2AsRIjLX1r5Gd+GMwT2GAMz9VOxmGrTn
 ZsNHYTPkUJ0mdQn4dzkUg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/Tup/o67f2s=;fft4x1Yi5bbnkYHAlM343dyk5hF
 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
 lqWbFnREZprq6Q==

> The "Fixes:" tags of the first five patches in this patchset are the sam=
e:
>=20
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")

Can such a technical detail indicate a need for the recombination
of proposed update steps?

Regards,
Markus

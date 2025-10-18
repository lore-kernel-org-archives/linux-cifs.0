Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC6A25228D;
	Sat, 18 Oct 2025 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760812030; cv=none; b=ExdmJvn0obbNhuGczv7a0sMNVkF6zRBnZVytTXg0T0MhVcZJjM+/1OIowHOSkWyscU8BmgvHCZLZza0+Qr9puaEC+Dt5g35s94hB9ALPOM1bGTDqAvIk1lHEUO7invUZ3Ws4xSEKGnC8JPLBXqytU3lZR+DDYxstRxg9elT8G3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760812030; c=relaxed/simple;
	bh=/Xrb+g2lLP/GAwm4Yz+WC96T1V72JcBdSC9IdI2wKmo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=uVqT83MxDCTUng7WTNSI7843eZ0Bqh1eHaONl3DZCKb2uFhHl1l79dO6NpcNwwdiNCoYcJlxjQMq950KF+eJ2k3CsnfD8CoYPhr97cxW4jMnEAJe3ulbYLtYp2OCOxILLNsBogBaR8o3ypuYfyFHkTUNqtoRlOnv3uj4TgiikZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Aa6G3kRI; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Aa6G3kRI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760812025; x=1761416825; i=markus.elfring@web.de;
	bh=/Xrb+g2lLP/GAwm4Yz+WC96T1V72JcBdSC9IdI2wKmo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Aa6G3kRIQ5k7imWp8zLP24v4XNw81cACL2Bl21GEMIe9PgvsKkyZncNZPfCteSEU
	 4hSksxMeY1K8n6vAXhZWXdxEMcWPickkHeMqAOuuy2OQTzmnTQCLuQa29Pd8OfwEK
	 Ff+m70AuC7CVzaIE+b/JR0rtp6NBRsoDTB0tgCvRqOsPht6U0j51eR61Nx4GomSiV
	 6+iMFcsQhb+xsffzm/+Lakn63oRVru1lqTXQRgm0i4ymXy+yyJlfZQ34CseJV7Fj6
	 vrXTen30XIExPGgcvCu5xWXu1h3ZZ4seGLMOQlQQkHjPbyBrJnKn8u5wSkwYE96Xk
	 Pgzn0G1tRPdorHYBuA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.233]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MpTxo-1uQxqn1uKC-00qEDN; Sat, 18
 Oct 2025 20:27:05 +0200
Message-ID: <d3950582-2e2b-43b9-a86f-8e1d1b48ac30@web.de>
Date: Sat, 18 Oct 2025 20:27:02 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <sfrench@samba.org>, Steve French <smfrench@gmail.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, LKML <linux-kernel@vger.kernel.org>
References: <20251017104613.3094031-2-chenxiaosong.chenxiaosong@linux.dev>
Subject: Re: [PATCH v2 1/6] smb/server: fix return value of smb2_read()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20251017104613.3094031-2-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:8C1ci5ux71GiXrryeRTlhis1mivPqqsjpBzdeWwpptBeVjlHzyj
 NaC7J7crgQrs4e6uaDcvgllJpvVLEK6entfvYNvGTwh2R4HUcXNXFuKkJp44yRxUIHK2NQx
 sYYMkFtFSNwfqf3xq4vegnb1ChvruJuYRoWGyI0OSqiCQoBOWU4wgb1d7GMG8Hf6+QWVGNs
 T+QxmreOQfdwtl8H06jFg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:SP48okk2KzE=;KXW5JbHGoM3kz5UHEG8DB8VbNKh
 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
 ceFsg==

> STATUS_END_OF_FILE maps to the linux error -ENODATA. Perhaps in the future
> we can move client/smb2maperror.c into common/ and then call
> map_smb2_to_linux_error() to get the linux error.

Will another imperative wording approach become more helpful for an improved
change description?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.18-rc1#n94


> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

Can a personal name deviate a bit more from an email identifier
according to the Developer's Certificate of Origin?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.18-rc1#n436

Regards,
Markus

Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E42202F65
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 13:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760360728; cv=none; b=D1hjmmaTT4BN63/BPDxKssJH0ar+xvIhVI6Jtg6uqptce6/hIfR5grm8KZRkqI1nBn0RgTmsHrP6HPN/sLewaYr5Qy6yzp+/W7/CvYJSwyUIFH8gzoI2zwO1wSA2FCBsn8T+5/rH5r42bmfzdQ2+jka+CYS0jKckWBDdIxB7mIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760360728; c=relaxed/simple;
	bh=7m2oV/ozhVetE9TfAosLrhAU86Ea1Fd8PjJVaXUk0Zs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cuzt0ttb4WuXhJ048D9FBEjt52E8YKEuLjZYKp2EZA0ST/YBTFTxb0iEdAHmoEmIBPGjQpkX8rfxBEvizHidd/H/zWXAs8ReRe2tgF41MSmXYJFLI/zOfmy4l8HTAC6r9bKAE3ABYh3vx2Cvrpi1BeEggYhUMb/sgDs4FjOWC+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=gtTll6Uk; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="gtTll6Uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1760360722; x=1760965522; i=markus.elfring@web.de;
	bh=7m2oV/ozhVetE9TfAosLrhAU86Ea1Fd8PjJVaXUk0Zs=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gtTll6UkL88A9VnC77lsqSgaafRjCqqr8nmE18fLQwyEH1cvARfm5Q4yPSPLIh26
	 QWlB/5S22vzifWenTgjtctoGI+qFXfitn+rtsBswcP1eSgfU8b8vSS6Pxw+rX0imU
	 ti78GjsWCxCgi2aMtJvvOLDM0VfDi1Oi18MgFOx1hb+xDJt0YcgmXDHIYgz3lN3VW
	 sRCyRJyRHU1l9bBJxdeqcV7HPVaer0TylN5YXLX5514ziIW/1f0QtbLk89CNvg4dA
	 +R4v5TUKUnsBzeXdned9NZBCTLqfWVgDPA4nz3qY5lzhmrcyJ4UrTAuv7ghburE7g
	 DPpjJ/upMVyw+8JUHQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.69.186]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MTfkf-1uelJ91cej-00OqMS; Mon, 13
 Oct 2025 15:05:22 +0200
Message-ID: <4a37e90c-f008-4094-91db-7e284e974a5b@web.de>
Date: Mon, 13 Oct 2025 15:05:21 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: =?UTF-8?Q?Re=3A_=5Bcocci=5D_Improving_source_code_parsing_for_?=
 =?UTF-8?B?4oCcZnMvc21iL2NsaWVudC9kaXIuY+KAnT8=?=
To: Julia Lawall <julia.lawall@inria.fr>, cocci@inria.fr
Cc: linux-cifs@vger.kernel.org
References: <335b0fe9-313f-4e3d-a01d-1954f3c46489@web.de>
 <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <805f36f6-ea15-cbc9-f510-45856eb6f6d7@inria.fr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Z0/IpucWK8TNE1EGf+djkIskU9+SxV3oYO7loYEXPsS/0yrp43A
 YLSXaP0yCn/4Or/JJxPgidsWSyt2uUTbV8PAX5ePobMvYwPf9qMDbrjnhyUyIUBQjA1hvGf
 LRkfagruBwiUO/yqJphxVMkeyxr3UOECIg4sYaw576PY4qMvomGJmAbmtBFEZu/dywuhqUt
 2DW97scyrFR+17fzx6h9A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:l6Jvkcwx3zQ=;6sP0Q8FrY4Kv0I3RFHo4uVVAjiD
 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
 DqvJPOKSQT8kmDP0zvIslbHZrwOPxgOeJqA=

> If you want the problem to be solved, please make some effort to narrow =
it
> down to a smaller number of lines. =E2=80=A6

Can other data parsing technology help more here?

Why are the following source file parts marked as =E2=80=9Cbad=E2=80=9D so=
 far?

1. Complete implementation of the function =E2=80=9Ccifs_do_create=E2=80=
=9D

2. Comment line between two function implementations

3. Blank lines

4. Closing curly bracket from the function =E2=80=9Ccheck_name=E2=80=9D


Regards,
Markus

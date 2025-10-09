Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B9920330;
	Thu,  9 Oct 2025 05:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759987111; cv=none; b=nV9fNZ0O1PLU1ZSralYtdClJaE7eA+b/QwEpImap6JcYVKtdmvXG7hlBdNwOLYBHPu/XTWlYc6Wif6O1kOngZOsn7YHaFCUsxLbl7se1hOQiWEUg+kwo/+7Uj+kn9zUU18KdrjuiyBq/KzHQTKAV1+zqflHt2BsNsLXmP7CTurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759987111; c=relaxed/simple;
	bh=kYqCIQV33Ty9A5jvaxvSullPFtVpWx4KRxQoFomNZLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7Fit9y1pToDPy+FZjE7q2pFIF5nllLC3HS4qX3qOgaKbseNzGHuyYtnHRiFQkY9M0SiAYSBQjNZ0J+Mm2lLqCNPr2bOWx3NcEcNBi5nZlDcWmN+4UXZPMmz7pGgxte4sNabrha1EpAZtyG2BkzFBP0RiMKvcnWQ+9aQhcVVlRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Xdh9KDyd; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Xdh9KDyd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759987073; x=1760591873; i=markus.elfring@web.de;
	bh=kYqCIQV33Ty9A5jvaxvSullPFtVpWx4KRxQoFomNZLM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Xdh9KDydFS4lBw1B1g0L51K61rDahpE9CtTBZKGTrvIqpDdklZeYwwNVxFmMbX08
	 sGPJ80BV7oE//H3+78PrP9b7DxAzvdwO9olR6UbwghsxOz1RLBN40BEjh/NAqXyN2
	 expMPqYS7YwQpBVQSmp540lXOfLFwd3bQ5Fq/PA5aYkbFf/5bpbqQ72IpD7tNOU+P
	 ugSLMp+iGk5JbR9UtsQM9L4GVBsxF+c/megPDNy075az0Q52UcUKOt4Ix2FJC06SD
	 zxr3n6S3FVEhQLHblKPp/MsAX+qDa7wQs1Ag1ZVK8YfEcO5Mx2B13O8rwHGDG0ijT
	 Y4Od0n+PAVm1T7uFvw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.255]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MgRQJ-1ucMVK0z6t-00hfX6; Thu, 09
 Oct 2025 07:17:53 +0200
Message-ID: <bc8f02de-0cd5-475d-bb19-e44e202f7a58@web.de>
Date: Thu, 9 Oct 2025 07:17:40 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: smb: client: Simplify a return statement in
 get_smb2_acl_by_path()
To: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org,
 samba-technical <samba-technical@lists.samba.org>,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>
Cc: Steve French <sfrench@samba.org>, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org
References: <5b95806a-e72e-4d05-9db8-104be645e6e5@web.de>
 <CAH2r5mtpoLscs9sodXcRMO3-dqMDBSTR+ncExdqy4dQR=4uE8A@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAH2r5mtpoLscs9sodXcRMO3-dqMDBSTR+ncExdqy4dQR=4uE8A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:aK6u5vY3rfsU/U3U6mny2nsDgSwSi98VQpQWc40Km2mADSr2n8A
 V2IetDSFNiAsFxmU4yw16p48+bdwpLkV1ZTFWsD2uO3CF5fovg3vAUzKHpx3CAUONoWvorD
 7n8xZAxM6ylWZeVICTMstyyXWpS2sO44kEq3gteInwqMm4DBLqPHKUWt2p5cVDFgbHut/Bx
 WC6Z2dsweXpwvaTRjXtwQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hUW4gf7FZ+s=;yyoLG+GLsIVyA067XSKuoec055/
 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

> This is an example of one that is probably slightly worth it,

Thanks for such a positive indication.


> it shrinks one line of code, and also doesn't have risk,

Similar source code refinements might become also interesting and helpful.


> but at least three of the others today don't shrink and sometimes grow lines of code (and don't fix anything )

Further update candidates can be found and eventually transformed also with the help
of the semantic patch language (Coccinelle software).


> so are unlikely to be worth it since they slightly increase risk of adding difficulty to stable backports of future fixes

I hope that such change resistance can be reconsidered.

Regards,
Markus

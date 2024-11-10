Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF8214600D;
	Sun, 10 Nov 2024 19:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731268298; cv=none; b=kbq2UaygbPZUJW4h6JVBd8o9T0Tba0caA53RW4vrZdRz3jKGbTTgZ8FvI3aar3w7zuoR72UnOnvR6a68IfI0lf/Y/bbo3rvR/aU4+xS1+Z4cOmxNkjvkpCo2JYB0EMWqnj2ncEkw6C4gTBT/hn5XlAH9NxMGCIhW8VzeaQXhzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731268298; c=relaxed/simple;
	bh=Zk0yKqcLszl7HOiRtJf2Uqi9dlPLtZbTnCSwnm+RNTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YcNS4qOdigSNyq/5FQFVExtp+D+RNiXpUrLUHQzPA0oHbiy2AzudFfWtiQDH4+4eHncc0tn2ExKRDOQeNjM0iLQygnifvsfPbO7vRmcK7hoVJNzHqpz5nHYYLBvgeTOJBvKXf4JA6gM3UiY4Na/8t3kQscBwpjm8UP853wc4PSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oyu4m7oo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oyu4m7oo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=Zk0yKqcLszl7HOiRtJf2Uqi9dlPLtZbTnCSwnm+RNTA=; b=oyu4m7oot7hp9g5+0K8XfsvYJG
	Mu2mPkAyppiOYMcBrGPyJpW5PxkUabyU2RjdSPIpY3mJesc1SRkvjnNZ/e4F799qCmbxPCIfEY9MW
	c2Ma+LFfw2XSmGnFFpRhq9UPKjE0tjXSF7YTgH+/Dq+xqt5VOiHrrBOs6QRSWXTWR4J3zx7UginR9
	aF47HSuT1MioD7yM9utejYlgxbnDuHSHe2zVPRdkPEWD9RKEehdCwPUUcGbnPmdMnfXBw5Tc2rSgl
	3xJ9xqZy/3TdrLj5VlugojKxEZWp2c8oh+FeeLhyQxhvh5X8H52MNVaHBkGn3WqNRb0964XiRGfDh
	DD9iowVmzuyWj4X6n0/SAWr2Tn0eq2SH+VTPE21izs6m4m3fS+ofOU+kGavuY24KhRa6pKhvYrJ8j
	/d6oKUFtx3/nJbprc4ydgkneiVVqhzbEICW8+t6Drkp1cDgu+JKltr88bOGvWKrC89viDGNfqOq/l
	hqeK9jLM/hfTy/p64qAIbA2d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tADy2-009wGa-2j;
	Sun, 10 Nov 2024 19:51:27 +0000
Date: Sun, 10 Nov 2024 11:51:22 -0800
From: Jeremy Allison <jra@samba.org>
To: Steve French <smfrench@gmail.com>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath S M <bharathsm@microsoft.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
Message-ID: <ZzEOuqDwagwoGCMf@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <20241007210214.102568-1-linux@treblig.org>
 <Zy0reBfykkwXA47d@gallifrey>
 <CAH2r5mvL+xXH_nnoKKKnVPFo_xtOb=8mPSqrG28Dgngx6Aab7Q@mail.gmail.com>
 <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5ms1y3XsGmA2kU6Vdvdmg_jnVyd2w7mQPRyX9oh9rFD2tA@mail.gmail.com>

On Fri, Nov 08, 2024 at 10:09:58PM -0600, Steve French wrote:
>As an alternative, might be useful to see if this command still works
>to Samba and/or older Windows (and e.g. enable an ioctl for it - might
>have been useful in the past to old servers)

No, this command has *never* been useful. Please don't enable
it, just remove support.

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793178280;
	b=BzUAL/UQn9kUubaoGoq9O7WCr1lm4FceIxYyxsZCmaIPwoij0sXtgt/+mgVbD2agXoLD
	 /5xYwtH/0l+2WtdwHqvkYSsvxkSc5Hc8jPcwwjPeobqvhLe9KOoET2k1pVm9dnRoOAZFl
	 DHpf+xzwdkl/FjAZKrywv7x/PIccViqs1K6NzLDdMMUA8+Bn2v5vHNh+cIIcFDE2jcanm
	 V8b8PLOQhbnJiLxcPKW70pPD1FujPhV3M5HxpSmZT30UzbNNBsZ6jT62ny1vfwOma+Xnq
	 fq8fxUko2La9fhM196QQ8HsmN1bgY92974+hLd0Ge5LQkQR7iQkTMXw6qQhb4A6VuHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793178280;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=QgxSQlglSulgYW+zjA2RlQDuafTI1/6f0G7Szlj2ZsU=;
	b=Idw5sTsMl76z+xntcx1KLN93/gMv0lt9us/b3vXrLNl18Pvk78MsPCj7MHQhFm/ChY3W
	 W4xPGNREolYtK/Exoy1EQAG8Na6HKyTNwoDhcGaqaLQD7dVxIOz07cTPozVs6mhanHDxF
	 RHV6B8H8IFUH1kJyEx9kwAbnFZ7jOuZ48BXBnsqBJpGnD9Try1HycpbEDzb1b4sp7o2Om
	 +UzJR9mZtVGcSSmmFtrqPeCtq4Y1J1UkoIZBrUkgC5cM9trSMhWHLEZE89f1AE5CFJiwj
	 Fg3OlHRnf1j7HVcuvW5DzTRBvG9FByEQB/3BDHfH2zdE84dsa9hvo/QIXWwKw1HdfiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Lp45J+J0;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0B8606A31A;
	Wed, 28 Oct 2026 09:04:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF0B8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=Lp45J+J0
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=QgxSQlglSulgYW+zjA2RlQDuafTI1/6f0G7Szlj2ZsU=; b=Lp45J+J0cAMXh8imTFkCtBrZ9G
	l1S0j23aYnLzLEre0pahLwny+7ueGZZBJHjIJ48/FTT6pT7AbOASF4pOQjS1Q8MmCVSIGfZz2epHv
	7fLdV72b/9EeZXcEUQVNI0/jqIPCkbdu9jmuBnaVwA4jatIAyGsAJcY4m2ks+bTahRwYF+B3G2iRK
	hVVYIEngnHHBR5vouv4KfIlqYgAr+C5NWB57NMv9cxmANey2gfad2psWdRwRv5iL3DBPlZfnzMPLk
	vg4jYKAiamZmMqXpht4jZcoG4nDWiLSfgPEfD4lQA8HXwsy+SUMTuxwrVtKIUDGuwsXmZQ3TPJrZU
	nBiWKXfTUA7dRugic80pPIEhR6tWSmwF6WDxL23yvWe8uHlU5pNdmZJeR9dM8saRTiTKpkHJFLwoU
	CS57qKEdzU2vV0R00Yb5ZclMdXzmUSgvNjUsEZ5GYQAgD6sMvDiC1h91G03JDzdFPmgxFGgS2+jK5
	gh8+ny5RTU+YtCK+8+A73M5o;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xLza6-000000065tj-0JYg;
	Wed, 28 Oct 2026 09:04:26 +0000
Message-ID: <b69a61a6-47b7-40d3-9235-2c34fa0cfc29@samba.org>
Date: Wed, 28 Oct 2026 10:04:22 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
To: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>,
 Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
References: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
 <2026102733-sinner-baguette-1d07@gregkh>
 <CANTrAmys9yD+KB4Nhkqo5Z1R7vJCbyoXpizDeV6kM5YA4nEMiw@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CANTrAmys9yD+KB4Nhkqo5Z1R7vJCbyoXpizDeV6kM5YA4nEMiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 27.10.26 um 17:47 schrieb 이성현:
> On Tue, Oct 27, 2026 at 11:44PM, Greg KH wrote:
>> Why no tag?  What happened to prevent that?
> 
> For 3) that is on me. When I sent ef85bad39cf2 on 2026-10-15 the
> commit it fixes, 25e414db7033, was only in 7.3-rc, so I assumed there
> was no released kernel to backport to and left the tag off. 7.3 was
> then released with the bug before the fix reached mainline, which is
> why I am asking now.
> 
> For 1) and 2) I am the reporter, not the author, so I cannot say why
> the tags were not added. Namjae and Stefan are on Cc and can answer
> that. I only noticed the gap when I checked which of the fixes had
> reached a stable tree.

Sorry, I thought that a Fixes: tag would be enough to have commits being backported
as needed.

I read Documentation/process/stable-kernel-rules.rst again
and will also add stable in addition.

metze

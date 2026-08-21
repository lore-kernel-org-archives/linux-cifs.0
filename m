Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227CD37C93C
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330729; cv=none; b=RZUh04KlxrntYhPV5TlCpOR69KHcTDdN6PbMuDosDwM4JwlHZ4TpRPIomGseKiX3KvBdIO4K0ch7QskxMfo1jj51UUVSjC7sKQTrX/H9wwI3zL3syiithsUX6Vk0ZuFg6sOfEl0JwhX5ePpJvP3IN5yjBOYhlITlLXFVD1sJILA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330729; c=relaxed/simple;
	bh=q8pzCf1lvSLbAv306mDSyMhPbL8KOuLOlyT1tD3a+Fk=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=rSw1R290w1MghMGtvhh+79pnyjM0Fmgf9bzCNqj/X5XWq0P1S6u8t8Fc+yEw0CfXNmzIRk6xA65mdpbK+J0BoeV3M7liuTsSLloDk/tvDAJhgJXRSdvi0UNoZRCPCFz3wcGFmnPaP0v+IM6TJ+DcaHzLWrgr6BpblmX2kjmZZNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Ow+7XFrE; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Ow+7XFrE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q8pzCf1lvSLbAv306mDSyMhPbL8KOuLOlyT1tD3a+Fk=; b=Ow+7XFrEz45NLW00y9KHBwZPQ2
	6+udjcqvagZHJ0nKeLAQd9HPEDDXvwxAEg2Y+FWtUbqfaKU6LSRUmgQQAzUfgwvQ3WZqpX+BNb2Tl
	gOr7mCeR+I8mHn+WSjMvDWKebsGrXh2/HqMM7poaIOVNsVLbWf6dPOkrLS+zjGCczkIc2VnkdF3jB
	i3Am8TuSRJxl/vPSc6oBMwEK8p/fJM6WdH4mxVATeaO62Gp+01Xr0K3VU4rdtQhq6gf6lm/eC6oPR
	sKO6nEbmDVVDjeLVhk8yyqNX79QVvEZmQkeyqbrppMAlEVoL4KI/h7xQRQI1toKtcQKP7GseCX6My
	ELTXyc7g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wxSMo-00000000PeS-022B;
	Fri, 21 Aug 2026 13:45:18 -0300
Message-ID: <dc434bdc262320af3a9f274bd570304d@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Huiwen He <huiwen.he@linux.dev>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org, lkp@intel.com
Subject: Re: [PATCH] smb/client: remove redundant NULL check before kfree()
In-Reply-To: <20260816153922.484091-1-huiwen.he@linux.dev>
References: <20260816153922.484091-1-huiwen.he@linux.dev>
Date: Fri, 21 Aug 2026 13:45:17 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Huiwen He <huiwen.he@linux.dev> writes:

> From: Huiwen He <hehuiwen@kylinos.cn>
>
> kfree() accepts NULL pointers, so checking tmp_cfile before freeing it
> is unnecessary and triggers a Coccinelle warning.
>
> Remove the redundant check. This does not change runtime behavior.

The same fix [1] was already sent, so I applied it.

[1] https://lore.kernel.org/all/20260703122104.69788-1-mdshahid03@gmail.com/

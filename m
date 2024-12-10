Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DA519DF99
	for <linux-cifs@vger.kernel.org>; Tue, 10 Dec 2024 13:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733836773; cv=none; b=BRsXZ4tm1106FljwP5efUl/FIvlFkcAIk3j754iGlXl62uBBKS0Ne8xg0U9529qLSq00JUxKC9+aIpbcAtQeVnVhlpvthzE3MXVrKBF6EmVsf7WbSSxCg+asJH42O3FL+Oh7S5RAqsL2TY0vYd79YOfsmciATyaBDwc4wb0TGCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733836773; c=relaxed/simple;
	bh=00uuIXSbxE2chD/OpQhguw6mytogPGTzjnNwnmvbUiQ=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Dr4jjuUMWTEytiul20u8Qx08D4KJT1BQyF6OInuXMCW/UfleJObj+nxUzX5NuFBih8s+zxCGs543VLIiPN2QUhIvGV3cmhwKe3RS0XkNQfVU/ffQWjmUocDmbbbAeN7k6VTzx9dkeMjwz4uLckexCsVcojqGRpoaWrIn6oYvd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=d4not0Gp; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="d4not0Gp"
Message-ID: <8d0a687be2cba9cb4d2745c0752d8fbf@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733836769;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9IEPlQMQvlkiLKRfqeiaab83yX8hGfdB1uCPnwcxN28=;
	b=d4not0GpS0fPHkqSLvMk2XFAgqzEehnVEFFOJE5WU1kz2i/X+Dv1m11X7Osnyr9uHoqi6E
	vIo4PpGKb14m6/zhdPdXabktksZ6mgyAXsO/WgOhpKy/mK1EU42xXf8kiScQjDivj3IHeb
	HicC0v02J06b9HAyHzzKg4skh2pEC8L168lWR34FORS3Hzj/XAXdOKWK7I4J/qAE+ykvrZ
	Gs1Pf4csJay8ArDE8mS99cN4ih3k9rEn/teFpx95iC+QqJ/AF2vpoVew266zJ5nhOKX1n2
	7/iPAbJdo7RxSDtTUNfPTyrMFaOSwF3EsoV5exSZJfv2FoNlNaA98GidUIL4Ig==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>
Cc: Ralph Boehme <slow@samba.org>, Steven French
 <Steven.French@microsoft.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
In-Reply-To: <20241209195420.7mnya3ua2y7nl6tp@pali>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <20241209183946.yafga2vixfdx5edu@pali>
 <1098e751d1109d8730254ada7648ae4d@manguebit.com>
 <20241209193445.yrcaa7ciqegvs6fz@pali>
 <829df5e75aba7f0857ff688689b52676@manguebit.com>
 <20241209195420.7mnya3ua2y7nl6tp@pali>
Date: Tue, 10 Dec 2024 10:19:26 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Ok. Would you have a time to prepare a patch? I have still feeling that
> the smb2_compound_op() code and EAs code is rather complicated for me.
> I would like if somebody else could look at it, as I have feeling if I
> try to do it, it can end up with something more broken...

Yeah, it's a bit tricky.  I'll let you know when I have patch so I can
try it against your old servers.

Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793A6481B1
	for <linux-cifs@vger.kernel.org>; Wed, 25 Sep 2024 14:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727274665; cv=pass; b=laupB6sCT04fQk2F60FTpRsO1lHIXano3gPSX8ez+O0QZ+Xqc28HCx7ognu+8tTT7gTnJrCIebUMNO77tli8AySnSQjnvkg7Dn9Wtj0cJhjNLAVbMMQdZDwKyKSHZ+UDolQJcRxd8wQ3SPGF/yDmhxe0npiwM5/4deCZlLDTUW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727274665; c=relaxed/simple;
	bh=jTrsWzMXnmm3pLiZYcDMbw6GuZaGOBDhbM/7J3lpGF8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=avPQt1rgHje3lgGUqgk6usYWElPXaF1S3QFBgj/U4gBfTMshFPsSPPfcvgBYKnUWX5+GLjGCzT5fBkUzHU7NseVz3Y/BSy2Pu5PbmcJPO6+3jJZ/8K55BQ0Z3IawaYagQMsAdiugNclYf9rB53HR6K60nDTnr34loK5qPns4SHk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=MCm433G3; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="MCm433G3"
Message-ID: <be8c5bf4a6241054e5e3c184c473f9bf@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727274655;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QYZCPokb4hEiP9TlbB3hGogmxUxHR1k9w+au4YtmAdk=;
	b=MCm433G3oNOTTc3eiaT2NBVWEhswu58DCej76tu54+LSdmak/Ds9lWbHstGTPFuw8zk4LT
	KpL4WQ2O5+REFzz4d++3Xy3cL6E2g2HxSl4FPMVr6YyyrgkwuYdHTShgx+XQUtRgfS5iRQ
	NZfcHXJDNHgU+j69LJn/Eu4lL70QkvxLQCmwfdA/Z7DnQugAztYPRGD1zhhK2V3XvsCkyQ
	HLP2oB9W3v3kFFMFgGycuIfoVFGVGZapCfOZsmHHpVOZ3od7ptrW1vXl4EwNP79icf9nNX
	Do0E1AdEaFOs6l2otMFVSjnshlfJCYlUSMRSFP5342uLDldi6wrTQSMFt0Ty4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1727274655; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QYZCPokb4hEiP9TlbB3hGogmxUxHR1k9w+au4YtmAdk=;
	b=sEWTbW3JJONsQ/ni9lxaZJNk2nAqw0307n5zAWDY0+R/N+MzW8xJZW7fuc4ar/i0UDCgAs
	kqNS+Tx+59GFXI0ID8BwYGtwZqSLpkJ+w368qC6tbhL0gAzMy9CmbKfKcqt6YGrgnFsxRd
	aEutGSIh0WrkN6CsfeBbmC8zt9MEMy67i1lEO1p+R5mTGVd27MGG13B/TVJ0C3TkGuDxrt
	OJ0NXbQ+cle+/4qK6j/GnxgH1hzk9hK9g0uHLjSoqTREse6gJ3zDezMm3k0vXPu3CObQKP
	mKaEfIsxfKdH6Vm1/ioMICyRzSZMvYbxyYtAQEUlwUTtSoXtIxHTneVfeFvcMg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1727274655; a=rsa-sha256;
	cv=none;
	b=Eml7pXiI8snaaBtRghw6lVIgw1wsd0hwpAJWmuBfa7JYkatRoEzXtHXd5pGgMtIof+6nFj
	IyDMDTE2K9+Zzzstj2ETZ15l0jPXsrRFdYkDXDLcrdlhOqWf39ivUk6nb9ktJjct02eA7c
	VcFKjD/269de/dtNrN22maK+xf4Fx32w8I9JTXKY4Euts8e8Nz7JnsQ4s7Z/NG1+Bwy4HZ
	0UuCfCG7agLP22hMjgnOZ7lyFSl/7BWHOZddE1swGe0kRJFBw8wbm37PlBzKoHedYHqiIz
	3noCwdACw1UH/mk6VCIaT2fHAdPJlgpxnzXk2YVmwhkkzzb0KPWYw1NrxiPBwg==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH 4/9] smb: client: stop flooding dmesg in
 smb2_calc_signature()
In-Reply-To: <CAH2r5mu5GNh1p4ns_B68AnsNN44o01A7LM6r21zK_j=ZfyyL0Q@mail.gmail.com>
References: <20240918051542.64349-1-pc@manguebit.com>
 <20240918051542.64349-4-pc@manguebit.com>
 <CAH2r5mu5GNh1p4ns_B68AnsNN44o01A7LM6r21zK_j=ZfyyL0Q@mail.gmail.com>
Date: Wed, 25 Sep 2024 11:30:52 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> any thoughts on whether this should be at least a log once event? How
> to make it log at least once, but also something that could be turned
> on (doesn't seem like it makes sense to make it an dynamic trace point
> though ... right?)

Yep, having it logged once with "VFS | ONCE" would be fine.  Feel free
to change it.

A dynamic trace point would be great, too.  This could be done in a
separate patch.

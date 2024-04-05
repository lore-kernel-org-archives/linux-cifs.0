Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F88393
	for <linux-cifs@vger.kernel.org>; Fri,  5 Apr 2024 00:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712276661; cv=pass; b=l7LVMEuJfFKI8p7Zu1HvBMV+V8HQXsENJuTLgdVGpedkxCCILELsdH6L6d6Em/Vp+/vzDy/7ME3Byn82hjmmOaLVmizyStsteDlfXPTTJleliMEXkQIH/XLL+wrSQdFuU+okZYfxetgY0zZb24QbScrpQ4K6IvHnma8sVagnSu8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712276661; c=relaxed/simple;
	bh=NEpuIB+CGO4ehiiABfJYEfSUY7DiIk87jD1on6RwU04=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=ub83DmUxml03jxDy3PLkH3g2g3qatQQLuj2G98vfQG/cVY7QbVWu5+vF+VJblTMXKnPgnxV2gkoCZFZ3ov00ECfjHvR4S6vAmfAcqyzq9wozSUCKFx9foJ+00udh8JHEhVFwOXiwKYiiVn4uoHxlp4BMpk1pdL2lIIKXU5eAPz8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=tDihX92C; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="tDihX92C"
Message-ID: <b1680423bce48c6ee54e43f894607ba1@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712276656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K7YiUqv8hSwp9Y2wQywvprR8lJkcMd1wbd/c9fj8C88=;
	b=tDihX92CZy8RFJEJtYr2H5Iif3FbpniuQNGRskiK8Mwibp+VXO4oQ8kEd39Ig6zTASM47U
	9xHNgEtetwMzpnv2+yKxdbVnV3dvcOD9nB78jDir3BGcDcWYdcSdyYylScH3SsUXMjwtP2
	4arl2wCsMAGyv+xeXxDq63uswEg8MKhlidTrgzXBKh1Ae4S1qXFRioVPUbi3fozejAi7A/
	eWKb9bLLpnkaXYFhQqGrRwyVDC6kMxiiik8Rnm2PSeSAsxNcxoXAjEm5OrvpHX2qVVyM3X
	1nFIJVBZIYg4jCTqktrajY7GBpqhqA1AJ+NQQiTf4eTIux+Labv815plkduWug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712276656; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7YiUqv8hSwp9Y2wQywvprR8lJkcMd1wbd/c9fj8C88=;
	b=FzWWU6Grmaps+SQzCFnYbD/RfrQ/7IwKbgl6Xn7een1Vzagl1h6UmJRt8YMvgHgnHSPqh3
	T0GwJylwrXLj9MX+ldwtSeN/RJWGAVj114cz6Ci8IjcVZuRSRZdkP5wxQynoRYDVZVipwd
	Bf4W6ebVqeX48pidCEts8teJouj/NWyopha8+/nsKlUYUDN9XoF+QFNhw8QDGu6Mg8Z7kX
	E4DZ/DwHMNjy+j9gjqEcrCMso3xubfQLKOZDVc3hSKvv94h14Hy6AX620unF2GdXRlOo8g
	aipwcugHwVYvdgweA6GkTW6i24zJqFcyGMuLjqYPfRUMer7Oth3EdMjGrVYtZQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712276656; a=rsa-sha256;
	cv=none;
	b=S5viGfaWXr9Cs/q7CA7eiB51ne4ttO6r88ws8tBhnGNsDWWk1TwINNR7kYxKH7wZKuynG5
	K6f/LB7U630q2iRcvUjXS1hvS+wwBH+vgQPR3k8+fuZxNhj8U5udZmtkprxMeHivcDWVFo
	j4yxiU4fcGGaopxlcd5b8+EbSv/rZb86SBM3cy3CNluDAuDDTxqnlbliCF2gVqERD4nssG
	D9/KOrz+boFRWPe1Au0WZxMmTBAs6qpgkbRQ4Jpc+Pm5Tm6nM3MTl8GxdKMlUnvJ3F+lYA
	oZG+xp0pfkif4HGNum+Ls9aHBVMWyOMFxtpInIjKY1GX1qQ9XBRFHVvcfO5Iuw==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
 samba-technical <samba-technical@lists.samba.org>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Tom Talpey <tom@talpey.com>,
 Bharath S M <bharathsm@microsoft.com>
Subject: Re: [SMB3] fix reconnect so it can handle cases where server is
 doing password rotation
In-Reply-To: <CAH2r5muFhPy+zJ7iuyOajVT8PQhO=2ruazg0kkbKOz3_YeNWSw@mail.gmail.com>
References: <CAH2r5muFhPy+zJ7iuyOajVT8PQhO=2ruazg0kkbKOz3_YeNWSw@mail.gmail.com>
Date: Thu, 04 Apr 2024 21:24:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> An alternative would have been to use the kernel keyring for this but the
> processes doing the reconnect does not have access to the keyring but does
> have access to the ses structure.

Are sure?  For example, DNS resolver and kerberos auth require keyring
and are used over reconnect.

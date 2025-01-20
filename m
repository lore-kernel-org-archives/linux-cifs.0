Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3E1E98E6
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 16:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389435; cv=none; b=u3Vs5YKZfCT9rF4g/2OsJcjwsrgw23gLB+mytOmdJN0wz/M7hqB8OCqfvll65mMvN3BvCsEEzTmkSSQd48q3E16fzhaQfXSaqEkc7ygpB7B1hF2JVXSR+zbt/vEfI97nAmrHRdllYHSO/+kJkTmadTegS7P6mIWN2BXptHfMvQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389435; c=relaxed/simple;
	bh=g22e7q7lKgVEJppwDOqdSri3PqdSTKjIrstI42+2FGA=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=sCTb/vozal1wGUGmYhGYIJPLhGcNbjvfAwpjBrmeuIEvyz4TSC5bsOB0raCiEJvJPVxLxhGGpX3V8fGXJVhxGL8c3wZzT8hqrYEZTJsrq6qF1xlMZzXWgLOI/mIXtrYrK+zeSPI32WKEnMRu27NyAQU9fT9aBqoXkVgaCUAmSks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=lz5Sk6CJ; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="lz5Sk6CJ"
Message-ID: <92333abc251f433ebe5e0cca280f7426@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737389431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ssa04VaK2gDCqVOJlUDTxDLMsdArumRoyKPJHdM2vQE=;
	b=lz5Sk6CJDKaEJWOn1bRTmbskZeIGYKrWA4iaElKpy5H/zAKZarc6wKTZEb6L5NsxJLC3rg
	w3Ok4us1lkSSGVxyr67ICGpEcrdbweype9Z6ryh+Bjtw6GD3EfPUr/TxIT95Z814bQCvGt
	s+/eMyVIOoDz//JMzhHaiZLuPn+CQDt2hihS4p/iyTC7Ipd2d/i/kfzPJ2CIN8XF+af2LZ
	MEsQkuvPZERtYuHwUvwiEf+qlGJBO5/xtcnUVT0RFZk+E7/BICfJHTRICUB9QvbaFYwZcV
	XvQODBYoWZvJLO9MUbncXQY8d13PnmbAvOCcBBO1trtTx4eTk++tYxWYu2O31g==
From: Paulo Alcantara <pc@manguebit.com>
To: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Pavel Shilovsky
 <pshilovsky@samba.org>
Cc: linux-cifs@vger.kernel.org, Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH cifs-utils] cldap_ping.c: add missing <sys/types.h> include
In-Reply-To: <20241226204235.2311371-1-thomas.petazzoni@bootlin.com>
References: <20241226204235.2311371-1-thomas.petazzoni@bootlin.com>
Date: Mon, 20 Jan 2025 13:10:28 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Thomas Petazzoni <thomas.petazzoni@bootlin.com> writes:

> Fixes:
>
> cldap_ping.c: In function =E2=80=98read_dns_string=E2=80=99:
> cldap_ping.c:72:37: error: =E2=80=98u_char=E2=80=99 undeclared (first use=
 in this function)
>
> when building with the musl C library, but even with glibc u_char is
> defined in <sys/types.h>, it happens to work with glibc <sys/types.h>
> gets included by another header.
>
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
> ---
>  cldap_ping.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>

Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C361A2AEEE;
	Tue, 17 Sep 2024 21:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726607084; cv=pass; b=o/Y1GIjNlXbExACU0oVa7bCuu++ReUVs78CFT16AsIAbsA5LWLXToW7E9G0hsJ6lWgC8KoGYFjpGVYZ69sEXl3EFBiUxlDfau3PHqjMtDoTIxpu57vBq8Bq9AdCHZl5jKzekxzYvXfaLPgMGpAPP5WcP9tZdN5U7sGUSPtm/Q6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726607084; c=relaxed/simple;
	bh=WiBMgjXh1JZ/nQmfAXzduyy2EvhjIr1uGzPplKqsTz4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MfIEA6WhglNwd758tjG5Uh9FyhPe21789Nl88Cjot0aaiHIFnJsf2MVDnXz3MtNA6Wjux55AChLd4dlMMclQYA5oZckl56lcPPja0+HGCxeoskyFnRvACKU9o2eUy3GDP0xW6FPL9u4XegGTHP2BUTVzH60HZ5Hzpvzr/BpVa3w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=Te0V5ksR; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="Te0V5ksR"
Message-ID: <73552a5120ff0a49a5e046a08c6c57f4@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726607080;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJ6YctFkZQi7t9pOWNN5E7eSZxom2Rq0yTccz3cGPUk=;
	b=Te0V5ksRhpH0q5sw8HGqGvqqogON9iaDpzTjbBZw+nDHNUt0+dcb516dUXcyS6xidOTnXW
	G62Kyz+kAeoszSXf9YVGNrkJpvg39r/XofGm8GvfUa6yJ2W3nHaBRSWD9IgO3dGTBbW/aj
	uB/RC5AoWryd8ShrUN02pKJFwO5gtrXrfNjJO5C4Ff+9djsnqQyICkFcJq7/vgWxMPN6V4
	PXiY/qmlVJRLaxnH2Blz7IQI+pZ3l+3HR4zsc8XaGCVR2IqWM+R3eePi16eOL9kNV5lqGv
	RoTpeSPTj2gvpjpRI599sSQW9Y3sYVjr9OBbun6MWbFppzdiTcwB0T6aj/P9+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1726607080; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJ6YctFkZQi7t9pOWNN5E7eSZxom2Rq0yTccz3cGPUk=;
	b=SiKcukG0CWw1jq0AYDjCXOOu+Xv1ffOFrjpZRPThh3nRAILcQzq5GFO4FJJCneE5u4r8SU
	iBwEF4g5KGvXNlt5oNvoJUgzi8t0Dj8XNhOfVx/ldQzG70rpDaX7RWLB9tBqrUq++N/txp
	qJ3spng4i+HxYOHoSPhJoo8TD5FFwZNZf4+3PWKQbvy/b6YMBtlQRrbAo4z6JXjDv/Om1Z
	p14RtYV/3w/3tJp+pR5Q7K1iYH9CyDrndSS38ahlPF4Aj0skkZ2YXmqon23qvd4+hldAW/
	XQlKb3T9KmX/QS+oKX8DYF16n6t8pVWG77DzrhBWyQBCZEoan4Cv/A9SqFn3Cg==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1726607080; a=rsa-sha256;
	cv=none;
	b=LCpvGtpulcvGby4D4S4ij4CVNFjxFVoZlSf+p+s8t7Kg8f2R5yqcb4uANOD/TQUot4QPU8
	alQClBjO/Zob8MT1kygSTGcaDwQtuMSa4bueaRYRRtQ5TsrOuaI+MXnSI52u9NCK8jsYGa
	UW0dIuNcXQCb9sqEI6NuDV6AnCs9qH3MFlF1sizoE2K4H0gep4liH6DkvS7eShfOM+YqVS
	Jti9gfNkf2EtAW3pkhmypAtJW4r0oE49oGSaqKhElQPJ1SP47vHPGTtmwPK8vR6JpiO+7e
	EJsiAB+66pch44c0zo3kCWP6cEaLe1DyUqw0U31sX3VDBFWAiDBDULLk+vcy0Q==
From: Paulo Alcantara <pc@manguebit.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>, Steve French
 <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix getting reparse points from server without
 WSL support
In-Reply-To: <20240913201041.cwueaflcxhewnvwj@pali>
References: <20240913200204.10660-1-pali@kernel.org>
 <20240913201041.cwueaflcxhewnvwj@pali>
Date: Tue, 17 Sep 2024 18:04:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pali Roh=C3=A1r <pali@kernel.org> writes:

> Paulo, please look at this patch as it is related to WSL attributes
> which you introduced in the mentioned commit. I think that the proper
> fix should be to change SMB2_OP_QUERY_WSL_EA code to not trigger that
> -EOPNOTSUPP error which is delivered to userspace. I just checked that
> this my patch works fine for Native NTFS symlinks and NFS-style reparse
> point special files.

Thanks for the patch.  The problem is that the client is considering
that the entire compound request failed when the server doesn't support
EA.  The client should still parse the rest of the response that
contains the getinfo and get reparse info data.

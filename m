Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAEF315D5D
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318915; cv=pass; b=a32qx6yGeqxGcBU9QB6Bd2GPG2JC9lvlkJaEZ3CasuBZquWbq+ihsNUjhLPmM6sp736Pt6W8sbFr4DZLlEq+udVVt7+e/aCAnN5RwlG/XEI/w+CeS9lNXwubZEyIc7XU5Q7h4xxp875OJB2kEsaJV5gWM7/4CYZWp18Im8Dxhrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318915; c=relaxed/simple;
	bh=SPqknecDtjTTtuhNB/QrDHa9ciYC3ivCmhIhHPgnGq8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gWGqgx6cAVdpWzZMPb+MWCSfNO79AMXjZdjVN1ZzGrjIrfLUyXWUL2p6L6m6yFmtTQn5RpDBsvlhayzzAXxZkESM504lzT3oIFUyMsg2IVlCvoedzCie0oRVXZ6Cx0Ve3m4iPIM+mmBuEcvY6L5byVhBW2Z+JpY85CjtrFDZJhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g2B6Qagv; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g2B6Qagv"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8947e17968eso16636956d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:15:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770318913; cv=none;
        d=google.com; s=arc-20240605;
        b=K6M4QgjolNF/39agGIDWaJ5T5vZoI2rCtj4UgBdA5ODXbCh/tbo+PuI1ZW6G5FHfjp
         7Zm48rTzXfQJEN2hWcPCue+YmtO9OTyzn3VJtAU4XH858M4n8h547Zl426VvqPw7QTUF
         rXvXTe4RZRBE/SDye1E7al+4jCQMbMKEoeegzDkwAnxrjfxLZvqzNhOmauAqSO9xP9W+
         xg0ki4mDv6LfwTBRtkBaFXb8Epp7Tt1Jx2ePxdvYide0DAizMfGcoIe8khrSW6ttWNOn
         XF12RLuvUZvdMZg5jUs7xWzsWUpCH8x4dM9Y0ylSRTLHJ018WP44nQqnHcmH8Rko6ibr
         mFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SPqknecDtjTTtuhNB/QrDHa9ciYC3ivCmhIhHPgnGq8=;
        fh=tXlXfFzseOhfehmSmsLTIAm6In1J1ul1aoxHCHPKqrc=;
        b=X1gXR8S+8cB+ix83XliOoQc8k5znncWKPQcSQzhuUr7v4HdRdC9G+z1kt3CGnvnKga
         veJXkLyoGsSYxpNu6IXNOA2iCEEydm64Z38OITWtXQV3xp5ksYKYuy63Cv7xOwl9CAPl
         JVWqz//zy0H1+fRr3/O6DhBtVWF3qN4X2DvKxaJWZP7W3mzCsBoDHefnZxeknEXGNl6G
         xFJai5Sd5U4BaR+SExN+ly4FJ6TAI4K6Y/YKibgOS/qzO5WbDqaGijMUsC9SbJ8K7AxP
         DEn6UTdBtTD+/z0SmKMFZwL4nEycATdFEc0Y7FE8eD+BDe22uVUU0G+DiBxsY+jT+W1O
         /8Cw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770318913; x=1770923713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SPqknecDtjTTtuhNB/QrDHa9ciYC3ivCmhIhHPgnGq8=;
        b=g2B6Qagvm3VbCeKnFjxKXDqGPO8fpedqvKcCdggjG1hQ9ah04fpCNAy5zvs9idEdKX
         o+Ev5rMKWHXyzB2qUg3/Asbpmv681sXVFAwGoYZAF/qYhDPg3eg2EaP7j5c/F1tt72Xe
         O7nCVpxJPNzMCKRJbdTgXlXXjfq35J5KwXsozSGiqwgurZ/ppg7M6AQExBoFq130lG7N
         BzBkOq1Mun+5E7XryIfpL0GTlXveGAjoj/r2r++XGU2AEmTtj/hvKS6PCRrShk6vyjmy
         tGfTiFeh/tQRRi4j/tfe1tf0paGnWxOkPf9/1/iYd0ClYx+USWxyqrwTlxW55R5D6nFy
         tSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770318913; x=1770923713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SPqknecDtjTTtuhNB/QrDHa9ciYC3ivCmhIhHPgnGq8=;
        b=pSrOnoR4Iad38vwGHZqbjp7y6Ap9cmcKTMOo8K7o6g50OLAuDmzVBCx2eM9OGKiKhT
         9VKaCU9DQMv4kRVtoDQCkrroYN4GRWDR1SBrEGWAZIZIvu1NBLAw3B6g8T3ZM6etpxVo
         s65OGeGU/ZDwc3U19oz5F8RJ5rdSVzxv8fLAk00L1Gp+b/zgxPMRaIYwl/Wo7ghnanFb
         6qjU2npuyUxxjJ9wconF+Jdq16jBnzw4Gl9YAaz+DhcmO/Y1U4iBPOxUu410peR6Xacn
         5q+RIjMk76zqpq3THyMauGYlEGy8WZtVXGM4S+koaZr19WNy/3gaYD7t7caMuLE/xH4b
         g5Bw==
X-Forwarded-Encrypted: i=1; AJvYcCVJYDlesTu2RyWY142UBjsNUkC6kADROvRPRC1FzvKxDdt/Osd5mut4CeLpaqCJJ+Mj43E2wNRtYGJX@vger.kernel.org
X-Gm-Message-State: AOJu0YyquT82Kq/W4juhWT0tK5Wdp6ecWhw12tqMrS3Z6qVoheDKzITQ
	MiV+kG+dpQ6Rrp0A1p+LU/8mqcTXOtYMrGhQWU5/UgzqYcepQmVO6SqmU4XjwiP0ialy1NGOhWU
	YC4OyoZaYSrIOWlfCcYtPn2vVFsjo8Q4=
X-Gm-Gg: AZuq6aJOdzwfnf11/DD2RkhZXTyeigQl1o3VNza4K2aybBDGvXx0reZm6CRz/CrTgnw
	tfXwQM+MlZ3LcJEUcaHLu8/z3cHaDwoPpc0GZU/lbt0V9q3Uj+8VoDQXcUj3w8gNXFuISlq3WOe
	EeeDU5ibEsayaisf/puh85HP7ippylSVlG/TyqUlUmWnYNy3mOVphzV8NzHgSW4hhKw0q395BNQ
	0p/Ja9aXaRPyI842CpD9JRUnF5hJc9VOFugpYlMtIcNCiZEze8UcIWoLqQ6BzWhUrmXOwA4tnLR
	0m9YmeEtJC8iL2XXLq2GneYV0Wo5fJ3u58iR4/OYVMn9hU6KNBnbATvv+pWX/4/3tHiA6fAk5S/
	T6vrt3tOD+v/J9DiXnSXgABxkhsCca3oJyoz9Uv+x62B7DhNtAmu5BN7oiUukl6oNPLJuhr55MF
	tucX4qbV9S
X-Received: by 2002:a05:6214:20a1:b0:88f:e333:4a9c with SMTP id
 6a1803df08f44-8953ce9e945mr2451476d6.51.1770318913303; Thu, 05 Feb 2026
 11:15:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205161952.245146-1-pc@manguebit.org> <bfa4a0be-8429-4ea1-8bd6-691c3a47ff00@linux.dev>
In-Reply-To: <bfa4a0be-8429-4ea1-8bd6-691c3a47ff00@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 5 Feb 2026 13:15:01 -0600
X-Gm-Features: AZwV_QgM8P0ub1iillZ7k0qMYELtrL1BfSVtPYMp8qKEP1PcXH0cdqLoiv8lZQM
Message-ID: <CAH2r5mtUEYTWb4m5aN0TiTkXdSA0UMbeQxOdViLXkUCZcT6WyA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential UAF and double free it smb2_open_file()
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: Paulo Alcantara <pc@manguebit.org>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 1:10=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Is there a typo in the subject? Should it be "in ..." instead of "it ..."=
?

Yes - I will fix the typo

> Thanks,
> ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> On 2/6/26 12:19 AM, Paulo Alcantara wrote:
> > [PATCH] smb: client: fix potential UAF and double free it smb2_open_fil=
e()
>


--=20
Thanks,

Steve

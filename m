Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C15632
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 02:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779676480; cv=none; b=JuUXUJwdtYt+z6eZsSBHnyUcH57Te0uY3F3EmWh+9y6W20UA5r2RLzfGsOuJtN72arXPJUAPb00yW95C/5u4y4os5I9E+zu0mRLN8LeIqj+YD0yhBgv+AmmpQ32FIJWl2KX83bulfXNWpSQnAhrAabtvpYMENUY9WoMB2HEfJqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779676480; c=relaxed/simple;
	bh=d5LijKwyfW4ekG7eMx6Ep4mcVFGBEkXOaoxyNbjHaOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZT52jzdQdI0534PuS0Ac4c6t5F2MuBS+JgD2sDXw26AxhqhMnUJ90sMXXMbahyqpCz1OeVBUILHXEySwRqhVhWfV5s02RBqmviE8/S79/0Z/cTBdFTthpXjklPEsDyZLUdgG821r1HXH+ikNGPll9xqkvocj3lo/ssUO4gRbeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyYEm7e/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyYEm7e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31931F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 25 May 2026 02:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779676479;
	bh=d5LijKwyfW4ekG7eMx6Ep4mcVFGBEkXOaoxyNbjHaOY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WyYEm7e/Smzk69Bs8w1UxIQVaFc4ePgX0cipZOGiOWMa1p3EekKhh5e6vWMM3Z+kA
	 JT1QM7GnZw95wnY5Wc58QoPfD+nYeL5JNuuXc+QR5opctbKcEqghR4FVlaSU93FHcf
	 0+iD4SQy7RRPQQ+881pl77Ay+bYb8Pp1CoalSkFKhFa/9l+nx63Kd2EzYVWfq4EKbe
	 Sh4As+kJ0+OJRr+jEITOYq+gnQdizAIiETTGGL+edH+kMvulS5xAy3sAg74LszGiuP
	 4DzTAoZuviw3TwWOS6IWq/6Cu/vfzPt4SKfImb1VAijXgAiXdqU0Jiv6ekz/FnFV3E
	 TebQyz878nl0g==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bd4f8260e4eso1666812266b.1
        for <linux-cifs@vger.kernel.org>; Sun, 24 May 2026 19:34:38 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx6r84cTM9K7XEe6mJ4TCzBuXOY2N2hcvW+cvn102wtYn/ESCFL
	+qcROWhk5ou8bVsHvdMvOqH9y90LGglArfWSmOxbFwyQcxG5w4NCQwFoMiOdC9sLrMaXTf5AF7V
	FHE3uUES9LRVgkso0ANVUl2BNYg69RJ0=
X-Received: by 2002:a17:907:b80c:b0:bde:137a:45a8 with SMTP id
 a640c23a62f3a-bde137a477fmr398713966b.39.1779676477619; Sun, 24 May 2026
 19:34:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
In-Reply-To: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 25 May 2026 11:34:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
X-Gm-Features: AVHnY4JIDslAC4crCx48JJGF8ClM0swyTocDhVAmW5EXM8ZwIWS-DkGTqqsOrBI
Message-ID: <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add missing software bounds checks in RDMA
 transport layer
To: _Vx Ano13 <ano13vx@gmail.com>
Cc: linux-cifs@vger.kernel.org, stfrench@microsoft.com, 
	Stefan Metzmacher <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 24, 2026 at 10:50=E2=80=AFPM _Vx Ano13 <ano13vx@gmail.com> wrot=
e:
>
> Hi maintainers,
> This patch fixes a missing software bounds check in the ksmbd RDMA
> transport layer. I noticed that a length parameter was not being
> properly validated before use, which could lead to potential issues.
> Please review this fix. Any feedback is appreciated.
Could you please explain where the problem occurs without this patch?
It must be described in detail in the patch description.
And wouldn't it be better to move the validation check inside
smbdirect_connection_rdma_xmit ?
Thanks.

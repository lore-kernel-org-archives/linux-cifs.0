Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5904F143726
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720182835; cv=none; b=dEOdDzHrTCeCAOP/tNP5SGtk4DmKIuWsmUqXQDxs4reQc3yuzJZTX8nRv9e0x3urVtuc3fgNT36kb9mrPSrBkbUgmKiIXPIyK9vdH5sQwl3IO0gg3cw1Q/oh+h1Mjhb9Xuqs8TBKFtjM4NTDaNNECRTSqbeg0wKzri1IeOCEAoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720182835; c=relaxed/simple;
	bh=cikoHVayZDNLK3fPvvk/LuQE0x4tF42uUYDdp8ZdbB4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vpw/043tmbgA3Dpd1rviVQSIXbCh4fR3cwFK4UqiFblvrHx85VbEc03GZfz39ejj97VGKFiszof7LZ7f+rISowE2YGfrj3ZnnkD4hECxgRSdd6Tqo4306VXYKXiNIdYeo8fCMq7MawH5XW1jpIGAiX/xSVcbfQpViLQLUaR5rZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvfEkKjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvfEkKjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63FEC4AF0D
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jul 2024 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720182834;
	bh=cikoHVayZDNLK3fPvvk/LuQE0x4tF42uUYDdp8ZdbB4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dvfEkKjKEvh/xAJQ2wJq8+TeV2i8f/z2SJzwaKQ5LnW7Zaogg87UT5deWCUTH1Bky
	 tURQw3JHy90OJUeM1VGsBTMg2t3DRcuGWtIkXHPszykUQYeLvEUE3q0nuEg3LUVyiU
	 Gy61FPrNXcepvjVdkVvZJBFMJzg7+Im/x+UJ7H0H6k4lQKW276Rd2mAENSvRqDJuXV
	 KRHwbeOjB2/ByC18uuJfpCswXj7g6uAs8LLHK9OYYUogaEugJxzT+c/RwWq3L0XiQF
	 QlYNC9ZlCt0lbgMRaF3pbz+HBpbWcs7HqG5dmSCrFqCE/V9jrb8t4MAfi7pRHkowub
	 gPHtQJc2/6Tmw==
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-3d850109679so849396b6e.0
        for <linux-cifs@vger.kernel.org>; Fri, 05 Jul 2024 05:33:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX0faT4Y91wgfmHYxJ/3vEFYLF+iDB2H0DhY8zr1J3XC3OHJwNqwiELnqJ4mZBBBI8yX1dzFfZoZ6DNthVBYyhjgt5rcFUia51v+w==
X-Gm-Message-State: AOJu0YwVK9Ko12fLt+6ySJL+jt15ze/LvFWSydUKHlwJnJuHN4Ym6Iit
	LEMW+SLxYVeGKBco78uVVOgJE+o775PnSaNr8PWbsOs7OQAGgEj5u8fa7IeBzHnCCuxGQURGqGG
	+0DKD0+TJZEW1bBoONf5x51wjRi8=
X-Google-Smtp-Source: AGHT+IFXkfa8jK+mbYgmV+qUplfOpKRY78zy250OKDlAClg3skMuMWR1yHamjyVHC9lmeWoredGmDXJyGRDBA7TaYaM=
X-Received: by 2002:a05:6808:1446:b0:3d1:ea4d:a8f6 with SMTP id
 5614622812f47-3d915d666a9mr1780509b6e.24.1720182834137; Fri, 05 Jul 2024
 05:33:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240705032731epcas1p177d910a154ded37c459af1c2374a3571@epcas1p1.samsung.com>
 <20240705032725.39761-1-hobin.woo@samsung.com> <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
In-Reply-To: <1995c5b6-0f3f-422b-85e4-8ebd38916a08@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 5 Jul 2024 21:33:43 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
Message-ID: <CAKYAXd_6pHALjKQQDf4xOGoReZ9jBw-KtFBEh7uV8+aw3VNKZw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmb: discard write access to the directory open
To: Ralph Boehme <slow@samba.org>
Cc: Hobin Woo <hobin.woo@samsung.com>, linux-cifs@vger.kernel.org, sfrench@samba.org, 
	senozhatsky@chromium.org, tom@talpey.com, sj1557.seo@samsung.com, 
	yoonho.shin@samsung.com, kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 7=EC=9B=94 5=EC=9D=BC (=EA=B8=88) =EC=98=A4=ED=9B=84 8:54, Ra=
lph Boehme <slow@samba.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 7/5/24 5:27 AM, Hobin Woo wrote:
> > may_open() does not allow a directory to be opened with the write acces=
s.
> > However, some writing flags set by client result in adding write access
> > on server, making ksmbd incompatible with FUSE file system. Simply, let=
's
> > discard the write access when opening a directory.
>
> afair this should cause a failure like EACCESS or EISDIR and just be
> ignored. What does a Windows server return in this case, or Samba for
> that matter as it (hopefully) will behave like Windows.
From what I've checked the packet dump, Samba doesn't return any
errors in the same case.
Samba seems to open it with O_RDONLY if it is directory, So there is
no problem, is it right?
>
> -slow
>

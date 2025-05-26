Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9834A433B3
	for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748269499; cv=none; b=Amn+iWP8UDp5AHN72QziX+d5LC8ODrCPl73yV+z9lhFDSsPxGae/0hCmNv9k5rD95/M+kBGoWKNJZwDr+MoKhunhmoXJYNHJo2TRP64J8FtOFvDgxlI6voJEJACm8Veb7XTHwuEk6b1VcWEkRL1JIJAM+cDNaA1dwvPiaAiBd2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748269499; c=relaxed/simple;
	bh=FzyTQIlVdzNv5jN0hyPdpBp66ZxU5HNQjzsHODOBwQw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M27zVYQHyM5p6gYglISOjH7GC0T/sQCB/3SdfjXQfJkjhZAUVmAG7P2PJ/2fkxFBdhABM93Ax23WsNCBUDU9/OumBg/TUoyhWaxzFlyaorKie1JZuiEIUVzAg2IZIVycCAc4hIaEW3rBf0VInnFY12Zk0ONVBvpAiO8aLQbZuC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T75m/g1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T75m/g1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07665C4CEED
	for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748269499;
	bh=FzyTQIlVdzNv5jN0hyPdpBp66ZxU5HNQjzsHODOBwQw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=T75m/g1wVRn1JP90TSNtqzwdu7VDDehnaacqyKkZnwT7jOedDNLpL6W15j1jgaZgv
	 Xa2kU3ebqq8hW26olz4O/x9CGb4se9WHvepRarb5/Ql7iNBEkJ8wrN1J/w7dXhRuut
	 cGLnA3DGGBu2u4BuqyeYuK+g/yZwyGKFqmpagp9awajXuuxLdbmOo+abMIIpfM5m0+
	 nF8CYRoB06YbK6e3ODYxjAZMxjubvLWRn2gBQ/oyS/w3sNvgqSRG13PkfW/HDC+GRb
	 wTS4aXBAAcxAMVs2OgNUysL35TAlM2kvlcy0Gz/ajbAM5e9yK9t70lw23o3pa3Sv9x
	 Z0aZm6ypAlLcA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad883afdf0cso75456266b.0
        for <linux-cifs@vger.kernel.org>; Mon, 26 May 2025 07:24:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUdznnDjYAOlFWQz27gHjhlbs+RSkHfVWWg+r4YWeOUFTp5mpzkjNFiR0T2RYF0PBRmk8spkUm4gKLf@vger.kernel.org
X-Gm-Message-State: AOJu0YyrBZabWcm1gdVlU3riMzWkyYQ8Gt8GkrZ2QhEKpPiLhDFY1SHc
	VNQi9AZWnz20+ubS6X578IdJTupuHE0GEA9R8Qvy063cjItk08JBx/Z6UEnKUxAQ4zuxEukYg2N
	4Bgerod5KB6EfbIreJyaNkoo5uSTvJu0=
X-Google-Smtp-Source: AGHT+IGKl7ROsCJlvH1K5Rsgo3qSrt0koyKUqSjUn3O70mFL2s51stLIp4sXP8kYzb8euOpFToM4BX+oVqov3BWdVQE=
X-Received: by 2002:a17:907:1c19:b0:ad2:2569:697c with SMTP id
 a640c23a62f3a-ad85b050483mr747361666b.8.1748269497617; Mon, 26 May 2025
 07:24:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com> <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
In-Reply-To: <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 26 May 2025 23:24:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
X-Gm-Features: AX0GCFtkBpSIQDgjI-JZo6BFUzzrZGEBUqfUi9fluYlsbSNe4BPpKkKcSyifTCI
Message-ID: <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
Subject: Re: ksmbd and special characters in file names
To: Ralph Boehme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>, Philipp Kerling <pkerling@casix.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2025 at 9:39=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 5/26/25 1:37 PM, Namjae Jeon wrote:
> > On Mon, May 26, 2025 at 7:45=E2=80=AFAM Steve French <smfrench@gmail.co=
m> wrote:
> >> If the POSIX/Linux context is included in the SMB3.1.1 open then we
> >> mounted with ("linux" or "posix")
> > Such a context could be created in smb2_create context like apple conte=
xt(AAPL).
> > However, I wonder if there is any plan to add it to SMB3.1.1 posix
> > extension specification.
> It's been part of the spec since the beginning. You can find it here:
Right, I found it.
Thanks for your reply.
>
> https://gitlab.com/samba-team/smb3-posix-spec/-/releases
>
> POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT

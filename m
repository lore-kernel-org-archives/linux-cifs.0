Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C092DA759
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 02:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999960; cv=none; b=CUNM4xlWd49XZ22XltMHIK/s+ExR7vBZmMfHYFxRKGju8jXKqJVXUi5WNbuJjYPbY4YswY6mB6Z+Y8fjpCwoMeBDZlppzXr2IIAtMwGyUGsIN62h6Tcd0d2tKtLOIxBkS9SI5qd4FvP9GvGU6n9TukujxWYXuy/Q1w7C60NTCY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999960; c=relaxed/simple;
	bh=eunM6lFOtg60cJinz8jCdCXay4DGmA8E08p6jgGr6C8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e9SqT56DR/UNITjhNYVECGSMIk6b77pqyPFd/3sq0754tcl4PenREfz8rMIREjCzgu4nwod4dgx3t6toC9FMQWLrHvlSXJarNJXA6P383yAC4EoNzyXj88HabGRs7UoJbcUzAWZwlRfQb4Mhq/N7GCfD3kiZ2GogTQV/hZQ+x7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeitnRji; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeitnRji"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D792C19424
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 02:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762999959;
	bh=eunM6lFOtg60cJinz8jCdCXay4DGmA8E08p6jgGr6C8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XeitnRjidoNm7IeLEr3VjBr6UAV6cPkt+LZBvfMOOSiaTFsakCkPGWedvh6Zw+BHN
	 F+jIheewedqvGqsDo1k3Ppq64EFDBzq4zysNoqrQL3daPs6ZF0EWaRHxpdhFQ4oJPt
	 /7sZkJ325TcRDu2XPUekrEz1LChqV5kJAdoP19RlUHPk1DVzz8FD/tIv2pY/s4AAle
	 WnpB8ulDApUV8C6ZE2jmxflYX7iujut5z3xyxHcoTPXOkAcVdNLf1FsU9MJ5ALkU8C
	 qo67z/mWd+31cAY7CgmmutKeHxvEjooWTs/jKPXicIiwOJOg16XTkj5icWoqJLf27r
	 TFNtgVfE4JJyA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64088c6b309so495938a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 18:12:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUXM1jDXjtTrqbHCaDjxl67fFUn5QVoBdEAqBDLS1YsbAPxGjG7poMtQPV/9nZyrvuMbVnx55nHbVAk@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/OntGk8fkWcILejsOSzI92WWg/Rke0RVz0MY2npccOUKBH72O
	/zKyvWiBqoUZ/mTb7RnsLk90/bO3kEoOPkRF4rhWjNdX9wJgN2KZIym/TmmsIJWVREVlpTWZJt9
	0nBZ8K3gsx9Zx9kqlcwNO0j7oKYQmwrI=
X-Google-Smtp-Source: AGHT+IGvr4PyRge3H1tPN47kpaot3DaL+oE9X08xC7yp/+y9GeNLtZZeuUUq9w/wYd84gyycWzLzbQEt6KUl4XWm4AA=
X-Received: by 2002:a05:6402:34ce:b0:63c:683c:f9d2 with SMTP id
 4fb4d7f45d1cf-6431a4d60b9mr4650668a12.12.1762999958142; Wed, 12 Nov 2025
 18:12:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102073059.3681026-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251102073059.3681026-7-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd8o3CKcaArMzEifR+oaX2G_g3XuEjFkBtPhyO99pKQO+g@mail.gmail.com> <fd9d8a05-32e8-4f83-8e40-a6497dde1ed5@chenxiaosong.com>
In-Reply-To: <fd9d8a05-32e8-4f83-8e40-a6497dde1ed5@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 13 Nov 2025 11:12:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-niyc2df5BvZYBzo-fOX3WcTjhgtxh5aQyHrVwL4ONsQ@mail.gmail.com>
X-Gm-Features: AWmQ_blMVnsOyedOFMGFML-5m4qQos6dPAtk7FXodpOIVT2VlGDPcijcCea34j8
Message-ID: <CAKYAXd-niyc2df5BvZYBzo-fOX3WcTjhgtxh5aQyHrVwL4ONsQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/14] smb/server: remove create_durable_reconn_req
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org, smfrench@gmail.com, 
	linkinjeon@samba.org, christophe.jaillet@wanadoo.fr, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 10:46=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Okay, I'll make the changes.
>
> Once you've applied some of the patches from this version, I'll
> immediately send the next version.
I have applied all patches except 0006, 0012 patches to #ksmbd-for-next-nex=
t.
Thanks!
>
> Thanks,
> ChenXiaoSong.
>
> On 11/13/25 9:19 AM, Namjae Jeon wrote:
> > On Sun, Nov 2, 2025 at 4:32=E2=80=AFPM <chenxiaosong.chenxiaosong@linux=
.dev> wrote:
> >>
> >> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>
> >> The fields in struct create_durable_reconn_req and struct create_durab=
le
> >> are exactly the same.
> >>
> >> The documentation references are:
> >>
> >>    - SMB2_CREATE_DURABLE_HANDLE_REQUEST   in MS-SMB2 2.2.13.2.3
> >>    - SMB2_CREATE_DURABLE_HANDLE_RECONNECT in MS-SMB2 2.2.13.2.4
> >>    - SMB2_FILEID in MS-SMB2 2.2.14.1
> >>
> >> We can give these two structs a uniform name: create_durable.
> > Please use typedef to define multiple aliases for a single struct.
> > typedef struct {
> >    ...
> > } create_durable, create_durable_reconn_req;
> >
> > Thanks.
>

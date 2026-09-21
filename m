Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E9F35A385
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789969316; cv=none; b=IJUL3Zx/B85BQITC5fru2bbokH9Pt7p74vV1X7V0AE88NGWNyA7XhH0hS4Jn2QLI+jEoyH/a7X2dpTMc5YTYIpfTLIik8YFhMxH2jNRiiyv3rJ60f2cjoGyF2cIJL7cQ1kCKniPzny4j5PxSSymLn5rgHtRdEZ1yPuN2nZHSwm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789969316; c=relaxed/simple;
	bh=alOkypGBl7StPCfxrufk7mKYOKXSsqxWIcxSoIzWQe8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJ3NbqSlQjcim7MaUUG+hp4e8vujhAxmda/no4+u6mbx7kKJzeXnIIwxpB9pOjBXw05RjsuAcyew30NSyS0vDWJwlmTNs3wi6kiUw+/3yuvtedCm6pfhg7sKbMax1qfHsku5svuVnO2E7IW0oAXpbYFHgKXcatPtEzJA3Ef240g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmaHNahO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmaHNahO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1871F00898
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789969315;
	bh=alOkypGBl7StPCfxrufk7mKYOKXSsqxWIcxSoIzWQe8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TmaHNahOqM635+tF2NHyojsTxrdMHkrk/uWt6yI2kuWWRnzvDGun028lNuVOkQ7EA
	 CP2GlT1ftphrC+lXH9ESwbkRzM7c2DQWUIEvrbVosVIGW3fhalRauVMJCNHqb9F3VR
	 A3/pE4xIm8T5elet6FEpeGWrlk2huJEbc5dleEtbdbWlqAKt8t0LhikrTo7Kxzaj/o
	 wXA8lfzRrejPkO/BxJ0pJqR/nz5g7MD1TWGGfOxrZaQwpVctpnldNSBJWRW2Env7SP
	 TXi7M35VLiw03+6FcnSjHMUnfXVWwAFRNzeG76jNVJE5Xb6+Jvi4sC+Y23JBXn7coI
	 u+3dKHpyTXWSQ==
Received: by mail-ed2-f30.google.com with SMTP id 4fb4d7f45d1cf-6aa06e51bc3so4161856a12.2
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 22:41:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy0cVL80zXTBbQesa9GqgZldbJ7XE+xT01zWgY9WM9J3FTK1qHX0oTASEl1ayp9SzRT2oxWn1vwk322@vger.kernel.org
X-Gm-Message-State: AFuF++nf0SFODs2f62vXn2MGrdPeOeDcWBSOsluCykg4fSzTMESVBr2d
	a7JN/WY4DV3iEs90Sf1o24i2E7MkSA0Yo97HY6ttZAky92gJ7hQqjhIld6tubajHmhSen9HQlqN
	5gCQPXx5oAH3wA3JfwDbgL0aH9vQ4psY=
X-Received: by 2002:a05:6402:2750:b0:6a9:983b:79ba with SMTP id
 4fb4d7f45d1cf-6aa569a9a71mr7351290a12.41.1789969313805; Sun, 20 Sep 2026
 22:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921014130.147229-1-zhang.guodong@linux.dev> <20260921014130.147229-3-zhang.guodong@linux.dev>
In-Reply-To: <20260921014130.147229-3-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 21 Sep 2026 14:41:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_jScyDZC2tejqADDHW7aB0Cwd2cr8HoJr2iZarRbc3tw@mail.gmail.com>
X-Gm-Features: AcwNN1XgZ2JDkYZiZCi9_1fbEthVFHypBChz_6Zlb0K3h-aJ7RxaMGdMyoz3Dvw
Message-ID: <CAKYAXd_jScyDZC2tejqADDHW7aB0Cwd2cr8HoJr2iZarRbc3tw@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb/client: update POSIX extension specification references
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:41=E2=80=AFAM ZhangGuoDong <zhang.guodong@linux.=
dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> The POSIX extension specifications have now been published:
> https://smb3posix.org/
>
> Suggested-by: Paulo Alcantara <pc@manguebit.org>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.

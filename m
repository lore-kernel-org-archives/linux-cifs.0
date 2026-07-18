Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722F521638D
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 04:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784350298; cv=none; b=N6dUENVK1LRE9ixXOhhct9VvZvW4QAkMEhKDAXhsN+G/8jXoBHwKRNGO0ru83ftjl8w9EfK4DgeAnIWMiuX7YdfifPN12jz7ibRxiDwO6RdjyDPGr8TxNPjuHsgjsIaEFWIt88EZZjAwPRr6XXf5LySUkhrH9fBTOGfHc+y0FEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784350298; c=relaxed/simple;
	bh=5/dv8liWAzpXOGlp2AahzB3aQyCc28KdlNIcZlCsSZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m5LU2aD2cJwmoT8uMOzEG2xt5IibaT2qCP5FsCKI/Dg8fNZVU1Ls/+ZZBhR2oi+JzIk9M6BKTppJRsdpx1gfVQcrHSBhEr5MJateD4mAa9y6IZugn9pizYg29XRoAJAnF6D39MytCFxgXkaGLV6rxa/71h1SoypLCLQdXmkOXNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S180Y66P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S180Y66P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C060D1F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 04:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784350296;
	bh=SW5ID7XNZ4VJo5c7n3b/9qovpeUdS+agXnDA3NuVxzQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S180Y66PR7gv5hgN3hMxo+ycwoGNrH2UY0IzwRkFdQ8B20Teer18Qe7wtKuR2+UJa
	 OAd8GxsqhH46gYoQecbUuZROig2lBBFyiuMkYebk1BW36Gh3K9JaF7Yp9ywMNGaWIG
	 Ig1waHvDRH/6wlH1R6909tWqxWJjwj3O8bzOCdXeYtjE7Sk9dU+66pzitVdYTfEEw0
	 R/A3fqBCp+5jgwm1NXWzCqjybfWV3x0OduEUIfe2OxEWYpMECBeE1DQr3leI8aS1wl
	 rrnGhfmU8WLkghE1n2OB4yw4BWvqA4Hpssa8QdsJ5h9ZyFdaro3W7gGUUiVOq6MPiz
	 FqJ6GTdP8EtaQ==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15f6d667bcso1064851666b.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2026 21:51:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrZk1mPJQ/VsM+nF+6JkF7mSnVG66Nr/cOzsW7Me79uONyMXaTEsVipoLFeBwn2bYKk9B5mEuf8M+se@vger.kernel.org
X-Gm-Message-State: AOJu0YwZyyW3LCZPZQO68qjw9sDP6sgV2YcUeDFGPF5mMFrzN+1Urf/U
	ozd3wcedptvhpBMOt9PCyF2XH9DGjxoTrYZL5ga8W2bMXc2cUI2rxd6hz9uLXx8AsrGMQFcjBMn
	Ja97gAS779A2ay6PV+7DduA9xKeh06dk=
X-Received: by 2002:a17:907:7ba5:b0:c16:4df6:1768 with SMTP id
 a640c23a62f3a-c16b47d714emr234190166b.42.1784350295289; Fri, 17 Jul 2026
 21:51:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715135513.667260-1-chenxiaosong@chenxiaosong.com> <73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com>
In-Reply-To: <73f4bc4e-3bdc-4bf2-b145-c9b6fc480451@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 18 Jul 2026 13:51:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-ZSbyU8NPCBYCVrExRJiRdn=y0mYbc71sSRqD4LoYAw@mail.gmail.com>
X-Gm-Features: AUfX_mz-KB3pGIFCzszfSZ51pOZ-6dl9TAhTyvB75xr0ElS0Vm7Px95zjdSC1QM
Message-ID: <CAKYAXd8-ZSbyU8NPCBYCVrExRJiRdn=y0mYbc71sSRqD4LoYAw@mail.gmail.com>
Subject: Re: [PATCH 0/3] smb/server: fix some bugs in preparation for change
 notify support
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>, 
	linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com, 
	metze@samba.org, andriy.shevchenko@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> Could you update your patch "ksmbd: defer CHANGE_NOTIFY completion
> instead of STATUS_NOT_IMPLEMENTED" so that my remaining notify feature
> patches can be rebased on top of it?
Ga=C3=ABl,
I have already merged your patch ("ksmbd: defer CHANGE_NOTIFY
completion instead of STATUS_NOT_IMPLEMENTED") into the
ksmbd-for-next-next branch. Please use that as the base and send a
follow-up patches to update the implementation using the
approach you and ChenXiaoSong discussed.
Thanks!

>
> https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify/
>
> =E5=9C=A8 2026/7/15 21:55, ChenXiaoSong =E5=86=99=E9=81=93:
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > I have implemented the ksmbd change notify feature, please see the foll=
owing GitHub link (some minor changes are also needed):
> > https://github.com/chenxiaosonggithub/linux/commits/ksmbd-change-notify=
/
> >
> > However, to make this feature work properly, some pre-existing bugs nee=
d to be fixed first.
> >
> > ChenXiaoSong (3):
> >    smb/server: fix signing when a response uses more than one iov
> >    smb/server: cancel async requests when closing connection
> >    smb/server: stop new async work when closing connection
> >
> >   fs/smb/server/connection.c | 21 +++++++++++
> >   fs/smb/server/smb2pdu.c    | 76 ++++++++++++++++++++++++++-----------=
-
> >   2 files changed, 74 insertions(+), 23 deletions(-)
> >
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>

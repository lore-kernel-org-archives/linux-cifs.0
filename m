Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2577843F4B4
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 12:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787661699; cv=none; b=GKn/HfD8KUU44X+Dm9xd2tgI2p3izc6ivQ5Ql7nhlRBYwtP2P1n1saYeG1SXjmtAZLaqUI+DyjL+lvGUlHWUZakRFvBJP09lZ9G5Ro2DlqM0u9yRnXrttSLzSFVhnxGrJmMpTK3WJ7rdpw5W9aCsE9Pt1FdHQegajsk5PUSpqEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787661699; c=relaxed/simple;
	bh=vOmif/9omQ/1RzlG1fSykn06A+Tp5IYR4sAET4aEtjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=STix+i6k1t1GXlu2JQAZ5KvStZWdqQR/4ehUBkefTivaBjO2EP1h9U10c34JYHEctUJ7W3DqCIe99e197W6lDk+o/uKpERl+caU7ryGGsNBWdsHz8Py231pBDT0fb+fcaf/qBnYhYT0x1y9Wyh9ncQQzygwEFbWZGMhmx7v+J+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QY1M0VeK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QY1M0VeK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E451F00A3A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787661697;
	bh=vOmif/9omQ/1RzlG1fSykn06A+Tp5IYR4sAET4aEtjw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QY1M0VeKNzIundrl7R5SYLDdj/Wi9hBM1AL14kXujOC2btXVM+1Z99axSYWZZXtp9
	 YXOxNl630qY/FAsOL651vkmPxrqbIwUJeGzRItZm+W/V/3ScpD9Sp6Oed7bTqUsEA0
	 QX3FrC/8SV05N2OQ5Q2WWhReoTgIZvMvIU4sDxZUbXH1iOeZXVLwZsfP4bszSjPUM3
	 Yk9NJjpWCw+idUVq19mCszmE+11W6sdVw9DGS9wj4EN7JGv9xNe5bi+1gnUg1YaCU+
	 o2pV1zLO2kQY4ixD7MzHyyenhQLYPeJJ3bhVgPctMwZDQFggzHrxnnwMNnSqfdDePQ
	 tU/YaxERYwzag==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c167aa9500dso716672866b.3
        for <linux-cifs@vger.kernel.org>; Tue, 25 Aug 2026 05:41:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq1B9TjevvcUQNyQC0sKHuwLYyULFUe1jqfauULeBb2on+36LKPQ8Kwif9/mR9oDtxVNGEN+z08WdbA@vger.kernel.org
X-Gm-Message-State: AFuF++njYumbQJsBn+HXuw635WIioRbVHYDyNGXcbQvU/nlCkFUnZFLg
	FxiaF8q5Y6NbM+wGTZn8u/s1S/KiYxQL3PDou/SlZ2Mt8KVG//FKlhUV1lc4c/fkfUeX7ITM33p
	VDqeYx3IbABdUC1HBUizCHZBa78w12Pg=
X-Received: by 2002:a17:906:f246:b0:c21:61a6:8821 with SMTP id
 a640c23a62f3a-c246a6cd384mr3165842866b.23.1787661696377; Tue, 25 Aug 2026
 05:41:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260809161916.1071530-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd84UnfdQ6Ef2nqybnhdgURFo9uYpB1mHZpphFyCiMhutA@mail.gmail.com>
 <9aeb9ccf-dcd0-48a7-bc24-4b6948943f62@chenxiaosong.com> <CAKYAXd8JMs25fdyZhPn9KYEfv1WH297nxAV0enFHm6T+q=VTFQ@mail.gmail.com>
 <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
In-Reply-To: <51fba35c-967f-46b9-8252-d433beab7129@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 25 Aug 2026 21:41:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-1=RqAhykLJVgDrYEmr1AU6B-MUfiQb4o4S_JJyU0NVg@mail.gmail.com>
X-Gm-Features: AcwNN1WTKWeyWpPGeyr6FGeEN43DWwrHdDomt5qfL7Q239ecXNkQhJ2R7bOSA_U
Message-ID: <CAKYAXd-1=RqAhykLJVgDrYEmr1AU6B-MUfiQb4o4S_JJyU0NVg@mail.gmail.com>
Subject: Re: [PATCH v4 0/3] ksmbd: refactor smb2_notify() to a blocking wait
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, gael.blivet@gmail.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 23, 2026 at 1:30=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> After this patchset, `smb2.session.expire1s/1e` are passed.
>
> On 8/22/2026 4:48 PM, Namjae Jeon wrote:
> > Can you check if smb2.session.expire1s/1e tests are passed after
> > applying these patches ?
I tried to check again, but your patch set isn't applying to
#ksmbd-for-next. If you could send the patch again, I will check it.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA6C2701C4
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783602644; cv=none; b=NA39FtsL8OmGkojijuqByqR+1lgoyctMGKTlvPWF2m7aPsFIKQxpx9J/sdSkgesWm9xDt9QT6BIaPFEpebTxsoJYGSEXrUv0lMr171vRiyYUF4aVwgSukrq2Fiit3xick4vTHV/5lN1if5fkedNdzH4osdbrKN8LCzP11FquxBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783602644; c=relaxed/simple;
	bh=jJmL86mc4TuGA1QUMRG4IM+rpkpZ9i6hnTjkQKv7sXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PvTeCTFLMesimjqQQ96nzdPSAQhpw8j4ccism5H8mKKX10EObY4w39cZPK6hXI57yHlasza5CjP8XLKfJSQkv1dmue/O6/SwPaeqRRjbfsMeNJqghwj4TLz4+IGR4jJtpOjD5usflGqK4J32BqkD/ioXS5+cVtTniQj4+INBFLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bh602egZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bh602egZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803A21F00A3A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 13:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783602642;
	bh=8kuvHCI2zu7ocW63Zh8YakaB2ba+Nt2SM3+PQ215lnQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Bh602egZkb2970/8D7tVGxSleBwNdheiLSX84kCqTxOxqHTdkXhgqlj96FSjBUCIH
	 p1n6src9SUC4jfmCmV1hCHNoMdbXz2/TATj+XJ8tdS84HrbT4vuQLpyyCVhdTOghO5
	 yorHuX1ze1ZrS5WnCESS3EHAdiceYQvfj4eXR4qoX6iTCJ2W7iqKHmp7XTvW/MrlWp
	 FALitnu6ifaY4xYwqY8Fc/uHZDBzgMMZaYrOWVRWywrqA7jdbEU2RKjDtqI7FyTqH4
	 PfWNNGm+MVv0M9utysTYbPVvUWLelRckrZgsGAZB4JT5j52N5Sp+TDZ9hULf2DY9tj
	 chwqUktBQ4AKg==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15c257a488so244366566b.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 06:10:42 -0700 (PDT)
X-Gm-Message-State: AOJu0Yzvc5dYh4zopdGRly49UTe52Ok0g+YcC3eWe7PFmCuD6dE2MFfT
	BD8JTA3KdTUFk/r+S9C6BGddH68efjXht0l4dFrIxQh28d7WXHRCAJeuFuv+ShRSB0ETU4rXwJb
	91JQ3NXfXZWYZ+NQkOp0tVn5zBzAm6QI=
X-Received: by 2002:a17:907:9709:b0:c15:dc92:5df with SMTP id
 a640c23a62f3a-c15dc9207cfmr221842666b.49.1783602641197; Thu, 09 Jul 2026
 06:10:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709000548.66445-1-g.blivet@me.com> <20260709000548.66445-3-g.blivet@me.com>
In-Reply-To: <20260709000548.66445-3-g.blivet@me.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 9 Jul 2026 22:10:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-7eVwMcmE14Wv45UQ_-q+k_Xzn8mEpd41CwcBmOE5-Cw@mail.gmail.com>
X-Gm-Features: AUfX_mzeftfiww1i56adI7mE9vKU9B0AcCGj3y8p_LDEN07FTtkyjcVv9vVxxjs
Message-ID: <CAKYAXd-7eVwMcmE14Wv45UQ_-q+k_Xzn8mEpd41CwcBmOE5-Cw@mail.gmail.com>
Subject: Re: [PATCH 2/8] ksmbd: quiet mdssvc RPC log spam in create_smb2_pipe
To: =?UTF-8?Q?Ga=C3=ABl_Blivet=2DBailly?= <gael.blivet@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 81f4af614..2e87139d0 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2656,7 +2656,16 @@ static noinline int create_smb2_pipe(struct ksmbd_work *work)
>
>         id = ksmbd_session_rpc_open(work->sess, name);
>         if (id < 0) {
> -               pr_err("Unable to open RPC pipe: %d\n", id);
> +               /*
> +                * mdssvc (Spotlight) is a routine, expected probe from macOS
> +                * that we deliberately don't support -- it's disabled at the
> +                * __rpc_method() level (mgmt/user_session.c), but this
> +                * generic failure log would otherwise still fire on every
> +                * single probe regardless.
> +                */
> +               if (!(id == -EINVAL && (!strcmp(name, "\\mdssvc") ||
I think this patch may not have been tested against the latest
ksmbd-for-next-next tree.
In the current ksmbd-for-next-next code, the mdssvc path returns
-ENOENT (not -EINVAL), so the check added in this patch should be
updated from -EINVAL to -ENOENT.

> +                                       !strcmp(name, "mdssvc"))))
> +                       pr_err("Unable to open RPC pipe: %d\n", id);
>                 err = id;
>                 goto out;
>         }
> --
> 2.43.0
>

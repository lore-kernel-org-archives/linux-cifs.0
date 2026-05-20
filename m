Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06C49443
	for <linux-cifs@vger.kernel.org>; Wed, 20 May 2026 01:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779241982; cv=pass; b=Tf2ZXUeIoVPGkvlFlje7E6wgJWrCWcDgbTvVdUYrHl49MxRlnSs49xl4Ff5THu37abWnkpQuEq9EIaNKI92/CdWTyMS1IxWxxesE8+h3sJbH0nqcIi73fjUnfdGUA5MEP4+ZXz+erCmZPLY2j+rwbW6dAwv8I3iBeiHqErD37i0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779241982; c=relaxed/simple;
	bh=uKgH7pJzwShd3l3h9Kie21E1UNJdXPtqg6XvgLOCv5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PS5KidU1oFB2aSPOxf5PG7hYhffBZ0+WS3oXuDiIcu6jb+JLqTHu5Yt1GhIRemmZ+FjF79TxKeym7G76M68+o5kSOyjX01ia9/pFVJpSTFt1V9cYdnDDEQ0xgPZ3Gq/U2ynbCc6UY9DxmyGYShZjhZ/ixGSaeYiUxa7NZ/Fdtb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=miP2nTQr; arc=pass smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miP2nTQr"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-95cd9a5f24cso1029739241.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 18:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779241980; cv=none;
        d=google.com; s=arc-20240605;
        b=G2p5FhpOrCXXF22mlbq19GIiqPZleg+wWFkgLyZ1C8qejVUX8tIUCcXhvW9wh+LmNR
         GdpgBwuGDfV0ZUr53ZRTwd24MK4lX8WI7Pc59X9et95haEvbaVPs0tA9xoZ0uYNqGjJ2
         Z1UiEGLEkpRLZhhPddkyqfdezx5/i8lOKnLZv9UQGs4emTuWVhYW1dHNWyhUz2EhN7zL
         /WhMzNoLKkz4HfcvQUDfhE4FIPoYgtDVjrfF5eNobRBbYn7aU8W81Oij+munzL7FY3An
         FCd2Nq5Wme/6fZ6okaWLXlLxl36bN4o5PEwldlSnGj1bX/7j5slNDTanoV0nqLleyC07
         nMQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OfiPYiS6scK9qfd7wKbDZfR7CqjtM+D9fRngzz5WV/k=;
        fh=jneaMvy0xezsJ6wUmdacuUfL22I0beCVmnCgvjO+V6w=;
        b=GJzpSx7z2RdKlUI2cwvNOYGif9JdLvROCUtls+rJPqRar/3PqoCYxU/57fYiuZZqyI
         iI1zSTeIW2BEKvHU+utCoGlK+wOg3Du97C05ElkY2jlIG8k6SQ2ryeHkOmP1u0Zw3P8e
         WF9y71/6SIJaGIdxgz+WwEUYTXydb8U8oaIGjK/BxxcJqNoihPvAjiznAMkRBlFGE8Gk
         YOavw97DpXoefSeT6J9xWy1gLv59YwWHSN6nj8IDHOykRXXP771IqS1QEDLuJm4h3G6p
         +zdhXTJ288unrkFc2EA0fUoEVo9p443JKUA/GD/oZMxJA7Cp1YV6DTArZfV3oxpUcAVO
         Xv+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779241980; x=1779846780; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfiPYiS6scK9qfd7wKbDZfR7CqjtM+D9fRngzz5WV/k=;
        b=miP2nTQrFXuO3YbzGHmVIVugTsDaZySUNHleNJ85v47q6mv6xAAjWmmemkv3qgI4Wa
         E2ZfR5SMecqGzphpzPK/uXqyIX4ouZGPYk3X+8kiqsxSC7n5G6KmGQgLAbXMCqGDG9/r
         BiSjrk51MP7XV1WcOv8t5aBfTb0tqWW27TYWFahCWHQbWlocEi8Mn3hAWfgf1oS3U23o
         ptzDOnL8KsEuLsDl+mwocgFLgUgfMwM6uUiGXMVnLv+FuJQVnOFMSq1RL5VrhkGNm9gx
         2TtcuQPZEqSmdbuDwmBJrKsjWH/FuFHDYHuVSzjimDd9LSGJLQ/CHWtAo/YF5qKG3GWp
         uukA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779241980; x=1779846780;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfiPYiS6scK9qfd7wKbDZfR7CqjtM+D9fRngzz5WV/k=;
        b=afikt+0D9gNH2fcYXNdMiy1wWxtKhHCnYLUVUNz0p9275kt2BJq2IJ6ZfRWKbez73Z
         MiS4t8dEXMobj84rU8U2U+OZTrejcqiRNG80b3s9hFM8hBdlNZzGb96Uz189/l+3h2vS
         x45rFbR5cgnr2nbFGSan7Y/jimbhZdIFFFoV9BTZ5a6N5aOjSm4je74Sr6Bdbnzb1Yhx
         6wboxMm3vaI1JuRgHnDnlWNUGzbBiztX6oemIooShDGo9kYe5JvHLLuS0oqDZkg2V12W
         dOsho53wED/OhpGhM+UilYdbUN8JQ8O6I14BUEOsSPCVb+kdjjdCsm68aHjSVPK+EMPF
         tN7g==
X-Gm-Message-State: AOJu0YwVxU9OLvsj4DJgg6tr6bWJrQ7No54pa7/apGxSg5RqUnaP7aVY
	DXj4T2/qQa2f8mZsOdUZrNxtjni1U2AIeIR73jUx0Yl+gisNNlyIz3oDPu9oYCXN4J33qUbqh8v
	16MZyfPLRIvsTvr+oM+53a+2NtPTUd/k=
X-Gm-Gg: Acq92OGVJIW9lHmOjr47rZFGu2PtBG+TG1/e46gADBgmoCyu2bBRLWWSQ6Or1XDadWF
	ysq/J3JizPfdjH42udrlNhRP/8Kl7xy8mpfLmw7n318z6oxmb8aSWpFGpnf+TEHQfMc1MwzcMrS
	gsg2eeg6nZWQCOPApHGDr8TNfMCyGFWeHSayKpWvmEgwE3uxPYiJp0liD8Q+/mHIYaJnRsXy9dz
	rHBPjFA1IF8iYXBhsgpfuGQExqXj9rnmSeLGxfrn2F1LB6y5qKVCuicxuBp6CKpvMUTMeLcapBS
	uy4MmUdO9UOpxkQhd4A=
X-Received: by 2002:a05:6102:808b:b0:635:1bc8:3568 with SMTP id
 ada2fe7eead31-63a3fb99c96mr10946475137.23.1779241980065; Tue, 19 May 2026
 18:53:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513201915.401320-1-FredTheDude@proton.me>
In-Reply-To: <20260513201915.401320-1-FredTheDude@proton.me>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Tue, 19 May 2026 18:52:49 -0700
X-Gm-Features: AVHnY4KppfoJyxSdjWv2q1jjh8Lrey4kMz6TjHgG7WH0KQ6d_Qx66GD4Ux6M0ns
Message-ID: <CAAk_H6EYShvace2Kgdk+v9Mv_zkwfQgoLtRLCuu02w+S8BshWA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: change allocation requirements in
 DUP_CTX_STR macro
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Following up on this patch. This logic should remain sound and still
merge properly.
Let me know if you need any modifications.

Thanks,
Fredric Cover

On Wed, May 13, 2026 at 1:20=E2=80=AFPM Fredric Cover
<fredric.cover.lkernel@gmail.com> wrote:
>
> From: Fredric Cover <fredric.cover.lkernel@gmail.com>
>
> Currently, the macro DUP_CTX_STR allocates new_ctx->field using
> GFP_ATOMIC. DUP_CTX_STR is only used in smb3_fs_context_dup(), which
> is never called in an atomic context. Using GFP_ATOMIC puts unnecessary
> pressure on emergency memory pools.
>
> Change GFP_ATOMIC to GFP_KERNEL.
>
> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> ---
>  fs/smb/client/fs_context.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index b9544eb03..a3ccc06c0 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -420,7 +420,7 @@ static int parse_symlink_flavor(struct fs_context *fc=
, char *value,
>  #define DUP_CTX_STR(field)                                             \
>  do {                                                                   \
>         if (ctx->field) {                                               \
> -               new_ctx->field =3D kstrdup(ctx->field, GFP_ATOMIC);      =
 \
> +               new_ctx->field =3D kstrdup(ctx->field, GFP_KERNEL);      =
 \
>                 if (new_ctx->field =3D=3D NULL) {                        =
   \
>                         smb3_cleanup_fs_context_contents(new_ctx);      \
>                         return -ENOMEM;                                 \
> --
> 2.53.0
>

Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1661EDA0F
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 02:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194857; cv=pass; b=qn8vqPlrOLszPjKFbCLZZb5UtdKDDZNwNlrOBBjVr3kBrXDJrPzQ7KECUJHKsKe5BNiEC7NBGosD6+fdhPMPxi6JT6NTFz76F8n8sIylvR7ffHhsk3JwqWxjNyVZHcG+ksPdJyzup9zhFrckg5FUo6u/ZIpdgCwgtrYIBz7I/cU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194857; c=relaxed/simple;
	bh=8UJnLa/DDQ+b65RDSHa97nR/Rm6zetnRjswOkVb13wc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ujY48pyoYbcjWehK57wwmd/7DaptpUIUvKvGmm8frAVN6kh/ucMwUweoSvKxUZ5QxWjjKNDkVMcOUSnav5TVvHI8yq9JAGzSy1/psiq0UoWQ8tlzNGJcUBYthKw7MZllvS/Vt5uBOAy9s/xIxl5Rsvh2JSuaEacKdFfG5IYq9Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=SqpOgAb4; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SqpOgAb4"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a13d1c6f25so4703789e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Mar 2026 19:07:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773194852; cv=none;
        d=google.com; s=arc-20240605;
        b=OjSKsAw5iSA/vYJslqPNBNG5I8EJh6WoGkGlQY0N7Geeib/J6Rb/NRvGBYYp3Zr/OQ
         3k5IThiTzAnByUHGkxYdkh0EtVBGAg+/8RCcHsrYt9GolcqHOwWf38x6lYnAI+UfARbj
         gBvrBs1KJ1TfajcjlpTURCf6PEeabybIAtxGmcKpoD9TEJA6tU8ZAlrWolWWZIwoyIk1
         ujcdu5wFLLFHOYYqFF0yKPCnBJI5OzBB3MD2SzIDaMYFKaSuvIbA2uS1fQ+AH+ztoLgl
         urDscDZ487WuVD819fsPf7E3GRBoCPalflwMtuHF79E0ZTfMdXtYY5IhvIx2i1hndbps
         JQUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        fh=IttYCFQ4RYO+BGGllO8KegIihXO2sgRvvr63IdZvCgc=;
        b=Z5I44t/bXbtsrJKEN19zICwFe15XQ9MxnV/tEsER48HT9DaD8cpmDKeOk2iYgEeJA6
         mWbKTXy9wGvZMBmND18chZn/tth4Fj9tmg2X9fzBngaKHWhCSNXV57zjx832K9IS0hiG
         NgyA0KoQ6gf6Zs2LCdkkIgT+/yQdpdyrtOehG5t0Bw0TM7FpKBOSbBD7KUYfJ+kUtRsA
         vo6JOmN8Kqnhwhb6fLzbz7ZlRcfPFe3+xpNVDQyntTLX47/zAqEzQSximnxnBZL1ze2H
         vuB3q44uyjRjcqu5gFf5+9blZVGKUAsXR8QPu3bgyf4QhIQbhGHM93gT8PDna1PcE0x0
         qFeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773194852; x=1773799652; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=SqpOgAb4CQOCp6QT1IhDiJXNOENCCAthmmQiQ2Xm1LqdH6AuNnr9pWEOxoaM6J2EHp
         TaZvrNsWvEAAdeAh3rGZCGLrxzU767HUy57VJt43+079ae3+2kuAr2+JBVbU8T9+l/BT
         vjjO+GANIyds0bGFgUhdgNG0FnF3NJi/nWQH4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773194852; x=1773799652;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+zLBLQzKjcztDlxJqoLP6w+B6xnZmfHibV4jlBQCebA=;
        b=PPnoIgGGDLMB+zhv9V4bMCdZFKmFIhsKx+6aTrxjPIPtKCXXfToz2J/wJ28CYzh0X8
         djvHkMXxaGlcSiYR43Ms8Qp+2DjZFmU2fiDaJLmLJRWIgCn3nrhBtHP9+ylJm/O3XuiF
         BlpFGH0penTXuEKUNidmcp+A8p516FTlng+/A+zICqthbN68p8TU2NrCeQAeT/430wNe
         j8Jp1ZKIjdUFlucUuw/GuBycQIHxUvKHn5IyJfnWs7Ficzq11H3wu4RYnv9wXa4LoSn4
         wAe+ACX24k4JLrdtQoqNgpWb9PRmRRwwCx+dDRpTobtcpWJsjBCC20ZGp5+hT6TLlMCI
         TcAg==
X-Forwarded-Encrypted: i=1; AJvYcCXNfWeuons6ME8ZUdyc44JrJchXpeF2k4w8qGiDpYmoqVCrXFQ5XSsLdseG3EMd2a1qhiunBldy4UKn@vger.kernel.org
X-Gm-Message-State: AOJu0Yzb7Q/B1OE1h/vMhKHXeTTkgtRi0ocgzO7TwCtl+v/IgWgQ4YQu
	7ILS617p34KlAUjuYBwQGsQoW1wXUTOLlGVR4c/xnOwSimMkwADtWRAioW8pdCA42uro8K75FKo
	Dw5XFQsl0AtSpVC3C0nhSxhyYcGfSPVdCCcTahnAy
X-Gm-Gg: ATEYQzybyDVQuLgq/Q/txccnRPu7I/3Pl4ddijNzZYvQuBPeU3LxIaNJ8Io3Mr9UIIC
	fC8hFnXB6nlg3W4+55t6XRof4SePeOih7sinmkLfNeGPl42Yrq25erwudgj7j4JDcdH8QGWb4X0
	+7GYUiJNwBWN7J8UdRaVSEapzN+nrk5gfdbOiDfUAHQhGGFiTtGCaSepPljRFprGmlQwmdRLMD1
	ihkbo8toPSbTJxu/jWP/F02V8ryy0eBA7fqqgDmANxNrJuYv8RvjooHk63hlOgfJuUaYJ+jtXv5
	LX3unq1Zng==
X-Received: by 2002:ac2:4427:0:b0:5a1:3134:9bac with SMTP id
 2adb3069b0e04-5a156cbd1bbmr169453e87.28.1773194852284; Tue, 10 Mar 2026
 19:07:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-56-bd63b656022d@avm.de>
From: Chen-Yu Tsai <wenst@chromium.org>
Date: Wed, 11 Mar 2026 11:07:21 +0900
X-Gm-Features: AaiRm5028PWt8n-JnveiRgn8oYMksdR_-_nk4JOkvxMfplWs-GDr7RRk-OxICyw
Message-ID: <CAGXv+5FQAVaJjqhv+Xq-ysOc4SHQn2mCNTgCAp8XocmWBWGGoA@mail.gmail.com>
Subject: Re: [PATCH 56/61] clk: Prefer IS_ERR_OR_NULL over manual NULL check
To: Philipp Hahn <phahn-oss@avm.de>
Cc: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
	bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
	dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
	gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
	intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-clk@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-leds@vger.kernel.org, 
	linux-media@vger.kernel.org, linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
	linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
	linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
	linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	samba-technical@lists.samba.org, sched-ext@lists.linux.dev, 
	target-devel@vger.kernel.org, tipc-discussion@lists.sourceforge.net, 
	v9fs@lists.linux.dev, Michael Turquette <mturquette@baylibre.com>, 
	Stephen Boyd <sboyd@kernel.org>, Daniel Lezcano <daniel.lezcano@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 9:57=E2=80=AFPM Philipp Hahn <phahn-oss@avm.de> wro=
te:
>
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Semantich change: Previously the code only printed the warning on error,
> but not when the pointer was NULL. Now the warning is printed in both
> cases!
>
> Change found with coccinelle.
>
> To: Michael Turquette <mturquette@baylibre.com>
> To: Stephen Boyd <sboyd@kernel.org>
> To: Daniel Lezcano <daniel.lezcano@kernel.org>
> To: Thomas Gleixner <tglx@kernel.org>
> Cc: linux-clk@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
> ---
>  drivers/clk/clk.c               | 4 ++--
>  drivers/clocksource/timer-pxa.c | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 47093cda9df32223c1120c3710261296027c4cd3..35146e3869a7dd93741d10b72=
23d4488a9216ed1 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -4558,7 +4558,7 @@ void clk_unregister(struct clk *clk)
>         unsigned long flags;
>         const struct clk_ops *ops;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))
>                 return;
>
>         clk_debug_unregister(clk->core);
> @@ -4744,7 +4744,7 @@ void __clk_put(struct clk *clk)
>  {
>         struct module *owner;
>
> -       if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
> +       if (WARN_ON_ONCE(IS_ERR_OR_NULL(clk)))

clk_get_optional() returns NULL if the clk isn't present.

Drivers would just pass this to clk_put(). Your change here would cause
this pattern to emit a very big warning.

I don't think this change should be landed.


ChenYu

>                 return;
>
>         clk_prepare_lock();
> diff --git a/drivers/clocksource/timer-pxa.c b/drivers/clocksource/timer-=
pxa.c
> index 7ad0e5adb2ffac4125c34710fc67f4b45f30331d..f65fb0b7fc318b766227e5e7a=
4c0fb08ba11c8f9 100644
> --- a/drivers/clocksource/timer-pxa.c
> +++ b/drivers/clocksource/timer-pxa.c
> @@ -218,7 +218,7 @@ void __init pxa_timer_nodt_init(int irq, void __iomem=
 *base)
>
>         timer_base =3D base;
>         clk =3D clk_get(NULL, "OSTIMER0");
> -       if (clk && !IS_ERR(clk)) {
> +       if (!IS_ERR_OR_NULL(clk)) {
>                 clk_prepare_enable(clk);
>                 pxa_timer_common_init(irq, clk_get_rate(clk));
>         } else {
>
> --
> 2.43.0
>
>

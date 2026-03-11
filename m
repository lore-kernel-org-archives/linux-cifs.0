Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C61242D72
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 13:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773235321; cv=none; b=H8i1Onphb8jveuOXqvv1BObYHTLw7QVW9xoXHo2v2yZyhWnw3q9Sp+F8PznhBaznK9i5wZzmEG84TwPy13QuRZApLJeqT1/VsyMti6+5ikmEQEjW66NLmTYrokYHHoBMbpFa6+A7OzPFZlyn8FlANDCcQy0iCEpkFM2phAd8xx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773235321; c=relaxed/simple;
	bh=bQRlE5OR+3/41N9B/xBGXfMeOTv3hgeQ2WrY6jcTpBY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFgvAjCgxgIt5rC282KfXVTB2ysKNKW0WshUkSaekw0MkEF5fgcIH999gequ6O/qUbaLpIOKWDd3eE6YpVhACltyVmeC6MVGLR8NYwzd3xsrMucGdKKcTAad84kuHdMGr+XQf2iB289U5wQt+wYbtOwrxy1oaY1zI5edmCxk1/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5675d609621so11791156e0c.2
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 06:22:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773235320; x=1773840120;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34DR94e/1PAvLLEaib58vFA4GW0m5SGe6jvxchEhMek=;
        b=uB9BquRDLahBIbZvw1A+UKV34Hlr60e9hgV1JtLOVFgu53PiH4BsDNx7t/ii3LEzHa
         QaykUuMNRyDDlL5j/OHkYA7WRDLiM+Rpqx5AR0FPUJTTs3h3EaLzBSkrQsgAarbr/fNv
         dYVbOpZT7zEXRNpUsyDXzpbCMpFEBXq8FZhS221Z0DxFzFtBS6cX+Yw1JXJbZFLA9jjc
         ieWhBwk4CUKrQJhuEPDUv18mT0qbVFfLefVwmnCkl2Cut6Ghmj9khIb6FQYxhqyo/RKX
         piw/O+7Nsa40c2f5Ayd5bpvj9vjg5xhKXqreHErpIUgIS7AYkR/JMXg0QrWkAQAYHw4K
         A1+Q==
X-Forwarded-Encrypted: i=1; AJvYcCX6HWeuho/B9b+84ublEw2bs1/atXna8QLmu2qgqZPaqhmlT3IE8cnany+VoXatR6F0MtiLyYPS5quY@vger.kernel.org
X-Gm-Message-State: AOJu0YxVZnpXCzCvStJoPYhNhGXktHMSyWSdwnDaMUaKBZIZaWNiNL6G
	pUVDg1Mp9xhxvpQGHMNZ2bhueKlNthH7r9CVwRznQULkluaKA4sE3J6+lgkCDB3lIsw=
X-Gm-Gg: ATEYQzxrQMCur2HQd/nbGSkw6XVCrLP2+W1QfGWajagpZZLQNxh8E5+RFAPJMqmRS1R
	tQNNrvNyiSVZJVLVmpRwh1/WW27HDYUrYrUAIuKYCZPf8E7l0ibq7WX1iQsP7gOA8IVIh1SH1D1
	W9DLigVZhThne+cmFb7C3qaWPSl25/o6SSq5M2H34HudrOAHGBaMTobLaN/oPJH+t9w+/xF0Z06
	ON21L+B5MuHCJZilXuYiaHKkvEK1zDFya7u3VJy6b+H0JHev8DdR0O4Snz/aQTXxClAX3LLLFg7
	8A17Jr2QVf4nqnTat19eSIW/Sr6JZDgsyjDSWZao6fYYbhQALK/ObiU/hS9TnMOt/BQGuioPlTG
	pmUhrzg6OYWwhdO3tEdY6yrsHJqnqCMRMFq0sX2PahCYj40OJRMrdRORGUuoliiOb3ONEGRCP4k
	8/fyf1a6os1xWJsO4mtTG9xzAigl5n1WNdbmpiO4OpR1N4dmMlW9CAxfqcO5fi
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id 71dfb90a1353d-56b4752d806mr930759e0c.10.1773235319757;
        Wed, 11 Mar 2026 06:21:59 -0700 (PDT)
Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com. [209.85.222.45])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56b4645d11csm902071e0c.12.2026.03.11.06.21.59
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 06:21:59 -0700 (PDT)
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-94dd0f3c4b7so8222190241.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 06:21:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVgKGQyaLzQhojSgoV75nWt1AArf+HeEFwIi4lJIOKyeaqihF+/KqHfM0Oap8JsGQCc4Lh//5z6aKQL@vger.kernel.org
X-Received: by 2002:a05:6122:1d05:b0:55b:7494:177b with SMTP id
 71dfb90a1353d-56b4752d806mr922396e0c.10.1773234967338; Wed, 11 Mar 2026
 06:16:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de> <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-36-bd63b656022d@avm.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 14:15:56 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
X-Gm-Features: AaiRm52J84H77ROK64ZWWtJfaiCpnFeKyoSRmPbi-NC8CN6Ju1TJEFxJU9gZQQ8
Message-ID: <CAMuHMdXQ8Q4jvkgFRJYhghz2BZRDC-9Mk6DbXxuaOc6C9DFHZQ@mail.gmail.com>
Subject: Re: [PATCH 36/61] arch/sh: Prefer IS_ERR_OR_NULL over manual NULL check
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
	v9fs@lists.linux.dev, Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 10 Mar 2026 at 12:56, Philipp Hahn <phahn-oss@avm.de> wrote:
> Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
> check.
>
> Change generated with coccinelle.
>
> To: Yoshinori Sato <ysato@users.sourceforge.jp>
> To: Rich Felker <dalias@libc.org>
> To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> Cc: linux-sh@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Philipp Hahn <phahn-oss@avm.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

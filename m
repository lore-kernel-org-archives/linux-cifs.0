Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F762FDC3C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 14:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773238455; cv=none; b=O3b8NOhnfAKb3OqiPi2L73iWrPMeaoWkk41blAbn/XVrZOzO6ckio4G86ibuz1yhEgLDDgd011C7jradS5ycbUMmbahUs2LEYNTejs4L282M2IqHzfvmpS6huYt7mWgLjy2Wn//f4agiF2UlpWrSvBAQc44VU0JOhpc/IxpPfN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773238455; c=relaxed/simple;
	bh=POUJjzeRhBIXfPGojdZfC417KH92loTKx1KmDpRcfoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l+k1t82Mg3zMRnbeaIzg7e+V2VCtlN9VrBYuT3xV3CRvd/Lzv0Uw7EC9jBc+bA+d3wzyfkxsd1oS+hCVuylt7Vk/auKbGmjFiVZp3vchEwUZtmVq9QdTzNDfWaRYXZj854Nhmh+I+4K16h5KE7eqARdztRII2MZwf322rqEhBKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-66325f30570so986816a12.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 07:14:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773238452; x=1773843252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIz9Fr5w5J45ZN4rxwvT/0kjXMGfLP1VpB2aKPOax7k=;
        b=kp3vgftDfvuAZlTeI5XXjy+lNUdpq+ZCh0L/On/4tKkbQPfsZl2VNESlyfQMIQgGWb
         IMRoCXRiTas028zwlZThNFEVvR/eya49B83SrgKqNE9Uz7OdKFoPmfjPFTnQXX1YmYNR
         XuNWRkUSxxIPqsS68bFOocW3Zb58v/jrw56we/mVkkjJ0R9RyNb2++P+8vwMARQgQn3X
         YZ3VvDWUDJbVtlkHZ1J2lAlK+8Z7ep3omKhm970XDLKACJstThijcRKgqy4rd1/3+M6r
         M6tE3jaR45cLuBrgwwn8kbSV6eAZtf2fUvV5X2k9SAOWBZuZgCXbiWCrhkXCAUSDrpRJ
         JrIw==
X-Forwarded-Encrypted: i=1; AJvYcCVU7PcAazYGqYzYhP5bCbJMWXPhK6YJQJhvaES6sqHmhLWlcWJrE+PWJtSrwQp2Ijrl5Tv5pGmrl9nk@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtzbdw91EyIuSTFQNHTmohst2xoaofDhNAEFxiAdrEw9D5qEnk
	9B/6fvL+EPFlnkH55x37urgjYjgnbuM3dLuD8zaHMz4IshEiHkkpCeh/1iSKn0bCmka9kQ==
X-Gm-Gg: ATEYQzxKuy//lBgsWfg2+CyyJy9RCmcV+2HLmrOnm9CtmTOSoxFP8eiTRxFogEISzqb
	svJeBt9DFK5y7fkpnbOil9ZoZh/Hzdu0qviLb1pNUy3yRelOCeLW6uY1jrDeMQm8EgQrY9DDbPb
	+DK/eAB4DYR1NIxowVilfVMUqXzOsU3xg9XykqPAghviW3+0Ez3pe5LZGjA5DB/1CvPPkYkDEez
	LiQVNtIKdc9n6rWlUGmx6xEbUChONoMnOpN6LBJtpkoaTbyKyNehLjyRh4R/2pMlbtWsnXnJ+GI
	OxM5EbcuOEtpzPhi/ICA7fnWaQ0WE7iIk20hzLi92NHkflhNO7/XL0DbUzs8MgSwSzC+BRUK/Fu
	2XA1g1hUXBGPpqjDy93GGaQw0I7gOjrfq+XjP6+7PilgncjVMNJliKVlTGTAP9i3Tsf2bZGcE3U
	2+GXijeekkEpzv83tRgPOe01Ixh1uSO/b96O2VI61rMRAtp8v2mT6uwmET+fQh
X-Received: by 2002:a05:6402:a2cf:10b0:649:19bf:bba1 with SMTP id 4fb4d7f45d1cf-662ba944685mr3094330a12.17.1773238452146;
        Wed, 11 Mar 2026 07:14:12 -0700 (PDT)
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com. [209.85.208.51])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-663153216b6sm557726a12.23.2026.03.11.07.14.10
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2026 07:14:10 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-66174cf4549so2117497a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 07:14:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVox7oGvUjMN8FFwHRh5WAN1PxlGBKtqbnwXvuR42wruyuAQ0iz/8Bgf6bTEKf8sjH4Sp7fcjl8/AFb@vger.kernel.org
X-Received: by 2002:a17:907:6d16:b0:b88:4f25:81da with SMTP id
 a640c23a62f3a-b97113ff0b9mr462021166b.0.1773237981235; Wed, 11 Mar 2026
 07:06:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
 <20260310-b4-is_err_or_null-v1-15-bd63b656022d@avm.de> <20260310100750.303af303@gandalf.local.home>
 <20260311141332.b611237d36b61b2409e66cb3@kernel.org> <20260311100332.6a2ce4b1@gandalf.local.home>
In-Reply-To: <20260311100332.6a2ce4b1@gandalf.local.home>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 11 Mar 2026 15:06:07 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
X-Gm-Features: AaiRm53WEGMMLW4z34e7P-lM1qFvsCJGZ_o4JNL5NPWbhJPKmcqz6k9bJcyL--8
Message-ID: <CAMuHMdX4kRGLaKMzPuhS1Pmxh609eiqQW-cAS_jWBBbt-vE6SA@mail.gmail.com>
Subject: Re: [PATCH 15/61] trace: Prefer IS_ERR_OR_NULL over manual NULL check
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Philipp Hahn <phahn-oss@avm.de>, amd-gfx@lists.freedesktop.org, 
	apparmor@lists.ubuntu.com, bpf@vger.kernel.org, ceph-devel@vger.kernel.org, 
	cocci@inria.fr, dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
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
	v9fs@lists.linux.dev, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset="UTF-8"

Hi Steven,

On Wed, 11 Mar 2026 at 15:03, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Wed, 11 Mar 2026 14:13:32 +0900
> Masami Hiramatsu (Google) <mhiramat@kernel.org> wrote:
>
> > Hmm, now IS_ERR_OR_NULL() is an inline function, so it is safe.
> > But if you want to use IS_ERR_OR_NULL() here, it will be better something like
> >
> > node = rhashtable_walk_next(&iter);
> > while (!IS_ERR_OR_NULL(node)) {
> >       fprobe_remove_node_in_module(mod, node, &alist);
> >       node = rhashtable_walk_next(&iter);
> > }
>
> But now you need to have a duplicate code in order to acquire "node"
>
> I think the patch just makes the code worse.

Obviously we need a new for_each_*() helper hiding all the gory internals?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

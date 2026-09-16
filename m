Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75B3509F1E
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 13:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789566761; cv=none; b=SokNU70iSJvytko8M1SgxBf2wAIO1UyecdBDizCv1HH7856Zxep6idrwhr9xHXAk8SA6pmz50GTyXi7kiEU59rmuMee0LXq1IO2lu6zfFH6ZSQUwPPkBYMgra064+C4R81b8HtzdmmqSEEOu5usRJXXuL6+X87aAjUowzN9r59M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789566761; c=relaxed/simple;
	bh=awVq26HSvYrQw8zZjQpltR+Ovm928+m5vq7+B3VCkqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=buXtQZ2nsjW7vXbaufhWk2OKjHBayFCfxXq5xglVDtU13TSY1x+vAC959E/aEbhfRDaiB6/PgJozC9TWqB4wPI9Im9Idanz2eoVNV2QxiYVFiOySIGoYppDzjQdUkKqrXmaGRibnd3vw1lgHX0kcOepRRUikWtRcYKJxoUmNW70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IiafGwwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IiafGwwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527DC1F0089A
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 13:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789566756;
	bh=tVfvozavmgY5vrjkSXQVGgkZZ+3YXHRBUplPz8k6vrw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IiafGwwIRQV/O8Q5Uw1sGcXCWbYYX5USjfo4LYTHpwrLTXnULrtB35MM6rD83lxDj
	 headwz3ThHI2dHSSYRzvvYXf4wPH802yRBj18ryP5YRuO3dtyt1bRIjBfMgOOdcjra
	 G6YrgkljskaiBpYhhMdTUG8zRrqrfsqRagC4jfgj+31CQrjhECVNsPcWVEFK67qts4
	 LT5fKKdeSesp6I5jEj0gU9h8BbLqsRbFz1LBCpMZ0AdAnL4iCG2ds6eDyi9f9llVhh
	 cqtwCCqP4vgEEQbBfKzZMEoP6abSMRWJCvhfVgtJcjGWedyUdlek++Kht7a90OT0LA
	 oazOoMgoteg3w==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f705536so212124466b.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 06:52:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwW7DR7ouhWkyuOwowNZUapuOHJPp7NuYakbY+eEVMXJ9T+3dHAWrO6fky/5KU5UY6lxlMUiWWylsWO@vger.kernel.org
X-Gm-Message-State: AFuF++nfWnCkEMvDxnpopj41pxHOzAWKWsp0kMMH6z9oBSpSPMzPaA9w
	oxqSgOZ0MKqI/6LFCu4XtgNNSdQ+7a+/0Mvc9tNb8NsHtsEHR8Nw3UEUcV/f8/SpGxytDN+J3wi
	q4ExFVJxgc+BA/lcc31ETmyjFPFXFkyk=
X-Received: by 2002:a17:907:9613:b0:c25:62db:772b with SMTP id
 a640c23a62f3a-c29e51e1cdcmr177216266b.7.1789566754971; Wed, 16 Sep 2026
 06:52:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260915064657.110687-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 16 Sep 2026 22:52:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd86rboXRCxK+nO-pXBnvMvHMt56h0Y9HmPqFW82zApjaQ@mail.gmail.com>
X-Gm-Features: AcwNN1WRU1Pbmr29KlJQTvWhf3p1IdXWVJCYtP55sC7WSlPKBzeLJ976eEqhRD8
Message-ID: <CAKYAXd86rboXRCxK+nO-pXBnvMvHMt56h0Y9HmPqFW82zApjaQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] smb/server: fix some bugs in file name information handling
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:47=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> ChenXiaoSong (3):
>   smb/server: fix trailing period in generated short names
>   smb/server: align partial normalized name responses to UTF-16
>   smb/server: rename smb2_file_alt_name_info to smb2_file_name_info
Applied them to #ksmbd-for-next.
Thanks!

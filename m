Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B420F385D72
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787212184; cv=none; b=mKY/pJK8f0aHZAlP8n4tDBxEINWtl8qjiMOJZYjeVKRviqhupEwue6tmyszZR9iOphj8zNqy/BhfmSROTfZGPoz57v19K2YaqgebrTt+QzSsqJiUZq6Qq2RS2cjMm5UGrgH4nIBIEFcNxNeAl2F21tMnvVdDpj8jt58wcYPh6NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787212184; c=relaxed/simple;
	bh=tQtbr98MUgNOvoah/2UQPXpjjrrla4zv7AwxDLCld8I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XFSmQ5CXN+SqkSh5KRA4hT06nom1Nv6x3J4KoGz3dCZpoW1nsKl5ScSuSJoHdjHprE3eTQorvIZQR/pymPKqBqqDMoxpcbiReEK5cU5WdChqnjctnUsQowyKUg94ShDTxG42zmC6daY032NgzCYkLCFvNxGsjG7HrGoIxtUbpmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfhEyaDy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfhEyaDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595881F00A3D
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 07:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787212182;
	bh=tQtbr98MUgNOvoah/2UQPXpjjrrla4zv7AwxDLCld8I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GfhEyaDyH+WzWiCiVitbm9Vzir9sgJ/qAxR/QAr/s7ckpaz2DaaukqNJc5czzwdjs
	 xCjfI3T07YKDTZxihpu2hnXz2Sr+8sPie3a5diJJJTm/r4kjOFsSpNE6wuvEhDkUld
	 tyY4E/IVwOzlL3JWQ8pcAo4UxQVSGTQwt39I16K3ThTbPOvjFiMre2Khs/fDCiVMg3
	 ZNWUHH2/U6thd4bdX0S6mI5rpdkKlf8/eWvdpQh2InTyLz9xq62DRh4EEaZReMH7Kb
	 cq4ubwxr6qEhq9GlD7Yf4Z58Rux817Ks1rWMiGkwwJxjWTgKKKNy7V2Xi+7jFCSxNI
	 1LkA1vpC+wVMw==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a3efa2b38aso3276104a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 00:49:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rolm3J2xwI7w8QciqLLq3FbfstI0tvT0vK+jRv4i9urkg3twiYLF0OVkDKZqGsgOOnkBDaem04d2DWx@vger.kernel.org
X-Gm-Message-State: AOJu0YyS7IIQjnCuuanrP+msA1mtHuN8ByL81vIYlDEEAo5x8fn0Q2EF
	rIafmfqclQ3QEeJxkI0C6JpF9u+unSH0qVA1Vimu+8J+ROXrKGkIE97RiDa3C2UOrBNpqWQs+0M
	/R9tlhVnybODKGCGsxyeGg/9swP0iOrs=
X-Received: by 2002:a17:907:9611:b0:c20:eeaa:ec85 with SMTP id
 a640c23a62f3a-c242e254afemr621904166b.17.1787212181030; Thu, 20 Aug 2026
 00:49:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260819071224.527479-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260819071224.527479-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 20 Aug 2026 16:49:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8YX60A56=epLx7s=ejwX+Cxw1=BKPAFfw0dZZ6LKvoXA@mail.gmail.com>
X-Gm-Features: AcwNN1XYtrK0tt0cgfwMGFg6EiSFOBFIktOrUoooZzDDj7_OXgEDWgYx-ISrnrI
Message-ID: <CAKYAXd8YX60A56=epLx7s=ejwX+Cxw1=BKPAFfw0dZZ6LKvoXA@mail.gmail.com>
Subject: Re: [PATCH v2] MAINTAINERS: add myself as KSMBD reviewer
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 19, 2026 at 4:12=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> I and my team have been working on KSMBD development, and I am also
> interested in helping maintain this code.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!

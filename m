Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EB82253AB
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766977094; cv=none; b=ZbQEX0+rVBBo9IcmX0XnvLx22/qNotAy2GU0S1bUi2FK3qUvkwlGuJbgzse2sVZmCFVtaZAw8EiLwBWkpdHZDWHne6llUdKDSC74QrshCsKID+LJwUmT0xB0YXYdR7tnp6qLQmPmV9Fq55yqIFU56q+UE5Dk5T2xMs1jxqZ33Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766977094; c=relaxed/simple;
	bh=n7tQv8kRoDSLAaheMQ7iAaJ+gYclyWzg2toNgzQJLyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PXlbQYztXhaxGtSJaHoFrUq1pgzPEvk4YPqwvnmLIi+9GvvAraTZp1w6fby3kresg1XAwvjXZ4w1DZxS97SerP7hLRV9JhnJ2+y3japraYU5I687XBaZPurGj1SkyKCZEa0q3wc8RJJ65VxME3O4K3ez6aJKpCu+lBYxUFecSSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hd9Ce3Al; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hd9Ce3Al"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF22AC16AAE
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766977093;
	bh=n7tQv8kRoDSLAaheMQ7iAaJ+gYclyWzg2toNgzQJLyA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hd9Ce3Alyn/i7jtgPliRGaJK0tvre6+9L01FVyrp6QtI5I8vHnRmPqmyis5Vr2sms
	 wgrkTltJBCGH6cysTTLWx2sySHt7uMCCpawZL6IroS8URi+ZSvB0JI29pYrjv6Raf7
	 UX6fZ4ACnMVkcli6TqYxKChrKp19ibE+o+XoyrgnampLFvV04KvV59Yi9oAr6IDXLf
	 OZT7fkP15BfxBPiisYhalxmpV3Ob2YMRxu2Km7zGY415p7z0xNj5+/fNPwKzxzz1oc
	 HFo48zCFq76VceTjNELDxCP+zeKH726WSGSaREoA1pLkDKGtXhBIWAt0LDh/z7tWxo
	 18j6n3yJPgqaQ==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7ce5d6627dso1519493266b.2
        for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 18:58:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVKi7cszpvLlkeDxwPdos+urX2KYxHk7XgEtjkrafX+I9QLMqYXOAfarJ+U5A6KaUeIVYsKz3w6dCxr@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp7h3fSEZzuw+YkoSyJdnwXr1+Uude0E93I2iOFkOTGvdbOPgW
	0OiFR7u4sq4N8ySrVafAMAts5T1h5b+Yj3XZOdQV8W++dYVYsssJMNB+mT4gJe/HZbHDvM86Hn4
	yO5ODy5+E/n4T1PcbV+Qp+gI1Qt2+7YQ=
X-Google-Smtp-Source: AGHT+IFxYoPWsBYuuaeRnJe04FVpajPFOfyllXgpksePOc16Sn5C9GSOc4qiCLMHBVVldHSk5HwIW5QqmMWaKEHtaiE=
X-Received: by 2002:a17:906:3d22:b0:b80:4119:2436 with SMTP id
 a640c23a62f3a-b80411924c1mr1958637866b.7.1766977091589; Sun, 28 Dec 2025
 18:58:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev> <20251229021330.1026506-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229021330.1026506-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 29 Dec 2025 11:57:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-K+kfHy3KBMcPjUhmoCV-=RwCATBJK1+kvyczbzySU2w@mail.gmail.com>
X-Gm-Features: AQt7F2qezkEyXpEG4SbmgLyu5CA2enSoA4PGM-CDzQPJnwLo-Mnid4uVmTfKKPQ
Message-ID: <CAKYAXd-K+kfHy3KBMcPjUhmoCV-=RwCATBJK1+kvyczbzySU2w@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb/server: fix refcount leak in parse_durable_handle_context()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 11:15=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> When the command is a replay operation and -ENOEXEC is returned,
> the refcount of ksmbd_file must be released.
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!

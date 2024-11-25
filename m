Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C71336D
	for <linux-cifs@vger.kernel.org>; Mon, 25 Nov 2024 01:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732497557; cv=none; b=Fz3Clmvoh36cU+xtwj/2rbIeWSu9FrlVewSZfRzUp7ALSNNLPXpiwo3tcXIwn+TFGkblq5RdKIsopWCcsi1ps6NfJJslzVyQmlZvPzq0+ev/+T+eRSO1kFKDDVRjcUJCY8k2I37IsXMcuE2VdMcDWtpDVfrlG57mwFoqNgqFM64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732497557; c=relaxed/simple;
	bh=5REnBKsbu9dhPP0a7hb6d9SPJFeGbmJ1vCeTvyiQONE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jUSbjNCEtZ93WAI5OJOLdkzPpcrUwMAN7rKdMwy0NSP86uVFTwrvhWytxBsCTCxagYbiUQgHFwPot/uFjIFy71fQJ+r+qtl8H3OuM8DiUi+Si7Tbb5NUuBcFeF9aPaxlUF3TGAL3RbdXhjekcktLZkcgTgrEpPYrh5uITN5aCos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GXRvuY8v; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GXRvuY8v"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53dde4f0f23so1004008e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 24 Nov 2024 17:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732497553; x=1733102353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qexvsLcoW9zE3mmFWDdvWHsfQto1Xwdffzfj51luljs=;
        b=GXRvuY8vR+ubIwa6KENKVBpXq6cRVOJ+S72SGIYw3h+kMYKFNFesU4yvWw3erlUL1U
         LC5NqgNdCIfoJCdnE35W1QOlMknVaozjb1KT9DX0TU7YvnysB8HR0etLzWBsbBbz3+eU
         7ZLPNeoEImh0Vzk3fiZXxkbf36SmNrz50e4EKIwaHMzp0W4YDzI2IA523JGy8vY7JQGi
         sXi4P60ZN3lR+aJBrDID4uuQlaqmlL4nNpYDdc47rQlSiIAqNJRFzdPgZAAw6qjit9lW
         OJSHkxZvFwxVXuovb/JsmcqOGldXjp6yxIzBs5f5xumMBmp1K7YqKjY/Bs4q2xM5zUIF
         nNGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732497553; x=1733102353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qexvsLcoW9zE3mmFWDdvWHsfQto1Xwdffzfj51luljs=;
        b=uevvOXEPcA8eo2aPLPUWShU+TvjCbhQ+G+dMzStMxKuK0xVdMNflLTHWKxn4bP7PSW
         zSDxRv8pcg4QueXofWNrCnDyeZJ0hHAtcKKvGuf+weJ1ar5MBiWAp7NKySrZ+ehw21Wf
         l7gHlwxURtN3UlToD7mU1szlDOhBWRAESCOTIkiavXRK2Re8gqE8jzyymlCaxvQhCn6L
         9SucsDo9cAJNSM4XVxWJ+sCmgBhunLUQG2RmOScki4gxE1oEuEuC8p24PxEYoaWU9T4a
         8ZX7QGiPCL8fNRnAqmkBnoZ4smdgF3o9oMG2ocn3Xbs4UiXb4r9DsDM9snDhYxreJlEn
         CwHA==
X-Forwarded-Encrypted: i=1; AJvYcCWE+LE0EqoKqsa3R65UZyLFZC52IfznH1zhYlCxvFvsqc6I+N5JS40IrBUBnEa/+SJk/Nm2WE8VYMkp@vger.kernel.org
X-Gm-Message-State: AOJu0Ywl+z8iu3kvUwZyFAbZgdJpcdxW3GIJmo3CvjgByUN4PE5NbG33
	bdraZC2FbIi/8JoGRtJQqhM0Njed6w6Xwwbc92ZHMfE1lSP+w5c2CCLmwqzV8zMWKJjHBdTBTzQ
	600Y5IAk7BQYc2mfPBa/m8lmAvMU=
X-Gm-Gg: ASbGncvdSETwRGkvOGBLe1GIzw/ATX8lLuICrJmXgZk5kep8s5xTrnyXX+hFM5aSsYj
	6EoDVyh8JKSUoLwPydQn2VfMYnzk0VlXKVWW3z4q11aAGarAPmQw2lcYudiRdQ2Kc
X-Google-Smtp-Source: AGHT+IFGK4ciuVBZPt0Kj36tbNEIX0lNZu+HhFiAZMHFy30KO5uRw/w7pfwT7aQV90UEnEGhGkfhyfGUuGeN24tXngE=
X-Received: by 2002:a05:6512:239f:b0:53d:e57e:dd4a with SMTP id
 2adb3069b0e04-53de57edd9cmr135151e87.22.1732497553266; Sun, 24 Nov 2024
 17:19:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123011437.375637-1-henrique.carvalho@suse.com> <1759723155478fb008c3b36bdd07c63f@manguebit.com>
In-Reply-To: <1759723155478fb008c3b36bdd07c63f@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 24 Nov 2024 19:19:02 -0600
Message-ID: <CAH2r5mscAw9k_-r3_uqO4E3hMiNuxENTHjGzygPjpTOeKfrC6A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] smb: client: disable directory caching when
 dir_cache_timeout is zero
To: Paulo Alcantara <pc@manguebit.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org, ematsumiya@suse.de, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added the reviewed-by for these three. Testing seems to be going ok on
these so far - let me know if any updates or missed/new patches

On Sun, Nov 24, 2024 at 4:14=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Henrique Carvalho <henrique.carvalho@suse.com> writes:
>
> > Setting dir_cache_timeout to zero should disable the caching of
> > directory contents. Currently, even when dir_cache_timeout is zero,
> > some caching related functions are still invoked, which is unintended
> > behavior.
> >
> > Fix the issue by setting tcon->nohandlecache to true when
> > dir_cache_timeout is zero, ensuring that directory handle caching
> > is properly disabled.
> >
> > Fixes: 238b351d0935 ("smb3: allow controlling length of time directory =
entries are cached with dir leases")
> > Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> > ---
> > V1 -> V2: Split patch and addressed review comments
> >
> >  fs/smb/client/connect.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
>


--=20
Thanks,

Steve

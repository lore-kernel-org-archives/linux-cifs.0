Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E981527B1;
	Tue, 22 Oct 2024 22:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729635703; cv=none; b=q/SU1V27wJerWYINqbrCmeU4OYcJjbnfXJOp6/yGCBk3573sXZBAzretIAcvK1kSuQqfrBhjhvYqXvtboQCgCpo/Bm4vOqZ/kCmD8b7GzyoHrj92iNTIfwUMN3BDd3+FleCM1wuwPSuNLuCHPZzkxaEDxly9f7r3bVrvn+kyrQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729635703; c=relaxed/simple;
	bh=JFE08dluIaiarxL21dzPDO6HbXbk9HvWUlkanoq8sYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCqyLJrGcb/ykduEV0gJLJXjhyaQbXVH/BqBB0ix/zZi7llNKL0aQ3+HKPy7HyVQWRvJwqAine7+a+jEqwAszHL+EYc16/V1PFUj2zjs6OdYKKBohjUje2cnmbbp3RphRaDOm+MUK0tEFhOSVhNUe3a/N+0WT+bHvboLWIhbXV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZ0nYv0w; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ0nYv0w"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-539e63c8678so7500523e87.0;
        Tue, 22 Oct 2024 15:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729635699; x=1730240499; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kgBh57DSw/h+OTaq/JFTaRyo9BI9dYA6G3zBw7DQ+M=;
        b=FZ0nYv0w0OfGVKM4pj6Cn5W3zUxIdfOijLzWLJhGNEdPl9XIEs+DJr8R3MBB2wjY/K
         lyMQmbBQYDQmVMBECZ5+UNlEgANCRPSxHJzatxGCw+pf6ZkYO/WroHacO/vF3AibhKfO
         2feqvTb/w2bQlwTpisaw2J3uuF26UjO9rc7v5JURiI8TNOborqOco7+6TVTIS058G0q9
         EYl0sORRZl6XNpQsOUbXm/gd8uomyKz1x7pTcvuDUU0bCAK8YkDc2xQlMIcihJJf9n/T
         lkHTxQNprJuLMYvhwAnNYbugeQyE5wFzJDnmyTwwhGO/N0hciT3q+kF89AYb1Ue0wzeT
         6E2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729635699; x=1730240499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9kgBh57DSw/h+OTaq/JFTaRyo9BI9dYA6G3zBw7DQ+M=;
        b=vJk0oy+Odtbt/qAqhelq4lKftGVlPQ7guDarNst83IzQipYc55URos8Ip3yaqvTiwP
         feM/cjAAJ0YiMcQkgdP8KR9ekFcsETIhe6/mqmzxt7Yy9yWvRpLD7xx72VxJ+B0tZ6R1
         9fJL9fs4hO52CPTMskrjbByr8w7cJo27Lm8dh/Te4pUsRDp6+Scv/abifK6/NlPfqMbM
         2mFzf5A4TEOsVN5t21Zs1Pa9xw8wIrtbUYiLfHQYgClTrjrTWMx5JpQj7LjRiTXX7j7V
         i+KdqDpP71PgODaxC2TLf7AkvbvyZt0vvck9pz97A8qvT3Hqr7yaHEG+RNo23KPvot73
         VyvA==
X-Forwarded-Encrypted: i=1; AJvYcCUFKt4B1yQ+wn/WbdDuNv0qIkIvQk7HQYBojhusVMmeGls8TDmA47ZuBoZncsWGykf4mD6zbhfS7SErig==@vger.kernel.org, AJvYcCWBXfM5zhMn2U1FBQ1QASkAQmKFqG9dLq7t+WvioxkxKKX3DB4XEd24Eg1ercSSZuY3OReZB2/nRbVkCQy9IsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7wkSTEwntP0bO8I6wkmDFFBNLAGwgU0KxV4IXc5/r81AcnMPb
	xDzzJgGWijoWzcW+ln5I72y3qpCV+XZxJJC/Jk6fCyt88zD/OhfetvRHGTGzzgdMYanlwERH8Q1
	+IFjjTB//QnNlHDEABxa93RBdV/4=
X-Google-Smtp-Source: AGHT+IE8lJvrh9YOTJ10anJKfHxrcIxLlvMcvR97sr2y6uBbugwAOCpM3iaIuIM+6ijv7YXCjo6Mf0kfgiOWCdBIxsM=
X-Received: by 2002:a05:6512:2393:b0:536:a564:fd48 with SMTP id
 2adb3069b0e04-53b1a2f4d0cmr216189e87.3.1729635699166; Tue, 22 Oct 2024
 15:21:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241022171515.3330183-1-henrique.carvalho@suse.com> <20241022182126.3353440-1-henrique.carvalho@suse.com>
In-Reply-To: <20241022182126.3353440-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 22 Oct 2024 17:21:27 -0500
Message-ID: <CAH2r5mv+qUw=zJY85S4gQitafHXY6RaVPOqY5ZR_RXpF_Zqf3w@mail.gmail.com>
Subject: Re: [PATCH v3] smb: client: Handle kstrdup failures for passwords
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, bharathsm@microsoft.com, ematsumiya@suse.de, 
	kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org, 
	make24@iscas.ac.cn, markus.elfring@web.de, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending review and more testi=
ng

On Tue, Oct 22, 2024 at 1:22=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> In smb3_reconfigure(), after duplicating ctx->password and
> ctx->password2 with kstrdup(), we need to check for allocation
> failures.
>
> If ses->password allocation fails, return -ENOMEM.
> If ses->password2 allocation fails, free ses->password, set it
> to NULL, and return -ENOMEM.
>
> Fixes: c1eb537bf456 ("cifs: allow changing password during remount")
> Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V2 -> V3: Adjust commit subject.
> V1 -> V2: Decoupled checks for ses->password and ses->password2. Ensured
> ses->password is freed and set to NULL if ses->password2 allocation
> fails. Corrected return value. Improved commit message.
>
>  fs/smb/client/fs_context.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 28c4e576d460a..5c5a52019efad 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -920,8 +920,15 @@ static int smb3_reconfigure(struct fs_context *fc)
>         else  {
>                 kfree_sensitive(ses->password);
>                 ses->password =3D kstrdup(ctx->password, GFP_KERNEL);
> +               if (!ses->password)
> +                       return -ENOMEM;
>                 kfree_sensitive(ses->password2);
>                 ses->password2 =3D kstrdup(ctx->password2, GFP_KERNEL);
> +               if (!ses->password2) {
> +                       kfree_sensitive(ses->password);
> +                       ses->password =3D NULL;
> +                       return -ENOMEM;
> +               }
>         }
>         STEAL_STRING(cifs_sb, ctx, domainname);
>         STEAL_STRING(cifs_sb, ctx, nodename);
> --
> 2.46.0
>
>


--=20
Thanks,

Steve

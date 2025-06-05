Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2BD530
	for <linux-cifs@vger.kernel.org>; Thu,  5 Jun 2025 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749165362; cv=none; b=naAzqzC8HTh6sd8c917BYn1qNQnlCTShRk41i0hI4W8UagRVNPqzLyIlJVDwISZZ+6nyxq6UsTqzixL8ahnR3f39f5unQhZcGr2Qjwb5j0dlTSC/3eX6yZipDye0Z2eKO+GCmWQ7qiLjHZm8Rr6+jip+CGEByNScqahQhCBKVvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749165362; c=relaxed/simple;
	bh=ybdAGYmB13OCWNJgHoE15+edqTI4VIaNRCfI9e9pArQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YnR6DhXk+X1hIGpdoHfgJ3O+Acg1GQ6gG1Qo5n7gVMtgaxwEMJ+R4TzoBe2+bnuxQas7xmYajCty0WXyL8NXv6TAedV+HiOvWbnUVcbAgCRfsfr8NC9yOXcAzgzITa99daH4LosoJ4h14rCjujIFWOmWbzRvpvYaHl14lbs292Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=umPd0X3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="umPd0X3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE565C4CEEE
	for <linux-cifs@vger.kernel.org>; Thu,  5 Jun 2025 23:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749165362;
	bh=ybdAGYmB13OCWNJgHoE15+edqTI4VIaNRCfI9e9pArQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=umPd0X3RNbTpMjR+C3TCqqe5ywVCuBEG63u9HdeKSPD7RJKWhkK6MQSV9ddeHuR1f
	 V5snJBOBR0YIVd5wOTgL0c8r3YemEjCaJjDf8itGGodIOhi6ihJvi2+evUgz+CksLa
	 cRWCbUhyqy6Xept0GDAWhh0Rn8Ef55bSkPdGx+bTSmFyGR6Fz7SkzWxXFdQ/SQd0OH
	 A+vRBKmgEQyuCgFLM9YnjybqWne97P43BIzm4u97fw54Z4VDNdiyrV1tX8Ju9HieOi
	 EN7MaXVl+ZXx8WAA6XeOmA/Cb0aul3+b4mYvfPBt74SVqtAmQacxG/pxVLdg7F9aI/
	 iccIqw8zSTUrw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-acb39c45b4eso237546366b.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Jun 2025 16:16:01 -0700 (PDT)
X-Gm-Message-State: AOJu0Yx2zVsVCJYt5aS1elJMy2ljc8fduSGInQILoJo6Cp9/wYXeOP1H
	mNrVeO1WSOQflIrPSeusF1YnnsGLgzhUxOTqesgqoMICgnYVR3fINsr1UWe73WefIwHuFQe31c+
	vsk218w/R4xFQSnPMYOr21F5VCCI4xfg=
X-Google-Smtp-Source: AGHT+IHptR2E3icHQ9iZLhj9C+89w7ZINpMMjoyIa3IjufiSDNGfMBApRg+fX0cUwzdwJWA9LJTwF3QFekK7COF3cVo=
X-Received: by 2002:a17:907:96a8:b0:ad2:46b2:78b2 with SMTP id
 a640c23a62f3a-ade1aa4dd5dmr96585266b.18.1749165360507; Thu, 05 Jun 2025
 16:16:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605134118.31162-1-meetakshisetiyaoss@gmail.com>
In-Reply-To: <20250605134118.31162-1-meetakshisetiyaoss@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 6 Jun 2025 08:15:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_vMAOcTKirmnqMxVYuZyZ-BXkESaCyojPnb-GNj9Ecxw@mail.gmail.com>
X-Gm-Features: AX0GCFtwADtaWTbPMX2v5JIJDGROEH6qWHSEE-nc-SYlQbborJySaXe-BbClbZ4
Message-ID: <CAKYAXd_vMAOcTKirmnqMxVYuZyZ-BXkESaCyojPnb-GNj9Ecxw@mail.gmail.com>
Subject: Re: [PATCH] cifs: add smbdirect.rst to toctree
To: meetakshisetiyaoss@gmail.com
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, nspmangalore@gmail.com, 
	bharathsm.hsk@gmail.com, pc@manguebit.com, lsahlber@redhat.com, 
	tom@talpey.com, sfrench@samba.org, metze@samba.org, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 10:41=E2=80=AFPM <meetakshisetiyaoss@gmail.com> wrot=
e:
>
> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> This patch fixes the warning thrown on building htmldocs by
> including the new document added in Commit b94d1b9e07ba ("cifs:
> add documentation for smbdirect setup") to the toctree.
>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  Documentation/filesystems/smb/index.rst | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/filesystems/smb/index.rst b/Documentation/file=
systems/smb/index.rst
> index 1c8597a679ab..6df23b0e45c8 100644
> --- a/Documentation/filesystems/smb/index.rst
> +++ b/Documentation/filesystems/smb/index.rst
> @@ -8,3 +8,4 @@ CIFS
>
>     ksmbd
>     cifsroot
> +   smbdirect
If b94d1b9e07ba ("cifs: add documentation for smbdirect setup") patch
is not merged to Linus's tree yet,
You can send v3 patch instead of this patch.
> --
> 2.46.0.46.g406f326d27
>

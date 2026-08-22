Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECAE2F3632
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 11:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787399097; cv=none; b=ZqM1Cce28Q0bEFFc/XpJEZbK+pcERfGshfu7dBA74JmaWFFmeSIMD6ipc7bAoaphIpUt2DsMufH0N2dLLkUGKbLK7Px+G8XXuFc4H/9+OtgBlW/rREFuVJcMcM8uLyhKMapbo4XMQ/40LMGG4GNmiIOqtPHM6wVVsz+oS4tDros=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787399097; c=relaxed/simple;
	bh=e3c2pNiPJ/ucxFwoh4RbuGG9QPDSc7IEhMPinMg5MnI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uo7cReaOriSk6KGMsf1C4UTl/P14q/mKkBSRDeCYohiXAU+g4mN1nrN8jKM6bg1XU3OXgpVQB/U5Tmap38e9TgxXc1hDv2Zq8lKyDj3bARf3Mb6ZWkhrdJY8FmlWrseCdiKYjH+Lp4iKMFO4WLmKqIP14XMCQnfdphrO/RfkSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eTyh2C+K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eTyh2C+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24041F00A3A
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787399095;
	bh=SsPrlUp1VBSXNjdAaPg7irxjSfCBSqbWEGD0DLyRgc8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eTyh2C+K7icB/b2oKBEKbcHr02yE7+Zn2X8PgxKUdkorqZkKKTl8Jc+hxpp5QvHt4
	 q5GWFlDXaUmfnXoUvEWWewwe42V0Hl9iGW2LpoNRSMDLb23lTjbByc1YnqB+ivsvAJ
	 iS/k543yH/pimPTlQsBsOMYUKGcxPL/C+8+ScP0KfJ49yBqDzsm7ls9ueencs6qQqR
	 85DtFnyNmYBIA9Pqr6QuopliJaQqJvxTPD/Vqtg9lXrGNjB4/vjY+0fb0UyCbGA4qp
	 ha+zIklZdPnYbJVqM/CBhRyfDTae+Y6tjvN/sauCOQ4xot4zVDIO65WNvDr+QJEcmj
	 TGPyxcrbWBw8g==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so3768936a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 04:44:55 -0700 (PDT)
X-Gm-Message-State: AFuF++klEXKyuvt4DXQtjSEeucPi+YsncPCJ8ZcYNETRvznIiTc3nvoi
	MEj7Hff13OQxdCld/eD6biSyZh5Z41+2O3GyQs0bO571ONlZpSUAi4Dixdv4GNwHvcu/9Wq0BuK
	ukC8FpjfCGcwb1iKZdIu+sJPY3Am3/+c=
X-Received: by 2002:a17:907:97c4:b0:c20:af9d:454a with SMTP id
 a640c23a62f3a-c2492621bf8mr532232266b.16.1787399094444; Sat, 22 Aug 2026
 04:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821184109.1834871-1-sorenson@redhat.com> <20260821184109.1834871-3-sorenson@redhat.com>
In-Reply-To: <20260821184109.1834871-3-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 22 Aug 2026 20:44:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-_CGXiYTo7OXQ=Lmo-tCv+gmi3HYOmyVkZ_GURoyJhnA@mail.gmail.com>
X-Gm-Features: AcwNN1XopdI5sUtgOwCwGnrfVD-Rt38W0QvNSpEDx_GKk6J45HS77lduwMb2vGs
Message-ID: <CAKYAXd-_CGXiYTo7OXQ=Lmo-tCv+gmi3HYOmyVkZ_GURoyJhnA@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] cifs: fix loff_t underflow in cifs_remap_file_range()
 when len == 0
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1415,8 +1415,15 @@ static loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
>          */
>         lock_two_nondirectories(target_inode, src_inode);
>
> -       if (len == 0)
> -               len = src_inode->i_size - off;
> +       if (len == 0) {
> +               loff_t src_size = i_size_read(src_inode);
> +
> +               if (off > src_size) {
> +                       rc = -EINVAL;
> +                       goto unlock;
> +               }
> +               len = src_size - off;
I have checked __generic_remap_file_range_prep(). Shouldn't this treat
off == src_size && len == 0 as a successful no-op ?

                    if (!len) {
                         rc = 0;
                         goto unlock;
                   }

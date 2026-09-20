Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A2A25F981
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 14:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789913037; cv=none; b=EXhC5cH8vQmLn3P+W9BzBKtUnhufU4ya0MioqxClQ+xPBt9O/DcdHQlPBZl85g8+4lBJuWwdHDBJF/5JS5NbgqjoYcKpcqwSLvxFRfjiNv1IeP1cHJsXQ4NP34ddLov0E8GO4zR+Hlq4aJ6L31IjaxqpHRozstI9x3VihkoV3H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789913037; c=relaxed/simple;
	bh=ol+DvmTUt6tnQ3FMHQ3z5x10dEKB99EaQtrcEKmCVCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tCimp8tKaLe1pvblLM7+nv78oxsum06ipPSayeAp20NVXNsjwz4HDMZ6egE2Bg1KoMlBYG1Nx3nDQ4QKkm2vXRHsQwxdurUjNabBn2XdxT62nt+GSqB7FLb6bLvIrCFn4vt4I//mlhlOBMziMm++sefKs7RVMG9O8KbMICfk+Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UCVyB4qT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UCVyB4qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB3B1F00898
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789913036;
	bh=KmiWSdZjdcDg9+cxRdCAy2ssJw89+gf/1Wd+QRW3ZPY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UCVyB4qTydBefJvwKYXomosYIeevUT6xRII+YZIRaJt8v2ls3jzUP3h38bV8UQn6Q
	 uWq7B+0akwVarDCFP/5AhxIvd7NCAR5gO0DVXYciiEXxV7YOYEV17hkknmXKln7kFA
	 StaRBFMnjhlpfKpZ2Fd/s1YeXO/cT8P4NMcD6iHclf+wdduwnoT42sv7BQQpgCDn5l
	 F0yMhZZBSFOMDhDEUo45XO2tX6IdsXuJld3LHvrEmdQfZs1/LQhfLTMzEmC1/YkEhv
	 UEENLYzXQin5xaIwnsbu/hO4H+drxBvJCOPgz8S8jT5g8BWzeOXySmlrKNosDfsMAB
	 p7bYREj7/fUSw==
Received: by mail-ed2-f29.google.com with SMTP id 4fb4d7f45d1cf-6aa0ee64afdso2459450a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 07:03:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwN27ZioEGzOI/Z1m0JwleXmwWWbVMQm3kSptYW366P9K2aHpJ/y0yuJmHNq3OywvRkAMpwipsjQzbr@vger.kernel.org
X-Gm-Message-State: AFuF++lJzBhaM3YZn3amEFuikkUunsJIpFebyH0/Bt826+sjddoIRbqT
	tcjScsfxXKXEv9mkZtllhMxWIjvYopgIjpgNIPRnZ6GelWEhgdTjuR8ylXZKF2tfHpNVjTqj/25
	0RhN9m9bkzAP/kMV7l7FaXlz33ZWiG5A=
X-Received: by 2002:a05:6402:320a:b0:6aa:1cf5:6076 with SMTP id
 4fb4d7f45d1cf-6aa577f4d79mr9717532a12.1.1789913034702; Sun, 20 Sep 2026
 07:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920055653.114794-1-zhang.guodong@linux.dev> <20260920055653.114794-2-zhang.guodong@linux.dev>
In-Reply-To: <20260920055653.114794-2-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 20 Sep 2026 23:03:41 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8kkDh54n3R2GZX0HrsZEcBSDP2UoyD+ozwomEXSeObYw@mail.gmail.com>
X-Gm-Features: AcwNN1Vr2S1jd6QA18CWTDmrJRVJDZ2-jAFD27F8Uup6r1UeTai-ucL0UAFWePM
Message-ID: <CAKYAXd8kkDh54n3R2GZX0HrsZEcBSDP2UoyD+ozwomEXSeObYw@mail.gmail.com>
Subject: Re: [PATCH 1/3] smb/server: update POSIX extension specification references
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> @@ -362,20 +362,18 @@ struct smb2_posix_info {
>         __le64 Inode;
>         __le32 DeviceId;
>         __le32 Zero;
> -       /* beginning of POSIX Create Context Response */
> +       /*
> +        * Beginning of POSIX Create Context Response
> +        * See POSIX-SMB2 2.1.3.2.1
> +        */
>         __le32 HardLinks;
>         __le32 ReparseTag;
>         __le32 Mode;
>         /* SidBuffer contain two sids (UNIX user sid(16), UNIX group sid(16)) */
>         u8 SidBuffer[32];
> +       /* End of POSIX Create Context Response */
>         __le32 name_len;
>         u8 name[];
> -       /*
> -        * var sized owner SID
> -        * var sized group SID
> -        * le32 filenamelength
> -        * u8  filename[]
> -        */
Is there any reason to delete these?

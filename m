Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552F2C0262
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760936596; cv=none; b=Yb5h5dW29qVdvydgTE62vINZ3lJo05JVOabpmtV9XSrL/38ajU58E51wLX1OGvNMkDxUrGge0XINufzImrpiw6FYyvHrCgf0QeS/cYg3gsKeYoO7rgdjF7bafUe/qPZ/jFonLheAla2rnqmbp8Gc+MOW+SR179f7ICnzHF3qQwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760936596; c=relaxed/simple;
	bh=etxCApgdgnBijPI1T0DibfTrBg+nQeKaoI9q1FeiBrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmCmTdxm7AUKL2FKJM0tLVkvUipqlSywzG82JPn4fcUU1NdCy7q+ijk31FUjohzBsc0xf6fJmP4ebvAxdHdAFn5B+98KV0RxIHs4RmLazmAZccq2tCIrzDTgU9mclCwkq3CXMEQGovrF6sNCsNtq8DuU1BIxLso1ffxe0iXTx90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bT3IsDld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bT3IsDld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E068C4CEF9
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760936594;
	bh=etxCApgdgnBijPI1T0DibfTrBg+nQeKaoI9q1FeiBrQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=bT3IsDldZ+dzs0SKlb68Axv/OITgz37S+13So+mN0V24dm8/b2ZxF96GrnBxP7fG5
	 V5zwgcRZfw6wO2L8NoTLGxJ44L97YhZyxSr7Y8IhC0XdCtyQTsY5UoVJ54G4JTD6yj
	 lmiuChqH/BGmQyVlo+BALZqnrs4UQFNW0X87gEQDAa0DUWwwMIUfgCbVF3AMKHSvaN
	 6XGP/6gxS8Hjslm41y5Uu6T7YPFQNbQy4N47NGXsPEghJl9QLJRT6KFN00p72vyMRn
	 2Vw9+C1cfI377S/+Lgt/H+MyEWLQ1Sve5G1sJY27aCDnGPlkGFviKms+jh2o3K7/Lk
	 2YNlZx/LJjPTA==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-63bad3cd668so7472237a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 22:03:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVZTVlJBPU8jgpBdMhrjBkz/tkqVS8n3QifI9tfrEvvKZJ3bsiFVyaujX1NI4QHhG9kx/sKfZNsgfoa@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7GyNExwzQnGee+GXhpl0C4u2UKz+7mWdrV7oXV+9qvT+fiVUM
	wOuQ4+p5rtXGk5olNUvL7rfX29KqJ++ssrvWovXJs5QbugIDwZlQQSK5oBiI43dxEVWwJVbAqy+
	8IErXVae/0iL2QLrtX+S133/e+eTh7ao=
X-Google-Smtp-Source: AGHT+IFx+F2BT09NtY957zTEzJFrrLdKDfb/4t9mK+mq3XyOhaPDmlUqvbNnye4qaRJB5iC9dHHISj0/zR9BxV+CINg=
X-Received: by 2002:a05:6402:848:b0:639:c94f:93b9 with SMTP id
 4fb4d7f45d1cf-63c1f6d4691mr10433481a12.33.1760936593075; Sun, 19 Oct 2025
 22:03:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev> <20251014071917.3004573-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-10-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 14:03:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-zUyxsrevM9huWDeyOb3Y7XbT3ngqq1Xax0um-dXTwqg@mail.gmail.com>
X-Gm-Features: AS18NWAH1NWKTf5iWkVIYaCb0sEEOhlcF6TaOw0NJJrXIjjP-x3O0tyby-A7Yig
Message-ID: <CAKYAXd-zUyxsrevM9huWDeyOb3Y7XbT3ngqq1Xax0um-dXTwqg@mail.gmail.com>
Subject: Re: [PATCH v3 09/22] smb: move copychunk definitions to common/smb2pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	zhangguodong@kylinos.cn, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 0be63c00f848..9b5880e60a4e 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -191,36 +191,12 @@ struct crt_sd_ctxt {
>         struct smb3_sd sd;
>  } __packed;
>
> -
> -#define COPY_CHUNK_RES_KEY_SIZE        24
>  struct resume_key_req {
>         char ResumeKey[COPY_CHUNK_RES_KEY_SIZE];
>         __le32  ContextLength;  /* MBZ */
>         char    Context[];      /* ignored, Windows sets to 4 bytes of zero */
>  } __packed;
This can also be moved along with copychunk structures.
Thanks.

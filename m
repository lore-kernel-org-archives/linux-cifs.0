Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC363BE155
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 01:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789696060; cv=none; b=LB1dfg9COrHE8jT+LwjzkOAg+XlfGSklg1w1iolexMwMKgh4uSbc8jgfy6+i5j31ISYkiebb693Viv2BlGdzUVGzFyBJzbmvhGK0DvNeQWxDUUAL7xYSJ7wAhxTR4bTrjiJGuBASo1t4mfDrktittbzxDhbLILapQm2SipoBM8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789696060; c=relaxed/simple;
	bh=bo0us6OOCsoIPB0dLXszuBqVD1dyZWkMn6r0/aJMQbI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aLCx7PLXCEleiYivFXl7Lop696+wh1NIAQb9jDkBgRTBQjT4SCo6vxEWteP7pSkZ8OGKWvW5P2s0O2aOr53DKRnA/yjwcICTTYjT++KKUCBJ7TIwnrE3mSRMiVwaJVvwTB7+n1jfyOQDgZ8w8kZyuKp2cuFzlEfo2GUX0GI40+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewEPOFJi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewEPOFJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1B71F000FF
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 01:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789696046;
	bh=uX3+BImbwHE/pofi6qjlPrbFrgViIsmcfQSKC7nhXsM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ewEPOFJiJSqT7Nt+Hn1onOzvYRxqU3L85buD4/vssymd+tTs61CZ8b26p4y5mU4vW
	 58ifLvbFPnzrSicZF/77GUZ6yx6cF951Msg2Te06W82ILZChj0k+i78BoHwV9Ttb+m
	 EVlF9/tdghVZ2Wi3cfcfoVT7hvFMRGCTWeTqxTcfkQ5nW0m1SBqTtz7V+pQq8aekal
	 goYj3KFtk938qPcLQj9NGu7rfnChFKWz7gtBWd1gU9I+dMd0C/ztp3AhT1nBn2dGiV
	 haxUAavSmrsSiMTN9UVCeuNajvhQAOpB1z5mpZb/rWRfJTjt2sHgqc+iHF507o4hVA
	 ZFz4atZVNXABg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c169ae1cb26so177569966b.1
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 18:47:26 -0700 (PDT)
X-Gm-Message-State: AFuF++mh70PCOuQl2nzqhgLv2T/nuVSoTypZiwU3F3465W5YnkCND90D
	va44figRMwFgZx/lyyTs0XmdLVOnAxhbpWxV5xBqa0MbqR7hBu+vnBenZmX6N8j4KQZGDUz3/nT
	6c4oY1N2kdbuqQlkTS9GszGtWdvDKhL4=
X-Received: by 2002:a17:907:3f8c:b0:c29:3909:6555 with SMTP id
 a640c23a62f3a-c29f525c3afmr503955166b.10.1789696045351; Thu, 17 Sep 2026
 18:47:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260918003327.2539470-1-sorenson@redhat.com>
In-Reply-To: <20260918003327.2539470-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 18 Sep 2026 10:47:13 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9UW34G21Xr6kUArCGsKUQZxz7ttkuCcdE9tVgyXNWTNA@mail.gmail.com>
X-Gm-Features: AcwNN1W6RI8juVgww_TdfbAJ5KgWMK3PXfwfGFNGRTmh06RyL3bJFupK3v3Y474
Message-ID: <CAKYAXd9UW34G21Xr6kUArCGsKUQZxz7ttkuCcdE9tVgyXNWTNA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix potential use-after-free with TCP_Server_Info->hostname
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index dea05aeb53a1..bb30cfa156aa 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -173,9 +173,8 @@ cifs_chan_skip_or_disable(struct cifs_ses *ses,
>         unsigned int chan_index;
>
>         if (SERVER_IS_CHAN(server)) {
> -               cifs_dbg(VFS,
> -                       "server %s does not support multichannel anymore. Skip secondary channel\n",
> -                        ses->server->hostname);
> +               cifs_server_dbg(VFS,
> +                               "server does not support multichannel anymore. Skip secondary channel\n");
Since SERVER_IS_CHAN(server) means that server is a secondary channel,
Is it intentional that this now logs the secondary hostname instead of
the primary hostname?

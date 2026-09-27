Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A010C38839F
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 02:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790475816; cv=none; b=I7sSKbNfG+aX6Yx4tfQp7tcLS7CbN5AZn2jIdbJH0ESqEa2/dtm7VOe8d2mTB6CQVdoRGf6exBBSOxnTmxHAUKnT/d3Nttvcn0BNcLWMruIKINU7MxPIsf9G4f9v2UAZMeWHXd8tdXjHQGqBETQ6ggS3wT7vFvAnfibLwXYOCuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790475816; c=relaxed/simple;
	bh=reNeOOXVzfXPjpIbTrcp6x8zksBzEAfx0mvL56+4vj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TV7UfrT0sj+KO8QOcn3D0nRbKFUPeDp602Yty9ifygv+Lmt3wCcHAY725UiH1v88g/Kq3KZ101nWDZZ6KJyK4UUNGsrOi4rXOdt8cig+QhW6gfs6XyW0/RNBPSpnUU8/cJWTjCvtulsWmEfYu782a2eb42/YnaeUGbHunzUd+ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgcLW/Hq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgcLW/Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BE11F00893
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 02:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790475815;
	bh=t0sd2WYEHNKUkojofc+b7E1p9eP04Ep5nooeYzFqgag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VgcLW/HqyX5qBwGIWMAuSZ6qyB1F5mByDv5LrHfTMNvp2EWpTBPNnMqsAXuAGxMW1
	 dpVQsYLfp+t0xg1AxVuu8g5ISqJzEYEFhGXsF8CFrUInGG0HMPWZcW9ESgp4WBYp6V
	 He+GGUiGMlWrGbXli9xluNnQ4nqqmVpKjAdEI27JMyupeBsTo0k1SsmdkOYfnPfOfj
	 95/dbithJMTKY5OTEHwUZRWaQbby0emF9auLeGGSegbLDZQ6X8RvNDPjfLtqrkZQiP
	 e7EjB38+gXY8vhL6KAp6WC705w1VbO9KW0s+WVbtdOU6wQQEiR9xyPvFiDlexjBTm/
	 ckJCSqRIfQgog==
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaea178c96so2164058a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 19:23:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw4aYOq2xdjb7tEJByVHtxrFcxUYGOatam0cPsyZ2w19O4vJ1Zz+kz/Q92+IsEIbqDs8HURx+6EH0Oy@vger.kernel.org
X-Gm-Message-State: AFq9FYISUKk0BsjFrqAHVo4gW8uJ81MGdG8fIaa/6q9wYBtlHLPIkcLI
	IUmd87nhMqenjaFm8pGopExuus5Qr7n7Fm6cK6fT/xL9B9pZ0SkqLIW9REpPgHtQKJ/p6HsSc1/
	uf8qECosyTHnpH2MsBWDRewGwdMwiQec=
X-Received: by 2002:a05:6402:378e:b0:6a8:398d:f57d with SMTP id
 4fb4d7f45d1cf-6aacc83e309mr8161360a12.27.1790475813965; Sat, 26 Sep 2026
 19:23:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260926132208.23360-1-zihanx@nebusec.ai>
In-Reply-To: <20260926132208.23360-1-zihanx@nebusec.ai>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 27 Sep 2026 11:23:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_T=r4doyNdeykejj4SsJHiK7Fv8aujt-fXACFybUr9xg@mail.gmail.com>
X-Gm-Features: AclHuK8IqYcRPOmdS5FFOdSF2W2Jugm1H1ys2DHDizlQVeQ0L2lg_0_gcJ6qYgc
Message-ID: <CAKYAXd_T=r4doyNdeykejj4SsJHiK7Fv8aujt-fXACFybUr9xg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid NULL resp_iov dereference
To: Zihan Xi <zihanx@nebusec.ai>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	stfrench@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel test robot <lkp@intel.com>, Dan Carpenter <error27@gmail.com>, 
	Luxing Yin <root@tr0jan.top>
Content-Type: text/plain; charset="UTF-8"

> @@ -1111,7 +1111,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         /*
>          * Compounding is never used during session establish.
>          */
> -       if (num_processed == num_rqst) {
> +       if (num_processed == num_rqst && resp_iov) {
Could you please explain how this code path can be reached? Earlier in
the function, if ses->ses_status == SES_NEW or optype contains
CIFS_NEG_OP or CIFS_SESS_OP, the code checks !resp_iov and returns
-EINVAL.

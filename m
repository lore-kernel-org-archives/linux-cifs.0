Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A6A352021
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 22:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788821984; cv=none; b=rQIRRnYi7pchkAT2UEuExyD/j3vBnDrqipgiem0xiqXzopynar5gBiIC3VPCV09qAF5uPlbN+EVacUgiY3Q0BFHVtx4HDaYSctGqTsXXHNp+MCW4kqDb9lZrpxYnod1TGWlkbC3P2Yb5U04E+RQiYBW6j1NIAS6m96yMrTp9Mdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788821984; c=relaxed/simple;
	bh=O5TUJ1SPfk9l3n1tUztikFuB7w6B+QFSstUdv0hxknE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egT6RT5gUAT6WYe8/IVgj7pqDqnAlw1aYjO/GqZKDb8K/nDCy4/9LQQUeM/SpKJ8vt2rqEqj0Na1sq3tZuoNL5Na0qFy856aSDLcEb/IdTHPf3CbPj3i4QebTHXqY2eguemvizoSECj2pTMQvQk9v73tl/nNfiB5hY5krB5Dwc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+0a6K7g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+0a6K7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1CB1F00ACA
	for <linux-cifs@vger.kernel.org>; Mon,  7 Sep 2026 22:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788821983;
	bh=O5TUJ1SPfk9l3n1tUztikFuB7w6B+QFSstUdv0hxknE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n+0a6K7gaS/OszLOAMmYvayG9LDssPFSFQ38CQejo65dW6GA3Wz2KaBCJLh8EDYRT
	 EJ1BqsbhVkYKD2gMY+CN0MtQsAMgFmooeLXAkRpZH9phOGtX25NwdyzP/qHE0gSkBT
	 lZj2MQKdq7uD+rXW8a7hEj2TM7C2o0Iu/yJ1jElFUM/vQsRQ4V2gsb2bfZCQKkhyXg
	 xhxgvEoja17wCvcrKox4nhMquKR6kfWU7qC2u63b3f4MrSjn1i5qOZMgodrakgwQk7
	 SoLbAfyH2BUkAdy4qWvDJrOXyecbEqu7ONjkY+7BN+hfp2weQm6Zw7BQZU4RNEj2q7
	 mb+d/7XCX7D6g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c25b661d37dso544487266b.0
        for <linux-cifs@vger.kernel.org>; Mon, 07 Sep 2026 15:59:42 -0700 (PDT)
X-Gm-Message-State: AFuF++n0u73DviKqoe7fXfnGil5Br5xudMZpslNgs2PNsXmbovlj+shu
	VXmWPg+NvXK5fMW8KJHaI95x6hzzgALW/YNMMPBTMKUqSYhUZvXEbL9uDK+EtpNcj0KQLXZ+ViE
	30HuleBh9xZeImYDMrhllvDBcQIWTHyU=
X-Received: by 2002:a17:907:3f98:b0:c26:19e3:e988 with SMTP id
 a640c23a62f3a-c2619e3ef32mr845471166b.40.1788821981576; Mon, 07 Sep 2026
 15:59:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260906200517.725015-1-pc@manguebit.org> <20260906200517.725015-3-pc@manguebit.org>
In-Reply-To: <20260906200517.725015-3-pc@manguebit.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 8 Sep 2026 07:59:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-XhacE=52vRVjwTi14t6Kr+27Uiw=uqEMJLF8169R2Tg@mail.gmail.com>
X-Gm-Features: AcwNN1Va2XxklPjg8CKZDjMvfjmDXDsc-ZkpJB43-p7Z54eMz-5EE3IBUjRRV8U
Message-ID: <CAKYAXd-XhacE=52vRVjwTi14t6Kr+27Uiw=uqEMJLF8169R2Tg@mail.gmail.com>
Subject: Re: [PATCH v4 3/7] smb: client: fix WSL reparse point uid/gid override
To: Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 5:05=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> wsl_to_fattr() unconditionally overwrites cf_uid/cf_gid with values
> from WSL extended attributes ($LXUID/$LXGID), ignoring the forceuid
> and forcegid mount options.
>
> Fix this by initializing cf_uid/cf_gid to the mount defaults and
> gating the $LXUID/$LXGID EA parsing on forceuid/forcegid.
>
> Closes: https://sashiko.dev/#/patchset/20260906190803.667489-1-pc%40mangu=
ebit.org
> Signed-off-by: Paulo Alcantara <pc@manguebit.org>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: stable@vger.kernel.org
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

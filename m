Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA4B2BEC23
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785160212; cv=none; b=PoXI0DifQkc5PtW8sktdeBDoZdknd+zwpWlxsoDn7YJPROdPrgyIFtOUuXX2EpTHCj/9mR1VyiXayPyjPYxQKBk7Covu98oomomR7e+VlO9OhghTdustGToo2DV96YOlIxFI8Twr+jMaxcUI/ZtJKUUMfI+xbcpAAIB4HdZPV1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785160212; c=relaxed/simple;
	bh=9bO65FtpSJBZeKIubM7G+FWUIPApKUfTBHkVdtFGrz0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BLkGxGIQDc3ZYjBKjHRK7IG/3klURjrVQpnaiIlT2MT3BZdNPLqBAozjIWOKxe7X8SLKi3iGhI4A/OSRVCyPDq5GXvVsbxa/+xz0Crbjckmy5iPr88qWOfaWvp+qM57zNw7KpXRBH36usPoAm/QLDC0jOgNnMbwpygVaCFiLY94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HyQHbN5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HyQHbN5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38B81F00AC4
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785160211;
	bh=9bO65FtpSJBZeKIubM7G+FWUIPApKUfTBHkVdtFGrz0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HyQHbN5Q3IuQD2oqZMvmqiwEN3xQF+JTfcvpNEWcKQwteQUMDB9eW/dtwPErsZH73
	 WoQJ0UaWZ9bU5xk2GqKGvkG39hStbvBG48w0PSFfgd4MarPJFAcHiGp1y2BRuceX48
	 Yukttb2Z805Lqo8w1iFQzk8rZqsLRht/9DVsKQXfwDww3NBgwdzWp+/QlO1NKBR8I/
	 iDm1vdOTzE6t3EpfQauCaopT2CDMz3ViXpEfJAmsVYXIyYADcQNKeDrNu6eTiYfVsV
	 Ji/BvJWqQuIhdoBOFmxG7P0Wr2mKHa9IFY9TisxE5s98n8+jrxsnRpy4k21btP/rL2
	 vX/1mvyMfGCPQ==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1670dad7a8so418768766b.3
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 06:50:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp6VJV9TmeekCPjmrzhcTewbV6gIW4IPOdSlzIi/QfbcrCoDUjzJr5Pzvu/t3/mWp+Z0ld5FYiYZjDJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzCyQNXMCzgrx296FzxPsNDLvS/3HMveMjSqZhtfqtvDGch84Xr
	TlZomZuezwUllfM4tsstyCO4qStiWO1BAnDYYCBWS5nKiKQeKHBk3s1462rE7AiNK+73fD7yvyi
	UpFrL6BrMqFTnpalINo1GyV/KJXOzsow=
X-Received: by 2002:a17:906:7951:b0:c15:d6c8:2816 with SMTP id
 a640c23a62f3a-c1f1f039145mr349032766b.27.1785160210299; Mon, 27 Jul 2026
 06:50:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260726090108.20938-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260726090108.20938-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 27 Jul 2026 22:49:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9kKWrMbrz49q8V79oPv=pWETE5r2gLRYV0_n3ok4yF6A@mail.gmail.com>
X-Gm-Features: AUfX_mwURz_L_fOQTnK6GPTf8G-UXWei1UXSyLvmmmGkWTTJ79qhTmSnkiG0zX4
Message-ID: <CAKYAXd9kKWrMbrz49q8V79oPv=pWETE5r2gLRYV0_n3ok4yF6A@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix unbuffered file position alignment check
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 26, 2026 at 6:01=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> FILE_NO_INTERMEDIATE_BUFFERING is a CreateOptions flag and can be
> combined with other flags, such as FILE_NON_DIRECTORY_FILE.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!

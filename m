Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3479F3EF0C8
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 15:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747859; cv=pass; b=dpMvQJdVr0s/mRd5fAza54B98unf5U86wcfNrp4uHImKMIkwXEy1xzkSCYhOyEKRZFCI13t4SZubuU2X+ZkSvOTI7i0unlhcbeFmmD9nXA4vQeBiY6955OUnyFDOj16yLOc75Kh3WbKV8KOpeLf0iCttvnOPZehSF/0NmPrPaP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747859; c=relaxed/simple;
	bh=Q6kxoXtOFY9y/aUqZ3/FCkysduRqjz7pyCV9cbOqte0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDpwNLBkezaehgDwW//DDKmqg5dr5TyOYFTRALg95TLD+vGsCbN3f+npshIEEFvtAgt+Bxp0Lcx7/N5Jh9lw9NWQXdqMrXMkBS1Rk4/49sr8ZhcpRZRhO0E+m61qFsasHAy+3+GHOI6wu2f4RCTkS9x1lhMkjszY5CZNTkP+H24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dwMKmvM/; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dwMKmvM/"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8efef6533aaso13331886d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 08:44:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782747857; cv=none;
        d=google.com; s=arc-20260327;
        b=NXclZKL8zcHSc0iFBSM6F1axFuCyim3vCm/nBotZmV9yt/LfbF/+OLTv+l3JUxKW9C
         u8bQCxJAy3wABB9mkDSjlVgeuoChB6tvXcH30nhGFtYMHcLMJuwtrQpqYayXPyS/Ne7T
         AlOw7OLH/rDcvdRzyaA1Kx9/QUGcH2PQO/tFrv+LEbVWQDtTOKt8L3pWQuz84jGinlmK
         waQzQOGr16nxVePshv+Iqu51FedbxSLjHZZVo1pdlSkmhRTHYNxL1cKXuOC6mIUe951f
         k7reocaH8nA7pwVWALDhLMbEGkNUviGlpMKs80L2tf4PEA+5NJnyynQkKAuqA7IMu+jK
         SEzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q6kxoXtOFY9y/aUqZ3/FCkysduRqjz7pyCV9cbOqte0=;
        fh=yQcp/7PkSQZi4/9fF4MTvlLYFq14RGXzVoH1Anzq4Pk=;
        b=m0LIcoW2+hm7By3x5wu7kw6XtISpXgvNRninfzGxEJaXUsS3gTolKAjDQOMgdbGzG/
         FfzXXP8n1gu6Hmyz3JS0CG56D4CzX4mamDiD9UDdKVej6v4y2j088rsYDxv/buebsahe
         t6l6WLmMKGGaU/D29BlQV++CJc7Ik26Nvwu8SYrmDL2jfGagsRmMome7KdXToha5puCl
         uX0rhKKTxAWEnd+PaaDeY1MSR6C26idpnCzcLqyaPa3Xe+Vk4k3EZQUiX7vcXlsc/ReI
         AtMO2HWYJ/q8KFdOhWL5vBa4Dw3YjqRe5AC2nLoOg28eIq8VaUZ8mQSZo63okcQ/BuJD
         zGAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782747857; x=1783352657; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q6kxoXtOFY9y/aUqZ3/FCkysduRqjz7pyCV9cbOqte0=;
        b=dwMKmvM/2m20bmqrEbfGcmlvMeBGWG3iMsqUHWnlzSUgDGve5kaUyxyRlCpi5P1grR
         ZDl8se4I9S4NBeVya0qDOsijAbsNhuEJatzPwDK+rNl+tie5uTppkl1KUsr8MJ6mCYCB
         RM9PeFU6dGJFr/4VWGPKnpC5fPwSqX9Rd5DS1ZsDY9xBm6BcuPKDg2l8h/Wp4SIPPOBP
         8K4NfzB+Cc0V4iNCFF2Ve3FsWWfVLeCDFni3BO+arbLs9tYPBqBFbmbGfRN7Xph7DQDn
         /liZOJb6sgkBre2L2NPBdkqTAgyEVt1ueaLJNLj2QbL2jRRRaYRlIhd3Payz2dGCjMIW
         9IHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782747857; x=1783352657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q6kxoXtOFY9y/aUqZ3/FCkysduRqjz7pyCV9cbOqte0=;
        b=LGGu7JpJ9gDMrrk6DN4HE0d3F1y3JpxrO0J3FoYZPLQXNi/qd7lLfqfDlPCO0f252n
         4bfjf6gbEwryj0cXcH/CkmGeX5mkq58NfrL0OvnxGWuLfL8kYwT9P7z/+VL8+APMpQxd
         x6+svLZoJyz7xZalWcAJTxU6qNG4TnSS1bmzTIPJERXhOot1DNS/rQl+YsWn++4V/wzP
         rh5xNE1PlDjzuMvrnUGcaRqoyM/B15oZdadzqf5x27rlR0W1CtfzryTVze6kNAbDW2Ba
         iLHc9MvEh+6Yq15juPYVp7fGUBh8rWkUrE20nbUEcz2SE5Z+HgqS6Nq9arZTV31djNGt
         hNIg==
X-Forwarded-Encrypted: i=1; AHgh+RpT3uu7NMWpyhcZwUSmnMCuo2ZG2iwt5tRNmCeHgHci9UEeQE2UjysBx7RQn5TalizpVuV/gH/1Hwmm@vger.kernel.org
X-Gm-Message-State: AOJu0YwpfvSMBP5ynN1VSyMX39bCqbTm9RNL54dxotW8FLXczoEKVoGR
	kLvmSql+hs3btOC1b9MS0dRKvx40eJqKAxGNVHkiqduwZH91Of0zueIhZFmPf8x2h+K0MI/3LZL
	F1jfrj56d2w/XhPO0qOR/XtZRXAr9xJ4=
X-Gm-Gg: AfdE7cnx2JD+Z+vBnYeBcABvOEkOp/Lh7x2+hedBUuN5JlRmQcXi4i1ObNmhDxPBg1S
	T1xqOnH2MWPr3Tm3tgxs3mfv6WfNSvRPRsINRO/O9HK1+rIrT6qZ4FRBRQxLnQi9nTJf5SVCPp7
	3bg0F2jkGDk5YSzSzo2v85TAyM20CQjLwsam+0ZGqHerZBwPiU6rtb+Cn7w2wYizQgOuSlhYU42
	w2FiOGKnXWQZArErUgXn9GVKNLuOvSfz8MGS/9nRF0p0ni3OhnVMpeT4iQdiMNVh+5GseIPyTEc
	9AhNwp0T0VLbZXIBMh0vt3MwjEBDWqMQjWLmZE5qwjkTAgoKghhaBgbR/JHMRSk4EfQGqmr8PiP
	VD8Zz9e2Z5dYQT2JZvdt5+9DYEe3Dad9805gJhTpndCeOBWIsUeQha7IzukW/50XTJIXv8jVPDx
	UIF8yXB7Q3aJk=
X-Received: by 2002:ad4:5c4b:0:b0:8f0:aa3c:52dd with SMTP id
 6a1803df08f44-8f0aa3c54ecmr44504596d6.25.1782747856978; Mon, 29 Jun 2026
 08:44:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
 <CAH2r5mt2Jonpx-YZ9ea0icKtGTCHFcEF77F0nJdFXRn97eUC=w@mail.gmail.com> <243d6eda-796d-45d9-8c26-6372af5efe20@chenxiaosong.com>
In-Reply-To: <243d6eda-796d-45d9-8c26-6372af5efe20@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Jun 2026 10:44:05 -0500
X-Gm-Features: AVVi8Cd8fmyCnunmfMrIDaDhkiFolDzEsUuT2whv7PRhoiYelw4GIbzwg6nJk7Y
Message-ID: <CAH2r5mufBWn7P-iRhHN5xs6d2E2--hFPwVY4sZ3QRm=wXJup4Q@mail.gmail.com>
Subject: Re: [PATCH] smb/client: fix incorrect nlink returned by fstat()
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> do you have any better ideas?

Not really, was hoping that there was a way to cache the link count
locally as additional hardlinks are done

Does this fix any xfstests?

On Mon, Jun 29, 2026 at 10:41=E2=80=AFAM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> SMB2_open() should not be called that frequently. Steve, do you have any
> better ideas?
>
> =E5=9C=A8 2026/6/29 23:34, Steve French =E5=86=99=E9=81=93:
> > wouldn't this be a big performance penalty, adding an extra roundtrip,
> > adding query_info call to open?
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>


--=20
Thanks,

Steve

Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538833AB498
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 08:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673666; cv=none; b=ZeREV/4EJ7/+bfp/pes23gzkHc0NLNMxextWwx6k1bnOZ197sC5pzjTgaQ7iBpf1F4UB6uJLk94bNUdmF7uyuM2YfD0zxGUxJWrEIwjRhZI+KLjoSxauqnDUMeFMTDQz51iYiLTJ1jygXCF7UFHygdDAL++Txu9dU/irUTJSmWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673666; c=relaxed/simple;
	bh=ikFzRmJdvvB9xT/Pby2r2lpQO997Kyt/bUOVdXRXtAI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=QIKtkS40WPwdulo8fnB0EtSy9WLst/NWV2w7VoV8MKz9y3XsurwenUyozSyLyHZ2khAOTU25pT/yaBw4t+pAO6sYjHocxyIRpxulIwAdoZkMhKN2rE6Y90aQruV0rccWapxqG2Ojm+Ll5LElZC1R3ZMKcfojGH/JTLuXnI+Csj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GeFlDnWL; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GeFlDnWL"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so5453195e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 01:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783673664; x=1784278464; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=onszkBXLVPfaBGvAcSP6rYb15NiYr6s/VHada9pQsBM=;
        b=GeFlDnWLBLRsucoR3zcwGMb7cqCQadkcVM330FxPqtH8zn6HT1DR4fh6/aZdLfSFsi
         wTKC9jfBavoBiJdnSVQC9XlY8G7CsqHTgLegiwcZJA3EvjUMZbPUAimATgPxLT4m+cPq
         E+vtOjVCOoXd051wkfsRPxr2dlasIQMXZPhLIYMJk7b8lg6nRQtqGD71v1PGM3+dFqAX
         DqosGyiVxeKuG2fVnzV+Wr7CcpVkBO2kJ5ckpu9lyLB7dGoRKkVBup1jCwHPF8T8Ff8k
         BRtWE9so6lzsZwEE/doAIN7ImXYqDaFdAafL56vt7MtSMYx7WzfxoPDHLjfoPIUi2e6s
         +61g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783673664; x=1784278464;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:content-type:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=onszkBXLVPfaBGvAcSP6rYb15NiYr6s/VHada9pQsBM=;
        b=Ok6yL12ausnSWgDMW7lFETHayF/eNQcHulhuW2HDI3HzUHw9Auig5awBQzfsM47rs2
         l7JPTjatU6/4py1SBM4QiFdTxqNyynfnMU0FlldNJRpnVc6/UDuZmxO7gNqC8Fw2JyAZ
         UH2tLQ4mpEMwq0TM0MDzu/t7iG8D/I4m6TjXx2gGJCJgTJpmeHHCIQbLRP1T/nEGDXk3
         gr4MihUokSVB/8hEUAz64mgsdAYEOdxef9h9H2X6YIBl4NCNDRYHQaMgJDbh1ayYYB2f
         BtfLGcf6LTvgIocWs6gES0hOfqOudnXhYJiEpENqNUWC5bpXsvnxm66nVms24qf7WlW3
         wkWQ==
X-Forwarded-Encrypted: i=1; AHgh+RqaGxFCOuFiuvmowjhpg3fVjne/ciMObnUab6vPocwB1LcHe296iaw1s7a4OdNHZzNWsRbkdF/jra+V@vger.kernel.org
X-Gm-Message-State: AOJu0YyHgEW3Mlqyt6hPaM5X8xQCT7Q3yprlwCgnqUe1VkUupvJtuZaK
	kaQanJp5u8UwkiZt+RgqP0O0cXh8yhDMdKPBMVcSeeWZ1SGFbk8H3d+N
X-Gm-Gg: AfdE7cmK9HPPqD5VcRer19YuGd5k7DaYOTNMIhQASecFJr2Go/OYucWkAZ+jEK1Y8BA
	5zLoGFaVxGvumftZBcJgRkKYjULr7uDjTnVkZPG5GQxAKFuFqasNSbvsZYWxnC0BKtJpf+tmqbU
	2cU7N8ipIY3Bil/3HLwq+DXexGLcvDnIsmksch8rOyvyLFjxWjLpNQT5wAxZIq4Win5XfFxAnTR
	U53kIq6j2s3hvEXpDHdV+NE3lmoHy70iTvdATQpdVlrnlYGqE6o0hHNkBQHO9soaqIBI3bkd2Wn
	+IYBK/vzZyBBBJ5pdWuqGjCcwALs/uIyeqneO/7cd6e9odtVhN6HftuYwEVSuDAla0K2wZhw15m
	Oy395Vv1hmxGRPbSjUwBaVhVBqisHDdpv1dFMUwSYekk/Y1ZPKUm8l4zM3YiRb2JcPYvMTncFmP
	HD6ptjm2GnKDBpID+c+2MSamIpEhTU
X-Received: by 2002:a05:600c:4d98:b0:493:e583:7053 with SMTP id 5b1f17b1804b1-493e68f5905mr63030805e9.35.1783673663570;
        Fri, 10 Jul 2026 01:54:23 -0700 (PDT)
Received: from smtpclient.apple ([82.67.171.69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb74b3edsm146379395e9.15.2026.07.10.01.54.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Jul 2026 01:54:23 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
From: =?utf-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
In-Reply-To: <c9a3fe37-c999-4d0d-8ee8-a34157c8a09e@chenxiaosong.com>
Date: Fri, 10 Jul 2026 10:54:11 +0200
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 linux-cifs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <12AF7BDE-BF1C-40FA-81CD-93DD3AB666AC@gmail.com>
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
 <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
 <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
 <c9a3fe37-c999-4d0d-8ee8-a34157c8a09e@chenxiaosong.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
X-Mailer: Apple Mail (2.3864.600.51.1.1)

Hi ChenXiaoSong,

Makes sense, sorry for the misunderstanding. Could be cleaner, but =
doesn't wait_for_completion_interruptible() still block a worker thread =
from ksmbd_wq for as long as the watch stays open?=20

Happy to help align the merged patch with your series once it's up.

> Le 10 juil. 2026 =C3=A0 09:04, ChenXiaoSong =
<chenxiaosong@chenxiaosong.com> a =C3=A9crit :
>=20
> Would it be better to do it like the following?
>=20
> ```
> int smb2_notify()
> {
>    setup_async_work(..., smb2_notify_cancel_fn, ...);
>=20
>    smb2_send_interim_resp(work, STATUS_PENDING);
>    wait_for_completion_interruptible(); // woken up by =
smb2_notify_cancel_fn()
>=20
>    if (work->state =3D=3D KSMBD_WORK_CANCELLED) {
>        smb2_send_interim_resp(work, STATUS_CANCELLED);
>        work->send_no_response =3D 1;
>        goto out;
>    }
>=20
>    // Add my implementation of notification events here.
> }



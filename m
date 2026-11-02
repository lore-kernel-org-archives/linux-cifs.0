Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793660626;
	b=4c/dILaAq5eFoje0MYinrHKerqteZY/GlR0ABolK0AaPHBzmnxQuyHGfyKKmN3gZCk7P
	 Q89jt8LA1XISIxfqeyFWRS/6H3nHkf3WOQHgUWSzGb4nAoo1qmmkaCv7Tw5qiMwMEVVoX
	 M5VhGwj7zI2239EftkrhPe3VhuzNZhCBGnPUiTPbSQzkXbUyvsCPjCmUHuQA6HKIiLbTl
	 JTmueUclwHyjN/tib72pqBMIhaWjOEiHVX/mZgduRCHUbRIoSUMSLjvcjms7YbLxWaklP
	 3ved5mY14oLsibyQKAkRcrCA7thVMYC6zI616t4Zpt8NoXTUjY/VJsORIipXO4RtaWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793660626;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=TOCj0cvfOMcwdE+2asmc5YrfnJ5Rb+uIiOaWLNlRZwI=;
	b=FWPCjUtk24VrmUiRMqzCSCzGkD8mhvagrP/jG6jgb2oNx+amCCslcp2yRPKpX1ee3WCs
	 twnTi3ebwqtYyxMjWx9bWFgbg/ja8gvoayMJVOwA6QzoLKOabhgNiIt0f2p8J0+WLEToP
	 kASSqWsAMHFJa2+yHQhkbZUXoe9OARkJrkxEIuEqyEo8A+lGxRGNFaxIh1+emQHCV+AEw
	 3KjFyK2h7rcxOrJcK10aZZEg+SfnNChKSfu/DSzLrOPExvDrplLaesgKxqdMcGSWP18ls
	 i5emOGBDSN1yONX5XiZMbLVqBM9utbYzg9sbD2CMOeNP7bbIvnNbZUrQJga2csYiotg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HUMxQjH4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629BE606A337
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 23:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HUMxQjH4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF1B1F00A1D
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 23:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793660626;
	bh=TOCj0cvfOMcwdE+2asmc5YrfnJ5Rb+uIiOaWLNlRZwI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HUMxQjH4baTzG8pm5hQhi324eB43eyyV540nF4LklvF0lVZosj0Ok1EUmU+SdsH4a
	 3h9KBSHeJ6VVTsZVuBA9YZq4WO6d3TXPNLx8FfmSOhD/JafKt4VXJG+k+R5X1ePNgS
	 q/PQLdHB9y/KxXn1C7Lri+Ut04qtVWXs1eYcff90KPKaSSP+UV1x4iZojSO1M2AIgF
	 G2JwreVan9DydZjNt2ojlpKClf5jXdtCpnsfYwBOco523Q86nNE5fxGJF4Js68xvI8
	 wZUs1Mwn47HbPHtK3xv1OZIt5FRICtu4CZwLx8Tz6TJTSd+8oTVMVmVrMce6xKaMzo
	 3mLOPWgIJxwpA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso521110166b.2
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 15:03:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwQLQnatZ6Y81pmnYubeAI80qXqELYmclvf/xfx+6ofMcZFaQb67XRx8olhT9wm9wB+vqUHRGVheBO7@vger.kernel.org
X-Gm-Message-State: APuU4Z8IcI0+GJvNepgCNuViUJLA7d7MV9Dzt1Ap9Jx4f6vu2l6N5QgZ
	qyIQqxaplwqMfh0H2zzCWtMXDPTthXkd5hBmKplEt+XLKV2smr2o0Aff1JswuxOCDVXFTz/EX64
	+Ya3vhTUnC1dRf4QcIYViJlLy55ZJzDU=
X-Received: by 2002:a17:907:c5ce:b0:c29:63f2:99bb with SMTP id
 a640c23a62f3a-c4ca7acf3a8mr975101066b.47.1793660624646; Mon, 02 Nov 2026
 15:03:44 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <179362071772.29269.615878810410303214@stu.pku.edu.cn>
In-Reply-To: <179362071772.29269.615878810410303214@stu.pku.edu.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 3 Nov 2026 08:03:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd96EhhA99O-xZyZ66a=tHB90DkmgFe2YhTwKRKT136bJg@mail.gmail.com>
X-Gm-Features: AclHuK8qzNqMYHI4Ba66Ka9nSMCYCzbbTHTLaBo2b77zwDgZoRBYxqX7hCpqpTI
Message-ID: <CAKYAXd96EhhA99O-xZyZ66a=tHB90DkmgFe2YhTwKRKT136bJg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: require NUL-terminated EA names
To: Yifan Zhang <yfzhang23@stu.pku.edu.cn>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, linux-cifs@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Steve French <stfrench@microsoft.com>, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -3419,6 +3419,11 @@ static int smb2_set_ea(struct smb2_ea_info *eabuf, unsigned int buf_len,
>                 if (!eabuf->EaNameLength)
>                         goto next;
>
> +               if (eabuf->name[eabuf->EaNameLength]) {
> +                       rc = -EINVAL;
The NULL-termination check looks correct, but returning -EINVAL here
causes smb2_set_info() to return STATUS_INVALID_PARAMETER. MS-SMB2
section 3.3.5.21.1 describes STATUS_EA_LIST_INCONSISTENT as the error
response for a malformed EA buffer. Please return -EBADMSG for this EA
format error and map it to STATUS_EA_LIST_INCONSISTENT in
smb2_set_info(). Since smb2_set_ea() is also called from SMB2 CREATE,
you need to update the error handling for that caller as well. Also,
the patch was sent with quoted-printable encoding. Please send it as
plain text, preferably using git send-email.
Thanks!

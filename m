Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792525226;
	b=NBcbQr/RHm3TVwNecXz54aKWVtXm0S6+WTJeGLIf905wJ/9uorto8nhNMyqZZQAiZMbz
	 tybU/WdbIF+7NQOJXbZeYMRWqbx8rj0vQRgTTohAgHNjN+hW+szOwpWHHfMssBmyRTVQ1
	 xCO4uib8xQo47Uf25o0c/m3FFgwLyhm8Z253RFvxafB0V4cIFn2ZArDUdrZf725zg9KSM
	 ie+ytCBV6lLXqAIi2ALrO5/5vgv++QGGcLZRFwS2L0sACIgtG/LSYbKhpzCBDufNXCRhr
	 64bUaTb8E/MumuukAwuKn2qRa6fObxWKERXrlOJn9AEJWU95IZO9GQywZOha5lOARxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792525226;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=e4JsFSb02TA55hrw/5psLRJkNgQYlwZOZtfuBpG76qU=;
	b=n4hO3GT6kXyE+8w0yJa42NLW+F++jH9JSbzXOYF8gO2DAh7g0If3ZMUvNJpTyaJXv0rR
	 nU1S3D848fN8e8IK9uIk6FKJtRowqnammgZNjRhatOslwVGHfwazZksHqDPW5KhOiMcCO
	 u+Jd1OaUW5eVFZjhVisY3yxonsq0Klbq57nd/E4VerNJkbV4Hl/Hn/8klqYr5oJzPts6Q
	 rnD28NdKIvBmC49V8UbcM4mcBkwp2xWfrVs7uzQzfSs8vcUFtQHQe5JZB1KYkgEfbSf55
	 G5PJX9zLh0PZnB6qdtFHHcCnhjvkIJXdzaUMw7zs9BeXW4pUL0QqWxmvd5YXltk1mrg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sDq4O5Mz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.177
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C5606A322
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 19:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 794C5606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=sDq4O5Mz
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b06c0794cfso232597b3.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 12:40:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792525224; cv=none;
        d=google.com; s=arc-20260327;
        b=se19chtzTS3YHhJqW3z6LVvLR/Sd/3RzA8pwcHRkQ1/onRh4ybfymWikoM7tz13DCZ
         5g04kRP7b4hLrPR/DXajF5rO3VNEZpCjGOVjp0A9BtcoZ82fNLFM/J8od+c8DXCFSRN5
         N+iKaqjSBDvctkDDKlzeEEnKYJBALSKc9j0wP7DlSHKnBsjqTiGP+Nqzxb8mmEToXtP8
         QwHF2vDgJyEGyNngnCgeG6vbABNNjJuSoKzzarkoHeGZAVmXRh5Aww4WnTHDVqOkHepr
         CD8idBhY3ssCMgFwecwfcv/s5XRVLSpT8sq5JDFLGrtBh83pfcHwzgoos9E9Bm+owDhL
         NUXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=e4JsFSb02TA55hrw/5psLRJkNgQYlwZOZtfuBpG76qU=;
        fh=5DA/jpqiat3+yNMmXToa7te5X3tWElb7xPSho0++ipc=;
        b=mHWPAeafE/OP2Fu8WqWCBSqqDaXCufavydt7wtXA04BCakQAKz3FeVHisK1KWbcnk4
         7sHHNyP6ZXVP1U2qnMiHQVwggOMR8TEMDTfO3eG6Kgn3vwZIIu7lUsGUesDcILaU4Vpd
         IQTbTFeAF6JT/q0yMN94tLMcre8ABvl9nqTZYB6zCkSfPNYLdny19gEljPfIH8gEDXyE
         2Wft0zrjr5bAi6hQqFFGK6zdACDPBSk/wq6GGVe7+8jzcfg548aAM9SuDB9jdoR2kcxs
         uR0kghxU12O8P1egN+gtFubFsicPPtmMCSAVVEu5W/hO0MKcbFh1p+wnx65/bwRm+Ggp
         KSxQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792525224; x=1793130024; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e4JsFSb02TA55hrw/5psLRJkNgQYlwZOZtfuBpG76qU=;
        b=sDq4O5Mzv7SmSuBHS4/QTeRkTYRt6RhWEfl8ZGLyy8160fn+uTZ3CXqPFf2+79S0Km
         SDYJ/z7uhRxvfIcef2kxnQeREhqofAYj/xN5S7T8HuUi2RsE6a43WK8wm8sZHC42zGOK
         3sVw6jq/wurpM7z0B7/kw8EoYfjoQHgX56LbMfcD1yIcPiQR9LatgvbHkOKlx7T+HewV
         B50XErQ2qAWjhzE448dWlpZcwINXqVof3JTa5DiMoy2f77Rucd0+/yc3RmTb/jreNC/a
         iuC+FeJYjEkydPyNEuOUgY5E3nUbZhPZRd9NocGLCqbqHGrs3k32kDUOStaHJrI06Kel
         AcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792525224; x=1793130024;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=e4JsFSb02TA55hrw/5psLRJkNgQYlwZOZtfuBpG76qU=;
        b=FxNA1BoqduLVQ/cfjFepsB1sq7U5XksiPW2yjRb0PEJ+Nq6Qpl5MTWlJdZjMjZXcxA
         BxcgGBJY1FTUL1xdkohhQoS9Bn2PvYVQ4LUzLp1m+yC1xJMusT+CRcrUXvl8yWaEI8qo
         uWPsoGZphxRXOikQEQ4A1SKuhCUY2vio4acvJgyjF7gIrwJ9k3TycRlaaEOhnOIuU4Hs
         GkybYSIvDGc7O9DaZCXAMCczkIC+8dfGHUY9bHeN3m5DAHhEyTRoPTg+Af3jrLO2Eb9+
         +XI7Wm6ajAFmZBxjP3aPyUFdIA8ooqOR1pA7Utod7V32dAv5tPMMWcL8NF0ym3mCB39+
         J0mg==
X-Forwarded-Encrypted: i=1; AKwUvByxYH22oRJR16ASS6gp2G33aMbvZqzSYu+pKTQiAVAkKcS6t8ILYdCSXfl5P0IN1XaLfp2TAWE4XaRL@vger.kernel.org
X-Gm-Message-State: AFq9FYLFxQWw8YNrNhQoeotU/ELSrorTHBz2qCfL8uCdqwf9Gt3D/HgZ
	4+sVDkb53u9Dpr3UxuyGIIRweCWZos3XAzYT975+k/tfMPWT+vWoau9k8B45iDq1jsnXCZiZXVI
	nj9pheGWmW1JWRmnSNzbv0TyKye1jkcs=
X-Gm-Gg: AYBFou1s6dmBJ05IVHNmuLr6k5LoUalO5/q2RcpJqKwMdMpR7uGt92ooPmyJJ28Mtep
	paZ62UASy7h5VNgaq6qJ4i3UqAt2fyNn4+P1qrf7rNRGGbvOfR7avWpxoJ6a53OyRMD2/hQDim9
	sZrHLFZlLb8sYiXwWBfk4du3EWzC4Wqunw6S+mJzbB6P91Ft3/NtuVuBV5VYdgxeGlcnCZp1dMt
	9CLuRGxYWFyKRc8IehEM78wIBWywpBtTSWV/LWVcBOYh67NCqg5SkwSMwOHMxbuosjkBfZn/Ooc
	rsp3x5PCdUC4rIAO3iEeI8IqfsAP1ZYCvbgANHyOtVHlAFEO4oMzHi/PfmpJXKK7cGAPYBmh4ym
	/b/ax3ExnxeY4dv8EE4+ajSF3ziv59J5W2CDzhv4=
X-Received: by 2002:a05:690c:788:b0:8a8:8456:a970 with SMTP id
 00721157ae682-8b0f21e9dbemr44226057b3.68.1792525224347; Tue, 20 Oct 2026
 12:40:24 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1792345559.git.jan.koester@gmx.net>
In-Reply-To: <cover.1792345559.git.jan.koester@gmx.net>
From: ronnie sahlberg <ronniesahlberg@gmail.com>
Date: Wed, 21 Oct 2026 05:40:12 +1000
X-Gm-Features: AclHuK_4nBepdHPIpyzJ4Q-CKoanV6D7TiXN__qc8a6qvpWN2kog280Tj0oflWc
Message-ID: <CAN05THQGpsya=GJgZjwdNpsrDF7FgRw1mTQePnaoRAgFfKVRgw@mail.gmail.com>
Subject: Re: [PATCH 0/2] ksmbd: NTLM pass-through to a domain controller
To: Jan Koester <jan.koester@gmx.net>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 19 Oct 2026 at 03:53, Jan Koester <jan.koester@gmx.net> wrote:
>
> Hi,
>
> a ksmbd server joined to an Active Directory domain can authenticate
> domain users with Kerberos, but not with NTLM: it has no password hash
> for them, so the NTLMv2 response can't be checked locally. Clients that
> fall back to NTLM (access by IP address, machines outside the domain,
> mount.cifs with user name and password) are refused.
>
> Samba solves this by forwarding the response to a domain controller
> over NETLOGON (NetrLogonSamLogonEx on a schannel connection). These two
> patches give ksmbd the kernel half of that, and leave the NETLOGON client
> to user space, like the rest of ksmbd's user handling:
>
> 1/2 adds a KSMBD_USER_FLAG_PASSTHROUGH login flag. For such a user,
>     ksmbd_decode_ntlmssp_auth_blob() doesn't compute the response from a
>     local hash. It sends the server challenge, the user, domain and
>     workstation names and the NT/LM responses to user space in a new
>     KSMBD_EVENT_NTLM_AUTHEN_REQUEST event, then takes the session base
>     key from KSMBD_EVENT_NTLM_AUTHEN_RESPONSE and goes on with the
>     existing key exchange. Both events have a strict netlink policy and
>     are checked in ipc_validate_msg().
>
> 2/2 puts the workgroup, not the netbios name, into MsvAvNbDomainName and
>     MsvAvDnsDomainName of the challenge's target info. A domain
>     controller checks these when it verifies the NTLMv2 response (Samba
>     in NTLMv2_RESPONSE_verify_workstation()), so without this patch
>     every pass-through login fails with NT_STATUS_LOGON_FAILURE. The
>     patch also checks that the challenge blob fits the response buffer,
>     since the workgroup can be longer than the netbios name.
>
> Logins of users without the new flag are checked as before. The only
> change they see is the domain names in the challenge's target info
> (patch 2/2). ksmbd-tools doesn't set the flag yet. The user space side
> we tested with is sharedd/adconnect from FenrirOS: it marks domain users
> without a local hash as pass-through, and it answers the event through
> a NETLOGON schannel client, tested against a Samba 4.22 AD DC.
>
> I can send the matching ksmbd-tools change if the interface looks
> acceptable.

Please see https://github.com/cifsd-team/ksmbd-tools/pull/346
If added it will give you much improved DCE/RPC support instead of the
hand-marshalled
stuff and make it much easier to add additional DCE/RPC functions
you might need for this in ksmbd-tools.

>
> The series is based on v7.3-rc7.
>
> Jan Koester (2):
>   ksmbd: pass through NTLM authentication to a domain controller
>   ksmbd: put the workgroup into the NTLMSSP target info's domain names
>
>  fs/smb/server/auth.c          | 109 +++++++++++++++++++++++++++++++---
>  fs/smb/server/ksmbd_netlink.h |  41 +++++++++++++
>  fs/smb/server/smb2pdu.c       |  21 ++++++-
>  fs/smb/server/transport_ipc.c |  73 ++++++++++++++++++++++-
>  fs/smb/server/transport_ipc.h |   3 +
>  5 files changed, 236 insertions(+), 11 deletions(-)
>
>
> base-commit: 32c52ec87d6245ee2d12ed5dd509e40062939b50
> --
> 2.56.0
>
>

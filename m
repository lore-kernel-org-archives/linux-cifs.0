Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B837B3EB
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768892055; cv=pass; b=pOKWFZdVc9KFbj1K6j4UcLBclnUdWWmD8XP9a4nQpWRpvln3QN8SL5vH3rm7hkXjtbOAmkzI2uO/fKPcEntWcE2z3HrySQD4r5YaqkVOEQ7hX6tHy4fdM/TXb8lsmxp7Wm03LjDrOy44VpKMuYggnmK9dTmI4BDQ6Smdyeg+JkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768892055; c=relaxed/simple;
	bh=l9AC7AVMrjDoD7ycveA9s64KcRDS8cgXBFcIiVvZx0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jP6Dl3yUCXPt0ceS91ar/Mgg2OXeudr/8wjrYw8HwcAkcp13D91b4bgfIZaTIP2Pbo/VEZLOHGEPMS3Ruafe1tCmNP3R+D55BZhGgwn9bulPH86kjmQlxBEeWjoA4gdXszjQJhRVGxKZ9aVGSScD28GbnT+IIa/62YbMNlcbRC0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fRI+Zsu4; arc=pass smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fRI+Zsu4"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b7ffbf4284dso651213866b.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:54:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768892044; cv=none;
        d=google.com; s=arc-20240605;
        b=YHBe0wrV0ZcpTZITf0AfHPGWpzdMXyu4w1ORJqNhbF86LnWF5l8JKxuYXuGfG2raGV
         xOnan8oKhrKVw7/ajm8VtsnVKs1A8BqbUBTlWLirPMTj7qHGW4PBTGfzf1eXgTSdz5F/
         4bRoU+tt+yYFmZOHKrk0AxwcvoYLvpBraMlrZk++s2r9zyiDThVf3iNSTZgv3pXQ8Aff
         PyfjpckI4XCYzzJhhTTYGeUAzVo4MNB60hXnFK+/U/hU2pfXG1+DnhVSJD/7MZBo8z7t
         2U7dGJ7DQoYUMDWGcuGCMkWEbXlxxCjod7wPmBjpn9wdzHatkrf3J79C/a490YoZAsQQ
         hTGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EYs6Ts3ORmEAv32CPe/waBiP6wEJY9gE/t7X0m32yZ0=;
        fh=Dp9uIY45odjhHC22pgHQMegIzqjxbukXljredGLix7c=;
        b=fq/iZup9Bz1hmwq8xeE3ZHqVVbHjs8PHKniBJB3Er3XMEXdcw5XLbnOY9BQoy418Sp
         WjW7wLKwSNXdRqJDrcMt2vSSUtvxqS804gsrw1XZTT7+lE5OBlZCdAzVDhZGtMXVf9z9
         4a7+bqzvTZH+hDc0CY/9VHXinuK1aRLterKGFSFbQIdvXLH+TXVLpr/wGFV8NwnTMDfR
         m/nIPF+p7LaORrxJksTl52jqe13C6ESY+j5SPj3XMX6YS5/nwEf97CklGltiy8rb6i/q
         8ZtByp5m4NNF9X0o5U4ke+X6Vph9OuL1+EbSJyn9TWoNrmJ3i7P1ahwcxBKwALCnf7vF
         hUpA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768892044; x=1769496844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EYs6Ts3ORmEAv32CPe/waBiP6wEJY9gE/t7X0m32yZ0=;
        b=fRI+Zsu45+YXUznnGB1JZEDIpn4A2+/oAwUy+U+LPenLg2Hbnhbd1h8Yl0uHZJF9C9
         xo1YDTgZw6vgyIDbO0Zhaini07vOJEUQA4/0mZMnq0EL6VBwAIRcXyLazRU2vnBIPJzq
         r37VRXeO+3v7BZZs6Cv+4uJkQ1d6gTf7PyuORD2Tp1dAiXlTQMjrx6vL4YEybbn1Z1Kg
         1je1EqRYg4bVc5lLS/QiNOVWpaFv5YLJWTmCnVbCeCwPsa9XzHm3tVI/89I73uxfT5sM
         exvU1LoQo80BmbRJyE/gul6tWPFVdrC8JNa0ouJ8PS7ZFP6BUCH5csnFZT+djYNEPBP7
         38eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768892044; x=1769496844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EYs6Ts3ORmEAv32CPe/waBiP6wEJY9gE/t7X0m32yZ0=;
        b=wQr233bnx2yi/+sr0umnx8UH8JenW1R+bDqnlJhvlAgid6tvQ8IWsuAX/GcOfyBs1e
         /y3B2iYJsTFHTYce8U/CHI1err23f5yXrP9/0euGhgLPen2P/Q2HRVVBiUb2+ogWQqC9
         UHk1c3zLKXS1dq7M6v02VxId/m7Z2a6CfHYPdMvq53wYvl8uG6BTPrqMtxh6pnQxSfCH
         lIZ9pfiPele/o7rN8BfQbkJVzI6FVwrbIOXgx+QZMThPChzCNEg0e2hyXGIhY6XHfC4P
         Ja1jFyAmY5ACJE58arwyMx3Mkt5N+Eyv8V1E+1e0CckKWuP1s2VRNYHELLK9ZAOYizpw
         AgNA==
X-Forwarded-Encrypted: i=1; AJvYcCUvv2OqwE6Fm96BrjGXbD1XE1NtCG0OULmJyKCnDkT4OnV8skUMi0zC3Rki6HXgIaEsTPKI8ExapEAy@vger.kernel.org
X-Gm-Message-State: AOJu0YwcdU/secsxdZ2r2TsNrZ1OHIzsyLxrt3temaikliG+Noe+58U1
	iWBDj9q5HmL36jRk5zIncxruug5KVZvAQfXgiWgfeutokd9aDyyVVZDawFYy4W3RMT0MtwTz4gQ
	TLLfUrUSAP5hIYV93QroIXEVgcu+Gywg=
X-Gm-Gg: AY/fxX7Udih9V6Q0nuAXofE1biO0UAL3XEoU7MlxQ0cg7ec85MngE0IN8s8CPkq+jJf
	KJSWZFsgSdzLwjJ/WYHKH1JMAC4xrC6nDFS3jgooe3NKy3pImu8hdvh5BD9WHMo/3ax6ErCOFQp
	cfjcm5NJDP93A9lTEbOBm/yVDsGmdR8mUcZ1HzCGyUfRhjB31NX9HvjZHRGFGCYR4mzGmXIyEPO
	t2UVY26YUpAoB5HHg9h8R90SrgOwv19x7ntMBNs64FpPaFzWw/AiHm2znxtdcEQe7d2Sg==
X-Received: by 2002:a17:907:da6:b0:b83:975:f8a6 with SMTP id
 a640c23a62f3a-b8793033340mr1246281666b.43.1768892043831; Mon, 19 Jan 2026
 22:54:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119175445.800228-1-henrique.carvalho@suse.com> <20260119175445.800228-2-henrique.carvalho@suse.com>
In-Reply-To: <20260119175445.800228-2-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 20 Jan 2026 12:23:52 +0530
X-Gm-Features: AZwV_Qix_NG05KMRJiyb5y7oZmY0_bc4BMtuIUKcgiwfbl9g7LsugW6mEW40ZWk
Message-ID: <CANT5p=rJWke=jX23RLZBgCBYjG7Ss=tJBQ9KZM=KP=CKpq9sAg@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: add proper locking around ses->iface_last_update
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 11:27=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> There is a missing ses->iface_lock in cifs_setup_session,
> around ses->iface_last_update.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/connect.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 4e71d5e0fbc4..7cf26181ee3d 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4335,7 +4335,9 @@ cifs_setup_session(const unsigned int xid, struct c=
ifs_ses *ses,
>                 ses->ses_status =3D SES_IN_SETUP;
>
>                 /* force iface_list refresh */
> +               spin_lock(&ses->iface_lock);
>                 ses->iface_last_update =3D 0;
> +               spin_unlock(&ses->iface_lock);
>         }
>         spin_unlock(&ses->ses_lock);
>
> --
> 2.50.1
>
>

Looks good to me. Please feel free to add my RB.

--=20
Regards,
Shyam

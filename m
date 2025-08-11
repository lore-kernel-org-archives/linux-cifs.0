Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05368F6F;
	Mon, 11 Aug 2025 03:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754884200; cv=none; b=KolnHFS54tUjaRfd75Igje+73FA5KHuCrkasd/gg92tqgcJntsFmriiS20PzUs5p3o01lJeyiQZZvHOyrdaIy3JPAPobVsWxH6zQv3I2JD3PlOVHP0453O2DD6kRB43k7trAUWfXRRh5A4dM78EELxSOUry5DLvdb0A7mpKudfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754884200; c=relaxed/simple;
	bh=vLj7sE/rOpjxfKeHAl+we/21AK9YuVsKrzSembbWi2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IsAYXxgOSRaW41hlnxL8WJ03c8bY11JlHzFBioBE/nT4qXdebIGWowNQqZbETIXF7pw3CotvJ5u1S5TILA3TYuWahN8u0Q2i66PxzMsSKzf3wHuqo5Bk+clOQG/IwV28qwp3lPvhvLlRQOasy0iQoQVgRiRI5lis3QF4Jmef3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DbtmcCUS; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DbtmcCUS"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-7077a1563b5so36042176d6.1;
        Sun, 10 Aug 2025 20:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754884197; x=1755488997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dU0qTogiP2a033v5TYXMo7DdbYERcKnC4lC7Xn3UtLo=;
        b=DbtmcCUSHprcNdt4oDTcxHJ3RZqYuWyWXA4buiC7D41H6wbr7IbEzuo7T994ybNgNE
         fEjs8/McziNSfFheKmF9sQIV+B3AiF+sjRoRDn8wnqsCfBgiRDBpWO4rg3QjsBX/TI89
         huty39kske8XDK4eTsTVI9/BuOgQwqO2iVLKBEdaXUwauzOyOpUpZ6QedCz6ktf/ZIXX
         s+sFD1MgCj0oo8m4kUgGmF38dYLJmQ5y+zBZvpm+m8r//9mhneOooMrDuPaJbPw2aJz8
         Zuz4AukTafLoxKm2XPhvCwuvHJkz1EosbKHwfX6Rld4l+GxNQ6tYGZutI27J44sfdACP
         42lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754884197; x=1755488997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dU0qTogiP2a033v5TYXMo7DdbYERcKnC4lC7Xn3UtLo=;
        b=vHhiR/NbOkgHRuPLGY4BNqCdsqDunv0BvQEQXZblHZcUdkHKnRjzACN/g7g4AGQHnJ
         V8cNeHiieHUXLOMEmxI6iQAeW3I0UHklNjUZp6FBCqdevu6uCiAyjA6eNIlFpvgWCwo0
         mYfg0hcY526AO3JU2QksAIZ2IUWOAvJudRMs/+SfNywCb/y8VFxckfUo1zJYoTvJORpD
         4rsFhF1TtiE1J7GWGMZme8MXEs6cIp+m4Zu94TMe4FDUtQ079X9ET5Dj01V03FT6CJcz
         LLjCWtGSkuur/GE5zPdRubhNYxD38z8fk6z/yHrf4a+zkSWywRytoSkgrMcUj0ql1/EI
         VzPg==
X-Forwarded-Encrypted: i=1; AJvYcCW1d51Nq1SOsBS9dmf+hSgN92hjGjgGAr1n3lVp1u9fosmGeLNSlUl5qJI8K7BIbplaUDu906C/uOqo4PI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrRc9L/My1JZXgIKC5BGt5PmrNHODNECFRScvYPmsqTwgqkN0f
	BhzFCu4+C2bcuer+p8hjKDXDHF482LLo+mrHG0OscbnAXDNGOM2Ds1oEbg83z/PczOk7R7IEgjR
	5YKetaej5sP0YzSoaLFWqyIuFY0FyNL2HJA==
X-Gm-Gg: ASbGncuPnWESBFfOlG14MFOuKk3SvwUJJA/luqhMP7OoWathbTKiBEFzscfQomMHX7c
	Rwb/klmVmnUsgjYz41FJqm5emYdbQoa5Oz8Q/jvK9AJDvtsemP6uuYmUcjh0U8/0PSw56tlSBic
	IZl4p1+doG5DoK4m93kZYARXxNXIAEuPOP/xdD8k4JUIXyR09i/Wf8CBLeaKNNV9lM3CusYpCbm
	aG7W7ODlru/nSPAHDklAuQv8wGXcENwwTU6EO1Xew==
X-Google-Smtp-Source: AGHT+IF7zha6IkAtgvMpZSM/kef8AJ49qQQvXQxRtK2XDtuVt4EJE2F1Gv8Kr8UddslI+Qv3yCauyP57SlpqHn3q5Kw=
X-Received: by 2002:a05:6214:20a7:b0:707:6364:792f with SMTP id
 6a1803df08f44-7099a2842c6mr128624876d6.11.1754884197387; Sun, 10 Aug 2025
 20:49:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801090724.2903515-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250801090724.2903515-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 10 Aug 2025 22:49:46 -0500
X-Gm-Features: Ac12FXwslo12TH7OKSYMVozbK7r8DgvDFN8SBf_9dWAWAORt8pccei83N3-_dng
Message-ID: <CAH2r5muBsUA3V+JKHuNj-TeOqW5Bhg6cS+2A+zx17owHCYJw4g@mail.gmail.com>
Subject: Re: [PATCH -next] smb: client: remove redundant lstrp update in
 negotiate protocol
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	chengzhihao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more review and testi=
ng

On Fri, Aug 1, 2025 at 4:07=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> Commit 34331d7beed7 ("smb: client: fix first command failure during
> re-negotiation") addressed a race condition by updating lstrp before
> entering negotiate state. However, this approach may have some unintended
> side effects.
>
> The lstrp field is documented as "when we got last response from this
> server", and updating it before actually receiving a server response
> could potentially affect other mechanisms that rely on this timestamp.
> For example, the SMB echo detection logic also uses lstrp as a reference
> point. In scenarios with frequent user operations during reconnect states=
,
> the repeated calls to cifs_negotiate_protocol() might continuously
> update lstrp, which could interfere with the echo detection timing.
>
> Additionally, commit 266b5d02e14f ("smb: client: fix race condition in
> negotiate timeout by using more precise timing") introduced a dedicated
> neg_start field specifically for tracking negotiate start time. This
> provides a more precise solution for the original race condition while
> preserving the intended semantics of lstrp.
>
> Since the race condition is now properly handled by the neg_start
> mechanism, the lstrp update in cifs_negotiate_protocol() is no longer
> necessary and can be safely removed.
>
> Fixes: 266b5d02e14f ("smb: client: fix race condition in negotiate timeou=
t by using more precise timing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/connect.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 205f547ca49e..a2c49683be66 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4205,11 +4205,10 @@ cifs_negotiate_protocol(const unsigned int xid, s=
truct cifs_ses *ses,
>             server->tcpStatus =3D=3D CifsGood) {
>                 spin_unlock(&server->srv_lock);
>                 return 0;
>         }
>
> -       server->lstrp =3D jiffies;
>         server->tcpStatus =3D CifsInNegotiate;
>         server->neg_start =3D jiffies;
>         spin_unlock(&server->srv_lock);
>
>         rc =3D server->ops->negotiate(xid, ses, server);
> --
> 2.34.3
>
>


--=20
Thanks,

Steve

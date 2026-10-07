Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DC935C6BC
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791384699; cv=none; b=Q+4BAFCpvNnBSTM30ckHYef6SaDIpF6Xd/rXhBjGUs4wZuCWcZdEhl/Vjk2XbBr3qCze+XBlH4B2/DhDwywUiLGQyD0gJI9GuNmaCZWgOyY3O805tkfsS3LFG803vYnpGO5of3uuWm/BCGLJDVbEBuwBq8fwFysmyLL6GhSbyQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791384699; c=relaxed/simple;
	bh=64sH55gGEwMY+Fw2KXIImqn0GDwpwS7PI7uWlPJf1Zc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tjIz1mkSMab7CJNJSu8iRn/RfYEaFhjPrsteTa+8t++1XtgFO/gYdH0kxTMwdqQr7BgcIqT1Tsm18IU3EflwHKrC+S0sIDDxjfY/u3Ea0BZcb8T8zF3hPHFb5B8G/IbCLApwfQseui1eRBxLk+UudgSk6WVrSN0mWV+648uKtmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bWHIwmCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bWHIwmCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EAA1F0089A
	for <linux-cifs@vger.kernel.org>; Wed,  7 Oct 2026 14:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791384694;
	bh=dq7PEjyV2HZQoJ2a7ZdJJNJjZ4wuz8neRmWl6VRJ6QI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bWHIwmCBNQ5XAF7T4M3OSYYT4dHBLDuruLb5jv1h+NJBpbhPsb0VeEOrZgmIF9MvU
	 vTsoUKnYBJPU0rdhbf1IoDsYP5Buci8kf/QupsIciR4wWwjwg/OcpfkhM/IASbbk33
	 v+hST5EVirD4bsbsreM/5xMZBy+5sn2nGk/1EMhH/LdjwlEhUDJ8D257ZzeOxkwp99
	 a4VIRVew7EeXovW1h/pMbXmohJTvGVhmYBHXm1ezzPPz6LY6mkOJEWbAct6HxHlGTo
	 4OI9PWrFKN/DH67CVBnDMJZmUlMD/YxHLQvnXFZHiD7Sv+ia37rk6WPCRV8Zhm+47G
	 IKnSIjRzenK9g==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso3682588a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 07 Oct 2026 07:51:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxrFbwVsU3DOUlGdBC93zvIunNQzAZy3VNnil4ax5/DUbfnEGoJghEfoaJe0tbzAiok35NWbpeKlOy8@vger.kernel.org
X-Gm-Message-State: AFq9FYJTFA84r0gnI3cxKLX/rT+uzK0RcD3borvn9SDF4+eQgn6le7lk
	6z57D4W4UKYdzxjO2Ur8Ljw9QBya05JyogANcpCs8E/7YITRWWr9sIj2MiGXCJa4Kc/gV9RnuXF
	CSjip1+9rXyDc73mKiEnF326rLQBeWh0=
X-Received: by 2002:a17:907:c1f:b0:c2a:f1f5:51ef with SMTP id
 a640c23a62f3a-c317bf5fd97mr245414766b.20.1791384692658; Wed, 07 Oct 2026
 07:51:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261007074444.84875-1-tjdqudcks0424@naver.com>
In-Reply-To: <20261007074444.84875-1-tjdqudcks0424@naver.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 7 Oct 2026 23:51:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9sNGp8G8N0D=4a_SX89L7zGGGcH_kN0r7WUhvur=fc=g@mail.gmail.com>
X-Gm-Features: AclHuK_bkq-JfZGVCFr8SYhVctpq1iWXVLnpTj4qGEFOmeQKJ5bY589IIitve58
Message-ID: <CAKYAXd9sNGp8G8N0D=4a_SX89L7zGGGcH_kN0r7WUhvur=fc=g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate share path for batch oplock reconnects
To: Sung Byeongchan <tjdqudcks0424@naver.com>
Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -2489,9 +2489,10 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
>                 if (opinfo->level != SMB2_OPLOCK_LEVEL_BATCH) {
>                         pr_err("oplock level is not equal to SMB2_OPLOCK_LEVEL_BATCH\n");
>                         ret = -EBADF;
> +                       goto out;
>                 }
>
> -               goto out;
> +               goto validate_name;
SMB specification(MS-SMB2) explicitly skip path name validation. The
filename mismatch check applies only to lease-based opens
(opinfo->is_lease in ksmbd). This violates the reconnect semantics.

>         }
>
>         if (memcmp(conn->ClientGUID, fp->client_guid,
> @@ -2528,6 +2529,7 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
>                 goto out;
>         }
>
> +validate_name:
>         if (!ksmbd_inode_pending_delete(fp))
>                 ret = ksmbd_validate_name_reconnect(share, fp, name);
>  out:
> --
> 2.43.0
>

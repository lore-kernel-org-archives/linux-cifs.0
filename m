Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E033987E
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783054899; cv=none; b=fP0MFz1ZLBht3jumJksDLkt7ZDuc8GA848EQm+Z18CSu2hXqvwZZPPsDAtLMuFRxIrOa05Yvc+/OH6Nv5shNOf0Z8ZolY9Ljz1nMgUWHUYCiK+iSQ9wpIqYz8+efd9GKARf6ElHXplbHAEu5vNMX1aLpr1+JQW5Rqq8s7PJ+e/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783054899; c=relaxed/simple;
	bh=NP+ToeMxN9dFqUvkgmn2huJhs7f9v4z3zgln/xTkm8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQqukaZrGyH2HPAdy8KGWyZ/RUq3X2HaUaixedCq43fRGDUeltKmr3OigBIAYBQE9wWduDLcfK7irlwJdsmq2vrJu7hsJ22Um7thDsUW7l98kPRnYvLsmw/GgaVr9SJjrHZVLdXzL2+onNfBKZVbTZoMEvQL6EF6FSEdeiIAQFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NfdWotNU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NfdWotNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A3491F000E9
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783054885;
	bh=E3lnbLtFRY15TP8d2t4wH4z8cbErkkUwA2Hhh8TL7lI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NfdWotNUSs3+u08dCaGqHaPZ0NJvi752ZQ43xrsKHERxb1BwFi68wRYChE0EhafgD
	 kaFMgitqN3oDQVWju92H4MjmpOGNgr/WdqO1VZUFFuPc2ugF4r9Urno0fI4srVJSyd
	 IwgTmvqO7RtEP3jAXtwbycRMLAmjrmyYDijhbjFcjsChbYSi35lajWZN9kWt4Yza1I
	 OW315Vif4T9Tu5COtVX46TdFfKK8ibfk7i4rFIpsF60Lwnb/c1TUfXfB63xJ77j9YJ
	 zWxEn2z/ZcI4l01ZvQ4Vu/QytfQ+UATKj+z/8C8n7EplaZD7b1kZ6O+Iobz7+nUq8f
	 oh3siiXxygGcg==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-698c0ff45b5so1178208a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 02 Jul 2026 22:01:25 -0700 (PDT)
X-Gm-Message-State: AOJu0YxxK4UHjxAq7mO21Z71STNKbBg6jcNERkCBjvvFYpwIZCdtI/rQ
	uOSkwvpBpsDPPi3kFUIOzCdYXzUeVmXOP6iM3K8uwl0bKeXk2yV60orz6FuMbLRkFhWFMtOyiwB
	sOL//4hVd7zmAxZxtu4q/UcohDaEZqBI=
X-Received: by 2002:a17:907:d303:b0:c12:a7c5:e638 with SMTP id
 a640c23a62f3a-c12c9d3c84cmr108555266b.7.1783054883783; Thu, 02 Jul 2026
 22:01:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260702155449.3639773-1-james_montgomery@disroot.org>
In-Reply-To: <20260702155449.3639773-1-james_montgomery@disroot.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 3 Jul 2026 14:01:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-t2Oz4ZM8BWkJ7uKciaGo=akTMPUEFy2_Z3cx0abHptQ@mail.gmail.com>
X-Gm-Features: AVVi8CcxqVCqx8iIhiuyphANWpKtxkmZkevRDJ7Z67TDeji4pRJdn8lmun10N1Q
Message-ID: <CAKYAXd-t2Oz4ZM8BWkJ7uKciaGo=akTMPUEFy2_Z3cx0abHptQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: defer destroy_previous_session() until after NTLM authentication
To: James Montgomery <james_montgomery@disroot.org>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, senozhatsky@chromium.org, 
	tom@talpey.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 5859fa68bb84..1ce13b23cf6c 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -1670,10 +1670,7 @@ static int ntlm_authenticate(struct ksmbd_work *work,
>                 return -EPERM;
>         }
>
> -       /* Check for previous session */
>         prev_id = le64_to_cpu(req->PreviousSessionId);
Is there any specific reason for not moving this line together?

> -       if (prev_id && prev_id != sess->id)
> -               destroy_previous_session(conn, user, prev_id);
>
>         if (sess->state == SMB2_SESSION_VALID) {
>                 /*
> @@ -1712,6 +1709,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
>                 }
>         }
>
> +       if (prev_id && prev_id != sess->id)
> +               destroy_previous_session(conn, sess->user, prev_id);
> +
>         /*
>          * If session state is SMB2_SESSION_VALID, We can assume
>          * that it is reauthentication. And the user/password
> --
> 2.47.3
>

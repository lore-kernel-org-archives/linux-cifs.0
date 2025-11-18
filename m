Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FA53596E6
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 11:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763465456; cv=none; b=ITVt3AmM90mm1iTUgbrNtyivcWJvAZz0UrN8cnt5tZUE8TXg6pGzrXbmRy7kdCau3NYseaXvoNccmQXtO32aPfXY0Ad4h3Ia+FKaXbbPEzbrQi0E9bemrP8zyuDVBEigmM6I9wk0avBcC5szrkYzOkuH9lI1936HsixEdcYqwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763465456; c=relaxed/simple;
	bh=8G0oC21tMOptGbCUJNNojeexF+X/1jyQulA92pCh78Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SaM6sxAOtA2IsMwNUvZWsgN6UBYZooZo2Xon+1ujiOYqTQMHfU1yj9MK11Vc1vtWm9zq+HRChShU16muR1fEj5/bvmjSaE4kA1/mZJ9hAHI/7jLPc5hZXxuBaw46iBm5xmOZ9a9OGPgorbMxlHH94GZKcvuDhGIb+e1PJ4fZtpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iz/ZJruf; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iz/ZJruf"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6571763793bso2285935eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 03:30:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763465453; x=1764070253; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMk2Gmhyz4mZ0hX/GcBUw/MPizMIU67FwAQejeo43zo=;
        b=iz/ZJrufbCVDadkdjvDc0Dn/Btz/Hg81Wi9HLedZ4rcgGzS+lar7bWToCgo+ZqZUtm
         0nOqjl4DgrokCtF0OE3vL1gwZVB/WxbmzZCS3KmujOiTazEKvt0nK19jYlEIbjhrpCyi
         l/ckJayKBU+OW2TG98EbQ78DauhkfIEa3n9ajbUDjdijh1NLrkXguA3bY6wn0amctQP/
         +MbAB2GsqIjnf58req0S1IpaAk1e10iqSfCEmko/FJMunnQvxvubXpovOvkotbF0LmtB
         6/0/n6wPLgMa+0SIZr2oReQRq+mB5XxJ+bs4UoBiaaiVNwUXpFAxyt0OlJM43/jeZPje
         wrCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763465453; x=1764070253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fMk2Gmhyz4mZ0hX/GcBUw/MPizMIU67FwAQejeo43zo=;
        b=HoEXIYD1l5om/Kios26Y8Z7bkD66TIxECIRoR3iH+Zdl3eJ/6JL3q9GTtEE1M09QqJ
         VYxuqahkR28MRDufDR/b7esG97IOK6xbfOOaUZSm/nAhy4qnFCJnIade3ypoDqLDLfQL
         fodUIbMFCMCzEd4cVneXHRadRv3zwwf+gmS1HB/0tUA9XjET7bTQAQNxB8hRkRmyEGdV
         ijmWf6EuWZeAvjezX7h643S2qUW/i+LwYbRTaXptKLPdOysFEGOCjkHlagERJuA6wWd/
         8bZxj1+ii7Y/LIe50trPK4Y04Y+JMrCPXzOySKIzW3jPlVj2JYpYibU+/8aKmdwxMtUt
         7Zig==
X-Forwarded-Encrypted: i=1; AJvYcCVYPM2Z+H70wiwNnXXDDYk30qfr7TLJ29awI9tpzaKkKBU0Jg8pnNJeEA0FhVZ5nkYXH7fpAtUEE4oT@vger.kernel.org
X-Gm-Message-State: AOJu0YxNBWJuQNN14PpHNk90D7km7BFGt5RAqKqik1hkGupN2C1lkBBg
	X6Z0UW3c1K5BrLUXADoQLL1tq8n00Q0La+rUtTwcnMjrl11SNsB28t40i9wPpas1u548K6TAarU
	13rWpcvgHeCVSCz2OeZiiaLnDzkXhYEH2YG2p1trvY36PXHMNSFx6CDBL
X-Gm-Gg: ASbGncvnsUA8UlTl2wPxC+8lGaetnwCgnxyYKqkymZ+sEwrcCoviKQFujsotG2J88g0
	9Zqs8bVd0yyFtb2j8uct4hf3ztAMLRItd6y/GNGEvB/91FUB0xB+pKIxCMErte5TQTw5gks2/qI
	LGX6PCPQivm0GBNEt/TPMmQwnTI0ys1CLP6acZXcNrxXCHp5QdHcOE7eFPcSvxZlvHF5A+Kpg7A
	coYz2Z6S1TZwvWwaeVCEaAHkWdmnFDNrJLw6AKR5GkvDPUFYkn66W+nme5c2r2V3xcFQVEaZe4N
	/0QATWFCfoc3VAJA8A31SbotERbVRvTK0imMFQpqevIYMlSgncg+yRq4JmNxr+G3luC0
X-Google-Smtp-Source: AGHT+IG0QYbndBWz4vHyLK7RBnTsoT1GlfNu5Qb0hCn0KKGjRcr0+HQRxAxjulyoWCHqvrP1sbD6PFljaIX8mTYvTD4=
X-Received: by 2002:a05:6820:8188:b0:654:f691:9da8 with SMTP id
 006d021491bc7-65733d0fb8amr6036672eaf.7.1763465452429; Tue, 18 Nov 2025
 03:30:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <69155df4.a70a0220.3124cb.0016.GAE@google.com> <8831475d-0eeb-4107-ad87-c9c8736c219c@gmail.com>
In-Reply-To: <8831475d-0eeb-4107-ad87-c9c8736c219c@gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 18 Nov 2025 12:30:40 +0100
X-Gm-Features: AWmQ_bkD1Hb3GiY68IUWKWDhis1zv_OyiKF58zR0hx50S_NNlA2IzblxbrCg6i0
Message-ID: <CANp29Y7PyKg3j7X9AM1r1H+6VDb_F_O7N60svjc1j9WAQksHgQ@mail.gmail.com>
Subject: Re: [syzbot] [cifs?] memory leak in smb3_fs_context_fullpath
To: shaurya <ssranevjti@gmail.com>
Cc: syzbot+87be6809ed9bf6d718e3@syzkaller.appspotmail.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 12:23=E2=80=AFPM shaurya <ssranevjti@gmail.com> wro=
te:
>
> #syz test:
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 0f894d09157b..975f1fa153fd 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1834,6 +1834,12 @@ static int smb3_fs_context_parse_param(struct
> fs_context *fc,

Please note that your email client has line-wrapped the text, thus
breaking this git patch. It may be easier to just attach it as a file,
syzbot should understand it.

>       ctx->password =3D NULL;
>       kfree_sensitive(ctx->password2);
>       ctx->password2 =3D NULL;
> +    kfree(ctx->source);
> +    ctx->source =3D NULL;
> +    if (fc) {
> +        kfree(fc->source);
> +        fc->source =3D NULL;
> +    }
>       return -EINVAL;
>   }
>
> --
> 2.34.1
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-bugs/8831475d-0eeb-4107-ad87-c9c8736c219c%40gmail.com.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2A32F7F10
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784987902; cv=none; b=p7cnnTjCfKVPs1xTKQq4jKvcakT4z2y15hInkx08TlVg0ycxcQychXcom8jLc28ZyRGL7aSxFWkwbPpI7cqF5ZwcxipCnc0Z7lh0vjvE+hnaptDN8MDXCffcrwtlLWSr7QK+drZFj/y2O/jzqzWxGrR2wvgC1VzkjUonFnHyzA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784987902; c=relaxed/simple;
	bh=IbuO3r/bkdWn9Nfelre7xgZqBBkop/X0tZLadrwdmcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhvnaTATm9nxqppWb3FBQG2V3yfDwEhSS8vnBIq8SHEW51U+2puQGL73RaJh2mThRThZH2ByK/UUeiSrC2u0P83RyORaVEwcuirwufO6FZKlTuXIUqL4MgHTfWlS5iuqgUm+/CNwzTBvrQ9T+bGbifvZuI+hDjHYgpTl27Ju6qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ObF+7Jim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ObF+7Jim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0449E1F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784987901;
	bh=pDjm7D0GiBy4go7o/HC6YoP+ILtfpqXnG73TmoRKtWg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ObF+7Jimww2UA924Utn+cX4+Xy/BaUgQZ8+rGVMDyw+OKg6Yi3Bv+cB5fwZPYHLeB
	 Uyx0MDXVxwBlMA1sdgPLOKAl/F2GXnSeFEyGcosWPXzWVxYohDDRTsD9VbzXwWB9Nw
	 at3VysdONP61cd2JZmtVZWZAytLzDKcC85j0a11JZaFlTrwRn3c7YC5XkQ9g2y1J4f
	 +bbLIn4vX2LZpOTz+xtPlkVtjnkfqW/IWAgyQn+ODYLIZ0jCLx+IY7pmmYuTp2XNVh
	 fLVvj2mNKdB05uUvdmPK6MOW0oaDG/GnXRRkbErcADEHB5M0w9lnuvY9Z6DEqcnTlN
	 Hi5hEGK3/1bgg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c197eaaab00so209665066b.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:58:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqNgpY6Vkp9wO1t1sliUgsKe6OwCCYI9IQXVY5dzEe8kzlrTezkFg8VoyvYpIy1EsGF+gblgo60Cpok@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4tLV/GVYcqqBcA+g+B6fHXz4FVnzL3eT7NMZyIzJukiuVF9Ma
	cx5qIIfatwfgh3NanIi0aSkLdfN0ia/4zTcRkLjveDkZGv36eiia4AY6M8nYBbLnfRkL8SyQssS
	Ii15r1HolY4zkQyQyA/17mxoFqISAKyE=
X-Received: by 2002:a17:907:72d1:b0:c16:9ca5:e558 with SMTP id
 a640c23a62f3a-c1f1f3ded2cmr98962466b.48.1784987899725; Sat, 25 Jul 2026
 06:58:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com> <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-11-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 22:58:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8qTX-+PFe5roH_AUqXxpHcWcz-ve97m=nky7SWDjgnHA@mail.gmail.com>
X-Gm-Features: AUfX_mzFImpwcrRc6nm64oxwYLitpL7EaM-iud6EM82Dfaihi8NAGY_Vy9kvNEY
Message-ID: <CAKYAXd8qTX-+PFe5roH_AUqXxpHcWcz-ve97m=nky7SWDjgnHA@mail.gmail.com>
Subject: Re: [RFC PATCH 10/11] smb/server: send notify events to the client
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> @@ -752,6 +904,12 @@ int ksmbd_handle_notify(struct ksmbd_work *work,
>                 goto out;
>         }
>
> +       /* Changes which arrived without a waiter are returned synchronously. */
> +       if (ksmbd_notify_take_events(notify, &events)) {
This can violate the required FIFO completion order. If an older
CHANGE_NOTIFY request is already pending and events are waiting for
the delayed broadcast worker, a newly arriving request can take
notify->events here and complete before the older request. Please give
queued events to the oldest pending waiter first, and use this
synchronous path only when no earlier request is pending.
> +               err = ksmbd_notify_reply(work, notify, req, rsp, &events);
> +               goto out;
> +       }
> +

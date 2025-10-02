Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B24CD189F20
	for <linux-cifs@vger.kernel.org>; Thu,  2 Oct 2025 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759418092; cv=none; b=H1kVFAX5PyKOsONYBdLO6ldT9Mv7h38Fqr6OghxrQX5iV05Hsw9VpsRT0vnLB9W4/vXVw8ilz14nvObJbfXE/R6nX+7QU57Qw98ZHAo2fIhzYMTA/730thXfsNp/swM7bP+RVrntrWG9LnyZq/7Ey5Yf63IXTjE4aNwBWQreVxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759418092; c=relaxed/simple;
	bh=PduUZoikr8LnqAZaTzWf0aljgdXphuwsyDaOnjpUC5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o5Dh0BOMDhWcup30mAIF9v9H3UrTCMPfYQqq+0H+1YCXKmda1xUSamVcZ31sIYQ0Q4AMB2NaZ4ChnQhTsYa1laUW/K331fjhFVygqWkCP9BplgYrU7FL3d4wLgJLD9lFr6cCfpVwa0jArZ9ppS8oACLVj/9c11nHBU2rY7iniXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6O3BzEL; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6O3BzEL"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-78eba712e89so10341316d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 02 Oct 2025 08:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759418090; x=1760022890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PduUZoikr8LnqAZaTzWf0aljgdXphuwsyDaOnjpUC5o=;
        b=X6O3BzEL7gA/laF1um/c7axpZUmmp+wVsQtWPa5nsLsmmCwh1m4ALhXJmbA8+cblby
         4888/pG1pDgUXY6e1NDvYWhRNUTqpfnL6To5Z26rQA6eFoTCWig83HXDoEEDDkTui+/z
         LAiQOwG03S2ABLV2rCOtpa88UKRCEWjt1Q4ul2crynEhj04Jde3PSiOp2CNt8gsgEzin
         gLI3Wumy0R/qEo04RYJkl8D3jNWhZZQXQubCv0L9U9oZyZaf4EDH+2JH+ah/Bk9GKM2A
         Xw7HZVJbyoIktiuZVKII2Hjrn0EiTDj8d50jKWdfMIQ85LY8aj52PNPHYpVpExMPrl0V
         TXQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759418090; x=1760022890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PduUZoikr8LnqAZaTzWf0aljgdXphuwsyDaOnjpUC5o=;
        b=M7VrqYXjqtzUO5dbjmPkjMNMG+S7FvG11gExybCLV7R7f7QhR2k25Qgs1TzqRJKqZ/
         WbdN42BxvuoxzjeqDXEAs7AL/vULB4gBgYd0ZxPQM/BnLD0t7ONyryTQuN1xNizWJDmf
         /eB5JKQa17GrtpqB0xtPpB5gSa7JjyCTQLuH9VCB9o1CWz1+wwAshEpJbr++8cjLDOUt
         iNJY4vb6fPcb2WdqnohEKAqAslBqm1p0ytVyhkg+CJ2cZg3OCvjIkleq4obtBfOYkbnJ
         fNhfsREDlYO0/hC5kjujwWrvzNPSxbz9RKsKHz36njm4+wLlJak8otceTiZgHaTTItYQ
         kkiQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0Nk7Xu9NLqlMvbcg5861+47K+52sBjE9WwoaBW1oIR0jUp8XGmF9ZpKzDuFvx7JsgiWb9tW8LvDll@vger.kernel.org
X-Gm-Message-State: AOJu0YxAL20RxCoXwy41/DucQjO81CQAqGqV+xRgaIcHBtBBxp/VxJsP
	WcH6tQSzFHpuSWjj6rmjxLSVddy7INTfidx+l35QxVvv4XFMCHmuzh+FsKUZ+KYPDNBusxf/rKm
	2SO3afRXbzuZFty28aHqdsFKMf1IuG6I=
X-Gm-Gg: ASbGncu9E/nXaB+hD1aGsIzP/yd/v71OwsO4I5PM6T+a/T/zIh0lDF6OJ2JIbhv2iZy
	quatqD+Q+WXTT6kTxRiMqshWVBvM2FPIz/eEKvk/c9iLlu7AT7+rAGe72cFa/1mq/CkEsMtfvYj
	RNSev6BWZz9C/7nyzaF+MjAjoXLnDFy5yKCON7hFlV7jOZq38I1BEKITA39KkekOAOGoDbp9f4T
	5er8Aj117XVLTrkIQkKwPXuvuxhQpCJywbyEdar2/8oS6BSqMA4GhGMTUacR5oA2z/0AE8ow058
	lGuBB3rxQTxgK3PtH5M/aKK8IVJcOl2uFr+ofMqxs2LqqHi7VtltuEENBPaI2OZg3E4KWvk2ZPP
	h9pJX5wjhmA==
X-Google-Smtp-Source: AGHT+IGyfzn10GjCw6AbrHIRNFIF7sVwOU2PmWXcEbIdO80lNgoAtt7bNshbrMBB5VQ0QLFvb0YDQlUlMexok3l/HTg=
X-Received: by 2002:a0c:f088:0:20b0:786:d65c:1c3e with SMTP id
 6a1803df08f44-873a06edb4dmr97474656d6.30.1759418089626; Thu, 02 Oct 2025
 08:14:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <7f956b3b-853b-4150-b2e0-ccd430adf9ac@web.de> <a9518620-29cf-4994-a9f4-a6f862d8c214@samba.org>
In-Reply-To: <a9518620-29cf-4994-a9f4-a6f862d8c214@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 2 Oct 2025 10:14:37 -0500
X-Gm-Features: AS18NWDp3jCCqFOTgwnnq5szZSBZZh9XBeoSBG6yvmFg9Zc70t7XgYEAJdiinjo
Message-ID: <CAH2r5muh7GCAdNmiF4YjJrP5p9wVeU+OLC_41um2_Yr9G8mhnQ@mail.gmail.com>
Subject: Re: [PATCH] smb: server: Use common error handling code in smb_direct_rdma_xmit()
To: Stefan Metzmacher <metze@samba.org>
Cc: Markus Elfring <Markus.Elfring@web.de>, linux-cifs@vger.kernel.org, 
	Hyunchul Lee <hyc.lee@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to ksmbd-for-next

On Thu, Oct 2, 2025 at 7:31=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Hi Markus,
>
> > Add two jump targets so that a bit of exception handling can be better
> > reused at the end of this function implementation.
> >
> > Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
>
> Reviewed-by: Stefan Metzmacher <metze@samba.org>
>
> I'll add this to my for-6.19/fs-smb branch and rebase on top
> of it as this function will move to another file there.
>
> Namjae, Steve: this can also be pushed to 6.18 if you want.
>
> Thanks!
> metze
>


--=20
Thanks,

Steve

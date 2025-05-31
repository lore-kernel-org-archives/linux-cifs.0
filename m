Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4845513790B
	for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 19:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748720243; cv=none; b=oBSWJ0SRqHYjU2+eCcW0LYZeyHdFA6lja/0j4QI7BaB6P52kDWUVDNBodgsZlFYQxIYGdFhQ+B20IsFPhCk8nCMZHsyJuJJTiL8cFHBMJrUDBe79iiNsuChEfCulKo2NcPC5iRP5Oeeg9sTUCboJu/uFvWLxnAUpMR3wxBx+8Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748720243; c=relaxed/simple;
	bh=8MDNwx+Q/pMv/7+iBrypXo9VmYaRGxBsBQQhIJLhwXg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rXIrBLcWpIQsMUJlY8qF6E6RH/dPm+7lgO98Zg4cFTFTqte6qvP9ILQNzT7iUpqZXQ0gBYdQKbeIgq6ZF0Y+JWPEbbLdS6hrBGw63K7/m07gPVGubo+3VecfoVlN+SbjlgqTkfeB26KT0S9ONSzpcR7wwPb21aZ44BiFTRGAjGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lAIGDf3I; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lAIGDf3I"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-32a61af11ffso35043871fa.1
        for <linux-cifs@vger.kernel.org>; Sat, 31 May 2025 12:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748720239; x=1749325039; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDs8u8vb9kPfwkxfjdGAtSvoJK8yBI8BB/W2yi05NU8=;
        b=lAIGDf3Ik4j3buq2DVCGrF9B/NB3uYxM+xAfQd0rpWOqTKnq1OVHm7sYbykXfmPmf/
         JaObQSr+qk41r9a5r2+dtCWIxqk90lWW3jpoe7qFgv9KmPLU2AiCgIG1zc4v3SykNEeB
         V4wqksL/0uFpq4G+nCgA5lb8D1a6IomtNBpApVlmU6dCi8aEmfY9FA+vCQUcthovQ2PL
         J8yE2m2hnkTvKmxw+nYWUwsGASJ/KUiYYhFlQPYWkc9alD5B5wFjk2Wvq5y75si1rvuc
         /c6DRFlwUCeKp/0Q37D+6MUBznQiLc7z9TPskxooBCgYOgvp6OfHpxc0TnfoHus44apV
         171A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748720239; x=1749325039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDs8u8vb9kPfwkxfjdGAtSvoJK8yBI8BB/W2yi05NU8=;
        b=DSERjUhMrWVVt7jjr1sQFTSKOBGhn8X++m4cw9dV1RmK5oawJ1zv5h83zyHkwQTR1Q
         q7T4TZYZy0CxAlCmUZ+GHA3UcdDlnADPTaLjMQPqIN+e8vZ+D+g31O6PM1HkjfCFYVHn
         lLQe7e6OSGhIaf1zhmlkA0hmse2vhh0VTS7KF5PhnSiK5nsO1javB5OPeXFIzFZuOdsq
         dtr+u5qBQSD+vBFk1qUm/DKTRmk1nRy+MMU2AbF2xbQGNhsSYfTUH/8PCVVMIEBi4JWn
         FqKtkfuzbgieqGzMp9G82VQlo0xXf16SoH1YV3fQ527KBp44TuoonGiHJZjBiCs/m9v2
         HTjg==
X-Forwarded-Encrypted: i=1; AJvYcCUKY44SPo9tMSsocptNCIETH1Arhl5hAnf1jVLsDtZlfhmY2fWNYZCSDD5JY0+is6ozlUEYGkr/PDJc@vger.kernel.org
X-Gm-Message-State: AOJu0YwQLOmNvi6g1NPtmhKG6FwMUNToNh5y+lCsdbPe/JvTjGa7wWqc
	gq0BBlk9IXLJui650nmgg7WgNrk64EIyM9BD6SRVi256SmtgTmZNlW+OxgLw2XhrCXYF45q6Hx+
	zhHR/U0NVhCqY36W3uN+Z3sNMFwrdvdb4a4f4wv+lLw==
X-Gm-Gg: ASbGncvasphZAKdccF3gMoSpmfub/SVWqn0Nmod5uvuoW4goBoGNNeklTx/wcn3YnOv
	wQgEryhF1VsQ+B7eC1iEZ0rfsBHdQ2u38Ar2V9kmGMUK/uMbrWgGv1PAz/UzaOFAeAoevn3FycL
	4T+oDfmbuiQkChbIYQ4VJjSadHBuZ2WjkG
X-Google-Smtp-Source: AGHT+IHES6IUsoZhu4WrIkaM6eEWU+XxP+2wnwa5zWwWBOz2xRCNacD158U6lyIVsz/xhKHXkHIYuH0kSDat0ndtZyA=
X-Received: by 2002:a2e:b8c3:0:b0:30b:f0da:3ae7 with SMTP id
 38308e7fff4ca-32a8dbd6f26mr27306381fa.14.1748720239213; Sat, 31 May 2025
 12:37:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org> <2025053156-gilled-mangy-e8b9@gregkh>
In-Reply-To: <2025053156-gilled-mangy-e8b9@gregkh>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sat, 31 May 2025 21:37:07 +0200
X-Gm-Features: AX0GCFvnZg-kfPLzEAbEMy-_yy_nWNUNyv8-Ak-xoXkDEsbpsOB7mGAxJQhcxgw
Message-ID: <CACRpkdYpjWMNbmj6-A_3XEbS0W6Y+UaMuAc2Sra_qebtJvBSbA@mail.gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 31, 2025 at 8:56=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, May 31, 2025 at 08:42:44AM +0200, Linus Walleij wrote:

> > Adding MODULE_VERSION("1.0") to ksmbd makes /sys/modules/ksmbd
> > appear even when ksmbd is compiled into the kernel.
> >
> > Adding a version as a way to get a module name is documented in
> > Documentation/ABI/stable/sysfs-module.
>
> MODULE_VERSIONS() mean nothing and should be removed entirely from the
> kernel tree.  The only "version" that is an issue is the kernel version.

I get it, I need to think of some better way to handle this.
(Adding a random module parameter just to get this dir is probably a
bad idea too.)

Yours,
Linus Walleij

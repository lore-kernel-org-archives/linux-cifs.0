Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB9832AAB5
	for <linux-cifs@vger.kernel.org>; Fri,  9 Jan 2026 12:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960982; cv=none; b=df0aFTkzhmacA1fc7+ylX6xGKmRrDGxLDwn/67/KO3242OSugU/81tDXhkF2S+rxDJRm021BuKjkDkmcFfC+xc8LY1iG/cRAVnvo3HbO41+8cyP0fH9VTxuAAz797a0DZJ3pg/s7DAHau18pEgAPUMCwNmMJLIPeC6YIFTYzzPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960982; c=relaxed/simple;
	bh=1DPRooS4SVaOvVOPS2Q3va4Ao9cficnxbkJydJL71Mg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V1w2GaPyynZjz1ADsvg9Qa6GxIyUSznrBi3RWT6sgAjTorMdA1PxgbkbDADB3hqTgx/SM3eF/LT9g98C0XDgRNCzk2UGlusiPr1aW88zwyg/iSKMDon+614yoJ1QKte4bVcSpU/aE4gQglQivStGKpBeML8yLfdaCyYooptxlT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDiccaQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDiccaQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9952EC19423
	for <linux-cifs@vger.kernel.org>; Fri,  9 Jan 2026 12:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767960982;
	bh=1DPRooS4SVaOvVOPS2Q3va4Ao9cficnxbkJydJL71Mg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RDiccaQpsEQqjvSprkBRAts3O95mK7R/DYEV1zyGWYPWbElQQM0MClBV2DyfRMt6c
	 9H75O9jZ5QkErTrsbb1VQiQA3A/n2/ndmY1hmT2MKp0y647V6FQSBugPLnpbrSCjtw
	 zttivrAwLlE0O2tlF3m+H/6nTGuTNINyK5zIDzzYfG8NS8NJh0Lko1dRN+27xnuiaL
	 fqZHp+YLMf1QYUd1elvBbngQ6jdWdlcaPcUni6cKGdBbRYicFhzSJH9fbSvG1YLbLd
	 ysN7OJ3QZ68Jug7/VFLVD/aXAHDhwWyoCm79lc4uNJYnGxaFz1YoXVF7Ayuap8P0u6
	 T6ntrbSjWVqYg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b727f452fffso460334166b.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Jan 2026 04:16:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWNXVPH521AgoTdI/1KoudYOn3yl+YLc7Rpf/WeUhtzYYP4QjJMiatM5J60g+AGp8Br4sMpEWPw0zCF@vger.kernel.org
X-Gm-Message-State: AOJu0YxPsGb/bz7xFiCm6lK+lZjeVYsFd6aXuFgWUkiXg008E33meGqM
	p7R71Lkht3o1af+9kRX8lmAzh9LKCjnQJKLpNCyRzZEomZBPITUWXesBXRqoD2flZOUeL+5H7Zo
	fcOQQ7w92+kEqYTHj8OxBPMnxw15+rXg=
X-Google-Smtp-Source: AGHT+IFpIESaPRsYpx1iiqwXrTZGzEOnCcF9g5fS8T7Vgp+Fia4soR40WhDH1PuCiBGKQBMu8pWfXAx7VDznaqvPgbM=
X-Received: by 2002:a17:906:ef0c:b0:b79:eba9:83b4 with SMTP id
 a640c23a62f3a-b8444c5a60bmr1143001966b.6.1767960981252; Fri, 09 Jan 2026
 04:16:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260109103840.55252-2-fourier.thomas@gmail.com>
In-Reply-To: <20260109103840.55252-2-fourier.thomas@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Jan 2026 21:16:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+kB786kWGetUUJG22CWzG7GuJCYYOLmTxRsY5i93AfA@mail.gmail.com>
X-Gm-Features: AZwV_QiG8SImZKCuVBzH-znCHBBY3UmrU5jGIYcqzk8Y4klTC8446Vr08GrTQLg
Message-ID: <CAKYAXd-+kB786kWGetUUJG22CWzG7GuJCYYOLmTxRsY5i93AfA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: fix dma_unmap_sg() nents
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 9, 2026 at 7:39=E2=80=AFPM Thomas Fourier <fourier.thomas@gmail=
.com> wrote:
>
> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
>
> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing an=
d tranport layers")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!

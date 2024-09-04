Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964161E871
	for <linux-cifs@vger.kernel.org>; Wed,  4 Sep 2024 14:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725460233; cv=none; b=FCndPGembu1sg8jJZJeyKFoT2U4CcDuWqRWAG+FPzlQ4mokwIV/s5QlPKqU+az6wDK4NQz4uV4fqzL4r8TT8ovfsr5/lPYqk0pySCvDg6ojvOgM3zOkzjkEjrVzLDmgSjoo2TpJ9y+f8dXi8kjPVLnHfN8667DA3BRbUdTPq9R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725460233; c=relaxed/simple;
	bh=Qv3+bWGBOEFD245z2fq08+hC53ZdianQ6Rb24yS/HSk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bdD9vuN5cgJtmPoW9kOxmAVmYwpj064kLt/LWNRXUAgFkiZipedrd4p+8pjLC7XhOttrpIYYm3nNrbnjj+vSXK+i0yrCJZxDdE5TrFgHWbbVu/EA8IhnhedpPgazM+tZB3Bgr4Uegks4NJfq7reCu9jSx/94DhrjwKjpZ3pu8pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7/q+vFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7/q+vFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C87C4CECB
	for <linux-cifs@vger.kernel.org>; Wed,  4 Sep 2024 14:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725460233;
	bh=Qv3+bWGBOEFD245z2fq08+hC53ZdianQ6Rb24yS/HSk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m7/q+vFrFDXQvaS3E0w69mu9OFNSpJCeLV7oSaQ2BEyGqQoxPaQY4POuNlp8PKGeZ
	 bLCCcBnrUf76J6QzoCFAX1oRS+Ea5RG6e/stPaK+WDpnsroPgklXW1c8pV8XgEA8lt
	 5rYKOs+GujG17l4k0T7ToJrxAwilg/vop1p4M/YG2ALRhTSOfu6FVUfCygbpObDRFf
	 o53gvlgO5AG4ZRQ8aaxH3OusAopQORDFgigdCVGdraGFco66dW5pPnUmzVt22pUjGJ
	 e2BNoohV/GrNNHMOr+A51zcIDzg2CXJB+ZiRURc0LiQjg4IY5l16Dj2I35OVoDUDRB
	 Yln9FqHimU1mw==
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-26ff21d82e4so464546fac.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Sep 2024 07:30:32 -0700 (PDT)
X-Gm-Message-State: AOJu0Yz7vUpdIMyluZHXKvw3LFO4Lt5X16Z0LMf8zx16EB5/8bSr6q+Y
	2qXMoH955823VqTVYxs22zq9JThbddMdPt0NsCRgvJMx1vE6pNxFh+m6NufHt9jUtwUBPxmXyAp
	MGdG8Loy2BWaiL8z5rQ4R508Cuc0=
X-Google-Smtp-Source: AGHT+IGIBS4s+p5Wx+1MgafHfQlTpbHcIvfXJ3q5B0U1jURihIIajMmldwUZ8r+QD9rA6srW0B4DOSTaGnolwUL417M=
X-Received: by 2002:a05:6870:828f:b0:278:3de:c8de with SMTP id
 586e51a60fabf-27803df0c8amr7645999fac.24.1725460232294; Wed, 04 Sep 2024
 07:30:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240904043639epcas1p27080078eed3604d12cff3b01d7636343@epcas1p2.samsung.com>
 <20240904043635.782603-1-hobin.woo@samsung.com>
In-Reply-To: <20240904043635.782603-1-hobin.woo@samsung.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Sep 2024 23:30:19 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_e+59DgaRepHBwck17nZcA8WwNNWN5xLm5TFAKPVZbgg@mail.gmail.com>
Message-ID: <CAKYAXd_e+59DgaRepHBwck17nZcA8WwNNWN5xLm5TFAKPVZbgg@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: make __dir_empty() compatible with POSIX
To: Hobin Woo <hobin.woo@samsung.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, sj1557.seo@samsung.com, kiras.lee@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 4, 2024 at 1:36=E2=80=AFPM Hobin Woo <hobin.woo@samsung.com> wr=
ote:
>
> Some file systems may not provide dot (.) and dot-dot (..) as they are
> optional in POSIX. ksmbd can misjudge emptiness of a directory in those
> file systems, since it assumes there are always at least two entries:
> dot and dot-dot.
> Just don't count dot and dot-dot.
>
> Signed-off-by: Hobin Woo <hobin.woo@samsung.com>
Applied it to #ksmbd-for-next-next.
Thanks for your patch!

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB31B641;
	Sat, 28 Sep 2024 00:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727484238; cv=none; b=i3sr2CAApeu5gKx7yWGT8Suh6a7v3c7NTrxXe3zCalWAT3ZV9itk+3lCSe9q65tgoRTLCr2IDJLAh3shIggFpBz90OqiFSzX/1OI00wlQspjmH8lKeu45itev4CJ+bJVdK3yNicEp+CY4fbioj843Te9H0NsHS2uMiswqNPMTGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727484238; c=relaxed/simple;
	bh=1Nkv3/vZsyn0bPP6JMKVOIIvIbroZDhLV82CtZVVTcc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cqaiPmtqN93pug/FCVPLi4ZShXKB2XMjLppilWrRBmK2g6FuWYIK1hLmCBH3uVJxAQPgeWYEfshX3ZYnmwJSsa9JGNAyaGdrhHCZz0vcGligUjd2XzYWOczlcna5Sn2f5ckkGyvasyYNhHKHtGrhYM3Z1E9/CgWnpCJQtI6kU/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A3TShJzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A3TShJzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5A9C4CEC6;
	Sat, 28 Sep 2024 00:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727484237;
	bh=1Nkv3/vZsyn0bPP6JMKVOIIvIbroZDhLV82CtZVVTcc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A3TShJzIPQC3BvdFkGppCuxAETLS/v4HO7bWsyDrqoWhqc7jvTqIVlpLdJZ5GidNj
	 S5J8AR4/PVja4ok7p6x8Of6e+BKYZCrJCbgIWHtkTebA3hJfc4IaS4EqgPPrjUwjgC
	 EsiyNSdoJdj+/feZANnLi1BidSL4SFGyz6PO/qkByO7gWS6PWmc75IrO/QmVPiixOw
	 4VD+ZJsKp1ybYH8qmDrujj0QRZK8k6u4VixGNN1ULdaLoLkTQEUqUM9+7Pr9maa35+
	 VoRCewgQTiaG4Vi02C0ZD/ZaEQLRli/F/4tLwWj40+nMSSoJts5Io/9tS3Bo4XyNqb
	 FxionpQk6+/zA==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5e1baf317c7so1155020eaf.2;
        Fri, 27 Sep 2024 17:43:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVDkqYfu0wEMy0Ot3Q22noN0d4XTqdhtUbXy8kFjr7Mz9Oc6ubuJa03E4HOjRuJEaYC8nPWvmJ45d7Y@vger.kernel.org, AJvYcCW/0pl5qpp+KcaaLryLXIDGzBkAu1ObIPp71YvSWDGv7StP1wiSpDMS2pMOfYU4cfXOJWz2gEJrQwBQl/1m@vger.kernel.org
X-Gm-Message-State: AOJu0YzJLUSXxssfOYzcqwVthuo8FfWlYnKCh6+44icDFHulWPOixwsl
	/HiP3FHUVam3Jk3QblUpZwG4M6SmgmT4fOkQJhIGIiDc8MdVJokF9uk9LeqXCRFQopIfVz2kBd/
	dTvlC6JpUivL8lB9/d04+bAO6AvI=
X-Google-Smtp-Source: AGHT+IEPKZbfE2U1eNHim9IuiFMSauP5e22V0EpAgqJZa0n89StUqYHPt88fePg+LI2f1c+r6mjoS3IxbpRNdV2VxwU=
X-Received: by 2002:a05:6820:81e:b0:5e1:c9d8:38ca with SMTP id
 006d021491bc7-5e7727637a9mr2766761eaf.4.1727484236969; Fri, 27 Sep 2024
 17:43:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240927143642.2086-2-thorsten.blum@linux.dev>
In-Reply-To: <20240927143642.2086-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Sep 2024 09:43:46 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-WoiaJP23fMUCY8Txyo8wG0Rsfge7BkQ2Ub5AseJ41ww@mail.gmail.com>
Message-ID: <CAKYAXd-WoiaJP23fMUCY8Txyo8wG0Rsfge7BkQ2Ub5AseJ41ww@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use struct_size() to improve get_file_alternate_info()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 27, 2024 at 11:37=E2=80=AFPM Thorsten Blum <thorsten.blum@linux=
.dev> wrote:
>
> Use struct_size() to calculate the output buffer length.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks.

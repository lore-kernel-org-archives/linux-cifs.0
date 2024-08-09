Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98F199B9;
	Fri,  9 Aug 2024 02:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723171903; cv=none; b=jvvoBaC+2d2v5n/bPUFMcI1vVPz9pkzQML4IZ36mqAusSQj6dpGXc1v4w7UIeRmud9Wt9a35+rx66GnBx77csW8Gxvv2/+iyG3aHhu9U14+89DQkV++IEX4wjJA4q//tleDHfEtDMF7qAYlo/+aCkbvm+EJZXnTC4dQk8I2MYd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723171903; c=relaxed/simple;
	bh=Pa7eDJ4t1xpc18+Np23nsKw+Qc3avfwtmBY5kU8KZ50=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H0Owp0FLuGB8BY7d9d4IOTrgY1bK4P325PPJpL3y2UiaQphKK+zNC3l5NxeGm9xu3YDVm1DUzO44Y4vBVK5znurITx8ovneGQbKKtKgugeqqDfF9IBBwi+gpa2EXwLVgP0tkBml7JdLGeqZaZUM+JmykZuGzs52RUWVCYsqh1RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tp2RTvOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tp2RTvOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CACC32786;
	Fri,  9 Aug 2024 02:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723171902;
	bh=Pa7eDJ4t1xpc18+Np23nsKw+Qc3avfwtmBY5kU8KZ50=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Tp2RTvOgG3K4xiDPI7cCiLrTQs1QX2Bl8yGPYlnC4aio0GCEidWPGX6jqMoXF7Wre
	 BWlskMjaVUut6fuLMHcruUIw14PLApn3VNdcGecwOAtQFlR8TnRuOoA52kB1qgw0cA
	 OYbjLLrJQNTp2eWRq+kIIwlPCXKh6d2GmaJPNnTYkUSrn2DnOXFvjgv4ihKqC03asb
	 yvUbgW1S45OwDJjdf0CVyyNKNJ9ZyvGxzz/Hg6QmaSMgy0r8cTHgSkw6hbABj+SpCH
	 okFzxwdgB08ySM0CrPGTjSfPZ286vBBbQOgAKYNmSp9bknI0gvo7ebgL67QW+wlWJD
	 /GwUgmQDOnz8Q==
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-264545214efso912687fac.3;
        Thu, 08 Aug 2024 19:51:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWiM3V8kfE6/6zcXY+kPwRPcQICUS/K814R4u+E0AZG88fa78jk9jqm2avMlpVcqg9sqWfrSmT+Xv0DnuEe/b4KUWcGkATrqsmli8E5okfuxjRxvGBSfnypibnPKO/vWRGchSEgvqV2lVfI9MWIHqgNqm0IxVFePt5laXo/Ii1mgxalauRyxTMlww==
X-Gm-Message-State: AOJu0Yxydl7PIT65Oqs1p8krzAkrGtIscUVtSb4FWKFZQUvQMtKto3tL
	olbB+2xAih6oaynSXceAqJkeBiesu7/zsZ52lJQg34kd/3FgYlFqU0b/eSwenqtykcsPewt+iv0
	y4vjCwksBIH3V+rKQkV6viGFunJw=
X-Google-Smtp-Source: AGHT+IEoUjgjrKsz7zNykn14iHMUq5I0duHy7vcOoiOasSgT3fpmZ3N3RprxQxmTKbqOGsGT1nvjMGBGPRFnlESiqUo=
X-Received: by 2002:a05:6870:46a8:b0:25d:fc34:ba6a with SMTP id
 586e51a60fabf-26c62cbe04amr286423fac.26.1723171901804; Thu, 08 Aug 2024
 19:51:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZrVA1N6Iv0Byb3I7@cute>
In-Reply-To: <ZrVA1N6Iv0Byb3I7@cute>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 9 Aug 2024 11:51:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-5gKBEAO_GvSKBLciiB1qhjevTSd8kre_-nJQpTw+3vQ@mail.gmail.com>
Message-ID: <CAKYAXd-5gKBEAO_GvSKBLciiB1qhjevTSd8kre_-nJQpTw+3vQ@mail.gmail.com>
Subject: Re: [PATCH][next] smb: smb2pdu.h: Use static_assert() to check struct sizes
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2024=EB=85=84 8=EC=9B=94 9=EC=9D=BC (=EA=B8=88) =EC=98=A4=EC=A0=84 7:04, Gu=
stavo A. R. Silva <gustavoars@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=
=B1:
>
> Commit 9f9bef9bc5c6 ("smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-en=
d
> warnings") introduced tagged `struct create_context_hdr`. We want to
> ensure that when new members need to be added to the flexible structure,
> they are always included within this tagged struct.
>
> So, we use `static_assert()` to ensure that the memory layout for
> both the flexible structure and the tagged struct is the same after
> any changes.
>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Thanks!

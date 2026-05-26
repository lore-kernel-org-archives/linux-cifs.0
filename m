Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EE01DED49
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779806077; cv=none; b=GVQGPZEflsNzdfLqiLc/l5U0zzsBp8+WkmCNYpynYR1dF0OR9NbMrGWXDIAUXhIbK6h76hOGhVtFlulX+6gH+CzMLA6ONXRbyT3fJ+oHa1zXlGGw2d1CakBkjNM5tNcrICmOeobSVQt1nduRm2x1jeA+sV5R0XwhjWwOCU6GM8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779806077; c=relaxed/simple;
	bh=yFoOpsWUbrwn9+NYPdFQqQ/xsHh5hFNztMA89lPZ4s8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBl3fG9jfjsSWNaX80v2R3je5AHSDXmVZimv5C6Nt5A6+bFJoKimpiAvsxKrDW8H5VWTFjDurdPOPzEMlHpx1b+lNM+irCqZZHRb1lSzMqQ0Ra8Ob8cxcVmcGH1aqlIVuls9Kmw9PZgcPj2AZ9nNI04Q954Nv0VpGYXY7ldb80M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1aj48HN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1aj48HN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04781F00A3A
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 14:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779806076;
	bh=yFoOpsWUbrwn9+NYPdFQqQ/xsHh5hFNztMA89lPZ4s8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=o1aj48HN02HTTPF+NFA9kS6qkjmPm1KLBcDiCvQxnteO8JTh853FJ9l9fh9jMbvCJ
	 C2uSqF7JbJ+QjH4FlDzu3FIoD2fR01VUxOxp2kfRA5ij5/lGawtG+7163mNHgpKCPs
	 3syuUvHBXliM+MmTtir3UuzB/SdxTXFy0pZjNw9z7sPx8VUWGFbXjLc3//l4ku3zUr
	 sWq0eTsEtKbL37pizLCxUQpBxtq9r/3XBDfR8fjaNph7zgB2SzopPC4LT4C5iiNtkv
	 db2+CmL1venx2OGcnDw7e8GDEof0U3gQmYKRRbZ2YipuFugpdxqgj6CKCixCOTksHj
	 FrBz6GpeGbKQA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bd2d8bb1068so1995777466b.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 07:34:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9k6+FAlwDrjHgFKMAZUt0aT/JnSoF1vnPAF/0UWJkBhemsVbooI2y0C34D3oSoRwFSWVebWuf87dtK@vger.kernel.org
X-Gm-Message-State: AOJu0YzprwxlqJ9U6mVOmsfLZLnVDffkGaYEVIHjOdXdt43ersi0KEB7
	k/BDSu0KyZLOmdVJg+A3S5qkiWKLN86yS371IIGdO5Phx6BxcarzbT8X0u+JnpdscFPG+IJOUDc
	xfC1NRO1rnXFRKv1ZgeXWvobGSyHksm8=
X-Received: by 2002:a17:907:75d4:b0:bd5:40d9:c6c9 with SMTP id
 a640c23a62f3a-bdd21565a91mr792630866b.0.1779806074651; Tue, 26 May 2026
 07:34:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAFdAxs5xz_-jE7+Gg5P=6L5UvoVJCZnF7QHmiCE5CK+1zn+vHA@mail.gmail.com>
 <CAKYAXd8z=ELtutzKvSUaBikyQZ7nD2etSZcLNR3DugjoB_GLgw@mail.gmail.com>
 <472015a3-3592-4eda-a2b7-9ac2304c1d24@samba.org> <CAKYAXd9wf9L6-ij1AL30rn9jzd4Rdrg4hmptSMBW+rU4HvA=yA@mail.gmail.com>
 <CAFdAxs6Ljafk6fU=jwaH4pwfebjLbaAAttTiar+gsSjiyfNxMw@mail.gmail.com>
In-Reply-To: <CAFdAxs6Ljafk6fU=jwaH4pwfebjLbaAAttTiar+gsSjiyfNxMw@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 26 May 2026 23:34:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd95A0Ph5wdsKHZrwDJb09AvTFuNKYOrtWjYodSAYKAXBQ@mail.gmail.com>
X-Gm-Features: AVHnY4JRQzMwcFC5AxWaokzTOB0u80MiDPPPVi1KOkBAwdzSf15J2hhe_yIW0vg
Message-ID: <CAKYAXd95A0Ph5wdsKHZrwDJb09AvTFuNKYOrtWjYodSAYKAXBQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: add missing software bounds checks in RDMA
 transport layer
To: _Vx Ano13 <ano13vx@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, stfrench@microsoft.com, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 10:10=E2=80=AFPM _Vx Ano13 <ano13vx@gmail.com> wrot=
e:
>
> To be honest, I don't have the bandwidth to rework the patch or
> develop a PoC right now. Since Stefan has already confirmed the issue
> in the SMB2 layer, I=E2=80=99ll leave the final fix to you guys. Thanks f=
or
> the feedback.
Honestly, I can tell that you used AI to create this patch without
understanding the project. Even your response to my question seemed
like it was written by AI. Do not forget that your poorly-made AI
patch is wasting our time.

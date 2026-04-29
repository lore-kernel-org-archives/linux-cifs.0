Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD12F32720C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 10:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777457856; cv=none; b=pyElaU2kthYKAftuH/4SEsBX/5AJb2XCZP3WFBiWtvTdFW/UdIXGThSOC8dELCfVlHtZifVWD2jWZbHHq0wLop1k/R5tyukk8X/7mM7uy35SQPYTMCO2/F7SUmuLNnvebJEbz0bZprBQg7JXR7l6IEipw2ZlgaFAayIJKPrrWbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777457856; c=relaxed/simple;
	bh=fQbhdiGUrI5ESJ7CR1gbX0K0Lf+zodJ5LwrDU6i6NOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YERnR1C3GWquUCf6BeNkG1R3ZaZMBejNa6WKc0NcvZ/W/QT9TVdC0MJQeiUDKWmiLF1iBJfRjjh1jlYVxuPvQqwdMVUXUp0P0oBSH2ZwZHF6LKG17StFcAXkhBW367uM9vfDrsKf1HqN8INibrUiAT2AUIBfXPbA5bq3A2H2i5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0AoYySv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0AoYySv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9499BC2BCC7
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777457856;
	bh=fQbhdiGUrI5ESJ7CR1gbX0K0Lf+zodJ5LwrDU6i6NOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=t0AoYySvIxlq05/X2qe5UeFMZCJjHo1Awo2oGiPzi3UuwG5WtR+bvF3oDTNj4Of8C
	 NXwm9fMnMVheegYRiHJlQ3YqhxAfTr20Ue2iScabbOpQpPxljySfFVRS3IWgB1bKr5
	 malJPdYipkjZ0QMBpZiPcuRcBLVa8Lq3hpH/b/JLQ42EppTAN5KS1FdobRJTKik+LP
	 eXPSKhO4lGYNNg4/M72Yk/vff5YzabN1z8ozwp7NV0OZZ73EuLGk5UEtZY+GPoOBtX
	 YJev8jsXcnAm3WUkxKAJBeZ1Tsr3z0dxVxqjP7UtjVISaHYDbokIV7fB7Lv0V3LyTk
	 gHc1kGCya2U+Q==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-bb91b426e40so166128166b.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 03:17:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/OCWmeSQa9A2I4LAUkSl7ZKNNT0TB10fdHkEIOe7vFm6dAvIuvegNuhrewUdTjtrUv8yYwJSg7v+Zm@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs44ZlD43MkDa8s2a2BPVAjlASA6dhK7FEKX4Kko8Ty2QPDH7A
	htXLonlFcuxjniaqbJx0QaR15rFMPy63zqfawPjApQ8xb53krRehLcgHHmA+bPqrErAs3CH6VQ2
	bkXVWlUTWyL2/6Xmz6eWT/WwrAOTV+8o=
X-Received: by 2002:a17:907:da16:b0:ba9:bb46:345b with SMTP id
 a640c23a62f3a-bb93cd8bfa3mr204870066b.18.1777457855191; Wed, 29 Apr 2026
 03:17:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <85118db1.AWEAAJaZP3EAAAAAAAAABAMtJJUAAYKKIjQAAAAAAC-ZZgBp8da6@mailjet.com>
In-Reply-To: <85118db1.AWEAAJaZP3EAAAAAAAAABAMtJJUAAYKKIjQAAAAAAC-ZZgBp8da6@mailjet.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Apr 2026 19:17:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Ci4ReATdeoSr1Y++JfF1qF3i-QnbX+Qa2NDnGho2aBw@mail.gmail.com>
X-Gm-Features: AVHnY4Is24Oz6cUtoldNmij8u68TkMk7TshQI-dHO70i-bi8NIH_TE8R7FEjEHE
Message-ID: <CAKYAXd-Ci4ReATdeoSr1Y++JfF1qF3i-QnbX+Qa2NDnGho2aBw@mail.gmail.com>
Subject: Re: [PATCH v2] smb: smbdirect: fix MR registration for coalesced SG lists
To: Yi Kuo <yi@yikuo.dev>
Cc: smfrench@gmail.com, metze@samba.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 29, 2026 at 7:00=E2=80=AFPM Yi Kuo <yi@yikuo.dev> wrote:
>
> ib_dma_map_sg() modifies the provided scatterlist and returns the
> number of mapped entries, which can be fewer than the requested
> mr->sgt.nents if the DMA controller coalesces contiguous memory
> segments. Passing the original, uncoalesced count to ib_map_mr_sg()
> causes memory registration failures if coalescing actually occurs.
>
> Capture the actual mapped count returned by ib_dma_map_sg() and pass it
> to ib_map_mr_sg() to ensure correct MR registration.
>
> Also update the ib_dma_map_sg() error logging to drop the error
> pointer formatting, since the return value is an integer count
> rather than an error code.
>
> Ensure a proper error code (-EIO) is assigned when DMA mapping or
> MR registration fails.
>
> Fixes: de5ef8ec3c46 ("smb: smbdirect: introduce smbdirect_mr.c with clien=
t mr code")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D221408
> Signed-off-by: Yi Kuo <yi@yikuo.dev>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks!

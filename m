Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8164627FD76
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 02:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787970929; cv=none; b=rUQnrT+DpT6uKkb5aeC4tD0MEx8+8GTkoobk54Fzdle+ykV9Rgv1NSh85RiJ/Ia7m7xgD2ljGVDX5zGVoNFa8XfWH6YEJTYoaA3GmBYRVAdlAsXy4+BkOmkm4s+/gcHh5Wxqo42o6irFOlDfliPOtBrSt22tAWmn++TBcuXuB3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787970929; c=relaxed/simple;
	bh=8FKAW2fbU/+vR19TKosg0DLDdJCJyJiydWvYDurbDWg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JvFDTRLkv0/k+bEMwdcX6OSPRjZexCDhjCZ9FuR7h4SMY+5C3S7BEiV4vfQqshsC7tlMhV5dHrYcJIdnHxLRxvGTLr+QngXbqjm73bUauR91nOWy0KzjaxbE9HR/TqJLOh4OSKQ/PsXJFW9AYI/QMSTxGeNj6m/ilLyaxS7/3qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvgSsVkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvgSsVkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201821F00A3F
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 02:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787970928;
	bh=wnMnsReKWSz815XNXaYZFmrLpOzJUPyAVGLRSq7zVwE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MvgSsVkMluUE8oXut+FGg3KKNJ1j8G8f4xb0JCHTrVAI9AbfnXSPIUog07lReI9Zf
	 oxt8Whp7q5MrYvBy8429De4oFPVcEtENu3miqkY2Gu1/ANzIMutYiQTNmzuAvJzp57
	 rqO3MRWDU/Lg5EQZLM6FmTiD6xwK3W9ctkFkvrJcqpOO4BDrSzNB29vCgEo+uGyAen
	 QOWp4ac38pGDajvdIM5u59de4BjOPkCd/SreUYmDtsvsoaebBXkQoXqcLaGbc8vfsF
	 92HDGzECOU7zs2aITC5o56JxF52jLZCsPQdx1RtMCptnwwsBtRRcHd5exrSwoDLtMv
	 cz/+v2FIQo2fw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69fc9f25118so1797716a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 19:35:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxinJ6rsVyQ5GfNb5g1xOQqvM55nFOQYDlDbw35EEMf4Kh2wuT8/gluGhKBhd9XOQh/Fbvne5LfquKt@vger.kernel.org
X-Gm-Message-State: AFuF++mBnQ8GDXtTdQGJuR0vusf5/pybNZgNXTo33jDgbriI6Y9OGb2v
	LOsWSw8Q5h2iRY/pz9R1LKWz4sLAZlnAPSjfMj09b5B87q6dRylhxNluzLnxweYfVni1yThnffm
	aVi89foXNInGWBRNjB683Zw9953M1SSk=
X-Received: by 2002:a05:6402:5050:b0:6a3:f4fe:9d5f with SMTP id
 4fb4d7f45d1cf-6a60d3ae3fbmr7538205a12.11.1787970926774; Fri, 28 Aug 2026
 19:35:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828150203.1419003-1-diego@bynar.io>
In-Reply-To: <20260828150203.1419003-1-diego@bynar.io>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 11:35:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_HuQvCPPBjaX99StocSW_J9nU2NeZ+YRB9Z_jqpRHhJg@mail.gmail.com>
X-Gm-Features: AcwNN1XfIqYxhFMPTbWsezDpwgaxp9K14cZ5H3IOLo775v95VJOsR-jH9991m9I
Message-ID: <CAKYAXd_HuQvCPPBjaX99StocSW_J9nU2NeZ+YRB9Z_jqpRHhJg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
To: Diego Oliva <diego@bynar.io>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 12:02=E2=80=AFAM Diego Oliva <diego@bynar.io> wrote=
:
>
> The SMB1 synchronous read helper CIFSSMBRead() validates the server's
> DataLength against CIFSMaxBufSize and the caller's count, but never
> validates DataOffset. The copy source is formed as
>
>         &pSMBr->hdr.Protocol + le16_to_cpu(pSMBr->DataOffset)
>
> and memcpy()'d for DataLength bytes with no check that the
> [DataOffset, DataOffset + DataLength) range lies within the response
> actually received from the server.
>
> A malicious or compromised SMB1 server can return a short response
> carrying an in-range DataLength and a large DataOffset, driving the
> source pointer past the end of the response buffer. The memcpy() then
> copies adjacent kernel heap into the caller's read buffer (information
> disclosure), or reads unmapped memory and oopses (denial of service).
> SMB1 is not negotiated by default; reaching this code requires an
> explicit vers=3D1.0 mount.
>
> Both DataOffset and the received response length recorded in
> rsp_iov.iov_len are relative to the start of the SMB header, so reject
> the response unless DataOffset + DataLength fits within that length,
> using overflow-safe arithmetic, before forming the source pointer.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Assisted-by: Bynario AI
> Signed-off-by: Diego Oliva <diego@bynar.io>
> ---
> Note for backporting: this uses the smb_EIO2() tracepoint helper added
> in v6.19 with f80ac7eda1cf5. For older kernels, the call can be
> replaced with a simple return of -EIO.
>
>  fs/smb/client/cifssmb.c | 11 +++++++++--
>  fs/smb/client/trace.h   |  1 +
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index f5aad5f61dce..1a822121a883 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -1721,6 +1721,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_=
parms *io_parms,
>                 cifs_dbg(VFS, "Send error in read =3D %d\n", rc);
>         } else {
>                 int data_length =3D le16_to_cpu(pSMBr->DataLengthHigh);
Should we make data_length unsigned also ?

> +               __u16 data_offset =3D le16_to_cpu(pSMBr->DataOffset);

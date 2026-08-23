Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E74E6377007
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787447710; cv=none; b=lII3+3Tps026o8H5Eo0z5wxr+0PVRp/F9oV7O5WfdX1+MY9oGs0ch/fjQO9Qd6A5VmnMcqLI34NnQnRfojThzcMLTPU9h5t2GLRJmySi7/HR2H3NdKn1Y2yqLFLc/pAyk5IiG9BRJqmgOxZBEqCDlFBRIT/NoeX4BitV4aX+k3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787447710; c=relaxed/simple;
	bh=/9UDB+KPgphaCTBJx6zhUAmu+5x7l/SLPAtNq/SvXmM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e2yobSZgw5lt2dx9B944cJcbHrKEM8aPHGA6o3uRsBPOhcp3x/Rfm5SHDsULNOGLXONOiVpOVEtO8RZm/lpcuyJvKMb7MM0yMkhYjAsSumspUiKt/8N3z1kMzdDohMFEfcbuaAeGV0We0mXj1PPt6WjncxWfMwnbpfYHTziE3Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDblue2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDblue2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCAA1F00A3E
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 01:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787447708;
	bh=0B6HLbESejhNWrrWaH0HS9SH5mrA5HU01UmPadV/XrM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QDblue2f8fANcAVVXfo036kS9vrJnzYwn0KZVXsmFd38S9sBseNmrc4ouuGqWHlL+
	 dly7TNZJD0+9Hrxksqc8rIGI6TdCM20TviWpEtVGbOk66zqYPoOAxMioVtj+qb4WFP
	 /PlwqX8qGSCqAfDV8oBxibz6x6WiIfAZTPjS63NL4JY8Nrxx0zj0BzIzaqA70eQYQI
	 VtTh3+AG4r10ZwTukflxynNSQydZY9vLrWouIVZvfvwFaQfjlMv+eZHpXloR/rv/RL
	 MFT6A5jowAaYjGbKwtQlsJi8MMPPYAuwom15AtBnT5MsAO+tFDSU96r7pdAxpAz5dl
	 yMMOGT0iEKMEw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2022323c37so356041966b.0
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 18:15:08 -0700 (PDT)
X-Gm-Message-State: AFuF++ns5A8MA1OCArnzUp0hAEuVqVw4re/DgXpD4Ut+Wp+QCZ0B1r0y
	+vxH+iSAsTMJ6P+gEK/9H/OPHl9RrHU/GT8QBBDdx1gn//PZ+L/A/nefPJC5WTHSQtLOZnts2Yc
	PwRq1BTufYqOCwG2WQeolx3oFBIXCJaM=
X-Received: by 2002:a17:907:d0e:b0:c24:6505:8f67 with SMTP id
 a640c23a62f3a-c246a37cf52mr1700624466b.10.1787447707312; Sat, 22 Aug 2026
 18:15:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260822215517.2353835-1-sorenson@redhat.com>
In-Reply-To: <20260822215517.2353835-1-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 23 Aug 2026 10:14:55 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-eHBebxFfNgSwJ2iHd6WX9u7xvLzeRwzp=yJTamEYcmQ@mail.gmail.com>
X-Gm-Features: AcwNN1WTijGFHTL85Od23gy7iQRPtRPU6L1qumvm75Qw8MqAHhNDdbevyB55px0
Message-ID: <CAKYAXd-eHBebxFfNgSwJ2iHd6WX9u7xvLzeRwzp=yJTamEYcmQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix loff_t underflow in cifs_remap_file_range()
 when len == 0
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 23, 2026 at 6:55=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> With len =3D=3D 0 (clone to EOF), the effective length is computed as:
>
>     len =3D src_inode->i_size - off;
>
> If off > i_size, this is a negative loff_t, corrupting the ByteCount
> in the FSCTL_DUPLICATE_EXTENTS_TO_FILE request and inverting the range
> in filemap_write_and_wait_range().  The existing off >=3D i_size check
> fires only after the ioctl has already been sent.
>
> Snapshot i_size_read() once for both the bounds check and the length
> calculation, eliminating the TOCTOU and 32-bit torn-read risk.  Reject
> off > src_size with -EINVAL.  Treat off =3D=3D src_size as a no-op,
> consistent with __generic_remap_file_range_prep().
>
> Fixes: 04b38d601239 ("vfs: pull btrfs clone API to vfs layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F02B22F01
	for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2026 01:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791942515; cv=none; b=Kvx3KLYrns+daWIyQMZvf2MfK/iDJ9249vNNnPEqQutlqOf2gioiLFSd52R463Pc56YU8M0SjOSQbCRx3SKgJRtvzYlY63vXcruNDW/9Pzmcp0kJHDe55TDAJeOiWxEd2DasMPg4Nk8hibd8lZCcbFGd7lW7I1r0DlFQBR9ltz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791942515; c=relaxed/simple;
	bh=bNhxfSO3PykIeoiJNaMKeGlO/pELpsMJqXv0MoaMiE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+whnOWvLmF/N48N4yTitjjzXepzQMXmVElX2cWGkviZcZcLFsxs8NO1cviQxYR6M57pMy1+xa3oqZmX5jQFKWjSclt0YZZRGg7rRLcgS8VbSJOnJwXjmIN3cSHWtRgmQVx/thgrtcpq1NoZ+Z1UiSWRJEL0exqN1OSpoJdGjRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJJ3l/Uh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJJ3l/Uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E101F00899
	for <linux-cifs@vger.kernel.org>; Wed, 14 Oct 2026 01:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791942513;
	bh=bNhxfSO3PykIeoiJNaMKeGlO/pELpsMJqXv0MoaMiE0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PJJ3l/Uha05+9M/TwxqaykQtC6iwaDjOcJ/lJu1mD1iy06B0iPRzQM2fLuP2/sFli
	 mEoTBhf7f0ifcv01V1PuLYDUC+b0lWiD1Cz54fRIz+b6euKXgH1BM8AEWxHsErcx4p
	 gb+MX06RiS4c4UdZ03t2anEdumkHBoPuJG+YKY3ayWiUmH/1PUi/wu5syyjlipTiqP
	 1s3h5xesV6+D7cUZZ+eueQoSKjm4SWzxbl7stFg7xbUkQKzfGsLEsbd4mFJrz0Z9dw
	 ylW/VZuSPI9aMtN28QRKgq0D7nxvNWHbfx1odznzBXhL8TBfuEdzhGlTgLzyic/pRp
	 RxBgXZmX+00Tg==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2e8c710847so444424866b.0
        for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 18:48:33 -0700 (PDT)
X-Gm-Message-State: AFq9FYIMoIgRAorTBV9fG2Nx23Im1XdMvnmhfAwKnDTcUh5FEfcPUDU6
	j4oMaZkML76m80VE5Jvf2ksrmOJV2NC1h9w2vECJQh82g0gwLC/HwhSdma4R3DkO2z2lCG3KhzQ
	3PCosLWYv56lprf6T5v9QQW0d+2K9f54=
X-Received: by 2002:a17:907:9816:b0:c2e:378c:8ceb with SMTP id
 a640c23a62f3a-c31a9fa39abmr1344030866b.36.1791942512575; Tue, 13 Oct 2026
 18:48:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1791865501.git.rakukuip@gmail.com> <0f3d431d65a5f46c0487293d127e748775ca85b8.1791865501.git.rakukuip@gmail.com>
In-Reply-To: <0f3d431d65a5f46c0487293d127e748775ca85b8.1791865501.git.rakukuip@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 14 Oct 2026 10:48:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9XUxmA_feJJePfFu1YDkZ6_n2SPpYEV+TA+_eWyuL-6Q@mail.gmail.com>
X-Gm-Features: AclHuK9MKhT_u8pnv3FeWTi7d6jQazECqsT-hoiVko2PFuIYi3DwhYPtt_IYrqM
Message-ID: <CAKYAXd9XUxmA_feJJePfFu1YDkZ6_n2SPpYEV+TA+_eWyuL-6Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] cifs: fix buffer overflow in SMB2_tcon
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, jlayton@kernel.org, 
	smfrench@gmail.com, bird@lzu.edu.cn, rakukuip@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 14, 2026 at 2:16=E2=80=AFAM Ren Wei <n05ec@lzu.edu.cn> wrote:
>
> From: Luxiao Xu <rakukuip@gmail.com>
>
> In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
> MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
> UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
> destination buffer is large enough and writes strlen(tree) + 1 UTF-16 cod=
e
> units.
>
> Commit 62a1a439e0fd ("cifs: clean up handling of unc=3D option") removed =
the
> length check on UNC mount options, allowing mount paths to exceed
> MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
> SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16=
()
> to write past the end of the heap object, resulting in a slab-out-of-boun=
ds
> write.
>
> Fix this by dynamically allocating unc_path based on the length of tree s=
o
> that it safely accommodates all UTF-16 code units.
>
> Fixes: 62a1a439e0fd ("cifs: clean up handling of unc=3D option")
> Cc: stable@vger.kernel.org
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Assisted-by: LLM
> Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
> Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.

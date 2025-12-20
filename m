Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DB91DDC2B
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 02:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766197059; cv=none; b=m7SjvYyj8HndtvvIGVBFdqEZj6IpS5ON45rkiL65okvfiDPrOKuivprHK7VotvSTcJ9uA8pTBCC/pKLDxdoD4+ktzo7nf4ipjBvAG2GElvw1UyIsEuJZpgSH0avo4az83ailw5NDH8l426G/yOUvtV8xIxLCbWmsxz9wrREVj9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766197059; c=relaxed/simple;
	bh=FdiQ6TCrxPgrtd91/nGqoxzyxLgjtAmJ50voemxE8S4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kWcTZO45JAWMlkuzZ+32luMQyWsUEzDY01tK0bEyXPUnaMZavqp09qL3SUx9weU18ZYmbu6jfazNosOM6LHlenHvIoXHUDadINTnEYBc+ijeFRFoM3XbPEWhLHeeilOLm3c/5uKo+X0Jcq8SslBG7o7re9PDe1vCPuOjrDUszWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c5Us2QBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c5Us2QBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA23C4AF0C
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 02:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766197059;
	bh=FdiQ6TCrxPgrtd91/nGqoxzyxLgjtAmJ50voemxE8S4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c5Us2QBGx9QNoY2rSnEKzLOfPZEQoQpIIlzU8jw+obHDOqNLWe0bL/TfiD/UHyhp7
	 fUOEG4fno1pr1wVYA1PipS598UqcUiexZYz8fQw6unbd3W/0RYq1PdDbP1LQe5tCvI
	 hfOlg5JSSI/SLFXCAilJ7SLyHU3lQSJUMLlcRLsh9tO5FCalBc2/4JoBp5uI83YNW7
	 Qej+EgEsccHgdDafQ25rOoMRwRwc1mXMneS+ZLLLuZeJs2ZT8WhBTTKJO7wtBtXIMT
	 QIDNpMDaGV2bUZTUQxRxZ4xNvYv85ZZyUYdhAkvBc3tCiXgEKpEC9D0XxyetQNkchv
	 Q5KAtZlPEySyA==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b7277324054so418087666b.0
        for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 18:17:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWnjfPhVMg1XIJWnZMRygm5cDWoa91stM96D5ISevWRoI2JrYyBYu99BElnKBAj8GvAJp2+IRY8NkGc@vger.kernel.org
X-Gm-Message-State: AOJu0YyIDeT9+JBXgxs2phs5aTOSvTadcfh0v0rF87mjIm910qEdaGIr
	1RGDaw5I6GoMGfhW/Q1ozepN5yEzWe8ViLqbp+LbJ4NO9oQmvKL5yLGozRAhzRIWe8NUcPfT8c5
	CO8o8Eflt7vCZHtTEf1UxbuaTcozsGhk=
X-Google-Smtp-Source: AGHT+IHqsuB8rTJGCu8W0i+UO2KlB2jS9PTeHZneZ1QNX7ezKB521Ky7D3BFjfBRW2Ge1A37R8kzLjr80OSl9+uHoJM=
X-Received: by 2002:a17:907:c24:b0:b73:76c5:8f7c with SMTP id
 a640c23a62f3a-b80371f7236mr478932766b.43.1766197057782; Fri, 19 Dec 2025
 18:17:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev> <20251219235419.338880-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219235419.338880-4-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 20 Dec 2025 11:17:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_bhyFYSB_tmXGTczjgMPsEyVnSQUKztNfRzJH0bTdHvA@mail.gmail.com>
X-Gm-Features: AQt7F2rNtcvh7E0CS19NsHF0cE5G0z6w8q2gTaVWKRZSKyYtAkeBp8k8NsZSTsU
Message-ID: <CAKYAXd_bhyFYSB_tmXGTczjgMPsEyVnSQUKztNfRzJH0bTdHvA@mail.gmail.com>
Subject: Re: [PATCH RFC v3 3/3] smb: use sizeof() to get __SMB2_HEADER_STRUCTURE_SIZE
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2025 at 8:55=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> I have checked the size of the structure using GDB:
>
>   gdb ./build/fs/smb/server/ksmbd.ko
>   (gdb) p sizeof(struct smb2_hdr)
>   $1 =3D 64
>
>   gdb ./build/fs/smb/client/cifs.ko
>   (gdb) p sizeof(struct smb2_hdr)
>   $1 =3D 64
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
When reading the patch description, I don't know why this change is needed.
You don't need to include this patch on the v3 patch-set.
Thanks!
> ---
>  fs/smb/common/smb2pdu.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index f5ebbe31384a..f2a6b7191f43 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -107,10 +107,6 @@
>   *
>   */
>
> -#define __SMB2_HEADER_STRUCTURE_SIZE   64
> -#define SMB2_HEADER_STRUCTURE_SIZE                             \
> -       cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
> -
>  #define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
>  #define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
>  #define SMB2_COMPRESSION_TRANSFORM_ID cpu_to_le32(0x424d53fc)
> @@ -157,6 +153,10 @@ struct smb2_hdr {
>         __u8   Signature[16];
>  } __packed;
>
> +#define __SMB2_HEADER_STRUCTURE_SIZE   (sizeof(struct smb2_hdr))
> +#define SMB2_HEADER_STRUCTURE_SIZE                             \
> +       cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
> +
>  struct smb3_hdr_req {
>         __le32 ProtocolId;      /* 0xFE 'S' 'M' 'B' */
>         __le16 StructureSize;   /* 64 */
> --
> 2.43.0
>

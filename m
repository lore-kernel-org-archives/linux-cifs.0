Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58EF175A84
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780965125; cv=none; b=AAL5KJS4wn8D6iOcqbNfVumhblDdeqPJ085ncrjJC4b0upIid4cWlaGbWsX8nWilPReloscBuxDj/QpnHM4Cr4zEJSuDZP7SMv6WUBxMWl7qJBmLBSL2yTmXoZZcK/PMaeC87ECwV6SMHuhEeibIIpJOAVk+L5v7ZbWUvQ+eipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780965125; c=relaxed/simple;
	bh=Egs8RoNt9rU7BtC/pafzLe/1YuyAsob8a3yFE90Z9BM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SqK9xxayIlwDwVEu4WQEMuRGwaYlJg4iBgr4UW/ir2k/n/NHKicUly9EdVgg5iaOvIjaLjSVK04MC/KOhbeVBn/Opj5rcuqeDttWXE7W5hfVJ/v9Obi1ifmcd+8/2lmqYi3qgDdwfPqQB5JjVNlltHyrTdRt3s+BV720pyaxGr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n1s6N6F6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n1s6N6F6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4941F008A0
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780965124;
	bh=1vUWycOtjeCv4PfyJLEBA+FeJiReG8Z6FEtRQNg9kfY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=n1s6N6F6qj69D3NnPP4RerJjajyfNI0Eehmr9eRmJieinW1Hf6c0YNtaqwIxsWtmm
	 UptbAezQwSFbN9byf55QmNipCJss9p4an8Jf7ZFPIgB8YM6wUbGI6CJ1uiMOHFOczP
	 tfXTmyZU9c0/+SWSiUyEpBPN30VAYwWJyFvcLm/b5H5OpCmuV5muArdkzrE/IkpbdO
	 pPpJe25J3AkTczRJhZDHobtZZkrbuI3nEOi+63PL99SHzAvqJBZ6bXzIXLbgQYS7Z5
	 Vsx3P09YyFm1NjBi/DKyaRNE3rKHVBDLZh4dAX1M+0cOi6j9rxOZjuearCt9ppKMQ3
	 gN0pMgUmmJFow==
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bec429c2bb1so715832466b.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2026 17:32:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Sm7GaYvsBzBNo7A37zsugKWAyW8mrLAWeM6PdYnsVgZFeRr2LK6EU64o+7Y+e9tMq9MYahBWFDsYe@vger.kernel.org
X-Gm-Message-State: AOJu0YwgaP7pV+AjuyqhbLAD1G7VnfDSaZ8fEyQ/8jtMzDDtRgqKuRBU
	3ySSkmr10TXm2C7witcT+PlQ6vdQX/hHCSenZn/TUl18BUb1WIiQlFfjR7Aa+yzEylsfNT5mXyN
	QWqDDhjxEEOz7+lusgTkvLFgsP6PM6ug=
X-Received: by 2002:a17:906:8a48:b0:bed:6e53:bb25 with SMTP id
 a640c23a62f3a-bf37301d00amr634249666b.40.1780965122959; Mon, 08 Jun 2026
 17:32:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260608140128.387844-1-chenxiaosong@chenxiaosong.com> <20260608140128.387844-8-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260608140128.387844-8-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Jun 2026 09:31:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9JGDYJvtO3fZcjLh_qY3bs198BYW4ijYaHsgZDFF9eCA@mail.gmail.com>
X-Gm-Features: AVVi8CdU3nt13U9owmyAZDB2zCuimdc-Df79QAU4CUHOhHkYjovwRZpDKflMBgI
Message-ID: <CAKYAXd9JGDYJvtO3fZcjLh_qY3bs198BYW4ijYaHsgZDFF9eCA@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] smb/server: fix incorrect file size in get_file_compression_info()
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 8, 2026 at 11:03=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Before this patch, we got the wrong file size:
>
>   - client: touch /mnt/file
>   - client: smbinfo setcompression default /mnt/file
>   - client: dd if=3D/dev/zero of=3D/mnt/file bs=3D1 count=3D1000
>   - client: smbinfo filecompressioninfo /mnt/file
>             Compressed File Size: 4096
>             Compression Format: 2 (LZNT1)
>
> After this patch, we get the correct file size:
>
>   - client: smbinfo filecompressioninfo /mnt/file
>             Compressed File Size: 1000
>             Compression Format: 2 (LZNT1)
>
> Note that the actual compressed file size must be got by other methods.
> For Btrfs, use the following command to get actual compressed file size:
>
>   - server: compsize /export/file
>             Processed 1 file, 0 regular extents (0 refs), 1 inline.
>             Type       Perc     Disk Usage   Uncompressed Referenced
>             TOTAL        4%       47B        1000B        1000B
>             zlib         4%       47B        1000B        1000B
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 7150e77ff113..5781695d1094 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5291,7 +5291,7 @@ static int get_file_compression_info(struct smb2_qu=
ery_info_rsp *rsp,
>                 return ret;
>
>         file_info =3D (struct smb2_file_comp_info *)rsp->Buffer;
> -       file_info->CompressedFileSize =3D cpu_to_le64(stat.blocks << 9);
> +       file_info->CompressedFileSize =3D cpu_to_le64(stat.size);
We should return the number of bytes allocated to the actual disk
after compression. Is stat.size the actual compressed size?

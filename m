Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E19039FCE
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780758954; cv=none; b=KT+LBzu8JRyhK2GjFRao3MyiISzu3RY6OTQYAgjUXxVVWcRmq0BTo4H8xJZfWMgwcXuW0v5gexOpRGxX9dranIZLzmisx7RL5UK4p880RxkQrvgJSh6GZVuhh9P5w6e4yYwN6eOWgY+sZfTwKX7WA38YetpHnITuPUawEKVC1LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780758954; c=relaxed/simple;
	bh=6r/aJyYdsUruKWw6sLk4dlC12wOuJbq6R/DmgKvx0BQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rgTVi3FCganBHqSbVSsC6OT/EvUweE2ztDeaorHQjHL1PZZxASYjksTOgncsbtfqqKSO77duFxYB22W159c10CGX6MoJDSse0OzCuqnHeB9dmIywXKyMn+N8QjwDPbZ9Wm3QPjTyqDqfkbQR0e6MJsL8Qs0fZlDymxwdHTvf5WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUZ/tShV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUZ/tShV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD651F0089A
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780758953;
	bh=6r/aJyYdsUruKWw6sLk4dlC12wOuJbq6R/DmgKvx0BQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OUZ/tShVNXw6KVCFtTCWpyrxEcWLmSw2jOf9MtchVUS309Wp6gRFl8VPYag30KzTk
	 amOeN/22BIUTyPPKRnLcRsLGM0xPwZ5/ySbXvERGIqmtsRZgVOEIkN40fAQYJ2t7UC
	 zOH358A0rOlh/RVjUJ6k/VdbbKT8YC0BEytQMqcBB3lf2RchCLtwXXek3cF6nVEuFU
	 Wqiy2uicmnsf5l/BOldQVh2mpkuwsZfe/SYCbQSFOm7EX9gR3bfu6HRxyNJx/LRymf
	 CVOAY1tmUC+xmyT7TXfoqznfvA3NHIgdmtcqOxkur8N8iC06KMG8NNnzIHxvbiE5qj
	 RH7NhQfhTKgWQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-beb7f26ed62so329296066b.0
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 08:15:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/lh/LD6J1YcaZiNFVreiDWqF5WQdrpee3sOrmOtqWGGP25KIdAxTbqfDPBD14XsKByhImf9OIi3orx@vger.kernel.org
X-Gm-Message-State: AOJu0YxcT1XwOc5iV7K1bPyobKXwqzCLs+bcsKc0FhTTJQVAYpCldVF+
	8M9Hr4fJ7K2WhMD3G98a72atOlOKZYvaQRAT2BOxq74GPvqG0keUDBfNomIYFS9qiksSlZdAdkP
	XLxibczv5ZGnFOJxc97YiyHsaBcFroG8=
X-Received: by 2002:a17:907:970e:b0:bec:d5e1:5aee with SMTP id
 a640c23a62f3a-bf372446932mr474346866b.34.1780758951567; Sat, 06 Jun 2026
 08:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com> <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
In-Reply-To: <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 7 Jun 2026 00:15:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
X-Gm-Features: AVVi8CcXeNz6wcx_mPS-3ymCJhxF8gbSj5g66muZ3YS-B8hMZoYLCHlwHSaUG_U
Message-ID: <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 6, 2026 at 10:59=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> It is defined in MS-FSCC 2.3.67:
> https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/77f=
650a3-e3a2-4a25-baac-4bf9b36bcc46
>
> There's one thing I'm not sure about, vfs_fileattr_get() seems to only
> tell us whether the file is compressed or not, but it doesn't provide
> the detailed CompressionState. Namjae, do you have a better idea for how
> to get detailed CompressionState?
It seems possible to get the file's compression algorithm format or
information via ioctl in f2fs and other filesystems. However,
COMPRESSION_FORMAT_DEFAULT is not defined in FSCTL_GET_COMPRESSION.
Isn't that why it showed up as UNKNOWN in your test results?

2. client: smbinfo getcompression /mnt/file Compression: 1 (UNKNOWN)

My thought is that if the file is compressed, it might be better to
return COMPRESSION_FORMAT_LZNT1 even though it is not actually
compressed with LZNT1. Of course, we need to test this with a Windows
client. This is because I think FSCTL_GET_COMPRESSION is simply a
request to check whether the file is in a compressed state or not.

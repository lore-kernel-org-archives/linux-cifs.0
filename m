Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09772303CAB
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 05:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760507050; cv=none; b=Flzfi5qR+SdI3ZOQzNIKyI7fsRs6uDWia4uPC4573JNaY0ghhzw3514bPvvKqQe4cqKhcj8u3kThKetZb1srKznoI6vVw9fqL0yo9IlxD20qcBMdZedU+/FPHfLH1lS+B57Cv04K9AA/1nTRN/sQbr+nQYB7/Vq2whp4luxm+WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760507050; c=relaxed/simple;
	bh=GVlZDNYjq1s3cVnBfknhY5bLXf9IalVhWvKScVdciXE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fKNmQw7XG7r21dLc1YuMskBRMVRNoaWQ9RYhiLPygS2IHtKImMME4ee6Njr31pr3LCDYGVXVdC1h9t5r+/374e81aCu4gnKeHMtIGIrhtJHU7zv9Vbq4VZ/mduCrKijQ1Hih36w7EHYGfbDeYzepabOAk8uN3IPZs87GUniwu50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ClQKqN/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ClQKqN/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9185C19424
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 05:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760507049;
	bh=GVlZDNYjq1s3cVnBfknhY5bLXf9IalVhWvKScVdciXE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ClQKqN/8wPvhKwojSg1BSZM2ZveboyUc97qHFP13hpn9CTXQwUIXJUEtDO5m6eB7t
	 p3KHcAUyrTkMF1fIJ6DqlKSf5zSIlx3ZEqeijC64GCD5Hs7jkFZELmzhVe0ncCxMXl
	 lgOtqpL1sEo+tcOV7F+iYBqZORY35oTcoD0c1BjVvxuEegii2k6arUAiIPUxwQdYTM
	 el+BjvUhSVlknN3bAN4DAkn4su6SV0+IDdS+rQH2EljQrbqJlGk9YxnY5ZsowY3vpy
	 Y/fMu+9YFpKoXK3q3ZJJglYOb0ZexHmRxpMKkzcx8B6a8MmPsMCIT/3kUbHvVhHYWm
	 JEaEKosSVccmw==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3ee18913c0so989170266b.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Oct 2025 22:44:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVctJQeNuUAXgKwhRaYb56PpYFxgyDb+W4rLtjO89u6bc0FTOtMsgPp1FI0K44W05K+zUlAt8ynn6Hx@vger.kernel.org
X-Gm-Message-State: AOJu0YyOICMeVOgW2D1qo3rAsvb+bxO1QjSoUfiEh+r98B4VYX2xeKmH
	MwXTp+UVe/z+Kx1CKkAtgJCRzyymdJkn3L5xM69F3a6H6Uotm/7ltHkaekBNnx7PUQrb38k3bq6
	PUpEJCkVbMMwhai1JGu5aWLf0sd7GW2c=
X-Google-Smtp-Source: AGHT+IEWvSXZubKOaiM32KLLroSnv9MqhPpdUc/GdRTxP9G0CYD9+vYTI9V7Z2IU7kmAEHMPP2/d8SwlicHiKWS7me4=
X-Received: by 2002:a17:906:fa0e:b0:b55:a883:63c4 with SMTP id
 a640c23a62f3a-b55a8841f25mr1872492166b.10.1760507048110; Tue, 14 Oct 2025
 22:44:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Oct 2025 14:43:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9GtfRDe50P2PGPOuy3LEnf5hMVAAfeKXYHN_+XY37ZVA@mail.gmail.com>
X-Gm-Features: AS18NWA5KrbTsr1Lnqc8dzysiebpRMxsn5PXElwNVmntQ_T2SoEOujIg-9OjHuE
Message-ID: <CAKYAXd9GtfRDe50P2PGPOuy3LEnf5hMVAAfeKXYHN_+XY37ZVA@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] smb: fix some bugs, move duplicate definitions
 to common header file
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	zhangguodong@kylinos.cn, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 4:20=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Emails from previous address were often not received (went to the spam
> folder or other reasons), and the cover letter wasn't linked to the
> patches. So yesterday I requested chenxiaosong.chenxiaosong@linux.dev
> account and have now sent v3.
>
> Fix some bugs of smb server.
>
> In order to maintain the code more easily, move some duplicate definition=
s
> to common header file.
>
> Add some MS documentation references for macro and struct definitions.
I have applied 0001, 0002 patches to #ksmbd-for-next-next as they are
obvious bug fixes.
I will give you feedback on the remaining patches soon.
Thanks.
>
> v2->v3:
>   - Update patch #06: use "Suggested-by:" instead of "Reviewed-by:"
>
> v1->v2:
>   - Update patch #06 according to Christophe JAILLET's suggestions: https=
://lore.kernel.org/all/d03c64d2-46c0-42d8-8f88-28669e921c95@wanadoo.fr/
>
> v2:
>   - cover-letter: https://lore.kernel.org/all/40F04A8E2145E761+2025101216=
1749.2994033-1-chenxiaosong@chenxiaosong.com/
>   - patches: https://lore.kernel.org/all/47508024F79AE36C+20251012161749.=
2994033-2-chenxiaosong@chenxiaosong.com/
>
> v1:
>   - cover-letter: https://lore.kernel.org/all/76A15C078023E21F+2025101215=
0915.2992220-1-chenxiaosong@chenxiaosong.com/
>   - patches: https://lore.kernel.org/all/029014EF18C9D322+20251012150915.=
2992220-2-chenxiaosong@chenxiaosong.com/
>   - RESEND cover-letter: https://lore.kernel.org/all/37DF3D711BAD3621+202=
51012152247.2992573-1-chenxiaosong@chenxiaosong.com/
>   - RESEND patches: https://lore.kernel.org/all/9836A3F274B62345+20251012=
152247.2992573-2-chenxiaosong@chenxiaosong.com/
>
> ZhangGuoDong (10):
>   smb/server: fix possible memory leak in smb2_read()
>   smb/server: fix possible refcount leak in smb2_sess_setup()
>   smb: move some duplicate definitions to common/cifsglob.h
>   smb: move smb_version_values to common/cifsglob.h
>   smb: move get_rfc1002_len() to common/cifsglob.h
>   smb: move SMB1_PROTO_NUMBER to common/cifsglob.h
>   smb: move some duplicate definitions to common/smb2pdu.h
>   smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
>   smb: move copychunk definitions to common/smb2pdu.h
>   smb: move resume_key_ioctl_rsp to common/smb2pdu.h
>
> ChenXiaoSong (12):
>   smb: move smb2_file_network_open_info to common/smb2pdu.h
>   smb: move some duplicate definitions to common/cifspdu.h
>   smb: move file access permission bits definitions to common/cifspdu.h
>   smb: move SMB frame definitions to common/cifspdu.h
>   smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
>   smb: move FILE_SYSTEM_DEVICE_INFO to common/cifspdu.h
>   smb: move FILE_SYSTEM_INFO to common/cifspdu.h
>   smb: move FILE_DIRECTORY_INFO to common/cifspdu.h
>   smb: move FILE_FULL_DIRECTORY_INFO to common/cifspdu.h
>   smb: move FILE_BOTH_DIRECTORY_INFO to common/cifspdu.h
>   smb: move SEARCH_ID_FULL_DIR_INFO to common/cifspdu.h
>   smb: move FILE_SYSTEM_POSIX_INFO to common/cifspdu.h
>
>  fs/smb/client/cifsacl.c       |   4 +-
>  fs/smb/client/cifsglob.h      |  47 +---
>  fs/smb/client/cifspdu.h       | 436 +-------------------------------
>  fs/smb/client/cifssmb.c       |  10 +-
>  fs/smb/client/cifstransport.c |   8 +-
>  fs/smb/client/connect.c       |   2 +-
>  fs/smb/client/misc.c          |   2 +-
>  fs/smb/client/smb2ops.c       |  18 +-
>  fs/smb/client/smb2pdu.h       |  80 +-----
>  fs/smb/common/cifsglob.h      |  68 +++++
>  fs/smb/common/cifspdu.h       | 464 ++++++++++++++++++++++++++++++++++
>  fs/smb/common/smb2pdu.h       |  98 ++++++-
>  fs/smb/server/smb2misc.c      |   2 +-
>  fs/smb/server/smb2ops.c       |  32 +--
>  fs/smb/server/smb2pdu.c       | 114 +++++----
>  fs/smb/server/smb2pdu.h       |  67 -----
>  fs/smb/server/smb_common.c    |  10 +-
>  fs/smb/server/smb_common.h    | 304 +---------------------
>  fs/smb/server/smbacl.c        |   2 +-
>  fs/smb/server/vfs.c           |   2 +-
>  20 files changed, 735 insertions(+), 1035 deletions(-)
>  create mode 100644 fs/smb/common/cifsglob.h
>  create mode 100644 fs/smb/common/cifspdu.h
>
> --
> 2.43.0
>

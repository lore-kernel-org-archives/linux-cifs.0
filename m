Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6566C76026
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 02:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766196858; cv=none; b=DwAOURwsaKfc0+bMajbmejp89H3eXBFZQBA4ku8d1bSfepk4egyG/hPX7NayLT8gEnQRF24dbjGpkNaCV6L13N6yULrKVgCxBfOLF2AG1f0IFDbSIqR/5OkAW+84TxvuEfc21/Hx+bPk30FfPAci7dodQrxM8aeHcAIL/f0tuG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766196858; c=relaxed/simple;
	bh=uX5iIeaYNHkxAJ7FaxetikZd5wzsQ4DeE22e83eG6ho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g8vxwu5MotcvdZO8uUjWByC2wRL0vtp2oUnohW1yYhjSY0i+JL8egcrvJcwP7vT6+n9m7qB7qm1CsmVhPc4L5Fg7cvDAjTQCFYXR+wkgJxOPH9Cy1+KP0slx/sVrPmF1YP+w6d5w9DQqQMGTHhE6GbP98mzR7qNeQVK2B+9xcEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P/VcIh2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P/VcIh2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E599EC116D0
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 02:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766196857;
	bh=uX5iIeaYNHkxAJ7FaxetikZd5wzsQ4DeE22e83eG6ho=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=P/VcIh2AK556b3st2uzS22Q4/s/Wb3W0SJ6p5gDWNTI6zs/RIBNhZhilQr0dC+FRN
	 yVUT9/nycZQDvlPH1nyCJB/tQLsARyHmZ+wJ62sT0Sa2ZlymNrhWdymKWyzomnuQrw
	 saRcGqA+MFMreyfrvKe31WkhBYvsUwwJYB0VAzamcabyQj7eu8uUsuCxhdRK9ZSE8z
	 LgHp/DPse2hOH7V2T7oXAsnGCVPvtKiJ2Y5LpYphunNHxtdu7aWdxRevr8/IpkZMOm
	 /rvbyM2sGAPZtvpyfLwnNAxSkcAHnxuYPHI2JXyTY79eoO933i/Sqlp74whUQgp1nb
	 iJfUAr4F1SQ2Q==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b736d883ac4so416338366b.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 18:14:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXZ0DXK4obnGi7hgUzsPBvrMcKXEyKTzMXzJVk528bedJX4W0EQfIQaQHrpYe0te3YNz/VCp7xRmDkZ@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv61RM/pd+e9Y2+E1yErTn4mgiqqFwmU8UUA3ZKEBdGtwzf7mO
	dgOdgBTpczfGExDD48eUkE7NpdK7PmVxFaCfu2J6ndBFXeFxlEaSD4bir/F52oZC50+/pFlYHfx
	qIjemyHHKW+q/K4WaTJx0SbMnQazvfCE=
X-Google-Smtp-Source: AGHT+IGFCLzSW3qIgdWXDP+BLr4XFw5qhI4SMUEQ7WkqliNdaTpRKpnXzx4Ee/hvdblXJeELzBO0bBQP64U8p3XAW7Q=
X-Received: by 2002:a17:907:97c7:b0:b79:d24b:474d with SMTP id
 a640c23a62f3a-b8036f56569mr514044466b.16.1766196856544; Fri, 19 Dec 2025
 18:14:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev> <20251219235419.338880-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219235419.338880-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 20 Dec 2025 11:14:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qnEzj3=-sAdNr0HpBOp5vvU_SBX=wSPrMfKqK8LE03w@mail.gmail.com>
X-Gm-Features: AQt7F2prk-2441CNpTF2W3fzPygo0v3-MDnP91JWyW1UocAKQdfscB_9TDq_qDc
Message-ID: <CAKYAXd-qnEzj3=-sAdNr0HpBOp5vvU_SBX=wSPrMfKqK8LE03w@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] smb/server: fix minimum SMB1 PDU size
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
> Since the RFC1002 header has been removed from `struct smb_hdr`,
> the minimum SMB1 PDU size should be updated as well.
>
> Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
> Suggested-by: David Howells <dhowells@redhat.com>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/common/smb1pdu.h    | 5 +++++
>  fs/smb/server/connection.c | 4 ++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> index df6d4e11ae92..3c5332a82ea7 100644
> --- a/fs/smb/common/smb1pdu.h
> +++ b/fs/smb/common/smb1pdu.h
> @@ -53,4 +53,9 @@ typedef struct smb_negotiate_req {
>         unsigned char DialectsArray[];
>  } __packed SMB_NEGOTIATE_REQ;
>
> +struct smb_pdu {
> +       struct smb_hdr;
> +       __le16 ByteCount;
> +} __packed;
I don't prefer adding unused structure for size. Please use + 2 and
add a comment to clarify why it's there.
> +
>  #endif /* _COMMON_SMB1_PDU_H */
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index b6b4f1286b9c..f372486ebcc5 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -295,7 +295,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
>         return true;
>  }
>
> -#define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
> +#define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_pdu))
>  #define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
>
>  /**
> @@ -363,7 +363,7 @@ int ksmbd_conn_handler_loop(void *p)
>                 if (pdu_size > MAX_STREAM_PROT_LEN)
>                         break;
>
> -               if (pdu_size < SMB1_MIN_SUPPORTED_HEADER_SIZE)
> +               if (pdu_size < SMB1_MIN_SUPPORTED_PDU_SIZE)
>                         break;
>
>                 /* 4 for rfc1002 length field */
> --
> 2.43.0
>

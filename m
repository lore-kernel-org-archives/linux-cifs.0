Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999318DB37
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 23:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765323972; cv=none; b=XjqSXS9WxF8plLaU+DEJFp1JnA9f4HtzGOHHLqgTJBEBnMnJecu60Rivyo9nnlIl0ppR8uQdfoVN6Wib9yHBCxsAKrhrt0DZFkObEuvR5ZeAIy39MXrECFfsuL+t8SVvY5z7Xc0uiebFb4nHEyd+7alUCGoOwfwkmXcsT1UJ5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765323972; c=relaxed/simple;
	bh=9pdZuG/1Dym7mrTDxn8+uCydHlztyGss3vKnCrxk2to=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fgoS9m2KXMTiQGspUkAELTgJIhmqrDVaYPKXCIudB8bsWdw1g4u72HlMMBxV+sG2Szf2pmZ65oKKARHxW3z39fm/QyUIgmyNVTvj9NIHiOTDSVdXSEO0iNFqC0vOjTaegMrfmrFzvpFQY/QMhOS0zRaCNByxxgVPdFfXHt6qJRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nmKEMpAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nmKEMpAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DE4DC2BC87
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 23:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765323972;
	bh=9pdZuG/1Dym7mrTDxn8+uCydHlztyGss3vKnCrxk2to=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nmKEMpAF5HIiKWuLaRCUO81MnxToWfQInKGHMLKIWbzMgHaUguChxZEDJHTGpX9ge
	 DUYbjflKvKG2sMP/nFgUiwLFrN6aFEm0Ar6ESNLa358S1qmB6Z0SWRVsHWPggxhJCq
	 iA1LC36MH4lQ+E4EGVGXA4chAmOB5OQT9cGTO248naPm29s5qBFpksA0sEHkZWnmc/
	 +QHBrq+Yg+savt+4erLvKNQFQFbCvJe6p/XPixCfU7czhRfbgbMfYQ11CC4C4ZD2IH
	 BVSDKwou8K8hUmwMz3yf8w5WnJNXNSUBUq5qLuq1KQGC5nmBI8WVtX/xgWKKFw9C1z
	 Pbu3TWxA9iWGA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-647a3bca834so8050701a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 09 Dec 2025 15:46:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUe1Y5y4SuUBU6OKRhiyYSydY7c9XgEcSVw/fO9WZ5rAb6YXVTRTgrnjeOk3ov7F7AsV6TL97+dP59G@vger.kernel.org
X-Gm-Message-State: AOJu0Yys6h91fbWY/84sDIjDcsDJoW77QKRdaqJkQxi+++kngg11jM2g
	wQIJlGg+Xm9h/J+/LCRLKa9mCQOyNzWLQITBxTppHmM9614mNUioNI4z/h6cLOo+hG6/eer+kfb
	VTivbaCNhoVpP8ep5kZbSYW9eDb1RG5w=
X-Google-Smtp-Source: AGHT+IEV0usO/WOC//KV++wjWTBfv1yrMoEAufsrNOjU6fhQNONu57NOe7af0VQXkQnlqnYEGFg1Zy+YQ7ZB6NBcOPA=
X-Received: by 2002:a05:6402:144d:b0:640:ca0a:dc1c with SMTP id
 4fb4d7f45d1cf-6496cb6b889mr696447a12.7.1765323970748; Tue, 09 Dec 2025
 15:46:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev> <20251209011020.3270989-12-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-12-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 10 Dec 2025 08:45:57 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com>
X-Gm-Features: AQt7F2p6wucrjKrfunNecKvM8qeEVH23hzqQT93erdy6WDGFlR5PUc7XutdvVxo
Message-ID: <CAKYAXd8so+qB4zAXmj2mNSxqQ4emJe6eqhg-UgpKYgP+URk_yA@mail.gmail.com>
Subject: Re: [PATCH 11/13] smb: introduce struct create_posix_ctxt_rsp
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 9, 2025 at 10:12=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> Modify the following places:
>
>   - introduce new struct create_posix_ctxt_rsp
>   - some fields in "struct create_posix_rsp" -> "struct create_posix_ctxt=
_rsp"
>   - create_posix_rsp_buf(): offsetof(..., nlink) -> offsetof(..., ctxt_rs=
p)
I don't know why we need to add a new create_posix_ctxt_rsp struct.
>
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>  fs/smb/client/smb2pdu.c |  9 +++++----
>  fs/smb/client/smb2pdu.h |  6 ++----
>  fs/smb/common/smb2pdu.h | 18 ++++++++++++++++++
>  fs/smb/server/oplock.c  |  8 ++++----
>  fs/smb/server/smb2pdu.h |  6 ++----
>  5 files changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index ef2c6ac500f7..ec0f83db5591 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2298,9 +2298,9 @@ parse_posix_ctxt(struct create_context *cc, struct =
smb2_file_all_info *info,
>
>         memset(posix, 0, sizeof(*posix));
>
> -       posix->nlink =3D le32_to_cpu(*(__le32 *)(beg + 0));
> -       posix->reparse_tag =3D le32_to_cpu(*(__le32 *)(beg + 4));
> -       posix->mode =3D le32_to_cpu(*(__le32 *)(beg + 8));
> +       posix->ctxt_rsp.nlink =3D le32_to_cpu(*(__le32 *)(beg + 0));
> +       posix->ctxt_rsp.reparse_tag =3D le32_to_cpu(*(__le32 *)(beg + 4))=
;
> +       posix->ctxt_rsp.mode =3D le32_to_cpu(*(__le32 *)(beg + 8));
>
>         sid =3D beg + 12;
>         sid_len =3D posix_info_sid_size(sid, end);
> @@ -2319,7 +2319,8 @@ parse_posix_ctxt(struct create_context *cc, struct =
smb2_file_all_info *info,
>         memcpy(&posix->group, sid, sid_len);
>
>         cifs_dbg(FYI, "nlink=3D%d mode=3D%o reparse_tag=3D%x\n",
> -                posix->nlink, posix->mode, posix->reparse_tag);
> +                posix->ctxt_rsp.nlink, posix->ctxt_rsp.mode,
> +                posix->ctxt_rsp.reparse_tag);
>  }
>
>  int smb2_parse_contexts(struct TCP_Server_Info *server,
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 78bb99f29d38..4928fb620233 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -251,11 +251,9 @@ struct smb2_file_id_extd_directory_info {
>
>  extern char smb2_padding[7];
>
> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
> +/* See POSIX-SMB2 2.2.14.2.16 */
>  struct create_posix_rsp {
> -       u32 nlink;
> -       u32 reparse_tag;
> -       u32 mode;
> +       struct create_posix_ctxt_rsp ctxt_rsp;
>         struct smb_sid owner; /* var-sized on the wire */
>         struct smb_sid group; /* var-sized on the wire */
>  } __packed;
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index 72f2cfc47da8..698ab9d7d16b 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1814,4 +1814,22 @@ typedef struct smb_negotiate_req {
>         unsigned char DialectsArray[];
>  } __packed SMB_NEGOTIATE_REQ;
>
> +
> +/*
> + * [POSIX-SMB2] SMB3 POSIX Extensions
> + * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb=
3_posix_extensions.md
> + */
> +
> +/*
> + * SMB2_CREATE_POSIX_CONTEXT Response
> + * See POSIX-SMB2 2.2.14.2.16
> + */
> +struct create_posix_ctxt_rsp {
> +       __le32 nlink;
> +       __le32 reparse_tag;
> +       __le32 mode;
> +       // var sized owner SID
> +       // var sized group SID
> +} __packed;
> +
>  #endif                         /* _COMMON_SMB2PDU_H */
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> index 1f07ebf431d7..8658402ff893 100644
> --- a/fs/smb/server/oplock.c
> +++ b/fs/smb/server/oplock.c
> @@ -1703,7 +1703,7 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_fi=
le *fp)
>         buf =3D (struct create_posix_rsp *)cc;
>         memset(buf, 0, sizeof(struct create_posix_rsp));
>         buf->ccontext.DataOffset =3D cpu_to_le16(offsetof
> -                       (struct create_posix_rsp, nlink));
> +                       (struct create_posix_rsp, ctxt_rsp));
>         /*
>          * DataLength =3D nlink(4) + reparse_tag(4) + mode(4) +
>          * domain sid(28) + unix group sid(16).
> @@ -1730,9 +1730,9 @@ void create_posix_rsp_buf(char *cc, struct ksmbd_fi=
le *fp)
>         buf->Name[14] =3D 0xCD;
>         buf->Name[15] =3D 0x7C;
>
> -       buf->nlink =3D cpu_to_le32(inode->i_nlink);
> -       buf->reparse_tag =3D cpu_to_le32(fp->volatile_id);
> -       buf->mode =3D cpu_to_le32(inode->i_mode & 0777);
> +       buf->ctxt_rsp.nlink =3D cpu_to_le32(inode->i_nlink);
> +       buf->ctxt_rsp.reparse_tag =3D cpu_to_le32(fp->volatile_id);
> +       buf->ctxt_rsp.mode =3D cpu_to_le32(inode->i_mode & 0777);
>         /*
>          * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(=
16)).
>          * Domain sid(28) =3D revision(1) + num_subauth(1) + authority(6)=
 +
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index 66cdc8e4a648..09311a9eb1de 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -83,13 +83,11 @@ struct create_durable_rsp {
>         } Data;
>  } __packed;
>
> -/* equivalent of the contents of SMB3.1.1 POSIX open context response */
> +/* See POSIX-SMB2 2.2.14.2.16 */
>  struct create_posix_rsp {
>         struct create_context_hdr ccontext;
>         __u8    Name[16];
> -       __le32 nlink;
> -       __le32 reparse_tag;
> -       __le32 mode;
> +       struct create_posix_ctxt_rsp ctxt_rsp;
>         /* SidBuffer contain two sids(Domain sid(28), UNIX group sid(16))=
 */
>         u8 SidBuffer[44];
>  } __packed;
> --
> 2.43.0
>

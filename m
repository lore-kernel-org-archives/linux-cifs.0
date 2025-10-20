Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22072459EA
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760938534; cv=none; b=M00OvRI1yiejaC68TNACohCpTaUdo0mNBerhKEESd9Jwbe53Xq4p0zZ3CJhPSEidFeBlzELf3SAD1UX4PJHhsfe8FK82WlMheJMJTDgkvL3ScwK7jmrLnobJ3/x1KOMb15Uv0lgbP1KpBcRR64HyDI8KDS+Fi+CXWQeUjA9nH/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760938534; c=relaxed/simple;
	bh=OmseD2GSHOEHpHB6QqwwQHqjeBZ8sXlRm2+cbjVYE94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRCdZ83pp/HZjcRIBKhSJpefrqtBqBkKfJbMJRKz6MrL5/ukSV5jYZb9SCQi2nshqGD23WGqj0UMr3leum2qCd8LS6F0RNVTy9RofUoNaiIrQTNqzqbARLmrwaX6r4OH28NyKlXQjknl4cmqI5ig62cgoC5HpM62MV6wYkj+GtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2l3gjU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2l3gjU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D631C113D0
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 05:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760938532;
	bh=OmseD2GSHOEHpHB6QqwwQHqjeBZ8sXlRm2+cbjVYE94=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=o2l3gjU8dPY9QYzdZfMB4+OCbqP99DTEqJqbSoOLRzPJ52UtIpgZhl8Jf9C+F0etf
	 CSYPJL+SCuDwKDlM9i5Gkvbe25laDPNpLS4BStA8/84qBheHSsVPWBklLGehO4EXr7
	 InzZprTre3fzfOfqvTV8PjoRhRUDXXfu4Bp40uXTQUEKyzRATPg8BmxR6MnzDVKQDv
	 Fobc6K9WcklXOtHD+GmWnrrcEe7WF0ODxJLoFueTeYMa9pKrr2svIM2gA+AGH4ax2i
	 SFyxwhczsOhxUJHgXjdTIJ0Eyk9C1iQrMNRIvfeTIX+U914zmGguH85j4NTQ47BbAO
	 W10MBjdCjFeAw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b403bb7843eso720946066b.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 22:35:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX32pSO5+LbP6wLMs//alH2KAQzOLKXyOP+jblB9VvpqmFS4Quzb2Ij0wVAmL9mnyTB0mRh0JcTet34@vger.kernel.org
X-Gm-Message-State: AOJu0YxnOPe4UWcVza5KSZ9yH4ak7491FMDmx2HSsDX2Bc4NYmmfIuqH
	W2m6GQkHtBLv6JBQG39GJAuTPj9bKhqmuZPyIuBd/V5JwqfOYs7+R4A3YBbkue3pXi6NPxiyCHB
	xauNAFVTXN+Kl913lHcK6l9rJxm9P69o=
X-Google-Smtp-Source: AGHT+IGJ8vJJhlpaws17DbH8YvNznNg35vZBBhvw4ze2LW69dvFdUZTxnYKudaXWdopgIaUC8wm0j3I4yu4CuSadzsU=
X-Received: by 2002:a17:907:5c9:b0:b3e:fe8f:764 with SMTP id
 a640c23a62f3a-b6473b51c3amr1491346966b.32.1760938530955; Sun, 19 Oct 2025
 22:35:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev> <20251014072856.3004683-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014072856.3004683-5-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 14:35:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_xwKGST7PXu9ha5wdBF_M-qoe2g52Dp9Y3-0r+aYXa-w@mail.gmail.com>
X-Gm-Features: AS18NWDE9ndh_wUKHI08XJDuUrySPQisDTHRSfrG6H2JnZao0cRGyNPG-iHYZTw
Message-ID: <CAKYAXd_xwKGST7PXu9ha5wdBF_M-qoe2g52Dp9Y3-0r+aYXa-w@mail.gmail.com>
Subject: Re: [PATCH v3 15/22] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/cifspdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 4:30=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Rename "struct filesystem_attribute_info" to "FILE_SYSTEM_ATTRIBUTE_INFO"=
,
> then move duplicate definitions to common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Please check the warnings from checkpatch.pl.

WARNING: do not add new typedefs
#109: FILE: fs/smb/common/cifspdu.h:352:
+typedef struct {

WARNING: Prefer __packed over __attribute__((packed))
#114: FILE: fs/smb/common/cifspdu.h:357:
+} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;

> ---
>  fs/smb/client/cifspdu.h    | 7 -------
>  fs/smb/common/cifspdu.h    | 8 ++++++++
>  fs/smb/server/smb2pdu.c    | 6 +++---
>  fs/smb/server/smb_common.h | 7 -------
>  4 files changed, 11 insertions(+), 17 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index 07eb821654e1..a6f7e168961e 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -1937,13 +1937,6 @@ typedef struct {
>  /* minimum includes first three fields, and empty FS Name */
>  #define MIN_FS_ATTR_INFO_SIZE 12
>
> -typedef struct {
> -       __le32 Attributes;
> -       __le32 MaxPathNameComponentLength;
> -       __le32 FileSystemNameLen;
> -       char FileSystemName[52]; /* do not have to save this - get subset=
? */
> -} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
> -
>  /***********************************************************************=
*******/
>  /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer fo=
rmats */
>  /***********************************************************************=
*******/
> diff --git a/fs/smb/common/cifspdu.h b/fs/smb/common/cifspdu.h
> index 1109c20f7bf8..560900617be7 100644
> --- a/fs/smb/common/cifspdu.h
> +++ b/fs/smb/common/cifspdu.h
> @@ -348,4 +348,12 @@ typedef struct server_negotiate_rsp {
>  #define FILE_CASE_PRESERVED_NAMES      0x00000002
>  #define FILE_CASE_SENSITIVE_SEARCH     0x00000001
>
> +/* See FS-FSCC 2.5.1 */
> +typedef struct {
> +       __le32 Attributes;
> +       __le32 MaxPathNameComponentLength;
> +       __le32 FileSystemNameLen;
> +       __le16 FileSystemName[]; /* do not have to save this - get subset=
? */
> +} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
> +
>  #endif /* _COMMON_CIFSPDU_H */
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index a46d4ddade9e..a05b04799c0d 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5485,10 +5485,10 @@ static int smb2_get_info_filesystem(struct ksmbd_=
work *work,
>         }
>         case FS_ATTRIBUTE_INFORMATION:
>         {
> -               struct filesystem_attribute_info *info;
> +               FILE_SYSTEM_ATTRIBUTE_INFO *info;
>                 size_t sz;
>
> -               info =3D (struct filesystem_attribute_info *)rsp->Buffer;
> +               info =3D (FILE_SYSTEM_ATTRIBUTE_INFO *)rsp->Buffer;
>                 info->Attributes =3D cpu_to_le32(FILE_SUPPORTS_OBJECT_IDS=
 |
>                                                FILE_PERSISTENT_ACLS |
>                                                FILE_UNICODE_ON_DISK |
> @@ -5507,7 +5507,7 @@ static int smb2_get_info_filesystem(struct ksmbd_wo=
rk *work,
>                                         "NTFS", PATH_MAX, conn->local_nls=
, 0);
>                 len =3D len * 2;
>                 info->FileSystemNameLen =3D cpu_to_le32(len);
> -               sz =3D sizeof(struct filesystem_attribute_info) + len;
> +               sz =3D sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) + len;
>                 rsp->OutputBufferLength =3D cpu_to_le32(sz);
>                 break;
>         }
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index a5dd656c36f1..016ec93e6df4 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -56,13 +56,6 @@
>                 FILE_EXECUTE | FILE_DELETE_CHILD | \
>                 FILE_READ_ATTRIBUTES | FILE_WRITE_ATTRIBUTES)
>
> -struct filesystem_attribute_info {
> -       __le32 Attributes;
> -       __le32 MaxPathNameComponentLength;
> -       __le32 FileSystemNameLen;
> -       __le16 FileSystemName[]; /* do not have to save this - get subset=
? */
> -} __packed;
> -
>  struct filesystem_device_info {
>         __le32 DeviceType;
>         __le32 DeviceCharacteristics;
> --
> 2.43.0
>

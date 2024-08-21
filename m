Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F39171066;
	Wed, 21 Aug 2024 19:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724269889; cv=none; b=YRGGoL2Kb/WBMaEbJxSZN86OH5a24yplT+JI8J+CLBGQvEpm1NrpVtjF1jn6yookOrzTgGLGDuHY0J/aqE9iuw71wKUjBwhy8LlKjCmfAk8MaNeRrqVVdFEWNisOUGT9KLl67Lp9sHA4xOHjzEmiXQRYeBHJO53DiMmhzHKQC48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724269889; c=relaxed/simple;
	bh=RV79pZyAk89wV7IZyPRZ3c+JwWNAY79LO4tqoiruEt0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yuaa0vVLADIsaq0ue6jm4MG98h4GXQSGhEAT27YQG1j6GwA3sIVoXQlJ2FzjzlupmP0kkpf86V5JQtZAn51FjNYlp/sxpXU4XMmkv9cimm0NRuFMySOoUAcymHS35ggctuPb3d6Zshbdn1G9usqTD2+GP8Qu5HVbcw5ug7CXb2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OzkFwFLg; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OzkFwFLg"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-530e062217eso88522e87.1;
        Wed, 21 Aug 2024 12:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724269885; x=1724874685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NLhmbmyjy8hjjCX4hi+KvgP62vWsvB01yymrRQ6wR8U=;
        b=OzkFwFLgCi9UuNvNF39tKPBx5EvXKilh5DN+QKKQUmV/i+2SwHvF/dmivEOYAeNhRi
         clxV/mPidhkfp/XpKCfThMbOHz2r4RTN9Sl6BjePTn5BRgVuBkj/jijIy04Mh6W0MEZI
         3Djy/tJoDuSXwZNfn7y05P954Xfg87F6+NBCdC3gRVINWZTZPw8MpZuiEz4MgoSIhHah
         1ENZDX+CC9eKuSJQGLAmBk7scDpzjZ1OBJW9llycltaoV1ETzjeTHiQfs0bakVaI9/RN
         OoiLQZewxb9MoDf86GpqN6bGEGUZzdtn2uY//PhFkO2amg6ZHIn83j+N/de8qbGcZO7p
         Pidw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724269885; x=1724874685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NLhmbmyjy8hjjCX4hi+KvgP62vWsvB01yymrRQ6wR8U=;
        b=P/kD6OYCu1OY4Qp6Oiq70v/lUC3VIABGLd1ExDE+oysinincqQlrRLZ3sp+ClrMYy7
         MNPSNGAq8VGSfnH/dFh7JxFgrmAFJTDkY6oy/tbQhS57Npn/O6qqroVBDNWG8DRWZOl/
         e5Dgv7KXAJiqyZCKqSZSN0SsI+npPi3SBVxgtOIyE3M7AQANtdVF8aMv9UFUAudjyp39
         /fKsPdUTJnimAHbYdNB7o4tY1v9CV6PU7fBuzfWwv1fcZMZUm9kXIPU0EbwQxwy6pp1M
         VDQE7zO/wFZ2DnqNMDtsL8scHHNTDFSaoFEN/2VboUGmXZz5baqoICPQJrsZuZNwvBUJ
         3Yqg==
X-Forwarded-Encrypted: i=1; AJvYcCVBP5B+iqx8xNSlxt2H40HrnvGHTyN2gY7EWFMu3iln5ol6eneHKApoprhxD5HN2rlYE+hVdz2msPA/EExm@vger.kernel.org, AJvYcCXtKyN5LT2ICcDTeFTCGbCHDCuunu+ZX0vaVNgvo+Nr8jWIhOx2ltC4OuPXwxSWZ5hw91r23uTC6TO1@vger.kernel.org
X-Gm-Message-State: AOJu0Yze3JCy6cbWrRmWCy+rPpD7rHiRp8YiwgP0ZDK3vp5OvxqRreSv
	CvOA77SgyGP+dztlso8SXVd311XXlwnCdBHpXT+TcYEFNzvFDtxSIrWrc5fBLW7nM6uDASPULPr
	vy09iHBViPwUrA+BF3WuulcBkLYc=
X-Google-Smtp-Source: AGHT+IEMrbeSwRdWjgmxAGOa3TjA1C7uJECxwBInD7Fo+ycURP+9D3FjDzGHtsh+R8OBdkZKKO9/5zUY+TqrbeE4d0E=
X-Received: by 2002:a05:6512:118f:b0:530:b871:eb9a with SMTP id
 2adb3069b0e04-533485efb26mr2437461e87.47.1724269885056; Wed, 21 Aug 2024
 12:51:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240820143319.274033-1-chenxiaosong@chenxiaosong.com> <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240820143319.274033-7-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 21 Aug 2024 14:51:13 -0500
Message-ID: <CAH2r5mt37quVDJsjqpKsaFi8PhT0PBeKyjn8x6CMowZr5GvAyA@mail.gmail.com>
Subject: Re: [PATCH 6/8] smb: move some duplicate definitions to common/smbacl.h
To: chenxiaosong@chenxiaosong.com
Cc: linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	bharathsm@microsoft.com, chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, 
	huhai@kylinos.cn, liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next-next (target for 6.12-rc1) but fixed
the typo in author !=3D Signed-off-by

On Tue, Aug 20, 2024 at 9:43=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> In order to maintain the code more easily, move duplicate acl
> definitions to new common header file.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> ---
>  fs/smb/client/cifsacl.h | 58 +--------------------------
>  fs/smb/common/smbacl.h  | 88 +++++++++++++++++++++++++++++++++++++++++
>  fs/smb/server/smbacl.h  | 80 +------------------------------------
>  3 files changed, 91 insertions(+), 135 deletions(-)
>  create mode 100644 fs/smb/common/smbacl.h
>
> diff --git a/fs/smb/client/cifsacl.h b/fs/smb/client/cifsacl.h
> index ccbfc754bd3c..74cff8a121e5 100644
> --- a/fs/smb/client/cifsacl.h
> +++ b/fs/smb/client/cifsacl.h
> @@ -9,8 +9,7 @@
>  #ifndef _CIFSACL_H
>  #define _CIFSACL_H
>
> -#define NUM_AUTHS (6)  /* number of authority fields */
> -#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fiel=
ds */
> +#include "../common/smbacl.h"
>
>  #define READ_BIT        0x4
>  #define WRITE_BIT       0x2
> @@ -23,12 +22,6 @@
>  #define UBITSHIFT      6
>  #define GBITSHIFT      3
>
> -#define ACCESS_ALLOWED 0
> -#define ACCESS_DENIED  1
> -
> -#define SIDOWNER 1
> -#define SIDGROUP 2
> -
>  /*
>   * Security Descriptor length containing DACL with 3 ACEs (one each for
>   * owner, group and world).
> @@ -37,24 +30,6 @@
>                               sizeof(struct cifs_acl) + \
>                               (sizeof(struct cifs_ace) * 4))
>
> -/*
> - * Maximum size of a string representation of a SID:
> - *
> - * The fields are unsigned values in decimal. So:
> - *
> - * u8:  max 3 bytes in decimal
> - * u32: max 10 bytes in decimal
> - *
> - * "S-" + 3 bytes for version field + 15 for authority field + NULL term=
inator
> - *
> - * For authority field, max is when all 6 values are non-zero and it mus=
t be
> - * represented in hex. So "-0x" + 12 hex digits.
> - *
> - * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
> - */
> -#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
> -#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string =
*/
> -
>  struct cifs_ntsd {
>         __le16 revision; /* revision level */
>         __le16 type;
> @@ -80,37 +55,6 @@ struct cifs_acl {
>         __le32 num_aces;
>  } __attribute__((packed));
>
> -/* ACE types - see MS-DTYP 2.4.4.1 */
> -#define ACCESS_ALLOWED_ACE_TYPE        0x00
> -#define ACCESS_DENIED_ACE_TYPE 0x01
> -#define SYSTEM_AUDIT_ACE_TYPE  0x02
> -#define SYSTEM_ALARM_ACE_TYPE  0x03
> -#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
> -#define ACCESS_ALLOWED_OBJECT_ACE_TYPE 0x05
> -#define ACCESS_DENIED_OBJECT_ACE_TYPE  0x06
> -#define SYSTEM_AUDIT_OBJECT_ACE_TYPE   0x07
> -#define SYSTEM_ALARM_OBJECT_ACE_TYPE   0x08
> -#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
> -#define ACCESS_DENIED_CALLBACK_ACE_TYPE        0x0A
> -#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
> -#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
> -#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE 0x0D
> -#define SYSTEM_ALARM_CALLBACK_ACE_TYPE 0x0E /* Reserved */
> -#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
> -#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
> -#define SYSTEM_MANDATORY_LABEL_ACE_TYPE        0x11
> -#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
> -#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
> -
> -/* ACE flags */
> -#define OBJECT_INHERIT_ACE     0x01
> -#define CONTAINER_INHERIT_ACE  0x02
> -#define NO_PROPAGATE_INHERIT_ACE 0x04
> -#define INHERIT_ONLY_ACE       0x08
> -#define INHERITED_ACE          0x10
> -#define SUCCESSFUL_ACCESS_ACE_FLAG 0x40
> -#define FAILED_ACCESS_ACE_FLAG 0x80
> -
>  struct cifs_ace {
>         __u8 type; /* see above and MS-DTYP 2.4.4.1 */
>         __u8 flags;
> diff --git a/fs/smb/common/smbacl.h b/fs/smb/common/smbacl.h
> new file mode 100644
> index 000000000000..b46341d56e6a
> --- /dev/null
> +++ b/fs/smb/common/smbacl.h
> @@ -0,0 +1,88 @@
> +/* SPDX-License-Identifier: LGPL-2.1+ */
> +/*
> + *   Copyright (c) International Business Machines  Corp., 2007
> + *   Author(s): Steve French (sfrench@us.ibm.com)
> + *   Modified by Namjae Jeon (linkinjeon@kernel.org)
> + */
> +
> +#ifndef _COMMON_SMBACL_H
> +#define _COMMON_SMBACL_H
> +
> +#define NUM_AUTHS (6)  /* number of authority fields */
> +#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fiel=
ds */
> +
> +/*
> + * ACE types - see MS-DTYP 2.4.4.1
> + */
> +enum {
> +       ACCESS_ALLOWED,
> +       ACCESS_DENIED,
> +};
> +
> +/*
> + * Security ID types
> + */
> +enum {
> +       SIDOWNER =3D 1,
> +       SIDGROUP,
> +       SIDCREATOR_OWNER,
> +       SIDCREATOR_GROUP,
> +       SIDUNIX_USER,
> +       SIDUNIX_GROUP,
> +       SIDNFS_USER,
> +       SIDNFS_GROUP,
> +       SIDNFS_MODE,
> +};
> +
> +/* ACE types - see MS-DTYP 2.4.4.1 */
> +#define ACCESS_ALLOWED_ACE_TYPE 0x00
> +#define ACCESS_DENIED_ACE_TYPE  0x01
> +#define SYSTEM_AUDIT_ACE_TYPE   0x02
> +#define SYSTEM_ALARM_ACE_TYPE   0x03
> +#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
> +#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
> +#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
> +#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
> +#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
> +#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
> +#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
> +#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
> +#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
> +#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
> +#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
> +#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
> +#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
> +#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
> +#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
> +#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
> +
> +/* ACE flags */
> +#define OBJECT_INHERIT_ACE             0x01
> +#define CONTAINER_INHERIT_ACE          0x02
> +#define NO_PROPAGATE_INHERIT_ACE       0x04
> +#define INHERIT_ONLY_ACE               0x08
> +#define INHERITED_ACE                  0x10
> +#define SUCCESSFUL_ACCESS_ACE_FLAG     0x40
> +#define FAILED_ACCESS_ACE_FLAG         0x80
> +
> +/*
> + * Maximum size of a string representation of a SID:
> + *
> + * The fields are unsigned values in decimal. So:
> + *
> + * u8:  max 3 bytes in decimal
> + * u32: max 10 bytes in decimal
> + *
> + * "S-" + 3 bytes for version field + 15 for authority field + NULL term=
inator
> + *
> + * For authority field, max is when all 6 values are non-zero and it mus=
t be
> + * represented in hex. So "-0x" + 12 hex digits.
> + *
> + * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
> + */
> +#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
> +#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string =
*/
> +
> +#define DOMAIN_USER_RID_LE     cpu_to_le32(513)
> +
> +#endif /* _COMMON_SMBACL_H */
> diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
> index 2b52861707d8..3e44bb77d6b0 100644
> --- a/fs/smb/server/smbacl.h
> +++ b/fs/smb/server/smbacl.h
> @@ -8,6 +8,7 @@
>  #ifndef _SMBACL_H
>  #define _SMBACL_H
>
> +#include "../common/smbacl.h"
>  #include <linux/fs.h>
>  #include <linux/namei.h>
>  #include <linux/posix_acl.h>
> @@ -15,32 +16,6 @@
>
>  #include "mgmt/tree_connect.h"
>
> -#define NUM_AUTHS (6)  /* number of authority fields */
> -#define SID_MAX_SUB_AUTHORITIES (15) /* max number of sub authority fiel=
ds */
> -
> -/*
> - * ACE types - see MS-DTYP 2.4.4.1
> - */
> -enum {
> -       ACCESS_ALLOWED,
> -       ACCESS_DENIED,
> -};
> -
> -/*
> - * Security ID types
> - */
> -enum {
> -       SIDOWNER =3D 1,
> -       SIDGROUP,
> -       SIDCREATOR_OWNER,
> -       SIDCREATOR_GROUP,
> -       SIDUNIX_USER,
> -       SIDUNIX_GROUP,
> -       SIDNFS_USER,
> -       SIDNFS_GROUP,
> -       SIDNFS_MODE,
> -};
> -
>  /* Revision for ACLs */
>  #define SD_REVISION    1
>
> @@ -62,57 +37,6 @@ enum {
>  #define RM_CONTROL_VALID       0x4000
>  #define SELF_RELATIVE          0x8000
>
> -/* ACE types - see MS-DTYP 2.4.4.1 */
> -#define ACCESS_ALLOWED_ACE_TYPE 0x00
> -#define ACCESS_DENIED_ACE_TYPE  0x01
> -#define SYSTEM_AUDIT_ACE_TYPE   0x02
> -#define SYSTEM_ALARM_ACE_TYPE   0x03
> -#define ACCESS_ALLOWED_COMPOUND_ACE_TYPE 0x04
> -#define ACCESS_ALLOWED_OBJECT_ACE_TYPE  0x05
> -#define ACCESS_DENIED_OBJECT_ACE_TYPE   0x06
> -#define SYSTEM_AUDIT_OBJECT_ACE_TYPE    0x07
> -#define SYSTEM_ALARM_OBJECT_ACE_TYPE    0x08
> -#define ACCESS_ALLOWED_CALLBACK_ACE_TYPE 0x09
> -#define ACCESS_DENIED_CALLBACK_ACE_TYPE 0x0A
> -#define ACCESS_ALLOWED_CALLBACK_OBJECT_ACE_TYPE 0x0B
> -#define ACCESS_DENIED_CALLBACK_OBJECT_ACE_TYPE  0x0C
> -#define SYSTEM_AUDIT_CALLBACK_ACE_TYPE  0x0D
> -#define SYSTEM_ALARM_CALLBACK_ACE_TYPE  0x0E /* Reserved */
> -#define SYSTEM_AUDIT_CALLBACK_OBJECT_ACE_TYPE 0x0F
> -#define SYSTEM_ALARM_CALLBACK_OBJECT_ACE_TYPE 0x10 /* reserved */
> -#define SYSTEM_MANDATORY_LABEL_ACE_TYPE 0x11
> -#define SYSTEM_RESOURCE_ATTRIBUTE_ACE_TYPE 0x12
> -#define SYSTEM_SCOPED_POLICY_ID_ACE_TYPE 0x13
> -
> -/* ACE flags */
> -#define OBJECT_INHERIT_ACE             0x01
> -#define CONTAINER_INHERIT_ACE          0x02
> -#define NO_PROPAGATE_INHERIT_ACE       0x04
> -#define INHERIT_ONLY_ACE               0x08
> -#define INHERITED_ACE                  0x10
> -#define SUCCESSFUL_ACCESS_ACE_FLAG     0x40
> -#define FAILED_ACCESS_ACE_FLAG         0x80
> -
> -/*
> - * Maximum size of a string representation of a SID:
> - *
> - * The fields are unsigned values in decimal. So:
> - *
> - * u8:  max 3 bytes in decimal
> - * u32: max 10 bytes in decimal
> - *
> - * "S-" + 3 bytes for version field + 15 for authority field + NULL term=
inator
> - *
> - * For authority field, max is when all 6 values are non-zero and it mus=
t be
> - * represented in hex. So "-0x" + 12 hex digits.
> - *
> - * Add 11 bytes for each subauthority field (10 bytes each + 1 for '-')
> - */
> -#define SID_STRING_BASE_SIZE (2 + 3 + 15 + 1)
> -#define SID_STRING_SUBAUTH_SIZE (11) /* size of a single subauth string =
*/
> -
> -#define DOMAIN_USER_RID_LE     cpu_to_le32(513)
> -
>  struct ksmbd_conn;
>
>  struct smb_ntsd {
> @@ -131,7 +55,7 @@ struct smb_sid {
>         __le32 sub_auth[SID_MAX_SUB_AUTHORITIES]; /* sub_auth[num_subauth=
] */
>  } __packed;
>
> -/* size of a struct cifs_sid, sans sub_auth array */
> +/* size of a struct smb_sid, sans sub_auth array */
>  #define CIFS_SID_BASE_SIZE (1 + 1 + NUM_AUTHS)
>
>  struct smb_acl {
> --
> 2.34.1
>
>
>


--=20
Thanks,

Steve

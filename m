Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEA418FDDB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 04:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760935158; cv=none; b=P2P76lj5IDIMP0kb7vG7XSaBd985eP5f6aTV/M2s9CD+Ad7H9T3ARirh9wqAiZrMbGE9wadQqXLOww+wnf/yTfwbDWdGeS+Y2KT250MZygmud8ww+1sogE4va9AOl3/+4DfDyq5GQvX3wvd+EPCNsxjfsnciI6pJDzCV2T+xjPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760935158; c=relaxed/simple;
	bh=0lEuHphZEJBnAn7ReiIvbjfn1Hb0S/RVFc4qor7YKp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GC/p20U75f87Z+iz2BeyHcbo3cO+OwpS0KkYPQxv6BQcPKaBy99ZeYyc64gMNAQq76FqrrxuHwHJU+noamyFRlDcR1SxQqIQh3Ya5y5lAqp/sDyQ7YALg5+q4T3oy/JKFYpV3i6KPQV4OUdaNOIkH/Wk+wwgUkknfdioW6WH4yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=faYkP5NZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faYkP5NZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3623CC4CEFB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 04:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760935158;
	bh=0lEuHphZEJBnAn7ReiIvbjfn1Hb0S/RVFc4qor7YKp0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=faYkP5NZE16YZIaz6nqK6z7ynSXCjhcD1uOyAeEPWJ4sP5bJpqucJS6RQlOGOkXKR
	 mfHHL1Yf0hu+lO+sx+PQxbuFXJg+zensK2iWp0N+QiEN3bIy906y9h1qutHBGQP8qh
	 ZPUkkNk/pEOb/i04Xnh+KeIqH+oZk7e7jtBjdzt1yhn0hakKWt9ZWrvSpz+YysU2N6
	 qCpWsUpZwAWu9TOquIfHaJiohC2DD4q7j2oWuAXnx/2bqQ5l/XLYMV/Fyip4mkjaLv
	 xb7MELuNZdBgvlOk07bHGiuB9bYXljRnaMj72qR18bAJAcanYpPEXKR8Vo+3cpJQo0
	 wU7oD0UnnQFAA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b403bb7843eso714602666b.3
        for <linux-cifs@vger.kernel.org>; Sun, 19 Oct 2025 21:39:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUsVVYuNbdLBxx+VTf3zloj5W6NUTGN4hPxlAKnoWiLzoYica/yGc6SP/2oxOa8uWCN0TsI22N4FwwO@vger.kernel.org
X-Gm-Message-State: AOJu0YytBT3WxYkD99O+McvWsQg8veKcDyi1Vo0ZCfitntqq8kE9ZqGP
	RvSPaRQllN78tTtpnIQ/2bi0C8TsLqoXEqs7hgONfFKNIiYOOuGSiWqDxlT9R+M4xXtxmF2wTzR
	i+9/AfkuwdfAdVK31vRGC9ID4aQm81RM=
X-Google-Smtp-Source: AGHT+IFePAXF7U5/SChhNT0TWqp8e7MJxybLoyo+yfz+CrPCbQrNHNTphVAVhfTnBX18iJLK2g8Xmt/Vyr7nk4DfoIw=
X-Received: by 2002:a17:907:fd15:b0:b47:de64:df34 with SMTP id
 a640c23a62f3a-b6474241266mr1497341966b.51.1760935156739; Sun, 19 Oct 2025
 21:39:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev> <20251014071917.3004573-4-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251014071917.3004573-4-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Oct 2025 13:39:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9hFbYvLtX7TRL0dmVTQj_hvAaY=uKhmUtCUVNhJuGMzg@mail.gmail.com>
X-Gm-Features: AS18NWDC2DN-ewOyxqqf19p2skDpuXOuak1yYFKOalzKxymLebLbhSfRaQbhXJY
Message-ID: <CAKYAXd9hFbYvLtX7TRL0dmVTQj_hvAaY=uKhmUtCUVNhJuGMzg@mail.gmail.com>
Subject: Re: [PATCH v3 03/22] smb: move some duplicate definitions to common/cifsglob.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, christophe.jaillet@wanadoo.fr, 
	zhangguodong@kylinos.cn, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 14, 2025 at 4:21=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> In order to maintain the code more easily, move duplicate definitions to
> new common header file.
>
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>  fs/smb/client/cifsglob.h   | 19 +------------------
>  fs/smb/common/cifsglob.h   | 30 ++++++++++++++++++++++++++++++
>  fs/smb/server/smb_common.h | 14 +-------------
>  3 files changed, 32 insertions(+), 31 deletions(-)
>  create mode 100644 fs/smb/common/cifsglob.h
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 8f6f567d7474..c5034cf9ac9e 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -24,6 +24,7 @@
>  #include "cifsacl.h"
>  #include <crypto/internal/hash.h>
>  #include <uapi/linux/cifs/cifs_mount.h>
> +#include "../common/cifsglob.h"
cifs is a legacy name. How about renaming it smbglob.h?
>  #include "../common/smb2pdu.h"
>  #include "smb2pdu.h"
>  #include <linux/filelock.h>
> @@ -702,12 +703,6 @@ get_rfc1002_length(void *buf)
>         return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
>  }
>
> -static inline void
> -inc_rfc1001_len(void *buf, int count)
> -{
> -       be32_add_cpu((__be32 *)buf, count);
> -}
> -
>  struct TCP_Server_Info {
>         struct list_head tcp_ses_list;
>         struct list_head smb_ses_list;
> @@ -1021,8 +1016,6 @@ compare_mid(__u16 mid, const struct smb_hdr *smb)
>  #define CIFS_MAX_RFC1002_WSIZE ((1<<17) - 1 - sizeof(WRITE_REQ) + 4)
>  #define CIFS_MAX_RFC1002_RSIZE ((1<<17) - 1 - sizeof(READ_RSP) + 4)
>
> -#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> -
>  /*
>   * Windows only supports a max of 60kb reads and 65535 byte writes. Defa=
ult to
>   * those values when posix extensions aren't in force. In actuality here=
, we
> @@ -2148,30 +2141,20 @@ extern mempool_t cifs_io_request_pool;
>  extern mempool_t cifs_io_subrequest_pool;
>
>  /* Operations for different SMB versions */
> -#define SMB1_VERSION_STRING    "1.0"
> -#define SMB20_VERSION_STRING    "2.0"
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
>  extern struct smb_version_operations smb1_operations;
>  extern struct smb_version_values smb1_values;
>  extern struct smb_version_operations smb20_operations;
>  extern struct smb_version_values smb20_values;
>  #endif /* CIFS_ALLOW_INSECURE_LEGACY */
> -#define SMB21_VERSION_STRING   "2.1"
>  extern struct smb_version_operations smb21_operations;
>  extern struct smb_version_values smb21_values;
> -#define SMBDEFAULT_VERSION_STRING "default"
>  extern struct smb_version_values smbdefault_values;
> -#define SMB3ANY_VERSION_STRING "3"
>  extern struct smb_version_values smb3any_values;
> -#define SMB30_VERSION_STRING   "3.0"
>  extern struct smb_version_operations smb30_operations;
>  extern struct smb_version_values smb30_values;
> -#define SMB302_VERSION_STRING  "3.02"
> -#define ALT_SMB302_VERSION_STRING "3.0.2"
>  /*extern struct smb_version_operations smb302_operations;*/ /* not neede=
d yet */
>  extern struct smb_version_values smb302_values;
> -#define SMB311_VERSION_STRING  "3.1.1"
> -#define ALT_SMB311_VERSION_STRING "3.11"
>  extern struct smb_version_operations smb311_operations;
>  extern struct smb_version_values smb311_values;
>
> diff --git a/fs/smb/common/cifsglob.h b/fs/smb/common/cifsglob.h
> new file mode 100644
> index 000000000000..00fd215e3eb5
> --- /dev/null
> +++ b/fs/smb/common/cifsglob.h
> @@ -0,0 +1,30 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + *
> + *   Copyright (C) International Business Machines  Corp., 2002,2008
> + *   Author(s): Steve French (sfrench@us.ibm.com)
> + *              Jeremy Allison (jra@samba.org)
> + *
> + */
> +#ifndef _COMMON_CIFS_GLOB_H
> +#define _COMMON_CIFS_GLOB_H
> +
> +static inline void inc_rfc1001_len(void *buf, int count)
> +{
> +       be32_add_cpu((__be32 *)buf, count);
> +}
> +
> +#define SMB1_VERSION_STRING    "1.0"
> +#define SMB20_VERSION_STRING    "2.0"
> +#define SMB21_VERSION_STRING   "2.1"
> +#define SMBDEFAULT_VERSION_STRING "default"
> +#define SMB3ANY_VERSION_STRING "3"
> +#define SMB30_VERSION_STRING   "3.0"
> +#define SMB302_VERSION_STRING  "3.02"
> +#define ALT_SMB302_VERSION_STRING "3.0.2"
> +#define SMB311_VERSION_STRING  "3.1.1"
> +#define ALT_SMB311_VERSION_STRING "3.11"
> +
> +#define CIFS_DEFAULT_IOSIZE (1024 * 1024)
> +
> +#endif /* _COMMON_CIFS_GLOB_H */
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index d742ba754348..863716207a0d 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -10,6 +10,7 @@
>
>  #include "glob.h"
>  #include "nterr.h"
> +#include "../common/cifsglob.h"
>  #include "../common/smb2pdu.h"
>  #include "smb2pdu.h"
>
> @@ -26,16 +27,8 @@
>  #define SMB311_PROT            6
>  #define BAD_PROT               0xFFFF
>
> -#define SMB1_VERSION_STRING    "1.0"
> -#define SMB20_VERSION_STRING   "2.0"
> -#define SMB21_VERSION_STRING   "2.1"
> -#define SMB30_VERSION_STRING   "3.0"
> -#define SMB302_VERSION_STRING  "3.02"
> -#define SMB311_VERSION_STRING  "3.1.1"
> -
>  #define SMB_ECHO_INTERVAL      (60 * HZ)
>
> -#define CIFS_DEFAULT_IOSIZE    (64 * 1024)
>  #define MAX_CIFS_SMALL_BUFFER_SIZE 448 /* big enough for most */
>
>  #define MAX_STREAM_PROT_LEN    0x00FFFFFF
> @@ -464,9 +457,4 @@ static inline unsigned int get_rfc1002_len(void *buf)
>  {
>         return be32_to_cpu(*((__be32 *)buf)) & 0xffffff;
>  }
> -
> -static inline void inc_rfc1001_len(void *buf, int count)
> -{
> -       be32_add_cpu((__be32 *)buf, count);
> -}
>  #endif /* __SMB_COMMON_H__ */
> --
> 2.43.0
>

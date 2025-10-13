Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7A1A9B46
	for <linux-cifs@vger.kernel.org>; Mon, 13 Oct 2025 03:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760325322; cv=none; b=u4XCjPVTuHM6AHYQpgtrK9waT671Pgl0QzNC3GOzrAxLo6TS8toudRFO/+w8ZD1Ch1YftsHNcHiO4Fjo6CBOKt66uIiidiQiJ/K4IvxGGR1YQMpB4tFXe33DU6V93dn0vQpXvAAVpjw9+qZsw1zYaUrF4KkmirYY/FeGzC+jljY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760325322; c=relaxed/simple;
	bh=S7H5wkFKlasUTRHJgnbuQ8KeOe6jUsB16GdlnGIU/3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CwvghjrTuQCj2NeTvduuyPY6roleYCIZmq3WI7F13FNLKpc3BGVUtILfsdJHHrHZY+PSvtJSphSB31BpNpSBigoB+Ife/F1tw3Cb3znmQX8oiPnAjqLuX3cjuXAdGe7ASIe0aXEES4iVFRjADYRkmFV5KoaYJV6KtjoFUmxqzPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=askCyDXP; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="askCyDXP"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-87499a3cd37so30858146d6.3
        for <linux-cifs@vger.kernel.org>; Sun, 12 Oct 2025 20:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760325319; x=1760930119; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivwjJwoHekiW/GElWyuqz+5VYGLWEsbXIWLqG2BLXhM=;
        b=askCyDXPH2W9PO1eIwCZ8eZ8nWzjPM/TmrtoD5Wf12hQOG0WaxGWLGdLxv86qr4n7s
         PWtHrqEIh60tLbsDzHeYGr4Qidb63DJXQVDmCoVjPqNL/XjDrTfheCQLZ7+Z/Hdgo+wr
         Qx5FOCQekhQcj9pXybTwpzQ/mdlJdAxasD5GR3Fdw2V4GAJAvwLU9g4/OgQ8BRi3TZOp
         wYxryTy1IX/s+XG6SM6YZx+fSb8Rbs9D25s3guiMX815VsC5uCmG5SZcTvMn3v8RPIHf
         IzLxGDMwVm3bwQUyuMlMHPz+ioxoq+S6ss75XgwpAwnu/WduyRTDD0VzUZwxs4Si/Sz7
         HjsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760325319; x=1760930119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivwjJwoHekiW/GElWyuqz+5VYGLWEsbXIWLqG2BLXhM=;
        b=X6oYSRL0JC7WFgANg7nTHYalnTqqTv0MSLFy9F4DardKI/4BFcjK7s6E11yTYQeJQW
         keFL6UwveoYiq+AzP3ZO4q+V0TfMCiOYtHcZbvryh5v1opIJXfr4ATmINZs0h97i/iRs
         S27FLmvHlwUtTv7IyLbcXHLHFkeTOKMwOwGp14sZNULKM/ZCLDUiAP2wO6Em38YWs3ZV
         JAzgC+Ly2qTQjIVfW0WARreiPGgJoOqyJSOLBzXH6wppJ5n2/PdR83T4t9RMLBdwgwPr
         oByr7rSGRoNp4+7IWwzFpfkYClrVG+up8Fw0fgQ2aKockeqx9uPNGK0TAXZ4sdyCnYwd
         UvMw==
X-Forwarded-Encrypted: i=1; AJvYcCX62BlsWjgqhu3hw2CVUS3oNteOLpDcaaHZOUEaVEpMkDJEyREKwnjbUSHJ8LWraWf3XgtddRdWYnSM@vger.kernel.org
X-Gm-Message-State: AOJu0YwX1UuXY/mo1q5pzsID8/ZBq2aq3stl6ejJcstKPYgc6JpzArKJ
	i4l61XWe8YYVBHvK/4lvxstO+ahetIs6288YGA6VWc3N6/1lKgAORHdWotOvZ7dMELMfopKFM59
	MsyYV8Ab8muk6xXJNKiXJQGMb7MwNC88=
X-Gm-Gg: ASbGnctuPDSHZbOBlUhMqPiQVPCACSjW8FweWMIZBdPueTwprF1NG7Dx0WFKPIgLLmc
	a6fGCWQadwayBAldyHChK8WfidQdWEbJ0KNl+lLWFGAj75yDQ34agWt/4BM2LZaXycRaILwWfCO
	6cno1c4JDp2WhAgro6Pgx4MkkAvdk2AO2hEINc6dh0/JJWZCkVQOGn3cHKIhC3+92FYcZn5uUay
	ggwiusdSY8CSzlogaPzcjZNnxtN1VSuCvV4Ous+lEkxFVOOTWKDevi9tHVxpbB0fwB7SlDAstih
	+H0PmkO2innGTaeW5n1fRaZxZ2RIuM4eV6H0aI/NCIrgTuVqHfp9+MVTkPRSVHXtKb+sWl0qvrn
	xTCIA0a/zG9Vvg+mawr1VEbfnqKlH8+7NnwzvsKUasQWhsFGI4nw=
X-Google-Smtp-Source: AGHT+IEV2iK6QHc+Z6ZkBdZkclGP6pKl6es0o1epAFUd335wqQRFzKUkHUk9+VMHACaN7Z/UBA1HsLyjrUr2zdapNqQ=
X-Received: by 2002:a05:6214:c29:b0:78f:493d:15c6 with SMTP id
 6a1803df08f44-87b20feda94mr252400486d6.3.1760325319492; Sun, 12 Oct 2025
 20:15:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251012161749.2994033-1-chenxiaosong@chenxiaosong.com> <CB472CFA60B005D5+20251012161749.2994033-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <CB472CFA60B005D5+20251012161749.2994033-4-chenxiaosong@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 12 Oct 2025 22:15:07 -0500
X-Gm-Features: AS18NWC8NgXN6YXYePx_NRRPtW6JzT2_uOAWY_zJ2P60dt4G77krJYRLJntiBTs
Message-ID: <CAH2r5mvcFOYP-Mc5QzoaNoPYP0yiZQThT0c668APRK8y=FNUMw@mail.gmail.com>
Subject: Re: [PATCH v2 03/22] smb: move some duplicate definitions to common/cifsglob.h
To: chenxiaosong@chenxiaosong.com
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org, 
	linkinjeon@kernel.org, sfrench@samba.org, senozhatsky@chromium.org, 
	tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, zhangguodong@kylinos.cn, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git pending testing and any
additional review feedback

On Sun, Oct 12, 2025 at 11:18=E2=80=AFAM <chenxiaosong@chenxiaosong.com> wr=
ote:
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


--=20
Thanks,

Steve

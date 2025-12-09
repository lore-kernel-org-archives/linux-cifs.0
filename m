Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735AB20FAAB
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 02:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765248795; cv=none; b=o2WBRoM+KCbnKVUQXYBk/CB7jTWSQLeL4/6wOmNrTiuQAS9obUVNIthbJqnMzxmPev4eiYjk++MJuq3q1J69+FbBB8iXBpj6VJ4cm29Cx/2vFCenDuQFu5qdNsn7Rv3UaPCQNiKSSYHnrLwW19llbvsorVXy63IrKYVhQBd4UIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765248795; c=relaxed/simple;
	bh=z049QrNcQQXO0CkAlCq0Hur9UAFIdtSSSVdtvpQicEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gFCHlU8StTNWzztxIVBLHIkVgpxNmv/PwCChWQ0j/UIQyYs5mQZdZ7QuWdbQI81GZ8KQKizZxa+nPmlUU185yzTYQHi/N6y+dLc8pyEvMamBM6U8Ll3uqLPlx6ooj/b4s3L9czWvJ5Y+YWnJKMUEOit4eGOcUepjWwZHJXq/FY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eUneBUK0; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUneBUK0"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8804ca2a730so83948186d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 08 Dec 2025 18:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765248792; x=1765853592; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fg7FRo4l1PDu7IlCtTMnfW5780OlRBFGf4+UzPNpGMU=;
        b=eUneBUK0rgOOkfLkzM140PE0GIxr5v7juYsvO11rSF608C/BbE1QniA1UgkUWaW1F6
         V9OMP/bjnyC90PFvFdObsAMGSffbp1vbn1zN7Dwpu9AcMc3UoFViJh7k19sLnCWOD1HJ
         wP3kEmEYiUfmScdnPd4/Vad8xkoXv2f06YIz0aGgtE9I4vf7TsOE1FFGXcg2s9HuLyhH
         E7xGY2DMHpTpDrSYxbWYBIx3oBM3eh5fwHJv1myaxVvs/Qa5wuek0R4Hn6GocPjRxuVR
         0rjG2FzpRCDUJDLB6KTea8y+M3dpg/fqTZnEGAJPqi8SDe2hBXuQeIvWxFPdFD4ZhN+Y
         j55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765248792; x=1765853592;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fg7FRo4l1PDu7IlCtTMnfW5780OlRBFGf4+UzPNpGMU=;
        b=DqD2W/Uf2eeLiyOwdT1gGxsuDkSBo5M8AzvtG4XuPdHzCLIhW5k0d38IdtoI+7zRVu
         NM/kS9eMydsZPjTviekWPrCF2ZfSIpUCEeSMRkMvQst3BfN2YLnW6eZdpAb81iwn9Do6
         5yzsByrZS7APvfH76N6/O7LQIFk6Fo2H6I6Fz1UH1RQpIPxdvDLHVAugzOKdmpDIiNYG
         TkTl7kOy7Qlnc50dakWSNaZVYtVyKN12wkxLJXTMvenawOKMxBcuvoPvE96qI5GlGXRy
         ISTyDlg6P4KbqUYvRzmnx9RcccWP4ZwklnQQ5nOhE2LpZ4vb8yKDVIovzUaroAVcTxrE
         N0xg==
X-Forwarded-Encrypted: i=1; AJvYcCUqdalZmx8Igh9Nyo2R5PNj1ABcUXBN+D7wX34JTZ3HyvqiA5QXqD3clFg1FavJHhGlyRYb1XaXvbqv@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8DXsvtGO5Oc0/Ejpit7XC4cbB3QOlBp9pH7zJPrHetwqyc2gV
	Yc9/+H7PX24DpxbopZhf+WIabUREN5GzajqDH6Fh1pu6gYy+khQuRufLVrPLKAcpqB2GppuA9yK
	8usJGaP9VboiWPVX1HOHBKnCu2xHb01NWyXw0
X-Gm-Gg: ASbGncvYgXXSHFuHS9gkZXMuHFnKeqg2KhxfO/Lsb9pSqsAnifDfK4B2t49d1m6NUCw
	dCMkeEleu0H0RgCEqBM9R+X5g/vnjzLv4qutIB+U4rW3cKKapYszBAQh5/kLBLuM6MJxzCZ33g2
	LcKRH3U4uBDh3YSZxGT3a19arlJfO8Z4698mz/Oy2yy8f2gHq40gEm6FvD7EzuBjZMJjiyGsRBy
	68Ak5WhgECWVz+64jmJkKR5jTiknWtX6lIDm5peNs1vMew1iiw1PzVW11g/SS2cULQzbk/orq+V
	KDq2mlXMfZpTa3Ku5hZcrZ6qPhtwVLTpcAQbZ3y61AxoOEqZRSt5RZ+kk62Br5GahZpTOZlhF5W
	csRvr6eIu8qQ28ontqtWKUUiMZTiaGfgxd6kYoxpR6X1J1YPvEJ4yBDg+feMztAVGe9/2GcQH81
	mKazA/kg==
X-Google-Smtp-Source: AGHT+IEATqmiEQF/Ji29vfNamDackh2qSG8ehGTzQ3NbmJ95D2c3UV7GPG+FHgxEwris9PIttJO7M6r15AJoANtZYjQ=
X-Received: by 2002:a05:6214:519a:b0:882:3bfe:457c with SMTP id
 6a1803df08f44-8883dc5bf85mr156611306d6.49.1765248792191; Mon, 08 Dec 2025
 18:53:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev> <20251209011020.3270989-14-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-14-chenxiaosong.chenxiaosong@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Dec 2025 20:52:59 -0600
X-Gm-Features: AQt7F2petaKzZ-7wpMIyu63WKEMP1hO3Iq5IBHnJsZvNqCD_-aAM7DxYMDoQkeY
Message-ID: <CAH2r5muXiti986tsg7fwLTEw7CceJ6UdtTh6s7CXWqU-D+COAw@mail.gmail.com>
Subject: Re: [PATCH 13/13] smb: move some SMB1 definitions into common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, linkinjeon@kernel.org, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

One option to consider is moving smb1 definitions into a client only
(fs/smb/client) header since ksmbd doesn't use SMB1 technically they
aren't 'common'

Did you find ksmbd server cases where it depends on any of these?

On Mon, Dec 8, 2025 at 7:12=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> These definitions are only used by SMB1, so move them into the new
> common/smb1pdu.h.
>
> Co-developed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> ---
>  fs/smb/client/cifspdu.h    |  2 +-
>  fs/smb/common/smb1pdu.h    | 59 ++++++++++++++++++++++++++++++++++++++
>  fs/smb/common/smb2pdu.h    | 44 ----------------------------
>  fs/smb/common/smbglob.h    |  2 --
>  fs/smb/server/smb_common.h |  1 +
>  5 files changed, 61 insertions(+), 47 deletions(-)
>  create mode 100644 fs/smb/common/smb1pdu.h
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index 758ea29769da..bf6329cb4fd4 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -12,7 +12,7 @@
>  #include <net/sock.h>
>  #include <linux/unaligned.h>
>  #include "../common/smbfsctl.h"
> -#include "../common/smb2pdu.h"
> +#include "../common/smb1pdu.h"
>
>  #define CIFS_PROT   0
>  #define POSIX_PROT  (CIFS_PROT+1)
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> new file mode 100644
> index 000000000000..11797471b2eb
> --- /dev/null
> +++ b/fs/smb/common/smb1pdu.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: LGPL-2.1 */
> +/*
> + *
> + *   Copyright (c) International Business Machines  Corp., 2002,2009
> + *                 2018 Samsung Electronics Co., Ltd.
> + *   Author(s): Steve French (sfrench@us.ibm.com)
> + *              Namjae Jeon (linkinjeon@kernel.org)
> + *
> + */
> +
> +#ifndef _COMMON_SMB1_PDU_H
> +#define _COMMON_SMB1_PDU_H
> +
> +#define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
> +
> +/*
> + * See MS-CIFS 2.2.3.1
> + *     MS-SMB 2.2.3.1
> + */
> +struct smb_hdr {
> +       __be32 smb_buf_length;  /* BB length is only two (rarely three) b=
ytes,
> +               with one or two byte "type" preceding it that will be
> +               zero - we could mask the type byte off */
> +       __u8 Protocol[4];
> +       __u8 Command;
> +       union {
> +               struct {
> +                       __u8 ErrorClass;
> +                       __u8 Reserved;
> +                       __le16 Error;
> +               } __packed DosError;
> +               __le32 CifsError;
> +       } __packed Status;
> +       __u8 Flags;
> +       __le16 Flags2;          /* note: le */
> +       __le16 PidHigh;
> +       union {
> +               struct {
> +                       __le32 SequenceNumber;  /* le */
> +                       __u32 Reserved; /* zero */
> +               } __packed Sequence;
> +               __u8 SecuritySignature[8];      /* le */
> +       } __packed Signature;
> +       __u8 pad[2];
> +       __u16 Tid;
> +       __le16 Pid;
> +       __u16 Uid;
> +       __le16 Mid;
> +       __u8 WordCount;
> +} __packed;
> +
> +/* See MS-CIFS 2.2.4.52.1 */
> +typedef struct smb_negotiate_req {
> +       struct smb_hdr hdr;     /* wct =3D 0 */
> +       __le16 ByteCount;
> +       unsigned char DialectsArray[];
> +} __packed SMB_NEGOTIATE_REQ;
> +
> +#endif /* _COMMON_SMB1_PDU_H */
> diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
> index 2d68bd24f3bd..098f147680c5 100644
> --- a/fs/smb/common/smb2pdu.h
> +++ b/fs/smb/common/smb2pdu.h
> @@ -1642,42 +1642,6 @@ struct smb2_lease_ack {
>         __le64 LeaseDuration;
>  } __packed;
>
> -/*
> - * See MS-CIFS 2.2.3.1
> - *     MS-SMB 2.2.3.1
> - */
> -struct smb_hdr {
> -       __be32 smb_buf_length;  /* BB length is only two (rarely three) b=
ytes,
> -               with one or two byte "type" preceding it that will be
> -               zero - we could mask the type byte off */
> -       __u8 Protocol[4];
> -       __u8 Command;
> -       union {
> -               struct {
> -                       __u8 ErrorClass;
> -                       __u8 Reserved;
> -                       __le16 Error;
> -               } __packed DosError;
> -               __le32 CifsError;
> -       } __packed Status;
> -       __u8 Flags;
> -       __le16 Flags2;          /* note: le */
> -       __le16 PidHigh;
> -       union {
> -               struct {
> -                       __le32 SequenceNumber;  /* le */
> -                       __u32 Reserved; /* zero */
> -               } __packed Sequence;
> -               __u8 SecuritySignature[8];      /* le */
> -       } __packed Signature;
> -       __u8 pad[2];
> -       __u16 Tid;
> -       __le16 Pid;
> -       __u16 Uid;
> -       __le16 Mid;
> -       __u8 WordCount;
> -} __packed;
> -
>  #define OP_BREAK_STRUCT_SIZE_20                24
>  #define OP_BREAK_STRUCT_SIZE_21                36
>
> @@ -1782,14 +1746,6 @@ struct smb_hdr {
>  #define SET_MINIMUM_RIGHTS (FILE_READ_EA | FILE_READ_ATTRIBUTES \
>                                 | READ_CONTROL | SYNCHRONIZE)
>
> -/* See MS-CIFS 2.2.4.52.1 */
> -typedef struct smb_negotiate_req {
> -       struct smb_hdr hdr;     /* wct =3D 0 */
> -       __le16 ByteCount;
> -       unsigned char DialectsArray[];
> -} __packed SMB_NEGOTIATE_REQ;
> -
> -
>  /*
>   * [POSIX-SMB2] SMB3 POSIX Extensions
>   * Link: https://gitlab.com/samba-team/smb3-posix-spec/-/blob/master/smb=
3_posix_extensions.md
> diff --git a/fs/smb/common/smbglob.h b/fs/smb/common/smbglob.h
> index 7853b5771128..353dc4f0971a 100644
> --- a/fs/smb/common/smbglob.h
> +++ b/fs/smb/common/smbglob.h
> @@ -11,8 +11,6 @@
>  #ifndef _COMMON_SMB_GLOB_H
>  #define _COMMON_SMB_GLOB_H
>
> -#define SMB1_PROTO_NUMBER              cpu_to_le32(0x424d53ff)
> -
>  struct smb_version_values {
>         char            *version_string;
>         __u16           protocol_id;
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index b8da31cdbfd1..f47ce4a6719c 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -11,6 +11,7 @@
>  #include "glob.h"
>  #include "nterr.h"
>  #include "../common/smbglob.h"
> +#include "../common/smb1pdu.h"
>  #include "../common/smb2pdu.h"
>  #include "../common/fscc.h"
>  #include "smb2pdu.h"
> --
> 2.43.0
>


--=20
Thanks,

Steve

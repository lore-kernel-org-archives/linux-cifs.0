Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB6A15689D
	for <linux-cifs@vger.kernel.org>; Wed, 24 Apr 2024 06:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713938904; cv=none; b=A2LGI5PfadYbqzh8U7RaCq7Z1K5W+BD8yunhUt3rChCmKLP56mWxme6C/LnO9tLJGl54YkQk8giXCnlwvkSHOJtJu25wYvGQEZb+qJB8CmTukRHfNfMC5NOkuFlX1Y5rzaK28TJbj32HOufMvBtH8uNOPGOYINgE6Rd8P1Jc6lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713938904; c=relaxed/simple;
	bh=NP0Rh+d+ojX9zZY+IMrpzB8L1ILXCNPm8fivMB+phH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KYpUl4lS4Rlb+WSDfDndIBMp9ZXVjmn9gGtj4v+7e+LuLQxSwfaGuxsTLvjp8FUvnvhY5OMzxNvp9GfSZ9ynarch9y/Va59NzHXdN9RQ8vgh6gCdaqH+B1KYnV5Z8b8fcJ+ywiZazAneCFjcMz9Vj7iE+FjhrGJwMStJUWcmQOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QFdwtBUB; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QFdwtBUB"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-518931f8d23so6992748e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Apr 2024 23:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713938901; x=1714543701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6VbdjsCb3cngpFxUS980uS7lfr2RASsYjYPR8Ygz9oE=;
        b=QFdwtBUBLerVuALSAk3KDUfWy21DrotQQwDPkBfaoiZGxwmVm1GuXOyELX1Cbg64PT
         oJT+UzWii9yo294TEI7teYo3biWcotUB3xbgF37AdFMkZiR+N4Wm6vXlU7vmg+E38X6i
         ccG8y8+vwJ/yDcft3oxZ1yA/3ifjgRPe29gqLnNA3DIDuGpLkXk59kZKwJTuelejm44o
         rG0AOWfeoNslLaMZb+5+AWsT8o3cIYdK5H0DakGS4kVuyLo1PIMR076sbKVYZshSKoKY
         /QGPElqKQ7NpZEh3MJ5H+HZTSAmBnLiS1ptPWzV0gT2vUU9FWdyfOcFSmflg2HGp018R
         JSIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713938901; x=1714543701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6VbdjsCb3cngpFxUS980uS7lfr2RASsYjYPR8Ygz9oE=;
        b=Rq1UXYb5PAzN+DGXNluzczWpqa6RovX1ijS6sjiwH62pc1T0TJx3YGr8Ukgcx4mBJc
         ULeSTSJtzt4tI0SYSqvMBSBWVFYwqjuTpvZKr9PpUi217PITjOgV97PCtm8/rm9qadpv
         cIc7YTP7sAixjK0pm7NmvYwxIC3AGaCSe7+kZ0hMkNgWfJcym5UqTB4M5HBybcZ2TMO6
         ACxt6u/hya6fVcByA3bltR/zfQf6niznxf1ce+eH0gniI+mFNhCkqOGkEOprqVGNoqSV
         i19I7ND2ZyIrwg7JxQLZKivewim7MJVdoQ+GxQTEhH8umVyhC8lsIaA3+iFcee1/RkZq
         xX+A==
X-Gm-Message-State: AOJu0YyavM5X1vIOh7rJjaqR116y+EP1WVL+kUYisRPE2fvu6VdmFdZD
	DnoE/JI3YVeDNACeS0y+P5XfPMa/J2kW9sszPmr/kWqT3Cy0jjQ0f/pqNR9uYLgmEtzCI7aEwp8
	nYBsCaN8TEiiWacysgBd0sqKK3Lg=
X-Google-Smtp-Source: AGHT+IGbw4hYFkmvESWaBUZc3mZQO+4bc5zeEMSZLxLnmmUpUmoIDy7SwYF/BprZtqJF25BR6qH9402zWhJmBoqR+y8=
X-Received: by 2002:a05:6512:239f:b0:51b:223f:ac47 with SMTP id
 c31-20020a056512239f00b0051b223fac47mr1309702lfv.41.1713938900145; Tue, 23
 Apr 2024 23:08:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZihxUuQOkZ6Zz363@neat> <CAKYAXd-i3Fjv-7JmQa8bSrWD69yFfi8jqfBJV51JgyseA-yXFQ@mail.gmail.com>
In-Reply-To: <CAKYAXd-i3Fjv-7JmQa8bSrWD69yFfi8jqfBJV51JgyseA-yXFQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 24 Apr 2024 01:08:07 -0500
Message-ID: <CAH2r5mt3W9Y8MJkUyVGjj9-Z_tVJS1UsuV3=1BnA=pch7+MzPg@mail.gmail.com>
Subject: Re: [PATCH][next] smb: client: Fix struct_group() usage in __packed structs
To: Namjae Jeon <linkinjeon@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to cifs-2.6.git for-next

On Tue, Apr 23, 2024 at 11:36=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org=
> wrote:
>
> 2024=EB=85=84 4=EC=9B=94 24=EC=9D=BC (=EC=88=98) =EC=98=A4=EC=A0=84 11:41=
, Gustavo A. R. Silva <gustavoars@kernel.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=
=EC=84=B1:
> >
> > Use struct_group_attr() in __packed structs, instead of struct_group().
> >
> > Below you can see the pahole output before/after changes:
> >
> > pahole -C smb2_file_network_open_info fs/smb/client/smb2ops.o
> > struct smb2_file_network_open_info {
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le64     AllocationSize;       /*    32     8=
 */
> >                         __le64     EndOfFile;            /*    40     8=
 */
> >                         __le32     Attributes;           /*    48     4=
 */
> >                 };                                       /*     0    56=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le64     AllocationSize;       /*    32     8=
 */
> >                         __le64     EndOfFile;            /*    40     8=
 */
> >                         __le32     Attributes;           /*    48     4=
 */
> >                 } network_open_info;                     /*     0    56=
 */
> >         };                                               /*     0    56=
 */
> >         __le32                     Reserved;             /*    56     4=
 */
> >
> >         /* size: 60, cachelines: 1, members: 2 */
> >         /* last cacheline: 60 bytes */
> > } __attribute__((__packed__));
> >
> > pahole -C smb2_file_network_open_info fs/smb/client/smb2ops.o
> > struct smb2_file_network_open_info {
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le64     AllocationSize;       /*    32     8=
 */
> >                         __le64     EndOfFile;            /*    40     8=
 */
> >                         __le32     Attributes;           /*    48     4=
 */
> >                 } __attribute__((__packed__));           /*     0    52=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le64     AllocationSize;       /*    32     8=
 */
> >                         __le64     EndOfFile;            /*    40     8=
 */
> >                         __le32     Attributes;           /*    48     4=
 */
> >                 } __attribute__((__packed__)) network_open_info;       =
/*     0    52 */
> >         };                                               /*     0    52=
 */
> >         __le32                     Reserved;             /*    52     4=
 */
> >
> >         /* size: 56, cachelines: 1, members: 2 */
> >         /* last cacheline: 56 bytes */
> > };
> >
> > pahole -C smb_com_open_rsp fs/smb/client/cifssmb.o
> > struct smb_com_open_rsp {
> >         ...
> >
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*    48     8=
 */
> >                         __le64     LastAccessTime;       /*    56     8=
 */
> >                         /* --- cacheline 1 boundary (64 bytes) --- */
> >                         __le64     LastWriteTime;        /*    64     8=
 */
> >                         __le64     ChangeTime;           /*    72     8=
 */
> >                         __le32     FileAttributes;       /*    80     4=
 */
> >                 };                                       /*    48    40=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*    48     8=
 */
> >                         __le64     LastAccessTime;       /*    56     8=
 */
> >                         /* --- cacheline 1 boundary (64 bytes) --- */
> >                         __le64     LastWriteTime;        /*    64     8=
 */
> >                         __le64     ChangeTime;           /*    72     8=
 */
> >                         __le32     FileAttributes;       /*    80     4=
 */
> >                 } common_attributes;                     /*    48    40=
 */
> >         };                                               /*    48    40=
 */
> >
> >         ...
> >
> >         /* size: 111, cachelines: 2, members: 14 */
> >         /* last cacheline: 47 bytes */
> > } __attribute__((__packed__));
> >
> > pahole -C smb_com_open_rsp fs/smb/client/cifssmb.o
> > struct smb_com_open_rsp {
> >         ...
> >
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*    48     8=
 */
> >                         __le64     LastAccessTime;       /*    56     8=
 */
> >                         /* --- cacheline 1 boundary (64 bytes) --- */
> >                         __le64     LastWriteTime;        /*    64     8=
 */
> >                         __le64     ChangeTime;           /*    72     8=
 */
> >                         __le32     FileAttributes;       /*    80     4=
 */
> >                 } __attribute__((__packed__));           /*    48    36=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*    48     8=
 */
> >                         __le64     LastAccessTime;       /*    56     8=
 */
> >                         /* --- cacheline 1 boundary (64 bytes) --- */
> >                         __le64     LastWriteTime;        /*    64     8=
 */
> >                         __le64     ChangeTime;           /*    72     8=
 */
> >                         __le32     FileAttributes;       /*    80     4=
 */
> >                 } __attribute__((__packed__)) common_attributes;       =
/*    48    36 */
> >         };                                               /*    48    36=
 */
> >
> >         ...
> >
> >         /* size: 107, cachelines: 2, members: 14 */
> >         /* last cacheline: 43 bytes */
> > } __attribute__((__packed__));
> >
> > pahole -C FILE_ALL_INFO fs/smb/client/cifssmb.o
> > typedef struct {
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le32     Attributes;           /*    32     4=
 */
> >                 };                                       /*     0    40=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le32     Attributes;           /*    32     4=
 */
> >                 } common_attributes;                     /*     0    40=
 */
> >         };                                               /*     0    40=
 */
> >
> >         ...
> >
> >         /* size: 113, cachelines: 2, members: 17 */
> >         /* last cacheline: 49 bytes */
> > } __attribute__((__packed__)) FILE_ALL_INFO;
> >
> > pahole -C FILE_ALL_INFO fs/smb/client/cifssmb.o
> > typedef struct {
> >         union {
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le32     Attributes;           /*    32     4=
 */
> >                 } __attribute__((__packed__));           /*     0    36=
 */
> >                 struct {
> >                         __le64     CreationTime;         /*     0     8=
 */
> >                         __le64     LastAccessTime;       /*     8     8=
 */
> >                         __le64     LastWriteTime;        /*    16     8=
 */
> >                         __le64     ChangeTime;           /*    24     8=
 */
> >                         __le32     Attributes;           /*    32     4=
 */
> >                 } __attribute__((__packed__)) common_attributes;       =
/*     0    36 */
> >         };                                               /*     0    36=
 */
> >
> >         ...
> >
> >         /* size: 109, cachelines: 2, members: 17 */
> >         /* last
>
> cacheline: 45 bytes */
> > } __attribute__((__packed__)) FILE_ALL_INFO;
> >
> > Fixes: 0015eb6e1238 ("smb: client, common: fix fortify warnings")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Looks good to me:)
> Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
> Thanks!
>


--=20
Thanks,

Steve

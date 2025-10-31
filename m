Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503212EA75C
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 02:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761878038; cv=none; b=M2sh9MdCEU7V63OZk6wTt+mbmdTaRElMv5BOW1EZBsWt/biLcmK17qSmdj5GQthwLmAmd05mvQi2PCPEscJ5KcYXDtaG/3m/fVAgG+nwYW9EVE+i6gZhQOktnD/kQ1+jLnuFF2Xx8CCkYtgUl4TyIkbkX79OIhnVrQx1vaMaF2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761878038; c=relaxed/simple;
	bh=jCZVMpuSvfzZE8Sq5EH0GrUWN4cGJOLB4SPWdbmSC94=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqrd7dcXbRi+J+pGYW/blCsJ0gvhQHHD3SQBtUOO0j5idikralZlWBfuJpPyDEpHKvt0uIxS4eSoMqhfnocuJTKFDat6RgeepkH3nJJesV3Sb9AGnHZta64dJahBxzH3xWmOpPY4nkFo58vebYNx059/OyKwLBg5nnJY9OSTR8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HQtYOM3l; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HQtYOM3l"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87bb66dd224so21700056d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 19:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761878032; x=1762482832; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ZYYmFeIdKjQ+/rwBQkpsYTKGGR6aXz28qE1jRlz+sQ=;
        b=HQtYOM3luRDD3W8GXDWz+IV0j9pJnAvUTkXUPKiciu6CmFSIpNDhqdZkDZ8hmHcxdi
         k/NmY6af2hYOaulSozSsTlIB3Nw7OGPoqYPEZ7YhFkx6EqLzQ/U9T2tbOzYWRFcOFMhB
         pG5G+0OjjdtbzFI41e3SkRgI2MJZhrvNdUHnXZMwD5JtgbnwU4XPLkLMu4bUNiBU3uig
         L46+oBSEqfczBiM//aO9R4C3GlO9dCg5pIoBGUW5N1s85nZMpngTNqR2ymRyv0ECT5N5
         /6EGZTiGyNaD5q5RZOpmjaHiNNjpqb91msYDvP7xz5N7nfzUHrQ3tHOg10VZ6MShmgm3
         2D0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761878032; x=1762482832;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ZYYmFeIdKjQ+/rwBQkpsYTKGGR6aXz28qE1jRlz+sQ=;
        b=GskGj9zII+kP1R12kPwNEG4oBXHYsc62YnNeX8tMMdssMRR1H+7EAsyeHGfzro5ssB
         Lh4EKTQ75Gzsgr2C5xJjlXFIxY8MeJLGAs90ZUCgDxbeu3bI+3Oy5IBh0f/FaM2XFBcS
         SECF87nHwiDC+AgaBew9ScMnOxu5AC+B8AL0rx7y9eT5kARblVU2193wtaOs9Cp28JWB
         BsVl+2TlC4/YK7cwDK+ujP8kzDJ0ecbfTKhhLcqZqk9SJa7EGRTp9/XnWFnBHO0IZuKv
         nrzjxPHEdCT1vYeSK3G37KiuSttIwLE0emN7oWsLUKGThswzA/gP9rnN224p3Z1LEifv
         btQw==
X-Forwarded-Encrypted: i=1; AJvYcCX6R5B2THYQR17NXcW3k/C4UZuFgTH4lYDeil5uFzoSWBvqCBmkmCvCQiWIowZ8do9agDHRnKSxxgdo@vger.kernel.org
X-Gm-Message-State: AOJu0YzwOvzZYFvWP7HXf+eH7KoQtpSqW3feMAojtJTF7Ryp/BOTMIPF
	WGOfVwd9MkoD3LNtFyiA2iOXN18edDhJSxfaiyksGDpImmPz6pklG9rAIRx8NB4TSVQFpQszIAq
	ytYfJth94xn+tJ4Y5E0vJmY7EH+GTGMY=
X-Gm-Gg: ASbGnctZcOLR0pRwM2yXmz9tECT4GWDaEMfC9mD1Ef1mdf19viFWQZyRlUYDkDSVkHk
	dlikKGm97CXl//tYjZipT0hpmxXVA9a+l2HFkybp5kE9o2qsHgKNvavz8mcG9bIBHbxO03Qebbm
	9p+nTo9YZPnT3eVIogcwXn2YyjnpzQVNRofKL5Li2a2YzHzGrTb5AG7kY0kcqgm4nUrqKSgi1RX
	noWKamPRdTcQZ764A0xUG9TlCawdRbDqsDFWrFm9LvbL9vGrkj2/dtg9DIggLTjbKUlCZvFQa2t
	wsGSRfHWgt+eUs6xjdwlZor9/e7lpTjZvK+S7F3viCjgDinmNKedpAFsO2Obzxmee0lUjBzgFlV
	4L9wdDsGw5tR8K8oQrkL28wk3tGTBmViedvtRtiRSbDYyGLwOtp5m7lL0LsjT3dwbEyWCf4tWNS
	Q=
X-Google-Smtp-Source: AGHT+IF6nxVrfPwv+AiV4li/d1NDoAttcBj14XoL0BKgK+gjHFUVpz16sul+DM5dMnmJkoecOCBRxUU3BB9mL4bodBE=
X-Received: by 2002:a05:6214:f62:b0:87c:a721:42ea with SMTP id
 6a1803df08f44-8802f48d7f2mr24076386d6.32.1761878031899; Thu, 30 Oct 2025
 19:33:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev>
 <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev> <CAH2r5mtHXDuKUSvZ5TZU1f6WnQaH5Dz59=z29ABJsOYmric+1Q@mail.gmail.com>
 <CAH2r5muwP4uyELKDNrRGU+8YgwNurb1+jQb+5CYOcU74LZhj3w@mail.gmail.com> <d1835c8a-f354-498f-a8c3-f43d7bb62548@linux.dev>
In-Reply-To: <d1835c8a-f354-498f-a8c3-f43d7bb62548@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Oct 2025 21:33:38 -0500
X-Gm-Features: AWmQ_bl7uQePSmynHAHTP_qkGgjDjrYM3EBURWhpYbmKTa5RWcQLl4EAx2PK1Qc
Message-ID: <CAH2r5mvyGVXgY4AhW0kRymz241+=-PkhcKNi5NoGwn8N_juDfQ@mail.gmail.com>
Subject: Re: [PATCH v4 15/24] smb: move FILE_SYSTEM_POSIX_INFO to common/smb1pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>, sfrench@samba.org, 
	linkinjeon@kernel.org, linkinjeon@samba.org, christophe.jaillet@wanadoo.fr, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes - agreed. Ralph could give more details on that

On Thu, Oct 30, 2025 at 9:32=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> This GitLab repository seems to be more up to date than the one on
> samba.org: https://git.samba.org/?p=3Dslow/smb3_posix_spec.git;a=3Dshortl=
og
>
> Thanks,
> ChenXiaoSong.
>
> =E5=9C=A8 2025/10/31 09:53, Steve French =E5=86=99=E9=81=93:
> > Sorry forgot to attach the link
> >
> > https://gitlab.com/samba-team/smb3-posix-spec
> >
> > On Thu, Oct 30, 2025 at 8:53=E2=80=AFPM Steve French <smfrench@gmail.co=
m> wrote:
> >>
> >> Ralph,
> >> Is this link current? or do you have the link to a more current
> >> version of the POSIX extensions documentation?
> >>
> >> On Thu, Oct 30, 2025 at 8:42=E2=80=AFPM ChenXiaoSong
> >> <chenxiaosong.chenxiaosong@linux.dev> wrote:
> >>>
> >>> Hi Namjae and Steve,
> >>>
> >>> I couldn=E2=80=99t find the definition of FILE_SYSTEM_POSIX_INFO in a=
ny of the
> >>> following MS documents:
> >>>
> >>>     - MS-FSCC:
> >>> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.c=
om%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
> >>>     - MS-CIFS:
> >>> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.c=
om%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
> >>>     - MS-SMB:
> >>> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.c=
om%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
> >>>     - MS-SMB2:
> >>> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.c=
om%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json
> >>>
> >>> Is this structure defined in other MS document?
> >>>
> >>> On 10/27/25 3:21 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> >>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>>>
> >>>> Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
> >>>> then move duplicate definitions to common header file.
> >>>>
> >>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >>>> ---
> >>>>    fs/smb/client/cifspdu.h    | 22 ----------------------
> >>>>    fs/smb/common/smb1pdu.h    | 23 +++++++++++++++++++++++
> >>>>    fs/smb/server/smb2pdu.c    |  4 ++--
> >>>>    fs/smb/server/smb_common.h | 23 -----------------------
> >>>>    4 files changed, 25 insertions(+), 47 deletions(-)
> >>>>
> >>>> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> >>>> index d106c6850807..55aaae6dbc86 100644
> >>>> --- a/fs/smb/client/cifspdu.h
> >>>> +++ b/fs/smb/client/cifspdu.h
> >>>> @@ -1875,28 +1875,6 @@ typedef struct {
> >>>>
> >>>>    #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for=
 new QFSInfo */
> >>>>
> >>>> -typedef struct {
> >>>> -     /* For undefined recommended transfer size return -1 in that f=
ield */
> >>>> -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on ot=
her os */
> >>>> -     __le32 BlockSize;
> >>>> -    /* The next three fields are in terms of the block size.
> >>>> -     (above). If block size is unknown, 4096 would be a
> >>>> -     reasonable block size for a server to report.
> >>>> -     Note that returning the blocks/blocksavail removes need
> >>>> -     to make a second call (to QFSInfo level 0x103 to get this info=
.
> >>>> -     UserBlockAvail is typically less than or equal to BlocksAvail,
> >>>> -     if no distinction is made return the same value in each */
> >>>> -     __le64 TotalBlocks;
> >>>> -     __le64 BlocksAvail;       /* bfree */
> >>>> -     __le64 UserBlocksAvail;   /* bavail */
> >>>> -    /* For undefined Node fields or FSID return -1 */
> >>>> -     __le64 TotalFileNodes;
> >>>> -     __le64 FreeFileNodes;
> >>>> -     __le64 FileSysIdentifier;   /* fsid */
> >>>> -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> >>>> -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> >>>> -} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
> >>>> -
> >>>>    /* DeviceType Flags */
> >>>>    #define FILE_DEVICE_CD_ROM              0x00000002
> >>>>    #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
> >>>> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> >>>> index 82331a8f70e8..38b9c091baab 100644
> >>>> --- a/fs/smb/common/smb1pdu.h
> >>>> +++ b/fs/smb/common/smb1pdu.h
> >>>> @@ -327,6 +327,29 @@ typedef struct {
> >>>>        __le32 BytesPerSector;
> >>>>    } __packed FILE_SYSTEM_INFO;        /* size info, level 0x103 */
> >>>>
> >>>> +typedef struct {
> >>>> +     /* For undefined recommended transfer size return -1 in that f=
ield */
> >>>> +     __le32 OptimalTransferSize;  /* bsize on some os, iosize on ot=
her os */
> >>>> +     __le32 BlockSize;
> >>>> +     /* The next three fields are in terms of the block size.
> >>>> +      * (above). If block size is unknown, 4096 would be a
> >>>> +      * reasonable block size for a server to report.
> >>>> +      * Note that returning the blocks/blocksavail removes need
> >>>> +      * to make a second call (to QFSInfo level 0x103 to get this i=
nfo.
> >>>> +      * UserBlockAvail is typically less than or equal to BlocksAva=
il,
> >>>> +      * if no distinction is made return the same value in each
> >>>> +      */
> >>>> +     __le64 TotalBlocks;
> >>>> +     __le64 BlocksAvail;       /* bfree */
> >>>> +     __le64 UserBlocksAvail;   /* bavail */
> >>>> +     /* For undefined Node fields or FSID return -1 */
> >>>> +     __le64 TotalFileNodes;
> >>>> +     __le64 FreeFileNodes;
> >>>> +     __le64 FileSysIdentifier;   /* fsid */
> >>>> +     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> >>>> +     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> >>>> +} __packed FILE_SYSTEM_POSIX_INFO;
> >>>> +
> >>>>    /* See MS-CIFS 2.2.8.2.5 */
> >>>>    typedef struct {
> >>>>        __le32 DeviceType;
> >>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> >>>> index 47fab72a3588..dc0f0ed4ccb6 100644
> >>>> --- a/fs/smb/server/smb2pdu.c
> >>>> +++ b/fs/smb/server/smb2pdu.c
> >>>> @@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct k=
smbd_work *work,
> >>>>        }
> >>>>        case FS_POSIX_INFORMATION:
> >>>>        {
> >>>> -             struct filesystem_posix_info *info;
> >>>> +             FILE_SYSTEM_POSIX_INFO *info;
> >>>>
> >>>>                if (!work->tcon->posix_extensions) {
> >>>>                        pr_err("client doesn't negotiate with SMB3.1.=
1 POSIX Extensions\n");
> >>>>                        path_put(&path);
> >>>>                        return -EOPNOTSUPP;
> >>>>                } else {
> >>>> -                     info =3D (struct filesystem_posix_info *)(rsp-=
>Buffer);
> >>>> +                     info =3D (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffe=
r);
> >>>>                        info->OptimalTransferSize =3D cpu_to_le32(stf=
s.f_bsize);
> >>>>                        info->BlockSize =3D cpu_to_le32(stfs.f_bsize)=
;
> >>>>                        info->TotalBlocks =3D cpu_to_le64(stfs.f_bloc=
ks);
> >>>> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> >>>> index 6141ca8f7e1c..61048568f4c7 100644
> >>>> --- a/fs/smb/server/smb_common.h
> >>>> +++ b/fs/smb/server/smb_common.h
> >>>> @@ -108,29 +108,6 @@ struct file_id_both_directory_info {
> >>>>        char FileName[];
> >>>>    } __packed;
> >>>>
> >>>> -struct filesystem_posix_info {
> >>>> -     /* For undefined recommended transfer size return -1 in that f=
ield */
> >>>> -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on ot=
her os */
> >>>> -     __le32 BlockSize;
> >>>> -     /* The next three fields are in terms of the block size.
> >>>> -      * (above). If block size is unknown, 4096 would be a
> >>>> -      * reasonable block size for a server to report.
> >>>> -      * Note that returning the blocks/blocksavail removes need
> >>>> -      * to make a second call (to QFSInfo level 0x103 to get this i=
nfo.
> >>>> -      * UserBlockAvail is typically less than or equal to BlocksAva=
il,
> >>>> -      * if no distinction is made return the same value in each
> >>>> -      */
> >>>> -     __le64 TotalBlocks;
> >>>> -     __le64 BlocksAvail;       /* bfree */
> >>>> -     __le64 UserBlocksAvail;   /* bavail */
> >>>> -     /* For undefined Node fields or FSID return -1 */
> >>>> -     __le64 TotalFileNodes;
> >>>> -     __le64 FreeFileNodes;
> >>>> -     __le64 FileSysIdentifier;   /* fsid */
> >>>> -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> >>>> -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> >>>> -} __packed;
> >>>> -
> >>>>    struct smb_version_ops {
> >>>>        u16 (*get_cmd_val)(struct ksmbd_work *swork);
> >>>>        int (*init_rsp_hdr)(struct ksmbd_work *swork);
> >>>
> >>
> >>
> >> --
> >> Thanks,
> >>
> >> Steve
> >
> >
> >
>


--=20
Thanks,

Steve

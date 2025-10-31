Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDC9208961
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 01:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761875599; cv=none; b=L66gzqUiXRClV/SUXU2TsBIIAR1i3ExpPW7Cx9Qgjb9JzWyxrci1SZT9MRdJ7kaONRVrSsCx284l2J9HqpB1FFhGjdJ4z39HchKrZyw0mqjRaZ0Aior84tQ6/3Z7pxiI1Pmkzq27P3oRsva4iH5nDJVC3aUgeB9mOlEx5eaBPSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761875599; c=relaxed/simple;
	bh=BndDZ3lGhVxrBWvZR+9y4LHlu8s5nq9Xy22dfRdzcqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vx46ts2WL2KzpQgQOfL3uF2hYhAGf4wqQN8F7DbGhBuOvvv8aUWpmV0wLSzkZShfTGoiWAjFOiFDFxfYooiKTNYYh2gt0AQEtEnFcDRIpwZc1eIrInQDQrK47muTc4qG4BDEVSYpAUTKNnu+Gd1jYsVf0uOUuAkxuqDG5uQ8t+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bvoeAXsx; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bvoeAXsx"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-880330ab54fso1951586d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 18:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761875596; x=1762480396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/USK4xlMFa4PneuHe9GpeYbrj+vpPqmzgo0m1/JhnSs=;
        b=bvoeAXsxLUJkkqrNK8+dXWCCPk3KX7b7BdTlJLusDylo/CP/dAwV4n2x2CMUKJYZnI
         2Gl3WKZQcFQq+mA9Ez2MKnJbT6OaA5MJLTrQeq3Ueb+FnUXt548LLe5pgmk0sOZNVIr/
         b64/C7F9TvJHoJP/vsRUWRXb5RpUaxzIOS5I1F2+Sg1CBqAYOumrUGw0pcQH7nLcSPhA
         QN828VGelOYgwnu0jjyxh5LXYvMQbL56encs3D628xrQS92aNtDlC20PMoVoqsHL2ZWK
         kTVcfeb//NJRTATOgxbTISt8h9SBJ4WNM4wNA1C5JRHexp2N1neP7miIgeKvSAwqGoSz
         997Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761875596; x=1762480396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/USK4xlMFa4PneuHe9GpeYbrj+vpPqmzgo0m1/JhnSs=;
        b=nbZUsAX4hrtFtMpjQh0rzMJzUyKRYgsSGAMy5x44XzfttjgIIDjLLczCgCikEZDeaR
         Mv5rXibwZ2F83zH9Eyfe2hb4o6ABqiXlj15HDsHKKF+JlhVMZV6w/qWsRJKjJ45Gnowm
         uWQGUeSYahT4WpV9ycczbDQXovaxGLy6rIOvAx5doXPujHJlYqR+Adu7WViclIbGWmCo
         xi+EVUTmuT5t/oMzf3g20aRvK2CaIIAerQZougAlfikbF6OsI6UWmO9UPiFw9p1l5F/k
         p4P3ISAmQxjV075wnHyQN2jxdqsjVx3yFk6xtRkdFWMvDGVJlT3Sh2t24edEFX16zSHi
         j3KA==
X-Forwarded-Encrypted: i=1; AJvYcCUVHAZhj8Jw3/0atutlU7SggdeTQh+k7QjrUlHM89M8EpQ1q7kwgi03RYaYF/r8BdA5X7609LZxpvAY@vger.kernel.org
X-Gm-Message-State: AOJu0YyO4RSeIpHfem9uLaOmp2LIGNIhXUZzWgPPJ/1XrMJZdBLtnkw2
	4y0AfKTX7GuTQ3jBaXzYMKyeluIpUkYVg07WwZeKKOMKwIBmmYqb2qdm0FoQVTYdJyoAHaul8Ro
	KE98K4PuBbivqe7DVEhnlcS0UuQnMPJSlVkw4
X-Gm-Gg: ASbGncsvDETgrEt2tcqIzWYgB9uW3SApyCqluLVBp/HIC4ubriIoL5JtVsLBCBelP3p
	tbV9tYUFlR8BWQeGnvAPTdniDASZePY8rWAgUphxajMVtfSCeMdxx2j3RjUdy7HVUK0tJx37iFs
	pazcEgkvHQwons3wK6nasEBL8xogGyzfbdFWjTGAMinT2IgmFTSAKi0XOycT4pP0XIqw9DFWrDf
	HksEG6FKtjuT/FO7hTLxyZssd5PmbFXchfsEfA2Y65mxnl3HsV88JbvEtDmzlNGUBzHOnHWWKPb
	48zunLkvdVZg0VVyRbMIMHSLqqPM2PFAH1mR3UtX2xPBg2wBlXhwJR3ay8P3KkZbk8udO2Pj3Rb
	gzgwCz2USuiBJT+8ItD0bFhsWyN3fZ+OgKA8d4k5m48BhcjLeE0V7Qq1eMne3sXJt3JRC1MjEEj
	o=
X-Google-Smtp-Source: AGHT+IGUPbJlT6n9OcI1T7MVl1PO5uZWN6cMli+VC4XHgHUJAoY3hcSblNlspvhem/YCCbO6HP7qRmcFqDzP3q6QHoQ=
X-Received: by 2002:ad4:5c85:0:b0:87d:cb55:823b with SMTP id
 6a1803df08f44-8802f4cd30bmr22996256d6.51.1761875596361; Thu, 30 Oct 2025
 18:53:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev> <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev>
In-Reply-To: <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Oct 2025 20:53:04 -0500
X-Gm-Features: AWmQ_bnf7-vHG0UtdbX-KJXa4BIuLJy6jQyI41kPToOgTKwSd6ZWi6fOCIZCYs0
Message-ID: <CAH2r5mtHXDuKUSvZ5TZU1f6WnQaH5Dz59=z29ABJsOYmric+1Q@mail.gmail.com>
Subject: Re: [PATCH v4 15/24] smb: move FILE_SYSTEM_POSIX_INFO to common/smb1pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Cc: sfrench@samba.org, linkinjeon@kernel.org, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Ralph,
Is this link current? or do you have the link to a more current
version of the POSIX extensions documentation?

On Thu, Oct 30, 2025 at 8:42=E2=80=AFPM ChenXiaoSong
<chenxiaosong.chenxiaosong@linux.dev> wrote:
>
> Hi Namjae and Steve,
>
> I couldn=E2=80=99t find the definition of FILE_SYSTEM_POSIX_INFO in any o=
f the
> following MS documents:
>
>    - MS-FSCC:
> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com%2=
Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
>    - MS-CIFS:
> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com%2=
Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
>    - MS-SMB:
> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com%2=
Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
>    - MS-SMB2:
> https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com%2=
Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json
>
> Is this structure defined in other MS document?
>
> On 10/27/25 3:21 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> >
> > Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
> > then move duplicate definitions to common header file.
> >
> > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > ---
> >   fs/smb/client/cifspdu.h    | 22 ----------------------
> >   fs/smb/common/smb1pdu.h    | 23 +++++++++++++++++++++++
> >   fs/smb/server/smb2pdu.c    |  4 ++--
> >   fs/smb/server/smb_common.h | 23 -----------------------
> >   4 files changed, 25 insertions(+), 47 deletions(-)
> >
> > diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> > index d106c6850807..55aaae6dbc86 100644
> > --- a/fs/smb/client/cifspdu.h
> > +++ b/fs/smb/client/cifspdu.h
> > @@ -1875,28 +1875,6 @@ typedef struct {
> >
> >   #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new=
 QFSInfo */
> >
> > -typedef struct {
> > -     /* For undefined recommended transfer size return -1 in that fiel=
d */
> > -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other=
 os */
> > -     __le32 BlockSize;
> > -    /* The next three fields are in terms of the block size.
> > -     (above). If block size is unknown, 4096 would be a
> > -     reasonable block size for a server to report.
> > -     Note that returning the blocks/blocksavail removes need
> > -     to make a second call (to QFSInfo level 0x103 to get this info.
> > -     UserBlockAvail is typically less than or equal to BlocksAvail,
> > -     if no distinction is made return the same value in each */
> > -     __le64 TotalBlocks;
> > -     __le64 BlocksAvail;       /* bfree */
> > -     __le64 UserBlocksAvail;   /* bavail */
> > -    /* For undefined Node fields or FSID return -1 */
> > -     __le64 TotalFileNodes;
> > -     __le64 FreeFileNodes;
> > -     __le64 FileSysIdentifier;   /* fsid */
> > -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > -} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
> > -
> >   /* DeviceType Flags */
> >   #define FILE_DEVICE_CD_ROM              0x00000002
> >   #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
> > diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> > index 82331a8f70e8..38b9c091baab 100644
> > --- a/fs/smb/common/smb1pdu.h
> > +++ b/fs/smb/common/smb1pdu.h
> > @@ -327,6 +327,29 @@ typedef struct {
> >       __le32 BytesPerSector;
> >   } __packed FILE_SYSTEM_INFO;        /* size info, level 0x103 */
> >
> > +typedef struct {
> > +     /* For undefined recommended transfer size return -1 in that fiel=
d */
> > +     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other=
 os */
> > +     __le32 BlockSize;
> > +     /* The next three fields are in terms of the block size.
> > +      * (above). If block size is unknown, 4096 would be a
> > +      * reasonable block size for a server to report.
> > +      * Note that returning the blocks/blocksavail removes need
> > +      * to make a second call (to QFSInfo level 0x103 to get this info=
.
> > +      * UserBlockAvail is typically less than or equal to BlocksAvail,
> > +      * if no distinction is made return the same value in each
> > +      */
> > +     __le64 TotalBlocks;
> > +     __le64 BlocksAvail;       /* bfree */
> > +     __le64 UserBlocksAvail;   /* bavail */
> > +     /* For undefined Node fields or FSID return -1 */
> > +     __le64 TotalFileNodes;
> > +     __le64 FreeFileNodes;
> > +     __le64 FileSysIdentifier;   /* fsid */
> > +     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > +     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > +} __packed FILE_SYSTEM_POSIX_INFO;
> > +
> >   /* See MS-CIFS 2.2.8.2.5 */
> >   typedef struct {
> >       __le32 DeviceType;
> > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > index 47fab72a3588..dc0f0ed4ccb6 100644
> > --- a/fs/smb/server/smb2pdu.c
> > +++ b/fs/smb/server/smb2pdu.c
> > @@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct ksmb=
d_work *work,
> >       }
> >       case FS_POSIX_INFORMATION:
> >       {
> > -             struct filesystem_posix_info *info;
> > +             FILE_SYSTEM_POSIX_INFO *info;
> >
> >               if (!work->tcon->posix_extensions) {
> >                       pr_err("client doesn't negotiate with SMB3.1.1 PO=
SIX Extensions\n");
> >                       path_put(&path);
> >                       return -EOPNOTSUPP;
> >               } else {
> > -                     info =3D (struct filesystem_posix_info *)(rsp->Bu=
ffer);
> > +                     info =3D (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
> >                       info->OptimalTransferSize =3D cpu_to_le32(stfs.f_=
bsize);
> >                       info->BlockSize =3D cpu_to_le32(stfs.f_bsize);
> >                       info->TotalBlocks =3D cpu_to_le64(stfs.f_blocks);
> > diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> > index 6141ca8f7e1c..61048568f4c7 100644
> > --- a/fs/smb/server/smb_common.h
> > +++ b/fs/smb/server/smb_common.h
> > @@ -108,29 +108,6 @@ struct file_id_both_directory_info {
> >       char FileName[];
> >   } __packed;
> >
> > -struct filesystem_posix_info {
> > -     /* For undefined recommended transfer size return -1 in that fiel=
d */
> > -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other=
 os */
> > -     __le32 BlockSize;
> > -     /* The next three fields are in terms of the block size.
> > -      * (above). If block size is unknown, 4096 would be a
> > -      * reasonable block size for a server to report.
> > -      * Note that returning the blocks/blocksavail removes need
> > -      * to make a second call (to QFSInfo level 0x103 to get this info=
.
> > -      * UserBlockAvail is typically less than or equal to BlocksAvail,
> > -      * if no distinction is made return the same value in each
> > -      */
> > -     __le64 TotalBlocks;
> > -     __le64 BlocksAvail;       /* bfree */
> > -     __le64 UserBlocksAvail;   /* bavail */
> > -     /* For undefined Node fields or FSID return -1 */
> > -     __le64 TotalFileNodes;
> > -     __le64 FreeFileNodes;
> > -     __le64 FileSysIdentifier;   /* fsid */
> > -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > -} __packed;
> > -
> >   struct smb_version_ops {
> >       u16 (*get_cmd_val)(struct ksmbd_work *swork);
> >       int (*init_rsp_hdr)(struct ksmbd_work *swork);
>


--=20
Thanks,

Steve

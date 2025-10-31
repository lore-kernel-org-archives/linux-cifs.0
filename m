Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787B41494A8
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 01:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761875630; cv=none; b=KBpmcI8ylDSbe6KXGZaoldw702JMHjRNI4/fzBHCbCHJNNZf/6Jc0z0AMAwEmDErDDPCErrAm/W5cx2Zd3fd5KLNVfxpMu0fPDiH/vgwSHbWmKeIORfLsatn+29aCdqgjmzanO/zUnj57uXWJ+LQ+9sROHMAmMLl2+jZqu/4Yqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761875630; c=relaxed/simple;
	bh=TkEQdgncQmkZUdZTHYsv8Q32LmvRLVsL4ht2RzwEteA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1MnW9dma9MkgkVDRnI189srNGyEtpHPJmjcKi39FizHcU3MX0KqM8k9f1oJVBFBqaL3E27oZqj3Jd3t1aLQbfezKUYlA+f94qw3xZubhbCmbn902GFKavw7jD0DOD7XjNqJjLjWcMbsf5YTWoCz69RSzhYlRv553iHDVuucu6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dr05KAS4; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dr05KAS4"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-88021e1abc4so11957296d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761875627; x=1762480427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iu/I3TTkFlE7Ln/q4osrgcC6+jKW4F1NfjqmlswaX70=;
        b=Dr05KAS4yU69+ks94w38f3MDAFKy2GufNt81TISftPKDg3yRetqO20raMNPRxG0FeW
         sj7JdLrnTyhIUBHz1av0sae05/+VPSLveCujwwR83vs6nGuDYMtWAmgvrvTxuQml9Mqd
         iqsDT4JWsM3WxUi+8+Khu0Rvh1TuIgIRnBue1bayWvsnBbTz4DyehXNX3PpoQW54sX14
         VFm6lZ3OW5U8+rQQelbVmPzTM5cffYkrGih/mmb7ZdIyLYL9yQDBqw7wKpsOVFBN9eYE
         7/lmnerJpxw2HXQZrkxKRBABXyEc0/xTjma1HXVsBYsqyChmOhFlBD5iP5n5XK0IaI0w
         BjBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761875627; x=1762480427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iu/I3TTkFlE7Ln/q4osrgcC6+jKW4F1NfjqmlswaX70=;
        b=G7bwZNO8cs8vbbJBrVCOulosRsK7zMP5pdGHUOjGqKIdGuYyHmzVjEVgy4I/gmm6nE
         pILkI51OrxJgVdsXNQufkAASeGmpc5NcRebRB0Xl1kH9mIfpsvQbhlDyi4yP2bqcILNf
         DnczNnUY6FYb1r7vNOL02EuTAT2cJWFSTYKzsoCzwmT3A6sr0Cd26R3AYokaEiqw9Idf
         FhTGw7sXVi/9lCNSDVBo4Y/qLzp5sIJzilr1Z6rDql0cs9K60XCLSoynhANi43/DM+iD
         ZxChyM+mPCYW7u4J00He/0BeQHUP7ApYVK1JfNFXiV5tahsqhSSh9LQuqN0Fg7RH4nj3
         UzLA==
X-Forwarded-Encrypted: i=1; AJvYcCU69IfzbUY3zsR6okqUJm3z6vvsGMXn2hqEVC0q/02jqaEXohWDGHAOEXyVFBNa3GbCE6tnbwRecKCc@vger.kernel.org
X-Gm-Message-State: AOJu0YzHZAPYCRlJHOXUcp2e1vQx1A3lQCFDQWz87CqYo3Oej/pWgpjP
	hGBZPRbwMVYZJecU1xmMB9oC2Gui/8tm2SOj58pI+i5iK6wJCTkxmp974TQAzg456Uc5tA4qjc6
	dLQGm/Rld3KRSKe/26mK83ymjz6hLvgM=
X-Gm-Gg: ASbGncvwQ+B3QQhlvTJBvk6eg97gfwjKrWwJB/N2tQ0ywseK/QvZJ4nW45zvbamoPBs
	ns7QbqkTgU9TBbm6IyszbN04hXqfLz8nWaEZulEcfr/YgKn/cqvTebKpbZQJ8hiISy4rAE1E4DJ
	w8ajHG73ZcZOzKK8APctlrnIPJtKI4YbwY8klxS+0kOXG8SIMESksubEJBkw4YIGWtBO9D6kyA5
	V1bRP0ARTBSgSAM9IOumfdo9flSD06VDIFk9jXxGfQmJKuW0D1wIKOxPbR2cBfFj5vbuSRGcSMg
	YmvlyMMRDrWfZ5L+m4/LuMi/tazq6t6GWMJDNn7Nxs9PO1hn7xpg1oa9Wzv9Tbh1BX5E6HMMcV1
	1gUafSNPYepyls4q/tvkb7TdDvRmwUNt0M12qoDND+TaUm9S1M72oe/yxwIjHjdtyIFJcKdAtGP
	c=
X-Google-Smtp-Source: AGHT+IG5pz3OzOV3AfykrpxWJkruh3Ti/8oCPc/nhWC4s4ja6Tx8ik9tDtB3p4StJ521sZet60OOtjsBY5QWeHuk8AY=
X-Received: by 2002:a05:6214:19e7:b0:880:2248:3a09 with SMTP id
 6a1803df08f44-8802f2f6ae0mr21289276d6.22.1761875627264; Thu, 30 Oct 2025
 18:53:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev>
 <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev> <CAH2r5mtHXDuKUSvZ5TZU1f6WnQaH5Dz59=z29ABJsOYmric+1Q@mail.gmail.com>
In-Reply-To: <CAH2r5mtHXDuKUSvZ5TZU1f6WnQaH5Dz59=z29ABJsOYmric+1Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 30 Oct 2025 20:53:34 -0500
X-Gm-Features: AWmQ_bn8ZtwkKQDRKtPaCIoFD8q7imAFDtOKuBdMxk4l8Sbiu0PLwLreE1eYthU
Message-ID: <CAH2r5muwP4uyELKDNrRGU+8YgwNurb1+jQb+5CYOcU74LZhj3w@mail.gmail.com>
Subject: Re: [PATCH v4 15/24] smb: move FILE_SYSTEM_POSIX_INFO to common/smb1pdu.h
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>, =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>
Cc: sfrench@samba.org, linkinjeon@kernel.org, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sorry forgot to attach the link

https://gitlab.com/samba-team/smb3-posix-spec

On Thu, Oct 30, 2025 at 8:53=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Ralph,
> Is this link current? or do you have the link to a more current
> version of the POSIX extensions documentation?
>
> On Thu, Oct 30, 2025 at 8:42=E2=80=AFPM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
> >
> > Hi Namjae and Steve,
> >
> > I couldn=E2=80=99t find the definition of FILE_SYSTEM_POSIX_INFO in any=
 of the
> > following MS documents:
> >
> >    - MS-FSCC:
> > https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com=
%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
> >    - MS-CIFS:
> > https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com=
%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
> >    - MS-SMB:
> > https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com=
%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
> >    - MS-SMB2:
> > https://learn.microsoft.com/pdf?url=3Dhttps%3A%2F%2Flearn.microsoft.com=
%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json
> >
> > Is this structure defined in other MS document?
> >
> > On 10/27/25 3:21 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> > > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > >
> > > Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
> > > then move duplicate definitions to common header file.
> > >
> > > Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > > ---
> > >   fs/smb/client/cifspdu.h    | 22 ----------------------
> > >   fs/smb/common/smb1pdu.h    | 23 +++++++++++++++++++++++
> > >   fs/smb/server/smb2pdu.c    |  4 ++--
> > >   fs/smb/server/smb_common.h | 23 -----------------------
> > >   4 files changed, 25 insertions(+), 47 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> > > index d106c6850807..55aaae6dbc86 100644
> > > --- a/fs/smb/client/cifspdu.h
> > > +++ b/fs/smb/client/cifspdu.h
> > > @@ -1875,28 +1875,6 @@ typedef struct {
> > >
> > >   #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for n=
ew QFSInfo */
> > >
> > > -typedef struct {
> > > -     /* For undefined recommended transfer size return -1 in that fi=
eld */
> > > -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on oth=
er os */
> > > -     __le32 BlockSize;
> > > -    /* The next three fields are in terms of the block size.
> > > -     (above). If block size is unknown, 4096 would be a
> > > -     reasonable block size for a server to report.
> > > -     Note that returning the blocks/blocksavail removes need
> > > -     to make a second call (to QFSInfo level 0x103 to get this info.
> > > -     UserBlockAvail is typically less than or equal to BlocksAvail,
> > > -     if no distinction is made return the same value in each */
> > > -     __le64 TotalBlocks;
> > > -     __le64 BlocksAvail;       /* bfree */
> > > -     __le64 UserBlocksAvail;   /* bavail */
> > > -    /* For undefined Node fields or FSID return -1 */
> > > -     __le64 TotalFileNodes;
> > > -     __le64 FreeFileNodes;
> > > -     __le64 FileSysIdentifier;   /* fsid */
> > > -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > > -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > > -} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
> > > -
> > >   /* DeviceType Flags */
> > >   #define FILE_DEVICE_CD_ROM              0x00000002
> > >   #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
> > > diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> > > index 82331a8f70e8..38b9c091baab 100644
> > > --- a/fs/smb/common/smb1pdu.h
> > > +++ b/fs/smb/common/smb1pdu.h
> > > @@ -327,6 +327,29 @@ typedef struct {
> > >       __le32 BytesPerSector;
> > >   } __packed FILE_SYSTEM_INFO;        /* size info, level 0x103 */
> > >
> > > +typedef struct {
> > > +     /* For undefined recommended transfer size return -1 in that fi=
eld */
> > > +     __le32 OptimalTransferSize;  /* bsize on some os, iosize on oth=
er os */
> > > +     __le32 BlockSize;
> > > +     /* The next three fields are in terms of the block size.
> > > +      * (above). If block size is unknown, 4096 would be a
> > > +      * reasonable block size for a server to report.
> > > +      * Note that returning the blocks/blocksavail removes need
> > > +      * to make a second call (to QFSInfo level 0x103 to get this in=
fo.
> > > +      * UserBlockAvail is typically less than or equal to BlocksAvai=
l,
> > > +      * if no distinction is made return the same value in each
> > > +      */
> > > +     __le64 TotalBlocks;
> > > +     __le64 BlocksAvail;       /* bfree */
> > > +     __le64 UserBlocksAvail;   /* bavail */
> > > +     /* For undefined Node fields or FSID return -1 */
> > > +     __le64 TotalFileNodes;
> > > +     __le64 FreeFileNodes;
> > > +     __le64 FileSysIdentifier;   /* fsid */
> > > +     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > > +     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > > +} __packed FILE_SYSTEM_POSIX_INFO;
> > > +
> > >   /* See MS-CIFS 2.2.8.2.5 */
> > >   typedef struct {
> > >       __le32 DeviceType;
> > > diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> > > index 47fab72a3588..dc0f0ed4ccb6 100644
> > > --- a/fs/smb/server/smb2pdu.c
> > > +++ b/fs/smb/server/smb2pdu.c
> > > @@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct ks=
mbd_work *work,
> > >       }
> > >       case FS_POSIX_INFORMATION:
> > >       {
> > > -             struct filesystem_posix_info *info;
> > > +             FILE_SYSTEM_POSIX_INFO *info;
> > >
> > >               if (!work->tcon->posix_extensions) {
> > >                       pr_err("client doesn't negotiate with SMB3.1.1 =
POSIX Extensions\n");
> > >                       path_put(&path);
> > >                       return -EOPNOTSUPP;
> > >               } else {
> > > -                     info =3D (struct filesystem_posix_info *)(rsp->=
Buffer);
> > > +                     info =3D (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer=
);
> > >                       info->OptimalTransferSize =3D cpu_to_le32(stfs.=
f_bsize);
> > >                       info->BlockSize =3D cpu_to_le32(stfs.f_bsize);
> > >                       info->TotalBlocks =3D cpu_to_le64(stfs.f_blocks=
);
> > > diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> > > index 6141ca8f7e1c..61048568f4c7 100644
> > > --- a/fs/smb/server/smb_common.h
> > > +++ b/fs/smb/server/smb_common.h
> > > @@ -108,29 +108,6 @@ struct file_id_both_directory_info {
> > >       char FileName[];
> > >   } __packed;
> > >
> > > -struct filesystem_posix_info {
> > > -     /* For undefined recommended transfer size return -1 in that fi=
eld */
> > > -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on oth=
er os */
> > > -     __le32 BlockSize;
> > > -     /* The next three fields are in terms of the block size.
> > > -      * (above). If block size is unknown, 4096 would be a
> > > -      * reasonable block size for a server to report.
> > > -      * Note that returning the blocks/blocksavail removes need
> > > -      * to make a second call (to QFSInfo level 0x103 to get this in=
fo.
> > > -      * UserBlockAvail is typically less than or equal to BlocksAvai=
l,
> > > -      * if no distinction is made return the same value in each
> > > -      */
> > > -     __le64 TotalBlocks;
> > > -     __le64 BlocksAvail;       /* bfree */
> > > -     __le64 UserBlocksAvail;   /* bavail */
> > > -     /* For undefined Node fields or FSID return -1 */
> > > -     __le64 TotalFileNodes;
> > > -     __le64 FreeFileNodes;
> > > -     __le64 FileSysIdentifier;   /* fsid */
> > > -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> > > -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> > > -} __packed;
> > > -
> > >   struct smb_version_ops {
> > >       u16 (*get_cmd_val)(struct ksmbd_work *swork);
> > >       int (*init_rsp_hdr)(struct ksmbd_work *swork);
> >
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

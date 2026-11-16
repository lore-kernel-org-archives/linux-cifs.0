Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794862438;
	b=mJaGh5Cg4UGOACY1v2WwOFRYZE5Uyevfj/GRKiXjA/DfSEmQt+ZP2mcx6s4obfPicQpu
	 k3hbt0YLP580Ml1IZ3IvuT/CeVJ8UezIfceHmChPMKnBCLQqMWxzZzWxQ+dIr9AJo33/I
	 DhkJsQciAN88Vlf2LXRGRbyTxaTqBnc72uJS6lOIU5kExC7WAZCsc/Yaz4OCrBDvxaxa3
	 FEGJ8qcIXfXCZVSRvp9B/UtNMWBVbKcqWdObSHJ5yGS5+jHZOBJLoIE1E2xyyS56e5YX5
	 T/5KzZf6/7dLepyPIQzynfarkhZ8yXmKMW8JJnvVeVL6UZSj301R/8GvDMKqELyuhRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794862438;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=tzdH03fxvdHG/WP+ISnD29s1t0jRH5uKJ+YnULP8Tr0=;
	b=yj9tuuspJve9ppG5g1LoMEGQQvl+G2YpGKn6Z88sHScOTzCENX0gjuTj6A5bmfW3D6dq
	 3yTjklff840Vqer2FiYSICfodYX/zFiT/FJVZj4dNROlsJZ+vqXUZcxCqmz6zTKRMlorz
	 YZPvnpngw9EY+E8WSW9PxuBr3Oc53HK2z0mbKH3zGurCPRGiWXVmOhcoh2EKoRjTk7dx1
	 eAccZLMAVH3qWvSupnYVGm95V1UzjMwoz+SILk65sEzo4X5WzQB3K8ERtxZaZPay5O/XT
	 uh6+PKsj8YtViLJdPIQAYmwCY2RiqK+JPcpqoA4sSFaQ8ujFkiEw8momPSdjYooP0aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5sm9T50;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A1E606A8AC
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 20:53:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3A1E606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L5sm9T50
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso32616365e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 12:53:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794862436; x=1795467236; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tzdH03fxvdHG/WP+ISnD29s1t0jRH5uKJ+YnULP8Tr0=;
        b=L5sm9T50a7sqt8w6n5QqMCx2guZ/ceCCaSawY3J0jxqzahZ/LN4bt26KoGHp/uxFmk
         WolNlyKBnyZ1ec/7ZBJ64TpLAMa5GpOCqE5CcwXsF6xR2eT/T77xWEVoGtvYUuScpPgN
         oz4iIqpqxQDYdqVGkZ6S56sYlTHUsvde9FjQULBdQwu+w/8a71UaoF3qQ3EF1S6gzVuf
         dgE0P/WOfZoYnPuKsQQ5Jt//NJN4mC5iRbQCozXEE4yB0v0DbLjq7YCnC1TvPdkKeY89
         THDwEB3iExsY9Ok3aiSiUawJk00aXtPKjGcx+g+wp9cCLgujF5NkMGxtzDgjbUuRcBOa
         A6iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794862436; x=1795467236;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=tzdH03fxvdHG/WP+ISnD29s1t0jRH5uKJ+YnULP8Tr0=;
        b=PDMZdTvmZ9j5x4eRYyOgh4FH9W0h264tkkPueD6O21Iop407I9CSr7QiMCMtbuRKSU
         iNQfydFAQgn05tmf4CaWcm4dHiPY/SZARVIRK6VpnGSmKUDfCh44MHeuJ/j5kK8Lb6UB
         ZXZPvOMHJ73/ypCZkVayd8adZquBBgcnJxVr+zk2E9EqH2kYSvRFfmHJLK5l07cYu3qz
         Lq/ZaZQujS6M/R/eAqPhVXJtOW0uT3z3sXEY+xXqY41B5JDw5wB7pN0oZHQ7Nq+d9gBQ
         4iTztpBuHnwbdm7kfjNslVJOXZfBIQD3GGY9jW+DwN0lFgk4NOYtDCzo7cYcv65YTwVm
         rzdw==
X-Forwarded-Encrypted: i=1; AL+hErECVQ0h9vBUj59FoIGfQnE73IUEqaDBi1PfKq4znGcHnxKG3A8AUBDXWs5ATJbKGDaKZb+hEjaeaQCu@vger.kernel.org
X-Gm-Message-State: APuU4Z8jU0JSrQMhhebfd2tHen+DB3qcaT57NmvFDU/+/cyGOeEPf3U8
	2NE8fMx/NdHGmzk6qFrCXdArh4ZoVWRpufL78mKJjObmPqK+I8r+FMWP
X-Gm-Gg: AYBFou0lfo9lNh3QtCySp8UKKxRxVlzI6KHzD0/k1e8pP2igy5oJC9u+6Rqf+yr/WLt
	pEniBDWrX2uiVtOahcpSYmjx8uG2LuXKl95ebSo9ux/+Kr8j2wUI7//jMjjobEvckvYsJxNi/KQ
	o4HAieZnnsJD8rihK5caVIwuza06T2xWRqRzzNqYOuhB/7wk0DeoJbZfDzlif+Rpps1l/Jg4fe1
	fq4KG169FM+cZx6gl7duJY7tEHF0WVdqJNTz0tL/nwbFGsxocntNWgEtTt3GS1SEgnL/czRTUDK
	muDSp7efHJjUYx+wSNmNYq61DDJ2QLFyISRqkB8Yd5ttKdWfKuYryNyGL0CYfAoMDIW4L/k9EC+
	XpIyIPPEs9XAGC4ao7HRhhKYTmOWlmMpbdM6OWezCHkeCYp2iNDDLPdVYGQ2JjYObT0VVEvtlWJ
	bBowxhMnYXwPV0I8+x4zig1VwD4TMlFI2RYyjLaJN+vq8nYT5iqV6pXZIDntBfAMl07pye526q2
	ReyykG9VsYiwo4+plw4tGCQX1wDTIy0AiSpZpRK9frqS6Pp6gxeJCxqQmnKJuqP6Brw0kSrEGlT
	SrXsgfNcSOl1dhXHxqAKni50iw==
X-Received: by 2002:a05:600c:3b2a:b0:4a8:9a2f:d27 with SMTP id 5b1f17b1804b1-4bb55aabdf9mr263187925e9.25.1794862436065;
        Mon, 16 Nov 2026 12:53:56 -0800 (PST)
Received: from localhost ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c5d22394esm24799165f8f.3.2026.11.16.12.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 12:53:55 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=37fc961d2ca56be80f03ddce209a59446815f2f70d142ce639c6d949d73f;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Mon, 16 Nov 2026 21:53:49 +0100
Message-Id: <DMWXMP61YXEH.1W32ZFF7A7Y5H@gmail.com>
Cc: "David Sterba" <dsterba@suse.com>, "Namjae Jeon"
 <linkinjeon@kernel.org>, "Sungjong Seo" <sj1557.seo@samsung.com>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner"
 <brauner@kernel.org>, "Trond Myklebust" <trondmy@kernel.org>, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Jeff Layton"
 <jlayton@kernel.org>, "Konstantin Komarov"
 <almaz.alexandrovich@paragon-software.com>, "Paulo Alcantara"
 <pc@manguebit.org>, "Chris Mason" <mason@kernel.org>, "Yuezhang Mo"
 <yuezhang.mo@sony.com>, "Jan Kara" <jack@suse.cz>, "NeilBrown"
 <neil@brown.name>, "Olga Kornievskaia" <okorniev@redhat.com>, "Dai Ngo"
 <Dai.Ngo@oracle.com>, "Tom Talpey" <tom@talpey.com>, "Ronnie Sahlberg"
 <ronniesahlberg@gmail.com>, "Shyam Prasad N" <sprasad@microsoft.com>,
 "Bharath SM" <bharathsm@microsoft.com>, "Sergey Senozhatsky"
 <senozhatsky@chromium.org>, "ChenXiaoSong" <chenxiaosong@chenxiaosong.com>,
 "Darrick J . Wong" <djwong@kernel.org>, "Sean Smith"
 <defendthedisabled@gmail.com>, "Andrey Albershteyn" <aalbersh@kernel.org>,
 "Pedro Falcato" <pfalcato@suse.de>, =?utf-8?q?Pali_Roh=C3=A1r?=
 <pali@kernel.org>, <linux-btrfs@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
 <exfat@lists.linux.dev>, <ntfs3@lists.linux.dev>,
 <linux-cifs@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
 <linux-api@vger.kernel.org>
Subject: Re: [RFC PATCH v4 01/10] vfs: add provenance time (ptime)
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <20261115180343.576773-1-koray.fra@gmail.com>
 <20261115180343.576773-2-koray.fra@gmail.com>
 <CAOQ4uxi+50NU8qzg+Owvr8gFZ4vYF5FqWg4Hr9vB6ONUpPsFwg@mail.gmail.com>
In-Reply-To: <CAOQ4uxi+50NU8qzg+Owvr8gFZ4vYF5FqWg4Hr9vB6ONUpPsFwg@mail.gmail.com>

--37fc961d2ca56be80f03ddce209a59446815f2f70d142ce639c6d949d73f
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Mon Nov 16, 2026 at 9:10 PM CET, Amir Goldstein wrote:
> On Sun, Nov 15, 2026 at 7:04=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>>
>> Add provenance time (ptime), indicating the time when a file or
>> directory was created. This is user-settable via file_setattr() and
>> retrievable via statx(2) (using STATX_PTIME) or file_getattr().
>>
>> The semantics of when to preserve this new timestamp are the same as
>> mtime, the idea being that there is a correspondence like this:
>>
>> ctime <-> btime
>> mtime <-> ptime
>>
>> so every operation (copying, moving, ...) that currently preserves mtime
>> should also preserve ptime.
>>
>> Also add fa_xflags_mask to struct file_attr (and equivalent
>
> That is a very big "Also" part
> This is a significant UAPI change that needs to be delivered and
> explained with a patch on its own.

Right, that definitely makes more sense, I didn't think of that lol.

>> fsx_xflags_mask to struct file_kattr) to let the filesystems advertise
>> their support for specific xflags and users advertise what they want to
>> change, behaving like statx.stx_attributes_mask:
>> - on GET (file_getattr): each filesystem fills the mask according to
>>   their supported xflags, e.g. FS_XFLAG_PTIME or FS_XFLAG_COWEXTSIZE,
>>   and provides the values in the corresponding struct fields;
>> - on SET (file_setattr): userspace fills the mask according to which
>>   xflags it wants to change, VFS validates this and preserves xflags
>>   that were not specified in the mask;
>> - if xflags_mask =3D=3D 0, use legacy full-struct replacement to keep
>>   compatibility with older programs.
>>
>> Furthermore, in order to avoid the legacy FS_IOC_FSSETXATTR accepting
>> FS_XFLAG_PTIME, add an FS_FILE_ATTR_XFLAGS_MASK mask to support new
>> xflags and use it in fileattr_to_file_attr()/file_attr_to_fileattr() to
>> validate that the xflags passed in xflags and xflags_mask fields are
>> valid.
>>
>> Finally, add the missing FS_XFLAG_PROJID flag, to allow userspace to set
>> the projid using file_[sg]etattr().
>
> This part also belongs with the xflags_mask patch

Ok.

>>
>> [ This is a re-implementation of the initial patch[1] by Sean Smith
>>   <defendthedisabled@gmail.com>, following the advice[2] from Darrick J.
>>   Wong <djwong@kernel.org> of using file_setattr() instead of updating
>>   utimensat() ]
>>
>> [1]: https://lore.kernel.org/20260405195007.1306-2-DefendTheDisabled@gma=
il.com
>> [2]: https://lore.kernel.org/20260407014129.GC6192@frogsfrogsfrogs
>>
>> Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.4.7
>> Signed-off-by: koraynilay <koray.fra@gmail.com>
>> ---
>>  fs/file_attr.c            | 75 +++++++++++++++++++++++++++++++++++++--
>>  fs/stat.c                 |  2 ++
>>  include/linux/fileattr.h  |  6 ++++
>>  include/linux/stat.h      |  1 +
>>  include/uapi/linux/fs.h   |  9 ++++-
>>  include/uapi/linux/stat.h |  7 +++-
>>  6 files changed, 95 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/file_attr.c b/fs/file_attr.c
>> index 833e03810b24..12610fb6a751 100644
>> --- a/fs/file_attr.c
>> +++ b/fs/file_attr.c
>> @@ -102,14 +102,23 @@ EXPORT_SYMBOL(vfs_fileattr_get);
>>  static void fileattr_to_file_attr(const struct file_kattr *fa,
>>                                   struct file_attr *fattr)
>>  {
>> -       __u32 mask =3D FS_XFLAGS_MASK;
>> +       /*
>> +        * fsx_xflags_mask contains only flags added after the
>> +        * file_[gs]etattr() API, so we need to tell userspace the files=
ystem
>> +        * actually supports all legacy and new advertised flags
>> +        */
>> +       __u32 mask =3D (FS_XFLAGS_MASK | fa->fsx_xflags_mask) &
>> +                    FS_FILE_ATTR_XFLAGS_MASK;
>>
>>         memset(fattr, 0, sizeof(struct file_attr));
>>         fattr->fa_xflags =3D fa->fsx_xflags & mask;
>> +       fattr->fa_xflags_mask =3D mask;
>>         fattr->fa_extsize =3D fa->fsx_extsize;
>>         fattr->fa_nextents =3D fa->fsx_nextents;
>>         fattr->fa_projid =3D fa->fsx_projid;
>>         fattr->fa_cowextsize =3D fa->fsx_cowextsize;
>> +       fattr->fa_ptime_sec =3D fa->fsx_ptime.tv_sec;
>> +       fattr->fa_ptime_nsec =3D fa->fsx_ptime.tv_nsec;
>>  }
>>
>>  /**
>> @@ -141,15 +150,23 @@ EXPORT_SYMBOL(copy_fsxattr_to_user);
>>  static int file_attr_to_fileattr(const struct file_attr *fattr,
>>                                  struct file_kattr *fa)
>>  {
>> -       __u64 mask =3D FS_XFLAGS_MASK;
>> +       __u64 mask =3D fattr->fa_xflags_mask ?: FS_XFLAGS_MASK;
>> +
>> +       if (fattr->fa_xflags_mask & ~FS_FILE_ATTR_XFLAGS_MASK)
>> +               return -EINVAL;
>>
>>         if (fattr->fa_xflags & ~mask)
>>                 return -EINVAL;
>>
>>         fileattr_fill_xflags(fa, fattr->fa_xflags & ~FS_XFLAG_RDONLY_MAS=
K);
>> +       fa->fsx_xflags_mask =3D fattr->fa_xflags_mask;
>>         fa->fsx_extsize =3D fattr->fa_extsize;
>>         fa->fsx_projid =3D fattr->fa_projid;
>>         fa->fsx_cowextsize =3D fattr->fa_cowextsize;
>> +       if (fattr->fa_xflags_mask & FS_XFLAG_PTIME) {
>> +               fa->fsx_ptime.tv_sec =3D fattr->fa_ptime_sec;
>> +               fa->fsx_ptime.tv_nsec =3D fattr->fa_ptime_nsec;
>> +       }
>>
>>         return 0;
>>  }
>> @@ -232,6 +249,23 @@ static int fileattr_set_prepare(struct inode *inode=
,
>>             !S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
>>                 return -EINVAL;
>>
>> +       if (fa->fsx_xflags_mask & FS_XFLAG_PTIME) {
>> +               if (!(old_ma->fsx_xflags_mask & FS_XFLAG_PTIME))
>> +                       return -EOPNOTSUPP;
>> +
>> +               if (!(fa->fsx_xflags & FS_XFLAG_PTIME))
>> +                       return -EINVAL;
>> +
>> +               if ((unsigned long)fa->fsx_ptime.tv_nsec >=3D NSEC_PER_S=
EC)
>> +                       return -EINVAL;
>> +
>> +               fa->fsx_ptime =3D timestamp_truncate(fa->fsx_ptime, inod=
e);
>> +
>> +               if (!timespec64_equal(&old_ma->fsx_ptime, &fa->fsx_ptime=
) &&
>> +                   (fa->flags & old_ma->flags) & (FS_APPEND_FL | FS_IMM=
UTABLE_FL))
>> +                       return -EPERM;
>
> I don't know what this is but it looks strange.

That's for preserv- ok nevermind it's probably not needed anymore
since adding fsx_xflags_mask. I'll check that too for v5.

>
>> +       }
>> +
>>         /*
>>          * It is only valid to set the DAX flag on regular files and
>>          * directories on filesystems.
>> @@ -288,13 +322,41 @@ int vfs_fileattr_set(const struct mnt_idmap *idmap=
, struct dentry *dentry,
>>         if (!err) {
>>                 /* initialize missing bits from old_ma */
>>                 if (fa->flags_valid) {
>> -                       fa->fsx_xflags |=3D old_ma.fsx_xflags & ~FS_XFLA=
G_COMMON;
>> +                       /* FS_IOC_SETFLAGS */
>> +                       fa->fsx_xflags |=3D (old_ma.fsx_xflags & FS_XFLA=
GS_MASK) &
>> +                                         ~FS_XFLAG_COMMON;
>>                         fa->fsx_extsize =3D old_ma.fsx_extsize;
>>                         fa->fsx_nextents =3D old_ma.fsx_nextents;
>>                         fa->fsx_projid =3D old_ma.fsx_projid;
>>                         fa->fsx_cowextsize =3D old_ma.fsx_cowextsize;
>> +                       fa->fsx_ptime =3D old_ma.fsx_ptime;
>>                 } else {
>> +                       /*
>> +                        * Preserve unmasked xflags when running file_se=
tattr()
>> +                        * with a mask, which doesn't need a read-modify=
-write
>> +                        * so these attributes would be set to 0.
>> +                        *
>> +                        * With FS_IOC_FSSETXATTR or mask =3D=3D 0 (lega=
cy mode)
>> +                        * this is not needed as userspace does
>> +                        * read-modify-write already.
>> +                        */
>> +                       if (fa->fsx_xflags_mask) {
>> +                               fa->fsx_xflags |=3D old_ma.fsx_xflags &
>> +                                                 ~fa->fsx_xflags_mask;
>> +                               fileattr_fill_xflags(fa, fa->fsx_xflags =
&
>> +                                                    ~FS_XFLAG_RDONLY_MA=
SK);
>> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_EXT=
SIZE))
>> +                                       fa->fsx_extsize =3D old_ma.fsx_e=
xtsize;
>> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_PRO=
JID))
>> +                                       fa->fsx_projid =3D old_ma.fsx_pr=
ojid;
>> +                               if (!(fa->fsx_xflags_mask & FS_XFLAG_COW=
EXTSIZE))
>> +                                       fa->fsx_cowextsize =3D old_ma.fs=
x_cowextsize;
>> +                       }
>>                         fa->flags |=3D old_ma.flags & ~FS_COMMON_FL;
>> +
>> +                       /* xflags not present in fsxattr */
>> +                       if (!(fa->fsx_xflags_mask & FS_XFLAG_PTIME))
>> +                               fa->fsx_ptime =3D old_ma.fsx_ptime;
>>                 }
>>
>
> This whole flags/xflags duality needs a closer look
> This looks a bit too complicated right now.

Yes, I agree.

> I don't have time to do the full review so wanted to give you the
> main feedback first.
>
> I'll try to get to it this week.

Of course, no problem, I also still have a few kinda unrelated patches
to work on and a fairly long list of bugs to fix (found by sashiko), so
v5 will probably be ready this weekend/next week anyway.

Thank you again very much.

Best,
koraynilay

> Thanks,
> Amir.

--37fc961d2ca56be80f03ddce209a59446815f2f70d142ce639c6d949d73f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSgVimKafU5DQMcjcDmj22qf5IGXAUCavttXQAKCRDmj22qf5IG
XLKyAQDUbIPDnr/fz9a76CKxleC/LzaQMjyuAgz3koP+G7YFrwD/QwnPpap95GR9
4QZordaDbvLNae5E2c5s96XsV/AKmAA=
=1jPB
-----END PGP SIGNATURE-----

--37fc961d2ca56be80f03ddce209a59446815f2f70d142ce639c6d949d73f--

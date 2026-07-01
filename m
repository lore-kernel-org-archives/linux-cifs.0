Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72F0393DF0
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 21:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782940806; cv=pass; b=HwWDk00/qfLhLbebHh+DGjwJ8Zz2I5fHCH7JPnUloUcGJdwg38+WFVLuEwny5gfx4AGwkFyk5sv7qY+u+BBHYCrx+8IMEuegKOPFySrDGoZHXTR2Y02i9glr4cbwvk7lCwWXfHCgnksARx1zdoMp24gYoBae4On3yk2m1DaxR7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782940806; c=relaxed/simple;
	bh=/Ux83zg1PqYcZH5iLzb43vgGjkCV2+L95I+nyyH9Z9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TG6jEOSrXjZkT+yIJH5CGRElbRe0mYHXuP00qyK86tGOX1DijgK8J6yOq0BMu8QQ7DZ6wzRT3OYwm8srxMzL67CTi8/xbHlzSlQuIosWsJBqnDxKmV3mUeuMRS/wc76YBQhlqGZfu01m2aIMwWUbJFjZ0lT1qHIe3k9BeWBe63Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtENuR+8; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtENuR+8"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8f2509d6becso10967916d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 14:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782940803; cv=none;
        d=google.com; s=arc-20260327;
        b=KBQBBqB0aAQHHk4rrw3xxRGf1E0Se7e0uRrIgSqSW/mCKgkaUtFOBvddEptiF3/xzb
         7Oq/CCDJpPZL4jH7f7LBHTxPIbMopvyRvwIRdVqiGAVlKVxx5ZB+ESvj3LeVK+GN6Vwq
         /zTsZlcno1w8Oa5320ZFo/jvHL0MZBLjDdAl8Hil4F3gN0/F9nLIzrCmdgffmWKWS4ZR
         DYD09KfD7G5D1xlCqhGGRI/ZL+pXBy7VJ6HSNUsZDAFkuJeGjJs4YhczCdsmkHMUF7gZ
         V74A093lweLfA9hDf44mff78tD5iS+BsU7cYudiO5sSTVrIYuD9bTFBuLmA2yUAZheU5
         CWOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OBhEpWJUv0KmQZwPOc1kYdeMY/SvDxTnIv9UExFbdcY=;
        fh=Hhoag2Q4XQJSvENOQAv4gXqA+AceMD2p5eLIc9NWRyI=;
        b=bBBSB+pN1nIw47hdpfiaj+OKUHgL22ouiUz3fj4eMlvGt8pN1362//A7QgymDUJeIx
         aIYuEF2hmsWPTnCmVoIXPckBUPEP9bKtMaF780T/QJZkEobFh3bxh4/UM7JC9k5lOkQ5
         tPISfzHvvPqpULlva5GFR3c3JzJsWHl7fHZBou28BsVQrEEtoD6eVeUuKx+gIX/G6SnO
         nwPmKvTIvEjHH3gd5bzCAfQLUVmPcTgBCRSQry+xXT25VLjDEu6Sq3sMCEeJC/gcn8MB
         u9jYX0f+LvWgClY1MJbuyUD5R2+01+T8vS/VEMaks7A/3dMnsJMdFcaFeneN0JbbpH+e
         XHUA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782940803; x=1783545603; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OBhEpWJUv0KmQZwPOc1kYdeMY/SvDxTnIv9UExFbdcY=;
        b=GtENuR+8s+n46O1jJCSuCKR0XSzfVwKfLqygWs43NIiykMPgeQqlwwcPhU3xgJbvOB
         EjJiR+PFygWgETGjtJUG65YAaSVU6RB7DPoqAUhYMtN9iHsnerb/3254tHZJPkmFyTYY
         6fIpE7nH7LH48B0zZveRQ6iXEsFGr6z6uUQmix8j/iWMjWJQCmDMfX5WaKOb3P2KhN9w
         6x7/MYXRu+PAWkTPysbSREL3Pk8nM/MB4L2HnzQXuIW0fN+9iiaQVJPys8yiv2pGdY5U
         T98t/pnN7NbKPx7guvtx0TvuylIaf3SYc9Dr0jVD9aNRRLOvnAr1I3K1OmXNMgVrJtEU
         4HLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782940803; x=1783545603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OBhEpWJUv0KmQZwPOc1kYdeMY/SvDxTnIv9UExFbdcY=;
        b=Jpei61sZgByLxdlzjl/cLXsAdC4Y6QDVESrlUEkfKY/qYg0gkmMWU2N7yGncYgug3K
         UowzJ0yiVLVXF39FSR7Y+wVmPQ1jh69aLLM3TZm25Tv6gpHSO+PpZZiG5yrwX+Gw6xi/
         hCzssDVK4QObaYL+i403fDuwhqpBbzKF8BRWlFHXGVL9xbarecZ2rOqQEgPgKAzxm5JD
         wxayxe3URM/DFSrtO5DPb3qhr6iro4VRJPeltLRf8HIi0K0MQtwenvbIRWh5ypTTqf4O
         rJtgULR4UE70cbbCqZsxYVB9sbeBSfPT1LlNCUgDvVfMtfFRYiBP7kvnKAt5dHZa+oEx
         /TyA==
X-Forwarded-Encrypted: i=1; AHgh+Rp9iw+MFQCU/AcFnXG7f23/CnaPPuq8dZoXBqo2LT1wqRtiYz3g23NYMENSa2f7XtIoPnSP00QM6e+x@vger.kernel.org
X-Gm-Message-State: AOJu0YyLAkD77ppQTRNxMKdWUkoO5sIlymlIePeicSr4kGKh8zZ8ZOR9
	1kpWGbh+LCLMbI5YUu7MLYgRmwjVubkPWUFA6SdoYWQunSpJ7gzyVQLlavlu+iGWeadFAjEpQPh
	kEir5aQOtelqCHDg5h2vatuHftXzv5kc=
X-Gm-Gg: AfdE7ckB54nuFDX2YZ/u1vHpNBVyZDrVjTGQw/5rC8aywvauzLlfH9Zaf3KH1jn35Ez
	JqI+p0+7Axva+KqyHdhlb/IJu3qSre0j6tR6VZjjP6Cieuns8JME++DSgLoXXVPIAFb+tTwZN/z
	CfkDcmxU/r+R1g0wmnIy8XXcreYf9k63b2QBBsx+qO17ZWjR6WXOehSsN1PRuE/IM2LzBNpEP4s
	YSAKEWs70wnv801aT3iJGFnOktiP9vRe32S6ZR5Bq2RyrLasPHNTFslwGizkv6ZFegS5qH1aQY7
	E/262BJARosPnH4ooFoQVKuBHJtSwBNIUCh680WctGnxfJYQamdMCQWV4AL0g2X4WGssAxbPVmK
	3Q+WpO1I+F9VWLmCqVARWYXO4sRRiHQq1/tWelEOL7iJRh7Z1VeoNyUkhmDonmwQLgzh+6aIlda
	2dEBhsUIW66v8=
X-Received: by 2002:ad4:43ca:0:b0:8f2:e9a1:923a with SMTP id
 6a1803df08f44-8f3c9da7f59mr35612246d6.54.1782940803441; Wed, 01 Jul 2026
 14:20:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701152157.822207-1-huiwen.he@linux.dev> <20260701152157.822207-5-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-5-huiwen.he@linux.dev>
From: Steve French <smfrench@gmail.com>
Date: Wed, 1 Jul 2026 16:19:52 -0500
X-Gm-Features: AVVi8CcguP9jaL_tAjvCtDAXOsy4HdmUwOZ6FQhzXzwZDTbSBAiH_Mi8pdYlzwo
Message-ID: <CAH2r5mvX5qdWyEszD2reWMHOaUYrqtMmk0RK9xgkrx+Wc-RdWA@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] smb/client: refresh allocation after EOF-extending fallocate
To: Huiwen He <huiwen.he@linux.dev>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

With this patch I do see a difference in generic/103 which with the
patch returns

generic/103  0s ... - output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/103.out.bad)
    --- tests/generic/103.out 2025-08-22 09:54:32.266754366 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/103.out.bad
2026-07-01 16:13:02.220130644 -0500
    @@ -1,2 +1,3 @@
     QA output created by 103
    +fallocate: No space left on device
     Silence is golden.

but without that patch works.  Also is puzzling why the error changes
for generic/539 with the four fallocate patches from:

generic/539  0s ... [failed, exit status 1]- output mismatch (see
/home/smfrench/xfstests-dev/results//sambamfs/generic/539.out.bad)
    --- tests/generic/539.out 2025-08-22 09:54:32.329794445 -0500
    +++ /home/smfrench/xfstests-dev/results//sambamfs/generic/539.out.bad
2026-06-30 20:27:26.739245628 -0500
    @@ -1,2 +1,4 @@
     QA output created by 539
     Silence is golden
    +seek sanity check failed!
    +(see /home/smfrench/xfstests-dev/results//sambamfs/generic/539.full
for details)
    ...

to
   generic/539  0s ... [not run] File system does not support
llseek(2) SEEK_DATA/HOLE

Samba supports SEEK_DATA/SEEK_HOLE right?

On Wed, Jul 1, 2026 at 10:22=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> Before this change, xfstests generic/496 was not supported on ksmbd:
>
>         generic/496 ... [not run] fallocated swap not supported here
>
> ksmbd handles SetEOF as truncate, so EOF extension alone does not
> allocate backing blocks. A fallocated swapfile can therefore still
> look sparse to swapon.
>
> Request allocation for EOF-extending fallocate ranges that can be
> represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
> state afterwards.
>
> With this change, xfstests generic/496 and generic/701 pass on ksmbd.
>
> However, Samba "strict allocate =3D no" now exposes the real generic/701
> failure: the old pass came from inflated local i_blocks, not from
> server allocation. generic/213 also fails in that case because an
> oversized allocation request may not return ENOSPC.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/smb2ops.c   | 43 ++++++++++++++++++++++++++++++++++++---
>  fs/smb/client/smb2pdu.c   | 19 +++++++++++++++++
>  fs/smb/client/smb2proto.h |  3 +++
>  fs/smb/common/fscc.h      |  5 +++++
>  fs/smb/server/smb2pdu.h   |  4 ----
>  5 files changed, 67 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index c75f55935b9b..698fce6feea3 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -3756,12 +3756,49 @@ static long smb3_simple_falloc(struct file *file,=
 struct cifs_tcon *tcon,
>                         smb2_set_sparse(xid, tcon, cfile, inode, false);
>
>                 new_eof =3D off + len;
> +
> +               qrc =3D SMB2_query_info(xid, tcon,
> +                                     cfile->fid.persistent_fid,
> +                                     cfile->fid.volatile_fid, &file_inf)=
;
> +               if (qrc =3D=3D 0)
> +                       asize =3D le64_to_cpu(file_inf.AllocationSize);
> +
> +               /*
> +                * FILE_ALLOCATION_INFORMATION can only describe allocati=
on up to
> +                * new_eof. Some servers may accept it without allocating=
 blocks,
> +                * so refresh AllocationSize before updating i_blocks.
> +                */
> +               if (off =3D=3D 0 || off =3D=3D old_eof) {
> +                       if (qrc || asize < new_eof) {
> +                               rc =3D SMB2_set_allocation(xid, tcon,
> +                                                        cfile->fid.persi=
stent_fid,
> +                                                        cfile->fid.volat=
ile_fid,
> +                                                        cfile->pid, new_=
eof);
> +                               if (rc)
> +                                       goto out;
> +                       }
> +               }
> +
>                 rc =3D SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
>                                   cfile->fid.volatile_fid, cfile->pid, ne=
w_eof);
> -               if (rc =3D=3D 0) {
> -                       netfs_resize_file(&cifsi->netfs, new_eof, true);
> -                       cifs_setsize(inode, new_eof);
> +               if (rc)
> +                       goto out;
> +
> +               netfs_resize_file(&cifsi->netfs, new_eof, true);
> +               cifs_setsize(inode, new_eof);
> +
> +               qrc =3D SMB2_query_info(xid, tcon,
> +                                     cfile->fid.persistent_fid,
> +                                     cfile->fid.volatile_fid, &file_inf)=
;
> +               spin_lock(&inode->i_lock);
> +               if (qrc =3D=3D 0) {
> +                       asize =3D le64_to_cpu(file_inf.AllocationSize);
> +                       if (asize >=3D new_eof)
> +                               inode->i_blocks =3D CIFS_INO_BLOCKS(asize=
);
> +               } else {
> +                       cifsi->time =3D 0;
>                 }
> +               spin_unlock(&inode->i_lock);
>                 goto out;
>         }
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index d058584b8f05..1374bbae627f 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5947,6 +5947,25 @@ SMB2_set_eof(const unsigned int xid, struct cifs_t=
con *tcon, u64 persistent_fid,
>                         0, 1, &data, &size);
>  }
>
> +int
> +SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
> +                   u64 persistent_fid, u64 volatile_fid, u32 pid,
> +                   loff_t allocation_size)
> +{
> +       struct smb2_file_alloc_info info;
> +       void *data;
> +       unsigned int size;
> +
> +       info.AllocationSize =3D cpu_to_le64(allocation_size);
> +
> +       data =3D &info;
> +       size =3D sizeof(struct smb2_file_alloc_info);
> +
> +       return send_set_info(xid, tcon, persistent_fid, volatile_fid,
> +                       pid, FILE_ALLOCATION_INFORMATION, SMB2_O_INFO_FIL=
E,
> +                       0, 1, &data, &size);
> +}
> +
>  int
>  SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
>                 u64 persistent_fid, u64 volatile_fid,
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 78a4e1c340f9..16a02c1eb0a1 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -204,6 +204,9 @@ void SMB2_query_directory_free(struct smb_rqst *rqst)=
;
>  int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
>                  u64 persistent_fid, u64 volatile_fid, u32 pid,
>                  loff_t new_eof);
> +int SMB2_set_allocation(const unsigned int xid, struct cifs_tcon *tcon,
> +                       u64 persistent_fid, u64 volatile_fid, u32 pid,
> +                       loff_t allocation_size);
>  int SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *s=
erver,
>                        struct smb_rqst *rqst, u64 persistent_fid,
>                        u64 volatile_fid, u32 pid, u8 info_class, u8 info_=
type,
> diff --git a/fs/smb/common/fscc.h b/fs/smb/common/fscc.h
> index 859849a42fec..941db5a95564 100644
> --- a/fs/smb/common/fscc.h
> +++ b/fs/smb/common/fscc.h
> @@ -283,6 +283,11 @@ struct smb2_file_eof_info { /* encoding of request f=
or level 10 */
>         __le64 EndOfFile; /* new end of file value */
>  } __packed; /* level 20 Set */
>
> +/* See MS-FSCC 2.4.4 */
> +struct smb2_file_alloc_info { /* encoding of request for level 19 */
> +       __le64 AllocationSize;
> +} __packed;
> +
>  /* See MS-FSCC 2.4.15 */
>  typedef struct {
>         __le32 NextEntryOffset;
> diff --git a/fs/smb/server/smb2pdu.h b/fs/smb/server/smb2pdu.h
> index c2512dbcdec8..aa06c8c905f1 100644
> --- a/fs/smb/server/smb2pdu.h
> +++ b/fs/smb/server/smb2pdu.h
> @@ -212,10 +212,6 @@ struct smb2_file_ea_info {
>         __le32 EASize;
>  } __packed;
>
> -struct smb2_file_alloc_info {
> -       __le64 AllocationSize;
> -} __packed;
> -
>  struct smb2_file_disposition_info {
>         __u8 DeletePending;
>  } __packed;
> --
> 2.43.0
>


--=20
Thanks,

Steve

Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F181FAC37
	for <linux-cifs@vger.kernel.org>; Tue, 26 Aug 2025 01:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756172633; cv=none; b=hOPGRSGVTZ156iOyJJDAxYpRpCpcrv2nDBAkCl/B5xqohPriE3UsjTJcd6K8g4gQDlsNcSKs8VXZ89XJgljN1iJL93/u+5xN2kIvfpTCZEaB4FmUw3YrQ+zZcdBCkHOmZRQbjRut7KrtJRRTAbu3GfqxJWiyvRKA53R8RX1AMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756172633; c=relaxed/simple;
	bh=47uwTXY7pLb28CuobPySQ4W/5oaCT3Orn3EolbJMBgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZoB1Y2RctnUFiIyXQ8NSxWE4m3Ug6A0343V2O2j3pIzca50iZRgRCnHosni991sODUiBxFXsBTOvrxIScTcFIz7MddHxLgcVb/BmwMkmVyqJTqmbk+vaXGCyP1U7Omi0Lpk7kvdwxwa3z60RjNPfd7eRkMUa2y4nXlmiBeDQNSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NV4ck+Gc; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NV4ck+Gc"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-70bb007a821so65405866d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 18:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756172630; x=1756777430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XUYCycUtJC2DkQKlCoJfaleOCStJ6yovaCR9+sE2iwg=;
        b=NV4ck+GcPCnRws9XCH50/hm9tlj1zUQp5kgDXDaOyhF5YHwBK0Bx5djKK9EIfLRY/b
         2g8e/p/cirG18kGRIDG5aBw1X0jq/VW5v29oH5VZiJEPbGOFFoduVbtuSN6nFqM6jPcN
         Ybbf4GufwCq/f5cOUNXr7LErbMn8W0QJKkOuTzBA6Ty5haua3YwdERbbgMG8Q/2QEZCd
         S3lpPWBCi+XqQFPTk3mYCXTJDAnTbfPRPqJ3J8FjbENetPyXv3it15bNruPMAUqvP3cB
         vwwaVlps/vUyChUcAoXePhHG/T1QCNVwQ+rUyj93q1Ik7mMhxLXdmXqhCYT0y/whPWFp
         58Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756172630; x=1756777430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XUYCycUtJC2DkQKlCoJfaleOCStJ6yovaCR9+sE2iwg=;
        b=AlZX5jp5jUYhYkQNhM8qjtPv7ulW/1tGQuqYTiEZ6ck/ZGVMR+6Rx/SCJmSxTAjmTC
         hgxtRlPeBCK7R5Fc867G/L9UNdkSYkVLdFP/QYkzbuKkm4e/TdnSE5RATFAyD1BxwvYt
         ZcxoJI030rUgyRxMv36avjWs/gX0JhQINHsZGWTtYyUm1aJErOj7X/Y0muRdOPJzlFwd
         Lx/2IczMxMJY61GQ6dtIGtJMauAQ+sJPFS+9bodf+M39GJUT3RZg42NNWEsKeoskHfuM
         lahlrBlcu1DiFTcnTA7BOhN2uW0WAFKXPHmHFPcdfFg9WNM7pV09gDDV8alstJ4P8x0J
         4V5w==
X-Forwarded-Encrypted: i=1; AJvYcCXvvKgLMchtEqUb64e+L8zjDE6OTY5dVF3D7HTUhRjXuMxV3lwXlo+OfY7E2qKvYi0R9lCv2ohZqMqg@vger.kernel.org
X-Gm-Message-State: AOJu0YwMwsytmURC1La4YxKQofSQvDcGRK5f2DYA1aXEbH1SjDUvXS0f
	hszmBZqT/iQvtB7Pq+/8YoF9tRYYkzssioHNRjdQtL0+bGnGqWE/YSDYaAJme9Ue9eo90putErs
	IsBVjO9shoKnTg6h1Xeu2oPfbS0YtuA8=
X-Gm-Gg: ASbGncsgBdoek+91u06cXpidfAE5jEa9bvEspMKDgZFZrgjdvGBFWWgxqobjV6svlmR
	kCm+ZkKVVJmt+Au/BQdbvhSaxva+WbVG/HPNHT5vhKfMYXtHQgCnoUjlSxdek5dZXg0TtNLXBgZ
	rwDLTdEddEFl4Nw/77uhWsQQog+tNBHjajx3KdCZD0XcEe0aGfxZhXH9f8fu9jMFVSm/qYmOpds
	wjpHyv2GRzGiQAkMJx4GTzA2Mz+sebAvnunFsWm4/bAVEOqBLYDUKR8fYdGexyhnQWiw0vNo5wG
	bcv5t9QxnoytXTNTYVorRg==
X-Google-Smtp-Source: AGHT+IHbmvopbclGJafloMTJ1boW3d431Ug3WzQZvBvEmQgAvUFEqbMqGH3Zw/AWhRhdaRIU8ICsUKMNZEwYkgUcZKI=
X-Received: by 2002:a05:6214:d8c:b0:70d:6df4:1b0f with SMTP id
 6a1803df08f44-70d973bae47mr181611956d6.61.1756172630424; Mon, 25 Aug 2025
 18:43:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250825162010.417958-1-pc@manguebit.org>
In-Reply-To: <20250825162010.417958-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 25 Aug 2025 20:43:37 -0500
X-Gm-Features: Ac12FXyj65o_T7eoqsEjUFihtL7C9YwMrqwbZ7_k45BJXvTqLpUZG_zLwG5ajMQ
Message-ID: <CAH2r5mth_bxfVch4rS0kk6f91houRsnbou7NVjGmFNvfdk+0Wg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix data loss due to broken rename(2)
To: Paulo Alcantara <pc@manguebit.org>
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>, David Howells <dhowells@redhat.com>, 
	Frank Sorenson <sorenson@redhat.com>, Olga Kornievskaia <okorniev@redhat.com>, 
	Benjamin Coddington <bcodding@redhat.com>, Scott Mayhew <smayhew@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more review and testing
(running more tests on it now)

Added Cc: stable

On Mon, Aug 25, 2025 at 11:20=E2=80=AFAM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> Rename of open files in SMB2+ has been broken for a very long time,
> resulting in data loss as the CIFS client would fail the rename(2)
> call with -ENOENT and then removing the target file.
>
> Fix this by implementing ->rename_pending_delete() for SMB2+, which
> will rename busy files to random filenames (e.g. silly rename) during
> unlink(2) or rename(2), and then marking them to delete-on-close.
>
> Besides, introduce a FIND_RD_NO_PENDING_DELETE flag for
> cifs_get_readable_path() to be used in smb2_query_path_info() and
> smb2_query_reparse_point() so we don't end up reusing open handles of
> files that were already removed.
>
> Reported-by: Jean-Baptiste Denis <jbdenis@pasteur.fr>
> Closes: https://marc.info/?i=3D16aeb380-30d4-4551-9134-4e7d1dc833c0@paste=
ur.fr
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Frank Sorenson <sorenson@redhat.com>
> Cc: Olga Kornievskaia <okorniev@redhat.com>
> Cc: Benjamin Coddington <bcodding@redhat.com>
> Cc: Scott Mayhew <smayhew@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h  |   5 ++
>  fs/smb/client/cifsproto.h |   4 +-
>  fs/smb/client/file.c      |  18 ++++-
>  fs/smb/client/inode.c     |   6 +-
>  fs/smb/client/smb2glob.h  |   1 +
>  fs/smb/client/smb2inode.c | 151 +++++++++++++++++++++++++++++++++++++-
>  fs/smb/client/smb2ops.c   |   4 +
>  fs/smb/client/smb2proto.h |   3 +
>  fs/smb/client/trace.h     |   3 +
>  9 files changed, 184 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 1e64a4fb6af0..d238b186946b 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -1886,6 +1886,9 @@ static inline bool is_replayable_error(int error)
>  #define FIND_WR_FSUID_ONLY  1
>  #define FIND_WR_WITH_DELETE 2
>
> +/* cifs_get_readable_path() flags */
> +#define FIND_RD_NO_PENDING_DELETE 1
> +
>  #define   MID_FREE 0
>  #define   MID_REQUEST_ALLOCATED 1
>  #define   MID_REQUEST_SUBMITTED 2
> @@ -2343,6 +2346,8 @@ struct smb2_compound_vars {
>         struct kvec qi_iov;
>         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
>         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> +       struct kvec fdis_iov[SMB2_SET_INFO_IOV_SIZE];
> +       struct kvec rename_iov[SMB2_SET_INFO_IOV_SIZE];
>         struct kvec close_iov;
>         struct smb2_file_rename_info_hdr rename_info;
>         struct smb2_file_link_info_hdr link_info;
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index c34c533b2efa..518b4e5126cd 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -176,8 +176,8 @@ extern int cifs_get_writable_path(struct cifs_tcon *t=
con, const char *name,
>                                   int flags,
>                                   struct cifsFileInfo **ret_file);
>  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, b=
ool);
> -extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *na=
me,
> -                                 struct cifsFileInfo **ret_file);
> +int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
> +                          unsigned int flags, struct cifsFileInfo **ret_=
file);
>  extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *=
inode,
>                                   struct file *file);
>  extern unsigned int smbCalcSize(void *buf);
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 186e061068be..12e72f08f046 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1000,7 +1000,7 @@ int cifs_open(struct inode *inode, struct file *fil=
e)
>         if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
>                 rc =3D cifs_get_writable_path(tcon, full_path, FIND_WR_FS=
UID_ONLY, &cfile);
>         } else {
> -               rc =3D cifs_get_readable_path(tcon, full_path, &cfile);
> +               rc =3D cifs_get_readable_path(tcon, full_path, 0, &cfile)=
;
>         }
>         if (rc =3D=3D 0) {
>                 unsigned int oflags =3D file->f_flags & ~(O_CREAT|O_EXCL|=
O_TRUNC);
> @@ -2622,9 +2622,8 @@ cifs_get_writable_path(struct cifs_tcon *tcon, cons=
t char *name,
>         return -ENOENT;
>  }
>
> -int
> -cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
> -                      struct cifsFileInfo **ret_file)
> +int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
> +                          unsigned int flags, struct cifsFileInfo **ret_=
file)
>  {
>         struct cifsFileInfo *cfile;
>         void *page =3D alloc_dentry_path();
> @@ -2647,6 +2646,17 @@ cifs_get_readable_path(struct cifs_tcon *tcon, con=
st char *name,
>                 spin_unlock(&tcon->open_file_lock);
>                 free_dentry_path(page);
>                 *ret_file =3D find_readable_file(cinode, 0);
> +               if (*ret_file) {
> +                       spin_lock(&cinode->open_file_lock);
> +                       if ((flags & FIND_RD_NO_PENDING_DELETE) &&
> +                           (*ret_file)->status_file_deleted) {
> +                               spin_unlock(&cinode->open_file_lock);
> +                               cifsFileInfo_put(*ret_file);
> +                               *ret_file =3D NULL;
> +                       } else {
> +                               spin_unlock(&cinode->open_file_lock);
> +                       }
> +               }
>                 return *ret_file ? 0 : -ENOENT;
>         }
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index fe453a4b3dc8..48dbfb451576 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -2003,7 +2003,11 @@ int cifs_unlink(struct inode *dir, struct dentry *=
dentry)
>                 goto psx_del_no_retry;
>         }
>
> -       rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry)=
;
> +       if (server->vals->protocol_id > SMB10_PROT_ID &&
> +           d_is_positive(dentry) && d_count(dentry) > 2)
> +               rc =3D -EBUSY;
> +       else
> +               rc =3D server->ops->unlink(xid, tcon, full_path, cifs_sb,=
 dentry);
>
>  psx_del_no_retry:
>         if (!rc) {
> diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> index 224495322a05..474fddb9c56c 100644
> --- a/fs/smb/client/smb2glob.h
> +++ b/fs/smb/client/smb2glob.h
> @@ -39,6 +39,7 @@ enum smb2_compound_ops {
>         SMB2_OP_GET_REPARSE,
>         SMB2_OP_QUERY_WSL_EA,
>         SMB2_OP_OPEN_QUERY,
> +       SMB2_OP_SET_FILE_DISP,
>  };
>
>  /* Used when constructing chained read requests. */
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 2a0316c514e4..223358e082b3 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -440,7 +440,7 @@ static int smb2_compound_op(const unsigned int xid, s=
truct cifs_tcon *tcon,
>                                                            ses->Suid, ful=
l_path);
>                         break;
>                 case SMB2_OP_RENAME:
> -                       rqst[num_rqst].rq_iov =3D &vars->si_iov[0];
> +                       rqst[num_rqst].rq_iov =3D vars->rename_iov;
>                         rqst[num_rqst].rq_nvec =3D 2;
>
>                         len =3D in_iov[i].iov_len;
> @@ -594,6 +594,41 @@ static int smb2_compound_op(const unsigned int xid, =
struct cifs_tcon *tcon,
>                         trace_smb3_query_wsl_ea_compound_enter(xid, tcon-=
>tid,
>                                                                ses->Suid,=
 full_path);
>                         break;
> +               case SMB2_OP_SET_FILE_DISP:
> +                       rqst[num_rqst].rq_iov =3D vars->fdis_iov;
> +                       rqst[num_rqst].rq_nvec =3D 1;
> +
> +                       size[0] =3D in_iov[i].iov_len;
> +                       data[0] =3D in_iov[i].iov_base;
> +
> +                       if (cfile) {
> +                               rc =3D SMB2_set_info_init(tcon, server,
> +                                                       &rqst[num_rqst],
> +                                                       cfile->fid.persis=
tent_fid,
> +                                                       cfile->fid.volati=
le_fid,
> +                                                       current->tgid,
> +                                                       FILE_DISPOSITION_=
INFORMATION,
> +                                                       SMB2_O_INFO_FILE,=
 0,
> +                                                       data, size);
> +                       } else {
> +                               rc =3D SMB2_set_info_init(tcon, server,
> +                                                       &rqst[num_rqst],
> +                                                       COMPOUND_FID,
> +                                                       COMPOUND_FID,
> +                                                       current->tgid,
> +                                                       FILE_DISPOSITION_=
INFORMATION,
> +                                                       SMB2_O_INFO_FILE,=
 0,
> +                                                       data, size);
> +                       }
> +                       if (!rc && (!cfile || num_rqst > 1)) {
> +                               smb2_set_next_command(tcon, &rqst[num_rqs=
t]);
> +                               smb2_set_related(&rqst[num_rqst]);
> +                       } else if (rc) {
> +                               goto finished;
> +                       }
> +                       num_rqst++;
> +                       trace_smb3_set_file_disp_enter(xid, tcon->tid, se=
s->Suid, full_path);
> +                       break;
>                 default:
>                         cifs_dbg(VFS, "Invalid command\n");
>                         rc =3D -EINVAL;
> @@ -843,6 +878,13 @@ static int smb2_compound_op(const unsigned int xid, =
struct cifs_tcon *tcon,
>                         }
>                         SMB2_query_info_free(&rqst[num_rqst++]);
>                         break;
> +               case SMB2_OP_SET_FILE_DISP:
> +                       if (!rc)
> +                               trace_smb3_set_file_disp_done(xid, tcon->=
tid, ses->Suid);
> +                       else
> +                               trace_smb3_set_file_disp_err(xid, tcon->t=
id, ses->Suid, rc);
> +                       SMB2_set_info_free(&rqst[num_rqst++]);
> +                       break;
>                 }
>         }
>         SMB2_close_free(&rqst[num_rqst]);
> @@ -990,7 +1032,7 @@ int smb2_query_path_info(const unsigned int xid,
>         in_iov[1] =3D in_iov[0];
>         in_iov[2] =3D in_iov[0];
>
> -       cifs_get_readable_path(tcon, full_path, &cfile);
> +       cifs_get_readable_path(tcon, full_path, FIND_RD_NO_PENDING_DELETE=
, &cfile);
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIB=
UTES,
>                              FILE_OPEN, create_options, ACL_NO_MODE);
>         rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
> @@ -1069,7 +1111,8 @@ int smb2_query_path_info(const unsigned int xid,
>                                      FILE_READ_EA | SYNCHRONIZE,
>                                      FILE_OPEN, create_options |
>                                      OPEN_REPARSE_POINT, ACL_NO_MODE);
> -               cifs_get_readable_path(tcon, full_path, &cfile);
> +               cifs_get_readable_path(tcon, full_path,
> +                                      FIND_RD_NO_PENDING_DELETE, &cfile)=
;
>                 free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
>                 rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path,
>                                       &oparms, in_iov, cmds, num_cmds,
> @@ -1418,7 +1461,8 @@ int smb2_query_reparse_point(const unsigned int xid=
,
>
>         cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
>
> -       cifs_get_readable_path(tcon, full_path, &cfile);
> +       cifs_get_readable_path(tcon, full_path,
> +                              FIND_RD_NO_PENDING_DELETE, &cfile);
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path,
>                              FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHR=
ONIZE,
>                              FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
> @@ -1438,3 +1482,102 @@ int smb2_query_reparse_point(const unsigned int x=
id,
>         cifs_free_open_info(&data);
>         return rc;
>  }
> +
> +int smb2_rename_pending_delete(const char *full_path,
> +                              struct dentry *dentry,
> +                              const unsigned int xid)
> +{
> +       struct cifs_sb_info *cifs_sb =3D CIFS_SB(d_inode(dentry)->i_sb);
> +       struct cifsInodeInfo *cinode =3D CIFS_I(d_inode(dentry));
> +       __le16 *utf16_path __free(kfree) =3D NULL;
> +       __u32 co =3D file_create_options(dentry);
> +       int cmds[] =3D {
> +               SMB2_OP_SET_INFO,
> +               SMB2_OP_RENAME,
> +               SMB2_OP_SET_FILE_DISP,
> +       };
> +       const int num_cmds =3D ARRAY_SIZE(cmds);
> +       char *to_name __free(kfree) =3D NULL;
> +       struct kvec iov[ARRAY_SIZE(cmds)];
> +       __u32 attrs =3D cinode->cifsAttrs;
> +       struct cifs_open_parms oparms;
> +       static atomic_t sillycounter;
> +       struct cifsFileInfo *cfile;
> +       struct tcon_link *tlink;
> +       __u8 delete_pending =3D 1;
> +       struct cifs_tcon *tcon;
> +       const char *ppath;
> +       void *page;
> +       size_t len;
> +       int rc;
> +
> +       tlink =3D cifs_sb_tlink(cifs_sb);
> +       if (IS_ERR(tlink))
> +               return PTR_ERR(tlink);
> +       tcon =3D tlink_tcon(tlink);
> +
> +       page =3D alloc_dentry_path();
> +
> +       ppath =3D build_path_from_dentry(dentry->d_parent, page);
> +       if (IS_ERR(ppath)) {
> +               rc =3D PTR_ERR(ppath);
> +               goto out;
> +       }
> +
> +       len =3D strlen(ppath) + strlen("/.__smb1234") + 1;
> +       if (unlikely(len >=3D PATH_MAX)) {
> +               rc =3D -ENAMETOOLONG;
> +               goto out;
> +       }
> +       to_name =3D kmalloc(len, GFP_KERNEL);
> +       if (!to_name) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
> +
> +       scnprintf(to_name, len, "%s%c.__smb%04X", ppath, CIFS_DIR_SEP(cif=
s_sb),
> +                 atomic_inc_return(&sillycounter) & 0xffff);
> +
> +       utf16_path =3D cifs_convert_path_to_utf16(to_name, cifs_sb);
> +       if (!utf16_path) {
> +               rc =3D -ENOMEM;
> +               goto out;
> +       }
> +
> +       drop_cached_dir_by_name(xid, tcon, full_path, cifs_sb);
> +       oparms =3D CIFS_OPARMS(cifs_sb, tcon, full_path,
> +                            DELETE | FILE_WRITE_ATTRIBUTES,
> +                            FILE_OPEN, co, ACL_NO_MODE);
> +
> +       attrs &=3D ~ATTR_READONLY;
> +       iov[0].iov_base =3D &(FILE_BASIC_INFO) {
> +               .Attributes =3D cpu_to_le32((attrs ?: ATTR_NORMAL) | ATTR=
_HIDDEN),
> +       };
> +       iov[0].iov_len =3D sizeof(FILE_BASIC_INFO);
> +       iov[1].iov_base =3D utf16_path;
> +       iov[1].iov_len =3D sizeof(*utf16_path) * UniStrnlen((wchar_t *)ut=
f16_path, PATH_MAX);
> +       iov[2].iov_base =3D &delete_pending;
> +       iov[2].iov_len =3D sizeof(delete_pending);
> +
> +       cifs_get_writable_path(tcon, full_path, FIND_WR_WITH_DELETE, &cfi=
le);
> +       rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, i=
ov,
> +                             cmds, num_cmds, cfile, NULL, NULL, dentry);
> +       if (rc =3D=3D -EINVAL) {
> +               cifs_dbg(FYI, "invalid lease key, resending request witho=
ut lease\n");
> +               cifs_get_writable_path(tcon, full_path,
> +                                      FIND_WR_WITH_DELETE, &cfile);
> +               rc =3D smb2_compound_op(xid, tcon, cifs_sb, full_path, &o=
parms, iov,
> +                                     cmds, num_cmds, cfile, NULL, NULL, =
NULL);
> +       }
> +       if (!rc) {
> +               set_bit(CIFS_INO_DELETE_PENDING, &cinode->flags);
> +       } else {
> +               cifs_tcon_dbg(VFS, "%s: failed to rename '%s' to '%s': %d=
\n",
> +                             __func__, full_path, to_name, rc);
> +               rc =3D -EIO;
> +       }
> +out:
> +       cifs_put_tlink(tlink);
> +       free_dentry_path(page);
> +       return rc;
> +}
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 94b1d7a395d5..aa604c9c683b 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -5376,6 +5376,7 @@ struct smb_version_operations smb20_operations =3D =
{
>         .llseek =3D smb3_llseek,
>         .is_status_io_timeout =3D smb2_is_status_io_timeout,
>         .is_network_name_deleted =3D smb2_is_network_name_deleted,
> +       .rename_pending_delete =3D smb2_rename_pending_delete,
>  };
>  #endif /* CIFS_ALLOW_INSECURE_LEGACY */
>
> @@ -5481,6 +5482,7 @@ struct smb_version_operations smb21_operations =3D =
{
>         .llseek =3D smb3_llseek,
>         .is_status_io_timeout =3D smb2_is_status_io_timeout,
>         .is_network_name_deleted =3D smb2_is_network_name_deleted,
> +       .rename_pending_delete =3D smb2_rename_pending_delete,
>  };
>
>  struct smb_version_operations smb30_operations =3D {
> @@ -5597,6 +5599,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .llseek =3D smb3_llseek,
>         .is_status_io_timeout =3D smb2_is_status_io_timeout,
>         .is_network_name_deleted =3D smb2_is_network_name_deleted,
> +       .rename_pending_delete =3D smb2_rename_pending_delete,
>  };
>
>  struct smb_version_operations smb311_operations =3D {
> @@ -5713,6 +5716,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .llseek =3D smb3_llseek,
>         .is_status_io_timeout =3D smb2_is_status_io_timeout,
>         .is_network_name_deleted =3D smb2_is_network_name_deleted,
> +       .rename_pending_delete =3D smb2_rename_pending_delete,
>  };
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 6e805ece6a7b..b3f1398c9f79 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -317,5 +317,8 @@ int posix_info_sid_size(const void *beg, const void *=
end);
>  int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
>                        struct dentry *dentry, struct cifs_tcon *tcon,
>                        const char *full_path, umode_t mode, dev_t dev);
> +int smb2_rename_pending_delete(const char *full_path,
> +                              struct dentry *dentry,
> +                              const unsigned int xid);
>
>  #endif                 /* _SMB2PROTO_H */
> diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
> index 93e5b2bb9f28..323a82f66d2b 100644
> --- a/fs/smb/client/trace.h
> +++ b/fs/smb/client/trace.h
> @@ -675,6 +675,7 @@ DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_info_compoun=
d_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_reparse_compound_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(get_reparse_compound_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(query_wsl_ea_compound_enter);
> +DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_file_disp_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(delete_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mkdir_enter);
>  DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(tdis_enter);
> @@ -716,6 +717,7 @@ DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_info_compound=
_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_reparse_compound_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(get_reparse_compound_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(query_wsl_ea_compound_done);
> +DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_file_disp_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(delete_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mkdir_done);
>  DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(tdis_done);
> @@ -762,6 +764,7 @@ DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_info_compound_=
err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_reparse_compound_err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(get_reparse_compound_err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(query_wsl_ea_compound_err);
> +DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_file_disp_err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mkdir_err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(delete_err);
>  DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(tdis_err);
> --
> 2.51.0
>


--=20
Thanks,

Steve

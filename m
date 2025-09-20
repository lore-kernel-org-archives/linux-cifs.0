Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9B530F55A
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758390983; cv=none; b=hGSBuDXMPBAFIgk/oMlUgUVpJ4nYIVHhQVQaOBSYX6zFsnVUwrBGSWJ41jcgSM7nbM0YrF6Bs8dfpiFciGkNFCI1ufDMi/H98j2ETBqTmtgdM6GcwVlkmWfcRFrq3ntdGk+4BK4Ssf3BS82ypk/Giy+yle+nnSO4KlxcgKfrsXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758390983; c=relaxed/simple;
	bh=FK7kLDiEffyT/XanZXsXfVmS5aajDYBrU1p6ynRZnOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DhEiuOGLlLAcSTmL6NokUP+NViy95XTKmss3rdZ6zLpA3puVvDHVuAwx7z6D+sxfj1QVvHW0tjCLujKBDU2MeR9nOS0YRxQT8hwqP9mKh5u4MONV6pGouoDgDtvGaG7bKxtA4PH15VnUmUQSk9WUbZF3l/bpCF9kaKTJqDaN6rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NzyaS5lE; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NzyaS5lE"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-78de32583fbso15495136d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758390979; x=1758995779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCxLXd98m4lFSwfEfHBVYzTrRnPd5Uybb76jpfb6UN8=;
        b=NzyaS5lE7DU1JsBaSbdK10E88aUr5Ezjd2jsaDVxVc9tNCvvDso9Y2n6H8nVCMrS3x
         qY81IqlOKfMbnBDOhqwXacZQRLbW3GlMhhIPFMbdDkMpeELlgqxuk9mI3layCskuhFa9
         ZcauRqq0vu8xa8VTpNujk5FyCNaub2bvBXwJAjrNSuAKQwtl8zuX5NZdQ+ut/w7ZhjPw
         u8Z4fYCfdbAu5conPBLrAShNZwcRBkh+uNc+bcuhQRThETYogexqxKOUDH6UfB3993dS
         4CPLee/RaWzlNFqznZIP8aFyqSvrfNxk0WYWlM2qVmR1e5xBHhdIv9X/eBefDgNSUlZV
         xxAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758390979; x=1758995779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCxLXd98m4lFSwfEfHBVYzTrRnPd5Uybb76jpfb6UN8=;
        b=lDpZYlKvVWljeNnv62UJ19TQAPJ5btMIMgzZk9pO4wx0Jj+LRVQpG3sPpp1leu43LF
         Ys4IGDhEOoutzWH0Rd0uwdY9+7J7LeTxggHskdGBYIv7x0nmI4yTly9542MsxL3mJE3q
         rjK6n63jolnsiCvbXrdQX5kgnpVU/m97eitTKL9OLmYGg6Q5jC8osOxVOqH48vCRaQQP
         YX5wwbLIeiv0cJ5FrppBco7rzIYNySlpxwGR5vHlO3lR/CTj0yqqmH/tDOpgoaL4jVYL
         rUFrc8GRkh+TdAsV8DDWDFS4O19AAg92Fi1Paq0aZYRJeLbup5O58Fs8mehXi3IdfGcU
         O7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCUK1Y1w+GZxJAsy3TRr2wcRvkQqrrGWokqCXoaR2nLkGOVj6ewSjW6IALRXucUcwSQDMIqBMiRiGh6P@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5V20f5uGGpuojNk/LTibV7Pjrm5ChcuxG2D0S/Tu5yAuuL9Ev
	L5iWSnZo5mItLoI6edqeUk+aHxrgqVCHtAY6QpNcxs9kXkytGhyJWq9fT72bF2yoxoV0IDW3TO+
	bFJJeiaxx6whBEb7mvrhtVlBv1eI/Kq0=
X-Gm-Gg: ASbGncszU8pihJJoJE1KtEUiUxwUCAvKCr2d1BhT8S4QXEaMXhT6fACFaAfd6ccjVSt
	QIeslgeUebs0DI2kBmpyOldpiFMbGSZtm41ML0Iaw5u8AmdRr3jZ354EOtgOp/+rJBniTTeGQo9
	VU/iCtIBhm84QbM7YdXu/XrA4s5gu6OjtDEJj+sC28BEUZhd8lcWnoSTErIFpqK5pFYNt0fwOL9
	z95/f3LsA3ogLgrpxZOuPqDMzJ1sRLQgnMrKgQblKPWZvJINtppqoDw6OEauEbekaNsOmT2AT0V
	8fCov3TfF3Nje6JN0Zif7uAXXGiV+zMcmZDTLIBdj/vcf9i1c+sUC0od1cmJNtV1MARLSy14cfU
	sJTYBIsodaNu1ktEx41xj
X-Google-Smtp-Source: AGHT+IHlEhmS5nXRlniTKAogHw1PVHXoqPmKHtjzxu6Z/onc5CAqXarZRx4FWFgpC+2oUZWi4srFiXq6OfX5Tl1Wm38=
X-Received: by 2002:a05:6214:2264:b0:76c:7ff7:d8bd with SMTP id
 6a1803df08f44-799211da71fmr90049226d6.62.1758390979190; Sat, 20 Sep 2025
 10:56:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muRF1=H=acG2d0jVayW2fp0_V-5-0=Mx+8+VDRD-2oK4A@mail.gmail.com>
 <20250920173630.rjajntsu2sy72fys@pali> <CAH2r5muDLtJ1hFPmmuRydyh64ovU5Lg5z1WUhCrAo9iCEG33KQ@mail.gmail.com>
 <CAH2r5ms_ufxY-J+8rQ3X5zToe6aQv9B1ZorRuk86CAfW_VBzQw@mail.gmail.com> <20250920175108.6t45aw5d2dekplor@pali>
In-Reply-To: <20250920175108.6t45aw5d2dekplor@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:56:07 -0500
X-Gm-Features: AS18NWDbFYw2BG7pfH81MwmydEumH--dIS5jO_YA0GdkVj8jyC2STWm6MxJ1mA0
Message-ID: <CAH2r5mvX9rgen9JsesaT+CdBUJcbqcBesjc9jELT3pUNRKQc7g@mail.gmail.com>
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> "We can use tricks like marking file as hidden and silly rename to make
them less visible" --> This is exactly what is the whole patch series is
doing.

It wasn't at all clear looking at the 35 patches ... which fix
rename/delete cases for current (smb3.1.1) mounts on current mainline.
Would be helpful if a few simple test examples to show examples of
where current mainline fails to Windows or Samba or ksmbd or Azure
etc.   Even better is if you could show which xfstests that it fixes
that break with current mainline

On Sat, Sep 20, 2025 at 12:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> "We can use tricks like marking file as hidden and silly rename to make
> them less visible" --> This is exactly what is the whole patch series is
> doing.
>
> On Saturday 20 September 2025 12:40:14 Steve French wrote:
> > We can use tricks like marking file as hidden and silly rename to make
> > them less visible - but focus on the closest we can get to expected
> > Linux behavior
> >
> > On Sat, Sep 20, 2025 at 12:39=E2=80=AFPM Steve French <smfrench@gmail.c=
om> wrote:
> > >
> > > As long as we don't break any Linux apps - we need to return file not
> > > found or equivalent when a file is in delete pending in every path
> > > that we can (if we have some places that incorrectly show the file,
> > > the better solution is to hide it there, not to break more Linux apps
> > > by showing a file which has been deleted/silly-renamed
> > >
> > > On Sat, Sep 20, 2025 at 12:36=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel=
.org> wrote:
> > > >
> > > > The point is that the directory entry is not deleted yet. It is pre=
sent
> > > > in the readdir() output. For Linux apps the file not found should b=
e
> > > > returned when the directory entry disappear (from readdir()). I wro=
te
> > > > few test scenarios in cover letter of the patch series, which cover=
s
> > > > this.
> > > >
> > > > On Saturday 20 September 2025 12:14:00 Steve French wrote:
> > > > > This looks confusing, like it is wrong for Linux apps - when Linu=
x
> > > > > queries a file that is deleted (but still open by some other proc=
ess)
> > > > > it should get the equivalent of file not found or at least an err=
or -
> > > > > you aren't supposed to allow path based calls on a file which has=
 a
> > > > > pending delete or that would break Linux apps.
> > > > >
> > > > > On Sun, Aug 31, 2025 at 7:36=E2=80=AFAM Pali Roh=C3=A1r <pali@ker=
nel.org> wrote:
> > > > > >
> > > > > > Paths in DELETE_PENDING state cannot be opened at all. So stand=
ard way of
> > > > > > querying path attributes for this case is not possible.
> > > > > >
> > > > > > There is an alternative way how to query limited information ab=
out file
> > > > > > over SMB2+ dialects without opening file itself. It is by openi=
ng the
> > > > > > parent directory, querying specific child with filled search fi=
lter and
> > > > > > asking for attributes for that child.
> > > > > >
> > > > > > Implement this fallback when standard case in smb2_query_path_i=
nfo fails
> > > > > > with STATUS_DELETE_PENDING error and stat was asked for path wh=
ich is not
> > > > > > top level one (because top level does not have parent directory=
 at all).
> > > > > >
> > > > > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING t=
o -EBUSY".
> > > > > >
> > > > > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > > > > ---
> > > > > >  fs/smb/client/cifsglob.h  |   1 +
> > > > > >  fs/smb/client/smb2glob.h  |   1 +
> > > > > >  fs/smb/client/smb2inode.c | 177 ++++++++++++++++++++++++++++++=
+++++++-
> > > > > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > > > > >
> > > > > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.=
h
> > > > > > index e6830ab3a546..0ecf4988664e 100644
> > > > > > --- a/fs/smb/client/cifsglob.h
> > > > > > +++ b/fs/smb/client/cifsglob.h
> > > > > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > > > > >         struct smb_rqst rqst[MAX_COMPOUND];
> > > > > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > > > >         struct kvec qi_iov;
> > > > > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > > > > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > > > > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > > > > >         struct kvec close_iov;
> > > > > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.=
h
> > > > > > index 224495322a05..1cb219605e75 100644
> > > > > > --- a/fs/smb/client/smb2glob.h
> > > > > > +++ b/fs/smb/client/smb2glob.h
> > > > > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > > > > >         SMB2_OP_GET_REPARSE,
> > > > > >         SMB2_OP_QUERY_WSL_EA,
> > > > > >         SMB2_OP_OPEN_QUERY,
> > > > > > +       SMB2_OP_QUERY_DIRECTORY,
> > > > > >  };
> > > > > >
> > > > > >  /* Used when constructing chained read requests. */
> > > > > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inod=
e.c
> > > > > > index 2a0316c514e4..460e75614ef1 100644
> > > > > > --- a/fs/smb/client/smb2inode.c
> > > > > > +++ b/fs/smb/client/smb2inode.c
> > > > > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned =
int xid, struct cifs_tcon *tcon,
> > > > > >                             struct kvec *out_iov, int *out_buft=
ype, struct dentry *dentry)
> > > > > >  {
> > > > > >
> > > > > > +       bool has_cifs_mount_server_inum =3D cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_SERVER_INUM;
> > > > > > +       struct smb2_query_directory_req *qd_rqst =3D NULL;
> > > > > > +       struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> > > > > >         struct smb2_create_rsp *create_rsp =3D NULL;
> > > > > >         struct smb2_query_info_rsp *qi_rsp =3D NULL;
> > > > > >         struct smb2_compound_vars *vars =3D NULL;
> > > > > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned=
 int xid, struct cifs_tcon *tcon,
> > > > > >                         trace_smb3_posix_query_info_compound_en=
ter(xid, tcon->tid,
> > > > > >                                                                =
    ses->Suid, full_path);
> > > > > >                         break;
> > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > +                       rqst[num_rqst].rq_iov =3D &vars->qd_iov=
[0];
> > > > > > +                       rqst[num_rqst].rq_nvec =3D SMB2_QUERY_D=
IRECTORY_IOV_SIZE;
> > > > > > +
> > > > > > +                       rc =3D SMB2_query_directory_init(xid,
> > > > > > +                                                      tcon,
> > > > > > +                                                      server,
> > > > > > +                                                      &rqst[nu=
m_rqst],
> > > > > > +                                                      cfile ?
> > > > > > +                                                       cfile->=
fid.persistent_fid : COMPOUND_FID,
> > > > > > +                                                      cfile ?
> > > > > > +                                                       cfile->=
fid.volatile_fid : COMPOUND_FID,
> > > > > > +                                                      0,
> > > > > > +                                                      has_cifs=
_mount_server_inum ?
> > > > > > +                                                       SMB_FIN=
D_FILE_ID_FULL_DIR_INFO :
> > > > > > +                                                       SMB_FIN=
D_FILE_FULL_DIRECTORY_INFO);
> > > > > > +                       if (!rc) {
> > > > > > +                               /*
> > > > > > +                                * Change the default search wi=
ldcard pattern '*'
> > > > > > +                                * to the requested file name s=
tored in in_iov[i]
> > > > > > +                                * and request for only one sin=
gle entry.
> > > > > > +                                */
> > > > > > +                               qd_rqst =3D rqst[num_rqst].rq_i=
ov[0].iov_base;
> > > > > > +                               qd_rqst->Flags |=3D SMB2_RETURN=
_SINGLE_ENTRY;
> > > > > > +                               qd_rqst->FileNameLength =3D cpu=
_to_le16(in_iov[i].iov_len);
> > > > > > +                               rqst[num_rqst].rq_iov[1] =3D in=
_iov[i];
> > > > > > +                       }
> > > > > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > > > > +                               smb2_set_next_command(tcon, &rq=
st[num_rqst]);
> > > > > > +                               smb2_set_related(&rqst[num_rqst=
]);
> > > > > > +                       } else if (rc) {
> > > > > > +                               goto finished;
> > > > > > +                       }
> > > > > > +                       num_rqst++;
> > > > > > +                       break;
> > > > > >                 case SMB2_OP_DELETE:
> > > > > >                         trace_smb3_delete_enter(xid, tcon->tid,=
 ses->Suid, full_path);
> > > > > >                         break;
> > > > > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned=
 int xid, struct cifs_tcon *tcon,
> > > > > >                                 trace_smb3_posix_query_info_com=
pound_done(xid, tcon->tid,
> > > > > >                                                                =
           ses->Suid);
> > > > > >                         break;
> > > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > > +                       if (rc =3D=3D 0) {
> > > > > > +                               qd_rsp =3D (struct smb2_query_d=
irectory_rsp *)
> > > > > > +                                       rsp_iov[i + 1].iov_base=
;
> > > > > > +                               rc =3D smb2_validate_iov(le16_t=
o_cpu(qd_rsp->OutputBufferOffset),
> > > > > > +                                                      le32_to_=
cpu(qd_rsp->OutputBufferLength),
> > > > > > +                                                      &rsp_iov=
[i + 1],
> > > > > > +                                                      has_cifs=
_mount_server_inum ?
> > > > > > +                                                       sizeof(=
SEARCH_ID_FULL_DIR_INFO) :
> > > > > > +                                                       sizeof(=
FILE_FULL_DIRECTORY_INFO));
> > > > > > +                       }
> > > > > > +                       if (rc =3D=3D 0) {
> > > > > > +                               /*
> > > > > > +                                * Both SEARCH_ID_FULL_DIR_INFO=
 and FILE_FULL_DIRECTORY_INFO
> > > > > > +                                * have same member offsets exc=
ept the UniqueId and FileName.
> > > > > > +                                */
> > > > > > +                               SEARCH_ID_FULL_DIR_INFO *si =3D
> > > > > > +                                       (SEARCH_ID_FULL_DIR_INF=
O *)qd_rsp->Buffer;
> > > > > > +
> > > > > > +                               idata =3D in_iov[i + 1].iov_bas=
e;
> > > > > > +                               idata->fi.CreationTime =3D si->=
CreationTime;
> > > > > > +                               idata->fi.LastAccessTime =3D si=
->LastAccessTime;
> > > > > > +                               idata->fi.LastWriteTime =3D si-=
>LastWriteTime;
> > > > > > +                               idata->fi.ChangeTime =3D si->Ch=
angeTime;
> > > > > > +                               idata->fi.Attributes =3D si->Ex=
tFileAttributes;
> > > > > > +                               idata->fi.AllocationSize =3D si=
->AllocationSize;
> > > > > > +                               idata->fi.EndOfFile =3D si->End=
OfFile;
> > > > > > +                               idata->fi.EASize =3D si->EaSize=
;
> > > > > > +                               idata->fi.Directory =3D
> > > > > > +                                       !!(le32_to_cpu(si->ExtF=
ileAttributes) & ATTR_DIRECTORY);
> > > > > > +                               /*
> > > > > > +                                * UniqueId is present only in =
struct SEARCH_ID_FULL_DIR_INFO.
> > > > > > +                                * It is not present in struct =
FILE_FULL_DIRECTORY_INFO.
> > > > > > +                                * struct SEARCH_ID_FULL_DIR_IN=
FO was requested only when
> > > > > > +                                * CIFS_MOUNT_SERVER_INUM is se=
t.
> > > > > > +                                */
> > > > > > +                               if (has_cifs_mount_server_inum)
> > > > > > +                                       idata->fi.IndexNumber =
=3D si->UniqueId;
> > > > > > +                               /*
> > > > > > +                                * Do not change idata->fi.Numb=
erOfLinks to correctly
> > > > > > +                                * trigger the CIFS_FATTR_UNKNO=
WN_NLINK flag.
> > > > > > +                                */
> > > > > > +                               /*
> > > > > > +                                * Do not change idata->fi.Dele=
tePending as we do not know if
> > > > > > +                                * the entry is in the delete p=
ending state. SMB2 QUERY_DIRECTORY
> > > > > > +                                * at any level does not provid=
e this information.
> > > > > > +                                */
> > > > > > +                       }
> > > > > > +                       SMB2_query_directory_free(&rqst[num_rqs=
t++]);
> > > > > > +                       if (rc)
> > > > > > +                               trace_smb3_query_dir_err(xid,
> > > > > > +                                       cfile ? cfile->fid.pers=
istent_fid : COMPOUND_FID,
> > > > > > +                                       tcon->tid, ses->Suid, 0=
, 0, rc);
> > > > > > +                       else
> > > > > > +                               trace_smb3_query_dir_done(xid,
> > > > > > +                                       cfile ? cfile->fid.pers=
istent_fid : COMPOUND_FID,
> > > > > > +                                       tcon->tid, ses->Suid, 0=
, 0);
> > > > > > +                       break;
> > > > > >                 case SMB2_OP_DELETE:
> > > > > >                         if (rc)
> > > > > >                                 trace_smb3_delete_err(xid, tcon=
->tid, ses->Suid, rc);
> > > > > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned i=
nt xid,
> > > > > >                 break;
> > > > > >         case -EREMOTE:
> > > > > >                 break;
> > > > > > -       default:
> > > > > > -               if (hdr->Status !=3D STATUS_OBJECT_NAME_INVALID=
)
> > > > > > -                       break;
> > > > > > +       }
> > > > > > +
> > > > > > +       if (hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALID) {
> > > > > >                 rc2 =3D cifs_inval_name_dfs_link_error(xid, tco=
n, cifs_sb,
> > > > > >                                                      full_path,=
 &islink);
> > > > > >                 if (rc2) {
> > > > > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned =
int xid,
> > > > > >                 }
> > > > > >                 if (islink)
> > > > > >                         rc =3D -EREMOTE;
> > > > > > +       } else if (hdr->Status =3D=3D STATUS_DELETE_PENDING && =
full_path[0]) {
> > > > > > +               /*
> > > > > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE=
_PENDING error,
> > > > > > +                * it means that the path is in delete pending =
state and it is
> > > > > > +                * not possible to open it until some other cli=
ent clears delete
> > > > > > +                * pending state or all other clients close all=
 opened handles
> > > > > > +                * to that path.
> > > > > > +                *
> > > > > > +                * There is an alternative way how to query lim=
ited information
> > > > > > +                * about path which is in delete pending state =
still suitable
> > > > > > +                * for the stat() syscall. It is by opening the=
 parent directory,
> > > > > > +                * querying specific child with filled search f=
iler and asking
> > > > > > +                * for attributes for that child.
> > > > > > +                */
> > > > > > +
> > > > > > +               char *parent_path;
> > > > > > +               const char *basename;
> > > > > > +               __le16 *basename_utf16;
> > > > > > +               int basename_utf16_len;
> > > > > > +               struct cifsFileInfo *parent_cfile;
> > > > > > +
> > > > > > +               basename =3D strrchr(full_path, CIFS_DIR_SEP(ci=
fs_sb));
> > > > > > +               if (basename) {
> > > > > > +                       parent_path =3D kstrndup(full_path, bas=
ename - full_path, GFP_KERNEL);
> > > > > > +                       basename++;
> > > > > > +               } else {
> > > > > > +                       parent_path =3D kstrdup("", GFP_KERNEL)=
;
> > > > > > +                       basename =3D full_path;
> > > > > > +               }
> > > > > > +
> > > > > > +               if (!parent_path) {
> > > > > > +                       rc =3D -ENOMEM;
> > > > > > +                       goto out;
> > > > > > +               }
> > > > > > +
> > > > > > +               basename_utf16 =3D cifs_convert_path_to_utf16(b=
asename, cifs_sb);
> > > > > > +               if (!basename_utf16) {
> > > > > > +                       kfree(parent_path);
> > > > > > +                       rc =3D -ENOMEM;
> > > > > > +                       goto out;
> > > > > > +               }
> > > > > > +
> > > > > > +               basename_utf16_len =3D 2 * UniStrnlen((wchar_t =
*)basename_utf16, PATH_MAX);
> > > > > > +
> > > > > > +retry_query_directory:
> > > > > > +               num_cmds =3D 1;
> > > > > > +               cmds[0] =3D SMB2_OP_QUERY_DIRECTORY;
> > > > > > +               in_iov[0].iov_base =3D basename_utf16;
> > > > > > +               in_iov[0].iov_len =3D basename_utf16_len;
> > > > > > +               in_iov[1].iov_base =3D data;
> > > > > > +               in_iov[1].iov_len =3D sizeof(*data);
> > > > > > +               oparms =3D CIFS_OPARMS(cifs_sb, tcon, parent_pa=
th, FILE_READ_DATA,
> > > > > > +                                    FILE_OPEN, CREATE_NOT_FILE=
, ACL_NO_MODE);
> > > > > > +               cifs_get_readable_path(tcon, parent_path, &pare=
nt_cfile);
> > > > > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(o=
ut_iov));
> > > > > > +               rc =3D smb2_compound_op(xid, tcon, cifs_sb, par=
ent_path,
> > > > > > +                                     &oparms, in_iov, cmds, nu=
m_cmds,
> > > > > > +                                     parent_cfile, out_iov, ou=
t_buftype, NULL);
> > > > > > +               if (rc =3D=3D -EOPNOTSUPP && (cifs_sb->mnt_cifs=
_flags & CIFS_MOUNT_SERVER_INUM)) {
> > > > > > +                       /*
> > > > > > +                        * If querying of server inode numbers =
is not supported
> > > > > > +                        * but is enabled, then disable it and =
try again.
> > > > > > +                        */
> > > > > > +                       cifs_autodisable_serverino(cifs_sb);
> > > > > > +                       goto retry_query_directory;
> > > > > > +               }
> > > > > > +
> > > > > > +               kfree(parent_path);
> > > > > > +               kfree(basename_utf16);
> > > > > > +
> > > > > > +               hdr =3D out_iov[0].iov_base;
> > > > > > +               if (!hdr || out_buftype[0] =3D=3D CIFS_NO_BUFFE=
R)
> > > > > > +                       goto out;
> > > > > > +
> > > > > > +               data->fi.DeletePending =3D 1; /* This is code p=
ath for STATUS_DELETE_PENDING. */
> > > > > >         }
> > > > > >
> > > > > >  out:
> > > > > > --
> > > > > > 2.20.1
> > > > > >
> > > > > >
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB75F9EC
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758391468; cv=none; b=C49wa42NsdRSshxTI2LP7SMUmIWegeHpYyP2knA3EcuNcyv1o1i/vW7+rmAfpj/y9vDJt3zZxKLiUpGhrQva38a6Sj15HZdTSUpJbK02YXh9BX1WIvs4Mw+ZC9KtqgwhEXzbunIhYiig2Is+qctbZaP35vQN7BhvEC6Jc8nxV+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758391468; c=relaxed/simple;
	bh=AjlGtvt1y4UVmipW7Gq9aCb5NVl/vrus1BiUcotHPOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nI7QJVk/Ev5k+mI0D5TzD1VjfQBWce7s9ccGmIGP/S/S9DEACkIrJa8IZfxWBy2cdiD2B7JXIQ6Gq5JU0QLRqhLPApyNdQEie0Wbg1T283rakOmMi+HFqQ99PUGEO8te3aw2QTsuksW9bgOc6bx9lpvQ4dS2vXr85d0EtziqFMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7muQLb4; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7muQLb4"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-795773ac2a2so26634216d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 11:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758391465; x=1758996265; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ahe1D4nmjHxbCnfxk3Wu6xHxdTJqyy5fZIn5PS21wk=;
        b=H7muQLb4ozfueSveLlWfQS0zw9BcUvdpi2gxkEfmVqQFH6ijpZtNkJZfx2ZeApHZ0F
         Nekrk18ihuxJqEGO9ZXsAwcFyWvjr4KopoZmG1/fF/9B6sacYn+9pYZj84q5rGRb9ooR
         uhvtUD2nXHtffe2hG9/HImiv+/GBn8wfevEzuKQD+c7/sJHu/6bETwga43OfwFBCTSui
         Cl826fyaC3hJtLkRdkHDEkfgeCWeX3faUosm7Vk+3r+pbfkYsr47Muyurs6/6v+TGQCy
         ZRJLkZYvDQbM6bj+CgCZ5SJWi1zmriLUIwBmY/wreL1ChAvAq79e5Hn25nBW3fhy1cBK
         ecIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758391465; x=1758996265;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ahe1D4nmjHxbCnfxk3Wu6xHxdTJqyy5fZIn5PS21wk=;
        b=UR9lVlc/DSTyTZAiQFFA15MwzdQAUcgz00UcOVJH5NbQ+aainPRVDWeyoBCDxXg7p7
         F077EikyU/cKRirDZpDvBkhtEdwB+w3huxy7A80dRK8H1YdAHoN4RaK7YumKbkTmpDKZ
         MCUFGO+JrFIjIV+mo7xGAC1B2G5W1oFrBFPvss7+O/RjlQwsZEYGQ0bxWnpwPssa0fo8
         hKes5m4HHq5LFDAzbl7/TdywpfMQE9sD5TSurNzkQuOrUAoPZ4bKd1YmhZHb5xU7RJTf
         BJTlFcES7ie69m+K+IIhhM5TOljFX5F47IXsAOnqwPuW4mrCLbc6XjigiTbYKYe1EDSE
         awqw==
X-Forwarded-Encrypted: i=1; AJvYcCXbzx/CLmBX6lHFfG87azDJcxK4EnTSuzPYrz5RUqgSIae1quYiWGsLI8qGgvASr/D73zXmJVEu8QpD@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7EoLkkYBJ3MyIVl6hTFljVu0LgvV3zE9ziqc7lo7qOmXhtm6c
	ucMbR8MFIvFQc6cW7sOJIZRD5D5apGnrz4toPQLWtR3uvNEfZvuO8yUfVFQxAOB3mzA3/0eXaFu
	GORAQq6u3ordJmTXIJL0sFcr/xWieCAOrE5Fh
X-Gm-Gg: ASbGncsFoGH3Ag2G6SageZ52MAa044X5LZ5quesyqjXNJfr8DMQGexJgRfSpPVK1vFF
	yZnY/FKtyAYQNnTyaFiaXelRmmFQ7i2N6Op6rjy1KpRNidqqjFHreDpSBaOBHbSI7xRHX4KHY7L
	9m33PzgGM/VJqJcjUBQ2iixdtw7pbGyEgIj0+ihBty3VhJvb/TafM/5jGg4eLuZcCCv2PWpj8XY
	lQfxxIV/c/sta9KiZWXC2sfwCxnEOub6o9zWyHiGIKyQjdx+3fHVOxlp0mQxbh2Rdqn/MOJXH9x
	O+hgmHrqYkcXRHkb3YMJdnsw+70aDH9in0E8kFgS8rlXCEL/Ypk3IS4zfHTRMJeHP8hm9FIMVF9
	Df5euk2sSEDHd+K1WvdrA
X-Google-Smtp-Source: AGHT+IEjtAdkfYbz/Zy3e6l/xSw29MPGNV32tgcdPVw2p3hXWRxlvVsmHAhVkVkCL4q/cusnQ8BhMqkVlxdky5LIIiM=
X-Received: by 2002:ad4:4eee:0:b0:7a6:20fe:298d with SMTP id
 6a1803df08f44-7a620fe3bd5mr41376516d6.39.1758391465124; Sat, 20 Sep 2025
 11:04:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muVP5NuZFfsCWDYhCKATDyeaD2cpXgC3=zNh+3T_zO1Mg@mail.gmail.com>
 <20250920174217.h5neq5yllnbvgn5a@pali> <CAH2r5msWy9K04gMAQhfxsV-_TVhkTWL--oOGy_aQ78HCuibR0g@mail.gmail.com>
 <20250920180024.qo5m2oiniiwrxxyw@pali>
In-Reply-To: <20250920180024.qo5m2oiniiwrxxyw@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 13:04:13 -0500
X-Gm-Features: AS18NWAW9hrqrddAPrHcpDwr33JIQZ8OIHdfotx9p84jmvgYtMRKY9kZ6sZ6z9w
Message-ID: <CAH2r5mvVpUY5T+qNhHMnub1ktiwhgUjr3ZfyL7UCMyiO_Ay9mw@mail.gmail.com>
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> The last changes which enable silly rename

There were LOTS of good discussions about silly rename at the test
event last week (and what other FS do and what Apple client does etc.)
and some testing of it, but would be helpful to know which scenarios
your silly rename changes fix (example tests) that don't work with
current mainline (and as mentioned earlier even better if this fixes
an industry standard test, like one of xfstests - still plenty of
those to fix)

On Sat, Sep 20, 2025 at 1:00=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Reordering is very problematic. Majority of patches depends on previous
> patches, that is why I sent them in a patch series to make it visible
> in which order they needs to be applied.
>
> I tried to avoid sending "one big change". So I split that my one big
> change into lot of smaller (even that they depend each on other) to make
> it easier to review. And the result is this patch series.
>
> The last changes which enable silly rename depends on the implementation
> in all previous changes in this patch series, so basically this patch
> series should be treated as fixing one unlink/rmdir feature.
>
> There are also smb1 change, but majority of them is related to silly
> rename which as explained in commit message is smb1-only and after this
> patch series, code is modified and reused also for smb3.
>
> On Saturday 20 September 2025 12:48:45 Steve French wrote:
> > Also would be helpful to reorder these in order by importance. Prioriti=
ze:
> > 1) those fixes that are useful for current mounts (e.g. smb3.1.1 or
> > smb3) and matter for servers that are still commonly used (obviously
> > SMB1 fixes are low priority, unless small and obvious fixes)
> > 2) those that fix bugs that can be shown with simple test script
> > 3) those that improve "best effort" Linux semantics
> > 4) those that are large and hard to review are prioritized lower
> >
> > On Sat, Sep 20, 2025 at 12:42=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.o=
rg> wrote:
> > >
> > > Commits in this patch series needs to be applied in the order.
> > > So this patch does not apply without the previous dependent. It would
> > > not apply alone.
> > >
> > > I sent this patch series about month ago, so maybe the patch series
> > > needs to be rebased, I can look at it in next days.
> > >
> > > On Saturday 20 September 2025 12:26:40 Steve French wrote:
> > > > This patch doesn't apply to current mainline - can you update it?
> > > >
> > > > On Sun, Aug 31, 2025 at 7:36=E2=80=AFAM Pali Roh=C3=A1r <pali@kerne=
l.org> wrote:
> > > > >
> > > > > Paths in DELETE_PENDING state cannot be opened at all. So standar=
d way of
> > > > > querying path attributes for this case is not possible.
> > > > >
> > > > > There is an alternative way how to query limited information abou=
t file
> > > > > over SMB2+ dialects without opening file itself. It is by opening=
 the
> > > > > parent directory, querying specific child with filled search filt=
er and
> > > > > asking for attributes for that child.
> > > > >
> > > > > Implement this fallback when standard case in smb2_query_path_inf=
o fails
> > > > > with STATUS_DELETE_PENDING error and stat was asked for path whic=
h is not
> > > > > top level one (because top level does not have parent directory a=
t all).
> > > > >
> > > > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING to =
-EBUSY".
> > > > >
> > > > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > > > ---
> > > > >  fs/smb/client/cifsglob.h  |   1 +
> > > > >  fs/smb/client/smb2glob.h  |   1 +
> > > > >  fs/smb/client/smb2inode.c | 177 ++++++++++++++++++++++++++++++++=
+++++-
> > > > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > > > >
> > > > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > > > index e6830ab3a546..0ecf4988664e 100644
> > > > > --- a/fs/smb/client/cifsglob.h
> > > > > +++ b/fs/smb/client/cifsglob.h
> > > > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > > > >         struct smb_rqst rqst[MAX_COMPOUND];
> > > > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > > >         struct kvec qi_iov;
> > > > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > > > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > > > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > > > >         struct kvec close_iov;
> > > > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> > > > > index 224495322a05..1cb219605e75 100644
> > > > > --- a/fs/smb/client/smb2glob.h
> > > > > +++ b/fs/smb/client/smb2glob.h
> > > > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > > > >         SMB2_OP_GET_REPARSE,
> > > > >         SMB2_OP_QUERY_WSL_EA,
> > > > >         SMB2_OP_OPEN_QUERY,
> > > > > +       SMB2_OP_QUERY_DIRECTORY,
> > > > >  };
> > > > >
> > > > >  /* Used when constructing chained read requests. */
> > > > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.=
c
> > > > > index 2a0316c514e4..460e75614ef1 100644
> > > > > --- a/fs/smb/client/smb2inode.c
> > > > > +++ b/fs/smb/client/smb2inode.c
> > > > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned in=
t xid, struct cifs_tcon *tcon,
> > > > >                             struct kvec *out_iov, int *out_buftyp=
e, struct dentry *dentry)
> > > > >  {
> > > > >
> > > > > +       bool has_cifs_mount_server_inum =3D cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_SERVER_INUM;
> > > > > +       struct smb2_query_directory_req *qd_rqst =3D NULL;
> > > > > +       struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> > > > >         struct smb2_create_rsp *create_rsp =3D NULL;
> > > > >         struct smb2_query_info_rsp *qi_rsp =3D NULL;
> > > > >         struct smb2_compound_vars *vars =3D NULL;
> > > > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned i=
nt xid, struct cifs_tcon *tcon,
> > > > >                         trace_smb3_posix_query_info_compound_ente=
r(xid, tcon->tid,
> > > > >                                                                  =
  ses->Suid, full_path);
> > > > >                         break;
> > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > +                       rqst[num_rqst].rq_iov =3D &vars->qd_iov[0=
];
> > > > > +                       rqst[num_rqst].rq_nvec =3D SMB2_QUERY_DIR=
ECTORY_IOV_SIZE;
> > > > > +
> > > > > +                       rc =3D SMB2_query_directory_init(xid,
> > > > > +                                                      tcon,
> > > > > +                                                      server,
> > > > > +                                                      &rqst[num_=
rqst],
> > > > > +                                                      cfile ?
> > > > > +                                                       cfile->fi=
d.persistent_fid : COMPOUND_FID,
> > > > > +                                                      cfile ?
> > > > > +                                                       cfile->fi=
d.volatile_fid : COMPOUND_FID,
> > > > > +                                                      0,
> > > > > +                                                      has_cifs_m=
ount_server_inum ?
> > > > > +                                                       SMB_FIND_=
FILE_ID_FULL_DIR_INFO :
> > > > > +                                                       SMB_FIND_=
FILE_FULL_DIRECTORY_INFO);
> > > > > +                       if (!rc) {
> > > > > +                               /*
> > > > > +                                * Change the default search wild=
card pattern '*'
> > > > > +                                * to the requested file name sto=
red in in_iov[i]
> > > > > +                                * and request for only one singl=
e entry.
> > > > > +                                */
> > > > > +                               qd_rqst =3D rqst[num_rqst].rq_iov=
[0].iov_base;
> > > > > +                               qd_rqst->Flags |=3D SMB2_RETURN_S=
INGLE_ENTRY;
> > > > > +                               qd_rqst->FileNameLength =3D cpu_t=
o_le16(in_iov[i].iov_len);
> > > > > +                               rqst[num_rqst].rq_iov[1] =3D in_i=
ov[i];
> > > > > +                       }
> > > > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > > > +                               smb2_set_next_command(tcon, &rqst=
[num_rqst]);
> > > > > +                               smb2_set_related(&rqst[num_rqst])=
;
> > > > > +                       } else if (rc) {
> > > > > +                               goto finished;
> > > > > +                       }
> > > > > +                       num_rqst++;
> > > > > +                       break;
> > > > >                 case SMB2_OP_DELETE:
> > > > >                         trace_smb3_delete_enter(xid, tcon->tid, s=
es->Suid, full_path);
> > > > >                         break;
> > > > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned i=
nt xid, struct cifs_tcon *tcon,
> > > > >                                 trace_smb3_posix_query_info_compo=
und_done(xid, tcon->tid,
> > > > >                                                                  =
         ses->Suid);
> > > > >                         break;
> > > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > > +                       if (rc =3D=3D 0) {
> > > > > +                               qd_rsp =3D (struct smb2_query_dir=
ectory_rsp *)
> > > > > +                                       rsp_iov[i + 1].iov_base;
> > > > > +                               rc =3D smb2_validate_iov(le16_to_=
cpu(qd_rsp->OutputBufferOffset),
> > > > > +                                                      le32_to_cp=
u(qd_rsp->OutputBufferLength),
> > > > > +                                                      &rsp_iov[i=
 + 1],
> > > > > +                                                      has_cifs_m=
ount_server_inum ?
> > > > > +                                                       sizeof(SE=
ARCH_ID_FULL_DIR_INFO) :
> > > > > +                                                       sizeof(FI=
LE_FULL_DIRECTORY_INFO));
> > > > > +                       }
> > > > > +                       if (rc =3D=3D 0) {
> > > > > +                               /*
> > > > > +                                * Both SEARCH_ID_FULL_DIR_INFO a=
nd FILE_FULL_DIRECTORY_INFO
> > > > > +                                * have same member offsets excep=
t the UniqueId and FileName.
> > > > > +                                */
> > > > > +                               SEARCH_ID_FULL_DIR_INFO *si =3D
> > > > > +                                       (SEARCH_ID_FULL_DIR_INFO =
*)qd_rsp->Buffer;
> > > > > +
> > > > > +                               idata =3D in_iov[i + 1].iov_base;
> > > > > +                               idata->fi.CreationTime =3D si->Cr=
eationTime;
> > > > > +                               idata->fi.LastAccessTime =3D si->=
LastAccessTime;
> > > > > +                               idata->fi.LastWriteTime =3D si->L=
astWriteTime;
> > > > > +                               idata->fi.ChangeTime =3D si->Chan=
geTime;
> > > > > +                               idata->fi.Attributes =3D si->ExtF=
ileAttributes;
> > > > > +                               idata->fi.AllocationSize =3D si->=
AllocationSize;
> > > > > +                               idata->fi.EndOfFile =3D si->EndOf=
File;
> > > > > +                               idata->fi.EASize =3D si->EaSize;
> > > > > +                               idata->fi.Directory =3D
> > > > > +                                       !!(le32_to_cpu(si->ExtFil=
eAttributes) & ATTR_DIRECTORY);
> > > > > +                               /*
> > > > > +                                * UniqueId is present only in st=
ruct SEARCH_ID_FULL_DIR_INFO.
> > > > > +                                * It is not present in struct FI=
LE_FULL_DIRECTORY_INFO.
> > > > > +                                * struct SEARCH_ID_FULL_DIR_INFO=
 was requested only when
> > > > > +                                * CIFS_MOUNT_SERVER_INUM is set.
> > > > > +                                */
> > > > > +                               if (has_cifs_mount_server_inum)
> > > > > +                                       idata->fi.IndexNumber =3D=
 si->UniqueId;
> > > > > +                               /*
> > > > > +                                * Do not change idata->fi.Number=
OfLinks to correctly
> > > > > +                                * trigger the CIFS_FATTR_UNKNOWN=
_NLINK flag.
> > > > > +                                */
> > > > > +                               /*
> > > > > +                                * Do not change idata->fi.Delete=
Pending as we do not know if
> > > > > +                                * the entry is in the delete pen=
ding state. SMB2 QUERY_DIRECTORY
> > > > > +                                * at any level does not provide =
this information.
> > > > > +                                */
> > > > > +                       }
> > > > > +                       SMB2_query_directory_free(&rqst[num_rqst+=
+]);
> > > > > +                       if (rc)
> > > > > +                               trace_smb3_query_dir_err(xid,
> > > > > +                                       cfile ? cfile->fid.persis=
tent_fid : COMPOUND_FID,
> > > > > +                                       tcon->tid, ses->Suid, 0, =
0, rc);
> > > > > +                       else
> > > > > +                               trace_smb3_query_dir_done(xid,
> > > > > +                                       cfile ? cfile->fid.persis=
tent_fid : COMPOUND_FID,
> > > > > +                                       tcon->tid, ses->Suid, 0, =
0);
> > > > > +                       break;
> > > > >                 case SMB2_OP_DELETE:
> > > > >                         if (rc)
> > > > >                                 trace_smb3_delete_err(xid, tcon->=
tid, ses->Suid, rc);
> > > > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned int=
 xid,
> > > > >                 break;
> > > > >         case -EREMOTE:
> > > > >                 break;
> > > > > -       default:
> > > > > -               if (hdr->Status !=3D STATUS_OBJECT_NAME_INVALID)
> > > > > -                       break;
> > > > > +       }
> > > > > +
> > > > > +       if (hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALID) {
> > > > >                 rc2 =3D cifs_inval_name_dfs_link_error(xid, tcon,=
 cifs_sb,
> > > > >                                                      full_path, &=
islink);
> > > > >                 if (rc2) {
> > > > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned in=
t xid,
> > > > >                 }
> > > > >                 if (islink)
> > > > >                         rc =3D -EREMOTE;
> > > > > +       } else if (hdr->Status =3D=3D STATUS_DELETE_PENDING && fu=
ll_path[0]) {
> > > > > +               /*
> > > > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE_P=
ENDING error,
> > > > > +                * it means that the path is in delete pending st=
ate and it is
> > > > > +                * not possible to open it until some other clien=
t clears delete
> > > > > +                * pending state or all other clients close all o=
pened handles
> > > > > +                * to that path.
> > > > > +                *
> > > > > +                * There is an alternative way how to query limit=
ed information
> > > > > +                * about path which is in delete pending state st=
ill suitable
> > > > > +                * for the stat() syscall. It is by opening the p=
arent directory,
> > > > > +                * querying specific child with filled search fil=
er and asking
> > > > > +                * for attributes for that child.
> > > > > +                */
> > > > > +
> > > > > +               char *parent_path;
> > > > > +               const char *basename;
> > > > > +               __le16 *basename_utf16;
> > > > > +               int basename_utf16_len;
> > > > > +               struct cifsFileInfo *parent_cfile;
> > > > > +
> > > > > +               basename =3D strrchr(full_path, CIFS_DIR_SEP(cifs=
_sb));
> > > > > +               if (basename) {
> > > > > +                       parent_path =3D kstrndup(full_path, basen=
ame - full_path, GFP_KERNEL);
> > > > > +                       basename++;
> > > > > +               } else {
> > > > > +                       parent_path =3D kstrdup("", GFP_KERNEL);
> > > > > +                       basename =3D full_path;
> > > > > +               }
> > > > > +
> > > > > +               if (!parent_path) {
> > > > > +                       rc =3D -ENOMEM;
> > > > > +                       goto out;
> > > > > +               }
> > > > > +
> > > > > +               basename_utf16 =3D cifs_convert_path_to_utf16(bas=
ename, cifs_sb);
> > > > > +               if (!basename_utf16) {
> > > > > +                       kfree(parent_path);
> > > > > +                       rc =3D -ENOMEM;
> > > > > +                       goto out;
> > > > > +               }
> > > > > +
> > > > > +               basename_utf16_len =3D 2 * UniStrnlen((wchar_t *)=
basename_utf16, PATH_MAX);
> > > > > +
> > > > > +retry_query_directory:
> > > > > +               num_cmds =3D 1;
> > > > > +               cmds[0] =3D SMB2_OP_QUERY_DIRECTORY;
> > > > > +               in_iov[0].iov_base =3D basename_utf16;
> > > > > +               in_iov[0].iov_len =3D basename_utf16_len;
> > > > > +               in_iov[1].iov_base =3D data;
> > > > > +               in_iov[1].iov_len =3D sizeof(*data);
> > > > > +               oparms =3D CIFS_OPARMS(cifs_sb, tcon, parent_path=
, FILE_READ_DATA,
> > > > > +                                    FILE_OPEN, CREATE_NOT_FILE, =
ACL_NO_MODE);
> > > > > +               cifs_get_readable_path(tcon, parent_path, &parent=
_cfile);
> > > > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out=
_iov));
> > > > > +               rc =3D smb2_compound_op(xid, tcon, cifs_sb, paren=
t_path,
> > > > > +                                     &oparms, in_iov, cmds, num_=
cmds,
> > > > > +                                     parent_cfile, out_iov, out_=
buftype, NULL);
> > > > > +               if (rc =3D=3D -EOPNOTSUPP && (cifs_sb->mnt_cifs_f=
lags & CIFS_MOUNT_SERVER_INUM)) {
> > > > > +                       /*
> > > > > +                        * If querying of server inode numbers is=
 not supported
> > > > > +                        * but is enabled, then disable it and tr=
y again.
> > > > > +                        */
> > > > > +                       cifs_autodisable_serverino(cifs_sb);
> > > > > +                       goto retry_query_directory;
> > > > > +               }
> > > > > +
> > > > > +               kfree(parent_path);
> > > > > +               kfree(basename_utf16);
> > > > > +
> > > > > +               hdr =3D out_iov[0].iov_base;
> > > > > +               if (!hdr || out_buftype[0] =3D=3D CIFS_NO_BUFFER)
> > > > > +                       goto out;
> > > > > +
> > > > > +               data->fi.DeletePending =3D 1; /* This is code pat=
h for STATUS_DELETE_PENDING. */
> > > > >         }
> > > > >
> > > > >  out:
> > > > > --
> > > > > 2.20.1
> > > > >
> > > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
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

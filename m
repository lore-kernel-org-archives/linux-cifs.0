Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B767D205ABA
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758389968; cv=none; b=mJOzYysO0zGGa/a+RBAQ0O/Ovkjp0UHN9ereRVnI3SlnAOkFUd/r2zvOLFlxVD5ytP2dgHGaYpPdqo7AbwyRSo1wOPVfQeZy69qO/d8XW5k+PdYJqJu2msRC7qRuNNCyA+H8A5d9CGIhfTiip8nWZIhkr2FQwtFDXjfqGbDqZes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758389968; c=relaxed/simple;
	bh=z5Pq0afyIEvYkit+MGSVHf3Trj3bLK+hL7rVNFDwrbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QaufH0QrXoq76F4XtfHVrob7juXvi+u39treW83vw3WglQaYDZtYe5Jjb1LvdJR+Qdg/zpOKm+dKzLlHGZ4t4XwAxr+LR0bsdYgmbJuYXrS3vvLU2CCbQ3ekyOuNoHFRuHrQPjgohMvDa70adoaiDfTRg+67uOESdMK+07ZnkJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtV6JYRV; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtV6JYRV"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-7970e8d1cfeso29771276d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758389965; x=1758994765; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7l7XjLjUH5qyMPAKGLG0RH5Y9ADSxEqmgVlomS7WjQ=;
        b=XtV6JYRVdjYeuBdpdQLGCJMPrgxaZQ/QS+no3pcODo1cEcIDBeskcJ79T8q2jxBZaX
         QKyEPpiAAbkftLfj6IoSO+nAvofLDudFjBMmghgmxVlgu67psqffNoGtWRgQAbZjxL8b
         t9flbpVn+lGWmVa0yHS/7vBOJ2Y11kDQs/HZC3El4RtYJVZToAJ+Cszk7j23T+UFWt4Q
         a7Whvkp/cayl86wQ22+WTVLvgM5dPjkdYcyqVWrpjtIHXVyYAl+E95rlG1BILW0jebnP
         7H4UEWdsZpbQNShX2GPir5gQ028tJ0hG9fEt951uIa9rH5saDzY6q0T60uuVNS8MyqW/
         TDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758389965; x=1758994765;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7l7XjLjUH5qyMPAKGLG0RH5Y9ADSxEqmgVlomS7WjQ=;
        b=GJ7WkYA41Wy6/ww2ptGQiD2W3XrK8uJ62rQwCe2+UDScCj2xM8Jag97Yi1snDUMJlN
         a3ChS4GnaMEIvR5GQSGbNCaOS1KYK1q6ACJNwyq81EWM8YJOiIfWBl9wGHkE8fspHaVX
         9LwnTyIpjexq1vSDcVOSAN8lQrK1w2Qb26pSN0pPT6imN3LCPG/H2y2RqtStzRyoz6ZZ
         kj/LE4yuJf/JgWGsGreF802c7mZixnorMt+ap489dNOZAalVn2LT7zBMrUFRXngMX9yS
         LiJikHBV9bK71TpOxYJwII8VJMC32tg7j69FVHP/bbv6NB2tRJ74NJ766fi7KGJD1sWW
         LRnw==
X-Forwarded-Encrypted: i=1; AJvYcCUpEzjIcSXh9Pxe2KEall2/pYXxpTYIj4oN8RRhr5BwJcZYh1wv/Jj4AsIQ+JSL9ifxACFkqXedZXdv@vger.kernel.org
X-Gm-Message-State: AOJu0YxAg0BsKU0EOSNd5BtzaynCnDpKc+020gw3wm5kh+lzpaE9W5M4
	FeSRQV5vE3V/8C4FnMJvJ8eTVeDZRKJAR9Dtf9QE1jo/x7+lB6HJVATYsd2VeCyKlGnXj4KY75Q
	zmFwKRjbJ7sXxyzwkY6Gqtg7AboRckgI=
X-Gm-Gg: ASbGncsGZcZyqvqUt4grQ4enmTmkuh1ARCju3RJ7ZnUv1MN9Gtz35j3ekCDsIDd5Y6/
	nZJaBsAoV7X3fK+9c+w4cTlzPjIczSX1/Okfab7gtUvvVazeF5unKgOnmo7GeQUr052q9MxdwP0
	dVBkZDmBxmtnjHjOsRQR4Z9ezobQdIArbXGl79k24XmHGdSe6VgHEtGxyJq7cBu9usuf2rtsswT
	wDM6xKK1UanA+aHYdIyHxUFhr6kcJ/cjmYHB4BlptvJluexAtxLiQLugqFtmwRxQsAvMuTQEk1R
	PE19zQhq23l3Atz//4Q1HdTy3oZ/bJIBjaj01GCUI0QdIuCWoXt2WcPOkENGg2FroM3Q5Vf3Rbk
	GecueQZmugdmlVAW93OfC
X-Google-Smtp-Source: AGHT+IGsRChzRddt+cjg9piavp9C/PQTKKKBppn1Phd2o1pkNNvqcDFwTv5oRL1v+Au4Oc+cN/JHl+D3QXdbz9iqaqo=
X-Received: by 2002:ad4:5de6:0:b0:73a:1587:125f with SMTP id
 6a1803df08f44-79913f8cb26mr89578106d6.23.1758389965470; Sat, 20 Sep 2025
 10:39:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muRF1=H=acG2d0jVayW2fp0_V-5-0=Mx+8+VDRD-2oK4A@mail.gmail.com> <20250920173630.rjajntsu2sy72fys@pali>
In-Reply-To: <20250920173630.rjajntsu2sy72fys@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:39:14 -0500
X-Gm-Features: AS18NWC7uxDzShyvK_4UKVMJNGT0sAmog75NaBvnv2Sb_VM_crHiH5cEV3WVUB8
Message-ID: <CAH2r5muDLtJ1hFPmmuRydyh64ovU5Lg5z1WUhCrAo9iCEG33KQ@mail.gmail.com>
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

As long as we don't break any Linux apps - we need to return file not
found or equivalent when a file is in delete pending in every path
that we can (if we have some places that incorrectly show the file,
the better solution is to hide it there, not to break more Linux apps
by showing a file which has been deleted/silly-renamed

On Sat, Sep 20, 2025 at 12:36=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> The point is that the directory entry is not deleted yet. It is present
> in the readdir() output. For Linux apps the file not found should be
> returned when the directory entry disappear (from readdir()). I wrote
> few test scenarios in cover letter of the patch series, which covers
> this.
>
> On Saturday 20 September 2025 12:14:00 Steve French wrote:
> > This looks confusing, like it is wrong for Linux apps - when Linux
> > queries a file that is deleted (but still open by some other process)
> > it should get the equivalent of file not found or at least an error -
> > you aren't supposed to allow path based calls on a file which has a
> > pending delete or that would break Linux apps.
> >
> > On Sun, Aug 31, 2025 at 7:36=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.or=
g> wrote:
> > >
> > > Paths in DELETE_PENDING state cannot be opened at all. So standard wa=
y of
> > > querying path attributes for this case is not possible.
> > >
> > > There is an alternative way how to query limited information about fi=
le
> > > over SMB2+ dialects without opening file itself. It is by opening the
> > > parent directory, querying specific child with filled search filter a=
nd
> > > asking for attributes for that child.
> > >
> > > Implement this fallback when standard case in smb2_query_path_info fa=
ils
> > > with STATUS_DELETE_PENDING error and stat was asked for path which is=
 not
> > > top level one (because top level does not have parent directory at al=
l).
> > >
> > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -EBU=
SY".
> > >
> > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > ---
> > >  fs/smb/client/cifsglob.h  |   1 +
> > >  fs/smb/client/smb2glob.h  |   1 +
> > >  fs/smb/client/smb2inode.c | 177 ++++++++++++++++++++++++++++++++++++=
+-
> > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > index e6830ab3a546..0ecf4988664e 100644
> > > --- a/fs/smb/client/cifsglob.h
> > > +++ b/fs/smb/client/cifsglob.h
> > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > >         struct smb_rqst rqst[MAX_COMPOUND];
> > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > >         struct kvec qi_iov;
> > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > >         struct kvec close_iov;
> > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> > > index 224495322a05..1cb219605e75 100644
> > > --- a/fs/smb/client/smb2glob.h
> > > +++ b/fs/smb/client/smb2glob.h
> > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > >         SMB2_OP_GET_REPARSE,
> > >         SMB2_OP_QUERY_WSL_EA,
> > >         SMB2_OP_OPEN_QUERY,
> > > +       SMB2_OP_QUERY_DIRECTORY,
> > >  };
> > >
> > >  /* Used when constructing chained read requests. */
> > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > index 2a0316c514e4..460e75614ef1 100644
> > > --- a/fs/smb/client/smb2inode.c
> > > +++ b/fs/smb/client/smb2inode.c
> > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned int xi=
d, struct cifs_tcon *tcon,
> > >                             struct kvec *out_iov, int *out_buftype, s=
truct dentry *dentry)
> > >  {
> > >
> > > +       bool has_cifs_mount_server_inum =3D cifs_sb->mnt_cifs_flags &=
 CIFS_MOUNT_SERVER_INUM;
> > > +       struct smb2_query_directory_req *qd_rqst =3D NULL;
> > > +       struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> > >         struct smb2_create_rsp *create_rsp =3D NULL;
> > >         struct smb2_query_info_rsp *qi_rsp =3D NULL;
> > >         struct smb2_compound_vars *vars =3D NULL;
> > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned int x=
id, struct cifs_tcon *tcon,
> > >                         trace_smb3_posix_query_info_compound_enter(xi=
d, tcon->tid,
> > >                                                                    se=
s->Suid, full_path);
> > >                         break;
> > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > +                       rqst[num_rqst].rq_iov =3D &vars->qd_iov[0];
> > > +                       rqst[num_rqst].rq_nvec =3D SMB2_QUERY_DIRECTO=
RY_IOV_SIZE;
> > > +
> > > +                       rc =3D SMB2_query_directory_init(xid,
> > > +                                                      tcon,
> > > +                                                      server,
> > > +                                                      &rqst[num_rqst=
],
> > > +                                                      cfile ?
> > > +                                                       cfile->fid.pe=
rsistent_fid : COMPOUND_FID,
> > > +                                                      cfile ?
> > > +                                                       cfile->fid.vo=
latile_fid : COMPOUND_FID,
> > > +                                                      0,
> > > +                                                      has_cifs_mount=
_server_inum ?
> > > +                                                       SMB_FIND_FILE=
_ID_FULL_DIR_INFO :
> > > +                                                       SMB_FIND_FILE=
_FULL_DIRECTORY_INFO);
> > > +                       if (!rc) {
> > > +                               /*
> > > +                                * Change the default search wildcard=
 pattern '*'
> > > +                                * to the requested file name stored =
in in_iov[i]
> > > +                                * and request for only one single en=
try.
> > > +                                */
> > > +                               qd_rqst =3D rqst[num_rqst].rq_iov[0].=
iov_base;
> > > +                               qd_rqst->Flags |=3D SMB2_RETURN_SINGL=
E_ENTRY;
> > > +                               qd_rqst->FileNameLength =3D cpu_to_le=
16(in_iov[i].iov_len);
> > > +                               rqst[num_rqst].rq_iov[1] =3D in_iov[i=
];
> > > +                       }
> > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > +                               smb2_set_next_command(tcon, &rqst[num=
_rqst]);
> > > +                               smb2_set_related(&rqst[num_rqst]);
> > > +                       } else if (rc) {
> > > +                               goto finished;
> > > +                       }
> > > +                       num_rqst++;
> > > +                       break;
> > >                 case SMB2_OP_DELETE:
> > >                         trace_smb3_delete_enter(xid, tcon->tid, ses->=
Suid, full_path);
> > >                         break;
> > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned int x=
id, struct cifs_tcon *tcon,
> > >                                 trace_smb3_posix_query_info_compound_=
done(xid, tcon->tid,
> > >                                                                      =
     ses->Suid);
> > >                         break;
> > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > +                       if (rc =3D=3D 0) {
> > > +                               qd_rsp =3D (struct smb2_query_directo=
ry_rsp *)
> > > +                                       rsp_iov[i + 1].iov_base;
> > > +                               rc =3D smb2_validate_iov(le16_to_cpu(=
qd_rsp->OutputBufferOffset),
> > > +                                                      le32_to_cpu(qd=
_rsp->OutputBufferLength),
> > > +                                                      &rsp_iov[i + 1=
],
> > > +                                                      has_cifs_mount=
_server_inum ?
> > > +                                                       sizeof(SEARCH=
_ID_FULL_DIR_INFO) :
> > > +                                                       sizeof(FILE_F=
ULL_DIRECTORY_INFO));
> > > +                       }
> > > +                       if (rc =3D=3D 0) {
> > > +                               /*
> > > +                                * Both SEARCH_ID_FULL_DIR_INFO and F=
ILE_FULL_DIRECTORY_INFO
> > > +                                * have same member offsets except th=
e UniqueId and FileName.
> > > +                                */
> > > +                               SEARCH_ID_FULL_DIR_INFO *si =3D
> > > +                                       (SEARCH_ID_FULL_DIR_INFO *)qd=
_rsp->Buffer;
> > > +
> > > +                               idata =3D in_iov[i + 1].iov_base;
> > > +                               idata->fi.CreationTime =3D si->Creati=
onTime;
> > > +                               idata->fi.LastAccessTime =3D si->Last=
AccessTime;
> > > +                               idata->fi.LastWriteTime =3D si->LastW=
riteTime;
> > > +                               idata->fi.ChangeTime =3D si->ChangeTi=
me;
> > > +                               idata->fi.Attributes =3D si->ExtFileA=
ttributes;
> > > +                               idata->fi.AllocationSize =3D si->Allo=
cationSize;
> > > +                               idata->fi.EndOfFile =3D si->EndOfFile=
;
> > > +                               idata->fi.EASize =3D si->EaSize;
> > > +                               idata->fi.Directory =3D
> > > +                                       !!(le32_to_cpu(si->ExtFileAtt=
ributes) & ATTR_DIRECTORY);
> > > +                               /*
> > > +                                * UniqueId is present only in struct=
 SEARCH_ID_FULL_DIR_INFO.
> > > +                                * It is not present in struct FILE_F=
ULL_DIRECTORY_INFO.
> > > +                                * struct SEARCH_ID_FULL_DIR_INFO was=
 requested only when
> > > +                                * CIFS_MOUNT_SERVER_INUM is set.
> > > +                                */
> > > +                               if (has_cifs_mount_server_inum)
> > > +                                       idata->fi.IndexNumber =3D si-=
>UniqueId;
> > > +                               /*
> > > +                                * Do not change idata->fi.NumberOfLi=
nks to correctly
> > > +                                * trigger the CIFS_FATTR_UNKNOWN_NLI=
NK flag.
> > > +                                */
> > > +                               /*
> > > +                                * Do not change idata->fi.DeletePend=
ing as we do not know if
> > > +                                * the entry is in the delete pending=
 state. SMB2 QUERY_DIRECTORY
> > > +                                * at any level does not provide this=
 information.
> > > +                                */
> > > +                       }
> > > +                       SMB2_query_directory_free(&rqst[num_rqst++]);
> > > +                       if (rc)
> > > +                               trace_smb3_query_dir_err(xid,
> > > +                                       cfile ? cfile->fid.persistent=
_fid : COMPOUND_FID,
> > > +                                       tcon->tid, ses->Suid, 0, 0, r=
c);
> > > +                       else
> > > +                               trace_smb3_query_dir_done(xid,
> > > +                                       cfile ? cfile->fid.persistent=
_fid : COMPOUND_FID,
> > > +                                       tcon->tid, ses->Suid, 0, 0);
> > > +                       break;
> > >                 case SMB2_OP_DELETE:
> > >                         if (rc)
> > >                                 trace_smb3_delete_err(xid, tcon->tid,=
 ses->Suid, rc);
> > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned int xid=
,
> > >                 break;
> > >         case -EREMOTE:
> > >                 break;
> > > -       default:
> > > -               if (hdr->Status !=3D STATUS_OBJECT_NAME_INVALID)
> > > -                       break;
> > > +       }
> > > +
> > > +       if (hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALID) {
> > >                 rc2 =3D cifs_inval_name_dfs_link_error(xid, tcon, cif=
s_sb,
> > >                                                      full_path, &isli=
nk);
> > >                 if (rc2) {
> > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned int xi=
d,
> > >                 }
> > >                 if (islink)
> > >                         rc =3D -EREMOTE;
> > > +       } else if (hdr->Status =3D=3D STATUS_DELETE_PENDING && full_p=
ath[0]) {
> > > +               /*
> > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE_PENDI=
NG error,
> > > +                * it means that the path is in delete pending state =
and it is
> > > +                * not possible to open it until some other client cl=
ears delete
> > > +                * pending state or all other clients close all opene=
d handles
> > > +                * to that path.
> > > +                *
> > > +                * There is an alternative way how to query limited i=
nformation
> > > +                * about path which is in delete pending state still =
suitable
> > > +                * for the stat() syscall. It is by opening the paren=
t directory,
> > > +                * querying specific child with filled search filer a=
nd asking
> > > +                * for attributes for that child.
> > > +                */
> > > +
> > > +               char *parent_path;
> > > +               const char *basename;
> > > +               __le16 *basename_utf16;
> > > +               int basename_utf16_len;
> > > +               struct cifsFileInfo *parent_cfile;
> > > +
> > > +               basename =3D strrchr(full_path, CIFS_DIR_SEP(cifs_sb)=
);
> > > +               if (basename) {
> > > +                       parent_path =3D kstrndup(full_path, basename =
- full_path, GFP_KERNEL);
> > > +                       basename++;
> > > +               } else {
> > > +                       parent_path =3D kstrdup("", GFP_KERNEL);
> > > +                       basename =3D full_path;
> > > +               }
> > > +
> > > +               if (!parent_path) {
> > > +                       rc =3D -ENOMEM;
> > > +                       goto out;
> > > +               }
> > > +
> > > +               basename_utf16 =3D cifs_convert_path_to_utf16(basenam=
e, cifs_sb);
> > > +               if (!basename_utf16) {
> > > +                       kfree(parent_path);
> > > +                       rc =3D -ENOMEM;
> > > +                       goto out;
> > > +               }
> > > +
> > > +               basename_utf16_len =3D 2 * UniStrnlen((wchar_t *)base=
name_utf16, PATH_MAX);
> > > +
> > > +retry_query_directory:
> > > +               num_cmds =3D 1;
> > > +               cmds[0] =3D SMB2_OP_QUERY_DIRECTORY;
> > > +               in_iov[0].iov_base =3D basename_utf16;
> > > +               in_iov[0].iov_len =3D basename_utf16_len;
> > > +               in_iov[1].iov_base =3D data;
> > > +               in_iov[1].iov_len =3D sizeof(*data);
> > > +               oparms =3D CIFS_OPARMS(cifs_sb, tcon, parent_path, FI=
LE_READ_DATA,
> > > +                                    FILE_OPEN, CREATE_NOT_FILE, ACL_=
NO_MODE);
> > > +               cifs_get_readable_path(tcon, parent_path, &parent_cfi=
le);
> > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov=
));
> > > +               rc =3D smb2_compound_op(xid, tcon, cifs_sb, parent_pa=
th,
> > > +                                     &oparms, in_iov, cmds, num_cmds=
,
> > > +                                     parent_cfile, out_iov, out_buft=
ype, NULL);
> > > +               if (rc =3D=3D -EOPNOTSUPP && (cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_SERVER_INUM)) {
> > > +                       /*
> > > +                        * If querying of server inode numbers is not=
 supported
> > > +                        * but is enabled, then disable it and try ag=
ain.
> > > +                        */
> > > +                       cifs_autodisable_serverino(cifs_sb);
> > > +                       goto retry_query_directory;
> > > +               }
> > > +
> > > +               kfree(parent_path);
> > > +               kfree(basename_utf16);
> > > +
> > > +               hdr =3D out_iov[0].iov_base;
> > > +               if (!hdr || out_buftype[0] =3D=3D CIFS_NO_BUFFER)
> > > +                       goto out;
> > > +
> > > +               data->fi.DeletePending =3D 1; /* This is code path fo=
r STATUS_DELETE_PENDING. */
> > >         }
> > >
> > >  out:
> > > --
> > > 2.20.1
> > >
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve

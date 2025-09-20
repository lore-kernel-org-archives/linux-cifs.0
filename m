Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B68E2FF65D
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758390540; cv=none; b=K5g3Jo2vQr+usUDLV0rATsPOVh4rwQ2XR+Lo4CpCv569+G2OdixCJP1LqDHUjnGa5DchWV2CWhAQ/QOGdblG2MA8p2yzrIzJKnvLcRs9Ss+Uu42+xUZXqdthNccC4lHVKHlYLwtrZlSDhTsy+HQANd4KB87oCydU6gywaFU8OUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758390540; c=relaxed/simple;
	bh=1z1R7hN67t3gOlhyZDO1UzvlhT5RsclpyiOYy5mfVuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pl/J6tAKAlM6rwItlswq6req5wrTFRKcS9DXYVakRul8bXZyy/FCbOcP2M2MULYQkdkJQmKcEuilReFqDAV6ij9U9wsAzQdvBL0NWx7LovGbphdWq0jDoUZ0hUepS+TjYK0Jm9duNKUoPCtrOngPbYAvW/p0OgGgtRxCrq1YiVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EN5oLZnI; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EN5oLZnI"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-7957e2f6ba8so22902076d6.3
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758390537; x=1758995337; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4mB+L5RoiJqkFAUMZ0nEbA/WRT11ED1AtdPYWwkU5NU=;
        b=EN5oLZnIsMhMUIiiyPB1prV2can85ms7te1GW4GWhNLxvwdjoiBASQol0EsI3cW0RL
         mmzMupuzbG7LfyZL/57KrHnYLoXjFXyyDWGMzc+JG0gnFHu7yYqCOC4pbVxbAfaqMwPk
         ZR7vaQq1JX4EcQ1uAAbCuMPmJrXzccO0ncx1qhx6uF5IEZ+cLqdY+0OQPXfAed9/ki1J
         qh87gaZvcuIpJDRzxj/gFHMKgscZSmM935mAIey4GJDdh4lwMpJtWadsQOKpNpVhVTHN
         AGQlj1pMaDhBg8PBtb4dxIsNvWAOtgc0kaRmI5gED4y8rZR7br2m62xuzXz181PHEsm1
         5Bgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758390537; x=1758995337;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4mB+L5RoiJqkFAUMZ0nEbA/WRT11ED1AtdPYWwkU5NU=;
        b=QcTPZYKLmEcOBDe17gKAB3GNCTuFeHXylYTal0ffI/mRL+a+whcSqM/dA9CNVtksJh
         +OQRx7ToCvosfvIYMfhME7ryRpJBnwt2OimARa9ik+UQ6CdotOYl51RC4NdQiCl/atjs
         thNiLP0gqAvlmwe4I7jvXTlDC/BXLZ1oOBP0SOS3R7PkqL4Hy//X+yIVEupMPX5W8YS3
         q6AUcqXoVpO11FhXHXosVk4w2F60aQz+Jrry3V1bzzU4/dWPH0dTejlyyz7L7GTHDwUP
         m5Yja1FPhqavnGoFdmJ1cMuVLwsQg8jRyo3S/ixtUy7yCmovTYmwoDiPd/MgC12Iiqpl
         KOpg==
X-Forwarded-Encrypted: i=1; AJvYcCV0gyQblRUwkb7SJHzZjXkpPIjPbsWZP0MG5nQF+HACxnCKF7UOCJf9LfQzQOBF387PDje0GR0KRfB1@vger.kernel.org
X-Gm-Message-State: AOJu0YxcWD9y6jYnx6+08YZLedBPeEDTkMRv2euI1MEcJc7fAXUib1ZW
	eP3NtZutEPpL7dLBQo7AKQK4kydRDym2oP0tfk3TZGo0Y0ciW/nksrqkqyhZ1t9jcDnid3Qj4P/
	ruJDYLYaRP5s7yTY+qqKi6998kSmpUXlUWyaU
X-Gm-Gg: ASbGncs5cirjtSakfTnNCaK8YwYsX/tJougnRmTbmVBRU6RMViGPeN5xWGRxKrdu5jG
	mkrQSW5ysq5+U5ZteIvGfAECPdOl4niJXWsbu4M2NykvxvMYEp1bc3EyfRcEwPm6Sx/RgSgWnTc
	uW6jxdy8+Ya/8+aMaeQ3lAeoXs8DQ304apV7wdQS8OpVVtyMhjFhX2flD4taEzYkGrTNvBBx4lh
	9o8xc6IsbR20lEbG9PDcntSmKDNPsw7Qqx0tlk+aKQJcPMzDRXQxrPpSOV52HJnq5p4LNePVgtt
	ExyY0VRNSb2VIUNZogAaltLpNxgXurzIOWfVEtqWYY6i5UDR6lK8deRJ1G671cCJHj6RblzlNX+
	iZdbDqPPZQKhl+J0u1Juh
X-Google-Smtp-Source: AGHT+IHQxvQlxBT93mqk/OysEvPUymZ/EZisF7l5XLNe16+3emEUh9jA1ZY1HfPVqRPZaZAQ1+0VOrZflfnOmn2YXus=
X-Received: by 2002:a05:6214:e42:b0:786:5ae7:7846 with SMTP id
 6a1803df08f44-799197ee535mr89935676d6.32.1758390537052; Sat, 20 Sep 2025
 10:48:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muVP5NuZFfsCWDYhCKATDyeaD2cpXgC3=zNh+3T_zO1Mg@mail.gmail.com> <20250920174217.h5neq5yllnbvgn5a@pali>
In-Reply-To: <20250920174217.h5neq5yllnbvgn5a@pali>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:48:45 -0500
X-Gm-Features: AS18NWA1wzRopF4eqqXHR3JGgY3lVKWGxlkKI6Jb3slVxC7VVCsgMUh1RiJvKGA
Message-ID: <CAH2r5msWy9K04gMAQhfxsV-_TVhkTWL--oOGy_aQ78HCuibR0g@mail.gmail.com>
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Also would be helpful to reorder these in order by importance. Prioritize:
1) those fixes that are useful for current mounts (e.g. smb3.1.1 or
smb3) and matter for servers that are still commonly used (obviously
SMB1 fixes are low priority, unless small and obvious fixes)
2) those that fix bugs that can be shown with simple test script
3) those that improve "best effort" Linux semantics
4) those that are large and hard to review are prioritized lower

On Sat, Sep 20, 2025 at 12:42=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> Commits in this patch series needs to be applied in the order.
> So this patch does not apply without the previous dependent. It would
> not apply alone.
>
> I sent this patch series about month ago, so maybe the patch series
> needs to be rebased, I can look at it in next days.
>
> On Saturday 20 September 2025 12:26:40 Steve French wrote:
> > This patch doesn't apply to current mainline - can you update it?
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

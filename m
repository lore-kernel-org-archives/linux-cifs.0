Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC1921ABB9
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758390029; cv=none; b=ATej5gVSy5ljFPgoI3KtsKFAyNuyt1cab1+50qj0JLHCh89nRGQ46uwjBnrQ+Vet5IVZjKBWtKeFG702XHaTdBwUrLHvpz0/SgZCdyAu/bFt7sMF4DwHDs+BoTWevklXQk6TF8uFeMkvJnJ/CrJz1PP1raRNkNQUhjDzDAM+DOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758390029; c=relaxed/simple;
	bh=oMyr8Rp3uABI9AWB5ojpH+gnTSNeOZE97auGhUtMQ5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wh5d8/zyMgP1wa7gEu38dM/3hUPtqllznFU1KF9tkDsWqRE1NgfvZljJhHuR5Nmnf+fAkanPWLebhBcRepSX4yoje8SLA+Q0Q/GlVtkSucUWDguSVSnpbphasVx0ljGVTpEOe/f6HQLKXVINRYXw7iI4oMQBkTnb6F8ibSjb6VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjP3/xjm; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjP3/xjm"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-791875a9071so30934606d6.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 10:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758390026; x=1758994826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E1t3kkR3p6wIDonOR+IV6mj8ckUGmi/2qnDq6wsfBvA=;
        b=BjP3/xjm/iu5ia73k6hhyfvY8nTmAY/1T0yVbBH5v6+QYG6OlP06EEXCDMYgE+r0Gb
         piWtM3FdBJjTW1ybx5r+puBeg1H0q7lDZ+pHt7IYnJsYxEqblbWpkWtbsKxEkwz+1gJF
         4mwXNdb22tZyIDeCxs3MoMsKzYr8gKxFoUvksokeE8iRT0WOiecCLBXxY2137figw87C
         aIkEjj+UxicEiw9052915y/OezpbGoF2213egRnmt2w365FCNVB9ueMemm5QV9DkGkFA
         acSUVxJJa8DB42YoLhRjvYMwdSERq5S5QhoTxMhiaOCrng7ijJI7rFGraW++AaOWwKmB
         Mz5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758390026; x=1758994826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E1t3kkR3p6wIDonOR+IV6mj8ckUGmi/2qnDq6wsfBvA=;
        b=C+bZqpI+yf7sbQQ58/qOJYqcDfdQjrish9I+KrzTcVK4xcFhvNr1CoLShGzfRkCKrI
         i3AfRpBCjyWW2VcTimRwNTS5Xp3mHYoMIKKxqVJg+U7N9U7bk6KiZjbaRpxmG5HZqUIc
         x4Q6jRIHswkM13pfjY+MVMvA4CPdu+3sqi8aKhEZNPnZGb9z1kAMKv7W/G54SAgZY7nU
         RNBC0zLTtSqjrK641jrp7jqI6ii3IrvzsJ7zX5fG8WXJS5H0LDGtSkXNkBkG4h3VDP2K
         Qy73hB8BFtgeoO1ntRYKh2YU+X0y5aXGMvK5dIn6eC03Nj0NL/LS4uKpCu4z3stOaiR2
         LZxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX64xdHL0HT2J9FYOPZDVYedmWxvbUGM06DMXb+75TKpGCrkzmZf15UCsAPnUEJKdYS2jL7KFa95F8s@vger.kernel.org
X-Gm-Message-State: AOJu0YxbJ8IVe4hTSo9csYJ/+G13F14VsZdtHhASpb1eQ7CMArc4Yr5t
	vuErMbUwCWNq+0B1OmpTPZYD9LJu2HPeqFBiQt0HTaxO0O8wxo5Xjj977y20W7mQoOAbakF6zi/
	/PiOfMh/4YjAOk6sLjKmC/JgNKKdbxMc=
X-Gm-Gg: ASbGncuYNTTukUHpXDHQH6+Mh1n3JZH3KsyKK1ObjXu3mjWiEanF80NfdlKtv5awL/8
	rZ2Ig5ctYkywnW/cnzQ2GLktBU+r2Lqn6P+jpfQTb/s8n5HS1eTmqzB7LF2evqbHIslarVmrSAI
	Z6bfxI9N1q6LX5z+qAnLczarQHDtEjEBO67p/9Wq3nK4QggyAba+HEP7Q2sAn5jRoanVwuWhkcI
	3NQmqwKe59OSqyt8n0zS2okegsvhTWlKG8YNQBNLhrWfPr6Fy+vXslsifsXwUf5skBuo/GneTGq
	P6WgIr2aN1jgNYBYsZAYJUgjwM/S2XII2hkzltKlAoq3Nos7YEwJAOCWyu6+i2696pC98crXsjh
	kVRAXg5P1d4UPZb+KcHN4
X-Google-Smtp-Source: AGHT+IEY8gdSUfYDAF5YALNEzcG2tCnK4sxNGN6dZVqqhlEcVFzXNsrYIKm4TYgbTkSmt/0GAkslXqM6knJGMaPo4lI=
X-Received: by 2002:a05:6214:d0b:b0:78d:b474:8e3e with SMTP id
 6a1803df08f44-7991cbb138emr85998386d6.49.1758390026214; Sat, 20 Sep 2025
 10:40:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250831123602.14037-1-pali@kernel.org> <20250831123602.14037-9-pali@kernel.org>
 <CAH2r5muRF1=H=acG2d0jVayW2fp0_V-5-0=Mx+8+VDRD-2oK4A@mail.gmail.com>
 <20250920173630.rjajntsu2sy72fys@pali> <CAH2r5muDLtJ1hFPmmuRydyh64ovU5Lg5z1WUhCrAo9iCEG33KQ@mail.gmail.com>
In-Reply-To: <CAH2r5muDLtJ1hFPmmuRydyh64ovU5Lg5z1WUhCrAo9iCEG33KQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 20 Sep 2025 12:40:14 -0500
X-Gm-Features: AS18NWDTMcNbE4-wokAJc3GeGK9fXYGy1FEbvRffN0B-xdpQ8BvXZDexib5QurY
Message-ID: <CAH2r5ms_ufxY-J+8rQ3X5zToe6aQv9B1ZorRuk86CAfW_VBzQw@mail.gmail.com>
Subject: Re: [PATCH 08/35] cifs: Improve SMB2+ stat() to work also for paths
 in DELETE_PENDING state
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	ronnie sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We can use tricks like marking file as hidden and silly rename to make
them less visible - but focus on the closest we can get to expected
Linux behavior

On Sat, Sep 20, 2025 at 12:39=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> As long as we don't break any Linux apps - we need to return file not
> found or equivalent when a file is in delete pending in every path
> that we can (if we have some places that incorrectly show the file,
> the better solution is to hide it there, not to break more Linux apps
> by showing a file which has been deleted/silly-renamed
>
> On Sat, Sep 20, 2025 at 12:36=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org=
> wrote:
> >
> > The point is that the directory entry is not deleted yet. It is present
> > in the readdir() output. For Linux apps the file not found should be
> > returned when the directory entry disappear (from readdir()). I wrote
> > few test scenarios in cover letter of the patch series, which covers
> > this.
> >
> > On Saturday 20 September 2025 12:14:00 Steve French wrote:
> > > This looks confusing, like it is wrong for Linux apps - when Linux
> > > queries a file that is deleted (but still open by some other process)
> > > it should get the equivalent of file not found or at least an error -
> > > you aren't supposed to allow path based calls on a file which has a
> > > pending delete or that would break Linux apps.
> > >
> > > On Sun, Aug 31, 2025 at 7:36=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.=
org> wrote:
> > > >
> > > > Paths in DELETE_PENDING state cannot be opened at all. So standard =
way of
> > > > querying path attributes for this case is not possible.
> > > >
> > > > There is an alternative way how to query limited information about =
file
> > > > over SMB2+ dialects without opening file itself. It is by opening t=
he
> > > > parent directory, querying specific child with filled search filter=
 and
> > > > asking for attributes for that child.
> > > >
> > > > Implement this fallback when standard case in smb2_query_path_info =
fails
> > > > with STATUS_DELETE_PENDING error and stat was asked for path which =
is not
> > > > top level one (because top level does not have parent directory at =
all).
> > > >
> > > > Depends on "cifs: Change translation of STATUS_DELETE_PENDING to -E=
BUSY".
> > > >
> > > > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> > > > ---
> > > >  fs/smb/client/cifsglob.h  |   1 +
> > > >  fs/smb/client/smb2glob.h  |   1 +
> > > >  fs/smb/client/smb2inode.c | 177 ++++++++++++++++++++++++++++++++++=
+++-
> > > >  3 files changed, 176 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > > > index e6830ab3a546..0ecf4988664e 100644
> > > > --- a/fs/smb/client/cifsglob.h
> > > > +++ b/fs/smb/client/cifsglob.h
> > > > @@ -2337,6 +2337,7 @@ struct smb2_compound_vars {
> > > >         struct smb_rqst rqst[MAX_COMPOUND];
> > > >         struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> > > >         struct kvec qi_iov;
> > > > +       struct kvec qd_iov[SMB2_QUERY_DIRECTORY_IOV_SIZE];
> > > >         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> > > >         struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
> > > >         struct kvec close_iov;
> > > > diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
> > > > index 224495322a05..1cb219605e75 100644
> > > > --- a/fs/smb/client/smb2glob.h
> > > > +++ b/fs/smb/client/smb2glob.h
> > > > @@ -39,6 +39,7 @@ enum smb2_compound_ops {
> > > >         SMB2_OP_GET_REPARSE,
> > > >         SMB2_OP_QUERY_WSL_EA,
> > > >         SMB2_OP_OPEN_QUERY,
> > > > +       SMB2_OP_QUERY_DIRECTORY,
> > > >  };
> > > >
> > > >  /* Used when constructing chained read requests. */
> > > > diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> > > > index 2a0316c514e4..460e75614ef1 100644
> > > > --- a/fs/smb/client/smb2inode.c
> > > > +++ b/fs/smb/client/smb2inode.c
> > > > @@ -176,6 +176,9 @@ static int smb2_compound_op(const unsigned int =
xid, struct cifs_tcon *tcon,
> > > >                             struct kvec *out_iov, int *out_buftype,=
 struct dentry *dentry)
> > > >  {
> > > >
> > > > +       bool has_cifs_mount_server_inum =3D cifs_sb->mnt_cifs_flags=
 & CIFS_MOUNT_SERVER_INUM;
> > > > +       struct smb2_query_directory_req *qd_rqst =3D NULL;
> > > > +       struct smb2_query_directory_rsp *qd_rsp =3D NULL;
> > > >         struct smb2_create_rsp *create_rsp =3D NULL;
> > > >         struct smb2_query_info_rsp *qi_rsp =3D NULL;
> > > >         struct smb2_compound_vars *vars =3D NULL;
> > > > @@ -344,6 +347,41 @@ static int smb2_compound_op(const unsigned int=
 xid, struct cifs_tcon *tcon,
> > > >                         trace_smb3_posix_query_info_compound_enter(=
xid, tcon->tid,
> > > >                                                                    =
ses->Suid, full_path);
> > > >                         break;
> > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > +                       rqst[num_rqst].rq_iov =3D &vars->qd_iov[0];
> > > > +                       rqst[num_rqst].rq_nvec =3D SMB2_QUERY_DIREC=
TORY_IOV_SIZE;
> > > > +
> > > > +                       rc =3D SMB2_query_directory_init(xid,
> > > > +                                                      tcon,
> > > > +                                                      server,
> > > > +                                                      &rqst[num_rq=
st],
> > > > +                                                      cfile ?
> > > > +                                                       cfile->fid.=
persistent_fid : COMPOUND_FID,
> > > > +                                                      cfile ?
> > > > +                                                       cfile->fid.=
volatile_fid : COMPOUND_FID,
> > > > +                                                      0,
> > > > +                                                      has_cifs_mou=
nt_server_inum ?
> > > > +                                                       SMB_FIND_FI=
LE_ID_FULL_DIR_INFO :
> > > > +                                                       SMB_FIND_FI=
LE_FULL_DIRECTORY_INFO);
> > > > +                       if (!rc) {
> > > > +                               /*
> > > > +                                * Change the default search wildca=
rd pattern '*'
> > > > +                                * to the requested file name store=
d in in_iov[i]
> > > > +                                * and request for only one single =
entry.
> > > > +                                */
> > > > +                               qd_rqst =3D rqst[num_rqst].rq_iov[0=
].iov_base;
> > > > +                               qd_rqst->Flags |=3D SMB2_RETURN_SIN=
GLE_ENTRY;
> > > > +                               qd_rqst->FileNameLength =3D cpu_to_=
le16(in_iov[i].iov_len);
> > > > +                               rqst[num_rqst].rq_iov[1] =3D in_iov=
[i];
> > > > +                       }
> > > > +                       if (!rc && (!cfile || num_rqst > 1)) {
> > > > +                               smb2_set_next_command(tcon, &rqst[n=
um_rqst]);
> > > > +                               smb2_set_related(&rqst[num_rqst]);
> > > > +                       } else if (rc) {
> > > > +                               goto finished;
> > > > +                       }
> > > > +                       num_rqst++;
> > > > +                       break;
> > > >                 case SMB2_OP_DELETE:
> > > >                         trace_smb3_delete_enter(xid, tcon->tid, ses=
->Suid, full_path);
> > > >                         break;
> > > > @@ -730,6 +768,64 @@ static int smb2_compound_op(const unsigned int=
 xid, struct cifs_tcon *tcon,
> > > >                                 trace_smb3_posix_query_info_compoun=
d_done(xid, tcon->tid,
> > > >                                                                    =
       ses->Suid);
> > > >                         break;
> > > > +               case SMB2_OP_QUERY_DIRECTORY:
> > > > +                       if (rc =3D=3D 0) {
> > > > +                               qd_rsp =3D (struct smb2_query_direc=
tory_rsp *)
> > > > +                                       rsp_iov[i + 1].iov_base;
> > > > +                               rc =3D smb2_validate_iov(le16_to_cp=
u(qd_rsp->OutputBufferOffset),
> > > > +                                                      le32_to_cpu(=
qd_rsp->OutputBufferLength),
> > > > +                                                      &rsp_iov[i +=
 1],
> > > > +                                                      has_cifs_mou=
nt_server_inum ?
> > > > +                                                       sizeof(SEAR=
CH_ID_FULL_DIR_INFO) :
> > > > +                                                       sizeof(FILE=
_FULL_DIRECTORY_INFO));
> > > > +                       }
> > > > +                       if (rc =3D=3D 0) {
> > > > +                               /*
> > > > +                                * Both SEARCH_ID_FULL_DIR_INFO and=
 FILE_FULL_DIRECTORY_INFO
> > > > +                                * have same member offsets except =
the UniqueId and FileName.
> > > > +                                */
> > > > +                               SEARCH_ID_FULL_DIR_INFO *si =3D
> > > > +                                       (SEARCH_ID_FULL_DIR_INFO *)=
qd_rsp->Buffer;
> > > > +
> > > > +                               idata =3D in_iov[i + 1].iov_base;
> > > > +                               idata->fi.CreationTime =3D si->Crea=
tionTime;
> > > > +                               idata->fi.LastAccessTime =3D si->La=
stAccessTime;
> > > > +                               idata->fi.LastWriteTime =3D si->Las=
tWriteTime;
> > > > +                               idata->fi.ChangeTime =3D si->Change=
Time;
> > > > +                               idata->fi.Attributes =3D si->ExtFil=
eAttributes;
> > > > +                               idata->fi.AllocationSize =3D si->Al=
locationSize;
> > > > +                               idata->fi.EndOfFile =3D si->EndOfFi=
le;
> > > > +                               idata->fi.EASize =3D si->EaSize;
> > > > +                               idata->fi.Directory =3D
> > > > +                                       !!(le32_to_cpu(si->ExtFileA=
ttributes) & ATTR_DIRECTORY);
> > > > +                               /*
> > > > +                                * UniqueId is present only in stru=
ct SEARCH_ID_FULL_DIR_INFO.
> > > > +                                * It is not present in struct FILE=
_FULL_DIRECTORY_INFO.
> > > > +                                * struct SEARCH_ID_FULL_DIR_INFO w=
as requested only when
> > > > +                                * CIFS_MOUNT_SERVER_INUM is set.
> > > > +                                */
> > > > +                               if (has_cifs_mount_server_inum)
> > > > +                                       idata->fi.IndexNumber =3D s=
i->UniqueId;
> > > > +                               /*
> > > > +                                * Do not change idata->fi.NumberOf=
Links to correctly
> > > > +                                * trigger the CIFS_FATTR_UNKNOWN_N=
LINK flag.
> > > > +                                */
> > > > +                               /*
> > > > +                                * Do not change idata->fi.DeletePe=
nding as we do not know if
> > > > +                                * the entry is in the delete pendi=
ng state. SMB2 QUERY_DIRECTORY
> > > > +                                * at any level does not provide th=
is information.
> > > > +                                */
> > > > +                       }
> > > > +                       SMB2_query_directory_free(&rqst[num_rqst++]=
);
> > > > +                       if (rc)
> > > > +                               trace_smb3_query_dir_err(xid,
> > > > +                                       cfile ? cfile->fid.persiste=
nt_fid : COMPOUND_FID,
> > > > +                                       tcon->tid, ses->Suid, 0, 0,=
 rc);
> > > > +                       else
> > > > +                               trace_smb3_query_dir_done(xid,
> > > > +                                       cfile ? cfile->fid.persiste=
nt_fid : COMPOUND_FID,
> > > > +                                       tcon->tid, ses->Suid, 0, 0)=
;
> > > > +                       break;
> > > >                 case SMB2_OP_DELETE:
> > > >                         if (rc)
> > > >                                 trace_smb3_delete_err(xid, tcon->ti=
d, ses->Suid, rc);
> > > > @@ -1090,9 +1186,9 @@ int smb2_query_path_info(const unsigned int x=
id,
> > > >                 break;
> > > >         case -EREMOTE:
> > > >                 break;
> > > > -       default:
> > > > -               if (hdr->Status !=3D STATUS_OBJECT_NAME_INVALID)
> > > > -                       break;
> > > > +       }
> > > > +
> > > > +       if (hdr->Status =3D=3D STATUS_OBJECT_NAME_INVALID) {
> > > >                 rc2 =3D cifs_inval_name_dfs_link_error(xid, tcon, c=
ifs_sb,
> > > >                                                      full_path, &is=
link);
> > > >                 if (rc2) {
> > > > @@ -1101,6 +1197,81 @@ int smb2_query_path_info(const unsigned int =
xid,
> > > >                 }
> > > >                 if (islink)
> > > >                         rc =3D -EREMOTE;
> > > > +       } else if (hdr->Status =3D=3D STATUS_DELETE_PENDING && full=
_path[0]) {
> > > > +               /*
> > > > +                * If SMB2 OPEN/CREATE fails with STATUS_DELETE_PEN=
DING error,
> > > > +                * it means that the path is in delete pending stat=
e and it is
> > > > +                * not possible to open it until some other client =
clears delete
> > > > +                * pending state or all other clients close all ope=
ned handles
> > > > +                * to that path.
> > > > +                *
> > > > +                * There is an alternative way how to query limited=
 information
> > > > +                * about path which is in delete pending state stil=
l suitable
> > > > +                * for the stat() syscall. It is by opening the par=
ent directory,
> > > > +                * querying specific child with filled search filer=
 and asking
> > > > +                * for attributes for that child.
> > > > +                */
> > > > +
> > > > +               char *parent_path;
> > > > +               const char *basename;
> > > > +               __le16 *basename_utf16;
> > > > +               int basename_utf16_len;
> > > > +               struct cifsFileInfo *parent_cfile;
> > > > +
> > > > +               basename =3D strrchr(full_path, CIFS_DIR_SEP(cifs_s=
b));
> > > > +               if (basename) {
> > > > +                       parent_path =3D kstrndup(full_path, basenam=
e - full_path, GFP_KERNEL);
> > > > +                       basename++;
> > > > +               } else {
> > > > +                       parent_path =3D kstrdup("", GFP_KERNEL);
> > > > +                       basename =3D full_path;
> > > > +               }
> > > > +
> > > > +               if (!parent_path) {
> > > > +                       rc =3D -ENOMEM;
> > > > +                       goto out;
> > > > +               }
> > > > +
> > > > +               basename_utf16 =3D cifs_convert_path_to_utf16(basen=
ame, cifs_sb);
> > > > +               if (!basename_utf16) {
> > > > +                       kfree(parent_path);
> > > > +                       rc =3D -ENOMEM;
> > > > +                       goto out;
> > > > +               }
> > > > +
> > > > +               basename_utf16_len =3D 2 * UniStrnlen((wchar_t *)ba=
sename_utf16, PATH_MAX);
> > > > +
> > > > +retry_query_directory:
> > > > +               num_cmds =3D 1;
> > > > +               cmds[0] =3D SMB2_OP_QUERY_DIRECTORY;
> > > > +               in_iov[0].iov_base =3D basename_utf16;
> > > > +               in_iov[0].iov_len =3D basename_utf16_len;
> > > > +               in_iov[1].iov_base =3D data;
> > > > +               in_iov[1].iov_len =3D sizeof(*data);
> > > > +               oparms =3D CIFS_OPARMS(cifs_sb, tcon, parent_path, =
FILE_READ_DATA,
> > > > +                                    FILE_OPEN, CREATE_NOT_FILE, AC=
L_NO_MODE);
> > > > +               cifs_get_readable_path(tcon, parent_path, &parent_c=
file);
> > > > +               free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_i=
ov));
> > > > +               rc =3D smb2_compound_op(xid, tcon, cifs_sb, parent_=
path,
> > > > +                                     &oparms, in_iov, cmds, num_cm=
ds,
> > > > +                                     parent_cfile, out_iov, out_bu=
ftype, NULL);
> > > > +               if (rc =3D=3D -EOPNOTSUPP && (cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_SERVER_INUM)) {
> > > > +                       /*
> > > > +                        * If querying of server inode numbers is n=
ot supported
> > > > +                        * but is enabled, then disable it and try =
again.
> > > > +                        */
> > > > +                       cifs_autodisable_serverino(cifs_sb);
> > > > +                       goto retry_query_directory;
> > > > +               }
> > > > +
> > > > +               kfree(parent_path);
> > > > +               kfree(basename_utf16);
> > > > +
> > > > +               hdr =3D out_iov[0].iov_base;
> > > > +               if (!hdr || out_buftype[0] =3D=3D CIFS_NO_BUFFER)
> > > > +                       goto out;
> > > > +
> > > > +               data->fi.DeletePending =3D 1; /* This is code path =
for STATUS_DELETE_PENDING. */
> > > >         }
> > > >
> > > >  out:
> > > > --
> > > > 2.20.1
> > > >
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

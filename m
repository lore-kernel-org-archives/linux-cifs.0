Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51476157A72
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 14:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759155838; cv=none; b=hcF4Q9qaDxGrwcF9L+6pYIQy6k8C+pG3i29vk+7vJl79wCl6ZcUe+US/STN/Kh8czMaQ1wbafxzQJvxum8jnBEU8R8F+ACRBVu+BlBqueX+QNDaKXjA+rgS8vfocJqNs1Zx8+SkKUBlQvlmJdllRFTuPiICRa4xL39KqteLpTrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759155838; c=relaxed/simple;
	bh=26kSSfMvylbrwZ1/UUtEJiSj6Lcom6bZaDNApPd/dT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y+KjtqSjAK+AFJZQ4HmWPG2wRrHa6zHrMTTkWNndGhy1scE2oX6HFnm5QRdrf3ZpzFqDntxyRF//5WcDZ0wvPfjQBdj5xXDsyfb13AzaalJzE7PmxjVkDoxyqazKQi1PtyDI8eUW40Qg3E2l86VaElN2M33SHRwdSIXk7TwqW3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LXkkkWsc; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LXkkkWsc"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4dca66a31f7so49609061cf.3
        for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 07:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759155835; x=1759760635; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tqREPX/VMFr+ZYfSs7/X5gkPxFV7YT0wNVQ8UnlEQ/4=;
        b=LXkkkWscgwDMWghclx1i8glFaK6IUxp1TLub/hGSkYdwfMbPg1MF47xnuSVTXYl++n
         Lt+VWXWZSX0H02Hfo0GI8MuqoDeIVbr35m/CflzAziNcPw0PhbS2uJuA0VKQZ7jz909R
         ezBGb2YStjeatozSH7B5YU49Qy5d2QXnpRjEgWWaz2JexPybGdMbCB4vWy9ex0DT8/n3
         UHjKn2L815et1RQP3mNuFxGj6weCxwG4hEE3wWeDLKsevBmu1r/Koq30K1FpN5krCz8d
         cXrAW8C3bm2ZPz8uRYP26Kj/pLD+KcvEEs3VxK9XgoIwk38iTmHhOq3zzCxuTLl8HWfT
         5C8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759155835; x=1759760635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tqREPX/VMFr+ZYfSs7/X5gkPxFV7YT0wNVQ8UnlEQ/4=;
        b=tDZXBpnYJd3FHzi5s4hsq02HN7qOZQx8XcJ7STjgISdAJWbDJA8ElFgRSlKUllnswq
         Yk7Hk6WzgF8DfXGr8PgC80gnyaLDuj1LlCRBU3sU2gWKu44/qaYEScxl0un514SWQ+qv
         1YhLYivcJeAF6lRkG1HrS2ICKwDVzXornANnAFg4F+GkRSZ4iz7vizq1Qht8ewNw8vXc
         WyWMgRcCyvHHsxxgI63P/v/XKQvJJcByjGcX0tF2Og4cIFjinaQasfwxgNRhtekkswT4
         xRzNmU/iF6YbKeon/f0zYJr5+eaCHPTjhtCATeTo/TlPpl2fH0XEGJ0epBDehoB8dvPo
         QbTg==
X-Gm-Message-State: AOJu0Ywv2kBIG+PCLMcFD9vY+smOHAluuoCFP76snYrAN7tvQJQKVKiF
	SZKkDClJg8ExbFWbe62g0df12HPKp8LHhyQfYXSo5k9V2y2qZDPN5krX92x5az2RbWLNHB3Gfk3
	DiFGOZE8kmlscwRAswQ5IKgDJcyNRquk=
X-Gm-Gg: ASbGnct/AbUsA0uC9pKWUxe0M0BDFQ8aKbi+h8tcvJM9q03W0qgUxo7Z8dR+0MsED8L
	SfNEKaZ9xI1zIfROSiHh9S1/zxJRHSlsjhNKTebEibk8Mwf7zIVYFGLMazrw61meSFMOslt+lgl
	b1LjjKrTb9nOGOV+/f/gimqtLNPB+tfqdnbU/ZvU/F89XYFiyurAkAUbYp8RIcz9E65pcUBM33x
	2RJb0JnjjHfiLs8P+9O5hkiki6czugqTdS+JixnsdpVeYQnYexKMPf9IYeKRyH2A9EAmlnlPvBq
	VoH+FLSxCKeZanGpGW1gHC7ysmRaT2MJV1S0mL5+iFAQy5JwwzpS/S112PcNEZOK
X-Google-Smtp-Source: AGHT+IF2/zIYs8c+I6msP/SSWo9EiMQa2Q2Rr4xY3tUdNKbguPBPQUixdsll+Gy77T+ykwHrm4NnZPFRo4tKj1E94Ro=
X-Received: by 2002:a05:622a:a06:b0:4b6:3aad:ea41 with SMTP id
 d75a77b69052e-4da4782d4eamr235746401cf.11.1759155834839; Mon, 29 Sep 2025
 07:23:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929132805.220558-1-ematsumiya@suse.de> <20250929132805.220558-13-ematsumiya@suse.de>
In-Reply-To: <20250929132805.220558-13-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Sep 2025 09:23:42 -0500
X-Gm-Features: AS18NWDwl1OGeDJpiA_SCIMFvyiqTfASNhqJKm9k8usj9gM6tKhSROWehmzSCmA
Message-ID: <CAH2r5muhdzfxsXCJpCK+X1BDTVVraA-Wz1ErTNHv2Y1-ADTj3A@mail.gmail.com>
Subject: Re: [PATCH 12/20] smb: client: prevent lease breaks of cached parents
 when opening children
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

This looks potentially very useful but would help to have some simple
repro example

On Mon, Sep 29, 2025 at 8:29=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> In SMB2_open_init(), when opening (not creating/deleting) a path, lookup
> for a cached parent and set ParentLeaseKey in lease context if found.
>
> Other:
> - set oparms->cifs_sb in open_cached_dir() as we need it in
>   add_parent_lease_key(); use CIFS_OPARMS() too
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cached_dir.c | 42 ++++---------------
>  fs/smb/client/dir.c        | 26 +++---------
>  fs/smb/client/smb2inode.c  |  2 +
>  fs/smb/client/smb2pdu.c    | 86 ++++++++++++++++++++++++++++++++------
>  4 files changed, 88 insertions(+), 68 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index ff71f2c06b72..9dd74268b2d8 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -226,7 +226,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon, const char *path,
>         struct cached_fids *cfids;
>         const char *npath;
>         int retries =3D 0, cur_sleep =3D 1;
> -       __le32 lease_flags =3D 0;
>
>         if (cifs_sb->root =3D=3D NULL)
>                 return -ENOENT;
> @@ -236,9 +235,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon, const char *path,
>
>         ses =3D tcon->ses;
>         cfids =3D tcon->cfids;
> -
>         if (!cfids)
>                 return -EOPNOTSUPP;
> +
>  replay_again:
>         /* reinitialize for possible replay */
>         flags =3D 0;
> @@ -306,24 +305,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tc=
on *tcon, const char *path,
>                         rc =3D -ENOENT;
>                         goto out;
>                 }
> -               if (dentry->d_parent && server->dialect >=3D SMB30_PROT_I=
D) {
> -                       struct cached_fid *parent_cfid;
> -
> -                       spin_lock(&cfids->cfid_list_lock);
> -                       list_for_each_entry(parent_cfid, &cfids->entries,=
 entry) {
> -                               if (parent_cfid->dentry =3D=3D dentry->d_=
parent) {
> -                                       if (!cfid_is_valid(parent_cfid))
> -                                               break;
> -
> -                                       cifs_dbg(FYI, "found a parent cac=
hed file handle\n");
> -                                       lease_flags |=3D SMB2_LEASE_FLAG_=
PARENT_LEASE_KEY_SET_LE;
> -                                       memcpy(pfid->parent_lease_key, pa=
rent_cfid->fid.lease_key,
> -                                              SMB2_LEASE_KEY_SIZE);
> -                                       break;
> -                               }
> -                       }
> -                       spin_unlock(&cfids->cfid_list_lock);
> -               }
>         }
>         cfid->dentry =3D dentry;
>         cfid->tcon =3D tcon;
> @@ -350,20 +331,13 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon, const char *path,
>         rqst[0].rq_iov =3D open_iov;
>         rqst[0].rq_nvec =3D SMB2_CREATE_IOV_SIZE;
>
> -       oparms =3D (struct cifs_open_parms) {
> -               .tcon =3D tcon,
> -               .path =3D path,
> -               .create_options =3D cifs_create_options(cifs_sb, CREATE_N=
OT_FILE),
> -               .desired_access =3D  FILE_READ_DATA | FILE_READ_ATTRIBUTE=
S |
> -                                  FILE_READ_EA,
> -               .disposition =3D FILE_OPEN,
> -               .fid =3D pfid,
> -               .lease_flags =3D lease_flags,
> -               .replay =3D !!(retries),
> -       };
> -
> -       rc =3D SMB2_open_init(tcon, server,
> -                           &rqst[0], &oplock, &oparms, utf16_path);
> +       oparms =3D CIFS_OPARMS(cifs_sb, tcon, path,
> +                            FILE_READ_DATA | FILE_READ_ATTRIBUTES | FILE=
_READ_EA, FILE_OPEN,
> +                            cifs_create_options(cifs_sb, CREATE_NOT_FILE=
), 0);
> +       oparms.fid =3D pfid;
> +       oparms.replay =3D !!retries;
> +
> +       rc =3D SMB2_open_init(tcon, server, &rqst[0], &oplock, &oparms, u=
tf16_path);
>         if (rc)
>                 goto oshr_free;
>         smb2_set_next_command(tcon, &rqst[0]);
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index e5372c2c799d..b60af27668bb 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -189,10 +189,9 @@ static int cifs_do_create(struct inode *inode, struc=
t dentry *direntry, unsigned
>         struct inode *newinode =3D NULL;
>         int disposition;
>         struct TCP_Server_Info *server =3D tcon->ses->server;
> +       struct cached_fid *parent_cfid;
>         struct cifs_open_parms oparms;
> -       struct cached_fid *parent_cfid =3D NULL;
>         int rdwr_for_fscache =3D 0;
> -       __le32 lease_flags =3D 0;
>
>         *oplock =3D 0;
>         if (tcon->ses->server->oplocks)
> @@ -314,25 +313,11 @@ static int cifs_do_create(struct inode *inode, stru=
ct dentry *direntry, unsigned
>         if (!tcon->unix_ext && (mode & S_IWUGO) =3D=3D 0)
>                 create_options |=3D CREATE_OPTION_READONLY;
>
> -
>  retry_open:
> -       if (tcon->cfids && direntry->d_parent && server->dialect >=3D SMB=
30_PROT_ID) {
> -               parent_cfid =3D NULL;
> -               spin_lock(&tcon->cfids->cfid_list_lock);
> -               list_for_each_entry(parent_cfid, &tcon->cfids->entries, e=
ntry) {
> -                       if (parent_cfid->dentry =3D=3D direntry->d_parent=
) {
> -                               if (!cfid_is_valid(parent_cfid))
> -                                       break;
> -
> -                               cifs_dbg(FYI, "found a parent cached file=
 handle\n");
> -                               lease_flags |=3D SMB2_LEASE_FLAG_PARENT_L=
EASE_KEY_SET_LE;
> -                               memcpy(fid->parent_lease_key, parent_cfid=
->fid.lease_key,
> -                                      SMB2_LEASE_KEY_SIZE);
> -                               parent_cfid->dirents.is_valid =3D false;
> -                               break;
> -                       }
> -               }
> -               spin_unlock(&tcon->cfids->cfid_list_lock);
> +       parent_cfid =3D find_cached_dir(tcon->cfids, direntry->d_parent, =
CFID_LOOKUP_DENTRY);
> +       if (parent_cfid) {
> +               parent_cfid->dirents.is_valid =3D false;
> +               close_cached_dir(parent_cfid);
>         }
>
>         oparms =3D (struct cifs_open_parms) {
> @@ -343,7 +328,6 @@ static int cifs_do_create(struct inode *inode, struct=
 dentry *direntry, unsigned
>                 .disposition =3D disposition,
>                 .path =3D full_path,
>                 .fid =3D fid,
> -               .lease_flags =3D lease_flags,
>                 .mode =3D mode,
>         };
>         rc =3D server->ops->open(xid, &oparms, oplock, buf);
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 8ccdd1a3ba2c..6d643b8b9547 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1120,6 +1120,8 @@ smb2_mkdir(const unsigned int xid, struct inode *pa=
rent_inode, umode_t mode,
>  {
>         struct cifs_open_parms oparms;
>
> +       drop_cached_dir(tcon->cfids, name, CFID_LOOKUP_PATH);
> +
>         oparms =3D CIFS_OPARMS(cifs_sb, tcon, name, FILE_WRITE_ATTRIBUTES=
,
>                              FILE_CREATE, CREATE_NOT_FILE, mode);
>         return smb2_compound_op(xid, tcon, cifs_sb,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 07ba61583114..2474ac18b85e 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2419,7 +2419,8 @@ add_lease_context(struct TCP_Server_Info *server,
>         if (iov[num].iov_base =3D=3D NULL)
>                 return -ENOMEM;
>         iov[num].iov_len =3D server->vals->create_lease_size;
> -       req->RequestedOplockLevel =3D SMB2_OPLOCK_LEVEL_LEASE;
> +       /* keep the requested oplock level in case of just setting Parent=
LeaseKey */
> +       req->RequestedOplockLevel =3D *oplock;
>         *num_iovec =3D num + 1;
>         return 0;
>  }
> @@ -3001,6 +3002,50 @@ int smb311_posix_mkdir(const unsigned int xid, str=
uct inode *inode,
>         return rc;
>  }
>
> +/*
> + * When opening a path, set ParentLeaseKey in @oparms if its parent is c=
ached.
> + * We only have RH caching for dirs, so skip this on mkdir, unlink, rmdi=
r.
> + *
> + * Ref: MS-SMB2 3.3.5.9 and MS-FSA 2.1.5.1
> + *
> + * Return: 0 if ParentLeaseKey was set in @oparms, -errno otherwise.
> + */
> +static int check_cached_parent(struct cached_fids *cfids, struct cifs_op=
en_parms *oparms)
> +{
> +       struct cached_fid *cfid;
> +       const char *parent_path, *path;
> +
> +       if (!cfids || !oparms || !oparms->cifs_sb || !*oparms->path)
> +               return -EINVAL;
> +
> +       if ((oparms->disposition =3D=3D FILE_CREATE && oparms->create_opt=
ions =3D=3D CREATE_NOT_FILE) ||
> +           oparms->desired_access =3D=3D DELETE)
> +               return -EOPNOTSUPP;
> +
> +       path =3D oparms->path;
> +       parent_path =3D strrchr(path, CIFS_DIR_SEP(oparms->cifs_sb));
> +       if (!parent_path)
> +               return -ENOENT;
> +
> +       parent_path =3D kstrndup(path, parent_path - path, GFP_KERNEL);
> +       if (!parent_path)
> +               return -ENOMEM;
> +
> +       cfid =3D find_cached_dir(cfids, parent_path, CFID_LOOKUP_PATH);
> +       kfree(parent_path);
> +
> +       if (!cfid)
> +               return -ENOENT;
> +
> +       cifs_dbg(FYI, "%s: found cached parent for path: %s\n", __func__,=
 oparms->path);
> +
> +       memcpy(oparms->fid->parent_lease_key, cfid->fid.lease_key, SMB2_L=
EASE_KEY_SIZE);
> +       oparms->lease_flags |=3D SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
> +       close_cached_dir(cfid);
> +
> +       return 0;
> +}
> +
>  int
>  SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
>                struct smb_rqst *rqst, __u8 *oplock,
> @@ -3077,20 +3122,35 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP=
_Server_Info *server,
>         iov[1].iov_len =3D uni_path_len;
>         iov[1].iov_base =3D path;
>
> -       if ((!server->oplocks) || (tcon->no_lease))
> +       if (!server->oplocks || tcon->no_lease)
>                 *oplock =3D SMB2_OPLOCK_LEVEL_NONE;
>
> -       if (!(server->capabilities & SMB2_GLOBAL_CAP_LEASING) ||
> -           *oplock =3D=3D SMB2_OPLOCK_LEVEL_NONE)
> -               req->RequestedOplockLevel =3D *oplock;
> -       else if (!(server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEASI=
NG) &&
> -                 (oparms->create_options & CREATE_NOT_FILE))
> -               req->RequestedOplockLevel =3D *oplock; /* no srv lease su=
pport */
> -       else {
> -               rc =3D add_lease_context(server, req, iov, &n_iov,
> -                                      oparms->fid->lease_key, oplock,
> -                                      oparms->fid->parent_lease_key,
> -                                      oparms->lease_flags);
> +       req->RequestedOplockLevel =3D *oplock;
> +
> +       /*
> +        * MS-SMB2 "Product Behavior" says Windows only checks/sets Paren=
tLeaseKey when a lease is
> +        * requested for the child/target.
> +        * Practically speaking, adding the lease context with ParentLeas=
eKey set, even with oplock
> +        * none, works fine.
> +        * As a precaution, however, only set it for oplocks !=3D none.
> +        */
> +       if ((server->capabilities & SMB2_GLOBAL_CAP_LEASING) &&
> +           *oplock !=3D SMB2_OPLOCK_LEVEL_NONE) {
> +               rc =3D -EOPNOTSUPP;
> +               if (server->capabilities & SMB2_GLOBAL_CAP_DIRECTORY_LEAS=
ING)
> +                       rc =3D check_cached_parent(tcon->cfids, oparms);
> +
> +               /*
> +                * -ENOENT just means we couldn't find a cached parent, b=
ut we do have dir leasing,
> +                * so try requesting a level II oplock for the child path=
.
> +                */
> +               if ((!rc || rc =3D=3D -ENOENT) && *oplock =3D=3D SMB2_OPL=
OCK_LEVEL_NONE)
> +                       *oplock =3D SMB2_OPLOCK_LEVEL_II;
> +
> +               if (*oplock !=3D SMB2_OPLOCK_LEVEL_NONE)
> +                       rc =3D add_lease_context(server, req, iov, &n_iov=
, oparms->fid->lease_key,
> +                                              oplock, oparms->fid->paren=
t_lease_key,
> +                                              oparms->lease_flags);
>                 if (rc)
>                         return rc;
>         }
> --
> 2.49.0
>


--=20
Thanks,

Steve

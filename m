Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637FA309DC6
	for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 14:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759155988; cv=none; b=C/KzD4SfX01ptCFgKgSCdckNzmecEOJQJ+KtMWyvJmF8G4xxbBE9nCNZqq30AtkHN+G2BjgnGLLgGlkXJlRb2FFkKLIh/mG9DnXd0G9QROOq4+aR0nwOUt1j7PcXbImLDuR+9iCysaNTT4VBP5AcrwhhC39xPltmzGo4aJe/Szw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759155988; c=relaxed/simple;
	bh=+yk2wr1PQNsUZcoE0CMxK8+/Kc6JU32mx6eOFZOMOeQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n2tESEHNKSHk8grPMEad5vDEyRCCR+kO4D+ZID8ROmYvqHeO2TmaI3KYGmgUNM+KrUtEs4ql8xQasz4CXtqeA/e0+iQcb0lMdn0fvfOWrQNUmftJPvzzk9GA0xBHt1uK8ypAOylENKHEyMxl4//J0HFxKHmA8hWS5T4D38MitwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R21q3+h4; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R21q3+h4"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-78f15d58576so42550006d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 29 Sep 2025 07:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759155985; x=1759760785; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCS+XQGFvOAJBJ0TDm5uRXhIFoKRSdTjFsS4OrRmZ0Q=;
        b=R21q3+h4diSFCMVLJONOTN8pEdUnFb+eyCdmQ1LAooF+e2OSAZE/bvPM4eTEBf/XBq
         Iqy/G9fKOm5bog3GJQ1gL+kXmaE9ogPHWPtSF0wU/R5O2jZN9JAnB5ns6QodRoxzVtRR
         tR2YizEIZNv4QdP3tPXgqq81NOMaEBDKPu6XjLc6uuUtjU+DZJz7dilGS9N9faZ++ClZ
         gJV9PKfylx7OOEL/VFpIMXDZVw0Xw6/zDFMq20ZGnO60e1oMuq5tb1GZ5gDNINOAjS3k
         D8ECTV8UUT1v7nejnYPblbcPkXNW/n28Bl2xyyh+dOcWGPvjz2zmmZBtbkYt3xoYTiSm
         NMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759155985; x=1759760785;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCS+XQGFvOAJBJ0TDm5uRXhIFoKRSdTjFsS4OrRmZ0Q=;
        b=HkNxdQDsq+L6iq7dshzSCWJC7ggTFMxZ64p24Ai0xsL2bVWMZhXzpymMDcQAwvZ08A
         ZpR0baitIQ7qXczlcpoRq6cSU3gq8stKMlaH2oDQ7GBaUC9v6cs9din5/EoV7PP1MYPB
         dKJv6hdV+KO4dWW57+has8zpVuxEPDXpSnBef8+ddBvpLOE6LdCMRrkQZfPEW/VUnFDl
         foZXf763tqS7Ab7KgR62nN27auPErx2JvqEPYj8vJXSnS18bjprm0fCtBtuQzcCPTdLb
         OK2UyqA2FVn0pV3WKNZ6CGGRH/JiN/I/XQHRqFGrKslnpBRsDVS5nf4DdGJOw7GmdvU/
         QOPg==
X-Gm-Message-State: AOJu0Yx4IyBoTV1wQaxsmYvqrc1U/poM5HLyWD4sEd26bB8zTUmt2+wQ
	WbSYzBS2VOQ3XP3qAO0LMveWWZdjDtyR6P5LeLrygQfQ04+5HXizSPT7KHjdyTXo0njYpSx51b+
	MLMQ6AectkeA22UhqQQsC1wZH1cbPAwo=
X-Gm-Gg: ASbGncsFXMYGW2CD/r0Ywv9zUwHIlrO6h95mCj63hKGM04AANYd4+k2X7y1cETNvisd
	EI5YhNRdve3wcy2f+Ez8IHdPvgY2V5pve1IvYufA0y/j7asHHX21Pjf+MuYYOU3xF7X2egaqfuv
	TVTxbwbpgiK4Odqjtn3vjYuqoGlT0+MC20/rRXR7ZECLxsOLMrlj0gvVdRTUM0xf+1FBgoSFAGG
	3Tz0zBNKroJY08K+drIiSh/ebyZHH5jDjCMQaM57+hcuLUbYYjLvVJ/rcyBAbaody6iRrFyZJ8g
	zWMboshXtMA4eEMSH0b1BAPh+L+c8NqGCS0VvXKCO/Rcf9EhzbFevnZCQboW3PDDM6cUNNU968A
	=
X-Google-Smtp-Source: AGHT+IEEG2TLskFQHWaPYvaSsuTDTUKjgzR9cgTJpyzAZOUp1KRdXSfchzPF9a0duFAF+oW0jmXBunKihp4G9vI5URA=
X-Received: by 2002:a05:6214:2625:b0:78e:5985:92f1 with SMTP id
 6a1803df08f44-869973a156fmr11350396d6.11.1759155984954; Mon, 29 Sep 2025
 07:26:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250929132805.220558-1-ematsumiya@suse.de> <20250929132805.220558-18-ematsumiya@suse.de>
In-Reply-To: <20250929132805.220558-18-ematsumiya@suse.de>
From: Steve French <smfrench@gmail.com>
Date: Mon, 29 Sep 2025 09:26:13 -0500
X-Gm-Features: AS18NWDuap-oePh6VqSPVktQAK2wKmU0f_h2kfEjZme6NClVplr2SH1cxv3I9H0
Message-ID: <CAH2r5msNGYd+EXKe9n4+3KLfj9Z4F9=Xe8J=HuuxkfyqWtTaQw@mail.gmail.com>
Subject: Re: [PATCH 17/20] smb: client: use cached dir on queryfs/smb2_compound_op
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	henrique.carvalho@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Would be helpful to show simple command example where this reduces ops

On Mon, Sep 29, 2025 at 8:29=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> A dentry is passed to cifs_statfs(), so pass down d_is_dir() to
> smb2_queryfs() so we can cache/reuse this dir.
>
> Other:
> - make smb2_compound_op a static function, as it's not used anywhere
>   else
>
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/client/cifsfs.c    |  2 +-
>  fs/smb/client/cifsglob.h  |  2 +-
>  fs/smb/client/smb1ops.c   |  2 +-
>  fs/smb/client/smb2ops.c   | 32 +++++++++++++++++---------------
>  fs/smb/client/smb2proto.h |  6 ------
>  5 files changed, 20 insertions(+), 24 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index e1848276bab4..a2ecc5649860 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -339,7 +339,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *bu=
f)
>         buf->f_ffree =3D 0;       /* unlimited */
>
>         if (server->ops->queryfs)
> -               rc =3D server->ops->queryfs(xid, tcon, full_path, cifs_sb=
, buf);
> +               rc =3D server->ops->queryfs(xid, tcon, full_path, cifs_sb=
, buf, d_is_dir(dentry));
>
>  statfs_out:
>         free_dentry_path(page);
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 08c8131c8018..dddac55abd6f 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -519,7 +519,7 @@ struct smb_version_operations {
>                         __u16 net_fid, struct cifsInodeInfo *cifs_inode);
>         /* query remote filesystem */
>         int (*queryfs)(const unsigned int, struct cifs_tcon *,
> -                      const char *, struct cifs_sb_info *, struct kstatf=
s *);
> +                      const char *, struct cifs_sb_info *, struct kstatf=
s *, bool);
>         /* send mandatory brlock to the server */
>         int (*mand_lock)(const unsigned int, struct cifsFileInfo *, __u64=
,
>                          __u64, __u32, int, int, bool);
> diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
> index d964bc9c2823..9fa1ff9ea70d 100644
> --- a/fs/smb/client/smb1ops.c
> +++ b/fs/smb/client/smb1ops.c
> @@ -1105,7 +1105,7 @@ cifs_oplock_response(struct cifs_tcon *tcon, __u64 =
persistent_fid,
>
>  static int
>  cifs_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf)
> +            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf, bool is_dir)
>  {
>         int rc =3D -EOPNOTSUPP;
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 8842315d2526..f691271463b5 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -1110,6 +1110,11 @@ move_smb2_ea_to_cifs(char *dst, size_t dst_size,
>         return (ssize_t)rc;
>  }
>
> +static int smb2_query_info_compound(const unsigned int xid, struct cifs_=
tcon *tcon,
> +                                   const char *path, u32 desired_access,=
 u32 class, u32 type,
> +                                   u32 output_len, struct kvec *rsp, int=
 *buftype,
> +                                   struct cifs_sb_info *cifs_sb, bool is=
_dir);
> +
>  static ssize_t
>  smb2_query_eas(const unsigned int xid, struct cifs_tcon *tcon,
>                const unsigned char *path, const unsigned char *ea_name,
> @@ -1129,7 +1134,7 @@ smb2_query_eas(const unsigned int xid, struct cifs_=
tcon *tcon,
>                                       CIFSMaxBufSize -
>                                       MAX_SMB2_CREATE_RESPONSE_SIZE -
>                                       MAX_SMB2_CLOSE_RESPONSE_SIZE,
> -                                     &rsp_iov, &buftype, cifs_sb);
> +                                     &rsp_iov, &buftype, cifs_sb, false)=
;
>         if (rc) {
>                 /*
>                  * If ea_name is NULL (listxattr) and there are no EAs,
> @@ -1231,7 +1236,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>                                       CIFSMaxBufSize -
>                                       MAX_SMB2_CREATE_RESPONSE_SIZE -
>                                       MAX_SMB2_CLOSE_RESPONSE_SIZE,
> -                                     &rsp_iov[1], &resp_buftype[1], cifs=
_sb);
> +                                     &rsp_iov[1], &resp_buftype[1], cifs=
_sb, false);
>                         if (rc =3D=3D 0) {
>                                 rsp =3D (struct smb2_query_info_rsp *)rsp=
_iov[1].iov_base;
>                                 used_len =3D le32_to_cpu(rsp->OutputBuffe=
rLength);
> @@ -2694,12 +2699,10 @@ bool smb2_should_replay(struct cifs_tcon *tcon,
>   * Passes the query info response back to the caller on success.
>   * Caller need to free this with free_rsp_buf().
>   */
> -int
> -smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
> -                        const char *path, u32 desired_access,
> -                        u32 class, u32 type, u32 output_len,
> -                        struct kvec *rsp, int *buftype,
> -                        struct cifs_sb_info *cifs_sb)
> +static int smb2_query_info_compound(const unsigned int xid, struct cifs_=
tcon *tcon,
> +                                   const char *path, u32 desired_access,=
 u32 class, u32 type,
> +                                   u32 output_len, struct kvec *rsp, int=
 *buftype,
> +                                   struct cifs_sb_info *cifs_sb, bool is=
_dir)
>  {
>         struct smb2_compound_vars *vars;
>         struct cifs_ses *ses =3D tcon->ses;
> @@ -2741,9 +2744,9 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>         rsp_iov =3D vars->rsp_iov;
>
>         /*
> -        * We can only call this for things we know are directories.
> +        * We can only open + cache paths we know are directories.
>          */
> -       if (!strcmp(path, ""))
> +       if (is_dir)
>                 /* cfid null if open dir failed */
>                 open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
>
> @@ -2852,7 +2855,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>
>  static int
>  smb2_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf)
> +            const char *path, struct cifs_sb_info *cifs_sb, struct kstat=
fs *buf, bool is_dir)
>  {
>         struct smb2_query_info_rsp *rsp;
>         struct smb2_fs_full_size_info *info =3D NULL;
> @@ -2860,13 +2863,12 @@ smb2_queryfs(const unsigned int xid, struct cifs_=
tcon *tcon,
>         int buftype =3D CIFS_NO_BUFFER;
>         int rc;
>
> -
>         rc =3D smb2_query_info_compound(xid, tcon, path,
>                                       FILE_READ_ATTRIBUTES,
>                                       FS_FULL_SIZE_INFORMATION,
>                                       SMB2_O_INFO_FILESYSTEM,
>                                       sizeof(struct smb2_fs_full_size_inf=
o),
> -                                     &rsp_iov, &buftype, cifs_sb);
> +                                     &rsp_iov, &buftype, cifs_sb, is_dir=
);
>         if (rc)
>                 goto qfs_exit;
>
> @@ -2889,7 +2891,7 @@ smb2_queryfs(const unsigned int xid, struct cifs_tc=
on *tcon,
>
>  static int
>  smb311_queryfs(const unsigned int xid, struct cifs_tcon *tcon,
> -              const char *path, struct cifs_sb_info *cifs_sb, struct kst=
atfs *buf)
> +              const char *path, struct cifs_sb_info *cifs_sb, struct kst=
atfs *buf, bool is_dir)
>  {
>         int rc;
>         __le16 *utf16_path =3D NULL;
> @@ -2898,7 +2900,7 @@ smb311_queryfs(const unsigned int xid, struct cifs_=
tcon *tcon,
>         struct cifs_fid fid;
>
>         if (!tcon->posix_extensions)
> -               return smb2_queryfs(xid, tcon, path, cifs_sb, buf);
> +               return smb2_queryfs(xid, tcon, path, cifs_sb, buf, is_dir=
);
>
>         oparms =3D (struct cifs_open_parms) {
>                 .tcon =3D tcon,
> diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
> index 3e3faa7cf633..99326810a159 100644
> --- a/fs/smb/client/smb2proto.h
> +++ b/fs/smb/client/smb2proto.h
> @@ -299,12 +299,6 @@ extern int smb311_crypto_shash_allocate(struct TCP_S=
erver_Info *server);
>  extern int smb311_update_preauth_hash(struct cifs_ses *ses,
>                                       struct TCP_Server_Info *server,
>                                       struct kvec *iov, int nvec);
> -extern int smb2_query_info_compound(const unsigned int xid,
> -                                   struct cifs_tcon *tcon,
> -                                   const char *path, u32 desired_access,
> -                                   u32 class, u32 type, u32 output_len,
> -                                   struct kvec *rsp, int *buftype,
> -                                   struct cifs_sb_info *cifs_sb);
>  /* query path info from the server using SMB311 POSIX extensions*/
>  int smb311_posix_query_path_info(const unsigned int xid,
>                                  struct cifs_tcon *tcon,
> --
> 2.49.0
>


--=20
Thanks,

Steve

Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FDE3D47A3
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785180778; cv=pass; b=C9iMANFSfTdzE7AeuXdZCnN1bzHU8Z+vmg8Sv9FzQeMQMx9rZ7r3fUoiPYAkWZJ8W7mtHpOPeQjvNtF0QDaxWQGrtMQJ1l4XHItOOo8YR4JFxupaj2XBjPP4yXDF6JmAcuJvbTX1XaM0m9HX5XkvLC4h1JFlz4H8TUPkPv1o73k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785180778; c=relaxed/simple;
	bh=cRN14V5PqW0j73A1ASuvDEkG4z/xlGeTTWGDmUQyy3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HDH64GH2qqcHFNhogmqwhhCMgNZYHCYcd6AoQyDRbcm0UYyFqtEuEZQcmUJrd2QRz4+DBB42RDeXtOZEq14Y2mxNezjlSrGUmcT6c8sTqyzP6Klp6ySRolJUp8wwoaGDbyR8R63SEt+7E4SdNGJCVLhouztnkJ3cWerTlyj/ddQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inE/07mM; arc=pass smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inE/07mM"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso4394407a91.1
        for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 12:32:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785180776; cv=none;
        d=google.com; s=arc-20260327;
        b=X5sO7ZzJ1Hrw8rQ4/QRTtwURPKe9w057hiNZpZNqToeqedJ/Hcx/KL6uL+F2xt2O6g
         GX8Erb8ZbNK7TMa3/2J/z+ES4seHfJhsH2jue0dum0OaWyQoGAoP0yr8ukloHvOIWUBF
         m/XgVWWQKfYIxoKaR7sKKSKf6iuVfDzy5c8cIhqIUozBlD2szWv4Zg1Z0NO9iuUS9GNO
         o2JpDBkYWpDbQFav/angB6vShM5lQ3Ms9V11scCtDVTOAkpxKpJDWztExctYIJmKVjjL
         g/nfVlpOb/hBsb/WCsQQypylwg3gxfpBly/oS/8O0OKy+eF3Y0E5cJ4tMaWqLewqyPG/
         e8Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0QS/aDvpvt9OZjo08FZUrCVVwABGioVP1vNRnJUUgXQ=;
        fh=CrN8lXKxNjDpqn3yD3fIgdekbDPyIDVwz3AQTgpw5s8=;
        b=BHHGz73nOBqwmtx7Xfik6GK+F3/Mj0W59Y/JNSfJGWt7zKn9mFdFn96YxQP903/nZJ
         yXrsnh1tLv4TUCDfFfeotshq/pmvnV3VMs5MtC9NwXi6TO0vwP05H1uc0w51k9OiDHgt
         QcgMr2/Y5TdZDrDfykLLsUMUNLsl3sB3C4LNV63kA9qhUylnoUhIU/6vWtzsxvgJbOuj
         YJRzVii/7D8A+waWBJEpX8hYl9+GUidhUOoZ/+MWTSaY4ikC6mbXaTadqYhao3z4wN26
         tdIm+pnyRdXBCco3cxIOhsUaYOtojwmhrgBeaKal6ghd0Xk6vyODNDKVOEOuh/QgZCfD
         P81A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785180776; x=1785785576; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0QS/aDvpvt9OZjo08FZUrCVVwABGioVP1vNRnJUUgXQ=;
        b=inE/07mMuJIcRn+3tfXn0NXzEOS/YPwzKxuO9Z3a300KakJl03BGiK6jBnMivVRB4T
         qgNTmSvCWWvoVssanDYr6TaOrTR4LzopvUwKhRZyJF7CFv6MWqWh4XfnNgAZxNGL8RIj
         uaL4442ld3zXpTKPTcj/5vDAD5uwH7v1bYJHegxMVb8t4KnaSBcIEbEg7gAuZdc30qam
         6dtxdVUcJukTsxLGbVSahXHWlwGfM5N8J8wJDt5xLOuMzNnQxlq8VddGuIgaaj8qj2x2
         M0/NfskA4LZkUhIoq/Pv7+glisqTglMZpRy3NqmDUVMdnDhEW2QCGrnVy7DNadqw9yb4
         jMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785180776; x=1785785576;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0QS/aDvpvt9OZjo08FZUrCVVwABGioVP1vNRnJUUgXQ=;
        b=YI0s8d51mgh2QpzbhWHQ2J9ynsraQNmlAj1TtHGBNYuHKLyhqjrGCEJpl4uCEuMphN
         vnbVrxiAEiTRC8gcjAXQenbbNZ4eUd+RDo9kzcA2m0PtmzNZCDwC+oA6XPQvmUdymepp
         HLosQ+R5wMIKO1FYfhceYv7HcFsycRlW/JllTfqgpkf5swgVrsB5zqW9kyXbfCiEKfD3
         v1yaf7JimtywPr28U+GHfeIADgPGcMtoJgLBxPesJ9+oxuQ7zKnLDVOiB4yjYSkCHYw0
         vvoVCKoX6f2J9sI6u0HAm1KvJ84pAUr8YicN9o1f5HIhb1UV/kWexzJXl4hsLufAoe/h
         iVsQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4XRHhLoqjubuf7yRq3hPEAJYCB3BhUxU0/TXcISFxRFhDFMl4s6EmzoKstaVzkyyBAWjJL13XSFWT@vger.kernel.org
X-Gm-Message-State: AOJu0YwAoIUdxXuNp6vhKrZK/Tq77Rsaq3xTlc38XyV5SrchNA6KKYeG
	MUwtMNPIOJV4AYF5tl5czqOMJZkxFEA/LkrwK2a2/8xqWNgM2egeBRko6Um5VpobIC25m4WacmF
	rO0DMA+5aSgjHEAWv+BZCfS2k6aXy4X8=
X-Gm-Gg: AR+sD100ZYCUMb93G859YxnzutunUhn94EoLQN7lgahPYWiZ2rjhdob/5s6o8gx+oBI
	6z3rkUnDWAwJUt7ihKK+RSrCHyZ/IM1pe0HPNXXhnLBAbTowq4AuTXaT5qzgodtJnxYyWjp7HBR
	jBMZ9IWGcxeWjE+ULa/iWkSVTa4f7w6GrpbBeVVNivoFN6VewE5ewLVOaMIGLVe9LGw6HUxhhOX
	iuGy0Ybat95adDgOO1uucv9bTuPBN8q09qoGX+7r6YWBW7Ql6Myh52BOjydmTprwdFYlhttF/ak
	0rQ8Jupfjg7A2f+GsPlgZWIRcD0JbLsoNMI4HhZGEw==
X-Received: by 2002:a17:90b:5706:b0:38e:101f:c867 with SMTP id
 98e67ed59e1d1-38f295232dcmr9447393a91.18.1785180775618; Mon, 27 Jul 2026
 12:32:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260727130827.1100080-1-dhowells@redhat.com> <20260727130827.1100080-9-dhowells@redhat.com>
In-Reply-To: <20260727130827.1100080-9-dhowells@redhat.com>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Mon, 27 Jul 2026 16:32:43 -0300
X-Gm-Features: AUfX_mxXeZ9B1ErvAPGqD7SJ0--YBDsGi02woSWlxC1HAnkhzOLHdtYmqstk4DE
Message-ID: <CAB9dFdu+tuOkBmFPKve2Xwt1+JkFJOatCwEXaM+ZNT46AAqGHQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] afs, bash: Fix open(O_CREAT) on an extant AFS file in
 a sticky dir
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Etienne Champetier <champetier.etienne@gmail.com>, Jeffrey Altman <jaltman@auristor.com>, 
	Chet Ramey <chet.ramey@case.edu>, Cheyenne Wills <cwills@sinenomine.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Steve French <sfrench@samba.org>, openafs-devel@openafs.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 27, 2026 at 10:09=E2=80=AFAM David Howells <dhowells@redhat.com=
> wrote:
>
> Since version 1.11 (January 1992) Bash has a work around in redir_open()
> that causes open(O_CREAT) of a file to be retried without O_CREAT if open=
()
> fails with an EACCES error if bash was built with AFS workarounds
> configured:
>
>         #if defined (AFS)
>               if ((fd < 0) && (errno =3D=3D EACCES))
>             {
>               fd =3D open (filename, flags & ~O_CREAT, mode);
>               errno =3D EACCES;    /* restore errno */
>             }
>
>         #endif /* AFS */
>
> The ~O_CREAT fallback logic was introduced to workaround a bug[1] in the
> IBM AFS 3.1 cache manager and server which can return EACCES in preferenc=
e
> to EEXIST if the requested file exists but the caller is neither granted
> explicit PRSFS_READ permission nor is the file owner and is granted
> PRSFS_INSERT permission on the directory.  IBM AFS 3.2 altered the cache
> manager permission checks but failed to correct the permission checks in
> the AFS server.  As of this writing, all IBM AFS derived servers continue
> to return EACCES in preference to EEXIST when these conditions are met.
> Bug reports have been filed with all implementations.
>
> As an unintended side effect, the Bash fallback logic also undermines the
> Linux kernel protections against O_CREAT opening FIFOs and regular files
> not owned by the user in world writeable sticky directories - unless the
> owner is the same as that of the directory - as was added in commit
> 30aba6656f61e ("namei: allow restricted O_CREAT of FIFOs and regular
> files").
>
> As a result the Bash fallback logic masks an incompatibility between the
> ownership checks performed by may_create_in_sticky() and network
> filesystems such as AFS where the uid namespace is disjoint from the uid
> namespace of the local system.
>
> However, the bash work around is going to be removed[2].
>
> Fix this in the kernel by using a preceding patch that allows the user ID
> comparisons to be overridden by:
>
>  (1) Implement the ->is_owned_by_me() inode op for kafs to determine if t=
he
>      caller owns the file by checking to see if the server indicated the
>      ADMINISTER bit was set in the access rights returned by the
>      FS.FetchStatus and suchlike instead of checking the i_uid to
>      current_fsuid().
>
>      Unfortunately, this check doesn't work for directories, but none of
>      the ops should require that.
>
>      Note that anonymous accesses to AFS will never see the ADMINISTER bi=
t
>      being set and so will not be perceived as owning an anonymously-owne=
d
>      file.
>
>  (2) Implement the ->have_same_owner() inode op, for kafs to compare the
>      AFS owner IDs retrieved by FS.FetchStatus (which are 64-bit integers
>      with AuriStor's YFS server and, as such, won't fit in a kuid_t).
>
>      Note that whilst an anonymously-owned file will match an
>      anonymously-owned parent directory, an anonymously-owned directory
>      cannot have the sticky bit set.
>
> This can be tested by creating a sticky directory (the user must have a
> token to do this) and creating a file in it.  Then strace bash doing "ech=
o
> foo >>file" and look at whether bash does a single, successful O_CREAT op=
en
> on the file or whether that one fails and then bash does one without
> O_CREAT that succeeds.
>
> Fixes: 30aba6656f61 ("namei: allow restricted O_CREAT of FIFOs and regula=
r files")
> Reported-by: Etienne Champetier <champetier.etienne@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Marc Dionne <marc.dionne@auristor.com>
> cc: Jeffrey Altman <jaltman@auristor.com>
> cc: Chet Ramey <chet.ramey@case.edu>
> cc: Cheyenne Wills <cwills@sinenomine.net>
> cc: Alexander Viro <viro@zeniv.linux.org.uk>
> cc: Christian Brauner <brauner@kernel.org>
> cc: Steve French <sfrench@samba.org>
> cc: linux-afs@lists.infradead.org
> cc: openafs-devel@openafs.org
> cc: linux-cifs@vger.kernel.org
> cc: linux-fsdevel@vger.kernel.org
> Link: https://groups.google.com/g/gnu.bash.bug/c/6PPTfOgFdL4/m/2AQU-S1N76=
UJ [1]
> Link: https://git.savannah.gnu.org/cgit/bash.git/tree/redir.c?h=3Dbash-5.=
3-rc1#n733 [2]
> ---
>  fs/afs/dir.c      |  2 ++
>  fs/afs/file.c     |  2 ++
>  fs/afs/inode.c    |  1 +
>  fs/afs/internal.h |  3 +++
>  fs/afs/security.c | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 54 insertions(+)
>
> diff --git a/fs/afs/dir.c b/fs/afs/dir.c
> index 6df56fe9163f..ee2f5ec0b2c6 100644
> --- a/fs/afs/dir.c
> +++ b/fs/afs/dir.c
> @@ -69,6 +69,8 @@ const struct inode_operations afs_dir_inode_operations =
=3D {
>         .permission     =3D afs_permission,
>         .getattr        =3D afs_getattr,
>         .setattr        =3D afs_setattr,
> +       .is_owned_by_me =3D afs_is_owned_by_me,
> +       .have_same_owner =3D afs_have_same_owner,
>  };
>
>  const struct address_space_operations afs_dir_aops =3D {
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index 0467742bfeee..ba44493ccaf6 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -49,6 +49,8 @@ const struct inode_operations afs_file_inode_operations=
 =3D {
>         .getattr        =3D afs_getattr,
>         .setattr        =3D afs_setattr,
>         .permission     =3D afs_permission,
> +       .is_owned_by_me =3D afs_is_owned_by_me,
> +       .have_same_owner =3D afs_have_same_owner,
>  };
>
>  const struct address_space_operations afs_file_aops =3D {
> diff --git a/fs/afs/inode.c b/fs/afs/inode.c
> index 14f39a9bea6c..af85a88d943d 100644
> --- a/fs/afs/inode.c
> +++ b/fs/afs/inode.c
> @@ -91,6 +91,7 @@ static int afs_inode_init_from_status(struct afs_operat=
ion *op,
>         inode->i_flags |=3D S_NOATIME;
>         inode->i_uid =3D make_kuid(&init_user_ns, status->owner);
>         inode->i_gid =3D make_kgid(&init_user_ns, status->group);
> +       inode->i_opflags |=3D IOP_OWNERSHIP_OVERRIDE;

This sets IOP_OWNERSHIP_OVERRIDE for all inodes, but the ops are only
defined for files and directories.  The vfs_inode* helpers will oops
if the subject is not a file or a directory (a symlink for instance).

>         set_nlink(&vnode->netfs.inode, status->nlink);
>
>         i_size_write(inode, status->size);
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 330654ed16ec..40e5ce619476 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -1539,6 +1539,9 @@ extern struct key *afs_request_key(struct afs_cell =
*);
>  extern struct key *afs_request_key_rcu(struct afs_cell *);
>  extern int afs_check_permit(struct afs_vnode *, struct key *, afs_access=
_t *);
>  extern int afs_permission(struct mnt_idmap *, struct inode *, int);
> +int afs_is_owned_by_me(struct mnt_idmap *idmap, struct inode *inode);
> +int afs_have_same_owner(struct mnt_idmap *idmap, struct inode *inode1,
> +                       struct inode *inode2);
>  extern void __exit afs_clean_up_permit_cache(void);
>
>  /*
> diff --git a/fs/afs/security.c b/fs/afs/security.c
> index 6d00d62a65ed..7092f5acdcd6 100644
> --- a/fs/afs/security.c
> +++ b/fs/afs/security.c
> @@ -510,6 +510,52 @@ int afs_permission(struct mnt_idmap *idmap, struct i=
node *inode,
>         return ret;
>  }
>
> +/*
> + * Determine if an inode is owned by 'me' - whatever that means for the
> + * filesystem.  In the case of AFS, this means that the file is owned by=
 the
> + * AFS user represented by the Rx Security Class token held in a key.  R=
eturns
> + * 0 if owned by me, 1 if not; can also return an error.
> + */
> +int afs_is_owned_by_me(struct mnt_idmap *idmap, struct inode *inode)
> +{
> +       struct afs_vnode *vnode =3D AFS_FS_I(inode);
> +       afs_access_t access;
> +       struct key *key;
> +       int ret;
> +
> +       if (S_ISDIR(inode->i_mode))
> +               return 1; /* The ADMIN right check doesn't work for direc=
tories. */
> +
> +       key =3D afs_request_key(vnode->volume->cell);
> +       if (IS_ERR(key))
> +               return PTR_ERR(key);
> +
> +       /* Get the access rights for the key on this file. */
> +       ret =3D afs_check_permit(vnode, key, &access);
> +       if (ret < 0)
> +               goto error;
> +
> +       /* We get the ADMINISTER bit if we own the file. */
> +       ret =3D (access & AFS_ACE_ADMINISTER) ? 0 : 1;
> +error:
> +       key_put(key);
> +       return ret;
> +}
> +
> +/*
> + * Determine if a file has the same owner as its parent - whatever that =
means
> + * for the filesystem.  In the case of AFS, this means comparing their A=
FS
> + * UIDs.  Returns 0 if same, 1 if not same; can also return an error.
> + */
> +int afs_have_same_owner(struct mnt_idmap *idmap, struct inode *inode1,
> +                       struct inode *inode2)
> +{
> +       const struct afs_vnode *vnode1 =3D AFS_FS_I(inode1);
> +       const struct afs_vnode *vnode2 =3D AFS_FS_I(inode2);
> +
> +       return vnode1->status.owner !=3D vnode2->status.owner;
> +}
> +
>  void __exit afs_clean_up_permit_cache(void)
>  {
>         int i;
>
>

Marc

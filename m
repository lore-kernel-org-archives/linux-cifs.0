Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45643F86E6
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 10:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408421; cv=pass; b=rgNBIjZXFaRdqZCM7ONLaPnADpXEZ7qOmp9e2VnQSuek8edIqNnnK9I477smaB6YtFj6dBJiTO5lHKg+Z34xMDOURYChuoDNzq+Qu9nE1y2TxAx3IK1N+gvCt5RJsxHj4Rb2ASzV3net2x6uBYHoPLSUwogqXVrnSC7rZIAtkOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408421; c=relaxed/simple;
	bh=/pJBra67lWCzahXQ92MjOFzygYwtV4EH48I5mTe3KMs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pc6omqW2T/gVU8i3AHbDlF1a8pAHOLR98gszKkKMoQJ4JWb9eKKJc6t4LqzBEfjxhRhHhi7YfFxmb7bbHekmapftC95jTMyakrZHEvGJ/m5tZp7O7jyJ9vcKmGci0ifRyZ0cv9FWsLqkxC3dSt8v19XQnOH2xkUYnOckJidsEXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mrp/wnoX; arc=pass smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mrp/wnoX"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-381c51fde6bso2199072a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 03:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785408419; cv=none;
        d=google.com; s=arc-20260327;
        b=cKrVuc66Hlourk69YMcnUM+8zv3X0VnaBjM7MRbTAES41OgTW5cXD876lMGLV4023C
         LqYbt56s6pYkYMFsz4G6jeD98h8GtO9O3nFHuzYsoX7cbDaliGE0fVasxC0zZMmwdKIC
         /Hv44xc3joC/oJ+tZKPz4wwOiU30BiwEI6448lkoeZGWAsUNvUjBS1E+R/IZHuUDvAoZ
         gLg+k17seU6t0C+6joyZjQNek1B3sLm67GhkmfK9txk2TDVKK2IYVy9kwUF+3jqnzn+2
         /JAPz08zEl5eFvjpOidWFK8wwRPpdbKNGyIecnluEqTbaRg+PxhRMiZVl7HwSM3ZtvPi
         ceSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J/ZIpYBLl+T/TmsaIqNrZUY0dv0btutwVLQKa6wwGls=;
        fh=hXi0IyrW+jzn3wP2OB3WsmtvYRldmkxQeM+MMHcG77Y=;
        b=KFhdYZ//zSJsnSxALHDmdf0NOtlFaeLPTIVSLfr9PkOZEd8qKaTfx5I8XefHEX5Wxy
         4rky9vz1Ls7gMpfHllwYJeyGQeIgRrxhQcBkWAiIVotU5unO/zWAGfhYdiZU9hEsmmeF
         ico8sY/bmXuxIM4JhwEMpRO4WRROoQYAilt7dSugE08SnXb0VgpUcYyyW58UqovaqmfX
         30jWO8unuGfVME1oU/W9uczeWJ+WYvNlM+QOci55wy6jID3BKhggeRbU6LtKBmZb7DoZ
         0bFxSGyds1tBFmxd435X562A3jhwp6mfN+c923V2sp6/qmzxWpjaNTZp8ltO1Drt9Y+4
         g3GQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785408419; x=1786013219; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J/ZIpYBLl+T/TmsaIqNrZUY0dv0btutwVLQKa6wwGls=;
        b=Mrp/wnoXhj2JQmIR8INLiMAf7HgaCLz3AtB106wbdSQeR+bKwuD2pIQJxSFizcFwSV
         q06J3rnYyb9oPTW5JrCI+9Fmy/yxVh4A/i1LVCH3e7tn4BWl0SR6gaN2WiyP6qOlYwEc
         b59RuVMWg5dI4EDZN4cL8Qflx1aLDPt7QHJctVwuj9XG1j2OAvwu3nmtInHZ6j3PADad
         o+2g9/rKotrdyIYl+Y18gGF1AyZslKbiDMoSqb3NZ3opH6jTmOSuNb2MJYQUqk12XNBc
         ozUk/K6YUot0rDtubQK9yC5vw/7/xNuZzRoOD8EaMs2XiaYBn3sUwzcrx8pHUqEUMMjV
         8kRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785408419; x=1786013219;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J/ZIpYBLl+T/TmsaIqNrZUY0dv0btutwVLQKa6wwGls=;
        b=Cq9NEVjLVMPvUTEg7OsmdrHY//QLjZ3vsVmG9pn7jSMyyi/A+DkUkntRvH1OwO/loo
         kKxfx/37zbt9Lv/X4RXgrlF5DxRtdh/65Z77QsRWKTHr8+Zfv5YGdura9NKZb0K6/gIR
         cVEh/nCzwMmV1KGk9pqiBUjOoPIojvuObI/ZifZOazuvE5GsIYcdwolNShxrWRwaFoxv
         hGBsNGHOWvllKbfDe5zk6oL6bKZEGG4M0qDeErcOx/oJ3hPsi72/NZ3vxjilH9fd1eGw
         vso0bG9Seg/bSSr2swfbD+HNgb9ONQgF4huQtw1dU74Ek4OBJq0OxJ5FDcxpuFCi9cTW
         hbsQ==
X-Forwarded-Encrypted: i=1; AHgh+RpbCsUv7gMHZNv6OoAUSYNOF73eLSHm0y7lndQsqXL0RA3RSVs4H7mWLo16RPWz9bXmpVSS66H1sc86@vger.kernel.org
X-Gm-Message-State: AOJu0YzVy3d5QFQsUau8tfotMVQidjdGp8ZK3vqJ0XD7jtv8cQrTMdIT
	ksJm1vIyY7ckAJwloYyvd+UUH2EqLqIAxuXDPQXoePjEHoiEm5JEx1uTNRo7bdlqeS9bC4HTltN
	0KaOb68C0miKZo90Ii4BYiJ2WLsu65ok=
X-Gm-Gg: AR+sD13htR3UHoHOn78TAWB/K+IBM1mAtxinKuxMx4o52CobqrU79Q2qqPhBwrOp+kS
	ioK2BQrXlFYdKi3eMdshcPulA/qYvc7TrfZTuRH1yQaa6jg3iFo+7NBpze/Va8ylG0k0iUItzni
	cYLEzpxuZR1UybLV6vTaSHDRX8doli80gyPs00BG+BTjmX99vqag47W3Tazd+2OVxRczE3FNdGi
	krsrZX5+jIRlrnZS0NMN7+8CdtZyL5eXRswRhnumUlkX0YSt1n4o1bvy0EM65zPCDHBKiw65EzT
	DrHBl5Q1km0kqTQ8+x2kPmVlvBERRgd10ZXafynEGw==
X-Received: by 2002:a05:6a20:ed0a:10b0:3c3:92aa:4302 with SMTP id
 adf61e73a8af0-3c900a121c0mr1494173637.70.1785408419131; Thu, 30 Jul 2026
 03:46:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728141344.1811120-1-dhowells@redhat.com> <20260728141344.1811120-3-dhowells@redhat.com>
In-Reply-To: <20260728141344.1811120-3-dhowells@redhat.com>
From: Marc Dionne <marc.c.dionne@gmail.com>
Date: Thu, 30 Jul 2026 07:46:46 -0300
X-Gm-Features: AUfX_mzfLJImvRuh6yVkodLmz2yp1G4hdsI4jg4G5JxpGyA9U2_irkB9xgU3jHs
Message-ID: <CAB9dFdviO5UE=0oMLwkReJ3AkqVp==N5b7-ejLRub62SYeJLag@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] afs, bash: Fix open(O_CREAT) on an extant AFS file
 in a sticky dir
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <christian@brauner.io>, 
	Jeffrey Altman <jaltman@auristor.com>, Steve French <sfrench@samba.org>, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Etienne Champetier <champetier.etienne@gmail.com>, Chet Ramey <chet.ramey@case.edu>, 
	Cheyenne Wills <cwills@sinenomine.net>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 28, 2026 at 11:14=E2=80=AFAM David Howells <dhowells@redhat.com=
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
> However, the bash work around has been removed in bash-5.3[2].
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
>  fs/afs/symlink.c  |  2 ++
>  6 files changed, 56 insertions(+)
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
>         set_nlink(&vnode->netfs.inode, status->nlink);
>
>         i_size_write(inode, status->size);
> diff --git a/fs/afs/internal.h b/fs/afs/internal.h
> index 290873bac89b..f15dbbc8dd26 100644
> --- a/fs/afs/internal.h
> +++ b/fs/afs/internal.h
> @@ -1531,6 +1531,9 @@ extern struct key *afs_request_key(struct afs_cell =
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
> diff --git a/fs/afs/symlink.c b/fs/afs/symlink.c
> index 16b4823cb7b7..ed834ba90e85 100644
> --- a/fs/afs/symlink.c
> +++ b/fs/afs/symlink.c
> @@ -271,6 +271,8 @@ int afs_symlink_writepages(struct address_space *mapp=
ing,
>  const struct inode_operations afs_symlink_inode_operations =3D {
>         .get_link       =3D afs_get_link,
>         .readlink       =3D afs_readlink,
> +       .is_owned_by_me =3D afs_is_owned_by_me,
> +       .have_same_owner =3D afs_have_same_owner,
>  };
>
>  const struct address_space_operations afs_symlink_aops =3D {
>
>

Acked-by: Marc Dionne <marc.dionne@auristor.com>

Marc

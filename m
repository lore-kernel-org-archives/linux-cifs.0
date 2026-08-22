Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9855A49364E
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 12:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787400187; cv=none; b=gS/b6fWzTd1GFXeBdBL4m930m+VCliGVh5urB6JcHvaq996lak8IQbFaDXuED5gtO/Wl6U/ddY+nNgr5CiXrVOtKyn/QdqyjVMg7PK4vQGUJdswTMw6M0ri1JJCNWU6ZpRKIK4AcAGNEyp7dLx0YWsruvxNg07ol2G7orIcThuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787400187; c=relaxed/simple;
	bh=phJVPIEwV4/F9KojIZ2G03l9qYSIcG2eyxjWJbc+D5g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ngfh6tfo376h/d4QYj9gTI1KWgi3/+7zaSM0bi8ucaCvhjgT5AOdX8t4zvwXFtlTUxlxf85Cw38yBZdRM+QmiwaY/B/3ueAEbqEmlv+PN4bY0LjHP3lGFKveLdLfGOgvr5cwy8PG+CvC8hjR0e7BsasX3FuRa4MMykEbOm+oun8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hQb/KKgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hQb/KKgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CF91F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 12:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787400186;
	bh=tRKwFiM+cGjmgowE3hd8nv1AwymHAsJvRIpJ31cf1Oo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hQb/KKgcqvPwZoRv8wWIgRwBW8lsUW0VSQHIhQaUOX4PC5BWnmnKc/PdmjWib3huC
	 6V+eZ0bhEO29UaQn8VPv1sAdHzh1OsbFoKmB31h9FCdF/kiHtamM7dKSOf2ef8lSdk
	 1fGOwi/2JQVTlAL1CL819P4dRczP5sO9J5KIyQ7WYYmwz6k7PvJgfU5/c9VgY2DD5u
	 axUn5ln/R/UFa3mRcmRquakqD/PyiXdfQxzcDs7oZBQx5WgWUnu0Uwai1wpWsHqzcp
	 1QOwyjlborN9ezBKs7HHBeUbrGwJAeAl8lE4d2H7DiNWj/sCFkh6CC+IMHczPDD+D7
	 mtLQsQsCQHFYg==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698ae09e356so2908569a12.2
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 05:03:06 -0700 (PDT)
X-Gm-Message-State: AFuF++lBJaN+oiQUbkLGU4Mp/MAqNL2lbWYnKCC7/HfDQLxW6oqZcp77
	aJYc8ZyPHsu3yAVisCITBJv0VCvmgT7ztfHtp9fH6NvXPo/jqaRuvMOP3skq2xspPeQ7yznQf9V
	/KUSs+94m8LOzwGNGHwxu6DuO46ws1/Q=
X-Received: by 2002:a05:6402:27d0:b0:6a1:2efd:8687 with SMTP id
 4fb4d7f45d1cf-6a42f20afd9mr13372751a12.14.1787400184879; Sat, 22 Aug 2026
 05:03:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821184109.1834871-1-sorenson@redhat.com> <20260821184109.1834871-2-sorenson@redhat.com>
In-Reply-To: <20260821184109.1834871-2-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 22 Aug 2026 21:02:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-st8zvEiMTKw5vggFVTvY_Ln5nA3zeZgThuqQuQxAZtA@mail.gmail.com>
X-Gm-Features: AcwNN1WpFAkSsTvDoTpUX1Qe0TtEmji84BhZ6Y-BazYcYBMpE6nNI8LHpa6L9c4
Message-ID: <CAKYAXd-st8zvEiMTKw5vggFVTvY_Ln5nA3zeZgThuqQuQxAZtA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] cifs: don't update i_size in cifs_do_truncate()
 without a cached handle
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, stable@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 22, 2026 at 3:41=E2=80=AFAM Frank Sorenson <sorenson@redhat.com=
> wrote:
>
> If find_writable_file() returns NULL, cifs_file_flush() returns 0
> without issuing set_file_size, and the outer if (!rc) block sets i_size
> to 0 before the server is told to truncate.  If the subsequent
> cifs_open() fails, the inode is stranded at size 0 while the server
> file is unchanged.
>
> Move netfs_resize_file() and cifs_setsize() inside the if (cfile) arm
> so they only run after a successful set_file_size().  In the no-handle
> else branch, call truncate_inode_pages() to evict stale pages before
> the O_TRUNC open: cifs_invalidate_cache() is fscache-only and does not
> touch the VFS page cache, so without it old pages persist and may be
> served as stale data after a later file extension.
>
> Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_T=
RUNC")
> Cc: stable@vger.kernel.org
> Cc: Paulo Alcantara <pc@manguebit.com>
> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
> ---
>  fs/smb/client/file.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index 389083f9ce00..05aeb9d94ffe 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -1012,10 +1012,20 @@ static int cifs_do_truncate(const unsigned int xi=
d, struct dentry *dentry)
>                         server =3D tcon->ses->server;
>                         rc =3D server->ops->set_file_size(xid, tcon,
>                                                         cfile, 0, false);
> -               }
> -               if (!rc) {
> -                       netfs_resize_file(&cinode->netfs, 0, true);
> -                       cifs_setsize(inode, 0);
> +                       if (!rc) {
> +                               netfs_resize_file(&cinode->netfs, 0, true=
);
> +                               cifs_setsize(inode, 0);
> +                               cifs_invalidate_cache(inode, 0);
> +                       }
> +               } else {
> +                       /*
> +                        * No cached handle; the server truncates as part=
 of the
> +                        * O_TRUNC open request that follows.  Evict stal=
e pages
> +                        * from the page cache now so they cannot be serv=
ed as
> +                        * stale data after the file is later extended; i=
_size is
> +                        * updated from the server's open response.
> +                        */
> +                       truncate_inode_pages(inode->i_mapping, 0);
truncate_inode_pages() expects both ->i_rwsem and ->invalidate_lock to
be held. Please check the comment of truncate_inode_pages().

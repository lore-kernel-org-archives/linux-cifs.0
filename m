From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: set ra_pages in backing_dev_info
Date: Mon, 28 Mar 2011 17:34:24 -0500
Message-ID: <AANLkTikvctGXFeaQqXiK9665xK6_5jSo7K85Kf2oxMqq@mail.gmail.com>
References: <1301084757-2260-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, till2.schaefer-ka8IRLAdjMFlCbFer0i7Sg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301084757-2260-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

added bug number to the patch description and merged into cifs-2.6.git

On Fri, Mar 25, 2011 at 3:25 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Commit 522440ed made cifs set backing_dev_info on the mapping attache=
d
> to new inodes. This change caused a fairly significant read performan=
ce
> regression, as cifs started doing page-sized reads exclusively.
>
> By virtue of the fact that they're allocated as part of cifs_sb_info =
by
> kzalloc, the ra_pages on cifs BDIs get set to 0, which prevents any
> readahead. This forces the normal read codepaths to use readpage inst=
ead
> of readpages causing a four-fold increase in the number of read calls
> with the default rsize.
>
> Fix it by setting ra_pages in the BDI to the same value as that in th=
e
> default_backing_dev_info.
>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Reported-and-Tested-by: Till <till2.schaefer-ka8IRLAdjMFlCbFer0i7Sg@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifsfs.c | =A0 =A01 +
> =A01 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1af2470..fb6a2ad 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -131,6 +131,7 @@ cifs_read_super(struct super_block *sb, void *dat=
a,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(cifs_sb);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 cifs_sb->bdi.ra_pages =3D default_backing_dev_info.ra_p=
ages;
>
> =A0#ifdef CONFIG_CIFS_DFS_UPCALL
> =A0 =A0 =A0 =A0/* copy mount params to sb for use in submounts */
> --
> 1.7.4.1
>
>



--=20
Thanks,

Steve

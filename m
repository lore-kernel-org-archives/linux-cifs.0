From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/4] cifs: new helper function: cifs_revalidate_mapping
Date: Thu, 24 Apr 2014 22:53:25 -0500
Message-ID: <CAH2r5mvAgcLnX7igwAyzzzKMhxy-bLRKqOgOLdJQ-3Ewr3omwg@mail.gmail.com>
References: <1396288209-27328-1-git-send-email-jlayton@redhat.com> <1396288209-27328-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396288209-27328-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The extra semicolon in the following looks wrong

On Mon, Mar 31, 2014 at 12:50 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Consolidate a bit of code. In a later patch we'll expand this to fix
> some races.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.h |  1 +
>  fs/cifs/inode.c  | 16 ++++++++++------
>  2 files changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
> index 26a754f49ba1..40d5a4df1e38 100644
> --- a/fs/cifs/cifsfs.h
> +++ b/fs/cifs/cifsfs.h
> @@ -67,6 +67,7 @@ extern int cifs_revalidate_dentry_attr(struct dentry *);
>  extern int cifs_revalidate_file(struct file *filp);
>  extern int cifs_revalidate_dentry(struct dentry *);
>  extern int cifs_invalidate_mapping(struct inode *inode);
> +extern int cifs_revalidate_mapping(struct inode *inode);
>  extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
>  extern int cifs_setattr(struct dentry *, struct iattr *);
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 3e9d8ba21f5c..39b76bac196d 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -1779,6 +1779,14 @@ cifs_invalidate_mapping(struct inode *inode)
>         return rc;
>  }
>
> +int
> +cifs_revalidate_mapping(struct inode *inode)
> +{
> +       if (test_bit(CIFS_INODE_INVALID_MAPPING, &CIFS_I(inode)->flags));
> +               return cifs_invalidate_mapping(inode);
> +       return 0;
> +}
> +
>  int cifs_revalidate_file_attr(struct file *filp)
>  {
>         int rc = 0;
> @@ -1845,9 +1853,7 @@ int cifs_revalidate_file(struct file *filp)
>         if (rc)
>                 return rc;
>
> -       if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags));
> -               rc = cifs_invalidate_mapping(inode);
> -       return rc;
> +       return cifs_revalidate_mapping(inode);
>  }
>
>  /* revalidate a dentry's inode attributes */
> @@ -1860,9 +1866,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
>         if (rc)
>                 return rc;
>
> -       if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags));
> -               rc = cifs_invalidate_mapping(inode);
> -       return rc;
> +       return cifs_revalidate_mapping(inode);
>  }
>
>  int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
> --
> 1.9.0
>



-- 
Thanks,

Steve

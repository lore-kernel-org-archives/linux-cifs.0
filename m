From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Fri, 27 Apr 2012 19:46:01 -0700
Message-ID: <CA+55aFwx-vCQcbU5pKcRxFm1uJmjrT_OafTTMx026idX+H1oJg@mail.gmail.com>
References: <20120427081815.4478.26011.stgit@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120427081815.4478.26011.stgit-jgopVnDzZD88qxobedHYj6xOck334EZe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Steve? I have a CIFS pull request from you now, and it doesn't contain
this one. I don't know the code well enough to say one way or the
other, so I haven't applied this. Pls Ack/Nak.

                   Linus

On Fri, Apr 27, 2012 at 1:18 AM, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org> wrote:
> When revalidating a dentry, if the inode wasn't known to be a dfs
> entry when the dentry was instantiated, such as when created via
> ->readdir(), the DCACHE_NEED_AUTOMOUNT flag needs to be set on the
> dentry in ->d_revalidate().
>
> The false return from cifs_d_revalidate(), due to the inode now
> being marked with the S_AUTOMOUNT flag, might not invalidate the
> dentry if there is a concurrent unlazy path walk. This is because
> the dentry reference count will be at least 2 in this case causing
> d_invalidate() to return EBUSY. So the asumption that the dentry
> will be discarded then correctly instantiated via ->lookup() might
> not hold.
>
> Signed-off-by: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>
> =A0fs/cifs/dir.c | =A0 17 ++++++++++++-----
> =A01 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index d172c8e..ec4e9a2 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -668,12 +668,19 @@ cifs_d_revalidate(struct dentry *direntry, stru=
ct nameidata *nd)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Forcibly invalidat=
e automounting directory inodes
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* (remote DFS direct=
ories) so to have them
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* instantiated again=
 for automount
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* If the inode wasn'=
t known to be a dfs entry when
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the dentry was ins=
tantiated, such as when created
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* via ->readdir(), i=
t needs to be set now since the
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* attributes will ha=
ve been updated by
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* cifs_revalidate_de=
ntry().
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_AUTOMOUNT(dirent=
ry->d_inode))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_AUTOMOUNT(dirent=
ry->d_inode) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0!(direntry->d_fl=
ags & DCACHE_NEED_AUTOMOUNT)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lo=
ck(&direntry->d_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 direntr=
y->d_flags |=3D DCACHE_NEED_AUTOMOUNT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&direntry->d_lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>

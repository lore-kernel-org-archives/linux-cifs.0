From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Do not lookup hashed negative dentry in
 cifs_atomic_open
Date: Tue, 30 Oct 2012 12:46:33 -0400
Message-ID: <20121030124633.2f50e09c@tlielax.poochiereds.net>
References: <1351615413-9182-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, vit.zahradka-IWqWACnzNjzrBKCeMvbIDA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351615413-9182-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 30 Oct 2012 16:43:33 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> We do not need to lookup a hashed negative directory since we have
> already revalidated it before and have found it to be fine.
> 
> This also prevents a crash in cifs_lookup() when it attempts to rehash
> the already hashed negative lookup dentry.
> 
> The patch has been tested using the reproducer at
> https://bugzilla.redhat.com/show_bug.cgi?id=867344#c28
> 
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> # 3.6.x 
> Reported-by: Vit Zahradka <vit.zahradka-IWqWACnzNjzrBKCeMvbIDA@public.gmane.org>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/dir.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 7c0a812..e26d0a6 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -398,6 +398,12 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
>  	 * in network traffic in the other paths.
>  	 */
>  	if (!(oflags & O_CREAT)) {
> +		/* Check for hashed negative dentry. We have already revalidated
> +		 * the dentry and it is fine. No need to perform another lookup.
> +		 */
> +		if (!d_unhashed(direntry))
> +			return -ENOENT;
> +
>  		struct dentry *res = cifs_lookup(inode, direntry, 0);
>  		if (IS_ERR(res))
>  			return PTR_ERR(res);

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC] cifs: revalidate directories instiantiated via
 FIND_* in order to handle DFS referrals
Date: Thu, 07 Feb 2013 17:42:14 +0000
Message-ID: <1360258934.11095.13.camel@localhost>
References: <1358276491-4835-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1358276491-4835-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We had a problem reported by a user which I found is fixed by this
patch.

The customer reported a crash where they were able to cd into a DFS
share where the target doesn't exist. The machine eventually crashes
when the lookup code attempts to access the inode->i_ops->lookup which
is set to NULL for DFS shares.

I was able to recreate this problem and noticed that this also affects a
standard DFS share. To recreate the problem, simply mount the DFS share
on a mount point and run the following commands.

# mount -t cifs -o
username=user,password=mysecret //vm140-52/DFS_Public/ /mnt
# cd /mnt
# ls; cd n1/

Where n1 is a DFS share.

1) The first command 'ls', results in the readdir system call which ends
up calling FIND_FIRST SMB command to the server. 
2) An inode is initiated but no S_AUTOMOUNT flag is set at this stage.
3) The dentry initiated doesn't contain the DCACHE_NEED_AUTOMOUNT flag.
4) When we cd into this directory immediately, the dentry returned was
just created(ie. not yet timed out) and is valid.
5) We then called  for this dentry. Since we do not have the
DCACHE_NEED_AUTOMOUNT flag set in dentry->d_flags, we do not trigger the
automount. 
6) After we have done the chdir, By attempting a few lookups, we
eventually hit a problem because the inode functions in inode->i_ops are
all set to NULL.

I have tested with this patch and it does work since we force a
QUERY_PATH_LOOKUP on all directories returned in FIND_FIRST. The
downside ofcourse is increase in the QUERY_PATH_LOOKUPs.

Sachin Prabhu

On Tue, 2013-01-15 at 14:01 -0500, Jeff Layton wrote:
> We've had a long-standing problem with DFS referral points. CIFS servers
> generally try to make them look like directories in FIND_FIRST/NEXT
> responses. When you go to try to do a FIND_FIRST on them though, the
> server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
> manifests as spurious EREMOTE errors back to userland.
> 
> This patch attempts to fix this by marking directories that are
> discovered via FIND_FIRST/NEXT for revaldiation. When the lookup code
> runs across them again, we'll reissue a QPathInfo against them and that
> will make it chase the referral properly.
> 
> There is some performance penalty involved here and no I haven't
> measured it -- it'll be highly dependent upon the workload and contents
> of the mounted share. To try and mitigate that though, the code only
> marks the inode for revalidation when it's possible to run across a DFS
> referral. i.e.: when the kernel has DFS support built in and the share
> is "in DFS".
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/readdir.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index cdd6ff4..5fc9b4a 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -128,6 +128,22 @@ out:
>  	dput(dentry);
>  }
>  
> +/*
> + * Is it possible that this directory might turn out to be a DFS referral
> + * once we go to try and use it?
> + */
> +static bool
> +cifs_dfs_is_possible(struct cifs_sb_info *cifs_sb)
> +{
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
> +
> +	if (tcon->Flags & SMB_SHARE_IS_IN_DFS)
> +		return true;
> +#endif
> +	return false;
> +}
> +
>  static void
>  cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  {
> @@ -137,6 +153,14 @@ cifs_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
>  	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>  		fattr->cf_dtype = DT_DIR;
> +		/*
> +		 * CIFS servers generally make DFS referrals look like
> +		 * directories in FIND_* responses. Since there's no way to
> +		 * tell the difference, we must revalidate directory inodes
> +		 * before trying to use them.
> +		 */
> +		if (cifs_dfs_is_possible(cifs_sb))
> +			fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
>  	} else {
>  		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
>  		fattr->cf_dtype = DT_REG;

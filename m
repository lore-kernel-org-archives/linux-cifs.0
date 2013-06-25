From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: cifs: revalidate directories instiantiated via FIND_* in order
 to handle DFS referrals
Date: Tue, 25 Jun 2013 13:38:28 -0400
Message-ID: <20130625133828.5f842939@tlielax.poochiereds.net>
References: <CAH2r5ms41WtzRSMD9F229kFQzVVBu=ymDKd3KHV10UpsjNQX2Q@mail.gmail.com>
	<20130625110018.0f5fe0eb@tlielax.poochiereds.net>
	<CAH2r5mtgZmaunFvcrY6vgX1zsNVyoxpn+MEjJ6W_TNRAmp2Lmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtgZmaunFvcrY6vgX1zsNVyoxpn+MEjJ6W_TNRAmp2Lmg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Jun 2013 12:30:11 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jun 25, 2013 at 10:00 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Tue, 25 Jun 2013 01:42:44 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> Looking at this issue at the plugfest this week - the recommendation
> >> is to add a check for ATTR_REPARSE
> >> since this is usually set (for the Windows case) for DFS links (DFS
> >> links are one case of reparse points - but the performance hit for
> >> revalidating all reparse points is not bad).   Tomorrow we can check
> >> for the Samba case in more detail to see how the scenario looks and
> >> whether we can workaround it.
> >>
> >> We did find another workaround which could be checked, but decided
> >> against using that one in preference to simply checking for the
> >> reparse attribute.   In the Windows case since you don't create
> >> subdirectories under a DFS link on the server side - the creation time
> >> and last write time of the directory will match for the case of a DFS
> >> link returned by QueryDir or FindFirst (so we also could have refused
> >> to cache directories whose creation time and last write time match -
> >> which would also mean that we don't cache empty subdirectories which
> >> is also a trivial perf hit to not cache those - it would be easy
> >> enough to refuse to cache those directories too if you want).
> >>
> >
> > Sounds reasonable -- you should probably post the patch you've already
> > merged into your for-next branch so others can comment and review
> > though...
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> 
> commit 732e0143e8811afcb79d4e1b308536e4a7a1d791
> Author: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Tue Jun 25 01:32:17 2013 -0500
> 
>     [CIFS] revalidate directories instiantiated via FIND_* in order to
> handle DFS referrals
> 
>     We've had a long-standing problem with DFS referral points. CIFS servers
>     generally try to make them look like directories in FIND_FIRST/NEXT
>     responses. When you go to try to do a FIND_FIRST on them though, the
>     server will then (correctly) return STATUS_PATH_NOT_COVERED. Mostly this
>     manifests as spurious EREMOTE errors back to userland.
> 
>     This patch attempts to fix this by marking directories that are
>     discovered via FIND_FIRST/NEXT for revaldiation. When the lookup code
>     runs across them again, we'll reissue a QPathInfo against them and that
>     will make it chase the referral properly.
> 
>     There is some performance penalty involved here and no I haven't
>     measured it -- it'll be highly dependent upon the workload and contents
>     of the mounted share. To try and mitigate that though, the code only
>     marks the inode for revalidation when it's possible to run across a DFS
>     referral. i.e.: when the kernel has DFS support built in and the share
>     is "in DFS"
> 
>     [At the Microsoft plugfest we noted that usually the DFS links had
>     the REPARSE attribute tag enabled - DFS junctions are reparse points
>     after all - so I just added a check for that flag too so the
>     performance impact should be smaller - Steve]
> 
>     Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Reviewed-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> index 770d5a9..94d6201 100644
> --- a/fs/cifs/readdir.c
> +++ b/fs/cifs/readdir.c
> @@ -126,6 +126,22 @@ out:
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
> @@ -135,6 +151,19 @@ cifs_fill_common_info(struct cifs_fattr *fattr,
> struct cifs_sb_info *cifs_sb)
>  	if (fattr->cf_cifsattrs & ATTR_DIRECTORY) {
>  		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
>  		fattr->cf_dtype = DT_DIR;
> +		/*
> +		 * Windows CIFS servers generally make DFS referrals look
> +		 * like directories in FIND_* responses with the reparse
> +		 * attribute flag also set (since DFS junctions are
> +		 * reparse points). We must revalidate at least these
> +		 * directory inodes before trying to use them (if
> +		 * they are DFS we will get PATH_NOT_COVERED back
> +		 * when queried directly and can then try to connect
> +		 * to the DFS target)
> +		 */
> +		if (cifs_dfs_is_possible(cifs_sb) &&
> +		    (fattr->cf_cifsattrs & ATTR_REPARSE))
> +			fattr->cf_flags |= CIFS_FATTR_NEED_REVAL;
>  	} else {
>  		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
>  		fattr->cf_dtype = DT_REG;
> 
> 
> 

Looks good to me -- ACK on the changes...


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 8/8] cifs: Add support for readlink on dfs shares under
 posix extensions
Date: Wed, 27 Nov 2013 12:58:51 +0000
Message-ID: <1385557131.3706.5.camel@sachin-laptop>
References: <1385399395-19217-1-git-send-email-sprabhu@redhat.com>
	 <1385399395-19217-9-git-send-email-sprabhu@redhat.com>
	 <20131127064551.7a8b77a2@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131127064551.7a8b77a2-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2013-11-27 at 06:45 -0500, Jeff Layton wrote:
> On Mon, 25 Nov 2013 17:09:55 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > When using posix extensions, dfs shares in the dfs root show up as
> > symlinks resulting in userland tools such as 'ls' calling readlink() on
> > these shares. Since these are dfs shares, readlink fails with -EREMOTE.
> > 
> > With added support for dfs shares on readlink when using unix
> > extensions, we call GET_DFS_REFERRAL to obtain the DFS referral and
> > return the first node returned.
> > 
> > The dfs share in the dfs root is now displayed in the following manner.
> > $ ls -l /mnt
> > total 0
> > lrwxrwxrwx. 1 root root 19 Nov  6 09:47 test -> \vm140-31\test
> > 
> 
> nit: I know that DFS referrals are prefixed with a single backslash,
> but it might look more like a UNC with a double backslash prefix:
> 
>     lrwxrwxrwx. 1 root root 19 Nov  6 09:47 test -> \\vm140-31\test
> 
> ...but I don't feel too strongly about it.
> 
> > Red Hat BZ: 1020715
> > 
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/smb1ops.c | 34 +++++++++++++++++++++++++++++++++-
> >  1 file changed, 33 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> > index 2d822dd..abd2cc9 100644
> > --- a/fs/cifs/smb1ops.c
> > +++ b/fs/cifs/smb1ops.c
> > @@ -908,6 +908,33 @@ cifs_mand_lock(const unsigned int xid, struct cifsFileInfo *cfile, __u64 offset,
> >  }
> >  
> >  static int
> > +cifs_unix_dfs_readlink(const unsigned int xid, struct cifs_tcon *tcon,
> > +		       const unsigned char *searchName, char **symlinkinfo,
> > +		       const struct nls_table *nls_codepage)
> > +{
> > +#ifdef CONFIG_CIFS_DFS_UPCALL
> > +	int rc;
> > +	unsigned int num_referrals = 0;
> > +	struct dfs_info3_param *referrals = NULL;
> > +
> > +	rc = get_dfs_path(xid, tcon->ses, searchName, nls_codepage,
> > +			  &num_referrals, &referrals, 0);
> > +
> > +	if (!rc && num_referrals > 0) {
> > +		*symlinkinfo = kstrndup(referrals->node_name,
> > +					strlen(referrals->node_name),
> > +					GFP_KERNEL);
> > +		if (!*symlinkinfo)
> > +			rc = -ENOMEM;
> > +		free_dfs_info_array(referrals, num_referrals);
> > +	}
> > +	return rc;
> > +#else /* No DFS support */
> > +	return -EREMOTE;
> > +#endif
> > +}
> > +
> > +static int
> >  cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> >  		   const char *full_path, char **target_path,
> >  		   struct cifs_sb_info *cifs_sb)
> > @@ -920,8 +947,13 @@ cifs_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
> >  
> >  	/* Check for unix extensions */
> >  	if (cap_unix(tcon->ses)) {
> > -		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, &target_path,
> > +		rc = CIFSSMBUnixQuerySymLink(xid, tcon, full_path, target_path,

It looks like I made a mistake in this line. When writing patch #7, I
introduced a bug here which results in a compilation error. I then wrote
the fix and applied it to the wrong patch ie. patch #8 instead of #7. I
will resend patches 7 and 8. 

For now, I'll just resend the patches without including the proposed
change from Jeff so that we can get this error fixed quickly. If needed,
we can change the format in which the remote node is printed in a
separate patch.

Sachin Prabhu
>>  					     cifs_sb->local_nls);
> > +		if (rc == -EREMOTE)
> > +			rc = cifs_unix_dfs_readlink(xid, tcon, full_path,
> > +						    target_path,
> > +						    cifs_sb->local_nls);
> > +
> >  		goto out;
> >  	}
> >  
> 
> 
> Either way, this is a marked improvement:
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix usage of d_materialise_unique in
 cifs_get_root
Date: Mon, 18 Jul 2011 13:49:42 -0400
Message-ID: <20110718134942.0d06f203@tlielax.poochiereds.net>
References: <1310990594-3570-1-git-send-email-jlayton@redhat.com>
	<20110718164501.GB11013@ZenIV.linux.org.uk>
	<20110718173454.GC11013@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110718173454.GC11013-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Jul 2011 18:34:54 +0100
Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org> wrote:

> On Mon, Jul 18, 2011 at 05:45:02PM +0100, Al Viro wrote:
> > lookup-by-hand code in there.  Or with calculating hash - also done
> > by lookup_one_len(), TYVM...  If anything, I'd start with this as the first
> > approximation and probably looked into simplifying the loop a bit more -
> > lookup_one_len() doesn't need name component to be NUL-terminated...
> 
> Fix cifs_get_root()
> 
> Add missing ->i_mutex, convert to lookup_one_len() instead of
> (broken) open-coded analog, cope with getting something like
> a//b as relative pathname.  Simplify the hell out of it, while
> we are there...
> 
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 112fbd96..cbbb55e 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -35,6 +35,7 @@
>  #include <linux/delay.h>
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
> +#include <linux/namei.h>
>  #include <net/ipv6.h>
>  #include "cifsfs.h"
>  #include "cifspdu.h"
> @@ -542,14 +543,12 @@ static const struct super_operations cifs_super_ops = {
>  static struct dentry *
>  cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  {
> -	int xid, rc;
> -	struct inode *inode;
> -	struct qstr name;
> -	struct dentry *dparent = NULL, *dchild = NULL, *alias;
> +	struct dentry *dentry;
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
> -	unsigned int i, full_len, len;
> -	char *full_path = NULL, *pstart;
> +	char *full_path = NULL;
> +	char *s, *p;
>  	char sep;
> +	int xid;
>  
>  	full_path = cifs_build_path_to_root(vol, cifs_sb,
>  					    cifs_sb_master_tcon(cifs_sb));
> @@ -560,73 +559,32 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
>  
>  	xid = GetXid();
>  	sep = CIFS_DIR_SEP(cifs_sb);
> -	dparent = dget(sb->s_root);
> -	full_len = strlen(full_path);
> -	full_path[full_len] = sep;
> -	pstart = full_path + 1;
> -
> -	for (i = 1, len = 0; i <= full_len; i++) {
> -		if (full_path[i] != sep || !len) {
> -			len++;
> -			continue;
> -		}
> -
> -		full_path[i] = 0;
> -		cFYI(1, "get dentry for %s", pstart);
> -
> -		name.name = pstart;
> -		name.len = len;
> -		name.hash = full_name_hash(pstart, len);
> -		dchild = d_lookup(dparent, &name);
> -		if (dchild == NULL) {
> -			cFYI(1, "not exists");
> -			dchild = d_alloc(dparent, &name);
> -			if (dchild == NULL) {
> -				dput(dparent);
> -				dparent = ERR_PTR(-ENOMEM);
> -				goto out;
> -			}
> -		}
> -
> -		cFYI(1, "get inode");
> -		if (dchild->d_inode == NULL) {
> -			cFYI(1, "not exists");
> -			inode = NULL;
> -			if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
> -				rc = cifs_get_inode_info_unix(&inode, full_path,
> -							      sb, xid);
> -			else
> -				rc = cifs_get_inode_info(&inode, full_path,
> -							 NULL, sb, xid, NULL);
> -			if (rc) {
> -				dput(dchild);
> -				dput(dparent);
> -				dparent = ERR_PTR(rc);
> -				goto out;
> -			}
> -			alias = d_materialise_unique(dchild, inode);
> -			if (alias != NULL) {
> -				dput(dchild);
> -				if (IS_ERR(alias)) {
> -					dput(dparent);
> -					dparent = ERR_PTR(-EINVAL); /* XXX */
> -					goto out;
> -				}
> -				dchild = alias;
> -			}
> -		}
> -		cFYI(1, "parent %p, child %p", dparent, dchild);
> -
> -		dput(dparent);
> -		dparent = dchild;
> -		len = 0;
> -		pstart = full_path + i + 1;
> -		full_path[i] = sep;
> -	}
> -out:
> +	dentry = dget(sb->s_root);
> +	p = s = full_path;
> +
> +	do {
> +		struct inode *dir = dentry->d_inode;
> +		struct dentry *child;
> +
> +		/* skip separators */
> +		while (*s == sep)
> +			s++;
> +		if (!*s)
> +			break;
> +		p = s++;
> +		/* next separator */
> +		while (*s && *s != sep)
> +			s++;
> +
> +		mutex_lock(&dir->i_mutex);
> +		child = lookup_one_len(p, dentry, s - p);
> +		mutex_unlock(&dir->i_mutex);
> +		dput(dentry);
> +		dentry = child;
> +	} while (!IS_ERR(dentry));
>  	_FreeXid(xid);
>  	kfree(full_path);
> -	return dparent;
> +	return dentry;
>  }
>  
>  static int cifs_set_super(struct super_block *sb, void *data)

Thanks, Al...

Looks good to me. I also gave it some basic smoke testing and it seems
to do the right thing.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

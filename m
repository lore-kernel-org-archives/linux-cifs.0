From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Add idmap key and related functions (try #3)
Date: Sat, 22 Jan 2011 08:03:50 -0500
Message-ID: <20110122080350.54fe7e31@tlielax.poochiereds.net>
References: <1295646260-21875-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295646260-21875-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Jan 2011 15:44:20 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> A new type of key, cifs_idmap_key_type, is used.
> 
> Keys are instantiated and searched using credential of the root by
> overriding and restoring the credentials of the caller requesting the key.
> Once a SID is mapped, it is stored along with the mapped id, in one
> of the rb trees and key is released.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c   |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/cifs/cifsacl.h   |    5 +++
>  fs/cifs/cifsfs.c    |    6 +++
>  fs/cifs/cifsproto.h |    2 +
>  fs/cifs/connect.c   |   12 ++++++
>  5 files changed, 119 insertions(+), 0 deletions(-)
> 

[...]

> index 18d3c77..ac6f536 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -3099,6 +3099,18 @@ cifs_umount(struct super_block *sb, struct cifs_sb_info *cifs_sb)
>  	}
>  	spin_unlock(&cifs_sb->tlink_tree_lock);
>  
> +	root = &cifs_sb->uidtree;
> +	spin_lock(&cifs_sb->siduidlock);
> +	while ((node = rb_first(root)))
> +		rb_erase(node, root);
> +	spin_unlock(&cifs_sb->siduidlock);
> +
> +	root = &cifs_sb->gidtree;
> +	spin_lock(&cifs_sb->sidgidlock);
> +	while ((node = rb_first(root)))
> +		rb_erase(node, root);
> +	spin_unlock(&cifs_sb->sidgidlock);
> +
>  	tmp = cifs_sb->prepath;
>  	cifs_sb->prepathlen = 0;
>  	cifs_sb->prepath = NULL;

This cache grows without bound until an unmount occurs? I don't think
that's a good idea. It would be easy for someone malicious to DoS the
box by simply putting a bunch of files owned by unique SIDs in a
directory and then doing a "ls -l" in that dir.

Perhaps you should register a shrinker for this cache to allow the VM
to prune LRU entries whenever memory gets tight? See "struct shrinker"
in include/linux/mm.h.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

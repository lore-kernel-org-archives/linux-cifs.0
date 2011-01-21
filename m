From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/3]] cifs: Add idmap data structures and defines (try
 #3)
Date: Fri, 21 Jan 2011 17:04:48 -0500
Message-ID: <20110121170448.6850b176@tlielax.poochiereds.net>
References: <1295646253-21852-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295646253-21852-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Jan 2011 15:44:13 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> A structure stored an rb tree is defined consisting of a SID and
> a id (either uid or gid) to which that SID is mapped.
> 
> Added fields needed to store this defined data structures of a
> rb tree to a superblock and initialized them.
> 
> There are two separate trees, one for SID/uid and another one for SID/gid.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifs_fs_sb.h |    4 ++++
>  fs/cifs/cifsacl.h    |    6 ++++++
>  fs/cifs/cifsfs.c     |    6 ++++++
>  3 files changed, 16 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index ac51cd2..4bd0680 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -45,6 +45,10 @@
>  struct cifs_sb_info {
>  	struct rb_root tlink_tree;
>  	spinlock_t tlink_tree_lock;
> +	struct rb_root uidtree;
> +	spinlock_t siduidlock;
> +	struct rb_root gidtree;
> +	spinlock_t sidgidlock;
>  	struct tcon_link *master_tlink;
>  	struct nls_table *local_nls;
>  	unsigned int rsize;
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index c4ae7d0..6c26e7f 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -74,6 +74,12 @@ struct cifs_wksid {
>  	char sidname[SIDNAMELENGTH];
>  } __attribute__((packed));
>  
> +struct cifs_sid_id {
> +	struct rb_node rbnode;
> +	struct cifs_sid sid;
> +	unsigned long id;
> +} __attribute__((packed));
> +
>  extern int match_sid(struct cifs_sid *);
>  extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
>  
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index a8323f1..36182e3 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -122,6 +122,12 @@ cifs_read_super(struct super_block *sb, void *data,
>  	spin_lock_init(&cifs_sb->tlink_tree_lock);
>  	cifs_sb->tlink_tree = RB_ROOT;
>  
> +	spin_lock_init(&cifs_sb->siduidlock);
> +	cifs_sb->uidtree = RB_ROOT;
> +
> +	spin_lock_init(&cifs_sb->sidgidlock);
> +	cifs_sb->gidtree = RB_ROOT;
> +
>  	rc = bdi_setup_and_register(&cifs_sb->bdi, "cifs", BDI_CAP_MAP_COPY);
>  	if (rc) {
>  		kfree(cifs_sb);

Why do you need per-sb caches? The upcall isn't specific to a
particular superblock, so if you have more than one mount you'll have
to do multiple upcalls for the same SID and have mutiple copies of the
same cifs_sid_id in various caches. It seems like a global cache would
be better.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

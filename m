From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] cifs: trivial: cleanup fscache cFYI and cERROR messages
Date: Tue, 14 Jun 2011 12:00:48 -0400
Message-ID: <20110614120048.7c04567d@corrin.poochiereds.net>
References: <4DF7804B.8000502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DF7804B.8000502-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 14 Jun 2011 21:07:47 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> ... for uniformity and cleaner debug logs.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cache.c   |    6 +++---
>  fs/cifs/fscache.c |   53 +++++++++++++++++++++++++----------------------------
>  2 files changed, 28 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/cifs/cache.c b/fs/cifs/cache.c
> index dd8584d..545509c 100644
> --- a/fs/cifs/cache.c
> +++ b/fs/cifs/cache.c
> @@ -92,7 +92,7 @@ static uint16_t cifs_server_get_key(const void *cookie_netfs_data,
>  		break;
>  
>  	default:
> -		cERROR(1, "CIFS: Unknown network family '%d'", sa->sa_family);
> +		cERROR(1, "Unknown network family '%d'", sa->sa_family);
			^^^^^^^^^
		Maybe this would be a good time to add in a new
		cFYI/cERROR "flag" for fscache and convert all of these
		to use it?

>  		key_len = 0;
>  		break;
>  	}
> @@ -152,7 +152,7 @@ static uint16_t cifs_super_get_key(const void *cookie_netfs_data, void *buffer,
>  
>  	sharename = extract_sharename(tcon->treeName);
>  	if (IS_ERR(sharename)) {
> -		cFYI(1, "CIFS: couldn't extract sharename\n");
> +		cFYI(1, "%s: couldn't extract sharename\n", __func__);
>  		sharename = NULL;
>  		return 0;
>  	}
> @@ -302,7 +302,7 @@ static void cifs_fscache_inode_now_uncached(void *cookie_netfs_data)
>  	pagevec_init(&pvec, 0);
>  	first = 0;
>  
> -	cFYI(1, "cifs inode 0x%p now uncached", cifsi);
> +	cFYI(1, "%s: cifs inode 0x%p now uncached", __func__, cifsi);
>  
>  	for (;;) {
>  		nr_pages = pagevec_lookup(&pvec,
> diff --git a/fs/cifs/fscache.c b/fs/cifs/fscache.c
> index 8a1070f..2e9e81e 100644
> --- a/fs/cifs/fscache.c
> +++ b/fs/cifs/fscache.c
> @@ -28,14 +28,14 @@ void cifs_fscache_get_client_cookie(struct TCP_Server_Info *server)
>  	server->fscache =
>  		fscache_acquire_cookie(cifs_fscache_netfs.primary_index,
>  				&cifs_fscache_server_index_def, server);
> -	cFYI(1, "CIFS: get client cookie (0x%p/0x%p)", server,
> -				server->fscache);
> +	cFYI(1, "%s: (0x%p/0x%p)", __func__, server,
> +			server->fscache);
>  }
>  
>  void cifs_fscache_release_client_cookie(struct TCP_Server_Info *server)
>  {
> -	cFYI(1, "CIFS: release client cookie (0x%p/0x%p)", server,
> -				server->fscache);
> +	cFYI(1, "%s: (0x%p/0x%p)", __func__, server,
> +			server->fscache);
>  	fscache_relinquish_cookie(server->fscache, 0);
>  	server->fscache = NULL;
>  }
> @@ -47,13 +47,13 @@ void cifs_fscache_get_super_cookie(struct cifs_tcon *tcon)
>  	tcon->fscache =
>  		fscache_acquire_cookie(server->fscache,
>  				&cifs_fscache_super_index_def, tcon);
> -	cFYI(1, "CIFS: get superblock cookie (0x%p/0x%p)",
> -				server->fscache, tcon->fscache);
> +	cFYI(1, "%s: (0x%p/0x%p)", __func__, server->fscache,
> +			tcon->fscache);
>  }
>  
>  void cifs_fscache_release_super_cookie(struct cifs_tcon *tcon)
>  {
> -	cFYI(1, "CIFS: releasing superblock cookie (0x%p)", tcon->fscache);
> +	cFYI(1, "%s: (0x%p)", __func__, tcon->fscache);
>  	fscache_relinquish_cookie(tcon->fscache, 0);
>  	tcon->fscache = NULL;
>  }
> @@ -70,8 +70,8 @@ static void cifs_fscache_enable_inode_cookie(struct inode *inode)
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE) {
>  		cifsi->fscache = fscache_acquire_cookie(tcon->fscache,
>  				&cifs_fscache_inode_object_def, cifsi);
> -		cFYI(1, "CIFS: got FH cookie (0x%p/0x%p)", tcon->fscache,
> -				cifsi->fscache);
> +		cFYI(1, "%s: got FH cookie (0x%p/0x%p)", __func__,
> +				tcon->fscache, cifsi->fscache);
>  	}
>  }
>  
> @@ -80,8 +80,7 @@ void cifs_fscache_release_inode_cookie(struct inode *inode)
>  	struct cifsInodeInfo *cifsi = CIFS_I(inode);
>  
>  	if (cifsi->fscache) {
> -		cFYI(1, "CIFS releasing inode cookie (0x%p)",
> -				cifsi->fscache);
> +		cFYI(1, "%s: (0x%p)", __func__, cifsi->fscache);
>  		fscache_relinquish_cookie(cifsi->fscache, 0);
>  		cifsi->fscache = NULL;
>  	}
> @@ -93,13 +92,12 @@ static int cifs_fscache_disable_inode_cookie(struct inode *inode)
>  	int ret = 0;
>  
>  	if (cifsi->fscache) {
> -		cFYI(1, "CIFS disabling inode cookie (0x%p)",
> -				cifsi->fscache);
> +		cFYI(1, "%s: (0x%p)", __func__, cifsi->fscache);
>  		/* invalidate any mapped pages that were read in before */
>  		if (inode->i_mapping && inode->i_mapping->nrpages) {
>  			ret = invalidate_inode_pages2(inode->i_mapping);
>  			if (ret) {
> -				cERROR(1, "CIFS couldn't invalidate inode %p",
> +				cERROR(1, "couldn't invalidate inode %p",
>  						inode);
>  				return ret;
>  			}
> @@ -136,8 +134,8 @@ void cifs_fscache_reset_inode_cookie(struct inode *inode)
>  					cifs_sb_master_tcon(cifs_sb)->fscache,
>  					&cifs_fscache_inode_object_def,
>  					cifsi);
> -		cFYI(1, "CIFS: new cookie 0x%p oldcookie 0x%p",
> -				cifsi->fscache, old);
> +		cFYI(1, "%s: new cookie 0x%p oldcookie 0x%p",
> +				__func__, cifsi->fscache, old);
>  	}
>  }
>  
> @@ -147,8 +145,8 @@ int cifs_fscache_release_page(struct page *page, gfp_t gfp)
>  		struct inode *inode = page->mapping->host;
>  		struct cifsInodeInfo *cifsi = CIFS_I(inode);
>  
> -		cFYI(1, "CIFS: fscache release page (0x%p/0x%p)",
> -				page, cifsi->fscache);
> +		cFYI(1, "%s: (0x%p/0x%p)", __func__, page,
> +				cifsi->fscache);
>  		if (!fscache_maybe_release_page(cifsi->fscache, page, gfp))
>  			return 0;
>  	}
> @@ -159,8 +157,7 @@ int cifs_fscache_release_page(struct page *page, gfp_t gfp)
>  static void cifs_readpage_from_fscache_complete(struct page *page, void *ctx,
>  						int error)
>  {
> -	cFYI(1, "CFS: readpage_from_fscache_complete (0x%p/%d)",
> -			page, error);
> +	cFYI(1, "%s: (0x%p/%d)", __func__, page, error);
>  	if (!error)
>  		SetPageUptodate(page);
>  	unlock_page(page);
> @@ -173,7 +170,7 @@ int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
>  {
>  	int ret;
>  
> -	cFYI(1, "CIFS: readpage_from_fscache(fsc:%p, p:%p, i:0x%p",
> +	cFYI(1, "%s: (fsc:%p, p:%p, i:0x%p", __func__,
>  			CIFS_I(inode)->fscache, page, inode);
>  	ret = fscache_read_or_alloc_page(CIFS_I(inode)->fscache, page,
>  					 cifs_readpage_from_fscache_complete,
> @@ -182,11 +179,11 @@ int __cifs_readpage_from_fscache(struct inode *inode, struct page *page)
>  	switch (ret) {
>  
>  	case 0: /* page found in fscache, read submitted */
> -		cFYI(1, "CIFS: readpage_from_fscache: submitted");
> +		cFYI(1, "%s: submitted", __func__);
>  		return ret;
>  	case -ENOBUFS:	/* page won't be cached */
>  	case -ENODATA:	/* page not in cache */
> -		cFYI(1, "CIFS: readpage_from_fscache %d", ret);
> +		cFYI(1, "%s: %d", __func__, ret);
>  		return 1;
>  
>  	default:
> @@ -205,7 +202,7 @@ int __cifs_readpages_from_fscache(struct inode *inode,
>  {
>  	int ret;
>  
> -	cFYI(1, "CIFS: __cifs_readpages_from_fscache (0x%p/%u/0x%p)",
> +	cFYI(1, "%s: (0x%p/%u/0x%p)", __func__,
>  			CIFS_I(inode)->fscache, *nr_pages, inode);
>  	ret = fscache_read_or_alloc_pages(CIFS_I(inode)->fscache, mapping,
>  					  pages, nr_pages,
> @@ -214,12 +211,12 @@ int __cifs_readpages_from_fscache(struct inode *inode,
>  					  mapping_gfp_mask(mapping));
>  	switch (ret) {
>  	case 0:	/* read submitted to the cache for all pages */
> -		cFYI(1, "CIFS: readpages_from_fscache: submitted");
> +		cFYI(1, "%s: submitted", __func__);
>  		return ret;
>  
>  	case -ENOBUFS:	/* some pages are not cached and can't be */
>  	case -ENODATA:	/* some pages are not cached */
> -		cFYI(1, "CIFS: readpages_from_fscache: no page");
> +		cFYI(1, "%s: no page", __func__);
>  		return 1;
>  
>  	default:
> @@ -233,7 +230,7 @@ void __cifs_readpage_to_fscache(struct inode *inode, struct page *page)
>  {
>  	int ret;
>  
> -	cFYI(1, "CIFS: readpage_to_fscache(fsc: %p, p: %p, i: %p",
> +	cFYI(1, "%s: (fsc: %p, p: %p, i: %p)", __func__,
>  			CIFS_I(inode)->fscache, page, inode);
>  	ret = fscache_write_page(CIFS_I(inode)->fscache, page, GFP_KERNEL);
>  	if (ret != 0)
> @@ -245,7 +242,7 @@ void __cifs_fscache_invalidate_page(struct page *page, struct inode *inode)
>  	struct cifsInodeInfo *cifsi = CIFS_I(inode);
>  	struct fscache_cookie *cookie = cifsi->fscache;
>  
> -	cFYI(1, "CIFS: fscache invalidatepage (0x%p/0x%p)", page, cookie);
> +	cFYI(1, "%s: (0x%p/0x%p)", __func__, page, cookie);
>  	fscache_wait_on_page_write(cookie, page);
>  	fscache_uncache_page(cookie, page);
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

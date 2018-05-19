From: Tom Talpey <tom@talpey.com>
Subject: Re: [RFC PATCH 02/09] Change wdata alloc to support direct pages
Date: Fri, 18 May 2018 18:05:10 -0700
Message-ID: <e8eba448-542b-2e20-506b-a91dc12335c6@talpey.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
 <20180518002214.5657-3-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: longli@microsoft.com, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-3-longli@linuxonhyperv.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 5/17/2018 5:22 PM, Long Li wrote:
> From: Long Li <longli@microsoft.com>
> 
> When using direct pages from user space, there is no need to allocate pages.
> 
> Just ping those user pages for RDMA.

Did you mean "pin" those user pages? If so, where does that pinning
occur, it's not in this patch.

Perhaps this should just say "point to" those user pages.

I also don't think this is necessarily only "for RDMA". Perhaps
there are other transport scenarios where this is advantageous.


> 
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>   fs/cifs/cifsproto.h |  2 +-
>   fs/cifs/cifssmb.c   | 10 +++++++---
>   fs/cifs/file.c      |  4 ++--
>   3 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 365a414..94106b9 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -523,7 +523,7 @@ int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
>   int cifs_async_writev(struct cifs_writedata *wdata,
>   		      void (*release)(struct kref *kref));
>   void cifs_writev_complete(struct work_struct *work);
> -struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages,
> +struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages, struct page **direct_pages,
>   						work_func_t complete);
>   void cifs_writedata_release(struct kref *refcount);
>   int cifs_query_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 1529a08..3b1731d 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1983,7 +1983,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
>   			tailsz = rest_len - (nr_pages - 1) * PAGE_SIZE;
>   		}
>   
> -		wdata2 = cifs_writedata_alloc(nr_pages, cifs_writev_complete);
> +		wdata2 = cifs_writedata_alloc(nr_pages, NULL, cifs_writev_complete);
>   		if (!wdata2) {
>   			rc = -ENOMEM;
>   			break;
> @@ -2067,12 +2067,16 @@ cifs_writev_complete(struct work_struct *work)
>   }
>   
>   struct cifs_writedata *
> -cifs_writedata_alloc(unsigned int nr_pages, work_func_t complete)
> +cifs_writedata_alloc(unsigned int nr_pages, struct page **direct_pages, work_func_t complete)
>   {
>   	struct cifs_writedata *wdata;
>   
>   	/* writedata + number of page pointers */
> -	wdata = kzalloc(sizeof(*wdata) +
> +	if (direct_pages) {
> +		wdata = kzalloc(sizeof(*wdata), GFP_NOFS);
> +		wdata->direct_pages = direct_pages;
> +	} else
> +		wdata = kzalloc(sizeof(*wdata) +
>   			sizeof(struct page *) * nr_pages, GFP_NOFS);
>   	if (wdata != NULL) {
>   		kref_init(&wdata->refcount);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 23fd430..a6ec896 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1965,7 +1965,7 @@ wdata_alloc_and_fillpages(pgoff_t tofind, struct address_space *mapping,
>   {
>   	struct cifs_writedata *wdata;
>   
> -	wdata = cifs_writedata_alloc((unsigned int)tofind,
> +	wdata = cifs_writedata_alloc((unsigned int)tofind, NULL,
>   				     cifs_writev_complete);
>   	if (!wdata)
>   		return NULL;
> @@ -2554,7 +2554,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>   			break;
>   
>   		nr_pages = get_numpages(wsize, len, &cur_len);
> -		wdata = cifs_writedata_alloc(nr_pages,
> +		wdata = cifs_writedata_alloc(nr_pages, NULL,
>   					     cifs_uncached_writev_complete);
>   		if (!wdata) {
>   			rc = -ENOMEM;
> 

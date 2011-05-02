From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 5/8] cifs: add cifs_async_writev
Date: Mon, 2 May 2011 10:27:36 -0400
Message-ID: <20110502102736.4e0cd17a@corrin.poochiereds.net>
References: <1304345069-2441-1-git-send-email-jlayton@redhat.com>
	<1304345069-2441-6-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1304345069-2441-6-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  2 May 2011 10:04:26 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Add the ability for CIFS to do an asynchronous write. The kernel will
> set the frame up as it would for a "normal" SMBWrite2 request, and use
> cifs_call_async to send it. The mid callback will then be configured to
> handle the result.
> 
> Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsproto.h |   18 ++++
>  fs/cifs/cifssmb.c   |  238 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 256 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index c621b45..d35019b 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -433,4 +433,22 @@ extern int mdfour(unsigned char *, unsigned char *, int);
>  extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
>  extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
>  			unsigned char *p24);
> +
> +/* asynchronous write support */
> +struct cifs_writedata {
> +	struct kref			refcount;
> +	enum writeback_sync_modes	sync_mode;
> +	struct work_struct		work;
> +	struct cifsFileInfo		*cfile;
> +	__u64				offset;
> +	unsigned int			bytes;
> +	int				result;
> +	unsigned int			nr_pages;
> +	struct page 			*pages[1];
> +};
> +
> +int cifs_async_writev(struct cifs_writedata *wdata);
> +struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages);
> +void cifs_writedata_release(struct kref *refcount);
> +
>  #endif			/* _CIFSPROTO_H */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index d4698b9..6ff9b0a 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -32,6 +32,7 @@
>  #include <linux/vfs.h>
>  #include <linux/slab.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/pagemap.h>
>  #include <asm/uaccess.h>
>  #include "cifspdu.h"
>  #include "cifsglob.h"
> @@ -1604,6 +1605,243 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
>  	return rc;
>  }
>  
> +void
> +cifs_writedata_release(struct kref *refcount)
> +{
> +	struct cifs_writedata *wdata = container_of(refcount,
> +					struct cifs_writedata, refcount);
> +
> +	if (wdata->cfile)
> +		cifsFileInfo_put(wdata->cfile);
> +
> +	kfree(wdata);
> +}
> +
> +/*
> + * Write failed with a retryable error. Resend the write request. It's also
> + * possible that the page was redirtied so re-clean the page.
> + */
> +static void
> +cifs_writev_requeue(struct cifs_writedata *wdata)
> +{
> +	int i, rc;
> +	struct inode *inode = wdata->cfile->dentry->d_inode;
> +
> +	for (i = 0; i < wdata->nr_pages; i++) {
> +		lock_page(wdata->pages[i]);
> +		clear_page_dirty_for_io(wdata->pages[i]);
> +	}
> +
> +	do {
> +		rc = cifs_async_writev(wdata);
> +	} while(rc != -EAGAIN);
> +

<forehead slap>

The above should be == -EAGAIN...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

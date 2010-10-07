From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 13/15] cifs: convert cifsFileInfo->count to non-atomic
 counter
Date: Thu, 07 Oct 2010 14:18:50 +0530
Message-ID: <4CAD8972.9090406@suse.de>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com> <1286394857-32541-14-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286394857-32541-14-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/07/2010 01:24 AM, Jeff Layton wrote:
> The count for cifsFileInfo is currently an atomic, but that just adds
> complexity for little value. We generally need to hold cifs_file_list_lock
> to traverse the lists anyway so we might as well make this counter
> non-atomic and simply use the cifs_file_list_lock to protect it.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    9 ++++++---
>  fs/cifs/file.c     |    8 +++++---
>  2 files changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 531a768..f3c4e00 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -393,16 +393,19 @@ struct cifsFileInfo {
>  	struct list_head llist; /* list of byte range locks we have. */
>  	bool invalidHandle:1;	/* file closed via session abend */
>  	bool oplock_break_cancelled:1;
> -	atomic_t count;		/* reference count */
> +	int count;		/* refcount -- protected by cifs_file_list_lock */
>  	struct mutex fh_mutex; /* prevents reopen race after dead ses*/
>  	struct cifs_search_info srch_inf;
>  	struct work_struct oplock_break; /* work for oplock breaks */
>  };
>  
> -/* Take a reference on the file private data */
> +/*
> + * Take a reference on the file private data. Must be called with
> + * cifs_file_list_lock held for read or write.
> + */
>  static inline void cifsFileInfo_get(struct cifsFileInfo *cifs_file)
>  {
> -	atomic_inc(&cifs_file->count);
> +	++cifs_file->count;

Since we now use cifs_file_list_lock to protect cifs_file->count too,
shouldn't all the callers of cifsFileInfo_get() need to acquire a write
lock instead of read lock?


-- 
Suresh Jayaraman

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: when CONFIG_HIGHMEM is set, serialize the
 read/write kmaps
Date: Thu, 12 Jul 2012 20:41:19 +0400
Message-ID: <CAKywueT59Xe_1nnr8TNvDq7WCEdLAHM3evVqs0wyVatat+OcrA@mail.gmail.com>
References: <1342012176-14783-1-git-send-email-jlayton@redhat.com>
	<1342012176-14783-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342012176-14783-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/11 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Jian found that when he ran fsx on a 32 bit arch with a large wsize the
> process and one of the bdi writeback kthreads would sometimes deadlock
> with a stack trace like this:
>
> crash> bt
> PID: 2789   TASK: f02edaa0  CPU: 3   COMMAND: "fsx"
>  #0 [eed63cbc] schedule at c083c5b3
>  #1 [eed63d80] kmap_high at c0500ec8
>  #2 [eed63db0] cifs_async_writev at f7fabcd7 [cifs]
>  #3 [eed63df0] cifs_writepages at f7fb7f5c [cifs]
>  #4 [eed63e50] do_writepages at c04f3e32
>  #5 [eed63e54] __filemap_fdatawrite_range at c04e152a
>  #6 [eed63ea4] filemap_fdatawrite at c04e1b3e
>  #7 [eed63eb4] cifs_file_aio_write at f7fa111a [cifs]
>  #8 [eed63ecc] do_sync_write at c052d202
>  #9 [eed63f74] vfs_write at c052d4ee
> #10 [eed63f94] sys_write at c052df4c
> #11 [eed63fb0] ia32_sysenter_target at c0409a98
>     EAX: 00000004  EBX: 00000003  ECX: abd73b73  EDX: 012a65c6
>     DS:  007b      ESI: 012a65c6  ES:  007b      EDI: 00000000
>     SS:  007b      ESP: bf8db178  EBP: bf8db1f8  GS:  0033
>     CS:  0073      EIP: 40000424  ERR: 00000004  EFLAGS: 00000246
>
> Each task would kmap part of its address array before getting stuck, but
> not enough to actually issue the write.
>
> This patch fixes this by serializing the marshal_iov operations for
> async reads and writes. The idea here is to ensure that cifs
> aggressively tries to populate a request before attempting to fulfill
> another one. As soon as all of the pages are kmapped for a request, then
> we can unlock and allow another one to proceed.
>
> There's no need to do this serialization on non-CONFIG_HIGHMEM arches
> however, so optimize all of this out when CONFIG_HIGHMEM isn't set.
>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Reported-by: Jian Li <jiali-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifssmb.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 0170ee8..684a072 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -86,7 +86,31 @@ static struct {
>  #endif /* CONFIG_CIFS_WEAK_PW_HASH */
>  #endif /* CIFS_POSIX */
>
> -/* Forward declarations */
> +#ifdef CONFIG_HIGHMEM
> +/*
> + * On arches that have high memory, kmap address space is limited. By
> + * serializing the kmap operations on those arches, we ensure that we don't
> + * end up with a bunch of threads in writeback with partially mapped page
> + * arrays, stuck waiting for kmap to come back. That situation prevents
> + * progress and can deadlock.
> + */
> +static DEFINE_MUTEX(cifs_kmap_mutex);
> +
> +static inline void
> +cifs_kmap_lock(void)
> +{
> +       mutex_lock(&cifs_kmap_mutex);
> +}
> +
> +static inline void
> +cifs_kmap_unlock(void)
> +{
> +       mutex_unlock(&cifs_kmap_mutex);
> +}
> +#else /* !CONFIG_HIGHMEM */
> +#define cifs_kmap_lock() do { ; } while(0)

checkpatch.pl raises the "ERROR: space required before the open
parenthesis '('" error.

> +#define cifs_kmap_unlock() do { ; } while(0)

the same checkpatch.pl error.

> +#endif /* CONFIG_HIGHMEM */
>
>  /* Mark as invalid, all open files on tree connections since they
>     were closed when session to server was lost */
> @@ -1503,7 +1527,9 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
>         }
>
>         /* marshal up the page array */
> +       cifs_kmap_lock();
>         len = rdata->marshal_iov(rdata, data_len);
> +       cifs_kmap_unlock();
>         data_len -= len;
>
>         /* issue the read if we have any iovecs left to fill */
> @@ -2069,7 +2095,9 @@ cifs_async_writev(struct cifs_writedata *wdata)
>          * and set the iov_len properly for each one. It may also set
>          * wdata->bytes too.
>          */
> +       cifs_kmap_lock();
>         wdata->marshal_iov(iov, wdata);
> +       cifs_kmap_unlock();
>
>         cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards,
Pavel Shilovsky.

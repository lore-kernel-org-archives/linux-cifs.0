From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: show features compiled in as part of
 DebugData
Date: Fri, 30 Jul 2010 09:04:15 -0400
Message-ID: <20100730090415.2a61f86a@corrin.poochiereds.net>
References: <1280494556.19538.7.camel@jay-t60p>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280494556.19538.7.camel@jay-t60p>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Jul 2010 18:25:56 +0530
Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org> wrote:

> Fixed the nit pointed out by Jeff.
> 
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [PATCH 1/2] cifs: show features compiled in as part of DebugData
> 
> This patch adds the features that are compiled in to the CIFS debugging data
> as shown below:
> 
> 	$cat /proc/fs/cifs/DebugData 
> 	Display Internal CIFS Data Structures for Debugging
> 	---------------------------------------------------
> 	CIFS Version 1.64
> 	Features: dfs fscache posix spnego xattr 
> 	Active VFS Requests: 0
> 	...
> 
> This patch provides a definitive way to tell what features are currently
> enabled in the running kernel. This could also help debugging.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |   25 +++++++++++++++++++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 4fce6e6..eb1ba49 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -119,6 +119,31 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
>  		    "Display Internal CIFS Data Structures for Debugging\n"
>  		    "---------------------------------------------------\n");
>  	seq_printf(m, "CIFS Version %s\n", CIFS_VERSION);
> +	seq_printf(m, "Features: ");
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +	seq_printf(m, "dfs");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_FSCACHE
> +	seq_printf(m, "fscache");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_WEAK_PW_HASH
> +	seq_printf(m, "lanman");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_POSIX
> +	seq_printf(m, "posix");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_UPCALL
> +	seq_printf(m, "spnego");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_XATTR
> +	seq_printf(m, "xattr");
> +#endif
> +	seq_putc(m, '\n');
>  	seq_printf(m, "Active VFS Requests: %d\n", GlobalTotalActiveXid);
>  	seq_printf(m, "Servers:");
>  
> 
> 

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

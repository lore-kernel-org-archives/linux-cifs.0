From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 1/2] cifs: show enabled features in /proc
Date: Fri, 30 Jul 2010 07:09:33 -0400
Message-ID: <20100730070933.12ddc467@corrin.poochiereds.net>
References: <4C52A287.7020904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Steve French (smfltc)" <smfltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C52A287.7020904-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 30 Jul 2010 15:29:35 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> Based on the previous discussions and suggestion by Jeff on providing a way
> to tell about compiled kernel config options, I wrote a simple patch. It seems
> useful. But, feel free to ignore this patch if you think it is not..
> 
> From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Subject: [RFC][PATCH 1/2] cifs: show enabled features in /proc
> 
> Here's a simple patch to show the compiled in CIFS features. This patch adds a
> /proc file called "features" when read will show the features enabled in the
> running kernel as shown below:
> 
> 	$cat /proc/fs/cifs/features
> 	# CIFS features enabled
> 	dfs spnego fsc
> 
> This provides a definitive way to tell what features are currently enabled.
> This could be useful as a debugging information as well.
> 
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |   36 ++++++++++++++++++++++++++++++++++++
>  1 files changed, 36 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 4fce6e6..af5dbf7 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -402,6 +402,7 @@ static const struct file_operations cifs_multiuser_mount_proc_fops;
>  static const struct file_operations cifs_security_flags_proc_fops;
>  static const struct file_operations cifs_experimental_proc_fops;
>  static const struct file_operations cifs_linux_ext_proc_fops;
> +static const struct file_operations cifs_feat_proc_fops;
>  
>  void
>  cifs_proc_init(void)
> @@ -428,6 +429,8 @@ cifs_proc_init(void)
>  		    &cifs_security_flags_proc_fops);
>  	proc_create("LookupCacheEnabled", 0, proc_fs_cifs,
>  		    &cifs_lookup_cache_proc_fops);
> +	proc_create("features", 0, proc_fs_cifs,
> +		    &cifs_feat_proc_fops);
>  }
>  
>  void
> @@ -448,6 +451,7 @@ cifs_proc_clean(void)
>  	remove_proc_entry("LinuxExtensionsEnabled", proc_fs_cifs);
>  	remove_proc_entry("Experimental", proc_fs_cifs);
>  	remove_proc_entry("LookupCacheEnabled", proc_fs_cifs);
> +	remove_proc_entry("features", proc_fs_cifs);
>  	remove_proc_entry("fs/cifs", NULL);
>  }
>  
> @@ -791,6 +795,38 @@ static const struct file_operations cifs_security_flags_proc_fops = {
>  	.release	= single_release,
>  	.write		= cifs_security_flags_proc_write,
>  };
> +
> +static int cifs_feat_proc_show(struct seq_file *m, void *v)
> +{
> +	seq_printf(m, "# CIFS features enabled\n");
> +#ifdef CONFIG_CIFS_DFS_UPCALL
> +	seq_printf(m, "dfs");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_UPCALL
> +	seq_printf(m, "spnego");
> +	seq_putc(m, ' ');
> +#endif
> +#ifdef CONFIG_CIFS_FSCACHE
> +	seq_printf(m, "fsc");
> +	seq_putc(m, ' ');
> +#endif
> +	seq_putc(m, '\n');
> +	return 0;
> +}
> +
> +static int cifs_feat_proc_open(struct inode *inode, struct file *file)
> +{
> +	return single_open(file, cifs_feat_proc_show, NULL);
> +}
> +
> +static const struct file_operations cifs_feat_proc_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= cifs_feat_proc_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= single_release,
> +};
>  #else
>  inline void cifs_proc_init(void)
>  {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks good. Now that I've given this more thought though...

I wonder if this would be better done as a new line near the beginning
of /proc/fs/cifs/DebugData. Maybe:

Features: dfs spnego fsc

People often provide that info already when reporting bugs. We wouldn't
need to ask for anything new that way.

Thoughts?
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

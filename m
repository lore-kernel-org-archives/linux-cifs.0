From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: remove /proc/fs/cifs/Experimental
Date: Tue, 7 Dec 2010 11:13:28 -0500
Message-ID: <20101207111328.6647c36c@tlielax.poochiereds.net>
References: <1291731835-1120-1-git-send-email-jlayton@redhat.com>
	<1291731835-1120-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291731835-1120-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue,  7 Dec 2010 09:23:55 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> This flag only affects a couple of places in the write codepath, and
> it's not entirely clear to me what the purpose of it is. I've never
> known anyone (even developers) to use this knob, so let's remove it.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |   42 ------------------------------------------
>  fs/cifs/cifsfs.c     |    1 -
>  fs/cifs/cifsglob.h   |    1 -
>  fs/cifs/file.c       |    6 +++---
>  4 files changed, 3 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 103ab8b..04eecb2 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -425,7 +425,6 @@ static const struct file_operations cifs_lookup_cache_proc_fops;
>  static const struct file_operations traceSMB_proc_fops;
>  static const struct file_operations cifs_multiuser_mount_proc_fops;
>  static const struct file_operations cifs_security_flags_proc_fops;
> -static const struct file_operations cifs_experimental_proc_fops;
>  static const struct file_operations cifs_linux_ext_proc_fops;
>  
>  void
> @@ -443,8 +442,6 @@ cifs_proc_init(void)
>  	proc_create("cifsFYI", 0, proc_fs_cifs, &cifsFYI_proc_fops);
>  	proc_create("traceSMB", 0, proc_fs_cifs, &traceSMB_proc_fops);
>  	proc_create("OplockEnabled", 0, proc_fs_cifs, &cifs_oplock_proc_fops);
> -	proc_create("Experimental", 0, proc_fs_cifs,
> -		    &cifs_experimental_proc_fops);
>  	proc_create("LinuxExtensionsEnabled", 0, proc_fs_cifs,
>  		    &cifs_linux_ext_proc_fops);
>  	proc_create("MultiuserMount", 0, proc_fs_cifs,
> @@ -552,45 +549,6 @@ static const struct file_operations cifs_oplock_proc_fops = {
>  	.write		= cifs_oplock_proc_write,
>  };
>  
> -static int cifs_experimental_proc_show(struct seq_file *m, void *v)
> -{
> -	seq_printf(m, "%d\n", experimEnabled);
> -	return 0;
> -}
> -
> -static int cifs_experimental_proc_open(struct inode *inode, struct file *file)
> -{
> -	return single_open(file, cifs_experimental_proc_show, NULL);
> -}
> -
> -static ssize_t cifs_experimental_proc_write(struct file *file,
> -		const char __user *buffer, size_t count, loff_t *ppos)
> -{
> -	char c;
> -	int rc;
> -
> -	rc = get_user(c, buffer);
> -	if (rc)
> -		return rc;
> -	if (c == '0' || c == 'n' || c == 'N')
> -		experimEnabled = 0;
> -	else if (c == '1' || c == 'y' || c == 'Y')
> -		experimEnabled = 1;
> -	else if (c == '2')
> -		experimEnabled = 2;
> -
> -	return count;
> -}
> -
> -static const struct file_operations cifs_experimental_proc_fops = {
> -	.owner		= THIS_MODULE,
> -	.open		= cifs_experimental_proc_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= single_release,
> -	.write		= cifs_experimental_proc_write,
> -};
> -
>  static int cifs_linux_ext_proc_show(struct seq_file *m, void *v)
>  {
>  	seq_printf(m, "%d\n", linuxExtEnabled);
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 48582b7..932a347 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -53,7 +53,6 @@ int cifsFYI = 0;
>  int cifsERROR = 1;
>  int traceSMB = 0;
>  unsigned int oplockEnabled = 1;
> -unsigned int experimEnabled = 0;
>  unsigned int linuxExtEnabled = 1;
>  unsigned int lookupCacheEnabled = 1;
>  unsigned int multiuser_mount = 0;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 37fb246..5ab6701 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -777,7 +777,6 @@ GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
>  				have the uid/password or Kerberos credential
>  				or equivalent for current user */
>  GLOBAL_EXTERN unsigned int oplockEnabled;
> -GLOBAL_EXTERN unsigned int experimEnabled;
>  GLOBAL_EXTERN unsigned int lookupCacheEnabled;
>  GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
>  				with more secure ntlmssp2 challenge/resp */
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5a28660..5f6907e 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1054,10 +1054,10 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file,
>  				if (rc != 0)
>  					break;
>  			}
> -			if (experimEnabled || (pTcon->ses->server &&
> +			if (pTcon->ses->server &&
>  				((pTcon->ses->server->secMode &
>  				(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
> -				== 0))) {
> +				== 0)) {
>  				struct kvec iov[2];
>  				unsigned int len;
>  
> @@ -1319,7 +1319,7 @@ static int cifs_writepages(struct address_space *mapping,
>  	}
>  
>  	tcon = tlink_tcon(open_file->tlink);
> -	if (!experimEnabled && tcon->ses->server->secMode &
> +	if (tcon->ses->server->secMode &
>  			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
>  		cifsFileInfo_put(open_file);
>  		kfree(iov);

Just noticed that this misses removing the de-registration of
"Experimental", so it'll need to be respun.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/3] cifs: add new module parameter 'enable_oplocks'
Date: Wed, 12 Oct 2011 08:12:12 -0400
Message-ID: <20111012081212.73c2eba2@tlielax.poochiereds.net>
References: <4E95827D.900@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E95827D.900-IBi9RG/b67k@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 12 Oct 2011 17:35:17 +0530
Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:

> Thus spake Jeff Layton:
> 
> "Making that a module parm would allow you to set that parameter at boot
> time without needing to add special startup scripts. IMO, all of the
> procfile "switches" under /proc/fs/cifs should be module parms
> instead."
> 
> This patch doesn't alter the default behavior (Oplocks are enabled by
> default).
> 
> To disable oplocks when loading the module, use
>  
>    modprobe cifs enable_oplocks=0
> 
> (any of '0' or 'n' or 'N' conventions can be used).
> 
> To disable oplocks at runtime using the new interface, use
> 
>    echo 0 > /sys/module/cifs/parameters/enable_oplocks
> 
> The older /proc/fs/cifs/OplockEnabled interface will be deprecated
> after two releases. A subsequent patch will add an warning message
> about this deprecation.
> 
> Changes since v2:
>    - make enable_oplocks a 'bool'
> 
> Changes since v1:
>    - eliminate the use of extra variable by renaming the old one to
>      enable_oplocks and make it an 'int' type.
> 
> Reported-by: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    6 +++---
>  fs/cifs/cifsfs.c     |    6 +++++-
>  fs/cifs/cifsglob.h   |    3 ++-
>  fs/cifs/dir.c        |    2 +-
>  fs/cifs/file.c       |    4 ++--
>  5 files changed, 13 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index 2fe3cf1..7c27035 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -511,7 +511,7 @@ static const struct file_operations cifsFYI_proc_fops = {
>  
>  static int cifs_oplock_proc_show(struct seq_file *m, void *v)
>  {
> -	seq_printf(m, "%d\n", oplockEnabled);
> +	seq_printf(m, "%d\n", enable_oplocks);
>  	return 0;
>  }
>  
> @@ -530,9 +530,9 @@ static ssize_t cifs_oplock_proc_write(struct file *file,
>  	if (rc)
>  		return rc;
>  	if (c == '0' || c == 'n' || c == 'N')
> -		oplockEnabled = 0;
> +		enable_oplocks = false;
>  	else if (c == '1' || c == 'y' || c == 'Y')
> -		oplockEnabled = 1;
> +		enable_oplocks = true;
>  
>  	return count;
>  }
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 3e29899..f40ed47 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -52,7 +52,7 @@
>  int cifsFYI = 0;
>  int cifsERROR = 1;
>  int traceSMB = 0;
> -unsigned int oplockEnabled = 1;
> +bool enable_oplocks = true;
>  unsigned int linuxExtEnabled = 1;
>  unsigned int lookupCacheEnabled = 1;
>  unsigned int multiuser_mount = 0;
> @@ -81,6 +81,10 @@ module_param(echo_retries, ushort, 0644);
>  MODULE_PARM_DESC(echo_retries, "Number of echo attempts before giving up and "
>  			       "reconnecting server. Default: 5. 0 means "
>  			       "never reconnect.");
> +module_param(enable_oplocks, bool, 0644);
> +MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
> +				 "y/Y/1");
> +
>  extern mempool_t *cifs_sm_req_poolp;
>  extern mempool_t *cifs_req_poolp;
>  extern mempool_t *cifs_mid_poolp;
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6255fa8..5c72f60 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -922,7 +922,8 @@ GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
>  				to be established on existing mount if we
>  				have the uid/password or Kerberos credential
>  				or equivalent for current user */
> -GLOBAL_EXTERN unsigned int oplockEnabled;
> +/* enable or disable oplocks */
> +GLOBAL_EXTERN bool enable_oplocks;
>  GLOBAL_EXTERN unsigned int lookupCacheEnabled;
>  GLOBAL_EXTERN unsigned int global_secflags;	/* if on, session setup sent
>  				with more secure ntlmssp2 challenge/resp */
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 81914df..4d83659 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -165,7 +165,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, int mode,
>  	}
>  	tcon = tlink_tcon(tlink);
>  
> -	if (oplockEnabled)
> +	if (enable_oplocks)
>  		oplock = REQ_OPLOCK;
>  
>  	if (nd && (nd->flags & LOOKUP_OPEN))
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index bb71471..41149a0 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -369,7 +369,7 @@ int cifs_open(struct inode *inode, struct file *file)
>  	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
>  		 inode, file->f_flags, full_path);
>  
> -	if (oplockEnabled)
> +	if (enable_oplocks)
>  		oplock = REQ_OPLOCK;
>  	else
>  		oplock = 0;
> @@ -493,7 +493,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
>  	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
>  		 inode, pCifsFile->f_flags, full_path);
>  
> -	if (oplockEnabled)
> +	if (enable_oplocks)
>  		oplock = REQ_OPLOCK;
>  	else
>  		oplock = 0;

Looks good. The other patches from the v2 series also seem fine.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

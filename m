From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 1/8] cifs: add "mfsymlinks" mount option
Date: Thu, 05 Aug 2010 17:14:25 +0530
Message-ID: <4C5AA419.1050005@suse.de>
References: <1280847960-16371-1-git-send-email-metze@samba.org> <1280847960-16371-2-git-send-email-metze@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-2-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 08/03/2010 08:35 PM, Stefan Metzmacher wrote:
> This is the start for an implementation of "Minshall+French Symlinks"
> (see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks).
> 
> Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/README       |    5 +++++
>  fs/cifs/cifs_fs_sb.h |    1 +
>  fs/cifs/cifsfs.c     |    2 ++
>  fs/cifs/connect.c    |   11 +++++++++++
>  4 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index a727b7c..228c239 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -517,6 +517,11 @@ A partial list of the supported mount options follows:
>  		SFU does).  In the future the bottom 9 bits of the
>  		mode also will be emulated using queries of the security
>  		descriptor (ACL).
> + mfsymlinks     Enable support for Minshall+French symlinks
> +		(see http://wiki.samba.org/index.php/UNIX_Extensions#Minshall.2BFrench_symlinks)
> +		This option is ignored when specified together with the
> +		'sfu' option. Minshall+French symlinks are used event if

nit..  Did you mean "even" here?                               ^^^^

> +		the server supports the CIFS Unix Extensions.
>   sign           Must use packet signing (helps avoid unwanted data modification
>  		by intermediate systems in the route).  Note that signing
>  		does not work with lanman or plaintext authentication.
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 2a43a0a..b3b8752 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -100,6 +100,7 @@ struct smb_vol {
>  	bool noautotune:1;
>  	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
>  	bool fsc:1;	/* enable fscache */
> +	bool mfsymlinks:1; /* use Minshall+French Symlinks */
>  	unsigned int rsize;
>  	unsigned int wsize;
>  	bool sockopt_tcp_nodelay:1;
> @@ -1343,6 +1344,8 @@ cifs_parse_mount_options(char *options, const char *devname,
>  				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
>  		} else if (strnicmp(data, "fsc", 3) == 0) {
>  			vol->fsc = true;
> +		} else if (strnicmp(data, "mfsymlinks", 22) == 0) {
				
 Why 22 here?


Thanks,


-- 
Suresh Jayaraman

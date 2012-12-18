From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] setcifsacl: remove syslog goop
Date: Tue, 18 Dec 2012 08:59:36 -0500
Message-ID: <20121218085936.5d7ed046@tlielax.poochiereds.net>
References: <1355409355-9565-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355409355-9565-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 13 Dec 2012 09:35:55 -0500
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> setcifsacl doesn't use syslog, so no need to open a channel to it.
> 
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  setcifsacl.c | 15 ++++-----------
>  1 file changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/setcifsacl.c b/setcifsacl.c
> index 593997a..e8c10a9 100644
> --- a/setcifsacl.c
> +++ b/setcifsacl.c
> @@ -26,7 +26,6 @@
>  
>  #include <string.h>
>  #include <getopt.h>
> -#include <syslog.h>
>  #include <stdint.h>
>  #include <stdbool.h>
>  #include <unistd.h>
> @@ -39,8 +38,6 @@
>  #include <sys/xattr.h>
>  #include "cifsacl.h"
>  
> -static const char *prog;
> -
>  enum setcifsacl_actions {
>  	ActUnknown = -1,
>  	ActDelete,
> @@ -732,7 +729,7 @@ setacl_action(struct cifs_ntsd *pntsd, struct cifs_ntsd **npntsd,
>  }
>  
>  static void
> -setcifsacl_usage(void)
> +setcifsacl_usage(const char *prog)
>  {
>  	fprintf(stderr,
>  	"%s: Alter CIFS/NTFS ACL in a security descriptor of a file object\n",
> @@ -771,10 +768,6 @@ main(const int argc, char *const argv[])
>  	struct cifs_ace **cacesptr = NULL, **facesptr = NULL;
>  	struct cifs_ntsd *ntsdptr = NULL;
>  
> -	prog = basename(argv[0]);
> -
> -	openlog(prog, 0, LOG_DAEMON);
> -
>  	c = getopt(argc, argv, "hvD:M:a:S:");
>  	switch (c) {
>  	case 'D':
> @@ -794,19 +787,19 @@ main(const int argc, char *const argv[])
>  		ace_list = optarg;
>  		break;
>  	case 'h':
> -		setcifsacl_usage();
> +		setcifsacl_usage(basename(argv[0]));
>  		return 0;
>  	case 'v':
>  		printf("Version: %s\n", VERSION);
>  		return 0;
>  	default:
> -		setcifsacl_usage();
> +		setcifsacl_usage(basename(argv[0]));
>  		return -1;
>  	}
>  
>  	/* We expect 1 argument in addition to the option */
>  	if (argc != 4) {
> -		setcifsacl_usage();
> +		setcifsacl_usage(basename(argv[0]));
>  		return -1;
>  	}
>  	filename = argv[3];

Merged...
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RFC cifs-utils: Use autoconf to get kernel headers
Date: Mon, 22 Jul 2013 14:27:52 -0400
Message-ID: <20130722142752.046fde43@tlielax.poochiereds.net>
References: <1374515243-21624-1-git-send-email-scott.lovenberg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: gang.chen-bOixZGp5f+dBDgjK7y7TUQ@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374515243-21624-1-git-send-email-scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 22 Jul 2013 13:47:23 -0400
scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> This is an RFC for how we'd use autoconf to get the Linux kernel headers
> in include/uapi/linux/cifs.h.  If this is the correct approach, I'll
> formalize this patch.  I've never played with autoconf before so this is
> completely untested but should (read: might) probably work.
> 
> Signed-off-by: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  configure.ac |  3 +++
>  mount.cifs.c | 27 +++++++++++++++++++--------
>  2 files changed, 22 insertions(+), 8 deletions(-)
> 

I think the first step is to do a kernel patch that makes this cifs.h
file. I won't commit any sort of patch like this until that's committed
first.

Also "cifs.h" is somewhat generic. I think you should probably name it
a bit more specifically -- maybe include/uapi/linux/cifs/cifs_mount.h...

> diff --git a/configure.ac b/configure.ac
> index b5f7c49..708fdeb 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -111,6 +111,9 @@ AC_SUBST(RT_LDADD)
>  # Checks for header files.
>  AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb.h stddef.h stdint.h stdbool.h stdlib.h stdio.h errno.h string.h strings.h sys/mount.h sys/param.h sys/socket.h sys/time.h syslog.h unistd.h], , [AC_MSG_ERROR([necessary header(s) not found])])
>  
> +# Check for linux's cifs.h header that defines string lengths.
> +AC_CHECK_HEADER([linux/cifs.h], ,[AC_MSG_WARN([cifs kernel header not found. Using internal values.])])
> +
>  # do we have sys/fsuid.h and setfsuid()?
>  AC_CHECK_HEADERS([sys/fsuid.h])
>  AC_CHECK_FUNC(setfsuid, , [AC_MSG_ERROR([System does not support setfsuid()])])
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 77ea0f8..0fca0a9 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -62,6 +62,9 @@
>  #include "mount.h"
>  #include "util.h"
>  #include "resolve_host.h"
> +#ifdef HAVE_LINUX_CIFS_H
> +#include <linux/cifs.h>
> +#endif /* HAVE_LINUX_CIFS_h */
>  
>  #ifndef MS_MOVE 
>  #define MS_MOVE 8192 
> @@ -91,16 +94,24 @@
>  
>  /* Max length of the share name portion of a UNC. Share names over 80
>   * characters cannot be accessed via commandline in Windows 2000/XP. */
> -#define MAX_SHARE_LEN 256
> +#ifndef MAX_SHARE_SIZE
> +#define MAX_SHARE_SIZE 256
> +#endif
>  
>  /* Max user name length. */
> +#ifndef MAX_USERNAME_SIZE
>  #define MAX_USERNAME_SIZE 256
> +#endif
>  
>  /* Max domain size. */
> -#define MAX_DOMAIN_SIZE 256
> +#ifndef MAX_DOMAINNAME_SIZE
> +#define MAX_DOMAINNAME_SIZE 256
> +#endif
>  
>  /* Max password size. */
> -#define MOUNT_PASSWD_SIZE 512
> +#ifndef MAX_PASSWORD_SIZE
> +#define MAX_PASSWORD_SIZE 512
> +#endif
>  
>  
>  
> @@ -176,12 +187,12 @@
>  struct parsed_mount_info {
>  	unsigned long flags;
>  	char host[NI_MAXHOST + 1];
> -	char share[MAX_SHARE_LEN + 1];
> +	char share[MAX_SHARE_SIZE + 1];
>  	char prefix[PATH_MAX + 1];
>  	char options[MAX_OPTIONS_LEN];
> -	char domain[MAX_DOMAIN_SIZE + 1];
> +	char domain[MAX_DOMAINNAME_SIZE + 1];
>  	char username[MAX_USERNAME_SIZE + 1];
> -	char password[MOUNT_PASSWD_SIZE + 1];
> +	char password[MAX_PASSWORD_SIZE + 1];
>  	char addrlist[MAX_ADDR_LIST_LEN];
>  	unsigned int got_user:1;
>  	unsigned int got_password:1;
> @@ -1766,13 +1777,13 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
>  	}
>  
>  	if (!parsed_info->got_password) {
> -		char tmp_pass[MOUNT_PASSWD_SIZE + 1];
> +		char tmp_pass[MAX_PASSWORD_SIZE + 1];
>  		char *prompt = NULL;
>  
>  		if(asprintf(&prompt, "Password for %s@%s: ", parsed_info->username, orig_dev) < 0)
>  			prompt = NULL;
>  
> -		if (get_password(prompt ? prompt : "Password: ", tmp_pass, MOUNT_PASSWD_SIZE + 1)) {
> +		if (get_password(prompt ? prompt : "Password: ", tmp_pass, MAX_PASSWORD_SIZE + 1)) {
>  			rc = set_password(parsed_info, tmp_pass);
>  		} else {
>  			fprintf(stderr, "Error reading password, exiting\n");


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [cifs-utils PATCH] cifs: use krb5_kt_default() to determine
 default keytab location
Date: Mon, 7 Apr 2014 14:37:51 -0400
Message-ID: <20140407143751.51c7fc8a@tlielax.poochiereds.net>
References: <1396488119-7796-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, klepikho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396488119-7796-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  2 Apr 2014 21:21:59 -0400
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> ...don't assume that it's in /etc/krb5.keytab.
> 
> Reported-by: Konstantin Lepikhov <klepikho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  cifs.upcall.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/cifs.upcall.c b/cifs.upcall.c
> index cc65824d3689..e8544c2b68ad 100644
> --- a/cifs.upcall.c
> +++ b/cifs.upcall.c
> @@ -55,7 +55,6 @@
>  #define	CIFS_DEFAULT_KRB5_DIR		"/tmp"
>  #define	CIFS_DEFAULT_KRB5_USER_DIR	"/run/user/%U"
>  #define	CIFS_DEFAULT_KRB5_PREFIX	"krb5cc"
> -#define CIFS_DEFAULT_KRB5_KEYTAB	"/etc/krb5.keytab"
>  
>  #define	MAX_CCNAME_LEN			PATH_MAX + 5
>  
> @@ -205,9 +204,15 @@ init_cc_from_keytab(const char *keytab_name, const char *user)
>  		goto icfk_cleanup;
>  	}
>  
> -	ret = krb5_kt_resolve(context, keytab_name, &keytab);
> +	if (keytab_name)
> +		ret = krb5_kt_resolve(context, keytab_name, &keytab);
> +	else
> +		ret = krb5_kt_default(context, &keytab);
> +
>  	if (ret) {
> -		syslog(LOG_DEBUG, "krb5_kt_resolve: %d", (int)ret);
> +		syslog(LOG_DEBUG, "%s: %d",
> +			keytab_name ? "krb5_kt_resolve" : "krb5_kt_default",
> +			(int)ret);
>  		goto icfk_cleanup;
>  	}
>  
> @@ -841,7 +846,7 @@ int main(const int argc, char *const argv[])
>  	struct decoded_args arg;
>  	const char *oid;
>  	uid_t uid;
> -	char *keytab_name = CIFS_DEFAULT_KRB5_KEYTAB;
> +	char *keytab_name = NULL;
>  	time_t best_time = 0;
>  
>  	hostbuf[0] = '\0';


Merged...
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

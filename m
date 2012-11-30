From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH 2/3] cifs: Make CIFS_DEBUG possible to undefine
Date: Fri, 30 Nov 2012 06:49:19 -0500
Message-ID: <20121130064919.373547f4@tlielax.poochiereds.net>
References: <cover.1354217746.git.joe@perches.com>
	<26f6f4e1a1fb5091784fb1a6919e214994a6dc88.1354217746.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <26f6f4e1a1fb5091784fb1a6919e214994a6dc88.1354217746.git.joe@perches.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 29 Nov 2012 11:37:19 -0800
Joe Perches <joe@perches.com> wrote:

> Make the compilation work again when CIFS_DEBUG is not #define'd.
> 
> Add format and argument verification for the various macros when
> CIFS_DEBUG is not #define'd.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/cifs/cifs_debug.h |   64 ++++++++++++++++++++++++++++++++------------------
>  1 files changed, 41 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
> index b0fc344..4d12fe4 100644
> --- a/fs/cifs/cifs_debug.h
> +++ b/fs/cifs/cifs_debug.h
> @@ -37,6 +37,9 @@ void dump_smb(void *, int);
>  #define CIFS_RC		0x02
>  #define CIFS_TIMER	0x04
>  
> +extern int cifsFYI;
> +extern int cifsERROR;
> +
>  /*
>   *	debug ON
>   *	--------
> @@ -44,36 +47,33 @@ void dump_smb(void *, int);
>  #ifdef CIFS_DEBUG
>  
>  /* information message: e.g., configuration, major event */
> -extern int cifsFYI;
> -#define cifsfyi(fmt, arg...)						\
> +#define cifsfyi(fmt, ...)						\
>  do {									\
>  	if (cifsFYI & CIFS_INFO)					\
> -		printk(KERN_DEBUG "%s: " fmt "\n", __FILE__, ##arg);	\
> +		printk(KERN_DEBUG "%s: " fmt "\n",			\
> +		       __FILE__, ##__VA_ARGS__);			\
>  } while (0)
>  
> -#define cFYI(set, fmt, arg...)			\
> -do {						\
> -	if (set)				\
> -		cifsfyi(fmt, ##arg);		\
> +#define cFYI(set, fmt, ...)						\
> +do {									\
> +	if (set)							\
> +		cifsfyi(fmt, ##__VA_ARGS__);				\
>  } while (0)
>  
> -#define cifswarn(fmt, arg...)			\
> -	printk(KERN_WARNING fmt "\n", ##arg)
> -
> -/* debug event message: */
> -extern int cifsERROR;
> +#define cifswarn(fmt, ...)						\
> +	printk(KERN_WARNING fmt "\n", ##__VA_ARGS__)
>  
>  /* error event message: e.g., i/o error */
> -#define cifserror(fmt, arg...)					\
> -do {								\
> -	if (cifsERROR)						\
> -		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##arg);	\
> +#define cifserror(fmt, ...)						\
> +do {									\
> +	if (cifsERROR)							\
> +		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
>  } while (0)
>  
> -#define cERROR(set, fmt, arg...)		\
> -do {						\
> -	if (set)				\
> -		cifserror(fmt, ##arg);		\
> +#define cERROR(set, fmt, ...)						\
> +do {									\
> +	if (set)							\
> +		cifserror(fmt, ##__VA_ARGS__);				\
>  } while (0)
>  
>  /*
> @@ -81,9 +81,27 @@ do {						\
>   *	---------
>   */
>  #else		/* _CIFS_DEBUG */
> -#define cERROR(set, fmt, arg...)
> -#define cFYI(set, fmt, arg...)
> -#define cifserror(fmt, arg...)
> +#define cifsfyi(fmt, ...)						\
> +do {									\
> +	if (0)								\
> +		printk(KERN_DEBUG "%s: " fmt "\n",			\
> +		       __FILE__, ##__VA_ARGS__);			\
> +} while (0)
> +#define cFYI(set, fmt, ...)						\
> +do {									\
> +	if (0 && set)							\
> +		cifsfyi(fmt, ##__VA_ARGS__);				\
> +} while (0)
> +#define cifserror(fmt, ...)						\
> +do {									\
> +	if (0)								\
> +		printk(KERN_ERR "CIFS VFS: " fmt "\n", ##__VA_ARGS__);	\
> +} while (0)
> +#define cERROR(set, fmt, ...)						\
> +do {									\
> +	if (0 && set)							\
> +		cifserror(fmt, ##__VA_ARGS__);				\
> +} while (0)

Would it be better to simply make those the standard

"do { ; } while(0)" noop macros?

I'm not sure I see the point in keeping the printk statements in there...

>  #endif		/* _CIFS_DEBUG */
>  
>  #endif				/* _H_CIFS_DEBUG */

-- 
Jeff Layton <jlayton@redhat.com>

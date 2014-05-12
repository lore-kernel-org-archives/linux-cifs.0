From: Alexander Bokovoy <ab-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v2] cifs: call print_hex_dump instead of custom
 implementation
Date: Mon, 12 May 2014 18:41:34 +0300
Message-ID: <20140512154134.GA2319@leiri.espoo.7ia.org>
References: <1399907720-18622-1-git-send-email-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399907720-18622-1-git-send-email-andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, May 12, 2014 at 06:15:20PM +0300, Andy Shevchenko wrote:
> This patch converts custom dumper to use native print_hex_dump() instead. The
> dump will have a given label and addresses per each line which differs it from
> the original code.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c | 21 ++-------------------
>  1 file changed, 2 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
> index fa78b68..e7b87ce 100644
> --- a/fs/cifs/cifs_debug.c
> +++ b/fs/cifs/cifs_debug.c
> @@ -34,27 +34,10 @@
>  void
>  cifs_dump_mem(char *label, void *data, int length)
>  {
> -	int i, j;
> -	int *intptr = data;
> -	char *charptr = data;
> -	char buf[10], line[80];
> -
>  	printk(KERN_DEBUG "%s: dump of %d bytes of data at 0x%p\n",
>  		label, length, data);
> -	for (i = 0; i < length; i += 16) {
> -		line[0] = 0;
> -		for (j = 0; (j < 4) && (i + j * 4 < length); j++) {
> -			sprintf(buf, " %08x", intptr[i / 4 + j]);
> -			strcat(line, buf);
> -		}
> -		buf[0] = ' ';
> -		buf[2] = 0;
> -		for (j = 0; (j < 16) && (i + j < length); j++) {
> -			buf[1] = isprint(charptr[i + j]) ? charptr[i + j] : '.';
> -			strcat(line, buf);
> -		}
> -		printk(KERN_DEBUG "%s\n", line);
> -	}
> +	print_hex_dump(KERN_DEBUG, label, DUMP_PREFIX_ADDRESS, 16, 4,
> +		       data, length, true);
>  }
>  
>  #ifdef CONFIG_CIFS_DEBUG
Looks good, thanks for this. You can add my Reviewed-By.

-- 
/ Alexander Bokovoy

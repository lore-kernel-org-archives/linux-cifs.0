From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v4 1/7] CIFS: Add safe access to is_valid_oplock and
 dump_detail ops struct field
Date: Wed, 6 Jun 2012 07:17:58 -0400
Message-ID: <20120606071758.554e48c3@corrin.poochiereds.net>
References: <1338468657-29742-1-git-send-email-pshilovsky@samba.org>
	<1338468657-29742-2-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338468657-29742-2-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 31 May 2012 16:50:50 +0400
Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
>  fs/cifs/connect.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccafded..3647b1a 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1058,13 +1058,15 @@ cifs_demultiplex_thread(void *p)
>  		if (mid_entry != NULL) {
>  			if (!mid_entry->multiRsp || mid_entry->multiEnd)
>  				mid_entry->callback(mid_entry);
> -		} else if (!server->ops->is_oplock_break(buf, server)) {
> +		} else if (!server->ops->is_oplock_break ||
> +			   !server->ops->is_oplock_break(buf, server)) {
>  			cERROR(1, "No task to wake, unknown frame received! "
>  				   "NumMids %d", atomic_read(&midCount));
>  			cifs_dump_mem("Received Data is: ", buf,
>  				      HEADER_SIZE(server));
>  #ifdef CONFIG_CIFS_DEBUG2
> -			server->ops->dump_detail(buf);
> +			if (server->ops->dump_detail)
> +				server->ops->dump_detail(buf);
>  			cifs_dump_mids(server);
>  #endif /* CIFS_DEBUG2 */
>  

Looks fine for now. Eventually you might want to make dump_detail
mandatory, in which case you could eliminate the second check.

Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

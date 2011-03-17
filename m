From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] wait_for_free_request needs to wait on credits returned
 by server for SMB2
Date: Thu, 17 Mar 2011 10:36:08 -0400
Message-ID: <20110317143608.GC3295@infradead.org>
References: <AANLkTimsJ+vQm7XuVk2NHneRc04CeWebuG3jsLxML4sd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimsJ+vQm7XuVk2NHneRc04CeWebuG3jsLxML4sd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

>  #ifdef CONFIG_CIFS_STATS2
>  			atomic_inc(&server->num_waiters);
> @@ -283,6 +284,20 @@ static int wait_for_free_request(struct
> TCP_Server_Info *server,
>  			atomic_dec(&server->num_waiters);
>  #endif
>  			spin_lock(&GlobalMid_Lock);
> +#ifdef CONFIG_CIFS_SMB2
> +		} else if (server->is_smb2 &&
> +			  (atomic_read(&server->credits) < 1)) {
> +			spin_unlock(&GlobalMid_Lock);
> +#ifdef CONFIG_CIFS_STATS2
> +			atomic_inc(&server->num_waiters);
> +#endif
> +			wait_event(server->request_q,
> +				   atomic_read(&server->credits) > 0);
> +#ifdef CONFIG_CIFS_STATS2
> +			atomic_dec(&server->num_waiters);
> +#endif
> +			spin_lock(&GlobalMid_Lock);
> +#endif /* CONFIG_CIFS_SMB2 */

This ifdef mania is madness.  Please make sure to hide the stats
and smb2 code in properly abstracted helpers that get compiled out if
not actually used.

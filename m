From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix oplock break handling
Date: Mon, 17 Jan 2011 11:19:30 -0500
Message-ID: <20110117111930.5ca9cc0e@tlielax.poochiereds.net>
References: <1295027561-24077-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295027561-24077-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 14 Jan 2011 20:52:41 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> When we get oplock break notification we should set the appropriate
> value of OplockLevel field in oplock break acknowledge according to
> the oplock level held by the client in this time. As we only can have
> level II oplock or no oplock in the case of oplock break, we should be
> aware only about clientCanCacheRead field in cifsInodeInfo structure.
> 
> Also fix bug connected with wrong interpretation of OplockLevel field
> during oplock break notification processing.
> 
> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

[...]

> @@ -2192,7 +2192,8 @@ void cifs_oplock_break(struct work_struct *work)
>  	 */
>  	if (!cfile->oplock_break_cancelled) {
>  		rc = CIFSSMBLock(0, tlink_tcon(cfile->tlink), cfile->netfid, 0,
> -				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false);
> +				 0, 0, 0, LOCKING_ANDX_OPLOCK_RELEASE, false,
> +				 cinode->clientCanCacheRead);

					^^^^^^^^^^^
				This looks wrong. clientCanCacheRead is
				a bool, but that parm is a __u8. That
				might get turned into "1" by most
				compilers, but I'd probably not count
				on that.

>  		cFYI(1, "Oplock release rc = %d", rc);
>  	}
>  


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

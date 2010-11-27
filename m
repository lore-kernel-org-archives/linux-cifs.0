From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Make cifsFileInfo_put work with strict cache mode
 (try #3)
Date: Sat, 27 Nov 2010 07:31:16 -0500
Message-ID: <20101127073116.20f3a064@tlielax.poochiereds.net>
References: <1290368618-12918-1-git-send-email-piastryyy@gmail.com>
	<AANLkTikhDHcSK2p6UJKtTS4rNq-bMWDarYd=PTHg-TUN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikhDHcSK2p6UJKtTS4rNq-bMWDarYd=PTHg-TUN-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 25 Nov 2010 13:51:29 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/21 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> > On strict cache mode when we close the last file handle of the inode we
> > should set invalid_mapping flag on this inode to prevent data coherency
> > problem when we open it again but it has been modified by other clients.
> >
> 
> What's about this patch and other strictcache mode related things?
> 

I'm not sure which ones need review at this point. Perhaps it would be
best to re-post the set? If you do, make sure to attach
Reviewed-by/Acked-by tags on patches that have already been reviewed.

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

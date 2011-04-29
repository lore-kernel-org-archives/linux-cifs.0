From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Add rwpidforward mount option
Date: Fri, 29 Apr 2011 10:22:13 -0400
Message-ID: <20110429102213.3c8bdb33@corrin.poochiereds.net>
References: <1303392395-9217-1-git-send-email-piastry@etersoft.ru>
	<1303392395-9217-2-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303392395-9217-2-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Apr 2011 17:26:35 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add rwpidforward mount option that switches on a mode when we forward
> pid of a process who opened a file to any read and write operation.
> 
> This can prevent applications like WINE from failing on read or write
> operation on a previously locked file region from the same netfd from
> another process if we use mandatory brlock style.
> It is actual for WINE because during a run of WINE program two processes
> work on the same netfd - share the same file struct between several VFS
> fds:
> 1) WINE-server does open and lock;
> 2) WINE-application does read and write.
> 

I guess I still don't quite get it. Why not always forward the pid
unconditionally?

For wine, you want to forward the pid in order to emulate windows
locking semantics. But always forwarding the pid seems like it would
give you more unix-like semantics when locking unix applications,
right? IOW, you'd be less likely to block in a read or write operation.

Can you give an example of some use case that would break if you were
to do this unconditionally?

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

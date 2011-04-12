From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add wine mount option (try #2)
Date: Tue, 12 Apr 2011 10:16:49 -0400
Message-ID: <20110412101649.0d760e94@corrin.poochiereds.net>
References: <1302435874-11073-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302435874-11073-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 10 Apr 2011 15:44:34 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Add wine mount option that switches on WINE-capability mode - forward
> pid of a process who opened a file to any read and write operation.
> 
> This can prevent WINE program from failing on read or write operation
> on a previously locked file region from the same file descriptor, because
> while a run of WINE program two processes work on the same file descriptor:
> 1) WINE-application does read and write on a file;
> 2) WINE-server does open and lock.
> 
> Also switch on strictcache and forcemand modes because WINE needs to work
> with mandatory brlocks and does read and write operations correctly with
> them.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

As a general rule, I'm not too fond of enshrining application behavior
into a mount option like this. What if wine changes their
implementation in the future?

Would it make more sense to have one mount option that enables this
new mode of PID handling, and keep forcemand and strictcache separate?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

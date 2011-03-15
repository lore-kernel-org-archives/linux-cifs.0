From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: directio read/write cleanups
Date: Tue, 15 Mar 2011 16:02:52 -0400
Message-ID: <20110315160252.1c6a6109@tlielax.poochiereds.net>
References: <1299751865-2741-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299751865-2741-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 10 Mar 2011 13:11:05 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Recently introduced strictcache mode brought a new code that can be
> efficiently used by directio part. That's let us add vectored operations
> and break unnecessary cifs_user_read and cifs_user_write.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   18 +++++----
>  fs/cifs/cifsfs.h |    8 ++--
>  fs/cifs/file.c   |  103 +----------------------------------------------------
>  3 files changed, 16 insertions(+), 113 deletions(-)
> 

Nice cleanup.

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

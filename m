From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/6] Prepare byte-range locking code for future SMB2
 usage
Date: Mon, 26 Mar 2012 14:48:47 -0400
Message-ID: <20120326144847.42719249@corrin.poochiereds.net>
References: <1331911072-1078-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331911072-1078-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 16 Mar 2012 18:17:46 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> This is one of the preparation step that makes the byte-range locking code more
> protocol independent.
> 

Ok, I sat down to review this set today, but found it very difficult to
do so. Most of these patches have little to no explanation or
justification at all. Terseness is not a virtue when it come to patch
descriptions:

> Pavel Shilovsky (6):
>   CIFS: Move locks to file structure
^^^
That's all that patch says. No explanation of *why* you're moving those
to the file structure -- whatever that is. Do you mean cifsFileInfo here?

>   CIFS: Fix VFS locks usage

This one says:

Surround VFS posix_lock_file_wait calls with CIFS lock_mutex
where it needs.

...so you're saying that the existing code is broken? Or is it only a
problem for SMB2 support? Does a fix need to go to stable?

>   CIFS: Convert lock type to 32 bit variable
>   CIFS: Separate protocol specific lock type handling
>   CIFS: Separate protocol specific part from getlk
>   CIFS: Separate protocol specific part from setlk
> 
>  fs/cifs/cifsfs.c   |    1 -
>  fs/cifs/cifsglob.h |    5 +-
>  fs/cifs/file.c     |  250 +++++++++++++++++++++++++++++++++++++---------------
>  3 files changed, 182 insertions(+), 74 deletions(-)
> 

Given that it's not clear to me what the goal of this patchset is, not
to mention the lack of any description on these patches, I can't
reasonably review this.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

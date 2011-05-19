From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Simplify invalidate part (try #5)
Date: Thu, 19 May 2011 14:01:32 -0400
Message-ID: <20110519140132.32850e2c@barsoom.rdu.redhat.com>
References: <1303565417-3653-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303565417-3653-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 23 Apr 2011 17:30:17 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Simplify many places when we call cifs_revalidate/invalidate to make
> it do what it exactly needs.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c |   33 +++++++++++-----
>  fs/cifs/cifsfs.h |    4 +-
>  fs/cifs/file.c   |   16 ++++++--
>  fs/cifs/inode.c  |  117 ++++++++++++++++++++++++++++++++++-------------------
>  4 files changed, 113 insertions(+), 57 deletions(-)
> 

This patch is causing a regression in tests5:

./test5: read and write
        ./test5: (/mnt/salusa/rawhide.test) 'bigfile' has size -2130066000, should be 1048576
basic tests failed

Pavel, can you track this down?

Steve, in the meantime I suggest that this patch not be pushed when
the merge window opens.
 
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: make cifs_ioctl handle NULL filp->private_data
 correctly
Date: Mon, 08 Nov 2010 18:14:55 +0530
Message-ID: <4CD7F0C7.1060005@suse.de>
References: <1289219312-21396-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kjella79-eZNTXLQAfP4@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289219312-21396-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 11/08/2010 05:58 PM, Jeff Layton wrote:
> Commit 13cfb7334e made cifs_ioctl use the tlink attached to the
> cifsFileInfo for a filp. This ignores the case of an open directory
> however, which in CIFS can have a NULL private_data until a readdir
> is done on it.
> 
> This patch re-adds the NULL pointer checks that were removed in commit
> 50ae28f01 and moves the setting of tcon and "caps" variables lower.
> 
> Long term, a better fix would be to establish a f_op->open routine for
> directories that populates that field at open time, but that requires
> some other changes to how readdir calls are handled.
> 
> Reported-by: Kjell Rune Skaaraas <kjella79-eZNTXLQAfP4@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/ioctl.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 

Looks correct to me and fixes the bug caused by my reproducer.
(BTW, the file should be open with O_RDONLY in the reproducer to trigger
the Oops)


Reviewed-and-Tested-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

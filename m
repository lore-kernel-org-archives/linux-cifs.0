From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 3/4] cifs: remove CIFSSMBQueryReparseLinkInfo and CONFIG_CIFS_EXPERIMENTAL
Date: Fri, 17 Dec 2010 20:59:11 +0530
Message-ID: <4D0B81C7.7080006@suse.de>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com> <1291820625-20907-4-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291820625-20907-4-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/08/2010 08:33 PM, Jeff Layton wrote:
> Nothing calls this function. Remove it.
> 
> With this, the last user of CONFIG_CIFS_EXPERIMENTAL has been
> removed. Also, update the README.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/Kconfig     |   13 ------
>  fs/cifs/README      |   12 ------
>  fs/cifs/cifsproto.h |    6 ---
>  fs/cifs/cifssmb.c   |  104 ---------------------------------------------------
>  4 files changed, 0 insertions(+), 135 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

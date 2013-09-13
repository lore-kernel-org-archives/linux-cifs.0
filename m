From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/2] Fix page unlocking in cifs_readpage()
Date: Fri, 13 Sep 2013 09:41:54 -0400
Message-ID: <20130913094154.24d67fe1@tlielax.poochiereds.net>
References: <1379077917-31017-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379077917-31017-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 13 Sep 2013 14:11:55 +0100
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> A set of 2 patches to fix a warning message generated when using
> fscache with cifs. The problem was first discovered when testing
> new fscache patches for cifs.
> 
> This is a repost of the original patch after taking into account
> suggestions from Jeff Layton and Steve French.
> 
> Sachin Prabhu (2):
>   cifs: Do not take a reference to the page in cifs_readpage_worker()
>   cifs: Avoid calling unlock_page() twice in cifs_readpage() when using
>     fscache
> 
>  fs/cifs/file.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 

Looks good. You can add this to the set if you like:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

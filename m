From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 4/4] cifs: replace /proc/fs/cifs/Experimental with a module
 parm
Date: Fri, 17 Dec 2010 21:02:45 +0530
Message-ID: <4D0B829D.2070005@suse.de>
References: <1291820625-20907-1-git-send-email-jlayton@redhat.com> <1291820625-20907-5-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291820625-20907-5-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/08/2010 08:33 PM, Jeff Layton wrote:
> This flag currently only affects whether we allow "zero-copy" writes
> with signing enabled. Typically we map pages in the pagecache directly
> into the write request. If signing is enabled however and the contents
> of the page change after the signature is calculated but before the
> write is sent then the signature will be wrong. Servers typically
> respond to this by closing down the socket.
> 
> Still, this can provide a performance benefit so the "Experimental" flag
> was overloaded to allow this. That's really not a good place for this
> option however since it's not clear what that flag does.
> 
> Move that flag instead to a new module parameter that better describes
> its purpose. That's also better since it can be set at module insertion
> time by configuring modprobe.d.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/README       |   16 ----------------
>  fs/cifs/cifs_debug.c |   43 -------------------------------------------
>  fs/cifs/cifsfs.c     |    6 ++++--
>  fs/cifs/cifsglob.h   |    2 +-
>  fs/cifs/file.c       |    4 ++--
>  5 files changed, 7 insertions(+), 64 deletions(-)
> 

Making it a module param sounds appropriate to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

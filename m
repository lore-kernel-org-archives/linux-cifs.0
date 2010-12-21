From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 10/18] cifs: allow for different handling of received
 response
Date: Tue, 21 Dec 2010 21:21:28 +0530
Message-ID: <4D10CD00.2020003@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-11-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-11-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> In order to incorporate async requests, we need to allow for a more
> general way to do things on receive, rather than just waking up a
> process.
> 
> Turn the task pointer in the mid_q_entry into a callback function and a
> generic data pointer. When a response comes in, or the socket is
> reconnected, cifsd can call the callback function in order to wake up
> the process.
> 
> The default is to just wake up the current process which should mean no
> change in behavior for existing code.
> 
> Also, clean up the locking in cifs_reconnect. There doesn't seem to be
> any need to hold both the srv_mutex and GlobalMid_Lock when walking the
> list of mids.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifs_debug.c |    8 +++---
>  fs/cifs/cifsglob.h   |   15 ++++++++++++-
>  fs/cifs/connect.c    |   56 +++++++++++++++++++++++++-------------------------
>  fs/cifs/transport.c  |   19 +++++++++++++++-
>  4 files changed, 63 insertions(+), 35 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

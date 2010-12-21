From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 07/18] cifs: wait indefinitely for responses
Date: Tue, 21 Dec 2010 21:20:47 +0530
Message-ID: <4D10CCD7.80807@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-8-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-8-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> The client should not be timing out on individual SMB requests. Too much
> of the state between client and server is tied to the state of the
> socket. If we time out requests and issue spurious disconnects then that
> comprimises data integrity.
> 
> Instead of doing this complicated dance where we try to decide how long
> to wait for a response for particular requests, have the client instead
> wait indefinitely for a response. Also, use a TASK_KILLABLE sleep here
> so that fatal signals will break out of this waiting.
> 
> Later patches will add support for detecting dead peers and forcing
> reconnects based on that.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c |  110 ++++++++-------------------------------------------
>  1 files changed, 17 insertions(+), 93 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

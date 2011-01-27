From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: don't always drop malformed replies on the
 floor
Date: Thu, 27 Jan 2011 08:04:24 -0500
Message-ID: <20110127080424.39356393@barsoom.rdu.redhat.com>
References: <1296132476-21948-1-git-send-email-jlayton@redhat.com>
	<1296132476-21948-2-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1296132476-21948-2-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 27 Jan 2011 07:47:56 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> After receiving a packet, we currently check the header. If it's no
> good, then we toss it out and continue the loop, leaving the caller
> waiting on that response. This is problematic now that the client waits
> indefinitely for responses.
> 
> Check first to see if the packet is big enough for us to read the Mid.
> If it's not, then discard it since we can't do anything with it anyway.
> 
> If it is big enough, then go ahead and do the checkSMB checks. Don't
> immediately discard the packet however if they fail. Instead, find the
> matching mid_q_entry, mark it as having a malformed response and issue
> the callback.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    2 +-
>  fs/cifs/connect.c   |   24 +++++++++++++++++++++---
>  fs/cifs/transport.c |    3 +++
>  3 files changed, 25 insertions(+), 4 deletions(-)
> 

Doh! Self-NAK on this patch. It occurs to me that we need to make sure
that checkSMB passes before we allow check2ndT2 to called for the
packet. I'll fix and resend the pair of patches -- sorry for the
noise...

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

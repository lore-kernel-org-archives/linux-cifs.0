From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] cifs: change DOS/NT/POSIX mapping of ERRnoresource
Date: Wed, 26 Sep 2012 10:38:58 +0530
Message-ID: <50628DEA.4040802@suse.com>
References: <1348493620-1887-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348493620-1887-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 09/24/2012 07:03 PM, Jeff Layton wrote:
> ERRnoresource is an ERRSRV level (aka server-side) error and means "No
> resources currently available for request". Currently that maps to POSIX
> -ENOBUFS. No NT errors map to it currently.
> 
> NT_STATUS_INSUFFICIENT_RESOURCES and NT_STATUS_INSUFF_SERVER_RESOURCES
> are also similar in meaning. Currently the client maps those to
> ERRnomem, which maps to -ENOMEM in POSIX.
> 
> All of these mappings seem to be quite wrong to me and are confusing for
> users. All of the above errors indicate problems on the server, not the
> client. Reporting -ENOMEM or -ENOBUFS implies that the client is running
> out of resources.
> 
> This patch changes those mappings. The NT_* errors are changed to map to
> the SRV level ERRnoresource. That error is in turn changed to return
> -EREMOTEIO which is the only POSIX error I could find that conveys that
> something went wrong on the server. While we're at it, change the SMB2
> equivalent error to return the same.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---

Seems reasonable to me.

Acked-by: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>

From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 15/18] cifs: reconnect unresponsive servers
Date: Thu, 06 Jan 2011 12:46:17 +0530
Message-ID: <4D256C41.8060507@suse.de>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com> <1293417006-6417-16-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-16-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/27/2010 08:00 AM, Jeff Layton wrote:
> If the server isn't responding to echoes, we don't want to leave tasks
> hung waiting for it to reply. At that point, we'll want to reconnect
> so that soft mounts can return an error to userspace quickly.
> 
> If the client hasn't received a reply after a specified number of echo
> intervals, assume that the transport is down and attempt to reconnect
> the socket.
> 
> The number of echo_intervals to wait before attempting to reconnect is
> tunable via a module parameter. Setting it to 0, means that the client
> will never attempt to reconnect. The default is 5.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |    5 +++++
>  fs/cifs/cifsglob.h |    3 +++
>  fs/cifs/connect.c  |   21 +++++++++++++++++----
>  3 files changed, 25 insertions(+), 4 deletions(-)

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

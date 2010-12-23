From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 16/18] cifs: remove code for setting timeouts on requests
Date: Thu, 23 Dec 2010 16:02:56 +0530
Message-ID: <4D132558.4070603@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-17-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-17-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> Since we don't time out individual requests anymore, remove the code
> that we used to use for setting timeouts on different requests.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h  |    9 +++------
>  fs/cifs/cifssmb.c   |    8 ++++----
>  fs/cifs/connect.c   |    2 +-
>  fs/cifs/file.c      |   44 +++++++-------------------------------------
>  fs/cifs/sess.c      |    2 +-
>  fs/cifs/transport.c |    2 +-
>  6 files changed, 17 insertions(+), 50 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

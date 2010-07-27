From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] cifs: fsc should not default to "on"
Date: Tue, 27 Jul 2010 19:10:54 +0530
Message-ID: <4C4EE1E6.3030200@suse.de>
References: <1280168708-2943-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280168708-2943-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 07/26/2010 11:55 PM, Jeff Layton wrote:
> I'm not sure why this was merged with this flag hardcoded on, but it
> seems quite dangerous. Turn it off.

Mea culpa.. I forgot to remove this during the second post.

> Also, mount.cifs hands unrecognized options off to the kernel so there
> should be no need for changes there in order to support this.

Yeah, it does not seem to require any handling - I had misunderstood.

> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)

Reviewed-and-Tested-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>


Thanks,

-- 
Suresh Jayaraman

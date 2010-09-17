From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken oplock handling
Date: Fri, 17 Sep 2010 09:42:46 -0400
Message-ID: <20100917094246.113ff95f@tlielax.poochiereds.net>
References: <4C936C8F.9050804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C936C8F.9050804-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 17 Sep 2010 18:56:39 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> cifs_new_fileinfo() does not use the 'oplock' value from the callers. Instead,
> it sets it to REQ_OPLOCK which seems wrong. We should be using the oplock value
> obtained from the Server to set the inode's clientCanCacheAll or
> clientCanCacheRead flags. Fix this by passing oplock from the callers to
> cifs_new_fileinfo().
> 
> This change dates back to commit a6ce4932 (2.6.30-rc3). So, all the affected
> versions will need this fix. Please Cc stable once reviewed and accepted.
> 
> Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

Looks correct to me:

Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 02/18] cifs: no need to mark smb_ses_list as cifs_demultiplex_thread
 is exiting
Date: Mon, 20 Dec 2010 16:22:55 +0530
Message-ID: <4D0F3587.7050906@suse.de>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com> <1292598497-29796-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 12/17/2010 08:38 PM, Jeff Layton wrote:
> The TCP_Server_Info is refcounted and every SMB session holds a
> reference to it. Thus, smb_ses_list is always going to be empty when
> cifsd is coming down. This is dead code.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/connect.c |   44 +++-----------------------------------------
>  1 files changed, 3 insertions(+), 41 deletions(-)
> 

Looks good to me.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>

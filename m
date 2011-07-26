From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v4 PATCH 0/5] Simplify demultiplex thread
Date: Tue, 26 Jul 2011 08:14:00 -0400
Message-ID: <20110726081400.6a7ed834@tlielax.poochiereds.net>
References: <1311519630-2500-1-git-send-email-piastryyy@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1311519630-2500-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, 24 Jul 2011 19:00:30 +0400
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> This patchset is going to make demultiplex code smaller and let us intergrate SMB2 protocol support easier further.
> 
> I successfully tested it with Connectathon Testsuites and two parallel mount/umount scripts.
> 
> This is the 4rd version of the patchset that includes minor changes for patch #1.
> 
> 
> Pavel Shilovsky (5):
>   CIFS: Move buffer allocation to a separate function
>   CIFS: Simplify socket reading in demultiplex thread
>   CIFS: Move RFC1002 check to a separate function
>   CIFS: Move mid search to a separate function
>   CIFS: Cleanup demupltiplex thread exiting code
> 
>  fs/cifs/connect.c |  653 ++++++++++++++++++++++++++++-------------------------
>  1 files changed, 346 insertions(+), 307 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

This patchset seems like a good start. It does have some warts...

 static int
+read_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg,
+		 struct kvec *iov, unsigned int to_read,
+		 unsigned int *ptotal_read, bool is_header_read)


...that is_header_read parm could probably be done away with by moving
the special handling into the caller. Making these routines more
general purpose would be preferable.

That said, it's still a good starting point for future cleanup, so I'm
inclined to ACK the set. I also ran it through some basic smoke testing
and didn't see any problems.

Reviewed-and-Tested-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

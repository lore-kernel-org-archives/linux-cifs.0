From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs: fix some bounds checking problems
Date: Wed, 27 Apr 2011 10:17:40 -0400
Message-ID: <20110427101740.32be5c28@corrin.poochiereds.net>
References: <1303819401-14789-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303819401-14789-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 26 Apr 2011 08:03:16 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> This patchset fixes a number of problems that David pointed out while
> reviewing some backports for RHEL. I think they're appropriate for
> 2.6.39 and probably the stable series as well.
> 
> Jeff Layton (5):
>   cifs: change bleft in decode_unicode_ssetup back to signed type
>   cifs: check for bytes_remaining going to zero in CIFS_SessSetup
>   cifs: sanitize length checking in coalesce_t2
>   cifs: refactor mid finding loop in cifs_demultiplex_thread
>   cifs: handle errors from coalesce_t2
> 
>  fs/cifs/connect.c |  117 +++++++++++++++++++++++++++++-----------------------
>  fs/cifs/sess.c    |   19 ++-------
>  2 files changed, 69 insertions(+), 67 deletions(-)
> 

Note too that some of this patchset has merge conflicts with the patch
to change the BCC to little-endian. I'll plan to respin that patch once
you let me know what you plan to do with this set.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 00/17] Preparations before SMB2 protocol support
Date: Mon, 12 Mar 2012 11:20:10 -0400
Message-ID: <20120312112010.1f5eb0ba@tlielax.poochiereds.net>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat,  3 Mar 2012 12:37:01 +0300
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> The goal of this patchset is to reorganize existing CIFS code to make it
> easily expandable when SMB2 specific code come into the tree. This let us
> avoid a code dublication and reduce the whole number of changes coming
> with SMB2 code.
> 
> Pavel Shilovsky (17):
>   CIFS: Simplify inFlight logic
>   CIFS: Introduce credit-based flow control
>   CIFS: Count blocking lock command
>   CIFS: Delete echo_retries module parm
>   CIFS: Make wait_for_free_request killable
>   CIFS: Respect MaxMpxCount field
>   CIFS: Separate protocol-specific code from transport routines
>   CIFS: Separate protocol-specific code from demultiplex code
>   CIFS: Separate protocol-specific code from cifs_readv_receive code
>   CIFS: Expand CurrentMid field
>   CIFS: Change mid_q_entry structure fields

nit: It seems like the above patches ought to be one set and the lower
patches ought to be another. No objection to merging them both in 3.3,
however but it's generally easier to get small sets merged than bigger
ones.

>   CIFS: Move locks to file structure
>   CIFS: Fix VFS locks usage
>   CIFS: Convert lock type to 32 bit variable
>   CIFS: Separate protocol specific lock type handling
>   CIFS: Separate protocol specific part from getlk
>   CIFS: Separate protocol specific part from setlk
> 
>  fs/cifs/README       |    6 +-
>  fs/cifs/cifs_debug.c |   28 ++--
>  fs/cifs/cifs_debug.h |    4 +-
>  fs/cifs/cifsfs.c     |   18 ---
>  fs/cifs/cifsglob.h   |   98 +++++++++++----
>  fs/cifs/cifsproto.h  |   18 ++-
>  fs/cifs/cifssmb.c    |  107 ++++++++++-------
>  fs/cifs/connect.c    |  123 +++++++++----------
>  fs/cifs/dir.c        |    5 +-
>  fs/cifs/file.c       |  254 ++++++++++++++++++++++++++++-----------
>  fs/cifs/misc.c       |  152 +++++++++++++++++-------
>  fs/cifs/netmisc.c    |    3 +-
>  fs/cifs/transport.c  |  327 +++++++++++++++++++++++++++++---------------------
>  13 files changed, 702 insertions(+), 441 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I like this set overall, but we obviously have some unanswered
questions about SMB1 behavior.

Here's what I'd suggest for 3.3:

Let's plan to take this patchset or something very similar to it, but
do it in such a way that we do substantially alter the SMB1 behavior
yet. IOW, integrate the existing behavior of the SMB1 code into this
patchset.

You should be fine to change the echo behavior and get rid of
echo_retries. What we don't want to change yet is the behavior of
blocking locks, oplock breaks, etc...

Once we have a clearer picture of how we want the SMB1 code to behave,
we can then do a (hopefully small) set of patches to change the SMB1
behavior for the better.

Does that sound reasonable?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

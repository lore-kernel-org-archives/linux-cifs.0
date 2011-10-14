From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [v3 PATCH 0/6] Implement byte-range lock caching
Date: Fri, 14 Oct 2011 07:05:06 -0400
Message-ID: <20111014070506.10f0a0b7@tlielax.poochiereds.net>
References: <1318016059-29306-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1318016059-29306-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri,  7 Oct 2011 23:34:13 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> This patchset is going to simplify brlocking code and add the caching support for exclusive oplock cases. I splitted it into several independent parts - so, each can be applied separately once it's reviewed.
> 
> This version of the patchset includes some code style improvements in patch #3.
> 
> Any comments and testing are welcome!
> 

The above description is a bit vague. Is this just a generic cleanup of
the code, or does it represent any behavioral changes?

> Pavel Shilovsky (6):
>   CIFS: Simplify byte range locking code
>   CIFS: Move byte range lock list from fd to inode
>   CIFS: Implement caching mechanism for mandatory brlocks
>   CIFS: Implement caching mechanism for posix brlocks
>   CIFS: Send as many mandatory unlock ranges at once as possible
>   CIFS: Make cifs_push_locks send as many locks at once as possible
> 
>  fs/cifs/cifsfs.c    |    3 +-
>  fs/cifs/cifsglob.h  |   10 +-
>  fs/cifs/cifsproto.h |    9 +-
>  fs/cifs/cifssmb.c   |   52 +++-
>  fs/cifs/file.c      |  767 ++++++++++++++++++++++++++++++++++++++++-----------
>  5 files changed, 661 insertions(+), 180 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

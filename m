From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [v3 PATCH 0/6] Implement byte-range lock caching
Date: Fri, 21 Oct 2011 14:14:12 -0400
Message-ID: <20111021141412.54bae877@corrin.poochiereds.net>
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

I decided to test this out today. With posix extensions enabled, it
works fine. When I test with posix extensions disabled though,
connectathon lock test 7 is hanging after step 7.2.

The regression is fortunately in the portion that hasn't been merged
yet. Pavel, let me know if you need info on how to test that. I don't
think we can merge the rest of these until that regression is fixed.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

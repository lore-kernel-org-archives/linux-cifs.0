From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: don't allow mmap'ed pages to be dirtied while
 under writeback
Date: Sun, 27 Mar 2011 07:32:04 -0400
Message-ID: <20110327073204.3e85ad65@tlielax.poochiereds.net>
References: <1300302931-13830-1-git-send-email-jlayton@redhat.com>
	<1300302931-13830-3-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300302931-13830-3-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Mar 2011 15:15:31 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> If a process has a dirty page mapped into its page tables, then it has
> the ability to change it while the client is trying to write the data
> out to the server. If that happens after the signature has been
> calculated then that signature will then be wrong, and the server will
> likely reset the TCP connection.
> 
> This patch adds a page_mkwrite handler for CIFS that simply takes the
> page lock. Because the page lock is held over the life of writepage and
> writepages, this prevents the page from becoming writeable until
> the write call has completed.
> 
> With this, we can also remove the "sign_zero_copy" module option and
> always inline the pages when writing.
> 
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c   |    4 ---
>  fs/cifs/cifsglob.h |    1 -
>  fs/cifs/file.c     |   62 ++++++++++++++++++++++++++--------------------------
>  3 files changed, 31 insertions(+), 36 deletions(-)
> 

Steve, can you let me know where we are with this patch? It's not
merged and you haven't commented on it.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

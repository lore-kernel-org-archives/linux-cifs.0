From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #15)
Date: Mon, 18 Apr 2011 09:19:21 -0400
Message-ID: <20110418091921.57416e5f@corrin.poochiereds.net>
References: <1302750991-18515-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1302750991-18515-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Apr 2011 22:16:31 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> rb tree search and insertion routines.
> 
> A SID which needs to be mapped, is looked up in one of the rb trees
> depending whether SID is either owner or group SID.
> If found in the tree, a (mapped) id from that node is assigned to
> uid or gid as appropriate.  If unmapped, an upcall is attempted to
> map the SID to an id.  If upcall is successful, node is marked as
> mapped.  If upcall fails, node stays marked as unmapped and a mapping
> is attempted again only after an arbitrary time period has passed.
> 
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID converted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
> 
> Nodes in rb tree have fields to prevent multiple upcalls for
> a SID.  Adding and removing nodes is done within global locks.
> shrinker routine does not prune a node if mapping for that node
> is either pending or or node was recently created (before timeout
> period expires and node could be purged). The timeout period should
> be long enough at least for an upcall to return back to cifs.
> Every time an existing node is accessed, its timestamp is updated
> to prevent it from getting erased.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID (string) for an id.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |  308 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/cifsacl.h |   24 ++++
>  2 files changed, 308 insertions(+), 24 deletions(-)
> 

[...]

> +#define SID_ID_MAPPED 0
> +#define SID_ID_PENDING 1
> +#define SID_MAP_EXPIRE 1000 /* enough for an upcall to return? */
> +#define SID_MAP_RETRY 1000  /* wait for next attempt to map sid */
> +


Now that I look...

Is this enough time to ensure that this entry won't disappear from the
cache? I can forsee an upcall that takes longer than 1s to return.
That could also be quite problematic if that upcall returns and the
shrinker has pruned this entry out of the cache.

Perhaps it would be better to refcount these objects rather than
assuming that any time period is long enough to prevent their removal?

Also, shouldn't these values be based on HZ too? You're making an
assumption about the jiffies per second here, right?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

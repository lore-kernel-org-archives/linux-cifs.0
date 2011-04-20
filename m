From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #16)
Date: Wed, 20 Apr 2011 13:07:52 -0400
Message-ID: <20110420130752.06d6397d@corrin.poochiereds.net>
References: <1303219269-31144-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303219269-31144-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 19 Apr 2011 08:21:09 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
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
> Shrinker routine prunes a node if it has expired but does not prne
> an expired node if its refcount is not zero (i.e. sid of that node
> is being mapped via an upcall).
> Every time an existing node is accessed, its timestamp is updated
> to prevent it from getting erased.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID for an id.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |  332 +++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/cifsacl.h |   25 ++++
>  2 files changed, 333 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index cad8d9b..bbc29b8 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c

[...]

> +	/*
> +	 * Shrinker could be accessing this entry but it will not
> +	 * get erased at this point in time and to make it stay further,
> +	 * pretty soon we will take a reference on it only to
> +	 * release the reference only after upcall returns (or we are
> +	 * woken up), however longer that upcall may take to return.
> +	 */
> +	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
> +		/* paidid and its fields are being accessed sans spinlock */
> +		++psidid->refcount;
		^^^
		Huh? You're incrementing and decrementing the
		refcount without any locking at all? What prevents the
		shrinker from finding the entry just before you bump
		the refcount and wiping it out anyway?

> +struct cifs_sid_id {
> +	unsigned int refcount;
> +	unsigned long id;
> +	unsigned long time;
> +	unsigned long retry;

Why, exactly do we need "time" and "retry"? Wouldn't one timestamp
field do here?

> +	unsigned long state;
> +	char *sidstr;
> +	struct rb_node rbnode;
> +	struct cifs_sid sid;
> +};
> +

-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #11)
Date: Tue, 29 Mar 2011 09:30:15 -0400
Message-ID: <20110329093015.315caf36@tlielax.poochiereds.net>
References: <1301343901-28531-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301343901-28531-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 28 Mar 2011 15:25:01 -0500
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
> is attempted again during next resolution.
> 
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID converted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
> 
> Nodes in rb tree as fields to prevent multiple upcalls for
> a SID.  Adding and removing nodes is done within global locks.
> shrinker routine does not prune a node if mapping for that node
> is either pending or or node was recently created (before timeout
> period expires and node could be purged). The timeout period should
> be long enough at least for an upcall to return back to cifs.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID (string) for an id.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |  298 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/cifs/cifsacl.h |   22 ++++
>  2 files changed, 296 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index c60bb90..5b2ef73 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -54,7 +54,30 @@ static const struct cifs_sid sid_authusers = {
>  /* group users */
>  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
>  
> -static const struct cred *root_cred;
> +const struct cred *root_cred;
> +
> +static void
> +shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
> +			int *nr_del)
> +{
> +	struct rb_node *node;
> +	struct rb_node *tmp;
> +	struct cifs_sid_id *psidid;
> +
> +	node = rb_first(root);
> +	while (node) {
> +		tmp = node;
> +		node = rb_next(tmp);
> +		psidid = rb_entry(tmp, struct cifs_sid_id, rbnode);
> +		if (time_after(psidid->time + SID_MAP_EXPIRE, jiffies) ||
> +				(nr_to_scan == 0) || (*nr_del == nr_to_scan))
> +			++(*nr_rem);
> +		else {
> +			rb_erase(tmp, root);
> +			++(*nr_del);
> +		}
> +	}
> +}
>  
>  /*
>   * Run idmap cache shrinker.
> @@ -62,9 +85,21 @@ static const struct cred *root_cred;
>  static int
>  cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
>  {
> -	/* Use a pruning scheme in a subsequent patch instead */
> -	cifs_destroy_idmaptrees();
> -	return 0;
> +	int nr_del = 0;
> +	int nr_rem = 0;
> +	struct rb_root *root;
> +
> +	root = &uidtree;
> +	spin_lock(&siduidlock);
> +	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> +	spin_unlock(&siduidlock);
> +
> +	root = &gidtree;
> +	spin_lock(&sidgidlock);
> +	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> +	spin_unlock(&sidgidlock);
> +
> +	return nr_rem;
>  }
>  
>  static struct shrinker cifs_shrinker = {
> @@ -92,7 +127,6 @@ cifs_idmap_key_destroy(struct key *key)
>  	kfree(key->payload.data);
>  }
>  
> -static
>  struct key_type cifs_idmap_key_type = {
>  	.name        = "cifs.cifs_idmap",
>  	.instantiate = cifs_idmap_key_instantiate,
> @@ -101,6 +135,196 @@ struct key_type cifs_idmap_key_type = {
>  	.match       = user_match,
>  };
>  
> +static void
> +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
> +		struct cifs_sid_id **psidid)
> +{
> +	int rc;
> +	struct rb_node *node = root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rb_node **linkto = &(root->rb_node);
> +	struct cifs_sid_id *lsidid;
> +
> +	while (node) {
> +		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
> +		parent = node;
> +		rc = compare_sids(sidptr, &((lsidid)->sid));
> +		if (rc > 0) {
> +			linkto = &(node->rb_left);
> +			node = node->rb_left;
> +		} else if (rc < 0) {
> +			linkto = &(node->rb_right);
> +			node = node->rb_right;
> +		}
> +	}
> +
> +	memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
> +	clear_bit(SID_ID_PENDING, &(*psidid)->state);
> +	clear_bit(SID_ID_MAPPED, &(*psidid)->state);
> +
> +	rb_link_node(&(*psidid)->rbnode, parent, linkto);
> +	rb_insert_color(&(*psidid)->rbnode, root);
> +}
> +
> +static struct cifs_sid_id *
> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
> +{
> +	int rc;
> +	struct rb_node *node = root->rb_node;
> +	struct rb_node *parent = NULL;
> +	struct rb_node **linkto = &(root->rb_node);
> +	struct cifs_sid_id *lsidid;
> +
> +	while (node) {
> +		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
> +		parent = node;
> +		rc = compare_sids(sidptr, &((lsidid)->sid));
> +		if (rc > 0) {
> +			linkto = &(node->rb_left);
> +			node = node->rb_left;
> +		} else if (rc < 0) {
> +			linkto = &(node->rb_right);
> +			node = node->rb_right;
> +		} else /* node found */
> +			return lsidid;
> +	}
> +
> +	return NULL;
> +}
> +
> +static void
> +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
> +{
> +	int i;
> +	unsigned long saval;
> +	char *strptr;
> +
> +	strptr = sidstr;
> +
> +	sprintf(strptr, "%s", "S");
> +	strptr = sidstr + strlen(sidstr);
> +
> +	sprintf(strptr, "-%d", sidptr->revision);
> +	strptr = sidstr + strlen(sidstr);
> +
> +	for (i = 0; i < 6; ++i) {
> +		if (sidptr->authority[i]) {
> +			sprintf(strptr, "-%d", sidptr->authority[i]);
> +			strptr = sidstr + strlen(sidstr);
> +		}
> +	}
> +
> +	for (i = 0; i < sidptr->num_subauth; ++i) {
> +		saval = le32_to_cpu(sidptr->sub_auth[i]);
> +		sprintf(strptr, "-%ld", saval);
> +		strptr = sidstr + strlen(sidstr);
> +	}
> +}
> +
> +static int
> +sidid_pending_wait(void *unused)
> +{
> +	schedule();
> +	return signal_pending(current) ? -ERESTARTSYS : 0;
> +}
> +
> +static int
> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> +		struct cifs_fattr *fattr, uint sidtype)
> +{
> +	int rc;
> +	unsigned long cid;
> +	char *strptr;
> +	struct key *idkey;
> +	const struct cred *saved_cred;
> +	struct cifs_sid_id *psidid, *npsidid;
> +	struct rb_root *cidtree;
> +	spinlock_t *cidlock;
> +
> +	if (sidtype == SIDOWNER) {
> +		cid = cifs_sb->mnt_uid; /* default uid, in case upcall fails */
> +		cidlock = &siduidlock;
> +		cidtree = &uidtree;
> +	} else if (sidtype == SIDGROUP) {
> +		cid = cifs_sb->mnt_gid; /* default gid, in case upcall fails */
> +		cidlock = &sidgidlock;
> +		cidtree = &gidtree;
> +	} else
> +		return -ENOENT;
> +
> +	spin_lock(cidlock);
> +	psidid = id_rb_search(cidtree, psid);
> +	spin_unlock(cidlock);
> +
> +	if (!psidid) { /* node does not exist, allocate one & attempt adding */
> +		npsidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
> +		if (!npsidid)
> +			return -ENOMEM;
> +
> +		spin_lock(cidlock);
> +		psidid = id_rb_search(cidtree, psid);
> +		if (psidid) { /* node happened to get inserted meanwhile */
> +			spin_unlock(cidlock);
> +			kfree(npsidid);
> +		} else {
> +			psidid = npsidid;
> +			id_rb_insert(cidtree, psid, &psidid);
> +			spin_unlock(cidlock);
> +		}
> +	}
> +
> +	if (!test_bit(SID_ID_MAPPED, &psidid->state)) { /* SID not mapped */

	^^^ nit: maybe just do:

	if (test_bit(SID_ID_MAPPED...
		goto out;

	...or something. That would allow you to reduce the indentation
	of the code below and make it easier to read.

> +		if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
> +			memset(psidid->sidstr, '\0', SIDLEN);
> +			if (sidtype == SIDOWNER)
> +				sprintf(psidid->sidstr, "%s", "os:");
> +			else
> +				sprintf(psidid->sidstr, "%s", "gs:");
> +
> +			strptr = psidid->sidstr + strlen(psidid->sidstr);
> +			sid_to_str(psid, strptr);
> +

Would it be better to do the string handling above before you insert
this struct into the tree? In the case where this thing can't be mapped,
then you're going to have to re-convert the sid on every pass through
this function. Just doing that once would make more sense, IMO...

I wonder too...once this thing is mapped, then the above string will
never be used again, will it? If so, would it be best to release that
memory instead of keeping it around in the cache?

> +			saved_cred = override_creds(root_cred);
> +			idkey = request_key(&cifs_idmap_key_type,
> +						psidid->sidstr, "");
> +			if (IS_ERR(idkey)) {
> +				psidid->id = cid;
> +				cFYI(1, "%s: Can't map SID to an id", __func__);
> +			} else {
> +				psidid->id =
> +					*(unsigned long *)idkey->payload.value;
> +				psidid->time = jiffies;
> +				set_bit(SID_ID_MAPPED, &psidid->state);
> +				key_put(idkey);
> +			}
> +			revert_creds(saved_cred);
> +			clear_bit(SID_ID_PENDING, &psidid->state);
> +			wake_up_bit(&psidid->state, SID_ID_PENDING);
> +		} else {
> +			/*
> +			 * either an existing node with SID mapped (in which
> +			 * case we would not wait) or a node whose SID is
> +			 * being mapped by somebody else (in which case, we
> +			 * would end up waiting).
> +			 */
> +			rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
> +					sidid_pending_wait, TASK_INTERRUPTIBLE);
> +			if (rc) {
> +				cFYI(1, "%s: sidid_pending_wait interrupted %d",
> +					__func__, rc);
> +				return rc;
> +			}
> +		}
> +	}
> +
> +	if (sidtype == SIDOWNER)
> +		fattr->cf_uid = psidid->id;
> +	else
> +		fattr->cf_gid = psidid->id;
> +
> +	return 0;
> +}
> +

So let's consider the case where we have a directory with a lot of
files in it that are owned by a user that can't be mapped. Someone does
a "ls -l" in that dir.

Presumably, on every stat() call we'll call into this routine to map
the SID to a unix uid. The MAPPED bit will never be set though, so
we'll always call request_key().

cifs.upcall will generally negatively instantiate the key with a 1s
timeout. I think if request-key doesn't find a match (indicating that
no one set up request-key.conf) then it negatively instantiates the key
with a 60s timeout.

Is that reasonable behavior here?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

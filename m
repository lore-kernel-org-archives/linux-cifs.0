From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #17)
Date: Fri, 22 Apr 2011 07:43:30 -0400
Message-ID: <20110422074330.75236825@tlielax.poochiereds.net>
References: <1303395351-26687-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303395351-26687-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 21 Apr 2011 09:15:51 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> rb tree search and insertion routines.
> 
> A SID which needs to be mapped, is looked up in one of the rb trees
> depending on whether SID is either owner or group SID.
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
> a SID.  Searching, adding, and removing nodes is done within global locks.
> Whenever a node is either found or inserted in a tree, a reference
> is taken on that node.
> Shrinker routine prunes a node if it has expired but does not prune
> an expired node if its refcount is not zero (i.e. sid/id of that node
> is_being/will_be accessed).
> Thus a node, if its SID needs to be mapped by making an upcall,
> can safely stay and its fields accessed without shrinker pruning it.
> 
> Every time an existing mapped node is accessed or mapping is attempted,
> its timestamp is updated to prevent it from getting erased or a 
> to prevent multiple unnecessary repeat mapping retries respectively.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID for an id.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  fs/cifs/cifsacl.c |  321 +++++++++++++++++++++++++++++++++++++++++++++++++----
>  fs/cifs/cifsacl.h |   24 ++++
>  2 files changed, 321 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 061fc3a..b01921f 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -54,7 +54,33 @@ static const struct cifs_sid sid_authusers = {
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
> +		if (nr_to_scan == 0 || *nr_del == nr_to_scan)
> +			++(*nr_rem);
> +		else {
> +			if (time_after(jiffies, psidid->time + SID_MAP_EXPIRE)
> +						&& psidid->refcount == 0) {
> +				rb_erase(tmp, root);
> +				++(*nr_del);
> +			} else
> +				++(*nr_rem);
> +		}
> +	}
> +}
>  
>  /*
>   * Run idmap cache shrinker.
> @@ -62,9 +88,21 @@ static const struct cred *root_cred;
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
> @@ -92,7 +130,6 @@ cifs_idmap_key_destroy(struct key *key)
>  	kfree(key->payload.data);
>  }
>  
> -static
>  struct key_type cifs_idmap_key_type = {
>  	.name        = "cifs.cifs_idmap",
>  	.instantiate = cifs_idmap_key_instantiate,
> @@ -101,6 +138,216 @@ struct key_type cifs_idmap_key_type = {
>  	.match       = user_match,
>  };
>  
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
> +static void
> +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
> +		struct cifs_sid_id **psidid, char *typestr)
> +{
> +	int rc;
> +	char *strptr;
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
> +	(*psidid)->time = jiffies - (SID_MAP_RETRY + 1);
> +	(*psidid)->refcount = 0;
	^^^^^^^^^^^^
	nit: if you initialize the refcount to 1, then you won't need
	to increment it after insertion into the tree.
> +
> +	sprintf((*psidid)->sidstr, "%s", typestr);
> +	strptr = (*psidid)->sidstr + strlen((*psidid)->sidstr);
> +	sid_to_str(&(*psidid)->sid, strptr);
> +
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
> +
> +	if (!psidid) { /* node does not exist, allocate one & attempt adding */
> +		spin_unlock(cidlock);
> +		npsidid = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
> +		if (!npsidid)
> +			return -ENOMEM;
> +
> +		npsidid->sidstr = kmalloc(SIDLEN, GFP_KERNEL);
> +		if (!npsidid->sidstr) {
> +			kfree(npsidid);
> +			return -ENOMEM;
> +		}
> +
> +		spin_lock(cidlock);
> +		psidid = id_rb_search(cidtree, psid);
> +		if (psidid) { /* node happened to get inserted meanwhile */
> +			++psidid->refcount;
> +			spin_unlock(cidlock);
> +			kfree(npsidid->sidstr);
> +			kfree(npsidid);
> +		} else {
> +			psidid = npsidid;
> +			id_rb_insert(cidtree, psid, &psidid,
> +					sidtype == SIDOWNER ? "os:" : "gs:");
> +			++psidid->refcount;
> +			spin_unlock(cidlock);
> +		}
> +	} else {
> +		++psidid->refcount;
> +		spin_unlock(cidlock);
> +	}
> +
> +	/*
> +	 * If we are here, it is safe to access psidid and its fields
> +	 * since a reference was taken earlier while holding the spinlock.
> +	 */
> +	if (test_bit(SID_ID_MAPPED, &psidid->state)) {
> +		cid = psidid->id;
> +		psidid->time = jiffies; /* update ts for accessing */
> +		goto sid_to_id_out;
> +	}
> +
> +	if (time_after(psidid->time + SID_MAP_RETRY, jiffies))
> +		goto sid_to_id_out;
> +
> +	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
> +		saved_cred = override_creds(root_cred);
> +		idkey = request_key(&cifs_idmap_key_type, psidid->sidstr, "");
> +		if (IS_ERR(idkey))
> +			cFYI(1, "%s: Can't map SID to an id", __func__);
> +		else {
> +			cid = *(unsigned long *)idkey->payload.value;
> +			psidid->id = cid;
> +			set_bit(SID_ID_MAPPED, &psidid->state);
> +			key_put(idkey);
> +			kfree(psidid->sidstr);
> +		}
> +		revert_creds(saved_cred);
> +		psidid->time = jiffies; /* update ts for accessing */
		^^^^^^^
		Note that here you're setting the timestamp after the
		(possible) upcall. Is that what you want? That means
		that your next retry attempt will be SID_MAP_RETRY
		jiffies after this call returned, not after it was
		initiated. If the upcall takes a long time to return
		then you may end up delaying retries for quite some time.


> +		clear_bit(SID_ID_PENDING, &psidid->state);
> +		wake_up_bit(&psidid->state, SID_ID_PENDING);
> +	} else {
> +		rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
> +				sidid_pending_wait, TASK_INTERRUPTIBLE);
> +		if (rc) {
> +			cFYI(1, "%s: sidid_pending_wait interrupted %d",
> +					__func__, rc);
> +			--psidid->refcount;

			^^^^^^^^^^^^
			So you're incrementing the refcount while
			holding a lock, but decrementing it without
			one. That's a rather odd set of locking rules.
			If it is safe to do it this way, it deserves a
			comment explaining why (maybe somewhere near
			the field declaration).

> +			return rc;
> +		}
> +		if (test_bit(SID_ID_MAPPED, &psidid->state))
> +			cid = psidid->id;
> +	}
> +
> +sid_to_id_out:
> +	--psidid->refcount;
> +	if (sidtype == SIDOWNER)
> +		fattr->cf_uid = cid;
> +	else
> +		fattr->cf_gid = cid;
> +
> +	return 0;
> +}
> +
>  int
>  init_cifs_idmap(void)
>  {
> @@ -242,16 +489,24 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
>  	int num_subauth, num_sat, num_saw;
>  
>  	if ((!ctsid) || (!cwsid))
> -		return 0;
> +		return 1;
>  
>  	/* compare the revision */
> -	if (ctsid->revision != cwsid->revision)
> -		return 0;
> +	if (ctsid->revision != cwsid->revision) {
> +		if (ctsid->revision > cwsid->revision)
> +			return 1;
> +		else
> +			return -1;
> +	}
>  
>  	/* compare all of the six auth values */
>  	for (i = 0; i < 6; ++i) {
> -		if (ctsid->authority[i] != cwsid->authority[i])
> -			return 0;
> +		if (ctsid->authority[i] != cwsid->authority[i]) {
> +			if (ctsid->authority[i] > cwsid->authority[i])
> +				return 1;
> +			else
> +				return -1;
> +		}
>  	}
>  
>  	/* compare all of the subauth values if any */
> @@ -260,12 +515,16 @@ int compare_sids(const struct cifs_sid *ctsid, const struct cifs_sid *cwsid)
>  	num_subauth = num_sat < num_saw ? num_sat : num_saw;
>  	if (num_subauth) {
>  		for (i = 0; i < num_subauth; ++i) {
> -			if (ctsid->sub_auth[i] != cwsid->sub_auth[i])
> -				return 0;
> +			if (ctsid->sub_auth[i] != cwsid->sub_auth[i]) {
> +				if (ctsid->sub_auth[i] > cwsid->sub_auth[i])
> +					return 1;
> +				else
> +					return -1;
> +			}
>  		}
>  	}
>  
> -	return 1; /* sids compare/match */
> +	return 0; /* sids compare/match */
>  }
>  
>  
> @@ -520,22 +779,22 @@ static void parse_dacl(struct cifs_acl *pdacl, char *end_of_acl,
>  #ifdef CONFIG_CIFS_DEBUG2
>  			dump_ace(ppace[i], end_of_acl);
>  #endif
> -			if (compare_sids(&(ppace[i]->sid), pownersid))
> +			if (compare_sids(&(ppace[i]->sid), pownersid) == 0)
>  				access_flags_to_mode(ppace[i]->access_req,
>  						     ppace[i]->type,
>  						     &fattr->cf_mode,
>  						     &user_mask);
> -			if (compare_sids(&(ppace[i]->sid), pgrpsid))
> +			if (compare_sids(&(ppace[i]->sid), pgrpsid) == 0)
>  				access_flags_to_mode(ppace[i]->access_req,
>  						     ppace[i]->type,
>  						     &fattr->cf_mode,
>  						     &group_mask);
> -			if (compare_sids(&(ppace[i]->sid), &sid_everyone))
> +			if (compare_sids(&(ppace[i]->sid), &sid_everyone) == 0)
>  				access_flags_to_mode(ppace[i]->access_req,
>  						     ppace[i]->type,
>  						     &fattr->cf_mode,
>  						     &other_mask);
> -			if (compare_sids(&(ppace[i]->sid), &sid_authusers))
> +			if (compare_sids(&(ppace[i]->sid), &sid_authusers) == 0)
>  				access_flags_to_mode(ppace[i]->access_req,
>  						     ppace[i]->type,
>  						     &fattr->cf_mode,
> @@ -613,10 +872,10 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
>  
>  
>  /* Convert CIFS ACL to POSIX form */
> -static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
> -			  struct cifs_fattr *fattr)
> +static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
> +		struct cifs_ntsd *pntsd, int acl_len, struct cifs_fattr *fattr)
>  {
> -	int rc;
> +	int rc = 0;
>  	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
>  	struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
>  	char *end_of_acl = ((char *)pntsd) + acl_len;
> @@ -638,12 +897,26 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
>  		 le32_to_cpu(pntsd->sacloffset), dacloffset);
>  /*	cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
>  	rc = parse_sid(owner_sid_ptr, end_of_acl);
> -	if (rc)
> +	if (rc) {
> +		cFYI(1, "%s: Error %d parsing Owner SID", __func__, rc);
>  		return rc;
> +	}
> +	rc = sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
> +	if (rc) {
> +		cFYI(1, "%s: Error %d mapping Owner SID to uid", __func__, rc);
> +		return rc;
> +	}
>  
>  	rc = parse_sid(group_sid_ptr, end_of_acl);
> -	if (rc)
> +	if (rc) {
> +		cFYI(1, "%s: Error %d mapping Owner SID to gid", __func__, rc);
>  		return rc;
> +	}
> +	rc = sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
> +	if (rc) {
> +		cFYI(1, "%s: Error %d mapping Group SID to gid", __func__, rc);
> +		return rc;
> +	}
>  
>  	if (dacloffset)
>  		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
> @@ -658,7 +931,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
>  	memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_ptr,
>  			sizeof(struct cifs_sid)); */
>  
> -	return 0;
> +	return rc;
>  }
>  
>  
> @@ -865,7 +1138,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr *fattr,
>  		rc = PTR_ERR(pntsd);
>  		cERROR(1, "%s: error %d getting sec desc", __func__, rc);
>  	} else {
> -		rc = parse_sec_desc(pntsd, acllen, fattr);
> +		rc = parse_sec_desc(cifs_sb, pntsd, acllen, fattr);
>  		kfree(pntsd);
>  		if (rc)
>  			cERROR(1, "parse sec desc failed rc = %d", rc);
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index c4ae7d0..4aee974 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -39,6 +39,15 @@
>  #define ACCESS_ALLOWED	0
>  #define ACCESS_DENIED	1
>  
> +#define SIDOWNER 1
> +#define SIDGROUP 2
> +#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub authorities */
> +
> +#define SID_ID_MAPPED 0
> +#define SID_ID_PENDING 1
> +#define SID_MAP_EXPIRE (3600 * HZ) /* map entry expires after one hour */
> +#define SID_MAP_RETRY (300 * HZ)   /* wait 5 minutes for next attempt to map */
> +
>  struct cifs_ntsd {
>  	__le16 revision; /* revision level */
>  	__le16 type;
> @@ -74,6 +83,21 @@ struct cifs_wksid {
>  	char sidname[SIDNAMELENGTH];
>  } __attribute__((packed));
>  
> +struct cifs_sid_id {
> +	unsigned int refcount;
> +	unsigned long id;
> +	unsigned long time;
> +	unsigned long state;
> +	char *sidstr;
> +	struct rb_node rbnode;
> +	struct cifs_sid sid;
> +};
> +
> +#ifdef __KERNEL__
> +extern struct key_type cifs_idmap_key_type;
> +extern const struct cred *root_cred;
> +#endif /* KERNEL */
> +
>  extern int match_sid(struct cifs_sid *);
>  extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
>  


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>

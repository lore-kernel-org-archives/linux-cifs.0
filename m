From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cifs: Invoke id mapping functions (try #14)
Date: Wed, 13 Apr 2011 16:16:13 -0400
Message-ID: <20110413161613.11562eb9@corrin.poochiereds.net>
References: <1302312015-17437-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110413155955.6240bc53@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110413155955.6240bc53-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Apr 2011 15:59:55 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri,  8 Apr 2011 20:20:15 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> 
> > From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > ---
> >  fs/cifs/cifsacl.c |  304 ++++++++++++++++++++++++++++++++++++++++++++++++----
> >  fs/cifs/cifsacl.h |   24 ++++
> >  2 files changed, 304 insertions(+), 24 deletions(-)
> > 
> > diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> > index 12854d0..8792ce1 100644
> > --- a/fs/cifs/cifsacl.c
> > +++ b/fs/cifs/cifsacl.c
> > @@ -54,7 +54,30 @@ static const struct cifs_sid sid_authusers = {
> >  /* group users */
> >  static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
> >  
> > -static const struct cred *root_cred;
> > +const struct cred *root_cred;
> > +
> > +static void
> > +shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
> > +			int *nr_del)
> > +{
> > +	struct rb_node *node;
> > +	struct rb_node *tmp;
> > +	struct cifs_sid_id *psidid;
> > +
> > +	node = rb_first(root);
> > +	while (node) {
> > +		tmp = node;
> > +		node = rb_next(tmp);
> > +		psidid = rb_entry(tmp, struct cifs_sid_id, rbnode);
> > +		if (time_after(psidid->time + SID_MAP_EXPIRE, jiffies) ||
> > +				(nr_to_scan == 0) || (*nr_del == nr_to_scan))
> > +			++(*nr_rem);
> > +		else {
> > +			rb_erase(tmp, root);
> > +			++(*nr_del);
> > +		}
> > +	}
> > +}
> >  
> >  /*
> >   * Run idmap cache shrinker.
> > @@ -62,9 +85,21 @@ static const struct cred *root_cred;
> >  static int
> >  cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
> >  {
> > -	/* Use a pruning scheme in a subsequent patch instead */
> > -	cifs_destroy_idmaptrees();
> > -	return 0;
> > +	int nr_del = 0;
> > +	int nr_rem = 0;
> > +	struct rb_root *root;
> > +
> > +	root = &uidtree;
> > +	spin_lock(&siduidlock);
> > +	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> > +	spin_unlock(&siduidlock);
> > +
> > +	root = &gidtree;
> > +	spin_lock(&sidgidlock);
> > +	shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> > +	spin_unlock(&sidgidlock);
> > +
> > +	return nr_rem;
> >  }
> >  
> >  static struct shrinker cifs_shrinker = {
> > @@ -92,7 +127,6 @@ cifs_idmap_key_destroy(struct key *key)
> >  	kfree(key->payload.data);
> >  }
> >  
> > -static
> >  struct key_type cifs_idmap_key_type = {
> >  	.name        = "cifs.cifs_idmap",
> >  	.instantiate = cifs_idmap_key_instantiate,
> > @@ -101,6 +135,202 @@ struct key_type cifs_idmap_key_type = {
> >  	.match       = user_match,
> >  };
> >  
> > +static void
> > +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
> > +{
> > +	int i;
> > +	unsigned long saval;
> > +	char *strptr;
> > +
> > +	strptr = sidstr;
> > +
> > +	sprintf(strptr, "%s", "S");
> > +	strptr = sidstr + strlen(sidstr);
> > +
> > +	sprintf(strptr, "-%d", sidptr->revision);
> > +	strptr = sidstr + strlen(sidstr);
> > +
> > +	for (i = 0; i < 6; ++i) {
> > +		if (sidptr->authority[i]) {
> > +			sprintf(strptr, "-%d", sidptr->authority[i]);
> > +			strptr = sidstr + strlen(sidstr);
> > +		}
> > +	}
> > +
> > +	for (i = 0; i < sidptr->num_subauth; ++i) {
> > +		saval = le32_to_cpu(sidptr->sub_auth[i]);
> > +		sprintf(strptr, "-%ld", saval);
> > +		strptr = sidstr + strlen(sidstr);
> > +	}
> > +}
> > +
> > +static void
> > +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
> > +		struct cifs_sid_id **psidid, char *typestr)
> > +{
> > +	int rc;
> > +	char *strptr;
> > +	struct rb_node *node = root->rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct rb_node **linkto = &(root->rb_node);
> > +	struct cifs_sid_id *lsidid;
> > +
> > +	while (node) {
> > +		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
> > +		parent = node;
> > +		rc = compare_sids(sidptr, &((lsidid)->sid));
> > +		if (rc > 0) {
> > +			linkto = &(node->rb_left);
> > +			node = node->rb_left;
> > +		} else if (rc < 0) {
> > +			linkto = &(node->rb_right);
> > +			node = node->rb_right;
> > +		}
> > +	}
> > +
> > +	memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
> > +	(*psidid)->time = jiffies;
> > +	(*psidid)->retry = jiffies - (SID_MAP_RETRY + 1);
> > +
> > +	sprintf((*psidid)->sidstr, "%s", typestr);
> > +	strptr = (*psidid)->sidstr + strlen((*psidid)->sidstr);
> > +	sid_to_str(&(*psidid)->sid, strptr);
> > +
> > +	clear_bit(SID_ID_PENDING, &(*psidid)->state);
> > +	clear_bit(SID_ID_MAPPED, &(*psidid)->state);
> > +
> > +	rb_link_node(&(*psidid)->rbnode, parent, linkto);
> > +	rb_insert_color(&(*psidid)->rbnode, root);
> > +}
> > +
> > +static struct cifs_sid_id *
> > +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
> > +{
> > +	int rc;
> > +	struct rb_node *node = root->rb_node;
> > +	struct rb_node *parent = NULL;
> > +	struct rb_node **linkto = &(root->rb_node);
> > +	struct cifs_sid_id *lsidid;
> > +
> > +	while (node) {
> > +		lsidid = rb_entry(node, struct cifs_sid_id, rbnode);
> > +		parent = node;
> > +		rc = compare_sids(sidptr, &((lsidid)->sid));
> > +		if (rc > 0) {
> > +			linkto = &(node->rb_left);
> > +			node = node->rb_left;
> > +		} else if (rc < 0) {
> > +			linkto = &(node->rb_right);
> > +			node = node->rb_right;
> > +		} else /* node found */
> > +			return lsidid;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static int
> > +sidid_pending_wait(void *unused)
> > +{
> > +	schedule();
> > +	return signal_pending(current) ? -ERESTARTSYS : 0;
> > +}
> > +
> > +static int
> > +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> > +		struct cifs_fattr *fattr, uint sidtype)
> > +{
> > +	int rc;
> > +	unsigned long cid;
> > +	struct key *idkey;
> > +	const struct cred *saved_cred;
> > +	struct cifs_sid_id *psidid, *npsidid;
> > +	struct rb_root *cidtree;
> > +	spinlock_t *cidlock;
> > +
> > +	if (sidtype == SIDOWNER) {
> > +		cid = cifs_sb->mnt_uid; /* default uid, in case upcall fails */
> > +		cidlock = &siduidlock;
> > +		cidtree = &uidtree;
> > +	} else if (sidtype == SIDGROUP) {
> > +		cid = cifs_sb->mnt_gid; /* default gid, in case upcall fails */
> > +		cidlock = &sidgidlock;
> > +		cidtree = &gidtree;
> > +	} else
> > +		return -ENOENT;
> > +
> > +	spin_lock(cidlock);
> > +	psidid = id_rb_search(cidtree, psid);
> > +	spin_unlock(cidlock);
> > +

Bah...I spoke too soon. NAK...

What prevents the following situation?

Suppose in the above code you find an existing entry. That entry is
MAPPED, but was created some time ago. The idmap cache shrinker runs
after you find this entry, but before you pull the id out of it. The
memory gets freed and then you get an OOPS because the memory was
reclaimed.

You'll need to deal with that case too. One way would be to reset the
timestamp on the entry before releasing the lock when you find one that
already exists. Another would be to just pull the id out of the entry
when it's already mapped, before you release the lock.

I'd probably say the first scheme is better since you probably don't
ever want to dump cache entries that are likely to be used (since you'd
probably end up just having to re-upcall for them anyway).
 
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

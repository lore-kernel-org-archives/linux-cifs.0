From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cifs: Invoke id mapping functions (try #3)
Date: Sat, 22 Jan 2011 07:48:26 -0500
Message-ID: <20110122074826.26e9ad03@tlielax.poochiereds.net>
References: <1295646269-21898-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295646269-21898-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Jan 2011 15:44:29 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> RB tree search and insertion routines.
> 
> A SID which needs to be mapped, is looked up in one of the RB trees
> depending whether SID is either owner or group SID.
> If found in a tree, a (mapped) id from that node is assigned to
> uid or gid as appropriated.
> 
> Otherwise, the SID is mapped and looked-up with the help of
> Winbind via upcall mechanism.
> 
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID converted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID (string) for an id.
> 
> 
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

[...]

> +static int
> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> +		struct cifs_fattr *fattr, uint sidtype)
> +{
> +	int rc = 0;
> +	unsigned long id;
> +	char *sidstr, *strptr;
> +	struct key *idkey;
> +	const struct cred *saved_cred;
> +	struct cifs_sid_id *sididptr;
> +
> +	if (sidtype == SIDOWNER) {
> +		spin_lock(&cifs_sb->siduidlock);
> +		id = id_rb_search(&cifs_sb->uidtree, psid);
> +		spin_unlock(&cifs_sb->siduidlock);
> +	} else if (sidtype == SIDGROUP) {
> +		spin_lock(&cifs_sb->sidgidlock);
> +		id = id_rb_search(&cifs_sb->gidtree, psid);
> +		spin_unlock(&cifs_sb->sidgidlock);
> +	} else
> +		return -ENOENT;
> +
> +	if (!id) {
> +		sidstr = kzalloc(SIDLEN, GFP_KERNEL);
> +		if (!sidstr)
> +			return -ENOMEM;
> +
> +		sididptr = kzalloc(sizeof(struct cifs_sid_id), GFP_KERNEL);
> +		if (!sididptr) {
> +			kfree(sidstr);
> +			return -ENOMEM;
> +		}
> +
> +		if (sidtype == SIDOWNER)
> +			sprintf(sidstr, "%s", "os:");
> +		else if (sidtype == SIDGROUP)
> +			sprintf(sidstr, "%s", "gs:");
> +
> +		strptr = sidstr + strlen(sidstr);
> +		sid_to_str(psid, strptr);
> +
> +		saved_cred = override_creds(root_cred);
> +		idkey = request_key(&cifs_idmap_key_type, sidstr, "");
> +		if (IS_ERR(idkey))
> +			cFYI(1, "%s: Can't resolve SID to an uid", __func__);
> +		else {
> +			id = *(unsigned long *)idkey->payload.value;
> +			key_put(idkey);
> +			memcpy(&sididptr->sid, psid, sizeof(struct cifs_sid));
> +			sididptr->id = id;
> +			if (sidtype == SIDOWNER) {
> +				spin_lock(&cifs_sb->siduidlock);
> +				id_rb_insert(&cifs_sb->uidtree, sididptr, id);
> +				spin_unlock(&cifs_sb->siduidlock);
> +			} else {
> +				spin_lock(&cifs_sb->sidgidlock);
> +				id_rb_insert(&cifs_sb->gidtree, sididptr, id);
> +				spin_unlock(&cifs_sb->sidgidlock);
> +			}
> +		}
> +		revert_creds(saved_cred);
> +		kfree(sidstr);
> +	}
> +
> +	if (sidtype == SIDOWNER)
> +		fattr->cf_uid = id;
> +	else
> +		fattr->cf_gid = id;
> +
> +	return rc;
> +}
> +

This looks racy.

You search for an entry in the rbtree and then do the upcall if it
doesn't exist. When you get the response back you stick it in the tree.

What if two different threads are doing this at the same time? It's
easily possible that once the downcall comes in, another thread has
already stuck an entry in that spot.

What you should do is stick a placeholder in the tree prior to doing
the upcall. Then, if another thread comes along and does a search you
have it wait until the upcall is complete. See cifs_sb_tlink for an
example of how to do that.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

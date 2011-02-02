From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions
Date: Wed, 2 Feb 2011 08:29:37 -0500
Message-ID: <20110202082937.3b3b68d7@corrin.poochiereds.net>
References: <1295995034-8771-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295995034-8771-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 25 Jan 2011 16:37:14 -0600
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> rb tree search and insertion routines.
> 
> A SID which needs to be mapped, is looked up in one of the rb trees
> depending whether SID is either owner or group SID.
> If found in a tree, a (mapped) id from that node is assigned to
> uid or gid as appropriated.
> 
> Otherwise, the SID is mapped and looked-up with the help of
> Winbind via upcall mechanism and a node with mapping is inserted
> in one of the caches while again making sure that the node does not exist.
> 
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID converted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
> 
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
> it would be used to obtain an SID (string) for an id.
> 

[...]

> +
> +static int
> +sid_to_id(struct cifs_sid *psid, struct cifs_fattr *fattr, uint sidtype)
> +{
> +	int rc = 0;
> +	unsigned long id;
> +	char *sidstr, *strptr;
> +	struct key *idkey;
> +	const struct cred *saved_cred;
> +	struct cifs_sid_id *sididptr;
> +
> +	if (sidtype == SIDOWNER) {
> +		spin_lock(&siduidlock);
> +		id = id_rb_search(&uidtree, psid);
> +		spin_unlock(&siduidlock);
> +	} else if (sidtype == SIDGROUP) {
> +		spin_lock(&sidgidlock);
> +		id = id_rb_search(&gidtree, psid);
> +		spin_unlock(&sidgidlock);
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
> +				spin_lock(&siduidlock);
> +				id_rb_insert(&uidtree, sididptr, id);
> +				spin_unlock(&siduidlock);
> +			} else {
> +				spin_lock(&sidgidlock);
> +				id_rb_insert(&gidtree, sididptr, id);
> +				spin_unlock(&sidgidlock);
> +			}
> +		}

		^^^^^^^^^^
Please go back and read my comments on your earlier attempt. This one
has not fixed the problems that will occur when two threads race to
insert into the same spot in the tree.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

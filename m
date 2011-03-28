From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #10)
Date: Mon, 28 Mar 2011 15:02:34 -0400
Message-ID: <20110328150234.21613793@tlielax.poochiereds.net>
References: <1300986024-7221-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300986024-7221-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 Mar 2011 12:00:24 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:


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

That default seems reasonable, I think...

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
> +	if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
> +		if (!test_bit(SID_ID_MAPPED, &psidid->state)) {

Overall this looks a lot better. The above however is a bit
questionable. Every time you find an entry in the tree, you then mark
it PENDING and check to see if it's MAPPED.

These entries are never going to go from being MAPPED to not. Would it
instead make more sense to check whether it's MAPPED first, and only
then try to set the PENDING bit?

if (!test_bit(SID_ID_MAPPED, &psidid->state) &&
    !test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
	/* construct the entry */
} else {
    /* wait on the PENDING bit */
}

The reason for this would be to minimize the times that you're going to
set the PENDING bit, and force other threads to serialize behind it.

> +			/* node with unmapped SID */
> +			memset(psidid->sidstr, '\0', SIDLEN);
> +			if (sidtype == SIDOWNER)
> +				sprintf(psidid->sidstr, "%s", "os:");
> +			else
> +				sprintf(psidid->sidstr, "%s", "gs:");
> +
> +			strptr = psidid->sidstr + strlen(psidid->sidstr);
> +			sid_to_str(psid, strptr);
> +
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
> +		}
> +		clear_bit(SID_ID_PENDING, &psidid->state);
> +		wake_up_bit(&psidid->state, SID_ID_PENDING);
> +	} else {
> +		/*
> +		 * either an existing node with SID mapped (in which case
> +		 * we would not wait) or a node whose SID is being mapped by
> +		 * somebody else (in which case, we would end up waiting).
> +		 */
> +		rc = wait_on_bit(&psidid->state, SID_ID_PENDING,
> +				sidid_pending_wait, TASK_INTERRUPTIBLE);
> +		if (rc) {
> +			cFYI(1, "%s: sidid_pending_wait interrupted %d",
> +				__func__, rc);
> +			return rc;
> +		}
> +	}
> +
> +
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

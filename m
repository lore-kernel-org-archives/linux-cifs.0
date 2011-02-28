From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Mon, 28 Feb 2011 17:49:57 -0500
Message-ID: <20110228224957.GB14237@fieldses.org>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1298929961-5541-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 03:52:41PM -0600, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> +static struct dentry *
> +cifs_fh_to_dentry(struct super_block *sb, struct fid *fh,
> +			int fh_len, int fh_type)
> +{
> +	struct cifs_fid *cfid = (struct cifs_fid *)fh;
> +	struct inode *inode = NULL;
> +	struct cifs_fattr fattr;
> +
>  
> -#endif /* CIFS_NFSD_EXPORT */
> +	if (fh_type != FILEID_INO32_GEN && fh_type != FILEID_INO32_GEN_PARENT) {
> +		cERROR(1, "%s: Can't handle fh type: %d", __func__, fh_type);
> +		return ERR_PTR(-EINVAL);
> +	}
>  
> +	if (!cfid->cino)
> +		return ERR_PTR(-ESTALE);
> +
> +	fattr.cf_uniqueid = cfid->cino;
> +	inode = iget5_locked(sb, cfid->cino, cifs_find_inode_id,
> +					cifs_init_inode, &fattr);
> +	if (IS_ERR(inode))
> +		return ERR_CAST(inode);
> +
> +	return d_obtain_alias(inode);

Does the cifs protocol give the client a way to look up a file by inode
number (or filehandle or equivalent?).

--b.

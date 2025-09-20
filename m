Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6C2176AC8
	for <linux-cifs@vger.kernel.org>; Sat, 20 Sep 2025 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758376718; cv=none; b=Kpw1yN8IqmfnbZKUerOjCX+vBZtaR9hUYI95qmDoruoZV+HX44Q5NESuzM/5o1eKlaDqqdD2L1O10ev/qyglubg04CbGHQuNiwhGQb7AnyRTPzIM6XWUPlx9fx9qUUQrZzhy2PYW7ZmNC3wD2ttWH0w5CTGI9w9s9sdEvd+zzE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758376718; c=relaxed/simple;
	bh=CJBr7IY2Q3P19XmLBSXYzb/7KQvWq//uVErqkUyS6jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CJCKOP4hUOxq2dQBVcOq316DajLSTD+VPLWiK1tomc6DhvgDMfsL26IjKVpkVW5guetLIC9wT2ukfo3PrhAt4/I5ttoknl1jMZjKyafKnnL7f/iJjmnUNGVX5o0sWBZzBUDWbNeUluVpEy3dSPbaxflIuk4ffg83B4WPxGJozYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EObFR8Zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EObFR8Zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21E9C4CEEB;
	Sat, 20 Sep 2025 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758376718;
	bh=CJBr7IY2Q3P19XmLBSXYzb/7KQvWq//uVErqkUyS6jk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EObFR8Zi041wjL06kUqZW6DBZeRLZxd16nMlMQsBvtR+eKt8AqEZud2ZTKCQJds+z
	 v3idU773tQ7PuehVSKgWzflCp79v9lyPwPt03otSVNNh6sCdfTrvxNzRyw2A643c1W
	 H3hPdj3I71i8ehf6Pdu4rXWEI3Ote6YMKig7CbuagQ89Gms0JxRr9+bBUVJWkflnBm
	 E941f7IJclpndLN+hwi9GI0tQlkFE2lw/ekP21N8eZMNqLtrAgsVawOLPdP78GBgsH
	 TJaJlE5Dsj/twIZA/6VifXU8jWY8dfSesWppPLkk14AQNMq6Q5DHLfAjLKdOK9/vES
	 N+SaORx6NgF1w==
Received: by pali.im (Postfix)
	id 31C1E7C5; Sat, 20 Sep 2025 15:58:34 +0200 (CEST)
Date: Sat, 20 Sep 2025 15:58:34 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: handle unlink(2) of files open by different
 clients
Message-ID: <20250920135834.4yohqhs3uj7aoeqe@pali>
References: <20250919171315.1137337-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919171315.1137337-1-pc@manguebit.org>
User-Agent: NeoMutt/20180716

I have already addressed this issue together with others related to
unlink in my patch series which I have sent month ago. Please look:

https://lore.kernel.org/linux-cifs/20250831123602.14037-1-pali@kernel.org/

On Friday 19 September 2025 14:13:15 Paulo Alcantara wrote:
> In order to identify whether a certain file is open by a different
> client, start the unlink process by sending a compound request of
> CREATE(DELETE_ON_CLOSE) + CLOSE with only FILE_SHARE_DELETE bit set in
> smb2_create_req::ShareAccess.  If the file is currently open, then the
> server will fail the request with STATUS_SHARING_VIOLATION, in which
> case we'll map it to -EBUSY, so __cifs_unlink() will fall back to
> silly-rename the file.
> 
> This fixes the following case where open(O_CREAT) fails with
> -ENOENT (STATUS_DELETE_PENDING) due to file still open by a different
> client.
> 
> * Before patch
> 
> $ mount.cifs //srv/share /mnt/1 -o ...,nosharesock
> $ mount.cifs //srv/share /mnt/2 -o ...,nosharesock
> $ cd /mnt/1
> $ touch foo
> $ exec 3<>foo
> $ cd /mnt/2
> $ rm foo
> $ touch foo
> touch: cannot touch 'foo': No such file or directory
> $ exec 3>&-
> 
> * After patch
> 
> $ mount.cifs //srv/share /mnt/1 -o ...,nosharesock
> $ mount.cifs //srv/share /mnt/2 -o ...,nosharesock
> $ cd /mnt/1
> $ touch foo
> $ exec 3<>foo
> $ cd /mnt/2
> $ rm foo
> $ touch foo
> $ exec 3>&-
> 
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Frank Sorenson <sorenson@redhat.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/smb2inode.c | 99 ++++++++++++++++++++++++++++++++++-----
>  1 file changed, 88 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 7cadc8ca4f55..e32a3f338793 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1175,23 +1175,92 @@ int
>  smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>  	    struct cifs_sb_info *cifs_sb, struct dentry *dentry)
>  {
> +	struct kvec open_iov[SMB2_CREATE_IOV_SIZE];
> +	__le16 *utf16_path __free(kfree) = NULL;
> +	int retries = 0, cur_sleep = 1;
> +	struct TCP_Server_Info *server;
>  	struct cifs_open_parms oparms;
> +	struct smb2_create_req *creq;
>  	struct inode *inode = NULL;
> +	struct smb_rqst rqst[2];
> +	struct kvec rsp_iov[2];
> +	struct kvec close_iov;
> +	int resp_buftype[2];
> +	struct cifs_fid fid;
> +	int flags = 0;
> +	__u8 oplock;
>  	int rc;
>  
> -	if (dentry)
> +	utf16_path = cifs_convert_path_to_utf16(name, cifs_sb);
> +	if (!utf16_path)
> +		return -ENOMEM;
> +
> +	if (smb3_encryption_required(tcon))
> +		flags |= CIFS_TRANSFORM_REQ;
> +again:
> +	oplock = SMB2_OPLOCK_LEVEL_NONE;
> +	server = cifs_pick_channel(tcon->ses);
> +
> +	memset(rqst, 0, sizeof(rqst));
> +	memset(resp_buftype, 0, sizeof(resp_buftype));
> +	memset(rsp_iov, 0, sizeof(rsp_iov));
> +
> +	rqst[0].rq_iov = open_iov;
> +	rqst[0].rq_nvec = ARRAY_SIZE(open_iov);
> +
> +	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE | FILE_READ_ATTRIBUTES,
> +			     FILE_OPEN, CREATE_DELETE_ON_CLOSE |
> +			     OPEN_REPARSE_POINT, ACL_NO_MODE);
> +	oparms.fid = &fid;
> +
> +	if (dentry) {
>  		inode = d_inode(dentry);
> +		if (CIFS_I(inode)->lease_granted && server->ops->get_lease_key) {
> +			oplock = SMB2_OPLOCK_LEVEL_LEASE;
> +			server->ops->get_lease_key(inode, &fid);
> +		}
> +	}
>  
> -	oparms = CIFS_OPARMS(cifs_sb, tcon, name, DELETE,
> -			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
> -	rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
> -			      NULL, &(int){SMB2_OP_UNLINK},
> -			      1, NULL, NULL, NULL, dentry);
> -	if (rc == -EINVAL) {
> -		cifs_dbg(FYI, "invalid lease key, resending request without lease");
> -		rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
> -				      NULL, &(int){SMB2_OP_UNLINK},
> -				      1, NULL, NULL, NULL, NULL);
> +	rc = SMB2_open_init(tcon, server,
> +			    &rqst[0], &oplock, &oparms, utf16_path);
> +	if (rc)
> +		goto err_free;
> +	smb2_set_next_command(tcon, &rqst[0]);
> +	creq = rqst[0].rq_iov[0].iov_base;
> +	creq->ShareAccess = FILE_SHARE_DELETE_LE;
> +
> +	rqst[1].rq_iov = &close_iov;
> +	rqst[1].rq_nvec = 1;
> +
> +	rc = SMB2_close_init(tcon, server, &rqst[1],
> +			     COMPOUND_FID, COMPOUND_FID, false);
> +	smb2_set_related(&rqst[1]);
> +	if (rc)
> +		goto err_free;
> +
> +	if (retries) {
> +		for (int i = 0; i < ARRAY_SIZE(rqst);  i++)
> +			smb2_set_replay(server, &rqst[i]);
> +	}
> +
> +	rc = compound_send_recv(xid, tcon->ses, server, flags,
> +				ARRAY_SIZE(rqst), rqst,
> +				resp_buftype, rsp_iov);
> +	SMB2_open_free(&rqst[0]);
> +	SMB2_close_free(&rqst[1]);
> +	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
> +
> +	if (is_replayable_error(rc) &&
> +	    smb2_should_replay(tcon, &retries, &cur_sleep))
> +		goto again;
> +
> +	/* Retry compound request without lease */
> +	if (rc == -EINVAL && dentry) {
> +		dentry = NULL;
> +		retries = 0;
> +		cur_sleep = 1;
> +		goto again;
>  	}
>  	/*
>  	 * If dentry (hence, inode) is NULL, lease break is going to
> @@ -1199,6 +1268,14 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>  	 */
>  	if (!rc && inode)
>  		cifs_mark_open_handles_for_deleted_file(inode, name);
> +
> +	return rc;
> +
> +err_free:
> +	SMB2_open_free(&rqst[0]);
> +	SMB2_close_free(&rqst[1]);
> +	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
> +	free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
>  	return rc;
>  }
>  
> -- 
> 2.51.0
> 

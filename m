Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B744166F3D;
	Sun, 29 Sep 2024 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727614404; cv=none; b=cT0fX+5ICQGUbKQdzWIyNq67RDsg1fN0tjPVlocLVd4VGtzlzN5wOA7iAjmRzZUB8icYmxisEvtujTHfBDSFpHQ5mfUd6TeT6CMTqlkcG1lGv0bai2tF9FH34Q/awCHuiHFSnr9aWwvTpTx6IXX/0YNqGX6+6wbcQMfs4en1/DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727614404; c=relaxed/simple;
	bh=Bp1K9G0WMsALT0d5ANIdqjivrQqSUfMMybbl4HmCxsY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HqWgktaApR3u0SG95Dyox1SIt2yX6P19ArIA5KAno+F5acVp+ZKoebDdB2N848QtC+kQejWj7hTjQyD73FQjmcndq+z/czoHNii3Or1qNQ7Czs+xYhD9t7QXIOod4cFhmYe93/hPXEtvqKm+KlnLXxVMjbp2ET1dEFGSDxWSoeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VWFbb8wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VWFbb8wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C88C4CEC5;
	Sun, 29 Sep 2024 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727614403;
	bh=Bp1K9G0WMsALT0d5ANIdqjivrQqSUfMMybbl4HmCxsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VWFbb8wYU0S1W1F1AHmyTFcb4nXxO2MdHHoQxg4vMzoLc6Ux3QC0yR2uoJKOFLO/E
	 Z3QDTcUpsvJmZHPbFiw4VfDN7EqPV/TmbZpueaPRdVXNYMlw9Pf4BjzYl6GINPDUdw
	 /qk+0354sajJseCamQt3PV5px0CUWDR9sS8lbSYWNt1Z1PJvBMg0NyNK2phcRa1HN3
	 UuJ198+3CE3VB7n5QDAt5jXb7H+y3CYyMVcbZHsMfKhRsvniueDx6ILYSRHx0j6h6D
	 CTUCkcJ+NR0qiGw1UiZvEogr1gztl2W3vwAal7QmCOiAM3dcTyM56siD9GqUaMF9wn
	 oQeonj4E2+QbA==
Received: by pali.im (Postfix)
	id BD4B1872; Sun, 29 Sep 2024 14:53:17 +0200 (CEST)
Date: Sun, 29 Sep 2024 14:53:17 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cifs: Remove intermediate object of failed create
 reparse call
Message-ID: <20240929125317.p7tbwvzy4bcs2a3s@pali>
References: <20240928215948.4494-1-pali@kernel.org>
 <20240928215948.4494-3-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240928215948.4494-3-pali@kernel.org>
User-Agent: NeoMutt/20180716

Hello Steve, I was reading again implementation of smb2_compound_op()
function and if I understood it correctly, then out_iov and out_buftype
array parameters needs to have num_cmds+2 members. This is quite
unexpected, and this patch cause buffer overflow and memory leaks.
+2 is for CREATE and CLOSE operations added automatically by compound.

Surprisingly, no memory issue and neither corrupted packed I observed.
And therefore I thought that change is working fine.

I will send a new version of this change to increase array members and
free all members of array.

On Saturday 28 September 2024 23:59:42 Pali Rohár wrote:
> If CREATE was successful but SMB2_OP_SET_REPARSE failed then remove the
> intermediate object created by CREATE. Otherwise empty object stay on the
> server when reparse call failed.
> 
> This ensures that if the creating of special files is unsupported by the
> server then no empty file stay on the server as a result of unsupported
> operation.
> 
> Fixes: 102466f303ff ("smb: client: allow creating special files via reparse points")
> Signed-off-by: Pali Rohár <pali@kernel.org>
> ---
>  fs/smb/client/smb2inode.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 11a1c53c64e0..af42f44bdcf4 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1205,6 +1205,8 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
>  	struct cifsFileInfo *cfile;
>  	struct inode *new = NULL;
> +	int out_buftype[2] = {};
> +	struct kvec out_iov[2];
>  	struct kvec in_iov[2];
>  	int cmds[2];
>  	int rc;
> @@ -1228,7 +1230,7 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
>  		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
>  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>  		if (!rc) {
>  			rc = smb311_posix_get_inode_info(&new, full_path,
>  							 data, sb, xid);
> @@ -1237,12 +1239,27 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
>  		cmds[1] = SMB2_OP_QUERY_INFO;
>  		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
>  		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms,
> -				      in_iov, cmds, 2, cfile, NULL, NULL, NULL);
> +				      in_iov, cmds, 2, cfile, out_iov, out_buftype, NULL);
>  		if (!rc) {
>  			rc = cifs_get_inode_info(&new, full_path,
>  						 data, sb, xid, NULL);
>  		}
>  	}
> +
> +	if (rc) {
> +		/*
> +		 * If CREATE was successful but SMB2_OP_SET_REPARSE failed then
> +		 * remove the intermediate object created by CREATE. Otherwise
> +		 * empty object stay on the server when reparse call failed.
> +		 */
> +		if (((struct smb2_hdr *)out_iov[0].iov_base)->Status == STATUS_SUCCESS &&
> +		    ((struct smb2_hdr *)out_iov[1].iov_base)->Status != STATUS_SUCCESS)
> +			smb2_unlink(xid, tcon, full_path, cifs_sb, NULL);
> +	}
> +
> +	free_rsp_buf(out_buftype[0], out_iov[0].iov_base);
> +	free_rsp_buf(out_buftype[1], out_iov[1].iov_base);
> +
>  	return rc ? ERR_PTR(rc) : new;
>  }
>  
> -- 
> 2.20.1
> 

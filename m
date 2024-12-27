Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE5C320B;
	Fri, 27 Dec 2024 14:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735310633; cv=none; b=LoiZjzkJdiAX0UZ31UCaw4MUVqe7UvmHOH93T6WdzUFJJ8aVkM4eks6lfQdBT3uzeSmKhfYVZvQIkHBIuphxcGyQrLnXo2lwfasZbipzs+XBXfG0vfN9ru+UJN6g9KcFnPsu0l+9ngtPXfYNnu7jXMfI1h/rbN40smsY9cRFp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735310633; c=relaxed/simple;
	bh=5e9AAl0Xf4AY6W8GthF3SFX2esg/un4yvi4SMHX2YWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4VUyCHFkFPGI6FHz4h6HlkUlwftVGZb5SFJvVyRMTDwYwWI1tp8GosuFzjJzUmeOKSundPEcqGMLb3jq0QvF9+d1hwieL7mMp72eg2Wh+H2ZrmU+ktuqSDNApQVj54hgUOsS2bgh8MbX12rp8ec2xGXVEDGGRfS6rYwGm4Sm7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqKLYj2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqKLYj2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0178BC4CED0;
	Fri, 27 Dec 2024 14:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735310633;
	bh=5e9AAl0Xf4AY6W8GthF3SFX2esg/un4yvi4SMHX2YWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PqKLYj2NNMaULIxJIdfXtMAf/qdT6S994jHeEsy5oA08RCrMTmqCZgTjKEAzKa1H7
	 xPJQpX6wSKGixAXN+nGU+afB91pnY9I/T5q57MpPQS70TbFd+vF7NugHf822UEe8KV
	 LQd2YLmn02oQn51a+d6ryBETOfDOANLctnGGo1aHdKhLpDsjsBNXVfaT4o3RAu8tVK
	 1dgazerHc3D8a+9hlpQjCG1zZWi4dTAExMIrg4yZ0+mDltzUgOOsaKffRhP3y+FPAt
	 bEu1k5rp/y9VRiWc1n/HQwjmvjHJABRsPEeZAypxd8kUliSopBRfbeALIybv9x4Ite
	 w+FyXpWWmKBSg==
Received: by pali.im (Postfix)
	id 48EAB787; Fri, 27 Dec 2024 15:43:43 +0100 (CET)
Date: Fri, 27 Dec 2024 15:43:43 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cifs: Fix getting and setting SACLs over SMB1
Message-ID: <20241227144343.volpdup7xx6xlsiq@pali>
References: <20241222151051.23917-1-pali@kernel.org>
 <20241222151051.23917-2-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241222151051.23917-2-pali@kernel.org>
User-Agent: NeoMutt/20180716

On Sunday 22 December 2024 16:10:48 Pali Rohár wrote:
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index ba79aa2107cc..b07f3609adec 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -1498,10 +1501,12 @@ int set_cifs_acl(struct smb_ntsd *pnntsd, __u32 acllen,
>  	tcon = tlink_tcon(tlink);
>  	xid = get_xid();
>  
> -	if (aclflag == CIFS_ACL_OWNER || aclflag == CIFS_ACL_GROUP)
> -		access_flags = WRITE_OWNER;
> -	else
> -		access_flags = WRITE_DAC;
> +	if (aclflag & CIFS_ACL_OWNER || aclflag & CIFS_ACL_GROUP)
> +		access_flags |= WRITE_OWNER;
> +	if (aclflag & CIFS_ACL_SACL)
> +		access_flags |= SYSTEM_SECURITY;
> +	if (aclflag & CIFS_ACL_DACL)
> +		access_flags |= WRITE_DAC;
>  
>  	oparms = (struct cifs_open_parms) {
>  		.tcon = tcon,

In this function is missing initialization of access_flags value after my change.
I can fix it by this simple fixup change:

diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
index 1054c62ade6c..b3e2f1dad175 100644
--- a/fs/smb/client/cifsacl.c
+++ b/fs/smb/client/cifsacl.c
@@ -1488,7 +1488,7 @@ int set_cifs_acl(struct smb_ntsd *pnntsd, __u32 acllen,
 {
 	int oplock = 0;
 	unsigned int xid;
-	int rc, access_flags;
+	int rc, access_flags = 0;
 	struct cifs_tcon *tcon;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct tcon_link *tlink = cifs_sb_tlink(cifs_sb);

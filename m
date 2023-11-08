Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB8199A5
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="BN26Q2Wj"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C491FD8
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 07:44:20 -0800 (PST)
Message-ID: <efd21d30cc8b110347931c98fb21db62.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699458259;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RipaHVPwMGGhbwJJPFTXj3Tjyq2bAG9KSaqxO9ECzrs=;
	b=BN26Q2Wjdm/VjViXbOCngio8lAHX5vd4pMmeH9vDtgxgercs5pOQxaR5hB0+0Q+W7VBbT1
	uKrqxpVNfAO67BIX1CoTVANVcJMHxQU1+2v9oMczTalaVC8+eNYgElNv8MAx9LMISACi4p
	lIgHafNowucV0A7xgDZRHJgn5y0hCUsRldmKR8Cq3wDmVVZ3VRO49j5s2+YN3OIuUVeQlB
	ka2It+hr9ZELgBmEJDQvEIPyvW+q3eK43NHqclBgq33Rq9/8VFRDkAHgdSrU7pm9W1W16e
	LBksTtNSuPIe7fZAnYZmHiBO6cTb5ncwiw6pjhWhTj5BeDNR7qrRJttclXlEWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699458259; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RipaHVPwMGGhbwJJPFTXj3Tjyq2bAG9KSaqxO9ECzrs=;
	b=HlDchp0dSaz47fMm0hJiq/Xi210KJilLLBsJ6mqYzfM/NuGSpm8yOztKuxbEpX55EBpcKJ
	VQje8LlrXfVRx1CxC0plxKvxjLdIk0R9ggMoZC9ichGJ+xuPL9NDVs8ZR5QtgGdQdTzdKI
	9IeYRZ+n61Mk15UDtIauJryRZy+qsCt/TXMrpvCCMfZE5mVWfsLo5pywBs+fu9z0MnglSH
	Cifu2YRORBw7qh8m5MU0/E9KmaTzjxqHtY04IDMatOIdf8mFGQxngm1DdO9w5bwgA/o029
	e3EolOpZKTAQy351UcsaCOchiduxcy60Pn9Hfm/Ho2Wu4BumfG7zDWVPhCH8hQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699458259; a=rsa-sha256;
	cv=none;
	b=s+lUGjmHIyiQNK6Z599xL8wH0CX1SJDwPPKqc+kvtrTqZhEDQxsoIeEb2rcau6SZ6tv9/f
	59QJrTPVYfj30nxW9blaURITlDpcsXFx8j9bVfJtnYfQ+4rBUXIQsE2YuKyW9llpAQ2bsu
	7Q6uVwzlf/NMRIB6437/0czbknVvIlc2c/3PGDvVidl3NPnNSRz46ABA7jImWxrpibVe2o
	1OBdkTMUBI/rUef0wyc+aZFICHt5GR1WuS3ztCiy+1SegnU1FPAc7SI7uSKPK1cBl2rKMi
	Xkj47WyKZxS8BvgDg8y/O5O1dv0QFLMpzrbslUggnVEf668D/eIEoeBtYTTZ4A==
From: Paulo Alcantara <pc@manguebit.com>
To: nspmangalore@gmail.com, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 08/14] cifs: account for primary channel in the
 interface list
In-Reply-To: <20231030110020.45627-8-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-8-sprasad@microsoft.com>
Date: Wed, 08 Nov 2023 12:44:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nspmangalore@gmail.com writes:

> From: Shyam Prasad N <sprasad@microsoft.com>
>
> The refcounting of server interfaces should account
> for the primary channel too. Although this is not
> strictly necessary, doing so will account for the primary
> channel in DebugData.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/sess.c    | 23 +++++++++++++++++++++++
>  fs/smb/client/smb2ops.c |  6 ++++++
>  2 files changed, 29 insertions(+)
>
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index d009994f82cf..6843deed6119 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -332,6 +332,16 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
>  
>  	/* then look for a new one */
>  	list_for_each_entry(iface, &ses->iface_list, iface_head) {
> +		if (!chan_index) {
> +			/* if we're trying to get the updated iface for primary channel */
> +			if (!cifs_match_ipaddr((struct sockaddr *) &server->dstaddr,
> +					       (struct sockaddr *) &iface->sockaddr))
> +				continue;

You should hold @server->srv_lock to protect access of @server->dstaddr
as it might change over reconnect or mount.

> +
> +			kref_get(&iface->refcount);
> +			break;
> +		}
> +
>  		/* do not mix rdma and non-rdma interfaces */
>  		if (iface->rdma_capable != server->rdma)
>  			continue;
> @@ -358,6 +368,13 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
>  		cifs_dbg(FYI, "unable to find a suitable iface\n");
>  	}
>  
> +	if (!chan_index && !iface) {
> +		cifs_dbg(VFS, "unable to get the interface matching: %pIS\n",
> +			 &server->dstaddr);

Ditto.

Also, I think you should log in FYI level as the above doesn't seem
unlikely to happen.

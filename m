Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15120217F50
	for <linux-cifs@vger.kernel.org>; Thu,  7 Nov 2024 19:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731006346; cv=fail; b=YPJURtSGjpqrCd0pLCLImggowBfW+4I93FWyKJ+J1R+AtUlYBiGOJfyYnZl2wnqCGq6UBlgqrcjMpi1UvPP/UKbEhMfq06C1tWvZaGr7BycN59BdCbUMA/0CW3z2jsj3LoTFv5GD6XAm8uaeBwBELA6UjEZYASiuwGXr1DKEFZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731006346; c=relaxed/simple;
	bh=HPKTzU/tzVrgflh0oNlcwPfudANujppa/qCHdOD9DXE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=sQlV1EDafUzDaMC99W3b8DdCTaZorlqFhMvV75tgg/iPdcsSagQa4YKEaz0/mHTiYWD/WAmdv5XUjzrPvYRY0ujVwiODclwHonp/MGVNUxXYnfwOYTlHfo8YHjQZUrWXqUj2W/ONeRWsfNAv/FPh8h7UOMKU+TJTCJ+bQa1oLCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=qLygH2aN; arc=fail smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="qLygH2aN"
Message-ID: <0282479bc2f446bcb34c53a30bb53bda@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731006343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gjkoh1ve14eQlYzW025BtfwFqgem2MNKxhWAvUgpeyE=;
	b=qLygH2aNZEX3iVDwgfryshji8VTQYFuOAsZhZ8keKOYzUy6i1IZIVl7oTYS/okrw2OVLOd
	u7uWG+vVlVF4WSOgGMK67+CvGRpG31hH146jo7mLo6DH0YZsAQ1PDNS5cIsBJe8Cb8RYEb
	qomRd5Xc3tbrzsO3CncopyJpEmy+HxI7z290/DJooVblcF/yOydMa2yUp4AbYwRU6AzB7k
	jRxNKHOh+aI//rj20aaVffrthyGSfb+M/HiACdRw07CvbJ7NoB2ug1DO35PJH7Fks3JDg/
	d/KIj8OU8MgKRxT87bqlLatNqACaZfEwW+cq4yzLlL/2bS2+o0enzot0OFwwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1731006343; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gjkoh1ve14eQlYzW025BtfwFqgem2MNKxhWAvUgpeyE=;
	b=KCroxt8c0r4yL06ja9O/g5yU7vN45ld5Ne3tIXcFW3eQCJ/VxgWkyltBHsJwMWmGGrTtKJ
	5sGkyO7P71k/vnvBYXwBNGFk/cH0WfWE5tLLEAhhaljt+bIGDcJU1LFPt1KZ6Xl3WxBTci
	tsRIS32N2/OAuUx6gxm/oFG8ojLQ8xQaGghpwOioB6eA1wJ2XsoKzNx0d3fUwd2GjEWf5r
	0JfWzgd90Dwdhn1QZasXVA2q2OJy79rYyleov38n2layiLXNo2f9XgKUehUym7eiV4YRkM
	v/lHDMZ46G8/RZNVf/KlzxtlIQdPm0Y489+2Qx7dCFkqPm7UfvvX9tlS5RzSzg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1731006343; a=rsa-sha256;
	cv=none;
	b=PSvdNVF/UOUynRd5NfZ+3wLPjpaGsA+O5jNobtGxmNSyPUTVESP8f4A84D9r+dc33v9/hw
	fJ3tUGJ0mZhgcb/OUQDxemN/Xd102kqSSj+pkP5OQOW+acCQrWTyc26EUxlU9hwDLfUcyg
	VMQ6iJBKA863dRDJOw5VgTvljADaBMApDu3TMiv/zwM7RCa7DkI5isbiq4fmQGua/36CaB
	PH3fu/m5tRT/HufXNlgrqXhqsiP2nfn+0jxDJ9kXkjy43QTxDPAeQNlin5+/Kz5ccEAMyY
	PLgS6GH3DpF+aLurLS0x1plulTScNSNs8qOqL8GUBMSxBHmvYBPlDL7h4ebSFQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
From: Paulo Alcantara <pc@manguebit.com>
To: meetakshisetiyaoss@gmail.com, smfrench@gmail.com, sfrench@samba.org,
 lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com,
 linux-cifs@vger.kernel.org, nspmangalore@gmail.com,
 bharathsm.hsk@gmail.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH 2/2] cifs: support mounting with alternate password to
 allow password rotation
In-Reply-To: <20241030142829.234828-2-meetakshisetiyaoss@gmail.com>
References: <20241030142829.234828-1-meetakshisetiyaoss@gmail.com>
 <20241030142829.234828-2-meetakshisetiyaoss@gmail.com>
Date: Thu, 07 Nov 2024 16:05:40 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

meetakshisetiyaoss@gmail.com writes:

> @@ -2245,6 +2269,7 @@ struct cifs_ses *
>  cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  {
>  	int rc = 0;
> +	int retries = 0;
>  	unsigned int xid;
>  	struct cifs_ses *ses;
>  	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
> @@ -2263,6 +2288,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  			cifs_dbg(FYI, "Session needs reconnect\n");
>  
>  			mutex_lock(&ses->session_mutex);
> +
> +retry_old_session:
>  			rc = cifs_negotiate_protocol(xid, ses, server);
>  			if (rc) {
>  				mutex_unlock(&ses->session_mutex);
> @@ -2275,6 +2302,13 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  			rc = cifs_setup_session(xid, ses, server,
>  						ctx->local_nls);
>  			if (rc) {
> +				if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
> +					(rc == -EKEYREVOKED)) && !retries && ses->password2) {
> +					retries++;
> +					cifs_info("Session reconnect failed, retrying with alternate password\n");

Please don't add more noisy messages over reconnect.  Remember that if
SMB session doesn't get re-established, there will be flood enough on
dmesg with "Send error in SessSetup = ..." messages on every 2s that
already pisses off users and customers.

> +					swap(ses->password, ses->password2);
> +					goto retry_old_session;
> +				}
>  				mutex_unlock(&ses->session_mutex);
>  				/* problem -- put our reference */
>  				cifs_put_smb_ses(ses);
> @@ -2350,6 +2384,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  	ses->chans_need_reconnect = 1;
>  	spin_unlock(&ses->chan_lock);
>  
> +retry_new_session:
>  	mutex_lock(&ses->session_mutex);
>  	rc = cifs_negotiate_protocol(xid, ses, server);
>  	if (!rc)
> @@ -2362,8 +2397,16 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
>  	       sizeof(ses->smb3signingkey));
>  	spin_unlock(&ses->chan_lock);
>  
> -	if (rc)
> -		goto get_ses_fail;
> +	if (rc) {
> +		if (((rc == -EACCES) || (rc == -EKEYEXPIRED) ||
> +			(rc == -EKEYREVOKED)) && !retries && ses->password2) {
> +			retries++;
> +			cifs_info("Session setup failed, retrying with alternate password\n");

Ditto.

> +			swap(ses->password, ses->password2);
> +			goto retry_new_session;
> +		} else
> +			goto get_ses_fail;
> +	}
>  
>  	/*
>  	 * success, put it on the list and add it as first channel
> -- 
> 2.46.0.46.g406f326d27

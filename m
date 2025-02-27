Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22BE1B4241
	for <linux-cifs@vger.kernel.org>; Thu, 27 Feb 2025 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740674023; cv=none; b=rkZ8qDaLAaHl33w338FRnukFunRW+pf8aI0zBm6Lp6k5kmcDyAxuZKns9Z4HfdW/nRvEBEgjW7ZFjfvc8uG+InQjmfoHMfHB4xowQGC3Dt4dSQZRZq0kZv0LYqMTYwQGar5MfOD5pIe8GrHlRP/Q0n9WRGNaalawRBNEHAtCkUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740674023; c=relaxed/simple;
	bh=lxaF58KPaFVMe3vikN4StyN1JXQCaUBw9iXH7TfoXmM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=C04lCWZjoULUg4zQs+cHiPWRhmzctMh3DIQL4F3TVN2Rs8qW1Z/Qb5LT/ikkfVrou9buPa4HkR/M0rgE6fTL3XqLVi9kISOfpcOBorsI32vcTDF27BmwTaIBkeeuuk+6GlGp4R3OZoOLXfAH/96OCbZspnJK3SQ+f6LO71NCU8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=JgRyoZr3; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JgRyoZr3"
Message-ID: <880cc89622306730dda9ff471e9bb896@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1740674014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g5DidU6iKoNssVdddsV47pdEZzG2MRw2eN7qzj3tQck=;
	b=JgRyoZr3ze+OYdMFphzXVaWfpG1bGH0PTr31Ri8zxIZAIt+z9KBhK/vIRf82WxU7gbdKQq
	/2+FyqQNAtKtTlR1PbR9XiFve5XNDWafh7p1PSmNJH0gJ2xKgobUcKPGB3AV8POJTDolJx
	n1jpy7HluJwjJwB10RJTzSrVj9cTBfAew2cM+UHGn7QpNVHXDeJQ+ODr4DZxzmKGvgkx1I
	haw5OCjU/cVfoKtmL0awBPEtu9+nQtelWtpB8RZhWW593JXPa8o10mb9MpmN6yKQEFxeDr
	fmG2P5Ab7PB/cXATLJVu+iqIffLBFbUauWRoO4AaPUUQDZ+8BLxkC+u8ySTKpg==
From: Paulo Alcantara <pc@manguebit.com>
To: aman1cifs@gmail.com, linux-cifs@vger.kernel.org, sfrench@samba.org,
 sprasad@microsoft.com, tom@talpey.com, ronniesahlberg@gmail.com,
 bharathsm@microsoft.com
Cc: Aman <aman1@microsoft.com>
Subject: Re: [PATCH 1/2] CIFS: Propagate min offload along with other
 parameters from primary to secondary channels.
In-Reply-To: <20250214124306.498808-1-aman1cifs@gmail.com>
References: <20250214124306.498808-1-aman1cifs@gmail.com>
Date: Thu, 27 Feb 2025 13:33:29 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

aman1cifs@gmail.com writes:

> From: Aman <aman1@microsoft.com>
>
> In a multichannel setup, it was observed that a few fields were not being
> copied over to the secondary channels, which impacted performance in cases
> where these options were relevant but not properly synchronized. To address
> this, this patch introduces copying the following parameters from the
> primary channel to the secondary channels:
>
> - min_offload
> - compression.requested
> - dfs_conn
> - ignore_signature
> - leaf_fullpath
> - noblockcnt
> - retrans
> - sign
>
> By copying these parameters, we ensure consistency across channels and
> prevent performance degradation due to missing or outdated settings.
>
> Signed-off-by: Aman <aman1@microsoft.com>
> ---
>  fs/smb/client/connect.c |  1 +
>  fs/smb/client/sess.c    | 10 ++++++++++
>  2 files changed, 11 insertions(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index eaa6be445..eb82458eb 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1721,6 +1721,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>  	/* Grab netns reference for this server. */
>  	cifs_set_net_ns(tcp_ses, get_net(current->nsproxy->net_ns));
>  
> +	tcp_ses->sign = ctx->sign;
>  	tcp_ses->conn_id = atomic_inc_return(&tcpSesNextId);
>  	tcp_ses->noblockcnt = ctx->rootfs;
>  	tcp_ses->noblocksnd = ctx->noblocksnd || ctx->rootfs;
> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 91d4d409c..fdbd32a13 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -522,6 +522,16 @@ cifs_ses_add_channel(struct cifs_ses *ses,
>  	ctx->sockopt_tcp_nodelay = ses->server->tcp_nodelay;
>  	ctx->echo_interval = ses->server->echo_interval / HZ;
>  	ctx->max_credits = ses->server->max_credits;
> +	ctx->min_offload = ses->server->min_offload;
> +	ctx->compress = ses->server->compression.requested;
> +	ctx->dfs_conn = ses->server->dfs_conn;
> +	ctx->ignore_signature = ses->server->ignore_signature;
> +
> +	if (ses->server->leaf_fullpath)
> +		ctx->leaf_fullpath = kstrdup(ses->server->leaf_fullpath, GFP_KERNEL);

You're missing NULL check in case kstrdup() fails and also leaking
@ctx->leaf_fullpath.

You don't need to kstrdup() it as cifs_get_tcp_session() will already do it.

Simply assign @ctx->leaf_fullpath to @ses->server->leaf_fullpath before
calling cifs_get_tcp_session().

Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21866F30C
	for <linux-cifs@vger.kernel.org>; Mon,  2 Dec 2024 22:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733179247; cv=none; b=tNc/Nv65qFVSgJsjG48kbts/KHUv2/MOxJnxnlqD76JZfM1Hrhw1RZNUJzJtjVoVx1P6pmyk8Y7aPfytPNlbVrvWYVzd6/JjwNbNs0b0+RG8RvF5IGCTw/srXK8cRgtOJ/AbQ53S7vecXUVlOC99XfFmB8vjkyfCCGqBDjfTAQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733179247; c=relaxed/simple;
	bh=UDWB4i9zA0iElfSmtvbNyvNH3C3kZ+x5vkDcnzSR6mg=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=dGLGjWfhpLk5e5f8bcGHI5Gfsln1yGuJCcOwUqpAj+vw5ETuHOjwkEdFM0iOwxh7ihAgV8XmjoZGFxCTMsEJj5xM4EeKaU49H/8znWKyTd3rPI14l0UPKoy21fcfjKXHDBKrGFBeOQyad6b7lGA5myD97/KagmGbBxOlqdMy6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=P/sedAWm; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="P/sedAWm"
Message-ID: <0a8569561645ad202c5cceba02cda93a@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1733179237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iXJzFwAJ52p7a8vbN8jLrQUAFsED+Pn8hmrw9pCNDkY=;
	b=P/sedAWm1ofz6Oqcj8g8dn64AqwJxsuNsHlMiH6pZNdu/pSvzOAMDI5BzHhwlcmGwa5+Sm
	6p87pNI/XRlkx3WfsVUJC+Hu/SaRbo4uCo3H0BP7HlKyVwwPQSVZ0v9FgaUA5AM/rbchRo
	a07L3whx3Nd6seK4jKnum8kGyX5z5NQZVYxjwBL7HGPwkfBUe65QnP1ltqcB1B6Davv7Jj
	UOTEmGQb6kBo3IfgJJBRbxx7nwpT0bQpgOrJx46vZ5n43sjA207yA2PYNoeIyiuI4E8xGq
	wSXGir5F6yozIArBrbjZaTbP8x+6rAa05Z8uj4BovD6Z6ZZWmmo1lCpzhuUIhg==
From: Paulo Alcantara <pc@manguebit.com>
To: Ralph Boehme <slow@samba.org>, Steven French <Steven.French@microsoft.com>
Cc: CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Special files broken against Samba master
In-Reply-To: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
Date: Mon, 02 Dec 2024 19:40:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ralph Boehme <slow@samba.org> writes:

> I'm also optimizing away unneeded reparse point queries 
> (create+fsctl+close) for nfs reparse points where we only need the file 
> type which we now get and use via the smb3 posix type.

Awesome!  Yeah, we don't need to revalidate the special files with
SMB3.1.1 POSIX as we can already parse file type directly from query dir
response.  We could that in separate patches, so no worries.  This will
definitely help with getdents(2).

> I'm sure I'm doing things wrong. Can you help me getting this across the 
> line?

Patches look good, thanks.  It would be great making sure it didn't
regress against NFS server on Windows, but Steve can do that.

Thanks Ralph!

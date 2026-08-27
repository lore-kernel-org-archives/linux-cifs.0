Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF93F3002AB;
	Thu, 27 Aug 2026 02:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787797322; cv=none; b=QLBoJ9lE0zPKy3R8TwADjoI6Kl80llpjU3XFVbYJQHbsZmiZcY6lkQVHY0d39X0pMIj0t7aCX+hQNrxXTUZ6kmqbFQcZ7xYdSYkEN4l0cGUR77iKyi/GBUw8Geo4XIGtOd1HYix+jx1HQp2PXFEJRPLBKISohcSM5rg91IxyCPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787797322; c=relaxed/simple;
	bh=SqePja7J/dEwuLLdIfh3YM2PPXtRMbBxzfhKtZRuQlE=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=k6vfHnCrjO6yCgpEGUVsUvr42CjApOCLDz9A/XcZ+orf4eugFOtV2oRleW70k3QZDwngQoFRDwxtaM8ZtFUdAhaxGREnN51CFvkRoMf2GPUBuehTnXrCQoL2Muk1aoAmLV2FNGo3HcDw7rvrMPXFu4kmpUUz6uxoBufxWc7PqQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=7dkyYzcV; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="7dkyYzcV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=QmPQRrUM2Ux/UrcDLf/3vOa5K/fkoAKcK35/7yi/VJo=; b=7dkyYzcV/tdEy7jNtilRZ4pE2Q
	w7RfQ7Vz1OslifSoT2bOJxzBSCqeaqdh+O8ZBTr6cKkldHhTdLg8KthNAnQBWG5aKTEDHQK8htidh
	5GJtAlmFLMzXrc+8QS9mv2VhR+DPgwCoRsO8tAuEH9ah39HvA8AuSpdCgvNJG2rqS2+qi9cHLsDk3
	0y5OqGH7dZJ4j7pbJ7dd4YEinv986sTghXBjHOCEyP4rK1Lh6AgPkCaFJwPpVFvSlErf5wd2A++b4
	iWG/QKVBoqh2q8noVA+gL6rawbVN9GaHhQxs55g0PZBbz7ciWIKqHkucqYqsPl3+5L4WVYlP0JOnt
	X46yztjw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wzPkd-000000004ja-0Ea1;
	Wed, 26 Aug 2026 23:21:59 -0300
Message-ID: <07d440fa8ba8fcdbd8ca1b5ed5988ba2@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Jacob Shivers <jshivers@redhat.com>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Namjae Jeon
 <linkinjeon@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix multiuser mount with krb5
In-Reply-To: <20260824195912.634526-1-pc@manguebit.org>
References: <20260824195912.634526-1-pc@manguebit.org>
Date: Wed, 26 Aug 2026 23:21:58 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Paulo Alcantara <pc@manguebit.org> writes:

> Customer reported that they could no longer mount their SMB shares
> with multiuser mount option and krb5.  Turned out that the client
> wasn't duplicating username option when creating multiuser
> connections, therefore failing to retrieve credentials as
> cifs.upcall(8) couldn't find them in keytab.
>
> Fix this by duplicating username option (if set) from original fs
> context before creating multiuser connections with krb5.
> ...

Applied.

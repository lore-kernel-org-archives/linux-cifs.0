Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F288130B519;
	Fri, 20 Feb 2026 20:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771619800; cv=none; b=A3afqOk4QWQP9X4PeHz+LnlJDcvbVI1l08Q59qDOIGHWizNDKqHJTvaR/7ZDjwsUKdnIhcZGdJwPXF9W9vKT9leh3GImwI8s5az+Hje1zTSBvdQS4M8NFrOfuL9MKzR0MDwjTA/wDKkrketbKnVQDrUGz88L/UkaBdjinAVHx9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771619800; c=relaxed/simple;
	bh=c6+zxDtSKI3C3nD+fbh/LRl1VY9PBu86X6RNR+6wxT4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=u9MyMrcMyCLS5mZqZq8S0a3GLvNi7exf+u9VEVJlbPEGo4rLsqqFjU3q0WkmfbAd+9d0K+bZsWzLTOxmAGWOQ05V/Gzoour4qZVq1Q/FtAPyO645VKNT8JrZRCDbQKQ4RTkziet7NhYzgg6c/jeQugHplLkSoUPIQIHvpwPKhzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Euqk6Yj1; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Euqk6Yj1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CV0z7Mp/QMQo1Weov77Wa76AtbLbmxx2O8T2s/mHSaU=; b=Euqk6Yj1xgjNe0L3fQl4OnRyfL
	6LB2H5coieyYG9UqUxgiwOibXnaq/5bWfTwwReqxrQThESZF32QqbYS8VT9pGaifNvdncFL1Cvmu7
	dAcs7Z5+bFMrzleUrfRrrCdnVnEdYY9TPIroychaadQ1TbBcKOhCX7ISzjGcXTDnUcovcKjjRxMPd
	VMw9em20oK35DebeDVRahUDw/YZi84uVxKDYSKLT43mzL1FY2FRbxAYd5eFWaFLAggUNtayZjOzqS
	G6U9kRlW/g5H1fpy7LSG4jl5FKh6u61m9V5SQk33HRdZow9yB7Nw7SIpgFkMxcloBHssyGlrj2Hk1
	HwtU2aqQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1vtXEo-00000000VQQ-1EPS;
	Fri, 20 Feb 2026 17:36:34 -0300
Message-ID: <44a65a89898b00be475d1906182ff32c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Henrique Carvalho <henrique.carvalho@suse.com>, sfrench@samba.org
Cc: ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org,
 Meetakshi Setiya <msetiya@microsoft.com>, stable@vger.kernel.org, Steve
 French <stfrench@microsoft.com>
Subject: Re: [PATCH v2] smb: client: fix cifs_pick_channel when channels are
 equally loaded
In-Reply-To: <20260220193505.553838-1-henrique.carvalho@suse.com>
References: <20260220193505.553838-1-henrique.carvalho@suse.com>
Date: Fri, 20 Feb 2026 17:36:34 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Henrique Carvalho <henrique.carvalho@suse.com> writes:

> cifs_pick_channel uses (start % chan_count) when channels are equally
> loaded, but that can return a channel that failed the eligibility
> checks.
>
> Drop the fallback and return the scan-selected channel instead. If none
> is eligible, keep the existing behavior of using the primary channel.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> Acked-by: Meetakshi Setiya <msetiya@microsoft.com>
> Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
> v1 -> v2:
> - Remove unneeded max_in_flight and associated code
>
>  fs/smb/client/transport.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)

Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

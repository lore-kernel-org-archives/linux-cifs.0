Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BFC28B516
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 16:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750348868; cv=none; b=moF2XqyQVsBUfCjZB2YUO/GOnsFrrNk58Ov6tc2H3+Bhrc9CHsmMVpcNWfn1oyMA6/qyU4g7Crf9+FmHb5dSAqTcE2qJhPb0UDuXBXPKZf/zyouLvEmjHKg83ipJSNI7MkDc3fOUhjj0QZGMYghslMph/KdYDP2YKCFUYxdrdVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750348868; c=relaxed/simple;
	bh=0XnP/wHCdmbuGtfOIumyJqadlZDQclJpNGdGpeSv/ok=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Rc2Q2JEdLHpshpgYwxAfKv1kTEm7ZPZmjkLc7JpR+HjbqIUnXA7yWoU045o5m96bg8QGmzyGJkYv2sWIErb3EeLotHd7vmHn12OvxFoQa1MuucrEp+VWgObQqbBdNvXbXIbT89NBKmFnlATvj6MvuZqKbDc8Bxp+PGjlFsbNqL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=rNJh2D/J; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="rNJh2D/J"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jztLd+sQi2Uxx3tFqmqmV9FIwO4VsVB+0PHsUt9ZBPg=; b=rNJh2D/JM/DtFNOG3D5oTNxkqW
	qYrneF4reZYcob7Cc82a2qKa7RvzNvKXV7bWFzZ5JvDYJkJ7oppANytFz5mUp5Rcab/57e4GhZLDc
	IfCsdnw10e6q+9qLbMWj65VV8qGUyUafDVNHY20z9tyNZQY20KQV8UdVHmlfhizDDE8yFSH1mEog9
	8SDEjA/6PskcbPkjIYZM3G9Lei5zpsj1TtFBj2xQZ0FIO4Y5KhSgtcPMTEU2gt09VBgiVhH3bIwZ2
	fmBhgPhHHfpqeJrryM9NZ3DSJgJOe1JaL+8UXNrzANf904tyVm/RXthd5mtxnxlsiJGebcWXwtx7j
	EmKyw0/w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSHhF-00000000Hgb-2RFx;
	Thu, 19 Jun 2025 13:01:04 -0300
Message-ID: <804a52779d6988d1d434680002ca4d64@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 6/7] smb: Fix potential divide-by-zero issue when
 iface_min_speed is 0
In-Reply-To: <20250619153538.1600500-6-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-6-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 13:01:02 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Address potential divide-by-zero issue when iface_min_speed is 0
> by adding proper handling to prevent undefined behavior.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 2 +-
>  fs/smb/client/sess.c       | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Isn't be7a6a776695 ("smb: client: fix oops due to unset link speed")
enough to prevent that already?

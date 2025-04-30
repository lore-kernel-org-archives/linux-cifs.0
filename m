Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141E01E4928
	for <linux-cifs@vger.kernel.org>; Wed, 30 Apr 2025 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746040495; cv=none; b=pTAvEmHQr+Oymi7cVg7CF0pJgi1YODTlaQdiaQs1RNnazqVMb2FaZVpHd7eLF5IttnYyIm1eyVEveAYjIziocV9WyKm1g+8y2w+sSh49QVkGELl5U+Vi3D79bXo/1Nvkb/MVYWAJ45L4A9K9CBepplmTvFKPjCYtj+E98gETLC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746040495; c=relaxed/simple;
	bh=Wiq1XZgCNw6ng1CwHSMSnagcLIpLQ8xoP7WZnntMbE4=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=loyjZWFcDtxhYCF3rhcCGX4Pxn+BCL4UraesK/ulKV86GN46J/V1X5OWlzUazypOrhcBueyyke1G9tiBCPOgBGs/RGiXyHTIPhOhq8o8q6+JuzNMWsZ/WEIvxXtNml3vZNoxyuHS75nWcEjQoflg+JhnN+Y3oM/xuVARA79RsXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=cohxyXfH; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="cohxyXfH"
Message-ID: <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1746040486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RCZgqHCWJogvZA748Ja3JB5jVegfNyv+JJkPqsKqgKQ=;
	b=cohxyXfHO1lKUedYMohbeIYG7rmGmV5QmpLBzvaCTpvkXyYFt3CucBsdqn0kOp/W9V1PKB
	VnRNUkAb1CvzhWBKyeB2HwPac9Gf8VSU9/98kuesOxtV4uO65eM/4x0/sTR3ysUis0M7g9
	xrTn1NxPkfrjxpN4rc2vDtUXqFqKqRifOiMcmevBZ6wGyLzO8vRnzTJj/LVXTZshV02/Uj
	NCLcYCosWeaT6mHaGHkvCMY20jZm4sbBhMLew53OaJP0seaH/Jl6O+1i3boWEYh1xnK3B6
	/mBwOIBs7wIlzAwgKWoBidCw3eD+WVfl5VRkKRTIdtJB5jBR6ILZynelSQCBKA==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Pierguido Lambri <plambri@redhat.com>, Bharath S M
 <bharathsm@microsoft.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
In-Reply-To: <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
References: <20250428140500.1462107-1-pc@manguebit.com>
 <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
Date: Wed, 30 Apr 2025 16:14:42 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Did you mean
>
> downgraded "RWH to RW"  or downgraded from "RWH to RH"

Downgraded from RWH to RW.

> But it is puzzling why file would still be open if not in openfile list

The server is breaking the H lease.  cifs_close_deferred_file() will put
all cifsFileInfo references from deferred closes in the inode, meaning
that _cifsFileInfo_put() call in cifs_oplock_break() will effectively
put the last reference and then closing the open handle.

The check for a non-empty list after that makes no sense as we already
closed all open handles.  As I understand it, the implicit ACK would
work if we have no open handles at the time we receive the lease break,
but that couldn't work as we always get an active reference of the open
handle before processing the lease break.

What am I missing?

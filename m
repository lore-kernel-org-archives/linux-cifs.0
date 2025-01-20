Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB2D18FDC8
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 16:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737389267; cv=none; b=sy4wQ81NqDqebHaOS4LhEOXaVXKnfxyC+hLOI2o606STj3y28xtsW/7/r4MmCJG8myggFzhFSvp4J3bDfxJt22fmSqTie49SuiYQG1tZ1ZN2WvoVu2QKG5YrJ4LtBt2QU7rrcpj3o8VufyPQ7RBPLCArOOvDNXi0zc+Wz9U3xFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737389267; c=relaxed/simple;
	bh=v5MAlJQOokMUtg+9gP5ohNawiadvKfbWxhPA5bxwM5w=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=Gga5HPY5XthZ1pRBgnYcfJoclzLiqqIOjrWmqE2tEjYgqPyIpUHKx5wzbPykJSfdOrDoGj1d3hSHNx1+3boSDkBRhiBirEY7wmUQs5QbwREFXPzySXBNXM8ObSfBvUZTtTBEBdzT/Rx3ht4vpXZhLCqsmg6whtHqDir3IllYjJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=REfpcdTX; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="REfpcdTX"
Message-ID: <90e00aca77426f60e0a3d563c8644d6e@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1737389263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R/FSLbGVdXwbSLd8lj7q3T+GQbkLHe5oFzihBHBViWg=;
	b=REfpcdTXmxq9E6selRR+f/JcRAzn9MQrDT0BFJyGBqIp5ZfEqt6kzD4kicsBJ5DaV+0eA/
	5ahnEaK4PcoOGCS2gtx2Jb7w+3wJxmFtcUUsRZHgdCv3HjAXF4TTrPqsehYsJA6Ksvw2vR
	KL8QdwqSrp63XZ6K92KFrQXCmdFeE5fOm8HcuHmoV4plPZlza1Q8/G1NhKcakLrSY7CfK/
	vXOj947qPF/+FMjvn6mqdij0shL0+olwQRqE2pQ/1UZLlWTUl/V5H9EnbMgCWDO1XeDEmq
	m1FiQgrkL1iXL3+FVZJpVZofiYE8JRf+uL/Ur8eLbKkGB6Ex55fPXhxlWYFdvg==
From: Paulo Alcantara <pc@manguebit.com>
To: tbecker@redhat.com, linux-cifs@vger.kernel.org
Cc: Thiago Becker <tbecker@redhat.com>
Subject: Re: [PATCH 2/2] cifscreds: allow user to set the key's timeout
In-Reply-To: <20250114203509.172766-1-tbecker@redhat.com>
References: <20250114203509.172766-1-tbecker@redhat.com>
Date: Mon, 20 Jan 2025 13:07:40 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

tbecker@redhat.com writes:

> From: Thiago Becker <tbecker@redhat.com>
>
> Allow the user to set the key's timeout when adding a new credential.
>
> Signed-off-by: Thiago Becker <tbecker@redhat.com>
> ---
>  cifscreds.c     | 17 +++++++++++------
>  cifskey.c       | 12 ++++++++++--
>  cifskey.h       |  7 ++++++-
>  pam_cifscreds.c |  4 ++--
>  4 files changed, 29 insertions(+), 11 deletions(-)

LGTM.  Do you mind to send a patch to update cifscreds.rst with the new
parameter so the user will know it should be in seconds?

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>

Thanks.

Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5A8259C80
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668933; cv=none; b=t2g+jXl+X4bCG1irNw8azGcOmFMO7f5nIzI+UghsRC9n5wvrsBKdadKSz6A8y5AAMpiFcTfg1i4iAeWDcpsoqIlwa2qhr97qfgbH5grJXsf576nyyKgug2ziyr4fdpkJdHKQnbOHMLp4+AiRdMdYRQ+f25WbWa8tULmOnjTj8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668933; c=relaxed/simple;
	bh=a4xn6OajFz88mWFS6XsIfIqvMgiS6yNN2n5C011NaLM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=tIEoscSvtVe/9Xf94eixZObsDst0e0J7dcJ1hHYVDjWU4+S2EErGNlTABon4QQPEc9Ex5FprMkissOtGHmrLSGCI6bMCWbJy7ec/wgIBRG37IUxTVEytgrlP3NtqYzr8s3QA33U6oUQtFWdYP83DuvfMVf3mZQWuhB64Yt84okU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=cxmsd9bT; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="cxmsd9bT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a4xn6OajFz88mWFS6XsIfIqvMgiS6yNN2n5C011NaLM=; b=cxmsd9bTOOQTbEfagDIHs2zypW
	/GDnjuIv0+zOupnNGyhS+rguR54sXIisBYokNiplrpw7L9Wy7cBrS074/YGTBRjYJhR9pxKzl5rnq
	ulzGYeLnusGBobivCBTBQ0qg92vThE72Qvj0ldERiIVhuTVUXdAhLPug5D4mDYU1XrtbSzkaLGcQD
	syyDFTJstdko/M6wi/3LVJq+Vef2W9fktEeG1zzwAFRbgrrc4PtMBX9RHnjnQhc2qtm5AixaKx1aY
	YsHp6c/gxhrWHWBjAtSoojQe1pk88KbIQcW8GQ5M6qEqzcZpW/iDJlZW3EsQLuYwndSoQsFggkmzO
	uouxLn2g==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x7Gdr-00000001fow-3Y7z;
	Thu, 17 Sep 2026 15:15:27 -0300
Message-ID: <d7a588baeab48062b417b5c99c5dd7b6@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Frank Sorenson <sorenson@redhat.com>, linux-cifs@vger.kernel.org
Cc: linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com
Subject: Re: [PATCH v5 0/9] smb: client: fix OOB reads and UAFs in SMB2/3
 receive paths
In-Reply-To: <20260916213406.1496960-1-sorenson@redhat.com>
References: <20260916213406.1496960-1-sorenson@redhat.com>
Date: Thu, 17 Sep 2026 15:15:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Frank Sorenson <sorenson@redhat.com> writes:

> This series fixes nine bounds-checking defects in the SMB2/3 client,
> all of which are reachable from a malicious or compromised server.
> ...

Applied.

BTW, The Fixes: tag in patch 9/9 was referring to a wrong commit id, so
I fixed it.

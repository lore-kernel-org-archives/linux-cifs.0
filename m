Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F6311712
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 16:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750349165; cv=none; b=BxllGqgCj2jGmDTJMOxMYNMKvMilq9m9vLmACUZ0/3GscQVXwHTSj9QSymaPx4htOE0OjaCsvNtMUU/wrDlDp9tzAd+fu7kUMbs/6F7g3yZhSTqGxDSAdkvR4jcPkT/1WqsppVa1UkFa6oKT56uo7HtoMJXwWamA+5BvP5bLN7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750349165; c=relaxed/simple;
	bh=bQmm6UG1a6CARhat9vSE9h0brhqUqGXrWps2ogldw/w=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=UQ4JZTUSeXglgnSH2j5lURgceGDOvVz1lQyLjn+IKmrBo1RpjVVx3hop21OVwDNyiSchRUNaN46jTaf8a0cxSYpqdazf046P0aqBaPuI2XRlNkmSIKWo6mbIm9TfhhzbMv3xcrrRNLPHhRaesGq8BLi+nHeutr2VYELA4F7d9GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=JNMA57j+; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="JNMA57j+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=6TsxXf0YgC5lbTo3ZWWgh+FHLroIitoPTlBn1XLhHiA=; b=JNMA57j+gKzb3uSThbsLdLq9Lh
	IgMDwCSheq5It7sbAsEH59zg+mmBmg5Ar/yLiL40a/Gzjg8dsH2mdPBBJP47EaF0ws3hBFnCK6xiM
	oX34aGClI0oqKXCcyjBhwLPDiERzuHW8G0v9xRUAaxm9zykRm7wWanR3cJgc/6QPptTLRGVoHTcsE
	qCpq/YWoWUmuUmD8qDCpQE5ilOYHe5qYpxRJ3BP2AtA8ooywQXZXoDkSLuqkOrTEd2f8nmeIhisYS
	xxmlCvZtCF+qwqleVHarf4oKsoQhIBBYVCSkhkhwC1wbRoCIfv2i00ipJehpKiXcr2+Y/xHfwHBID
	FfdIIqQg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSHm0-00000000Hhs-0mk9;
	Thu, 19 Jun 2025 13:05:59 -0300
Message-ID: <a3ca2505d715137333d5f053bd06e1be@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 1/7] smb: Use loff_t for directory position in
 cached_dirents
In-Reply-To: <20250619153538.1600500-1-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 13:05:57 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Change the pos field in struct cached_dirents from int to loff_t
> to support large directory offsets. This avoids overflow and
> matches kernel conventions for directory positions.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cached_dir.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

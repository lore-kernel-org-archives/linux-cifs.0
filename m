Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16F72367BF
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 16:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750349187; cv=none; b=TW3jNZvL2u8DUOK7n+u9B/jaorxW0xPYIr8mR+ySr72uskIWzz1hLAxO+8O+B6ZwasbFVhIMKB/ubTojqag1gQ4lPIx9EK6n5nATGQ8CsUnlIi3mWyRRqluYe26QSYS968KtRB+gYutL/2JBhW5HLVhpde9CXRvrof0tm44tXnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750349187; c=relaxed/simple;
	bh=PQqD04r1ICkO7fp2FqQJTLJOssF5Ff61uRSyTAQZ1ew=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=MAtATksQPflatke4ErnUoADZW4U/U8AqhistDAhkV6Y9lpwfnF94n0sa0hTIWu++JTIC9ykvHuUbu3O19+vTJXZVypUDEa0judXPZ0tMHv4ozNC3Q+mxJfSqEja2FghM+RenWsHRDuCuBrMKIDSydN06eCUjZaCmQKqN+Le8qS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=h15eKzBT; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="h15eKzBT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uinM+GYwl4otB0hDKYkYfK96wzINRzK9oxukzxANt6s=; b=h15eKzBThTyGGOPCEPT7I4kW+r
	5bcva4qNySa40QGmTv2hBd49k4Gjdb59PDvRCfZDHdf6fNR/H8UCEKccomuWQndDJ68V4/9GgE+VD
	0k5CPQbO6Gk4kLZxfEkwferffUuAhNA1VcC4X7Bol3gY/LjGEKLeRR/i2XPZ6MVVHQ2BdlfleItjj
	ErgioizMCpxlssHcvL4XvbMkYug5lOnzjKSqjuYF9PPKHMnZpIfrMJ12gP5Il804zI8LXiaDwWpYu
	FIj4h0XF7cL5m+pLP8urbrPhipa50I0T5Czq1+cZqbsaKqqYbN4Mu6hMQHDX/MvALkYVkEt7OI7ZD
	V9EfzRlg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSHmN-00000000HiC-3EJL;
	Thu, 19 Jun 2025 13:06:23 -0300
Message-ID: <3f3899dc518a44347641b893174918f1@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 2/7] smb: minor fix to use sizeof to initialize
 flags_string buffer
In-Reply-To: <20250619153538.1600500-2-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-2-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 13:06:20 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Replaced hardcoded length with sizeof(flags_string).
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>

Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EE821E098
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 16:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750350277; cv=none; b=ly2Gr9d7R/hkgRs1EPr6izE55aU5xefqu+tuI4QSzjrwReActjgh6iBR+F2e0ipRsACa9isnKObJrJuR4qAboPGuWaEsaIqifi+RSfXSM2uLIyl1PRVz3hMkRsoQ+UN5h8dmnrnS84DUTt6KFvN3o8wRtXH9tqePk6tMdXbUpQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750350277; c=relaxed/simple;
	bh=4/dkHk/ZhZg7/meJ4bZY+t+kRFdfhWSn8C1fTjOZmUM=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=WmTxai2jiEsFh8DVNWTQY1mqa5oNbFbo7TKCPFmc0TomNCPaClzHlH9pcEZ50hGX3BLbPJOBTyRdWkestNXcNBvFkzI/99IJ7W3y2JKYg8pl4txZ4UWBBdiwbY2EFbgWTroYsV2dfWooNv71uZewpFFDBQRZnKvc13wfd7e3HBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=4WW6FYmM; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="4WW6FYmM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=m6szuuvuIsy9hXOqIKtAIaJFgavW3kamhBoVlAEsf9U=; b=4WW6FYmMwkznThTqGRNz1jcojh
	I8iiQH5IOSX0IaT0LqU8m+ItLUD5A/FmcPQZo/I2uxDtw0EP6aPRrejyuX1du0K/b5R/1dgjl9vyX
	SbbfxBcZ8gr8HFF8+bjwuf5KdlOY6y5NFOPTiZeX8wVSb5xFoHVSb9bpYGbkRwxhPK6R5yBInLF3I
	0VzW8+EKTPuWEtE50ftreifba72vjrTW4kgzi9qgSyKjKin2JgnPRjZ2xJzieg6JfmmQEj1qSyhQg
	1Y3E+/IEz55Owy3Q4fKtHQuXdCZFQinErlVeNBzSF24InBPx9clq1RjvrXwwPNOs1PUSTeAG4kNGI
	jslUmu8w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uSI3y-00000000HkY-3L6h;
	Thu, 19 Jun 2025 13:24:34 -0300
Message-ID: <54184af46fa389c51312534fe05994b5@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Bharath SM <bharathsm.hsk@gmail.com>, linux-cifs@vger.kernel.org,
 smfrench@gmail.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 4/7] smb: add NULL check after kzalloc in
 cifsConvertToUTF16
In-Reply-To: <20250619153538.1600500-4-bharathsm@microsoft.com>
References: <20250619153538.1600500-1-bharathsm@microsoft.com>
 <20250619153538.1600500-4-bharathsm@microsoft.com>
Date: Thu, 19 Jun 2025 13:24:31 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: 1.1 (+)

Bharath SM <bharathsm.hsk@gmail.com> writes:

> Added a check to return -ENOMEM if kzalloc for wchar_to fails
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_unicode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/client/cifs_unicode.c b/fs/smb/client/cifs_unicode.c
> index 4cc6e0896fad..7bc2268d6881 100644
> --- a/fs/smb/client/cifs_unicode.c
> +++ b/fs/smb/client/cifs_unicode.c
> @@ -466,6 +466,8 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
>  		return cifs_strtoUTF16(target, source, PATH_MAX, cp);
>  
>  	wchar_to = kzalloc(6, GFP_KERNEL);
> +	if (wchar_to == NULL)
> +		return -ENOMEM;

I wouldn't do that as there are several places that rely on
cifsConvertToUTF16() returning >= 0 and some other places that don't
even check its return value.

What about having it defined as

        wchar_t wchar_to[3] = {};

and then getting rid of the memory allocation altogether?

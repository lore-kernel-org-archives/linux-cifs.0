Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA8F3624CF
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 03:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785209791; cv=none; b=Uur1SKJWKb16GagCYtbJ+T7baCLE50CgNm2E8Ia88jJghW+eewzKIs+8Zmsg7dLISiX1KW8xtWVrpnXIlercpvlnadoPhe75ez5skWTj+P2b35vZ/WiyEPomyNEoFbEpBsZCGMEnm9OdySOdb1EqZE9XyeOQTDHZGTm1EdM/Xto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785209791; c=relaxed/simple;
	bh=OTD7wv7FeR8GLOEaT6IZGRuGhp4u0xCHxWR1ZHFXpS0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1pnMtgU80UoAFLnoC4Dq//s8/0aMh1H8BJXRTVioRdidD8Jv6BHld3m1IH+9UkIv29JJup6gwc0yfInRjIX4DH7iEPRD1nYzuAJlgGw0Zt7S+wXPptsFJVKbvua1295qMcUu/FAJrLqF7gOyMQsj9cxxKowYth3uGZUeSjkoH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=unQS38Bl; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="unQS38Bl"
Message-ID: <31e5d003-9062-4654-b860-2a77f5d5c5c5@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785209784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4VjiNn+v5Ei4R+0mAbqthGjy5UxJTlVrw6N/5aa1+U=;
	b=unQS38BlxkeA9SFci8lLtKmtnm+tsZIGC6t6+hISFRqtlva8lZHfYswsoVj/5SalHLjPML
	IkSDpEDE26YK27izBULhjJ2VhMEV7t2DgNYsM5fJK9swh/ZuMdEqrCEh7IGJhrwcx+JjKp
	1izhf8thpptB/IOMYe9LlegtkzyDaPJyP7XebJ5W5hFrCIxfIqzFnx8SvcayA7h1sVLItA
	Sde3+6z0GBYDpV0HlwNHKD4iwJ/4lbfRg8CL5zFHQEHEraz52aE+Szu4StUGdzF4pDI5y6
	japS6dmu02cQfBVXN6AXFEZf0cSUQv0BIP2jXD1QL3Xty7eEFZbD9EfBd8dYOw==
Date: Tue, 28 Jul 2026 11:35:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 xfstests resend 0/3] add generic/795
To: Christoph Hellwig <hch@infradead.org>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 metze@samba.org, zlang@kernel.org, lukas@herbolt.com,
 linux-cifs@vger.kernel.org, fstests@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260720164207.732522-1-chenxiaosong@chenxiaosong.com>
 <amgh4bf-m25TSMSy@infradead.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <amgh4bf-m25TSMSy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Christoph,

Thanks for your review. There is new version:
https://lore.kernel.org/linux-cifs/20260724031210.332153-1-chenxiaosong@chenxiaosong.com/

On 7/28/26 11:28, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


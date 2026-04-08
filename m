Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A733A282F2C
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 06:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775629245; cv=none; b=DZZq+oPzT+xvO1vpummTfuJ0Tf5mqccUQhddYNfkk5JzqUQy0RO4MQR6wGQij6dmh6LkU19MtKMTV2vxA6vGfnJYtZWbFoyLMbuUktDIAvQyMpqDHI7EBWuyrKJDr9RBGgvrZodRj9ZjRNdjHwttz41brIYsCWG4bBynjX26JW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775629245; c=relaxed/simple;
	bh=MJl/cRTIP8pZSs9M2nxtYap1jFT7FTMYAzKzl07Be3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P1lSimyVsYYuabiI1edYWKW28R4a34ZYUPLC6bDTZ0YQHSb6MoxP8i8GCYmixo6TKjUKkl4hFLDRB/2BBP9w6MALfPQMCmsqqPhi49MKKZxJ8bypX1Xxb6Tr0FvRxaxcYCCRxaW9jALW4z3joXQXZOMjKXB1No0vtvX9zq8c50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mOKZfd/9; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mOKZfd/9"
Message-ID: <c7c0fcc2-ebdb-4ba0-9c64-fadbd57137fd@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775629239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kYU5bkJdbMIFqgaevph2uCBQue8kBmxDi1XOY4ekAsA=;
	b=mOKZfd/9GewPtrKBFwvYwcULUBdYAGYG2UHY7fMuC5B2MaK6eO2H7mcXLuDNQ42k+MT77U
	XgE6kSOwAVI5Cq0UM3LjQ7KDO4gEdUez0RM1hdgNoE9Z691qMTRxp1pPx6iPyfHYIcd8Ox
	xQK4cGFGtzzohbkcTnxs0Z/+K6mUGteZ3iJ0Wb2nfeF0zX+mOTYbGBJNdkrBgyexFAkq5X
	q/WVZvunsDIUGwI4XlaFX87wJA52IntZKjZVtLmJ8HilsLnLSSq535W5EzdPD2MsbcEQRu
	wXDJsqNiwva7HZb5/9YcQqmep2RmleWpLk95f+CFpTP1BTo1MTVsqCUh2IjKRQ==
Date: Wed, 8 Apr 2026 14:19:48 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
 <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
 <2026040833-espresso-triangle-425d@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040833-espresso-triangle-425d@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Could you send v2 with this check added?

I am currently reviewing another patch. Perhaps you could wait until I 
have finished reviewing it.

On 4/8/26 14:15, Greg Kroah-Hartman wrote:
> Ah, I missed the caller site.  Yeah, probably a good thing to check as
> well, want to make up a patch?

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en


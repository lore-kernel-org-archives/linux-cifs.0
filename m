Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7144727FB2B
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 15:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246372; cv=none; b=i3rVquWbSQ1O6V3tXmwhcP6/wilg161cBu5290yrceNr0XQGa4CkPASeFi4Ar6vb00TFpvpXUDlWxatZNYmpBH4lkFN2S0pArxCbKoLGgpn/Y2SrNfhWnEj5+MmiTxe/HHWP91lqWINEIKxfhwKtZH7YojmjaOwa4lCc5guSqHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246372; c=relaxed/simple;
	bh=w48l8me2Ns81SKF2jhLKw02EiW6nwdFjaxXdNXje0Dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bOaEM9OdLVrsFDz9Mdoxppccq71GcPP5clppWiYcrRNR0CdmWoMpJfSMCeYDpHVitNpo6sjKRSSVp2yM5i+0EQsKmKliiOktbhaiJQi4tW5HTDko7RsBB/gU9F70tCRXlqZ2OIxsakQiFJm9gmrLPSdlbWyTjqI5s9gnZ0GXe4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=d9zgaX6c; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="d9zgaX6c"
Message-ID: <d4af7560-6d22-443c-8cc4-c4937040e942@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766246368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Eje0CccxlXmaFbmAjW7WvHgwtCY0UBQWOTXHkxgUOww=;
	b=d9zgaX6cruQzY4AH1X8lD4h+plBnUKNRT5EhCJgzGWi23S1jQUjjW9to99luKdhQKsl2Fw
	K8cM+PSjo0OOS7tRbZx/lzSPE0s5OjYA2aLwjl7OwggZU0IIfj7EQ+TmiACTR2C+R5t7IJ
	ljMhojOX9GuKzP9XqT8Amhl84gz2ZX8=
Date: Sat, 20 Dec 2025 23:59:14 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/2] smb/server: fix minimum SMB2 PDU size
To: David Howells <dhowells@redhat.com>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org
References: <20251220132551.351932-3-chenxiaosong.chenxiaosong@linux.dev>
 <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
 <941517.1766243973@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <941517.1766243973@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/20/25 11:19 PM, David Howells wrote:
> Do you actually need two patches for this?  Though granted, only the first one
> is an actual fix.

The first patch fixes an SMB1 issue we are currently encountering, and 
the second patch fixes a potential SMB2 issue.

Thanks,
ChenXiaoSong.

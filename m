Received: from mta1.migadu.com (out-6.mta1.migadu.com [95.215.58.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD197416139
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 10:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786617885; cv=none; b=UkM7+3uWXn7IFniPyjBKVZbGTVDurmAoixIXAZN+ObpRti+NMEtgAq2zs6mGplRDShwREuwduyHFbiExT5qCqroK7ewFWPg9eIOl97vUK259TWIWxUSkgD0b0L9MOPLKYjazLimyuIp4+0qEeN0tfEfa/iXhkVSodNGZK1YvxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786617885; c=relaxed/simple;
	bh=MvhzC7e9cYU4JaoOTsPA8nGd5XvPVmENhEdhQPMPX1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1YuWsn2V8FpWQWVGK0sxve3NIXTZqadJDVvzBIIi4AXlFYDU8WCNqfCoNMjgqoCfwUBWagoiIfEFyrSDOM8L1RuaTB6AbaNyXlej+eb1+IPpyCdzgTX2VkhJkFjeyzF0XMituXN6svHWFNKL2Jc95HWOpYEMzmE7wf5iloGVH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=gh2gSvuO; arc=none smtp.client-ip=95.215.58.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="gh2gSvuO"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MvhzC7e9cYU4JaoOTsPA8nGd5XvPVmENhEdhQPMPX1c=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786617878; v=1; x=1787222678;
 b=gh2gSvuO+dPnoh8/VqE6BYLo9s5P47TnHycogZUgf/vY8uJ+yoD6zRXAU6Ely32UfqWx/z55
 Wt6B6oHY6flfCaw+iqYDSNNcKfW1wYRaZfEzWZ0OG5T34tJbEl84NK8QTnkvacQSO0t++6/xiBE
 ddmEhY3D9Cskeeh0B2ZEx75MeGOW5cmW2ERPDE8E7duKTzo4RXXfcil6cussVJdn+kVkA+nSD2Z
 iUmcEhBDD7R/XKkuRrkW62MbAoXZ77fCWc0dWAvgLeV6h0CNVKiWC+hkLPh9+7z/IJm1wifqoua
 cYIi8JMLqB8Cocy9tfm7q6sqjZfU8sJRf/fFAbKAcr7Fg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [IPV6:2408:8453:18:2afd:1121:d941:834d:a33c] (2408:8453:18:2afc:ac11:6e6:1a61:940f)
	by smtp.migadu.com with ESMTPS id 2b771b4d54acc1bb;
	Thu, 13 Aug 2026 10:44:38 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <76c86e67-23f4-457b-ba9b-240ac424beee@chenxiaosong.com>
Date: Thu, 13 Aug 2026 18:44:29 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
 tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
 <8ea028f5-90f4-4d21-b1ac-a343f0f04d88@chenxiaosong.com>
 <CALT=-86Z47htBZ6QjUZquDSMoeMYE1dswXVDSfAntg22p0ox2A@mail.gmail.com>
 <9ad355b5-5ae9-4dc3-98d9-cf46795d877b@chenxiaosong.com>
 <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-87Ziq01X+GLYXpOMThBMC6gcFLV3uaP1qy+k_vM6G+-AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The UAF issue is reproducible every time, and I have already submitted a 
patch to fix it:
https://lore.kernel.org/linux-cifs/20260813104042.170080-1-chenxiaosong@chenxiaosong.com/

在 2026/8/13 18:17, Blue bird 写道:
> Yes for the BUG_ON, no for the use-after-free. Details below, and I am inlining
> kfuzz2.py at the end since it never made it to the list.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


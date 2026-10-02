Received: from mta0.migadu.com (out-42.mta0.migadu.com [91.218.175.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628B4328635
	for <linux-cifs@vger.kernel.org>; Fri,  2 Oct 2026 01:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790906222; cv=none; b=qmtUswEdJBgWwf2hVbJy8c/nrgRFbtDGkSpk3xn1Io9yJxvWMBV0Ndo5GOtwtGNbMbAj5yh3MniB0663LD87ypRowyV5iIFEaw4e43pmy+V/XTBYpiVUfXy7f1YHIEHIXwRKh+/dRZYdIy4uz5FPw2uMaPnP2NHcsiI4nrpbofw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790906222; c=relaxed/simple;
	bh=oOqG0TKLy8mFSMKvvWHi4lBN0bSUCNpyPVhQS8gtLHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WTtNy2/n/oCTqhm9dKQDdlZsPCFbxYx4NZhkK8DetoWaqnwBODAoG13X8tIuF6oQKkUfNQEFSZzqhhSkwPmnjorCdCY69VwGpLrSvjOQdD3Z226NKDzGNqh/nocW3jkez0QPzQcc10+T9/KTHbR+vkFRelHrTqFEOPQGOD7un04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=oyYatHiB; arc=none smtp.client-ip=91.218.175.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="oyYatHiB"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=oOqG0TKLy8mFSMKvvWHi4lBN0bSUCNpyPVhQS8gtLHQ=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790906216; v=1; x=1791511016;
 b=oyYatHiBfl1+sm6rBHlFlj8Ax388RS59LB16gamYdsltInSEus9J7mdXogHIJ5CvfbYr3DtH
 XF/fu1yDWewznC3WjoIlOtsfdU7QRdX3MFR/P5wo7T8moc2NP3Dc1dbfzJD3ljGZPD0RC3KXLSY
 5TNAFB0wbo3UoVrJ7coSOoHl5Fk3J/iljrHJM9+A52+DGf+l992uxY9p0Ax6iYvy7lLspKqBl4H
 SHVCpgb+kx1zN6+3ByXFwrKoQs5xqmcP8WE6iZsxAVK1hk+BKEnBLpTP41kJ8GH72tiRitym3NB
 bSpbMMAiwIxqzRq7WhoGoA0NSR6ge8RF5FqHRHzkik8pQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 9428782484ed6090;
	Fri, 02 Oct 2026 01:56:46 +0000
X-Mizu-Trace-ID: 9428782484ed6090
X-Migadu-Flow: FLOW_OUT
Message-ID: <dd85c8b1-075b-47a3-8a88-6b55e5adb224@chenxiaosong.com>
Date: Fri, 2 Oct 2026 09:56:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ksmbd: use clear_and_wake_up_bit() directly
To: Daijiamu <3058704216@qq.com>, linkinjeon@kernel.org,
 sergey.senozhatsky@gmail.com, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260930183758.32342-1-3058704216@qq.com>
 <tencent_464A86FF7A38FD3620EBF1C6062745316307@qq.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <tencent_464A86FF7A38FD3620EBF1C6062745316307@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 10/1/26 23:06, Daijiamu wrote:
> clear_and_wake_up_bit() was introduced by commit 8236b0ae31c8 ("bdi:
> wake up concurrent wb_shutdown() callers.") to replace the open-coded
> clear_bit_unlock() + smp_mb__after_atomic() + wake_up_bit() sequence.
> 
> Replace the sequence and drop the now-trivial wake_up_oplock_break()
> wrapper, calling the helper directly at each call site.
> 
> Suggested-by: ChenXiaoSong<chenxiaosong@chenxiaosong.com>
> Signed-off-by: Daijiamu<3058704216@qq.com>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


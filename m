Received: from mta1.migadu.com (out-90.mta1.migadu.com [95.215.58.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283D7376A0A
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 02:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790823093; cv=none; b=OnWajU2ohoOp/AWHnZH3o0DSDvqcW39ad1BfAj2Smcwriptb3rTVU1N7msnOjVW4kidJLpWNziOdgI6Wv/FchTKW8fAlEEopDN1/+OIjlOrfSHLMczvC75m0Dz5pDvUW+0wh/Qvhc9nFDVTdTlXPnfVQ8y+bKgO5ZbxHt93Q8X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790823093; c=relaxed/simple;
	bh=jeSj2deFRKgsRDPJJJ4y2YKe6wuxSS/dZR8no12kX1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4y5M6RglHCGJ95b7qbsGB92Hzjcem08AEIm4r4iKMdieKPrszy9SvHUXHqCLDXOTej82gP/v7MKyYB2XYlHlmD8OiCIbczf0xiTiRwkf+RTkChNhhCX7Qjwx2IXQph4EnQ/VKgFZmc6xOHpebTJtl76TrEzWpfiR6/NC8PBiC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ap/ScQkk; arc=none smtp.client-ip=95.215.58.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ap/ScQkk"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=jeSj2deFRKgsRDPJJJ4y2YKe6wuxSS/dZR8no12kX1Y=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790823086; v=1; x=1791427886;
 b=ap/ScQkk1J36MMD1flMmkXiUIHSgYW+0UYuUBXVglBxu58vp8jMmSafQwheIFRmjRa50oInr
 fJH1N1k+WtUaA08ZgrH+8+V1O9ukEv24lMj61pHOJhtIyzcZ030RZlkRTmWwyFWWeVJN2w7fgJ0
 Bm9b1828VOxlKiZmnwBTvS9Gt0M55dQ9pn1MHCqvOso3sSLFif4JjVf4iZhwCYBwFQ5e6VFOtbe
 45uYsGs3qQ0/bAW0Q2CTfwqr7j+9JCVOxKwBAJMy7FTuOnVTYjeKutnoeKsgigkPq3814rQfLqi
 YUJNZTeIDAhUxuZQ3AVnRPRzBN2ZW7TMWBpLF8OV4f6HQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ae8e3eae607186db;
	Thu, 01 Oct 2026 02:51:25 +0000
X-Mizu-Trace-ID: ae8e3eae607186db
X-Migadu-Flow: FLOW_OUT
Message-ID: <1b73e6c1-5e35-4e03-8310-892efdfd77e5@chenxiaosong.com>
Date: Thu, 1 Oct 2026 10:51:21 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: use clear_and_wake_up_bit() in
 wake_up_oplock_break()
To: Daijiamu <3058704216@qq.com>, linkinjeon@kernel.org,
 sergey.senozhatsky@gmail.com, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <tencent_238A42C6350C25F55AFAA340BCE35A0D3B08@qq.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <tencent_238A42C6350C25F55AFAA340BCE35A0D3B08@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

We can remove wake_up_oplock_break() now as well, call 
clear_and_wake_up_bit() directly.

On 10/1/26 02:37, Daijiamu wrote:
>   static void wake_up_oplock_break(struct oplock_info *opinfo)
>   {
> -	clear_bit_unlock(0, &opinfo->pending_break);
> -	/* memory barrier is needed for wake_up_bit() */
> -	smp_mb__after_atomic();
> -	wake_up_bit(&opinfo->pending_break, 0);
> +	clear_and_wake_up_bit(0, &opinfo->pending_break);
>   }

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


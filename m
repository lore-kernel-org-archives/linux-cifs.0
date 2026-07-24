Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EABE26F2BE
	for <linux-cifs@vger.kernel.org>; Fri, 24 Jul 2026 04:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784868346; cv=none; b=oR8Dma7uVo7lpdLoemveGj+q0gPUiNv9Lhb6eaBcgECWUlpbbjYPBq6nyI2fC0QILARsdd+yznQzWSVhQxsSu4dmXZ3wSb+8IaqPLl6dICgTTIgUqBpEYenP5i2TmJwcwQ0OjP5hdg9GMbQbqEKRUdikoaNwAYaGPvC1A+EKZkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784868346; c=relaxed/simple;
	bh=TEFtnPMiL2FQgeh47IGfIuK7cD4kfIzrWbt5/klBj9I=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=UB8zW+AjYys0WFrOJlXuFBkbVc2vyj+k5Zcif1FSljfwjwlrqKknN7+B8tFc8aj/CIXRF3jTDJ4/fy2b7LddZUja7HqUJ7QlQDHeCu/m1fwn376soJZGr13qwOnmsJE9ihA245LG9HLe2/e8g8Guhc9hQlhS9HkygPAg3k4+g54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=F4LE1ly3; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="F4LE1ly3"
Message-ID: <4f918a86-9839-4ed2-8972-c0c71bd1c1b7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784868332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iZCJNmJGX0wIoxf9p3+SETDkZ/+DZKolrWDkg4Amxvg=;
	b=F4LE1ly3cpdN0gqpvjMI65X6dkCiK4u3SWIriaw8gzcOjw5vxXV8D1TXw5pVIQda2+c1I+
	wrrtS9dfHpgB4ls+DgGFqSkItExrGRsa1B9XJqdv2MuyL6j5r5Uk0rHPRaDASDm7mvmG/y
	MMj4QFcT6FlGNZEFAsArb9mt18czjaYh3jFS1BUzCRQArtVH9y6dFDKuf0nTpOoK+0eoKm
	S5XcDjPyyfrF+5PSOAr8kUwRPGHS2pSvLedC1Bbh9cdb5AZsMg+I1gNUYY9Dh7axw2LhmQ
	ojCXV8l2WFlFnQOxk88d9n5ruXAKGqevoVyzhn+gqP3R7d2wKdZ3HQ/OMA8rxw==
Date: Fri, 24 Jul 2026 12:45:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: remove extra byte from ipc_msg_alloc() size
 calculations
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: Rosen Penev <rosenp@gmail.com>, linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 Ronnie Sahlberg <lsahlber@redhat.com>, Hyunchul Lee <hyc.lee@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260724013841.1345481-1-rosenp@gmail.com>
 <7ad99c95-d1bc-4cab-9632-d00d8e7a1d1d@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <7ad99c95-d1bc-4cab-9632-d00d8e7a1d1d@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 7/24/26 12:37, ChenXiaoSong wrote:
> No `Fixes` tag is needed. While the extra byte allocation is indeed 
> unnecessary, strictly speaking this isn't a bug.
> 
> On 7/24/26 09:38, Rosen Penev wrote:
>> Fixes: 0626e6641f6b ("cifsd: add server handler for central processing 
>> and tranport layers")
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


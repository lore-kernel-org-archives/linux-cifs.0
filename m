Received: from mta0.migadu.com (out-210.mta0.migadu.com [91.218.175.210])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5D72F2914
	for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 04:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.210
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786593969; cv=none; b=qVz1waR3ru9fEYWugp9EQOQITov9Gulo78Agte/vB+5ZYRi4zNXqiFRiqx2O+udkG6u3Qj6cqHQWkVB1vzsDyiACTCShrkYXj+0etNlxYPSoAC69B3LJPTX5/rTmKHNW9Nhc7emU0jc9yoEqg8TcCznpg2zV94Vrtw+XYLoeOaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786593969; c=relaxed/simple;
	bh=EWKu6ub77ZYWYvKpRBV4ial/QKihh2vA69tlw0CZNag=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h/9QDD4he4m4qglgbNL7PALNaWYB+2Z+jUhcMUSH4c07edDv4bZKu/snzxY1YQaqiQAbhUTTQ8POYU/IzPzdwoHmR3AaLpQNxQi3Cpso3aNkRpDM0Goz1zIndyxqxoc3Q7jX69OdF3OkrFcMrbQFzgzPN7vDQLGMn5ao1rUB1Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=i4cgXSCy; arc=none smtp.client-ip=91.218.175.210
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="i4cgXSCy"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EWKu6ub77ZYWYvKpRBV4ial/QKihh2vA69tlw0CZNag=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786593964; v=1; x=1787198764;
 b=i4cgXSCyOUxJJrQQE/SaWmmF32mGaqPBiG4JDap4hBA7nmsoUaB1xPRj1f45RUS5h+tghtW1
 ny8/nSyE6L/eHAinHVsxYVz1D3hdBkahOUo7V47qPZ+1Ci5vd1m620yl4nHmyyRV1SgJV9R86FP
 VlCEJM3ex4SQoWAvfGmN/T/DTO0oqUeBjNvjlZQKO53isZLGJGAIhFIJGlhFCXkh8K08874IZB2
 80lH+yBSAj7ib02YV6lLWGriyQaL/jIe49/fFkVVIZBhuMzBRdukBmg18XzniEVMe2VFEEr7kvD
 lICkPLq4EKnKv1QtszhHVV2/aq4MN87hv+CGV4KBNhYfQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [172.21.20.206] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id b78dbc081f3acb46;
	Thu, 13 Aug 2026 04:05:53 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <437c9227-f0a2-4690-a2f3-e73faec909b4@chenxiaosong.com>
Date: Thu, 13 Aug 2026 12:05:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed
 while VFS blocked requests are still attached
To: Blue bird <obnred@gmail.com>, linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org
References: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

kfuzz2 does not seem to be a public python package. How can we get it?

On 8/13/26 00:09, Blue bird wrote:
> import kfuzz2 as K
-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


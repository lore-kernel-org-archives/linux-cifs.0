Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD8A3DB325
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 09:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675020; cv=none; b=uPUKNWgEPHYQKrjnDJz1HNb77Nusq1mpCCrG0vQ4qW/VQ+gpjqs1y0zfZI7XUosgw1ctvy4n+zAzvMrAeKjfURaoACjh0u9/UYJZluTZef7nywigVw3JTQB9/zwgdQ7Kl/DDVbpg/5i4WbBli1kFAZcCP1IkWNwK3WGhWl6fv+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675020; c=relaxed/simple;
	bh=Rrd+9TaF13wizuxztv0NdfGdMGsmkqaAVvKJSstbbv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QufDgA2XpoavRzoeZfUt+TnIAzc1jBtEObFaScCeUPZnSvyp1mSUY3ajF4d14k497uQd6tqpex96j5phOPiK73u82+ZdwyPYgeet3D7NjLvSYqu0vFYakDTwq+CUN4C5MDzyQ1zljDqvSVoWlE14YmzNMZ5cAId90lb4Ylgv7gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=kQJ/KxAl; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="kQJ/KxAl"
Message-ID: <58326ff4-02d7-4db5-8352-dc53a0ef1d09@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783675014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4m8k5qoq96YCrvr6jCwR5yik43/8mtfWKUHHqakQPys=;
	b=kQJ/KxAlgJqcXnUkm70BR9hgXhKcQCFKFTv6R3lTnTCDCJfyvSx16pTS+a64/MFMOjWpU5
	uuCL5pyr4HTr+DNYzcrVBmmHfdsIqQGwkLpUeteNlzg9ohlUZgmkKLAqf1kbxNfhXa3zZZ
	8SoLf4NfYdW63jIViPk8ZcC3Ws1NcOIo5Ypm7oFyuoNLdyOb6QCwXKiVRycdL+DSKw20qa
	Hf2GyRlAP3YNmCuozR5mSq+3fGgtg8m/5xDPF6ouYspTKKpJmMN+yiFsSATb54vn7c1Ieh
	4bqd7o6pfyS4RZ/xLfZ03h6GdZwCjkDJ32YzKTwxl895yQWrX3cUqUlZjwsP+A==
Date: Fri, 10 Jul 2026 17:15:55 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
To: =?UTF-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
 <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
 <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
 <c9a3fe37-c999-4d0d-8ee8-a34157c8a09e@chenxiaosong.com>
 <12AF7BDE-BF1C-40FA-81CD-93DD3AB666AC@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <12AF7BDE-BF1C-40FA-81CD-93DD3AB666AC@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël,

Yes, before the cancel response or event notification response is sent, 
the notify request has not completed yet, so the worker will remain waiting.

If you find that this approach causes any issues, we can refactor it and 
use a better solution.

On 7/10/26 16:54, Gaël Blivet wrote:
> Makes sense, sorry for the misunderstanding. Could be cleaner, but doesn't wait_for_completion_interruptible() still block a worker thread from ksmbd_wq for as long as the watch stays open?
> 
> Happy to help align the merged patch with your series once it's up.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


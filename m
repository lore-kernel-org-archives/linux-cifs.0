Received: from mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8533DDB09
	for <linux-cifs@vger.kernel.org>; Thu, 20 Aug 2026 09:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787217164; cv=none; b=esYQ5hvgG9duFVZQdX4FumE1jCOc907UKaBar6k7A/EaFO250sfFZjsazF5D3ES5B/QAONTP6xP+AG+sozUMR7g/RJJvOVL+d8IOwiZQb2FEym/UROzNkeIVeV1foWw3kRQpdUEcT3ChoaGcydEZbznuDNla8OMK7HA0PuxRO/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787217164; c=relaxed/simple;
	bh=qtjAUIG5STgEOcstKX97fOq/mmZgsVzuB9Gi4jZxsj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eNNl7KpAmwjr4qTf2Iqtjf2ctUVDod52p5OcdqwfP/LmTSFhI6z0trNTlV7fpv3WbNSJB0UpQufN/2q8nDKK14Ben5BbWTL8il5UaUygPukMiiQzBTgptLMUvUgReACb7HnheZ+EgyqBFQ/xCCUx9dgC5ZjliPBcDx9CMribgoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=YQ+MUxLS; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="YQ+MUxLS"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qtjAUIG5STgEOcstKX97fOq/mmZgsVzuB9Gi4jZxsj8=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787217158; v=1; x=1787821958;
 b=YQ+MUxLS4ABMr3CzOdo6WuW5ssxvhQoHalVLxU5YQ+kzHMxUfZmkUcUwr8rc4bqGNaNSDcY9
 0Lc/aq48FN2QpcEdYnWg5yXzXZ/0310mH0AtoJw7f8L4zJIj3GZU9zw9NdYcl9aApgpOP8h0ZjO
 pMWDtlRKT646VBzhIrajEVz/tBCE9/eE/Z4ag9l0CtMw7eomUPZXN2UYyqQT5aFYKcxupQUdL7R
 Reh4uSckZG1YwdQjgnQZ7T5rRMgXt/FZuZwcrtnLhaAwBnpnkrLL61Ta4ljGrfJYP3jDysRyAK2
 kO5u48WwvNeJWiM+HivCd5++tBeI1cXc/THmDJhrZOgqw==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.216] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 8090a4d5e89cb952;
	Thu, 20 Aug 2026 09:12:28 +0000
X-Mizu-Trace-ID: 8090a4d5e89cb952
X-Migadu-Flow: FLOW_OUT
Message-ID: <3c1652f7-5971-4502-894f-219d0dc7b3f7@chenxiaosong.com>
Date: Thu, 20 Aug 2026 17:12:24 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] MAINTAINERS: add myself as KSMBD reviewer
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260819071224.527479-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8YX60A56=epLx7s=ejwX+Cxw1=BKPAFfw0dZZ6LKvoXA@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8YX60A56=epLx7s=ejwX+Cxw1=BKPAFfw0dZZ6LKvoXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks very much for your trust. I and my team will make more 
contributions to SMB in the future.

It is really enjoyable to contribute to SMB.

On 8/20/2026 3:49 PM, Namjae Jeon wrote:
> Applied it to #ksmbd-for-next.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


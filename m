Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E58344DAC
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 07:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791496; cv=none; b=nPWnunSW/TSy78Ld2Oaz3hj6ZMs1V8zhX4l6T3gn6DpHDElP/vgiA2kskf0Mn6edVIWJy3p2YNPWFffykUDBZFPfVe/KZq70M1YZ+hh/4s8SJEQ/QxHadWvpfHO6fWsxyswhLU9ANHCrMr1NhbB8hZh5OkYg3mBGGX9666BpOak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791496; c=relaxed/simple;
	bh=n8SirqUSdpC1lBkCNQ5kSMD9Cf2hGam2kaaZaHC5KfE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJLnu4ZJuBAPP+IsrfVayln7Yr8M31pPfUvnIWXTA2n4BeJKCiV5L4GRphBQR+HFokAlrepukmaKUk4n7n9uzEgDOvzB0o/BVyJgLMOyyhc8OSGj5n6B5IPmebpTym+K13vE+B+G7NP5zhrC47F79kJAWl2Tlt8mG3ByuyG8tTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Fp9go0b2; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Fp9go0b2"
Message-ID: <b503dc06-0270-4887-9268-5696a3ff8713@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784791489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5s8LJ1D1a3ppsOzjck9nYLgaot+VAOTG7MtqpfCNyE=;
	b=Fp9go0b2c/gBVQER++w/2jnl7nET1dJc2W8bUnISMANwtb6G08XfltrndevzpDTbcgdlzO
	tMpSine248A9NVoyLknqUw40Xs1ylWtr0yNeZQqSHLKHOu768G0SQ4RwbyvFQlGk40o58+
	v7HvKYPl9qX3D6xb4RxZq3ZjsQzbEd9oWaZotmAWtzBU+d1OOvjZu59TsjRgtW4iR7zE44
	NN8o3fS60NJkYY9Di1LIASJXPJVcbQ1/NItmqZsUVyysjUYXDJBZjDLJ+F0vstHOXpo1YP
	4QDRJga+iuo0DWowyjc57BB62Fijv+6XaBl37ZWz5TJ6OjKAZk8Hia+nHQtTaw==
Date: Thu, 23 Jul 2026 15:23:52 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 3/3] smb/server: stop new async work when closing
 connection
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
 <20260723041131.313321-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd_X5JSh8YGk5Z8-gx2A=PDcmW74jKK8co=z=9Zxty5xSg@mail.gmail.com>
 <ce461389-2b54-4097-9f7d-409107e08e1d@chenxiaosong.com>
 <CAKYAXd98ByZ_Nr1wBRodfeA7HCKNFe2bGQ25u5JHEL5XoxsDBA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd98ByZ_Nr1wBRodfeA7HCKNFe2bGQ25u5JHEL5XoxsDBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

No worries. `Co-developed-by` is fine.

On 7/23/26 15:20, Namjae Jeon wrote:
> Also, I
> made a mistake. I should have set the author to you. I just updated
> it, so please check it.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


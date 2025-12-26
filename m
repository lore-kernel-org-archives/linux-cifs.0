Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5E71DB356
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 07:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766735422; cv=none; b=CHCJ7MqBzrl5aKMUGx2r99tWnQRlOo2Ne26LVS392rJWjSp5dQS6TpupisdsQ9Q+5P0bIk542FyTjPNFdvT/B4ey65ikQQ0jhzlIBBHFmJ3q4JR9C6h9DDO49xxTlLzT2OPh5BrZRDZZYHY8fvAFs1LdSr4HH06aWMarIuU/Z2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766735422; c=relaxed/simple;
	bh=vRYeHAnadloLcnXhFIDwz6LJip7kwKR3U0wk/vpTvJk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=DZeMXy+nvPrtaM+iLkC74mfUkXgwZtXspcxNdhh3a3J+8EFkNO+KybHGhBI65GVCh0D9uDS65wnwjZLT2yKhUfcUv6GKjHZfdhzBXRIVQbDaFN6AKvVFfA+tYAIqLo4MXZER93rCMBHt3Q4HW5aGBJ3mb8FCXPCiCL6ZOEvh9VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t2s59MHA; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t2s59MHA"
Message-ID: <217255d9-2422-429d-9aef-a916a8a52ca2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766735416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Lg3yZdkSZ7WT0UeBsHzbjzffIKq6/KiqWN0p3Nd4lDE=;
	b=t2s59MHAu1GiZm/6QY/YIVOeWJJFpApp2bTTaDk+9XfG/8c+xTf1vERZ2ljngYudL5RePk
	XCF+3R+ZMuqpOyyn5f6JLybz5Ym4bAG6RnJfTMOT3S9ZzobUqRUZEvE3DxIULWPNevgRXG
	Lh6m1rt3dSNJyNcEWSNaqIwhqCJssP4=
Date: Fri, 26 Dec 2025 15:49:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: generic/013 failure to Samba
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
To: Henrique Carvalho <henrique.carvalho@suse.com>,
 Steve French <smfrench@gmail.com>, Youling Tang <tangyouling@kylinos.cn>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>,
 Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, gustavoars@kernel.org
References: <CAH2r5ms9AWLy8WZ04Cpq5XOeVK64tcrUQ6__iMW+yk1VPzo1BA@mail.gmail.com>
 <5frnv6uc7yvfrb4nar5rpjbjyog5krbpfvus74n2iv4vmri2s7@i5bv6napwn4o>
 <141824e7-50ab-4072-b611-5db5fa01bb86@linux.dev>
 <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
Content-Language: en-US
In-Reply-To: <e56024d8-6fd3-4040-b31c-44d3dea3df3c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Sorry, there is a typo. It should be "remove `chunks`", not "remove 
`chunk_count`".

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/26/25 14:44, ChenXiaoSong wrote:
>      // remove `chunk_count`, and use only `cc_req->ChunkCount`


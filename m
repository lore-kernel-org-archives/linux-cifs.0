Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0829B22F
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 09:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767087829; cv=none; b=ouYRpkigEieLfnHZy2u1Y6U47agdy0XOHDwiX5FvY+BMKcf4WZG6sJtadqaiqnJDMNjOUGNBxnDl1MOuRZYHOcx0xFfd3rBe7wLlI2nogcudsSMSsVprU95qtE/JB8gH+HEnhH4J9z7Z+RoDmpo+XYm6E4oKd5wvb4GVWkfNEOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767087829; c=relaxed/simple;
	bh=SjOvxqrrM/mDiJTpreUsPaYVS5h3+my2BzQD1Y6MWS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qCYjgt+2pNF5Bdgi2DxQFTqMMrxwRS/SOT3zrwNpfFAJxY5Rv2Y4EI3XJs+JPegBXDSntEq9X/QmW7cSr/IqGQh1I4FYPAMrVqzsvzhC1GDrVYEZr8Em0NuaPPGeJunYmBxRT9i5pXeU9ve/4kimPSlh4YbKPF0i+9GTf1QwOyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Pa+ENM7o; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Pa+ENM7o"
Message-ID: <00150dea-4a30-49e3-a1c2-cd6e6561e238@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767087824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XA9MlYEXHkgJwIBrHJLRddx4Rx41sQqkGtDKm9l9xw=;
	b=Pa+ENM7oy6jeiTV7BFZ+gADhMx5suUPxqbcrARDxYIBp3kr7N0XHEdEoIvkVo76gr5CRCg
	JG1cora1Bn/xEIfMNhLeCNE5A8MkumvR3Snvet28AzSTypfv5xvVwKABKJYy326+AMFRTZ
	+FMVSzh6P2LDcA7dgF3GiYB9pLbC1II=
Date: Tue, 30 Dec 2025 17:42:57 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org
References: <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev>
 <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
 <1266596.1766836803@warthog.procyon.org.uk>
 <1276266.1766850638@warthog.procyon.org.uk>
 <1692b7a8-c208-4aa7-a9f4-02fea6d31733@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1692b7a8-c208-4aa7-a9f4-02fea6d31733@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

David, what do you think of the modifications? Call le32_to_cpu() to get 
a cpu-endian value before comparison.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/28/25 00:05, ChenXiaoSong wrote:
> Or, David, what do you think of the following modifications?
> 
> ```
> err_map = __inline_bsearch((const void *)(unsigned long)smb2_status, ...);
> 
> static __always_inline int cmp_smb2_status(const void *_key, const void 
> *_map)
> {
>          __u32 key = le32_to_cpu((unsigned long)_key);
>          const struct status_to_posix_error *map = _map;
>          __u32 pivot = le32_to_cpu(map->smb2_status);
> 
>          if (key < pivot)
>                  return -1;
>          if (key > pivot)
>                  return 1;
>          return 0;
> }
> ```


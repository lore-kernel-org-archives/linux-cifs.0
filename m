Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CE9EAE7
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 03:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767067020; cv=none; b=Tv86iXZnGLkY7BWUGOhUPWYtuVDcFhZhWTMekK2k9j7dLtAUiFsweGhw2KhIHvmbyEOIQ2CK/tBxkR5pDFf8Ea7M8bKpwA/r68oXQn1Rqdom5O3dvxaSl6AGBgZsL3B0crbO47SsdRU1qnKWT8m7hXLaxS9U4l8x5sMJXVXk/p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767067020; c=relaxed/simple;
	bh=yDd7TFbw7N1UdDjRVRO/x409L1FR6tQUoNfvF+mnpg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DNv0qKko5uVJm0TfawwKda+tRwLS0oX7rqV2yAIBzJd5jNsP7QjByHFypOhtmcSU5/utcqQh4NVbmdZjW/mFQcKnYb4xJEyFLNK1e5titYVXyt0jEo+ZfVqNWW4tUb5nAENGtiYct3ZK/U+egkJiVbt49Bav77qH+B5rpmGUfU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PxQewRjP; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PxQewRjP"
Message-ID: <c7d613d6-4424-495f-baf3-cf30ea70dc00@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767067015;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9iqidlUIBs9U2uR5dsNYRKr3Bgf41aEJQzY8B92Ylc=;
	b=PxQewRjPx5kNjRXFx5Z85qyAAyZ8v4F+piM27xjG9OdyDQRR3qfvTXt6UCyz4Fu3MgF5ez
	h4ScT38u3kHhDull6MstXwA478dZf0vRuyKN2maRSXR7gKeL97mfQThWYj0OVBc0IHRli0
	nvwMCOdfePx8wbpA+vvxEPKU+7QyAHA=
Date: Tue, 30 Dec 2025 11:55:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
 smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org
References: <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi David,

I would like to make two minor changes to this patch of yours in the 
next version:

   1. Update comment: sorted by NT status code (cpu-endian, ascending)
   2. Update coding style: use tabs instead of spaces

Do you agree?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/25/25 10:10, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: David Howells <dhowells@redhat.com>
> 
> +# Generate an SMB2 status -> error mapping table, sorted by NT status code.


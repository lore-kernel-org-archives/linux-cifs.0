Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B5C239E7D
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766847852; cv=none; b=itUTNyI1WrJvjmy8GU/lJJc5a0YUW+J+y8yEr4PejUUC3H6zxuiMwJXg+L8BVhfz8sdO3NfZYeTjmhDshhRk8LqIDG8FbdZLJiawrg4xDlMoa8KRenNhPy0bY2xSD156eDQK7JFEBdU3yEYN5IsM83Llv6DitSaUMVaB9iPPjLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766847852; c=relaxed/simple;
	bh=A7JwUhY1Em0RfWkn8OVt2Xc1loSvNN/Qh3wVLCYtEjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUxhIWNqP3yrVlZU7mEOp/UIten1k02FtkHb/C5go6J6gqIrdGdYVEmjYV65Pq4rfZgyq9rZHawObB1aHSV6EyhYGmS4NT1Sb9e/D/G/zoSkRgQ191drpDhebejMdgKmi30XHzbF/i+Zf9ykOsVOBISl+toX3MQfQIKHvtEQ+iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LxnWwpew; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LxnWwpew"
Message-ID: <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766847846;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DnZYkf23xX6H+nW9NBzp1lB/A4jczIa9QWgKkqhM0Ac=;
	b=LxnWwpewZ0KuKvfZfWX9TccUHNOolk0aTrV6DDmw3Zanvstbbsezwz1QrXZ6lT5jQTuLya
	HwPHqbJaT6d1SVOQqec+qKuC0jrAZeGuOALlw7RuufI3XpMcc76M4c8FqDeQJqJ9TCkYtF
	nRKZZrL3+nTVUkXtw05Lb++h9FJxfC8=
Date: Sat, 27 Dec 2025 23:03:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
To: David Howells <dhowells@redhat.com>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev>
 <1266596.1766836803@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <1266596.1766836803@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The `smb2_status` field in `struct status_to_posix_error` is `__le32`.

In many functions (e.g. `map_smb2_to_linux_error`), we compare `__le32` 
values directly.

Should we convert them all to cpu-endian? Should we remove 
`cpu_to_le32()` from the macro definitions in smb2status.h?

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/27/25 8:00 PM, David Howells wrote:
> Don't do that.  Store it in cpu-endian order.


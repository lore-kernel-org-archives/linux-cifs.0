Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26C71DE8AE
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780759291; cv=none; b=ojIVDxLRM5Sjm4lQx9NSsnVIYvMpl+OGtUMVGPvMURTc13sNASv5PLFsUR4Ea1k2/VcZY29grPAj+vze30LiwfXj7bebZG5Uq3QO8Y2Dm/fwAhRgzLz+4fJJHh/OkLOpfudjM9sHZEOETrielViem/6oYvuuyqmv2Z+827pypQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780759291; c=relaxed/simple;
	bh=QUUs487waUyaxooOch6ggTtuVgy/4UolOu9YV9e43aU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AH21jTrbgzqMSlxs8StvV/+jh73OhRRehuXiqJ0hm12VWRmXr5H2xPndQiSQbVcpwDN/+JXHyvmI3xSs9aXdEZmskzn7PDvvf2SkM+qvMe9xthhztxUfhzVGnst/k4KMk4J7hshTZe7DsleJdvJRmGu7B5jihjohJ5VO6odzExQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BEwl4dgC; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BEwl4dgC"
Message-ID: <13768420-79d3-46ba-9144-c517f47750bd@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780759286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DbQEhfGBFAkICDoCqhff9j24BSf/FcaVG0XHzc/uY8g=;
	b=BEwl4dgCEgxRm2MlHVq4ObqCH14K/LNhR0RoAcMvhk1G2IAuaa05ZmQoWx+z0E2k9zgtHV
	b9423femSVFm+cwD77S8bOAfacVUzR16yvEGSYIghEVXOR4vNplHabqmwg04dCM7jU4p3l
	E+KgU2+twRfykglTDjFSZzI6kAKbaOWbjf5dlKklOQhNJ4ryzgHCDbDEKprUupkpXFRk+p
	O+xwYnubW/UOXtMfGiOiDE9eVN5t4hXv+PCxvf7udUCWTb3ICji8kdQWzp0ElbCX2IrzTO
	0fOHf4xXo8xMwZVElGDqhWZuKNETg8cDACx8imcfm9c9HIDW2vg6kKl0zHDNSA==
Date: Sat, 6 Jun 2026 23:21:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl
 handler
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com>
 <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
 <8135aa2d-d576-4cb1-98cf-d76bd2bdd20a@chenxiaosong.com>
 <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9QPcOHWn13gRZHPJhy_pEVwRpJVr87+4mv5UXmR4juNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I will update it to use LZNT1. Thanks for your suggestion.

在 2026/6/6 23:15, Namjae Jeon 写道:
> It seems possible to get the file's compression algorithm format or
> information via ioctl in f2fs and other filesystems. However,
> COMPRESSION_FORMAT_DEFAULT is not defined in FSCTL_GET_COMPRESSION.
> Isn't that why it showed up as UNKNOWN in your test results?
> 
> 2. client: smbinfo getcompression /mnt/file Compression: 1 (UNKNOWN)
> 
> My thought is that if the file is compressed, it might be better to
> return COMPRESSION_FORMAT_LZNT1 even though it is not actually
> compressed with LZNT1. Of course, we need to test this with a Windows
> client. This is because I think FSCTL_GET_COMPRESSION is simply a
> request to check whether the file is in a compressed state or not.


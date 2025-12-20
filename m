Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 184E32F6905
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766221140; cv=none; b=lhYCCLyLjiociYe4Hx+FXlHLzgVdU/W0w3vlatKmMOtzdHRR7lM8Awf/CU5H92SAXSVuf2C+lZchd8Q9CHMW6LAq9ZpYtVIkgub+IVCLCh4KYv1SQL2kL9K+L7Ji1MAkEp7Y74HN0xazDL+Bryd5oVlUcm9TLeOeFzKDn8wXXjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766221140; c=relaxed/simple;
	bh=5Ny3gTYF+8ZGCBTLZVoT151wsmc8t4JBgeR/V1y8Up0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kg4xTjuszE3KK/k4cplrxDXEfEpod3uEVZvkhOgrZJQmtR1nXNKMsmx0veWH47TSOdJA6sPlaDIJDOYgZk/dsbYzjm+0ty6qttmRVvTIBlrkt1bDmwp35cPRGqYWxE3H6Y+q5cq7f28P5x2Id/yAQ/vwerDrW/WpzmbyNC3Lo0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pWgsmfwV; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pWgsmfwV"
Message-ID: <79544159-30c6-42e2-a8bb-bc70c1394798@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766221136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9VMJdf+3cr3wBc40ufzh6ByY9q9tS0xjBwr0KOkskak=;
	b=pWgsmfwVDadTsvsMGXsL+4jJjASxXF5P5L5dqnHTG93S4pFUlOsvHgoXaTRw4SCyBupKzW
	PhBTKyz9dLgY09KDZ9l9G34WvBa3SfE7+vQ6qGlGvNRugA7HXr82c9HQkJ9xs6Dw06MeKm
	r+tLMTfReHD3YC4TYN5TjLi2BOjOzxc=
Date: Sat, 20 Dec 2025 16:58:45 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RFC v3 3/3] smb: use sizeof() to get
 __SMB2_HEADER_STRUCTURE_SIZE
To: David Howells <dhowells@redhat.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <CAKYAXd_bhyFYSB_tmXGTczjgMPsEyVnSQUKztNfRzJH0bTdHvA@mail.gmail.com>
 <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251219235419.338880-4-chenxiaosong.chenxiaosong@linux.dev>
 <931181.1766220436@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <931181.1766220436@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

This was just an incidental change and is unrelated to the issue we are 
fixing.

I will drop this patch in the next version.

Thanks,
ChenXiaoSong.

On 12/20/25 4:47 PM, David Howells wrote:
> You don't want to use this SMB2_HEADER_STRUCTURE_SIZE for your comparison as
> it's little-endian if that's your intent.


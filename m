Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C65D18027
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 15:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766245875; cv=none; b=pwPdRLxrO7HwBbEG+nBFrxj5RQsRjXZtk5g7MP0Cogy9r24KgOnSSqldAFO4nLDroQ36xDZbYW4uHe3bbTUp8Ao7BvlFdnguqz8+ULjYN2tv5fKtnQJz3JovrvTaaV4DgpBjSXc9vK/iNe6txuPSFzKJvFcVLgNneJFSENuJwfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766245875; c=relaxed/simple;
	bh=sAp068MZQkZHT8cn/0yC58UX4TL+Q5SuGxfyqwYxtcA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=htk6nI06lyeOTq5+snZWo7eYAZiNmAb0g6a/o9VrFshwLYm7QmoeWnPwMXSaf0CGghd8AGO22ASG/6RYmnAyZdnXK5KfkmHI0T+osep2ym2QSLzt8QfoClCGbIhRm7DkhfxTbfHB39aIEKc2qEMAJ4m0beXakHY1ZXOlUCqMMnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cLtwf/MW; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cLtwf/MW"
Message-ID: <b24d88d2-5dbe-4a44-8042-0cf19f4d2737@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766245863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UUwtMQwsJBCPky4UTWO2wP6Z+tlQhCAlWI78zVyML2s=;
	b=cLtwf/MW4G86sJ4DzN190hNY6jsT7xbSueQhQcBJsmWN7cHLd1sFrXm+bKykm630Of+o09
	KJeQ4qrPqBbrnCOFjqa8xxQWcIrka9QD2M9yll7TsLk3uVqlAo04y+LVX4Vi00l26+Q4rX
	r2Q7nC5R46OXfIS+QVtjH87sR05+s7Y=
Date: Sat, 20 Dec 2025 23:50:51 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/2] smb/server: fix minimum SMB2 PDU size
To: David Howells <dhowells@redhat.com>
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251220132551.351932-3-chenxiaosong.chenxiaosong@linux.dev>
 <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
 <941517.1766243973@warthog.procyon.org.uk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <941517.1766243973@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 12/20/25 11:19 PM, David Howells wrote:
> chenxiaosong.chenxiaosong@linux.dev wrote:
> 
>> The minimum SMB2 PDU size should be updated to the size of
>> `struct smb2_pdu` (that is, the size of `struct smb2_hdr` + 2).
> smb_hdr + 4.

Thanks for your review.

Do you mean "smb_hdr2 + 4"?

Do you mean that the commit message should be changed to "the size of 
`struct smb2_hdr` + 4"?

`struct smb2_pdu` contains `smb2_hdr` and `__le16 StructureSize2`,
and `sizeof(StructureSize2)` is 2.

Thanks,
ChenXiaoSong.


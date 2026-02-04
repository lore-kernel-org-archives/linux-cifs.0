Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A18D3D4113
	for <linux-cifs@vger.kernel.org>; Wed,  4 Feb 2026 16:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770221362; cv=none; b=Gb0aN7ruC9xAHC0n1s4BQEDhsCohQy7QcbH1QXevbz5pIAmw/kDbjvv9Xik7CEnMaNesT/UcqfzTctPvUNxuSGsUIQ4dB63yT0d/EJy1MK/lWPfiNZbwRAoGBEgo5O0gpJfVmlVfyP/feuR02eIVD4wfngRCVxYT4w4rxZzK2BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770221362; c=relaxed/simple;
	bh=8p/4wA8ImiatlCVlGH8xSgrJIfnGqDwq25YKhJzoVIw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=CJZPVCIgkha8n7IXJ20wqIWVZLZZlhNWb4fXgrNzYxHvWr/9VXXfF3BQNEs4ktvx0qvDb+eB2f2AKenM6efuD5OZqQX9qll676+Jiq6iXmzZBQvTgjxM3xhhbnt6SCuqesbSdyC0a8E1ZOqMv5iQFGvSCBWOujKz6LY4lM8R0Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=OSRnRqk1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="OSRnRqk1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=ORz9Jai+iBRH4e+MQY0X+GWfFB7DEQupipIzex7ZRi4=; b=OSRnRqk1sTQSGaYw49kw6Sk+Mu
	a+DpsEAXnIf4a76JKJHqCB0YqM/MWT3ivGRs0WCtMknVtSmSiS//7fEFScBaf4Mo/ZAry8V958sVn
	KmuoD1nOpddqwfsrBCYG8+VCMTwdXBuhs3+20J8bq1xSBzTi3bXt8S3T2eLj4Ht7PfLMowDv0wtSz
	OvIeIhmx42lRPeoN0bi7iYRoIo/j52YUju68OsMQwVTy2fDzQ2+X/fprKx58OvkoA3YkrpSMm+yA1
	UwR9tt2N67GASac7g5CnFup6NL0gg5D+/PGoL3tJ13nZtCsoWXTPPU8MYqTw6dGrOccewuLBXkQbp
	xCMqICRNYX5LzgdhT5PUBe3qwraO9h7FGC1kvU8oM9BIS3VmwS20PyseOrUJr3Phc49M6GfvuyYHk
	Y58dkkSi/Mo3CZjFDUEx13wceglVsTBIquR+oHZUeu5EuCVm4XbzHGIcQh8KNDmQZeQ4EbJy8wWRk
	FrtPThleuGmf/6+P9FleeLVF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vnfRJ-00000004Bjs-3bUr;
	Wed, 04 Feb 2026 16:09:13 +0000
Message-ID: <46c9afa7-7834-4ac4-8509-b7087f358c96@samba.org>
Date: Wed, 4 Feb 2026 17:09:13 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: common: add header guards to
 fs/smb/common/smb2status.h
From: Stefan Metzmacher <metze@samba.org>
To: Steve French <smfrench@gmail.com>, David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
 Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
References: <20260203152012.914137-1-metze@samba.org>
 <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
Content-Language: en-US
In-Reply-To: <68046261-f2d9-49a2-92ea-9c7abb97cd5e@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 03.02.26 um 16:34 schrieb Stefan Metzmacher:
> Hi Steve,
> 
> this is on top of your for-next branch as it depends on this
> patch from David:
> 
> cifs: Label SMB2 statuses with errors
> 
> While there I found that this patch:
> cifs: Autogenerate SMB2 error mapping table
> 
> Generates this error:
> client/smb2maperror.c:55:60: SPARSE: error: restricted __le32 degrades to integer
> David can you check?


This also breaks cifs.ko against a running kernel.

$(obj)/smb2_mapping_table.c: $(srctree)/fs/smb/common/smb2status.h

results in:

make[3]: *** No rule to make target '/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/fs/smb/common/smb2status.h', needed by 'smb2_mapping_table.c'.  Stop.
make[3]: *** Waiting for unfinished jobs....
   CC [M]  smb2ops.o
make[2]: *** [/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/Makefile:2061: .] Error 2
make[1]: *** [/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+/Makefile:249: __sub-make] Error 2
make[1]: Leaving directory '/root/cifs-backport/fs-smb/client'
make: *** [Makefile:249: __sub-make] Error 2
make: Leaving directory '/usr/src/linux-headers-6.19.0-rc8-z-metze-perf.01+'

metze

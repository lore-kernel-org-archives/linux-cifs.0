Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E421FA15E
	for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 01:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763515391; cv=none; b=BiGTvZOpaCPdNVuPh00+XM7alFVZFQLr1u47KOrASxp3Wyua7Bt1N9Vv+slN3XunbJaQS7HfyYugAatZB47iRWfWIo09BjzmudQX5MWeSYIRh0i/KW7u/JMSrP+ezmp6+96wkmvOUPbOg4Fb2xP70kjF6yug9/tpGDhz1nkxfsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763515391; c=relaxed/simple;
	bh=0m9Uv4AqO22PB88x2xTdXO7eeEk9xoyNz8aELyUSLaY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IfGooVwbmT+qx248S07LHKp8L+BVor3wBxBrfudrJjKorb2jv9FwbxDLIUqUipuB/3gdJQBq79BcN7IV+iA1NwHpl3Xd76oYHJP2DirH/2IFNdyUrH/B30o5UTIPo5Hfh0+GTQ3BTUPaxirJFbVjJFdykclUc8a73oHLtgfn7z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=aPByPSY5; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="aPByPSY5"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763515385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDnn5YvJodsbLkYhj59/j5HwsXdLAb4xVLxw1OpDl7g=;
	b=aPByPSY5l94yXeICNlZPE6mw5XIerI/cY2ordCbj19LZnGgTeBMall/PrTlCLEk02lN6o9
	7kaaoPUozSEWcMBctmdcw/zQ3hVzlw9u/F7G+gybsNs4fxGDi7y4q1GxxWyDFh1eL/szDN
	R+AmO/U7x+m0XbKe9Z+UwUR2VTwSIuk=
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] ksmbd: Replace strcpy + strcat with scnprintf in
 convert_to_nt_pathname
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <20251118223513.241aed65@pumpkin>
Date: Wed, 19 Nov 2025 02:23:01 +0100
Cc: Namjae Jeon <linkinjeon@kernel.org>,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <620FC0E4-E745-429B-BF16-BCC2D5924E1D@linux.dev>
References: <20251118122555.75624-2-thorsten.blum@linux.dev>
 <20251118223513.241aed65@pumpkin>
To: David Laight <david.laight.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT

On 18. Nov 2025, at 23:35, David Laight wrote:
> On Tue, 18 Nov 2025 13:25:56 +0100
> Thorsten Blum <thorsten.blum@linux.dev> wrote:
> 
>> strcpy() is deprecated and using strcat() is discouraged; use the safer
>> scnprintf() instead.  No functional changes.
>> 
>> Link: https://github.com/KSPP/linux/issues/88
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
> 
> Ugg...
> If nothing else non-constant formats are definitely frowned upon.
> Never mind the non-trivial cpu cost of printf.
> 
> OTOH once you've got the string length, just use memcpy().
> That way you know you won't overflow the malloc buffer even
> if someone changes the string on you.

Ok, I'll submit a v2.

Thanks,
Thorsten


Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84A4937C11C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782750272; cv=none; b=He9LsFwx4nTirG7aqlJUdkJsYgYDjncsi7znG8PchtuM8J9jfTrQ14sPAnBWyXrSHCLtHvvuawSV2kx3id2LKEU9qkfCDzf/fuT+eA19SHcCGkouEf1KK+YFhPni2LwuqHt1XcIM2jVdGUO7I7hGDvbUXlE1+O4KY6M+T/GbkK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782750272; c=relaxed/simple;
	bh=yg7/OT3IBrIOUF1fluANppCR9lnvC9t4ZuTRHhDzClo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fj1QK4GIeSqEGPxGeEKrcHKKTNL2FIXVOGEzEf555TybhBHc5dR1N0SxlZPp/6dD99h2VaurkNmUeLJKYEtUW/oQwvxdbmJF7CyC2Ly1JdeAv7pdF/FtwM+JzZumDU0QnaoDuj8Ugebspul9aUchRn6BjmhrFe2+I0Cpk7IGJuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mNbS7eqv; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mNbS7eqv"
Message-ID: <b706c88f-f5ef-4212-b266-f87f91ade50c@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782750266;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yeTEcT83xfamlmtvZ4p7vpJt6JIgvdnFA1qJwa6mKnc=;
	b=mNbS7eqvcs9otYxM1l4qTZ/0031JCrUJQAzD74rVHd/N7kTSjTBfTn2RNlCJ95u+MJdkQt
	rUYyqszhndm0c+aHZBFOXUUzS92rPHEk+QqX+pyvfCRLRwcO8Cow4l7katbYFy/2V9ml0X
	8G697AHLz3BFddlo7C16QtzrqnjKQEKeukAKDSkr79L1UT/436ck2DV3zF34dlFUhd6Soi
	2x03xkh8kNKbaXfd+yd+23keV8iMB9WDf8SiaK7eazRxz/C1B1nUryeBQATS0sXg+T8B2F
	z4O4SSNUQP6CYxb+psXivKgCIA6biAl3F2Tpv4dOQpqSC2Qm9Nd7sy9Jmrs9Cg==
Date: Tue, 30 Jun 2026 00:23:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/client: fix incorrect nlink returned by fstat()
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260629152659.703943-1-chenxiaosong@chenxiaosong.com>
 <CAH2r5mt2Jonpx-YZ9ea0icKtGTCHFcEF77F0nJdFXRn97eUC=w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mt2Jonpx-YZ9ea0icKtGTCHFcEF77F0nJdFXRn97eUC=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Could we query FileStandardInformation instead of FileAllInformation 
just to get nlink?

在 2026/6/29 23:34, Steve French 写道:
> wouldn't this be a big performance penalty, adding an extra roundtrip,
> adding query_info call to open?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


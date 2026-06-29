Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE1D43637F
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 15:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782747717; cv=none; b=ClCdeLTjm+QwaQRChakforR3iXSGDP+vawyl5nCzhUrj9cexZsZuoS5MvWVLTfGVnEBgdKa0+D8ZToGrBI8VUV3831aAHn/hHaT1FtkGIDbWm0J8EkcHvuBjBTkGVW7e0mdChaUPzvdjZLPFSqEmzQQoHS8MxTuGih7+B6djmY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782747717; c=relaxed/simple;
	bh=ucN627hC3IBgyFihRVnBd797EIhFVZpy9P09hf0olMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=khQVcL1S74fL57RVVSqa4CeOmaofTVW0mP63emmTMkI7X4FCM5YNK9XwlLPltHJOBKNkPyC9vGSFgXxwm10LCmwB4x3pA7mdbOAboIQbVF3Yv3mY/dCoPRZNs/Fl1/Na32eThwOKhwI2x9uXl232iCqcWBM2YSreAbev0CZp8dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=wNGq6khc; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="wNGq6khc"
Message-ID: <243d6eda-796d-45d9-8c26-6372af5efe20@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782747711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IlG3RyRfpSrd3MxlClsBfmKXtC0auzfnaVr6JBZahn0=;
	b=wNGq6khcrnyT17JSLF9yLMpKdfjQgYXBOjY7gKOHY42IFN91rbMvHGnXBc6cexvFljhsmE
	rAbZUapdKNDuTrinSNSEVHrupTwbZFxD8TxZXhnflUokfrkIXuOy1T0tbh+C8OVQACHKBD
	MtMdzE4YcwO971ABIZ5e4s/+aeFNyUMBQMAcs7T13hnfG3GRxqm+3PV/9Oy+fpRXKomd2h
	FaE+441MbvjA7XfExBsKsQFM93YbFMmSXzBq9EIBsJ8yWGSFhSs0xznxbvdUA+79F1heq3
	uy82k9SrNunJ4M/1QwJWOBro6OhC+QRUhr/gbTLhFU3UnxjKxC8SnhheLjn98w==
Date: Mon, 29 Jun 2026 23:41:27 +0800
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

SMB2_open() should not be called that frequently. Steve, do you have any 
better ideas?

在 2026/6/29 23:34, Steve French 写道:
> wouldn't this be a big performance penalty, adding an extra roundtrip,
> adding query_info call to open?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


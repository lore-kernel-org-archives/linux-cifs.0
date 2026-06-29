Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10DA2D592C
	for <linux-cifs@vger.kernel.org>; Mon, 29 Jun 2026 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748344; cv=none; b=FAVW2xj4scBJz36YH8QP42zJgmaX68nsc8S8a0FdOXAdKQVQrqGPV8jlod8n/ntzI6PtHgRC0896PMdwB5+Ej4AN1F0T8wEEc/YcDb5TSTeLRC2oehboXNBPLxqNtA08QVe7nuwR4McrWw9sCwDT5J5AibogQVe+mhArMzGh23g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748344; c=relaxed/simple;
	bh=b8he6OIezUDUkkOt2hpPT7CP/89vQQQksH+NQ3vpkhY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HZ9wBD8NJQJV4m8Pip6f9zXUW0zL2DE3p2T9WseBD6APsQ2zdfNKeUbzWi/UyBz7W0+yM69ykfHZwEzGlp6wp10sjf02RYRgBPHm0T2sV6BelTJGBqGwiepucnU9g4n6ZuYyZ/Ls3fSYHxln0M9t97W/PXortQqt5GpnO/ILVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Bc12CB1y; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Bc12CB1y"
Message-ID: <730c5f3d-cbe3-4589-9f8b-01e2bddd4933@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782748337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4O44XB4JOlgM5jRCMUk6tJr7B9lyWdsPqYeTQ6tgFL4=;
	b=Bc12CB1yH03NHjKPrklsr+jMNCmZmDqy3hF9syybYlMSTszzr9jf6HMem+NRfqKftHjJlX
	kKCGjwlcCBG+q0/Wr7Le89tufSPvV4s5idle0nu66EG+N3fnFfzvmzABGYyFEERJLgNorx
	9q0oq9z4mjAySBc917uFtm7C/IY6KwVECu0s55G4sgzbO/LRHJsbO2KWZMoT4CFgZALLPZ
	afSk31+vGW3aAJWZWYfPxBleEhLyRDZNu32oPH1IttsRw/85GScIj9tXANAbk/fe4XcE5p
	VZiLstYnzbrY1F7yHb3WXRIt6V8BIN/73xbOMZ0YqeNjo0xuBwLpRu7pA6MVPg==
Date: Mon, 29 Jun 2026 23:52:10 +0800
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
 <243d6eda-796d-45d9-8c26-6372af5efe20@chenxiaosong.com>
 <CAH2r5mufBWn7P-iRhHN5xs6d2E2--hFPwVY4sZ3QRm=wXJup4Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mufBWn7P-iRhHN5xs6d2E2--hFPwVY4sZ3QRm=wXJup4Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/6/29 23:44, Steve French 写道:
> Not really, was hoping that there was a way to cache the link count
> locally as additional hardlinks are done

That would not work for hardlinks that were created before mounting, 
fstat() will not be able to return the correct nlink.

> 
> Does this fix any xfstests?

I found this issue while testing the modified xfstests generic/035.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


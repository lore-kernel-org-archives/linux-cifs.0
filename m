Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6C23DDB01
	for <linux-cifs@vger.kernel.org>; Tue,  4 Aug 2026 19:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785872372; cv=none; b=NEbedibqhxgdkYr0nq0U7nJOtk3tE8grRuz1iENvSY3PhpLKmeAFIsLCJbAzID/2E7QfLyO6bG5QlDMWX463H8JVvPC0xHUOqXwdNgbmWbTZu4ASKb0aTw3iQEfzA9YWkb/LWKtvTWS/L8gcsDcQ6MCRYVgArHn5wOcLmkGLAGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785872372; c=relaxed/simple;
	bh=kjUYBV6ZD9s5Or1c35Th2edTxe77eO1Zy206Vcgp1G0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=krokM6jL3+u3sYq4hy+IH/ViRx2iQ+usdb/voAexU7yN/oo5SMNaHh1r6xRpCNaa7vfoe3aVp+W0DjDDQJYTKO0jwM+aMrWSdBwvWgxZTlQSh7wR2x6/qu0/nQymRyNbi+gbbN9PDNk4N9B4AXHsWeNkLG8XTAp5+GQP+N9HvAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=WmDm6GeD; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="WmDm6GeD"
Message-ID: <56857873-dfb4-49c3-8627-e7674bde8ac6@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785872365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JeQpkWFQijBBFqebWhT/CDAP7J+hITVVaQ2tkRnLMBA=;
	b=WmDm6GeDV/j/qmrqK3rLG+Dne6Om41i/5WaoYfctG7dG/skexdluR5yciB03DcUmNSabsq
	MTd1tbHJoE/o6sKzwNrE/ltGk78TIAeqxkw6fmu1A+tK+e9U9547wtPumGAF8LZQvI7wvq
	h1x29ARd2mBKyCJvXguJibnb3AsBNX+TJNIjLu0wrB4vozTQobWTmEBM7uij2+EPMHq/a+
	kKxjhq4qIM+Ji3JgZzrjG8kG1MwUssUI3FbHKeh0IfL03pdJeQOqgIJal5HLdEkZuUqJf/
	hf13ylic7g1ROMPiWK4tlTO2twpHfFm4/HvKKOrfjNY2wLVMFCsfhk8A2pPVCg==
Date: Wed, 5 Aug 2026 03:38:55 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/3] smb/client: fix nlink of an overwritten open file
To: Steve French <smfrench@gmail.com>
Cc: linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 slow@samba.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
 <20260804123301.285434-4-chenxiaosong@chenxiaosong.com>
 <CAH2r5mu0rQKQDHgcF7jTBUk6zHitWinP5pzNUQ6+MxqP7j6w=g@mail.gmail.com>
 <36cdfc79-e586-48d1-a821-a1c86760cf19@chenxiaosong.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <36cdfc79-e586-48d1-a821-a1c86760cf19@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

As Ralph said,

- if there are one or more non-POSIX opens on the destination, MUST fail 
with STATUS_ACCESS_DENIED
- if there are only POSIX opens, the operation can proceed

Samba should allow the rename to succeed so that the silly-rename is not 
triggered.

We should fix this bug in Samba so that the Linux client should call 
cifs_drop_nlink(). Since silly-rename will not be triggered, 
__cifs_unlink() will not be called either.

在 2026/8/5 2:53, ChenXiaoSong 写道:
> Samba has a bug, please check the email: https://lore.kernel.org/linux- 
> cifs/0f6a5c9c-2c65-480e-aa44-facdf11fecc0@samba.org/
> 
> 在 2026/8/5 1:08, Steve French 写道:
>> generic/035 passes to Samba with posix mount option without the patch.
>> Any idea why this patch was needed for ksmbd but not for Samba
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


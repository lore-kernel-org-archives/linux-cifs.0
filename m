Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAE42D661C
	for <linux-cifs@vger.kernel.org>; Mon, 15 Dec 2025 13:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765804321; cv=none; b=DdZKCXVOzg3Ey6mP1hUcdRUIPvlp/BQ+1PK+yN5qUVzES9OrwMx/+K1RLIUeAlmjatMaM8b66lFCJZR2kJSBa5VrXHve/E8Vx0X1Q4J6PWl6nBWHeotrsvwtKyL24dmK9rTirrBugYoXHZ2U577DY+5IRkoD+P5YPoSkPDNUgEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765804321; c=relaxed/simple;
	bh=nGrU4xWqiR5C4l1H5RfAhczCI3zs+J3ddQwhNDIhgTU=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Pk8b1t2knYuzUjSMnpSWn5P8YVE1k0sumC9UUYx4tO92CZN7WIM+jV0BYPNiNvlHY/3NpKxRwXS0XL0/AkF2/FnyTlmS/x3vbjhVO9JTTSZPJj7zWwMgF3v1RYf2iIZIm+W0aY6nnczuPjp96XyW6zk4rn/yF0p1Z5Dr7pfDDiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vXSaDtZb; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vXSaDtZb"
Message-ID: <d745d9cf-2dc6-4240-a4be-1982082c0d28@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765804316;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r9yFXxAMD/81OanYZYiz/8z7/p4g5Jd9QYnGVTvdotg=;
	b=vXSaDtZbmv3aI4D1ZVgBHHvZCdV41emTgZSASfquFBJjUXVHs+S2We1A0O5RWyp+/tYRSC
	w7t6JddOU5uwtyUkvdWmpE76lsnu9lbxbCl7qVvu4PUW0VbInOIF8moE0EUsGmmD31Gdhr
	OuIToRCGM4wbLfSnSSRkork6rMzedcM=
Date: Mon, 15 Dec 2025 21:11:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Subject: Questions about SMB2 CHANGE_NOTIFY
To: Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>
Content-Language: en-US
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi,

I am currently using the following two methods to query a directory for 
change notifications on the client side:

   - `smbclient`: 
https://chenxiaosong.com/en/smb2-change-notify.html#linux-client-env
   - Windows "File Explorer": 
https://chenxiaosong.com/en/smb2-change-notify.html#win-client-env

Are there any better tools to print detailed info about change 
notifications on the client side, or any userspace C program examples 
(using `ioctl`) available?

Thanks,
ChenXiaoSong.


Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C9A1DE2A5
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 00:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785199818; cv=none; b=P6KhqvzAzETys4y+7bR+NsYrtmT9Tnd3E1UJ3ATjIoqGjFv1X9WemIvAyJDp803C/VMmiorzeVytqn4l5ojPhKmPgtbze7NXloLvVsb8hDr5RpqfUt+X1xZVlXqSQ4UVQk8yd/Mxw3c02cq8ZZ7zkiX75cqZtRjHJGv89dU5M5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785199818; c=relaxed/simple;
	bh=gCABzJxJBbXRAYSgUzYWzERmUkAawb4I3a9LG0G/LrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dDIl6/6U4jZcmEdJjgpj5jjUnw54AaGiBKjIJecAA7JCrA+95Wk1t1NZgTwElAzThviA2t4V0Q5ol7MR/2KPRUBdpTlLEZf9dpSJURolpbfNJTmgwgQy2I4DE3VP/rELpzs8psVqm6f8MXLMcCK8E96FD4XZLGyZ+BRSovZIyVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=nIGl/3wL; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="nIGl/3wL"
Message-ID: <6c4b4154-6d3e-49ae-bdb2-483f0a3a2b4a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785199808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BdL1Y0qjdva0zhE9dwbS4HNl5tTaDrja6H//BtNNEHc=;
	b=nIGl/3wLc2d88ekFHM/gtoXCCbMEsVgBaVq8+t1bZPnEAR93aUs80V2eFknTNyf1VHFCXK
	X3d47NNLQhbAdln0cj1fBz/HXBKqs89LaFzFodL5YW/gr6fymuiotM+NjXhDIwYxVjXSPY
	bpI3E791CX+zsddQ/hQHGj8uW+Xd7hItx6TIqpHXThZnnfIlzACYIa64INljiYE1vPEEaK
	TA1Uw08VlHKdbyQtuabRgKDPAth6O5S/PlUzVbDk0FI6q+vDWmQrFZibwioCKhR1pdiRes
	GbLni8iwGzYV1GSNR7g7Wo0LT0oD2K/x7G4q+swut+fznrI4mcwAyQ7lGqOx/A==
Date: Tue, 28 Jul 2026 08:49:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/15] smb: add native security and trusted xattrs
To: Steve French <smfrench@gmail.com>, Ralph Boehme <slow@samba.org>
Cc: tanze <tanze@kylinos.cn>, Steve French <sfrench@samba.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Jeremy Allison <jra@samba.org>, tom@talpey.com, linux-cifs@vger.kernel.org,
 Stefan Metzmacher <metze@samba.org>, "vl@samba.org" <vl@samba.org>
References: <cover.1784888897.git.tanze@kylinos.cn>
 <23f16c23-6221-4fcf-8cea-20eb36f47b9e@samba.org>
 <767aee26-2d03-4558-b473-70c3267dfdaa@kylinos.cn>
 <5ec4703f-12ca-4cce-9801-3f8a1a1ceabb@samba.org>
 <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAH2r5mu7Ra8vxkR4sNUy560FX5=R7pMzA-7k19p1j5bV28V-+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Our company has some urgent matters to deal with this week. We will 
review the protocol changes proposed by Ralph as soon as possible.

By the way, do we need to extend the protocol to support `chattr +i 
testfile`?

On 7/28/26 08:35, Steve French wrote:
> What other protocol improvements should go into the new version of the protocol?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en


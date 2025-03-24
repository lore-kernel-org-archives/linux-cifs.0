Received: from smtp-fw-9106.amazon.com (smtp-fw-9106.amazon.com [207.171.188.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B3C189520;
	Mon, 24 Mar 2025 22:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.171.188.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742854384; cv=none; b=dLmGOaPkXqfjB7xYzSbvaLO84TeDbTZMfjlM42gsLI85PlFd+Erz/wKkXd+41b9XPBdmcyV002lUO1BbK48YMBTKw7H/oN0basFZuzmcEBUjQAI88vk+gD9u8GPdH5qoRgLlQ5+THnAfJIGelIAFsr/IScGx+v80TkDZgjuhRZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742854384; c=relaxed/simple;
	bh=pxZV0lCq63K2Xm8Qxzn2wrfkO5sFjrmTs+gHDwFzjd0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JNkv4bM0icsjHU4roghQN1o1qH6YIKEaFo7GB2++lHr5+63m9jeRiIYJmrXaqiMW3pRyZqLqKJ6D4XQWmD+smWdHIOl7tnFg+VI/TpzQUqeswOlUSbMrbNwmzqQ3/j+sGMC1vJ0AVo+bKvlJABRJ2rqmP2UTyUmhIPH3a4J3UNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.co.jp; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=EvyuXIeA; arc=none smtp.client-ip=207.171.188.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="EvyuXIeA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1742854383; x=1774390383;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=k60Gai7cX/McVhIUIlEfUcNBi1wmCrikip+HM5lWowk=;
  b=EvyuXIeAXU+eSeQMsFdRwVNmjT+wKJGQ8Flff797+GmSTYGL5Ko3KlLk
   lfrK+VF9ZLySqFQtAy0p7nQyLkEOjLY8/RBmskMp7eUpis1g9/jnhl8bW
   mGyB0gyKhogl/gwy/SEuhN2w5YjYUt/gMU6e6tw5LqhLt1MCAghcWDzht
   Q=;
X-IronPort-AV: E=Sophos;i="6.14,273,1736812800"; 
   d="scan'208";a="810194261"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-9106.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2025 22:12:38 +0000
Received: from EX19MTAUWC001.ant.amazon.com [10.0.7.35:35727]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.41.16:2525] with esmtp (Farcaster)
 id b69190ba-5547-4800-ac46-7b9b581386b6; Mon, 24 Mar 2025 22:12:37 +0000 (UTC)
X-Farcaster-Flow-ID: b69190ba-5547-4800-ac46-7b9b581386b6
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 24 Mar 2025 22:12:36 +0000
Received: from 6c7e67bfbae3.amazon.com (10.106.100.20) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 24 Mar 2025 22:12:33 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <chenxiaosong@chenxiaosong.com>
CC: <david.laight.linux@gmail.com>, <chenxiaosong@kylinos.cn>,
	<linkinjeon@kernel.org>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<senozhatsky@chromium.org>, <sfrench@samba.org>, <tom@talpey.com>
Subject: Re: [PATCH] smb/server: use sock_create_kern() in create_socket()
Date: Mon, 24 Mar 2025 15:11:36 -0700
Message-ID: <20250324221225.73511-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250324210747.3dc899b9@pumpkin>
References: <20250324210747.3dc899b9@pumpkin>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)

From: David Laight <david.laight.linux@gmail.com>
Date: Mon, 24 Mar 2025 21:07:47 +0000
> On Mon, 24 Mar 2025 06:51:55 +0000
> chenxiaosong@chenxiaosong.com wrote:
> 
> > From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> > 
> > The socket resides in kernel space, so use sock_create_kern()
> > instead of sock_create().
> 
> As in the other patches you need to worry about whether the socket
> holds a reference to the network namespace.

Right, and if you don't see any real issue, I recommend leaving
it as is for now because we have seen many refcount issues for
kernel TCP sockets.

And I totally forgot to respin my series after holiday to clean
up such callers.
https://lore.kernel.org/netdev/20241213092152.14057-1-kuniyu@amazon.com/

I'll repost v4 after the merge window with some modification

  1. be less invasive as suggested by Paolo
  2. use sk_net_refcnt_upgrade()

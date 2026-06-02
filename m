Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BD1F35F8D2;
	Tue,  2 Jun 2026 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780424306; cv=none; b=CDSp+pGw6JUfa7pVI2Z+WrAOR91BsvUFe9zI2fqxb3LyG3yXK7sqVkjPPbfS+rlW4JtksD/DAf6Gv3Cw+F1/bR3p1ccXM8M9lgk32tMGaeQzxTsCOqZ+RypzECZ7bI55WBxPZKkdWvy1zWDvDeTNYRB9UDiT6Cm/ZHiXEc/5NYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780424306; c=relaxed/simple;
	bh=kaiP5nlmx+o6J5dZn3NEtFmE+/1HE1JUKqGhpXDCNTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3mSxbpF/6gxs8peUdyKPCRHvNVFdxZZOxgQrTq4JH/aKagjoCsvvRSS8bJdxec9QzaOc9E/mx6WKEc8fG7n1lRImV1Cx87GrSP81SyAOt7QlkWPVZUGfe+b4X+nmKofWkWLQiEcuAUwXVuCxhGclOPs5EoO4wKTgnOMjpz9jtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTzLFTrT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTzLFTrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3181F00893;
	Tue,  2 Jun 2026 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780424305;
	bh=tDyACb5/KqIGSD/zVzhz+P1a4GYNHCqoT3JaADnFHhQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nTzLFTrTFDNrds9z+BHs394zIpMQnncSZ4LXYu1cjVIecgdX4KfmqViJq75KQHnuK
	 abGBei3kUWObVS5dyh9mXuz/K5Fam0en2eakjVz/HigNAtrrNMiKcM8y1XZ554HLPF
	 4Ak4VGu63ZFHb6m3S/mvcQOViokzTcoWHewkWPfmS1QNHvpiHVeomNowhbIFYRWbsv
	 7KumAtMzFLELe/cAzhLLDVPj6BbSQJSphC1PbbT+HrKjTxlheI12ZAyyZkQi+wyq2C
	 1c/8QxH7mL4uPjYRAMQqivEvJX3FcdLJ1VD4RbAph4syzrxg2BYhJoMqH/xgNTgjei
	 lqyacgx2jzZWg==
Date: Tue, 2 Jun 2026 11:18:23 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Steve French
 <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey
 <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, Chuck Lever
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring
 <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, Matthieu Baerts
 <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, Cong Wang
 <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Jason
 Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>, mef@scarletmail.rutgers.edu,
 paul@jakma.org
Subject: Re: [PATCH net-next v12 00/15] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20260602111823.0b1129d6@kernel.org>
In-Reply-To: <CADvbK_fBbLCwY61HXsNeGCA8MhiBKcbvE0BvSZppohJgtXO+2g@mail.gmail.com>
References: <cover.1780232930.git.lucien.xin@gmail.com>
	<CADvbK_fBbLCwY61HXsNeGCA8MhiBKcbvE0BvSZppohJgtXO+2g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jun 2026 09:12:30 -0400 Xin Long wrote:
> Note: I've run Sashiko on this patchset many times locally over the past
> month and addressed all the real issues it found. I don't see any new real
> issues being reported on:

Coccinelle had a report tho:

The NIPA CI coccicheck run flagged a new Coccinelle warning introduced by
this patch:

  net/quic/crypto.c:1164:13-20: WARNING opportunity for kmemdup

At line 1164 of the newly introduced net/quic/crypto.c, there is a
kmalloc() call immediately followed by a memcpy() into the allocated
buffer.  Coccinelle's memdup checker suggests replacing this two-step
pattern with a single kmemdup() call, which is the preferred kernel idiom.

The fix is straightforward - replacing:

  p = kmalloc(len, gfp);
  if (!p)
      return -ENOMEM;
  memcpy(p, src, len);

with:

  p = kmemdup(src, len, gfp);
  if (!p)
      return -ENOMEM;

Please update the patch to use kmemdup() at that location.

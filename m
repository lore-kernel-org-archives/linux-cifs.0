Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349773;
	b=tt2sGHOAmXZxWOcXTleSgn5Hb23I9Rpk9vE3clUX7d5P2weiRXmvlCbnuG97SUmOB0K+
	 KHz+9DX7GaCp0fyT8uGgF3Q5ucjj8hd0iHavthG5qbUDnZnoJWZRuLYafke0QwUuHVrRU
	 dCl1y6FRIHx9/JrdQF1Q1v5hFHfZszqUYlv2SUXsc37GBRsBv7F0ZuAJVcHmIZILA5uBP
	 7UNgP63VAczAklZkF6UJJRy5j39nWTh0TF/jItQ6ByHo1YPQ0+WaOlh32FHXrFJRx5djd
	 m/zamFxu3mxoksBZe5X6Up5/y8ewT/zGiB/WAXptAof8lGF1iP/u5kFZa3m/JsODDjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349773;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=12aZd4VVZmazmO2LqNFc3EaBHnp9dr+S95mvD22St/k=;
	b=lxtF3JIW+t2+S1vdVwIXe/g5d1Uge4YSOS+pHsIIIZ+w7vz4fY0EXnVVNmTxnv4S7Jc/
	 hjNchnh8EPoRL74BukalVN0Jr+fTTKd3zLdLJmnLmzmkxOnkdWIT8KjXHLeyBSPzxR8q6
	 6yIWUC87pnXSOlj+xAmZOgINozXgcFMDMFS18xgt9aC6BpA5qkHlJEtVRHhL+oE41UDKs
	 Q/3+ktJHk8jgFfkBS07eGXYgwWaZ6OrAUGhiAeET6MXTsRlF4mgNN4Nyi3EDrzCu4+S6T
	 29cvI0Qfl3xZ2f9u7xrlRgaT4zF5+kurYKK70sBo9g9UQ95yl/9RLXrPm171aS2zpSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivezAf21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0399606A31C;
	Tue, 10 Nov 2026 22:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ivezAf21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A4F1F008A2;
	Tue, 10 Nov 2026 22:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349772;
	bh=12aZd4VVZmazmO2LqNFc3EaBHnp9dr+S95mvD22St/k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=ivezAf21BC5uxVSyWLO8nK/O+uPoddW4Sj29qqKHnmIkpppWEWnjyIiMmWIKfDWc8
	 rnowyCy/clYGQ0yX9QBZeFvu5j3spGAF9MG1I1ZpVtFpJqFdATaMb1r4gJVmXbvePJ
	 oEsZ1FTf3Fua2N0hwbc3I4mG4oRuXkQOhrSQs9nH88r6tfHdV8XhdczdbI7s4Xhdsu
	 ARZ3FqOAughIbNH2tEE8fUNXGVq8JX3ispl7PgFHFnwzOlMMG/V/y+FR8RLagovRpN
	 wXffMzcO5UowLrhQVPcUkgSJGqvmpcC5/86xVY/0eRQqgVNY/Ckz0g8WrKj85XkSLA
	 2civDFz0pU74Q==
Subject: Re: [PATCH net-next v18 02/15] net: build socket infrastructure for
 QUIC protocol
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 cel@kernel.org, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Tue, 10 Nov 2026 22:29:30 +0000
Message-ID: <179434977013.994134.13824008759137549463@kernel.org>
In-Reply-To: <1e1b85634f2cb7d625785edfe50b68a9af6508c7.1794241655.git.lucien.xin@gmail.com>
References: <1e1b85634f2cb7d625785edfe50b68a9af6508c7.1794241655.git.lucien.xin@gmail.com>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The tag block of commit "net: build socket infrastructure for
  QUIC protocol" reads 'Signed-off-by: Xin Long <lucien.xin@gmail.com>',…

--

net: build socket infrastructure for QUIC protocol

This patch adds the base socket infrastructure for QUIC: Kconfig and
Makefile integration, proto and proto_ops registration for IPv4 and IPv6,
per-net SNMP counters in procfs, and sysctl knobs for memory limits. Most
protocol operations are placeholders that later patches in the series fill
in.

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

[Severity: Low]
This isn't a bug, but are the sign-off tags in the right order?

Documentation/process/submitting-patches.rst gives two rules here:

  - A Co-developed-by tag must come directly before each co-author's
    Signed-off-by.

  - "the last Signed-off-by: must always be that of the developer
    submitting the patch."

Xin Long is the author, and he also appears to be the one submitting the
series. The last patch, "quic: add packet parser base", has only his
Signed-off-by.

If Pengtao He co-developed this patch, the tags should look like this:

  Co-developed-by: Pengtao He <hepengtao@xiaomi.com>
  Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
  Signed-off-by: Xin Long <lucien.xin@gmail.com>

If he only handled the patch, the current chain does not match the route
the patch actually took.

Other patches in the series follow the same pattern, for example "quic:
add crypto key derivation and installation" and "quic: provide quic.h
header files for kernel and userspace".

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com

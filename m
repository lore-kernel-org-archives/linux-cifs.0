Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED20622D792;
	Wed,  7 Oct 2026 01:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335130; cv=none; b=fBteGD+0ISGjF9FXiBQcp1kjYBGiampuxTSq5GPN+GEFSSceNsW6wRcuzNNhJzwQHOcHLi5q7FjVcHrZx18mnrkmzJ03WHTkUf3NJ7OU9Ut9QE8sfqHYObm1x/xG36PHA/cboThDXx9LroqtBjUkrZIhQ/qq7M7uxff0JXjfd1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335130; c=relaxed/simple;
	bh=jcV/YrDciklQ64ImrojdOytnIzmqrf5KypYAa1OPeos=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CJy/xsBT/wQ30wHfqtd8Lc0OTXK3wJardhtiWKZhstenR6XGSBPkGKmM4DxBR4RtFQxj3ioQOOp+SFCHpm3b+OfnvUpzdQfs4rVfUsgp3WA6WolfVVOqhBisFyGAM+yTLQ7rTGqpcOlFhhg6OOahUqPZFhPqDrWkBiDzRCm/eeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nEO2CBb0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nEO2CBb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCEA1F0089B;
	Wed,  7 Oct 2026 01:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335128;
	bh=wKHyyNp5GK5EIRI17U7XP0m8Gp/Evxq6CjLupR5zW9g=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nEO2CBb0xnFyEEXY5o0B+TYQXT5pjVXunXgCU33EWLx+aTHZt0NfvMBK2Nbko7R4W
	 O27XQGVSh/bYbCwUOeLe4adndbIvug1kCbnWnGdPST7SEuNHbNDLS056fwOzGtCvyJ
	 yWqHTKVQud4wfNqV4BrpFjqgaKYdJJ1azDuj3W7qSEzZtR2TqUx13wzMF+1U2JuMFk
	 Zi6rHOLDdyS2bYsRQTv4sO/23P75GMGN2GuIBuIeCz9pynqVZHslTzPGMuk6uplFyw
	 NNhUmZQ5Iqo193QpSvD/CNJ7lqKu1dlBBlfPMiJwfLRkKNXL/5h9hfcMimWDtlC3oV
	 eR9uYFe7Bmepw==
Subject: Re: [PATCH net-next v16 13/15] quic: add timer management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Wed, 07 Oct 2026 01:05:26 +0000
Message-ID: <179133512635.434549.6258447143844661377@kernel.org>
In-Reply-To: =?utf-8?q?=3Caf1b489d765e3e585eec7d3ffd621273fea8d7d6=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Caf1b489d765e3e585eec7d3ffd621273fea8d7d6=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The Signed-off-by chain of commit "quic: add timer management"
  does not follow Documentation/process/submitting-patches.rst.

--

quic: add timer management

This patch adds struct quic_timer to manage the five QUIC timers: loss
detection, delayed ACK, path validation, PMTU probing and pacing. It
provides common reset, start and stop helpers. Expirations that happen
while the socket is owned by the user are deferred and handled in
quic_release_cb().

> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

[Severity: Low]
This isn't a bug, but is the Signed-off-by chain in the right order?

The author is Xin Long, but the first Signed-off-by is Tyler Fanelli's.
There is no Co-developed-by: tag either.

Documentation/process/submitting-patches.rst says:

  SoB chains should reflect the **real** route a patch took
  as it was propagated to the maintainers and ultimately to Linus, with
  the first SoB entry signalling primary authorship of a single author.

It also says:

  Since
  Co-developed-by: denotes authorship, every Co-developed-by: must be
  immediately followed by a Signed-off-by: of the associated co-author.

If Tyler Fanelli co-developed this patch, should this line go directly
before his Signed-off-by?

  Co-developed-by: Tyler Fanelli <tfanelli@redhat.com>

If he didn't, his Signed-off-by is in the wrong place.

Other patches in the series have the same pattern:

- "quic: add path management" (Tyler Fanelli)
- "quic: provide quic.h header files for kernel and userspace" (Tyler
  Fanelli, Stefan Metzmacher, Thomas Dreibholz)
- "quic: add crypto key derivation and installation" (Pengtao He,
  Moritz Buhl)
- "net: build socket infrastructure for QUIC protocol" (Pengtao He)

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com

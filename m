Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC0E199E89;
	Wed,  7 Oct 2026 01:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335109; cv=none; b=sZ6wtjRO3mTelgJOmnMPm9C8XG/y28plMUz/oeh5o8TRjnTTwi38r159KIctidp9DC9un5WZG7C/Tkh98iNMhT1Aa9+X6qPoBXB+1CsCyy48OgNsOAHl9nh8fCCDW554FnBCQ1t4pnTTuSkCIu/8HRb09Rq7S8yIHh4uv+Rrmfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335109; c=relaxed/simple;
	bh=yJwxlcF6wANrj3x6+A4sYyl/duGqEcB/5Zwq8X2Yl34=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HiedYcXMtybZK4E+kOBY5QA0m/TxnlO+qyHTBI3KKXaE9wxTRiF40nEsZtWwDahNCs+z3T773mQSbYvmj8UaxtDtrMJGGUEn7T/D6CelpxuhsCKmf+gaSmKK00Seeg96xavbbIwqKd3E14SgtMXdD28oXzAnO8Ys3D/KEA0GBSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j1C3duRy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j1C3duRy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA9C1F0089D;
	Wed,  7 Oct 2026 01:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335108;
	bh=PpsAE/6bEpWEMOEly9QkxhEEOf0pvAMKHwSgMB/Mpq0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=j1C3duRyWO3yTck4+7mfHg3jAuDPWILMFwL2/MuyBs4cisVNhArdmhcD8R8NX/syB
	 AjM1UMH42fpSOtJiWxAhfusb/SaQ+Nl9JQo2hrJUiiuKnhuK75pt6KlhDXmgrEOWAE
	 6qz7WlB4QV5jTftGBq2CVo+kFErXqOIvMKctazyx+GKex1R0xjKMmrKwxgxHUCbKjB
	 Nro1SMq9mIYmNC0BZTiJkiLXNTS1QTxzSg3ov+KIpyntcFjXBJ4MltWphhN4m0zjuf
	 CVBbDQ2Ra+0BV3j59ZFRurDYoxARXm8hvVP9Cie+R2nSgPq8EPo27XuFuOPGQFG3Al
	 md6Hjg4zSXfdw==
Subject: Re: [PATCH net-next v16 05/15] quic: provide quic.h header files for
 kernel and userspace
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
Date: Wed, 07 Oct 2026 01:05:05 +0000
Message-ID: <179133510572.434549.6163094018291053303@kernel.org>
In-Reply-To: =?utf-8?q?=3C8ef5b145dbf8fece0920ca9cb737eb15688426fa=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C8ef5b145dbf8fece0920ca9cb737eb15688426fa=2E17912270?=
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

- [Low] The commit's Signed-off-by chain doesn't follow
  Documentation/process/submitting-patches.rst.

--

quic: provide quic.h header files for kernel and userspace

This commit adds include/uapi/linux/quic.h, which holds the QUIC socket
API definitions: control messages, socket options and event structures.
It also adds an internal include/linux/quic.h that exports
quic_do_setsockopt() and quic_do_getsockopt() for kernel consumers.

> Signed-off-by: Tyler Fanelli <tfanelli@redhat.com>
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Thomas Dreibholz <dreibh@simula.no>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Paolo Abeni <pabeni@redhat.com>

[Severity: Low]
This isn't a bug, but the trailer ordering here doesn't seem to follow
Documentation/process/submitting-patches.rst.

The From: author is Xin Long, but the first Signed-off-by is Tyler
Fanelli. Two more sign-offs from other people come before the author's
own. The document asks for the SoB chain to reflect the real route of
the patch:

  "with the first SoB entry signalling primary authorship of a single
  author."

The same document also says that each co-author should have a
Co-developed-by: line directly before their Signed-off-by:.

Did Tyler Fanelli, Stefan Metzmacher and Thomas Dreibholz co-develop
this patch? If so, could each of them get a Co-developed-by: tag, with
the trailers reordered to match the documented example for a patch
submitted by its From: author?

If they reviewed or tested the patch instead, would Reviewed-by: or
Tested-by: be the right tags?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com

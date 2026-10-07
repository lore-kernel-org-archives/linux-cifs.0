Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679EF22D792;
	Wed,  7 Oct 2026 01:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335122; cv=none; b=esOdtG/YmTxJQ7f1KtNRi+VO04J/9uqRo972hwuyWufi74shIcJJK4OmsPf885eks9Ds2A1mwNRqZJvljZrzlqBZC8VAt4oC4NcTDwOEr2+7udOXD425Wz44dwQkvhTgTkeWR4JL4jk7k8mnVc6HdGvPgwOK4NYKu5wlAkH3g84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335122; c=relaxed/simple;
	bh=KtY9H8H7O/Cb6mcqTI+yuCnH2LoWzbIJtqmjRMEvxIo=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IBIF7FbcOInCeUk8wE8VPXoOpjEQyjTG095pUzq34OXQEgc51AVvzHp7lI7u9NJah8ypucLWtvAtX7BK1zfMssJC0jmYx9I1H8/E4XXBhwVAzyMCwj78l5emIdjsqeyUSJ6iQFyLNvi1th/4W6HzVMabjnkF0fjDGkc8L4h4OLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IMMJXWrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IMMJXWrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE4E1F0089C;
	Wed,  7 Oct 2026 01:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335121;
	bh=9B7VDfkF9cuaiAEuwLf9hvLT6HuP7LMtIr2TzvUW/0Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=IMMJXWrYfqJFY5cnKKOokW4td3/qyNWzfgsJDgnHelOdSejiQ17zYTqXdC+hCj3O9
	 ZOqwXqo+IOKsGQV2UE9C8CLL2tw+sFYMb6Ckfbgn0FUJziW8lXmDzAr23zSlpCW8Nu
	 jYDI/N34yj8d5Dz8eGbj1uCnEFISmrBSuS2ZLucv4Tlwg/bTfLmzIz0Gqkz1Jffk81
	 w+AF+jDjpbsPqgJBujdukYjsTTJTauSaIMiOM9A9/cfxVpOk0uUAKxCme31+SmHkUb
	 OVwgW+kANtD6ya2wmBRM1Z0j4ProgTuSpN9P80YvowuIiGQJQSOIBAJyxNFB9jYTBj
	 VcA2b1icgcDAw==
Subject: Re: [PATCH net-next v16 10/15] quic: add packet number space
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
Date: Wed, 07 Oct 2026 01:05:18 +0000
Message-ID: <179133511883.434549.1095545154530968761@kernel.org>
In-Reply-To: =?utf-8?q?=3C4e13764a900fab1fe886a34a3c05351262b9a585=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C4e13764a900fab1fe886a34a3c05351262b9a585=2E17912270?=
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

- [Low] The commit message of "quic: add packet number space" does not
  mention ECN anywhere, yet much of the new API is ECN accounting and…
- [Low] The pn_map layout comment above struct quic_pnspace in
  net/quic/pnspace.h gives the size-based trigger for advancing the map…

--

quic: add packet number space

This patch adds struct quic_pnspace to track per packet number space
state such as next PN, inflight bytes, loss and ACK timestamps, plus a
received-PN bitmap. It provides helpers to check and mark received packet
numbers and to build gap ACK blocks for ACK frames, with APP and EARLY
sharing one packet number space.

> It maintains the next packet number to assign, tracks the total length of
> frames currently in flight, and records the time when the next packet may
> be considered lost. It also keeps track of the largest acknowledged packet
> number, the time it was acknowledged, and when the most recent ack
> eliciting packet was sent. These fields are useful for loss detection,
> RTT estimation, and congestion control.

[Severity: Low]

This isn't a bug, but the commit message never mentions ECN. A good part
of the new API is ECN accounting and validation.

The patch adds:

- the ecn_count[QUIC_ECN_DIR_MAX][QUIC_ECN_MAX] array in struct
  quic_pnspace
- the QUIC_ECN_LOCAL/PEER/ACKED enum
- the helpers quic_pnspace_inc_ecn_local(), quic_pnspace_inc_ecn_acked(),
  quic_pnspace_reset_ecn_acked(), quic_pnspace_has_ecn_local(),
  quic_pnspace_set_ecn_peer() and quic_pnspace_validate_ecn()

quic_pnspace_validate_ecn() implements the validation rules from
rfc9000#section-13.4.2.1.

The ECN history only appears in the changelog below the --- line, and
that part is dropped when the patch is applied.

Could a sentence be added along the lines of: "It also tracks
per-codepoint ECN counts (locally received, peer-reported, newly acked)
and provides helpers to validate peer ECN counts per
rfc9000#section-13.4.2.1."?

> diff --git a/net/quic/pnspace.h b/net/quic/pnspace.h
> new file mode 100644
> index 0000000000000..67981d5f1849c
> --- /dev/null
> +++ b/net/quic/pnspace.h

[ ... ]

> +/* Packet Number Map (pn_map) Layout:
> + *
> + *     min_pn_seen -->++-----------------------+---------------------+---
> + *         base_pn -----^   last_max_pn_seen --^       max_pn_seen --^
> + *
> + * Map Advancement Logic:
> + *   - min_pn_seen = last_max_pn_seen;
> + *   - base_pn = first zero bit after last_max_pn_seen;
> + *   - last_max_pn_seen = max_pn_seen;
> + *   - last_max_pn_time = max_pn_time;
> + *
> + * Conditions to Advance pn_map:
> + *   - (max_pn_time - last_max_pn_time) >= max_time_limit, or
> + *   - (max_pn_seen - last_max_pn_seen) > QUIC_PN_MAP_LIMIT

[Severity: Low]

Does the second condition match quic_pnspace_mark()? The code limits
the reference point to base_pn:

net/quic/pnspace.c:quic_pnspace_mark() {
    ...
	last_max_pn_seen = min_t(s64, space->last_max_pn_seen, space->base_pn);
	last_max_pn_time = space->last_max_pn_time;
	if (space->max_pn_time < last_max_pn_time + space->max_time_limit &&
	    space->max_pn_seen <= last_max_pn_seen + QUIC_PN_MAP_LIMIT)
		return 0;
    ...
}

So the map advances once max_pn_seen is more than QUIC_PN_MAP_LIMIT past
min(last_max_pn_seen, base_pn).

base_pn can be lower than last_max_pn_seen. During an advance,
quic_pnspace_move() only moves base_pn to the first zero bit after the
old last_max_pn_seen. Then last_max_pn_seen is set to max_pn_seen.

If a packet between those two points is missing, base_pn stays below
last_max_pn_seen. In that state the code advances earlier than this
comment says.

This base_pn limit is what keeps pn - base_pn inside the
QUIC_PN_MAP_SIZE bitmap. Could the comment be updated to show it, for
example (max_pn_seen - min(last_max_pn_seen, base_pn)) >
QUIC_PN_MAP_LIMIT?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com

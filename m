Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349781;
	b=Z0mblrbdN0b/zIWEwSOiThpwEjmOTNhEZtVPLVXWBux+vDHed6ITPHLe3RtDvcBd/Gj6
	 pGlyo8ICe+e+5244FtsklvX8swhuLMyLArLTIWccPyfDAqcFqVkcUSL+whQ0uLp4t90cp
	 w25SB3zauXOJ30F3UJiffP01BgPG/I2QK+/IR0rCRZdJZ0PwcMauLA+OEKTusXURNVqr9
	 Uvh5rNsmTR8UtS/XVbKFVXvGV70COCrfpZUJ2OKh+7WUBpIZMbFxRg4fIRDtExEyNWn5X
	 7xOr7JUbR/zjXzwQSTM9H2+cDAbT9kzI4QAO+SBHJrCH2c5U9EANd13aKGMELs4qoyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349781;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=D0LaGsanjVD3rU06xCeYUAHvTsoW/AnFS7pbjF7PdAI=;
	b=J8eTkANMbQlEXzCYhJOhmxI0H9S9gAXcHHuRz+PYsl4tVgdmmoxcEuK7dQGA5n0Q0N+x
	 9xhPknQLESyxAMiy4phaJ6T0mGUjK2GO9pibhbMtecS2NX+Ij6Ur/Hz6H7KUhyasc1VN6
	 ohH6N+J2PxEk2To3ClCKh1I9i/T8GuHY2GVvTXZW99uovopE08TE1o/0qY6rt03Nu25us
	 MYqcw6H3WD6MbeH86SyqmyfMqOfwXbqZkCX5IbAxsaR7Jl+0bBPQA5ScOHkV6sgnqlmxW
	 0ULcblsWxE9M8/0oGMw/ZAeelbzt+9KwwqCzMKAQ/ivsMZxMqWYbrSJloREzzxyEjLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZw8zF6C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC0A606A325;
	Tue, 10 Nov 2026 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PZw8zF6C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CDF41F008A3;
	Tue, 10 Nov 2026 22:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349780;
	bh=D0LaGsanjVD3rU06xCeYUAHvTsoW/AnFS7pbjF7PdAI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PZw8zF6CnFVgMY7f3qG7tAoFui9g9BLTqLWBVGtNNAgeDsiak+yQ+UBP3Pa7sk6/E
	 +97LoZ/p+wweGza1S2QL13hQLoOZ/X7jDGT5OGvCg/5xvMyWb1/AnJgvm5ZtjT0ebN
	 oGu4TEPbYZmhHWt4b8WmM02qLXJmjAgiMk5Bn2z2m8UydeP+mFgFrfPRR4lPtk9nBP
	 WF0q/T0APZVi3i+INcIizKblzdVNJq3D/Bj/89bZINenSBox3kl1/ca+IZXaTBEfju
	 C19az/bE8rbjNHm7dF2B5N79KIPb4fylVWNuEoRwSW5DEgfCYa8Q5gh69VXZ7D45ZX
	 vspsWO8k2mmvg==
Subject: Re: [PATCH net-next v18 07/15] quic: add connection id management
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
Date: Tue, 10 Nov 2026 22:29:37 +0000
Message-ID: <179434977756.994134.8929104101309471837@kernel.org>
In-Reply-To: <b0f3555fe5a07cddad4b5df3fcf179c9deb1378d.1794241656.git.lucien.xin@gmail.com>
References: <b0f3555fe5a07cddad4b5df3fcf179c9deb1378d.1794241656.git.lucien.xin@gmail.com>
X-sashiko-severity: Medium
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

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_conn_id_retire() in net/quic/connid.c starts with `if
  (WARN_ON_ONCE(id_set->use_count <= 1)) return;`.
- [Low] The commit message says quic_conn_id_token_exists() checks 'if a
  stateless reset token exists in any dest Connection ID'.
- [Low] The connection ID patch also rewrites the comments on
  bidi_blocked/uni_blocked in struct quic_stream_limits…

--

quic: add connection id management

This patch adds struct quic_conn_id_set to manage source and destination
connection IDs. It also adds helpers to add, retire, find and look up CIDs.
Source CIDs are inserted into the global hash table, and destination CIDs
can be checked for stateless reset tokens.

> - quic_conn_id_token_exists(): Check if a stateless reset token exists
>   in any dest Connection ID (used during stateless reset processing).

[Severity: Low]
This isn't a bug, but is "any dest Connection ID" accurate here?

quic_conn_id_token_exists() stops at the furthest used CID, which is the
larger of active and alt by sequence number. It also skips all-zero tokens,
so unused destination CIDs are never compared.

That matches RFC 9000 Section 10.3 and the code comment ("in the used
connection IDs"). The only explanation of the narrower check is in the v17
changelog below the "---", and that part will not be kept in git history.

Could the commit message describe the used-CID-only check instead?

> diff --git a/net/quic/connid.c b/net/quic/connid.c
> new file mode 100644
> index 0000000000000..63bf39e71b15f
> --- /dev/null
> +++ b/net/quic/connid.c
> @@ -0,0 +1,311 @@

[ ... ]

> +/* Retire a connection ID by marking it dead, then remove consecutive dead
> + * entries from the head of the list. The caller must ensure the number fall
> + * within the consecutive range [first_number, last_number].
> + */
> +void quic_conn_id_retire(struct quic_conn_id_set *id_set, u32 number)
> +{
> +	struct quic_common_conn_id *common, *tmp, *retired = NULL;
> +	struct list_head *list;
> +
> +	if (WARN_ON_ONCE(id_set->use_count <= 1))
> +		return;
> +
> +	list = &id_set->head;
> +	list_for_each_entry(common, list, list) {
> +		if (common->number > number)
> +			break;
> +		if (common->number == number) {
> +			if (common->dead)
> +				return;

[Severity: Medium]
Can retiring the same number twice trigger the WARN_ON_ONCE() in
quic_conn_id_retire()?

The dead check here suggests a duplicate retirement is meant to be a
harmless no-op. The use_count check runs before the lookup gets this far,
though.

Take a source set with CIDs 0 and 1 (count == 2, use_count == 2):

quic_conn_id_retire(set, 1)
    entry 1 is marked dead, use_count becomes 1
    entry 1 is not at the head, so it stays on the list

quic_conn_id_retire(set, 1)    (e.g. a retransmitted RETIRE_CONNECTION_ID)
    WARN_ON_ONCE(id_set->use_count <= 1) fires
    the "if (common->dead) return;" path is never reached

The comment above the function only asks the caller to keep number within
[first_number, last_number], and 1 is inside that range here.

RETIRE_CONNECTION_ID frames, and NEW_CONNECTION_ID frames with Retire Prior
To, come from the peer. Once frame processing calls this helper, could this
become a WARN that the peer can trigger, or a panic with panic_on_warn=1?
Nothing in the series calls quic_conn_id_retire() yet, so this depends on
how future callers use it.

The function also returns void. How would a caller tell a refused
retirement from a successful one, for example to raise a
PROTOCOL_VIOLATION?

Would it make sense to run the lookup and dead check before the use_count
check, or to return an error instead of warning?

[ ... ]

> diff --git a/net/quic/stream.h b/net/quic/stream.h
> index 48b27aa339679..c96d1516ecbec 100644
> --- a/net/quic/stream.h
> +++ b/net/quic/stream.h
> @@ -84,8 +84,8 @@ struct quic_stream_limits {
>  	s64 max_uni_stream_id;   /* Highest allowed uni stream ID */
>  	s64 active_stream_id;    /* Most recently opened stream ID */
>  
> -	u8 bidi_blocked;  /* STREAMS_BLOCKED_BIDI sent, awaiting ACK */
> -	u8 uni_blocked;   /* STREAMS_BLOCKED_UNI sent, awaiting ACK */
> +	u8 bidi_blocked;  /* STREAMS_BLOCKED/MAX_STREAMS_BIDI sent */
> +	u8 uni_blocked;   /* STREAMS_BLOCKED/MAX_STREAMS_UNI sent */

[Severity: Low]
This isn't a bug, but this comment change in struct quic_stream_limits looks
unrelated to connection ID management. The commit message doesn't mention
it either.

Nothing in net/quic reads or writes bidi_blocked or uni_blocked yet, in
this commit or at the end of the series. So the new MAX_STREAMS wording
describes behaviour that is not in the tree yet. The only explanation is
the v18 changelog note, which is dropped when the patch is applied.

Would this change fit better in a separate patch, or in the patch that adds
the MAX_STREAMS tracking?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com

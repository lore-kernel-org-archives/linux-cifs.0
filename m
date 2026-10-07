Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21892D3A7C;
	Wed,  7 Oct 2026 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335114; cv=none; b=shQhnyHDzhLujNiXBVTbngcSLLwcOYpV5T+Xk2R3TuwDUcgmcNiZypoVqBr2pmGggWWmWPf/01YymTa9o4f0Kc3Ee+vVYsbVYk8ovw1CVbEULqzkxTokMWXB/9oagA6Tr9f7D87onhEGdgbzaSogYfBQDGHgaSLOvnLHKyQKtHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335114; c=relaxed/simple;
	bh=8/1Qb4AewVQpHdaQm1MF8s+QmioDWsQOpzrhBEYJNxw=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NIA9ZbxTPbo3/NzTIqSUHOwhRt5lT2tRf9A22YiRc36db+demRtRQBHNSM4fASjlIiydfv9X9HtpVcwUsy+QvI9YcRF00RRZJPGxk1o4m1Fzz62TCg7HE/WVIG0pF3E69Wla3td3yADtH9ef2lsnl89VSFyJe1KUg/HG2bRgP+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jEa+M+cm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jEa+M+cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD61F0089B;
	Wed,  7 Oct 2026 01:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335113;
	bh=Xq7GLbOOIEQ/6NUN4wszNsDKN70DhVApYIPnu9maoU8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jEa+M+cmEqXXduBA+AEcHrt0hnPP4ka3R8ZehKe///1W84Cpaskap6WqtdbP8ZaBq
	 KFkWUzMQ+GIq9uWnGlv/egOg2SbOrR//tq84Es2HHX9cNjOBPNqwZc/X1bGNvxO217
	 0qeAirbs/CWSuJyhyTJp3UpfCqA0KUxcPZ9PbjPg3QL/N3XHwSDxsSPeZ7k+O5lX1U
	 kkHhibugb9ErSFBPeBMY7RP3R2CkQDAZGge0mRUY1iK6pTqQDmcDFHOGLONZZjxdwJ
	 Xxoh38RI6r2a961N16l8+EhfVkSpIavUuMkPR6YPHQd0nVeYBvXyarZ/giC3pRHfFp
	 H340r4Q5zG2kg==
Subject: Re: [PATCH net-next v16 07/15] quic: add connection id management
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
Date: Wed, 07 Oct 2026 01:05:10 +0000
Message-ID: <179133511091.434549.10167408049094041303@kernel.org>
In-Reply-To: =?utf-8?q?=3Ced18828ce3e3c80f4d03ac0f393164af3a64176b=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Ced18828ce3e3c80f4d03ac0f393164af3a64176b=2E17912270?=
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

- [Low] quic_conn_id_token_exists() (net/quic/connid.c:52-71) checks the
  active destination CID's token first.

--

quic: add connection id management

This patch adds struct quic_conn_id_set for managing source and
destination connection IDs. It adds helpers to add, remove and find
CIDs, and inserts source CIDs into the global hash table. It also adds
lookup helpers for the RX path and for stateless reset token checks.

> diff --git a/net/quic/connid.c b/net/quic/connid.c
> new file mode 100644
> index 0000000000000..85b8fc481e608
> --- /dev/null
> +++ b/net/quic/connid.c

[ ... ]

> +/* Check if a given stateless reset token exists in any connection ID in the
> + * connection ID set.
> + */
> +bool quic_conn_id_token_exists(struct quic_conn_id_set *id_set, u8 *token)
> +{
> +	struct quic_common_conn_id *common;
> +	struct quic_dest_conn_id *dcid;
> +
> +	dcid = (struct quic_dest_conn_id *)id_set->active;
> +	if (memchr_inv(dcid->token, 0, QUIC_CONN_ID_TOKEN_LEN) &&
> +	    !crypto_memneq(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN))
> +		return true; /* Fast path. */
> +
> +	list_for_each_entry(common, &id_set->head, list) {
> +		dcid = (struct quic_dest_conn_id *)common;
> +		if (common == id_set->active)
> +			continue;
> +		if (memchr_inv(dcid->token, 0, QUIC_CONN_ID_TOKEN_LEN) &&
> +		    !crypto_memneq(dcid->token, token, QUIC_CONN_ID_TOKEN_LEN))
> +			return true;
> +	}
> +	return false;
> +}

[Severity: Low]
Should quic_conn_id_token_exists() match against every destination CID in
id_set->head?

The loop compares the token with all entries in the set. That includes
destination CIDs that the peer supplied with NEW_CONNECTION_ID frames
through quic_conn_id_add() but that were never used to send packets.

RFC 9000 section 10.3.1 says:

    An endpoint MUST NOT check for any stateless reset tokens associated
    with connection IDs it has not used or for connection IDs that have
    been retired.

It also limits the comparison to tokens associated with the remote
address on which the datagram was received.

Retired CIDs are covered, because quic_conn_id_remove() unlinks them. But
nothing filters out unused CIDs. As a result, up to QUIC_CONN_ID_LIMIT
tokens could accept a stateless reset and tear down the connection,
instead of only the tokens for CIDs that have been used.

No caller of this helper exists yet in the series. The commit message
says it is meant for stateless reset processing, though, so the
semantics are being set here.

> diff --git a/net/quic/connid.h b/net/quic/connid.h
> new file mode 100644
> index 0000000000000..105c2b4b0f2ec
> --- /dev/null
> +++ b/net/quic/connid.h

[ ... ]

> +/* Common fields shared by both source and destination Connection IDs */
> +struct quic_common_conn_id {
> +	struct quic_conn_id id; /* Connection ID value and its length */
> +	struct list_head list;  /* List node for connection ID management */
> +	u32 number;  /* Sequence number assigned to this Connection ID */
> +	bool hashed; /* true if stored in source_conn_id hash table */
> +};

[ ... ]

> +struct quic_dest_conn_id {
> +	struct quic_common_conn_id common;
> +	/* Stateless reset token in rfc9000#section-10.3 */
> +	u8 token[QUIC_CONN_ID_TOKEN_LEN];
> +};

Neither struct quic_common_conn_id nor struct quic_dest_conn_id records
whether a CID has been used or which remote address it is tied to. How
would a later caller limit the check to used CIDs without that state?

Would it make sense to track a used flag here, or to limit
quic_conn_id_token_exists() to id_set->active and id_set->alt?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com

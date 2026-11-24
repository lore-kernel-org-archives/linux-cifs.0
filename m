Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483275;
	b=fSUBm5UJgpOphPWokRMFahjPKLEw8wloSWCEXhs3rcJXleijxeW1GcSF93+LKWoexw5E
	 zDW1clmWgf3WOAm8/K3Gk8nUbTS1klkC/ut4x8kKRepNmFvu1XwtVmru8SIaG2OQatkpf
	 iWUiPcMo68IGa0BXXPHDT6VYR7II6sQdDOkDo+rUn2DoJ71SR/21vNaALHU+WjW10K8TB
	 qDfZyS4S2jmPYmUsH0L1J/xvU/gjqek/fq3qJjfMJMlduydYAMu3wK7CDQ1vUCNA1F0HW
	 teXV59ndGwXrRs3ZcbX4IeUN4xdV9nyoVXxWCWa0TH4nBjuXXo31QdPQANdaHb4K5ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483275;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=7BxqU8scciUBPlVCv6kfp0HrjxqNHAp0nu+Z1dMs47Q=;
	b=QZzaQHANqni0/yF6h6DCTMomI5GVCELS77TK2FFb4h8Hbng6GNpYFyV7/7lPWGU6pipA
	 3RgmY5KBupZchLnkMu49UXxFC/Hz0qdWTT4iJilRLNKL6+otgmbUuAdP0DpbVb2+01K8F
	 r7aQM4DOnRArB3c/daJ8ie7f0tvUKPOM6dda8x1JIFD/Ga7EgFzaheWhKLcwKj0Sd+sbW
	 +uVl18Bmb1Be0m8EMXmSHVsmVj2ZXPZZGiaMGTkaGsHR5Fucm9Prv8BvKy+F0eSP3sXG6
	 2x9iSGZDQqaTTDHHnuggUI9NQQ0t3MXjIWIEQc1UvmFJWb9WOt8lMi4/peWtZb53HjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYltFTcd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C49606A321;
	Tue, 24 Nov 2026 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYltFTcd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7261F000CF;
	Tue, 24 Nov 2026 01:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483275;
	bh=7BxqU8scciUBPlVCv6kfp0HrjxqNHAp0nu+Z1dMs47Q=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XYltFTcdnj4KUOr9OmoQ9oABFYaMWVxGNR6r3cGPjfnGq13/JFq2uMH7Tf1ScK72/
	 b6oInXa2z9HZnLBrfMTvLwgYZJM3WxktGM+KSBzzvTYiaSJ3lBsUjntul6AsyQ5oxT
	 jLioRVygZFw/Sd6FqOggYuxYgvI6lRuW/QXd+bceMSB4CrxfHEKpslz8iPAdj0gWDF
	 ZGluJ2nXRVgz09QGVMvNH0qSc3TqR6YDFE4bJCW8mI/cWjo7pGVOD5rI/JDcx2wUGE
	 iZSOHIuvA/zw6WUEBJsqTqcarDRxQoyNCoB4xy24Z8j8dKUj/Dar/b2jJfs9TWz+Dp
	 BizllNrn5tiRg==
Subject: Re: [PATCH net-next v19 07/15] quic: add connection id management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:12 +0000
Message-ID: <179548327264.3135.6491698928014688203@kernel.org>
In-Reply-To: <a0b0796446aa6da7e62134343e27abb459c3e4cf.1795393691.git.lucien.xin@gmail.com>
References: <a0b0796446aa6da7e62134343e27abb459c3e4cf.1795393691.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_conn_id_retire() (net/quic/connid.c) handles 'retire the
  last live consecutive CID' with `if (WARN_ON_ONCE(id_set->use_count <=…

--

quic: add connection id management

This patch adds struct quic_conn_id_set to manage source and destination
connection IDs. It provides helpers to add, retire, find and look up CIDs.
Source CIDs are also inserted into a global RCU hash table, which the RX
path uses to look up the socket.

> diff --git a/net/quic/connid.c b/net/quic/connid.c
> new file mode 100644
> index 0000000000000..1ddf8bc9b7910
> --- /dev/null
> +++ b/net/quic/connid.c
> @@ -0,0 +1,313 @@

[ ... ]

> +/* Retire a connection ID by marking it dead, then remove consecutive dead
> + * entries from the head of the list. The caller must ensure the number falls
> + * within the consecutive range [first_number, last_number].
> + */
> +void quic_conn_id_retire(struct quic_conn_id_set *id_set, u32 number)
> +{
> +	struct quic_common_conn_id *common, *tmp, *retired = NULL;
> +	struct list_head *list;
> +
> +	list = &id_set->head;
> +	list_for_each_entry(common, list, list) {
> +		if (common->number > number)
> +			break;
> +		if (common->number == number) {
> +			if (common->dead)
> +				return;
> +			retired = common;
> +			break;
> +		}
> +	}
> +
> +	if (!retired)
> +		return;
> +
> +	if (WARN_ON_ONCE(id_set->use_count <= 1))
> +		return;

[Severity: Medium]
Can a peer reach this WARN_ON_ONCE() using only its own
RETIRE_CONNECTION_ID frames?

For the source set, number comes from the peer. The v19 changelog moved
this guard below the duplicate-retire check so duplicates would not hit
the WARN, which suggests peer-chosen numbers are expected to get here.

A retired source CID that is not at the head of the list is only marked
dead. It stays on the list and stays hashed. quic_conn_id_lookup() does
not check ->dead:

	hlist_nulls_for_each_entry_rcu(s_conn_id, node, &head->head, node) {
		if (net != sock_net(s_conn_id->sk))
			continue;
		if (s_conn_id->common.id.len != len ||
		    memcmp(scid, &s_conn_id->common.id.data, len))
			continue;

Later in the series, quic_packet_get_sock() in net/quic/packet.c uses
this lookup to route the packet to the socket and set cb->seqno. It does
not check the dead flag either.

Take a source set {0, 1, 2}, all live, use_count = 3, with the peer
using CID 0:

  peer sends RETIRE(1), then RETIRE(2)
    -> use_count = 1, CIDs 1 and 2 are dead but still hashed
  no replacement CID is issued (count still includes the dead middle
  entries, so max_count or QUIC_CONN_ID_LIMIT may already be reached)
  peer sends a packet with DCID = CID 1 carrying RETIRE(0)
    -> quic_conn_id_lookup() still finds CID 1
    -> quic_conn_id_retire(id_set, 0)
    -> WARN_ON_ONCE(id_set->use_count <= 1)

RFC 9000 Section 19.16 allows RETIRE(0) in that packet, since sequence
number 0 is not the DCID of the packet carrying the frame.

On panic_on_warn systems this would be a panic the peer can trigger
remotely. Without panic_on_warn, the retirement is silently dropped.

quic_conn_id_retire() returns void, so the caller cannot tell a refused
retirement from a successful one. That means it cannot turn this case
into a PROTOCOL_VIOLATION.

Would it make sense to return an error here instead of warning? Or to
reject packets addressed to dead source CIDs?

No caller of quic_conn_id_retire() exists in this series yet. Whether
this fires depends on how the RETIRE_CONNECTION_ID handler in the
follow-up patchset checks the number before calling it.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80987455610;
	Tue, 15 Sep 2026 19:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501845; cv=none; b=pI+gTh9YxpQ8avtmWKYmyrF+amOWmfd0P85rXFhxweBli/5W58p7xKSxnIJbi9d73nY/Wv3JouWGmoLcB+1Q9rlO8TPrX8tc0FjZueX/a8dpo8IS4e98oxi/PlFimdk285IQR6BkgHBae8UoEkAYSySMe74ZhLrQfyJQ1QIllkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501845; c=relaxed/simple;
	bh=tC8c4Hfjl9K5O2Dg99ry1B3cUF734KPK0G/TpaJ7EiE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NuY8s5WdZtU+t58BLSv5lonD5uKp3RuBn3BhmYiONxXvKkkY87cZRSnzGmCCpH8dza1OqsNseATQeDlR3/NjsDwjrDCbxxNJp6GiSSqjKctSpB+j4MRodgXrF/8UQRh/fEMyBchlkbkXuslnRwTRIr2TA7g6g/fiPrhBjNiMxjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z1dNA6hQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z1dNA6hQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B74C1F00893;
	Tue, 15 Sep 2026 19:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501844;
	bh=wPIZ/DqfqszUSqqIOmHFIRGTmhababaQY+mW6tc3VLk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Z1dNA6hQ0potbJ7k1Txwxrl3E8/9VHbLT9xZar9JFAYrX5OnJ0Kg4jVFgT1n1dEoY
	 mcODZPGV0YuE/InNXzaIhjMymjzO3lI1BekFSIpvYDLvvk83NCFNBqCV44p+4Lz72L
	 uI0V6taWcwqbsP6iTvwpH+d+TXxBtqR4Ya0T23gnKuyAZutF9fM7IIM5aGTurEBGn/
	 rt+oVM/QtuGGS86pTE0/ykQi4DzXZJoQXtWF3rgtMAlLGMo4D9QShFBxGsZfO74oy7
	 87cO1d3GXlEnMjRW+ieG2jV/cOJ7xExBDMNzjWluZDbcwYKPuSSh5nQl5mhP31JWqS
	 LFVNHe6u+0u6Q==
Subject: Re: [PATCH net-next v15 07/15] quic: add connection id management
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
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:41 +0000
Message-ID: <178950184154.22033.11596322184319753011@kernel.org>
In-Reply-To: =?utf-8?q?=3C03da9d52c2e42c4e06c47dafd8437c38c2ee1d41=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C03da9d52c2e42c4e06c47dafd8437c38c2ee1d41=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] quic_conn_id_lookup() (net/quic/connid.c) takes a hard socket
  reference via refcount_inc_not_zero(&s_conn_id->sk->sk_refcnt) but…

--

quic: add connection id management

This patch adds struct quic_conn_id_set plus helpers to add, remove, and
look up source and destination Connection IDs, including insertion of
source CIDs into the global connection ID hash table.  It also wires the
per-socket source/dest sets into quic_init_sock() and quic_destroy_sock().

> diff --git a/net/quic/connid.c b/net/quic/connid.c
> new file mode 100644
> index 0000000000000..e726a1d02c970
> --- /dev/null
> +++ b/net/quic/connid.c
> @@ -0,0 +1,283 @@

[ ... ]

> +/* Lookup a source connection ID (scid) in the global source connection ID hash
> + * table.
> + */
> +struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len)
> +{
> +	struct quic_shash_head *head = quic_source_conn_id_head(net, scid, len);
> +	struct quic_source_conn_id *s_conn_id;
> +	struct quic_conn_id *conn_id = NULL;
> +	struct hlist_nulls_node *node;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	hlist_nulls_for_each_entry_rcu(s_conn_id, node, &head->head, node) {
> +		if (net != sock_net(s_conn_id->sk))
> +			continue;
> +		if (s_conn_id->common.id.len != len ||
> +		    memcmp(scid, &s_conn_id->common.id.data, len))
> +			continue;
> +		if (likely(refcount_inc_not_zero(&s_conn_id->sk->sk_refcnt)))
> +			conn_id = &s_conn_id->common.id;
> +		break;
> +	}

[Severity: Low]
This isn't a bug, but could the reference semantics here be spelled out?

quic_conn_id_lookup() takes a hard socket reference with
refcount_inc_not_zero(&s_conn_id->sk->sk_refcnt), yet it returns a
struct quic_conn_id pointer.  Neither the kerneldoc-style comment above the
function ("Lookup a source connection ID (scid) in the global source
connection ID hash table.") nor the prototype in connid.h mentions that the
caller now owns an sk reference that must be dropped with sock_put().

Recovering the socket from the return value also requires the caller to know
about the type-punning accessor:

net/quic/connid.h:
	static inline struct sock *quic_conn_id_sk(struct quic_conn_id *conn_id)
	{
		return ((struct quic_source_conn_id *)conn_id)->sk;
	}

Within this patch there is no matching sock_put() anywhere in the tree; the
balance only appears later in the series in "quic: add packet parser base",
where quic_packet_get_sock() converts the result via
return quic_conn_id_sk(conn_id); and quic_packet_rcv() drops the reference
with sock_put(sk) on every path after the lookup.  So this is not a leak as
the series stands, only an implicit handoff that is easy to miss.

Would a short comment on quic_conn_id_lookup() stating that it returns with
an sk reference held, and that the caller must sock_put(quic_conn_id_sk())
it, make the contract clearer?

> +	/* No need to check get_nulls_value(node) != hash for !conn_id, as
> +	 * hashtable size is fixed and a conn_id can not rehashed.
> +	 */
> +	return conn_id;
> +}

[ ... ]

> diff --git a/net/quic/connid.h b/net/quic/connid.h
> new file mode 100644
> index 0000000000000..abad396a6ad6a
> --- /dev/null
> +++ b/net/quic/connid.h
> @@ -0,0 +1,183 @@

[ ... ]

> +struct quic_conn_id *quic_conn_id_find(struct quic_conn_id_set *id_set,
> +				       u32 number);
> +struct quic_conn_id *quic_conn_id_lookup(struct net *net, u8 *scid, u32 len);

[Severity: Low]
These two declarations sit next to each other, return the same type, but
have opposite reference-counting rules: quic_conn_id_find() returns a
borrowed pointer while quic_conn_id_lookup() returns one with an sk
reference attached.  Would it be worth documenting that difference here, or
returning the struct sock * (or an output sk parameter) from
quic_conn_id_lookup() so the acquired reference is visible in the signature?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com

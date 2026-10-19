Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445399;
	b=UNDOaBte8owIodjB4A+NqjQ2c0V0qFuKxgVMIsDF7eDG2TecmXDIZ6rAV5MobOaWywSC
	 7FL9MFVZjC0YdFPRqnjFPRtqBMdJitUkt52sW19EMhY8t2o4QfWH22ZdtWGV8YoBZ5kJb
	 C4Gw4lcal7aqjgUto9VTHMlLmTNwBQ6WOz3rqzX5xMR2G32/pUcrVhm9iUIFsQMMiPrGw
	 1upEJBKQ0MNoGTEFeRQ36NXEBPCJ9g9psDRjEq4NJ36kz926iF1MKF0A6tik5K9Mjw8+Y
	 90yBSKUqtr6UIlTk9U7FY7caa/nTjOck7SanwTTkOtHB+W+n/gSE/YXHLU4vATLxv2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445399;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qO/g4Acy+1cPSpxqYSMxIsGa5SLJV+7eifKnXeT0hnY=;
	b=fnvfd6xDxcFYBhx/1wk7ds4RPTNim0zxewGO2v1oWUGsQmg0Bq75fKCMrXlmsFQfaTfj
	 SWhuJd8Cwngeg9OEdFtpSNYlUuTH8XIJRpkGNbhUrAy2/n+qnVnMEjhaLX3BI2VoEFQYO
	 bhO01MgjXK4V1voSMALH9cvizqkOT55nSIS2G9RRioA24j6yvoSDo+8bO4KYm2q0QGZ3J
	 FBL8Csk6Jz9pw0sRQ7QQ7q+dpmsHxcsn/yrs6vQkUPWo74oUAtPZIxcz/9Rp+WzvrUzj0
	 JHR9HjvCfmha1t1e+YzzDPcS8W04T+/zvawR5w//ja0bDGV6imhCUsgS14ZBbukTKCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbLfhtoH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C611C606A320;
	Mon, 19 Oct 2026 21:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nbLfhtoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D961F000C4;
	Mon, 19 Oct 2026 21:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445398;
	bh=qO/g4Acy+1cPSpxqYSMxIsGa5SLJV+7eifKnXeT0hnY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nbLfhtoHsFNZw6w3lMT/CI4gs8tAllnXBzgTQlK36k++xBlsa+VOouR8w0sJAK3Xt
	 HseCWBPNhS6ezFdbV8FVPIp4F2Ophd9yabr4eweHAfHA6gWoEday5FNu+iG/AuEs7Y
	 +t0dasITZkj1uFUvsL3Z/hENw24Fjvze3WTRu8O2sC8IIsmpAaIAglu8CFhk2kVs1H
	 TqAljXzVFAhOETz6FdmtmvY2lsG9u1RQ+4QKClGgKioCV9MDTsFECO8A2uBfcZcvfm
	 R7YQ9bBt3+DW1q2zRMh314ofCLtZOn59rhC87lOAVN49/2sPWe9iBcQ+7BOUvzTCPk
	 RWHbGYVynEWRw==
Subject: Re: [PATCH net-next v17 07/15] quic: add connection id management
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
Date: Mon, 19 Oct 2026 21:29:55 +0000
Message-ID: <179244539578.3135.2545046427986099445@kernel.org>
In-Reply-To: =?utf-8?q?=3Ce444094df836a7945028f960a458f520effdf221=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Ce444094df836a7945028f960a458f520effdf221=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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

- [Low] The comment on the `count` field of `struct quic_conn_id_set`
  (net/quic/connid.h:46) does not match the code.

--

quic: add connection id management

This patch adds struct quic_conn_id_set to manage QUIC source and
destination connection IDs. It provides helpers to add, remove and find
connection IDs in a set, and inserts source connection IDs into a global
RCU-protected hash table. It also adds helpers for RX path lookup and for
checking stateless reset tokens.

> diff --git a/net/quic/connid.h b/net/quic/connid.h
> new file mode 100644
> index 0000000000000..105c2b4b0f2ec
> --- /dev/null
> +++ b/net/quic/connid.h
> @@ -0,0 +1,184 @@

[ ... ]

> +struct quic_conn_id_set {
> +	/* Connection ID in use on the current path */
> +	struct quic_common_conn_id *active;
> +	/* Connection ID to use for a new path (e.g., after migration) */
> +	struct quic_common_conn_id *alt;
> +	struct list_head head; /* List head of available connection IDs */
> +	u8 entry_size; /* Size of each connection ID entry in the list */
> +	u8 max_count;  /* active_connection_id_limit in rfc9000#section-18.2 */
> +	u8 count;      /* Current number of connection IDs in the list */

[Severity: Low]

This isn't a bug, but is this comment accurate?

quic_conn_id_add() links every new entry into the list. It only increments
count when the new number extends the consecutive run:

	list_add_tail(&common->list, list);

	if (number == quic_conn_id_last_number(id_set) + 1) {
		if (!id_set->active)
			id_set->active = common;
		id_set->count++;

For example, after adding numbers 0 and 5 to an empty set, the list holds
two entries but count is 1.

The consumers rely on count being the length of the consecutive run that
starts at the first entry:

	return quic_conn_id_first_number(id_set) + id_set->count - 1;

The WARN_ON_ONCE() guard in quic_conn_id_remove() and the
active->number != last_number check in quic_conn_id_select_alt() both
depend on that meaning.

Could the comment describe count as the number of consecutive connection
IDs starting from the first entry in the list? Otherwise a later caller
that compares count against max_count (active_connection_id_limit) would
be comparing a run length against a list-size limit.

> +	bool source;   /* true if this is a source conn_id set, false if dest */
> +};
> +
> +static inline u32 quic_conn_id_first_number(struct quic_conn_id_set *id_set)
> +{

[ ... ]

> +static inline u32 quic_conn_id_last_number(struct quic_conn_id_set *id_set)
> +{
> +	return quic_conn_id_first_number(id_set) + id_set->count - 1;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com

Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4B5296BBC
	for <linux-cifs@vger.kernel.org>; Tue,  3 Mar 2026 09:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772529413; cv=pass; b=r1w8BAJ1Ag8eDL3qQk0B/T7/Z9h4/uygMTZTx6oM6x1O/OerkCDtFAIKlXT1OqA8YxdeILPKXN9v6By4DTQxoRGV5uyeqctvc3hshn9R1FVpavjcw4OTs9KnVAZT/JWHOJ+cUPNrtmMr8EMrq0CzMDFz4vYAgi6psHn5sNyT1Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772529413; c=relaxed/simple;
	bh=N9T9tK8lrPlBnjE46aPR6EPWJfEat41vQnH/NRbnpNY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OLC8udS31iblK1VvirFcEPrcaJd+LobZJNP/WFl7aJ/CO/vczyVPCb9cmBPCtqGtarwk3/4rC8vwQvrthzB+ID0Vf4LtFmia6InhqO2Nss8CPK6vb4IkmsAkZ5tT5itK1BxUoi5CFWqs2yZH8wYjceVVwx4FAci0qXFDlGRUOVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IiAQ0aY1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=K2chw8p9; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IiAQ0aY1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="K2chw8p9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772529411;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=477xItCgA+po7bLgye1fu2Qz+J42vgm/OW+kOSIs1X8=;
	b=IiAQ0aY1wDeTtWDXCiITY0m4L3iGOiSmjHKz/89SUoyAs8BzvYcqPU4YnuMtz6suQMt02B
	cooN0dM6DrGgyXCL6lURld/xsr7pVxxEe+fgpZ1sTbBHFRqg33aTYqrkYiMDAHsZ8TCfLx
	1WZKuVi3rq8gOtLnxIpXpq5SmY70X+0=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-7L1MbcNLNtyzUNDCv5hJjQ-1; Tue, 03 Mar 2026 04:16:49 -0500
X-MC-Unique: 7L1MbcNLNtyzUNDCv5hJjQ-1
X-Mimecast-MFC-AGG-ID: 7L1MbcNLNtyzUNDCv5hJjQ_1772529409
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7987dc43f36so86983237b3.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 01:16:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772529409; cv=none;
        d=google.com; s=arc-20240605;
        b=JTCbxJ9sUShRg1susoGTdCuwU2tyws8QMVtS9f4/fqayb1IgNQJiI8eKRtSCmH/WIt
         qr9+LVj189nMr6H6IAtw27rsl1I6pG2EKhFqG7uGpBixv+pXNSDRxt1MrDPeEOjlGuBZ
         MApRr81QGZhcqrc29z/asYNjNwcSSt60NdKm7AzmAl4MR8ZVbHIsoYUiuYnfgvhr7BsF
         mjtLH4T/qLUZx7/KHy/0DagCj3ZvhAGqD1ExlP5Lclh45yoY9mebpIUoc+gEsLo9q0w0
         51EgadTTFAd1Yg7wa1tXpvKY17JheVcIZcRtZd/TkdF1aqI2g0oT0ICHh5JktSXrmHAX
         zGpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=477xItCgA+po7bLgye1fu2Qz+J42vgm/OW+kOSIs1X8=;
        fh=exb8XUsMq5AjMRvoBK1M6hIvemDTZ2CUBt7fJxAWFrE=;
        b=MT0Hp57GWBlHIoVQC6N89Y3OLjniiPOAoZI0Ng9XruGP5WZEXpW+LYhbgxLluIwlwM
         7k3pF59Wde14B2CA92VR7pk29VuyYNDNArZFGQpa6dgYB2tII0nlfQsiNG5OUKvv4Gjk
         Q+sKuH3EgrpLFYZnpCMppXNyFvd9G45Gn07F6gYCbXg40PEjvTiCcPEiW2RbffWp3ygX
         L8PNLOSV8KgvhEnZHinigkHd2Vo0c25crLHPxUWhE2W5vaeiNFBv66FC0DbWUlFEKdhw
         tcZuDeMaw5Wfk7yJLpcMb8vN5B+uoECJUc6k7HISQOPzpWCD2EK1tlpfAKdpFDYq4boE
         4QAQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772529409; x=1773134209; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=477xItCgA+po7bLgye1fu2Qz+J42vgm/OW+kOSIs1X8=;
        b=K2chw8p9qpU9CyCplHrXlJMGQzOIgkMMrmkWNxaWjFX9MOxoZvlRfc2hJ9qezWHBy0
         W9f4ANTOCJ166qQKgQJWucdURhk9O7RWSDODAcznomuVbcNy+LvmL6G2Gsd7azqCzxBj
         zNzjm7VnjW6WTCfGIdAKW5qPMkrn7uGSIqzL9fc0lT1iJdQHCa6D/1MaU5LBv29nNGUw
         5/tu1Z+bnJ9jWI0LBChs2D+s1k4RriD51Vf6Zf0R/Ll6NJKnvzsCtgbnbxP9n/r/0NUW
         SsB1qJhiB9vbva/FbcQMd61KDx9XdfUjhrudnnb5J0IcdBWnqjDr+Y1wTWstAOb/3xg3
         KSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772529409; x=1773134209;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=477xItCgA+po7bLgye1fu2Qz+J42vgm/OW+kOSIs1X8=;
        b=TUWPtyV167aEqyygSqUDQbPjd3Iv+96g/2CRazqGVPJXOMOVd7IiI7cyRbhUHdsHjN
         mecrz9GEzRAMgK92d9CtNljwcLPe5929qjutqe0GSwl/7PyzQSjQ9vTnnvpNaM+3Gx5w
         W/NUt7XillfIW24PRMRSqcnUO8ug7ib/HKMhRINtMjoZL7w2dHK3mYv/m7sfFo8v8jw4
         SY8SqWX5CNTRFc6i6qpqSIkqwawxkj4W3Bjt5+NqKSbO6r7gzF3sNES0thAek8YN1KEY
         kPtVrY8S1gEovM4a2uAwLlYdELggLUZg8scgcfDoNHKK2IrUNqzXBlMC64IAQq9Y6C7S
         79nw==
X-Forwarded-Encrypted: i=1; AJvYcCWkIynUOuStGA8PZpvw9OEUyeX4If8dQOIhPsnwtTsStwhhYh7jEV3QljG/8tN247gGenr93AfcjwF3@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3dY7OaxdaBowudUCyuuBZ8Hr8RKXBJ+xFxVvrtyTxmrOFEr00
	kMia3HiRGjOOS5xI59ceNKBu5HqWkYvHZoHPmJOG/2p0dVDRWkkMSTdXGFz7dwx0g/7KpKiXd0n
	jrE2HNxcQlnzn/gb2XsBv8LttUQTe6F2l0M96F3iaU2kMw/S/gqxexZIqrjRkm4Fvb8dHoAZ+KT
	hVsZgSRQelgbsXL3Y6Ol37sAgr8f5t1JHFUQeu5w==
X-Gm-Gg: ATEYQzwAqgq1v6/2xtbjD5Dm3ZdNPERLLVNWd4NNtQAQTZGZumlkJD7zy0OybqAKgWV
	nfhsEPx4ms7YkTc/boL8cLuV+5TJ2P0ZylQeAfjOpfJ/4d/AJxfuPaBXLBCuKqfbhH3+25HViRj
	LhSxqnnhUHsu75lYumh4L2kUsvMnqxZfX2lpuFhEkhlCnqXrT3X+vjZOqF6UEBPt+tgdZFoFDb+
	SjlQBk=
X-Received: by 2002:a05:690c:e373:b0:797:cd05:bcfa with SMTP id 00721157ae682-79885631b64mr135971537b3.56.1772529409181;
        Tue, 03 Mar 2026 01:16:49 -0800 (PST)
X-Received: by 2002:a05:690c:e373:b0:797:cd05:bcfa with SMTP id
 00721157ae682-79885631b64mr135971217b3.56.1772529408805; Tue, 03 Mar 2026
 01:16:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1771986861.git.lucien.xin@gmail.com> <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
In-Reply-To: <08a63705058aff77dd54fb388870f0bca6036c95.1771986861.git.lucien.xin@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 3 Mar 2026 10:16:37 +0100
X-Gm-Features: AaiRm51KQx9VYE8xMRhcvcGF5sOeXsvvCe5N0-c4bJqQWqxzxGk3Zy5J02q8C_U
Message-ID: <CAF6piCKOiwMz9Le2vBV4_W3R0NR3TW_je+ow4SCm5eX867awyg@mail.gmail.com>
Subject: Re: [PATCH net-next v10 15/15] quic: add packet parser base
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, 
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	"Marc E . Fiuczynski" <marc@fiuczynski.com>
Content-Type: text/plain; charset="UTF-8"

On 2/25/26 3:34 AM, Xin Long wrote:
> +/* Find the listening QUIC socket for an incoming packet.
> + *
> + * This function searches the QUIC socket table for a listening socket that matches the dest
> + * address and port, and the ALPN(s) if presented in the ClientHello.  If multiple listening
> + * sockets are bound to the same address, port, and ALPN(s) (e.g., via SO_REUSEPORT), this
> + * function selects a socket from the reuseport group.
> + *
> + * Return: A pointer to the matching listening socket, or NULL if no match is found.
> + */
> +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa, union quic_addr *da,
> +                                  struct quic_data *alpns)
> +{
> +     struct net *net = sock_net(skb->sk);
> +     struct hlist_nulls_node *node;
> +     struct sock *sk = NULL, *tmp;
> +     struct quic_shash_head *head;
> +     struct quic_data alpn;
> +     union quic_addr *a;
> +     u32 hash, len;
> +     u64 length;
> +     u8 *p;
> +
> +     hash = quic_listen_sock_hash(net, ntohs(sa->v4.sin_port));
> +     head = quic_listen_sock_head(hash);
> +
> +     rcu_read_lock();
> +begin:
> +     if (!alpns->len) { /* No ALPN entries present or failed to parse the ALPNs. */
> +             sk_nulls_for_each_rcu(tmp, node, &head->head) {
> +                     /* If alpns->data != NULL, TLS parsing succeeded but no ALPN was found.
> +                      * In this case, only match sockets that have no ALPN set.
> +                      */
> +                     a = quic_path_saddr(quic_paths(tmp), 0);
> +                     if (net == sock_net(tmp) && quic_cmp_sk_addr(tmp, a, sa) &&
> +                         quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
> +                         (!alpns->data || !quic_alpn(tmp)->len)) {
> +                             sk = tmp;
> +                             if (!quic_is_any_addr(a)) /* Prefer specific address match. */
> +                                     break;
> +                     }
> +             }
> +             goto out;
> +     }
> +
> +     /* ALPN present: loop through each ALPN entry. */
> +     for (p = alpns->data, len = alpns->len; len; len -= length, p += length) {
> +             quic_get_int(&p, &len, &length, 1);
> +             quic_data(&alpn, p, length);
> +             sk_nulls_for_each_rcu(tmp, node, &head->head) {
> +                     a = quic_path_saddr(quic_paths(tmp), 0);
> +                     if (net == sock_net(tmp) && quic_cmp_sk_addr(tmp, a, sa) &&
> +                         quic_path_usock(quic_paths(tmp), 0) == skb->sk &&
> +                         quic_data_has(quic_alpn(tmp), &alpn)) {
> +                             sk = tmp;
> +                             if (!quic_is_any_addr(a))
> +                                     break;
> +                     }
> +             }
> +             if (sk)
> +                     break;
> +     }
> +out:
> +     /* If the nulls value we got at the end of the iteration is different from the expected
> +      * one, we must restart the lookup as the list was modified concurrently.
> +      */
> +     if (!sk && get_nulls_value(node) != hash)
> +             goto begin;
> +
> +     if (sk && sk->sk_reuseport)
> +             sk = reuseport_select_sock(sk, quic_addr_hash(net, da), skb, 1);
> +
> +     if (sk && unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
> +             sk = NULL;

Note that you could avoid the refcount if you keep using the sk in an
RCU critical section. i.e. plain UDP does that. Same consideration for
established lookup.


/P


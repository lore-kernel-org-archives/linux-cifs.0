Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A692E1FF7D7
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447265; cv=none; b=p8Wmy368RLXiUlNGUf5muF0yoAUuSPlC9XERMonQoxmATs+U8GoMlf6UDATyw9vVmoTTQx1UFXMEmZ4OGgoR0+PWWpCXl/HuowBxhNFOdE8gmQcI7FSPc+17craxOsk3NMSrw9vdyscBETfeDAjWQCmTRkIkMt3X+dtTT0sH9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447265; c=relaxed/simple;
	bh=TBcIWrbd4TaZLgB/ZJb6p325CdBt3uGaZyZ9kmR9+1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WL0m3bYXAw8ODp3BlD0M5XyokVyLostLmqu+zacKcARGV/RQjbFWrLIw1c3I8BMNKdWEDD4IzHLVtY88qWAJCxGNuIITpkvfpN36nyEq/U7xWKDButnBEr9yoi9cu6sgUYZh7v0zBCPwncnYJPjrSLESeYicBAyowpMdNeYMUF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KJ8O/Vuq; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KJ8O/Vuq"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3414de5b27eso1042104a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 08:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762447261; x=1763052061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mvC8dwzzaWG4yq5+kQqkL0SJpAh/HOeEJ2LSeIlJuUc=;
        b=KJ8O/VuqOigHSLXYo0itTJT+08xhB7eilnKIW8TLxrADXPJZrbq50fkH1jQ92qCbhb
         s4QHzHQ7kbgFM3CfcCWjC/blGi8v7a0OMx4oq8DeEg1ac0oPMUVb82Pl/5XzPAzrx79r
         Nsl2ZQ+G/HNaI5xzZupMS+k/0R/hZEplRvm2OBuLvSD0UnCNeOtJQ7y7PCS1Bsfu1UeL
         /5k3+yEGfvb110IhM/1eautmp2m5dfmGkAkPBqQkVfyBnMPzH/UY6m4fSScsaQPyRj+v
         XecbB0WFiErmYJnuE8U/aT+NCMWiT8GA5nyfR2BHgRY2tsxLqqcGlrAGezkNLNG8FaLI
         +M0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447261; x=1763052061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mvC8dwzzaWG4yq5+kQqkL0SJpAh/HOeEJ2LSeIlJuUc=;
        b=m3addQq6d1Mlm/jCoKLuJjF4ohlrqvd/JzgyB6aI9Ej6u4oNIZ24jlaScU6aFaQKEy
         7HRio9qjXv00BMe+H5EJclI/Bjc4hsmVUtwq7vFlqaITm2qUFwHztt7G1tGQMgGgAm0u
         L2OJ+7SiFm19pudOYpCx5LLrQSSLQYuSLikbhjirwQV2VWftyAwH27tRkV7jqoyRklx/
         iurzf8tYDTNhpRfFbkoZ6JnPdJinfMMEd4ESVgxH2/zk1PT2/TFQo1nXzkZVH12hVNzT
         CkQudVVwybztD4NSiPSa22Hw0/XArfoETh2SOBrmokHKQyM5jBtjIlJHaduqXhhtCN8N
         zYaw==
X-Forwarded-Encrypted: i=1; AJvYcCVi1VAUOItxR9nRjgHuLNCYyZLIRQlJfX/p60jO0C+X2aFpxio8vEfeEBbG04o4AsZvdRkrDYLLV442@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/DrjYvmBpWZpAaL/Q1sMTd08b4cIDDbFg4LiNLf4orIIzVKv4
	jRCbDkp3nrteHAetAXrg0jTOEnZZ3EKaOzSAr/HsKVVGd/DOMyWiENTF41+rrn4Au/IJ8gPZj8C
	/0fBtJs9ssKcA6ccL0oH+a+CKyXG5Mbk=
X-Gm-Gg: ASbGnctwjZasZaN/+p4kkSytMUJ2BDABCPAPbWnxRPAZUqOezdjEUjdql0V+C7hjB+2
	qerNAJmDGx6hLWGWWsA6PjIbzZccec5NWs0UMwldf/5iR8+D1mjlYJBB/pDTpd2fAbnnyhM50ec
	Se3rnI0hpRMr6kCnOJW+n2pnuJDENCJHozSWQTvZ2TUpvdOPz42tansQXWc7RHej5MFOcut7CJu
	n5Izgu5f8eonjt6v3zRVnI63tqHxKG8/iPKiC7u7NKboK0ymFd9UcKpW8JFvGA+h/bEjFVaQJFP
	3BA307VvCbHcXBpQVF8=
X-Google-Smtp-Source: AGHT+IFhNfCSdGalSOf406WxoKMEjh2ITqWtl6zazWFVAs7ueoni8JgesPYbjGRu4NLpQW9g3l96QGzY8CifeXnMhgQ=
X-Received: by 2002:a17:90b:2888:b0:341:8bda:d0ae with SMTP id
 98e67ed59e1d1-341a6dd83b4mr10067477a91.20.1762447260941; Thu, 06 Nov 2025
 08:41:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <a1df61880c9f424b49b2d4933e0d6ea0bf6da268.1761748557.git.lucien.xin@gmail.com>
 <635b0dad-98bf-41e9-b7b6-1f28da48fc00@redhat.com>
In-Reply-To: <635b0dad-98bf-41e9-b7b6-1f28da48fc00@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 6 Nov 2025 11:40:49 -0500
X-Gm-Features: AWmQ_bly4E8gAJHH1RdZ4TnHldWIBRhfNNyves1f0Q8O3wlRAgOEjU9eQ8XrsCA
Message-ID: <CADvbK_ft3jLQcQekNtUjs_Bot5LdfcyWHbrfAUp5XEAYncrs7w@mail.gmail.com>
Subject: Re: [PATCH net-next v4 10/15] quic: add packet number space
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 4, 2025 at 7:17=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 10/29/25 3:35 PM, Xin Long wrote:
> > +struct quic_pnspace {
> > +     /* ECN counters indexed by direction (TX/RX) and ECN codepoint (E=
CT1, ECT0, CE) */
> > +     u64 ecn_count[QUIC_ECN_DIR_MAX][QUIC_ECN_MAX];
> > +     unsigned long *pn_map;  /* Bit map tracking received packet numbe=
rs for ACK generation */
> > +     u16 pn_map_len;         /* Length of the packet number bit map (i=
n bits) */
> > +     u8  need_sack:1;        /* Flag indicating a SACK frame should be=
 sent for this space */
> > +     u8  sack_path:1;        /* Path used for sending the SACK frame *=
/
> > +
> > +     s64 last_max_pn_seen;   /* Highest packet number seen before pn_m=
ap advanced */
> > +     u32 last_max_pn_time;   /* Timestamp when last_max_pn_seen was re=
ceived */
> > +     u32 max_time_limit;     /* Time threshold to trigger pn_map advan=
cement on packet receipt */
> > +     s64 min_pn_seen;        /* Smallest packet number received in thi=
s space */
> > +     s64 max_pn_seen;        /* Largest packet number received in this=
 space */
> > +     u32 max_pn_time;        /* Time at which max_pn_seen was received=
 */
> > +     s64 base_pn;            /* Packet number corresponding to the sta=
rt of the pn_map */
> > +     u32 time;               /* Cached current time, or time accept a =
socket (listen socket) */
>
> There are a few 32 bits holes above you could avoid reordering the fields=
.
I will switch base_pn and time.

For the hole after sack_path, It can't be avoided in this struct, I
will leave it there.

Thanks.

>
> Otherwise LGTM,
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>

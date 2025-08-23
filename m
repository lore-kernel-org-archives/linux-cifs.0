Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95DC1FDE09;
	Sat, 23 Aug 2025 16:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755965767; cv=none; b=eYA1dk+CxQH9/sK98shRDnFBg2rWA0KxG5jimAp9NR/wz3DRJJ7rfJR2p2642be7ITnd996eMMWbyowEV3+r0lfRoy1tCoBx4G97PzkhCwn7iXrTPPyoltqO78DTL5O3T/HnVZoywR9u8OAvCauS1K4OB1GNG6xV9eH22Qhzkxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755965767; c=relaxed/simple;
	bh=Q3Ijr4ja96ac2m91zgKJC3FKj3CDJoRZdtohiWNdhjg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Emx/feM1nf/LwKGKcraUyGa1T/jIJ8PrJDZYZsKALJBitmjWA/ONTp80nXZnQITX16HKCt/TGGgdFgHCTMHU0NsQ9phAB7ZprnJRdSxFVUWqL0qSSi9byZuLWAwuv7D/wpFtu68/+ksyL2Z6+pKjQw6adZSqzfrt+VX76vxmeag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nee8vDpF; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nee8vDpF"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-88432e1af6dso213078039f.2;
        Sat, 23 Aug 2025 09:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755965765; x=1756570565; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AWgxItAgYQsCgLUpyil58tulWppM9RxDdbbAZq3mTH8=;
        b=nee8vDpFz0utkWcGeW2qjAWDAWXJfhs7hOpwvX4ms9usH/29zCO8brHFspAVPeS8BZ
         XqCbcYNmLBSM2NgsL7byfvZNB/8y1bUfSbDPTyJnycltfFJfZkHAmb3Afqb4e3k99ZNt
         yyh4Wvy492iEg4JsWLZDoiHkN7B1xwl/GeLlVAvRUIjSJz4/NZKpewAq638SkJlohCyo
         1V9DVXzo48gluJmQNDUwbO73RCsMHhP2DRocvnLNm4q5S5PxNBIHsB45ctIzK2rzZIwz
         KbVjSS1JMRtZjOh9LmsQMKqr9urdu+e3qhsZv6R/wtYPCT3RyQE3JFz9afKeIIHZsqf3
         qlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755965765; x=1756570565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AWgxItAgYQsCgLUpyil58tulWppM9RxDdbbAZq3mTH8=;
        b=T8l/YTlrGep+rXwoye3oBdSsrVWnkqcVLQqFaBTfo017RGinAkQEohcjMSIXDhgEeV
         3VJDeOWpA5IkRbYvsh4NC1+mfXNgdqWRUXLzbPiuBomWUoWv1yBHerfdOqbtH/6YS66W
         /SYCmoeuzJPp0DFl4xDWyzH3ALM5OV1BO11BRpD29XP0EJCx7UlB1aTH3paump+qPIP2
         fvo5xQJIjB8CHliUJQo+6Ufz/2CLIt842/OFVLvsNRl7BE0kHI2s0Gmej1wWuA0a3K7O
         kaIq8lQcSu48FJdHhtXDksAxSGCrZPSdXbPR6pt0Zwsk6m7GTXhf6QsWZgzs8aD93Yke
         TM7w==
X-Forwarded-Encrypted: i=1; AJvYcCVieCE9JVDdxqoonh/pOx9kLpuDzI2yApnhw9WdoJJC1aUDC9r7NUeWQQY4cg23o/GJvR2FCJBn4IYy@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7TmTpJ2+RcXdcco5VSIC51dggfOhJ+Pof/5DACvZwbKLCI5zm
	9y3+y8Q70ZGIG6wXxgjVz5faqSP2GhAk4ZHH9o2WW6Q3e3+A4m4F8Gymib4M/xOOH9BPo6S3mYG
	/sXXLRIAEfCLmj6CS8fgqoRxMo/b/bVY=
X-Gm-Gg: ASbGnctNS6VQGEUVWisXK67xmjReMXqpjxy2KhAEK6KuyEsljXCVeu7MnKh/1X+E3Am
	Y0qQF9nTgoTSQNUi+ZSV/9hbe5iSSX8xjqCGBtNs3B4OFRc/qHZaJB6aPE7NvelqAGse0zrTs7g
	F6vHsZQjur3+hgZi6/2GEBRLIFvsf91w0bcr2KPFPtWxyDQbXTTmv6KXvZdIC5XVIrX4+0H3m8i
	WdBUgro9QeFjTLlrBHW
X-Google-Smtp-Source: AGHT+IGMB/8UuqwI+eA7R0raDmgE6VVQo9t0+NLRXm+dEW1N/1+RO5BG5zPgKsBurXL22e1u190cFKV4FZWjpQ/JLiY=
X-Received: by 2002:a92:cd88:0:b0:3e5:4816:8bca with SMTP id
 e9e14a558f8ab-3e921a5d7a2mr115332425ab.12.1755965764716; Sat, 23 Aug 2025
 09:16:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
 <7fd0f513-df05-43f4-b1dc-0fdb74e78378@akamai.com>
In-Reply-To: <7fd0f513-df05-43f4-b1dc-0fdb74e78378@akamai.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 12:15:53 -0400
X-Gm-Features: Ac12FXy_8xGDeqHoDT-ySDSOepCnWzY4imjS_XVu68giUoWF9t-QKARx-CULpvw
Message-ID: <CADvbK_dwH2WXWZFym5R2wbjBW0qkoLyxip+uRT751ELGqk0rog@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/15] quic: add connection id management
To: Jason Baron <jbaron@akamai.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025 at 1:11=E2=80=AFPM Jason Baron <jbaron@akamai.com> wro=
te:
>
> Hi Xin,
>
> On 8/18/25 10:04 AM, Xin Long wrote:
> > !-------------------------------------------------------------------|
> >    This Message Is From an External Sender
> >    This message came from outside your organization.
> > |-------------------------------------------------------------------!
> >
> > This patch introduces 'struct quic_conn_id_set' for managing Connection
> > IDs (CIDs), which are represented by 'struct quic_source_conn_id'
> > and 'struct quic_dest_conn_id'.
> >
> > It provides helpers to add and remove CIDs from the set, and handles
> > insertion of source CIDs into the global connection ID hash table
> > when necessary.
> >
> > - quic_conn_id_add(): Add a new Connection ID to the set, and inserts
> >    it to conn_id hash table if it is a source conn_id.
> >
> > - quic_conn_id_remove(): Remove connection IDs the set with sequence
> >    numbers less than or equal to a number.
> >
> > It also adds utilities to look up CIDs by value or sequence number,
> > search the global hash table for incoming packets, and check for
> > stateless reset tokens among destination CIDs. These functions are
> > essential for RX path connection lookup and stateless reset processing.
> >
> > - quic_conn_id_find(): Find a Connection ID in the set by seq number.
> >
> > - quic_conn_id_lookup(): Lookup a Connection ID from global hash table
> >    using the ID value, typically used for socket lookup on the RX path.
> >
> > - quic_conn_id_token_exists(): Check if a stateless reset token exists
> >    in any dest Connection ID (used during stateless reset processing).
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
>
> Thanks Xin for all your work on this!
>
> For QUIC-LB, where the server endpoint may want to choose a specific
> source CID to enable 'stateless' routing, I don't currently see an API
> to allow that? It appears source CIDs are created with random values and
> while userspace can get/set the indexes of the current ones in use, I
> don't see a way to set specific CID values?
>
> For reference here is a proposal around it -
> https://datatracker.ietf.org/doc/draft-ietf-quic-load-balancers/
>
> In the reference above, the source CID is encrypted to help protect
> traceability if the connection migrates. Thus, if the kernel were to
> support such a feature, I don't think it wants to enforce a specific
> encoding scheme, but perhaps it might want to be a privileged operation,
> perhaps requiring CAP_NET_ADMIN to set specific source CIDs.
>
Hi, Jason,

We currently support only the finalized QUIC RFCs. Drafts like
'Load Balancers' and 'Multipath' aren=E2=80=99t covered yet. I think
we will plan the APIs after they are standardized.

Thanks for pointing out this RFC.

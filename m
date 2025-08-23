Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A60C2ED141;
	Sat, 23 Aug 2025 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755964690; cv=none; b=VO8YBLbMrdKE9l/2PMwnXw4urNmaHtD9PG2m2MevDIGuggudP5Pdu4m6N/RvnSuJLc09v7lEGU9oRQm7GbzKi/Nx+tBLt8ueZNOuA928Kes1FyoAbTH4sReacpZ7Ec906YAxQj46gZHd0HTkNQ8Oyc431wBrhtPdrQa0E5k0nZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755964690; c=relaxed/simple;
	bh=CEss89D4rBcDaOXEtNPRHdQhEDfgyqGuolIWnEOZN24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8Ad0+yI8uTv2Fu6mcwUKI4HxVY67cxZMCk+194y/L9iS8lsMLe7OIJHRwExzWsJZ3yhNfWjtGOGG1oYUz1MYDxZ6hfDdfCtidD3pIU0rZuRCIx3BW3atESdhqqRw62NJ/irKHiM7Whn9wuDPCIsvHEx1PfBgQD//l/t9mRoUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P5bXb6S4; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P5bXb6S4"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e566327065so18259235ab.0;
        Sat, 23 Aug 2025 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755964687; x=1756569487; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6uOB/+tg1Dp4KQdja5HyNTCSLbeGrw8GP5vJj1HJRJ4=;
        b=P5bXb6S4ya2pnmCH/jFrfaOJwhDtPTSS/hmQ2ql371zjqPELn1RqRm8NTWxFS/BnRm
         joSHIAaA00QT9FEVUaXY818RiSfl/mfCW8twSdb1RMZjMwDZ3NGvWoqd2VEitN+Eig/b
         WirtstdpDtsgwfm1kruxwcrmjO7Nzzo4q7Iv4KajbGpHlfaS2HKxCruenB9Gq7vjzULt
         sq/gdcgu6n/skMaMJ6nc7Mudqacn3PJjewcBoLqPFtNhqOVyaaYbc+iZGwXLwfBDfQHS
         Tgs5KuHShUNbt7XGqtaEhgW9x9TuvUGD0RsTPDOWshYpOc19HPtLUFSeYl4l+T7Jc8SI
         vC3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755964687; x=1756569487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6uOB/+tg1Dp4KQdja5HyNTCSLbeGrw8GP5vJj1HJRJ4=;
        b=jPL/11oykXVT/93WBGnBF2qdo4TpCpTVmDVs9vjAa6UwLfxLl9d6Uak05ZPCITjMez
         +FYwZvBvlll7jxZvwnFbIm1dmPIjbybStiZLirXlatW6vAzPSfMVOr0tTJ1SSGrtIUhu
         dgkGf4C09MXBh7eRbiLZFILXbMA3LHz8UXHD3uVM9pkGUekNPs1ApH51fEq7cKAupzmI
         UUAwXZ+mk8zuB3dljjnm6v8FNGWyCyq1qfLqVv4s7dhjsLkEGYbAKlML7c3vmB1FuH5c
         Ho8cWf0PO4zczCqt0Hp+oylX5AbGC4I4l8Y9iW1KXZCIYrAmduoe97Fc2ftPetfSkxmN
         C2lA==
X-Forwarded-Encrypted: i=1; AJvYcCX/1lD3UPHbEPOo9QPppLJrlHxj9RD6iAGCysOeRJNIaKTaKhRdr3I5qBrJmjfkxIeaReQOzHxKQF6G@vger.kernel.org
X-Gm-Message-State: AOJu0YznwpUc1w6ybCem030CPjrMAObtdBxQxuQu18iBAvlXDG4rBXrI
	xnDIHv0VGjUc1jXDxdYe0qIhOaHo/H/HgT5eLS5FrR+h/sjjAB3P6xhrKgNYx7D4Jp1VqnwAZmS
	l0PQviyUheMWFP/uVoJL6++uUYFDc2DM=
X-Gm-Gg: ASbGnctfXetrvgkiVNFeIDRS5g7K7g71ZtGP62Dj8hPUYKX0r2+BJMUZe9HN2M6lpLB
	l6eUA4FiXt1/omUtXPZ8UxggVVB15Dp0k0PbgE0div5ELc++JoPuUvpvz/GkersGl3BfFaMm71r
	ZkwJvGCbMYpMIkzS6T1iXYsvVPA8qcXyln5Es6Mm14YQmex5A4/70tkjr5TJ3YyxnIAfLZ4HTvq
	HgcVwjHOQ==
X-Google-Smtp-Source: AGHT+IF7DvIt1E0z/6wT3rwFB77I1aID7CBLWX3CGdHH8OwOrHIkXssQnxHCXzuBMqbZLo+ZAHWp7pyACv5yRG02Iw0=
X-Received: by 2002:a05:6e02:2604:b0:3e6:6f40:ccfd with SMTP id
 e9e14a558f8ab-3e6d7479749mr141369325ab.5.1755964687293; Sat, 23 Aug 2025
 08:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <e7d5e3954c0d779e999dc50a9b03d9f7ed94dbd2.1755525878.git.lucien.xin@gmail.com>
 <1cf31726-bfb9-4909-a077-6c2c45e0720a@redhat.com>
In-Reply-To: <1cf31726-bfb9-4909-a077-6c2c45e0720a@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 23 Aug 2025 11:57:56 -0400
X-Gm-Features: Ac12FXxwa94_Bx2cdn5RolEYeYrrVdm5JXgdGyE99iwZrdO0j4BDHWfh7nVrIGc
Message-ID: <CADvbK_fLKuUaB1_M4DyLC6V==7ThXt+4heyZykBrLM5nL28DYw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 07/15] quic: add connection id management
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 9:55=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 8/18/25 4:04 PM, Xin Long wrote:
> > This patch introduces 'struct quic_conn_id_set' for managing Connection
> > IDs (CIDs), which are represented by 'struct quic_source_conn_id'
> > and 'struct quic_dest_conn_id'.
> >
> > It provides helpers to add and remove CIDs from the set, and handles
> > insertion of source CIDs into the global connection ID hash table
> > when necessary.
> >
> > - quic_conn_id_add(): Add a new Connection ID to the set, and inserts
> >   it to conn_id hash table if it is a source conn_id.
> >
> > - quic_conn_id_remove(): Remove connection IDs the set with sequence
> >   numbers less than or equal to a number.
>
> It's unclear how many connections are expected to be contained in each
> set. If more than an handful you should consider using RB-tree instead
> of lists.
>
We limit the max number of issued CIDs to 8 per connection, and the CID
per connection traversal is not on the data path, so it's fine to use
lists here.

Note that one connection/sk has one source CID set which contains a
couple of CIDs used for connection migration, and one dest CID set
to saving peer's CIDs.

> [...]
> > +static void quic_source_conn_id_free(struct quic_source_conn_id *s_con=
n_id)
> > +{
> > +     u8 *data =3D s_conn_id->common.id.data;
> > +     struct quic_hash_head *head;
> > +
> > +     if (!hlist_unhashed(&s_conn_id->node)) {
> > +             head =3D quic_source_conn_id_head(sock_net(s_conn_id->sk)=
, data);
> > +             spin_lock_bh(&head->s_lock);
> > +             hlist_del_init(&s_conn_id->node);
> > +             spin_unlock_bh(&head->s_lock);
> > +     }
> > +
> > +     /* Freeing is deferred via RCU to avoid use-after-free during con=
current lookups. */
> > +     call_rcu(&s_conn_id->rcu, quic_source_conn_id_free_rcu);
> > +}
> > +
> > +static void quic_conn_id_del(struct quic_common_conn_id *common)
> > +{
> > +     list_del(&common->list);
> > +     if (!common->hashed) {
> > +             kfree(common);
> > +             return;
> > +     }
> > +     quic_source_conn_id_free((struct quic_source_conn_id *)common);
>
> It looks like the above cast is not needed.
there will be a compiling error:

/root/quic/modules/net/quic/connid.c:68:66: note: expected =E2=80=98struct
quic_source_conn_id *=E2=80=99 but argument is of type =E2=80=98struct
quic_common_conn_id *=E2=80=99
   68 | static void quic_source_conn_id_free(struct
quic_source_conn_id *s_conn_id)

Or you mean change the parameter type of quic_source_conn_id_free() to:

static void quic_source_conn_id_free(struct quic_common_conn_id *common)

>
> > +}
> > +
> > +/* Add a connection ID with sequence number and associated private dat=
a to the connection ID set. */
> > +int quic_conn_id_add(struct quic_conn_id_set *id_set,
> > +                  struct quic_conn_id *conn_id, u32 number, void *data=
)
> > +{
> > +     struct quic_source_conn_id *s_conn_id;
> > +     struct quic_dest_conn_id *d_conn_id;
> > +     struct quic_common_conn_id *common;
> > +     struct quic_hash_head *head;
> > +     struct list_head *list;
> > +
> > +     /* Locate insertion point to keep list ordered by number. */
> > +     list =3D &id_set->head;
> > +     list_for_each_entry(common, list, list) {
> > +             if (number =3D=3D common->number)
> > +                     return 0; /* Ignore if it is already exists on th=
e list. */
> > +             if (number < common->number) {
> > +                     list =3D &common->list;
> > +                     break;
> > +             }
> > +     }
> > +
> > +     if (conn_id->len > QUIC_CONN_ID_MAX_LEN)
> > +             return -EINVAL;
> > +     common =3D kzalloc(id_set->entry_size, GFP_ATOMIC);
> > +     if (!common)
> > +             return -ENOMEM;
> > +     common->id =3D *conn_id;
> > +     common->number =3D number;
> > +     if (id_set->entry_size =3D=3D sizeof(struct quic_dest_conn_id)) {
> > +             /* For destination connection IDs, copy the stateless res=
et token if available. */
> > +             if (data) {
> > +                     d_conn_id =3D (struct quic_dest_conn_id *)common;
> > +                     memcpy(d_conn_id->token, data, QUIC_CONN_ID_TOKEN=
_LEN);
> > +             }
> > +     } else {
> > +             /* For source connection IDs, mark as hashed and insert i=
nto the global source
> > +              * connection ID hashtable.
> > +              */
> > +             common->hashed =3D 1;
> > +             s_conn_id =3D (struct quic_source_conn_id *)common;
> > +             s_conn_id->sk =3D data;
> > +
> > +             head =3D quic_source_conn_id_head(sock_net(s_conn_id->sk)=
, common->id.data);
> > +             spin_lock_bh(&head->s_lock);
> > +             hlist_add_head(&s_conn_id->node, &head->head);
> > +             spin_unlock_bh(&head->s_lock);
> > +     }
> > +     list_add_tail(&common->list, list);
>
> It's unclear if/how id_set->list is protected vs concurrent accesses.
>
id_set is per connection/socket, it's always protected by sock lock.
I will leave an annotation in the description of the function for that.

Thanks.

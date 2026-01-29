Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECFC2D0600
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 19:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769715656; cv=pass; b=V9oZoPNXTNtE0pT0gfxg7Uc4sQ0Ry3DqLEGgXa1tgC/TOncyx9TZpv34bG40Wp7EkwEj5Uy/Roc2NIUN7Wk3SH+AAROnOgvdZlC3da7FyBocUYD4nsC7qo/GIc3Dyi4Ehm6UhlQlYHp8SOLfCPtwflRtmEJRjsHy5Gky7GjnaX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769715656; c=relaxed/simple;
	bh=OQufuj5kkmYMxx6ttww64CZWm+ndiofyh3a3rNhNfCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+sH9JN2gLZCqTkM2X/ifQjWIsrva8dn1CHwh7eDBeJnZzRa2QRJ2JJO0SE4eh3jL7Sb//Vbubncsv11ZY89aLXdTQEHquH1DU93eXxn1IXF6P+JRqLyvriF68pUBXCmcl0MGNbzblzJQeB4vAWA50pFG2rWxVFpZkys1DnIt68=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TDUaVZHL; arc=pass smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TDUaVZHL"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-5f539e05d63so482030137.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 11:40:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769715654; cv=none;
        d=google.com; s=arc-20240605;
        b=hAPpZyU6WS01VhyLp+pEERAVZbzeLUVF6LAc66Mu9LTXooYeXu7itxX2Aw/st1fSu6
         rvrGwog5aeFm2KbJkxFvXfWbAaC6fDZRRJxd9h+XJDrmq5CDFsCzNpUDQ90EmplF1YRG
         EqdpFw9676X3jxYAjpK68qrhljA+xZyTLXS5gRMm820yV3UgAB4nXirltfN3fu7k/hV7
         tTj1LuI+aX1A38swnuRaRQfGfqXB48mPXRLwk6A3jNQB3M5BFXBysjmykzOatLQayU9c
         mqr5pvOHZ9C2lt2fX2DL9FZWerWfxZ+U2h+99IVefUQjNYQPovID4N4mZTFjxNAF5ft8
         Wx4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vWXOUBeb3b+nw5Cfis8wSYxSsjd/F4GCHIXMwqvZur4=;
        fh=OkPVkVCWnL8rse8iTr8tmm74XvDDoxVULWsITY5hGps=;
        b=jTmqzmqlBFEjUUBbNvYxPQ+JQlrMj8tiTdFL94OtdO0t8jJbb/2tHUf190ttpNszqW
         VCy4F+LsjKDZJfXI/Kr+ChGWWmaXbvsM0FhhSkVc7t0Jzn5Mh5BjcGg+eVPX71LeIaPW
         tKQOu91tmQbR9zOgzrZUxfy1PfAf0paN5G12pQi9+ASIfxKV60WOIZNR3iM3xY5/PX6k
         iGJ8lR+wQyAMRr9gJrrQWLaq/KKiQ+FlnWiAOSIgdqbump1bemxWuL6pBQvZyyOBA9fw
         FnJoX8WoMuNsnUB5kzqlm9EwIJf4W6PB2c9zrA4SWv8bUMdVcwiSGUw6YWfLKzEr2Kxq
         QOIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769715654; x=1770320454; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWXOUBeb3b+nw5Cfis8wSYxSsjd/F4GCHIXMwqvZur4=;
        b=TDUaVZHLKS6j8mBQqgRKfis+WbqxJrpZLP6/Xvs0c3IEw8N2Cmsmn2ZLJUljZSeULi
         YLt50yi0EpsnbAVU0Kam8JKrRFpMcyE8J4N7xOpJ1YuFCE1IziipaSTAqGpxLLUeCWZF
         7rRjbV5T21seHDGe89XVSx7JWPNdoK3DzjRkjpMH7u1np7+IWm6fFrNrDnbN7q/+8zJx
         i/MCvMOy1UiN0xAsXsUwQMIP2KVfPCYyIhO79+cHR0vv7GMApT3N50WP31XHZiIV5XWT
         1PUPignZ5q6gMwP8VcxpNYKVrfXZ7tFUR2qsR2yyGiMAZ7dTvugzHjYu/P9fkpd4BtJu
         wJWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769715654; x=1770320454;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vWXOUBeb3b+nw5Cfis8wSYxSsjd/F4GCHIXMwqvZur4=;
        b=ME7ndDJNbP5Q73iOPcJJeBZ6WLDAnAFeDJomP+kxKYDu0VcjVaaxiuD9//krG3ZEf5
         fPVFkwGRweZ2g1cbbTDeLjhSyMBmWVgTpSs3Zrhe8t+6pMRr1xpUo5OjmQIyqgpvgrxP
         a75Cdcjy+zuFP2smQSLr9dgm++R3BsqKYwOwXOsF7NW95wZV1PHVqEJVM7Agc0IFROCD
         JpkdMO3EecAm0uAIfckKWwjb2rj8O77yw0aLPs2CtsucBj04iEO06vZ9zvxQ/1d4WTxD
         AINYyi/n2JDkwIxrS9LEogAeOvBZrYKjXKlqU51+bdZlV/Lt0LxlbCV+lrOfrn8B6Rlt
         KNVA==
X-Forwarded-Encrypted: i=1; AJvYcCVbVHAzmS3Oqb2SyIB8zaZTDgR4+fbyaG3NNBPC+dV1hKCxFtHviA+TF66kJixeUyjBt7iLH38ct0eN@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5CHQJ1KGo0fVt/x484bneDtq5pIRxr+REWd+Nu1VFnd4h4uu6
	YXddWCe1PjbZaapeGSY5epidOTMfuxE8dTmZBkCfaXns8CMK4nGcBjphF6fa3P+22U1UycFd8al
	j744+N2n8ej3ykS/cbeO3GXxY071CN1E=
X-Gm-Gg: AZuq6aLldPGC24ncc4GKsqJjoD4nHfEFXQlU909c+bfWuWkTI7y4Ry1gudHufPd4PPq
	KRPd8Q0jiofInTX2VU6ByWwv9uL7OpeuDYfZsDqF2x77By+dvBFCraxg3FwyvBjqBGSbU7zEkok
	hEUtug2MA5MGSARFFfJmOuoXX9PeuH0oCTBAY6na0RsZ6lXqeADSf4pOsPwPhZi/CB3p9qxe0e3
	Cebkn6lBwqipNz8zVB2c0WY89N8uCuGVdmmiqV4TaxHyht0AaGlJwZHf8pq4fjLC71Lf3S82tky
	NU1ugYnAlHlefP/3F8nTSmLzpT0tJQ==
X-Received: by 2002:a05:6102:304e:b0:5f5:2e08:bbab with SMTP id
 ada2fe7eead31-5f8e23e7d3amr226299137.6.1769715653861; Thu, 29 Jan 2026
 11:40:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769439073.git.lucien.xin@gmail.com> <1cbfbd45fda48c82f629b000fc102ee011515e12.1769439073.git.lucien.xin@gmail.com>
 <9c17e0f5-0a07-4800-9356-0ee9445e3922@redhat.com>
In-Reply-To: <9c17e0f5-0a07-4800-9356-0ee9445e3922@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 29 Jan 2026 14:40:40 -0500
X-Gm-Features: AZwV_Qjx14-1bOrrh8LVqqfM15IbyrS2KpNfixIqKIZVNgumQoCFAq17MEBRSlw
Message-ID: <CADvbK_f7++7shAGwYLcz=ph-te_d+z+bMxiaTtY2Ahze+Wagqg@mail.gmail.com>
Subject: Re: [PATCH net-next v8 03/15] quic: provide common utilities and data structures
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 11:26=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wr=
ote:
>
> On 1/26/26 3:51 PM, Xin Long wrote:
> > +struct quic_skb_cb {
> > +     /* Callback and temporary context when encryption/decryption comp=
letes in async mode */
> > +     void (*crypto_done)(struct sk_buff *skb, int err);
> > +     void *crypto_ctx;
> > +     union {
> > +             struct sk_buff *last;   /* Last packet in bundle on TX */
> > +             u64 time;               /* Arrival timestamp in UDP tunne=
l on RX */
> > +     };
> > +     s64 number;             /* Parsed packet number, or the largest p=
reviously seen */
> > +     u32 seqno;              /* Dest connection ID number on RX */
> > +     u16 errcode;            /* Error code if encryption/decryption fa=
ils */
> > +     u16 length;             /* Payload length + packet number length =
*/
> > +
> > +     u16 number_offset;      /* Offset of packet number field */
> > +     u8 number_len;          /* Length of the packet number field */
> > +     u8 level;               /* Encryption level: Initial, Handshake, =
App, or Early */
> > +
> > +     u8 key_update:1;        /* Key update triggered by this packet */
> > +     u8 key_phase:1;         /* Key phase used (0 or 1) */
> > +     u8 backlog:1;           /* Enqueued into backlog list */
> > +     u8 resume:1;            /* Crypto already processed (encrypted or=
 decrypted) */
> > +     u8 path:1;              /* Packet arrived from a new or migrating=
 path */
> > +     u8 ecn:2;               /* ECN marking used on TX */
> > +};
> > +
> > +#define QUIC_SKB_CB(skb)     ((struct quic_skb_cb *)&((skb)->cb[0]))
>
> Please add a build time check on quic_skb_cb size.
>
I may put this in quic_init():

BUILD_BUG_ON(sizeof(struct quic_skb_cb) > sizeof_field(struct sk_buff, cb))=
;

thanks.

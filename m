Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2EC324B19
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770319092; cv=pass; b=CSK0vh/rNdfCUuo0purIHGj668r7c7YtrXrTL8vAJx2vyaBcxvpXc+KIjMA1Wf2Jqm0APUac868mReQ9N+OJBvqsBvUhPEq3OBH/7EchTklDE6VbrUGSQvY1dIO1LtXeaAfiEUcdnIvaMJiBa1Yy7FFiAbJI5t1RcEMUG5J3zBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770319092; c=relaxed/simple;
	bh=QRhy0aaIatw5X2ingQ3dP6bzvBtQ67P0/48x91gmp1w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XVZ7gf88Iv8vDTQ6qHt/DI5nAC214Cigx5CnWjX8m37340e2PzJpM10Dxqd1ajG5hqUjA6tMiKfvpWE/iP6V48Aj0u+p2CK8SKwzTTc+/i7ucOB15dA0b/mZlInsW7mrrMEccJgspFl6FuMQyseIhyUXmNIGMdyzxT4Nx/4GEYI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wsf1j6w9; arc=pass smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wsf1j6w9"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-823081bb15fso781667b3a.3
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:18:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770319092; cv=none;
        d=google.com; s=arc-20240605;
        b=UD5cShhEZLLq2K1GgLSQ004bKQ2pZPa/j9nb27MJ+lbwbkMAC+7iLQPcgtLvlLfFyy
         UrCrG30lrV2AbRjLZd+4BPHO4+f8yFdc505c9W8Fp/wKupqi6iA0UkOPrChYRMtFiUvz
         o2v8ljFPxvhViTJb+tlQkrzY6fnVQH5Uu245E+PhnBUkcrWmP+fw6GwV6cJQnU3//pVm
         35pDxUnzs76p1hXLblXOmLLKjh5Z48SylHD9E/IrXW3lFzj2t94SWXnop+flrPjSgAga
         XNhmoEyz6Q6bvjXq7eSpp4YHR9lz6q5bb2c8pDkNqE5pkMkMmv41gPNMBEkrfRpV5ENF
         8/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Vp6eSjM8r19A+ldOLHO2Ln5yqplokvRmWPI5a2FR3lU=;
        fh=2ou93IrQw/J4WyMGrkF3qrdQfWS9uiPnT3jtBtcP7uU=;
        b=cN6YMFQtdMsu8ZlbG3HVTds2IzI/lTQVOjOa25M6C4TUFx6aLcp33BQbafZBojmAJF
         OWftOsOTDHvdl3JIFQI5rX0GVRNqRnQlp1h6RxfMIQ4HzAeOsCyyFbVIIkZ5RLdDOscq
         jXuldcdGgVjAWl8CZba6UPL7PoRP9UtvB6RW+dGhgxNCJSlPUWvWCw9oZjrJdbzxxiIA
         uFW32stg8f5P+l83eeo99IOlTLD3JDi4IEv51KgV+N/fCubo9ZM8pR6tt6GKiYm+aPWx
         ueEAqpiSBw4Y/JG9XhT4ibYTxUJj2asc2yFt28dPb86hwh+DBTV0tdkJf9cq5cPBLBO9
         GXzA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770319092; x=1770923892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vp6eSjM8r19A+ldOLHO2Ln5yqplokvRmWPI5a2FR3lU=;
        b=Wsf1j6w97UwfEIyFwzWGNa28q28GTq8e5u7+D9V0xLKQ+VxTPI92JUmWyu6J5eGYzA
         38gyAL998O3UNabkmGuN9uHMuB1yCt0//NAyG97Awd52lE7MXle3JvDYP6GpArFhjpXb
         X5NdEJkuhITXNXdocoHPOVVSw/T/0PaMgAuXT05rwdm9CIJPDwLM/WHlD9G/spr/u9CB
         gNr2LMBdBzsCc1m0e4YF6MSW6xaITa9jCXEoE4Olep54/nqmsXgprbacF+PoA/rRvAMA
         0mAkQ7z+GmjiRo0zc2b+J/FaX8T37McF9ooscprY1tziTW5Iq32GRiR4M/RwFzVu2WQR
         bp0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770319092; x=1770923892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Vp6eSjM8r19A+ldOLHO2Ln5yqplokvRmWPI5a2FR3lU=;
        b=T05VCcB7fJbVQ/2mZql2erg76imeOMoArhUNoIPsk/BqVhC/hnget5WkOPFEc3SBO2
         qnPIQ0cBYplQYNfDRPYs8hYysJE0Hies9E//OQiFEh0bUOdNAHUUe+yRh9tW+qiTUi53
         wLSGud+ZLoEk8qsMs3vVjstVyP+v/V1ZarXO4mDKxmzE/ffuyubMNYnrc+e+uHasyAOU
         KSJiAVNnxlkHHPLHbtUNu3Y2akPnQnk1HNQpsyf0LhBobLcV9rAWi/tdPi5tIndsPslJ
         hOnr9hM/Sn5uS7XzEhELsY3Woe6vtd3DmeMaEjymJEZS7RoWupp7Bhd8zKHGfWCL50SF
         NkkA==
X-Forwarded-Encrypted: i=1; AJvYcCUVJ2eEocYARguB6olCLUmyn8fgPAWXOuW9WoboobnSJsvUAZFtuGQqkFzOWP2nLisscDmp3jjgPnHX@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ64SMO5UG6s+oiGxeHBCXJD3WyHdw8HfJJ6o5toth8EHZ0mJx
	5gk+U+nZv7gm0xjBhvB6N/1kkhZQQDfZ9QYIzuqUMuNLV+lXfl7HO6ytqA3sIExL63scnZYZXs9
	Jc9GwxgQMBZq0ysBf6Ab1UqJydrptXL0=
X-Gm-Gg: AZuq6aKHOH0cEb7poIyJm7OHyKwKoxOFlVoBHdXioIoXptR7SkPxMNvKMkSiiHyBa98
	fs22y3pLVYDNH+vets/YTWq4vJeYafGieUnwNC+yYW4WHFGl3/g5Hx8F2JBhYVhhbaFb2c8F3mi
	FTA7bnHafM3jqDijPgj3S+9H2u8RGtNp/5zxrkGGwlkdwkHhpNSWZZBciwpDqZ3jYiAsjAP2HJL
	4Ny8nPqWgxUYqba9TZNReq23gHLJrRerouuj2dCqw9FDUJmuZVSlQIF90Akb3pJq+QhckNnRw/z
	fBnKGhlRC2b6jkT2js84OMbtmXzj
X-Received: by 2002:a17:90b:268b:b0:34f:63b7:a1f5 with SMTP id
 98e67ed59e1d1-354b3e2f135mr64355a91.21.1770319091958; Thu, 05 Feb 2026
 11:18:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <74174c085fb11b8a63e72a7df730b6f4a7479c5c.1770042461.git.lucien.xin@gmail.com>
 <20260205115449.2195294-1-horms@kernel.org> <1bcfe20e-0103-44a5-82b5-90cba7ba5a60@redhat.com>
In-Reply-To: <1bcfe20e-0103-44a5-82b5-90cba7ba5a60@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 14:18:00 -0500
X-Gm-Features: AZwV_Qh_mc3jaIOzqDW1hY_eOgDZvqz5PolYvBWVQrjtRoVkuvNydWMH3Z6Pil0
Message-ID: <CADvbK_eLJ2HWxx5G8PBwePCUZ7dXdDw6X8pryWWyn7SRx1NdDg@mail.gmail.com>
Subject: Re: [net-next,v9,03/15] quic: provide common utilities and data structures
To: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, steved@redhat.com, marcelo.leitner@gmail.com, 
	aahringo@redhat.com, alibuda@linux.alibaba.com, jbaron@akamai.com, 
	hare@suse.de, kuba@kernel.org, tom@talpey.com, linux-cifs@vger.kernel.org, 
	daniel@haxx.se, quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com, 
	dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com, 
	pc@manguebit.com, kernel-tls-handshake@lists.linux.dev, 
	illiliti@protonmail.com, xiyou.wangcong@gmail.com, 
	andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com, 
	matttbe@kernel.org, netdev@vger.kernel.org, smfrench@gmail.com, 
	metze@samba.org, mbuhl@openbsd.org, chuck.lever@oracle.com, dreibh@simula.no, 
	davem@davemloft.net, sd@queasysnail.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 7:51=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/5/26 12:54 PM, Simon Horman wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> >
> > For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-lo=
cal.html
> > ---
> > quic: provide common utilities and data structures
> >
> > This patch provides foundational data structures and utilities for
> > the QUIC stack, including hash tables for socket lookup, connection
> > ID management, and helpers for encoding/decoding transport parameters.
> >
> >> diff --git a/net/quic/common.c b/net/quic/common.c
> >> new file mode 100644
> >> index 000000000000..94321f3f213d
> >> --- /dev/null
> >> +++ b/net/quic/common.c
> >
> > [ ... ]
> >
> >> +/* Reads a QUIC transport parameter value. */
> >> +u8 quic_get_param(u64 *pdest, u8 **pp, u32 *plen)
> >> +{
> >> +    u64 valuelen;
> >> +
> >> +    if (!quic_get_var(pp, plen, &valuelen))
> >> +            return 0;
> >> +
> >> +    if (*plen < valuelen)
> >> +            return 0;
> >> +
> >> +    if (!quic_get_var(pp, plen, pdest))
> >> +            return 0;
> >> +
> >> +    return (u8)valuelen;
> >> +}
> >
> > Does quic_get_param() need to verify that quic_get_var() consumed exact=
ly
> > valuelen bytes?
> >
> > The function reads valuelen at the first quic_get_var() call, then deco=
des
> > the value with the second quic_get_var(). However, quic_get_var() deter=
mines
> > how many bytes to consume based on the varint prefix in the data, not f=
rom
> > valuelen.
> >
> > If a malformed packet has valuelen=3D2 but the varint encoding requires=
 4 bytes,
> > quic_get_var() will consume 4 bytes while the function returns valuelen=
=3D2.
> > This could desynchronize parsing of subsequent parameters since the cal=
ler
> > expects the buffer to have advanced by valuelen bytes based on the retu=
rn
> > value.
>
> Hard to tell without any caller for this function. Possibly you could
> drop it? IDK if enforcing such check would be correct/safe from an
> interoperability PoV.
I kind of forgot why I didn't validate it, I will decide if it should be
added after interop testing with those userland implementations.

>
> >> diff --git a/net/quic/common.h b/net/quic/common.h
> >> new file mode 100644
> >> index 000000000000..bfec0aaf2907
> >> --- /dev/null
> >> +++ b/net/quic/common.h
> >
> > [ ... ]
> >
> >> +#define QUIC_CONN_ID_MAX_LEN        20
> >
> > [ ... ]
> >
> >> +struct quic_conn_id {
> >> +    u8 data[QUIC_CONN_ID_MAX_LEN];
> >> +    u8 len;
> >> +};
> >> +
> >> +static inline void quic_conn_id_update(struct quic_conn_id *conn_id, =
u8 *data, u32 len)
> >> +{
> >> +    memcpy(conn_id->data, data, len);
> >> +    conn_id->len =3D (u8)len;
> >> +}
> >
> > Should quic_conn_id_update() validate that len does not exceed
> > QUIC_CONN_ID_MAX_LEN before the memcpy?
> >
> > The destination buffer conn_id->data is a 20-byte array, but the len
> > parameter is u32 with no bounds check. If a caller passes len > 20, the
> > memcpy would overflow the buffer.
>
> It looks like the check responsibility is on the callers. I guess it
> would make things more robust and simpler move the check here.
>
Parsing the connid from incoming packets will always check its length,
not good to move the check here then return an error for coding.

I will only leave a comment here. like:

/* Caller must ensure len does not exceed QUIC_CONN_ID_MAX_LEN. */

Thanks.

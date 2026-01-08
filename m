Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7082E0412
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767891514; cv=none; b=BRnGL4CnVBZo0h/e/Z3fcJip9ijG5HP4XlyBVJCirRTKuETgAwGht9unlvIlVJZeSpCrQTS0VUx67LD/0dh8XBCCWg2ZKDEmeT+m+yyYA7YeaS+froeTqe54jK3UoZNgxqaJClJ767d2Jqfx1w3J4mlmjkJAr2m3jKNVQ1rlvh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767891514; c=relaxed/simple;
	bh=MVTzGXbScex35TzesGDsimq24WTvc4nqhQnvv4OBy3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxT0SmRRLCUxxSQiJwEvCY2zqvgfaOyOIb2cfEIayzjAndf5Va7H0pVKxA+RkzJTa6Hb48h2qwFKU/SJA/1RWQnysKO6pSm61uu31mOQxtttS6DN0NiaBrxquIy5olFwi+T8sxZN++NB/vGc9l4o8FAXz46xOKCh7pxq6K7TggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DRW1BX6J; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DRW1BX6J"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c3e921afad1so1502648a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 08:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767891511; x=1768496311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fIpmw3TbxuFac2rr3Ral/5NrCqmxWN0HTMSbOEZp4Sw=;
        b=DRW1BX6JIl5KubVDEoi/bLzYViOSOuIQB0Vqt8HDE5tY6ut+XRnck3d83XoYziHEWu
         vsnFlKF8tnjlsR4iMiiQ5Yly3nkCI4NmBeDGHtVL7JEqU6WPBrkV8t1uPK64vvsQB38V
         +D4Jon6ClRLavjf9AUDqo2bC1/BkRljIVizM16sKo7IG53+6kGsSZ7v7bjLfr7wimtTO
         d/gnZfOU0cY+RYznJS7mMDVJuecDDyTZkRMoSQLzCMC9D+LF3xHIz8NQNfD8o6CebUif
         tG1LvV5GlCHid6lIoWV5Rkz2oJs4XDQ87n+NWzwl0nOCFha1gtWniaV0MT/uhZDGvrA8
         BhmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767891511; x=1768496311;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fIpmw3TbxuFac2rr3Ral/5NrCqmxWN0HTMSbOEZp4Sw=;
        b=Z/KsVAeGx7tMcSR1IH3TxxqXQF26gOOJVjQ2R+mjeRHk0ceJBMbHmaT6GG7ByQVuC/
         VeSwyjZyKPwjAnGR1YX0Sym620BSxjxwP+lwBzTDX/Wry5tINbAJaUwT+fI3rV4rBWVl
         nKtDHNs1An37OXvsuo31j1o0YVzK5sE3r6gM4fGCrkaULTSttq0XohH6bUXLBEJVb1OE
         ThiifgU8hrugTetMRqnBnlX1Y8Prly8aunuLeID1Q2y2PV2beRW7M6CFqdytqVMZuq5b
         9vdksRxq40FEuDVzReA02HmvSKRhBmAWSEnDBcOs80azSwekkusWcd0+He5N486+esWy
         nk4g==
X-Forwarded-Encrypted: i=1; AJvYcCUlons/YsHiP76eaGPAZ3RCrKzgs/YJ8K3jsi0BKqLWJKH6KKxXROVFL48Xgvb8YG4Gbieh/9DtaIGL@vger.kernel.org
X-Gm-Message-State: AOJu0YxcM3s4b3dKY6uZekoN14fwMuXtQZ0t/K05eRcaybVV29hVg3Jh
	UGI+VMmto6/Sph84XgypW2s8S8mPy4bgmdUHUx/m0CwW12e8N6bbiiutA+z+/PYrPhZj4dMANYI
	BkZ2Yh6N9kyUUBiiFfjv5i8+ooyWmwX0=
X-Gm-Gg: AY/fxX6mOT2Eaoj3WA/b/A8BFwSGRDKJELYCkgt1sglQx9S+N3McJHqFZxIQwq9GMgv
	eHc/p+MavG9uU3ouUYYmF3iabwNYvlhOUby7b8+Y0DlLJWgOFTlzyAkgaixz8u5dFaaQ0odVT1k
	6w9YGenNPmCVSi+CmqTdFJXvjtDWb2d7SdhDmORueQ8LNjEaZIv1RxaDgAZZ9dejj5R8lAfdfY/
	S7ioK8RZxaSH+hs4DzC2EA4UHJSKzFvntjuWbPIqZHBLe4eykM4/tjcqhxye3AEbIJCCZUPUBPT
	DXDLEbpnJQuNS77v6rm9OIxTKBlf
X-Google-Smtp-Source: AGHT+IHULotT7XFOA4hDBTUJBhfsHPefC4PlHzU1kuHvxYpkrgCp4pB0H1Sx2VpJWUGOCosSRzEF1Th10/Eb/PAqOAk=
X-Received: by 2002:a17:903:1a6f:b0:2a3:ee53:d201 with SMTP id
 d9443c01a7336-2a3ee53d218mr72769795ad.12.1767891510843; Thu, 08 Jan 2026
 08:58:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767621882.git.lucien.xin@gmail.com> <f891d87f585b028c2994b4f57712504e6c39b1b5.1767621882.git.lucien.xin@gmail.com>
 <6c8a1f56-16ed-482f-a9a8-ac840a7aebd3@redhat.com>
In-Reply-To: <6c8a1f56-16ed-482f-a9a8-ac840a7aebd3@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Jan 2026 11:58:18 -0500
X-Gm-Features: AQt7F2r2eahRmpC-isaCgnTPZ3EtB5uQT5Ead8hHYSoe5kUDYAgbUFOe0Uminug
Message-ID: <CADvbK_d_3cF63zM6cJv0Oc5XB7ntaZozzbu4K+xmM2jaS7Jshg@mail.gmail.com>
Subject: Re: [PATCH net-next v6 03/16] quic: provide common utilities and data structures
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

On Thu, Jan 8, 2026 at 9:45=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 1/5/26 3:04 PM, Xin Long wrote:
> > +/* Check whether 'd2' is equal to any element inside the list 'd1'.
> > + *
> > + * 'd1' is assumed to be a sequence of length-prefixed elements. Each =
element
> > + * is compared to 'd2' using 'quic_data_cmp()'.
> > + *
> > + * Returns 1 if a match is found, 0 otherwise.
> > + */
> > +int quic_data_has(struct quic_data *d1, struct quic_data *d2)
> > +{
> > +     struct quic_data d;
> > +     u64 length;
> > +     u32 len;
> > +     u8 *p;
> > +
> > +     for (p =3D d1->data, len =3D d1->len; len; len -=3D length, p +=
=3D length) {
> > +             quic_get_int(&p, &len, &length, 1);
> > +             quic_data(&d, p, length);
> > +             if (!quic_data_cmp(&d, d2))
> > +                     return 1;
>
> AI review found something likely relevant here:
>
> """
> Can this cause an integer underflow?  When 'length' (read from the data)
> is greater than the remaining 'len', the subtraction 'len -=3D length' wi=
ll
> wrap the u32 to a very large value, causing out-of-bounds memory access.
>
> Compare with quic_data_to_string() which validates: 'len < length'.
>
> The same issue exists in quic_data_match() below.
> """
AI seems right. I will change it to:

                if (!quic_get_int(&p, &len, &length, 1) || len < length)
                        return 0;

Thanks.

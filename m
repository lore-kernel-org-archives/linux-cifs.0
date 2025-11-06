Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02C534AAF3
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762449736; cv=none; b=NgMPAYnGFEX89L1/eUwBZ5wEyy9AYgiA8Vf1AtP8VeQ8WwqJk3mko2lyqwDFRCBaMSsspl0xX3Ee0oh5/yJuAm+EP2mvzOZREz9moOsD6+4jncA9HC/y/EkpvLHqZwLki7oL8umIKogjHO83AiobHqWcBNglX/TaHvWCxnZoWXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762449736; c=relaxed/simple;
	bh=NH2hfHppCjrZFVx6eqpdpt03wHQYT9rQOCs3FER3WSU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bSckT8EAk0kxBYAz/8WvO1lkLJA+AYtKY6wwPpZ/6Pxs5aM3DL3s4GFJ54BDs6lUKUtnprR/oA0eh6IoNuZI7SPVJRz5fpZWE/Octp9/b53/dpYhO3sE1y4rsylNkhCxM29f7Rg00GEAh7z15qMdSJA/A+aShM6a5n28w0vMwZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ecr6jJ0W; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ecr6jJ0W"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-339d7c403b6so1446034a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 09:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762449734; x=1763054534; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ROsaoNagz4I7/dBZaDxwLj1TocAA02sCxxRugnpAtAU=;
        b=Ecr6jJ0W8ehZnjxendHBhQJfsVHKkFWKenIdwRgdz9sZSpKHp3m4xt0oaBey0du3GV
         o3m0440tVDT6tSEIlss0vsm95n9+DZ/bFOBMU1uQmmdEJ6ud9FXTifvYHplJ2lZfCDix
         BpxPGuWBKtCbAqZUoLJxHlucKwcl0zZf5naYzWEJ1adFu+NcJz3qUVTuOzZYamAGtbuX
         ANAdJKUloY/hwG4cwvlmVj53JopAth0/1Zp6/yUSnUlOcZ0D3gknYSVUl1HewPYiMxsl
         0A9hA/lCe0+6S0sAgVZ+G4PgelRxvADX+Lm0tX939d1gHdwfsWwMXjga3xVO5sHeapi0
         y9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762449734; x=1763054534;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ROsaoNagz4I7/dBZaDxwLj1TocAA02sCxxRugnpAtAU=;
        b=jzJl8itav5LtwA7SRUBb4rM/tYNCgpYeMHXi1ucmlregXr8djcqDz/9XeZ7bUNQnY0
         4/MK3omMRl8j+Mj1hnr1q4rISIUBzz9RvM7pUSBUXrZQrKphDicgt2Gz/LcZBUiiSCYM
         adXzbrdTm7fMqqPbWyOVK6rDBQ0i9WD2ENBVybG7rJ9fLqmfSdqiokDN2LRKB8ssdB0b
         DK1b3WefA1kP7lOYsZm/atar5N4o081sZiqp1OiniP29qBsgj96ATpZHBHSUM+buAVLM
         J7W8zb6crcCEG0Eb3T/+sMk3bNJrJcgUGbqCk0Hw05tPs2x1a8yz8xIPRa/UPR1dKB4G
         JVVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWun4/SU3GuQl+lGTKKYZq2j4Fv5Oji/cRcr8brvmgW7s5i3mkTBAXrKGL8RpKf7LrX/3V/v1A1kItE@vger.kernel.org
X-Gm-Message-State: AOJu0YzQF5pZeUvEIyiCrKU5B9HBqXQu612dKOfU7m9ttU68LOye1n5P
	k/3HZA1C3nRzfmzYctFV0UhJ/wfYIycLInZGWSP7tbgTK+jI07tXhiZQqGOrwrdeDBLBRv5Uzbc
	EfA3MPJb+4dBbCuqoHNbRXYTrfQAaNw4=
X-Gm-Gg: ASbGncsVUSYqIDr85m9MeLGq+cY62GbYBvGYosxfBF/obLhQ9zn1w1JJCPB5V8eYMbo
	nlHiJwa2/+0pUvAXslHOHLbonP3cyw93gY5ZzwIo/RgBE0YfSiW5aW0NGmkMAje1UOuRPss0caG
	jJBwkIvB1xO8xmLr5YOeZHfXtJuBI5In2RhS7bK/is2Ph9ITNCHV8E7DJZUCMkVt897Mjfnd6Et
	lxWscGzh5nb2bcyAoClEURFkmSD41PQ838ch8hD4WD/AoT06N+ILQRsbKqtiHgeoIM7/uxJuBXm
	9ZVaIdLyjycbmq8yDHQ=
X-Google-Smtp-Source: AGHT+IGhY0NYTXXkTu0P4tB4nC9X5IQVYEkg7KbXM/lxcc2ajgsNtrlqaMsuOSOOG/NPcl8ekPlhnRj1iJwQaZFqVyY=
X-Received: by 2002:a17:90b:2b44:b0:340:6f9c:b25b with SMTP id
 98e67ed59e1d1-341a6c4d3f4mr11082353a91.11.1762449734034; Thu, 06 Nov 2025
 09:22:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <56e8d1efe9c7d5db33b0c425bc4c1276a251923d.1761748557.git.lucien.xin@gmail.com>
 <989d3df8-52cf-41db-bb4c-44950a34ce89@redhat.com>
In-Reply-To: <989d3df8-52cf-41db-bb4c-44950a34ce89@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 6 Nov 2025 12:22:02 -0500
X-Gm-Features: AWmQ_blXBOK6Lm7J_4Le7zJYv7Rj5XNuyVIMzzqJ7AFvKAnEANk67rWLYRhV00Y
Message-ID: <CADvbK_eGPuueR7XL80eagkrAeJraKBMiTVrhiFb_wnTD+N7qVw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 14/15] quic: add frame encoder and decoder base
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

On Tue, Nov 4, 2025 at 7:47=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 10/29/25 3:35 PM, Xin Long wrote:
> > +static void quic_frame_free(struct quic_frame *frame)
> > +{
> > +     struct quic_frame_frag *frag, *next;
> > +
> > +     if (!frame->type && frame->skb) { /* RX path frame with skb. */
>
> Are RX path frame with !skb expected/possible? such frames will be
> 'misinterpreted' as TX ones, specifically will do `kfree(frame->data)`
> which in turn could be a bad thing.
>
Yes, when generating and delivering an event to userspace, it
keeps the frame content into frame->data, instead of frame->skb.

There's no need check !frame->type for RX path,  and I will change it to:

        if (frame->skb) { /* For stream/crypto/dgram frames on RX. */
                kfree_skb(frame->skb);
                goto out;
        }

if skb is set, it will go kfree_skb(frame->skb), instead of kfree(frame->da=
ta).
Because if frame->skb is set, it only needs to do kfree_skb(frame->skb).

Thanks.
> Possibly add a WARN on such scenario?
>
> /P
>

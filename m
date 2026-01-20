Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE54441056
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 16:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768925269; cv=pass; b=TD4ihSrKLnnGGSbZ/TGuZD158CkWddToAj0nR0uSIqZFA5P+xMlSZ4rn93mETD9gkg0GJu3uLssB7k9DGEMMf/SUuM+Dq/vmq8qm6OmorIB/SeZN8taOA5uRtem/d088/EOwjXxwukBxk1mnUGQ7m1Ui/JZFODv4tSkcbIuPq9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768925269; c=relaxed/simple;
	bh=67lJ0kNh1HNTrTPswLOz4RdeuIvnZ8b8fX/uZYsptR0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R8gC28zLzFwYpo63/dIVO2gyFUR9xzcIUXGuxbTUz2iq8A2Y7i+VVQ/YzyDBmMaChjoaQaVTEGm4AgHksuCQPAuvQT2WfIRgHTEnHl4Cx3ke2P2OfF8lC/xWFgxvalea85DioRJnZW/mwgScC6aj6ZkLbE04Fi1y7D1rRGR5IJU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuUs6ji3; arc=pass smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuUs6ji3"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso3169064a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 08:07:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768925267; cv=none;
        d=google.com; s=arc-20240605;
        b=bktVtbJmcBdVIo0TE9b79UgvdJEJqvJb26KpH4Xapa+pysmlHYFu8E4cpH0250KEoF
         yAjRZqSczMNwctmQ00z58hHCoGWBiYdFWdqzVW71r5sdUVKJ3wGLLJ/gxClXh/ILx6fn
         jzqEtd6x6DtS1gv7wAPmCgoEi8uUTnrtHACMXhNMOXkwHB6i4j8ltuIGUK7u2IkF46PC
         h5iIV+LWjMPkT2/HD+eS6HakH0IQjHgpsXBM+zuurNi8c1Iajy7xm3qli3TrE/1hEt9D
         0hs8e8jtZqxa8S97toFzLr6QTF8b1WNi+CotIkRqwSjUM8VEl3iT+JZFVy+8ssFRhw2B
         MaTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=upRjEeHQQRzQP6jy3c8t8EGW4Gu+OzsotYdbGrZ3w2g=;
        fh=PUUAcJJgvAgYE9PblTo6uAyH18uyXodMzMjMTSjBbTE=;
        b=GIjXkWPD1LvtVWoYbN29R1pIBUARjdgPlP8jygSGbkkWHnDSvHuDGdk1h6Q+T6rkhW
         bGbV3p9XovKK//kEvG/LXlrLc1OyvsZhay7kFIOav0xmCsq2Ak4DK+4K5GIgE5++SnH6
         Sb+A6hOF/aGxlgCYNaFuh1GcSZF6VzNHRfHoMFEWnI/gIbVncwAX4RMK1FN84SExo3Ni
         QUPqTtHKM1S01lp9PvEKhXy6rtJb2p6rVxeMHmP1rHpVxZLraKeYuOk5kc6UoWOBYkWj
         t2k7dC1cXLXC6xFV0VP7IVlInGtMFQ8TBR1I+X6NCIcSTUEJ03QqPws/Uwb9Ck7dNG/V
         qNEA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768925267; x=1769530067; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upRjEeHQQRzQP6jy3c8t8EGW4Gu+OzsotYdbGrZ3w2g=;
        b=WuUs6ji3I3g0/pcQt8ARHfVUHBmBXi8nSTYClIvkVb9tcp6PaP80zA7vf7tUD3gSq9
         5SuZqxOvD8z1y4htMRzxOxvPXuh+4IxBJqTEqAVEaY//osZabA24Cval9EPhh/sDb0Gv
         VzAIe8MHVrr4Y+VlJLAgjSTvsOkUwCN7PgZ/xoFxNu8dohWnrT+TPi/pmqOJL4HQco5N
         TH2g744h9cXPvUfoAWvI2gT/1hIJCcuV2XD5gZbcLfwpagYwMeoT2ttpBQ0MHN+bt51q
         Xf/GLcxLJcSeUmXZuDX8kIegf2QMbqVZi6STpakIWn+lj+8RSMEwxL6MWWSVAL8P59u9
         +M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768925267; x=1769530067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=upRjEeHQQRzQP6jy3c8t8EGW4Gu+OzsotYdbGrZ3w2g=;
        b=dCPJ2pItDaAEyojn9hJNafBi252UkDD3JPhknhm+D4ixslgaAFccvbEqu27Qy8YCO2
         JZqg0Dg8nGjYDnHS9WW88SKpa/KToi4LX049D3UaJANl6YzpzVJloN5frDcCTQ8ld0h/
         jNNGdElAblX7l4zaGozPh7FgjVBhaqfuH890xjVan7OhAvgNzg6axg81NFORikUsrOnx
         UKBIepTLjHKHS+XJQfIBChe9oVfIiLmoDL2MJWN2/CGsPnXkz0kwNskKhsV+aO6gVjl7
         7jgnlBQWreYbTlSJBUFNMzXSrojoubQOO84b0uASZEyG5MeEdVYAhF2NBblqbDjxR3lD
         hOkg==
X-Forwarded-Encrypted: i=1; AJvYcCU9NLbHKtl24aS/xs684y7D6FCa8exEzrQpMbXTfr7p9CMP6XEhzkQGPJpu5hpPmQ34lIARS/dsHWiB@vger.kernel.org
X-Gm-Message-State: AOJu0YyCF4RAWFNeWqF0atYXQcATeuWDnBwV4kh7yaHfsJGAW99bCbTI
	D0TMibg1EYm6gZXQyjZFDyYufPrtk5HtmtDZykXMHRvTjdIB6Q6ZcnJ23ggT/0phxqT9bL+/xKn
	st5EDgjhRqm/msJfdyeMELllJFnuPRR4=
X-Gm-Gg: AZuq6aKg2gy+AjtzL4+qxO7f4jydexyoMJZG1M2bWNpXdPYsAZrlq0N/mfTlGNHbHmT
	6mMZXLSsXIagfEZl4yTA10Xtws+6P5V6t05kEwalnhvJXGqmUro0MjYyeRC3waHlqIRPpcoxjJR
	7wAhHfk+whN81TIT9UF7vrXYub7ATPvHosq3FmXTQc80QpeEpyHQt8zVcwvc6SpcOBY3F37tO5x
	h+WLhhyo50aGGIPTO429Jnd1bDLYS6cM0G38v2yfGYrUJGIXg1QMNDj/4tsa385k+idrENi3Dj6
	ccni9rTXyegJh+rwF2qgc7a3QnpccwD3GIr120k=
X-Received: by 2002:a17:90b:240e:b0:352:c146:dc39 with SMTP id
 98e67ed59e1d1-352c146dc7amr1573652a91.30.1768925266857; Tue, 20 Jan 2026
 08:07:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768489876.git.lucien.xin@gmail.com> <e4753dbdd12ca45edef6815830c1bd437bd635bf.1768489876.git.lucien.xin@gmail.com>
 <001178f3-aea1-4886-92e9-1012ea6d6c76@redhat.com>
In-Reply-To: <001178f3-aea1-4886-92e9-1012ea6d6c76@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Jan 2026 11:07:35 -0500
X-Gm-Features: AZwV_Qi-fSbMUEaDUskVF2b8pxcUG-nT6lofmi0ehgNJjkJjIxLYY_l2FerCdKE
Message-ID: <CADvbK_eUfuuwMg28nxo4g4+fLjJNrRDDWro8oape3uXu6GvoQA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 15/16] quic: add packet builder base
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

On Tue, Jan 20, 2026 at 9:31=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/15/26 4:11 PM, Xin Long wrote:
> > +static struct sk_buff *quic_packet_handshake_create(struct sock *sk)
> > +{
> > +     struct quic_packet *packet =3D quic_packet(sk);
> > +     struct quic_frame *frame, *next;
> > +
> > +     /* Free all frames for now, and future patches will implement the=
 actual creation logic. */
> > +     list_for_each_entry_safe(frame, next, &packet->frame_list, list) =
{
> > +             list_del(&frame->list);
> > +             quic_frame_put(frame);
>
> If you leave this function body empty and do the same for
> quic_packet_app_create(), you could additionally strip patch 14 from
> this series and avoid leaving several function defined there as unused.
>
I will give it a try, to move patch 14 to patchset-2.

Thanks.

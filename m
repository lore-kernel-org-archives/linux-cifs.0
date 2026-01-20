Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5BF38BDA7
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768891969; cv=pass; b=rj9Mt7OCD7qbcwUL56puNFjjN7xl2TWt6fIk+U9oygU7R7JEmSCobOIa642RSsN4ENNf522R1pQBS6WZIk7GrgAve0/rC3y4iDCK1kYYHUz95mt+RByH9+VZQS6Sk0YIWKdKvYeFy5yZNBPXT2Fimj3TwTaKXYmZk13nt0EsaF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768891969; c=relaxed/simple;
	bh=h/OghsBsbwEFB+guNO0JrcBqJ86Bza26jxJQ5M/dJgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MsRxF7/hg/1mdoDtzLN1NcYz4PZ6N5maxe/WmU7hdDKG4A4vbIVOsAVqySyqhNQBncFK9b1OuMQLo5EVyCxemH361DbzcMg/rGzgqBoqplsxt/7knw3wQ2/WnLkJqUDQsMbbzx/ci2F06Hd0G408x+088tiPtT1UWR24HaTDKcw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Up/CuK5n; arc=pass smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Up/CuK5n"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b8765b80a52so811483166b.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:52:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768891963; cv=none;
        d=google.com; s=arc-20240605;
        b=BqbgR1o87eQi7wrg+A3TZA9Mznfe2MpNBt2MxVltWSl0EYrtuoh3OTFgS0lsHbEkRW
         b1jHQI9+MFW3goofYncl+280vXy5TJPv1o7ii/6qrDsR0zBGgnSZjXyoduLewrxoU4jp
         vIH3nnNWNiDJWnURCzQ7tM6hfGnYCqSf9yWKIAuenwDijq4bhZj9toLpbDWXxRaCnTeS
         uqvg1ikNJ3gdAEff993n/n5HiXtE+RSAgFex3OWdFqKByhRnFH91RXMVbBjwsc0qUNcP
         o6/l9Ohxdhw2v+1/IETJbVmmYZZgzaxQdwwuR1x5Pk1bZhnIHi9HF3AruQJOAsqQcQE1
         YG5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rXkGZ7x1ZJk4AWT+r55TCv6INATov24Bavsut2HvpQA=;
        fh=bwNMecjQSq0onAKBBy/p8RwMcd6E9oQsJg+eGYx2iB8=;
        b=EDrveJhTotAVXVnwj/hyiGA68Mdtjw0rgyn1zoA5p59gSM6rhlXi+6MMffxOJLjl11
         WBv045pQw0YOgrvQ+O4YJEtq9hOVPQPbmMlSrnr18/XlsIfbmyB2XAde+ddXdSvf6rXh
         sVRye6sH/Z8YsJEDFwbnodzb+8Z1cv4H0gwR/Qr19KCjSdc2R1E/OliiCNeleeHa60KV
         EvhW7vI7Yaj1zcZbUElPe1XqlT/1IwWHE5m4nlrFHiazsJv+r4er58ERMVrgExGkHJO+
         cM84uqM7VgKEqAASqBfkcbqO8afM/hUMUtnkPThIcvpsTTLV1NEiPRz9KyKgZem/svnb
         v38w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768891963; x=1769496763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rXkGZ7x1ZJk4AWT+r55TCv6INATov24Bavsut2HvpQA=;
        b=Up/CuK5nU4QLKlzHlPPEbUf4OM0rrXvtfNaSfzuPrkVppJh2bOSJ9c3IafEGuWafC0
         vlZBu78NOhio9nWwk/yOQ8Hq1r4cEdJijlKQtRGE3DbDXTSiryyZVux7+IxQdFbhk0Jx
         1U16v2SFBSAhXf39Fh9CtswtGdIFNXIDYN0Px1J1D5ZxKjvNr7nXG6RK3oViv/OgaUJu
         a3fJORvKRX1uOtlW1zh83drRNPiDJcuVruyLURFZSufr2KOVmaLKAANh2jkeR5OXE+5G
         cgKGqJ59c495ePdhcZ91USLePbXJlEfKo8KEUDC1QHdWdrbjk09A0L+eGrlvblIk0cDP
         dEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768891963; x=1769496763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rXkGZ7x1ZJk4AWT+r55TCv6INATov24Bavsut2HvpQA=;
        b=cAfG97ARbTTrNnjEZAvVSbicILSJKxAubw81IVU7dETG94v/BImVTPyb7itz5zBfru
         xM9sNAG0J2raHwC/afCYb99+deiKS9u/YDeQscMPxhy9pyTAEd5AOAxvFEzEp5Hz32/U
         UGjMrvi1jI8/FjxtRfXUqHgHKcqs/dJDdLVfNUSlTljeGq1QF5zwlTrIWXKlxHbK/rDA
         x95gN2QuDBuQWnvcH8p6F49qvuPLGCwZoIYjktqvHOqUkHTpynr4Y7KZxENz4Vdht+3Y
         zP8ElhM/K4IjO9C56TWLpvhP01H5UoiS8pPJr1HLyF+kTUJssDOGbfV412I8NBahA85g
         tJJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIBYJXXty34bvcRBw46+9pwqIT5V26koGEcNWbF3wq6nfcDVPEUmBmNRb+ZwCgIOyxD0xX3XE6JA36@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3W7cnw35scsUPLI1XFCKK6K2RWTAf85Litm3k19OlI+baVtLu
	QEtW/pn/0YXf6x284nF5kZBi7ra6QiIUOdf+TnNouXqVehC3ltIsJxQKFkXGeC0MWcr/KnZU78d
	1Z77JsR/jRwY98tesgOYJqdd3PpTOeag=
X-Gm-Gg: AY/fxX4IJE47XGmA0WbfJjiH4p58kSadnhHtK+Z/U+wVm8BZF+tst9hAPZTNAjjaYKY
	Le2PLAYUU3RmcOn1EtOTX3vol4w5q2/T2pD10bs/o77Mej/n4c6fZqo+oNyBEAQpP1tdmSjxYnJ
	PuF200C2CK2SMC+iKWFk0euQ+VwycbBh5O373Oif7WsjNXKRhnW/7Qn1hWv2OxNdG+RNIY17xJY
	FOdBOHX+lveitht1XAGUjOKt/OMCYQvKK0nYfTLyO6OOlThLOSqt9Q7bhl2U3tXtJ8c4Q==
X-Received: by 2002:a17:906:c153:b0:b87:3280:6003 with SMTP id
 a640c23a62f3a-b8792fc4229mr1282009866b.49.1768891963069; Mon, 19 Jan 2026
 22:52:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260119175445.800228-1-henrique.carvalho@suse.com>
In-Reply-To: <20260119175445.800228-1-henrique.carvalho@suse.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 20 Jan 2026 12:22:31 +0530
X-Gm-Features: AZwV_QhrjyAO5gc4WwkGWkXrBIkWiGnikb4QLHuQkL4coRAjK_Jr9QvNkB-eu1E
Message-ID: <CANT5p=qBM7qWVDFimQ9xzNegWEysDaV3BcNsKESGsrSnwSS8ag@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb: client: prevent races in ->query_interfaces()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 19, 2026 at 11:25=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> It was possible for two query interface works to be concurrently trying
> to update the interfaces.
>
> Prevent this by checking and updating iface_last_update under
> iface_lock.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/smb2ops.c | 19 ++++++++-----------
>  1 file changed, 8 insertions(+), 11 deletions(-)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index c1aaf77e187b..edfd6a4e87e8 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_inf=
o_ioctl_rsp *buf,
>         p =3D buf;
>
>         spin_lock(&ses->iface_lock);
> -       /* do not query too frequently, this time with lock held */
> -       if (ses->iface_last_update &&
> -           time_before(jiffies, ses->iface_last_update +
> -                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> -               spin_unlock(&ses->iface_lock);
> -               return 0;
> -       }

I originally had this second check so that I could test it under
iface_lock here. i.e. we do one check without the lock (in
SMB3_request_interfaces) and another one here with the lock held.

>
>         /*
>          * Go through iface_list and mark them as inactive
> @@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>                                  "Empty network interface list returned b=
y server %s\n",
>                                  ses->server->hostname);
>                 rc =3D -EOPNOTSUPP;
> -               ses->iface_last_update =3D jiffies;
>                 goto out;
>         }
>
> @@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info=
_ioctl_rsp *buf,
>              + sizeof(p->Next) && p->Next))
>                 cifs_dbg(VFS, "%s: incomplete interface info\n", __func__=
);
>
> -       ses->iface_last_update =3D jiffies;
> -

You are right to point that these updates do not happen with
iface_lock held. I'd lean towards fixing this after the "out" label
below (where the lock is actually held).

>  out:
>         /*
>          * Go through the list again and put the inactive entries
> @@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, str=
uct cifs_tcon *tcon, bool in_
>         struct TCP_Server_Info *pserver;
>
>         /* do not query too frequently */
> +       spin_lock(&ses->iface_lock);
>         if (ses->iface_last_update &&
>             time_before(jiffies, ses->iface_last_update +
> -                       (SMB_INTERFACE_POLL_INTERVAL * HZ)))
> +                       (SMB_INTERFACE_POLL_INTERVAL * HZ))) {
> +               spin_unlock(&ses->iface_lock);
>                 return 0;
> +       }
> +
> +       ses->iface_last_update =3D jiffies;
> +
> +       spin_unlock(&ses->iface_lock);

The ioctl is still not done by this time. So there's a possibility of
ioctl failing, yet we update iface_last_update.

>
>         rc =3D SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
>                         FSCTL_QUERY_NETWORK_INTERFACE_INFO,
> --
> 2.50.1
>
>


--=20
Regards,
Shyam

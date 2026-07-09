Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72A7346AD5
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 22:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783635354; cv=pass; b=Xtd+JrG4WArdUO9h2oZ/vXtHwsOm1Horo07DqF6NNkox+PzEvXwDqEllxOjizo5EvpAIkpwBv+ACn+Cmul1N8E+XzHln2cHKPqrDQGZryQlT0voC6EjdTJJUjXQqMP9PSEQirVVOcT5oA8ewlnuqgDn2hbUs9UoIrri1kUuG6e4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783635354; c=relaxed/simple;
	bh=jWjYzkNsjJZH5yGWvGBiZ+VdzbjgCvhdfeVBWM3yb1c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtffKb6TIKZa0tlUXrO5yJzJ1UTYRXRLKUTEeabvMjU+ofeKn+Lr344e/wiHsmBby8eCvSH8+IChy2vEgyVGjIx/I98LTJ13hmPZ1ApVQEoSHotZai9R8EeXXxg3jT5b1fkX38zq85DTwBjiCI+9gGmpqQQ6yp7hPXWaJ6sWFG8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WRZO5o6B; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRZO5o6B"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ff88549786so3329396d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 15:15:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783635352; cv=none;
        d=google.com; s=arc-20260327;
        b=VFnb+VTL+ZctVjNzdLVttnY80uP/YHfXHcyN/sl/TpjwTMLcX/2RZO0ZFS+3gghFH/
         1dPVlGbYsSgJD1V4dfyrHtB5dA1vPliqc3SjIaDqZaVK3XSBGt17rUhlI5jKtjGWSTqn
         X91uW6c9ubY+Eq0LkIdUl1by1fz6X2WMMa9KtCJMQa/SIffyyTyyibbfMyLOcnRxUeLc
         gBJ81tbIweSKr2wUb+bgn4GVvB5gyqte013nwXSoOVv8ioty0wRy7gpnjOqHTc/VD4zh
         uxlojyTkUfucCYrAR5DmGXifvHVU3T1WhbYbSoqoOZDQ5iZ9xSEkZB4fiYsV6KjOUNd5
         GPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/DCoOGjB3t2yqI8PL2v0s5UjSbFRMsQqTYSs+Ahyr1M=;
        fh=cJF4VuGbtb+1JhIyDy1lyJgaBun+of5wByR4/2lUwm8=;
        b=Tk4ScBRcDnJArKTbBANBqLVNaqJd4BbZ0bhC/dHLrZrFzFZYPrJk5RMesbr/iQeW+y
         QNyBUOGQdEgikOC2Ksh4PaiWvLzx9P5deRgQe6OPomv1ZGIcW0Fkzsn60gx0rfLYl0Io
         SKK/rajLlvxCvcWJ5NhjOvM0NW0waAFxs+jXLpRjn/uU1ytYgksM8jRuC5YDGMcenk8H
         ZmSDICutsyacTk4Pi+rzOy/M97m/iyshthQ6TtttU0IWSKqNiV7cg+7TcGsJwQae0uoo
         1zYUlQGP2tEKcTfe8+DPyJ7OJK968tyei6dQcqD3bUJVU5zp4igL9xDqzWVhE+YtXrs9
         E8xw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783635352; x=1784240152; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/DCoOGjB3t2yqI8PL2v0s5UjSbFRMsQqTYSs+Ahyr1M=;
        b=WRZO5o6BySSdSS+OUVab5zEBMfpdLUFH6XELkOsYBvkNAdctvOlxatdqVsYsXBB3Yw
         Wgy/wKCnMOQdO1OvURaNezwAmhXYLa01JgdafwxDN5izAiXK+Zfvva4Nw4Nnct5gHGZT
         wowHvIuUQGqafaVxEbcW3Awwa2dv3JDppX82qB9+uZU4ap7Y9Je0GGp9gulM4wQiE//y
         Io/4VGng39XDWOgj2oO5NuNpbHbcYil6fflukPMMhhAOrEkWNKVdZy51n1KQ66USbd17
         fDUv33H2QFkNH6TR7fVsa/sjFw5/TyjRU5WFbcqclIQJWikA7+Mobfkaba3nQSxz9lxW
         LYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783635352; x=1784240152;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/DCoOGjB3t2yqI8PL2v0s5UjSbFRMsQqTYSs+Ahyr1M=;
        b=aWd/DWhz0w8naDDNSFIQhYzu2TSCcCW5dTotVJwFrI+JjdiXE0ym1Gpd5AMrl2JGd5
         M8HPANDJnT7iwLcu/kZfWkTKrYtiQBztdxA3HVcXlkrW6QSct3Igqv3M2qUTqrTAZwo5
         EDt9LUHtEc5FjHpQ1OKbpeP2RYjj/o2e31QHQWbPVqbzHz/8AgAAyYEz/VlcREO0b049
         eYEgjKXDVcYFr0eAKpJs3hA5uImMJpl6cqJMIoMoP7lK6uLUqbDVK5Fl01KN3XtlaUGU
         kzpQT+CLw9BG+geuazKvcfOpkbu+JY36a2dLukFQPXvo7RTKWyVdKB8fBAHx/Q/PNHrz
         newA==
X-Forwarded-Encrypted: i=1; AHgh+RouZyTIr5xW8WNc2YXxqJAqtLs4LWTarqnJqj+frtpo16AepoPpPeGfElGreEGz1fjGqs3VDSfltii1@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk1tcTOFaQcL9w4AS+nFuBwI7BPBXnhZh/shEuMBbDjoHXBrpK
	MUoJ+Ifn5NhnroLY9W2TBtwyn7lLKl3GSnWv2eryxV7QRUZKNVloTexP6h9WIggdqr7CAO288Wa
	n/3w/KZWu5N1NGrkyp8M7sK6EHP0SMQM=
X-Gm-Gg: AfdE7cnJLFRCs4qnF61IhE/cSDBu0fD3HXw0T/AQRHEXpFefYTr4XtvurqrQyh99pKq
	jDswVd/8EE5/apA3t38t6bKsi3Wjq++Oyc1ImJE8JvJxBO2a0QY723v2Ny6cmSE7HcvnWTsg0wL
	3ySGcqIibm7RJgYvx+G1sfZNiYc5DHxOLD613gMBSqhQ3qRIFMj0jRHmo82TVnMUzaRAc6GnUE0
	2A0dA5jpMhl4n0aIFVkx6C6ud8KSv6wUe2o1t36iclpFikNEILR8rP9FDlyI99T8PXU4YLCmlw0
	ijNbzNyGXfHehacWHfkz6ex73XqWcMkWhhNleCZQ5ztHDuEJnUEdmrPdnKaSbfMI/HjkF03WQ3p
	vJwjgUPktsPVrPGC3uCdMNkFgJg8yg5KjYag7XufjdB5Etu27KlJEvd1wnx5jT/SyBOfqB9/jL6
	Fkywnfd/8RWQ==
X-Received: by 2002:a05:6214:410:b0:8ee:d9e7:be2d with SMTP id
 6a1803df08f44-8fec04e89f8mr112612426d6.7.1783635351816; Thu, 09 Jul 2026
 15:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709155440.2132459-1-doebel@amazon.de>
In-Reply-To: <20260709155440.2132459-1-doebel@amazon.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 17:15:40 -0500
X-Gm-Features: AUfX_myw31UoHX4SuoiHG9s00c7k_AK6flUf0AJ6VGinZ_8FPM7X0vQl2j6Y5eU
Message-ID: <CAH2r5mt_Pd=wd-pXdaYkNpWE9NfeM0bhnEy-LKuhgOZchVPTJA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix DACL-rewrite heap overflow in id_mode_to_cifs_acl()
To: Bjoern Doebel <doebel@amazon.de>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, nmanthey@amazon.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

When I tried this it changed the length used (for chown with cifsacl
mount option) from 88 bytes to 236 bytes
which seems suspicious.  Have you been able to reproduce the bug this
patch is supposed to fix?

On Thu, Jul 9, 2026 at 10:55=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> wr=
ote:
>
> Budget the destination buffer for the worst case in both branches:
> every rewritten ACE may take sizeof(struct smb_ace) bytes (which
> already accounts for an smb_sid with SID_MAX_SUB_AUTHORITIES
> sub-authorities), plus the smb_acl header that
> replace_sids_and_copy_aces() emits.
>
> Fixes: bc3e9dd9d104 ("cifs: Change SIDs in ACEs while transferring file o=
wnership.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Bjoern Doebel <doebel@amazon.de>
> Assisted-by: Kiro:claude-opus-4.6
> ---
>  fs/smb/client/cifsacl.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/smb/client/cifsacl.c b/fs/smb/client/cifsacl.c
> index 07cf0e5782337..6d572dd995d79 100644
> --- a/fs/smb/client/cifsacl.c
> +++ b/fs/smb/client/cifsacl.c
> @@ -1812,11 +1812,13 @@ id_mode_to_cifs_acl(struct inode *inode, const ch=
ar *path, __u64 *pnmode,
>                                 cifs_put_tlink(tlink);
>                                 return rc;
>                         }
> -                       if (mode_from_sid)
> -                               nsecdesclen +=3D
> -                                       le16_to_cpu(dacl_ptr->num_aces) *=
 sizeof(struct smb_ace);
> -                       else /* cifsacl */
> -                               nsecdesclen +=3D le16_to_cpu(dacl_ptr->si=
ze);
> +                       /*
> +                        * Worst case: every ACE is rewritten with a new =
SID of
> +                        * SID_MAX_SUB_AUTHORITIES sub-auths -> sizeof(sm=
b_ace) each,
> +                        * plus the smb_acl header replace_sids_and_copy_=
aces() emits.
> +                        */
> +                       nsecdesclen +=3D sizeof(struct smb_acl) +
> +                               le16_to_cpu(dacl_ptr->num_aces) * sizeof(=
struct smb_ace);
>                 }
>         }
>
> --
> 2.50.1
>
>


--=20
Thanks,

Steve

Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC69537F8CC
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 13:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789565292; cv=pass; b=lCBDi4YYYgQS/66DVmpJwoQ9nmW7b7zGc9zqjxKN9Z90qFoo1mjaJ4UhY3XY4s8g/tV1Tao2/GZCVwmKhQQ4ZXYfakEWsm4ynwY/DQ3l5vVeRsEfmw1HzLvW4z1EegYzKtK3m5nDRcKQS8pwM1tKft9VI3fHSs8f/AWrGrTzxRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789565292; c=relaxed/simple;
	bh=CfnmDgVpJyQs2PWAwDXuI7TBtKA9heR5d3Ukp6m6wbk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jb8xBkOH2Llr1W52mlB7rjuVRWCrEfVKsfzkhM0lpLWDg6ascxUKxrHGxPh8gNvgrzlRElcCkJzIV0Op9BeHN8XE/jTc5KlsIFuoN8t+1lnclDv6Ivqvm1Z17kbFk6rDiRHzDdDKl9d6MBRVtcsTnoEbN2NC5H+RZ6TjPf8+an0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l9OKx1fr; arc=pass smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l9OKx1fr"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a803458ba0so1449674a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 06:28:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789565288; cv=none;
        d=google.com; s=arc-20260327;
        b=N1jhGRb+Uh9aDh6C/YGZq63qqk5VEEm/dmOVoyZErySdUDFvIKB1gpKPY5Ylor5euT
         SJIULlv8YsisGI7XdnvlWOYSRSg6Py+w/2eWaDOi2YVMM8AiW32iy2eXQSZ4nfwdn5lJ
         fmcsPkNS2Olmfctg3Ilr3/Kisl0VgddA45vhUEOQwmz4oaaj2dIpRSyXUwWtWh3z20vX
         B0MH556SBEa8RJZAj7rEwht/ggrv1tdQdGkhVAtF/tldcgqTiPXvIAHK5jhWlqcQiXfk
         VTuIndFTuYpyEtOdv7ae8j8JSHpabSHHRvg5kU6z5nBJniYlf2/7OHlIHnoOvXqIfbYz
         GYdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qLwcU6w2JSQgA7d1LkdrDYajLLyI3PqjRvYBxCZ9/4M=;
        fh=x5Ejn96xyHTb3EzRsGds/AcSy0Z7+S5SbpOkA0BhH5M=;
        b=FTNVIjLOU9MhLmoD2dn9F3dBphaIhq+RjUOM+bS7/FVJQFKnwWFXVYko4q2+2dvxUM
         RC5LowXSA/DNNUhDbAgyYPlCYgxtby2Nu4ax0Y8xQF1pPNslZOHp6Yt0bPSX3UVvFGWi
         WrHH71epUVA5OPEmVY8okoiT+qk9awVCS1tFoeb5VPqtKrQJx1Yjo9+h6Ur4bh/UH21o
         hfAElKYBDE0DpemY/vXwW3SSyAvDm+KCWN4dbFXXwruCapt3Vtm2nb+bAxHyyeX7Odiv
         raBvN/qrXUslGBbPqRxlB/ZgJ12+t1lJRH9kNePSsY9NLh3qUI9Dzz5m2LtyGqyrGXNY
         N46w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789565288; x=1790170088; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qLwcU6w2JSQgA7d1LkdrDYajLLyI3PqjRvYBxCZ9/4M=;
        b=l9OKx1frZkktMrqpaX3jM3++GTVlkLzJlcO96iZaewTKks1Jb5uRhG0dZsWf3J6jnp
         RsJm7rL24X+utcbPa+sUMEsJgZrqChhQkwFJtHVl4dEL+gsmQKs592YLhFjWC29DOMfC
         zJxn7ilEufTHgyjP+MoOiRKlILN8z3NEkuPiGlCKmLLj2K/Ljn0WnTY4DG9PGxlxydFe
         xMHKIaswiBbCS1/EDyB7yRWloObOZo56SOoSfxrdmPe+3vzYE1p31XxzMvX5ffWWCyPb
         4BKkDF4OU9X2Rn0bpPxAGmwvlsYoF/zkccEo03FVCfWAvJkhLvdwNaTmYOWgMhOTL27z
         F7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789565288; x=1790170088;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qLwcU6w2JSQgA7d1LkdrDYajLLyI3PqjRvYBxCZ9/4M=;
        b=cvNYkw/QNqrSZZY7o/bT/1XhXMfgdCBriUtmuA7tsX00LuBwkkGRC37GmJfnRmmYtm
         Pe/DPPbVS7vlt/WFaYitjAbh0msHQPuLwGd6WNoqS5Ha5KH5eFPl5X5PEiw4SDHlOXtk
         SCNjDVkqDcFWO87bm55/qOUt5RY+mAbpjA/0pPIOvnQsqULMXaU9uNd3JdRQyTLhlLFt
         TtB0i6t0lk9lWWz+5MSQupuS8uPCzMr3ezGemsdgjhv32/G9bTiHmPkwR6hQulb13lyG
         f0+8DoEM1B/3CvdYn4RjF+aLG2ndUh9IG/iQnVjsvmVCzQgmI/OWzwyUekSIWBzUcxdI
         M1gA==
X-Forwarded-Encrypted: i=1; AKwUvBxvre0Lh5x5KlXMwTAaU2OEZmFrPN/uJ5m6GpwFAGfnlBOGX2qky7ejlBXj3ZUGZMqyZZ6DYiavO8QY@vger.kernel.org
X-Gm-Message-State: AFuF++mWS6cKgBajkCrny7tPma8e6rG+xnDikFBBLRP+quiD3iwDEOLm
	hl170RC7wE9Wew7O5hNlVeqEDr6J0oBbYO/TR9sDwhJu6litjWPn0dIn+khcNt937C8RUlan3tc
	dYrhv37S9Zs0EPWr7BPXwTBoE2Lg+66YP5g==
X-Gm-Gg: AYBFou3RqXr0rmpuc2j7NRh5ZGQSOsw2lxNndCzLBL8fQVduoH8s52Elu/yj+2UpDRJ
	rEG06T2iQ1ZJVixKeJMkuwz4cwcEf4F6Rml6U2pAX1ga1uuUDpVZfAVjbF9Haw62FiQIUWg8x/B
	QKsSKZQG6RRbym/cyJRxNNvUBkm5TofexA//DwgceJKLOP+Rk2h0B/VpaaNbwdN3NkFGV6pJfe8
	L8X3abkXyDqQDmlVA+Q9FpDVLm293Lu8vutPnzO6jhswy2mm0FNeNI2uiRrdJtWXM4IF0ZhsCkU
	kg6sj4gXpPCCtsAVrotnXySZHuaXF6w1FxNSoKQZ95ICqTZRUantOQ==
X-Received: by 2002:a05:6402:50c8:b0:6a9:9833:2ecf with SMTP id
 4fb4d7f45d1cf-6aa2224bbdbmr1976058a12.10.1789565287573; Wed, 16 Sep 2026
 06:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260901010413.368183-1-joseph.qi@linux.alibaba.com>
In-Reply-To: <20260901010413.368183-1-joseph.qi@linux.alibaba.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Wed, 16 Sep 2026 18:57:55 +0530
X-Gm-Features: AcwNN1WoH4xQoF4ojLj7xEUsXn_CDqPEy83phZsZ40aL_9WjjWXaL9BeVt3CVmE
Message-ID: <CANT5p=rfeGnXH-3DUehbE74uw-Q3Q4qzy++dpTks5gm+rdGm5Q@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix use-after-free of iface in cifs_try_adding_channels()
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 1, 2026 at 6:34=E2=80=AFAM Joseph Qi <joseph.qi@linux.alibaba.c=
om> wrote:
>
> cifs_try_adding_channels() iterates ses->iface_list with
> list_for_each_entry_safe_from(), which captures the next entry
> (niface) under iface_lock.  The loop body then drops iface_lock for
> the whole duration of cifs_ses_add_channel().
>
> A concurrent interface refresh (SMB3_request_interfaces() ->
> parse_server_interfaces()) marks all ifaces inactive and removes and
> frees any that are not re-advertised via list_del() + kref_put(),
> where release_iface() is a bare kfree().  Since niface typically has
> no channel holding a reference, the list reference is its last and it
> can be freed inside the unlocked window.  On continue, the iterator
> advance step then dereferences niface->iface_head.next, and the loop
> body reads iface->rdma_capable/is_active, both on freed memory.
>
> Fix this by never keeping an unreferenced list pointer across the
> unlocked window.  Each channel attempt now re-scans the list from the
> head under iface_lock, takes a kref on the selected candidate, and
> passes only that referenced candidate to cifs_ses_add_channel().
> weight_fulfilled still tracks selection progress, so restarting the
> scan preserves the original weighted distribution and the
> weight_fulfilled-before-kref_put ordering on the failure path.
>
> Add a per-pass attempts cap so a flapping interface refresh cannot
> keep the inner loop spinning within a single tries increment.
>
> Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked=
 list")
> Cc: stable@vger.kernel.org
> Assisted-by: Qoder:Qwen3.8-Max
> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
> ---
>  fs/smb/client/sess.c | 106 ++++++++++++++++++++++++++-----------------
>  1 file changed, 64 insertions(+), 42 deletions(-)
>

Good catch.
However, this changes the order of iface allocation. Earlier, even
when iface speeds were skewed, this function would attempt to allocate
one channel per iface. That logic is now modified to make weighted
allocations of the fastest interface first. Only then it would select
the next iface as a candidate. I don't think it's a big deal though.

Pending testing.
Acked-by: Shyam Prasad N <sprasad@microsoft.com>

> diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> index 7cf7dd104f7c..e095f41b5882 100644
> --- a/fs/smb/client/sess.c
> +++ b/fs/smb/client/sess.c
> @@ -149,9 +149,9 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>         int old_chan_count, new_chan_count;
>         int left;
>         int rc =3D 0;
> -       int tries =3D 0;
> +       int tries =3D 0, attempts;
>         size_t iface_weight =3D 0, iface_min_speed =3D 0;
> -       struct cifs_server_iface *iface =3D NULL, *niface =3D NULL;
> +       struct cifs_server_iface *iface =3D NULL, *candidate =3D NULL;
>         struct cifs_server_iface *last_iface =3D NULL;
>
>         spin_lock(&ses->chan_lock);
> @@ -197,67 +197,89 @@ int cifs_try_adding_channels(struct cifs_ses *ses)
>                         break;
>                 }
>
> -               if (!iface)
> -                       iface =3D list_first_entry(&ses->iface_list, stru=
ct cifs_server_iface,
> -                                                iface_head);
>                 last_iface =3D list_last_entry(&ses->iface_list, struct c=
ifs_server_iface,
>                                              iface_head);
>                 iface_min_speed =3D last_iface->speed;
> +               spin_unlock(&ses->iface_lock);
>
> -               list_for_each_entry_safe_from(iface, niface, &ses->iface_=
list,
> -                                   iface_head) {
> -                       /* do not mix rdma and non-rdma interfaces */
> -                       if (iface->rdma_capable !=3D ses->server->rdma)
> -                               continue;
> -
> -                       /* skip ifaces that are unusable */
> -                       if (!iface->is_active ||
> -                           (is_ses_using_iface(ses, iface) &&
> -                            !iface->rss_capable))
> -                               continue;
> +               attempts =3D 0;
> +               while (left > 0) {
> +                       spin_lock(&ses->iface_lock);
>
> -                       /* check if we already allocated enough channels =
*/
> -                       iface_weight =3D iface->speed / iface_min_speed;
> +                       /*
> +                        * iface_lock must be dropped while opening a cha=
nnel,
> +                        * and a concurrent interface refresh may remove =
and
> +                        * free entries during that window, so no list en=
try
> +                        * may be kept across it without a reference.  Sc=
an
> +                        * the list from the beginning each time and only=
 pass
> +                        * a referenced candidate to cifs_ses_add_channel=
();
> +                        * weight_fulfilled tracks the progress so that n=
o
> +                        * iface is selected beyond its weight.
> +                        */
> +                       candidate =3D NULL;
> +                       list_for_each_entry(iface, &ses->iface_list, ifac=
e_head) {
> +                               /* do not mix rdma and non-rdma interface=
s */
> +                               if (iface->rdma_capable !=3D ses->server-=
>rdma)
> +                                       continue;
> +
> +                               /* skip ifaces that are unusable */
> +                               if (!iface->is_active ||
> +                                   (is_ses_using_iface(ses, iface) &&
> +                                    !iface->rss_capable))
> +                                       continue;
> +
> +                               /* check if we already allocated enough c=
hannels */
> +                               iface_weight =3D iface->speed / iface_min=
_speed;
> +
> +                               if (iface->weight_fulfilled >=3D iface_we=
ight)
> +                                       continue;
> +
> +                               /* take ref before unlock */
> +                               kref_get(&iface->refcount);
> +                               candidate =3D iface;
> +                               break;
> +                       }
>
> -                       if (iface->weight_fulfilled >=3D iface_weight)
> -                               continue;
> +                       if (!candidate) {
> +                               /* no usable iface. reset weight_fulfille=
d and start over */
> +                               list_for_each_entry(iface, &ses->iface_li=
st, iface_head)
> +                                       iface->weight_fulfilled =3D 0;
> +                               spin_unlock(&ses->iface_lock);
> +                               break;
> +                       }
>
> -                       /* take ref before unlock */
> -                       kref_get(&iface->refcount);
> +                       attempts++;
> +                       if (attempts > 3 * ses->chan_max) {
> +                               kref_put(&candidate->refcount, release_if=
ace);
> +                               spin_unlock(&ses->iface_lock);
> +                               break;
> +                       }
>
>                         spin_unlock(&ses->iface_lock);
> -                       rc =3D cifs_ses_add_channel(ses, iface);
> +                       rc =3D cifs_ses_add_channel(ses, candidate);
>                         spin_lock(&ses->iface_lock);
>
>                         if (rc) {
>                                 cifs_dbg(VFS, "failed to open extra chann=
el on iface:%pIS rc=3D%d\n",
> -                                        &iface->sockaddr,
> +                                        &candidate->sockaddr,
>                                          rc);
>                                 /* failure to add chan should increase we=
ight */
> -                               iface->weight_fulfilled++;
> -                               kref_put(&iface->refcount, release_iface)=
;
> +                               candidate->weight_fulfilled++;
> +                               kref_put(&candidate->refcount, release_if=
ace);
> +                               spin_unlock(&ses->iface_lock);
>                                 continue;
>                         }
>
> -                       iface->num_channels++;
> -                       iface->weight_fulfilled++;
> +                       candidate->num_channels++;
> +                       candidate->weight_fulfilled++;
>                         cifs_info("successfully opened new channel on ifa=
ce:%pIS\n",
> -                                &iface->sockaddr);
> -                       break;
> -               }
> -
> -               /* reached end of list. reset weight_fulfilled and start =
over */
> -               if (list_entry_is_head(iface, &ses->iface_list, iface_hea=
d)) {
> -                       list_for_each_entry(iface, &ses->iface_list, ifac=
e_head)
> -                               iface->weight_fulfilled =3D 0;
> +                                &candidate->sockaddr);
>                         spin_unlock(&ses->iface_lock);
> -                       iface =3D NULL;
> -                       continue;
> -               }
> -               spin_unlock(&ses->iface_lock);
>
> -               left--;
> -               new_chan_count++;
> +                       left--;
> +                       new_chan_count++;
> +                       break;
> +               }
>         }
>
>         return new_chan_count - old_chan_count;
> --
> 2.39.3
>
>


--=20
Regards,
Shyam

Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43DF0382384
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 13:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776087661; cv=pass; b=BEms7bphAQp+OKVk9wfPcbrfWnAfaxmLXeZQXtNBcLW1APRn0EmMa4d0v8AwC9KZnjlT5UmFR9lcBWdmM/0FNwIbs8HJ5wSBBCHYkqjkN8WDUoxen5ZzsfaIetjEry+zPclnLwvO8m4Butjo/sk6jqHb04ECyZmOLj08U7QoEuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776087661; c=relaxed/simple;
	bh=7xQnsceMRUCZppktPNDUeoqbQ4s3PKjZQ1R4KG9Qh4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=can2Jrs1q9nFzzlxaSXCHbh8To1VOXM1r00wUIKy5IEY4wi/t5ASiO1gpizhJDt3rcjk0Tn9HTYqDoH93CdqTaFTfDSPo45YM34gOBTKNqQ53IcZJ6Qb0ivKASl3gN2oM2dHEBdTXxP7+s1P0C39PhYvIjru2aLoQVn9Pxo6ntc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=noVVlp0x; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="noVVlp0x"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso14528246d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 06:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776087659; cv=none;
        d=google.com; s=arc-20240605;
        b=JiiWK5W0kj5ZB5Fh+Xg8lLGIO+BKA4cXamUCSapXM0eV9P7punQqG8Vni6FBqfgi0F
         CSPjBH7FsXSzhT/2Z0Hwkm/ZtTRC5gnHPAV2opMJIS1hxpmDPIHcniKPE8l3puYFPSiM
         ow7WcrW+QYMbT9QpBmPFOeXiH0aAt74wMdTxnzcKuMKDsEFtVT7YiC7pyALAxvRJ2/Qm
         5hB9p8jOgRdmUxQaFpd6yz8GeBn//811g+k0mEzz/KzZgW6GcGoOMJxz7ahFfvyfKtge
         DLLqxHu1eO9SEwuGlzKimve2M+ErUfj32ZXwSQDnrLzii3DnZk1zqAYyIs7wpzY2jVEW
         cf+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n10+tYwZN29OCtbdeASyvHsCt+q8uFdBKENu8TNEbfw=;
        fh=9ZSRonDS38iNnQL3EBcryAaMRay7EiIwNefOtBS3AWs=;
        b=hFL4gMT7trb1H36+nRDWdnGnIc67J9+uMQWs9tRC8shj7pD153Sq8Im7ySnq0Fo3Jq
         LIflbtOVNeBObBSC3fzbZBXA+ZOEOtE/P4ibAlbQ1F3Z4hjp0DTJehFXj5XM21Y1kTIH
         d20CnjGnbBtpOajZ1Y3AfNzbkLwmX+y9nh4MaZKWwH21KYuyJ3kHBUKtHIpJ6uyK5xZM
         Gk3pIheSjiR0KrkuDsBmlWF/spXYWkQqN0Xr5O5drfDy2w7l+BIAdRBJ3ARC/p9KHF8/
         m6ZFuUCCYvIoE+fW9tPc84QOEdQf3Rc4NkPUtFlDh695qyEcjW5fETqWL1vQ/07waM+l
         TMDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776087659; x=1776692459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n10+tYwZN29OCtbdeASyvHsCt+q8uFdBKENu8TNEbfw=;
        b=noVVlp0x3PmoqEjP/PAzo/qlExicvTA4YqaZzN7PPcAeihsCANjO5Q6cisAKHa1Rqp
         yDwai9V1IgEhUDWRNACsIxVeZtz0bXoC5Hx2hvwGgmk1fX/XBs3T3cDTogaweRwo+6eb
         IGIBCPHDf7sxL5betqL8Xq0IUIiJWlxGinFiynbMitPWrO7Dhgr4zj0JWRtDA0L5knwg
         RPaXEuiEo5tsyNufLQ6Xaxp2Yl6qnw7GPXX3lC2RfiwJI/vYZm4UGHAwFleW5tATfXq4
         Zt6FHzBasPBZAaHSFgJSSN0n1ToHCiko+r7L+VNIRVVY+TagVdU5ims3dUEqoUdantGS
         nM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776087659; x=1776692459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n10+tYwZN29OCtbdeASyvHsCt+q8uFdBKENu8TNEbfw=;
        b=POJab7efr6aKHw9vhI7bCIso/elRxy00Yvmac6U0nY7nI7M/kInHwvY6+f7ykiKy5X
         ZGd/BkBzj06uETEIN4YkwyoUTkgDJme3D9JRT5Zp10HdVkiluOIkOIw5n8x9SasQsvca
         UlWeyoRFdk7dQISl8IaLDBbYU7qMz/yiKrwyY2I6lZuaFVzO1tfqZ3IzeOFAHJQTGcMK
         e1KoerfgEmSBYmZXEZOEXPY06c/nT3oEk5JC/Su9518eh0W+gtV9gwx03/oApYX30NJ3
         l4Zj1j2fwJYKDHEy6WVZRe9egjZp2y6Edo1FjBdORZQs5YszjRDY4H2jMPf4kMFeEprJ
         i99g==
X-Forwarded-Encrypted: i=1; AFNElJ8FZ/n/aVyGiij7++Z+KQRfXzGOQlD86LfNnCU0Arx2a70+A7TyDuQ2fFcpKmNQ0zt7USQdvdP98Ifh@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6a9iMAAWMBClW1VAvBntVzPKj1nfo05EhfCrktybjDDcjHnvi
	Dt1032I4qbT/3rlRBXXU1tpLSc3KLUwih2/13LudcKJbUvBW/+t0Rph5Yy5s0zbxIwhKWOAjzwX
	hAvi10SEwXCXfOYdR9KUKYkqD4ulezpM=
X-Gm-Gg: AeBDiesSBcxVeuQIxV+2ijQnzj9VDrLxq5DG4KveI4/s+Bkib5FFE7NW/AgRkcjq9qm
	iKiUEzAB47yY40FhmkE3VJdeF1fkfE+LKn+l3YZUCZZSGUMAbD2tSdpiWm152Wc9//fMY46No3+
	B5AtWyOZB6t0Y9TDZ8ayiNfbHj2NRQ8PSdSmyBSkfnh0BbMEOKrTpr414p3VKvtDDNn3S9j6oBC
	0nNB5e9/PWAMJo3Y402lf86jBNuEhYv8fcfzyNu9giVjPPGrozlSOZgDnMLPCljy4L+i93kM6eS
	yZLDvsZvx52E4UaM
X-Received: by 2002:a05:6214:4c92:b0:89c:47a0:390b with SMTP id
 6a1803df08f44-8ac862e5f0fmr189344736d6.47.1776087659045; Mon, 13 Apr 2026
 06:40:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260409095926.905020-1-rajasimandalos@gmail.com> <20260409095926.905020-7-rajasimandalos@gmail.com>
In-Reply-To: <20260409095926.905020-7-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Mon, 13 Apr 2026 06:40:48 -0700
X-Gm-Features: AQROBzBgzo1EmXTfMGvs2I6iYE8e3H9nOUyBeDQNFNBftd4z5Uj8rz5EMQX2byY
Message-ID: <CAFTVevVLJg59YjUPu8HBA4+emN_eUVJe8H9UCUCswY1ui6cnVw@mail.gmail.com>
Subject: Re: [PATCH 7/9] smb: client: block cache=ro and cache=singleclient on remount
To: rajasimandalos@gmail.com
Cc: sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	metze@samba.org, bharathsm@microsoft.com, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey Rajasi,

I guess this is not handling remounts where cache=3Dsingleclient/ro is
not specified i.e. preserving previous behaviour.

To reproduce, mount with cache=3Dro and remount without providing cache=3Dr=
o.

sudo mount -t cifs //server/winshare /mnt/mainshare -o
remount,username=3Ddemouser
mount error(22): Invalid argument

On Thu, Apr 9, 2026 at 3:07=E2=80=AFAM <rajasimandalos@gmail.com> wrote:
>
> From: Rajasi Mandal <rajasimandal@microsoft.com>
>
> cache=3Dro and cache=3Dsingleclient are mount-time environment declaratio=
ns
> where the admin promises that the share is read-only or exclusively
> accessed.  The client bypasses server-based coherency (oplocks/leases)
> and caches aggressively based on this promise.
>
> These modes were intentionally excluded from smb3_update_mnt_flags()
> when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
> flags into a separate function") =E2=80=94 only cache=3Dstrict, cache=3Dn=
one and
> cache=3Dloose were made reconfigurable.  However, remount currently
> silently accepts cache=3Dro and cache=3Dsingleclient without actually
> applying them, which is confusing.
>
> Add explicit checks in smb3_verify_reconfigure_ctx() to reject
> attempts to change these options during remount with a clear error
> message.
>
> Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index ce4842e778c4..2be72733ef2e 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1180,6 +1180,14 @@ static int smb3_verify_reconfigure_ctx(struct fs_c=
ontext *fc,
>                 cifs_errorf(fc, "can not change rdma during remount\n");
>                 return -EINVAL;
>         }
> +       if (new_ctx->cache_ro !=3D old_ctx->cache_ro) {
> +               cifs_errorf(fc, "can not change cache=3Dro during remount=
\n");
> +               return -EINVAL;
> +       }
> +       if (new_ctx->cache_rw !=3D old_ctx->cache_rw) {
> +               cifs_errorf(fc, "can not change cache=3Dsingleclient duri=
ng remount\n");
> +               return -EINVAL;
> +       }
>
>         return 0;
>  }
> --
> 2.43.0
>
>

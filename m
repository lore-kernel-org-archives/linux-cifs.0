Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A213502A9
	for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 07:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781595625; cv=pass; b=XDfOa065rb1jwEDGW7HFeshCtkYRLOua4Vs5t514dxXL+IvCopKTZg6rhUyDVc8F7aZ6H5c5OUnhxR3/NoK4AB6Lf5uw+E3lQvqy2PPIWl7RtvXCytBEUdRIqSDuVmHeUh1AHEyby9HXstD/rzVmx7Zmhh2sUOaPGoZfAD2M8RI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781595625; c=relaxed/simple;
	bh=aRsvI5zn+SA9kbCQWfpx4T6TjOZwAi/ouLJJIKUoDRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GvhMTgSLc1Nmeysn+4QT3JWstyjWBxoNeLQnPgitRhNjfCfvMKj9NqTaB4i7E5DfpgWIMcbFQD3Hltq2rbymb8sFdvxYSQUu6xX4dWRDI/EGf4ACPABe6CCBI/6aBIG+t/agulKc2YJfVzzmyJdfRL01l8/Tas85JPSs4tHz7Bk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ge/hb7KN; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ge/hb7KN"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8ccf18ef922so62668486d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 16 Jun 2026 00:40:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781595622; cv=none;
        d=google.com; s=arc-20240605;
        b=dDK0DJzkl0jYdgXIDwU+qWL32VvPnNPRbrb1j6+NGEcqf5Zrs+eqIk6CLgCNwy28Ep
         lma30bn6YxtavlvudjDKEPOFF3jKDaxxZ+ZJRi1Yu+9W3V9B6gXpOUsvoBpAY+Lpp3Lt
         1zE21w2+NMWIjxlM4kO9sdWzrPtuciptAP9zEkBjCYaoKxVWNjaJl5PRa3ZgV5sJNwjD
         MFjvQQVsqBZVCCLcWfi5mrHvZEXse8RVRR0Qzh5+5HKGRRXgmC0Ux5w79dL8WBFtdXfF
         KHoJMYgfWRaXl0fYEbhS3DBjeTwqyuB0OCOuFErXuqZcRTLnGplVnOGue/vmdpfjBDUS
         z/qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uO0U8EiGPuYcRQDJvtcn+DcIkN3kAImZygeNO7u0UzU=;
        fh=J8J6NhYwtFrPdYsK6YghV4S1vjaUSzne6Yns3a0MZ9A=;
        b=fH/iLTxDnNgTF5OBkWJMl4KJncYeXHqo/LrqKfu5aRLEjETdNZcZzCuPhP2XxdpXg1
         NY4+zisVpxEr2gJSQRIx7Kl1v7+wsk9ylg85YQf0annLeaKsMbyxniIuZzEY2V/XMOHS
         L6zAhc+OK08BM2+0Ab4AAkvzS3/DMJqCZG31RsYiAjzVAPOnd34hPXpJYcp/ja6hSK4M
         Szfqe+eQnuZth0YiLEZTmUYvgBNrCJa1sMgE/QSDWcMzvNX+LxNX7H6rYDTVSrmxU8dS
         AtZEDpmTaPtn0CHwvTkWgZWO9z/D1BwLWqV5TYbDxOb3O0hAHPrI7Nip5wakt6y+pHO7
         ut8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781595622; x=1782200422; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uO0U8EiGPuYcRQDJvtcn+DcIkN3kAImZygeNO7u0UzU=;
        b=ge/hb7KNUV4AUROCDYSPh80YSxEENofNRuwSrAuD7VsyJcC/lx9mzjOpxChINrhp2i
         bER1QUBmnsEX+dvqg0eFx2DQvo1tp1Y1XhsKEFe0iKdoVnBjgWrtNZlwGd8cy0JdBGre
         VJ0Eu2p+W0JvkWdRDywAhFq+9JulkIplyvWVdgrg3ps9rcpqnjDJQO2RWhVhprZIGMTp
         2GuahyaCsk4I7gJR3Q8LffDUuqRIMzCQBnmAr8WGmHZfC0ALkp4KTM4lwzwJSGDeg7wk
         OEbHrPyX0/IoHGykPjmPh1kDJ1OX45I3iqrdYifpvEPDuvufaw7w86YgO6he3OxFPCkh
         PHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781595622; x=1782200422;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uO0U8EiGPuYcRQDJvtcn+DcIkN3kAImZygeNO7u0UzU=;
        b=R+VWm2VZHvOsR3wVbyWI76bOpuDROBv+soO4D1rDjgv7GWsQfj/cPzoJWnVdCQEsYU
         p2EXU5eH1CsraMJjQBXa2M3+7fflJ9x9FG8quNB1i9aWSHy1O+C8k9h066DORwJcGKmT
         nIQDbonlJlYR3MrjjVt439t0kJVIb8tUw2HtUikTorlNRZb6mNYTK+mRSg17g2Rh/N9/
         mROGL4DlFvsLFFvin5/9taYVieAe+hfn+AK71IgDyZ4+cUcbbAOCEJPKf3DpnH+ko+ul
         o9norbjCPIHZc07pXVGz94H4NOPfQxcU9Y3l/SQkA1AhLd5HSHoe2YwPB5oNWmfkOEvv
         ekDg==
X-Forwarded-Encrypted: i=1; AFNElJ/sukE3LC3wSdYYYeZnbG84DQEUYDZhGBQXcQfmlP8ulVF/6S5Rs+2BlUN3+A5LSCR5aOWM0EuW6WD9@vger.kernel.org
X-Gm-Message-State: AOJu0Yw81OUbkwycNo8fPubv1XL6HV812WKQ4BdpDw0IFy989Pok+g+B
	kY0UymB5Y+ZqMU+o0kox/e6zbPxGhFKdNSdyF+OESljggxE6sl2JiXkypP61c9E1sTKfCe2a7oh
	ZNCmSfD9R3M9zOyzw//dLrTQLOUE3dq8=
X-Gm-Gg: Acq92OHu4T9H2wcv5jZ+igS+DDerFR9a5WCIRTchvWor//x3QQLjH05C0skWqTsxFFZ
	w20HOeQS2wULm6ib1x9mulYEs9zy9rNtDw/FIIWlT1FZonNfZiYRfdH780x8eoQrx64iQ3/XUU4
	YOe7RdhHbln7DT0SGRoEi3Pzuu3UjAcNZxrDhypXUPJQ9vuGeUeLzMRgPGeHUtRnq1iiVfulsCi
	7jGLPFfxp7I9/fyeEIMnIWkCQ1yAPy9Grwr4F4rQZUBH3MhsbkobHEZgBZOJcwM2m4VBg2OJvHK
	kzgdeQ==
X-Received: by 2002:a05:6214:d8c:b0:8cc:f135:52ac with SMTP id
 6a1803df08f44-8d44e97a8acmr238469336d6.27.1781595622479; Tue, 16 Jun 2026
 00:40:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260616055357.3798387-1-rajasimandalos@gmail.com> <20260616055357.3798387-5-rajasimandalos@gmail.com>
In-Reply-To: <20260616055357.3798387-5-rajasimandalos@gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Tue, 16 Jun 2026 00:40:11 -0700
X-Gm-Features: AVVi8CeATsF3_cVOpj7q46QM-aOSfbc2Ga-SDC2118BWp54gKzrMmEyyAM26cq0
Message-ID: <CAFTVevXM2K-1f+NemLVxPLwPLVisQZjvD3kpNBvCeemRdG6O_Q@mail.gmail.com>
Subject: Re: [PATCH v4 4/7] smb: client: block cache=ro and cache=singleclient
 on remount
To: rajasimandalos@gmail.com
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Rajasi Mandal <rajasimandal@microsoft.com>, 
	Meetakshi Setiya <msetiya@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>

On Mon, Jun 15, 2026 at 10:54=E2=80=AFPM <rajasimandalos@gmail.com> wrote:
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
> Reviewed-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/fs_context.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index bfbea0648f6a..659fb0adb528 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -1211,6 +1211,15 @@ static int smb3_verify_reconfigure_ctx(struct fs_c=
ontext *fc,
>                 cifs_errorf(fc, "can not change rdma during remount\n");
>                 return -EINVAL;
>         }
> +       /* init default: cache_ro =3D false, cache_rw =3D false (i.e. cac=
he=3Dstrict) */
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

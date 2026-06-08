Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3D34A21
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 00:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780876916; cv=pass; b=ICn3MSRjbkxYSDyjthbwixGypVoRCBGmF+UUP9hWF/mineFPcYOLRx/W2GBviXIrbrOiSwRAGjqQNhxOlJnKd+Bwy94FJhBD7BDAOV9J9HmL7gu4CNMWzDzUwxGG02KUD0xR7vlUxYTC27KEZMlLBJTfoQk9XBqoP9o8fW9yvZU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780876916; c=relaxed/simple;
	bh=4ccGriU0jBI4zlqTVcylF7L2OsPxg4vXas2lAH/cBQE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rPqM3deo3GXktosKjNnxi42QZRIhqxhl9GnVf7FnOapceF4d59TlEUhCGcW+LreiWzVB3nDGGEb9PESrxOYTb2uNc+UKjVjgVOUg9Q2e9A7gvF/wGfe9ZZD4kMTiCPTPCbe7iPBKBkGYBSP9RheaO9U2gQPrqFS2dpyX4wlofkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oXYgNc7U; arc=pass smtp.client-ip=209.85.161.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oXYgNc7U"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-69d60694c9bso2019925eaf.2
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 17:01:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780876914; cv=none;
        d=google.com; s=arc-20240605;
        b=O8i68eyoFBRRGeq7Rmjxgp+fGrkSrQaiLMvbQI1wPwgG9BOHObmp/FWnEhubRtHqdA
         lmsigK8v5pKWWxwQLP1YN6CFf5WIgWm2RELUhvzF8oa+h0HnpAyJqx60Bg5//iOk9YqL
         73TnNaC5ossuIIMVvi+VxZrUcO58dVBRwPguR5B8UpWnYO+SIwDvIpHhb0ubKdqaroAm
         tnexoOYuxYL8X36Erh+VwUyC6XEqMBqA/Pq51etSW/6mRgLZvJmcj8GBSgl8vgpVqlVJ
         uiJzKmYYiXeOH5R1PKLRgGQWiPk5E7WpF6cBzCoAEVDvaXLCtbkQNiefWttz3T+xFvwP
         9vhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7amvk2edp4yEOlkkFyXuSSAnr2HVmcL1P6a6jiI/2h4=;
        fh=ihI3bd4HokKqa0gWG3+s68rYf2/7+vRCQLPqcJIigic=;
        b=R+LXiVVMRWTKDl6Qvue75JP+IGMSsudx5B18TtT/fyxqbz/zTtssRmRm7dwbg0G0bR
         Sl7DuTl4qhs+N7glqYTCoy0+N2gvc/6tcu9OyAihJWRvoCdo3rZnrUl1hFEIN5X1XDww
         X+FwOmfhd+vtR4bpJ+8tEq+OjhnG27NEolvjA1PRZeuqaqffyIqomMNolM2KHMqZWJEV
         1HKA7qjBbN/KD7EbcLkY1Sxky4WJtGFlaLsxsOBdpXj3BDgdHwfMCC87ypoZg6t9A3BZ
         QW1RSwnULGRmcjBtVCPZPOSH1v+WN734HCqYKmSPH4S3l2jy9wrGECSpArQovtMowyp6
         iJqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780876914; x=1781481714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7amvk2edp4yEOlkkFyXuSSAnr2HVmcL1P6a6jiI/2h4=;
        b=oXYgNc7UEPt5e2FbNQzYcjc1xolnet2uPK/6TafRhDR2zyoQwyEmHW3UEiVqGn611k
         SG/xrS5iGJTNXysjYeaem1VOQfKCPmA35ZEgN5E7cr0MA8p4IUn28l1NaZSENa7EqaRq
         QV/Kpb27JDhXm6/osjwGBQbYueYubcMOQEQKHVX+/pba+8mmKoLeXJbPgKTq0zs8oVYA
         5UYyt3scwxUMQIl9mtOXu8wB3Ka1MU1MBzLtC3EvVXCjjG4cP2wyjMJUzCVqXekSJa0q
         UPWFmtJZw6Bg5D/9Xw5rYYgf5gtRpvFCfFOrJ+zrXVcY6ZDAspMNDyTGICE6NwL8ap2S
         l8rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780876914; x=1781481714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7amvk2edp4yEOlkkFyXuSSAnr2HVmcL1P6a6jiI/2h4=;
        b=H2o/CLjn0jYYin9ZzxqXotYGM2mbGUtrDG58zr7q+FCfeFzOwPH9JWsH/perqrxWAW
         mGX7niBIdbwu+SY85FM0KOqMqokDCh7Vi5as/wRYecRX8Riu0VWSF+HpKKIUk7CxUyjZ
         Quw0ZwBHQXrvL2esv9XlBMR8z4decCyGTbTHBqo5OI0ntQ5jFY3ZMWjyGzZQ8sBg53bk
         aOOy0F4d8MmWGAP88lM+ejwDa4yifH68pYiOKfmWXHq8S5Ftr6Lfqi/IPn5f+wqI0PZi
         4P301NQ+aF7YZg1SsOHgnTqPg+FAu63KZ0wHd6q/hx/4LdDW3N3nxLLAWOE21A3Ddrv2
         wdTg==
X-Forwarded-Encrypted: i=1; AFNElJ8VhGC4OWKvny33QCLY05Fajxm68CiluNNGNcrk8j7CYkoBdVJqrfDZrmhddn6ioYKTzcIM+1CzmSoZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyrC4Mhw36Ve+MxWlt6Nk++IPA9qe+R73y6Vc02Ypl04POlc5tY
	Lr/GL+OEG7dZ8+lWHuxMZp7HrsR8/gkWQ7O/XdY9NPwQ3SfW6kXG835DGEwfGys40rKw1+OL5jG
	Qt3PE68zHoOBNvFjXhBEKcNu45DWgZJY=
X-Gm-Gg: Acq92OF7iWSaN27tLWdhL2QNi0hzX7tM1Vh2b300VoCkEJbvipxsuOG4z3SZyYTRNie
	K9oJ0G8byzJA/gWJTQ9MkR1/sl3ZuuLWaah8YBFc7IqglAYKdUhjjkHWdEBWFRH8SItLyngf8eC
	kE4mmn7GQzuzfEfM+V+/WGXpv5RoK70PYGEpr3ZdYNx2a+eluYnJlr1Rc9qIrZ3RzM6gcaZzXih
	1r+QcMHFRspwH/4xwDVEIT1qA9ztqgVboja7fC3lAYfjyRb9NEsLf6eokXjD+Ktv0sHkLZUgg6R
	qVzyaOshmRP4ls7VqCxIg1NuXzDNXuN2+gXZpTYMTID/vxF1f1KDN/2HyoVof6otvBBznNXfIXq
	T1+5vvdzk3tYIe/oI2ey+BCX+nM8ByCwXTh5sVH2JOOSpzOzDMZ7ZZC3jPhlfc0zIF0ZKSK0dL0
	m2cXSwEB+DyJMoXlWLDFDAB6LMKPylJKg=
X-Received: by 2002:a05:6820:f02d:b0:69e:9d93:485c with SMTP id
 006d021491bc7-69e9d9349bfmr63785eaf.34.1780876913799; Sun, 07 Jun 2026
 17:01:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org> <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com>
 <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org> <CAH2r5mumYk1bcnwwgm8ogP9gaKSZzZX_TFdv+cm9CyxCiT11zw@mail.gmail.com>
In-Reply-To: <CAH2r5mumYk1bcnwwgm8ogP9gaKSZzZX_TFdv+cm9CyxCiT11zw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 19:01:42 -0500
X-Gm-Features: AVVi8CcGN0acCAkUBo4AT_LnLSo6E_ce7PPxplCHxVluE0MJXUM9qddJGDUmxXQ
Message-ID: <CAH2r5mtH3H8t1xOOwL+8=2CT6XPdndDkwb-438GQoibCgeF-tQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: Ralph Boehme <slow@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Jeremy Allison <jrasamba@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes - chmod seems to work mostly ok with posix (not using modefromsid,
the modefromsid bug I was talking about was not mounting with posix)
but there are a few examples of problems with posix and chmod.   e.g.
mounted to Samba with posix
     chmod 0764 /mnt/scratch/file
works fine and local and remote mode bits match but setting the sticky
bit remotely is ignored
     chmod +t /mnt/scratch/file
the mode stays at 0764.  On the other hand doing it locally on the
server rather than over the smb311 mount
      chmod +t /local/file
works and the server reports the sticky bit as expected over the
smb311 posix mount

On Sun, Jun 7, 2026 at 6:47=E2=80=AFPM Steve French <smfrench@gmail.com> wr=
ote:
>
> The modefromsid example was not mounting with posix
>
> On Sun, Jun 7, 2026 at 12:37=E2=80=AFPM Ralph Boehme <slow@samba.org> wro=
te:
> >
> > On 6/7/26 6:52 PM, Steve French wrote:
> > > the chmod bug (when mounting to samba with modefromsid) causes a few
> > > xfstests to fail (I noticed this when testing the swapon fixes from
> > > Huiwen.
> > see my other mail I just sent: this is expected, modefromsid is not
> > relevant in SMB3 POSIX context. If you mount with SMB3 POSIX, chmod()
> > will just work.
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

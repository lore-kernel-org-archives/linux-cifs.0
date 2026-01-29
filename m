Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C727E06C
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 11:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769686697; cv=pass; b=hH9KvS6bY8HvVf1poqjYQOUADbqcGbT5qUJXYKBGIgKVIielmdLKUUqDNmMdNOgtIc9iG95giyXhwONd8HZlx9vhf/FVebpVQzHzRcrthAQpybvS6aR3CZItbB/08VJYTzgetowun2QzUi2UvcWiVH4oHDHIiQXqluEDxdiVg3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769686697; c=relaxed/simple;
	bh=SB5MXNj4MZ59gpPwqS6cX38vB24oWguTL4eyUujyXig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M85JyqOE8/HngIJG7YWtm0S+xRuYmuZXFi2HbNjpkn5uTyWc2BLXtiM5S6eNVnmU8kd6Uv7z49TJsLaGqWeBIE0uJpqxWpuwlHOBevIqXNsG4habxye6+RYeA07ud3ysVOqsSQKVWxFk2Ox+Zyqqa+vIevoHPqV4tBZtdc9Md1U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MpQFD02G; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MpQFD02G"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b87677a8abeso130902766b.1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 03:38:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769686694; cv=none;
        d=google.com; s=arc-20240605;
        b=JO3b7MA7zyfRtT9kovolK/BA4pj3UQSgsJK4S6S6EOzTlMXr51zfig4FxtbiqmFg06
         eRdU/Libld928Y3WkmEbUcXYkY8eWfeb09ssfPlP1e9Zfjx5DSsnDf6Ec69KXQZ7mUwt
         O4H3tKoAfhRx+6T7WopzXOiy7jYg7Pw7hrasnSzk2OpT6X441+wLWOK3AIUtQqgvptIF
         4RpCyCeSd77RwmrjoRml9bhqc5gh35PWhvDvLB59WU/btd/I77B3wTIfAjc326J85/up
         RRoSdw4MYDwhDFW0jrjrj3xZSaaykKAu7MoOxmQIVaBGpW3v2JcXV7Pu7iuD9rXvt3Ov
         rjng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BFEK/kGeKRGmi1BOPZ9w7K9oAIyztWxWFc7fwh1Dn1U=;
        fh=ivCwkVCbTDUI/zL2b/roBiCbp/G9xQ3FpSiz58Fn7qk=;
        b=OTK4vc7APZXpF4ex2Ytc+vwFzaHBSM2ibTjarN8iwKxBG3venh+mnjJGUYUxSb4s8w
         XDcXmGUYEMpAKp2d/cuWrfMAx+mvbtrr1qCTRqf7HmvgzFRcb3ejkQdUyC73Taz6Czel
         BKRcRijCU1SBt3/b/ziIcV40xp9vRDeigx3pustfx6pQt1JsUhdtUudWlpCtBYDGORl4
         UebL6soT2PZO4rstEW8727KJlhQ1iu/SrlHAgqPaTiVq6ymQDENZShLGeSJsppxkGffU
         Opir2qejtOZ3/fzPZKZa91Y+x2d8UGF/rrIgAbdor5cIANKNd2clvv9zpO/LTSvgnNYF
         Yh7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769686694; x=1770291494; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFEK/kGeKRGmi1BOPZ9w7K9oAIyztWxWFc7fwh1Dn1U=;
        b=MpQFD02GVoN+l0wg6rTjk2xd5vtP/eIkx2rhhHHLQNdx64aajgyNtO3NVfZhLbIAjh
         pE2SmXKNwCKYoPtWCUAq7tlvsHLamWRcHcOii9FxxjF8s4v1Z68gVCm+ozeTjXPM/GTr
         p/EhxgTaJL6LPBG5YcyxUS2cQn55PbfvpGc/edtbOUUcdovDpMmCtrYxQ10hG59+BGMp
         dXWpBRU16YBlpxuKujnvVcafBZcWUx81crEbaeCEiS5gaWygwykWJPn5UahXCsPmeUCV
         8X6222bA8XMs4Ji9GhBuerHyUK3eKetZ4rcWXUmJmCZPpuzLJs7u8zCYbGtc9X/sUlOv
         Pvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769686694; x=1770291494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BFEK/kGeKRGmi1BOPZ9w7K9oAIyztWxWFc7fwh1Dn1U=;
        b=CNp2dLex9ym4cby1uIcWB81gF6N2bAW9DbSTsDfUKCc8otAdBD23byvfwpCOkjcR3p
         2/Rw11mwjC+igtVUng89vyqA9PBfq0E3heHSNKM07BAXE4UrSfgWwAhAV9DnATizXqKR
         fTuev/vt4PhEtizyCj1CNG3GLixvmKdUA7wUYqKHivAT/yPW/p4il4ghzK22pkm3K3Pw
         ghw6K5vGIN3zVkk35YqXZelxIEYyQUF7OZ4/F/0Y1diGloL2H5O42eGQOmBVmznh+vhL
         3S70zQ5C+BzUVDoC9h5mZYLn7US1c/KACWa9xOo6rtJdUUFFUX7X77M/QH0sNmQvZabv
         4tfQ==
X-Gm-Message-State: AOJu0YxNqXoQLxZZ7G8vhDLw1dS/pixKKrFbvsDoawPjtaLZCMRVLtmP
	Xry/3UDI4PM0V8+cV1JPNpVZsbj/mgWjLloA/HTBt00bO4J3V69KhrnIOiGdhdqvmK+82X3Jw51
	y84KOA36vit21oTCnVn4ugqXq/dNGy3lgPoNN
X-Gm-Gg: AZuq6aIzFMBaIQNBKHzR6WWzplMbkVuIcNU0iNiRwVAzlWDFN9ATQiew12Ij79A22b8
	8ITMx4omULf3lYkUMV/7ZY3TsGDhRAF33sxvEJTBnfHNZKvqexVO97NtnidH7SKxDorBonA0A90
	jvo/E/S5lxJ9VufiTAXMWZEJVThKAGFX2dxi52a57UXcxqgkf427ijAWSb6zyMlcTvSZd+53jMF
	Ghy6fXHwq9QxpjDTFQi8iE7wYCHfsAZEA0PWR26OwdMxD3HAWGB7O9zUZ2yw6/OdJzWTQ==
X-Received: by 2002:a17:907:6eac:b0:b88:464f:3db8 with SMTP id
 a640c23a62f3a-b8dab457b60mr543664466b.49.1769686693638; Thu, 29 Jan 2026
 03:38:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120062152.628822-4-sprasad@microsoft.com>
 <20260120062152.628822-1-sprasad@microsoft.com> <1653031.1769038583@warthog.procyon.org.uk>
 <1653265.1769039401@warthog.procyon.org.uk>
In-Reply-To: <1653265.1769039401@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 29 Jan 2026 17:08:02 +0530
X-Gm-Features: AZwV_QiHhKM4y3f3-0qv5thdrSkrXUgwx6Up5V-rH3M241keTZz20WhihQeOkwk
Message-ID: <CANT5p=pXP3+CywpmK-on2uTvxO3S=31_B85_UDR7RoK1dQVtMA@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: make retry logic in read/write path consistent
 with other paths
To: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com, 
	bharathsm@microsoft.com, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 5:20=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> David Howells <dhowells@redhat.com> wrote:
>
> > Better to offload the pause to netfslib if we can.
>
> I would suggest you look at doing it in netfs_retry_writes().  Something =
like:
>
>  (1) Add a timestamp to netfs_io_request to record either the first op be=
ing
>      issued or the last op being issued.
>
>  (2) After netfs_retry_writes() finishes waiting for subreqs to quiesce, =
wait
>      for the requisite amount of time since the timestamp recorded in (1)
>      before continuing the retry.
>
>  (3) Add a method to netfs_request_ops to allow netfslib to ask the files=
ystem
>      what backoff delay it wants to insert.  This could call
>      smb2_should_replay().
>
> Alternatively, set a flag on cifs_io_request indicating backoff is requir=
ed
> and do it in cifs_prepare_write() before waiting for credits if the flag =
is
> set - or maybe in cifs_issue_write() - at which point clear the flag.
>
> David
>

I get your point here David. (And good catch!)
The problem in my patch was the sleep in the cifsd thread.
I think I can handle the sleep fully in cifs.ko by changing where the
msleep happens.

I plan to do the following:
1. Take the msleep out of smb2_should_replay
2. Sleep before doing the actual replay (This will be the back-off
*before* replaying)

That way, I'll be able to safely call smb2_should_replay in the
callback functions and sleep in smb2_async_readv/writev functions.
I'll submit a revised patch series soon.

--=20
Regards,
Shyam

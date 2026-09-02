Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D05A368D4A
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 23:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788393396; cv=pass; b=iwFBYRdGX/JFMuYSqgRrqngcmbZyY0Pm2L9A2xszNNmVOaehpL/5vbyb7AxLe5lr84qlHhjm09uv7tkLtJqpMpQ+pChF28SEmIEwUAmKqv9FX3+TLajQeaITkC0f9akUaVf4gNK4jXy+Qnytk9+OHV24G29BvRwsGLE6ibmZoPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788393396; c=relaxed/simple;
	bh=IJhDGleDTgY91qpLvvE+dNdvhrQblJ9A1FgCmk4NQj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uzczCmuj132vkyv+/ehz/6Fum29+3QAoIY1Z9Ck5eGgJpmRHzYoto3Xyy4Qcyz7ZQeJZhnEah/3yOPpYoXf6LAoBgEhCuTdPUMmnWZ6IXl49IGpu2E1pGeyBSXot1KmXEJY1h70fXj30WbbK3y1yT33u4Di7wUNNPUMHEsFLORE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLXKUxor; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLXKUxor"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-97bf90f4b41so827042241.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 16:56:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788393394; cv=none;
        d=google.com; s=arc-20260327;
        b=kn1vnc7tbX0CaTp0u31M+2rzeoq+ekRPLn3oGOC5zHx9FLP8WIVJlLhLQBbli+FEn1
         7JiRUHIdzMU9lAVeQz4inYNN4K4ueUa0i6T0vSIWPECm8AHM4SKfeMW5N2Tqg+/7A0sE
         jINDBsV/WfqoKvK024C3G8uFLpGpFGBvGItxsita9JLDOxetLCJXFHD67gH5YXxbLJuC
         KrlJ9KwvrjIw643/9lMC40t2xgsz2Kho/kRLJ5hjbtpg23IPawCyohP4WpOXFWeov6+q
         /QPyzegSiLLcsvfCuMjZM1Dlr1IY38EN3XEEglzT16m39ZIYKEIkFYolE3AAGpws+ZR2
         3ifQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UJZSL+LFGxz2Sekirt7LIG9bYUqyGPk6CPn0ZxX1C8E=;
        fh=ipm8ZTxBZXmsskuYhvDlOjzIdI2uI6qlNKGPivmcC6Y=;
        b=VTO470b/pc4UwKAqT09+N8sGZFrXlZuFfSiZYNwjg59UDV8jf0U/WI0iq/9a4uhsAx
         VJmEYzZjqdxD34HbtizsNG/b6FdLM3Jqp5tderWkLJoWpzlHZV3LT8L3ZfmhsWTFgHAH
         p5zV4t2AhqCcctXsUvZSNyKxSemMDjPPIHN6TW9/GDsj7xn5ZlJHD7W9PBVCE3kn9yNa
         kADYrf7G0CYOuwthLZSoHIYl27TvNBGwmHMEZMO7RgNjJl051qzQZ0CZOQz+Z1Un3kz1
         P0lWxjX8DmipKgOHjKyLK6kpeIbH3VPmWQ8deD8oObLFEBkP3+Ej+CfOYosxXWZREiAU
         SzXw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788393394; x=1788998194; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UJZSL+LFGxz2Sekirt7LIG9bYUqyGPk6CPn0ZxX1C8E=;
        b=NLXKUxordYUWHxGMlOvnnCatP122WgGsb7IqHJ7IxC6FstavyqnUOS7faXIOjABSRt
         6J54Rg0S4grLZD6h9nOCTUn/kIdvJjA1BUVSt7+BeiFs9jIyM3gugRrwVPjF0mEb/kf1
         EJs5ixYiEH02LSyCaGuX5ngg6OC5zf/auyuHwrIS5kt8XhV8D3IeBof8X9+7m0Xkqz9G
         XU7QwMLNelqJcBt3Vapli8Iu0mx5a+ZQ1FSDPtVY/LyOPk7uDjMHsfjbeyPuk3EgBD8J
         kgeEKkhpeg/d7EC0eCUkW7fp9M6zjNzQc1AhW+TxF3kDnwZsvmLIICOjO/68JzA7ufMi
         bAKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788393394; x=1788998194;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UJZSL+LFGxz2Sekirt7LIG9bYUqyGPk6CPn0ZxX1C8E=;
        b=AvFmee6/Q0CaV1Yr4FcmBukutai+31MHwLH9jMxh8AmnpFlqSLIQKxULXYu80wNiXI
         rV79xf6HC29U4jcPZuBsPAnvkZY0mk5uJCSFGjbRe8q4mfD4VrNBAeD2azfEAIoBjewH
         0iOxPcpFrtwIFJeMWJueXkYjxGaAupoedJKUd1cT4sPOC3TcBNfl/6Ukl0dh0r4SxDXv
         +mSN1dmlj8MBr7TOyonLJCXUpcglkDODcDA34pWBb+gTO2bn6+PrKRvWlfoyfJI/dBAP
         ZTh+u38H6p7bwOVVziJdWn5+6pgXY1GCibhJ+ZSoMnuHq4tXvUoTCqpOo3rrRHAr6UlM
         Wckw==
X-Forwarded-Encrypted: i=1; AKwUvBzkF0Mq/5xuE3IdLhKLZ5RYf0urFftPnETKdM514Xrn3d1rGswphbY6ARQccCSvBWjgNGSPrgyTDRkx@vger.kernel.org
X-Gm-Message-State: AFuF++k+hFvH1W54UmZ7rPYbwwFojhR1NahYmW8T8b0u8SXmslVXgVnv
	uVb35y3UOdV3mpfHnHvhN2D9f3NQKsDE7AGbkbibrvXvWBoBFC3RRME1Jb2WA/dYlRqtBpHObt7
	SINz7oxGh1HJ+w1Wb98fNO0MVvRl5Wjc=
X-Gm-Gg: AYBFou2ox8zFhFyZF+rrYxFww50pxCL7ROGMpsR8d3REUJ6v9By4udbQhJbzrpdqxvA
	E11cCx7RtsDMMSFTiJR45p7TiQbCMVPt7E3gJ9PDBlitAiqO2j2RHRBKJ4DBJHTeAb+Y65DJhRo
	eMp2sp/FwZphH/7Al5t0sRpYpQnepKCOXZ47Oag/egSKq68W50MVbHpQk6qJgvmr0RbFwwt2sWD
	tis3k+lD4PZwVYQQqDU5xa3n6pQAXQmO4vdZkez2aT/ecvFXfnX13eA4n+AOb8q+sw+PbFpFDwt
	rPXhNv/iM+lkJkNWBPCnyfc4ngGfxAPyv9g3bCRWFoQ9sg==
X-Received: by 2002:a67:e704:0:b0:77c:6bdc:824f with SMTP id
 ada2fe7eead31-78a1f1d4903mr3745636137.1.1788393394099; Wed, 02 Sep 2026
 16:56:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826191033.162320-1-fredric.cover.lkernel@gmail.com>
 <20260826191033.162320-3-fredric.cover.lkernel@gmail.com> <7f87f15e7136147297a33a540f0880f3@manguebit.org>
In-Reply-To: <7f87f15e7136147297a33a540f0880f3@manguebit.org>
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
Date: Wed, 2 Sep 2026 16:56:23 -0700
X-Gm-Features: AcwNN1XDlDR860Z9DX-queudep_V0W64AlYD126lzdzAWwbcoUccmxpaxtcDA0s
Message-ID: <CAAk_H6H=YG4+ZpJRHGaNJC7AWBEHFFJrfy3z=93sh4-rPHcNJw@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb: client: prevent out-of-bounds dfs_info3_param
 access in copy_ref_data()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	Tom Talpey <tom@talpey.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paulo,

That makes sense. I originally added the check as purely defensive programm=
ing
because refs[0] is accessed unconditionally at the end of the function, and=
 I
wanted to guard against potential future caller bugs.

However, as you noted, parse_dfs_referrals() already guarantees that numref=
s > 0
on success.

I'll drop patch 2/2 and send patch 1/2 as a standalone v2 shortly, which wi=
ll
also include the removal of the redundant ce->numtgts assignment in
update_cache_entry_locked().

Thanks,
Fredric



On Wed, Sep 2, 2026 at 10:48=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Paulo Alcantara <pc@manguebit.org> writes:
>
> > Fredric Cover <fredric.cover.lkernel@gmail.com> writes:
> >
> >> Currently, copy_ref_data() assumes that numrefs > 0, and unconditinall=
y
> >> accesses refs[0]. If copy_ref_data() somehow is passed an empty list,
> >> this would cause major out-of-bounds write and read problems.
> >>
> >> Enforce numrefs > 0.
> >>
> >> Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
> >> ---
> >>  fs/smb/client/dfs_cache.c | 3 +++
> >>  1 file changed, 3 insertions(+)
> >>
> >> diff --git a/fs/smb/client/dfs_cache.c b/fs/smb/client/dfs_cache.c
> >> index b0388c460499..b51c8355d73d 100644
> >> --- a/fs/smb/client/dfs_cache.c
> >> +++ b/fs/smb/client/dfs_cache.c
> >> @@ -389,6 +389,9 @@ static int copy_ref_data(const struct dfs_info3_pa=
ram *refs, int numrefs,
> >>      struct cache_dfs_tgt *target;
> >>      int i;
> >>
> >> +    if (WARN_ON_ONCE(numrefs <=3D 0))
> >> +            return -EINVAL;
> >
> > I don't understand why this check is necessary.  All target referrals
> > come from get_dfs_referral(), and in case @numrefs < 0,
>                                             ^ @numrefs <=3D 0
>
> Sorry for the typo.

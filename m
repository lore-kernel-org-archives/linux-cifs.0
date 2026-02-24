Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC031E47CC
	for <linux-cifs@vger.kernel.org>; Tue, 24 Feb 2026 03:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771904019; cv=pass; b=jkRKiTaU5A4jiFFa5ByH0h6tvBUSHOvLiBL+1QaUTB9ysxmpx6qWwnldsNshg/tGB+rzvOzAv73I2I45F2DOzvzEaGgD0isot9BExw8+31OW6FFJpY9WVAKmJoKA5RV4AMOm8gdm8yfUeYrR+xk1yTgcVDP51D5QdevvObLIG9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771904019; c=relaxed/simple;
	bh=iJ1Xbe4wgQdzpLHpWKAWzR1x8I4Idd27NmjrfIEaqGc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PQoBM8NChMqIeBNi5vNLZsJvSHlcC7esrd193yym5me/8TphbQktU5hDhj1t5AQxV3eAXC5QjvDCcokNdGhoOc4rmNWvsYDQ/zKNAhYSRJaB4CeYRwa+D3t1Y02rtoJASRdEy5CIQeK7rX/zcR3v4WOvD44p6PFLg1bSozF2FmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=giBN8ySj; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="giBN8ySj"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c0d2f5fe1so8626621a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 23 Feb 2026 19:33:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771904016; cv=none;
        d=google.com; s=arc-20240605;
        b=kobUucoBcv2H9mbB94Y9JXbLZg6gW6+mghm12UYWssbvfg56ByP97rm3chQQdj5c6x
         i0kUvxKoFwRn0h/w1Aa3EPYx/5sdkHPGeU00kTb3LW8rcNjDuxCiV0tObykx8q799DOK
         x7PXMtgfxWU3Sin3cWaiAVFGuXfqH060u47VFLoO10aDPe2ivW5JpMdN1ZzabHTKBQRf
         3xSofwK8W08OSIvoXplPXX2gmMoVUgqYmf3nxqNWWvG4Y/beVuzS7QBHTmV0MKtfsoTz
         CEtySaOQAv/Ak+bTMJHVeVzP0BhyljeLVJ5Gi9+iSMgiRpHf3uJ6UCoDC0QVhtNQqMaf
         vjJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iJ1Xbe4wgQdzpLHpWKAWzR1x8I4Idd27NmjrfIEaqGc=;
        fh=A3NDxOdIddUYp1EsjYDU7RG5Khh7vu7r7wKOb0aZZ0E=;
        b=jhQbnjdhK2FNyDOLRxvK5VxYJ1N3Pmba1gtF/8WBDDLvxhCd9UjmE1egydUnL2QJ3K
         eY4CFUYTknXr5YRFW6/Bl9dyh4NN+jzSDAM/0dDlWAcuu2pNYYXkhN6ezyYhp3plvV4+
         iRDViVBDhO4A71GZTJZnU1GWuwBhI+rswY/tOm5GgTodiBAW17GImnrSbXsY8bw5ouq2
         2+sE2KLGpcR9fCqeR2zCbqMH3HxVOnVKZjtYLZiJsMdz1FNV/ALowpipWcb7Q0jt4zqX
         MC7JPsa4Xp2l3Z2IyDX5zOpsSmh3hsIE9WsrhP6tP6hyV5yuNAFECO2qy/6yfqO0QJVs
         mADA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771904016; x=1772508816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJ1Xbe4wgQdzpLHpWKAWzR1x8I4Idd27NmjrfIEaqGc=;
        b=giBN8ySjwkQQFYIxsnKRdoyCTfBNoEmuVC+UR61SEZV2Dr0JiOQQaXXoQxnHTjJrAo
         6Td3VAgsHPyrc6C+E8Tfkq08KJMGUUHtmuVra9n0rtYQbjkS6yduLGmw0jgEk+/qeJtY
         LIThk3lOtuVh44R767g00pfD+/Mtzu2xT+l32Jl+hDbCX4w0DlOouC4ol+mccvMlX1ug
         iG1FIdogRF/iXPiFUAR1bVpiJ1n+oF6qIgALTknAZaJcLQpM4EZ0K0I0RJ58JxeFlgM4
         NP4FzJtqrkoozSS4hh4PvHSezeRvbAHKzwL4kxryPXecmLLqG3F5TPLk5L9PYtJ0TF5D
         67hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771904016; x=1772508816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iJ1Xbe4wgQdzpLHpWKAWzR1x8I4Idd27NmjrfIEaqGc=;
        b=LlJ4/Sca6wlUcYUnT8nfrMeFfPp7uK+6leN1HdS7pLRgE76vRvaQSsb5+djN/2gV+J
         Rpi2YIgRe4r4oscJHHn0+vphl4cE5S/9SFdCg+35f5NlKiIc5YEQFivsaWMtSxhhkNHU
         UbsVoExvorXX4H/8HFy8Eiz173q6JxkC+i8DSyQiMwHhIed64Ll1Gid/IWuUDLal0foj
         QPc6ef//Ki4/W1kgR6/VnBhuwa8PBMljSdllrbwJ96NSs4ZLlRD8bkolEFmiPLBocykT
         /NC5cl5OnTdgbkNBKKngfDyXLEti7v2Mz175mCPyZ992XPP/p6oI+nymkklIruw8B6r5
         hhlg==
X-Forwarded-Encrypted: i=1; AJvYcCWpnyVzmI+Hldmq4xyUQrZSkMU65YOH4USlmPe1+xIOd9uxt0B9nPTVANGNCTn/oUYTD/qlApC30qZE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0fiDtj0UqByep8g7YcL7CdwgXoT3ICB+MoRKJbjJ44un9ZnEM
	12e19qm70faFpOUvIhcp2yw95fvA+/tYErtPVf/jRdqU58aphQDeIs+dh3ivdnK9Y8pM9gAaLWw
	KPxlhF9dVk1jgb+KLTRKkBeeg+wwx1mPBjw==
X-Gm-Gg: ATEYQzz8Fhg91jh6twAO/5etkto3UBKXhrfwXs8aFSqppLsdIBBw1hWZgfsZEGvau6M
	0J8vLzMkmqKnedwDllhkMf23NK00JaXyii4EcSPA8l6Bbq+t+RIWB8E4ETXaR9U70y2gUMVJWRl
	zv+yAULT2eIPzyXQUGsWTV+1ZDNwakhV3wK8Q3M8elQOKNTkCgFaznKXctuzUTCYvnbIhxQ8sY4
	ktXKT8iGEESX/t2HhJymKKsNA9yBpMeUfYIKKvrtpQQBr/nGP3S5HF+htl+l9zOsRlK5xTtl0tO
	JrQPPg==
X-Received: by 2002:a05:6402:4410:b0:65c:5a7b:bd99 with SMTP id
 4fb4d7f45d1cf-65ea4f0cf7cmr5793513a12.31.1771904016311; Mon, 23 Feb 2026
 19:33:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=orpQdzqxjNronnnKUo5HFGjuVwkwpjiGHQRmwh8es0Pw@mail.gmail.com>
 <2026-02-17-grimy-washed-domes-aluminum-0HKtw9@cyphar.com>
In-Reply-To: <2026-02-17-grimy-washed-domes-aluminum-0HKtw9@cyphar.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Tue, 24 Feb 2026 09:03:21 +0530
X-Gm-Features: AaiRm51P7OHLrFnboWksjbRX-NAP89jcZmSdGRNEJR_eFtlS1Z-LxcXzLTEF0t4
Message-ID: <CANT5p=qNA=uYY5YHvE8MfEtM6dXMXn343F=GC5M5-0FX-OVPNA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Support to split superblocks during remount
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	linux-nfs@vger.kernel.org, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 8:30=E2=80=AFAM Aleksa Sarai <cyphar@cyphar.com> wr=
ote:
>
> On 2026-02-17, Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > Filesystems today use sget/sget_fc at the time of mount to share
> > superblocks when possible to reuse resources. Often the reuse of
> > superblocks is a function of the mount options supplied. At the time
> > of umount, VFS handles the cleaning up of the superblock and only
> > notifies the filesystem when the last of those references is dropped.
> >
> > Some mount options could change during remount, and remount is
> > associated with a mount point and not the superblock it uses. Ideally,
> > during remount, the mount API needs to provide the filesystem an
> > option to call sget to get a new superblock (that can also be shared)
> > and do a put_super on the old superblock.
> >
> > I do realize that there are challenges here about how to transparently
> > failover resources (files, inodes, dentries etc) to the new
> > superblock. I would still like to understand if this is an idea worth
> > pursuing?
>
> I gave a talk at LPC 2025 about making the mount API more amenable to
> reporting these kinds of confusing behaviours with regards to mount
> options[1].
>
> It seems to me that doing this kind of splitting is far less preferable
> than providing a more robust mechanism to tell userspace about what
> exact mount flags were ignored (or were already applied). This has some
> other issues (as Christian explains during the discussion segment) but
> it seems like a more workable solution to me and is closer to what
> userspace would want.
>
> [1]: https://www.youtube.com/watch?v=3DNX5IzF6JXp0
>
> --
> Aleksa Sarai
> https://www.cyphar.com/

Thanks for sharing this. Will go over the details shared to understand
more about what you said.

--=20
Regards,
Shyam

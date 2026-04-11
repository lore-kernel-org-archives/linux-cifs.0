Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B8018050
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 01:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775871123; cv=pass; b=ryDbX7GZhcK92/Lm9FFYbB5hCfOU4isfb8Oa4RRJyhFlzdnK6fkzvjW9thVEnWxn00/oPIz6Ri3gFJGA5wVvtY3uHKGeJtytrmuR70Nd9byXHlaXkesJDTRQTw6n15WcXMri9b287U5GFu6nUBKILZtVsCzf637M3Lx5rOYQHOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775871123; c=relaxed/simple;
	bh=KF8AUjwPTgKFIKSxBmojpWMJ4MLGV7WCKD2Z/XWsXLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LtFtZdwtpJAyO2vLNMi+w3upXUSPLUjGmM/2gjSkuetDtJA6pElmB17CAVIgo109eN0bRpIZka5enjtpPX84pMBUdiHRoIuoqLHUwu+LcCJ3vGjgW64VnwCQoByt2sIqUz9yZe5RgcXfED5SOnjf5u7mbJS6VnP0BmW2YTtgakA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKdHKsyg; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKdHKsyg"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8a093c784b0so34143306d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 18:32:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775871121; cv=none;
        d=google.com; s=arc-20240605;
        b=NtFM2QwtKlqu7eLjXLD+RqaCnob2Z8A/DtMLMqAYRyARshifb3WiQVU6pfAaOzzotc
         bmL0LM8ZopW/AgdGYy+/u0XZOKCPXXAxORQRPRtyOZAKSuKwKUqBrSZYkpAiWVbZ1qjO
         UG7UA2XEyx4dqlTAghjBIeIING2Yn8dcfVgucZVpARjxBepUmBndGsr1cILGNpEh5hd+
         QbhFccasSy9kTdN/toDZ83gBKa/zX+x1bD2N7bipFydA8D6ahQKDMeRvjLGJ/0i5TAsw
         d0i5AGOUNQ4MI//1wwJ/AtrU4+SS5uJAuhDfU77/jw7O2BLSLNH66N/bD5WlArmtv8zK
         Zmpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VWYcMS5A97Mv+ERZKG9Y/U9KAlTskm9j6d67eeYGshQ=;
        fh=qqQz7oa0W7z+3oLGiq/Hs1QlggxtMBBdC6tt+mWDN8g=;
        b=Nr7sRdhTqrj7HAxaKa9QeaqQtw/qdiBsV/UGqM2oh5UupBKRXdbge/NXYdJ/hB2HvX
         4vUc48R0SYv0YR63fyehrKkDDdDvjNxhKN/tI3rtMJzoQgn0JyIvnrLjm8uHAo5f6hr6
         Iw/7ICJdgbTy52M6PJUL8QnAsD6Ms+uf7uMpTL3/lAaJ1iDpmtTtQVqD6vYZf23GHwLu
         K5WPCGksYth0nVZWKiybJU+w9xszQKKTHoxjdb2z/pFCHAvjx+lp5e7sYS16Rjxjb6ef
         A39YM2ERqWf8nvR8xNknYvwPuNkGNV6D/zGe8ZVLhQfZUVB7yMmNl9jdHBhY1lMLvImG
         novg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775871121; x=1776475921; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWYcMS5A97Mv+ERZKG9Y/U9KAlTskm9j6d67eeYGshQ=;
        b=QKdHKsyg7OylagfntI/9XmL3V1AcF4IX2JVl6vsPRMJyymUPG0ix3yAkzU4A5Cn1xj
         FLNgrYiaZpG3SMZKOY3jt9Egdz6w/lyNOysqHyMDfKxG2KC48CPWjqa1OU9OBDR1XO7C
         yIcaK4a8HNYeuz6k1eWgP0hc2qoHzwXE9yaMfMTg2O70Wn7UOupU+pyJXq9AC/K7fUIF
         EYy93g/IVTq/0kvpFBenxYJhbo90Ih0t5pVr6YmFCaSuFc4UKPK9EP++FotQ025mWAsF
         iQuy1x3sb5PN1dgg/k51yxkY0blsr9wKW/25gG1w+KDrhgY9NIrXGIvweZ/RAkUVbhaG
         3WXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775871121; x=1776475921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VWYcMS5A97Mv+ERZKG9Y/U9KAlTskm9j6d67eeYGshQ=;
        b=mhzPC/Zwt6qg0SLMcfR7yGAR8X9pkc7Dsrt3JiqTIgqrQp7lpiEHILFtE0yzGLSVfv
         4x29l5ZI8oZomsaSJXgrjZxoWFeL37csNQlcwkhKAl2YulHWOMjdWsCDPj8j61oijul4
         mIOLJZ1k6UuWbrUal0cmdmP2gHggL4AgjaDdGdjHDRYNpeog8T+/GzwCGkhnj70AujFi
         1Lj4VADDMO4MyoXcmVpfdEMDO4j3wSKZmU1Di/6TSpP+EffEV+OlSJWZZHD9+9TSNUZy
         UbNI+fdB4DM2KbS+RP0nr7NZbQBGHBjqAYcvlW0+Tmxyhz4EYa4a7ww2Lq7VMrJ9sO3W
         Hd2g==
X-Forwarded-Encrypted: i=1; AJvYcCVmhrEnWX0YZihIw08wAX9xwPEyGJPf9OfDDbR5/mmLdv3Tk1LZ0/6+WhBTReSNgyhW8BFKGzpJvT0+@vger.kernel.org
X-Gm-Message-State: AOJu0YwGO9TSeMzjSDBazKTBHUKvYy1i1wEEZq6K53mjifhDMLxfwGCA
	psG+s75RVNMJBZKQX1KrtuF/YiKwOQOLHdTKzLz1Y85WqOHRAdRJ89uZnh4i29cQoaLDpCVfEZh
	pFVbYl3y8BAOHjmFhh88wxsXoSVOsI4I=
X-Gm-Gg: AeBDietYyNH7BiAV3XapKpYCz4WL5UL8GEe9ZHYJGwyLTKLmaR0IVh7B/QRLE91BTEK
	AQVBIgSrzTEG1oiTDXqziXUcBCwv2hRp6HTJkv1V3wolPPn6DXcGzXKKhEyvGxAJe7Eea5US89/
	GB3j+Na5XT6H4WMSeYBQMSiJHWafEjUJ6d6XjVZ6gIStkTB0thoZl4UEyUDN7dHJkte8bIJA968
	k2XXAoa4aeEF8MGtGjbUT8Gpmqm8rExSlymAFiwOp0YfqVXbGBJn+OKiWgL9W4H77u1KbJu5xhl
	+9/UiPdu8HYxzMvbe0uggFdslXS2JiJu3u2nGQU9OhPaIDC9bw12wze2TPyNPci52h4WV/HF9tL
	YtIth5rEVyTNPJ1ljGoS06FcJ9hlHX/GBofRawKkLrP9l3v9H02skXk5TZz0YggcRv6nmawDs7U
	JoszTlzpdxyBS6TticsBLorLCYsGMXm5gs
X-Received: by 2002:a05:6214:8018:b0:8ac:9107:830 with SMTP id
 6a1803df08f44-8ac9107144dmr39877936d6.41.1775871121087; Fri, 10 Apr 2026
 18:32:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1775838249.git.metze@samba.org> <CAKYAXd8p8OJnw4ATHDPi18vodMxVwj+sr+TF-Mj-CcAUXXROzw@mail.gmail.com>
In-Reply-To: <CAKYAXd8p8OJnw4ATHDPi18vodMxVwj+sr+TF-Mj-CcAUXXROzw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 10 Apr 2026 20:31:48 -0500
X-Gm-Features: AQROBzD9J1NX0lQHAUBHz2FE7KaSPJ48etOgVwb7l6iDIAytFeMeKkS2BazlCO4
Message-ID: <CAH2r5mv2Yv=FmYk-bZS=rzT3tPJXDiedakcEYJnTb9Rq89Ga1A@mail.gmail.com>
Subject: Re: [PATCH 0/2] SMB Direct: double-free of send_io on ib_post_send
 failure in batch flush path
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Ruikai Peng <ruikai@pwno.io>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Paulo Alcantara <pc@manguebit.org>, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added the acked-by and updated ksmbd-for-next

On Fri, Apr 10, 2026 at 7:51=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Sat, Apr 11, 2026 at 5:11=E2=80=AFAM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Hi Steve,
> >
> > here are the real patches for the changes already tested by
> > Ruikai Peng for the double-free problem reported, see:
> > https://lore.kernel.org/linux-cifs/CAFD3drNOSJ05y3A+jNXSDxW-2w09KHQ0Div=
hxQ_pcc7immVVOQ@mail.gmail.com/
> >
> > I prepared a branch that can replace ksmbd-for-next.
> > The 2 changes are rebased below the smbdirect.ko changes,
> > I resolved the conflicts and made sure the problem is also solved in
> > the new common code. This in for-7.1/smbdirect-ko-20260410-v12
> > at commit: 274b415378bbd0cf6fde1a719e264cee2eefc06f
> > git fetch https://git.samba.org/metze/linux/wip.git for-7.1/smbdirect-k=
o-20260410-v12
> > https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dshortlog;h=3Drefs/he=
ads/for-7.1/smbdirect-ko-20260410-v12
> > I made sure each commit compiles fine...
> >
> >
> > Stefan Metzmacher (2):
> >   smb: client: avoid double-free in smbd_free_send_io() after
> >     smbd_send_batch_flush()
> >   smb: server: avoid double-free in smb_direct_free_sendmsg after
> >     smb_direct_flush_send_list()
> >
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>
> Thanks!



--=20
Thanks,

Steve

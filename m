Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ABA306B37
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 09:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761297246; cv=none; b=f9f4sb+YjL/fZsbi/TtxwOpqbvjpdhCzqYgscNo/t5CtuFSMVNW3uLA1qzSZck1J6MXQCqLdrwYC78LUhE9eU695NAIwhaMoPh3UGPJxfXAaGy43+ydl1FttfjRQbUdsJDidNzCVRPBDp8dc4TOp9jpXHqMX6icWnp4WVBC4HbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761297246; c=relaxed/simple;
	bh=YkWz/eLA9P5wnFmu3ZMMaRznLdfeB1qZAHP+lceLBSc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MS/eAoGbJPvNlmsD7ItfRrWhtTjT2tzTNDXq4J+RL1ZENbsrURcsNWF7S5pP5pD48lUkt2vlnB68+7WWA2FxjgtLAZBEt190wtWGQK07r20pD6Ps1ddOWrCwjMsH8NQ3HdLb0oIna1r3WfmOFOx3E0MKXNHqv/cw7qB4ViMO8Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=moBCDjVb; arc=none smtp.client-ip=74.125.224.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="moBCDjVb"
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-63e3568f90dso1895033d50.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 02:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761297243; x=1761902043; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ww5IStytbWWzh3axxpP6syzswHBpM+tPPGSPp/lLbiw=;
        b=moBCDjVbigDSdhuT+0fLM02gZFo1pnv83AV+6OQoyCyySIn+BWgULHh68oWzHHvryA
         pqwc1lGi59WH7tULW7HxxPS0cnaKIVNrv8EI8yGWHWtyzT6cxqcVR/uNR6pSRr0SXAoJ
         IwyJkKHPoE321yAJgj8YPvmPKBXZy35t3KakYoQ/xbJiFrzkXUvBBhSkYkxndBP+85qR
         3epjS6O/byY7fPGwBdJKl7ZP3p382oR7W3ziCUwZmkKjis+yBi8+weV5H0lfiaDRjauy
         6Y60NwjLwcCgVGhq2N7AP1VzkbUgKWjR/fqSfR04BQjUOu5V6UkN+Zj5uENdL05oyG8J
         4ifA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761297243; x=1761902043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ww5IStytbWWzh3axxpP6syzswHBpM+tPPGSPp/lLbiw=;
        b=aekN5KVmzeeCzUrIz02kQhFJhxHW1mKLE8cD14x091+V2joz5GFgR5u1MOxMtHq0VL
         u4N5jpMMkWUeFROATdcDuLR1EyVx7StWGZnsUUfb+jtxRxU1GPG5LE1NiXQ2WpPDbhIq
         rdP6jP2FrMXFVe1iuuwWQBQPoUcnGTelXwZr+3v4h8kodUPOWfoYRl16b4i7/EMzVMZ1
         Gj1xSIij1vsdAcn5fGnJoI0Ebhqu7728J7JKKB1xD62rUmbNldhUG8KaiUMj7lf5Wik/
         Y2YYdWqF+ceqso848lwCMjfmJrq/agldecgiHIUugm2YieZAHGSB1lzgCEc8fhoNn+UF
         p5eA==
X-Forwarded-Encrypted: i=1; AJvYcCWO0pYmRGWXh2q9yq7+fkueSF8XDwu2b3kw5+hqhyrJa7OxF8aGaHFUCaq/uKUoOEnjfDU4x8TtMVcC@vger.kernel.org
X-Gm-Message-State: AOJu0YyQ+uzRmJ4g7NlUVTLgKb0R1eCEgpKG/+7YJxmxNhZnjXHfWD4R
	XtSfOnMmmH/qvUWFHMy4fYLmtK+b8YO9F1GvIVnR/LY0kQpCVBjLs5eAPJu8DiffcoMJn2qhte2
	TqZoEyzrQMlSF7vjWvwmzSl+OuThDhAw=
X-Gm-Gg: ASbGnctCBk0Ir8JZVj2AA3i8JdziG07CFBtHCGnbTaW/uslBisjBUc6o/VEeOglTrra
	NNzOQO6b+gWAZvn0FoHiIHG08hIrLrdk1obO7ICiivRXuVGyKrYJHtO1gtt9uq0CD4dUZDXTqRw
	9J4c2yIjWpmIQfRkasbgtP/uhGBkL3lBI8n4CHXjLQwafvScaJqzditia5xxKqCZqFguiygj1TO
	zGg83gbvVeoK89xempzY6DYkXDITsGjaLjS47S1lULmpYx9Jc4vcdTi2vokVZO3Uht/Mj8=
X-Google-Smtp-Source: AGHT+IFSrdDKkSVcWsLqx7Pf7bHPRADDQgKRKHZHzQTFze2p72Runu1bsKnPmSgK3N/ff0Y7uzayMI/FM3pHq2ngItA=
X-Received: by 2002:a53:b3c9:0:b0:63e:3323:1ac1 with SMTP id
 956f58d0204a3-63f378c4e3dmr3077378d50.48.1761297242836; Fri, 24 Oct 2025
 02:14:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muGJTYxfNN9kcnBtX0JaJDeGa6SLiiuMg+zQVkNRjP1Yw@mail.gmail.com>
 <aztzqdkslkjs6jjtrxlir65hujpl4euikgaxwq67ulfeoqnitb@wnalncavigju>
In-Reply-To: <aztzqdkslkjs6jjtrxlir65hujpl4euikgaxwq67ulfeoqnitb@wnalncavigju>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Fri, 24 Oct 2025 02:13:51 -0700
X-Gm-Features: AS18NWB2MXPo156pqpEs0lh9QOhT8Mum2Brxph3YCLmu4Qmzg4GSu1JUNesDTu0
Message-ID: <CAGypqWxmEENEGAukMATvfCgWN_pvfqTw4aS1hFjEJptmPRBCEw@mail.gmail.com>
Subject: Re: [SMB CLIENT][PATCHES] directory lease debugging and configuration
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	Bharath S M <bharathsm@microsoft.com>, samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for your comments. Apologies for getting back late on this.

On Tue, Sep 30, 2025 at 6:11=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de>=
 wrote:
>
> Hi Steve, Bharath,
>
> Sending my review based on the commit messages and the patches applied
> manually on my local tree.
>
> Please try sending the patches with git-send-email next time, as it's
> much easier to apply and review.  Thanks!
Ack.

>
> On 09/29, Steve French via samba-technical wrote:
> >4 patches from Bharath to improve directory lease handling (see
> >attached).  Lightly updated and rebased on current mainline, and
> >merged into cifs-2.6.git for-next.  Feedback/review/comments welcome
> >
> >commit a50843f864205ea4576638cb32321313d9c06e54
> >Author: Bharath SM <bharathsm@microsoft.com>
> >Date:   Tue Sep 2 14:18:21 2025 +0530
> >
> >    smb: client: cap smb directory cache memory via module parameter
> >
> >    The CIFS directory entry cache could grow without a global
> >    bound across mounts. Add a module-wide cap to limit memory
> >    used by cached dirents and avoid unbounded growth.
> >
> >    Introduce a new module parameter, dir_cache_max_memory_kb
> >    (KB units; 0 =3D unlimited). When unset and directory caching
>
> "0 =3D unlimited" should be "0 =3D ~10% of RAM"

If the user wants behavior like today, then can explicitly write '0'
to make it unlimited.
Otherwise by default 10%of RAM.

>
> >    is enabled (dir_cache_timeout !=3D 0), default the cap to ~10%
> >    of system RAM during module init. The parameter is exposed
> >    under: /sys/module/cifs/parameters/dir_cache_max_memory_kb.
> >
> >    Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >    Signed-off-by: Steve French <stfrench@microsoft.com>
>
> I think this should be a sysfs module parameter, as it assumes users
> knows how much memory they'll need beforehand:

Ack. We can keep it in procfs.

> - one can't say how many entries are in the shares, or how many shares
>    will be mounted
> - if they do, they need to calculate (nentries * (sizeof(struct
>    cached_dirents) + namelen (of each entry) + 1)), + round up(1024),
>    then finally divide by 1024, meaning they'll fallback to using the
>    default value
>
> On the default value, I think 10% of RAM is too much for cifs cached
> entries.

Today, we don't have a limit on memory for cached entries. I took 10%
percent RAM
as default value to start with and we can tune it later based on need.
Please let me know if you have suggestions about limits.


>
> The max memory value should be module-wide, yes, but equally divided for
> each tcon, because I might have an initial not-so-important share that
> ends up filling the whole cache, then a more important/accessed one that
> will not have the chance to cache entries.

Ack. We can have more granular control later. But since we have dir
cache timeout of 30 seconds
unless it's reused again it is not a problem today. IMO memory will be
utilised by the mount which is
performing heavy metadata operations and that would actually need the
most caching.

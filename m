Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE433F7
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 21:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739827149; cv=none; b=pMRhHxYmuFO7GG2SA1lew0tGYJ0ixR3SuXwikHmQ3EIbVj6y+lS6X2wS+yUFImIJpKfknOjkpjsm+s8gfowXL4gLFJUxrV+KT3LfttN4zUcmSMCGqu7CBzEod6KRMSmmWNP7UAQfWYOv6g8YbYxXRE5SwdnMNWGrA5RBgXWCbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739827149; c=relaxed/simple;
	bh=NwmL0Nt/khGyjrY2JK467SNMNKU5AxvFBj1jVYZeLhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKYoe1FuuCen9bWLiQ++h9poB9RWN53fTZuY35RCWXTpwE1sUY9TmMaQGuEwD468NL1MKsacXNVKCAewmbgbbyx7ryLIFMTxLTn3/XeLoRH87B240jEJM+ZYXlmbdfZl2cDmGl9W7oq7A2JT2a9mxk7R5kB1t97eIVTv6mRPjhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JaTe6Qz9; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JaTe6Qz9"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30795988ebeso49366331fa.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 13:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739827146; x=1740431946; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8b9xO2HhPtpa/YvLrZhqh7RG+IW/NOAbVfxV4UZ5tXQ=;
        b=JaTe6Qz9QMN2uDwjjLjJs4HRoqAFFVBqHVCw2U5mAOu8pyVolnyX4LrvHOGAayNaUR
         u/Kea2DPt1ujs0OX2juK+gjL9LcLZ4Y2V59BGfQlT1ekMK/QBjCmyA18pjG3EgTym01d
         25tWD6L0Yisep5tjbV1dfF1Q3B0HFEvfZG3itLJQXcPBJfjAqBf/Bpf7qiwe14fmtR7A
         gFFnH0ir6+Kc47R8DjitoRluT7MfRHpHU4Vkj6F/HnJYnpnBaL915Gu7qj/9hMKKEL9z
         6MtB7gbaNIZ+v4noYnAQJPgO4pmm9N5wC0xCs7rNdkUx22kWqeJSsgzq+7myPhybnx7S
         bIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739827146; x=1740431946;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8b9xO2HhPtpa/YvLrZhqh7RG+IW/NOAbVfxV4UZ5tXQ=;
        b=l2lf8J9MP3fbXtvtZseS0gqvqe7mesW/47rY0fSBkektUjfU2Ycd6mvn0+7KKYBKxu
         +oKVtAoW+7pCNxF/YXWie+TOaKB4ecmEMyb47krkH9WWEc7XsmW08DQvQT7gMpva9bdA
         mPgq6IquCuiALjoGzF2kWHXl3vPevdgA2QTPPmHE3W+8f3sDLPh6Qw9CpqjPR/HCpMjb
         QIqudDHMOR7NWjw2B8R0C6632vBm/sIl/Qd3uP1kBJPQN+WDUIqt+sxC5u20zTTb0eRY
         4cq9Xh0S7gKVJ2Py6gXs2gKtVK4o+Z5BLIMeMH/C8YnSn39MRnfvldEs0x8anT6r93T0
         fpLw==
X-Forwarded-Encrypted: i=1; AJvYcCUz5gLdP5CNkNjXWKU2Bx5KxaD13PSc0E8l0wg6xdQoKeD+ej86TyruQXv81DhRbMtCAReCP/g0J8rJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxNKfwjtAn2r9K7aQqkxRZc8eZuJUrC6FvpVoC7+2N4mQnv6VIt
	sOLfVi41Vq32ZeYLTPlOgJRTCvVmzs0MY++VklgNUSff4oS1oTKawowc8ikWNwvUd2H+WIxpXMz
	byuB1Zi1xGR3DLE1avwd8YWNJMSJqZ4ZO
X-Gm-Gg: ASbGncsCUFQM6+QPkpmZUESIsFlgXXB4m78+ee0atQ+I180S6E3nRAfHFOwylbXPbXG
	0ViYurHCP6FNnxtxRbUMq2cUpftkqMSiIcoQ+4e4c28ItwdA4HQuMw200EEFpm1nXVwizzphANq
	5qxn4jW4qLuzjGv/rSR0Lps5Z2hjUdeLU=
X-Google-Smtp-Source: AGHT+IFW08/zILdqLTxk4RCFbEhOhbpI5SIjPOI+Qd0/bsH1Z48Bmebfynx3NHx5uxgOad0tHaLPNOZlJI2hV52zBZM=
X-Received: by 2002:a05:6512:1593:b0:545:2dcb:948a with SMTP id
 2adb3069b0e04-5452fe6b1b6mr3841392e87.34.1739827145360; Mon, 17 Feb 2025
 13:19:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
 <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com>
In-Reply-To: <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Feb 2025 15:18:52 -0600
X-Gm-Features: AWEUYZlTxduMtTBa0rO1RrpAfKOwUx8Mo3GDHNPRNj3mkZiYAIREoSIZLeR6htw
Message-ID: <CAH2r5mvf8iCpcp0bj29=1y=bDceEPjZiTGZEx9U2=9yYYgAKhg@mail.gmail.com>
Subject: Re: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Tom Talpey <tom@talpey.com>
Cc: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Ben Greear <greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 3:08=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 2/17/2025 1:27 PM, Steve French wrote:
> > Noticed this old bug today when cleaning up emails.
> >
> > When the user specifies a srcaddr on mount, the DNS resolution of the
> > host name should only look for the same type of address (ie IPv4 if
> > srcaddr is IPv4, IPv6 if IPv6) right?
> >
> > Any thoughts on how this was handled in other protocols?
>
> What is this "srcaddr" witchcraft that thou dost utter? :)

The original patch which added it was this, and apparently is needed in som=
e
cases where the subnet the request comes from is restricted:

commit 3eb9a8893a76cf1cda3b41c3212eb2cfe83eae0e
Author: Ben Greear <greearb@candelatech.com>
Date:   Wed Sep 1 17:06:02 2010 -0700

    cifs: Allow binding to local IP address.

    When using multi-homed machines, it's nice to be able to specify
    the local IP to use for outbound connections.  This patch gives
    cifs the ability to bind to a particular IP address.

       Usage:  mount -t cifs -o srcaddr=3D192.168.1.50,user=3Dfoo, ...
       Usage:  mount -t cifs -o srcaddr=3D2002::100:1,user=3Dfoo, ...

    Acked-by: Jeff Layton <jlayton@redhat.com>
    Acked-by: Dr. David Holder <david.holder@erion.co.uk>
    Signed-off-by: Ben Greear <greearb@candelatech.com>


> There isn't such an option in mount.nfs that I'm aware of.
> And, it isn't documented in mount.cifs either.

NFS man page does show "clientaddr=3D" mount option,
and it is necessary apparently in some cases (e.g.
https://forum.proxmox.com/threads/nfs-mounts-using-wrong-source-ip-interfac=
e.70754/)


> It seems like a hack on top of a hack to match the DNS result
> to the type of the specified srcaddr. If the server supports
> both IP versions and the DNS record exposes them, won't the
> same issue occur on "normal" mounts?
>
> I would not see this playing nicely with multichannel, btw.
> Or RDMA. Probably other scenarios.
>
> Tom.
>
>
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=3D218523

--=20
Thanks,

Steve

Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FF719D89E
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 22:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739830987; cv=none; b=Cu2wzbB3j2gAL0EpmxF/rCuXvBlSD2kTxe7IYAaXdeYdsG+ZkvL1DggftKaT+AQI1bb10X3ejUFvMXHhlcwA1YvR30FKxiIkrMudNwTFJRZfHTN44E+HDZ+a1D59CwSmeG+1WX2C/EKLHtvKVtQ6MULKsqUFOVcoV6sExIU0cio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739830987; c=relaxed/simple;
	bh=jQTm7IwJH7M74NPT5xhCyG+7HiMeodtf4KJyHoZToWk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g1WoTQxeF1ishHcxCTQ+oVr1RwXniWF079cXv96aD1QLq6gTp6MDyQ++qp6yiH1aK3gGhz3a/NTlrDrEZKlq4HjeISZbN34yHpE258uWNB+URf7l2eR9lsFanfky6vnL4hVHYjtWqDFpZZBIGV41JkQDZV10BQaSY1C2Jj76hsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PaYZneFH; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PaYZneFH"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54298ec925bso6552033e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 14:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739830984; x=1740435784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phaNxQLnAfg6GDKXQE489sg1ZPb1rJG/P4qRBNpzgZM=;
        b=PaYZneFH0VXq3qWjv+5y4Fip9ZTatvCDZzEb2Ub3zqRDIDmwurq953vSkWJLaftAfL
         /RHjkFtPWoQW9jljSAqZoaN2zE7njWedyoOccwCUX+IkTkBHlKAnUNWYhDBuQs2vUkqJ
         NrU9xAjaiJYuVOREouHmWhxX91BGPY1yllzU+SquuffBXKPOg47xO5zKAVdYQ1lLDi0p
         1NiCqeVLDSvVJYVOWQ/nC4H9glgMrMq66B5Af8dplSn3WKkys9bvwTp7ohUroEZytEkx
         5ohy7UBz60qzJs0XAvY3gcNuuM4lvKwfrs7BA5SRwyjQjNE72lgo7DnHxsm5+nBi85UW
         NiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739830984; x=1740435784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=phaNxQLnAfg6GDKXQE489sg1ZPb1rJG/P4qRBNpzgZM=;
        b=TC0YjDdmwUSfAhPD4zVdcllaCRg7asSmtCn+Zg/1DCg32CzGI/JEqUrF2TqzhVyTkH
         OShM2NCuTzdBL60Vym1jAyFRcO0OJQwl/i1qI8ThXzNQnnAtewiEXQlY2TqNj5lKAUEI
         C75CqfqHLgSlNyA5HwHi347YbywTu/8E/9AGI7osHMyymmK8Fmend+KpFxZoSQSr93uO
         mmQHyl8iY0deKJo6imafyTo6jOfQbXAly8v/qcnKTXzVxbtuY4p86Y+JSZDx7E0Y1DSA
         ihrIGhWj6HjPStejg29KkO1fEVlxEWEJr6yX/6NAmBFyI0vAvjjnxdqDAnES15xye/wL
         wemA==
X-Forwarded-Encrypted: i=1; AJvYcCUraI/Ueh8qf2BxXXliqnZV+GIO5PAEdWPKT4qOZN8eJF1RFofilfgdqg3QhsiGgjYC5MKpHb+rP5uE@vger.kernel.org
X-Gm-Message-State: AOJu0YxgQ64p7EOcY/iORFAjtaUHCF8AQydi9HOKw6FNECut/tQ/8vwn
	GZhpzcJyVbtER8NZ6+uLRSybCx2WB//wcXNYM0Cs+EZi99+Y+h4fuGv78bIYLhJgwUw2AkJOz9u
	4/2MXkhndEYqmEasUEi4nZ9F+rfM=
X-Gm-Gg: ASbGnctGG0zN+aSsNRhg06MYDSXJno1O4ILS4dOmGk60SOE+1M+K1V97r0I9V2D1sb2
	QWANNjaYnQXZoumM++siTpgoXkR0x9D7Nnfm6sSdoGVWM2SC0K2u4hPNCAcv+lBG3/1xbL9mchW
	oDxjHGhrDi332GB7HfgDreBi36KmIwlyY=
X-Google-Smtp-Source: AGHT+IEw0HwqiOgkm1QvhEdIhhxGOaz+s7W7Mcu0jlGycow/nUwxpnxjFnTTCIxK1m/9ZSM1tjLL0uKCuYSCcseXWVs=
X-Received: by 2002:a05:6512:3055:b0:545:271d:f85 with SMTP id
 2adb3069b0e04-5452fe65358mr2356557e87.29.1739830983293; Mon, 17 Feb 2025
 14:23:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
 <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com> <CAH2r5mvf8iCpcp0bj29=1y=bDceEPjZiTGZEx9U2=9yYYgAKhg@mail.gmail.com>
 <35d4423c-9714-4446-ba55-a278103584e7@talpey.com> <336ca66d-8655-4acd-b1d7-3f87016ac602@candelatech.com>
In-Reply-To: <336ca66d-8655-4acd-b1d7-3f87016ac602@candelatech.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 17 Feb 2025 16:22:51 -0600
X-Gm-Features: AWEUYZmg6TEjyOw4RAMIlqHAAC9LCjqWbOQwORq4mWvS8Frz6CLjmmFE_F1gEio
Message-ID: <CAH2r5mtqqiGWCC+UcPEq6ExqppP3m=5U5E3BtWqtH42+7XH1Pw@mail.gmail.com>
Subject: Re: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Ben Greear <greearb@candelatech.com>
Cc: Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@manguebit.com>, 
	David Howells <dhowells@redhat.com>, CIFS <linux-cifs@vger.kernel.org>, 
	psachdeva@microsoft.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 17, 2025 at 4:12=E2=80=AFPM Ben Greear <greearb@candelatech.com=
> wrote:
>
> On 2/17/25 1:28 PM, Tom Talpey wrote:
> > On 2/17/2025 4:18 PM, Steve French wrote:
> >> On Mon, Feb 17, 2025 at 3:08=E2=80=AFPM Tom Talpey <tom@talpey.com> wr=
ote:
> >>>
> >>> On 2/17/2025 1:27 PM, Steve French wrote:
> >>>> Noticed this old bug today when cleaning up emails.
> >>>>
> >>>> When the user specifies a srcaddr on mount, the DNS resolution of th=
e
> >>>> host name should only look for the same type of address (ie IPv4 if
> >>>> srcaddr is IPv4, IPv6 if IPv6) right?
> >>>>
> >>>> Any thoughts on how this was handled in other protocols?
> >>>
> >>> What is this "srcaddr" witchcraft that thou dost utter? :)
> >>
> >> The original patch which added it was this, and apparently is needed i=
n some
> >> cases where the subnet the request comes from is restricted:
> >>
> >> commit 3eb9a8893a76cf1cda3b41c3212eb2cfe83eae0e
> >> Author: Ben Greear <greearb@candelatech.com>
> >> Date:   Wed Sep 1 17:06:02 2010 -0700
> >>
> >>      cifs: Allow binding to local IP address.
> >>
> >>      When using multi-homed machines, it's nice to be able to specify
> >>      the local IP to use for outbound connections.  This patch gives
> >>      cifs the ability to bind to a particular IP address.
> >>
> >>         Usage:  mount -t cifs -o srcaddr=3D192.168.1.50,user=3Dfoo, ..=
.
> >>         Usage:  mount -t cifs -o srcaddr=3D2002::100:1,user=3Dfoo, ...
> >>
> >>      Acked-by: Jeff Layton <jlayton@redhat.com>
> >>      Acked-by: Dr. David Holder <david.holder@erion.co.uk>
> >>      Signed-off-by: Ben Greear <greearb@candelatech.com>
> >
> > I still think this is a hack, and unlikely to work reliably.
>
> Except for that DNS issue, it works as intended as far as I can tell, and=
 someone that doesn't want
> the behaviour can just not use it.

Presumably this could be fixed in cifs-utils by checking for the cases
when "srcaddr=3D" is
specified, only assembling the list of host ip addresses that match
IPv4 vs. IPv6
(ie change to resolve_host() function in cifs-utils/resolve_host.c)



> I guess we never run CIFS in mixed ipv4/6 environment with DNS.
>
> >>> There isn't such an option in mount.nfs that I'm aware of.
> >>> And, it isn't documented in mount.cifs either.
> >>
> >> NFS man page does show "clientaddr=3D" mount option,
> >> and it is necessary apparently in some cases (e.g.
> >> https://forum.proxmox.com/threads/nfs-mounts-using-wrong-source-ip-int=
erface.70754/)
> >
> > The NFSv4.0 clientaddr is totally different, that protocol requires
> > the client to inform the server which address to establish a
> > callback channel to. This horribly broken protocol architecture
> > was corrected in NFSv4.1.
>
> NFS requires a small pile of patches to have a similar behaviour...they a=
re in
> our kernel (github.com greearb) in case anyone wants them, but were never=
 accepted upstream.
>
> Thanks,
> Ben
>
> >
> > Tom.
> >
> >>
> >>
> >>> It seems like a hack on top of a hack to match the DNS result
> >>> to the type of the specified srcaddr. If the server supports
> >>> both IP versions and the DNS record exposes them, won't the
> >>> same issue occur on "normal" mounts?
> >>>
> >>> I would not see this playing nicely with multichannel, btw.
> >>> Or RDMA. Probably other scenarios.
> >>>
> >>> Tom.
> >>>
> >>>
> >>>>
> >>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D218523
> >>
> >
>
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com



--=20
Thanks,

Steve

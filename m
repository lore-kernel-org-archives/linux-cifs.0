Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EEA9475
	for <linux-cifs@vger.kernel.org>; Wed, 19 Nov 2025 00:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763510925; cv=none; b=bZpxZB/LtU+lc8aYFZKEZBwOu0G4+DNKeilR773IX53MrDKxO0MPA9XX6Fu8ZQeDHMr60qtx15bopCxYIA0caC1SbXW2k6Jg7LUIRVG+bRm2procDGL1A8xWYQvXfhqFJEi+82TlXHWf8rTBYgMbLDG8wofM5/WWIfiAyUOElGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763510925; c=relaxed/simple;
	bh=58F9PfgKelMJEehp6k3zfXPv5S12cMJeHRS7R7S3+Dw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ZvHNkTW6hYy9FxynoyluPxLqha0ojluElAYukPo4o2NbK1fMeZiqgPowbAQVAn4VeiZP4EaC1b23EdMDxgvJGTUMJq4r3yLMV8TN4bfsSQiCobrXl5eQiDAQtS94+TTuQCwIi0yCvIwo7M0Cnh96ogur5gaz7i6We0kqzEIIWH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lSiECLbo; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lSiECLbo"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88057f5d041so59116366d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 16:08:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763510922; x=1764115722; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W94JZriMgEUJVWomLxr9aeHXHRoN59JIc1YueA0Y2Mc=;
        b=lSiECLborNPx+scoaRBxXkobUgd5Ar0ftmDsnufeuBsu9X1vG4SzUG71OorZ8RXMPf
         KPgQfSB1VTcl5tf/O9DZ5TQ7JzabHLy1OZVQmMWKkQzscfe6/wtBNQlYmVkgWSY/X+8s
         T/5BXfsAdmVjTwTUHyvAxb4IPJd6rlO6rV8NNYSgdMNQinZGnHRpdKSZ0WDdWcaJuVh7
         zqvX5Hkft7zIO3iywrwV7nDdpu+6oviyl+5qUjQQHE6IYT0GDRJRWBDED4kvNrhWZD5f
         SKbCQCNXrG0SwlcilL48/mYAceVQydId1SLfRe6RkeqBdcH10HC9ygJxW+ZZMQhp8rJ7
         B66w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763510922; x=1764115722;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W94JZriMgEUJVWomLxr9aeHXHRoN59JIc1YueA0Y2Mc=;
        b=LjUtXOxIbijsoYwGO+W4U7odsh5jpuhEw8VUlt+YmrWg23fct/Q+uQ2T+kvo+ACZAZ
         NnzKOyWKt3EA24b6I3yhQgDCUyvT0ZPJFV7Z89pJB9JxLDU2hy47+0Yrl6/A5i4/h0QM
         /gvgCBm7b+rLrXy6aULCUWJDpT9ZdZZNf8fsLzJ6c72/KUyM9uf0RTTTYx5spbOUJjSh
         iN7PUOdl7vpewxhGr8lg7r8sP/XQUwAuNDjqWiYa1WemTMcGZ44FsevdDKMgCWl+SC6e
         y51BB71vOMfeVXDuNEYbNhMD3Ow/UGouAAJR2ubnIQ2PCXAAnL+WeMt1kYDEe/7942n+
         vqBg==
X-Forwarded-Encrypted: i=1; AJvYcCUfYzCDVhEtTPdaaS+nAaTVXMnEuixDFbwr0P4Gdi5bSAUxv0x/CWs/uWbQT2UkClCP2bMsPb4Da+Yd@vger.kernel.org
X-Gm-Message-State: AOJu0YxGsG18DuU2mNe03GVVXIquIzjoHOWHF3YXEMVx9FDscpwpOvBg
	WsEw1XtdHaKI6mYycXi52k4dlXIAFIS5Nk0XI0BlPzzXPOiOxYHGWbKYQKvquiN8LCQCtAQO+Pn
	8QneagAvGvS3P9kdfj6IQlQVat76H2Z/wtw==
X-Gm-Gg: ASbGncvwU5Y/oVeYNm2ccA9YRZ50tc4K1XdV3cRGysIHZuSec01fPSr03aSLaDvUlsD
	QbyN/6Ku1RljSrVpqiwxbbbxVK44OHGlX+JlhQXn/MbimJ2qazkf6dzL0Ea5C3xKhWcNvuThpiS
	vCS55T3m9y2MjcvBARo9yhozcwue/2+1AmAog+bKmCNwDPzW+OM6vOhlYUhRhisoww9cUtpqHo+
	ePZzlAXR+gdYmC1Mns6AmkOm2MWLBGveX0bXqeURM7GX+tLMGZddnxkWrKhQYtpnCEM/bFP6BSm
	RJZfyGe/B2H8W6owDh+DKNVaAzzY96HMKPJ65bT/+llLqQxc+4t1DFyfo93YaZUDKT5V+88WPkr
	cp7QlVXlkNgU5a/bSl0jBtYc7jSt/zi+rm2qB2QGsQTv5BBy0DG/i7QP17zjWkGrEm56X5EVTV1
	f7SllDc6UgSg==
X-Google-Smtp-Source: AGHT+IEareUYWMb9eMEPxiXUpNCgvERyl+uPJraGVbzznqXjC/xqzTgDcH5UiWVSejpamYHsOJu6jHtyYpOJ18uQFII=
X-Received: by 2002:a05:6214:f2e:b0:880:4f97:d17b with SMTP id
 6a1803df08f44-882925b26c3mr240638936d6.19.1763510922382; Tue, 18 Nov 2025
 16:08:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5ms6CEykTOCFyJ4GVx2hBGX3EzrtNwgE4z+2_+LuYASRAg@mail.gmail.com>
In-Reply-To: <CAH2r5ms6CEykTOCFyJ4GVx2hBGX3EzrtNwgE4z+2_+LuYASRAg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 18 Nov 2025 18:08:29 -0600
X-Gm-Features: AWmQ_bnHizEjya4WdL9153ruAB5KL5WSA7fa31UU8wpMfkZ_KMKuOrNF6taG4ew
Message-ID: <CAH2r5mvxS05AKK4XbMR_mvnjAdfQOurvrXvZqLuJmvGd7OYyOw@mail.gmail.com>
Subject: Re: Multichannel mount failures to Samba depending on IP address
 (single channel works)
To: Shyam Prasad <nspmangalore@gmail.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On a loosely related note is there a way to configure the "interfaces"
line in smb.conf to be "everything that would show up by default AND
localhost too" (man smb.conf indicates that localhost and 127.0.0.1
are filtered out of the interface list by default - but of course it
works to mount non-multichannel to localhost)

On Tue, Nov 18, 2025 at 5:46=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> Saw an interesting multichannel failure scenario to Samba today:
>
> Samba server smb.conf has
>    "server multi channel support =3D yes"
> in the [global] section but it does not include a line for
> "interfaces" (uses the default)
>
> On localhost, mounting to current Samba from Linux (tried various
> versions of cifs.ko so does not appear to be a recent regression),
> noticed:
>
> 1) mount -t cifs //locahost/share /mnt                                   =
 worked
> 2) mount -t cifs //localhost/share /mnt -o multichannel          failed
> 3) mount -t cifs //127.0.0.1/share /mnt                                  =
 worked
> 4) mount -t cifs //127.0.0.1/share /mnt -o multichannel          failed
> 5) mount -t cifs //192.168.1.190/share /mnt -o multichannel   worked
>
> When mounting with "localhost" or "127.0.0.1" as the server name (non
> multichannel) note that it does not show [CONNECTED] in
> /proc/fs/cifs/DebugData
>
> Server interfaces: 3 Last updated: 3 seconds ago
> 1) Speed: 1Gbps
> Capabilities: None
> IPv4: 192.168.1.198
> Weight (cur,total): (0,1)
> Allocated channels: 0
>
> 2) Speed: 1Gbps
> Capabilities: None
> IPv6: 2603:8080:2200:13fc:c82b:b16f:52c8:2329
> Weight (cur,total): (0,1)
> Allocated channels: 0
>
> 3) Speed: 1Gbps
> Capabilities: None
> IPv6: 2603:8080:2200:13fc:5b60:a7d6:77d7:72cc
> Weight (cur,total): (0,1)
> Allocated channels: 0
>
> Note that when mounting to "192.168.1.190" (non-multichannel) it only
> shows two instead of three interfaces (not sure why it drops one of
> the IPv6 ones) but it does correctly show [CONNECTED]
>
> Server interfaces: 2 Last updated: 1 seconds ago
> 1) Speed: 1Gbps
> Capabilities: None
> IPv4: 192.168.1.198
> Weight (cur,total): (1,1)
> Allocated channels: 1
> [CONNECTED]
>
> 2) Speed: 1Gbps
> Capabilities: None
> IPv6: 2603:8080:2200:13fc:5b60:a7d6:77d7:72cc
> Weight (cur,total): (0,1)
> Allocated channels: 0
>
> The mount failures with multichannel to 127.0.0.1 are weird - the
> first negprot/sessionsetup/tcon works fine but the second negprot then
> sessionsetup fails with the server returning with
> "STATUS_SESSION_DELETED" which seems strange (since the session is
> valid, and channel one session setup worked fine).  Any idea if this
> is a Samba server bug?
>
> Presumably the workaround is to add an "interfaces" line to smb.conf
> to force it to return 127.0.0.1 as a valid interface, but this still
> seems like it could be a server bug.  And quite confusing to users (as
> "Resource temporarily unavailable" won't make sense to them since
> single channel works fine) Any thoughts?
>
> And log messages are unlikely to help the user figure out the server
> config (or bug) issue.
>
> [12421.964837] CIFS: Attempting to mount //localhost/test
> [12422.032199] CIFS: VFS: \\localhost Send error in SessSetup =3D -11
> [12422.032234] CIFS: VFS: failed to open extra channel on
> iface:192.168.1.198 rc=3D-11
> [12422.137163] CIFS: successfully opened new channel on
> iface:2603:8080:2200:13fc:c82b:b16f:52c8:2329
> [12422.137401] CIFS: VFS: reconnect tcon failed rc =3D -11
>
> Thoughts?
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve

Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C50D28C006
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 22:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771367680; cv=pass; b=iaMo0vljAfpKr2iASlzwKQ913vGQXTmODxGgNl0UJX7YRwJTheJJSomql00tRtwDOqLPcSTGtrRollE16VBQxkc6qPpF7Qk7mmHqm/gaGAY88J4DOJu7xK/g8TuHWUUBN51bMHRkTc6kIV/H3wq2Z4Gi6dbYVTXJ92OmfRDPpXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771367680; c=relaxed/simple;
	bh=IMPigmx7RO/axJBUTfV/VQEOJJagu2+u9L2biqqNjDs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DEoi6wiXDWCH8zyWycYZDxkDysuzj+pLa8nvWaq0zyOrSFspVRC4CsfasYnbk8JYIEayXToTlwSPMIBF24VwVgNpZMOw0k2zPOG2rAnhnRmnxAxCq42w/bXOBuVBw6F9eQVyII13WbwqottlzqbpkL2VAT+y1ncr6ewumYu3/+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=On51LtDs; arc=pass smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="On51LtDs"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-896fcfc591eso46282146d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 14:34:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771367678; cv=none;
        d=google.com; s=arc-20240605;
        b=APGeGXvbx/GRpdVrpOwn++R9Zsvp9w79DSp6GyQB6vcLPHt9eJFlX1wCt6w1Hh+ymR
         37pYfEEIq8qzX/UTEt/dpmsHaTWtWKF3kHWAO9XNybqO3X1VSb9gQ7n8jBv5LVVarTRo
         upoYKycAFbWyF8YhS7GDrXmzbl4hrqqgErqufU8evcmyjizYao0MWg5i9aBTctpl/ivu
         BQSGw3C6rNjz5PnC4//uLi7bMSUO5JMXTqNvgN5wpKNv4eLARf6mvtNwXYVLh4Xc+WC2
         e6L7ROE81yCDYLVemfFWtmiTZyhH52EgGs6s7zgVZOAbLCOUcodjUA9MDslg9uQcBJSB
         egYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HNwPRT26lkwvhqgnuQm7jDLq4NRWV0QtCBubhLBxY0M=;
        fh=6aAC8ffY0/zFaam/d8UYqNXU0LtY0My9jRDsyo1Ka48=;
        b=cBNJaV5mONxLyE/d9fFIZvaR5HSGKTk4U8J2qUUHJiRZESVme0oD4JpMVz5KurN7Hu
         yZm856tWURLyx92MgyPWQ42jNf6BIzgtGS+CW2XJppffUWws4hCDlpxohbDC4WAbnaja
         iUDZbtZXJz778k8JuclJp4AHy6FRBYJOsurgSk0yn004zyIMkXUFsi/nADRXOGsuejeU
         ejFF6uyBMnKD/5ETmGSrxt+CDZI2Qpla+/N9wrqq0QgupdLbBCaereSVmyNrJMs+ywPL
         2FfsNgiXLB3dH9P8l1zPak2J1BqclJPou8CaEX0knw+mg680+UlqQSFMYJF/XOkBI6VS
         DteA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771367678; x=1771972478; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HNwPRT26lkwvhqgnuQm7jDLq4NRWV0QtCBubhLBxY0M=;
        b=On51LtDsiYEnRHIbGC1nqkJg1f75HGEDloc1VW8Fb1NVBjZe/B6upqVL+xxPX3Yq0H
         5mLAIAG9mzU3TpAXVM7fhFTIB69A4gSnFYdM5SomIT8/B3tXtTn4dYQcNVh+BOMg990d
         SN9DF0uI1v3HVHHVCCAnbrNumy+tbTn0WALyBthXcvcfUPwRCJpoiFC7ALAqh2sjNJJ9
         V+4xTiJeeYXzCoLCmLlUfRiN0eHec99gnw7CiqwOjxAW1HYZB4v/CuoyZCUe7DFK1Tsg
         7G+cFjRvf1BzTGJSm9S+jIH5jGExYaOLICLhdzt7OD0tLmewvjj8c9abiuAOZIRLfhzA
         IApw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771367678; x=1771972478;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HNwPRT26lkwvhqgnuQm7jDLq4NRWV0QtCBubhLBxY0M=;
        b=cnGkfq/Z43SSCcKYpvI34K8acZGbfyoaZ8f8Cb2DEcWnJoWF9LJUj+cO05sUsH3n/4
         Q0v1LitW/I1oFd7G+YEZ+t1gWU9TzFFb0D3wnl5K0+AFSaVkzF/RcwAbh+TwhR8bsppB
         ORrbFX2HtWJSoc5MHuulRBLMDf14TWUZ5tyyFJhxfcSjMOV1EoDAvejWI3iTs/lh8Dq5
         cxrdnHNGUihMWbK9m8ng8YBm+wRElx3fjHijUuszbQhIObo2McmmDRMLhUVkC7yEFwfO
         JjoYUGdUHTO21lQdwLE68UXiqK7J3NkIuFO4ZlVZ14rSWdii1P/DEQF3HBq362/MKKvM
         GkSQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlsiHPK3Z+1maqJXzTQ29tzlhu0FxgTa813n7+2J2BGyffXZvtL/YHM7Ng1Zr5J8h8kG2QJGJigd9H@vger.kernel.org
X-Gm-Message-State: AOJu0YzbJb1p+Bn9TJB/i90VZqFzRm2TVn7Bq0oWpoJkDZa+OuQrxMS+
	yMcgulhRxtR6sGBERYU+ud76hJL3SCbWV5ZFsjss2OPp5sGgj4rTrfc8fPQCLV/lE/PkslzSTG9
	Svqcl5qPWtVyobpODZvaGW8BnGWFAEUY=
X-Gm-Gg: AZuq6aIKN4cB//m26xgZwpVRz1uJT8b500ORRnBYteicGZ7cUBKw76rpa/stio3mP0t
	rldOZYCe8vZLU5kt6q15IBh7jKf3omHjfqb34bDQiCGcYEPl6dZR0ZEM9iL8IfDX6QaWv8zN8eL
	px8oft4OCy2LUtFgtoMBwQk0U1xiQH1AhQGkNXxDiEl16dTSlwy4Z1QVSZTH1TtB4ciQYmTygb+
	0hsnaM3josvA93/q3NTwoYenvgRm+v5Ik6MDKtdvN/LtN26oy4UtHjcNT4rxR7pMtpMgUEXhT6X
	WC0gTmIAQRjFxLfAbBNtm0fl/JKx4MsVDuO6n6BelZFNiFux08JXYSVksSF4nkUZpogQGr7Xr3E
	Kyani8k2U9LIf0ZcJmWsyt0vmgiD9SOkXqkudC6dHt8i3Wv3XhEpVNHuJXwqNIHLzpI+/c1QBKE
	/JckD72ta+lQeyACsZpmgT6A==
X-Received: by 2002:a05:6214:1cc4:b0:894:6510:4946 with SMTP id
 6a1803df08f44-8973488141amr226640436d6.10.1771367678229; Tue, 17 Feb 2026
 14:34:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1770311507.git.metze@samba.org> <CAKYAXd_CqpqXnh+k19NVdgQdDAnp6k5NbPqcyd0anocBJrGd_Q@mail.gmail.com>
 <7140153c-7858-474b-abe5-aee69bd196a2@samba.org> <d5d0ff21-83ed-44b9-bd3c-3cf3d2b14fc2@samba.org>
 <CAKYAXd-vGej9K53-06iy+p6nVSDLuwVU_+41R=7EUfbTjx=O5Q@mail.gmail.com>
 <CAH2r5muf=Th_AbA7SZaQKApyvr81FMB8WF-5yZ3ihzap1swQWg@mail.gmail.com>
 <98d25ce1-1f1a-4517-89f0-8956bffaf9d3@samba.org> <CAH2r5mswN8W652Br4QQTzhtDXtXKvqea=dWVfUFF+xDYfOx6HA@mail.gmail.com>
 <28d94c9f-b85e-4746-bb08-188090409682@samba.org> <CAH2r5mtA=DdpEiyqspNG3eoyjkGajnEwoRnOyXyBimDtCND9ig@mail.gmail.com>
 <c5aef237-2a12-4be5-b917-de502780be85@samba.org> <CAH2r5msAAN-EgOmRnoO7R4RPu2suNr+mgk5c5JAj9b-_kjwymg@mail.gmail.com>
 <237aa80d-8bd2-4dad-9975-85e11e2bf1fd@samba.org> <CAH2r5ms2EYJMm+764mJ2nLZRBz2R7+5LAeKfxZ1mb13uSSoYiw@mail.gmail.com>
 <CAH2r5mvmLYjJnxZmH3Mdawpk97Os7Zk9t_m=FrVOAXALNTw7hw@mail.gmail.com> <880038e4-f339-496a-8845-f7d3a7f3b5c5@samba.org>
In-Reply-To: <880038e4-f339-496a-8845-f7d3a7f3b5c5@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Feb 2026 16:34:26 -0600
X-Gm-Features: AaiRm50kh9SlPDfouIqUIQvY2jJ7WJ9_ts9X0zFgonbf9ZfhV4Wca-jZ7MILeRY
Message-ID: <CAH2r5mu28FLAwcS9=ej21enwo3aAYWsLCEvNGDc66p1p9Y0P7g@mail.gmail.com>
Subject: Re: [PATCH v5 000/144] smb: smbdirect/client/server: moving to common
 functions and smbdirect.ko
To: Stefan Metzmacher <metze@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>, 
	Paulo Alcantara <pc@manguebit.org>, Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, Arnd Bergmann <arnd@kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 17, 2026 at 3:25=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 17.02.26 um 03:16 schrieb Steve French:
> > I noticed build warnings on two files when I build with your updated
> > branch. See below:
> >
> >    CHECK   client/smbdirect.c
> > client/smbdirect.c:97:1: error: bad integer constant expression
> > client/smbdirect.c:97:1: error: static assertion failed:
> > "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
> > client/smbdirect.c:98:1: error: bad integer constant expression
> > client/smbdirect.c:98:1: error: static assertion failed:
> > "MODULE_INFO(parm, ...) contains embedded NUL byte"
> > client/smbdirect.c:104:1: error: bad integer constant expression
> > client/smbdirect.c:104:1: error: static assertion failed:
> > "MODULE_INFO(parmtype, ...) contains embedded NUL byte"
> > client/smbdirect.c:105:1: error: bad integer constant expression
> > client/smbdirect.c:105:1: error: static assertion failed:
> > "MODULE_INFO(parm, ...) contains embedded NUL byte"
> >    CC [M]  server/server.o
> >    CHECK   server/server.c
> > server/server.c:629:1: error: bad integer constant expression
> > server/server.c:629:1: error: static assertion failed:
> > "MODULE_INFO(author, ...) contains embedded NUL byte"
> > server/server.c:630:1: error: bad integer constant expression
> > server/server.c:630:1: error: static assertion failed:
> > "MODULE_INFO(description, ...) contains embedded NUL byte"
> > server/server.c:631:1: error: bad integer constant expression
> > server/server.c:631:1: error: static assertion failed:
> > "MODULE_INFO(license, ...) contains embedded NUL byte"
> > server/server.c:632:1: error: bad integer constant expression
> > server/server.c:632:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:633:1: error: bad integer constant expression
> > server/server.c:633:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:634:1: error: bad integer constant expression
> > server/server.c:634:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:635:1: error: bad integer constant expression
> > server/server.c:635:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:636:1: error: bad integer constant expression
> > server/server.c:636:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:637:1: error: bad integer constant expression
> > server/server.c:637:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
> > server/server.c:638:1: error: bad integer constant expression
> > server/server.c:638:1: error: static assertion failed:
> > "MODULE_INFO(softdep, ...) contains embedded NUL byte"
>
> I didn't change any MODULE_INFO() code, I guess it also happens
> without my patches?
>
> I saw something similar with MODULE_LICENSE and maybe MODULE_DESCRIPTION
> in the 6.19 merge windows.
>
> And it was a bug in sparse.
>
> I updated the version I use to this commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/commit/?i=
d=3D2634e39bf02697a18fece057208150362c985992
> which is one above https://git.kernel.org/pub/scm/devel/sparse/sparse.git=
/

Good catch - you were right it is a bug in sparse tool, not something
you changed (I had to upgrade sparse since it wasn't getting run for
the last few days due to requiring an upgrade).   I added the fix from
Al which fixed the incorrect warning.


--=20
Thanks,

Steve

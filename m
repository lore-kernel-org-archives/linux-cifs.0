Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADE1283FCE
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358007; cv=pass; b=qnCQ8HW9Y4kdWl87qt/Ab3wcki+vAHJm8gIDnILf8o99ylWqb32yFGjK6cZfIY8zpokKetWGuGEp0ptE8FLu8Bvb+U7ZS9Ixz4Yf+DGH1/ZxYW1FDz1puV7O/8IK/RRL5GWI+vr66h0dmlebG2x1Y9m6SerH6ZvLrPX7TJZjt3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358007; c=relaxed/simple;
	bh=5j/awRA5XHusFyJzqg689JPdFbRBXQJnr5+AsaOzyj8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pysOOWZdp6tHmTmygPaYKq2REDyEhTozwCFqKiCOgdDQF95tuGThPbvf8XMaOsTeECMecJuY2QySkq88G7M7qsVJmtdXAY5QdXO1KPiLwMgkbepYjTRzALl9vrtJSl8FFcCzTXpwltf8N73sO0vGKsP3oT7oBkkXLszf0X+pubY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bD30uho/; arc=pass smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bD30uho/"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-60fbeeeaa7aso2702494137.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 09:46:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776358005; cv=none;
        d=google.com; s=arc-20240605;
        b=alp1zoekFEd72C6Iy8X1hnB9Y6FBBsjvQ14DNZaR6EEKuBpc2YmB9IqUpIe1TYjrv8
         el/PMSprK6eCSLYNljzC8+aotE3kt8ErgE/xnIIUqqKyKFlcT/qxHWgcvlW7AJzQ77Eh
         UfXeJ8kAfAW3QUAytC5G9BJ/YPcvniDsiGue8y8CHRmx7cKE2ltgntSzXiU/c+Z6+mFb
         0qTdhtei/GNNGZaWdxruh40ICO+OvmqkvIvdxyGTLEmjFJtkc6R/zM8XupeeF88VB0BZ
         C4YOLeOsysE99EeCm1HIYATbYugi4zPdeXEWJwlHzlCvyouuK5nWn7m/OGIoHvzA7D3I
         bs2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pH+9LuXJ919QNepnip/0qzlMUT3suCi5eWWg8HrTkOE=;
        fh=vF3jXCffqQRt+u1KMKoSn9h5j28iylHllTSIVvJAfBo=;
        b=VVTQEF4vumvC6dBJTT0WUvG1OZ42IIwFOFlSSHOqzTdQBCwEgJALDdDpRDg2odVBZM
         7b4FsoGGhWSDNaURLCytQpMqqfrsb2MwU/cVtp4bY68NAcus8QJwwlPlZbMEn7end7o/
         SqPzyzJ9Siwjh+OtxFbOJffzge9La56G/4oESsptN3zUHEoIfMZMAfsxjxngWTxjJTlW
         7DG46aWylMpbesNCdW3hnZBlM0rnqcqxD+2MxoxlQe9uTWWhTKKFFcfheBTkcOSHEFu7
         xYkNZZWcMweVKe4Wt8RXgS+mio0BZjIix27OBP+I5zjcWyBBs3Z/Tdk3c9JLBpFYEats
         lGtg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776358005; x=1776962805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pH+9LuXJ919QNepnip/0qzlMUT3suCi5eWWg8HrTkOE=;
        b=bD30uho/zNknud7S+y3PuIKJwEaOpE21aiIa0vKDnnFzR+IFx5FRexB2latvbTlHHF
         jS23eja4u3/LgTrG8YXEmfUoXZTzKXP2YZcDvQM62XFqLZptcCuupoOMcsyKBDkUUBAs
         ARygAnxhhpVxpSHtcqWPePC2tAoGdLdZELbqRaxxL2OhEQ0rsrhpkYoXwshpt91T01m9
         AEcRPAW4PeS9Gm5Y/nQhHctG9huUYQ52bjTXIc3uzCdD12NYOlMoT1S82gs7dXyYS6bj
         7pSnJ9i66tfIjnsgyslDWC/Ael9cuY3/8fCmRvYK7Lvt2W3bLbO4bdL/YX9ykNzezKbs
         uIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776358005; x=1776962805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pH+9LuXJ919QNepnip/0qzlMUT3suCi5eWWg8HrTkOE=;
        b=VPHVXpK282Mr8hu9JT/fGx61Y+w0ch3RG698hJ7jbYwu+ke2rXZoLKzcn4oiHIHOCn
         PcIKzcIrZ60RzPXimTqxYrHyHc4X4iw/jd2PLRhdN2vjDR/VucRb5V4YvlO3nh8hNd0P
         rCKVRNS6rc36g8chJmxTJZph4hHzaM8Znj+EAWLrK5u34vdhmjQW0sHraeeyTcKMPuMe
         iUFgsd0R+hoMVwUAplnwWkvc1VypEWcuprhzarheVH5gj5qSHwV0SDjTIyvjiIXjmtCH
         el21a9Zdd5YhI6EN4YNZ6beQpVcXZlg/XpGNlKv/w48GOIUH/AI9VHXYQBUn7glKMC0m
         lZpw==
X-Forwarded-Encrypted: i=1; AFNElJ+D4femP9x+GLMGtpdDsHWQ5pt4KxjzrK2759U5xwtUZec2rxEl7vngTLJTYoyIgFwRTdSlJ9D98UzT@vger.kernel.org
X-Gm-Message-State: AOJu0YybARErk36BLfpOIp8tQcb6nVoywU3S21YFYqCiVsj88JwjhLmx
	FMYxP7JqdaTNYbKoy6otG01h1lYWtT6T9/21lrAbsFlMQdjPxbaNKf1RuHvbs20YycheFeLMphf
	SAJu+dc5p2HdM0wErp6eUgWS0hAHcqkk=
X-Gm-Gg: AeBDiesn8iynY8XG/8kl7a4AkwYWrPbVgR6YScygNVSUIdaS11Y+GGq+gfXdlQu3peR
	8pXKxSWY35q7iv/V/GjAnZEcdOHQL9NM7ntRXrTCAoY0X3W5TiElxw6A7UzywRrYyibMCVmyloz
	s43JOOS4qH/cLg5s7+r03sMu+eyai3En2zSlpptHiys5W/XAUuZAgr/RkbsCRgaAJLAS+gCi2Ac
	3Z47HTgxAcaK9cEd4zhH8s8diJMFb4UtEaaIT7Inj8mq9xWk4GqsllClzAUz0sFVsvAVI2uM6Dz
	qRom1GXjm3vpd5mnjetgQHO3/So/jwkegagO8nWIKQ9hhWG50kXoFGYR21jRdYj4T7AyVU1ZqtP
	rh+/M07j784XtT2K7XlaLh2rbFRkAZvlU843hsYavmxsTeYd3KwU2ZUxi2kgmbH+HHuafHwP+i2
	aax0d2dvuz2k3w4YnOu2+5wZikXTBARn6Boo7tUvdA8Cc=
X-Received: by 2002:a05:6102:26d2:b0:5fd:f2ad:c653 with SMTP id
 ada2fe7eead31-60a00e44498mr14450267137.16.1776358004819; Thu, 16 Apr 2026
 09:46:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu2+PGJER79PJpPVCysoEEgCsyuzuCKCD9LzZSHQnhOSQ@mail.gmail.com>
 <CAHk-=whmue3PVi88K0UZLZO0at22QhQZ-yu+qO2TOKyZpGqecw@mail.gmail.com>
In-Reply-To: <CAHk-=whmue3PVi88K0UZLZO0at22QhQZ-yu+qO2TOKyZpGqecw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Apr 2026 11:46:33 -0500
X-Gm-Features: AQROBzCTbQQkfDzGvG8LCEvko8GhVMYlfbfHzw4SclHkX2UdVk4R3H8HQGm-eBw
Message-ID: <CAH2r5muO_Qmw+fBDGyZayGDhVciY9v4xnaxP3rF7QF89_Uxb-A@mail.gmail.com>
Subject: Re: [GIT PULL] smbdirect ksmbd and cifs changes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 10:37=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, 16 Apr 2026 at 08:04, Steve French <smfrench@gmail.com> wrote:
> >
> > Move smbdirect server and client code to common
>
> Pulled.
>
> I did want to ask why you ended up with that very odd directory
> structure? Not that it's a problem - I don't expect that I'll ever end
> up doing a lot of pathname autocompletion in this all - but it just
> looks so strangely convoluted...
>
> Just to pick on the biggest file in there ("it's not fat, it just has
> thicc code") that also has the longest name:
>
>    fs/smb/common/smbdirect/smbdirect_connection.c
>
> why the redundant and complicated naming? The *point* of a directory
> structure is to structure your directory contents so that you don't
> need to name your files odd ways..
>
> And yes, it's "common" code, but it's a big subsystem of its own, and
> got its own subdirectory anyway and it all could just have been
>
>    fs/smb/smbdirect/connection.c

That makes sense.  Will ask Metze to make that update from
fs/smb/common/smbdirect/ to shorter path fs/smb/smbdirect/


--=20
Thanks,

Steve

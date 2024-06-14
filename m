Received: from eproxy.izw-berlin.de (eproxy.izw-berlin.de [62.141.164.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5EB14830B
	for <linux-cifs@vger.kernel.org>; Fri, 14 Jun 2024 11:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.141.164.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718362936; cv=none; b=Yz2fXIFmtkG9gjmnxe55qm8ySbiZqmxnN/M+6Fg2/WjpDBERGZJeAgNd7zppHcyoveYouH4G/XdRqRgOB1w13tZ+0VZE3IZ6TM7VIQOgf5hd/3qWcqhhHK9GRejJVuWSpydgLYfbWfbwB/oEoECnVxKVLLMvRrTEm+xsEa/euPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718362936; c=relaxed/simple;
	bh=fPZEXXC3yjjlmeiucbJ7tr0D8awAsufBLi899c++uzE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QbaksDp5Yh1m/yyiSJ4rmxwQ6B3pm/8oobPsyoRH7Tifqdn0eW4zXQ2k7didjQy8Y5no0T3epNO38ptcFeB/sg2FcCRE1E9AbbRYNEm/C2WysDOfxs/YhhGibMV9TwauqFpjLPzJfUtupkVy0Np0MlmsLKh1DJs6fwQ9dXeRfn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de; spf=pass smtp.mailfrom=izw-berlin.de; dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b=rAHMevJj; arc=none smtp.client-ip=62.141.164.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=izw-berlin.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=izw-berlin.de header.i=@izw-berlin.de header.b="rAHMevJj"
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by eproxy.izw-berlin.de over TLS secured channel with Microsoft SMTPSVC(10.0.14393.4169);
	 Fri, 14 Jun 2024 13:02:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; d=izw-berlin.de; s=p2024; c=simple/simple;
	t=1718362926; h=from:subject:to:date:message-id;
	bh=fPZEXXC3yjjlmeiucbJ7tr0D8awAsufBLi899c++uzE=;
	b=rAHMevJjNGSfxa0h5GlBIqKPD/VZVSPKfIqK+1sJ2nf0BhwfQDEW9zWte6FZG6ntwfBW53n+3EZ
	S8ZMli9aZfaiiS4sjd9DXiQG/dLz9CZ9sBt3gugARq+OnFs0CT0nMuw1zMDgg/mRX0Z9jCbGh7dYO
	VqVVESJNmfAglYQDwmY=
Received: from izw-mail-3.izw-berlin.local (192.168.2.11) by
 izw-mail-3.izw-berlin.local (192.168.2.11) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 14 Jun 2024 13:02:06 +0200
Received: from izw-mail-3.izw-berlin.local ([192.168.2.11]) by
 izw-mail-3.izw-berlin.local ([192.168.2.11]) with mapi id 15.01.2507.039;
 Fri, 14 Jun 2024 13:02:06 +0200
From: "Heckmann, Ilja" <heckmann@izw-berlin.de>
To: Enzo Matsumiya <ematsumiya@suse.de>
CC: "dhowells@redhat.com" <dhowells@redhat.com>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>
Subject: Re: Crash when attempting to run executables from a share
Thread-Topic: Crash when attempting to run executables from a share
Thread-Index: AQHavkpLSV40U19kGEKeMUGSqVoUAw==
Date: Fri, 14 Jun 2024 11:02:05 +0000
Message-ID: <8f407430e3254611bdcd4ddc880bfd1a@izw-berlin.de>
References: <55a38b4f4da449bb9da403d4f58847c5@izw-berlin.de>,<zfyfkb4zhatmzxcggdhuk2expapwetgqigdlku6ohq72bdtv3i@tx6uzncfj7jn>
In-Reply-To: <zfyfkb4zhatmzxcggdhuk2expapwetgqigdlku6ohq72bdtv3i@tx6uzncfj7jn>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginalArrivalTime: 14 Jun 2024 11:02:06.0269 (UTC) FILETIME=[4B6616D0:01DABE4A]

Thank you, Enzo, that's promising news! And thank you, David, for the work.
Compiling and installing a pre-release kernel feels above my skill level, b=
ut
I'm looking forward to trying it as soon as I can get the stable version fr=
om
the Arch repo and will report back.

Best wishes,
Ilja

________________________________________
Von: Enzo Matsumiya <ematsumiya@suse.de>
Gesendet: Donnerstag, 13. Juni 2024 19:37:06
An: Heckmann, Ilja
Cc: dhowells@redhat.com; linux-cifs@vger.kernel.org
Betreff: [[ EXT ]] Re: Crash when attempting to run executables from a shar=
e

Hi,

On 06/13, Heckmann, Ilja wrote:
> ...
>This is what the smb.conf looks like, without the (hopefully) irrelevant
>domain membership and printing settings:
>---------------------------------
>[global]
>case sensitive =3D yes
>delete readonly =3D yes
>map acl inherit =3D yes
>vfs objects =3D acl_xattr
>oplocks =3D no
>level2 oplocks =3D no
>min protocol =3D SMB2
>
>[share]
>path =3D /data/share
>read only =3D no
>acl_xattr:ignore system acl =3D yes
>---------------------------------

Thanks for the reproducer info.

>And here is a crash record from the journal:
>--------------------------------------------------------------------------=
------
>Jun 13 10:08:13 server kernel: ------------[ cut here ]------------
>Jun 13 10:08:13 server kernel: WARNING: CPU: 121 PID: 3906695 at fs/smb/cl=
ient/file.c:3341 cifs_limit_bvec_su bset.constprop.0+0xf2/0x130 [cifs]
> ...

That's not reproducible since v6.10-rc1, probably because of David's netfs =
work.
Can you try a kernel >=3D than that one?


Cheers,

Enzo

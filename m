Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0835A1F9F70;
	Wed,  8 Oct 2025 21:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759957230; cv=none; b=IusmwSw/McZ1J2eyZAMYeYljwDpcGGW7VFT2D/zU/7I8mBSZ75sA6ZfEDUSHt1KJIrUQiWimtjp0ZoT74Q44WmnjijcZ/necdmKB5+F6IAq+dj9c5PSipSWswKySHlFcABeuhICpCxqhVSlANwgeYVgUMztwi49JVc3HVZWcP/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759957230; c=relaxed/simple;
	bh=e87bG8v1WTGxac/uoC3grZQJr0znPQJvQ8t4+oDeR/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=snAAmwS4+i4p1T/5u8qIHksUleYpuEXqmUZqxJdNQsTOoTYXFnTQZyALywp8dv8Ku61cuXzUiQTXmijR42krypPYIew5bxv0t3HlucxOtfKRo6c5nbDPxwI1auMY4PALNspE/V+N0g1COI9Xuosuq9QgCQYhDhV5UGSsOMdnLp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=f+Imn/Rv; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="f+Imn/Rv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1759957214; x=1760562014; i=markus.elfring@web.de;
	bh=e87bG8v1WTGxac/uoC3grZQJr0znPQJvQ8t4+oDeR/s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=f+Imn/Rv8YQq2xk4Cr8A6zTloWNdrlLRNiwStshmxfo6h1Wq0ji4meoC3UQrvlDF
	 rtAvlm/dDZfd98++7uNyvZtagd4RDJpWOPkUWZ0wVpiyjgm0qjJ/TaHpQcX1slTxy
	 NKzbqslHlJtd9SRQ04CqUMDG4fWZhxZu/5dHWLZ8N0p4Af/NUmlYJ0ORLh991nbc6
	 Ki44gq0YRle+hyx2KFpUtMmQFN6plkJJIizHDMpbWxZanq5y0TnjssU2FHmnzdlBL
	 mwtcAfSOswHqQNhitdwAROK9b52mKGCvyf8mRnWzuUOIbvivZxawrWiRy+fDGJBZT
	 owXDUSGdrLfTWxgwLQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.249]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MnX5T-1uNgD50Y4b-00Zf5R; Wed, 08
 Oct 2025 23:00:14 +0200
Message-ID: <99546145-8c6a-4e26-a787-b5c9bb0b8613@web.de>
Date: Wed, 8 Oct 2025 23:00:12 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Move an error code assignment in
 smb3_init_transform_rq()
To: Steve French <smfrench@gmail.com>,
 Henrique Carvalho <henrique.carvalho@suse.com>, linux-cifs@vger.kernel.org,
 samba-technical <samba-technical@lists.samba.org>,
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>,
 Pavel Shilovsky <pshilov@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>,
 Tom Talpey <tom@talpey.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors <kernel-janitors@vger.kernel.org>
References: <02627021-da2f-41f8-9ea7-fd2da96e0503@web.de>
 <5bd37df6-1743-4b9c-a83a-a811e221489b@suse.com>
 <CAH2r5msZjL_krwN-nd1Ly3skxAHK9srJehPJ_vYXPLRFXpJ_yw@mail.gmail.com>
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAH2r5msZjL_krwN-nd1Ly3skxAHK9srJehPJ_vYXPLRFXpJ_yw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wesrHUFO7r9xF7dBDhSH6eNe1qWVlWEHS55pVwO8vpIlgLhaWa5
 ifQADtK0lKhrni0DiJFtCUVtmLNQJ8k39BMaqKMMNXyDFa7U5/aIPrTA8OJJGzLJWwPBMaL
 QKEyvBBMIrrvydwew+LNHbvmzVMLENm4CycRzZGGqevvUBc0pMXQLPWHM00axvViu0Nodo0
 R0PKPEVeQhciXn6yyejHQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ysYbaSs7CKM=;w4vDVf+I30nAnB2sh50cVxev/6L
 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

> Also when a patch doesn't shrink code, but even grows it by one line, an=
d doesn't make it much clearer, it is probably not worth changing (it comp=
licates future backports of real fixes in the future eg). Let's limit thes=
e to those that shrink code and make code clearer (or ideally fix potentia=
l bugs)

Do you insist to keep an extra initialisation for the local variable =E2=
=80=9Crc=E2=80=9D
despite of the implementation detail that the value =E2=80=9C-ENOMEM=E2=80=
=9D is needed
only for a single if branch here?

Regards,
Markus

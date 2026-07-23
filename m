Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7769733F374
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 07:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784791265; cv=none; b=QG0o++GeT35ejp5YhyfFQsldbo++4Y4gQUshQR6QmSfkL+q1JzPZFLKOaD2DEmTH3RLtSDYJzM3VERaw2v772HD+Gxr37elWUKcE1BPw1YUhQzDDvGQtiV3zZ+O8XHd9afLEogKwXlz212KNRN8oODCT/Xl0Rgg/j53PNy7X6xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784791265; c=relaxed/simple;
	bh=bpwEaFJF8IHNdZKc0UEvGZcchL8IEa5vDLScMptvw1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sfBusEhqV9SocGdXO7jNmTpOfKc/evsZpB/M2qizgar9Ad5CT1KhSGCPnPHOsL2tQhMumWEYOb0H8xioUGokLJxOEARHpdRd7ojncaMMOJzEqgiRZtNOSAL7w4XWsVLuoa3BXWNWKTV8Eqos2RHJm1yZaL9TN1UOuRWr/gKH6gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dHaeqlW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dHaeqlW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A111F00A3E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 07:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784791264;
	bh=bpwEaFJF8IHNdZKc0UEvGZcchL8IEa5vDLScMptvw1I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dHaeqlW2WpIOSfObjIQnf+pTRckPrgMzywG/VG0ZzV09YuTH1vIPzqPLiE+a8RJOz
	 u45F6sw6Hb9l4x1D8VRYGP95+qZf3CGpC+mqDdGikfZ8VKDm+lUM4qpyiA0JTexEVQ
	 a4b4fVj6knE1XsDFweFV3j0hzhmmWXiug2mtPxeVKuIbdI9N/k9MwviCskKbBvV80e
	 2RcJiUrKM7Sh6QJONFGVwiJ2x6mywM4lsBMf0A1Acsh3dEP6T4n8EyWw+LFP/QrbT4
	 zceMJVsGL8wTqyS7WDR1NDHY+VPCE86F2L/8/YxzBQAcyZ7TRWI+g8REpIbpt46epa
	 7Eia4Lozy9BQw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1600d040e4so18131666b.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 00:21:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoNhwquHISfpXS68pxSCQsrh+FvjXYO+MCUspyuM1cR0pIpcfaGIvSL+CQ5X3BG4JSGCD2gTK+HZulT@vger.kernel.org
X-Gm-Message-State: AOJu0YzVyE+V6Ul+hRvQXIYC8/luOqNKYBYSXYx1gIKn2Hh3YCpPmKuO
	64VLEI9DasXCq2Z1HOLSdzxhm/D2sVNX2MPQmMryLSChwT1KHdyzFPmn4GmE9LGNlgciQMOS0YO
	XFlfPGu8+tST+Kz7MR6pF27pIZWgAReI=
X-Received: by 2002:a17:907:9619:b0:c19:891c:e1a6 with SMTP id
 a640c23a62f3a-c1c536c8d6emr71127766b.12.1784791256656; Thu, 23 Jul 2026
 00:20:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723041131.313321-1-chenxiaosong@chenxiaosong.com>
 <20260723041131.313321-4-chenxiaosong@chenxiaosong.com> <CAKYAXd_X5JSh8YGk5Z8-gx2A=PDcmW74jKK8co=z=9Zxty5xSg@mail.gmail.com>
 <ce461389-2b54-4097-9f7d-409107e08e1d@chenxiaosong.com>
In-Reply-To: <ce461389-2b54-4097-9f7d-409107e08e1d@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 23 Jul 2026 16:20:44 +0900
X-Gmail-Original-Message-ID: <CAKYAXd98ByZ_Nr1wBRodfeA7HCKNFe2bGQ25u5JHEL5XoxsDBA@mail.gmail.com>
X-Gm-Features: AUfX_mxx1QbTcCPIzG15bKkTptBQ2TjLNJdmtZPVkm3C2fhitC0APya_ptObadE
Message-ID: <CAKYAXd98ByZ_Nr1wBRodfeA7HCKNFe2bGQ25u5JHEL5XoxsDBA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] smb/server: stop new async work when closing connection
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 3:58=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> I agree with your patch. However, could you split the changes in
> smb2_notify into a separate patch? We don't yet know how Ga=C3=ABl will
> update his patch, so keeping those changes separate would make things
> easier to rebase or adjust later.
>
> Does that make sense to you?
He needs to submit a patch aligned with the current base. We can't
just wait since we don't know when Ga=C3=ABl will send the patch. Also, I
made a mistake. I should have set the author to you. I just updated
it, so please check it.

Thanks!

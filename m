Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A184826290
	for <linux-cifs@vger.kernel.org>; Sun,  8 Mar 2026 03:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772939774; cv=pass; b=sMwdCHzznzF9Yb3N52Yu3HZ7SqGPlonoDrvZgaXF3nJCKibxm6RV+N036ZqHYLDe//AvwKUDhK9cVuxGGVJRQTk0ER7R+tNjfxyE+eaS4JQfn3VH6h6mp9k3JsPfFKbh4/RidMfdfG7qVpPKeZJQjPUptVLxRWipnzt4MFeVddc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772939774; c=relaxed/simple;
	bh=ptzar4KSz4wDw0/vkUS+kMwJguncsiZ3qv0bP0rP4k8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X+P98G9VVBerOZ/qUJP3Lvy3AWJZEb7L+0AHQrr5dHT4zBiMTE3F02/DhkCZmUGsL+B+X8Cx63nGjJ87h5XY4ykw8ZjurTxidx11LOo+NVcs2if3T0HLcpDz9wZCaWp4qAx+I2k5e3BodLKEEvw0+1yGKd/zw3WFlUj0qIk9MSw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EMJTZH16; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EMJTZH16"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-899fa9610bbso112598856d6.0
        for <linux-cifs@vger.kernel.org>; Sat, 07 Mar 2026 19:16:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772939770; cv=none;
        d=google.com; s=arc-20240605;
        b=H3WSCjo3xcI11guVSGshESbJKktTAMHTk2H7E65/5CYCjV5pxDH785TrJCt3dFBAA8
         h2lrbNFuAmeAhOe32pu07kf+1hoKMvjoIpm/KIcPc/1LXjKsmeOzsObpGxO9oOkDgoti
         VcrY7JZ2MmmjFZBjFw4dT5T4un4wPVLF69wkynxypZYGEK4J+Tn+I2XtHfoJemROUDwy
         ML8BMd2r1mm9+oNfhx7ZxdKgFKPhX8lbeLbedV/sl5eX7kx6cHRiYwpbLXtVnmv6qOm3
         SRt0Xv/U41vTaJKCasnpRrnuVmPOVTBcybNfB/V9HDs6eKbYpuEt2S1uz6iyzoqBrMBz
         shhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DOFvOi698kZ3+WmDT/JcnKnyi0l9JGMA6IndtCIf/dA=;
        fh=VPhPvacu0UDJ0h8htZ3cwUmRqiQIJ2UruAHyj/Wpo9I=;
        b=WSbmyJd/EPhHYWi9OYy6zhoa5NEhNfx6+73eV/+Ancpc2wZnYO2S2/+v/nVRfRt3la
         xjf3nUA4CXkvMsU4H4+Qxy2ZTsstq6AuROOcQ9mmDCbdnoqou7LzNe5kRnpfV6MhhLQn
         AgEZK5Q14qpp2MFPQLQbqIlEIEBKWnJe+JwLAp6Qq/JTh4SS2BoMECb6vEVt/tZUrMoa
         fEZC8DQbuPezaQBO3SaDpbawEn7htOSBCpg4psutJQj+Sq4LZgugx089KWPafKs2l2W8
         sRvLfp19QOQhfapmq9s+9pdtZIGcus2MHwojVGgA+zC8hTeqcuqcya/Ztb0TFkmeoyp8
         YqyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772939770; x=1773544570; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOFvOi698kZ3+WmDT/JcnKnyi0l9JGMA6IndtCIf/dA=;
        b=EMJTZH16rPi2Yr3RJ/lquKPqXjf6uQZlOMZLHVk6diCORZNGe+Z32ktTzkPD4JKHZu
         WpTQMUP9cmjTiv7TwbHNc2jQtt8Kr1/vQ7FyPTfjamTK8g1K/7+yynEK5FrtSz2XYtvG
         SICigWPnk6exqZgMUY60s/jKTy4ViRAPoMcycl0nMwup2l7YFqcibKXqbFlIO+WGspzm
         YRiOrTRcz8FtJ7UmdR0m23U5ePEzGcYqAj84EyP4i47Bd2KP9yu6iYNMwW4GKzberfYR
         RGYcLYJSOgA0F01ZQKrWZGBEHZDIjomrgDUkWRBratbayRsxDcHHbAN3HYbKoNTluG0j
         Kdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772939770; x=1773544570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DOFvOi698kZ3+WmDT/JcnKnyi0l9JGMA6IndtCIf/dA=;
        b=jUBEzyKdA1Srw3g64zokxCLu9/DLYvpIcULBnu6CWlaiaqxMUDtjve/i5/oy60zko4
         Z05EiquXRy1tC4khUn23S1QmyCvE7y8gpeFjvKs585I4XXGKN2CtySgdtB9lfbk2FDld
         HmBH6vzscWP9zGbHn7ljPsoe9J7Vjc+yspFaShOxvs4323rr1kt9zQ2Po/NrY2J2AI4X
         hxBKeBK+o9RB2RS67cu0fI7xRDQi3JM+q8m/UP/Kh/TxRJZSaQc0q2cxQDaTH6t4VU8t
         T+2dZNtymIkGPniVXO0WJuv9919NmVO0XnFLD/dVOjwB5iiR/277rjTiY/yq9k1uVDJD
         dHTA==
X-Forwarded-Encrypted: i=1; AJvYcCU5/rLs8ImIJDL8Y1iwM3n9z4YIXE8leNR9E2/dCKaWyBeaQ8wbzyol66rWMU+5UuJBEY5kGvB9W4NX@vger.kernel.org
X-Gm-Message-State: AOJu0YwAKfgFy2qMpkQIWCAxBAv/7HBB21ZbvYpEi59ZqK0N0ZD6pCxm
	KxeBNh1l/73kZJ+O9qkbaRTsuFLUD0kk62m96duCMqH43Y4jNohAPdjZO1vhjAz44nmQlY9eB44
	K0qkxmbOraMUv5YGMO6Ov0qRfXExJciw=
X-Gm-Gg: ATEYQzx81HcmS7vLGy2PyKfhYBj+V8OTadUiHX9y47V59jI6BmljCYu+wuXZLDGOdOX
	qasRYI6KATEX4HG2FX+N3prpow+8KDqrzJftVOa6+VL7tqQXBWEUjXcQ+KcaCulHl+TWWt+wsUT
	sXUvWKN24h2t/FQV/FSRIr2I9SvLycEHqw5ndzHphyEYwB/BXKhXpqjusC8EExJ7wKR5ywhvZ2z
	5iw+2uhRfcND6TXuHO7eUSRAZQ4uTkzDERXj1Ck5+N6iNkZD6mpCBglCqGigPbjT4VwL4/kyZPb
	VFjq9HiqRhvxiEhNf/rt9j8OBYr2FWNAfXQvEkTbM4acfFZfOc+FjFQxKIRYYd7FrcTjRNt+0lq
	5zffwhiolfc74zJt/PYdDYJYl7dOXzuWfZ47mALntC5LLV1aEqKCMmn1AE2E/Om66FuM8njpqRi
	DYebytMiL5Ng9EByCLsV5DOw==
X-Received: by 2002:a05:6214:4108:b0:899:f841:da21 with SMTP id
 6a1803df08f44-89a30ad68bamr107245266d6.51.1772939770511; Sat, 07 Mar 2026
 19:16:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306150717.483742-1-arnd@kernel.org> <8fa24f86dcbe2ef367b3e35fb6e1da5c@manguebit.org>
In-Reply-To: <8fa24f86dcbe2ef367b3e35fb6e1da5c@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Sat, 7 Mar 2026 21:15:58 -0600
X-Gm-Features: AaiRm53meeFRXBHsZooo0fkJ53yZ_ODO80fc4lQAv4-XiJlyLYH8XyL5rwaX-ZU
Message-ID: <CAH2r5muoUuTMOFMe0RrvQugUy0uw05+9H0bKJr0sG6Z1HL0xJQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix sbflags initialization
To: Paulo Alcantara <pc@manguebit.org>
Cc: Arnd Bergmann <arnd@kernel.org>, Steve French <sfrench@samba.org>, 
	David Howells <dhowells@redhat.com>, Arnd Bergmann <arnd@arndb.de>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Henrique Carvalho <henrique.carvalho@suse.com>, Markus Elfring <elfring@users.sourceforge.net>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.

Added the Reviewed-by and merged into cifs-2.6.git for-next

On Fri, Mar 6, 2026 at 9:17=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> w=
rote:
>
> Arnd Bergmann <arnd@kernel.org> writes:
>
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > The newly introduced variable is initialized in an #ifdef block
> > but used outside of it, leading to undefined behavior when
> > CONFIG_CIFS_ALLOW_INSECURE_LEGACY is disabled:
> >
> > fs/smb/client/dir.c:417:9: error: variable 'sbflags' is uninitialized w=
hen used here [-Werror,-Wuninitialized]
> >   417 |                                 if (sbflags & CIFS_MOUNT_DYNPER=
M)
> >       |                                     ^~~~~~~
> >
> > Move the initialization into the declaration, the same way as the
> > other similar function do it.
> >
> > Fixes: 4fc3a433c139 ("smb: client: use atomic_t for mnt_cifs_flags")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  fs/smb/client/dir.c | 3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve

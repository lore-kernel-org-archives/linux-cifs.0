Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B76A1D89E5;
	Sun, 17 Nov 2024 23:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731884909; cv=none; b=rszqueViOgS6w7RMAw4bbF3UxOXbYmaKwwdN3e9R0gsxqWmo6zqCWQMu3217u+53iokKDNvkS8t8DOGmyOH0gHZRdK+kmZSsVA07x/VmNxJMKe7smAGrwncGzbPosBylOqn7F1EiSSmu9TNpXoP8TD1XG6ZZqqUBUFf137PPl+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731884909; c=relaxed/simple;
	bh=qc//Rp6FgcU/OzykKOBKbEI0fB9iPhKctaTJW5N31Mg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pML2QmJnO/kFAEa4Gd2T4we15zWHJeXcw3EiAfqBSaSggekZUGsTWzXbvDVrH38V9SnP3FuAI0Uw3tgXuzXha+ARi3NkqO8wR3LjUbalwRxNDcICTtfLx3pu8ENzUX8ENgPMwxiCENY6+RfVPwDlHDVcMZdgLH7SyqaVukHoX+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHK6hhMu; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHK6hhMu"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53b34ed38easo3591120e87.0;
        Sun, 17 Nov 2024 15:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731884906; x=1732489706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MNN7ziIzHnkd18GYio7H3EiJ5Cg8s0kx1zTc8dpUr6c=;
        b=eHK6hhMutEUnhXkbiJqwd3lYmt3Clrzs5DrfD+pCo1YbMxAAHAIJwVKB9GBD1NVTkg
         ZWExkwWPCE5FNjvybQhbIEP126Kvnx3NAQtazuIVhN5xbqqmRGC0ATyNz8x2FDogAATi
         rDvQBuNymvxafMzAdhI5Kn/Ih+naJGnM+JXE4x3aLAwRL3TB1GotmYrUSA0WrtepT9LJ
         9V555bJpqFySjjx7N/WAW2uicj8kFbL1tdpZFJT5TcLX9FRd/BxrqAiOxlb/7w05ejAT
         WT0enUo3QgS7ACD9LRdRIzxkmdE86WLqdOndGYwL5HmTleXYlwAhLRyRmq/KNdBBFoPZ
         yqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731884906; x=1732489706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MNN7ziIzHnkd18GYio7H3EiJ5Cg8s0kx1zTc8dpUr6c=;
        b=L/DYOB1Zbuls1z+3Zf2T9BHZ5TsB+C3myHdt5yTCHydgdmn4Vc/3pzuE1HQLpw/Rza
         EeWdVzr1vlGtt/rcf/+8vj7AxX9wpoTiuCvSxNnjaTF4j5tt8Lyb7g4JTB2qcauRANrB
         nGRSl1btusc3htRJGx8x1S/ylsbvqgFrSqUGrqsyqQQyehVOLmuDvYY8HLO7CiMMwowy
         DJcnit7KLg5AgPjy216z4KlqGtwveML12+XJxw0kGoWFdOXU1t/v3i05yQuZpadRttiw
         6Ux5ygghbC4RMfucOJHBoBpgJvtdqD5G4PTJgKQRm0TqeJBFLL3KXlowpCAP37F4cesN
         QY8w==
X-Forwarded-Encrypted: i=1; AJvYcCUuFs/g67o38gkHDmYotLYciSpd0AjLNnJd02TRHG18BYHEvlnQEgxFPdtgoI7yf5DHlVDgFk/s7v+tYLYyqj3B@vger.kernel.org, AJvYcCVJ2kIlbK/UZI74Nf0uP8ElWTj99JFA4Oqbmvd0tjnsA7wDzm58/RkTk3ZlSN5tzl6V3VXkMueiFt+V@vger.kernel.org, AJvYcCX8JNEYnxVjSRLRIM1Qeu3G6TaxeR94SlkNeOEevWbiEyYOtqDmsVwMmtxiGZRhdfwKlf5aUBaVXJIeHX5w@vger.kernel.org
X-Gm-Message-State: AOJu0YxeZBLmw9iiFlMV4x3HUB78WScobf9t6XfUYlS8eI3yK2M5D6ch
	hdDuD5Xfoez0cw1ukZCju77dJAZw9oD/JejGSwLgAlwa5L9koJLrEjBQNuyu1N5+l+Yg+MCxFGL
	QqcQvgVvFyMBDVyeo4XfkWzpBFS0=
X-Google-Smtp-Source: AGHT+IG/Q4t9zlJxo0SzEiq1OWyQAiH8D9mhKsLHtjK5w2rEQERHHK17Ean2SepEZ7MUtCVHaZhXmMnoKX3qNPyE0Gk=
X-Received: by 2002:a05:6512:b83:b0:539:f9b9:e6d2 with SMTP id
 2adb3069b0e04-53dab3b126amr4424699e87.35.1731884905418; Sun, 17 Nov 2024
 15:08:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241117113204.work.419-kees@kernel.org> <bcd4fb0f-47ee-4676-8e71-6b06973e9b65@embeddedor.com>
In-Reply-To: <bcd4fb0f-47ee-4676-8e71-6b06973e9b65@embeddedor.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 17 Nov 2024 17:08:14 -0600
Message-ID: <CAH2r5msDZjC_iktAhCn6jxhUVQZ2sXrD8KpbCs-woDriZNDmXw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: memcpy() with surrounding object base address
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Kees Cook <kees@kernel.org>, Steve French <sfrench@samba.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Sun, Nov 17, 2024 at 1:15=E2=80=AFPM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
>
>
> On 17/11/24 05:32, Kees Cook wrote:
> > Like commit f1f047bd7ce0 ("smb: client: Fix -Wstringop-overflow issues"=
),
> > adjust the memcpy() destination address to be based off the surrounding
> > object rather than based off the 4-byte "Protocol" member. This avoids =
a
> > build-time warning when compiling under CONFIG_FORTIFY_SOURCE with GCC =
15:
> >
> > In function 'fortify_memcpy_chk',
> >      inlined from 'CIFSSMBSetPathInfo' at ../fs/smb/client/cifssmb.c:53=
58:2:
> > ../include/linux/fortify-string.h:571:25: error: call to '__write_overf=
low_field' declared with attribute warning: detected write beyond size of f=
ield (1st parameter); maybe use struct_group()? [-Werror=3Dattribute-warnin=
g]
> >    571 |                         __write_overflow_field(p_size_field, s=
ize);
> >        |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
> >
> > Signed-off-by: Kees Cook <kees@kernel.org>
>
> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>
> Thanks!
> -Gustavo
>
> > ---
> > Cc: Steve French <sfrench@samba.org>
> > Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> > Cc: Paulo Alcantara <pc@manguebit.com>
> > Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> > Cc: Shyam Prasad N <sprasad@microsoft.com>
> > Cc: Tom Talpey <tom@talpey.com>
> > Cc: Bharath SM <bharathsm@microsoft.com>
> > Cc: linux-cifs@vger.kernel.org
> > Cc: samba-technical@lists.samba.org
> > ---
> >   fs/smb/client/cifssmb.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> > index b96ca9be5352..026d6b5f23a9 100644
> > --- a/fs/smb/client/cifssmb.c
> > +++ b/fs/smb/client/cifssmb.c
> > @@ -5337,7 +5337,7 @@ CIFSSMBSetPathInfo(const unsigned int xid, struct=
 cifs_tcon *tcon,
> >       param_offset =3D offsetof(struct smb_com_transaction2_spi_req,
> >                               InformationLevel) - 4;
> >       offset =3D param_offset + params;
> > -     data_offset =3D (char *) (&pSMB->hdr.Protocol) + offset;
> > +     data_offset =3D (char *)pSMB + offsetof(typeof(*pSMB), hdr.Protoc=
ol) + offset;
> >       pSMB->ParameterOffset =3D cpu_to_le16(param_offset);
> >       pSMB->DataOffset =3D cpu_to_le16(offset);
> >       pSMB->SetupCount =3D 1;
>
>


--=20
Thanks,

Steve

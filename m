Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A956256C84
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 23:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764115164; cv=none; b=gw6u4BDSyo9wVH7FjnSXQbVOgj1agaTT2gyjYXt/zML7VnQnfdWRoRM5OAqdradeYvzYHV4cgWwRajH//6f7+G1ItlYePgA4jlEpPwD3e6N/X+jXXG/WIBlbfvm8mwaoGlgWNoAfLz8elT8p0S02He1TxKj1oe33tvAxWpBDN34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764115164; c=relaxed/simple;
	bh=RovQq1KhcIqyH6tmSHlLo8msvWJrI2AjLdxdreD11qo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rNG/lbHh6fWCEWRPWdeZQ67xOhRW1N+tfngZqLFel/cpXMURXy/WQx64Xym285dpvRQPnOdd46TXs/h1dTomM66oEKzRt/7VkK554xzoegRsA/e239SQ45Wyf6Zd9+w6WEZupPHAfnkQaDcVTGSorPqEHIDa3BdQW55JqIdiDhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U2tjWbTj; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U2tjWbTj"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8824ce98111so94717586d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 15:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764115162; x=1764719962; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LGKAbXSOb/hIN/3EXOfiiEv3A7Hp4O1wFMrKhdxoDso=;
        b=U2tjWbTjdirFao59AQ0YcM2zFFoeCBck29IcmEaOQqhoTrxKnwsXuPvcKpqutMDISs
         BFPvOyHzj64i0Yu5VNCiDngCkp0bY1za/Kumaw+iDUeMbKCGaSuHbXo5ogbXGfXfIoSm
         wAkXsDtep5hgU3lemrLFObJJ69fCFcGMHLIO7+G82tHbHYEt/ltUwj7MYSOLsqjxWOAB
         MQCiwjHcDr31M5MNe1C97q7vKthybQohEmAYl8XjLDkxH8iXY7BGVc8UTpIqFPwZZuEa
         JILswsyIDKWGkNOvlAns32fS+W6hrw3VQI5436tyDhmj1MCg2gr1JSzu0NUNJe/h34Zp
         PqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764115162; x=1764719962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LGKAbXSOb/hIN/3EXOfiiEv3A7Hp4O1wFMrKhdxoDso=;
        b=vutSDGei8rUDKKdZWCN3hyNm2KcaCCuhGczZizz+L/hVoupFqpoBuxBP36jHeif7qq
         CIYgDRedbc0WWNbSCbZzO5nWJngrXlR10JqAnU14X5C3h4pCVqIuA4qw/vHAMy/zj147
         CMGWgMYyJ6lbXITgR9sbtp7cxJKhs59d5XmxxzENkkjvz8L68O+UAeAjsN+k3oog35CF
         p5g5gGVBTHHKAuO35AE1EED1IiLWDnfq56My+ivTLnNwvvYZ0dDwtWhj4tPGciIBSmbN
         AHW3Jf2iYY1ZbpLIQNEmlU7eipicOwAHUmeuu7v2xh0gu73CK3Pd3CAopoiR9tcmNzZR
         Vb2w==
X-Forwarded-Encrypted: i=1; AJvYcCUxjkXl5meqbHgdvOM3/VtNE7AWht/jCF/7bj63ptQFvo4Vv5g4cAmioGDMxqbia9nAdLfsR88C21rI@vger.kernel.org
X-Gm-Message-State: AOJu0YwSUQUsLii52pkUu544ngQy5WfzT6WHmsXJPaN4gNZdWyit6BKW
	3RezAXA42ms5PkOLuj4n0eJ7JmK2137Ctgmrrw6GhslMJKQMnsC1909IW0yDcQJWyC5DdFIo0s4
	LAEWOuNj7Wy1A1oHKeTeeHwUsEdk8PLo=
X-Gm-Gg: ASbGncsdmByRp2VBXuxz6TFKNZJjLvCmxFiRyG1O1X3kPRR1aLy1sUXbuDhE+2iXF/r
	nCwUxV5vbzqumpsNxa+kHlsn6sAbNiJg4Q8rC1sZgm8Qu2EVc8zofknYmiovE4GuOkn08LkOJh4
	Crwv3xGEMIU9gXXnyUjVoQpAS+I3Ix+5kZK167DoLg+i5Cm8DXjlWAi4piHU/tKSrZ0eekFBq35
	l6ER+AueyVKiInttTaTVzTRXEa9gxSzJ0iW5aoJAPBcyNiUzqNFwaXzUbab/7EGKMZWcE7L0lgD
	GUh1a8DozCA9+aJM0i06VxfYTOLOtHVn5VrMwqMLimi4LBHO+fq5i+3ROaQpAv6Nzi7/A7Qn4af
	YKa2h1OZepBdFJcZ0/2I3YPsp9ZFjs9XeNEgfTg0PClQeqps3rXAxMmjCdY3au/qhZEabteakqZ
	3k4QNw0TfO0DT89sY7wKNb
X-Google-Smtp-Source: AGHT+IGvGBuP3gj1SzITT5yPR2BBx6IbHMF7PVeMxEYas9l4hy811l7wO/nNXAm0PljlOCe8AHwUQ0nz9gaJMntdsT4=
X-Received: by 2002:a05:6214:508e:b0:880:298b:3a6d with SMTP id
 6a1803df08f44-8847c515c4bmr283137986d6.35.1764115162003; Tue, 25 Nov 2025
 15:59:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251125195541.1701938-1-pc@manguebit.org>
In-Reply-To: <20251125195541.1701938-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 25 Nov 2025 17:59:10 -0600
X-Gm-Features: AWmQ_bmprbLgOxltibCwh_wV-OG1URFYExJL_Nr4aLpjs1iyFt2y0OVllv-h8HI
Message-ID: <CAH2r5mutuLO4s6azh8g7D6Xs286mW_NyptEkF_6X3Uy4kY=FBw@mail.gmail.com>
Subject: Re: [PATCH] cifscreds: fix parsing of commands and parameters
To: Paulo Alcantara <pc@manguebit.org>
Cc: piastryyy@gmail.com, Xiaoli Feng <xifeng@redhat.com>, Jay Shin <jaeshin@redhat.com>, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

added to cifs-utils for-next

Do you know if this is a regression of cifs-utils and if so what release/wh=
en?

On Tue, Nov 25, 2025 at 1:55=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Fix the parsing of '--username' and '--timeout' options as both
> require an argument by fixing the value passed in @optstring when
> calling getopt_long(3).
>
> Also fix the matching of commands by breaking the loop when an exact
> match is found.  Otherwise `cifscreds clear ...` would return
> "Ambiguous command" due to "clearall" command.
>
> * Before patch
>
> $ ./cifscreds add -u testuser w22-root2.zelda.test
> error: Could not resolve address for testuser
> $ ./cifscreds add -u testuser -d ZELDA
> Password:
> $ grep 'cifs:[ad]' /proc/keys
> 198de7a1 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:d:testuse=
r: 13
>                                                                   ^^ wron=
g desc
> $ ./cifscreds clear -u testuser w22-root2.zelda.test
> Ambiguous command
> $ ./cifscreds clear -u testuser -d ZELDA
> Ambiguous command
>
> * After patch
>
> $ ./cifscreds add -u testuser w22-root2.zelda.test
> Password:
> $ ./cifscreds add -u testuser -d ZELDA
> Password:
> $ grep 'cifs:[ad]' /proc/keys
> 089183a9 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:a:192.168=
.124.32: 17
> 0ca5ed80 I--Q---     1 perm 0d0d0000     0     0 logon     cifs:d:ZELDA: =
17
> $ ./cifscreds clear -u testuser w22-root2.zelda.test
> $ ./cifscreds clear -u testuser -d ZELDA
>
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  cifscreds.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/cifscreds.c b/cifscreds.c
> index 295059f9683d..e8713be23d71 100644
> --- a/cifscreds.c
> +++ b/cifscreds.c
> @@ -71,7 +71,7 @@ static struct command commands[] =3D {
>  static struct option longopts[] =3D {
>         {"username", 1, NULL, 'u'},
>         {"domain", 0, NULL, 'd' },
> -       {"timeout", 0, NULL, 't' },
> +       {"timeout", 1, NULL, 't' },
>         {NULL, 0, NULL, 0}
>  };
>
> @@ -477,7 +477,7 @@ int main(int argc, char **argv)
>         if (argc =3D=3D 1)
>                 return usage();
>
> -       while((n =3D getopt_long(argc, argv, "dut:", longopts, NULL)) !=
=3D -1) {
> +       while((n =3D getopt_long(argc, argv, "du:t:", longopts, NULL)) !=
=3D -1) {
>                 switch (n) {
>                 case 'd':
>                         arg.keytype =3D (char) n;
> @@ -507,7 +507,7 @@ int main(int argc, char **argv)
>                 if (cmd->name[n] =3D=3D 0) {
>                         /* exact match */
>                         best =3D cmd;
> -                       continue;
> +                       break;
>                 }
>
>                 /* partial match */
> --
> 2.51.1
>


--=20
Thanks,

Steve

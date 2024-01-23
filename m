Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4DA1292C7
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 18:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706035630; cv=none; b=FDVw3Tc3clGLrFIrt0uEkj4/HsUYKGjszqEyN8vyDurfXxnIMYvnCwsBEX832W93VMZ8eZKdDHVLJ9NEP60FO05w8kThXOj77nZJXBuYaJSWaGZ6VT5WLUbo3H+/4k1t8cIPJAkURADrcCW1c97b2jjzPGCsB3WA3TDJON/Wn1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706035630; c=relaxed/simple;
	bh=rvv8B+EUkuG9XUz85jwOiDZufKlw3Qe4JjWocxZYNlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qxrHQ1i5wdem9KkuQyeUvTMAYVMBamTOlBYz99huQtgcHp74SNFifKnwQeKqF+099SD7EMArZdfSmxNkC/G0vLA2WQepc1V7nI2fMJchR3c48w9CRm2++KM5K4V2Y0DLsqtlXQtkHJ6t9BGv22YaPFT1EhazKmzwcAC+SvxnZSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gQqrsK69; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gQqrsK69"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2cf1524cb17so10654981fa.2
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jan 2024 10:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706035627; x=1706640427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R+alqpYEA8OUjHgdr41ksd+PSXdMXnhYwFDZnUtyr6c=;
        b=gQqrsK69im36htKBdGlzE64qu+pEpUps9MUEHLaEf+b82Rz7tvJKhb18ERECytn6nO
         euWv7+pp2ODvkF/eOw25AgiTGTCAH1UOrJTKDcuezn3azfaMPeQIj6MQye8f4D1fNATN
         9FCiYhvhU1T5W7/c8qCt4hpgvmRYLYE64Ob4zXMCFbuWikl9g6ezEBRK81UpzR0tn8wd
         py4KNhwMRsMN4glcAUaU9iqhqlev+kI9ZCzQ32s3AX2olwPDu8KhnvQqzhmQPAQV/J8l
         Op/iXBMY+fc8OBl1s5SJ9haJnVLaD8gW6zmYLqQ0OLXR2GfTp1iVf98Dlj6T0+z/nRQT
         yZqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706035627; x=1706640427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R+alqpYEA8OUjHgdr41ksd+PSXdMXnhYwFDZnUtyr6c=;
        b=IPzVTI9ENLQTkloMpIWr+/b61JiaVqh9o2n1NN5lNKyD13AVTz/HxrCzIBzNv1T0EY
         YSzD/knMUlUe/qQyCuzAwTWk4HVrDuAbyOY9xgeUBTew6Ua9KJFQLy3xJhzoUbY4EOYP
         0k+HP/qELzsWXhpO6pPsq6QGSzkcqeTw6hLcMQSTA2q43KWGSaNEkBVhkWVe7Nsfi9ck
         OrSROm0GV0ss0qtxFitVrFZdJ4lxxZbV8IrkA0Kg1UMYMkRuR9xIIl2lhEu6RO5xLFsT
         6vwXNIklBztmBUmmWvaSs7IeEsI6lrn+T35F5la+1uiXICDj7hxSGInOq8V9Zq83WyjJ
         TTtg==
X-Gm-Message-State: AOJu0YyvPYz5vaAyvnQ5Kkz7FfdjEoZMD7Je3Fv6pKrFSplPlUdVhVto
	dkcsW+XjdQruQVtUlZ9OFqsXD7DEshavlJu8p9J5LrbNHAvLabv8cxrohf49rpckSEp8h1xiT8W
	V45bo3hbXgHeBObYOuZaGpHQf1L13gwav0R0=
X-Google-Smtp-Source: AGHT+IFlFw1AgABJtm948YHXXklzyodXyfu50PMz8nFuk9ixFMGowkvh4hgMOvnYHPw1r6yQLOWktSZBG42DD5HpnUA=
X-Received: by 2002:a2e:97ca:0:b0:2ce:dfc:db7a with SMTP id
 m10-20020a2e97ca000000b002ce0dfcdb7amr136319ljj.1.1706035626487; Tue, 23 Jan
 2024 10:47:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <e7b45a71-c973-4672-92b4-490864fdbe26@p183>
In-Reply-To: <e7b45a71-c973-4672-92b4-490864fdbe26@p183>
From: Steve French <smfrench@gmail.com>
Date: Tue, 23 Jan 2024 12:46:55 -0600
Message-ID: <CAH2r5msODGpoGCr=8K2nTixZmk6JZx-13p+oBix-25YL9CzWtA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: delete "true", "false" defines
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Jan 23, 2024 at 4:40=E2=80=AFAM Alexey Dobriyan <adobriyan@gmail.co=
m> wrote:
>
> Kernel has its own official true/false definitions.
>
> The defines aren't even used in this file.
>
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>
>  fs/smb/client/smbencrypt.c |    7 -------
>  1 file changed, 7 deletions(-)
>
> --- a/fs/smb/client/smbencrypt.c
> +++ b/fs/smb/client/smbencrypt.c
> @@ -26,13 +26,6 @@
>  #include "cifsproto.h"
>  #include "../common/md4.h"
>
> -#ifndef false
> -#define false 0
> -#endif
> -#ifndef true
> -#define true 1
> -#endif
> -
>  /* following came from the other byteorder.h to avoid include conflicts =
*/
>  #define CVAL(buf,pos) (((unsigned char *)(buf))[pos])
>  #define SSVALX(buf,pos,val) (CVAL(buf,pos)=3D(val)&0xFF,CVAL(buf,pos+1)=
=3D(val)>>8)
>


--=20
Thanks,

Steve

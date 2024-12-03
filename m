Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4111EE039
	for <linux-cifs@vger.kernel.org>; Tue,  3 Dec 2024 19:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733255832; cv=none; b=lJlNwamcoFt4NbarQHwXs1fYHJ9XWsbQWuagjoiB355uzaWyjqShW9HtVy25yOanQVpoVMK6rokPtdjeYXLf0kejNZ7YVel9zotndeiqUXlAGOmwcFLArQAwWlVwhZ7HArvQ4d5Wz32vKFxZoCkrxTxSrJELpKl0GlsQO0gSsB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733255832; c=relaxed/simple;
	bh=o4VXrsabOPrOP4PVVdBj4riTfFvhUmbVNFNaAvv2dnM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c3OQ43kv3yo4JQ11wFToLwKdSXCD2VoyurT00vM8U1O7uKpwVK91ZGUXC4hYAd1bfnj6B0q9/susdLpUYbga051ToX6Du0MrsDgwC7/v/QV8dIKWbV18cPdRdvUrprSEX+bQY2lhMl3mYaAMPGqkIZH8Uv3m2kl8sud2SD+ZA3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ievlv1kx; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ievlv1kx"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53dde4f0f23so5991542e87.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Dec 2024 11:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733255829; x=1733860629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DaKPq1n2g+VtTLBvOTa6a2vq3TuIvBVmwT6IEq+/UpE=;
        b=ievlv1kxT0aaHlD+A6LOY8gaieN5PKE2OD7BuQkPEj7KZwnYXDV6HG0AGjTrpZ2UBT
         H7INW3M7fjwcOELU3RJwfXhn2anJJ8jJ/8R1O269WNMuXE5oFmjX+27dhEVQVeIEX8gY
         pBUZENpSal3yffJZD6qqy3k5SZTKWgt/xFUU26P4jDSAGBDcP7LxImWYaxL4d/r7CyL4
         H5GW9ENxelGPnZIL0zn5+c9WLDZ/ze87qN4hvZ12Ww0qWQXR9rAHW+Tm4r+eWPMf5yPh
         RgCD/3U/p9aXC10/i9as+uhqtYgqM57kEgRf7tvHtuOYJOR7W1D5cnOMSuSH7PgP663j
         vRhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733255829; x=1733860629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DaKPq1n2g+VtTLBvOTa6a2vq3TuIvBVmwT6IEq+/UpE=;
        b=OUKmR8Sp/LJvLvkhnHU4P30tpqqUAK6dlJaBm9khp1XjSVPjOkAxmEZ3SQ9RTqTrqY
         dyTr+IiPac4slxUtvM+4PzSZRhT4STzr0NmR1BzBP/Q/nbWbRuRzgLsIb+1iJ1iQW+0k
         oMlgl+FqE7d4rC8YnSLGA080CF6AFYp9yIUBtd09hbcTbLLOqUfnDguToOai5UoBcwIn
         3wnAc0MyoXLsjPFCKIsUb2R5Gt9jBQNIJPwewHSlNelfsF6vEfwnJ3r+AkjUQZ5l9HhQ
         0F7jOyc0WNs6YQyuU9wnRD0iafrKdDPhiOAO8oiV3XFlgR7w20a4JWbbr7hU35RSkE3b
         xVNA==
X-Forwarded-Encrypted: i=1; AJvYcCUaPiXTDmA4z+w2eXmInv4BFbFB5LeBjoSQJegxUIBOspXklNPp79ntJYDylT/7bRJhVZgdUZj63J9X@vger.kernel.org
X-Gm-Message-State: AOJu0YwT2G4ZeTpakiW7XH0zbWW1+2RTlAbUsnclnbRXioT+uyycERKd
	dqxU3GtrB7nZPGfYKY4X+YmjkrMe0F7dwCMSIpbRuxkcXpq7n7pgF8K7v8LCqbGe/t6UvIA0K2S
	58xi5lZ1g9nXoukuNZ1lYLVLWC1g=
X-Gm-Gg: ASbGncsuD/zz70rnAKWVy7hsBzTVoFI0PZeXQDWNUIjH/xXKuJVsUTiS7I18TGqkLxk
	3h/zyHIXCAPOch5rSpxUoHXkFKMYht5TVGvwCuXgU84YlwAe63/j8Vx2G8DQQImPt4w==
X-Google-Smtp-Source: AGHT+IE+o1wAl3M115xHaz6zzUQgw6r9XmzLkvVELi/ru2UxnVZ0SeJSsIpVh74/vPwBzAo9Tc59ysf9MLwP2GmVAR0=
X-Received: by 2002:a19:6912:0:b0:53e:1c7b:388e with SMTP id
 2adb3069b0e04-53e1c7b39a0mr25292e87.8.1733255828389; Tue, 03 Dec 2024
 11:57:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <458d3314-2010-4271-bb73-bff47e9de358@samba.org>
 <0a8569561645ad202c5cceba02cda93a@manguebit.com> <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
In-Reply-To: <9e94e437-487d-426d-aa96-3477e95ececa@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Dec 2024 13:56:57 -0600
Message-ID: <CAH2r5mvrjGgtf4o+dk9KcEqM+QtvYodhbBNzcK5SDyyepK+Xog@mail.gmail.com>
Subject: Re: Special files broken against Samba master
To: Ralph Boehme <slow@samba.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steven French <Steven.French@microsoft.com>, 
	CIFS <linux-cifs@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks like a big improvement - fewer roundtrips to Samba.  Haven't
tried to Windows yet, but it does look like it breaks mounts to ksmbd
so I may need a minor change to cifs.ko or ksmbd.

On Tue, Dec 3, 2024 at 4:04=E2=80=AFAM Ralph Boehme <slow@samba.org> wrote:
>
> On 12/2/24 11:40 PM, Paulo Alcantara wrote:
> > Ralph Boehme <slow@samba.org> writes:
> >> I'm sure I'm doing things wrong. Can you help me getting this across t=
he
> >> line?
> >
> > Patches look good, thanks.  It would be great making sure it didn't
> > regress against NFS server on Windows, but Steve can do that.
>
> great, thanks for taking a look! I was expecting I was likely doing some
> stupid beginner mistakes, but if you think the changes look good, here's
> a v2 with just my +1 added, without code changes.
>
> Thanks!
> -slow



--=20
Thanks,

Steve

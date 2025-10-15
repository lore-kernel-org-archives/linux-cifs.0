Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7362517AA
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 18:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760551853; cv=none; b=mdDM9SYwEwTKn+vKUY2Q9CQBeyxU4CA/FjWHuzyjSlvotMGIfhZUtjEXyu4e+n56gfbMA/7SSrGdOTwyJRdZV3PsvzWfiGuPd4vyjiEIsZelZylfveHMh0Tj87APTj8XV9nkvpUZ8I+Nyt7aSBFRReVufZng8t1jcA+4REZhGNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760551853; c=relaxed/simple;
	bh=A1Yp6U35cANnY8G27X9QHKs7ZC1uiK/VGWHHtWeVu8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EctuNJ9P2+NDIsMWtwEwyY3P2FWrtTxW/luSm7CaAXKavoaQ4mbmsLRtVlUnwhcRzDy7e139tOptuk4cUBmGVK3fxyCDYImMHHOltTIgBBXdZOUR8UMbOho+JN4XsUoecYuwwOdEBfisE5ghcAHYv/uwJ3CGIGLxkOhoRN90bW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A6iYrQ72; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A6iYrQ72"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-796fe71deecso80048106d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 11:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760551850; x=1761156650; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nqA7k4UVVoz1WmvKpqEl1VWC0k/EIByv+fhLJjtIG9s=;
        b=A6iYrQ72i70wKcH+lwKdRv0LQ53a3isLZ679z7DbNBds4diWJX4Zpkh5ySfsfOLhMY
         lNT2EJBpGU2OGNi0mW4xqbmIv8NqfYwRVokPd1MF0b5RayS2rgo+jZEYoS8DzT62rZQs
         lwj38Iu1WNRlNUUYRzorQdphahmLEOPXXBiNcMj17PBpvlBHMk1se4q/WaZbrfVEq6li
         R/Vfg571qRjD3e+aQlMJgyTfRREOHmvcUimk6QZShneN59a8J88SkYTIgKNEurDPhaP1
         DzS+ySXUycFjNafnHGDbQU/BWWzV+/Jo8LKbxnvvFO/oAXCkVhBtm8QMpAmqWM7SgEIP
         h3zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760551851; x=1761156651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nqA7k4UVVoz1WmvKpqEl1VWC0k/EIByv+fhLJjtIG9s=;
        b=LyOwdN80fIPQy7IGzL3u3coHJQadRPhFPJyu2i+/buwZrCrF3fkfktO8stnFtz5PI7
         tokNQIo3lz/NwqnnhAs7x8laLcqvBLlQewHLBeWUz3Fd9aakUpmsOO0AL/Em92Y1hjj8
         zfzDkNEVZlpeSydHfpcMLfc9aIUU8JFGlBGq4+yDCjl9LWofmWNmZebr8LxfZRzflYOi
         AjoJkM/do+Is4x44s3VA53i/jQBa5pBvyvjYmGus5EuwWzAxiRnsUeQIpaaRCPhREAeb
         9MeJRbj+KqJGRQgH0jQAaoRtBkXUz6ShoYH8eCa6utCs+8N7yNPypNCNMecfVKYzlFQj
         UlQg==
X-Forwarded-Encrypted: i=1; AJvYcCWcmSowIFEBBihHXVMnCXVnnDGaOoRme+WY++fOTbAwxAekC+Fx0pBLxGW0TH5itTIPHYD5Cid/lA8y@vger.kernel.org
X-Gm-Message-State: AOJu0YzIFG3ICZEuGgBDP+JtU3qdTv3zpCqzb1K/kR2qBeUuNp+tgnZt
	Z3JXlkEvhh2VCUlmhB/QiAY7u3/SVT29D1//hDzSVSLngYQ+NDafkvnNKV0lny+Asgp2pYuYFds
	DTV+WUEGx37e0uhmc8OGlFHcKFQbsLxU=
X-Gm-Gg: ASbGncsxckpG+JHYFMVW1gj5aIZAPajkOWH4O0c8ijK2CfMrdZPf4pG4m+uNwf416RE
	tjAqwdAwPZE7itAoLpHRQh5ZlVmwqoBhg/T7ZPbuNsRLwA8K2le2bPqHzziuCowOShCOOjtQWaH
	P+6B/yXmPBxMyvhACwGcq2BwiOb1nsZDZwGzjPo/Etw9K9UbpwdTXONokFBIVGpWdyqRckjlwml
	rPJaV3shauDtEkblx0xDWyMKH2uKPgr3uXcJEcsUComR0TZ1XxvJUXMwMcWzVR3R4LXHidjqe+W
	DOJr5QIdKe/4D6TjaK/OfdvVnJLK3jGa57kspA4pZ/GEPcqVrS+hM1A4EWi3fA5gzDI5f6rD90N
	rdXhWTXpDilCmgLvlVhWHoiXo8Mkaw0RVIY52hfVV
X-Google-Smtp-Source: AGHT+IHninkPESQS8dHVL1fQL53uOsfSc1mur/cEdxDh3bmiIBfWuhMXmHWs7FOB1Mg5kel/vGkCWetRJzQIDq/GUh0=
X-Received: by 2002:ad4:5945:0:b0:78e:c8a6:e891 with SMTP id
 6a1803df08f44-87b2103f5c0mr366857086d6.24.1760551850329; Wed, 15 Oct 2025
 11:10:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aOzRF9JB9VkBKapw@osx.local> <6599bf31-1099-426d-a8e5-902c3d98e032@web.de>
 <aO/DLq/OtAjvkgcY@chcpu18> <6eeec2b6-ef28-4280-a854-cc22d2df55ed@web.de>
In-Reply-To: <6eeec2b6-ef28-4280-a854-cc22d2df55ed@web.de>
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 Oct 2025 13:10:38 -0500
X-Gm-Features: AS18NWBfaSIxv2RDHlnpAQo8uwRpyrQ2N8ndjpwz_0K_rEufX1VnmPESyUOVHfY
Message-ID: <CAH2r5mvg2Ask8SXOQArDLnKOjHHSPKGwuHkYp9NuuzEqYcZNEQ@mail.gmail.com>
Subject: Re: [PATCH] smb: Fix refcount leak for cifs_sb_tlink
To: Markus Elfring <Markus.Elfring@web.de>
Cc: Shuhao Fu <sfual@cse.ust.hk>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Bharath SM <bharathsm@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>, 
	LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I agree that "callsites" is incorrect, it should be "calls" e.g. but
the others are very minor and I think the existing wording is fine for
the others

On Wed, Oct 15, 2025 at 11:25=E2=80=AFAM Markus Elfring <Markus.Elfring@web=
.de> wrote:
>
> > Fix three refcount inconsistency issues related to `cifs_sb_tlink`.
>
> I suggest to omit this introduction.
>
>
> > Comments for `cifs_sb_tlink` state that `cifs_put_tlink()` needs to be
>
>                              ()?
>
>
> > called after successful calls to `cifs_sb_tlink`. Three callsites fail
>
>                                                           call sites?
>
>
> > to update refcount accordingly, leading to possible resource leaks.
>
> * Do we prefer the term =E2=80=9Creference count=E2=80=9D?
>
> * Is the word =E2=80=9Cpossible=E2=80=9D really relevant here?
>   (Would you find corresponding case distinctions more helpful?)
>
> * How do you think about to increase the application of scope-based resou=
rce management?
>
>
> Regards,
> Markus



--=20
Thanks,

Steve

Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08322609D0
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760979537; cv=none; b=OyRdJMDnnXfqJBS8ZIwtewVioEmZoV5jV2Eh5KRpquxBNoNUDMjPIk4VKGf8mo2AFdvpRPp3NuTT/f2rn1j80esBZ7aMFmAbuwGMoHswq746sHbNhOi/6IBGE2GficuZZGXInF9BC5i7OfIHpnWoLTlVkg595/Dg9DvwlC0OXkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760979537; c=relaxed/simple;
	bh=4bQ5dGdI37+mKtm3nyfRFem5GeQNndtwmqJv6QZC4X0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V9PWi9uz+qmx+qbNhecAfStfFHh08FT0GcxjSV+vH3ciZhU+h7ugzkVNwQw0wkngnp7i/6v+i404LWfH+Efd6zA7wcW1lP3NJcAH2N5VubYnQYPc5C1fr+Z1Jgz6K7OzbO2NQUWFE3UwtLnqW4M3E9fM56eT7e/UwspgCKhoe18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MeKcGWor; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MeKcGWor"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-78f75b0a058so61410206d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 09:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760979535; x=1761584335; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WgsdylpKUJQfQkBSHP7xg/RD79zsocybv4Uh09OP8R0=;
        b=MeKcGWoro02/4Eg8K9LVgB9EI6XZMMdkvBezzHR9H/bq9oKo86d4lpqZvjhBJ4YivJ
         NxtjUsp/enHfGZ84xtDNbbxfwcKknwJn5Io2fXOOnH0rQEegINY/LgyoufTcPT/0xokX
         0GG2Xwx4aHoFNuKl4RjCSkjLMjxLPsafu7+uuLzGA2Mnqq5V1gODvnaZm7eAg4CSn92h
         d1V6kLk1YSbTQ3dGYsWAyGgkfgscH+9/izwj+XbtiwbeCp93/VZj0FOQVlqfghWzBp8/
         Brv5Mq9fdgx7dRk67pWdFRh4Z64J1UTKhYhxNP1DBy7iRKGWRItJQnbawzA5fE6IZw/e
         A3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760979535; x=1761584335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WgsdylpKUJQfQkBSHP7xg/RD79zsocybv4Uh09OP8R0=;
        b=pwOJD/pu3Z8CFP+3xXR0xqBidMXfBRA4wiMxlaLFn85Eo81sLp5PTOG9v8sNCPZmXO
         nDCXN+mfb/SrYqzW8gdY5ppvrYplo6e/Xu30HB1Tw/XSP9uUeVgJKdtRb+VFTVlomuJT
         AiyjxkA8GbTznVoGxxlOeILpA6L+bXBHpY67GAqktkrrx0WMBs83mA/wvS8fyazm5WDW
         7N06XTDjXPtBXtbrRyHtEsML6f7ObNKjfwJMUtv0Jrv5EgeVAI7ry9dJkvl+nyxB3hTg
         Rf8m2daDABN859VuKjOnnIG58u3TtkooZgzGE0ccC992DzonsEJScx/kuTGxtvAxtIzS
         kb1w==
X-Forwarded-Encrypted: i=1; AJvYcCWhCJ14DHUZ9vldmb1N7XgpJhefqz3PaBowVq9MxBdq8IIBvIkT2EdngRbLkIcVAk3sVZwF1gx5vklQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1bPAyrlnde4YulONmskQYmWMIqyRjoEP5+ek/fxRi6Lj/C2Yo
	+5VbcG0oRi77mYDKsDjiQVD5yj3AJes9KcG6d+xBEeFdo1YA3nG+RdcnvtCY+QgO7Fl2WA7oXuK
	E5zINdSBMehEb7AxVyDvagoz45o+IJ/8=
X-Gm-Gg: ASbGncubLMPOcX7th3swIhhEvLAtC7OeWOsH2O6m7rZiUyBshuitiDPjr7/x4xk1PVs
	l/jCTzdg3TuDuYlj+/jaU2dZGEEnzhTSKjeM7srkCv7QchfaLGxsE9REzYKm61r1O8xEZTLb5Om
	LEdOS/c+fhI/O+uWu2bzIrtpGcZR3oVOjdMMy+Y4qjFmJXQ9hVWiof2mL1qJTJRPWA5HAVmpES5
	iFIywHJMdSuk52CPO/OciDoyDpd9aglIdIZaI2FEuN8/7bV5IAaErtaC1EoSLO0kmu98N4znOGz
	xc5f6eC/LutGyYKNH5FTnBDBFJ44/AsKMZjSTs5+vK3/JIEXd1K1wNPDClN6ss9NtyltKjcjX81
	pqbpcv8C0IOA5b9CfOVTpjAaIbad5bmUTLs2A3JpESNPGrbZ4irEYk3VDNqbFLcDOvG581sZtsl
	mN1ID6mbtqp7Oe33v8jhZb
X-Google-Smtp-Source: AGHT+IHbXFlV0wP4FY/uwKW9bu6aO+4kvfoixtYtWRosnhokGbPU8PEqiSlE80WY+IOyu6/479D4KFoQCxyPQIW+q5g=
X-Received: by 2002:a05:6214:1c09:b0:87c:dffa:3291 with SMTP id
 6a1803df08f44-87cdffa3562mr107155826d6.43.1760979534432; Mon, 20 Oct 2025
 09:58:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1006942.1760950016@warthog.procyon.org.uk> <vmbhu5djhw2fovzwpa6dptuthwocmjc5oh6vsi4aolodstmqix@4jv64tzfe3qp>
 <1158747.1760969306@warthog.procyon.org.uk>
In-Reply-To: <1158747.1760969306@warthog.procyon.org.uk>
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Oct 2025 11:58:42 -0500
X-Gm-Features: AS18NWCQzB81UKEefQM5CmQBxxIlIJnyDPWcumyA1Qwmkt85JWSyfbkHNlFn7yQ
Message-ID: <CAH2r5mvOwmdcP_5kjC+ENgtooi06AuPvwBXrMnZrfy7_poAoFQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix TCP_Server_Info::credits to be signed
To: David Howells <dhowells@redhat.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Pavel Shilovsky <piastryyy@gmail.com>, ronnie sahlberg <ronniesahlberg@gmail.com>, 
	Bharath S M <bharathsm@microsoft.com>, Shyam Prasad <nspmangalore@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2025 at 9:08=E2=80=AFAM David Howells <dhowells@redhat.com>=
 wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> > Both semantically and technically, credits shouldn't go negative.
> > Shouldn't those other fields/functions become unsigned instead?
>
> That's really a question for Steve, but it makes it easier to handle
> underflow, and I'm guessing that the maximum credits isn't likely to exce=
ed
> 2G.
>
> David

Interesting question - I do like the idea of keeping signed if it
makes it easier to check
for underflows but IIRC that hasn't been a problem in a long time (adding P=
avel
and Ronnie in case they remember) but more important than the signed
vs. unsigned
in my opinion is at least keeping the field consistent.

I have seen a few stress related xfstests that often generate
reconnects, so we may want
to run with the tracepoint enabled
(smb3_reconnect_with_invalid_credits) to see if that
is actually happening (the underflow of credits)

I also was thinking that we should doublecheck that lease break acks
will never run out credits
(since that can deadlock servers for more than 30 seconds as they wait
for timeouts), even if
"lease break storms" are rare.   Maybe we should allow e.g. lease
break acks to borrow echo
credits e.g. as minor improvement?

--=20
Thanks,

Steve

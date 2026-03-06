Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457A233B6C4
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 22:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772836198; cv=pass; b=lSwQHHqtq07336OREw5AfNdKjgfhvWGSuXdB+T3G5tLDaMF/O2oNrZ4S28E2mw+jHuyZwGCt8AFDqWxf0bOkFdkLFwhJInRCnr0/MTTg2HMb5awlmfc1fRGgt4nOwb9EH58+yTRh+9owj0PMeUzvCbIQQON2ILIbWqhp/4hCgSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772836198; c=relaxed/simple;
	bh=6hDayXAS3ZcgClltCyAPNYa3R9NmZajGKiRN57JV3kE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HvKT95Y0tt43J12wZqQNqCziKK9/SkzBl/+A6SnIcmw8CSubt+vvTMV3ZXv7tC/Iy9jHkBMCHs43sxoH8Gtg4pe/2yPDU8kQm4HLZPpKWJrf88Al1MV7AmPrcDsZhPDWFpIpdOrUxKCD3IBWS3nFu7SDwWnqin0ybelD9YEu9tQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RO4qRF0r; arc=pass smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RO4qRF0r"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899fa7d0780so61417816d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 14:29:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772836196; cv=none;
        d=google.com; s=arc-20240605;
        b=MY9hFr8xbL60djqDn0ZzoqYPhpdK10NL9L/YFR072sg7FpZz9gGFi1KBRCT2Ylrx+X
         JAlIlF28xDIcX0DI5H1c+huS/FK0EJBaTfH0z7oHoftwxQzuFGOfF9y0J72HoFiWRgGZ
         rrfGiUGREUiV3VxOOD3Y+IZcmvpp/OqqZylSLYrkG7XIJA8/wu6pvIM/Hv1Y8/+GPJuO
         +sKUa/0yFAa2e31FQk+yKaeGhfapqa9A8W9PLAaQlsfrGxYNwNCdZSScRDxiUR9TUOSN
         znrZg6qjUyLOl3kVCY+vDmkVi90Bmjlay0ZUaq6jyKdfl7zojiHWBIKTosiyDVNaSXj/
         ACuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A76+RCnh6RYBLUuf1MDuudhMzv5hTtl1b3nR7O2iJwY=;
        fh=hDeZLIiXWuA/MvHk2j4A/ZVtXqkzkPonuT9mwldeSiI=;
        b=F0Fof0COEqINtLZGhHvBRxHt3AOVtGul7LNd8w7eIdkO1TNRrE3W/vHxOqeiqTVvOX
         zY3yj8pwpkkkzLqbXSM4nKbreJvWBYynvn4z/7Tsf6uef72mbqK9y9lpGjqfRloechnM
         e6y7n84el3/278xqN0Dey+rs4vm5X5OTIwoaMiR6Vd3cEhzUeOX8bs6XMIbVyKfrBRn1
         NFLyqI7cLh81zmpYYFV/ACcijkzBbWTU8kZ5MaJ8Xe9e36Zq0HzUHNibswxVVxbYM3mz
         jZptAxdNRG20ogIAbl4vWB3oTvalNiw/2G0bylmLpAHwhaeCrx9MNoJM3D/HL3AUyYO6
         /TyA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772836196; x=1773440996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A76+RCnh6RYBLUuf1MDuudhMzv5hTtl1b3nR7O2iJwY=;
        b=RO4qRF0rlIE2pkX8MEN/f/sMdSCK98Q2Y4WPuW9ZdFe1b77A1JPVMjNysrTArQ3XG3
         Vw0325GXKzar+atw0VmBGrAGJD0O8K5VL1fOaeHftSr9ENzuNLMsy1F40RGPmGLDmc5b
         ecAZ9F+RqsQCpxpgavnS0jbDbsDkTe/u4WF40ZOO7X9GEuBoyWpzjsDWofNh1wI/mSqD
         lZ1V8x6HHuzT4t2RV9pZ8NQWXD6L1CynhSbt3S1UZ0XOJEQ48pJkw5t8ja+VCeMssLfA
         0veYRQVGZTEMPjF+os51D+BhHPZ9Fpx9fP7/QpTILfmkm2qAsOkhcU+evpSLxeCZCGn0
         Osgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772836196; x=1773440996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A76+RCnh6RYBLUuf1MDuudhMzv5hTtl1b3nR7O2iJwY=;
        b=tI9Neq761Vbf1K6h3ALEXmbZsNfeYftK8S/V+e7sgbvya2cH72qls8d0+cHDtmLdPh
         8eTk2p/DQBEFHrf1vFsmlA687O824m7B6bKlk9K6Zk5pUf1TYYfHBrxi3yt5Ci4/Sz2Z
         0VLeGoqYy68xm3eYLvps3GyMFdPkEoy6WczChUu/diKnxd9OjHKFBrxFh+/x0DF6SANG
         c3tqfYrbh+rxmBNh7znaXvFTrlT20cB6swb+TSKW9sz6hS2tuWjCJz3//FSQQn9BBM3+
         bZKCfzR06PO3Z+MRRHn+hn2baY7bos0eq71Hd/aTzbhdwup8lwUdy+RqisehZqPktnQa
         I9dw==
X-Forwarded-Encrypted: i=1; AJvYcCXhv8yHh/jk4L9nBypNHPjSqBm+CrTwg5Zk9pRyn42Q5DirdnmyyZG3CVWjx6re3Vt5Y2B7gvgdQHHt@vger.kernel.org
X-Gm-Message-State: AOJu0YymoPr+ggHQKScuJrar5uaZYI4g9QElHIGeO/pcS3drCnaqZgNO
	444uu5+6njhhds7msW2TycnotiKopyrBcmhBzY650zFbr/g/kNhk9GSU8xSpbdQ2/OWCdCpvEvX
	ihhzYcK13WtkgGXl32HjPtdpznbtfyKY=
X-Gm-Gg: ATEYQzyCu8rpJauApWjsfO1YyD8p+vOw/f749x/lRMfVNrZmMl6QY/WmYCkp8ejt+zy
	lk89XRwQpMu7Xptjtu2WrOpztp2khYoZZ1vhV/wxuNciyQJbR1+u++zZMlA4T9eWsJdKUF53CCO
	Hc+9g9Qx8Xm0w5C4OyzALdVkXvcSfJNp8XTxsKO30w7H15s3eARVaFVpK5omoN+b5txYJ36zn4N
	8FrxbhdTR9uAfkuElH6z5DswttiOdfIceqnADbDFte8VHOnV8U485/XizkOD4uS3l+68W9LcXpz
	sCOwNcQeZOMSzNdy1QfM1g6EfVg/EYjZ+o23hQKKqSfQyDBpeHKjKGPDjabk/duw9QUvR9jqFhL
	nKwfqe2yxqnVNXxWH9bsy6EmsEX+xQlUKcS8OW/otvbsLiTOVy507rhwSnnex/OkKEe61Gp1KPv
	l5w9rNmzkPI2YF7clFX5N2AD8/r0+RqOum
X-Received: by 2002:a05:6214:f63:b0:899:f6bb:331f with SMTP id
 6a1803df08f44-89a30acb563mr57602486d6.41.1772836196174; Fri, 06 Mar 2026
 14:29:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu0T+Gcea5YKaAA7L6FfM5OMjEKenih6Sgk2W4EXrSpWw@mail.gmail.com>
 <CAHk-=wgVoDTEDyEQgGn9yJQ7T47f-ZN4eV9XeutqzKPJwDrPtg@mail.gmail.com>
In-Reply-To: <CAHk-=wgVoDTEDyEQgGn9yJQ7T47f-ZN4eV9XeutqzKPJwDrPtg@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Mar 2026 16:29:45 -0600
X-Gm-Features: AaiRm50o6OBgcbzLK8Ma9HVf07vYYxTcud4ms2SDURAsFD_g5zOgS9N_lTd_otQ
Message-ID: <CAH2r5mvUfCe4ZCvnZO9tHbK-06NBN8BM28QUh6VoRmWLnC8GFQ@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 6, 2026 at 4:23=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 6 Mar 2026 at 14:04, Steve French <smfrench@gmail.com> wrote:
> >
> >   git://git.samba.org/sfrench/cifs-2.6.git v7.0-rc2-smb3-client-fixes
>
> Hmm. I get
>
>    fatal: couldn't find remote ref v7.0-rc2-smb3-client-fixes

Fixed. Should work now

> and I cannot see the alleged top commit:
>
> > for you to fetch changes up to 048efe129a297256d3c2088cf8d79515ff5ec864=
:
>
> anywhere else either. Forgot to push?
>

Yes. Sorry about the confusion.



--=20
Thanks,

Steve

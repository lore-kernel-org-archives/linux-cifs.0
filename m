Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9AE3B3886
	for <linux-cifs@vger.kernel.org>; Mon,  8 Jun 2026 22:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780958070; cv=pass; b=HcAIdOdMRGM+LJ63bXnVfJBiY3QPIjg7z8V8vxp9OxFeANrKgBPG2KRUnzQOVhidO4gjEeDXfy0MPrDrkfFa6PtahuZRreqHdL1tPAe2eKn4/atf42ic6IV5dFFit5yjj8gQ3qciOFY5sl0i/ny5NIyEtxGaXiuYR++xLOY+yU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780958070; c=relaxed/simple;
	bh=jrgsOYLu0aHR3gnZJyC7K1DyuZa/bQgGWt+lamS4Q8Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=T957L5enp9zrK2eumEZ6NLXg89oD/B9ZYjohxHuA/5WqZvlwoTPEKFi2ezhSqc/XSk6DKphQIkmX4unC5vgUNqKgkc6OtFV+ix0FQsjInPrxwbd3L+lZDKzykxgqolprxF6eYUO+W3EC1CpM8jxWwBpYh9zr1/Snqhho33uusT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WbtwBjnZ; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WbtwBjnZ"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ccef9eabccso56675516d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 Jun 2026 15:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780958068; cv=none;
        d=google.com; s=arc-20240605;
        b=etE5j0MN6eeVdMDAh6UHIreNTEo2e9S4qxiVPPX0WW0xqJYPFxLSnP/+NKkq1t3voR
         eq917MrxgrRQJXqhcc7UIA8FXu9ezMZBBAnsbtF9g221IiHme6juAwHKJaCPx7BdC+47
         huHWuVjwzkdOdGcGcbTVr29QSvUDK9XOLgCc7vsYlSTan1XPNfgCGlLvYF9cCup7JuEY
         UMCv6M6nrxRIFwUJ4qaPyoa0sNGsyv0CvVWP94v9vlpL1pPCEmO7dVnMgQ1xlU+mjpun
         ae0g2tZu+68KQXJTRc+YniSM8sNLLHyIJ/nhGbeJ9O5EFmnBENolipvXcPMsvWELVG2H
         O6nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=A8YkrczZi+iXKp1TNAEmUnrgjLzgRyXUAQtGxOytYig=;
        fh=4pZOygrxjUMSWMqRiZ7YhJnexf31YCNZaShWtwPX3Q8=;
        b=J+eke8Pf9GDDgvsTiyeuo1EQHaNgP2aJsDOfjNCYc3FeLyGM5wUTFpU6EVQ9cH8/td
         oi80Wl3SYUJRTPECFYMOB6jTy2lB+9Seq7HS4Tpl5/fVhz/61UJWB3y3qxudEudBfabm
         zT5417yTuaIj9XsBxiVD9/hHNoS8jBWELE1Cux88r6GWeQcVZLiXklqNc+/OIMcmFZLn
         p3pYvegJ7eqtAq7MgBgLVyesvpC6IAWHO+rJc3I0tkKKQMUYbp+hfBDdEjS7/78syZkw
         XPxdM4/rZq4Vz5h6ZeSXqPQ42qal+Q2uEwYkkD+vTel6d19+rKt9YeOWvAe5QV+j4mux
         dySA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780958068; x=1781562868; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A8YkrczZi+iXKp1TNAEmUnrgjLzgRyXUAQtGxOytYig=;
        b=WbtwBjnZFUicFiKIJVcd0THvstXZzESSYB5ELNB9CPkuEP/MrrD6+dm+hHN3UlwY5W
         KwNt0V+4/ukNaB180HD3SeU9mGIUY+LiVSPO1/mC8w5W6WByjSEQ/hNtXbHBwFn6OEzk
         m8Lx84iscut4/7up0WIK+h/s8qrM3StvjSu8kbs6P/UqMSCF8BEOf0dWDfdt01w0gUG/
         AmNyhimCO4OzzheUsMA1R7AUeis1YjWuND080SCq6pT/5a+H8t0HAfek4JN6AxZ0/QHh
         rKDL2DQsTlBJ67hCUnzyO8k3hg6gcAk2ZNfclOoUUdsq6AcwxCGlNfYdc2OdfvnRFKuO
         HB1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780958068; x=1781562868;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A8YkrczZi+iXKp1TNAEmUnrgjLzgRyXUAQtGxOytYig=;
        b=DfHMOvHifaputeGJXNSb1VYXiAzooAyWBRDQiMUmAkMo+li3leOFRY8CPgAxzbUa5N
         27u3wGfA2n6uGU5S7V2fDUtDh5KHYHN+Y0UtmSLHfdqTUvOauFidgRLPI0ZxkmQTa/m/
         xtvtPEp1H7i/5t8RPWc0WoKvNG3mzK15802ByyXHmPe23HAiPTPW8YELZ7QI6ZGwbg2I
         5ISGyJYR5tOTSkBedDTcXHYTgstWvHYIKrUklZT82uQcmRhXg8EhqotLwFdUuGxA33Me
         fb1ranmzZQ981mqOkcdsqn18mGmGVVaoM9xBVzdh3KQsVSJagj15ZDKEiRgDozvHiUzZ
         wxoQ==
X-Gm-Message-State: AOJu0Yz+lDkeeOEG0uP5ZYKpMC72f1Jl7Evd7I9OdtCmJ3F5HO/qjOvt
	dPsB4/y/7/i+FTGOxVGrr3oqAvrPDdBfIGIP96pkzJ8AEAvm1V7eC0PGYa9WKQE5o5+F4+BrutA
	T0LxNocrPhU990J9mJdww8zE5k4F4BL4=
X-Gm-Gg: Acq92OGjWfNXOYKwMHvCxkYWEwKZsIspl5NeBr8mcU0SoMdYquOxR5wZyN3qitFxv4e
	bCJbasv7GFByu1PcrPEa2iwYnx4JZB18qqOApg3kpn1HozHAenHD6QJQ3+F4LpK9SgAbWUVyV18
	1RfXwFsrkwQq8lT8OMNcBEnOxI2mVzmF3SMURILdKPzms6cENtv7A/wj0C84AV9MAR2PNYiug8z
	eBefTK5xvCtbRQPPtiuQ8JF5niPNWqgHf8tO+967SmBNGSyI7eAbmlCDLWxqGbn1ccFY82+5us3
	eLcsyCeh8E1iVxlyjD4pksAk2ggtdU6/jgPKhU1wEdslpb80ApclwqQ/nbmSQ6GWAzjPn9VkzDU
	rr3NiH+q2+bcUZ+ZXIszMsDjEnZYhTVgJNrEQhK4gIgiKi4Xlyr9Xg4k6fTNfkJPLIpY3fm+sh2
	O7j2nXm3IeE/mI2CCVfmcXfYaN7gH4XDxw
X-Received: by 2002:a05:6214:1242:b0:8ca:256b:8751 with SMTP id
 6a1803df08f44-8cee8b1db55mr212047496d6.1.1780958068364; Mon, 08 Jun 2026
 15:34:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Jun 2026 17:34:22 -0500
X-Gm-Features: AVVi8CeMcywVbR_REdArSCCCMzZ9vEntNfdQxZoM0RBYrd3qs3T9dojG8iX0vhA
Message-ID: <CAH2r5muMKwYGGAcBN_LQcE2zhd-+Kk+fKsRiTokpYXwZoGS68A@mail.gmail.com>
Subject: xfstest generic/035
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Do you also see xfstest generic/035 fail to ksmbd (but works to Samba)?

Client's mount options are "modefromsid,idsfromsid" otherwise default

generic/035         - output mismatch (see
/data/xfstests-dev/results//ksmbd/generic/035.out.bad)
    --- tests/generic/035.out   2024-05-15 02:56:12.624944737 -0500
    +++ /data/xfstests-dev/results//ksmbd/generic/035.out.bad
2026-06-08 17:26:09.357104228 -0500
    @@ -1,3 +1,4 @@
     QA output created by 035
     overwriting regular file:
    +nlink is 1, should be 0
     overwriting directory:
    ...
    (Run 'diff -u /data/xfstests-dev/tests/generic/035.out
/data/xfstests-dev/results//ksmbd/generic/035.out.bad'  to see the
entire diff)

-- 
Thanks,

Steve

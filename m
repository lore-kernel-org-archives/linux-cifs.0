Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C161DC1BE;
	Wed,  4 Sep 2024 14:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725461736; cv=none; b=XRc1nnMr/bL5lf08VvclMC+8WR5tG52Plaa+fQuf9Wvg537LpiWlj0vitOpnviKw0PwWudARObMyhO9Xn5MEzU1F+v3PrXU7oNnX2ntaJ++hf/+Jifjv4ikeQh8VuYygMIZk7BuhjfaiFZzlIwvD+5FCOgBF7bOGGn9Eph0GyvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725461736; c=relaxed/simple;
	bh=ymWC1YStYMGTEMXZ7FO0wmha5kKpx/fA96VZFrcOXIE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nPrZ9WU+M2/Sb4wkocsZeRDZZN2uZ8TqfgKnovKbO556kMvHh3W65Q/RI7bB6PtwhTb7xAOh9i/BepdNDGgiXY6U9RYokTIXnk1O8s3hruWcGDB5csvXdzU9iq53KN0F4f5B4dPvnljXeKXqUHq+0WJSxnnPJcSXiKIXEJNWs/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U74k0j2M; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U74k0j2M"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f4f505118fso75605281fa.3;
        Wed, 04 Sep 2024 07:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725461733; x=1726066533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Hd7gUZqbj28umqmZjsOsuH9ZJyZ+JUCo1bY2awC4m/E=;
        b=U74k0j2MjoGai8EJgUsWt8Y2tXj7NbaHWMeV60AZ5RUgUY4/z8OwncX/Npnpbg6rXv
         U1ddVvCS0YUS4aLZjv/l0Vnp1sNWznOkrEWEW9/ZPYV8lr/m+BFXQJbbhQdXInUKZlH/
         0ptm59prBzDfqnjhyKRV3pTghqhEjGJr/dRaWLiOeevgRT3a4G0yXkfpNoQ6pYMo3pcz
         c0tfIGpYBZdSBNuNkDgwfT1pF2LwymeAq3oWloBboY5pvCo3/6i+A5Qs9Le24WMXIzxm
         4OKeFPQR62A8PaSZ0JIgmSTaRAk1FIGMY42zPObECap6zf424/ZcApqCdCilYNqXji89
         D6fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725461733; x=1726066533;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hd7gUZqbj28umqmZjsOsuH9ZJyZ+JUCo1bY2awC4m/E=;
        b=ISFd/We9FUlKT6sB5+YgA0NagaFmRMefpyg/HkiybyuLaLkNeF91hznWfzMqSbjfi8
         KjAu1IosmM58tMPmOm+fksAHpVlshbgosXQd9LZMqu5iRdfwr23MNgwEMAV2ze1v23Ze
         sR5BMmsJJr5h4rzfdhLGZTovVUljqUZkJDiE3Fa+RJYE152Loz6Py3TeDBPWiPzkXdLQ
         NWRVnyIjMooM2rRYTreM8gLJ1sdzTZ2h5++aWm35wgECXA8Fu6Kp0ZBLK2+5a/ZU9NXm
         mJZ0/2lzf7RBfhIMBFZ1YoAfR0GkCO24VlttZ321Q+/U6BO7t1UY7Cwbh/xUuQUgi6F9
         Z1FQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv73z4JGq0GEpr1QeyGqqd+U3yL6lKzhxObwg9ymy+J92bjmMd1UObgQ83//JaZKacU704s+NFg6GF@vger.kernel.org
X-Gm-Message-State: AOJu0YzOAacpmVAL7WceAqxmoh3fQXWwj7lDiYKufQxwt/IP54xqNYFw
	X1Z539QRt4dI+A+K+ZaBwx1BX7Qc2y9J3YnGBsBnMz/tteNAJjTYSNCmDXF6CketfYUJlmBsvEw
	B15qQ8WO52LSJNk/qMhHPszic34QOb25/jVo=
X-Google-Smtp-Source: AGHT+IHOh3lqwP+i6vSZOE7DnLA7Enf8tQ/hCOZSZJaXJteR5wu1wdIhn8vxxmkvJB6gvpe6B94RSyK/uVC9/EII3WA=
X-Received: by 2002:a05:651c:1991:b0:2f1:922f:874a with SMTP id
 38308e7fff4ca-2f626564f62mr108709101fa.14.1725461732877; Wed, 04 Sep 2024
 07:55:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 4 Sep 2024 09:55:21 -0500
Message-ID: <CAH2r5msCnFTerrxda-e95d6xb5f9kLtEj8=h63WC7Mccj1_8NQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
780bdc1ba77646c3461f1988b12c42c60f836d77:

  Merge tag '6.11-rc5-server-fixes' of git://git.samba.org/ksmbd
(2024-08-25 12:15:04 +1200)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.11-rc6-server-fixes

for you to fetch changes up to 844436e045ac2ab7895d8b281cb784a24de1d14d:

  ksmbd: Unlock on in ksmbd_tcp_set_interfaces() (2024-08-29 20:28:37 -0500)

----------------------------------------------------------------
Three smb3 server fixes
- Fix crash in session setup
- FIx locking bug
- Improve access bounds checking
----------------------------------------------------------------
Dan Carpenter (1):
      ksmbd: Unlock on in ksmbd_tcp_set_interfaces()

Namjae Jeon (1):
      ksmbd: unset the binding mark of a reused connection

Thorsten Blum (1):
      smb: Annotate struct xattr_smb_acl with __counted_by()

 fs/smb/server/smb2pdu.c       | 4 ++++
 fs/smb/server/transport_tcp.c | 4 +++-
 fs/smb/server/xattr.h         | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve

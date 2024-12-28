Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B07635;
	Sat, 28 Dec 2024 02:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735353749; cv=none; b=YDEY5VaS+4QC5ylGq/JJriqNVYKZ3a9nxaN3iNpe1I/M1u+KYa0m0cr2k/9uMVgXaKYMVlWPE7f6OFMfKqShPJ+lk8aguM0lQREotXvrAbu7NiBJ8gWR6D6BtQZOW5JOM3RScfSr73usmnVnunRjlJ1P7pPWrefzgbJp++5zdFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735353749; c=relaxed/simple;
	bh=23Ljv7hZnEDy5L+e0TyCA2/yqLbHeI6yjkoNcoBGzIs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Ks7MWW5iciCluF9IDh6P/JVgHkPy4G5EdrpOBpS6HWvo0pMZLv447Y0q/M5EOd0A961jeEBiU6kBWkdnc+vZWvOF6KmZV4583knRd6VMCtESNQDBk6ItM+ZMRZCtkSug28Ow2Dp5/KC5cJ7oul426VUHeP6iMyN1fHvPBb/cm/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C4Taec3g; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C4Taec3g"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3003943288bso89130211fa.0;
        Fri, 27 Dec 2024 18:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735353746; x=1735958546; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Mnw8qFQVCbxnhK0aCKO9EuNGQXlFY1rc3kHi9aIiEQM=;
        b=C4Taec3gFJjqr09zVkvxvYcGP7bam4frHZNyqzv+qHS0fFZMDHgoC5izA108C0ubS7
         epN9wmQ8zzDmu0ktO2ZIZv+xkkUSJs2ssYxLRvdCLa7PhRYp06DrYgKx1nj5Wgf2RQ9i
         AQisofpvaK2xvj9/NgTdVLV5gY3yN+23iG4yaNBJiMjqCbS03iS5WwHsF/b41m4yJHY3
         2sbpKRlHaxM8gdfJhibnXrXlliulWHk4s/FhzfTh7cgaUbzAz3y2BOwxQwuzhJEvMWVV
         J+fVbbgp3dS5hM98SjZQGqyARN8E9RZYUkBgsKE/2fP7EVNJ2MWF+/OlM/QP3bVrS0dc
         620g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735353746; x=1735958546;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mnw8qFQVCbxnhK0aCKO9EuNGQXlFY1rc3kHi9aIiEQM=;
        b=quFudYnqH6XneYiXiVQ2LnQFcy8yjXV3HVg5nSz/nus0K5wumZRi9pe/8Gu6w1pH3i
         HeNMJB77E4uq08WRw4kUSAiNq4MNVnLXWIA/9F8I+28X5Hu5TjeJdiUBWSOti4G0y8CH
         xgjTK+fff7Lnbsl66buaxzNub5iGTEX2j48f9n0TtJHx+++kjnAvJHas5msASV24Pa9v
         GZInQD1tYoa9AlPG1MOZzKZ4jCHkiSb+IEEyPLaa1d1nhPft7Y2R4tYwATuNUNURVpo9
         ooXjkIZpUlYkVw8n78mzzuxBA0+WChjTc1bvfLxfANpM22IVh9skGBHzLu3afjUSYzc5
         gS+g==
X-Forwarded-Encrypted: i=1; AJvYcCXI5GnwH6n3j2OMOi4wqBTIUfw4R87xPvSzHMP2IyzlXjKBsYuR5IDJWMBwAYH2fzprKmQ/kogD3Uqd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8iLTnrIG13nKQs3fp0Kt1ha8KkbKyTmxT6Ed7ba5cmjzDhSsV
	UOXavlckLiz7ZxcVu9noQ2egcHDTQdWCVF7ZEnJcTsEAJY5bHjpAgJdbAN5Ch6npe/VAbP28g5f
	rNEGES9uEF8jtqthr9LbdqY9/Oip60NcB
X-Gm-Gg: ASbGncs3RIzVRqehU+mu84AsLzD10q5xJYtG+oDcD67hFpbfq5+6WSGv+5Emb0shOhn
	/6cTC/IREpngwmbDGQCv2uXWDIcz2EQLOiBtp
X-Google-Smtp-Source: AGHT+IGoR8ZcMI3OjHPooxoi2d20Zg0s9XLbZUGa2dwRLN/UboJ+pnSJ27uSzfRwT0S9yW+rICA2XVRI38bL5sp37Fw=
X-Received: by 2002:a05:6512:3352:b0:540:3561:969d with SMTP id
 2adb3069b0e04-5422956f51fmr7520124e87.49.1735353745594; Fri, 27 Dec 2024
 18:42:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Dec 2024 20:42:14 -0600
Message-ID: <CAH2r5mu+CPAAMHz9oFyzwr7O=cQ6pQa05+8_NDZ=3FwNh8bmSA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
4bbf9020becbfd8fc2c3da790855b7042fad455b:

  Linux 6.13-rc4 (2024-12-22 13:22:21 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc4-SMB3-client-fixes

for you to fetch changes up to f17224c2a7bdc11a17c96d9d8cb2d829f54d40bb:

  cifs: Remove unused is_server_using_iface() (2024-12-23 08:06:05 -0600)

----------------------------------------------------------------
Two smb3 client fixes
- fix caching of files that will be reused for write
- minor cleanup
----------------------------------------------------------------
Bharath SM (1):
      smb: enable reuse of deferred file handles for write operations

Dr. David Alan Gilbert (1):
      cifs: Remove unused is_server_using_iface()

 fs/smb/client/cifsproto.h |  2 --
 fs/smb/client/file.c      |  6 +++++-
 fs/smb/client/sess.c      | 25 -------------------------
 3 files changed, 5 insertions(+), 28 deletions(-)


-- 
Thanks,

Steve

Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD701B85EA;
	Fri,  6 Sep 2024 19:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725651116; cv=none; b=ssOq77xc8pflcZ5xd4FdKZfFmw1aqJOL+MaAUgKQ9K5Fw6GXOHGtJZLG1cuBY3AuaK/Z7A6Y/k8VXmzELnKGjIQkByxS95roh7PpzpP+RiQOJmohRlUvaYJArKT4zGntjFmpk449Szk1nlv2N4xJ7nnAQV4m0rgkTAckleq/Vyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725651116; c=relaxed/simple;
	bh=7CqKdMMa2W2u5sWK3EDB8rJvgqNG8GxHeQBQ2YsyL+w=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IrjzXgNwYRa09oZQvhw3i7NYBpQub+rwXKT/SWBUZFng5kfgC+W63wBAWbnvvfkM+tGp8343TSDKgMdbgldkXoQ0Nf3cIHPCSdoj5YXMBZrw9PgPw8pmcJ7/ePFWTJyChDFf6ajg1quFXTt6i8CcD8DYit0RcFfkE2dml0Iq+VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUl9K7lz; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUl9K7lz"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f75428b9f8so15732641fa.3;
        Fri, 06 Sep 2024 12:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725651113; x=1726255913; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Nuxy+071csmO0ZbB3fQ4CSEEMw+4ZTybAjYB4eqh4EQ=;
        b=gUl9K7lzuBGYFRDnXP5lL9J0SXKn6ApTlY/vzXLYLHEBXkthHkAFV3YuM/BnjOPvLD
         AEbK4Y2dnYw4fW4ioGTOY2t8o2TZVIoj74jN8yhiN3fCvwbMOXe4oF3eQ1opQYo9s5mc
         PbZNkczxMYRBxbzIxxnKjM3ug1sJfHxmnb32dX3ud47oP0VaYUUnrOL1jinxjYgJ7NGy
         lG37YR/bMIalQTIqRQNDJgDMmoXt2SrVnSumZVawHBGjBV/B40SppGIkY0i6U74e7FzJ
         I7iT078BKVOeLYSqkFHz5BcyxL28RCS19+m22D4Rm2ev2W3X4osBHCNdO+SpevCxjk3L
         l3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725651113; x=1726255913;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nuxy+071csmO0ZbB3fQ4CSEEMw+4ZTybAjYB4eqh4EQ=;
        b=ItSZrne1A86gP1F7EXkqqiCe6OzUAr9Y4DdJs0BuPYKi0hQ6d4duKO0J6B20BgJ5Ng
         0SioVNqPfy/4F2pdXF6OYAqiprvK68Bq85+IsvnTNaxAoIWUE0oSst61jDZaf9HZon7j
         jrcYrdaN1scYQlqClgcAgm2UzuJrFJp+VIGzhd7vSyB3jwMLW7YsDOg05qrOiA4P1e21
         sE2oeWLiWuHAu6elSdQwm3A3b+VD0aE1iAWzAsyS/EeU35fR2yQjbKF0mH5GZVm0S/Zz
         oTZ7ScPjeucccnMliR5vM8sC5qoZ3OrqK/QRRcze9zPB/WmapJmelR4dziIjePRVJhk9
         giOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWvwHfZKWEKE9UiN4RiBgaFXMLzacCt7UDXemnjAHVf9tiJhwe42p8g/TPZDkanoshi+YgftG7UpfFBEyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOrsq2vbyVA2OHd/4cUD79AoOu4MQ1gqn+DtsNmCE2y3WE5aHj
	QSMsZetkEaKwJ57oE4+11XDr89zSm6SzIS9ff/L+oZaT6w1GoU46hQJAXWgoJ4GdK3p3d072Ju5
	x8xgVwSKO4Vh17OcAFaq4VCDJvaRh4KMJPpA=
X-Google-Smtp-Source: AGHT+IE/6BUUKGp71wBZs/+LHe4mCzEeMa8JPUeJm+GJQOh5ietNFz4HzW3ihrpLwi0HsuqlMdY8EbaBlFIJMPJ/hJA=
X-Received: by 2002:a05:6512:3ba4:b0:533:483f:9562 with SMTP id
 2adb3069b0e04-536587f87damr2686486e87.42.1725651112908; Fri, 06 Sep 2024
 12:31:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 6 Sep 2024 14:31:41 -0500
Message-ID: <CAH2r5mu_sd0WC=c=eV-AS90-hH42-ANqyD1-BoJ-52oD-fMuOg@mail.gmail.com>
Subject: [GIT PULL] smb3/cifs client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
431c1646e1f86b949fa3685efc50b660a364c2b6:

  Linux 6.11-rc6 (2024-09-01 19:46:02 +1200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc6-cifs-client-fixes

for you to fetch changes up to ab85218910729b95f9b0acfebab55c2cab5f8ee7:

  netfs, cifs: Improve some debugging bits (2024-09-03 10:17:51 -0500)

----------------------------------------------------------------
Six smb3 client fixes
- fix potential mount hang
- fix retry problem in two types of compound operations
- important netfs integration fix in SMB1 read paths
- fix potential uninitialized zero point of inode
- minor patch to improve debugging for potential crediting problems
----------------------------------------------------------------
David Howells (3):
      cifs: Fix zero_point init on inode initialisation
      cifs: Fix SMB1 readv/writev callback in the same way as SMB2/3
      netfs, cifs: Improve some debugging bits

Paulo Alcantara (3):
      smb: client: fix hang in wait_for_response() for negproto
      smb: client: fix double put of @cfile in smb2_rename_path()
      smb: client: fix double put of @cfile in smb2_set_path_size()

 fs/netfs/io.c             |  2 +-
 fs/smb/client/cifssmb.c   | 54
++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/smb/client/connect.c   | 14 +++++++++++++-
 fs/smb/client/inode.c     |  2 ++
 fs/smb/client/smb2inode.c |  3 +++
 fs/smb/client/smb2ops.c   |  8 +++++---
 6 files changed, 70 insertions(+), 13 deletions(-)


-- 
Thanks,

Steve

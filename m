Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5812E1F02
	for <linux-cifs@vger.kernel.org>; Fri,  5 Jun 2026 01:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780621533; cv=pass; b=HscW5l8D81Nky/+gg5TYMWgDJItNDrNjuxN3hTx55G67+sAuvdd2pel+iTf8YdgklvESPy3ooTSBUjpVBmcBXCUwTix/uQhTAat5d7VKIkgVUwK6a3PkytyI+wKluQr0CTYXYcW7l+m8cdXNgu24Kl8F6aUKsFpTDhMd9wEauyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780621533; c=relaxed/simple;
	bh=aXiuoQV52r+S/KH4hTvJRmCeaPgm9e4+tI2Ssvemhvo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k1n+evhdc0FxpakOiPwkM0cEqnaiTLjmNmOtxD6Q85ouYPvdRUEsnpumE1l9Yr5HikmAydbSYVHbgezyLk7fBE3CFfuB4AS7Rn9XYpZ7GjhjBU74lC5UlBY1D5oEkVKINAiDV75NNgfI0Snks8t2YT80+C72Mm9rCTL/Jy5PRd0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NsB2AWny; arc=pass smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NsB2AWny"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5177945a279so13933501cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Jun 2026 18:05:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780621530; cv=none;
        d=google.com; s=arc-20240605;
        b=BPEKEGTKpNp3DD+2Qz0icl+K5HizN4WBCIyVeSsO46m9iJpN0UcUvuW/WZ0YzLD23l
         NlGdf8ZhxtkF2clI86QJY4HjJy/blH2xiv98Xjr7K1mbGi2SDS8u9Tij3YLcgvp0pZSd
         9JABn7h4ouOaTEuyHf0Zy+9/zqeLG/uKZn5yohjp4SNanDtemwjl5/XhFif6bXQzHfIE
         lKCzJiBMZJ4okKF3I2rYxC+e8YbsK5CX7FOPNcmRHUCZngj0YDh+RNjbxVcOfepUJsc8
         wfF6MGhATWjKAn3jVRJlWNLUpqtjKClov6Iz174DgZuWi0/qDT/nzdBSSZ5ojUAmsUha
         dJ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Su/C2V1bq+MhfXLJHZydnqsSwCOFf744TyZyk3brPUE=;
        fh=JCAJRyneh12kZG57Tv1JbHyRGB/zhlTjbCHQrj6dai4=;
        b=YMK1djjK3SNRFCZdB+sV2HKsTXI3yJIXu6/PrRrr7u9ddIqBtYKs62FWoDMsnVyGUf
         haRoIoBR5+jf02flaeUAJnUcLTu9W+ZBMbYKjTEwiOi1L6rD/xhSI46cwA6Ayh1Y1i4h
         sE2h2mk3f5rq9hTwt877pQgp0Z54qvxoSIlalXTDbmzrM0ObCBIw9k63xOK4AGeBYo96
         xO1qdX+2Mu8u4qu80JpofJwfOWfYAH50huOXKdogxWr+KdnXpxvH/0Jx7DUdX8Z5c31b
         ZU1yHr7FfCSlElwcJDon2rde9dU0/mMgWR20dvfMAnD3ftUIWT0Fu+ASn5yNvGHBKHHu
         3Wrg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780621530; x=1781226330; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Su/C2V1bq+MhfXLJHZydnqsSwCOFf744TyZyk3brPUE=;
        b=NsB2AWnygS+CaTXp2qaJwHZYbYEdv8sj2f41SYYiqeVhr5Nvxs9zICoAeolWIgDvwX
         vkJH/ZldNHKLcjlG+q/wvkKcQ45+3G01TxKNG3hKJmWCsHFi09P7P64+hnM3qvqczMZH
         iJ3qnMiBDuTuUj6GOP7o8snQNMewMSfKHLtFScnlE/vNTO336Lh7OtqXbMA9/ZqaEpmP
         K29YR3N+3AR3bPIoFIW5rsKLRj3tcF3pcfWkb4NNvpAV4tJJNFb/yUi1tqWMARBA0Rzb
         va0eG3aElgqQDbESK8Y9TqupEjp3vV7cy/LCGQ+a4Xh4JjSt+QPslU59Ry/1Ec0WboWX
         0v7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780621530; x=1781226330;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Su/C2V1bq+MhfXLJHZydnqsSwCOFf744TyZyk3brPUE=;
        b=Q6QEpOdByazA1MlWkEVyNKaPkmuR6OVCjwldO9D5vJGf33TFzAUq7Fp/SKdAA9x7b+
         MuHxZqDwCgxjiPT2+UwA3Nq+xajOjGn03df9bMVQhZepclFrNQZ9b3HS6fYWXpUKjFlv
         Y0mAR2GazkFWpzYJTV5BIdrIr2SqcZPszBwKE4WYkIzAmmsMeFMYH/CDc4DnUd38RfO9
         eldZAf8T4a2yI6J8PqbvrNS+k7b++YI9G3FZwWhVn+jvxj7F7WeRyHKlJ0+hWXpg2xGh
         XsE+h6+1e6s4cwNuPfMPqdeGTTNU7d1ATz3cuB6Lq8iF2Z/W9bAtM14gren3agTi98AB
         1/1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9mZ+oVVKYH0cVfoHuf921MKVGG2jAc7+awBYkwAdYPFAAIwApkw6p4WUJRmWhyAI+aznRYQSrMHy2+@vger.kernel.org
X-Gm-Message-State: AOJu0YxyasvRH+P+BrFfyRTA8g823EGSdLk69bgGjY+FGW9P3/b+axvX
	MKpdm2GU35IuaW/kyYYwhATI9FNceskzPTjpRafC1G2mkHE0xl+rf7zltVKOl7EdBVx6LNrY3rd
	0dW/hiPqPbuhcQ1PDIhToXLXd2ESECXk=
X-Gm-Gg: Acq92OE1B7iRUkpRX4OtB8q2cWIKNz0jYXZ5YzKidVI58pHGkKqTm1WCVxG8OeYQuvq
	g/lpVe0OBcdOZGznI7iFeFwWVtV+eait8QEuI19DOQyXacP7aYrWgnYuLm9VCuMBfKtMME2HwWE
	SnYTiIaU3REqQFnnisr/mqBezcqZWLWwM6PJ2khZNdSoXFCQxxtzO+pxkMfoLTAILFNVmkP7NNQ
	zWrbcG/h2YLgqPbvhAHE/uOEtHbzc40y7HdhWkgElEFD2bJ3VMcirGEArxUY2mJjZsCsIuQNyhP
	IZxV9QUCTlpttmPtUZuiSmEySa0XpYNq15zLPzDxoPSnq4cymrkzj3pwSKfOo5lmZntONXvVhKe
	JuGCgC3JOy5OZnVY49QwX7SOTioO/gP1wKSoo+w+do8iVb1JQ9cgOFzX005QYw14Kfrwv4AcPrQ
	trM4Plo+LltRVWf1QhDGEeivRhym9IBjox
X-Received: by 2002:a05:622a:188b:b0:50e:6182:b4c with SMTP id
 d75a77b69052e-51795b8f843mr20479371cf.25.1780621529718; Thu, 04 Jun 2026
 18:05:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 4 Jun 2026 20:05:18 -0500
X-Gm-Features: AVVi8Ceer_vTUlnCUlwT6H1zVgKVYNyS7zJ2CzUCJhHL3qOz8V3nMHFyeGMl8z8
Message-ID: <CAH2r5mu5c04vjOemsf8_c8htBD772sjRkLgNNtX7+bBk66Kg1Q@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e43ffb69e0438cddd72aaa30898b4dc446f664f8:

  Linux 7.1-rc6 (2026-05-31 15:14:24 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc7-ksmbd-server-fixes

for you to fetch changes up to f580d27e8928828693df44ba2db0fffdbe11dfea:

  ksmbd: fix use-after-free of a deferred file_lock on double
SMB2_CANCEL (2026-05-31 19:13:48 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- Fix use after free in SMB2_CANCEL
- Fix race in ksmbd_reopen_durable_fd
- Fix oplock and lease break potential NULL-dref

----------------------------------------------------------------
Gil Portnoy (3):
      ksmbd: fix NULL-deref of opinfo->conn in oplock/lease break notifiers
      ksmbd: fix durable reconnect double-bind race in ksmbd_reopen_durable_fd
      ksmbd: fix use-after-free of a deferred file_lock on double SMB2_CANCEL

 fs/smb/server/oplock.c    | 15 ++++++++++++---
 fs/smb/server/smb2pdu.c   | 11 +++++++++++
 fs/smb/server/vfs_cache.c | 12 +++++++++---
 3 files changed, 32 insertions(+), 6 deletions(-)

-- 
Thanks,

Steve

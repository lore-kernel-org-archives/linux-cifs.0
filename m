Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E14F645;
	Mon, 28 Jul 2025 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753744863; cv=none; b=k4a/n69pqRF+JXsyHuzJxyG+qVa+JnQcM40+8rvqe9NRnGlheYU/HGP/Vuu412Hz7OR1b3wyKs44l9iZbFpqFLJyd3mcL50LrYaTW/1rLU0puu1F/qc5JhbKpSp+/uEJDb7ufst47bYPIM0TTAizki3/NaJkPfjGVAiwcWCWMGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753744863; c=relaxed/simple;
	bh=NTnHYw9mQuuVS1VJSbGiyD5vbjMPtmMnRZr3v5fZLdY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=l2SnC8Ek3TcNG3OkOqeR1WvmAOfkSsd3n4hrNxnHPazJ21ZakYJmZCKgYTQFH8DiBomMaW0Bifnv/7r9JaBix2qv01oA3YgiwV/scJTS58ORughWuShbojbu+rnz+UGXAbUiCmARsu4KLa/hC68I8JMi/hZ9AE7Yhb7HDiRpFWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QVYmlHop; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QVYmlHop"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7e29d5f7672so452712785a.3;
        Mon, 28 Jul 2025 16:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753744860; x=1754349660; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VqiXYxogPPCleKAdsmkaWwQGQdBb1Nm2nmSw4/oIOiA=;
        b=QVYmlHopMscf+kGVRPxbCNeNOxbJ4qYc5d73/ZbnPhtsvX6Dq8SfHd5h5Gly2OoTjM
         ZYqPeohnt280ySAyNo8uU1d/mIF7rvFs+sKAQ6tYrZRx/RKkOlL+I9EVRWNopPlOCyYL
         UhltClphAkFL0/ECMYU7g3D0uGD+yzcQ3BeNpYcJY6JKjDBCnA9pQrJy7/HL9ByQC9sJ
         SAN11UpMC8cvq9VINaFcofjUcsNQ90/ihMW0PMlHt5yEnBU5k7H5uA0FmU27nKfFM7DW
         Eq2AM3UAmRHWyDm3w6FWRzyK9MCEiwEUTXvRNyEKhMbptR69Wm/zkOjow/LTBraNnyoq
         Nv8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753744860; x=1754349660;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VqiXYxogPPCleKAdsmkaWwQGQdBb1Nm2nmSw4/oIOiA=;
        b=M8ckFTNVJ3zLA6EUuPwrJnL1Lw0LaY5JKWIZaoN4YS3MkQqCQvOULPutkVWjMEPARk
         gn3AaHaIVAe/0Pt7O6PMp0O2kKsv1vlYJknc5YbWR7TRrsxCFN63GoGqGQfz6OmwE/GQ
         XhfDhmarMXxPnq3Lfx6hyDpyWMG2pHomNXY1mAeWxIjiGBEJjnqy6SOV0w+vcxnWgL8n
         zPN4GQhrUUgw2Qw6PHe2OHASo2HGSSOT3O6pAAgU+/70TvUsLxFTFGmqFV+NuRZCyRaa
         9VkFNNif3JF5va1trh8SuJ0eyHJGH3Enl78SxvyfY6/kxtGg3YcVMK1B1ua7HUnBUUh3
         bedw==
X-Forwarded-Encrypted: i=1; AJvYcCUuV+J5R3PIqcbwNDDW1Rppgw0+U8D7yD/WYUThy1gnfd1Dgii+PaJb9c7EZPQhaiY+9j+NqSMRh5c2@vger.kernel.org
X-Gm-Message-State: AOJu0YxPHXetqyOe5JGEYRnIzn1/wOosKfJAWXLel4ADA0GX2UsIL92n
	bAb7rTHYuy/LykWK3s6Em9HVxO8JquRWAbRJlsb40mERL4ESXYaKVJGmuDu6jCfdrh+0IFnMrJ0
	NxxuwW4Me+ioZupMjToIq1yHFXAFgvn0=
X-Gm-Gg: ASbGncvSsm+l0jj8x8o1ryMV57EBE6I11kJqCpWrXd4rvBxfcSO0Wzvw8JVtk/WGAFB
	5eFXps+xI0pX+5s6sbSUMJ/F5/azGK6JlAzMjDNUIVVEc1/s9eiIZYNRZDYT++jKIXPnvoV604Q
	3+fXclJJWcC6URwrHR5phtvHhifAYg6jPggEd57+WgQMyIhwZpbtSydY7wPgZD/Xgrf8KSeMiz7
	9yuVjDr1i6IKg6Nl1GuSjitlEHFGRML74F9Z/vRcw==
X-Google-Smtp-Source: AGHT+IGGwijIvkF1t+/HBm8/6p/0XxYnaneePuw0YWbLuMLtrPcwAkNTcJyzXkLuRACofgTtYR7D38csY/cOrQgll+k=
X-Received: by 2002:a05:620a:40c1:b0:7e6:2177:dd74 with SMTP id
 af79cd13be357-7e63be3b64emr1809792485a.9.1753744860254; Mon, 28 Jul 2025
 16:21:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 28 Jul 2025 18:20:47 -0500
X-Gm-Features: Ac12FXxRf3TliFbppBKwbqc2MxsbiRXFhErp2OQ7gh3xQjZVN-W6BOOmqOD1fDg
Message-ID: <CAH2r5ms0_hBugivNhSKW1TG22D6pTZA6WV=p+uOmcYmNp4Xvww@mail.gmail.com>
Subject: [GIT PULL] smb3 server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
89be9a83ccf1f88522317ce02f854f30d6115c41:

  Linux 6.16-rc7 (2025-07-20 15:18:33 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.17-rc-smb3-server-fixes

for you to fetch changes up to 4f8ff9486fd94b9d6a4932f2aefb9f2fc3bd0cf6:

  ksmbd: fix corrupted mtime and ctime in smb2_open (2025-07-24 22:55:29 -0500)

----------------------------------------------------------------
Eight SMB3 server fixes
- Fix mtime/ctime reporting issue
- Three auth fixes, including two session setup race bugs reported by ZDI
- Locking improvement in query directory
- Fix for potential deadlock in creating hardlinks
- Two improvements to path name processing
----------------------------------------------------------------
Namjae Jeon (4):
      ksmbd: fix null pointer dereference error in generate_encryptionkey
      ksmbd: check return value of xa_store() in krb5_authenticate
      ksmbd: fix Preauh_HashValue race condition
      ksmbd: fix corrupted mtime and ctime in smb2_open

NeilBrown (4):
      smb/server: use lookup_one_unlocked()
      smb/server: simplify ksmbd_vfs_kern_path_locked()
      smb/server: avoid deadlock when linking with ReplaceIfExists
      smb/server: add ksmbd_vfs_kern_path()

 fs/smb/server/smb2pdu.c |  91 +++++++++---------
 fs/smb/server/vfs.c     | 240 ++++++++++++++++++++++++++----------------------
 fs/smb/server/vfs.h     |   7 +-
 3 files changed, 174 insertions(+), 164 deletions(-)

-- 
Thanks,

Steve

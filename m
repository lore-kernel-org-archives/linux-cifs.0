Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15A1C8634
	for <linux-cifs@vger.kernel.org>; Fri, 27 Mar 2026 02:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774578758; cv=pass; b=QuJCCN6SYOoThr1KVTmHErEhsM+1iUudmwnsnKkUlAIah+g8Nbw99UdaFGdhD5HjfHXTFf/DNSxJDbhDHtIvHK9+fxCe5UZGQ5iUz7rUroupV59SNAUFl7oIIOXAzUM84U2PLrA/0N/I0FuY7YEnvAdIQfOTVN+eL5quCnxsl5s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774578758; c=relaxed/simple;
	bh=b3vYpakxrGtiXCmqQR+Lc5B5krj26cQ3Q8V1NFCzVa4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EhoDkHegkZ/n5CJ1eV0EG6MGYb+hzO5NXr5q23HD/xCXtnA78bcJqxLaBGwJq5+87LBznnPRU0mEjE7DICrfN+p/R+1vlIqIZ7sAvIgM2gqHzfab5EAAJBfEsgkHFTj8rU28gkSHToc7kXqqdr7UWEGwuD8HXNfV4uOPlSzS2AA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMC+o6+q; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMC+o6+q"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-506362ac5f7so15387131cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 26 Mar 2026 19:32:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774578755; cv=none;
        d=google.com; s=arc-20240605;
        b=kmCWBPKYxnc8grd8C8FCxG0GxHw38cc4AN8LAfDOjLlqfHXmpuapbIVIwqFNOLDyJK
         sbNsC+FX3VoSDIkj75tbWrRIxo8QWIo/VKnC3Whk9Y66YT/8v4rfuVlVdf0YeLyAYwhy
         7TtDUuuvYqImn8g9Mz4RHN35LyEEQO/p0O9/3Ea9GShGjeLc3FEyVufuB7NXGdtWaCni
         rS1LY4kuJI1g/IR42svXNRx2wPlXLvgXkU3IWRo9I1pzHAb5vSg+PULk4o8BjRBMsa6d
         FMICX63U7HRJLqYyxnK0laswLEB8RmsMPWN7DvTgn/kcvU0Xlm+n8JrbEL9cks76/HJo
         jkmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=tBw9SeCVM2zZ0GwGHprtL6UxFmBqYUQx9KG1hjfB2fE=;
        fh=8SKM5rP4hdv04I/oFEkDfNB1r/YA+Bd+QpNbYh2QYJE=;
        b=UCYWfECvDTt8tLYQQ5fbrz9AL55BxlNj1BjdGUB57gtGR2HVEYHBHXgoPzMYFVAvl8
         ZqNQib+ylTjwGDXx872aIORPmiPw99Q53kd/jT7ZYkO0+iWgfQ7sAItB3lPDXaQUFoPH
         nGsADI9pL423zztk6ZTNgcA75QH3gImHVDRflKSyhJ8hlBSFu+uvMR+gdG4ByVYkT0AF
         yQh5TWfaidqR6na68w8MJpxjWXyyr0bH2T+l8HafaZYqI//cCy63fMjrSDGoc1+PxLb5
         qeJHDB5TIUvOx7wh5IXjRBNUi+J3IIQaXAn7De3D4C26d4bdpTQeJiJ0FiBY6dRDYP/G
         Lkcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774578755; x=1775183555; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tBw9SeCVM2zZ0GwGHprtL6UxFmBqYUQx9KG1hjfB2fE=;
        b=aMC+o6+qSS6ENKNY9xqLsME8GDv/8YQF2CoHBpSYgDZVpNAUkD9H9f7KxBZgSFk+lO
         Zboaim2HT/Yb1nHDCxM/WzPDHKV4+aUE1XxTnJMTWpF13jH/dQKmIzqL3LbI3qMe9v6a
         /9oweWxEqON/pGdhrlk7V/w+jYjMZ9IygfgTSRjeD+WPemMcQpROiDGdUwLMD+IMimbm
         kCcT/OO+tbDCMaEgwEBqDW3SNdddd3wCble2qNer32U5pMXIZ2cAhVvlVuCZuAc2AMWO
         SVhJsE45Dgv/4EZA8dPPfht+GvlUYp6e/1OlAwU0wVn3UlJt4UlgwWVyRjlMGlWOOIUM
         yz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774578755; x=1775183555;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBw9SeCVM2zZ0GwGHprtL6UxFmBqYUQx9KG1hjfB2fE=;
        b=mwTsrHEUTlSW9jFlMDnIA5Gecn5zikLvyGIIHs+fuhI058VwvNBAgJgJl7GsRWJ40e
         RwX1YtlopXfbYJgRJf6Xn8ULO64X68XnTrth2mBIfXjFLUiKK39ZJQk4zoHjJCIcquIx
         zqQk050PBQtbxXpJX58H6EdnJijHEqa2X/QD/qtQ07MYZL+doKrhCjdx73evWeZ57lcD
         ajbEPsDSm8GEmE4o7a/kSP77rtj8TsaWJXIojlJdi3DL/EH8h4O/8UbKsCNXnEXEd9T9
         3CFr1h/d834qRqGQdSwInrvuZXpUZhf25Hpqj+GuWwVYV5M5+JQVHatLXKObAreRUO4r
         uF+Q==
X-Gm-Message-State: AOJu0Yzxpemiyw4sgQ44+vfkqrKiaxjG5RSdQF3Kd9VcRLwTYoGvV9BD
	wH4BwrUKSN7r5nz3PENAeRTW80Qvjp+0VZd7FddyhF0fH85wsUISnl4r16ztHbglfTdAL4Fqxyi
	9Ch6hGcMM/UWfBqGgrseL6STVRIyRaHw=
X-Gm-Gg: ATEYQzyBxGPAl/uNY4J5PwkHSU98bGA4uh6+Hq1xV/A+W7lqCvEALUbJgiCakqpyCF2
	adQGoltBYBGzzAkQ612TmFbG8qYMHiSLhdtRAGUownU0iSkidYpTWbIGOcTBjuQgh33OqeoQFAM
	GP1VFDEUdxDJ9OFvvKLXwzLzO0E8KasTS7sO/pBLVAqAby2921FkNI8bIXmjnk/X1XFToCedLTi
	VpbLqaZuwT3keXZLkvxYjvoonpJwoTCdg3IC0Gj8p6ZpAzjgT2UfZmhWRvVp80J7qenLFI+Xu7i
	CdYPTPLKH/kE5EdsB17dVsbCSV6pcgQnGlTmTbyvHCjfvt0zGPe3wYm+gqbY7t2lN+RB8I3TISs
	KeOmVryVixN5w+eo9Cv9h6X9jmrnUw0MSA9TYrahpMNy2pfGzT1WoqkOh0ydTfoAmZn56G11RmU
	AOv+kE+lK4Coc8qLu+1Er00b9VHZ9qPyI=
X-Received: by 2002:ac8:58c1:0:b0:509:e68:22de with SMTP id
 d75a77b69052e-50ba382991cmr12583901cf.32.1774578755553; Thu, 26 Mar 2026
 19:32:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Mar 2026 21:32:24 -0500
X-Gm-Features: AQROBzB_HK_p-5o7-cFYSK-7Ic2lwaR3_vbEZr6omemkf3v02BLUmRfCSw7VYjw
Message-ID: <CAH2r5mtec6-ByETs_C308WcPAJAeou-qKGtSGnn_28-ZSAzyFw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
c369299895a591d96745d6492d4888259b004a9e:

  Linux 7.0-rc5 (2026-03-22 14:42:17 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc5-ksmbd-srv-fixes

for you to fetch changes up to beef2634f81f1c086208191f7228bce1d366493d:

  ksmbd: fix potencial OOB in get_file_all_info() for compound
requests (2026-03-25 18:58:40 -0500)

----------------------------------------------------------------
Five server fixes
- Fix out of bounds write
- Fix for better calculating max output buffers
- Fix memory leaks in SMB2/SMB3 lock
- Fix use after free
- Multichannel fix
----------------------------------------------------------------
Hyunwoo Kim (1):
      ksmbd: do not expire session on binding failure

Namjae Jeon (2):
      ksmbd: replace hardcoded hdr2_len with offsetof() in
smb2_calc_max_out_buf_len()
      ksmbd: fix potencial OOB in get_file_all_info() for compound requests

Werner Kasselman (2):
      ksmbd: fix use-after-free and NULL deref in smb_grant_oplock()
      ksmbd: fix memory leaks and NULL deref in smb2_lock()

 fs/smb/server/oplock.c  | 72 ++++++++++++++++++++------------
 fs/smb/server/smb2pdu.c | 73 +++++++++++++++++++++++----------
 2 files changed, 97 insertions(+), 48 deletions(-)

-- 
Thanks,

Steve

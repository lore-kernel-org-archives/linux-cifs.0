Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841583769F7
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779202026; cv=pass; b=WRDq8CaBTSOfPjUSWWtt1N9ocX3BxY15eaJ49K+nVBnED3ZsScAJssoFqFvXJLOaRE7QiZNncHh6H3rgd6gOTcS52zGnTevhkQDNZI708qxjsqpYX+5dCCmBIa3sJ0D6ePQij21OhVpsO0KxjNQKnemZI/uBWKjYN9MEJsAOd3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779202026; c=relaxed/simple;
	bh=Dk1LtoGAVqYDC1faNwVB3HFgsDuzKq378PsLgrTHUQ4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gvFw2mkvDAbh3FI3pp/Ui8UOfSNkgsgpZaGl62ldREaWnYglz95SoJ9+xvghve91rRGsPoCgN8hkgLnxoQXNmEy+K7JP6ctSJeFuORtKgddgMdwJpC0QoKvBVLbRejiqk6RVIOoJMYxr2C31V3K+uhCivBQjYSY2ydF/6m1vG1E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEEmrekJ; arc=pass smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEEmrekJ"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso56709886d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 07:47:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779202023; cv=none;
        d=google.com; s=arc-20240605;
        b=IJ7JesZHcezl3Rznn++UsAf11NvK5qrjH9Cw7LM34vYpPhswjYCndANfyLpjAvkxGb
         xpRSPHOyTDwO6sfNCQ6NAiyaP3erpf0Sl1laI8AZLzccyve3FkkH6Wd36UjWZaFR6dE2
         hsH6D3+kLbaly8i6SWfJGqKGKutBI+vfQxqWFKLbfXA4apjcnzlQCm1CZbNkR0IC3NrE
         lKaHfZxuK0L7ocReGMc9e25TswwVJomdDN1DXzYI+t3foUSUy7MjbTM3cfoH4fE8ZcXQ
         wbwTUN/1iYUYoc8uvzfKf4PpqMffSDirhDSxIKXutDztjHwUl9AKeLRSN6D1Pfh8e5Co
         o3OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=HYLxy44+CJxubtdx3sbPibUrOVtwNoLbNzShEsXlknY=;
        fh=8SKM5rP4hdv04I/oFEkDfNB1r/YA+Bd+QpNbYh2QYJE=;
        b=jFuORHrbRtlrPR4kBJ1oRdtwuKs9Ua1/9PnggzjSUsQMLPJXmky82wvE+tBXlX74C/
         Cvpc2tq5aF5YobeXB54Lp+HDeVbE7AdKQpMBRXTPm5D3Rh71q9afGvlT8Qyv7n1RvMsu
         564IYdajOC0igXdksxHUyTZe2lT5iDlWvPISTqtXJksF8K/wbM6bl5IVOSi8CAML5xGs
         K+yIdpAaZsc7KPyrsipvo6I3r3G3aKOzoDtbQF/OvR0v3SpTRT6cQ4f8/Bw7DYX6SEC9
         Xtdwrx94Z4qW8yX7ZCcFRTGzOeESY8caboCtMYocQMjhLMolWjf7DARJ5MBS57LRdNzU
         vTpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779202023; x=1779806823; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HYLxy44+CJxubtdx3sbPibUrOVtwNoLbNzShEsXlknY=;
        b=YEEmrekJ/c52PWLilNGdRRDQJAGlJ0PCWhwbeTdkK5jpiAxuetXRhYUxKuHwbHWxBl
         xDPE0PSdITLsmLApt+PM27T4mT/eoOF5ScKuWMM3RujjyYH+GrvHYjuq4yWauJwkQEZJ
         Zd1n2oNwpg5udvvCsJxGtHwnsKoiZMD+V1Q9kTF8a4dIpcYYtlGwBrK1oVqGGEWQ2V+L
         3SR0Yr8HXKlE73pbg/uIt99BkViyFOz9YjsNtqkXC10NjdyBVW8wsLfqScHfseHJxXK8
         qYtmyakisyOsjP6sqUblIuQn3nVzc++p5roLHKDxd8mJGMk0MeHyWC6U10hzb3hgks1i
         GcRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779202023; x=1779806823;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYLxy44+CJxubtdx3sbPibUrOVtwNoLbNzShEsXlknY=;
        b=WIbsmpkf45UOttCMj9YYwOqeKaPAr4Bf/zMJ/k1WHwHYO3fBjY/IWKfQbG7fS4zI9q
         VUqi+tnkyHh0fdXO8GuqDQNkpsgKVe/gKISoBVqLvLKyVBY642R8cDiPlXW0orAZNceo
         Ix/q/gIKGnTjV3W5dkCt0GMYcOS7/GYrcVUHvR3Grx/9bRfLwdJfeX/zfyBpKmom8jE0
         5IT4RIARxzjcZyUBN3ji2L7eadptN3d7hlD8t9/2SH8hK10VMW55wguQxf+KBlrpoKqm
         FRUUMeehpGoN6EvzP0JwoIPdId43rmVC8gau3CsDd/wdKcAYznD1AAWMEb4JA6chxlib
         5wow==
X-Gm-Message-State: AOJu0Yzc/GcE9vybtG5X8jlyIvTmfmDScRFYIx1sdcNJ+A0zZ4uCRg9F
	eWOWzALTwLGD74Oco0NxZy4KP4v8O4AHQkTAzIAg8S5VnrwlQAES4kH5cHGHo+/wda2gvY7cTfP
	+6SYMyWIM8NwG+0fL0mJblvTQtvadJ4g=
X-Gm-Gg: Acq92OHlo2qg/A03DbcO6+pDA0A+AwkgYVuW7dgjo9T2boeSsFsk8UbdsxAjDh1qiKS
	H4lRCT8X65py8QhErdPIpIZMuLxSyYd1KnMT9hEk/mUKIvC13e9k9gLucIdOwDGk0hRyNQ1wjjm
	qRcDCUigv3XITZOUc2KTVLRoKQUjK+ntKV4BqdxskmdMsLcRu2+6kafJnMbaDsG7egc3WK3Qjpf
	1+veyTFn+m/3LF9RIKRztF02PABYKjObDZ5XZyn88Fsk3+rrFrUkufMy6UEd1nCq8BiGoUM9UlN
	v41lv2BpBEejB5RP39c1Bh+OjTpjsAzSsel3y5WeIHRH4m/uG5ce6qL1jncInTr7CkakPGunzFj
	ruf0HHXAXULmRjsZxJcYIxQo4PKlSiITWh7ZTSUATilL634O4VoVF8q8iC+ZoSqTIiyD8OCN/fN
	sHtBBQ9SuJ6e8TQCt19TSGyA==
X-Received: by 2002:a05:6214:230b:b0:8ca:23b1:524c with SMTP id
 6a1803df08f44-8ca23b15e0amr200527896d6.5.1779202023323; Tue, 19 May 2026
 07:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 19 May 2026 09:46:51 -0500
X-Gm-Features: AVHnY4LZja2QRxYS6I5jpHyIcLaqvqBeynAmjlN06SdHv89VeDD3na1oJDBcCms
Message-ID: <CAH2r5mvFfOokS8h86vit_yKvnA48k3bqXEz7AkXyaVZb-mLeZw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5d6919055dec134de3c40167a490f33c74c12581:

  Linux 7.1-rc3 (2026-05-10 14:08:09 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc4-ksmbd-server-fixes

for you to fetch changes up to 4b83cbc4c15f09b000cc06f033f64b0824b6dc87:

  ksmbd: fix null pointer dereference in compare_guid_key()
(2026-05-13 16:35:23 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- Fix two null pointer dereferences and a memory leak
----------------------------------------------------------------
Ferry Meng (1):
      ksmbd: fix SID memory leak in set_posix_acl_entries_dacl() on overflow

Jeremy Laratro (2):
      ksmbd: fix null pointer dereference in proc_show_files()
      ksmbd: fix null pointer dereference in compare_guid_key()

 fs/smb/server/oplock.c    |  6 +++++-
 fs/smb/server/smbacl.c    | 12 +++++++++---
 fs/smb/server/vfs_cache.c |  2 +-
 3 files changed, 15 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve

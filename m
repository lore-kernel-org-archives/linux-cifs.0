Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1743394479
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 23:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772147589; cv=pass; b=bwY7G8oXegD0rVVxeDbRycHHNTM1GQyD13c7P7S8TP751SbZbLxCdHJph1ibS62xa8+0wPzZJvfzCLmwuiovlMaFdipuTvtTn5Fx26/gkYN15Wop4U+XiN6T6bsLCFTvynqqbtAh7vmyojME5aMz2NoK1sI+2UWTs4FGbnXMOTw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772147589; c=relaxed/simple;
	bh=aOi+wg3f3iVksQNawAKy3lAsdD/GcOd0squY+Ef/N4s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=lYCTfEOcnOQ9r1wL9YpVmiXTI520tFNUS1Z3jZ8NejxHhy+r5DlLi+QsfNTXGmW82p31S++PW6PCh/GWqm2U1w5Grr3kVHM0a8m2dZBGTeZDVFmVDiPgd6w3pzBLRsDG14xmroY+r5lwFrK3L2g7pPKlVnLLHz+a07117G73Evg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcIBNYr0; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcIBNYr0"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-896fd2c5337so17035416d6.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 15:13:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772147587; cv=none;
        d=google.com; s=arc-20240605;
        b=es1OrZZReq1ys79XZ/Puz0iC44VnDnxToqLsGZsmG+KmfMHTvECbLOrKLHv22F6aRH
         iqOVSIdmScbTniHo/rB7/eismwWGu1fH5827c6QTd2mCziu6qOUDnymZGhIe7iH/salc
         j0yGY9fEo3gZpOQ/6nOhzNWgLa36GomqW/0+cgzkUjWyHDpSNSjvQsXFrLkP69yyn1T4
         hTLF3tUGCm1TPmno/jviitVyC3j1TdhHgNRN+a4q6r09gMkz7bKljppgZzRhcQIJh2Km
         AcUbwSfPRrrR8ssrrJJwC4KP0g5bL1xRkcgoPMs3ErLDEelc7PSRI1mFhaZDYSc7hAyv
         wjgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=31JKZmQtcR2pQHnZFYk/YLEf6y/G5dEzMHaosWjd1xk=;
        fh=DSKcvW4svhCRnKfagEYolZE+TqgnTy8fLPT+tm9bTDs=;
        b=Hu2euMMjpy/eBrUSl/R89wWVQOxGl8oWc2N1NNFOxuc0Pttq2aOfPO5dC2VFPuKCRy
         F6oaxm5sK6KavEwVdxc3YFsEWFhnjF0s5pTYGmlye6FfDy4rJwKHClX+bHXnHtQ/H2dg
         KBystG9wa3djmbxSMWK8rtUKc9DzgQJHPh8OG301P53G+2OaMITWekAv4VqaMi4oF4yq
         ddWq/gbid7hj/Btk5gw+N0JmWMdt39mfzy8jC936Aqb84wZzdH/TCNuJuEQ3cUqEneW+
         H8KFHG0ocG7/epV+o3VFffD9FkNdm8k6mP7wdgCa6bKKPm9NckFFlsY47yNlspm2ZLL0
         3BfA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772147587; x=1772752387; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=31JKZmQtcR2pQHnZFYk/YLEf6y/G5dEzMHaosWjd1xk=;
        b=LcIBNYr0uMKKfsOD4nMKu4H2hdd85THl1dl9crA+plZN4Fv8AQMLQb0oGGaYCTyQC+
         fI1Yt2urSkbq8acsBvMN59CYTJGAU3pfjVGIlyyBOm8KYu/jznBKT53HmkxqStbc1m5M
         C3gGEzQahGr4KrBdZbsaL1aaz4dlYddVfrIPsmj1ZMifnXSklavBrcIPUWFealBseC2c
         kUaoqKoUXfwGVdZxyrvJmTJIB8uNlPQ3BeVUsdzTX4fHMlTPsMYluIyhfAnC2u/0IVfn
         zl8cOAambwiUTfso7oDec68QUBoYBiLSV0pZyVqUmo+0uxFfBetQ6i/t7Fb5q2KmToyp
         qxvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772147587; x=1772752387;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31JKZmQtcR2pQHnZFYk/YLEf6y/G5dEzMHaosWjd1xk=;
        b=lPbJHL+eMI1V2rDdzZxP4zlKJbq3MZq5IyekI5ZKL9NrNvT0ENOf68KUt0p7Fj46HP
         tt/TyrWfHOmyPZv+sJxeRYBUN/lhYS4XfO1rJIsEwqwaYhmAQvjZtQ85Vs4LODll3ZrH
         WEzJBIobli8EHcl1ilkxLCIn5XsR5r17CftHT/JawNzYV1TcOZL+Xi3giV/1sTKzQPbS
         NfXpJSLXiVCiz304Xs4JVlBzSNYm4KAVeNP8jm/HF+hmO1MASJ6rmw8IHwrXRjSmx25H
         EA+h5GivfAXJCPDLdFq5kPsdFhCrLw8v4HXeJ5VOlByQVB0WE1ETytWPAd6tAudqFBgC
         +Hzw==
X-Forwarded-Encrypted: i=1; AJvYcCXpP0Dwhc0BEl1EN5Alg6zKBBjbognHlWi12JQXqfH3j9LDfPdk92jX1RI2g2rW0J0ODRu1z6mz9+Ae@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+C1UYNENmvZB2GRuHxN8cEW+Me1Cc+FuANetY8xU7EB+N+kZ0
	MIqOFneWZ0ac5xntUav7cDRHPH3ZdGROqIXl+/pREWRfMCvQ0E7J3EPU7TbKM5ypun62nHpOXsq
	dyijHUmkeM/RrKeo9DQC1s9VkAKSLnZ4=
X-Gm-Gg: ATEYQzy/ABDD2dq2q+uxein+7IKb0nCIeVnU8ayxpi4Yq/v7FZdmFXf7ClvrTG0PteT
	9/Gu9r+WKKaTYri1nEBVtrQweXeUmm1DdO4BTMRBQynNL+B+ZtqQTO56MkkU7l4NNwZ6u6nM2YK
	DY2Uge2PjCXXQc7/GfdyoXnEoDue4uEq+/c51I6Oa0cnQmRPZ/V6zoMs0OjArNZZZZ4e7rKibeD
	iYktHRWehbXuZZn7Z8ciz1idP+NtZmJ0AquoLae5C2Nnn5hFHRjcP0V7WO0W/tqtoNtgV2tQodI
	Et1iCn5vIrGjG/9HaJdyZs+fmACyS4MDc4Eg7hhvFVlq/vM/ipBkVMAN4IBf0GxkdsIt8XDNnzz
	gbEeXw/vxRogBBVEaNfyrJluK5oKfxoWPg/tES8CXSaaXYtt0sXzOe4xVnQo=
X-Received: by 2002:ad4:4eee:0:b0:87c:765:dc6 with SMTP id 6a1803df08f44-899d1d56cb3mr13860466d6.8.1772147586790;
 Thu, 26 Feb 2026 15:13:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 26 Feb 2026 17:12:54 -0600
X-Gm-Features: AaiRm51kf6IBHRa-vZDwoJBQwP49r0ftiy6Qm5269kgNg3KlEjoxPRhrJphqqbY
Message-ID: <CAH2r5mszMp8yO6oUHPeCKCo5iqco2L6cJ=MnRXuBusBNrdd7Sw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f:

  Linux 7.0-rc1 (2026-02-22 13:18:59 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.0-rc1-ksmbd-server-fixes

for you to fetch changes up to 6b4f875aac344cdd52a1f34cc70ed2f874a65757:

  ksmbd: fix signededness bug in smb_direct_prepare_negotiation()
(2026-02-22 21:27:33 -0600)

----------------------------------------------------------------
Two ksmbd server fixes
- auth security improvement
- fix potential buffer overflow in smbdirect negotiation
----------------------------------------------------------------
Eric Biggers (1):
      ksmbd: Compare MACs in constant time

Nicholas Carlini (1):
      ksmbd: fix signededness bug in smb_direct_prepare_negotiation()

 fs/smb/server/Kconfig          | 1 +
 fs/smb/server/auth.c           | 4 +++-
 fs/smb/server/smb2pdu.c        | 5 +++--
 fs/smb/server/transport_rdma.c | 4 ++--
 4 files changed, 9 insertions(+), 5 deletions(-)

-- 
Thanks,

Steve

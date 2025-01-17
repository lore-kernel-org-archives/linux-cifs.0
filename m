Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB5325A63D;
	Fri, 17 Jan 2025 04:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737089355; cv=none; b=dNNuHVzIOvfmy6lt4WsAr5XOj9tQ9P8V+JZd6IMam3L7St8qBX06qsCtCsOSpRsJBjctsrgH73XUQrMCS+lpvWlolyVfOnZ0revHj8q+NMIC3MRTcUHjWH4qINmLKLW9+94VK4bSlUolOSqjJXU4x9qT5jiUkaKWOQY+Jz0/JfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737089355; c=relaxed/simple;
	bh=JYLDItmINydPccxIGtAwrPjrdV5Plap0VCvDX8gpTiU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=r+TgvKTClv60k2WZENaFbjysGLt3Mt5YWcDIQ1gC7QXYFhUQazvnt3suVcM68gkAkPeN/d6novk7XqQIi7Hh7KrAji8JFc7f77gki8LfCVUiiu9r3sdzzIERP/NJvHb6nnRFcnY7JUQVZhSSoOQtFMXEtg2ICRAlLtUraeUReoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B6saAjfF; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B6saAjfF"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5401c52000fso1702412e87.2;
        Thu, 16 Jan 2025 20:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737089352; x=1737694152; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=whpgID72eYmRYyj4FYrMS7loa4XnZZ42YqJMUQw49/8=;
        b=B6saAjfFFYus2ea+FAqSe2ruKU//FwMlIg80PLenPMnn1DvqYkEo7ODXyWhRxx7YlU
         xe63Ye8Vz4HnzOArt9k5Z4lxyUp2PToHT6ed7nZVwisAkrlIuUm0aEoMDh3gEHXuL8Oh
         dZLXrB4/KEoDXp2L8DDe4v06WKmYfArG3ooHvSdleE1q/oz2jJQCYTfqf8SWeauctfte
         UY14pSAT7t9IyYue1AJ3r4askUleQw4x68pgLUFHSRim90ZTDS4wS5qrIXK4Ea45WxPJ
         sYWWuNp5g1eUjaBpuB/ReEB1DD3A9MmlNXqo4o10pqyZEejvMKYZdBETCL2mmGlMviB+
         NMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737089352; x=1737694152;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=whpgID72eYmRYyj4FYrMS7loa4XnZZ42YqJMUQw49/8=;
        b=qxwfs74HqC3TDzOadfXAtZ/OL09ivzWK+kHiJm7bpYQRExdBzQFcZ2x92cYdlpRQ2n
         0f3JqyEDAHBph+PxcBCEacdZWI0sCaLbM8CKI6JGP0vx6Srv87wsl3JfXj16qTaRIyOg
         y+AorSNjG8ka/u9w3bE/Xme1lVfcySNphgfpeElT91zn8Kw4m5+0+7LVUPSD9tdchIgn
         FX+8sO4jt7vml9Y/bhNZA93ciVbGFgbBcy9Mx3DfBs3V2mWaBIASlxoG/+QjiMDoo3Js
         mmJhU19uar3YTBFk4lLuz4+NmOmgPIkEUHo10UEtxoMXOruz3yYDFoAAX33jjqT4XHpY
         6ytA==
X-Forwarded-Encrypted: i=1; AJvYcCUwOJfG1IwE6q+qrEmI+/hnFzh7DH1Dt/Vx2z+ToXVMyyFhOQGnx93yZjS1cMQffYR4nkBJAXZmYnrp@vger.kernel.org
X-Gm-Message-State: AOJu0YwkIH4ET8Jq2XwN6vM7H/EP5GuDxwoRwAtToSPdNJ9BVQPtKfF/
	Nv2pFA8Z4I3Z7NWDRj6vXujPPLO+CT5FbRvvDZpJ5UVfcXF1vLzvGS6CyRRQPZE9R7AbRD6ftpg
	N9frVDXEgql6EPFNQzwZO7UcmtyIPiA==
X-Gm-Gg: ASbGncsBtyGrQPN3yjRlYyFHnKUnGqoonUkyoABiJchOp+rpExehUkc+r7qlh0opQRY
	GNGgNr2dw6muOu6LTVFU1kRfw9qzf/iel3GY=
X-Google-Smtp-Source: AGHT+IEngmLzDq3hNcwbU0zfck1WreMthSaGtFlM/t7NWS5k8KrFe768f4HdCbwf1//czeBckNkojQgz7iSswe7REyA=
X-Received: by 2002:ac2:5e9d:0:b0:542:2166:44cb with SMTP id
 2adb3069b0e04-5439c282b25mr231932e87.35.1737089351788; Thu, 16 Jan 2025
 20:49:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Jan 2025 22:49:00 -0600
X-Gm-Features: AbW1kvZrl7R8-3nK0hX-0Witd3YFXEWNR9rlLU12ZuE96UIdc258GKaZdIhyzeg
Message-ID: <CAH2r5mu3N+w35w+z_UAK4gnriBD+2gxvemXXR93XS_wF9nMRNQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5bc55a333a2f7316b58edc7573e8e893f7acb532:

  Linux 6.13-rc7 (2025-01-12 14:37:56 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc7-SMB3-client-fixes

for you to fetch changes up to fa2f9906a7b333ba757a7dbae0713d8a5396186e:

  smb: client: fix double free of TCP_Server_Info::hostname
(2025-01-15 16:56:06 -0600)

----------------------------------------------------------------
two client fixes, both for stable
- fix double free when reconnect racing with closing session
- fix SMB1 reconnect with password rotation

----------------------------------------------------------------
Meetakshi Setiya (1):
      cifs: support reconnect with alternate password for SMB1

Paulo Alcantara (1):
      smb: client: fix double free of TCP_Server_Info::hostname

 fs/smb/client/cifssmb.c | 11 ++++++++++-
 fs/smb/client/connect.c |  3 +--
 2 files changed, 11 insertions(+), 3 deletions(-)

--
Thanks,

Steve

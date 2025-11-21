Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3DC34DB7E
	for <linux-cifs@vger.kernel.org>; Fri, 21 Nov 2025 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763736208; cv=none; b=Y/xgLiXytAlps1/fZXnkeTSBTS3nv+umCPrMA8hogwBJlqqk2VB6E9tNb0UxPkus3V2bBRzd0MVIvuQ3RGa7yUg/LU86alHLzzrEYTPYo072NtKlHYWJFYzmd22PnhIrhnQBPvtpIi+lZiYMMpquTFNNoe13jFHiTWRxVXnQ9eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763736208; c=relaxed/simple;
	bh=c9L40OmvHbecjvzAW/ne03kRyanztKQPeAGVWZhNJ08=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=oR5A5GBhpfI5LIeiQdBTsaSp0639o5a9LPY50WOhtDu7WT/u6tSuI1qkUsAEdcRt194MYsT6rusKkln0DTB20fuToiEkrzTuQKaxsaC8P1HBu+8erPiL/i4lC4eioqRHO0HLfPZloiHHsLJO5PlhXX+j3M1vrbk4tnhZU7UWh50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=byYVPiPZ; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="byYVPiPZ"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4eddfb8c7f5so17367741cf.1
        for <linux-cifs@vger.kernel.org>; Fri, 21 Nov 2025 06:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763736205; x=1764341005; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ZYzWkM1olYNnl9KKLaWwJ7iDH6KAGDHOB4cHmPhPBGs=;
        b=byYVPiPZfQysnwJaoGVn50GMThKnJ30RcE+I2XeIMtGm9eHhk8lSb5rEcrbx8M/vju
         84vdKPe83NBviWLiBJ3lTM0Asrj/NZBPxYQ6FsJTGw65F7/zDZxbZI1E2r4QGYyEm3HZ
         1s9UE0Osr477yP/RlymIxJX5WeQV3UjHejUwX/+rKeo7QrbrGO/3MZ2JWlLRLT7XeesQ
         PLuUqcxxUtFLR0e8Al3hU0zLx+8PTD1EajhTk5XveXIyCbPjmECa3J1TxTMJYEwo7cLV
         dxubnBTRSi45KBGvppOqMagfDPaT41+7JGTjqj4CqEU5Q+2WzX1auWvSTNZQW6caQper
         XWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763736205; x=1764341005;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZYzWkM1olYNnl9KKLaWwJ7iDH6KAGDHOB4cHmPhPBGs=;
        b=VGkjIDRRBXPFnnTUUKaMYaXuvQMRgc2KD/dc7mf6QVHDAldbmhR1pdExxJA4heIXBv
         S/f3BDw3NjDQHnBD8pYqs/szzATxIoUXCS/yYqswhHZrdQVQjIKly/f3gM89B/5M2ulR
         /HZ/dRAXRm9eV9ClZ7e1zLoern+mxw+A9UHKSciI6c7YH75e1Hgb8I1nYz/N4xDtNQvv
         J0skOaS+p+zYM6Vd6dNy2MjlIm2JKkSd2Zsx03L9PLGna6+s7MD8/3coN6x3mMahH6sM
         aYf9kYBY/3eEPSbIF3pM6bt6dzUxYyr/t9edxewBgggFAakwYEvPo083CofgnhIFDsyy
         s27Q==
X-Gm-Message-State: AOJu0Yzlcn4dI8QQH7qJCM0e8oiDkV3zBvSRaH1NbLr/hRlpACTVL9LR
	YCHammh8iiF8W5/DLxv79Ugm1YX627JkYrqPz70TRE/B1icXK4w9WqEmXo+i/xAgpZCPCisioaH
	n7awFwGtrDsNQ3FS0zQBP/hRuxgsyVFw=
X-Gm-Gg: ASbGncuhX4gfAzgUELx4d5WpGBm4VSKtijyc9DOiS0pBJsZrrcMjIyl7h4xR7qFFA+k
	wEDKoVUTD6GYUypcBYyUpiB3/mXs5rKJhe2jVjK+lY8yMFgIAhsABJTzCJCVsl09JecUU2uy87F
	twAoZ94Ih+6XNrO2FPExxGtIZ6JFQeOmm8ba8zZpLMHV370qo6pkkwB2oOZ1bciCiTdp8NmsMCe
	B6Hz8HPhAt3IRO1QGWhCy3M4Lg780EvMBqfeVxWA1Hfa7wi5JFgNi4MVNSI65IXbBIDZh/PqAuA
	6LzBpBuZ5IPgsKrFVZKLXBwCc1GgvtZhlCqOKIE3oxHGLfl+UxTGA2ZpXMALwqzmscPU7T21i/W
	PLSP0S0yio5ZDvpXsEBQuEcsPcS4RvPieBaQX1RMYwVIkoptHl91kqJ6PRwxYL6PqU2hkS49owV
	3bcGyk311KeA==
X-Google-Smtp-Source: AGHT+IEY5Egu4KDdVgD2eO0CophkWcFrszk0ybCSwMQ8/pzhjDGU02lYmPOsuJu01kObnIBQ4M3jeuG+Q0V2iusBo2s=
X-Received: by 2002:a05:622a:4ce:b0:4ee:483:311f with SMTP id
 d75a77b69052e-4ee5889f4e0mr29670621cf.54.1763736205445; Fri, 21 Nov 2025
 06:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 21 Nov 2025 08:43:10 -0600
X-Gm-Features: AWmQ_bkmLPo-C60yIhQNvxV1UwmlTfVN-ilsrJ6-q-BTHKkjMoRreBmQI_LA_20
Message-ID: <CAH2r5ms_sWbxSs4tq4kfLNwXLZVKn-TGOYRg1h+zQQSE=C-Fbw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6a23ae0a96a600d1d12557add110e0bb6e32730c:

  Linux 6.18-rc6 (2025-11-16 14:25:38 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.18-rc6-smb3-client-fixes

for you to fetch changes up to d5227c88174c384d83d9176bd4315ef13dce306c:

  cifs: Add the smb3_read_* tracepoints to SMB1 (2025-11-20 03:12:05 -0600)

----------------------------------------------------------------
Three smb3 client fixes
- Fix potential memory leak in mount
- Add some missing read tracepoints
- Fix locking issue with directory leases
----------------------------------------------------------------
David Howells (1):
      cifs: Add the smb3_read_* tracepoints to SMB1

Henrique Carvalho (1):
      smb: client: introduce close_cached_dir_locked()

Shaurya Rane (1):
      cifs: fix memory leak in smb3_fs_context_parse_param error path

 fs/smb/client/cached_dir.c | 41 ++++++++++++++++++++++++++++++++++++++---
 fs/smb/client/cifssmb.c    | 22 ++++++++++++++++++++++
 fs/smb/client/fs_context.c |  4 ++++
 3 files changed, 64 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve

Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9A2CA9;
	Sat, 14 Jun 2025 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749917644; cv=none; b=F5j8ugx/2cKBB9PLZIgHQeiffkqBu+E1b0PIguxO2s0Mmz2DZGIeMWOAfGifqJ5cOa4a35PV1v2oeulHdnO0Z6cAvDrpXXbn27qrz64xM4UPiXiZ1L8KV6h3THzoHjTglp8hDwBy3FuIih6zaATFSIGzABaorUTBibJn0msahIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749917644; c=relaxed/simple;
	bh=e+/zlE6xyaYgObCF7so8RDR/0o5dI2JueOMf3qzeEXY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QNzxyONwy0J1Ymu598yPmWqZs53ZhmTCpM1dysCy4X4mEb1U/lZ6MPTNoOOPQ5qwWCBCkNs2kDNObOKG+RdT30VVGJb+aeMlRxBu7gJvwrtIKJsFYAVdLstqNbD60kam1T2ZvzdYsDcQPeKmA4UZ1jFlMRD6DcRNI+JXnrJDF3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrMP8Rkf; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrMP8Rkf"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-32b3c292bb4so20353071fa.1;
        Sat, 14 Jun 2025 09:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749917641; x=1750522441; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/YgRyCXygOFDd/rhvGyVUhq7/9zR28ePgeTQ2WjwLUs=;
        b=TrMP8Rkf+2PAyAi8XRu8CX7F2GAWvAoID2dinavRjZJG74gqRXk9zgJYDu1f17SL6F
         pDyeN5X6PFMPsG5BmDcxPfvjV53pnpQY3akZBHCYEd+OVUPv62HHLihlVfCSWlFyTrTp
         GnJHXSb3lerHUrvq29TPsC/q2IIwjQTkZlksIxc7TTI7gBWWDikvnozcoN2a+cJGFfqA
         aLCGu4/C3H22EGbOOUGyzGrXXIXfZUU1z4UhbJbPpl85I9/PL5SmKNtK66kTpc6m2LMQ
         qA7/9oQkBg8WFDlW6CRW585idu3fQ8abcc7tzvngm/peFR6qzDji9NhmFWlmb1TwHvpL
         6CGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749917641; x=1750522441;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/YgRyCXygOFDd/rhvGyVUhq7/9zR28ePgeTQ2WjwLUs=;
        b=bamxKvazz8JYhYIYY9cIJpSOwh2S7s586UgC0+SaTLPzVHqiREbbahuMh5Hx5bUycC
         tcxOHce2Uv+rCtezvURQH3QfKo0mtDOxsNCzT/lsM2Uz3rvE/K1WeeEidHNAiqUS6N8q
         vNcIKiUCB0+som0Ty2o/mJnA3Pl5f0vOZyMoqkjDnQqOwZAZQFyxlWGzH8p5FMoI5S9+
         BTzSIFyUkt8c6n/GGdCUk7cLPz4MehWYQ6NrVmobd1Y6MfXeNdAz/bOVEBacsNnAN+84
         0i5hiyWXPrFIu67ngsiXqaorurxEOTZ0X9CMCg5AIs8Vhag9EjkDZ90qLMWBlsnFrMKs
         /KmA==
X-Forwarded-Encrypted: i=1; AJvYcCWiyuTy7wmw+Ak7YvxxiyCzwnEZYq1GGPht+MbPz0grHPXAD6m8pdj7lSTGqWjIZMAonTbIYpjYVEFh@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/y9dJu7n9ZxSqDfRzjHrAWiO/F+Q8c1ogd7wjE/b+wLVE3Ofd
	mov70Z2xluA1s529ym+iH1hEtNRrZxYe2HSNP1QYhH3RpYyeMF+9rmzAdnRl6Ivnaj6Dx0tNgRY
	3uK8VHUBg8Fui8bLZCpMJx5c98Wr58Uc6S/l6
X-Gm-Gg: ASbGnct4DkkJB0pR1yr0SminZfjslgHDOkfUEyzaAAhMsdXpXdNOG4tLPQtCTi1ImD1
	HuLBONNEhpZ4BLfXGtYa1URg84IG+6CJyfqsUDfHJD6N0s2dw8otaOo5gpp/7SHiu2se16nOeYv
	wPS5nW8g2Fb8aoG9/2HUjuClG/svksoUwbZ+uD32CWOCIzynIqZmT9/JCuc1dz1YnrdUU+Xlelu
	HkB6Q==
X-Google-Smtp-Source: AGHT+IHmF0kiq/suVB3X/Ly/6h0VJFx5kF7zb+6Gsd5VTUl93chnoBak+Bc331rM1FFlJD4I5+k5Fzn6qtF3m/+a9SI=
X-Received: by 2002:a2e:bb9e:0:b0:32a:ec98:e15a with SMTP id
 38308e7fff4ca-32b4a5c5202mr6416801fa.36.1749917640509; Sat, 14 Jun 2025
 09:14:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 14 Jun 2025 11:13:49 -0500
X-Gm-Features: AX0GCFsA-QLpiw_wQ1XJ6N3s9v7-RRco9QUToJ6t-4RR1aM0aBN7Fin1ZfoJSGs
Message-ID: <CAH2r5msg0f6EP24x6dQyt8CbGs9OD6EzQV7rOW0=8gkfLFvJ=w@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
19272b37aa4f83ca52bdf9c16d5d81bdd1354494:

  Linux 6.16-rc1 (2025-06-08 13:44:43 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc1-smb3-client-fixes

for you to fetch changes up to 72dd7961a4bb4fa1fc456169a61dd12e68e50645:

  smb: improve directory cache reuse for readdir operations
(2025-06-12 13:38:21 -0500)

----------------------------------------------------------------
Three smb3 client fixes
- SMB3.1.1 POSIX extensions fix for char remapping
- Fix for repeated directory listings when directory leases enabled
- deferred close handle reuse fix
----------------------------------------------------------------
Bharath SM (1):
      smb: improve directory cache reuse for readdir operations

Paulo Alcantara (1):
      smb: client: fix perf regression with deferred closes

Philipp Kerling (1):
      smb: client: disable path remapping with POSIX extensions

 Documentation/admin-guide/cifs/usage.rst |  2 ++
 fs/smb/client/cached_dir.h               |  8 ++++----
 fs/smb/client/connect.c                  | 10 ++++++++--
 fs/smb/client/file.c                     |  9 ++++++---
 fs/smb/client/readdir.c                  | 28 +++++++++++++++-------------
 5 files changed, 35 insertions(+), 22 deletions(-)


-- 
Thanks,

Steve

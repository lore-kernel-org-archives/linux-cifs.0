Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD472382;
	Sun, 28 Jul 2024 00:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722126923; cv=none; b=eyU8i29oJuruJYWE+lcrtxtJUQChgQfkR6hO6Qmwob1TDB5wBRFJxYBNBdSm9LBKEfYTMvlYBaCR8VCh6NXpj1Fyx4qn1ciH33YnxJhGRaRRsYaBvpKOq91dx2XkGPizoeZXJ6UBOYe4O15mwAUPkG+ey3DQ0tyuyAf2ZN5G3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722126923; c=relaxed/simple;
	bh=aO61I0v/qao+UoDLht3IIF69/kCgfI5KNSjSzGL3zVE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=i4Ab0SUe5aLUBuRbKSSNfyRO+QGBr/mB9DpyxL8kCEznug1wF6cMqHIz7AXUmnJNoqYrD4+5cWJzErAdfRpFSq8CZKw+hXWE6893IU4omySX2X/FdSCfLujKy5Kti7WC21qeP2Pf8nuA484VOUqLHxIYDzA+S0SZjOWPNvtBHeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YSxIt1Fg; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YSxIt1Fg"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2f040733086so27005121fa.1;
        Sat, 27 Jul 2024 17:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722126920; x=1722731720; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vHrFGGQW7WEzTSEJx91bUUFVGQDkOrk8pgkc3hN4gDo=;
        b=YSxIt1Fg6OGyPsojhcRcdQJ1UyxO5ZdLpmOMuEtoTYffTNjzPgvtcEGXfXkV/hqerx
         ySnx5LD7PwWgtHfvmg00skvkwzK8rTT2XCTo6cB3iTnvyPXhiLeZI5uY1FcCej+b65Y6
         B5MwoJVhw8NvwwgXNLEhDAME5hMW3QCmXDcD7r5DRhnCkzhCkfkOO74zy5eQG58WlIR9
         feJ0dVPjgOT/wieWpVKg66CyUl1JbOAvO6dol2DFeMMOs94mgdghEBBb5KzOo3nFtaJu
         KuDlc7SFYvKO8x2aH+gKPfo8YwoSj6j7A5yLtkQPWAZ7YZV0K+/Yu0qRoTvtyqLzfYV/
         SqOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722126920; x=1722731720;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHrFGGQW7WEzTSEJx91bUUFVGQDkOrk8pgkc3hN4gDo=;
        b=hq336Jaykp1+cagYxGkBkTzkRRMn6v9sPy26MK5Eh7HE/TV1Fks+L9vqWB34Sr/x8M
         utth5Su6+T/IWZmvVNEebZFXS8vPuRq3lFvPRykHDAoCxS9obAxy8RFJhxMvqEhCiRIr
         Wftn/F9iJxQtTMa4cIVT2OBkVUDZwUT9CGtm1/Ybrc+bZ8LifFAwh948azTYOabm2fjk
         M+qgN5T3raPnCLUV38xVU8R69T/+l3HEIwuI2hbxnj4+3R4B9wxxEDp9UjV8eiOMe4TI
         xyuDx6ONYcsTPQhGaR0lTNdUluNaQbJS+yvu+TpMszOe34yu8z4ZCUG3eNTLZ9ok7tbV
         G19A==
X-Forwarded-Encrypted: i=1; AJvYcCUFhT2NBXnuxYzxajR8T/wrz2qDMiWN4FYPezlUv3W3fRJNdgYxbDARwIqQbs/wK0aWAjHkgy4zZ7HLnMPWjWs7wbaF0ay1+im4GnvY
X-Gm-Message-State: AOJu0YxKj1donXSQsR38VxnSH0I88NbRlRaA3Ayy0Mhk7t56vuG8fSUV
	81pQuDJ4hutGIDkWHZGpKu8pp+mpvxFnO5pLgP1HgFFOz0GdAqikcgCPIKKDXJ3V3CFOQ3qpcL/
	h9FaHOXhjQnUI8LpPbeBjW7CTx3ySeLBC
X-Google-Smtp-Source: AGHT+IE82gkxjoYFy4bOVPvVzjh6TvGugjLGrSDLaYbXJUpwjmRXOPO0mNF2jMhxmdepoA7J7DqZT3PqLq8KBlfRsEA=
X-Received: by 2002:ac2:4bd1:0:b0:52e:9b92:4999 with SMTP id
 2adb3069b0e04-5309b269ae5mr3149605e87.2.1722126919483; Sat, 27 Jul 2024
 17:35:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 27 Jul 2024 19:35:08 -0500
Message-ID: <CAH2r5msuLY9XywuKvnggezTdjCBQx8HDfYhHNstS-Yijz15sdg@mail.gmail.com>
Subject: [GIT PULL] SMB3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
33c9de2960d347c06d016c2c07ac4aa855cd75f0:

  Merge tag '6.11-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2024-07-21 15:23:39 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.11-rc-smb-client-fixes-part2

for you to fetch changes up to b6f6a7aa689f1c255e06fee3ca13c9f9e5c12780:

  smb3: add dynamic trace point for session setup key expired failures
(2024-07-26 12:34:50 -0500)

----------------------------------------------------------------
Six smb3 client fixes
- fix for potential null pointer use in init cifs
- three additional dynamic trace points to improve debugging of some
common scenarios
- two SMB1 fixes (one addressing reconnect with POSIX extensions, one
a mount parsing error)

There are some additional patches SMB3.1.1 compression improvements
and a locking fix that are still being debugged and are not included
in this P/R
----------------------------------------------------------------
Steve French (6):
      cifs: fix potential null pointer use in destroy_workqueue in
init_cifs error path
      cifs: fix reconnect with SMB1 UNIX Extensions
      cifs: mount with "unix" mount option for SMB1 incorrectly handled
      smb3: add dynamic tracepoint for reflink errors
      smb3: add four dynamic tracepoints for copy_file_range and reflink
      smb3: add dynamic trace point for session setup key expired failures

 fs/smb/client/cifsfs.c  |   8 +++---
 fs/smb/client/connect.c |  24 ++++++++++++++++-
 fs/smb/client/smb2ops.c |  20 +++++++++++++-
 fs/smb/client/smb2pdu.c |   8 +++++-
 fs/smb/client/trace.h   | 150
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 203 insertions(+), 7 deletions(-)

-- 
Thanks,

Steve

Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83A232AAAA
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 16:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760633577; cv=none; b=l7ni+SBJ9mlDG48ANpPIrY4izLUDeRZjcYaROidhvEPqHPenFuLiHcaka8y4JatJm0IQLDJyAzN6CCZgYu/nqhnAUgziYaOYwSbFviM3KZ2esJ53PkBeEqpRiDfYH9zdFBdcnxyCWkG8hZ82r1kjVrJ77yktrM7O1d/52HnS8gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760633577; c=relaxed/simple;
	bh=91r2Z9uzGui6jXDDbwibTsOiKmukFVeg4rpidFEE7Xc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EeY4seJ1Dh3uVzIAbtpmyS5hBnOZcUmBJjrsK8RWdvJ1VxW+s0QyVY2SNo1tm8TmEoGyckUopNZnkfN7uAWbedabj5HfthCSq5oPMsOJ1jnwR+JOER0s7T679KBO4T7h1P+5L+B/qzpakRntrIhp5IAg7QupAFwyf0s4guJTwbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X43P2cyr; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X43P2cyr"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-87bb66dd224so13442096d6.3
        for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 09:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760633574; x=1761238374; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aKSl3+cfP1Vo2Qx3JDVFT4eNJLa+wkzdcmaYs35sXUE=;
        b=X43P2cyrB5YBvI6WPgCXtpWcVFq3tKeQJ9A95Ha3fV1E6f9kvypFlBLeFNrXBrA35/
         2MpsguqkrEjFnCnSLHEdMX6Yd0Gpb0U6DPab3sueW7n9efmAT6Sl+L2IrnbnX5vuifYa
         bS9vSHUlOLx4fn1boqMP6TQguliKeFh5EFUid46aF7nCXU2ExT+j9TG8eYdREt3HcAPf
         9Y+RTLOsq98JOmhVSdN02pIUrg7JtHGpNufUKQ31iAl6kthSR2BNTOIutTHn9j2kn4vR
         9P3X6KKVHX55+J594wnzMmY7e3rR/xV5PE3IaX7rKRbZQmqHC7tpjXmZay9foTqaw9ai
         tXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760633574; x=1761238374;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aKSl3+cfP1Vo2Qx3JDVFT4eNJLa+wkzdcmaYs35sXUE=;
        b=os/vIBToGLUuW5JrV9GfmhhX0OWLy5yjkiSKuWX4J0nhElt8xElzBppi6FTBBspvzQ
         3xWhdShFXYjyC37IDi22VWZ3e8B0aLPe6AGgDOfUSlsOaf2mH9hPkvRePFbI7qQv8aml
         R+6re4YNaBZMtVQeesvOzS4opovN3P+5hdSDDLwCgxRDVys67XF0NSzwp7opaR23+Cd0
         2Hclb/JXmoWIL5V4VABnMt2UQElCs54UC6K7gFCy3Rg9v+tGdVEQxZQZEtJq0U4WWVe7
         ++cNKNXDdfBTyQzf6dt1ZQAtizjbKLdYoPXy5LtPzzndW/GTtL+kjp5/9QqJGumMYk7o
         Cwjw==
X-Forwarded-Encrypted: i=1; AJvYcCWSNw53qAwDvTivuT8hz9BwDsdlOb7mYWeflRiL35ZTL2hYr+ptY81GwWqPsa6+FF90X8pwLSEAncY1@vger.kernel.org
X-Gm-Message-State: AOJu0YxYnj59qVnkDMwjccdQoryhqdghm2dxOq8NUeZ01vg/tfCBjP0Z
	75JaNzFzF9oSduYX7rImIWw8dFcGWO+k/TSwgTfkLo+jhvVQYBgCeLjJ8H3lDjIR+VawFYMMoWc
	MKe+kIT/oDV+5E/kCyB/Fp7yYGzzUbZ8=
X-Gm-Gg: ASbGnctLNs3BwTErwYWFEJLY/z+60TybJdZZT2Z7bEjCWuFWW13JJwdMYqVLCJZG9xC
	WAZ5rNsgRHcAceHQwAR9HzuoGogzXgTDKD+8CdiWDSbeieShKDg8u+Vq5WnypVf8ogbVqdpivCt
	mH7yA8qlaFwJe3fxgreiZnPT7gTBn9IxtM6IK46+6fVfMLrSraj2jdZssVh5YJxNHPxplozbqng
	C2wER53R30IVV/ERS+fYAHxexsnHwh/Or0I2MOQ+7O7HGfuOQy73oQnNKC7r5kZAY2zIUG8YF1c
	eXIibMYokpT7+jTjOV+3xZ5eHCsj91JdorMgDN5a/V0m16SCddEUXeXijw8wPBHv8M1BL+GYwt6
	6t+2aAA4VBsE8giHuxDu0AruOq+p4LXFZ4S/14DTv1lGcPycfbvNznUt4KZ5A1TeRHl+AllRzOY
	agVpoqRPpzZtv9Ag8mLHfL
X-Google-Smtp-Source: AGHT+IGJWK3C6CF6OQJYzlqP095zFMaxgQUYflqcsTg/NQ3H0vdkLJDgmLZOaPUa6ctU9X5Y9xly2T64YAiDFjsV7QE=
X-Received: by 2002:ad4:5dc7:0:b0:851:746c:e6d7 with SMTP id
 6a1803df08f44-87c2055e644mr14330976d6.8.1760633574307; Thu, 16 Oct 2025
 09:52:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 16 Oct 2025 11:52:42 -0500
X-Gm-Features: AS18NWBpxJH37Hbj1jPUIn9nxP1UtWfLrFrfUeFXBooZHwdcuASwvIpONS-PBxg
Message-ID: <CAH2r5mt98+bMTuyp+AuEJMi8rCo+2PTxy=a8a_gXi4AyLuSG+A@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
3a8660878839faadb4f1a6dd72c3179c1df56787:

  Linux 6.18-rc1 (2025-10-12 13:42:36 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc1-smb-server-fixes

for you to fetch changes up to 88f170814fea74911ceab798a43cbd7c5599bed4:

  ksmbd: fix recursive locking in RPC handle list access (2025-10-15
06:03:09 -0500)

----------------------------------------------------------------
Three ksmbd fixes, and one cleanup
- Fix RPC hang due to locking bug
- Fix for memory leak  in read and refcount leak (in session setup)
- Minor cleanup
----------------------------------------------------------------
Marios Makassikis (1):
      ksmbd: fix recursive locking in RPC handle list access

Markus Elfring (1):
      smb: server: Use common error handling code in smb_direct_rdma_xmit()

ZhangGuoDong (2):
      smb/server: fix possible memory leak in smb2_read()
      smb/server: fix possible refcount leak in smb2_sess_setup()

 fs/smb/server/mgmt/user_session.c |  7 ++-----
 fs/smb/server/smb2pdu.c           | 11 ++++++++++-
 fs/smb/server/transport_ipc.c     | 12 ++++++++++++
 fs/smb/server/transport_rdma.c    | 20 ++++++++++----------
 4 files changed, 34 insertions(+), 16 deletions(-)

-- 
Thanks,

Steve

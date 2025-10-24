Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E981F03EF
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 14:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761316275; cv=none; b=BXHxo8p/P44j/KZLML/r0MYSwEjxOKPI7SO5aLnr7Wj+GYzPCdfD0RdRr7GP95CshhqJO1LaHX4FgG+3S1sx1QXxxQsVUWsTTpaPU2R6392ltLE8e7yBbjJh7xTH7whhVlewZx9Ic3ECEOKtNh5gHDHdDg8KOfZLJ+0+UQ+8cI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761316275; c=relaxed/simple;
	bh=YwWaL7YELIgYKGB8/RNOfIPO+vpDTLb5fhNB+3MDkO0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EndUviyDfCVwI/1uq8BiN6+Ukgru+BWILEoEAkqxbUMUuf8v1m8h45cL7VlMCWqdvMWPVqtP5FXNCRnweIJ1T5/qBn6M+oSFeP+u2/bVdMzce8RkUkSoO8LbL6AMhkEIzcxt8fVnJQ0SNX190eDXsnscm5s6D7blhZPSS6zoo30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D2YE9Ct0; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2YE9Ct0"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-78e4056623fso21192726d6.2
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 07:31:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761316272; x=1761921072; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0SfcH6cGIjO4GCF81rPy0gjRHBMgVWt4XFd5yPJO6t4=;
        b=D2YE9Ct0sQbdyKm7QkYZJY5IURTf6OETJ4Ko3D3xNw1UPwQivNeK8HHqe7OhuiPSck
         K9TDnAqv60UI8JluNeFiumJzR2er5gvoohBQ7CSl3Q3mD/sidcR9eQEPX8roCEYr7fEa
         83l42Uz8GD0d3smGmEuaoZcj1PoJRCulIx7dPeWRMjS9ciEbf7gkJj7nMIAz5pXlH/Qq
         sVJH8/T1+oA3cWh6pD71Gx6AeVihHlgpFtqphVcmt8xMqfLRYJNyuU7hxbqIk4MqUV8J
         7MoN1eXlE5PgyHl7BBjAyIeVotcMdUnLuTja7WCuHiwueIBg+SqR1+Sl3XSm8Ztx7+7I
         LbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316272; x=1761921072;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0SfcH6cGIjO4GCF81rPy0gjRHBMgVWt4XFd5yPJO6t4=;
        b=STqoH8HC6DhCfSNp8+PgsIxCUMsPuwJeOZ57vEJb6/zZSYeBKQjVZHs1tGqSaakflr
         CU7JGtVx7jYULmw8PmcKf99amxzmsssgvUNzdbVMkHwfstfHP7DRIYcYr7rsfJj3ihHs
         gyHhzUaQpwraY+uyGuasJyrE2V4NfKABrSLcHHBt4oBV/n/D5DjAOnEbHHzovcLHX+QN
         8S5RfmJC7tel4Eu2Xb46eiVo20USXajWgZay/2zs7RCHAIoNbyrQ4MPfTZi0NJYtUPzz
         5BOR0bLmr+m0cIGeT8DDlTwy1VGyuf8lywhTnB8TrdFh9WMyFlh105E7mDgBGAVUWR5G
         ujZw==
X-Forwarded-Encrypted: i=1; AJvYcCUuayK42GnJDbautJn158okVUSPbuac2yGadELqVXErqTpHXV1gD6NPVFCWaXvjaC9w+HXG7iz8H1me@vger.kernel.org
X-Gm-Message-State: AOJu0YyWwlr3gbmd5R/mhe78m+FUMjevlzD9qCuTVgUqTeUqdQMzANsV
	mI7ZZoH54KpskZI11liX5+jcGMG+64lTiBZwxYlTMTLOh+COl4P1zMlS7J9BjM2c616YC2vP39U
	PR601RabuMab/TXuxcJA67ISBSMWWtDI=
X-Gm-Gg: ASbGncvKzohgEEbnsUJqtnayDqnrrVJEpkVLsbz/fi/Sr9JCXdqYlqt4bgeHwbTX0Uv
	6AIWGm+HEd0LcDWpvshEAKcigOSl0rErOs85BQioLo2oI05mhwgWIZ5z8ydcn6QGvMnu00p+EEf
	QVZhCCLypAhGU7ghOBPoa3AUzhrWkUy61Fd57xcNEwksWUSw4kdYvfAmywUT1eGa0IUDNAyIwUz
	eGj8edDPywrfGPjyB3H0+N9mKt+jehjnlvEBP08JszhvbJI2gHgEq/AA888oUx/Y8pB0FhEKVmj
	P3TzatjVl5jEIMQ/ZMigtF7Jjcv/qSaD+O6APqnnXDzxrXGuow9PtyWzg/Ixor4TaIU1yj3/tOs
	tMYHj1HT2BR6ktRI+5Mk9ZbiX/4SvPZ1VWzvTQYZYJcjBZb30avJxZ4A/vyd2s9NEDZirb2iPUf
	+be1McPyqAmBn2OIAIYyY7
X-Google-Smtp-Source: AGHT+IH6Onrt1C57J648mHfgDzK7l5oADdvj83TGXRqZO0zc/iSil8hZgrdfB9t9cPOweL58IPlDUnQzrdV5d+yu3bQ=
X-Received: by 2002:a05:6214:2a84:b0:87f:b2f2:c591 with SMTP id
 6a1803df08f44-87fb2f2c6cdmr43135406d6.62.1761316272532; Fri, 24 Oct 2025
 07:31:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Oct 2025 09:31:01 -0500
X-Gm-Features: AWmQ_bn5GytQ4_bDnpEs9WssDXChStMg2wmQo6fAZTzxfcRt45URfRBpCcQuu4s
Message-ID: <CAH2r5mtRwOOJo1J_dR_2M4FwPcc1=LP1+NczMV8-PKJf+M=k-g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc2-smb-client-fixes

for you to fetch changes up to 64c9471aa9ded2440bf182b1c71d3f93f80b2f85:

  cifs: #include cifsglob.h before trace.h to allow structs in
tracepoints (2025-10-23 02:47:20 -0500)

----------------------------------------------------------------
Six smb client fixes
- add missing tracepoints
- smbdirect (RDMA) fix
- fix potential issue with credits underflow
- rename fix
- improvement to calc_signature and additional cleanup patch

----------------------------------------------------------------
David Howells (4):
      cifs: Add a couple of missing smb3_rw_credits tracepoints
      cifs: Fix TCP_Server_Info::credits to be signed
      cifs: Call the calc_signature functions directly
      cifs: #include cifsglob.h before trace.h to allow structs in tracepoints

Paulo Alcantara (1):
      smb: client: get rid of d_drop() in cifs_do_rename()

Stefan Metzmacher (1):
      smb: client: allocate enough space for MR WRs and ib_drain_qp()

 fs/smb/client/cifsglob.h      |  4 +---
 fs/smb/client/cifsproto.h     |  1 +
 fs/smb/client/cifssmb.c       |  8 ++++++++
 fs/smb/client/inode.c         |  5 +----
 fs/smb/client/smb2ops.c       |  4 ----
 fs/smb/client/smb2proto.h     |  6 ------
 fs/smb/client/smb2transport.c | 18 +++++++++---------
 fs/smb/client/smbdirect.c     | 36 +++++++++++++++++++++++-------------
 fs/smb/client/trace.c         |  1 +
 9 files changed, 44 insertions(+), 39 deletions(-)


--
Thanks,

Steve

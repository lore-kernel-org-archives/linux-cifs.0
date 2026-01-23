Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1C2158DA3
	for <linux-cifs@vger.kernel.org>; Fri, 23 Jan 2026 17:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769190646; cv=pass; b=Ca3amDgD0L7YuHgU3vh0Sj2R85pcBUwn5DfWEIGlOJrMydY4p7LqtmEg9LmX9KjBwNOyVnGqKOwDMNx3B+pxhuaMo+0P2BR2N3vTFweoFH5sB9KY6OKZ5Io+m6xgu0GrZHVwzrs862GFMGSx12uI3pixAHuNbXQyzPMH0/n9S6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769190646; c=relaxed/simple;
	bh=w/cpcvfy+P2Ox4eb4c8bq6u+vw2NVvsh1yXpaNemkxY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rsfc1vbTTkt2fv/AXU9SdNZePuVPul+qZFlWe641IxwBBoIdXkKP7sFU8CnvQeKF56cLGfhAT/Nua8o50vkTVzdoTooe4lgCP4x6DYO8tMsUuTPPivhoKL0Br7Kuhzd1v592ZztJyge2NeePRwhqqhzZh+7jOVXpt25vOs1svh0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bSy/N7pC; arc=pass smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bSy/N7pC"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8c533228383so148132185a.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Jan 2026 09:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769190644; cv=none;
        d=google.com; s=arc-20240605;
        b=WPAmmyb8/Of+LjhfHjX+AvQyVTYoX0Gz27JmmaAWQA2DdItxlctSj0fHIdGk1vhZrD
         Rgs/ZcYBzuPRMG0YiKvnCRc8k9pP8NJZujQ33WbIiP0ZtuNtufe+VkEYmfBiLUevsmpJ
         lTTlsG961gwd18a8vweOWASYpxFsxkMyJSl4rAEC4sLVUQApcyDC3/YS7QptyAtJ0OUO
         Exh/5ktc7EXXYDscrs1v7xnCYKwtFV9zjX4wgnawb2eJF+ISsSvjGQwkbRfDChfiQaKY
         c3VEioaxdQwsTUgOhrQf8T1fd8B9hfsGwdkKtrMrCmagBJ6lr93nzF+wvjd4XenD7GIZ
         DNEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=4vBY38R6f9FpMThI/pgkF/oG1rXdSrNTc80+WrsLqyc=;
        fh=bvXZhBm/kZgMd0JbIaGmXmQllmSv8otjIMpg/oAU0ao=;
        b=luUScoHl8ZllbEatX2GOeR0gX6Ehaewpz8FXS4AYOHstw/zHNxGnWrIsVBF9XSOB0E
         I6web1aapLWr2akyf0RhmIQXezA5JJkZCvHxfabUbLqvsk1dFmNtR2TlcIA3LlqRjqnB
         Cv38qHE4O/q7yCZ+tB25lv9aVMxKms81j+V3hDxfy1sNaU/PZzo7l4Z0OB+6CX/tq5xp
         0tlXsW0W4/rg3ST7G/vruhhT7sg9zQ6mWTapJhkPqagtnYsiwwrIfuAXh7gBHfukCz6y
         WyK/V6QMC0/EGdxPkM8O5mXZ3YJ4NC3vtXKOYIrgszFouvxYZHDZ2+rTnwodPve8Qaa/
         sWHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769190644; x=1769795444; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4vBY38R6f9FpMThI/pgkF/oG1rXdSrNTc80+WrsLqyc=;
        b=bSy/N7pCfTEkvI7ROMaUmsj58tgmLfKjVmRpg3x1eBxiUgfUUyD1wlN3blA16Gf98B
         xrMXW9bb+qe9f6hpTzRsQZ+y+3lI9zc8RNSQ2gzOVXPyLNAV0kTzmFcoRojcMTPoqLwn
         qAaqW5CONMW6/vYaic1XKkSZFnHY7oToTkiFBHF45s1hgSKFuPJhiZa0pt09YsO4P9BI
         cqcULmsFTDPmNTe1VXjbYtfNXf/tlx0QcLAE8WwNrAIWCvj7eJVcJ77vB4vKMYN50wZh
         1tXbgLBBcMdXTPfTpZ791JRJ9tKpBQI+nVih52+kfiwWDJd5yYTKgkEr3k31VJ/JIzRG
         aRPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769190644; x=1769795444;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4vBY38R6f9FpMThI/pgkF/oG1rXdSrNTc80+WrsLqyc=;
        b=BcpqcqxBjwdeezYCh5Upn4jJ1F36bVEtASazjGbBTz9r9+t8NWCHtHBnk7iKN3CTUf
         MvzA0SYYJ3zn57vG4GXDjRZCrarOJrMO5ksa2rAjs+F9qm4XXJwrHo6Wrvm0HnHZ1nEq
         XaxybW78+np3cq346rVuqAEWQojcoxbGg8JZH58/gLQ6+49swbI/GYmMoZfOmKz3PWbf
         yViywwzyijjEcDySSpXV+t9z/Obc19dvq4QsYcNL8hSFTpClxiiBF1v1N6Y2dzew5oer
         zqLV2zx3a/j2mLUqM7Q7nqdukOVLKF0WXuJhzDuogDo6GUCRnmcNUZxKwDTgW8BAPdWL
         mbEg==
X-Forwarded-Encrypted: i=1; AJvYcCVhMHK64g7HhmVhr94j3YlDAknY3Ljlf9BKDaT/Q9xx78KmxCWTcDPRLB0nuJggFtpu3PwXVB+1QJVU@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp6iGB0F5Ydzx6JrRhUX7lf9Bitm3qkwY9NDIeY2E3EffHa07V
	T2xQw8biZfWmYd1g5Vtrpcspz7eggPrIFxeR9YU+wHMpLMM6NJDBJlybWJDyoaELUgh6I5TehlA
	LkmyEp1P96blTJ6Lu7R8byJFJndHLfd4=
X-Gm-Gg: AZuq6aL6vx2cyZMW39iYTpqJb+NoS9VZdpIyaUuKVJSMfEsEXAQAwbJDlaxSFP65s/I
	MdfGID+2g/7p4nG0f7QFOVPQLFc5HbkpVf0U9nnc1BgOlvOQYPcNTiH6UIqqxMY4giB68/tYgyb
	bpuL9g+Grz3qvuoEpB0qiD/96ZGVdy6VNW8SOmLQeFJKN7phzEwGkP24Fc2YjtlDAo7eKTswNOm
	VSfd3eOoOVWIrDkGhbOq5A3csQHnPDz8pC6SJKuaPOJWfR4LnzCC6wDv/4eITqpGsLR4iH1/a1d
	F/Lr6M6DnBn9dRAegvo8mii4vwJgi2GVaAbmSc6dyOXU0n7P5im4KH7fYTFxsr2Y16soJPcD2z/
	tYi7eT6kKPKNF0HFZj97vdzj18J0pWF/gM7mhrY1Pn9N+EtPE8azV2MA9SgdSLj4BNk8M9RbpJR
	CTZYRtrPFBiQ==
X-Received: by 2002:a05:620a:d86:b0:8c3:7e51:94c6 with SMTP id
 af79cd13be357-8c6e2e2e578mr455631685a.60.1769190644374; Fri, 23 Jan 2026
 09:50:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 23 Jan 2026 11:50:33 -0600
X-Gm-Features: AZwV_Qj67N--d5HdiNaLzVPrDtvNFyzDFDfx4kOlYOBomyIfjMkeBtdKwlFDUL8
Message-ID: <CAH2r5mvaWKtqdCYTYv87mqdDzhy-Hw8vs5iTaWTryMzzD2hi9Q@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>, "Stefan (metze) Metzmacher" <metze@samba.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7:

  Linux 6.19-rc6 (2026-01-18 15:42:45 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc6-server-fixes

for you to fetch changes up to 5914d98ff0f7f9ec0e3963dbe2773401b02888ac:

  smb: server: reset smb_direct_port = SMB_DIRECT_PORT_INFINIBAND on
init (2026-01-22 18:13:44 -0600)

----------------------------------------------------------------
Three ksmbd server fixes:
- Use the original nents value for ib_dma_unmap_sg(), preventing
potential memory corruption in the RDMA transport layer.
- Fix a naming discrepancy in the kernel-doc for
ksmbd_vfs_kern_path_start_removing() as identified by sparse static
analysis.
- Reset smb_direct_port to its default value during initialization to
ensure the correct port is used when switching between different RDMA
device types without module reload.
----------------------------------------------------------------
Stefan Metzmacher (2):
      smb: server: fix comment for ksmbd_vfs_kern_path_start_removing()
      smb: server: reset smb_direct_port = SMB_DIRECT_PORT_INFINIBAND on init

Thomas Fourier (1):
      ksmbd: smbd: fix dma_unmap_sg() nents

 fs/smb/server/transport_rdma.c | 16 ++++++++--------
 fs/smb/server/vfs.c            |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

-- 
Thanks,

Steve

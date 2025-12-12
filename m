Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A00D310764
	for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 09:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765530335; cv=none; b=XQfJerYicp3GKN4kxCXnc7hpQFWxyduEBqt8mjxTdR6jn142TPhOsO+aWcdiRDsv/qXN3B1fgQDAhtVM48CuGMtm3hjGCVNfjomdx5mCT3Xoe+WPSlrCSfxI6TbIMhONYfgS5sxNVb42wszcDW8mg9QpncVtZIxoSJDXSfqQGjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765530335; c=relaxed/simple;
	bh=8SaIOqUDRfk/WXBcAnSZ1dZNMB/kQk+DL1ZcOZ3QWWk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bd34UmJcIDshMAW6oV5ooMOTuUHkawBY2bcfYbVsvKaoOypf/FYUy5A//CVUYjNxVWUuRktkJfP6ABLeiARfneCynM/s/g16LZU+fIUdIazppqkyDyJiPrLXMMR+qCWUxpwLSbqDSzofFJp0QT0aMPwOwhG2deRqjRaTztVUHCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VroVRNjt; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VroVRNjt"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-88244d1559eso9161176d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 01:05:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765530332; x=1766135132; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UHCtfFROb5decnHUbZXjamDKnZFipklx+EVjTu2nDGU=;
        b=VroVRNjtzQwp9E1F48L52+YtBfS2dsUwaRz6sgX1nuS9uf+ZeGY14q7fgGqRpeSJ/Y
         p3Pgrf++AuW34ceUTlFJ5ga4FiLAhvg5DAeNDMFMFxl5Xmtf8n+52gP9BF480YDjTtUj
         G8j+sqHUpG9i78TjvSnN6YXtOM8gyWqwsmSF2cnAKOF1L08o0xqwbH0Gv2Z5fuoyQoQ5
         21GY4Tt/41ntx42oeBEmjeL0yk1dD2XJ7PA487zYL4e0v2t2P9I47Wid8ir5IUiwaiS1
         fPOJej8cDLqyPagmDnsMDrdJJLGsnASkL7j9YJB3J9pacFKq5dAPeY61EZk40aDNODu3
         o9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765530332; x=1766135132;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UHCtfFROb5decnHUbZXjamDKnZFipklx+EVjTu2nDGU=;
        b=SslD0cU7+nvGB6M25fXd3T+LwqyxobDT3DMoT1FeZEs4VN9F1NJPWnz6Gx1FkLQkZS
         6jx1FKWcO/RqMA10fxfTD3OFc6U+yf9IoM+6nABrdpNRrzCmzbZcxDFnDjH2dR4HMcZX
         CpYucJPFswckk/kcmRr+Av/g8o1MtYy6m3EZr0wQON6l2UPq9C3SkrEScpexTQAWz9DX
         smsH80pjIXncsZs3LTLqD0IBh3a/JOr5RxvP+qzXrTtQ+BD1P+D2/E2b4yiGUz7nHxkl
         adsS1PNSDyRbdSX4iGhPJnOPASeIo4mifyk41px6moQZlBGA2lMkU4QFqZHfazFr6nOh
         ndPw==
X-Forwarded-Encrypted: i=1; AJvYcCWcNLqr+oUnfYwmIrGzTB6Qi4Sw3uFpoSCMQWGeLs5PZFbqpwp8KLNRkTKGsBuak6Usd2k7g5skfyaR@vger.kernel.org
X-Gm-Message-State: AOJu0YxOmgPNuNvltP3Y/MDwrViZDi88qVoHPs4h8FqDUb9XFsQPfvrg
	NKCjF6ofrOcpE8+nu0/RUyH+Imy+p/Rlg38DxpU1eZqhfi7rofEOXs36t00wfk6Pp5kp9268eQ4
	kJIJb45koEGhdCqXXfUVkYh6Q+EXf/fBMSsmlcWo=
X-Gm-Gg: AY/fxX5ag1c1C4ZE5jBfJEaaoenF856loyRHLE+h2DR7dVwL7Yw05RuqhRUAZpwesX0
	cYdOsJsxZkjG1/7stO8G/SMdIOMaW4K/brDx4sqNL51H4U6t2pGwbm1bb2sn44+OlqjIe1Dsi3S
	J+/1KPUbUncagqEPvVuaM3JTA7s8HmjfwUn/iB7kkitpP5godorE5SkupojcNYnQmaGhcQyyHhL
	4cvUck/XBlYvhih2uyHz9chKVUQM7fHiU0hEV6mwgDBGs8Cvg311Z7uFahvDoMqiG0MunAm7x4y
	O8GTqTqzJXxhVsUSHFwQdHAmh/Qx4cEggOsCGSQRrcgt5N2oMqyrL52s/t9ZmWkCypAMZcWYc2X
	2xdsFEceUyTlw/+wzppZBH8mU/qItE6piV4bUx6xQJCp3JJ9Nw2Y=
X-Google-Smtp-Source: AGHT+IHpjj2e5vL+H0GBnWKgiutlpH0lWdZWU4wb7UZ+GTtO8dyf+bvbxHEo5rK+GGt7M+DjRom03YVpqYcWKl6B17A=
X-Received: by 2002:a05:6214:1946:b0:884:6f86:e09a with SMTP id
 6a1803df08f44-8887f20699dmr17736036d6.6.1765530332344; Fri, 12 Dec 2025
 01:05:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 12 Dec 2025 03:05:20 -0600
X-Gm-Features: AQt7F2oOFu0qUKRYZ2y_sV7OE2we7orIiFgZHreMuWtdVOvBc3yKEyTxoEDGrEc
Message-ID: <CAH2r5ms9Xd8YEYzsw5DLYvayq0JyUqW4eSBUWwunzhNMVmJWng@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
3d99347a2e1ae60d9368b1d734290bab1acde0ce:

  Merge tag 'v6.19-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-12-09 16:09:32 +0900)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc-smb3-server-fixes

for you to fetch changes up to 2e0d224d89884819e6f25953bbe860ae6a49555f:

  smb/server: add comment to FileSystemName of
FileFsAttributeInformation (2025-12-09 21:01:36 -0600)

----------------------------------------------------------------
Three ksmbd server fixes
- two minor cleanup
- one minor update to comment to avoid confusion about fs type
----------------------------------------------------------------
ChenXiaoSong (3):
      smb/server: rename include guard in smb_common.h
      smb/server: remove unused nterr.h
      smb/server: add comment to FileSystemName of FileFsAttributeInformation

 fs/smb/server/nterr.h      | 543 ---------------------------------------------
 fs/smb/server/smb2misc.c   |   1 -
 fs/smb/server/smb2pdu.c    |   7 +
 fs/smb/server/smb_common.h |   7 +-
 4 files changed, 10 insertions(+), 548 deletions(-)
 delete mode 100644 fs/smb/server/nterr.h

-- 
Thanks,

Steve

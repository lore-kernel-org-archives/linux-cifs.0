Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ACE196D80;
	Thu,  3 Oct 2024 16:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727972957; cv=none; b=HRhZrv420O9S6PIEOwWtix3hDwcn+GVIQik8H7Zt+VV+uaKaVJH5RAoSz1nOO7yvaVgvQLXNYueq/jGM9m7utX/Ydfov0FG4e9CERkYs2nrwvlnPJPilyuxFAZAi4cU6mK5NdWd6h7Tlve8YpKu+jMPCLCZDb5Ey/YFuaDQSaUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727972957; c=relaxed/simple;
	bh=riWFRqwikXrJ5LBLlNpmR2Z5+gzV2Z6bLC88Xo+okNM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=MNJfslAOCe0GJxBCFSgxSa9qIck6ItFXXBtL2NEfChrUzEnA+J9pudHxf44uCRAg9KV5nrPFeb8zWe5fhlcJr9i5a5tA+OFLgGTI80boyoh1g6tgKvOQw1vbvDZggWHq5lYRIjkw7GvUb3ieIY8VcQl6GsR7laWG84b0PAghQ8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXZxke6n; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXZxke6n"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2fac9eaeafcso15192121fa.3;
        Thu, 03 Oct 2024 09:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727972954; x=1728577754; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=inMs9w95NrP7csQUf9iREI7l3tzPsASQInUfTPMGpTg=;
        b=WXZxke6nGVrHDQltLL+wxx2f1GvAN96q97FZ+ZL8fBPkvPjVFHpV4gxhsM/BLwikyk
         DH30SB9XNNjMP7Qyo2RuUGdK/rAzL03zHWGuHPFtvfKSVY3uKo0dY6e0HvokCFFeosXe
         FP82bnX8fGINhN4q8nT3XOpMmZs5RodDE9AbGcoIF+Z0JJi/0JFCd/shmIIisGqJPwSW
         crYirmzI8PidBpbeOZqZUZ2Df+KN0GbRZoH6EaoSnR+1a0lN9kQZPUfT4UpUq3PBX1yH
         q5Tj1KY4cIKLkngpzw7dYqJ2ma9tEBKRUYiFKwtp1or7KeALBq8kRQHNy9H5BuKuxsp3
         00SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727972954; x=1728577754;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=inMs9w95NrP7csQUf9iREI7l3tzPsASQInUfTPMGpTg=;
        b=qYQMiRPuQ4f6Pvr3Bo9luGAwgdd6X3Yga5cyBXfCvsLdEVWTr7n/wT7wmvxe1M0vEP
         3HeBkYxbC+VSTVObs1wR5uzjRyAnlXhUiEamndV+ZAAGB981AYkWWIr6ta4zrClSAsU0
         hYZ8YwkbdRYaCkt3/3Sfs9AfsHuPrTBH5g/zW92Eg2KF0qDMHDpTkJmiw66WcGqCRvJl
         yaj73QPlAQTr/UBT/Lw/+rynLf/pp5nS/XijtktudHkuvbT/GzBpmW3FRLnr9GtKGr3C
         MGrFZMkR7W3xQHs97dpr7NeCWZTaVIFlIy2bLaPaxLJEGvQY3jvPYFfC3z8m1otmt2Zu
         hfAA==
X-Forwarded-Encrypted: i=1; AJvYcCW3Lsf5oUzEtj+9w1Cjp/+XnOmw/F4MkFMVdVOcA9qd9V7VCR/GZ0VCn+c3AyE5lma3Q1qsKMoVlmGyCdvP@vger.kernel.org, AJvYcCXpluh2jqW1fO4pJHFcbc3A4J0pzO4LZdOb+dtrQn4dg88UCtHQ9I2z3sQLvd7G7msNiu8mDngH8b9h@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2tXtUEP3LFSgQJ4/giQwiKBCfze9sPjivXfJywbAPJZX4YwH5
	wcsCdEXk+7dTcjNPAW/j4+eAt38duisj5vHIlBmYtnuowcWEKRVn9GeNmEH9NNFgBP1Rq5jQfu6
	ooPBumZmzfo+bisKbBaPJVWVPXzA=
X-Google-Smtp-Source: AGHT+IFilZVMSvTUSPJPky5Eji2bWpmuTbeDUmNh1qzkjlki0wllc6tTobfYcJZH8un4jp/M6dZanFGa3fcs3QhpjeA=
X-Received: by 2002:a05:651c:198e:b0:2fa:e7f2:764b with SMTP id
 38308e7fff4ca-2fae7f284aamr34158621fa.33.1727972953844; Thu, 03 Oct 2024
 09:29:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 3 Oct 2024 11:29:01 -0500
Message-ID: <CAH2r5mtK7gFUwQfmsBpg2LKPLxkvewsYBAtp7QO2zpX-bJ8SrQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9852d85ec9d492ebef56dc5f229416c925758edc:

  Linux 6.12-rc1 (2024-09-29 15:06:19 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.12-rc1-ksmbd-fixes

for you to fetch changes up to 9c383396362a4d1db99ed5240f4708d443361ef3:

  ksmbd: Use struct_size() to improve smb_direct_rdma_xmit()
(2024-10-01 14:50:51 -0500)

----------------------------------------------------------------
Three small ksmbd server fixes
- small cleanup patches leveraging struct size to improve access bounds checking

----------------------------------------------------------------
Thorsten Blum (3):
      ksmbd: Use struct_size() to improve get_file_alternate_info()
      ksmbd: Annotate struct copychunk_ioctl_req with __counted_by_le()
      ksmbd: Use struct_size() to improve smb_direct_rdma_xmit()

 fs/smb/server/smb2pdu.c        |  7 +++----
 fs/smb/server/smb2pdu.h        | 14 +++++++-------
 fs/smb/server/transport_rdma.c |  4 ++--
 3 files changed, 12 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve

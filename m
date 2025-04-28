Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780713AC1;
	Mon, 28 Apr 2025 23:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745883876; cv=none; b=k1x4D17Xio4ZuPdN49NSd5GqEoq30ElnOJiJfsLJJHvQQeSxFUE8aTiS4rfaVvREj9NCRA9+mKBNfu89Vc10wTlhC8BSBfLJ8RgBCwxJQJ9CHzNc/Y0jSqOhzayyjCs3q6qqb+gb3dO3djuEMlUplFivlpDxmyL6EPExXwWJHQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745883876; c=relaxed/simple;
	bh=8xUo4fwlDVprEdPJtctVLsIXhF62wGUuKLnuzz87hEc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Mh8ffPHTdjoZ1FUvSV+omSM/nLLrJel84fO00ckTPUCcYkalWkjc8J6jgVO1AjzG6/R1bpCFZmdYj9Y2tCtMOzS10aEngWdOm+Pf/Xya+wGGSurwrV9/E5P9vZqHLdv8YQo81BvJV9NRzZDqBB9POhud4T5b8OAJ7wDCXdD1BCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CvgwaKo/; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CvgwaKo/"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-30db1bd3bddso54666421fa.3;
        Mon, 28 Apr 2025 16:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745883873; x=1746488673; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XVMBeXUzUjIugw33Pd9iUMACoFXldM1xioz8Ye504KA=;
        b=CvgwaKo/XqSSv+joefZSKnqbf5yD5O6Ye1thLEoh+Lw2V/IkhYwaBZyj2aOD2A2eHn
         itWV/VStXbibEJqSwGZKUPDxvoYVs8m4Nw05fLSkvaRBOp3xZR4xCq2hxp7W6XM0ZnXb
         391nCcUEIRPwquqcjhYYTNpFt0QSyghZFGBxjzbIvgdvOegd/i+Ju6nx+k36UfASD7wZ
         RLS7+u5M2lraZgtYlOiyq6oQ+7OM1TMZ+uXy/Q3BCJLjXaGuQX1uJ3op94Bj1B8wzr9r
         dgZa084zRZKKfpCmaKyBRBFQulkjbuSDcDKneHG6ssbEWfW5QXqzISIXTJp+PtGFxUI0
         HGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745883873; x=1746488673;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XVMBeXUzUjIugw33Pd9iUMACoFXldM1xioz8Ye504KA=;
        b=e8+5+XSbCj2EPK1abTvEidhl3NKWXgPVVpCCFdjPjbPQrzu6dhzBu/LB5h7/6KMIwo
         7BfiiXcUJipZItKItNIGbRUxkrKpWE+ZvULEnJU4mYI+nASC2+fd4p1cxf6oZx1MQMSQ
         y2Uwi4pb8Q4Ihkk2XKXcq/BwGrYip8keSyEWdjYWwsXIl6Pm4JH0StkaZTLi07hfIUVP
         zqAmnjJF6W3GIGUrv9CWHDkWcCkICECWSMPMUx+7XBbb344WuVsB0AfW4U5JCrs/rVbx
         3y885nmg3kJT80ehuiLW2hJvBhQbFUOeUFvruUBUx3z/F9iwOqph8facP15jeED0xsv9
         UGMA==
X-Forwarded-Encrypted: i=1; AJvYcCWEK0dT8ducCY5yRXTVI65CkzyTXN+jU1YFT9PzC59ETrEEuVclc9dmzZEzgI/0EbYJxpPHROFAOk5q@vger.kernel.org, AJvYcCWewHCK1goRV8nV7ys8e+80AzcnAfFRFXzM//uOPqbiE5knnDifwizLJAWQ3hO4M4ov2CWByh9oQ14m1Y/j@vger.kernel.org
X-Gm-Message-State: AOJu0YyH/FAv1QlvX8EWDoOzsGkmAcdmzcBp+jh8EasRJndpCPoO1HU6
	X4SwqXsofEvCtxl5oXj4VO+YsTpQCQAQFXbRB9xIH98nPF6bFw/aJcn8y+a3pHWgzt9EuI4CwBs
	hrri93os7L6RPMda9FdAcGWguFBlgyrZ7
X-Gm-Gg: ASbGncskOJu3o+/5GeswGI1nFlEs+JFMi8NNZ25duhmYh1PQKqZb2M6qQUX8W6GRsfH
	ypYIzrGN4Khmj7+3IcPR+9RrAG4blisTk+F5UjR0DiaigJvPSfxUs5/OyH48L8YibknwVHJqmG6
	Voy9Qzg7OzmSf7C6h07sGs+cvaZRFshG2Mx9k0gvxI4oMhwJp+Y8xg9OHi
X-Google-Smtp-Source: AGHT+IE4d5npkYzDu77mN0vfvbu/xEDKNXuRxig8ID4Gf+tyZux/ZuTHTFtFVIv3lGsCfJJ48KZBAiZypEyZT/ztvPc=
X-Received: by 2002:a05:651c:1144:b0:30b:c9cb:47e5 with SMTP id
 38308e7fff4ca-319dba4f840mr40550611fa.8.1745883872908; Mon, 28 Apr 2025
 16:44:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 28 Apr 2025 18:44:21 -0500
X-Gm-Features: ATxdqUFd_hsU3qo067Z1iYW-p7hIANK9uQON8_8W3_z0T5qahti-S3e78A1GAU8
Message-ID: <CAH2r5mtYUujsHMx28hNQdPOYLhgLTYMN6BypJhQ=28qSunocxg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9c32cda43eb78f78c73aee4aa344b777714e259b:

  Linux 6.15-rc3 (2025-04-20 13:43:47 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.15-rc4-ksmbd-server-fixes

for you to fetch changes up to 2fc9feff45d92a92cd5f96487655d5be23fb7e2b:

  ksmbd: fix use-after-free in session logoff (2025-04-25 18:22:26 -0500)

----------------------------------------------------------------
4 ksmbd SMB3 server fixes, most also for stable
- Fix three potential use after frees: in session logoff and in krb5 auth and
   in RPC open
- Fix missing rc check in session setup authentication
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: fix use-after-free in ksmbd_session_rpc_open

Salah Triki (1):
      smb: server: smb2pdu: check return value of xa_store()

Sean Heelan (2):
      ksmbd: fix use-after-free in kerberos authentication
      ksmbd: fix use-after-free in session logoff

 fs/smb/server/auth.c              | 14 +++++++++++++-
 fs/smb/server/mgmt/user_session.c | 20 ++++++++++++++------
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2pdu.c           | 18 +++++++-----------
 4 files changed, 35 insertions(+), 18 deletions(-)

-- 
Thanks,

Steve

Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3E981C174A;
	Fri, 21 Mar 2025 04:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742532093; cv=none; b=nA74ITXiq2V+QuTpMCgrAinbucPgztGJzFhqEUHvIx9olaX2C9GO7EIcZlVZsILzVnNcyCqvpT8jP7YgxZIJiaYCvvYfLBBv8Tmqr3pnkpFPp0QmMJEqG6GZHqb3ks1tX5xiCWdG20MigGTxS+CVbO++da5kz5qFj12aXEIhBUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742532093; c=relaxed/simple;
	bh=uGtyiqghnrPms/N1mxbBz8P8rp+aDTg9BWgFvMy4J2o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=fV5U0DuugpsifXCm2LkiCW/LwzHlMZKq2mk2ngAiveXpJnjmnz6FHGFDyRN+heXhwhKTVNP2QGHW8OOaxn38eYQd4ZG84+JhUrSJRQPJDW7onOQOdVYvBTvtL2/LkTLQ0LoBiVE9C6hJIfoznAUxLQLyY+40v63dZ9ytyf949Ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBjERpOj; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBjERpOj"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-549644ae382so2013483e87.1;
        Thu, 20 Mar 2025 21:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742532085; x=1743136885; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dqqlOuwgDqZzp9bz5GBCwhxF+fXIVL65riJZdwC7+6Y=;
        b=mBjERpOjRWj4LJJCRTCOLKABkUIcaYP8VT+jTmXvsQ4lFm92ikYqTmSZI4z0CPA5yg
         5VuDovKz0fesFrdXoDuSPFvte65Ta6sFGNFmMPYJCvlNJV7cNQb59HFrGo7O8Vsy4d7a
         304FJJGR1tEJ67k/y/MSB0JtFug7NURsTOkK4Qw+VGYuAXQ1ZYvyCVn96WM9c4y2nCbP
         LngcyWKKXBVq6xNVKvwcOqKp/W2dQoyqQwiuVhLlI+VUb0KE3gGLmFsVDhyn3Xnp9J9y
         EjtNNljRC2suE1IQzO++q5GJgfq0CqNgrq8+gNxB/C5YcRdcgLewPleaMNk86O1l9G9R
         OCFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742532085; x=1743136885;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dqqlOuwgDqZzp9bz5GBCwhxF+fXIVL65riJZdwC7+6Y=;
        b=qGwsE7pAcmLhu/UHey69HU0CGE0LHRa4SkGupdmWX1fO+AnJs4OjTH6WB4Oz0JWkrS
         sWocMW+RYr0tA/UwwwbbCEMQYm2VmglOB4WX6/H4rfODhnSB14IGf0nBuSXKFGKsMMvh
         G2Fy/yzD0P6GbVOrEX8Ki6b/VDtHFTupF46NAgS4gOHgzuxcrPrwadbMJgK2AAJPTwwg
         WKs4eN3y5fKHtza+7cpD5cpf6LuWCZG2rNP7fsJBDLn090PMIiIteCV56eVSoBtxLMTd
         r5b/w7BzWMX3mA9g3eUlLZ0XJp15D4SLsxFh4xVFY1IHJGiIacUFCuQk7zHsbNbTemT2
         wmnA==
X-Forwarded-Encrypted: i=1; AJvYcCWym+xjH7X57j1jbp1m7DobkAJeAUIYDiRpQKp4vHXZktqlXniE0WTr9a7BhgindNljnyigMFTpyr1Ckr8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+dOWUwiaIMtDh7iY/ABmksMhc6/ScskOVQw+D6wfLtqlqrPnj
	og2WcxAa5xZbNJftsY8Y7t3/OYIG6mkyHJWt2PoDrLx8bOR4KdNEWx605dpjZJuERs1HWuYkgAx
	O3XyY6UR0eauoMc+beH0SI6SwQzzhh7rt
X-Gm-Gg: ASbGnct2mGA/dfuZcpqzvWsZnXVqjsXZg+umCT4VXIZe/CtpEGc2Rls4j/aOKyn2lDE
	bG6hEfIGc2hsjpsn+ium+kncNaEk1+BXJv033l/QoYhymeYDDqSLg1eFfy7csyTAvbv5mkmWMF4
	8899Jjyj442URdvEZzDj4siwenZdlL66q9yzkqHZHhwZamNByeWD9FuJpSpMpf
X-Google-Smtp-Source: AGHT+IH9Ctb8My0VZ3PKZcoJ3VCVnG95JCkGLLFwePI/PfbhY9yjdHxpreHd3SgkxzXTJUzjVG0OiwqWXBgVO3Q+odA=
X-Received: by 2002:a05:6512:12cb:b0:54a:c4af:29 with SMTP id
 2adb3069b0e04-54ad650348fmr674536e87.52.1742532085157; Thu, 20 Mar 2025
 21:41:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 20 Mar 2025 23:41:13 -0500
X-Gm-Features: AQ5f1JoP4_OIOZBwzf7C-v4c73Qz62SPygr11gWZ1F6iL8usKWg0jUqOex5kbJU
Message-ID: <CAH2r5ms4nV+_+L_o8rhiAMhkF4u+SEThEQn5yfDn2fiLvXc_5w@mail.gmail.com>
Subject: [ANNOUNCE] cifs-utils release 7.3
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, Pavel Shilovsky <piastryyy@gmail.com>, 
	=?UTF-8?Q?Pavel_Filipensk=C3=BD?= <pfilipensky@samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

A new update, version 7.3, of cifs-utils has been released today.
Users of cifs-utils version 7.2 are encouraged to update to 7.3
since it includes a fix for a problem with "guest" mounts that
was introduced by cifs-utils version 7.2

Links:

webpage: https://wiki.samba.org/index.php/LinuxCIFS_utils
tarball: https://download.samba.org/pub/linux-cifs/cifs-utils/
git: git://git.samba.org/cifs-utils.git
gitweb: http://git.samba.org/?p=3Dcifs-utils.git;a=3Dsummary


Detailed list of changes since version 7.1 was released

Meetakshi Setiya (1):
      Fix regression in mount.cifs with guest mount option

Pavel Filipensk=C3=BD (2):
      cldap_ping: Fix socket fd leak
      resolve_host.c: Initialize site_name

Pavel Shilovsky (1):
      cifs-utils: bump version to 7.3
--=20
Thanks,

Steve

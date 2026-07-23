Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36A244C50B
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 20:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839494; cv=pass; b=f4kRP6CM9eN4Uj2ucmpRt4KkKuLMrYdzp3gsCfApf5Em0pSXRrKNv6mXxMVktjOvJkpbID5vwSIVfoskkGA46UAUiV/uSgjZEZ+4+RlP0WOyojosGFVqVFGdzrXQ4SuDHInL5kAy+VUbC8crSKZhPWX7SQPADleaLL9gAJeWWhw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839494; c=relaxed/simple;
	bh=4h/Rf7jmgBKlxfGQ2Y+qvpJ4DaieJeBuYuPU0q8Jqcg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=k0QqSjwYlDgMr8gjU3tN3NyYHHWuiRBhbQC3D4MpvViNzKdFzRiEiQp/cRAHEy+ilHdqfzlH1gdzDcIgggjhW9cxgDsj69rZmAeQl1I4pHfRDGEni1ABv7w+77lZ10xxv0DeLBYupAgOPu+aG0pJRBgLmH9OIyAp1UVKaQQw7kE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mloaTZn0; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mloaTZn0"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8ff20870ac7so10738446d6.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 13:44:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784839490; cv=none;
        d=google.com; s=arc-20260327;
        b=WXvpmhY3eRrk97JepGi5y7icVJHqCiFUSf1yfV/I7vjf5cjtpKEpyQL1uQiYgKqc/W
         +mn5Wqgfd0sSET+G+oOgGND2JtGjnGnr5Hf+f39W3LishYvbrtaEv9P5YYfqGVQ8O3ub
         pkxW2844zjNC1hfpUzJlw6kqXZlCSUfHCOjmymbDcv1FdljPNa+DIAPBYUqHSgb8XlUi
         o41bSD/442oNew7LCc1ADPhiu5wb01pouiBsVD4p/ja+JQQVRXfJVDlVN97AWudmep+M
         xs1qs9Q7tZ4ZxWwKfzR6F6s9vntYjYRSqnwdNDwNRx8n8d3pB63+XoKEnFSAG27WRj/l
         yVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=CDopvOj4k9WArHgo2doJqHaZGmsJBI+a+mdyRi5Y/H4=;
        fh=461vqIZoOg6NIbk+pdwtgJzufnhC0zIzeuKytqfZhTk=;
        b=beFLGvZxYerqhMZVMkra/ITW0SG0wzmCB4BYxj/hgC7EJk8tHmwWTgCoTTQiUT2ghU
         k/pytgIK8+Ycl6FIm+VF2YMJBm6hvu53X3pjWmvm7CNTpAh3sHV6ZGEfUKBTL/IcLboK
         a7JLIS/C0CNsUw8vdQi4qwWRG0Nfx6gC/MnQOJfA70r8bjUp8ozML5gcpDCeiBdixS2w
         Olf4v3FyyyeemW/5UXtUBKE2bPE1/IXvVRx7snP2fH8Z2pLxHkmNy/vaToXaf3Wcf4Nl
         oLMAD1O5U/PGPrl03cneiglEb0j112L/5+gnHP+KqgJPebTk1xtQLm8VeIjmTIp1DHL+
         vxig==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784839490; x=1785444290; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CDopvOj4k9WArHgo2doJqHaZGmsJBI+a+mdyRi5Y/H4=;
        b=mloaTZn0NwRIl7UzKNx+hygpLTO+pTvwCk5jA6TW4Fm7XSY9a2z3WiRRLUM+yOwnqy
         vfcC0Qjm1rM1x0/5GnLwkyyC6TSuFLCIRfXMmSaV+wnK3qxC1Fu7XUAeJuho3PkehGyF
         zVTd2zhR+SGOsPgDJJhqEf/jagUjJlSOU+KwDniaMfQfWk+hmCJD/Xh2FW9HiVac+pX6
         qdwPGp78wNtLm3WAKFUzVQmIxiY/Exi0CsrwNQhCXEToUUojqPxnbCn2UBxUixWdfCBi
         A46YtqPKqst1Lzz7DDkFkaliQipKmJ9WZ6zWy3VfXRSpiXG65iT6JS7wPx/H7sLu24Sf
         gPbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839490; x=1785444290;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=CDopvOj4k9WArHgo2doJqHaZGmsJBI+a+mdyRi5Y/H4=;
        b=HknGHTLycHeDPjN4LiDeNbiq545RzOFH5bNDg3UrcEanMchSnQTSIBW9MamPGN2f4u
         HjS8wg+zdCc/wbuZHjEDwd9Xs6f4LpmljaQM5oaPPY3Yem0SBOCEhYRUrxpyrJpfYH3e
         826eqOSz++kyFr3FTySn3EGP8f3s33km1KtXhpbqgshjRnWP404adf4M5sfroLhKMRFw
         /wJcPPHDW9y4HEDL49P8A6Nc15mP2ESWAmiUFvOQjqSo4fCI1DkT7U9A4L0mp6If23Ls
         Hm7fcxe534LaWYGobac5fqhGNmI0UoTUm74ykVx01zqZ5zPBHf6R5EikI6Uqkqnc0WDT
         +2CA==
X-Forwarded-Encrypted: i=1; AHgh+Rpb/ILJ7PjLU7SWRDMPsLqZNdKmunOwjgRJS72UPSVsrix0Ra5tgyQst6EFSUdxF58YIKPtKXA3O6L5@vger.kernel.org
X-Gm-Message-State: AOJu0YwahI2cZrYtIEXPFJPgCdZqvfSNMSYrP+/LhuO6bsqfzBhHa3at
	nvA75TmGMxf1Wh/M4RZYACd83t/w0YGLjwt7LDDUxTa0e/5HFPIsnncI0uDG72ZN4EanVd+gWXx
	X8r3Xz4v8d2TQi6OYBCFNwfhVFlsYT2vsPnR1z/U=
X-Gm-Gg: AR+sD11+PnsK/mh+tKq8spuQVeTsXc+daJ5sSNkWn9JrvTfmiFNSSVfBL9KWQFfva3k
	i175QREACznrdIPW/NkUJUicPVWaDVrLWX+ciU1/wh/L8OZRDpXgljIKl8NrajSsvMrD4QOOAz/
	uwrJ/DqD6/05I6Ac+/CZxG8ArDLpQSuIGNd6zqIuN1ZyP5QrA2nBfbl536kXBHfDmTsxSnYJ4VS
	Es0X3X7xsZohzB7u8pZQyZCs2dLoj1FK3WkBYeh00y/Xl3IXMQ/GvQT2ZHmSF8h+wsy1eh2Pxgr
	93KzTvoBGWl4k9uNj+zo/lL+V0x30tJPYXNAYSlWWTzhyk2ROkarmihxKeN1NZp5lxznCJKtDy0
	XhQ3O8XMIrYVfNWjCjxadCyEZRSB+9f7dFd/XgbEMRXgnQTxmUWEf1S9eDunJhdi7itiRIu2i/d
	g=
X-Received: by 2002:a05:6214:5bc7:b0:8f1:4bff:3a55 with SMTP id
 6a1803df08f44-907ca5e760dmr53578546d6.38.1784839490227; Thu, 23 Jul 2026
 13:44:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Jul 2026 15:44:39 -0500
X-Gm-Features: AUfX_mzfFqukVPGDCP9jvquxAf-EgJ1FdiCj6sx3fsVM68YyRNDCHJo7X-XzB5c
Message-ID: <CAH2r5mu0Qi4c8NprbnviCv5whzqGuzriVT6qShQ91=Kx4=T3Zg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
1590cf0329716306e948a8fc29f1d3ee87d3989f:

  Linux 7.2-rc4 (2026-07-19 13:54:41 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc4-smb3-client-fixes

for you to fetch changes up to c2f2e83e3bbc5483730fd4ee903182761f1ae50f:

  cifs: fix cifsFileInfo leak on kmalloc failure in deferred close
drain paths (2026-07-21 20:19:11 -0500)

----------------------------------------------------------------
Six client fixes
- Fix leak in cifs_close_deferred_file()
- Fix resolving MacOS symlinks
- Fix stale file size in readdir
- Update git branches in MAINTAINERS file
- Fix bounds check in cifs_filldir
- Fix checks in parse_dfs_referrals()
- Fix DFS referral checks for malformed packet
----------------------------------------------------------------
Carl Johnson (1):
      smb: client: handle STATUS_STOPPED_ON_SYMLINK responses without
a symlink target

Frank Sorenson (2):
      cifs: prevent readdir from changing file size due to stale
directory metadata
      cifs: fix cifsFileInfo leak on kmalloc failure in deferred close
drain paths

Jay Vadayath (1):
      smb: client: bound dirent name against end of SMB response in cifs_filldir

Steve French (1):
      Add missing git branch info for cifs and ksmbd to MAINTAINERS file

Yichong Chen (1):
      smb: client: validate DFS referral PathConsumed


-- 
Thanks,

Steve

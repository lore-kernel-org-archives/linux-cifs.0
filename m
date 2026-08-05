Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048932F8E99
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 01:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785894979; cv=none; b=of5aHHQJ6CG6N/uUn2XxM1husZ2Uq2cKeV0yv244FCB/p5fAut/WpyNFLn7BLGOd9pvjnkOrU1hRDz54WVyq8RSJuha7NPYTR8/ZHTPmkQOrvdvi2V67GHcS35jz6MJYnxYhuAEMUMp08ANWxlGMGKA+PzggHTTjcSNuYIWj7PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785894979; c=relaxed/simple;
	bh=1zjqtwIKa2dNoaIM+bGn2BAvcQrIIEjFf1keDxCULVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sRFVZ7tvwpWhjjWOHtXUBFg2krUNzwh7K4SQ7TBgOLb/lhz2DBiZB0N05bZlsj4t0ndXsa4XkWxZ+9OQ/JdArQaD2WjxQA2ma6twFkRRqp84pluUPLotOzAnHcs81uQbggrfbftAe42yQJkilnV+zKgLB+pMudSvHi/CIOf4ZKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=eC9QadDA; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="eC9QadDA"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785894975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SXeXmPJ0JkP6tKxFJQPPM3A1bI/0/RAUc8gBikPKa+c=;
	b=eC9QadDAdVmEEOffamC71luWSdQy3mHv2+EuBSWyvfcRhykwJmKyRYgbWu6DkLDDktBdVu
	ChEPqKidKKn/44r6FzbRZyXEhEL9mU4C1vfGknHG68iphosEvsqkOT1aHesYXJ1/fmsahw
	tS0l12VS3NJbZiT4k7GFB3t4fSYD2kY=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH RESEND 0/2] smb/client: handle compression flags through fileattr
Date: Wed,  5 Aug 2026 09:54:45 +0800
Message-ID: <20260805015447.15488-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

This series moves CIFS compression flag updates to the generic VFS
fileattr path.

- Patch1 implements ->fileattr_set for CIFS compression flags so
  FS_IOC_SETFLAGS uses the generic VFS permission and serialization checks.

- Patch 2 removes the old FS_IOC_GETFLAGS and FS_IOC_SETFLAGS
  handlers from cifs_ioctl(), which are no longer reachable.

Thanks,
Huiwen

Huiwen He (2):
  smb/client: implement fileattr_set for compression flags
  smb/client: remove unused file flags ioctl handlers

 fs/smb/client/cifsfs.c |   6 +-
 fs/smb/client/cifsfs.h |   2 +
 fs/smb/client/ioctl.c  | 165 ++++++++++++++++++-----------------------
 3 files changed, 79 insertions(+), 94 deletions(-)

-- 
2.43.0


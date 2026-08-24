Received: from mail.amicon.ru (mail.amicon.ru [77.108.111.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60C0375F82;
	Mon, 24 Aug 2026 10:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.108.111.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787566985; cv=none; b=cAuc6hyHmMnlnnCSnNOenrjg4Vs0lJ0O7Y5EN6lgVRoHDjP9lDuallI0LvcoatC09wn44wLg2nNcos93A1+4JHTkSZnhZKo+8b8ovbIbZXkS0n2kPpHOIqOMSbcLXV88tDpX842VVgZkMcbZlvqANzwrccGFuGyBA+AnAJvsYXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787566985; c=relaxed/simple;
	bh=jShiFoead9fuokoPOP9Yuj4r2dAijBBFy7kbSNEDk/o=;
	h=Content-Type:From:To:CC:Subject:Date:Message-ID:In-Reply-To:
	 References:MIME-Version; b=mvIruxygoV3AiXuY5QlKLA3pQvEn08NNz3fe6e3SmgUFBY19NUaYUCZ1AonDyqPhBAAY0Dz7vE3+1O4B/LeUR8M59oQpScWA/gyWK+TF3VGzEGuxYni39Q9jqsOMzI4YJPwQWzv3uz3aQubsDdNOeCmcKJXV+D7g/E0DW8atSI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru; spf=pass smtp.mailfrom=amicon.ru; dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b=eavpEBV+; arc=none smtp.client-ip=77.108.111.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amicon.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amicon.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amicon.ru header.i=@amicon.ru header.b="eavpEBV+"
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
DKIM-Signature: v=1; a=rsa-sha256; d=amicon.ru; s=mail; c=simple/simple;
	t=1787566980; h=from:subject:to:date:message-id;
	bh=jShiFoead9fuokoPOP9Yuj4r2dAijBBFy7kbSNEDk/o=;
	b=eavpEBV+oAnP7yU4TdVc8rWFr7qtvc4I0fVQHX4Xpi6cSJT5X/framfDz+sIH1u8Gi4LYqQBWpk
	YpzT1SrRMx9Ffgm8jReszOfxbtq1nM7G1PmdzrDGXndr2Es37f6DYga5jaceuKGtHWsvGyDfUc4v2
	rYw0pod4gNH/iX7p3KZarKVxCN6vDkAzbomgEt2DY+K4lUoDb402AF8am4lKtFPQcm5cTutwQQHTV
	iSompy71FCXwqlJcyCIOC2jRBbSMomy35k22TyJz29ajQNCPxBAXSW2wlAz+VgqBWGC/gQXAjvatt
	2LxaNMsNk6mNFLrxL+ZYDiyTvV59hGS0qDvA==
Received: from localhost.localdomain (192.168.0.250) by mail.amicon.lan
 (192.168.0.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.27; Mon, 24 Aug
 2026 13:22:57 +0300
From: Aleksandr Khromov <haa@amicon.ru>
To: <linkinjeon@kernel.org>, <sfrench@samba.org>
CC: <senozhatsky@chromium.org>, <tom@talpey.com>,
	<linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<lvc-project@linuxtesting.org>, <haa@amicon.ru>, <rrv@amicon.ru>
Subject: [PATCH v2 0/3] ksmbd: fix information leaks in smb2_get_info_filesystem()
Date: Mon, 24 Aug 2026 13:22:45 +0300
Message-ID: <20260824102248.178152-1-haa@amicon.ru>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260821135801.3790290-1-haa@amicon.ru>
References: <20260821135801.3790290-1-haa@amicon.ru>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: mail.amicon.lan (192.168.0.59) To mail.amicon.lan
 (192.168.0.59)

smb2_get_info_filesystem() sets rsp->OutputBufferLength to the full size
of the structure of the requested info level, but three levels leave
part of that structure unwritten:

  FS_OBJECT_ID_INFORMATION  31 of 64 bytes (objid[] tail when the volume
                            UUID is unavailable, plus version_string[])
  FS_CONTROL_INFORMATION     4 of 48 bytes (FileSystemControlFlags)
  FS_POSIX_INFORMATION       8 of 56 bytes (FileSysIdentifier)

The response buffer is zeroed on allocation, so a standalone request
returns zeros there.  A compound request need not:
work->next_smb2_rsp_hdr_off is advanced by the length pinned for the
previous response, so if a command wrote its reply into the buffer and
then failed, smb2_set_err_rsp() pins only the short error response and
the next reply is laid over the bytes already written.  Only the header
is cleared at that point:

	memset((char *)rsp_hdr, 0, sizeof(struct smb2_hdr) + 2);

What leaks is not arbitrary kernel memory but a reply that ksmbd built
for the same connection and did not send, including one that failed with
an access denied error.

Compile tested only (x86_64_defconfig + CONFIG_SMB_SERVER=m).

v2: v1 was a single patch clearing only objid[].  ChenXiaoSong asked in
    review whether extended_info.version_string leaks as well; it does,
    and so do the other two levels, so v2 clears the whole structure in
    patch 1 and adds patches 2 and 3.  All three go back to the original
    ksmbd import rather than to commit 3a64125730ca ("ksmbd: use volume
    UUID in FS_OBJECT_ID_INFORMATION"), so the Fixes: tags moved
    accordingly; on trees without that commit patch 1 needs a trivial
    context fixup.
    v1: https://lore.kernel.org/linux-cifs/20260821135801.3790290-1-haa@amicon.ru/

Aleksandr Khromov (3):
  ksmbd: zero the FS_OBJECT_ID_INFORMATION buffer before filling it in
  ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
  ksmbd: fill in FileSysIdentifier in FS_POSIX_INFORMATION

 fs/smb/server/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.48.1


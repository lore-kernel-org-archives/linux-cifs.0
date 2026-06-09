Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341D53CF21E
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 06:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780985498; cv=none; b=IUOqQe03d8McQRG8APAKVi9I0sZNMkf2Chg92A89NyX/Hm31K/IlR+Xwv7bi0DwgEs/4lGdyuOgHoEkYmiO+VQLHvbEtCqOwHop1SbcaID5t4+6bc41CTSu/2aHcLwwjuvL+FdvoMHnrAFb5Hahl7LFGDh7Rdzsb/O4u1XdY78w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780985498; c=relaxed/simple;
	bh=Xom+MR9BRXnkQlEgxCtJcq470L0w1Fd+suEbs0H9pus=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Skh8azydOxuQX/ERR07X64CF8A/ymEumXO0yFjbpJ2n5684si3QFHIVBwC3Vi2H0v7xy26ZQauVVpmAY55BLsvplcYXsw802QZxEI02vvzWgnINn/wduFZTS6j60erJvnqaArGSdMwtvAb6IrKV+VaFZts8gNCNKjN8jBeYUrxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=K8mqZ6LN; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="K8mqZ6LN"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1780985493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=85+Z0vJEC2ujfPVYCU/Lxh3Hb/ftAxrC1RZnPdI99+8=;
	b=K8mqZ6LNsKJNrjCNmrHdM1spx96lvISRjRrj5OZsoOTt4nUr7nHZ81IUZzTZbg90O2ECIC
	mInWD+R60WAJ63fsxLKdLFdgxoJQzTfHX7CjZ0nnCh8SWR7gY939L6sHaL5w5OPJjU2MBQ
	07ojTF/1Jp+RG3IOVklBU0q+kImhxj4U0Ud8SJmjwsULanqkeGuLniVvA6H2YaeoL7jQwt
	vh0Deq43kU2UpL1xy+eAjDD+SpybZG2Kb7vIcfH9VH6q6p+RxHEb2RKY0Jxf42GIvzfRM2
	uSZdqJAoyQ0u5E3C+9PAkOAPxev4opxuwZMqAC8w1tZsXYDKCTK9QwM4yK75FQ==
From: chenxiaosong@chenxiaosong.com
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH v4 0/1] smb/server: implement compression fattr handler
Date: Tue,  9 Jun 2026 06:10:27 +0000
Message-ID: <20260609061028.402886-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

v3->v4: use min(stat.size, stat.blocks << 9) as the compressed file size.

v3: https://lore.kernel.org/linux-cifs/20260608140128.387844-1-chenxiaosong@chenxiaosong.com/

The following patches from v3 have already been merged into ksmbd.git ksmbd-for-next-next:
  - smb/server: get compression format in get_file_compression_info()
  - smb/server: implement FSCTL_SET_COMPRESSION ioctl handler
  - smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
  - smb/server: get compression file attribute on open
  - smb: move compression definitions into common/fscc.h
  - smb: remove duplicate server/smbfsctl.h

ChenXiaoSong (1):
  smb/server: fix incorrect file size in get_file_compression_info()

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.54.0


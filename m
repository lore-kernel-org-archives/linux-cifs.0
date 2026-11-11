Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794363961;
	b=WG7zML23tJ7UuHpPyw+9kXSoV/Fz/VzaSKEf5Eg9z2HP6KaQlsTMmwcsfdVCrWo2IwrT
	 uDBOfJR+ohvxHnpXh1eOvIRWY522gI0v+xzdFd1BfeSZFl0/rAIJr6F11pr55I7GxlrBz
	 aZfEloVYwpBXy4XKfAV55ABfnZmkBGZwXDUivJjnZ6tIv+BHbdpCGN3achYEYsAqOMXYB
	 iEr+iGo04VUQPdmicWo/NA2/mpoj65DSipHdYTb167y28DndtNJWb8bPAnpYVNR6b5sAV
	 GqmfqZqMXmJ43zLxnD88uGQoaKglFcNlIY1PNeN1cWq5OdFmYNbYnIwuj4/uby9Uugw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794363961;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=kfKSysrLp5w2XMpSfKvFS4LMxV0RGC5lLOjwJnUxRoY=;
	b=eMZ0Gs8WFPYFkyfYZaZm7CkgF+uu5u2OyGr4N3Qxoi2lb9a6Gc4vJPcapiJfnza7Y8hN
	 zKYyW/C+5FdyeBiw3B6+FyX6h//HyTpdplV61z3ekh80gg97LCRfiRoAm4T+wKGNgkv0k
	 pla9aNGY29elBGeww9MqMbbO9umkTTMaYGzn5SaohmICSWpIXstfutZmYnIbul8ibkazi
	 BUK4ZG6r/ZJWcTffiKX0Yn190/wtC6qZYXKHZmBk13RMRMG6BIotlAT4OAJWfbn/8zoaz
	 4lbf6RHMKcb8d/GjnwPGXi8UfNrhGFr8wt2FJruB5nXx30o4HLZZp5Y/cfAg7aVbEpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=fN4yNnKc;
	arc=none smtp.remote-ip=95.215.58.39
Received: from mta1.migadu.com (out-39.mta1.migadu.com [95.215.58.39])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083A2606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 02:25:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 083A2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=fN4yNnKc
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HWyZPhyiqS3wVWcqdbBroKbsbs1m5WUzYzT0RJUvL2E=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794363957; v=1; x=1794968757;
 b=fN4yNnKcKMq4ZYAuK2Ut44zD9hOpvQ9lw26vvaJU7KsiZaWqOrh7sjiEsNK7L2NUgpPwU50a
 Yul1hUpenbEFcDCCH0FaP7W+so33slP8ysj9bgQkhzKgD8GYb3gVZC0t65V+uP97kIjdjfcJ2rx
 Jsq1iLXrkPvT+j/LEiD2l4RLOo3UAKpmS4UHnL+LBH7RKVv46djAkvFbvjxQ6ORd4gPwkVmov90
 c2hYS9Pz5+HLRk8Yr8y2UkqfDkQoj9cB2O0B73LejUIuHriVoU8bDf0qwjU6bxR2VGqRs5po7qx
 gjI2l6XXACayCuBWgV9bqMEtZn/olzny7SyzAxyacXY8w==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 139b4309f8871518;
	Wed, 11 Nov 2026 02:25:57 +0000
X-Mizu-Trace-ID: 139b4309f8871518
X-Migadu-Flow: FLOW_OUT
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	metze@samba.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH cifs-utils 0/3] smbinfo: add options to notify subcommand
Date: Wed, 11 Nov 2026 02:25:19 +0000
Message-ID: <20261111022522.406718-1-chenxiaosong@chenxiaosong.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Add optional `watch_tree` and `completion_filter` arguments to make
debugging easier.

Example:

  ./smbinfo notify -h
  usage: smbinfo notify [-h] directory [completion_filter] [watch_tree]
  
  positional arguments:
    directory          Directory to watch for changes
    completion_filter  Filter mask from 0 to 0xFFF; supports '|' (quote expressions in the shell; default: 0xFFF)
    watch_tree         Watch subdirectories: True/1 or False/0 (default: True)
  
  options:
    -h, --help         show this help message and exit
  
  completion_filter flags:
    0x00000001  FILE_NOTIFY_CHANGE_FILE_NAME
    0x00000002  FILE_NOTIFY_CHANGE_DIR_NAME
    0x00000003  FILE_NOTIFY_CHANGE_NAME
    0x00000004  FILE_NOTIFY_CHANGE_ATTRIBUTES
    0x00000008  FILE_NOTIFY_CHANGE_SIZE
    0x00000010  FILE_NOTIFY_CHANGE_LAST_WRITE
    0x00000020  FILE_NOTIFY_CHANGE_LAST_ACCESS
    0x00000040  FILE_NOTIFY_CHANGE_CREATION
    0x00000080  FILE_NOTIFY_CHANGE_EA
    0x00000100  FILE_NOTIFY_CHANGE_SECURITY
    0x00000200  FILE_NOTIFY_CHANGE_STREAM_NAME
    0x00000400  FILE_NOTIFY_CHANGE_STREAM_SIZE
    0x00000800  FILE_NOTIFY_CHANGE_STREAM_WRITE
  
  Example: smbinfo notify /mnt '0x1|0x2' 0

ChenXiaoSong (3):
  smbinfo: show directory in notify help
  smbinfo: make the notify completion filter configurable
  smbinfo: make notify subtree watching configurable

 smbinfo     | 68 +++++++++++++++++++++++++++++++++++++++++++++++------
 smbinfo.rst | 20 +++++++++++++++-
 2 files changed, 80 insertions(+), 8 deletions(-)

-- 
2.53.0


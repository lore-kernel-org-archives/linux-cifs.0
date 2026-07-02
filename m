Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED54923EA94
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 11:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782990360; cv=none; b=mqqYy8hrT7YbeIDIr7MMnREjtj/ux9SjO+SBiiCISmoNcvIX0ED+zMoHzSktdpEXYgnmKEhIyqwQIlUSqedLKCW79ifayJQ4mcEEbi5Eao3X/yhQPo1+jfwCfVhLBk5mJblrEQfMotch4ASZaWOSBTEWnQzgTu36eySgyOj4HnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782990360; c=relaxed/simple;
	bh=mV41vDkFr341gqQoZqn1oqmYQLnvSaSYL1/fD8VBIs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ALWWADWZ7/bJDTrsf2VA7gMz/jpvQnXIchsqpPVNReFen3ju5XI1PoSQNlK6Ct70IY6C4koWawNHNDi4j0gQ4Qm1zBl/HZ7r64/Wl8o7Gg2YVm+tQOMyIWRyEpf6is8gMwVXz1E2MsdUC3E22l1Hy2oWt1urfsvxyBOUoEdKQgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=lewfsgxu; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="lewfsgxu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782990353;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=O9qGcfHsw8a9WOMcfgJUDU1LLNwEfbOxqY/cSaT7Osw=;
	b=lewfsgxuhGfCSHrGi6oEkXbtjjobEHamlAds/XrVoOY8kQuNmAJCrF0DycsNio0hVYOhFc
	COm/JoclECoOolpcJF3eataJLgwwYeFkRuu4m0OMyVPasZVnkYD9cewt2HJb+OV4I1WMy+
	M17ICMJVb2I6sXGhyOjJ8+ZRkIy1lVV9syebKumpI3aqmwOPF9H9X4jmjfExT+YXVH2r3h
	k1Gz2ESspBXOWJFHQrcVpf6yg1C1aXJNMfINhWkrzdxEtL/Gnym2/q/04eGdozQ4domav5
	LKz7N06skoDjd4tupxNoLxiQ5lwYiYmtnXsHx4y27LTal4NlCkQ0i4axf4Vs7A==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
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
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 0/2] smb/server: improve async interim response handling for compound requests
Date: Thu,  2 Jul 2026 11:05:20 +0000
Message-ID: <20260702110522.911411-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

I am currently implementing the ksmbd change notify feature (I will send it out soon),
and I have encountered the following issue.

Before this patchset, no CREATE response:

  Windows client request:
    CREATE dir
    CHANGE_NOTIFY, fid = compound fid

  Server response:
    CHANGE_NOTIFY STATUS_PENDING, AsyncId = N

After this patchset:

  Server response:
    CREATE dir SUCCESS, fid = X
    CHANGE_NOTIFY STATUS_PENDING, AsyncId = N

ChenXiaoSong (2):
  smb/server: factor out smb2_init_err_rsp()
  smb/server: preserve compound prefix for async interim responses

 fs/smb/server/smb2pdu.c | 59 +++++++++++++++++++++++++++++++++--------
 1 file changed, 48 insertions(+), 11 deletions(-)

-- 
2.54.0


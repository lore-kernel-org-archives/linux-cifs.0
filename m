Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B530615B978
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086492; cv=pass; b=fLDvy/RHZ1X1XxoyoJlaBmTtN22NAvB5+JSx6gCKZC0uYtmMyr6MMGiPQ/ouo0VrfJ6+vqXUlEUJVkiPPZWmdXbK+DTMqQoyv9ttpMobJwxkhUQDOcCC6aqFWyjpKLH2XuiRIXsazY/dMR34ztucycGjxJe01brOlA+27oUDT/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086492; c=relaxed/simple;
	bh=qVRlRETcY8kRwBRnokLQFfdNwHDN84O3xHRcY/8N0Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khEDlgvRgHO5z+chmsKNfVs9GqtBh/tJgR8nPf+Mk3a38FBzZNlo/10Ub2SFEi2iq7sxN+MT4Rva8YhxKZ9+aRa/mX1VZtpKAJ0jFuOwrFjjZO605kitlmz1J6Zk1GysHudr0xtpD2nBQ2b3CRaWnQW9Y2e/xQ+hBxwKjT0cRD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=ptYOYkW3; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ptYOYkW3"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtUyWEBuOD6Bqor2G3ZGyuRMG4wxcqhKl97SBKlpZRU=;
	b=ptYOYkW3NrgYM3MEDDTXd5vaOGklq76GNu/vmPJDNk7gex2F5MXizL1qB31LVzdoaQuihZ
	k3z9yASQrcDZBVBnr2LPIJIsxA93RybI9DifkzsPQa1EPG0zxW2wPq3JaQWQzO7jGQS6iT
	3Nex69zHPeenCqJCLDdoeEmJFSehU+iWlXEYF0pT2ZnIjOUNWvarvB0sR1/lZggajUmqhn
	+a4WAWmorO1BYqKTEkbpTWXz3UQbOldVFPajgyOQq6eFzxUb/goLfEonREMT7gJTxrLE/y
	6tEPr0N7rbqA2wKh4hQHcC8CDGwOaMB6YNQ38Sr9DqLHWCYj3qqkNEhmGPr3lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086488; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FtUyWEBuOD6Bqor2G3ZGyuRMG4wxcqhKl97SBKlpZRU=;
	b=NRxlfBba18AF3QGrR+23B30jjjVzAWFSUH+XQPiNyIuM2A4Ed3qZGz2Bx3hDQCXjc898r8
	8OpkrLmIeopqtHb8S+J8oSJsSi/EoPoSKfuBl3zG5ucvi781gyOovWCIb2RTMR97sTMCil
	2ZSrn6XBsFVJU3Ug4k9O2J6A7IXtvzo8z/pKUMRwPeW/GiXpol5o/peT8ncWZ4mR/J1o39
	dl3+ZCAmyMlfOM55F3vgglG67AFmBPLBkkun9YSZBuLTo9WV7iiT9cJpKBlamoh4MTgs2s
	Sn54FE9oYYY0WnHniXCXePz1B9dYEOcjtEEOyb0ukPhwoRvy3zz8kd+c4BD75Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086488; a=rsa-sha256;
	cv=none;
	b=W0xgbttAXTtZE9YOMTeaB+mX9WPSJChkBqnPzjlUpvzMGa9NdOOa2EItGbD/T09YjQ3MQy
	1vFOvwmxtP3OeT/zV6J9zzXcLPIjICY70kIFFmB9ZCfwKhV/cT/UZqLFSKHxcfUMyx7l+J
	zKrxvRhCj/BgBLUpV8yjMTb4m7UyScvdxgPpQYx/OxhXeyIrDNvJhvSTWnZ7DqVu5ovQq9
	3X6EQmvuYQAQ2+YKOMAsORvVkENPydSRrh2tDui3SdUUFsQKrjyK2LdhOXZfx0rJxtd5dP
	sQ5Kve9r1GPbZ/Vw4n9NW7sJr1lwKpaLL5YOwEQrftmbtmZlfk8XqjYygoOgRA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 06/12] smb: client: fix potential UAF in smb2_is_valid_lease_break()
Date: Tue,  2 Apr 2024 16:33:58 -0300
Message-ID: <20240402193404.236159-6-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/smb2misc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 14d74ef70cc8..4abbf6545c9c 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -623,6 +623,8 @@ smb2_is_valid_lease_break(char *buffer, struct TCP_Server_Info *server)
 	/* look up tcon based on tid & uid */
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			spin_lock(&tcon->open_file_lock);
 			cifs_stats_inc(
-- 
2.44.0


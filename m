Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430B315B55A
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086489; cv=pass; b=Ak8aPGpaLWoL8YQi1gyXNZWEm9LkLnRfrDBuU5ET6+IAX87gGhHfn/1NcCYnArASLjeSWjy52YLuBdt5tpXsy+zK+RWhEDQeo177wl8JX858dJJwIKMmLIezIgsFDfb2eXgNtvDMSCkn0MKrwNjhy9G/ET02IrOrJEQOqrQq3Ng=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086489; c=relaxed/simple;
	bh=GHwyWn4yyn+aFcqZgMHPuKRk2PGrD/PxeGjQ+FCLmqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hH7VPpr4nCQjeDfLGJ7ioTUWfAersvw+epfHbfL7BAmTmTPeSI+hJj89iHQjzykdc22fD/VtTv0RRTolquKF1v2CNqCfCLadnWvvz+Rfem7Qnpd7mQu9NvaZez1nKW2EeSEyQLo5+IqGOv5cWkEswhEnFMSySLJD3iUWSDjgAKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=fEz1ZE6U; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="fEz1ZE6U"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086480;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdkdcLl0mzT6RHRLQeedBjYjNRa9l4aWwKjbkBd4BC8=;
	b=fEz1ZE6UG08yKRV5A3Qa9vO5rhQOVuqpPuRVFRq5Lvs4/6uE1O//IJnR0+m8hvRJm7XQac
	fP4hpF7YVLyD2kOS1HwV7B0dGSX0vV8s61oX8wwBxHTX4x9iNHdvUd1aqXiTdi04ioYng7
	ita0tTxCyE2zSPaEzPwiMnnWBfaX9KD7Opnb5snyWq3hgY/aVtjrDd+qtBwkYt2ErobD2U
	4W7Ju+pqp6BafLA6wHY19qu2ihnkMwVybsTP9ReNxoiaeqgbWWAwdJF7JTqJAEljSMe5zZ
	IqBnNgYLTBU3VANASAuGr9Wl0NYArSS2HXum36OzeOg6iIanYRiRzYcX9X2QLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086480; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdkdcLl0mzT6RHRLQeedBjYjNRa9l4aWwKjbkBd4BC8=;
	b=DUkNO1s+P9leigclTPIQiyKn7P1T/Y+tZPYmqZhj2M5cJsy2uglDDlmPj5By4nvIsqFFcI
	CHPWJXGzJAE8E3D3GNM5WIwRIPCH/wYkR9aUyjAo0jLak+kNk9EDEk/Ao/Vqjqn5sUxRl4
	gUwBmhc4CFH0RkSHcEgkc65Sk06JSokyDADMVdFea6oXsbT5E7QuVYfJxLgyEKRkuzNKxk
	heCCpWjD0Gf018s/qZWn+ircO/lNd3qWnwld5xSVAgCs4cKcTBcDIlmqxAFm+5s9UK0b6J
	sbfjgVMh8Ynk2HJfUcTyLunvVp1jWI9EhSqmqPv69GLKV6aG99x3Z+EEh6NJ9A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086480; a=rsa-sha256;
	cv=none;
	b=MAI7Nod4KgvkaBSPpNqK4Pz8MhaTxG3z0CWkAMpMzsXRhTRDOi3hIr17r2Rcy0R1uCY10V
	5L4VmUFOM4376tn3fTt2DURlAE0muXMUFm8v+Ib8wZywYFwPX96ZDVRiR51wjXlomZX5Bp
	912zY9fbQEKRRQH72mkYC8K95f+9H8lIl96Gprf5yWnmv6kWt7Z9+ATZChsHgdMLJzTnT7
	Xwd3PgQCNUxWOapweeS81Ti4ENUIEg6XqSfUBb7v4z8B+pCgctqmCEVbbpXMkZ6jYQhUxn
	K+78eJLtKFgbc3P4dHNpNTRnJRWEBgTo0268NtllLINXnEHI2qSCCOAbkMV9wQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 02/12] smb: client: fix potential UAF in cifs_dump_full_key()
Date: Tue,  2 Apr 2024 16:33:54 -0300
Message-ID: <20240402193404.236159-2-pc@manguebit.com>
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
 fs/smb/client/ioctl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
index c012dfdba80d..855ac5a62edf 100644
--- a/fs/smb/client/ioctl.c
+++ b/fs/smb/client/ioctl.c
@@ -247,7 +247,9 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 		spin_lock(&cifs_tcp_ses_lock);
 		list_for_each_entry(server_it, &cifs_tcp_ses_list, tcp_ses_list) {
 			list_for_each_entry(ses_it, &server_it->smb_ses_list, smb_ses_list) {
-				if (ses_it->Suid == out.session_id) {
+				spin_lock(&ses_it->ses_lock);
+				if (ses_it->ses_status != SES_EXITING &&
+				    ses_it->Suid == out.session_id) {
 					ses = ses_it;
 					/*
 					 * since we are using the session outside the crit
@@ -255,9 +257,11 @@ static int cifs_dump_full_key(struct cifs_tcon *tcon, struct smb3_full_key_debug
 					 * so increment its refcount
 					 */
 					cifs_smb_ses_inc_refcount(ses);
+					spin_unlock(&ses_it->ses_lock);
 					found = true;
 					goto search_end;
 				}
+				spin_unlock(&ses_it->ses_lock);
 			}
 		}
 search_end:
-- 
2.44.0


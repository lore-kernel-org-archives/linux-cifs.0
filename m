Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC8E224B1E
	for <linux-cifs@vger.kernel.org>; Wed,  4 Jun 2025 10:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749032319; cv=none; b=KOL3PHXnuxUMpW6bu2XjFIrptlXDEdpEykZ3cI0aFzX0iDo1mpV1W3ip1+40mJLZ6fafhqoVDwLHZUSwvPm5hbvl22YrSZEleSwEeBB+iI5L+gBIJx//anpYMhAaRqkaAhDBV92ARKtWX6Zq56QSqIjZFq4VMGBskvC18GSlM3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749032319; c=relaxed/simple;
	bh=ABYn1sMyJ7uujizmA6GI0gKWAHxlKNtZyGYpWnh0rp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ad+mSJab15gD0OfQGtAgsVNtba7vwh/hHdwL2IulYUG+fWcZn1hYvQHK+lKNpkA6oNfsGQh1wguraBn095lr/yDHuYlJdZXuHe1aTBqzXlwJ6iIAxjKYAq+qoJTfQtBceFJk3+9L4o4qajiZMnoUSvDWHyfKq5Bg05BgESD78qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NIic+ToQ; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NIic+ToQ"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-234e48b736aso78429735ad.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Jun 2025 03:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749032316; x=1749637116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9CjUb9vOs5POtU25rCaaN3b6Y1xuJ1kJ0I4yX8hOC4=;
        b=NIic+ToQxWZ9YtDFT24kmzS967IHvzDrctW1SNb649pO92Q/E+v/QTeBUxsWYSf8D5
         5whTtaslg+QZLO01dbk4/hmWOnGiGWHwrfd94Af1q+mQySTcJoEMNXA144ubRL9HBXd2
         AXOkm0DlWOvIet+32RY2MPTM4Bl4El8rIi8I6ni4QOf6SGsL/hFsRSu//QlL6kx5BzIF
         jpSQv0KbEQmQFK4UyhQU+RiAluiXFaQ568n3q9nQrqSLP2EFSA4ytXa3Q1/DoQSsbN/o
         LU2uxlkoxI+tn93tw15fL1KSBi9yWfPk6ulLlTYDdsFd9KQkmIVD80R4YkoTHEnd9Zja
         QJ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749032316; x=1749637116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9CjUb9vOs5POtU25rCaaN3b6Y1xuJ1kJ0I4yX8hOC4=;
        b=khLVdN9bzxL/7FWXSkyrfCbVnuHm9uEwV4e8kMCDuM7q7T75jR9ZsD0l3jJPkDBujI
         4q6JQOqP59JZwj9Jqp4fSmeSwKfMdi9gtlLC8vEgjO2s0FSKzjwQF+aUS+m/mSI8yOOR
         VhHoQlPBg61i3wh14kZC31brLxkIvz80MAIDQojhxZ0p5ZM/t7jj9Xup5znL18B0aJkP
         OA4D5zJTazHCbca4y5/WXJOjf2bCKFx08bj035uWsiZLyLw4YFJ0TuHulSJ0mdTAwUdY
         c0CprHDp+j4ffx5wvd5ebT6H6oIscJyZ9P0I3gVABd66ErKuYgYOCxwUnnLbNYHD9sZb
         c4Yg==
X-Gm-Message-State: AOJu0Ywp1PGn6O1gD3CBP2YiAOe6UcdL/HmDLjoaG+wv1RLsg71xWVne
	4LvngRRPb3Dc6apWzalHeCUKAaq16N8ILWX93mCnhLa9QyBu3sZTJfSmIhnOeB73mtc=
X-Gm-Gg: ASbGncuo56bPbiQMFEvTl8YS1sTwqdPaeW0DjVZzGIJ16Dgv+eMqnzIFh0AN2yjDkRF
	VznHItzATWxYe2y1s462rqbyrOzSOe0Xzmvugp991RvmvVsWcRNJ/Wyu5qBolbSgRIbWyiHgeR7
	F65l4jE0RUW4YOOFl4zdADUwBYGIAsJ/SCw8/qUmNf5dYV2dLoTpI7y0EDjlWwqwba3IpzDg+MQ
	EjoHChZHOqnqcjNNHVPMOvEgazlFWXa7gEzoOMCOomoeMyIIkmEKRI/E6IQkXVSIPOA27wCEhbU
	+GxxaFGN9q3XHzvrAewJsndo7GQaQu5gWoOd1OQQCcrT4mrEDmWYw1KxLoyZkxsvaCSOq0NoOel
	pI5I=
X-Google-Smtp-Source: AGHT+IH8CCfKyYbuc3AxvpPoW31UP4We/c2ccYggIIA86EziMpckiDtccQM820Wp+/AQ6XNT4vf6ig==
X-Received: by 2002:a17:902:e951:b0:235:779:edfe with SMTP id d9443c01a7336-235e1255989mr34255355ad.43.1749032316523;
        Wed, 04 Jun 2025 03:18:36 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506bf8132sm100563625ad.106.2025.06.04.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Jun 2025 03:18:36 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com,
	paul@darkrain42.org,
	henrique.carvalho@suse.com,
	ematsumiya@suse.de
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 6/7] cifs: tc_count updates should be done with tc_lock
Date: Wed,  4 Jun 2025 15:48:15 +0530
Message-ID: <20250604101829.832577-6-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250604101829.832577-1-sprasad@microsoft.com>
References: <20250604101829.832577-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

We had problems with deadlocks using the cifs_tcp_ses_lock for
protecting a lot of structures. So we broke it down into smaller
spinlocks. cifs_tcon struct fields are protected by tc_lock now.
Hence we should stick to using that.

Fixes: 3fa640d035e5 ("smb: During unmount, ensure all cached dir instances drop their dentry")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 2746d693d80a..4abf5bbd8baf 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -650,10 +650,12 @@ int cached_dir_lease_break(struct cifs_tcon *tcon, __u8 lease_key[16])
 			spin_unlock(&cfid->fid_lock);
 			cfids->num_entries--;
 
+			spin_lock(&cfid->tcon->tc_lock);
 			++tcon->tc_count;
 			trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_lease_break);
 			queue_work(cfid_put_wq, &cfid->put_work);
+			spin_unlock(&cfid->tcon->tc_lock);
 			spin_unlock(&cfids->cfid_list_lock);
 			return true;
 		}
@@ -767,11 +769,11 @@ static void cfids_laundromat_worker(struct work_struct *work)
 		dput(dentry);
 
 		if (cfid->is_open) {
-			spin_lock(&cifs_tcp_ses_lock);
+			spin_lock(&cfid->tcon->tc_lock);
 			++cfid->tcon->tc_count;
 			trace_smb3_tcon_ref(cfid->tcon->debug_id, cfid->tcon->tc_count,
 					    netfs_trace_tcon_ref_get_cached_laundromat);
-			spin_unlock(&cifs_tcp_ses_lock);
+			spin_unlock(&cfid->tcon->tc_lock);
 			queue_work(serverclose_wq, &cfid->close_work);
 		} else
 			/*
-- 
2.43.0


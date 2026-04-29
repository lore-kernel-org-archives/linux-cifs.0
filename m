Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035AA394462
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 20:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495992; cv=none; b=qq50CWHj4ekGDjtdBribuo9TZHYCoRC52TMEdl4JcD0Sq2WqF1oPt1YOSTomFv6OuzlpczF6MC2X49H+xhKaOaKqHoz++/BTOkNtJHZrRYyOyuwIknAEv2V9FWMKlzTrVfA4zdyPeV6QuUmAZvhaVOeRHVSdt9v9mpytz7AZpI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495992; c=relaxed/simple;
	bh=B43jmh8tyellEDHw/JHQWGP4Kl4Bt82DdbNgnsOczTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwTySs9CviLv10PdNM4wdYOhcoP/vN2N1kxH4jNU84bCdaQcyNwStuvxdr/Px2Kcv999IyTm5iTY7y/ODx3J+CDfhOLR//V04IEhIFctP5qqzKrkHkJkOSlCp6sj0t2n/5lX/SxoS9c+8yHwPSRtL9W5DU5PEENQlIBGwGBjiQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=E8yzMhy4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="E8yzMhy4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso2081405e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777495988; x=1778100788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86QVkp45/ToGTd4flnsgE7Dt+Q0OFD4ax6NkF368peQ=;
        b=E8yzMhy4SOL6sxsHtnTEJowaR2HCdNuuHqgmWU6jqGPmlbOw+xyuK2PyvCIYvceKqb
         xnJJk3pUIGLqMo3mgHNAnaDG2+bOtb3QtoMz5mayDDiZ45dhiuKap9tTgm++VyndyhiB
         Sv2P3vVMoYPq/dPqAzv4hsbj6ZAgwcp1DijNrg4psx+6Cr1KhqGP75pevVTczZyTG9kg
         64yi+b3Jfe39HwGVfngVQw53GMXrnoaQwa149rZzezucbr/2lTf6U58jLV1eeKePihAX
         sQ61q066u/mpR+nwA3FLJ3oNBPUB8JQjuWYiWY9k6WlHo5uojm7ubZxtQLBvEW2KqJW+
         YJdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777495988; x=1778100788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=86QVkp45/ToGTd4flnsgE7Dt+Q0OFD4ax6NkF368peQ=;
        b=cmZAybl8jRdekgTWOvr1hOBnlZ9pjwYOW2icvbZCzkEiGYwvR0t2B2jHRPkBrARUmp
         nF4owWhS2qfcAR6WKMre5mT4tEpE3oSUjXHFpXBXXicL4XlSmikrbymruRbTheRvKGc7
         J+PDwDVQvLwb6SX8/V16WVVJ5C2yO/tRhxWRK39mRDTzJgY8KiDulxk6uaP0A3Db4OH8
         8K3s2OW0QUfPHzlZ9ylv/yZjcr5x8KzD3x26zhwo7eGrGBFH0Wt858NBrDgC79C+NubX
         sq+qc/HWlBYhHa1uo/xBSlJNu1i2fqlBFA/5gppwpZD6Fy4xriZm/nfKUzTQo4oC3eUV
         JxGA==
X-Forwarded-Encrypted: i=1; AFNElJ9AEbIjdD3P3fhWT+QNyLBiS6ZRZqesPefIAGWkpAt3R8UUXuWEZFPfJfqV87cBaJSi+rcNro3OOt+5@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7j3ZokQO9G9FSV2EpY0vAMBtlXfIeA4KbNg3t3gN2StG+CY/6
	gqWaV4sqY3UdYll4VOr6DZhBXyJzNSfQj/IHVva5vHqyjEk4HMSxHjlqvm87Yll2CvA=
X-Gm-Gg: AeBDietKIYjwcGYamtxfnuhSLYaeXoeJEVi9GngfyXCyyQOZ90eECEzcouKJh3O8Dup
	iTXqKjKvSWK3Y3bdkm9RtIzk0Gy3NGErGPI3S6MwfIUkAPpKX3+qEOyxLMq4HqxxWgCbW4sysya
	x8xvg8WOl1RlcOWBUKrrLCgq/8srZKBeIKGQPRGL6l607gxDwSVZbu8IL4mGggl6wdRh5Yw1LGA
	NSc+mvmXg1eRhMpy5X47zMRvPOqidzc3a0HG+44DG6tA1GG5Gf9jpWe0fO3Dxl2Hc7dV6C/Yj2B
	NcPJvi39gDggt3o7GD7ZeM3fUspDADJFuEUzzP3vJXYmyxtO3mI/j6bu9+gdmDHJDcqTjTQlETD
	9Q+COCDmQJ0h0xQzbUETDtnUJrGHu14Hs99RwNtzNr+1HSpEMXnMjHw164RU7imzSyMfL08k37B
	haT8LMJqp3BrUIDt9+mxNzTlfdyakOlolDK6ffvqs05q5P
X-Received: by 2002:a05:600c:c058:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48a83d6f154mr2397105e9.9.1777495988358;
        Wed, 29 Apr 2026 13:53:08 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de3269b41sm3925240c88.13.2026.04.29.13.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 13:53:07 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: metze@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 2/3] smb: client: fix race in multichannel rescaling during mount
Date: Wed, 29 Apr 2026 17:52:35 -0300
Message-ID: <20260429205236.456099-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429205236.456099-1-henrique.carvalho@suse.com>
References: <20260429205236.456099-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mchan_mount_* introduced async channel rescaling during mount. That can
lead race with other mount/remount attempts that use the same session,
when these are scaling down the channels, potentially leading to UAF, as
described in
https://lore.kernel.org/linux-cifs/rw7ptbx22cntes5eag5r3kvg5mzfvvzdhj4v2kw6mnunmsewev@f2iyrmmitkl3/

Fix this by using the same serialization used in other rescaling paths
and if in a race, rescheduling the channel scaling work.

Cc: stable@vger.kernel.org
Fixes: 556bb341f9f2 ("smb: client: introduce multichannel async work during mount")
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cifsglob.h |  2 +-
 fs/smb/client/connect.c  | 32 +++++++++++++++++++++++++-------
 fs/smb/client/sess.c     |  1 -
 3 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 82e0adc1dabd..ef63a1c3249c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1817,7 +1817,7 @@ struct cifs_mount_ctx {
 };
 
 struct mchan_mount {
-	struct work_struct work;
+	struct delayed_work dwork;
 	struct cifs_ses *ses;
 };
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index dcde25da468d..2ea93f0b78c9 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3813,7 +3813,7 @@ mchan_mount_alloc(struct cifs_ses *ses)
 	if (!mchan_mount)
 		return ERR_PTR(-ENOMEM);
 
-	INIT_WORK(&mchan_mount->work, mchan_mount_work_fn);
+	INIT_DELAYED_WORK(&mchan_mount->dwork, mchan_mount_work_fn);
 
 	spin_lock(&cifs_tcp_ses_lock);
 	cifs_smb_ses_inc_refcount(ses);
@@ -3833,13 +3833,32 @@ mchan_mount_free(struct mchan_mount *mchan_mount)
 static void
 mchan_mount_work_fn(struct work_struct *work)
 {
-	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, work);
+	struct mchan_mount *mchan_mount = container_of(work, struct mchan_mount, dwork.work);
+	struct cifs_ses *ses = mchan_mount->ses;
 
-	smb3_update_ses_channels(mchan_mount->ses,
-				 mchan_mount->ses->server,
+	/*
+	 * mchan_mount_work_fn could race with smb3_update_ses_channel called
+	 * for the same session on remount, other mounts or
+	 * smb3_update_ses_channel
+	 */
+	spin_lock(&ses->ses_lock);
+	if (ses->flags & CIFS_SES_FLAG_SCALE_CHANNELS) {
+		spin_unlock(&ses->ses_lock);
+		queue_delayed_work(cifsiod_wq, &mchan_mount->dwork, 2 * HZ);
+		return;
+	}
+	ses->flags |= CIFS_SES_FLAG_SCALE_CHANNELS;
+	spin_unlock(&ses->ses_lock);
+
+	smb3_update_ses_channels(ses,
+				 ses->server,
 				 false /* from_reconnect */,
 				 false /* disable_mchan */);
 
+	spin_lock(&ses->ses_lock);
+	ses->flags &= ~CIFS_SES_FLAG_SCALE_CHANNELS;
+	spin_unlock(&ses->ses_lock);
+
 	mchan_mount_free(mchan_mount);
 }
 
@@ -3885,7 +3904,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		goto error;
 
 	if (ctx->multichannel)
-		queue_work(cifsiod_wq, &mchan_mount->work);
+		queue_work(cifsiod_wq, &mchan_mount->dwork.work);
 
 	free_xid(mnt_ctx.xid);
 	return rc;
@@ -3942,8 +3961,7 @@ int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx)
 		goto error;
 
 	if (ctx->multichannel)
-		queue_work(cifsiod_wq, &mchan_mount->work);
-
+		queue_work(cifsiod_wq, &mchan_mount->dwork.work);
 	free_xid(mnt_ctx.xid);
 	return rc;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index de2012cc9cf3..24d5206e5c44 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -627,7 +627,6 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 	return rc;
 }
 
-
 int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifs_ses *ses)
 {
-- 
2.53.0


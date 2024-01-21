Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E4914A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808027; cv=none; b=sH5bQpwDjdwVjp9in9Zhfwf5G7GWJ/qeiXovn74F1rO5/R/Et9vK4gLXRFggRFz5TYpo8NzUar2yjKJctlVaatFQm4VK2esS5FG31Rcuw+ISV/WlVTA5Pmvpvgl0X+CmmYSfB7K53Se4csYxEUe7NitQKrkgOBWUqONPVt4+BN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808027; c=relaxed/simple;
	bh=90fIssesruBejQk3fFAKmnKOfLRqH9XQjd2pio6C4fo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tvAEi98d3OhS081HGT8L9dYjFP4e/idhAINhjvtWevSYP0777UYmZ7kHWzh8ZEbIbrNmRaGB1yMdaXn+5g9bD/JrHRvnhtMhEIMxNu8q+cAlbt72JgmrS1sl9IVQayVEDOjNrz9kt2cKXrw3dicBiIFfeXA7y4Y8VgAE6NEFRtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LYFLS+pt; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LYFLS+pt"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-29065efa06fso722656a91.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808025; x=1706412825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l5VoHQ53gbjaawVnEnn5BrKaSO5fVnuv3DA0TA0OWPI=;
        b=LYFLS+ptCKq92v5NRLYsoUYBR0Qgcf5a7twV6wV0oY9bgeX8nn1jUdnNxl7mYcvCk7
         FoBiFiXr66sk/Axfnznnl0kzL24kWPJwwbCY/LZDfM1X5G8LEi6c7oWHDeBmH+WxyhlJ
         kyOIUmjs34jqveEM+91ewhpks7eUbRBU1mYWhAUdhM0iHpUxKQRGClM1CCLEa+q6F8GT
         bu2Xhl72HTAtfXgIFiy+d2UbbG6c/Oe7fB1vYaZb5pKJMIxWqDghdaNMEakan0EHzH8o
         K0LoUKyl1LuQj01W5DHc+L7+hJO8Yh2ncAF9aH+RextQ56glNnfJbaqmE/C+2UiSVMst
         6SxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808025; x=1706412825;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l5VoHQ53gbjaawVnEnn5BrKaSO5fVnuv3DA0TA0OWPI=;
        b=fGmZtYTVmH8UL2wjYwG2SRaWyajY/NuBwKZROrQAiJUX1IwAC0nsMYHxCpXDne/9g4
         qvO1mymQk1OvFufc44KCvu8OJaSP5E2Z5GEETAti6Bx6/Vm6rqj41M6AZPN/ZwUgJ6FX
         oCc+OKOWNZ4sIr7A4MPdEOzwcheg7js7lrw4mF/iCqfNx+qesDXzvZK69W1iuSx1T6Za
         iAjVtu1qzrxeiQ74dPf64eql5Djsv/vkpa3tmPrguEPDdzv6UKpNy+fU9DVxWZwH2A43
         JADVCby3wPWrRwH0tiqzS/e/ykG+6etiuin5iHcYtC2SUjVVagz/W268lMwCHLaqzp43
         BKLA==
X-Gm-Message-State: AOJu0YyQDkSowJeZEuAigEsc0SNi2sNLNu1B1eBks7lke+kjEukb6Eci
	QPKCZ/7Kb5lCZodsyHNIcknypSrx/lqtuGNs2oPlFgWeeQZF1Z4RyFgm6iVA
X-Google-Smtp-Source: AGHT+IHJDWzVBxu2dNGeQuDIwTx+f1+RcoX9VOShnL2F63w2Svcrb888YV475Xb/LqUdr+fhsW5JvQ==
X-Received: by 2002:a17:902:db02:b0:1d7:467b:f488 with SMTP id m2-20020a170902db0200b001d7467bf488mr594599plx.114.1705808024785;
        Sat, 20 Jan 2024 19:33:44 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:44 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 7/7] cifs: set replay flag for retries of write command
Date: Sun, 21 Jan 2024 03:32:48 +0000
Message-Id: <20240121033248.125282-7-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240121033248.125282-1-sprasad@microsoft.com>
References: <20240121033248.125282-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Similar to the rest of the commands, this is a change
to add replay flags on retry. This one does not add a
back-off, considering that we may want to flush a write
ASAP to the server. Considering that this will be a
flush of cached pages, the retrans value is also not
honoured.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/file.c     | 1 +
 fs/smb/client/smb2pdu.c  | 4 +++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index b5abe4d6f478..acda357e1dfd 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1506,6 +1506,7 @@ struct cifs_writedata {
 	struct smbd_mr			*mr;
 #endif
 	struct cifs_credits		credits;
+	bool				replay;
 };
 
 /*
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1b4262aff8fa..49d262d1df5f 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -3300,6 +3300,7 @@ cifs_resend_wdata(struct cifs_writedata *wdata, struct list_head *wdata_list,
 			if (wdata->cfile->invalidHandle)
 				rc = -EAGAIN;
 			else {
+				wdata->replay = true;
 #ifdef CONFIG_CIFS_SMB_DIRECT
 				if (wdata->mr) {
 					wdata->mr->need_invalidate = true;
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 0291482a3f51..a8ac9240a854 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4770,7 +4770,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct cifs_io_parms *io_parms = NULL;
 	int credit_request;
 
-	if (!wdata->server)
+	if (!wdata->server || wdata->replay)
 		server = wdata->server = cifs_pick_channel(tcon->ses);
 
 	/*
@@ -4855,6 +4855,8 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	rqst.rq_nvec = 1;
 	rqst.rq_iter = wdata->iter;
 	rqst.rq_iter_size = iov_iter_count(&rqst.rq_iter);
+	if (wdata->replay)
+		smb2_set_replay(server, &rqst);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (wdata->mr)
 		iov[0].iov_len += sizeof(struct smbd_buffer_descriptor_v1);
-- 
2.34.1


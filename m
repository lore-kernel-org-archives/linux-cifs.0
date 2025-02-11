Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A611F236C;
	Tue, 11 Feb 2025 10:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739268090; cv=none; b=C679065kmAriTa3LKwEj61D8J0SxG4/bjQSoTWUv6HXK2KZYkhBFhQCIUhmFM2EHFJLy7ZZMC1Wl+ne4wdn4Y8IXdrXnYyb2NBl5gvLdkB4au2mrRoL9IhfobYievN/XO1KjEyD0Oa4aXZP/z45DB0BKDm6V+LQ2GraxRV5tWas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739268090; c=relaxed/simple;
	bh=iErw32Uq4t5PXKFtsL4Eo9itj9Sq8wa9Jeeaqn9/UuE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l6AOlCaW206zvVtQVpLiX0tyLEFr9USNWslFpt+S5qxIvwm+e9K8zaZC6gj8nJncSy7JsH84mCCl5WaE1EmUeG35fDLzJA3dM9wRJ4+4fdjX38kkpP/zrCy4PwpwGIfRsGyDdzfqvICWOWAJZdbAen9CzJEOSq+TuIuuTUya/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QzZRn0YJ; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzZRn0YJ"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21fa56e1583so26484945ad.3;
        Tue, 11 Feb 2025 02:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739268087; x=1739872887; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lmVkjN/JH5TLrtl/d3KpNoTShOymLH1OzzxUyH/meaQ=;
        b=QzZRn0YJcKcrREdF0ydAGNJCPt916zxB//L8UALm21bJGAzAghLMZ3NP5pllyiamEe
         Z14OHIJrK/MWCXREBcmwXABfYlSU01OkMps1JkSPNCfRPfgYtBvQurOlSVVHBwH/sFB7
         OWGKChWqTJKehZOWy+LCRv+CBTf6I3GGHwm4HgQ+qZsdGcdQcNzzRAWxYXyRIsOAvMuU
         /OG+FXn/KDnrTHWrQZta+q8IB0SSOUAcP2vtp5SafTYmhC1uxOTdMhGNGeIRKfG+QGVg
         p+mwEEcZfsNbMtj3aT7R/lMVT6WbrivO1Z+a6h0+qigjbgDuZPKqDu9HVkwnYuQRhF3t
         aZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739268087; x=1739872887;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lmVkjN/JH5TLrtl/d3KpNoTShOymLH1OzzxUyH/meaQ=;
        b=fZ7lc79ABDJfonAM/uSVDjbzPA5SmwTX1AgDyzl+NdKfVRQxscxkDLITVIUr2FE1HB
         Jb0YbGZMANkHA/oGwqbmIs/SOd4tFVemEh2LDAZY/APCGPn1Usl4UQFn2jdQJbsZizUa
         TrNIiSnP7+o/uATj0OgHZsRuskG/8X5wLDajGt8PWJb9A67Q0NTd4rNWQa3J0ckdFnSh
         OjuD40EKHVvqlPmww+R4xJhRBrW8VBt3KicQTVUfjINEyCqYQN6653pGR/H8otMcYI+M
         W7pVduRH7r/eY8iF/oS3IueTuWol1GugbK+nezkMfGaVgrNFi8Eve2GTPFjJ27YGDrSL
         z7gw==
X-Forwarded-Encrypted: i=1; AJvYcCWkA90pRZJQJWN8Q/Au9gX1Fjfl6HN8PGDQcb0uYIFj1ZB3WIZvVarEqjW3DfCN/8o43iVzSYE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGgn1GaPchJxft6d8ltVQig3vH1C0JpDpTQuGrrnMX1wz6TEpw
	fBGp2EiGKowEsEEtvlt/5y5pvJWazDpWBdkeRgCNm7TbLiJq9Xc0Cfc1XoeM
X-Gm-Gg: ASbGnctS5zkqRdHAIYnrsQJ8wTYjLFsBxCF5Ipe5yQNcfdCHlGU/4vn1NtYSWBx0AiJ
	la7Eb3J4ZUCf0tyjT+hwP0/5IkCYhvwtWf5L6hGwCvf05oIDtFcdqDgxkCvmZ/CldGaneQ0U2Q0
	KhNR1n2aysNsVruu3WJ9BWWsMxpGu96lRuBs8ZpOJAlHifu/khNz6Zo/6ZXQczSz47njxXhPLAO
	qSx0QM+NV27uZH4fU5sCQliuRcNP0sKZKp5BdRPPAx++nSJsDFGZKqwKmJv7YzpG9jgchTuxDfH
	sGbElBnif24K2D1V7WKNXj/8941CdtoMS5N1K4NS1WskDzBFwA2IIA==
X-Google-Smtp-Source: AGHT+IGwW3HaNtNKHyCPGuM4og62OtaS9MMOw3inzVQNLyl2Sw1Mg5Lr9Z9adTxVQM3L1qegaH75gw==
X-Received: by 2002:a05:6a21:2d05:b0:1e1:ffec:b1bf with SMTP id adf61e73a8af0-1ee03b12947mr25752977637.26.1739268087234;
        Tue, 11 Feb 2025 02:01:27 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73085eb5facsm4297730b3a.11.2025.02.11.02.01.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 02:01:26 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: pick channels for individual subrequests
Date: Tue, 11 Feb 2025 10:00:25 +0000
Message-ID: <20250211100053.9485-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

The netfs library could break down a read request into
multiple subrequests. When multichannel is used, there is
potential to improve performance when each of these
subrequests pick a different channel.

Today we call cifs_pick_channel when the main read request
is initialized in cifs_init_request. This change moves this to
cifs_prepare_read, which is the right place to pick channel since
it gets called for each subrequest.

Interestingly cifs_prepare_write already does channel selection
for individual subreq, but looks like it was missed for read.
This is especially important when multichannel is used with
increased rasize.

In my test setup, with rasize set to 8MB, a sequential read
of large file was taking 11.5s without this change. With the
change, it completed in 9s. The difference is even more signigicant
with bigger rasize.

Cc: <stable@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 1 -
 fs/smb/client/file.c     | 7 ++++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a68434ad744a..243e4881528c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1508,7 +1508,6 @@ struct cifs_io_parms {
 struct cifs_io_request {
 	struct netfs_io_request		rreq;
 	struct cifsFileInfo		*cfile;
-	struct TCP_Server_Info		*server;
 	pid_t				pid;
 };
 
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 79de2f2f9c41..8582cf61242c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -147,7 +147,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	struct netfs_io_request *rreq = subreq->rreq;
 	struct cifs_io_subrequest *rdata = container_of(subreq, struct cifs_io_subrequest, subreq);
 	struct cifs_io_request *req = container_of(subreq->rreq, struct cifs_io_request, rreq);
-	struct TCP_Server_Info *server = req->server;
+	struct TCP_Server_Info *server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(rreq->inode->i_sb);
 	size_t size;
 	int rc = 0;
@@ -156,6 +156,8 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 		rdata->xid = get_xid();
 		rdata->have_xid = true;
 	}
+
+	server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 	rdata->server = server;
 
 	if (cifs_sb->ctx->rsize == 0)
@@ -198,7 +200,7 @@ static void cifs_issue_read(struct netfs_io_subrequest *subreq)
 	struct netfs_io_request *rreq = subreq->rreq;
 	struct cifs_io_subrequest *rdata = container_of(subreq, struct cifs_io_subrequest, subreq);
 	struct cifs_io_request *req = container_of(subreq->rreq, struct cifs_io_request, rreq);
-	struct TCP_Server_Info *server = req->server;
+	struct TCP_Server_Info *server = rdata->server;
 	int rc = 0;
 
 	cifs_dbg(FYI, "%s: op=%08x[%x] mapping=%p len=%zu/%zu\n",
@@ -266,7 +268,6 @@ static int cifs_init_request(struct netfs_io_request *rreq, struct file *file)
 		open_file = file->private_data;
 		rreq->netfs_priv = file->private_data;
 		req->cfile = cifsFileInfo_get(open_file);
-		req->server = cifs_pick_channel(tlink_tcon(req->cfile->tlink)->ses);
 		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 			req->pid = req->cfile->pid;
 	} else if (rreq->origin != NETFS_WRITEBACK) {
-- 
2.43.0


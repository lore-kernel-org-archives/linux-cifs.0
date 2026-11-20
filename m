Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.227.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795158963;
	b=r2HK09B3rUnSfnAuSzAdIpREJm4kUWrudbFSpDKH2ZF/jvzsXHP5FWMSsO1Fbf2nh1oX
	 C9WdHnTHskYMuNFSxTRyg2LRpg5SK7Tu2cHTu68JhXSPljX9GKd45RDGO4vbYH8MQFXsj
	 1g+aJXRbP2k+OXpKuZ1XNnEN5ZHCTMT4EtZsFF+LVFracUpdMy5p7dJX3OJsUPzqBrdfF
	 Ah3g4jjlIQQz+xgwCvdW/OLgIUbMSgPrW0hJfESqkaftmB12u6GE5mqrLng1DL30puBsq
	 URfMKpVK6RxIBxvXH7I3Io7ceLh0ms5VegGqG3WY4uCdFl/Y4ejXd0JcE6LDQYxktRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795158963;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=G0T4hYukVUR3bM8ultu5djVwEj07TU7Yi+IVhgyDzew=;
	b=kNavVRNIWDsgznhk5yNaTX0Po8nEVqVNgiB6chlEmNXdtdzHWIq8vEU8490QTpdpa62i
	 KHLxLypZQy8QHPCmnlm1oPj8zUUsIi1sN3rwDalngCtriVQCiHmS1JfH8Cj1/P2gzpESL
	 vts9phn0sTJltmv2ue+1j1H67tPr6r33K868De1XXpjKqz7kkAdV2r1X1CWGkihaPhZAO
	 PU2x5b1qy0rIOawx2gVGuaShiZ/5coVKCbfnN//TYsLuKDFGQnkMUCRle9vtMrKRecldA
	 H0z4aFkZLllINGpOTQObnPAYjlUixduWDQP6fADZm99Av9RqIbucRpcn5q3ywkbEhOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tsxuyy1E;
	arc=none smtp.remote-ip=74.125.227.138
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A9260A2629
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 07:16:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31A9260A2629
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tsxuyy1E
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3b4067446d7so132778a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 23:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795158962; x=1795763762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G0T4hYukVUR3bM8ultu5djVwEj07TU7Yi+IVhgyDzew=;
        b=Tsxuyy1EqSoHGfhTeWgBxYwdjjJZlzV0M2oE/zq72QvT7TPDk1GfNSK5uYYuEeHxWK
         4BRg5NlGGjEYKlvP4bUY6NIHt7BHLWxhB0dp8vOtq59zOWLoRmZuyzwUdvg7HevvkLGt
         DOgADEF8DiQ1etG5Vk2Lx+uwV3X8spjB7cUeCqjP+2y03I9VgQLwsa2ccQV5X0v7LkLW
         gbJl547lCa11462fRqHZcMnjmGxJLQ6nyiuIK8sCo19JDYLqSaAVGhDat841wba+8eZ/
         tTDaoLaGs2rTw1WwygrjK/Vt6Rra/ab+tk8+3S59S4RiW5U4fECOLc5vCEGDU3rTuVsW
         6Fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795158962; x=1795763762;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G0T4hYukVUR3bM8ultu5djVwEj07TU7Yi+IVhgyDzew=;
        b=QZdmIqsi/ZJ8uKhKtjxaoFNnzluSckkXb4qB88S3gLHJEjwZbpiOwvtwIcDeiJpie8
         CtKk0+SX516H1GhKrwoKvsJGIQfspDxtteU7K3qbxc7P67D03LqTIli6iRfifWJSflYg
         Au9afhAJuP5yoM/utHXXMgkB32tkODNEwgqY9KeWpvgE9vF1XgsMrYT5t35gRjj6mgoz
         mYeihDIBM2UKv1/4I1rtxuuxKYPgxVQh9hyrL99GbfIEZNFLkN0QCVJLHNT7UtDlDJTz
         ucgJpQVO1j0fgicPZrsNlgUoq5rKDAn6oJAprYP4f6RJOIPjfSkgFa0+07+2dkla5vWy
         RxWQ==
X-Forwarded-Encrypted: i=1; AL+hErGIRwdIzJs87/CPs6cQpdyKAk8hM7UkdHRs0GOXh2vLxpVA0uB9zDrgdiHVj4/ChWSWMyTtafqQciUS@vger.kernel.org
X-Gm-Message-State: APuU4Z/qBFmW6nANI8T4bSW4n/1Ys/5my2zLthRbddem4eNcyWrbs1VL
	nUr9aEp7dAhlHwGVYrZxFlA+5PCUPqBO5/9H6ge4NW2N0fpyIGGxl8s1
X-Gm-Gg: AZFdTZf6ig+ZZ5B4cnC75b8A//f5mPubmNHmN+rsJmQGjEUh/QYvNP/5+R6l4gFRGmo
	mWuAG318K7sx+iPTXzyC6hHQPw/K6V7SMM7msv+6D3gpPI7mvwCZ9VZMCDF7TgGhvOSSd8xqfM/
	VMiT73mr1N61o0MCuvQUj1HnQBi5ragOei4TzWBeI+xagIBvVIoZTRpw6Yc3c9UC1D5ngG00C5B
	BnAzUdOXFATKiCP8VFD8ru6wnqSin0H7JYFZJxXQdb3UIxQG8hwmBXXZctJjJL8YPBVGfh0nEUs
	YWkDRimdsDI7MNwaPJ2VOvCbW8J6Tk9oEfyiEXswwI37uJXZpo4inXcqRW+TLPqJK1pqMd+bF1p
	KlDHJa7VNpgXySysbCika8a2Af3F5fk4/9UP307wNJwZrQQKiyHTVFtl7tZYyVV2oJGiIxgtvaL
	+ZhE8S9PAJ9T5W0y7+47Ht6YETBTFOyjiUuzAnsPKFSN9t+UjtD3PHzkd+tUcVDKhhn06eOqvdf
	v4VZOHOU7fVjAaX3yzaTxonpU67wpn4sQA/OesYOLJeooxBMNYHSjnM+fqmkdjEm5rffHgMXemB
	u99OQDR78/0kW5bESoRc6q9D/RSj0EiV+sDHZ5A4E/PvDTm7t7cP0bEutKymf7Y3MumLG1HMeGe
	FYNFJiPNeh5Y2iF7wZxNdAUSKl0Qu4JUnKrCaZA==
X-Received: by 2002:a17:90b:2e4b:b0:3ab:884b:659e with SMTP id 98e67ed59e1d1-3b41c8e1705mr1694042a91.9.1795158962383;
        Thu, 19 Nov 2026 23:16:02 -0800 (PST)
Received: from localhost.localdomain ([98.148.34.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d639fdsm6258830a91.10.2026.11.19.23.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 23:16:01 -0800 (PST)
From: Hungyu Lin <dennylin0707@gmail.com>
To: linkinjeon@kernel.org
Cc: stfrench@microsoft.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	lsahlber@redhat.com,
	linux-cifs@vger.kernel.org,
	dennylin0707@gmail.com
Subject: [PATCH] ksmbd: refuse to open an append-only file for writing without O_APPEND
Date: Fri, 20 Nov 2026 07:15:53 +0000
Message-ID: <20261120071553.28739-1-dennylin0707@gmail.com>
X-Mailer: git-send-email 2.43.0
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

smb2_open() opens the file with dentry_open(), which does not go through
may_open(). inode_permission() refuses write access to an immutable
inode, but nothing looks at S_APPEND. A client that has write permission
on an append-only file can open it for writing and overwrite the data
that is already there, which open(2) on the server and nfsd do not
allow.

Refuse an open that asks for FILE_WRITE_DATA or FILE_APPEND_DATA on an
append-only file like may_open() does, unless the file is opened with
O_APPEND. Leave these two rights out of the maximal access of such a
file as well, so that an open with MAXIMUM_ALLOWED still gets a handle
for reading.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
---
 fs/smb/server/smb2pdu.c | 7 +++++++
 fs/smb/server/vfs.c     | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6bd63c5e7da3..e83e1cc3ba4f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5122,6 +5122,13 @@ int smb2_open(struct ksmbd_work *work)
 		goto err_out;
 	}
 
+	if (IS_APPEND(d_inode(path.dentry)) && !(open_flags & O_APPEND) &&
+	    (open_flags & O_ACCMODE) != O_RDONLY &&
+	    daccess & (FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE)) {
+		rc = -EACCES;
+		goto err_out;
+	}
+
 	rc = 0;
 	filp = dentry_open(&path, open_flags, current_cred());
 	if (IS_ERR(filp)) {
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 39bbe6aad629..e3169790619b 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -136,6 +136,9 @@ void ksmbd_vfs_query_maximal_access(const struct mnt_idmap *idmap,
 				FILE_WRITE_EA | FILE_WRITE_ATTRIBUTES |
 				FILE_DELETE_CHILD);
 
+	if (IS_APPEND(d_inode(dentry)) && !S_ISDIR(d_inode(dentry)->i_mode))
+		*daccess &= ~(FILE_WRITE_DATA_LE | FILE_APPEND_DATA_LE);
+
 	if (!inode_permission(idmap, d_inode(dentry), MAY_OPEN | MAY_READ))
 		*daccess |= FILE_READ_DATA_LE | FILE_READ_EA_LE;
 
-- 
2.43.0


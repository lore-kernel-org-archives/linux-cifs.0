Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1873F3BD64A;
	Sat,  4 Jul 2026 23:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783208638; cv=none; b=lIV3Rk5IV3HNvGykBfbgEuLJJRV4k3s7qQP6aDLZBA/A5FUpmdHdCAd7diJ4z/ytu56R0yHLpDhOKQ/e88dm1BzBa0UWE0JsRVFCZqNsJLy8yBKb9F3egw1GfAgpVfcxB1vLqtcLA0jKMdWgu2XFMGzUssFolqYDO9Ax1ShCaSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783208638; c=relaxed/simple;
	bh=6aMGhdrCzhp+oeCl1uQQWQF6RqI5CZAWaOi66BdKx7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7SRUuODuYqIf96J9UI9oKdxpkZqPTT/r8AgoMPI36a+cKrScOW8NHqxtI9qs4ouEEqLF5k+j765JbRQsBYXlGQ0vchr35nZ37TaTjIGfxU8IuZuB81wBwjBCV/YAcfALJfVeI1z+AKg+02YGXJodKBOgUhNJ8gT5dEBPVUQBJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=QigUpeDZ; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=iAHBwDvT; arc=none smtp.client-ip=103.168.172.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="QigUpeDZ";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="iAHBwDvT"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5CC63140007E;
	Sat,  4 Jul 2026 19:43:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Sat, 04 Jul 2026 19:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm2; t=1783208636;
	 x=1783295036; bh=kELunYvz3Y1VkaYUGBj90cnUBhWB/0z68kjFm6DpUW0=; b=
	QigUpeDZGkEXZV9iV91CHGGtGzjWykd4QUfR3ofmy81pDnn6OS/VMoDxwiZeioWH
	1JhATpEwxuxbK90nlUNXgj6msdNBIGDxcX7WK7PFpdydzm/t1MXALAhX0N40Rqow
	9MZ2k5AiI/Qz3oYn89l5DgJSgg9gFb0WDk87ncOau0DfSiiPdPlf7/vFMjwxAaEA
	8ZWfTuRx2Ey77HyHpZUSv6gQC0j79XHdQEynCimFv36ovfQjaPtteAfDSoQdJOjM
	alGBJN98J57DvNjFWOd5so0idvJtIxOnvpPVjSUrPL/PUrpuKbVooICcmWn3S3za
	qMBW4GC1p76WZmtJXcE66A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783208636; x=1783295036; bh=k
	ELunYvz3Y1VkaYUGBj90cnUBhWB/0z68kjFm6DpUW0=; b=iAHBwDvTwuRDDb+Z/
	UseBszDEDdPvn0G0TGE18VIgAv6aACBL90JHX8vvL4Eh8+kcW9Yy55eBF+TnuSNE
	dnuUW2oQiLQe4XYZdmp6eGLLCFXWbZ+YqK3lZQEaTUaATW1CjGtMiXeGbXU+MttG
	KUy3Sa2iTwgYKHxyXRRbSHTAxPUAej+4kiQs0sCJ0vXjLhJrXfYrGWNZ52sJiGGV
	QaWw1tfOjXLS/43eES2jBc9JPRCKiXFvYtlctRUp47pc0ma1e7ddoluplyCFXyT+
	PsDEb5a6mmSIRjCKMu/rZtsPKO4uSPkvScF/9aDO13srbs3OGiwoEOXhU5pu/3hB
	eKnoQ==
X-ME-Sender: <xms:vJpJavoUCqrKzrx39zPrHNfer7IiYvWFB8T2bU9475FYLPtwvVCFeA>
    <xme:vJpJarK0PB3y3LCWI9N5wvx9XuRykzkobhR0uLPU60nK3A3wqC4IUdBAXEjKsvDmG
    IwWq0Bp23x49nLs5T7_QUyjztm7KM8_rC5zXOu0RkEL6wCCFPg>
X-ME-Received: <xmr:vJpJasSYXiJRLd52wt8vafmqUKuZQUc0XiXGCo9F9SACdNl6xoCZ30m2GdKU2ZbPvcc8WJw14-YlNtv9MIE4h1smL1RufK4>
X-ME-Proxy-Cause: dmFkZTEO5dRXSqJvvQqPK9YLP1e4rkpUyEa/sOUM6Ze3bsjUJjRzNN46ZJ9WRBVLaTM3kH
    /Z7pPIYb8/NKmmmfDYw9n7gOS/sRi7KSmQSy85cs+/cZj5XWF80b9P8nxVnVOkDXWOF1yT
    Nb3vz0DXDjv0+iXn+uZzO8ReD4Y0dSvQCN1vHrsUI2v/gvs0ryw5QinGTXBsHvvz00ClI5
    s4PWHtebsOmLZyjDmwYigI1dHptzfEzPfCDFtQ2olJJoIwbYIKvgiIhu8ziWm5nK45Xy2F
    a34bWeZ0I8pwI8L6rwcB3IyC0yE8q6+451+PudVtTMPDb4ndxTS9n2K+hdlhO3/f1XTiR0
    n7mf3KTSt4aNxsf+wdIx3Ri7H5Q9sPGS1rNYX5bbMUY9m2r+oApEYYGzBuXK0E3lgYNfuO
    vQHaGKbXgPAtpAMfDO8hBt0d1Kcoc1zp+7L7dIRfsBZFclb2LnvK9EG8OS2ZNm+yAwOFSi
    8TtMpNyfZzuOc4YDDkxFRwnzuu8yBhh2i1w2VW5Aq/UtnLLde4SQypi/CLZlBNQCPDd8iX
    C07lQZe7jcWbHrMcN/8//Q/61JdzLHkay6NrPCmg/KdKz6fHhtTr8G+76C1gdUAd7ECXbh
    cEqyONqu1zUw2qd08bGkgsOZSTzKuVULOi00osGZ11sX461zYA32s024uXGA
X-ME-Proxy: <xmx:vJpJait9M3DVodJ7JVR_K3rQBZ-tlEA_cJ6lBYDAlKH48mdWtrJgbA>
    <xmx:vJpJalY1Pgw3PTM5RPjOMboy2xCP2LLBlRsM870hNW4ZWgMK-hWcJA>
    <xmx:vJpJagE7IdEdSJiLFwko_ogdJLoYAr2Afr9F3O8VrcB36EUUmfnsWg>
    <xmx:vJpJahxg2HEhwkR08vmOd0iHUggZsrI3PLDEuEoKxbRgfGjEdJVCMQ>
    <xmx:vJpJaghVhN0g2H6EsczPJxCW1JC_aPr59WmFjcb6b-XHMZEq1tY7Y0my>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 4 Jul 2026 19:43:54 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Steve French <sfrench@samba.org>,
	Steve French <smfrench@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/2] smb/client: use d_time to store a timestamp in dentry, not d_fsdata
Date: Sun,  5 Jul 2026 09:31:41 +1000
Message-ID: <20260704234339.377234-2-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260704234339.377234-1-neilb@ownmail.net>
References: <20260704234339.377234-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: NeilBrown <neil@brown.name>

smb/client uses d_fsdata is exactly the way that d_time is intended to
be used.  It previous used d_time but this was changed in
  Commit: a00be0e31f8d ("cifs: don't use ->d_time")
without any reason being given.

This patch effectively reverts that patch (though it doesn't remove the
helpers) so that d_fsdata can be used for something more generic.

As ->d_time is NOT initialised by d_alloc() (unlike ->d_fsdata), it is
important to initialise it in atomic_open (all dentries go through
either ->lookup or ->atomic_open before being hashed, and both of these
now initialise ->d_time).

Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/smb/client/cifsfs.h | 4 ++--
 fs/smb/client/dir.c    | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 901e1340c986..e489aaf206b2 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -34,12 +34,12 @@ cifs_uniqueid_to_ino_t(u64 fileid)
 
 static inline void cifs_set_time(struct dentry *dentry, unsigned long time)
 {
-	dentry->d_fsdata = (void *) time;
+	dentry->d_time = time;
 }
 
 static inline unsigned long cifs_get_time(struct dentry *dentry)
 {
-	return (unsigned long) dentry->d_fsdata;
+	return dentry->d_time;
 }
 
 extern struct file_system_type cifs_fs_type, smb3_fs_type;
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 88a4a1787ff0..bd9684b61c2b 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -598,6 +598,7 @@ int cifs_atomic_open(struct inode *dir, struct dentry *direntry,
 	} else {
 		d_instantiate(direntry, inode);
 	}
+	cifs_set_time(direntry, jiffies);
 
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		file->f_mode |= FMODE_CREATED;
-- 
2.50.0.107.gf914562f5916.dirty


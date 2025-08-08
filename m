Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DECF283C9F
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754666437; cv=none; b=TfvSCu52owxxqjkv9cSQOq6OiQTncGDVyBIHYAF3SGK6MCcqIFA5Mt2gY5X1JH/fOcD5rsTQl5ULUS2orEvM8MG/3W7ftzAQQ8brKTjrXrKukq00Dg+ezR3hTB04MUpaCsNaykHoQHEaslwtoZMB64xvQR3mJl0OyLZVkIKO95Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754666437; c=relaxed/simple;
	bh=jNC10H8jHnXfOHCAXgETZS3+qwwP+M3tWwewUCwyB7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PPSsKCOzILB0Hvx4/mTNkyPI+GAwVwsQ3ulkch7IELQ1z569BQH06tdz0eUUhgFYiCnmdfdZ88undRIdS/ayZbi/SUWLce0tQdcu2RGsMetz0vyzatfgsUNHF8YMkofTZYufrvgCP3EuQWod2L2yYuAv61MeINvFsFCkQqt4m4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=V3/tCg4y; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="V3/tCg4y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=LkS1ZWLc+1GeU5M3+sRZkHT+aC/G2mfitmhgkHS4qRM=; b=V3/tCg4yJtA4oZEtvud0GmAbNb
	kKc3iYw2cnOTeWkZ5t5h3ibbB1+j70rw10AZUm4HluoUfjNqNMZeyLF5iA8bpybc0lkrsauv/ntKz
	r1GJR0DdpUgqRNh7SFq/kPy/NdhyDNe7wyzEXmEa6Eqz/s7Bee3UTYvYJKHbq86DT86mF9+r1sex5
	DVdV+dy1Pa0+VBdPCqBrhqPccz7bbGKX8iojFT9sNXHPVo0vOI7ewkil1Y/1bxfJSP3+Dcqa3XYx4
	R1lAOCbAzt4ns1ffO6IkFKBIVVRjMUTg1fjNoF+IrAgKLVzRoRVmxfz7Ywj01C5/s3T7uyrx1Qjmh
	sUPzighQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1ukOtO-00000000FaP-2eBr;
	Fri, 08 Aug 2025 12:20:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Jay Shin <jaeshin@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/2] smb: client: fix race with concurrent opens in unlink(2)
Date: Fri,  8 Aug 2025 12:20:17 -0300
Message-ID: <20250808152018.527103-1-pc@manguebit.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

According to some logs reported by customers, CIFS client might end up
reporting unlinked files as existing in stat(2) due to concurrent
opens racing with unlink(2).

Besides sending the removal request to the server, the unlink process
could involve closing any deferred close as well as marking all
existing open handles as deleted to prevent them from deferring
closes, which increases the race window for potential concurrent
opens.

Fix this by unhashing the dentry in cifs_unlink() to prevent any
subsequent opens.  Any open attempts, while we're still unlinking,
will block on parent's i_rwsem.

Reported-by: Jay Shin <jaeshin@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/inode.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 75be4b46bc6f..cf9060f0fc08 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1943,15 +1943,24 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct tcon_link *tlink;
 	struct cifs_tcon *tcon;
-	struct TCP_Server_Info *server;
-	struct iattr *attrs = NULL;
 	__u32 dosattr = 0, origattr = 0;
+	struct TCP_Server_Info *server;
+	struct iattr *attrs = NULL;
+	bool rehash = false;
 
 	cifs_dbg(FYI, "cifs_unlink, dir=0x%p, dentry=0x%p\n", dir, dentry);
 
 	if (unlikely(cifs_forced_shutdown(cifs_sb)))
 		return -EIO;
 
+	/* Unhash dentry in advance to prevent any concurrent opens */
+	spin_lock(&dentry->d_lock);
+	if (!d_unhashed(dentry)) {
+		__d_drop(dentry);
+		rehash = true;
+	}
+	spin_unlock(&dentry->d_lock);
+
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
@@ -2003,7 +2012,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 			cifs_drop_nlink(inode);
 		}
 	} else if (rc == -ENOENT) {
-		d_drop(dentry);
+		if (simple_positive(dentry))
+			d_delete(dentry);
 	} else if (rc == -EBUSY) {
 		if (server->ops->rename_pending_delete) {
 			rc = server->ops->rename_pending_delete(full_path,
@@ -2056,6 +2066,8 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	kfree(attrs);
 	free_xid(xid);
 	cifs_put_tlink(tlink);
+	if (rehash)
+		d_rehash(dentry);
 	return rc;
 }
 
-- 
2.50.1


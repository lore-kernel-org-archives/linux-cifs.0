Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874662;
	b=XFP+aGRN30K08HorM0tG9NqeLoMwP4ztkSAaeTPC8NZMmHcBfXn4Ddh6eh02aa27p89m
	 /jH3ozcRGkNvg61BsIjnBadN7xvo/Vj8XvcOOz2KlZXvcp6Zojz7xUCWNF0n8UHHqvPLV
	 tuSC/QxU3d8aul4QjCzi7dviUt0Jrs5JCa1sDyq4FUog6D50DhuMmGNIujYTFfOXsQpWL
	 IZz/swIgHjE0bRBF1gEzqNM2Me2RPzJxUaWMcu/nCDa6J0V17ha7MgYeuwtkZMiCERguU
	 V+DI/gVrny6znvEmHR/xfbB91F/6Z6BfIBxOhz4iWe62Y4cP0v2siJC405CR8VlUj0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874662;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zgWfq2GAKVFYRnbXQJhzTkKnKyBJBEAwL8blc5h7O/Q=;
	b=VkuRYJUhrPB3eIpfY87L97Z2oAaFncOovT5ILPJbUmw/3BJFs66RymjUnqvVO3iVd5Oc
	 C/mnPTs7tGeb9RgY+nb+BZfRCu4xDBgss87Y0kbaC6vQ4Y0mBOMhh9TTOTF8IqLZo/iKN
	 qasXd5nx8+SXXRNVJRsSyxWQkDASn4vWe0Toq4RhPX/PRn8qYmcbD/3mH79JVbZldBQRx
	 74Jfx3IdFSKX9oaILjBNXWmVYi8zWbLtij8ULriQKQ299zRyHkUyws9qB7NfcenbOnnY6
	 OdKlQBchclsXv52PKTn74qxRsvIFLTU4f4MvJUVctterCLh803sWQsTZR6mQ2txBRkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nm28woXf;
	arc=none smtp.remote-ip=209.85.216.54
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED47B606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 00:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED47B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nm28woXf
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso4032918a91.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 16:17:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794874657; x=1795479457; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zgWfq2GAKVFYRnbXQJhzTkKnKyBJBEAwL8blc5h7O/Q=;
        b=Nm28woXfxOXeWkP5NYI99nnzo7HPpdJBy3Hs3DbMuf6fhXKY2d0loq8FZnHmo0dUqb
         w7KiVFdWlZHQIu4jwrCQsJmy6zd6zAiKPbXwwhthK3I+kMZHRqUZDunRaW+2NRmbEKEa
         mBF1hHNwZzzzRBXpDwhxtzZm/mKOAUkltFmfFsoqMFW+uwgRBE475+8rpY+8/goNvluq
         CQdVN/gEZXCF3teuKAfD46fqZivfvHTB4v+LDtu0F1UJNIrzRs+SPsxd1f1nLp4wxwB+
         KRiLylU8jMEp0qiisE56YeCAjSbJhMgpEADDxwbIh7nGYZMGExWkJDa+IkIJ2HVDA2Ao
         g2RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794874657; x=1795479457;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zgWfq2GAKVFYRnbXQJhzTkKnKyBJBEAwL8blc5h7O/Q=;
        b=0BwAiQ+qkISvpQBwDNEEgkOR3ndXL4NF2pI3ScShUXv6scWgut1Kgvtv7Dl9oSGKf3
         Y8p+AeClVX2jt/KqUWcHVPHk9mIXQN6dQQxse/XUuluR9woSlqWUrH5u/UyOW7jNg9Tu
         W9FEF9uQ6jUPsJMJ9ISGwCTNjnYMfpZdi3ZQYdQJDQ4bNPT1e+d+Blrn3dyFydVF+Naf
         GSXbZtv+5r+NksXIkesR6lJKnk3LjtKbrZxOOu8YZwGia8M0uDbLxgvbKswcJshNnsSw
         dG7ev9+4kMrDDPYnAIwkdkW4ypxF9lwrsikAgIoU0jxK8O+yX5Y9ymz1YsVnwlOFbMCx
         IM7Q==
X-Forwarded-Encrypted: i=1; AL+hErF2K4AQWKSMb+PpjTIrCV0x5roBFm69wun+oqXIbe1/7ymzNdySdKU7OZHeMc56O1OJLRjDo0dQ13nC@vger.kernel.org
X-Gm-Message-State: APuU4Z/gI/HGX+V7DmPG70A7v+ls0HY96mPAj452odLpsqkJ7IHlDFp1
	d7a2vnH39wtDn2QRZBX2lKUTk/wkMKrXHl1WR54xOibfzEEcGME/W4e8
X-Gm-Gg: AZFdTZdgyhHrzbQRW6Zcaz59zxCFz8ysDyqDS/cb6wFlxlcZwFiGKz6QgI/fTawx/yz
	7ojWe2CG7yBHt2+mtilFNrEzyj0AAAMgF0L+Oqd9MNdjHehbJXPkwyVKlhyCYQ2nSq+SRKz3Ymy
	O6PacW1Grg2vH1OOJL2DbxrTLPvKlcyqk2iRvCR/hhRDNkT7I82ioI4Yue3IXkAmfnIEaG++bj0
	9Reo/hL0nozaTSrzYVd+nua6wkXYD46TsWKw4njVX9HNGQztaEBD7RuNKeQfK9zwlDAQ1vo25oi
	ncE92Vu18GpaGUPZx+jpxX9WwtWzjZtcBzWz8/2g0/XHT5UtDSpu6WnyrgAHvVVATbmtLW1SthF
	GXKfQ4CL6XBwo70csnjh/tPdPH8MTBnM1Syu7ovKlVyQEkWs7XKcYwRKTux42olhCs9Obh8ivwG
	1FuSzAEMFeb3NDGhKP9R1UKQ0AGWr9S2lSOOQRrYMACT2nHKp5kTNF++6N72QU1DnbLscxPpyRB
	GtODN8IJHG5eFk6q+YJProEIqFGCPdY/7unb/961addbLVPzcyiIvP+9QJwglUyAAI6sYps2pRR
	nskzBUFT7r6mi+imXgUPzmlUTfsixDkuQh7eqspALEtmohnRYCKNpig7eq0SFJuNaoZ1o5g4Llw
	eatJbiFEThSGhSvy2O2Hw7LUqUVurp0JsUPgiuGg/m+AK5nXJblpG1DDxyIX4mHTFqYl1W0Pq5H
	Yg6iBxCohueEOU9UwhHFFSlNxDtKHuHUooCF5c4Yr3
X-Received: by 2002:a17:90b:3f46:b0:3b0:78c8:d56e with SMTP id 98e67ed59e1d1-3b1b0b8f0acmr12280481a91.27.1794874657124;
        Mon, 16 Nov 2026 16:17:37 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe77179sm1194081a91.11.2026.11.16.16.17.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 16:17:36 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Adam Kim <adamkim@microsoft.com>,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] smb: client: fix busy dentry and inode on unmount from late oplock break
Date: Tue, 17 Nov 2026 00:17:32 +0000
Message-ID: <20261117001733.192399-2-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117001733.192399-1-sidchintamaneni@gmail.com>
References: <20261117001733.192399-1-sidchintamaneni@gmail.com>
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

During unmount, cifs_kill_sb() flushes cifsoplockd_wq and deferredclose_wq
before waiting on cifs_sb->outstanding_rreq for in-flight netfs I/O
requests to finish their cleanup_work in cifs_free_request().

While cifs_kill_sb() is waiting on outstanding_rreq, any cifsFileInfo
referenced by an in-flight request (req->cfile) still has cfile->count >= 1
and remains on tcon->openFileList. If the SMB server sends a lease or
oplock break for that file during this window, the demultiplex thread
(cifsd) finds cfile on tcon->openFileList and calls
cifs_queue_oplock_break(cfile), which takes a new reference on cfile and
queues cfile->oplock_break onto cifsoplockd_wq after cifsoplockd_wq was
already flushed:

  Thread 1 (umount)      Thread 2 (cifsd)       Thread 3 (workers)
  -----------------      ----------------       ------------------
  cifs_kill_sb()
  flush(cifsoplockd_wq)
  flush(deferredclose_wq)
  wait(outstanding_rreq)
    [blocks: rreq == 1]
                         SMB2 Lease Break
                         finds cfile on list
                         cifs_queue_oplock_break()
                           queue(cifsoplockd_wq)
                           cifsFileInfo_get(cfile)
                           [cfile->count: 1 -> 2]
                                                cifs_oplock_break()
                                                  ihold(inode)
                                                cifs_free_request()
                                                  cifsFileInfo_put()
                                                  [cfile->count: 2 -> 1]
                                                  dec(outstanding_rreq)
    [wakes: rreq == 0]
  flush(serverclose_wq)
  flush(fileinfo_put_wq)
  kill_anon_super(sb)
    -> generic_shutdown_super()
       BUG: Dentry still in use (1)
       VFS: Busy inodes after unmount!

Furthermore, cifs_oplock_break() itself holds the inode via ihold() after
dropping cfile and may initiate writeback via filemap_fdatawrite(),
spawning new netfs I/O requests.

Fix this by counting queued oplock breaks in cifs_sb->outstanding_rreq
from when cifs_queue_oplock_break() queues the work until
cifs_oplock_break() finishes, so wait_var_event() in cifs_kill_sb() waits
for both in-flight I/O requests and any late oplock breaks to complete.

Fixes: 340cea84f691 ("cifs: open files should not hold ref on superblock")
Reported-by: Adam Kim <adamkim@microsoft.com>
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---
 fs/smb/client/cifsfs.c | 10 +++++-----
 fs/smb/client/file.c   |  2 ++
 fs/smb/client/misc.c   |  6 +++++-
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 8cff7857b4509..9faba158f8b6a 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -418,11 +418,11 @@ static void cifs_kill_sb(struct super_block *sb)
 		flush_workqueue(deferredclose_wq);
 
 		/*
-		 * Wait for all in-flight netfs I/O requests to finish their
-		 * cleanup_work so that any cifsFileInfo final puts they queue
-		 * to fileinfo_put_wq/serverclose_wq have been queued, then
-		 * drain the workqueue so the cfile dentry refs are dropped to
-		 * avoid the busy dentry warning.
+		 * Wait for all in-flight netfs I/O requests and oplock breaks
+		 * to finish so that any cifsFileInfo final puts they queue to
+		 * fileinfo_put_wq/serverclose_wq have been queued, then drain
+		 * the workqueue so the cfile dentry refs are dropped to avoid
+		 * the busy dentry warning.
 		 */
 		wait_var_event(&cifs_sb->outstanding_rreq,
 			       !atomic_read(&cifs_sb->outstanding_rreq));
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f51653cb6432a..146ff2adfa244 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4023,6 +4023,8 @@ void cifs_oplock_break(struct work_struct *work)
 out:
 	cifs_done_oplock_break(cinode);
 	iput(inode);
+	if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+		wake_up_var(&cifs_sb->outstanding_rreq);
 }
 
 #ifdef CONFIG_SWAP
diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index 4d0df73d15d7a..72a986bfaefc4 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -371,6 +371,8 @@ void cifs_put_writer(struct cifsInodeInfo *cinode)
  */
 void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(d_inode(cfile->dentry)->i_sb);
+
 	/*
 	 * Bump the handle refcount now while we hold the
 	 * open_file_lock to enforce the validity of it for the oplock
@@ -379,8 +381,10 @@ void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 	 *
 	 * Only take a reference if the work is actually queued.
 	 */
-	if (queue_work(cifsoplockd_wq, &cfile->oplock_break))
+	if (queue_work(cifsoplockd_wq, &cfile->oplock_break)) {
 		cifsFileInfo_get(cfile);
+		atomic_inc(&cifs_sb->outstanding_rreq);
+	}
 }
 
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
-- 
2.43.0


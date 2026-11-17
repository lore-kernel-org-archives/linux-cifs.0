Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874664;
	b=4vrBUAfgq2rLo2nYQVUDbyzHCgBkS9b/h7XrNCOr0HaQ7prlcv1JcSh+lUqvYqnxvP/l
	 udrJeSyAhMpQhAbtctPri1eTiecBA1o6keGXLfeCmeA0d7WziYpl9QOLXwCaviqX/AJlA
	 RLZmnq0OlKjpHHpUr7YfhuZq3cgpN5zudGVtPuHs5P/pYMAImnK4fXtwLeVMDv1I4KkB/
	 AScDbby/2UqA2HbI+Oyz7nPtZDRIeVwDhIrR/aLsmK/LuEbiXYCO6K8b/38qKKVNNyAHN
	 q+s60AffXJrO6Lv+TWzBVKzevaQ/yfSV3PYI5fYvg4sTOwJyY3NO4exxk0LX7HZqqSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8uYmVLMlUVU+cxd5o4cJaxLmzYdA/McqGttb5PW87pg=;
	b=Njk3MI1Ar0ij3jKV3LcebSD0XLQfJ4v3pJQ/wJBhUsL+FtqkNNpO+I5DDiA+56JUNVeC
	 s0eCMv2VyZq12u5cCY7s5ASlxJ4M5a2/9T5ycY08lUz4T13JDsJv3IksghqmnCfEpSWa/
	 +rk7NhSaNTla86WvkUEbpLlhzoDB3JxGkJAnlPGk5dLi9asS3kyEfPkbo+F5c9A1sPZJ/
	 eThMJtI1n+NUIznUtwIzpLNkBSdYjtYvxY53raQRfiM4FD+wfQ/Ro6YuccKmrQusFstOj
	 b2R0+oDGEWdCW5jdC5lRuYsRf/WUwn8xmRhmoIYweqnDNAIunkmwRZ451r6nMHKkzhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hedHCCss;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A458B606A8AC
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 00:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A458B606A8AC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hedHCCss
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cdb75699c7cso1639610a12.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 16:17:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794874658; x=1795479458; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uYmVLMlUVU+cxd5o4cJaxLmzYdA/McqGttb5PW87pg=;
        b=hedHCCssyR1sZA5kE1raSkzS+NrwJlryckT3Pigc2Xd5W6k/AifZkT1N3a0WslBvS+
         eXuq0BExtzuNzVEfDs9GK5So+KUWSs0DeDuzMk+5exFiS2L95kLtOo2uXyo15O2igJVs
         OwyyJRXD0qvXxK4DgQeOg7bOU4c7kd8sbz17Qmidk7APckKgguTH195cTYmrV9JK4FnU
         m0Xb3xRXeWRKDem2fHbQz2XsuJNqcf2XneYP32KW/OBxKd+y8XFc9z/jLfIdIEdDroa+
         mkeAG68eqWbDHzH4RjcjKgnGTqplbR0nvmly6gSJzasleHdN7Rq6GseoyZKlCZ2e3OCQ
         FRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794874658; x=1795479458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uYmVLMlUVU+cxd5o4cJaxLmzYdA/McqGttb5PW87pg=;
        b=WoTLiC//BT6I4SyIY2dbHMB3UHudzlFoZYi5xR97TrvymTvB00VoyUxRCoKtI6otcK
         axb+MkXWqJXBKLkBwffsbVyAR1OwbntxzhRaPQgiphpLRvoES92MXCESNYMPc5oid3MB
         t8QsWoVyRzQ85TnDeOHlMkkZXtDmOx0SxmGSgwzlU99BHXkTkJml2ltKQRIRNtQ2G4QQ
         drSGjuu9GQA75K+TmZsuQgi1OH/K1jyypQjZJf5AftJnliFHoeKdckhzUjrTV9GGfBVA
         NTvf0c/YjMM1Qr0zVf0N8WPuu3F3rDKEXgxukseGldpQsku38wCA4uV1cjuFPoEG5EiK
         gNTA==
X-Forwarded-Encrypted: i=1; AL+hErH9OxQyqWDWEgUU+vJNJIJfyTb+1AN4BfQEgCEqSqokiC0h3S4HYDADe32o11/1Dr3LmqzUkXreXHoH@vger.kernel.org
X-Gm-Message-State: APuU4Z/U2XvD8OoQwkDqQWaOEPCsIxqZfDHU+V6k4Q26lp7vhCu2dspj
	q7bwOrGQui8U3YF49/ii7/YyxO2UnpdpKHXCeQS1nORoCesu9slvW7OK
X-Gm-Gg: AZFdTZdJ84vjd5c1hkbztA8Ogei7yCZAAscu0l6rZNCGiYywGxbiLNNGAwAfptRG8fz
	GpH4eq8D2oxDCVSXArh1bNt/qdb/FsAwzIQZXcdW3ms5PlIIpfHKqC/tabv+wGRbCEhXAW8dKg1
	epQ+UQcjNLyS7aOtjM3uJ4BI5atgD06UTM1cLSgxJeGqlwVkWyh6/wTlnCNppKkyLNFsqAk8V85
	XrmHZHoEnu/wXFF+6z4kawhbEXbKYk2WLi2o+Cv9VHs2KYPlubd9gBG9DsB+m8WND3T3X8vV3Lc
	/EqSJJ9WqZ49mLaoZ3UKtDKV+Qn6yUkZ70gamADjZWye/3nux35WsCVxqMielCtlbBeexVUpAJG
	74FbN6e5xZCI5feGqVfEkCbNMPMb42uACUj1s7UJZpO+N/qZgkzId8tLJyuDhxKQlcGTCQ+8Oqi
	0N0X0Qo2XjgGoAJUNkuaOYr4Ogvr884UJ6Pyw+O+CA2Y3K1+HUuS8Rp3Px67XMCLwoT1IvAVJe6
	WZwY3ZxfEungPO9o0OtPS4nN5U2BMZGo1uOxwX+tUgggBoY3wfdsv5goQATUnmylU+Dx2de7ZZK
	l2wivC+CInkiVFePM86CyGrm0Y/iu+WrOaxYCJbFyn1CIndYm2+U8FBchDds8Yukmc38tM9zdSH
	wl0nBMeAr8dAEBCh7lPOJKJRA7aF1Svt7IX9h7g6/DRO1OF/dWanlh7fmPqxyvB0VmzLJzYr/5a
	zV9qA4OU6RpTzpDL7mv9jiF/wGTz1Cd3Y0bTPo3851eQHdc3uLOh8hMUsGxtyQqQ==
X-Received: by 2002:a17:90b:4c0e:b0:3ac:8741:e2e8 with SMTP id 98e67ed59e1d1-3b1b07ef0bemr13037975a91.8.1794874657803;
        Mon, 16 Nov 2026 16:17:37 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe77179sm1194081a91.11.2026.11.16.16.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 16:17:37 -0800 (PST)
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
Subject: [PATCH v1 2/2] smb: client: fix busy dentry on unmount from persistent handle reopen
Date: Tue, 17 Nov 2026 00:17:33 +0000
Message-ID: <20261117001733.192399-3-sidchintamaneni@gmail.com>
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

During unmount, cifs_kill_sb() waits on cifs_sb->outstanding_rreq for
in-flight netfs I/O requests and oplock breaks to complete before
flushing serverclose_wq and fileinfo_put_wq.

While cifs_kill_sb() is waiting on outstanding_rreq, any cifsFileInfo
referenced by an in-flight request (req->cfile) remains on
tcon->openFileList. On a mount using persistent handles, if a reconnect
runs on cifsiod_wq during this window, smb2_reconnect_server() calls
cifs_reopen_persistent_handles(), which walks tcon->openFileList and
takes a new reference on open_file via cifsFileInfo_get() to reopen the
handle over the network:

  Thread 1 (umount)      Thread 2 (cifsiod_wq)    Thread 3 (workers)
  -----------------      ---------------------    ------------------
  cifs_kill_sb()
  wait(outstanding_rreq)
    [blocks: rreq == 1]
                         smb2_reconnect_server()
                         cifs_reopen_persistent_handles()
                           finds open_file on list
                           cifsFileInfo_get(open_file)
                           [cfile->count: 1 -> 2]
                           cifs_reopen_file()
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

Fix this by incrementing cifs_sb->outstanding_rreq when
cifs_reopen_persistent_handles() takes a reference on open_file and
decrementing it after cifsFileInfo_put(open_file), so wait_var_event()
in cifs_kill_sb() waits for any in-progress persistent handle reopen to
finish and queue its final put before draining fileinfo_put_wq.

Fixes: 340cea84f691 ("cifs: open files should not hold ref on superblock")
Reported-by: Adam Kim <adamkim@microsoft.com>
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
---
 fs/smb/client/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 146ff2adfa244..e0b56c6c2c743 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2044,6 +2044,7 @@ bool
 cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 {
 	struct cifsFileInfo *open_file, *tmp;
+	struct cifs_sb_info *cifs_sb;
 	LIST_HEAD(tmp_list);
 	bool retry = false;
 	int rc;
@@ -2060,12 +2061,16 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 	list_for_each_entry(open_file, &tcon->openFileList, tlist) {
 		if (!open_file->invalidHandle)
 			continue;
+		cifs_sb = CIFS_SB(d_inode(open_file->dentry)->i_sb);
 		cifsFileInfo_get(open_file);
+		atomic_inc(&cifs_sb->outstanding_rreq);
 		list_add_tail(&open_file->rlist, &tmp_list);
 	}
 	spin_unlock(&tcon->open_file_lock);
 
 	list_for_each_entry_safe(open_file, tmp, &tmp_list, rlist) {
+		cifs_sb = CIFS_SB(d_inode(open_file->dentry)->i_sb);
+
 		/* do not flush */
 		rc = cifs_reopen_file(open_file, false,
 				      CIFS_REOPEN_BOUND | CIFS_REOPEN_NOWAIT);
@@ -2075,6 +2080,8 @@ cifs_reopen_persistent_handles(struct cifs_tcon *tcon)
 		}
 		list_del_init(&open_file->rlist);
 		cifsFileInfo_put(open_file);
+		if (atomic_dec_and_test(&cifs_sb->outstanding_rreq))
+			wake_up_var(&cifs_sb->outstanding_rreq);
 	}
 	return retry;
 }
-- 
2.43.0


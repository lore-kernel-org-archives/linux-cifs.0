Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13B82D2388
	for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 11:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749814777; cv=none; b=EZ1/7OPeCg9Q1CODxrdx8ioBAgM802lU9uFbu8BitHvt0+q9Nl00XN38Bux/Xz/SyqaFestpsgSX03rHypa30hI1fB0IiHTQ7Im4inPrnAJQYHhU19sc+znhEI1yNJ3FwZJSIzQ1vaLJdraIa1xiEROchnwx8Gknjjcm3c6IjaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749814777; c=relaxed/simple;
	bh=JdwLJlMuQS3XV10Hm7y2eqJnfHpe/n/SCULTJqJsgcE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=l1AtzvtfC6aIgnDBgb5bIEpMvn39VljuHlIYkX4AbfuduK8udMboImaHV0ozYkTsmakoUXDDjNBjeqXP6k2m3LhoncJaOOS/mTJejjLEf03qijYdoNpZVWsFRaU0xUVSQwfisxivJlAhnMhW3KGV9gRpapyouh7Pq20gz2kVsN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-234bfe37cccso26081035ad.0
        for <linux-cifs@vger.kernel.org>; Fri, 13 Jun 2025 04:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749814774; x=1750419574;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F0iWQbh/jziWtW2vr3423XoNipoPk2sSBuO5RTzFpRE=;
        b=skTBYvFjmI85AXSwZMY7gKZhECuoOUd+vegP6Csxbo8yh/PpBmYHvtqOcXL+9TWAh5
         opp3xKl7dWZIVqScLnKIjMFY2i7OzdMCdEw9/5L4uU9m3B304LBXI+WU/Z3ok9BJAa6y
         AkZI5oQUkhZiXt8O3ZuMHWmuyc/Rg/yjqxMW61FOuS9CZNgMZfnfvvi5niqCjVpBeNU7
         asjxPgEIria7kji7AyDgAZtssmU6mZSQkh3JSMP1XvSihNm9pYCZZMAGW19gXcVbaFRb
         tOXyHRaXP9yTBfYGkTzae/wvS7d93X+hTqyjsyQTRQShPApmmqlRiVAdZ91pR5vPsyQP
         0y6A==
X-Gm-Message-State: AOJu0Yx+geMLs8rVMk+IsgK6f3cfMjtcZeCGvXcWu7CE00lNZiY2ULST
	EkQ4C5/oGyqF4v7hhXpRiPNGQh74SFgjLq27zZa/RSVWJ0wOK4gyoShyiLitm2Io
X-Gm-Gg: ASbGnctDMS2k3Jt0padkyPo6DyG1/6XD3c80OCd4XUNBcb55D7PjE7hSpG35Y2RoDZa
	V/W2rA+gCnQmYcKA0mEtrkK7fkvsHfMm2ntdxPcTW8351swJzdI1YL7VC4gtWimxPs4a3jZeNJI
	9DmWNW/pqEPSGkomMf9kc1jjxNJDXfj2KN44OmyTl7k7udgz5m/8FycDFX3bYb0wcApwNtOidWN
	Jjl3jkv1OtW+H7/VF3o21wYUFg4QAUTDQt1PU6qxNrTrIC/HFl6tBYXXwFP2ZpL3gYwZk2GmeJU
	Bb7mssxZco4cB/zzNXNSxf/nWOtzpzkxNOaU52gHKDeA57lWV6kdz50SrKEeooV9P2s7dylFptQ
	9
X-Google-Smtp-Source: AGHT+IGIJnxABIGyMM4VnmJNTXUQfOBOt+VCz9xnRjOQ2oVvTZiu82d7Jcc29GxKtZIwLmh8NSPdMA==
X-Received: by 2002:a17:902:ce0d:b0:235:225d:3087 with SMTP id d9443c01a7336-2365da06f7dmr38839085ad.30.1749814774370;
        Fri, 13 Jun 2025 04:39:34 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe169205dsm1458085a12.74.2025.06.13.04.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jun 2025 04:39:33 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	Marios Makassikis <mmakassikis@freebox.fr>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH] ksmbd: handle set/get info file for streamed file
Date: Fri, 13 Jun 2025 20:39:04 +0900
Message-Id: <20250613113905.7452-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bug only appears when:
 - windows 11 copies a file that has an alternate data stream
 - streams_xattr is enabled on the share configuration.

Microsoft Edge adds a ZoneIdentifier data stream containing the URL
for files it downloads.

Another way to create a test file:
 - open cmd.exe
 - echo "hello from default data stream" > hello.txt
 - echo "hello again from ads" > hello.txt:ads.txt

If you open the file using notepad, we'll see the first message.
If you run "notepad hello.txt:ads.txt" in cmd.exe, we should see
the second message.

dir /s /r should least all streams for the file.

The truncation happens because the windows 11 client sends
a SetInfo/EndOfFile message on the ADS, but it is instead applied
on the main file, because we don't check fp->stream.

When receiving set/get info file for a stream file, Change to process
requests using stream position and size.
Truncate is unnecessary for stream files, so we skip
set_file_allocation_info and set_end_of_file_info operations.

Reported-by: Marios Makassikis <mmakassikis@freebox.fr>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/smb2pdu.c   | 63 +++++++++++++++++++++++++++++++--------
 fs/smb/server/vfs.c       |  5 ++--
 fs/smb/server/vfs_cache.h |  1 +
 3 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6645d8fd772e..fafa86273f12 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4872,8 +4872,13 @@ static int get_file_standard_info(struct smb2_query_info_rsp *rsp,
 	sinfo = (struct smb2_file_standard_info *)rsp->Buffer;
 	delete_pending = ksmbd_inode_pending_delete(fp);
 
-	sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
-	sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	if (ksmbd_stream_fd(fp) == false) {
+		sinfo->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		sinfo->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	} else {
+		sinfo->AllocationSize = cpu_to_le64(fp->stream.size);
+		sinfo->EndOfFile = cpu_to_le64(fp->stream.size);
+	}
 	sinfo->NumberOfLinks = cpu_to_le32(get_nlink(&stat) - delete_pending);
 	sinfo->DeletePending = delete_pending;
 	sinfo->Directory = S_ISDIR(stat.mode) ? 1 : 0;
@@ -4936,9 +4941,14 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
 	file_info->Pad1 = 0;
-	file_info->AllocationSize =
-		cpu_to_le64(stat.blocks << 9);
-	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	if (ksmbd_stream_fd(fp) == false) {
+		file_info->AllocationSize =
+			cpu_to_le64(stat.blocks << 9);
+		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	} else {
+		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
+		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
+	}
 	file_info->NumberOfLinks =
 			cpu_to_le32(get_nlink(&stat) - delete_pending);
 	file_info->DeletePending = delete_pending;
@@ -4947,7 +4957,10 @@ static int get_file_all_info(struct ksmbd_work *work,
 	file_info->IndexNumber = cpu_to_le64(stat.ino);
 	file_info->EASize = 0;
 	file_info->AccessFlags = fp->daccess;
-	file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
+	if (ksmbd_stream_fd(fp) == false)
+		file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
+	else
+		file_info->CurrentByteOffset = cpu_to_le64(fp->stream.pos);
 	file_info->Mode = fp->coption;
 	file_info->AlignmentRequirement = 0;
 	conv_len = smbConvertToUTF16((__le16 *)file_info->FileName, filename,
@@ -5135,8 +5148,13 @@ static int get_file_network_open_info(struct smb2_query_info_rsp *rsp,
 	time = ksmbd_UnixTimeToNT(stat.ctime);
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->Attributes = fp->f_ci->m_fattr;
-	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
-	file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	if (ksmbd_stream_fd(fp) == false) {
+		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+		file_info->EndOfFile = S_ISDIR(stat.mode) ? 0 : cpu_to_le64(stat.size);
+	} else {
+		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
+		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
+	}
 	file_info->Reserved = cpu_to_le32(0);
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_ntwrk_info));
@@ -5159,7 +5177,11 @@ static void get_file_position_info(struct smb2_query_info_rsp *rsp,
 	struct smb2_file_pos_info *file_info;
 
 	file_info = (struct smb2_file_pos_info *)rsp->Buffer;
-	file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
+	if (ksmbd_stream_fd(fp) == false)
+		file_info->CurrentByteOffset = cpu_to_le64(fp->filp->f_pos);
+	else
+		file_info->CurrentByteOffset = cpu_to_le64(fp->stream.pos);
+
 	rsp->OutputBufferLength =
 		cpu_to_le32(sizeof(struct smb2_file_pos_info));
 }
@@ -5248,8 +5270,13 @@ static int find_file_posix_info(struct smb2_query_info_rsp *rsp,
 	file_info->ChangeTime = cpu_to_le64(time);
 	file_info->DosAttributes = fp->f_ci->m_fattr;
 	file_info->Inode = cpu_to_le64(stat.ino);
-	file_info->EndOfFile = cpu_to_le64(stat.size);
-	file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+	if (ksmbd_stream_fd(fp) == false) {
+		file_info->EndOfFile = cpu_to_le64(stat.size);
+		file_info->AllocationSize = cpu_to_le64(stat.blocks << 9);
+	} else {
+		file_info->EndOfFile = cpu_to_le64(fp->stream.size);
+		file_info->AllocationSize = cpu_to_le64(fp->stream.size);
+	}
 	file_info->HardLinks = cpu_to_le32(stat.nlink);
 	file_info->Mode = cpu_to_le32(stat.mode & 0777);
 	switch (stat.mode & S_IFMT) {
@@ -6191,6 +6218,9 @@ static int set_file_allocation_info(struct ksmbd_work *work,
 	if (!(fp->daccess & FILE_WRITE_DATA_LE))
 		return -EACCES;
 
+	if (ksmbd_stream_fd(fp) == true)
+		return 0;
+
 	rc = vfs_getattr(&fp->filp->f_path, &stat, STATX_BASIC_STATS,
 			 AT_STATX_SYNC_AS_STAT);
 	if (rc)
@@ -6249,7 +6279,8 @@ static int set_end_of_file_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	 * truncate of some filesystem like FAT32 fill zero data in
 	 * truncated range.
 	 */
-	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC) {
+	if (inode->i_sb->s_magic != MSDOS_SUPER_MAGIC &&
+	    ksmbd_stream_fd(fp) == false) {
 		ksmbd_debug(SMB, "truncated to newsize %lld\n", newsize);
 		rc = ksmbd_vfs_truncate(work, fp, newsize);
 		if (rc) {
@@ -6322,7 +6353,13 @@ static int set_file_position_info(struct ksmbd_file *fp,
 		return -EINVAL;
 	}
 
-	fp->filp->f_pos = current_byte_offset;
+	if (ksmbd_stream_fd(fp) == false)
+		fp->filp->f_pos = current_byte_offset;
+	else {
+		if (current_byte_offset > XATTR_SIZE_MAX)
+			current_byte_offset = XATTR_SIZE_MAX;
+		fp->stream.pos = current_byte_offset;
+	}
 	return 0;
 }
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index ba45e809555a..0f3aad12e495 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -293,6 +293,7 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 
 	if (v_len - *pos < count)
 		count = v_len - *pos;
+	fp->stream.pos = v_len;
 
 	memcpy(buf, &stream_buf[*pos], count);
 
@@ -456,8 +457,8 @@ static int ksmbd_vfs_stream_write(struct ksmbd_file *fp, char *buf, loff_t *pos,
 				 true);
 	if (err < 0)
 		goto out;
-
-	fp->filp->f_pos = *pos;
+	else
+		fp->stream.pos = size;
 	err = 0;
 out:
 	kvfree(stream_buf);
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 5bbb179736c2..0708155b5caf 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -44,6 +44,7 @@ struct ksmbd_lock {
 struct stream {
 	char *name;
 	ssize_t size;
+	loff_t pos;
 };
 
 struct ksmbd_inode {
-- 
2.25.1


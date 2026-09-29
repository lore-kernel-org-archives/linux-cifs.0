Received: from mail-wr2-f32.google.com (mail-wr2-f32.google.com [74.125.225.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2774EF13A
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673501; cv=none; b=HokEmP++PKN1ZFGwNcb5lVOtJXBXvG/C+RiV1rh/8GfeH/KWTJIPq0PCpHOzRWSx5iDluSZ34H7jjLg/Da7/9tSkN1xrRx5YZql2vRxCZUDKOfUVNkWeSLvbCd79KfdCKOlOUQ8InCOWxwBDriBKUCcVAcE0kmBPfELBZjw2MKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673501; c=relaxed/simple;
	bh=Gd5DEslAjp0F3HbJsyLFYAPL42//vOVQ1Ghf2T01Jss=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b2thptnTl86bwkMBdLU+1GRTdKd7bwjCePbSv8xcco/ZXcDy71NCk4cPxbSkBBt7sRMv3BKTFWFAvuhHSp2RPATqE7XXnH9qa8AD1umniJ0u/7pNif3ZT2nqNr7xA6VaUdUowaf9SsMM2XPxE54aG/OAN9dPC9hnx1L7GAQfBTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=Ab9oHK2w; arc=none smtp.client-ip=74.125.225.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="Ab9oHK2w"
Received: by mail-wr2-f32.google.com with SMTP id ffacd0b85a97d-482f6350f91so2288414f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673493; x=1791278293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qV4Q28ZD1a1XczdrerQyg+46L7FroccXV02Vmd8dVAM=;
        b=Ab9oHK2wGZuF14P1+tZ9tdR4HiUI50h9/U8HVkfPzKHWpXtEkYNxrsAgDTQKlhNBWV
         tZLpK6nOMk+B8yJwHhSoB2ZzVTwIRoNJFBqs4++Zhijrf3AaG+/HP7uAAyGL1LZXDbb/
         bfZixi0FYlOPFjGQs12mirDLpn/AHDY8bBdq0izCa9pivXuDxX0mftdkb3PXLVXq5PBV
         owdx0sgDVUKj/hgKJYdirxAf/dnO4tEIZNsXNZd0sdRD+P3oTWf6AhWeY/gp0nw/KvZE
         A3D18AxVIsh6bThLmT4xV+sch+vDzBH528II3tngJ1MW96luuep8nkKuOO9sBdFn9okF
         Dq9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673493; x=1791278293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qV4Q28ZD1a1XczdrerQyg+46L7FroccXV02Vmd8dVAM=;
        b=KuGCfrbi9RRMO1X2xeY07at5bGrj3sAHlahzTblznf6WhiFlabgCRdi/umYN4qVLjW
         P1pavfYKb/kN5n4ZRhu0FLWn3gadtZk+lKxtvyWmZgusGaOpsuZ0wuF7Mylg18tq8HDr
         U1JqDY6bp8Y9rqPsaiX1Bzp7iRLTGOHkUqfn7gkEGhL8IhggPkmzSaL+2IOsIAZaysLP
         woQ3mGVM01+fgNGH9FgBTRXngaGxsuan9OGX2T1VrMoU3nKuaLsIyTSiS0YGGjx/3EFC
         TGpxXxuIiY3lShn1bedXYQYvXNs0pD2RGNM8nLDViD5nzEnR1Y/puHQOh58M1R0UBOf4
         S05Q==
X-Forwarded-Encrypted: i=1; AKwUvBwFiNDGTIzdcfxmiQfs0WD6EWinPZnWOVbXT3MGlrvZMiBwf3/R7x4n1xuFTr/HV5r0YkN1fuwcW/Cd@vger.kernel.org
X-Gm-Message-State: AFq9FYIspEZQcIG/12jOGPEh9MfHgtMTw5HdRSzeBvj1947cjTCe4TQk
	1R3gX2femxngZOpC0HMp31vapvnSf89tXQzshrwc067G7FSAu1f8OrVCWpbwFVuStAu3
X-Gm-Gg: AYBFou1fRF2ogGWUipvoaW0thxTtagAge0vHVjdEXWrwy78PeHrkb9yDzTNHHA24xy0
	kdQxCTwAgOGB6agxTy1aGdz8UPHPEHxMil/4/yVZVr6znS65gO1z6/GXcOO8b5CNoOBW7JEO7ve
	PDwV8Y0z/G66/4EUTigqk4tHEn/CMblJ1vxghR4V2eFhalGBzQmituayM350Z8wJD06ncO69nyg
	hvjlaTf5+/dovOM39R8VCxwEc1b9mZdXhKjxDp8ahcwIfcdq9xrJEMTWtQj37TyIUIMYiKdP4r3
	R7CPs42Xj3J9uYYrj6SpHWxG7Q8pO8HnkMzb+tVivDSjdN8JXI+pid/xa77tCS7dqTR/p+qWTcq
	4uE7yfr2kJax4hctKzhY7PMpcfiarefSvzi5SfNXmwzi33+512vUsjf2MaDWaPYAHX4C/znnTJL
	en7gcQUS2dYwm9oJd03xIDV+UNvLYF1w9tgI1bLfSlEJR1lNPB3BTj7/N7TVC7xNfOyeoqa+DFe
	kQDjLRrypMLXpLbbUFhlNebATQj5h6YbesAsQ==
X-Received: by 2002:a05:6000:4a1d:b0:487:1470:52d9 with SMTP id ffacd0b85a97d-4887d9fa527mr21778647f8f.3.1790673492769;
        Tue, 29 Sep 2026 02:18:12 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:11 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] smb: client: fix OOB read of the resume name sent in TRANS2_FIND_NEXT2
Date: Tue, 29 Sep 2026 10:16:32 +0100
Message-Id: <20260929091636.2618227-4-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260929091636.2618227-1-diego@bynar.io>
References: <20260929091636.2618227-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_fill_dirent() reads the fixed part of a directory entry and the
name length it holds, or for SMB_FIND_FILE_UNIX scans the name for its
terminating NUL, without knowing where the response ends.
cifs_save_resume_key() calls it for the entry at the LastNameOffset the
server chose, after every FindNext and after the FindFirst of a search
rewind, and records the name it returns as the resume name of the
search without bounding it; the next CIFSFindNext() copies up to
PATH_MAX - 1 bytes from that name into its request and sends them to
the server. cifs_filldir() bounds
the name against the end of the response since
commit f8cf09a53a0d ("smb: client: bound dirent name against end of
SMB response in cifs_filldir"), but only after cifs_fill_dirent() has
read the entry, and nxt_dir_entry() checks the entries it walks only
against sizeof(FILE_DIRECTORY_INFO), for every level but
SMB_FIND_FILE_INFO_STANDARD, and never sees the first entry of a
response.

Bounding where last_entry starts, as the preceding patch does, does
not bound the read. A last entry that starts within the final bytes of
the response still has its fixed part read past the end of the
received data, and the name length it declares, a __le32 for every
level but SMB_FIND_FILE_INFO_STANDARD and SMB_FIND_FILE_UNIX, is
recorded without being checked against anything. CIFSFindNext()
rejects only a length of PATH_MAX or more, then copies the name, up to
4095 bytes, into its request and sends it, and as the report below
shows that copy can run past the end of the cifs_request allocation
that holds the response. For SMB_FIND_FILE_UNIX the name is in
addition scanned for its terminating NUL over up to PATH_MAX + 1
UTF-16 units, or PATH_MAX bytes, before any check. The FindNext that
carries the name is only sent by the SMB1 dialect, which is not
negotiated by default; reaching it requires an explicit vers=1.0
mount.

With KASAN enabled, a response whose last entry declares a name
longer than the bytes that follow it gives:

 ==================================================================
 BUG: KASAN: slab-out-of-bounds in CIFSFindNext+0x8ca/0x14c0
 Read of size 4080 at addr ffff88807c823f98 by task ls/83

 CPU: 0 UID: 0 PID: 83 Comm: ls Not tainted 7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  kasan_check_range+0x10f/0x1e0
  __asan_memcpy+0x23/0x60
  CIFSFindNext+0x8ca/0x14c0
  cifs_readdir+0xf51/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 83 on cpu 1 at 13.497119s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address belongs to the object at ffff88807c820000
  which belongs to the cache cifs_request of size 16588
 The buggy address is located 16280 bytes inside of
  allocated 16588-byte region [ffff88807c820000, ffff88807c8240cc)
 ==================================================================

The read is the memcpy() that copies the recorded name into the next
request, so those bytes go to the server.

Pass the end of the response to cifs_fill_dirent() and have it reject
an entry whose fixed part does not fit or whose name extends past the
end, before either is used, so that both callers are covered;
cifs_save_resume_key() computes the end the same way cifs_readdir()
does. The name bound compares the bytes left between the name and the
end with the name length rather than adding the length to the name
pointer, since the length is a 32-bit value taken from the entry and
the sum could wrap on 32-bit systems. cifs_fill_dirent() is also used
on the SMB2 readdir path; there smb2_parse_query_directory() has
already checked every entry against the end of the response, so a
valid SMB2 response is not rejected by the new checks. The check
cifs_filldir() applies after the parse is left in place. The NUL scan
for SMB_FIND_FILE_UNIX names is capped by a separate patch.

An entry and its name lie inside the data area of the response, so a
server that points LastNameOffset at the entry is not affected. One
that points it at the file name, as MS-CIFS 2.2.6.2.2 describes, has
its last entry rejected here; the listing is unaffected, because
cifs_readdir() records the resume name from an entry it emitted, and
before this series such a response could instead end the listing early,
since a name length read from the wrong place is usually PATH_MAX or
more, which CIFSFindNext() rejects with -EINVAL.

On trees before v6.19 the type for the level 0x105 fixed part is
spelled SEARCH_ID_FULL_DIR_INFO; adjust when backporting.

Fixes: 0752f1522a91 ("[CIFS] make sure we have the right resume info before calling CIFSFindNext")
Cc: <stable@vger.kernel.org> # 6.1.x: f8cf09a53a0d: smb: client: bound dirent name against end of SMB response in cifs_filldir
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/readdir.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 6ab4e687c3e4..fdbe22b24c47 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -586,30 +586,46 @@ static void cifs_fill_dirent_std(struct cifs_dirent *de,
 }
 
 static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
-		u16 level, bool is_unicode)
+		const char *end, u16 level, bool is_unicode)
 {
+	size_t len = end > (const char *)info ? end - (const char *)info : 0;
+
 	memset(de, 0, sizeof(*de));
 
 	switch (level) {
 	case SMB_FIND_FILE_POSIX_INFO:
+		if (len < sizeof(struct smb2_posix_info))
+			goto too_short;
 		cifs_fill_dirent_posix(de, info);
 		break;
 	case SMB_FIND_FILE_UNIX:
+		if (len < offsetof(FILE_UNIX_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_unix(de, info, is_unicode);
 		break;
 	case SMB_FIND_FILE_DIRECTORY_INFO:
+		if (len < offsetof(FILE_DIRECTORY_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_dir(de, info);
 		break;
 	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
+		if (len < offsetof(FILE_FULL_DIRECTORY_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_full(de, info);
 		break;
 	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
+		if (len < offsetof(FILE_ID_FULL_DIR_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_search(de, info);
 		break;
 	case SMB_FIND_FILE_BOTH_DIRECTORY_INFO:
+		if (len < offsetof(FILE_BOTH_DIRECTORY_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_both(de, info);
 		break;
 	case SMB_FIND_FILE_INFO_STANDARD:
+		if (len < offsetof(FIND_FILE_STANDARD_INFO, FileName))
+			goto too_short;
 		cifs_fill_dirent_std(de, info);
 		break;
 	default:
@@ -617,7 +633,17 @@ static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
 		return -EINVAL;
 	}
 
+	if (de->name && (end < de->name ||
+			 (size_t)(end - de->name) < de->namelen)) {
+		cifs_dbg(VFS, "search entry name extends past end of SMB\n");
+		return -EINVAL;
+	}
+
 	return 0;
+
+too_short:
+	cifs_dbg(VFS, "search entry extends past end of SMB\n");
+	return -EINVAL;
 }
 
 #define UNICODE_DOT cpu_to_le16(0x2e)
@@ -672,10 +698,14 @@ static int is_dir_changed(struct file *file)
 static int cifs_save_resume_key(const char *current_entry,
 	struct cifsFileInfo *file_info)
 {
+	struct TCP_Server_Info *server = tlink_tcon(file_info->tlink)->ses->server;
+	char *buf = file_info->srch_inf.ntwrk_buf_start;
+	const char *end = buf + server->ops->calc_smb_size(buf);
 	struct cifs_dirent de;
 	int rc;
 
-	rc = cifs_fill_dirent(&de, current_entry, file_info->srch_inf.info_level,
+	rc = cifs_fill_dirent(&de, current_entry, end,
+			      file_info->srch_inf.info_level,
 			      file_info->srch_inf.unicode);
 	if (!rc) {
 		file_info->srch_inf.presume_name = de.name;
@@ -977,7 +1007,8 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	struct qstr name;
 	int rc = 0;
 
-	rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
+	rc = cifs_fill_dirent(&de, find_entry, end_of_smb,
+			      file_info->srch_inf.info_level,
 			      file_info->srch_inf.unicode);
 	if (rc)
 		return rc;
-- 
2.39.5


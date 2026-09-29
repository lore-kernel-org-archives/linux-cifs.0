Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8126D4C33F9
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673501; cv=none; b=mKLW13RhmvQ6j3GQ7fLiibU0SeiAQ3kmuvu7c/pD61SfNSc06/M3BlxH8Cl9CmhRI3MYG6xSZfoyIOcOhs4kxFTC6ESM1VTIAV8VSDJbjV4ZCjJkqvCFgVf6/soo9wAwjDS4uRmksRGoakgttkVkUyWNCpFWwIuazjrDrNRcXBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673501; c=relaxed/simple;
	bh=Oc5+m+0waFnTNHvgcr2mgu5TTazhGdM4vf3aK8aZ9FQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ug4DFAxy8A9mcjhRDnmtYd4VpULbaO1BMNqSVQI7h6Zu3ZJrd0vACo13O13bYFKbiKAvZk4qlC1VCR6U8FubtAEll9O6/OahSG8RGifraF1PwXU2RqiTDdE+t18Xgi04LCtQkOSwot7yJlg/NP3jvs0mLrgmutE4CjlgVFPw79I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=KHZ0yoCE; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="KHZ0yoCE"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4885d4825adso2381578f8f.0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673491; x=1791278291; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gy8M9IcJOjQGerNQOszCI6du9tK0xE+gWxQhuH6f0Rg=;
        b=KHZ0yoCE7vwKiaKUqEdgxwVS5sr7dmPNp2PlefP/Mn4eEwb8x8t10zEg7jR3HNJAjQ
         zrytvyYxiuU+qezqq5G6+qrDX0VAGnAiBZfGbcyCtlYUhVblCMtCGiuJSvyTI+CDyv1R
         sN/ja3M4sK8W9iseo+uZmpBR+eUUv5UmrNhwdo8QBM6c1ylZqTgts5u/IjL1v5jP7zEa
         P0g4YWOZAmYYqvpfW9xnGg37BZgEm7+fI9bgja7+bce281NsxyT1lYbXnCY1iCI7ZcgK
         /Vnx0NR6kxGlP4TybzHdbPS+QrQPq8shZpX2PvkyPoZI2G7MvFyJkqmp5j5SrqnZlWwu
         kCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673491; x=1791278291;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gy8M9IcJOjQGerNQOszCI6du9tK0xE+gWxQhuH6f0Rg=;
        b=RCKO00JpFS4LTB9QH75QCROw7nKjmdwNKVDgFo6jkbTYG4SidkJIVPriZke5JxopD2
         EzDcNhymV7z9zvoVH2LJhdrIfVf7kf6AtvTFql1uRjNU3Egoa7IDPeZjel/DJ9jDdJQz
         YXR4HCbbBU4woJbX1l1Ia+ydzxInqKTHNZfLGG/cMLxkRs1Z8IOsKGibSwyQnP0UIl+M
         AjQLAonLXgSxfIqs7Th8LUTqUdvxJZA5Z/uccVI2x5tNsSNwaJ1gA4xV2YD7fi2pd/wm
         D7BJ0R9AYs5QobZnkZKRlPeRVUDVjmDwzHQKPMY2GozuVpFub3cw7y5eB7kG27rjWRsA
         0f5A==
X-Forwarded-Encrypted: i=1; AKwUvByt2zhhXShm7VY+mxDJ5L3wfF//fIHzbmUOaeB3faSatkc5pK67boZPpIJQW32BzGhJGX5ZRAxVDLjV@vger.kernel.org
X-Gm-Message-State: AFq9FYKQAa7jam23qO10syuu9pv5PhyL766h0lQw0+hJ/UOmgA6FfR62
	zGLM9UvwPQx8Poru4Mx+Rf+cPhJAHoMjGYad9D7RifhNI/ZPUoKEm+13DR6QgX/4CBkn
X-Gm-Gg: AYBFou3tyawic/2wrzZHj+qJFSSEPXhxpqMu+CcFoxDfhj2ubINZRVwTpC0phXsWSIJ
	9RZPuD+FY0im1lr4VZQjd32OposZ2a94CxF2koaWWpOgSpmjysadMeP/EQIuJmqQghjsYTykbOu
	58hIW6KJeVpV82zuaNCff9jB6GGxvVxlKWx2I5JR5ThHJP/u4djHb/ny8YqZ+gEwMfuiPh4f5pr
	4+jO0bGUSFQR9boWDJZot/uhnIKkDUvcBkRWXgwuihX1V2Sl0YPTdYFKzBN932K+hcrfB7/QSJc
	g63F3dasSCPPWwQpXUy1dey+iJEwlAQiEZv9hOuBOIYyznDWcdbVQZpPYKuvDateTfa31oREZO0
	RGG9SDokLDn0rnV9B4I1MUhhslWkbvTpU5103IaxmrUVICf3sEMH+h4naPcFsVXBVIyKTWdHkg7
	fyOQYkTvq5QJ+qUJAeq06X/fL6NeNnmCWOgCc4zQdNi9U5EKns5j4aJ8Ra+svKdvWA7tK4i0S+z
	XRguaFNMACagbChInSbvZ0Jp60=
X-Received: by 2002:a5d:5f05:0:b0:488:82c5:ee4a with SMTP id ffacd0b85a97d-48882c5eed0mr17621546f8f.7.1790673490767;
        Tue, 29 Sep 2026 02:18:10 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:10 -0700 (PDT)
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
Subject: [PATCH 2/7] smb: client: fix OOB last_entry pointer from unbounded LastNameOffset
Date: Tue, 29 Sep 2026 10:16:31 +0100
Message-Id: <20260929091636.2618227-3-diego@bynar.io>
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

CIFSFindFirst() and CIFSFindNext() locate the last entry of a
TRANS2_FIND_FIRST2 or TRANS2_FIND_NEXT2 response by adding the
LastNameOffset of the response parameters to the start of the data
area, and store the result in psrch_inf->last_entry. MS-CIFS 2.2.6.2.2
defines that offset as the offset of the entry's file name; the client
follows the reading of NT and Samba servers, which point it at the
entry. LastNameOffset is only checked against CIFSMaxBufSize, which
says nothing about the response actually received: validate_t2() lets
the data area start up to 1024 bytes into the buffer, and SendReceive()
copies at most CIFSMaxBufSize + MAX_CIFS_HDR_SIZE bytes of a response,
16468 by default, into a cifs_request allocation of CIFSMaxBufSize +
MAX_SMB2_HDR_SIZE bytes, 16588 by default. The pointer itself can
therefore be placed anywhere from the end of the received data to 820
bytes past the end of the allocation.

The read through that pointer is far larger than its displacement.
find_cifs_entry() hands last_entry to cifs_save_resume_key() after every
FindNext and after the FindFirst of a search rewind, and
cifs_fill_dirent() takes the length of the name from the entry itself: a
__le32 FileNameLength for most levels, a __u8 for
SMB_FIND_FILE_INFO_STANDARD, and for SMB_FIND_FILE_UNIX the result of a
scan for the terminating NUL over up to PATH_MAX + 1 UTF-16 units. The
name is recorded as the resume name of the search, and the next
CIFSFindNext() rejects only a recorded length of PATH_MAX or more before
copying the name into the ResumeFileName of its request and sending it
with the resume key taken from the same entry: up to 4 KiB of memory
from past the end of the allocation leaks to the server, and for
SMB_FIND_FILE_UNIX the NUL scan runs about twice as far before the
length is even known. The entry does not have to lie outside the
response for that either: a maximal response ends about 120 bytes before
the end of the allocation, so an entry in its last bytes with a name
just under PATH_MAX has nearly all of that name copied from past the
allocation.

It needs nothing unusual from the client: a FindNext response that
reports no entries and does not end the search makes find_cifs_entry()
send the next FindNext at once, carrying whatever was parsed at
LastNameOffset, and a search rewind can do the same after its
FindFirst. SMB1 is not negotiated by default: this takes a malicious
or compromised server, a mount of it with an explicit vers=1.0, which
CONFIG_CIFS_ALLOW_INSECURE_LEGACY (default y) permits, and a directory
listing on that mount.

With KASAN enabled, a response that places the last entry past the
buffer, with a large DataOffset and a LastNameOffset near the end of
its range, gives:

 ==================================================================
 BUG: KASAN: slab-out-of-bounds in cifs_save_resume_key.isra.0+0x7aa/0x7f0
 Read of size 4 at addr ffff88807b55c33b by task ls/83

 CPU: 1 UID: 0 PID: 83 Comm: ls Not tainted 7.3.0-rc4-00457-gf14572c203d5 #69 PREEMPT(lazy)
 Call Trace:
  <TASK>
  kasan_report+0xdf/0x1a0
  cifs_save_resume_key.isra.0+0x7aa/0x7f0
  cifs_readdir+0x1ed6/0x29c0
  iterate_dir+0x1c0/0x570
  __x64_sys_getdents64+0x133/0x270
  do_syscall_64+0x109/0x5d0
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  </TASK>

 Allocated by task 83 on cpu 0 at 19.317556s:
  cifs_buf_get+0x36/0x90
  smb_init+0x4f/0x110
  CIFSFindNext+0xf7/0x14c0
  cifs_readdir+0xf51/0x29c0

 The buggy address belongs to the object at ffff88807b558000
  which belongs to the cache cifs_request of size 16588
 The buggy address is located 623 bytes to the right of
  allocated 16588-byte region [ffff88807b558000, ffff88807b55c0cc)
 ==================================================================

The four bytes read there are the FileNameLength of the entry, which
cifs_fill_dirent() takes before anything checks where the entry lies.

Ignore the last entry when it does not start inside the received
response or the response holds no entries; for a response without
entries, last_entry pointed into or past its empty data area and
cifs_save_resume_key() parsed whatever the buffer held there. The
entry is bounded by the response that was received, which is what the
buffer holds, rather than by the data area the response declares,
which a later patch checks against the received length. Record the
search handle before the last entry is examined, since a response
without a usable last entry still carries the handle that the search
is continued and closed with; leaving the assignment in the else
branch would drop the handle of every response without entries.

This bounds where the last entry starts, not how far it is parsed: an
entry that starts within the final bytes of the response still has
its fixed part read past the end of the received data and its name,
up to 4095 bytes, copied from past the end of the allocation, until
the following patch bounds the parse itself. A response without a
usable last entry continues the search with an empty resume name,
since the preceding patch, "smb: client: fix use-after-free infoleak
via the readdir resume name", drops the recorded name whenever a new
response is installed. This patch applies on top of that one and
relies on it: without it, every response rejected here would leave
the previous name in place, pointing into a buffer that has been
released.

A conforming server is not affected: the last entry lies inside the
data area of the response.

Fixes: 0752f1522a91 ("[CIFS] make sure we have the right resume info before calling CIFSFindNext")
Fixes: b77d753c413e ("[CIFS] Check that last search entry resume key is valid")
Cc: <stable@vger.kernel.org>
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 67f033b960e6..7eb83dd737fc 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4546,14 +4546,17 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->presume_name = NULL;
 	psrch_inf->resume_name_len = 0;
 	psrch_inf->resume_key = 0;
+	if (pnetfid)
+		*pnetfid = parms->SearchHandle;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (!psrch_inf->entries_in_buffer) {
+		psrch_inf->last_entry = NULL;
+	} else if (psrch_inf->srch_entries_start + lnoff >=
+		   psrch_inf->ntwrk_buf_start + bytes_returned) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
 		psrch_inf->last_entry = psrch_inf->srch_entries_start + lnoff;
-		if (pnetfid)
-			*pnetfid = parms->SearchHandle;
 	}
 	return 0;
 }
@@ -4670,7 +4673,10 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	psrch_inf->resume_name_len = 0;
 	psrch_inf->resume_key = 0;
 	lnoff = le16_to_cpu(parms->LastNameOffset);
-	if (CIFSMaxBufSize < lnoff) {
+	if (!psrch_inf->entries_in_buffer) {
+		psrch_inf->last_entry = NULL;
+	} else if (psrch_inf->srch_entries_start + lnoff >=
+		   psrch_inf->ntwrk_buf_start + bytes_returned) {
 		cifs_dbg(VFS, "ignoring corrupt resume name\n");
 		psrch_inf->last_entry = NULL;
 	} else {
-- 
2.39.5


Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABFB29992B
	for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2026 13:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782481680; cv=none; b=T2hUhJojsvTY1f1Ey0DRPAqQpyKbbSMdGfxp9fPMDBSunWeT/yCinpWtiRkKeTxaU+4+RvJz0+FlPH5mM9F4B56BhCeEfzoSP4M8K4CUZNnoK8gFTC+IOoAEkR5E3sUsRN1p98EQoKrnWAHNYEArpcBhYDVmejhLzOajye9cPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782481680; c=relaxed/simple;
	bh=wFBVdcaQ2ccka/5wOG8XaMSIigsAwYqNb6HJkNkItVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyLVh3WyEe4HBN3bpWDviIATCgKhtBnHVG1kYsgGrWH46kOXus+I4faDtbFX0/95kgIDeGiiktjbSXL9rxDUevduoaVkuotPbn3KXwgzc021kzBzTflOCiiTEWxQZa9GTNTIhHvBm8U0slM7eOGYiog9OxwqtqlezhsTFlXwGTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R2ak2zka; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="R2ak2zka"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782481676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5HLYlVjWpw5/+Ndl9Jy1h3h3K0H3guo4Z4LAa2Hv3fg=;
	b=R2ak2zkaidYBTFbN3jVOoL/VoGF1kZmM7IuEoMw8OVeC1raxGxQd6Sf2xxMuHxg23LRNLS
	p+AEhj7FeqJmBJYYa8mFWbuV2meYEyE3lJvot43m9Tx62NlmafEWK+8t5pYthj+Lh67+UY
	0e44W+nAGu/zaas4PYKjI+EdZOIZTlA=
From: Huiwen He <huiwen.he@linux.dev>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org,
	chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH v4 4/7] smb/client: handle overlapping allocated ranges in fallocate
Date: Fri, 26 Jun 2026 21:47:16 +0800
Message-ID: <20260626134719.158270-5-huiwen.he@linux.dev>
In-Reply-To: <20260626134719.158270-1-huiwen.he@linux.dev>
References: <20260626134719.158270-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

smb3_simple_fallocate_range() can skip holes when an allocated range
returned by the server starts before the current fallocate offset. The
skipped hole is not zero-filled, but fallocate still returns success. A
later write to that hole may therefore fail with ENOSPC.

The function queries allocated ranges so that it can preserve existing
contents and write zeroes only into holes. However, the server may return
a range that starts before the current fallocate offset.

For example, assume the fallocate request is [100, 400) and the only
allocated range returned by the server is [0, 200):

        Request:      [100, 400)
        Server range: [  0, 200)  allocated

        Correct:
        [100, 200)    allocated data, skip
        [200, 400)    hole, zero-fill

        Current:
        [100, 300)    skipped
        [300, 400)    zero-filled afterwards

The current code adds the full server range length, 200, to the current
offset 100 and moves to 300. As a result, the hole in [200, 300) is
skipped without being zero-filled.

Calculate the end of each allocated range and advance from the current
offset to that end. Ignore ranges ending before the current offset and
reject ranges whose end offset overflows.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2017357efac5..4cd0e578e3ce 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3597,6 +3597,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
 	u32 out_data_len;
 	char *buf = NULL;
+	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
@@ -3633,13 +3634,21 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 			goto out;
 		}
 
-		if (off < le64_to_cpu(tmp_data->file_offset)) {
+		range_start = le64_to_cpu(tmp_data->file_offset);
+		range_len = le64_to_cpu(tmp_data->length);
+		if (check_add_overflow(range_start, range_len, &range_end) ||
+		    range_end > S64_MAX) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		if (off < range_start) {
 			/*
 			 * We are at a hole. Write until the end of the region
 			 * or until the next allocated data,
 			 * whichever comes next.
 			 */
-			l = le64_to_cpu(tmp_data->file_offset) - off;
+			l = range_start - off;
 			if (len < l)
 				l = len;
 			rc = smb3_simple_fallocate_write_range(xid, tcon,
@@ -3656,11 +3665,13 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 		 * until the end of the data or the end of the region
 		 * we are supposed to fallocate, whichever comes first.
 		 */
-		l = le64_to_cpu(tmp_data->length);
-		if (len < l)
-			l = len;
-		off += l;
-		len -= l;
+		if (off < range_end) {
+			l = range_end - off;
+			if (len < l)
+				l = len;
+			off += l;
+			len -= l;
+		}
 
 		tmp_data = &tmp_data[1];
 		out_data_len -= sizeof(struct file_allocated_range_buffer);
-- 
2.43.0


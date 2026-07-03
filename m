Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF59A359A6F
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 05:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056847; cv=none; b=U94yuEGz4tONiRhGXR+PonkTTDqUcl3Q0cF5YzMNQDLqVhsAC/j/jquvYrqaWILKCIuoXLmtZqpwTv3PCI82hMe9DT7R17RWGHmGWsr2NagYZl5pVLfpcFIpd+7rw3IwAMrL8CjSrKX7nffIBpNTV+imhdjolbTlbahRl+XYJZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056847; c=relaxed/simple;
	bh=KgKqghqyNy8Q6fgp8fKTpyZnPdnh4VSUz0E8IBhdZFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODaEG64Axqokv3m35jz/+tnnOW+q6aVLbrbFrPFx9AWIjFkxlhn7CCRRGngguHUj3Hks/llaTB0gSTELhfXF/Qf88tl36MeR1oWSp/FedMjwvVE3joN/v/AtdcVeNQoLoHWt7Polz7Xy1bFOUZeX+OqagODqceasqN0unNf3rIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lCpVux2b; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lCpVux2b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783056841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/GK643mWH14p+S1J3cLnncZ+C62beF9RF48vv6+/kZ0=;
	b=lCpVux2bYbAhdk0pjfYY3n37lasMdLedRg/oGo1H6CoRWKN1DmEq6Wh8X4Lu0WF9S/fPK0
	X1Vn6qM9is0hMHVvUD2PABoAVSdZj5iA0uicE2ZqssaJRxdre0vpVyK9M4WfQxSDi8Kby7
	3ko4R4r41lSLFgOHynqVlZx8Pz5U1Rc=
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
Subject: [PATCH v8 2/5] smb/client: handle overlapping allocated ranges in fallocate
Date: Fri,  3 Jul 2026 13:32:56 +0800
Message-ID: <20260703053300.913371-3-huiwen.he@linux.dev>
In-Reply-To: <20260703053300.913371-1-huiwen.he@linux.dev>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
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

Fix this by advancing only over the part of the allocated range that
overlaps the current fallocate offset.  Ignore ranges that end before the
current offset and reject ranges whose end offset overflows.

This also prevents a malformed range length from causing an out-of-bounds
zero-buffer read.

Fixes: 966a3cb7c7db ("cifs: improve fallocate emulation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2ops.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 26366098c4b7..380f4b4ddcd7 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3611,6 +3611,7 @@ static int smb3_simple_fallocate_range(unsigned int xid,
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
 	u32 out_data_len;
 	char *buf = NULL;
+	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
@@ -3647,13 +3648,21 @@ static int smb3_simple_fallocate_range(unsigned int xid,
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
@@ -3670,11 +3679,13 @@ static int smb3_simple_fallocate_range(unsigned int xid,
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


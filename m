Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31107468C1F
	for <linux-cifs@vger.kernel.org>; Wed,  2 Sep 2026 10:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788345755; cv=none; b=uYWWlDWb0nmInUU6DXcVEORt26fXF6qst6JLdQva7prWV0kM0QTiwSbmeCnWoZn53PiY5J385mD1XSJ+cQEJC2fT14bsiJ/3qkk+N1MoZPoHdJeFLPezhUg9lCojRmjXKGdK8TMBG94nNHRtRUOVjqGH0wEOmo3oL2R8O2ji5Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788345755; c=relaxed/simple;
	bh=xyYMKLzzCsfncAvDaJj0J+b5UPf66aPFS2Ga9ljseK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FnA3NebfP41OLLzrm3E5CSRZpjvVLRMtwpDdJ0vt5LATwjNfQ9POgcJxy46FGMTdp0ggkB3JYwK+r0tHa4ZfmZ21v3ZQJ2mSKqRmFaR44mrM9qLDPKQuAceAKFj97VOuYN4it8Tr9ok0QKNk1njuRJrXet+U8kd0pSDXX0ddkoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=Yhz0cfAh; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="Yhz0cfAh"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-482e257a23aso691787f8f.0
        for <linux-cifs@vger.kernel.org>; Wed, 02 Sep 2026 03:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788345747; x=1788950547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FzrA12XVRpjhCE+SpE7Wp9kAWsl7VDT912zdHqjkACw=;
        b=Yhz0cfAho8UY67b4afxOXTaB8VnlJUJQoQazyl/tqD7mZVVfctVBfa+EoQssIzKvwc
         VwGgNTmXnzLIZf9T1+ChpV0GpIPIpustDAKnFH/VIJdv5b7h+BW0WA1VX7zz8i/rSEZu
         Ug6Z885M3pP/gz15SUtiwiBx7YOPbCbNICTZoKFCsdzuG4zCU2rk2guKyD1i+zShWNGo
         WeGYtey3SsKxDGyAN8fOYeVFMHJXpx9E1LGCehWX/CW5KNtp6+tgV98MyibmHRxkJ1sH
         6gNomp42LfqTw8UWKwzWHIXd8dIDfSQ5KEn3H8vSSFlzXUmYmTPczCM9PyhPf6Azkxab
         v6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788345747; x=1788950547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FzrA12XVRpjhCE+SpE7Wp9kAWsl7VDT912zdHqjkACw=;
        b=cCEAM6nFpbcxD1kUCNgi2MQVbQK4+jqe85k3BGT/kXZPovuE/yI0Y29gZ28rN3u4ZZ
         eXNwS6XAvTVg2oVJedQTki+FstyYY/HgcknoSDuQkL+5uh4K4mz5x9yCtLv1jdEQ9GcV
         HHEZveBTmOljnD+iJB37XFxTnZPQ8GucjX5nluB3ONNPOLNd9gRLa9RHXQRlEis7lg7d
         t2wJ4mf/1BDQtBfsh1sd9nLJa+LhafNdKsUMqjYqAj1LTYmncT/6GhP3nycBCuTYE5o9
         wUg9RDyTYKccesiBjhRkerOVTcNz5DbTOWhTosAYd2iH8R9dTG1lTMrJKEUDUgIO7JF7
         Bisw==
X-Forwarded-Encrypted: i=1; AHgh+RpOjTVduvi0bSWGaB6QypBiuhfW1mn5Sm3PAwgDIbwiJdZ7+K+GnXBGOu5uqfdTCQVqOQ4SZ1qrtK+g@vger.kernel.org
X-Gm-Message-State: AFuF++l2ciTn2mWURrooaxollCqIUcQzYjRu7GdVIZ6R5fWZp7ARDhN9
	eg6zwnwJsBWJQZugaFYCD8f5pq8jv+T7lP0AOC2C2NxydLapo3P9H304js1bw9TYPPa2
X-Gm-Gg: AR+sD101j0M152CrM9imyDxrFpblAdjZOyloD2frJAUemw39Rfdu4WtKWyzfgacCEYa
	fxJ2L5SC20fNC5Esa0L9oLKH2WCVrMPGqRy5Q+679PzUQOhRyGaKOgjngPo19hAKmv2xWEBylgx
	xhjemykdeJ+HwayP2yU5bb64Z7w/sR9qBRueMso8fc/r9RTC95jJbuLvJBW+D+QgCvJ0FLJBxWB
	hQuUBohjHtq9jVVSnmZuxRdMhDdY8kIndjOvtvRNsdVIogKLvGCakfu/nbpX/K+aL+4cX/4VqV1
	WxDw1tKuM/AvCtL3fqwZBB8tJIYjXPh+6NkFAq0NqcM59U9Vd1f1Kj3cw0bl7DjLgDBfG0e/wTE
	WrdgcjtK2PRW4Uy6+tX/COLJI+jiYpRzKvGsZ8bGscvEVo7o8wkOetMbQ7Hvg/NmUAmVlBsm1vN
	9aRkpAlnJCeWvkLFrLCQ2ewE8iKC/Ppr37+/Jxfvi9HFzRAUYc4gZVmoJi0X253+eSPJ18iMD+e
	XcZlurB66pyu5No6g==
X-Received: by 2002:a05:600c:1f87:b0:49c:dadb:18a7 with SMTP id 5b1f17b1804b1-49ce5818132mr59943005e9.10.1788345747514;
        Wed, 02 Sep 2026 03:42:27 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-484492ce5e5sm5197521f8f.36.2026.09.02.03.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 03:42:27 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
Date: Wed,  2 Sep 2026 11:42:07 +0100
Message-Id: <20260902104207.1820332-3-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260902104207.1820332-1-diego@bynar.io>
References: <20260902104207.1820332-1-diego@bynar.io>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB1 synchronous read helper CIFSSMBRead() validates the server's
DataLength against CIFSMaxBufSize and the caller's count, but never
validates DataOffset. The copy source is formed as

	&pSMBr->hdr.Protocol + le16_to_cpu(pSMBr->DataOffset)

and memcpy()'d for DataLength bytes with no check that the
[DataOffset, DataOffset + DataLength) range lies within the response
actually received from the server.

A malicious or compromised SMB1 server can return a response carrying
an in-range DataLength and a large DataOffset, driving the source
pointer past the end of the response buffer. The memcpy() then copies
adjacent kernel heap into the caller's read buffer (information
disclosure), or reads unmapped memory and oopses (denial of service).
SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Both DataOffset and the received response length recorded in
rsp_iov.iov_len are relative to the start of the SMB header, so reject
the response unless DataOffset + DataLength fits within that length,
using overflow-safe arithmetic, before forming the source pointer.
The response length has been validated by the previous patch, so the
DataOffset and DataLength fields can be read safely here.

While here, make data_length unsigned. It holds a length derived from
unsigned on-the-wire fields and is only ever compared against unsigned
quantities; print it with %u accordingly, and add __func__ to the
cifs_dbg() calls in this function.

smb_EIO2() was introduced in v6.19, so this does not apply to older
stable trees without returning plain -EIO instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org> # 6.19.x
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 17 ++++++++++++-----
 fs/smb/client/trace.h   |  1 +
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index aa6b904ad866..3c86eb6cf76e 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1728,7 +1728,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 			      rsp_iov.iov_len, tcon->ses->server->vals->read_rsp_size);
 		*nbytes = 0;
 	} else {
-		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		unsigned int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		__u16 data_offset = le16_to_cpu(pSMBr->DataOffset);
 		data_length = data_length << 16;
 		data_length += le16_to_cpu(pSMBr->DataLength);
 		*nbytes = data_length;
@@ -1736,14 +1737,20 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		/*check that DataLength would not go beyond end of SMB */
 		if ((data_length > CIFSMaxBufSize)
 				|| (data_length > count)) {
-			cifs_dbg(FYI, "bad length %d for count %d\n",
-				 data_length, count);
+			cifs_dbg(FYI, "%s: bad length %u for count %u\n",
+				 __func__, data_length, count);
 			rc = smb_EIO2(smb_eio_trace_read_overlarge,
 				      data_length, count);
 			*nbytes = 0;
+		} else if ((size_t)data_offset + data_length > rsp_iov.iov_len) {
+			/* check that the data lies within the received response */
+			cifs_dbg(FYI, "%s: bad data offset %u length %u for response of %zu\n",
+				 __func__, data_offset, data_length, rsp_iov.iov_len);
+			rc = smb_EIO2(smb_eio_trace_read_bad_offset,
+				      data_offset, data_length);
+			*nbytes = 0;
 		} else {
-			pReadData = (char *) (&pSMBr->hdr.Protocol) +
-					le16_to_cpu(pSMBr->DataOffset);
+			pReadData = (char *) (&pSMBr->hdr.Protocol) + data_offset;
 /*			if (rc = copy_to_user(buf, pReadData, data_length)) {
 				cifs_dbg(VFS, "Faulting on read rc = %d\n",rc);
 				rc = -EFAULT;
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 12241abb8e2e..b442cccd1530 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -79,6 +79,7 @@
 	EM(smb_eio_trace_qreparse_setup_count,		"qreparse_setup_count") \
 	EM(smb_eio_trace_qreparse_sizes_wrong,		"qreparse_sizes_wrong") \
 	EM(smb_eio_trace_qsym_bcc_too_small,		"qsym_bcc_too_small") \
+	EM(smb_eio_trace_read_bad_offset,		"read_bad_offset") \
 	EM(smb_eio_trace_read_mid_state_unknown,	"read_mid_state_unknown") \
 	EM(smb_eio_trace_read_overlarge,		"read_overlarge") \
 	EM(smb_eio_trace_read_rsp_malformed,		"read_rsp_malformed") \
-- 
2.39.5


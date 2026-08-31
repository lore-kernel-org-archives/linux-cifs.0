Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFCD3D6CC3
	for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788180678; cv=none; b=F4zuLRlQx27wvtYhmUhT8IAD/adlmDTaxEkMcBjvYGdyHJUxylPWRGiqXoYCPjmiiAdaYyZuZJOOp9gT30ivC2mwJ2Urj677XRtAv3hhtx5949XfwKDCKQFNc7WHaPZZZLBeX0cfKauqMyrMZ/5xbr1KfDgTML2hLnWKqmjBfcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788180678; c=relaxed/simple;
	bh=MsgD6xMrJ817lE4I/y63u6Ufiz4oIuiclFfZLj4rF+8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=azqpLmRMDo7mqriw34vDHuzaWuK2V2+KWkyA6BhEx4ClFJWp2bxZdYCddBYQV04AqmCGqdlZSHd3Yrbv6B1ily1lg+h2AsvOdBZtYpIbJubN+Bj/7FSQLaKjDFhquA3n2YbJmMZUTd7QNnYq1KeVFT23gx4EuFTFp7/WSbB4mhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=ncTawx13; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="ncTawx13"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49ccfbe062eso15307645e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 31 Aug 2026 05:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1788180675; x=1788785475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5A26gOuAVOyjv1TvWMYcqopm/IcXjJSkKIFefy8rQWY=;
        b=ncTawx13/dDkgf/CUItoXetCbuNzsZLgQ6QEoQEQqVkugqaz9ZIDut1O+t1Zsnt3Zp
         LybQMbgR4HFKG3mXdOjOEET7OR9hdrnUK9Nk3tsAxfgUuRHuoPmo+mgCC/VYYAiTVeyf
         DNNwGm9AAwRubePJQxHd6wN1cfATQBxhUL7fXTi28BGsaAXZkqC/EIjernZZeodJRiMs
         5EiLHVYTT2h4HVt93Gcy6pXaLrwgikQewM9dL/INOj6NfeXiK81SwS72E9oKo15d9gdY
         LyHRNPlF+eLqgztP1iBWavHJyJLWJfCwILfW/plQRk7d8NlzN86L2hj4pLn2Va+Keb7f
         F/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788180675; x=1788785475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5A26gOuAVOyjv1TvWMYcqopm/IcXjJSkKIFefy8rQWY=;
        b=rwOeRUIoV99AdD617FdaawhkmWcbuL5HYZCDE8QbOtcWJnqqCYP2KxekReJ0mNNxQR
         Ma76sRt6IZBxldU+8r3LHvuONHUSLnpX5uJWggX80LrJqc4MabOm0r2wRniwIsNPiQum
         CypMVXxYs/iJp1GSmuOSocFSzo395zryXTEPaIL13rE6GKNE7REVdgIAlKB61Z+IRYx2
         12RxYC4BXShyAIxE33ZWbcA0Bq5rRZMZUbpRL1GnxIzRERCY50RKK77hxojrO1rIv+ea
         BnXT0iz6gRHvk/4JY5mXdq4yBTYn/5ifJebRHC83NU7BEcL1mx7on7dyOthgnXffN8KU
         4BGw==
X-Forwarded-Encrypted: i=1; AHgh+Rokr3LMWklbu2ilDdH5T2r2W5EF5QWn8lye0EnC5awneHucpySnHN+pJDydT+2/gYSDEM4w4fsTRlw5@vger.kernel.org
X-Gm-Message-State: AFuF++l+hfCjD9k4xxpVKSwtLJpQ6Htxwp9sVpRvdHifAAmwO0a+9wRj
	J6FeTHz7BdgT/mirL3Kdxdvu3+8YjP6EGv5Sz/LS4i+VKUqDIQ/q8B7KhooofbDj5fEu
X-Gm-Gg: AR+sD10dxAEfmyyh7pFGUldBXAv4fYzoVIdEBQCOU6pGYtXW870QMaOHl1/oBJ08UEm
	2UpzOUwqbZGXsEhwt9BH1XQJxBQFCGrmE0GUQ0kBPzR4f5BTLGrzi6/825WnWwPedrf8pI/16dy
	JI9zn9piRfkMdvJRfVeUd3KjlCgwLWg1jE7U23kNEDTToYpLNya9OWq+4v2CcxtvaFN8p+6muX/
	3z4LelfLOzGKGnOfoM+0bmxq58cupHls8kjyT8fQeGkqkXaN3x060YTQtREbY6RFllgoYgE/Mvv
	v7CW//ki2dOptvfjzzeLNbrnUr5Q8IHCEIsfrUO6nuFfBIDkSfVq7FMIfPBeqTp4/XGa06eTw+Y
	aXmyAnTvK98xjmEY1Lw4oiGzi1h5suKqSCijEg4lw+CPDMeIdPQ65vs2nPNnILQForXEHW1GaSZ
	71xQMoWdgN3a1eUFZ4JyyxB+FH3G2fTmJ5rd6UEt+aLc+jx7szS0AGrkphrefizJX9
X-Received: by 2002:a05:600c:8b86:b0:493:f5bf:4dc6 with SMTP id 5b1f17b1804b1-49b91c2777emr454968265e9.7.1788180674354;
        Mon, 31 Aug 2026 05:51:14 -0700 (PDT)
Received: from localhost.localdomain ([151.18.18.196])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48432022ab8sm15739457f8f.28.2026.08.31.05.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 05:51:13 -0700 (PDT)
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
Subject: [PATCH v2] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
Date: Mon, 31 Aug 2026 13:50:45 +0100
Message-Id: <20260831125045.479576-1-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260828150203.1419003-1-diego@bynar.io>
References: <20260828150203.1419003-1-diego@bynar.io>
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

A malicious or compromised SMB1 server can return a short response
carrying an in-range DataLength and a large DataOffset, driving the
source pointer past the end of the response buffer. The memcpy() then
copies adjacent kernel heap into the caller's read buffer (information
disclosure), or reads unmapped memory and oopses (denial of service).
SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Both DataOffset and the received response length recorded in
rsp_iov.iov_len are relative to the start of the SMB header, so reject
the response unless DataOffset + DataLength fits within that length,
using overflow-safe arithmetic, before forming the source pointer.

While here, make data_length unsigned. It holds a length derived from
an unsigned on-the-wire field and is only ever compared against
unsigned quantities. This is not required by the validation added
above, but it matches what the variable represents.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
v2:
 - make data_length unsigned, as suggested by Namjae Jeon
 - rebased on current upstream
 - v1: https://lore.kernel.org/linux-cifs/20260828150203.1419003-1-diego@bynar.io/

Note for backporting: this uses the smb_EIO2() tracepoint helper added
in v6.19 with f80ac7eda1cf5. For older kernels, the call can be
replaced with a simple return of -EIO.

 fs/smb/client/cifssmb.c | 13 ++++++++++---
 fs/smb/client/trace.h   |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..b89d49395362 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1720,7 +1720,8 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (rc) {
 		cifs_dbg(VFS, "Send error in read = %d\n", rc);
 	} else {
-		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		unsigned int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
+		__u16 data_offset = le16_to_cpu(pSMBr->DataOffset);
 		data_length = data_length << 16;
 		data_length += le16_to_cpu(pSMBr->DataLength);
 		*nbytes = data_length;
@@ -1733,9 +1734,15 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 			rc = smb_EIO2(smb_eio_trace_read_overlarge,
 				      data_length, count);
 			*nbytes = 0;
+		} else if ((size_t)data_offset + data_length > rsp_iov.iov_len) {
+			/* check that the data lies within the received response */
+			cifs_dbg(FYI, "bad data offset %u length %d for read response of %zu\n",
+				 data_offset, data_length, rsp_iov.iov_len);
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
index 12241abb8e2e..982b6ba1e429 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -79,6 +79,7 @@
 	EM(smb_eio_trace_qreparse_setup_count,		"qreparse_setup_count") \
 	EM(smb_eio_trace_qreparse_sizes_wrong,		"qreparse_sizes_wrong") \
 	EM(smb_eio_trace_qsym_bcc_too_small,		"qsym_bcc_too_small") \
+	EM(smb_eio_trace_read_bad_offset,               "read_bad_offset") \
 	EM(smb_eio_trace_read_mid_state_unknown,	"read_mid_state_unknown") \
 	EM(smb_eio_trace_read_overlarge,		"read_overlarge") \
 	EM(smb_eio_trace_read_rsp_malformed,		"read_rsp_malformed") \

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.39.5


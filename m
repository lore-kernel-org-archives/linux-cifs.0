Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408FF474247
	for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 15:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787929339; cv=none; b=N9cDuLsrvdGl/Bq7phcbWdC9Xmm1t8G5edJrvZURnFMbk7avoretvjrgxERO6Ck5pmGvgWb9HRAtYkkcaS0G1mBalkTirRCW2SAvaiKHoNmxz/0XD8/SsGKsl46kmQBc2vojNdgruFYaKdLtlZg+9Qdm8y9wB7UxA9WUdnCQ4uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787929339; c=relaxed/simple;
	bh=Wa7DU2ONyVHxxUL57YXAP/BmtCQAuho+dw66VWI7TlY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BnM0kfiko5ysqQSz5XEYK3NAO1E2M0QwA9Gg9DFNwvewK/UdILFVlrxhwerbFKtlhHGJsBIqvHVWJA3guJhbm2hk7dQa9qmYQsR1tvPYPpVuu7mv+sqb9lD/28DD0nzRQCxZIP9WhTYhVnaqC45sORRzCWqm2udTODoCzHoM2D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=G1fReh8E; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="G1fReh8E"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b0dbfbf7bso7344445e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 28 Aug 2026 08:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1787929335; x=1788534135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=u4y9nYNVrdiwOeZUDCV+lDVrZEAd7aSbhGr58JFBRsg=;
        b=G1fReh8ED7PAAcwWjBu3pmsxfu4BaAwG/hGfUSoG2y9o85vWzPgMhC6uSZI3ngEqKl
         sJe0EmhaDTboC2ypxnokHxr3lKF6DFLlgGNxapOaR405UlFGW7uJeI9NmYEiQsAxB/7y
         WwcmNyZr+q9hYw3D5s5KhpmiMlybWtMWIkXx37kZLkfW9/eCYuatLpHTXX4HC1wWr3ZN
         iy/UwFAzJ+rrrEbwXSmGtkSK3t+Gy/OdMMEnDiFPDAsSl/TfuduxJevc+2bd0r/f97D/
         GbY8DCn9nidURv6balwwdBQ9sFFm5NiwbHDH5y4xgnOtNXJY6pZHoZsXhE5hGjwH1OFR
         yQOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787929335; x=1788534135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=u4y9nYNVrdiwOeZUDCV+lDVrZEAd7aSbhGr58JFBRsg=;
        b=rbYqo4M0c1eGyZAMLgqs8NdvTjdV0ytfqM98mwsLbcZyQx4tOt0Cu1rwpsR1H4M7S8
         5oibME55aTJTJpbxY3SrJaGMfIDSMrvK6DOvgTKJWPN7OdkWaku8cXRAoNFHwQ4jtEmY
         rASKS90Ep4BrJt7bC5Tt1gSRkv5g4/AqwvkkcdE8AkbmQ3MmpRBKK0My0c37fdIW3uPb
         byQRB0NHUzUvwcC4JRvHVkoouALprg64Bd8YL3zU5M1a94aJzkSubo2LLKMRUWhwGP+R
         GD2MAweIGs4KBba+yKM2nfUET1ikCy2sFTnxk3wVt0MdeLKQyXLV9Uot1G/+Vb/B07s1
         8udg==
X-Forwarded-Encrypted: i=1; AHgh+RqJE2MEzZV5pMFIHZkILG3sfQj6P30wKYfPWyGydTf6vnK6SnKWhKxfHUOif5OVg7kcDxdTDSBOGVY9@vger.kernel.org
X-Gm-Message-State: AFuF++kvcqS737hJZNPUpvECXdn0r3nBNA82/REuN65jjCKbofQ0uEFu
	mTdl8+rMSI/qKBUHo0sjWX8qnN+LAgidVezr1J8BRhgY2hOPXs7AHFP6YNBNk2GNnx3a
X-Gm-Gg: AR+sD10eRWcAo32lgg/2wCsEn9X+a1S0p3426bpTR7F6tLI2AhqvTuso/uOWyKwV+Tj
	G5OQWxaoslR0m7Cj7fM5Gf4j91sOvthfWx5EO/KBJtngEH9g8L41EhC44HRuhoN0C/HL1J32wMO
	hoFBLQXc1+y3OTB8JUXZkrLjoz/RtfkGL8RpwCb0C3CZbwuTPrZcLpkO4gcHw3Io2XtnCD2aMGm
	bLdKPfE2BExI9YgSFV/PYYNcs8Vbx+XIre1IlOgLNoewdAXk9J/b1i6ZAAqU6CfcxgdyEpTD1WI
	6SVD0LP5ff0bOAMBk+Fo0hBBwRy8Ji7h9ofaQijEFlM9wnBa82XkVvtjAb6UuKGc5+Y9FDTrGBD
	BmBAWThFOYG2Q16l8+0pLyln1Rr/OT19Rgvp6+kWzkNeUfK4cVNu8Iw603tkmIlBwWqlV4vbMg1
	GhwGGC07jgi3K5EUNbi+niO5VLvRf5W008ex0qGDOL1LNXRimuLjH9aEvBYpaSUfj/rddq/XSmJ
	Pr1rBYACc7ilbM85g==
X-Received: by 2002:a05:600c:8587:b0:499:dbae:43d3 with SMTP id 5b1f17b1804b1-49b91c489bbmr109262455e9.9.1787929334941;
        Fri, 28 Aug 2026 08:02:14 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbac4d0asm4696842f8f.10.2026.08.28.08.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 08:02:14 -0700 (PDT)
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
Subject: [PATCH] smb: client: reject out-of-bounds DataOffset in CIFSSMBRead()
Date: Fri, 28 Aug 2026 16:02:03 +0100
Message-Id: <20260828150203.1419003-1-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
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

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
Note for backporting: this uses the smb_EIO2() tracepoint helper added
in v6.19 with f80ac7eda1cf5. For older kernels, the call can be
replaced with a simple return of -EIO.

 fs/smb/client/cifssmb.c | 11 +++++++++--
 fs/smb/client/trace.h   |  1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f5aad5f61dce..1a822121a883 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1721,6 +1721,7 @@ CIFSSMBRead(const unsigned int xid, struct cifs_io_parms *io_parms,
 		cifs_dbg(VFS, "Send error in read = %d\n", rc);
 	} else {
 		int data_length = le16_to_cpu(pSMBr->DataLengthHigh);
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

base-commit: 1b78070aaef63512688aebfbc82365ef9d6660f1
-- 
2.39.5


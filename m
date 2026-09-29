Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A554E0210
	for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 09:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790673505; cv=none; b=hxTRuYuUBaxi0qxpUFxr5ANJBqQ/ncSYWYok9RWEHchaSOx1ntI/E86qwWLHjOgQuGbF4XRIuBLQAKfF1dIX/RVSpx/+ctHjfpvr/sHj3lZdg59F35CaxxfSCrtu5Mv6Gvpsow0jABVEmzZL+eCBp2nk6pWIy3XmenbfXWVVICA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790673505; c=relaxed/simple;
	bh=TFS0KzSBTe+S2D+lLJyxokiAq25/7TBHzphsYGycxAs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GtPY9J3d7tT5eHRCn/2zl043oZk2Bas95KK1xmKZNB5ndJunRuPSQQ6HnXPEmlAHhNuX+IfRAju6PJ9v+1cKeoOLitWC2mUt1p2iVh9in3hJCH9kOy5E83uOYFpHvPdy1KDscOmi52uYNPkjEF6hemMGfN12BgKY0dh3uZ6H8bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=WwfWrdsd; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="WwfWrdsd"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-4a003bd18e5so10614825e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Sep 2026 02:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1790673495; x=1791278295; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m3AWyU/VDrri+MrqCxkbSv5Eh7dGQEH+AnIW5hjUsVA=;
        b=WwfWrdsdv/fv+p43Vcbs4zUCligH+2eOAbX19mg+Pj1NccqlVH2fXeSFeNaa5q4yk1
         bUTmxC3ehV+fv4eB1ZHYyKia8aHcdNo3ve4UJlUM4ZDMQZuz6mG9Gh5uqVrDUMNMKPrT
         UnpYIgRjH0g24YWP7a0r4Nz2rV51T4khp645jIOctXRCAMo7I36mVM5htNq5Az4/l4K+
         D+XaA2J3OsJvebhfmnDKf8qcXmo6tNumyfxInUJStfYK0uMIT2s/1iEeEO2BxTyxkxxO
         J1NINDtZ3iogyPIV+yQa8VS1Yn5xywNaYLnF4cBDtJigTD2VXrhVSYeLnPi2h+R2b+qD
         L9sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790673495; x=1791278295;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=m3AWyU/VDrri+MrqCxkbSv5Eh7dGQEH+AnIW5hjUsVA=;
        b=Px7Ix/TdRJH3sK0KMcR6C+KE61x9aob9+wrWpLEGz8dMMQjxHRZraTem3I/8ZUNQ+z
         ggG64/AxHKYAvzosD8Ps0mZmCID3PprVdmcbxlcan0WBuGd3hvNRo7QgE6UXiPDWJHNV
         wb//FiLtxl06Y+Eww0Cmn4yZFYOM46Yy9ypek2LyFpgNKbzdMVvHfu3blYQIeIJoDfsf
         OlLDNtdiPot9dGU7ablIil/cDYFp5MDu+C5KhF+P4dhOcC68TE83E7XcJ3bS6w2ZB9fM
         bEKItw9oGCU2zk4F8SZ7dudYOIVs3O5QIm8Kahi4k3aUReNGOo/CJh3pivcZZdgc/m0I
         QgzA==
X-Forwarded-Encrypted: i=1; AKwUvBwzNhEbI7sCPad5TrUHauvHEBbSLj9jYKpaOYMdoB6UUgH5G3vjJTQUsoHcGZ2fTQNZfS/q6K5RdhDl@vger.kernel.org
X-Gm-Message-State: AFuF++mmX7oGuD87Uy9VDPNCSIVglS/ISASl6aDVaxEPhgDb9+uee7TI
	UZqEfnCeuLoLjPRB8WWx94L9rAdP6g7Hg43ZRXnoOSts59AyV1DRGBWnvK0UNcK9xHx6
X-Gm-Gg: AYBFou3cQ2P8hrU7NkFrzVp3sy5RN9RijoYBVicLzEhHXDlRUsB46WH5Y02ZcirsRKH
	5sSsLRaSC72zXTte9nCDz7GyXOl/MUsIz58lnQEsbGb9P8UKRBCCKhbssig298+hpoExqo40oi7
	DOlWtBZ4P+SxlFXQwrxPev6K4KH82RF83gMgT8xgnQeCCIYpjZoMMusPCmqirPA1P2g4tSkZgSW
	mRfPYdxzT6nFzgRq9rFOOFi5lZVfrNEA/lCvMyGRnmUXxsCbT7B4MTdsb2eVEY/zgeVvAPPwpM9
	1YlepqUidNye43O+hSdEPxMla0zF3fD17CsxZe+vBaFbffu/VpUvnPjSijUyHJ5sKJKVBDRsQey
	bxatjuYDCHoNC2PxLXxJIIU+ibYs/Xf1yF9cOhhXNK1z9k4zw0LZc9IgirDiFgx9+X+F6n86MaB
	fGKDo54wxyI0CozYQbVPn/h8uXeYy6r7y+D1/jQ/2kpPCRbmlheOnUeClW47f89I78BqYMeQN1Q
	CGN4sTtx5tyl3Y6f6Dls1J7O0E=
X-Received: by 2002:a05:600c:a012:b0:49f:ce73:7ac with SMTP id 5b1f17b1804b1-49ff06fc82emr203552445e9.35.1790673494401;
        Tue, 29 Sep 2026 02:18:14 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48af51c57a0sm2155723f8f.15.2026.09.29.02.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 02:18:14 -0700 (PDT)
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
Subject: [PATCH 5/7] smb: client: reject FIND data areas that run past the received response
Date: Tue, 29 Sep 2026 10:16:34 +0100
Message-Id: <20260929091636.2618227-6-diego@bynar.io>
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

CIFSFindFirst() and CIFSFindNext() take the directory entries of a
TRANS2_FIND_FIRST2 or TRANS2_FIND_NEXT2 response from DataOffset for
DataCount bytes. validate_t2() bounds DataOffset at 1024 and
ParameterCount + DataCount by the byte count, and nothing compares
DataOffset + DataCount with the number of bytes SendReceive() copied
into the buffer.

smb_init() places the request and the response in the same
cifs_request allocation and cifs_buf_get() clears only the start of
it, so a short response whose data area extends past its end has
srch_entries_start point at bytes of the request that was just sent,
or at whatever the allocation held before, and those bytes are parsed
as directory entries. cifs_readdir() and find_cifs_entry() walk the
entries with nxt_dir_entry(), which checks every entry but the first
of a response against the end of the SMB; cifs_query_path_info() and
cifs_backup_query_path_info() read the first entry with no check at
all. Those reads stay inside the allocation, but what they return is
not part of the response. The last entry, which LastNameOffset locates
relative to the data area, is bounded against the received response
by an earlier patch of this series, as is every entry that
cifs_fill_dirent() parses; the walk itself and the two query functions
are not.

SMB1 is not negotiated by default; reaching this code requires an
explicit vers=1.0 mount.

Reject a response whose data area extends past the received length,
with the -EINVAL that validate_t2() returns for the other malformed
transaction responses. cifs_query_path_info() and
cifs_backup_query_path_info() still read a whole entry from a data
area that may be smaller than one; that is not changed here.

A conforming server is not affected. The data block of a transaction
response is part of the SMB, so DataOffset + DataCount cannot exceed
the smbCalcSize() bytes that SendReceive() copies; coalesce_t2()
appends each secondary response to the data area and adds its length
to both DataCount and the byte count, which keeps that relation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: <stable@vger.kernel.org>
Assisted-by: Bynario AI
Signed-off-by: Diego Oliva <diego@bynar.io>
---
 fs/smb/client/cifssmb.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 7eb83dd737fc..107ca76e53d1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4412,6 +4412,7 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FFIRST_RSP *pSMBr = NULL;
 	T2_FFIRST_RSP_PARMS *parms;
 	struct nls_table *nls_codepage;
+	unsigned int data_off, data_count;
 	unsigned int in_len, lnoff;
 	__u16 params, byte_count;
 	int bytes_returned = 0;
@@ -4530,11 +4531,19 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	data_count = le16_to_cpu(pSMBr->t2.DataCount);
+	if (data_off + data_count > (unsigned int)bytes_returned) {
+		cifs_dbg(VFS, "%s: data area offset %u count %u past response length %d\n",
+			 __func__, data_off, data_count, bytes_returned);
+		cifs_buf_release(pSMB);
+		return -EINVAL;
+	}
+
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	psrch_inf->ntwrk_buf_start = (char *)pSMBr;
 	psrch_inf->smallBuf = false;
-	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	psrch_inf->srch_entries_start = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	parms = (T2_FFIRST_RSP_PARMS *)((char *)&pSMBr->hdr.Protocol +
 					le16_to_cpu(pSMBr->t2.ParameterOffset));
@@ -4568,6 +4577,7 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 	TRANSACTION2_FNEXT_REQ *pSMB = NULL;
 	TRANSACTION2_FNEXT_RSP *pSMBr = NULL;
 	T2_FNEXT_RSP_PARMS *parms;
+	unsigned int data_off, data_count;
 	unsigned int name_len, in_len;
 	unsigned int lnoff;
 	__u16 params, byte_count;
@@ -4650,13 +4660,22 @@ int CIFSFindNext(const unsigned int xid, struct cifs_tcon *tcon,
 		cifs_buf_release(pSMB);
 		return rc;
 	}
+
+	data_off = le16_to_cpu(pSMBr->t2.DataOffset);
+	data_count = le16_to_cpu(pSMBr->t2.DataCount);
+	if (data_off + data_count > (unsigned int)bytes_returned) {
+		cifs_dbg(VFS, "%s: data area offset %u count %u past response length %d\n",
+			 __func__, data_off, data_count, bytes_returned);
+		cifs_buf_release(pSMB);
+		return -EINVAL;
+	}
+
 	/* BB fixme add lock for file (srch_info) struct here */
 	psrch_inf->unicode = !!(pSMBr->hdr.Flags2 & SMBFLG2_UNICODE);
 	response_data = (char *)&pSMBr->hdr.Protocol +
 		le16_to_cpu(pSMBr->t2.ParameterOffset);
 	parms = (T2_FNEXT_RSP_PARMS *)response_data;
-	response_data = (char *)&pSMBr->hdr.Protocol +
-		le16_to_cpu(pSMBr->t2.DataOffset);
+	response_data = (char *)&pSMBr->hdr.Protocol + data_off;
 
 	if (psrch_inf->smallBuf)
 		cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
-- 
2.39.5


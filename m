Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DD72628D
	for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 00:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784422266; cv=none; b=GY4DrQjd8fu/lV1GQKI6y3cVHoFbrY8t9x7EgObh8WR0OdMRdF3nTAUyllVrd0dDP7qPXyW3H0NkZYW0/jzny/bjfUtV6BS8ibOf30WwfZzGHrddDW5Eeqy/KO4Ht5ty/ssWnITby8qAoRhVjM99w8vbK5tppbfC2/+PEvZ1ea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784422266; c=relaxed/simple;
	bh=DwI3k1qYelCNgC8B8tVCTE7ap4gFa8ahnO7X2iI4jR4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CFFqrjLy2b4lBHrkekHlWWXpmDgA8SK0XCi6F3DQZXloCoz3wiXswz6C2vpNxkPB11qYSyNLWmi1gh8GBR80tr5yJSXz5ej+nv2rY+ykcuFMaKhUQJShKHCy7ANu50WDC9j4EfyjSZxIsm401jQ23Vvl6a5kiqWKRvJsuwwQNls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org; spf=pass smtp.mailfrom=jpartners.org; dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b=p0XTBz7L; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jpartners.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b="p0XTBz7L"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92b21f65b60so245481485a.1
        for <linux-cifs@vger.kernel.org>; Sat, 18 Jul 2026 17:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jpartners-org.20251104.gappssmtp.com; s=20251104; t=1784422264; x=1785027064; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FuPoKX80iSa8+vqkUxb6tpNNuxB7x3ly8/lB/7SMUK4=;
        b=p0XTBz7LupGtxcoaOURQaNyspITYsLNvxkyYB2keO88X4cZ4eRMO9fBotDe2hpKwLK
         LT5fyytzmDiRQgyu2KnyGbmTUYecuwNwreEjc/fWv4rojASxi134qkMiRhrlsNyr4K5u
         uTdeFTXv4Ez8hfcszgi4cVdvPNAZoVgYieW5M9L5b6jRnkZGRFcO9PY1nM73GWvxFxZq
         ddOKhR8ni7lMWB4zQyyeQFzjcCc6Dini6uiFhxtnOMPZu0Knh02a1+f5E7a++Hhh+h4m
         /gujpaGrf4W3Re6cuTAFPv3cmPFZ7JkEhyGKoT05/3E+O2tYaa49KAXnCZDXddBcPl01
         2VBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784422264; x=1785027064;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FuPoKX80iSa8+vqkUxb6tpNNuxB7x3ly8/lB/7SMUK4=;
        b=pO4yuNGYhJnpo9iEBMFVAdAm0WtsRc+UOLm5wQqq9Li+eA1jSTLGxXQcYg5dXeHl8t
         hVOoAHi6h5pDp5pZ3sMGo9mtoJg8vCUUGluEdIDTyLbhwV1lJLZQjKGC609TFEgd+T3Y
         TQgdTmt3b8fKXVWdCNbVRFR5NZCPQYQJBUe78AqwNOeW6TNezD4uteIcMH1bflYdIXa4
         w+IyDq4eTDN4ryv/H/y4kCJ6Ys0L0D7ZfhmsKD85e378KHua02Cr2tHDoWNxPNuBOq+N
         41MBucr3VBvFIpRLdpZozFxwE2Vy1tvN7s23s3pwruLkiRUXsru+e5eVXyU7jJtTMma3
         U1WA==
X-Gm-Message-State: AOJu0YwObqafaXmzlY/ov6hwNxS3I8xpTrYGdMJjNrEdkMJkW0i9YvFa
	u4wyv/CME48VkF1bBTECEhXpKsEb00MscVZDP2xPlbMHyXmmGrQjX7hyfmoPqOe2prTxt14un0w
	+jN39ga/v
X-Gm-Gg: AfdE7cmlCuhxRxDpL4cQCT6F0qHbCMW3LLoOotZoDJLs7Xcjm6xfhLa5mtrNCSvXYgo
	Z01bfEPwUpl0cSk3be3w5ZkBScjbxquG9s86YOjJcBsl/zba1cAJ23Bmp7lg9MgwjBWy9KQpktH
	nzMDkTby0uAohOMSv6KUErlmdm5FH1HNrs5LH4LWTcWjOc4y8AK8DPo+vxd/gBlX5wDqX3o8J36
	cjxpro3hlIiqkb/+ps43xiMp6PZpDiLJzuRr/uNb1S4cilMNEDHqetKuxbYsqvavoz5F19xqSCO
	5/z6FwOg96cTdV8VebL+fj67JXHvs2K2pxXmK5Y+H2p14+vo4aJr3r2qCz2Y43v6XVbXf2mVZ2K
	pLo0z+Pwwdm7nSQdmOc04tR9RbDpFQ9oB6418oTSIq90xkDDQMETfJr7ZVwUyACVZ8cF3decsts
	S+y3MU1DGPo+pTTDLgCdaEpjBXlu9eZTSw+oSwDqM6raonI1/nGq5MJOlYnF2cxA==
X-Received: by 2002:a05:620a:6606:b0:929:f78f:6bf9 with SMTP id af79cd13be357-930b4865dc9mr772927885a.16.1784422263497;
        Sat, 18 Jul 2026 17:51:03 -0700 (PDT)
Received: from localhost.localdomain (dsl-sb4-27.greenmountainaccess.net. [65.19.73.27])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b5494c02sm524575385a.45.2026.07.18.17.51.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 18 Jul 2026 17:51:02 -0700 (PDT)
From: Carl Johnson <carl@jpartners.org>
To: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Carl Johnson <carl@jpartners.org>
Subject: [PATCH] smb: client: handle STATUS_STOPPED_ON_SYMLINK responses without a symlink target
Date: Sat, 18 Jul 2026 20:50:45 -0400
Message-ID: <20260719005045.13125-1-carl@jpartners.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The macOS built-in SMB server returns STATUS_STOPPED_ON_SYMLINK for a
CREATE on a path whose final component is a symlink, but it does not
include a Symbolic Link Error Response in the error data: both
ErrorContextCount and ByteCount are zero, so the symlink target is not
present in the response at all.  Per [MS-SMB2] section 2.2.2 such a
response should carry a valid Symbolic Link Error Response, so this is a
server bug, but the target can still be retrieved with
FSCTL_GET_REPARSE_POINT.

Frame from a capture against macOS 26.5.2 (build 25F84):

    SMB2 hdr : Status=0x8000002d STATUS_STOPPED_ON_SYMLINK, Cmd=Create
    Error Rsp: StructureSize=0x0009
               Error Context Count: 0
               Byte Count: 0
               Error Data: 00

symlink_data() cannot find a struct smb2_symlink_err_rsp in such a
response and returns -EINVAL, which parse_create_response() propagates,
so smb2_query_path_info() bails out at

	if (rc || !data->reparse_point)
		goto out;

before it can retry with SMB2_OP_GET_REPARSE.  stat(), readlink() and ls
of any server-side symlink then fail with -EINVAL:

  $ ls -la Config
  l????????? ? ? ? ? ? Config.json
  $ stat Config/Config.json
  stat: cannot statx 'Config/Config.json': Invalid argument

A 5.10 client resolves these symlinks correctly against the same server
and share, so this is a regression for Apple SMB servers.

Handle it in several places:

 - symlink_data() detects the empty response (ErrorContextCount and
   ByteCount both zero) and returns a distinct -ENODATA, so that "server
   did not send the target" can be told apart from a genuinely malformed
   response and only this case is worked around.

 - parse_create_response() treats -ENODATA like
   STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not carry the target
   either: leave the reparse tag unset and clear rc, so the existing
   SMB2_OP_GET_REPARSE path retrieves the target.

 - smb2_query_path_info() only fixes up the symlink target type when the
   target is already known.  SMB2_OP_GET_REPARSE sets data->reparse.tag
   but does not parse the target out of the reparse buffer; that happens
   later, in reparse_info_to_fattr().  Without this check
   smb2_fix_symlink_target_type() is called with a NULL target and
   returns -EIO.  This could not happen with servers that send the target
   inline and therefore skip SMB2_OP_GET_REPARSE.

 - smb2_open_file() maps -ENODATA to -EIO, matching
   STATUS_IO_REPARSE_TAG_NOT_HANDLED, so its callers retrieve the target
   with SMB2_OP_GET_REPARSE as well.

Tested on Debian 13, kernel 6.18.38 (armv7), against macOS 26.5.2:
symlinks now resolve, including relative, parent-traversing and directory
symlinks, and reads through symlinks succeed.

Co-developed-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Carl Johnson <carl@jpartners.org>
---
 fs/smb/client/smb2file.c  | 21 +++++++++++++++++++++
 fs/smb/client/smb2inode.c | 23 ++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index cc1ff24..9bab3c5 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -30,6 +30,19 @@ static struct smb2_symlink_err_rsp *symlink_data(const struct kvec *iov)
 	u8 *end = (u8 *)err + iov->iov_len;
 	u32 len;
 
+	/*
+	 * Per [MS-SMB2] section 2.2.2, a STATUS_STOPPED_ON_SYMLINK response has to
+	 * carry a Symbolic Link Error Response, so ByteCount cannot be zero.  Some
+	 * servers (e.g. the macOS built-in SMB server) violate this and return an
+	 * empty error response, with both ErrorContextCount and ByteCount set to
+	 * zero, i.e. without the symlink target.  Detect this and return -ENODATA
+	 * so that callers can tell "server did not send the target" apart from a
+	 * malformed response, and retrieve the target with FSCTL_GET_REPARSE_POINT
+	 * instead.
+	 */
+	if (!err->ErrorContextCount && !le32_to_cpu(err->ByteCount))
+		return ERR_PTR(-ENODATA);
+
 	if (err->ErrorContextCount) {
 		struct smb2_error_context_rsp *p;
 
@@ -200,6 +213,14 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 			rc = smb2_parse_symlink_response(oparms->cifs_sb, &err_iov,
 							 oparms->path,
 							 &data->symlink_target);
+			/*
+			 * If smb2_parse_symlink_response returned -ENODATA then the
+			 * symlink_target was not sent. Treat this as if the SMB2_open()
+			 * failed with STATUS_IO_REPARSE_TAG_NOT_HANDLED status, which is
+			 * indicated by the -EIO errno.
+			 */
+			if (rc == -ENODATA)
+				rc = -EIO;
 			if (!rc) {
 				memset(smb2_data, 0, sizeof(*smb2_data));
 				oparms->create_options |= OPEN_REPARSE_POINT;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index e13bc8a..f1de849 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -896,9 +896,19 @@ static int parse_create_response(struct cifs_open_info_data *data,
 		rc = smb2_parse_symlink_response(cifs_sb, iov,
 						 full_path,
 						 &data->symlink_target);
-		if (rc)
+		if (rc != 0 && rc != -ENODATA)
 			return rc;
-		tag = IO_REPARSE_TAG_SYMLINK;
+		/*
+		 * -ENODATA means that the response was parsed but did not contain
+		 * the symlink target at all (see symlink_data()).  Treat it like
+		 * STATUS_IO_REPARSE_TAG_NOT_HANDLED, which does not contain it
+		 * either: leave the tag unset and clear rc, so that the caller
+		 * retrieves the target with SMB2_OP_GET_REPARSE.
+		 */
+		if (rc == -ENODATA)
+			rc = 0;
+		else
+			tag = IO_REPARSE_TAG_SYMLINK;
 		reparse_point = true;
 		break;
 	case STATUS_SUCCESS:
@@ -1091,7 +1101,14 @@ int smb2_query_path_info(const unsigned int xid,
 				rc = -EOPNOTSUPP;
 		}
 
-		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc) {
+		/*
+		 * If the symlink was already parsed in create response then it is needed to fix
+		 * its type now (after the second call with OPEN_REPARSE_POINT which filled the
+		 * data->fi.Attributes). If the symlink was not parsed in create response then
+		 * the data->symlink_target was not filled yet and then the type will be fixed
+		 * later after data->symlink_target is filled.
+		 */
+		if (data->reparse.tag == IO_REPARSE_TAG_SYMLINK && !rc && data->symlink_target) {
 			bool directory = le32_to_cpu(data->fi.Attributes) & ATTR_DIRECTORY;
 			rc = smb2_fix_symlink_target_type(&data->symlink_target, directory, cifs_sb);
 		}
-- 
2.50.1 (Apple Git-155)


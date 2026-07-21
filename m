Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852B46C4CA
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654883; cv=none; b=lqUlFCUCAMLT1YK+Ij85LIqiI6rA9mKwqWOUzn8EN0tJcLKBwygMuOC/m7PtXIRjtsNNOsN1zxv0pITO0PGWA0aNkEFjl1GgnsOeEO7IL3UYIvG6YlvGqatnStakC8rjw5Q55OBR5ZZQ/VowHvb05slZ4d+WVxm2f0Ss759iG6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654883; c=relaxed/simple;
	bh=Ie6NOd1NnYTYqYUpjyig9u0Ul7HuRj7iIAE0R6HcWEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QX57RhiCoR1Q66qM8l6VkSH4/Evdp1u01zJmN+yj+XeS5qDd9ZzPs36aO52vihu5UuPHa7WkywzTUlraBLczLbd6tOcHD5V3mBfzsY83Gu8rSFnG3bJRf8rDadWDOmCWmYSKWvRg3xr3h4o23T6pI94RpHelNg1GF2Jc8m2NW3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org; spf=pass smtp.mailfrom=jpartners.org; dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b=nF51JS1h; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jpartners.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jpartners.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jpartners-org.20251104.gappssmtp.com header.i=@jpartners-org.20251104.gappssmtp.com header.b="nF51JS1h"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9034b6b7674so95982496d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Jul 2026 10:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jpartners-org.20251104.gappssmtp.com; s=20251104; t=1784654878; x=1785259678; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2hQTP2KavQDzlrFx5Gn1jpse/wSy0U3NPlwuvNWbDh8=;
        b=nF51JS1hKpcoQct9IKTXzdw93SeXYEAQtGaHcfmf3X/6gdSW4DlQzQCLbHFvSLtqHy
         N3ftcqe8uHZMqhZ7KVimhot4StbWCtkw+aFgWW9eCtDa1/3vpng6jXnmdIEg/t92ywnr
         kH88iMpExLlshiJTm7O/fY/cx7oGsIf97xwebVUMe73iI2YgyY6NDXyzYCQUxp22kL67
         PZiC9dLMlboYtvUwm/7QdxOmljfID2wcJZPnN61L8h6Vn7vvzP68GwYDiFQf62st5s4O
         bVFGJCtQ5c0fhxfYYdGf17+NiDjGRFEonw+/JV1S8GpgjK09BGmnsZwDnZQvDXx9crra
         PfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784654878; x=1785259678;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2hQTP2KavQDzlrFx5Gn1jpse/wSy0U3NPlwuvNWbDh8=;
        b=gsr1YdPizXKWwiSUuor01NoKNfClLJwS6YwhJ5I4WJtbgOu5rtFD69Vd9sNAflOL6v
         AIA/ZBm8qgjxX/pJ5ICoPHNBa5LU57glnl0ULcg5rIsbFGBElec7g0g+n6vhskXMRWRd
         5P+gvDe4xnpk0zQZ3wAVBAa0D8QkCJqpxGwA3tuXslOS+t/9bsfHV9jhVMegnrwUToZ/
         akAPZuXN6LeAmRjfmqRM6xKr+9nvr1y52jU7FE9AmH/f1zunPTxl5qAHBt1LFTIukoCc
         olCDqad3Msug5LKSFdE0m0t1sK49sCr8UJwJmpFzNJvPczxJdcFiAcomeh3gGIGgK3W3
         pexw==
X-Gm-Message-State: AOJu0YxR9Nu0wTUMxwtBI+5L/3phv+Pv/L6sICDI1OVzb7Zvz7DXr28K
	FwTEL04UI6BzUcN9ESDcmIHpxoHs98w2a68Wzbc27mAwp/Lw0SNdxse+S0ItaHgUZ4LGuT9a8iw
	WZIii1TvC
X-Gm-Gg: AR+sD11JeTZ/1CfPVxGaivRINtDH/1/gLp+u74xWCCoQiv/wgkY2OLmVGgAIWrTmGLu
	8lZnHMLmZKgdEO89BHQPQNCtk5rC5d7gbeeGyxUCr2hU2uG0ezs6s3yrW9HPfggjZRL+KAFy1iy
	fBxFTxDpYJjs88Q37wwGA0lOuJY7LSg8gZIoiIJxOZyzDoxra3bdLdA+joKQM2CFxeZoXLF8mEV
	lzQX1PXwiLbhA7VQxEY5I8uRgNSBeXFiKDY6O+l0qNLwPJMSH6ao6vUxlKbLmsJ8aYkwEBlDDeg
	lQhBKMyAvKyAT6kyFiqarIrL+qADhosNL/CQ6oH7mQYicMGH1ZZ8mE2fN8DAOYQP3ImqYGdJFI7
	RZBFecpm+bFtju9JZ26SQchog++aA9abAbKVjnuHt5+1CLLzFuaJttIfPw4NxR9T4k8Y4AO7bxb
	X0ffb4T8qr+0xTSj/i3pfoYhwnksoUvGyPWxSr1789UwTGt677f55hJ665URslLjc=
X-Received: by 2002:a05:6214:2349:b0:8ef:6b06:44c8 with SMTP id 6a1803df08f44-907783d1d3fmr199193986d6.48.1784654877639;
        Tue, 21 Jul 2026 10:27:57 -0700 (PDT)
Received: from localhost.localdomain (host3.lewism-gw2.cust.sover.net. [216.114.153.211])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907baa27361sm802466d6.43.2026.07.21.10.27.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Jul 2026 10:27:56 -0700 (PDT)
From: Carl Johnson <carl@jpartners.org>
To: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Carl Johnson <carl@jpartners.org>
Subject: [PATCH v2] smb: client: handle STATUS_STOPPED_ON_SYMLINK responses without a symlink target
Date: Tue, 21 Jul 2026 13:27:55 -0400
Message-ID: <20260721172755.41346-1-carl@jpartners.org>
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
v2: rebased onto cifs-2.6 for-next; no functional change.  v1 was generated
    against the 6.18.38 stable tree and did not apply to mainline/for-next.

 fs/smb/client/smb2file.c  | 21 +++++++++++++++++++++
 fs/smb/client/smb2inode.c | 23 ++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 5ef919b..f35b648 100644
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
 
@@ -199,6 +212,14 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
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
 				memset(&data->fi, 0, sizeof(data->fi));
 				oparms->create_options |= OPEN_REPARSE_POINT;
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 6c9c229..213bc29 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -792,9 +792,19 @@ static int parse_create_response(struct cifs_open_info_data *data,
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
@@ -987,7 +997,14 @@ int smb2_query_path_info(const unsigned int xid,
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


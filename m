Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F893C38
	for <linux-cifs@vger.kernel.org>; Tue,  3 Sep 2024 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371619; cv=pass; b=gVGd5I0TRxITh7eLXTuuhoIOzUtG8mRVcq7T/5/3w1d854EFiaepp6yR44AzRjv1kbg2hoaPzZXUeUcxC/fRqLLu7nm8NBOlrctSZeKnNs4isOUDPPs9nbHlWI0daIMG3Vr/Rt+9VW8jmReg8tw8q4VCvKQLO5RSxjBVsn97ek0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371619; c=relaxed/simple;
	bh=PF5O0NY0mtUjt/LqfNIhkHz4TAoYn5Mfaf6lHvKer3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iBexIoX4kqITWdvcXrRnYq1S7pHJCAwT0aFiwD5KyeqXdnKAXuw8ESUw3nwmx0xV5VH5FNkTRSSz3oS9zw98uMNKB2hzOkwlZQgIedksmHXS2DIPrA9IR8KZ7AS6XY3Ck78iIwxmvzQuUtLTkK2ivdSlfSbUO6HmWRh4XN3KU28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=AUpgg4jy; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="AUpgg4jy"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725371609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E8AP70m+p1WieObQdRO6huFOmQl1UPGwHhM8R0qCZUk=;
	b=AUpgg4jyHzSEwPoTPsQTONkE08vap3VKbD1tTX1+l1VMhBwS08pKgrPqnqABEuB5tG+dbU
	c3uTZcNnPhwJd5wyC7YjyEIkxTMQtpGkqk/b1O3HjDtc/OXPDc+ApyG/D2gOk7qhUsE5Nt
	k95tx0kx3Hc4prh3CrwsXZ/6bzPlq6L2nZd8DFH+aXV/tlu2MXEvHZIHYP/1HChSgzEigl
	r/kZun+3dVGoP6wl6MHGtkzJIV3B9t8amqGRfDLnJx+y3dahXQtts4kSa9N1yHSzQSRmQL
	x4OmvVQiHCSrMPou3GqjBCwvzqOJeJ+pa/7eU6/OiXoN3knI/hJYw9Cjxs0uZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1725371609; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=E8AP70m+p1WieObQdRO6huFOmQl1UPGwHhM8R0qCZUk=;
	b=UVq45PKt+5C0JsBO5f0AfkIGVi9aLkZrolJx4xlCqOtwr/ntOcXOHTU3l/sU9t55AkOU8U
	xFjRdWLUXcWicnUudM8J0JXL9uwuVcNpjrEMpblzIoz1GiUqQShWq1UT4PpUjRsR2r4/fd
	9DZWkpcypKV6SFMHxguvSkTcrhF90egrZGAQWxef7jcEmZqZbUPHydf9lju+hgUlTq7b26
	YefakkvrUiQfoZHyZYF+AQous1DcME3a4XyuuacnVU6t0f5F4yR34GwJLL6rMd3iKMRc22
	s0w1cLFQ04JTNcmOFu4QUtcoNVjRnNRbgGVe08lu2Vd1+0K0WBgtq7PZGmck5w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1725371609; a=rsa-sha256;
	cv=none;
	b=J7sJiPTWGUNGCN1y9PxFTd8fPcpgnT6PCZjckSqBzeCrgp2Pab+1kVCZ/tGiQGJPUk4pC3
	vrGlivvuQGVMA5nGBCpAKxnwz4+XkckmtfHBGzIX0Gk0pOZIhLks330qr5qW2+DC2elJtm
	dtTYRBXyjXgVdWsaTTCY6WMMV5JbCFVubbBalnxGfERLNBIZQQSBq5pYWSNYxEjSY+tRqy
	MIQ1U/Wdcu1mgYlkXTVJuFWEIbFuBBIod2yJAauyYFaM53DbH5GLXkypld1dIRdiPZK3lm
	83NAKk2+MY4fwVgsgZ/a/xYkBBP2JvEKgEH7ueIYaXfWQxfD74ijV1jBFDdOLQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] smb: client: fix double put of @cfile in smb2_rename_path()
Date: Tue,  3 Sep 2024 10:53:23 -0300
Message-ID: <20240903135324.887150-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If smb2_set_path_attr() is called with a valid @cfile and returned
-EINVAL, we need to call cifs_get_writable_path() again as the
reference of @cfile was already dropped by previous smb2_compound_op()
call.

Fixes: 71f15c90e785 ("smb: client: retry compound request without reusing lease")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Cc: David Howells <dhowells@redhat.com>
---
 fs/smb/client/smb2inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 9f5bc41433c1..e3117f3fb5b2 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1106,6 +1106,8 @@ int smb2_rename_path(const unsigned int xid,
 				  co, DELETE, SMB2_OP_RENAME, cfile, source_dentry);
 	if (rc == -EINVAL) {
 		cifs_dbg(FYI, "invalid lease key, resending request without lease");
+		cifs_get_writable_path(tcon, from_name,
+				       FIND_WR_WITH_DELETE, &cfile);
 		rc = smb2_set_path_attr(xid, tcon, from_name, to_name, cifs_sb,
 				  co, DELETE, SMB2_OP_RENAME, cfile, NULL);
 	}
-- 
2.46.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FF01FB3;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321275; cv=none; b=PM8/v+xe65zFmC6q/0yWwKqIVmBqPieD3w+j17uKYOk3aXjec29DJ1kVmi1lrMn6OpHIxgwG7qjWJ8Q9JzVRjgf3PNvgD0ROEpXMuqmBr2uLaVCEKCvQdRFicAU91VZQTMwPM8gGhUevKc2Pd6xSMpcYIn1p2Ah4DavKnorzoF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321275; c=relaxed/simple;
	bh=//4iYvXKNpfAG6CivVoeK2jZUVPirzXhdrGkqfqgO5M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hh5PKkaPnan9ewt+ieHYrJIV/1dJcaEekbeJ6OK3yYgrzFnBlzJSxodKprlMnLaO+Dshw6AwD+UDstsXIfA9ynIzgjexkd0+RhMYuPUYT5jJSJp/oXrkV5VmKPzJIcnKgn6E/73s6Il28OktIw41f4sSGxmC76TECJnWUEVyiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDOstlls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDOstlls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D940C4CED3;
	Fri, 27 Dec 2024 17:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321275;
	bh=//4iYvXKNpfAG6CivVoeK2jZUVPirzXhdrGkqfqgO5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDOstllsfdGCjkKG/9EHqwdJDKtksNZWNjx2bvBrmNiaXq2A9SX4OdAvl05wiSt0P
	 HK3b+utENhXL4arnefBBKXgav2J7cbOI78Dkko3+2+VKxV+gksOCA6CjCsxis8rn53
	 Rk9f07gz4IanQ1qT2FuzPkek5n5OnjsUqPdejcmEI53RpgCYR1b8nc7YelREopsb1C
	 YGXiZmAAQ3g7TCe1v3EaABdzatwCZbY7BCziLODqxOc3A2FImExeOICZqTn1N5q7kY
	 g6NW73TyRcZSvyQHUq7VnNPtHTf/cwTNRS9MZHb7qXGjX8ZjrNCGDKe7E7gB1KmK2o
	 qRup3YSBwLuzA==
Received: by pali.im (Postfix)
	id A7A35A7C; Fri, 27 Dec 2024 18:41:05 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cifs: Fix validation of SMB1 query reparse point response
Date: Fri, 27 Dec 2024 18:40:46 +0100
Message-Id: <20241227174047.23030-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227174047.23030-1-pali@kernel.org>
References: <20241227174047.23030-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

NT_TRANSACT_IOCTL response contains one word long setup data after which is
ByteCount member. So check that SetupCount is 1 before trying to read and
use ByteCount member.

Output setup data contains ReturnedDataLen member which is the output
length of executed IOCTL command by remote system. So check that output was
not truncated before transferring over network.

Change MaxSetupCount of NT_TRANSACT_IOCTL request from 4 to 1 as io_rsp
structure already expects one word long output setup data. This should
prevent server sending incompatible structure (in case it would be extended
in future, which is unlikely).

Change MaxParameterCount of NT_TRANSACT_IOCTL request from 2 to 0 as
NT IOCTL does not have any documented output parameters and this function
does not parse any output parameters at all.

Fixes: ed3e0a149b58 ("smb: client: implement ->query_reparse_point() for SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 83365861a99c..ff8633fde85c 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -2720,10 +2720,10 @@ int cifs_query_reparse_point(const unsigned int xid,
 
 	io_req->TotalParameterCount = 0;
 	io_req->TotalDataCount = 0;
-	io_req->MaxParameterCount = cpu_to_le32(2);
+	io_req->MaxParameterCount = cpu_to_le32(0);
 	/* BB find exact data count max from sess structure BB */
 	io_req->MaxDataCount = cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
-	io_req->MaxSetupCount = 4;
+	io_req->MaxSetupCount = 1;
 	io_req->Reserved = 0;
 	io_req->ParameterOffset = 0;
 	io_req->DataCount = 0;
@@ -2750,6 +2750,22 @@ int cifs_query_reparse_point(const unsigned int xid,
 		goto error;
 	}
 
+	/* SetupCount must be 1, otherwise offset to ByteCount is incorrect. */
+	if (io_rsp->SetupCount != 1) {
+		rc = -EIO;
+		goto error;
+	}
+
+	/*
+	 * ReturnedDataLen is output length of executed IOCTL.
+	 * DataCount is output length transferred over network.
+	 * Check that we have full FSCTL_GET_REPARSE_POINT buffer.
+	 */
+	if (data_count != le16_to_cpu(io_rsp->ReturnedDataLen)) {
+		rc = -EIO;
+		goto error;
+	}
+
 	end = 2 + get_bcc(&io_rsp->hdr) + (__u8 *)&io_rsp->ByteCount;
 	start = (__u8 *)&io_rsp->hdr.Protocol + data_offset;
 	if (start >= end) {
-- 
2.20.1


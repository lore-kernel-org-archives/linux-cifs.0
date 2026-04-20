Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC846331A78;
	Mon, 20 Apr 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700399; cv=none; b=bawy+7wc+ipVu0OWhQCpYXk40Z6wh/E0O8XNbSNPYtgF8PbmbbBTF6bKch/366yOiGO5AGw+jLr8NxnnOIuuxcLkan5u5CpvRBO7fAmD17iiAESHlb/Vo5NzvAlZL4dzgcG57HWLXDSz9SrcrOlVnMsQP/CdmY8ZFhRQdeqeIZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700399; c=relaxed/simple;
	bh=x39GDkHcmHPimkenSRbNN6UBuHy6N73oEspqX7F37NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gnr1cLyh6fN1DGe3Dwv6wYDgG0Wt67ld4NfUY+LE4PCk7lAMob2SPbGjXb4a6NmgmDUi7TujmUb8pZo+kLoZVZXia0BsAcJ6FScfSowzAWDtOSTcyBiLaotGemZFIcVRFF94nLCmU6xsSfxvMTOhEuXeeqlLsv/lijMC7p2lFHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niAnYraS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niAnYraS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63802C19425;
	Mon, 20 Apr 2026 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700399;
	bh=x39GDkHcmHPimkenSRbNN6UBuHy6N73oEspqX7F37NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niAnYraSt91+2VMyW9GmZyoWJdPUNRWrlQfpE8wc9q3a4w8Ml7vlKiMZ9JzWcldMm
	 K6PdkEkNPTVUy18PqULskUF71vx00JioNp4HwvsLTLXfAxVT5OTyw/1nvTM4lANOWG
	 GqjtlBvzdzwSKbolaRqhcCwsdngtERFL3IXV5TBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.19 158/220] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Mon, 20 Apr 2026 17:41:39 +0200
Message-ID: <20260420153939.716968248@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 66751841212c2cc196577453c37f7774ff363f02 upstream.

smb2_get_ea() reads ea_req->EaNameLength from the client request and
passes it directly to strncmp() as the comparison length without
verifying that the length of the name really is the size of the input
buffer received.

Fix this up by properly checking the size of the name based on the value
received and the overall size of the request, to prevent a later
strncmp() call to use the length as a "trusted" size of the buffer.
Without this check, uninitialized heap values might be slowly leaked to
the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4715,6 +4715,11 @@ static int smb2_get_ea(struct ksmbd_work
 
 		ea_req = (struct smb2_ea_info_req *)((char *)req +
 						     le16_to_cpu(req->InputBufferOffset));
+
+		if (le32_to_cpu(req->InputBufferLength) <
+		    offsetof(struct smb2_ea_info_req, name) +
+		    ea_req->EaNameLength)
+			return -EINVAL;
 	} else {
 		/* need to send all EAs, if no specific EA is requested*/
 		if (le32_to_cpu(req->Flags) & SL_RETURN_SINGLE_ENTRY)



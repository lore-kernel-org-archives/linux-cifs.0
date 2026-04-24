Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78FA19A288;
	Fri, 24 Apr 2026 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037929; cv=none; b=lxlqlymdK3TD2jsYLvlN8xfWXAFKV/MIVi8WujQFMHh4xiMvCwz361yLE+zQibl3SDwQ9BZ4HUbpzMTccahH+R+dFh11us7cnIPykfGJTHGe/CMEWO1uPAgfEiT8z/c44ar2sX26NzPd6Ja0/CTHxnl+iMyobvezuimSKuj9fEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037929; c=relaxed/simple;
	bh=Ua/ALm9A9GarjXHckxsD8hTsLUda4YJSltnLyhejMeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/8Cc7n6SFtFLHXO97XRN8lBpGVvsyN1RSBwG2XXy5xrZPT6Ctsc7lDZUrgQIkQ1mTVFahgEcn3eOxjKxVysiUuVxAaQqaTv+Q2sez27GuuoZ+QmHvpVb3QALLQGpkQJanJ7nl5mNtaDB5f5vx3xqX+Zcys/nO2TZXFBitGAJv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ej7M6EPE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ej7M6EPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0B2C19425;
	Fri, 24 Apr 2026 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037929;
	bh=Ua/ALm9A9GarjXHckxsD8hTsLUda4YJSltnLyhejMeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ej7M6EPEI2UAkbLRjGGEztaW0XJNkN4uCgVqWH8+F+oahyl3Dnk558ZOkBSW0YlRQ
	 Lhgxktl4ulWmdRnpkj4gQa8yC4q42TQ+DdP1sPym3W1II99YYmw2CHrM/XtFWFQyyf
	 1upIyoLGx2UZ31GAD0Y8TnMAfTFfARQXKqW62me0=
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
Subject: [PATCH 6.6 082/166] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Fri, 24 Apr 2026 15:29:56 +0200
Message-ID: <20260424132549.980479730@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4702,6 +4702,11 @@ static int smb2_get_ea(struct ksmbd_work
 
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



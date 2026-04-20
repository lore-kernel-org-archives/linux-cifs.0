Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9278D341AD6;
	Mon, 20 Apr 2026 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701424; cv=none; b=LAAVu+5o3o6Jo5O9QUwcuoF8AIa7uk14t25xUR4HF7eKQ3uv6twfqiJFfxXBJLkDaeiKXCNsl4yTmoZ/UWGF78beqAexx/V27rt5fRt0ARAhSU6xmq8K8kqtCApafZcpJihsFOhccuCFnPU+Fuqj1Y3OSqGhRMPJL+1gF8NvBiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701424; c=relaxed/simple;
	bh=RfIgBfWFfR04b0QyiGIAjdVceRlCx2Dz0B4J7Czz0RQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZq7nqBIxe9XDrU8QxEwKL+l7N5wsF+wIBi+7LTuebk8gHxOOYLvQXYWilue4leVCFCxC9d6wnHxVviWdzBA3MC1F+jjuce2jB7e9jWFxWM8qX9aDkxxQloFu3qZ1jZhDJdT+0vpZPRuVX8WulDEaqyi9O0h5Gls6K6MIr/Dw1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSA2wYpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSA2wYpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298F4C19425;
	Mon, 20 Apr 2026 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701424;
	bh=RfIgBfWFfR04b0QyiGIAjdVceRlCx2Dz0B4J7Czz0RQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kSA2wYpUQAx0VberUHc+grjcLwcNYBMCF4pXCi43TYnV/6BaldOOdqc+wBsZFBPaA
	 1O3TKzk4ug8gjIc/4bb63lcPO9FWZMC9EUGFFQXd6dn1OEwe6ijTUs3Z1bx8DxNDbu
	 5u0gANPkRZNOK8F+uIcWFvze++LzDfvOO23JHuL4=
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
Subject: [PATCH 6.12 108/162] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Mon, 20 Apr 2026 17:42:20 +0200
Message-ID: <20260420153930.953107782@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4728,6 +4728,11 @@ static int smb2_get_ea(struct ksmbd_work
 
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



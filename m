Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558D054FB1
	for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709047438; cv=none; b=aOqmsOZJj7xQHfEdwkVf0+BfR/UsiDuio43aU6GwQRFX59e7Cs8Hc9sicrNbY8iaVjfZGfNmXpI/BOY8S41h4SneR/BJr1AdJF+732I1pyN78FbSsiwiv5gJN9khh/KWnN5uHzk8KouDvoEojRL2Wg7gSSmCNiOBdY0GHJOSISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709047438; c=relaxed/simple;
	bh=B7NoCc2yXpna3QNmZyF4Xk7Zd0ejE97S2NBOwTiicmE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Zpf4GsxExS89+xgkeM7nqaQii6jUBmM8vsnx8eT+nFJGr5TP9bC5hvD0MVr3ZW68iIglXuLoI3JqFapx3H4pHd8PDmUW0uw3fE53myyTCENfem779tEn45YFkmRt39U4wKgN7xe3wTtGSOGDtTgswqSaNYA1Om/UgC6fOspD61E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=br3GmiAd; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="br3GmiAd"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-412a14299a4so22658385e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 27 Feb 2024 07:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709047435; x=1709652235; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CkT+3PCH4HA+LgSVwf+s4ecbaGZq1qd3r50SNFzDNAE=;
        b=br3GmiAdI2H7HgGy6sYPQN2fbT8xL79oX765FkALaKk5Vd6uCB32k5scEs2qCpq7Iq
         YPcPv2vrSYrvarERZMLnI+TyHc5p8bZN2x0dimQ+qBeYR6refa/F50Z6slvVCoVDsMZz
         eG52o9k4xhKW0HjNqSdrMoKSC1VS2tRCSd4Zu4jei+6rlxfcnFCAEQKzEsTLzDhaMZBH
         b2l8SoUhVsUQlvihHFgl0gQkCd5nfHA98PfMNjZW17mkc1VmNXVGldYIE1Z8dev9CjWI
         ygs/czinN1uWKRvk5OzVrr2r2WCavbsuck93GAYXh1IRvAYNzLhdDBr1gtwrS4mXIh8s
         pkuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709047435; x=1709652235;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CkT+3PCH4HA+LgSVwf+s4ecbaGZq1qd3r50SNFzDNAE=;
        b=Q1yPqVbmKWWkLpjD3I2ukQFheZTadJovYQ+gZxeoyWqqmA6/x3jCBlgGdw2mQHB0Ja
         MzYTZ4MP3T6uCKj+9PafbPzV99cW7FbHAOjQTWvAcuzGLtFN5cvJo5I9z34uou0N2o+w
         m3N1KdkbizV3EpCprhty70mbu8upU+7EZd0pTguY+1i7+2KkK/GTtv5lD3+5X9PpSVfX
         B65fDTkRxys/n3Lt8y6Q698jI7cxQcG/cW0FOXURsQsmuHtVaqiqGuyaBhDoq4sx6Gnb
         iDjKl0IVont63pCbRdac9rD2gjcgwxLtWkKjJoq4Z3D0axAfMUvnScMSQ33hA4CiX4Hj
         HRTA==
X-Gm-Message-State: AOJu0Ywjrb2M3ohTi/MoUQKoeltiJ4Ia3HapNE4yR8hx9qdmbxYaDZhZ
	3vN5J0om5LEOzoK0XEhrFmkY8QXnudWd8YU+0ZLIB6mb3wh2EcUpyWPIhog2c9E=
X-Google-Smtp-Source: AGHT+IFS1IGWR17SzRNSGQkwkJZbB5Jj6fgtlDRisQOoa84e0H+OTNjuZdAbOGL/QTx1JzSixDs/MQ==
X-Received: by 2002:a05:600c:4f86:b0:412:8814:9885 with SMTP id n6-20020a05600c4f8600b0041288149885mr7931676wmq.4.1709047434712;
        Tue, 27 Feb 2024 07:23:54 -0800 (PST)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id hg26-20020a05600c539a00b0041297d7e181sm11703755wmb.6.2024.02.27.07.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 07:23:54 -0800 (PST)
Date: Tue, 27 Feb 2024 18:23:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: msetiya@microsoft.com
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] smb: client: do not defer close open handles to deleted
 files
Message-ID: <eb0bd6c4-07a9-4f23-b857-2367835cb8ef@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Meetakshi Setiya,

The patch 05211603b73a: "smb: client: do not defer close open handles
to deleted files" from Feb 9, 2024 (linux-next), leads to the
following Smatch static checker warning:

	fs/smb/client/misc.c:871 cifs_mark_open_handles_for_deleted_file()
	error: 'full_path' dereferencing possible ERR_PTR()

fs/smb/client/misc.c
    860 void cifs_mark_open_handles_for_deleted_file(struct cifs_tcon *tcon,
    861                                              const char *path)
    862 {
    863         struct cifsFileInfo *cfile;
    864         void *page;
    865         const char *full_path;
    866 
    867         page = alloc_dentry_path();
    868         spin_lock(&tcon->open_file_lock);
    869         list_for_each_entry(cfile, &tcon->openFileList, tlist) {
    870                 full_path = build_path_from_dentry(cfile->dentry, page);

build_path_from_dentry() can only fail when the name is too long.  I
don't know if that's possible here...

--> 871                 if (strcmp(full_path, path) == 0)
                                   ^^^^^^^^^
This is the dereference Smatch is warning about.  Feel free to ignore
this warning if it's a false positive.  These are one time emails so
it's not a huge stress situation.

    872                         cfile->status_file_deleted = true;
    873         }
    874         spin_unlock(&tcon->open_file_lock);
    875         free_dentry_path(page);
    876 }

regards,
dan carpenter

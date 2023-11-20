Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="igEw89tg"
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1915ECA
	for <linux-cifs@vger.kernel.org>; Mon, 20 Nov 2023 03:33:43 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-40838915cecso15015745e9.2
        for <linux-cifs@vger.kernel.org>; Mon, 20 Nov 2023 03:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700480021; x=1701084821; darn=vger.kernel.org;
        h=delivered-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fs61Zyqtl8RiwGd/Qwpq0Eq8JZ08z+qR/ljCWMxQk9c=;
        b=igEw89tgbicBmvE0dmYh915vvi9oWIKRXMsQVpJEL0WeXB4a6nmvlULadI5RCYrji0
         1xZY6UsZU9+t64aI/o+Lvwj/Lq1jEOV7IiTgHRcKm6PTcFgRheqxxCVm3yrzugY4tHH2
         r3pTEyxwyyrcgODJlECuvWBJxAcVViC6oAjvRPuBKntgQobEaK0nkoJ9DYhKWVGSOaNs
         GEdaw844NzF1RyNHx3lwvn+l/aXBSKJYc4PcxixbtAshH4MynXULENnlrIct9POlhILy
         Qs+wgzns6znp0CKRGTCWd1dKk1rSYx2NFquD8J8o3JPH+wICCztRmBur4UQxKIAqCqpJ
         fQSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700480021; x=1701084821;
        h=delivered-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fs61Zyqtl8RiwGd/Qwpq0Eq8JZ08z+qR/ljCWMxQk9c=;
        b=ZrPq9l+xyBEWryhIfUEZzgvbPc3cAdpISuxd/7gNNTCUP/za7NEVZffU8KTbYT73ic
         JQstk3U7mwM2mOmGEMgsE9UfaMX3TZ+pq0zFOiFsIgj1GhdXjt4naoZbQ/gg1Zc7NgHM
         8KHbb8HDOiaSoN3SH5XVeHUEiax7D7yYARTscLLCoFYFSf9uzFm9xMtBj65mfxAm363f
         c9or+PbmZfHMBD+9NgDxdVxXXAsHKQMErPFAyRmoWMUIqRxQL+q4DqddVqL/fWWTjV2k
         jCCnEGC/nNiDvgU9ptWsw6DlXuUz8UR8KWwKUos4TqE+Q4mJDj3PcRpop9qpBQQUiIQT
         Tvbw==
X-Gm-Message-State: AOJu0Yzr/ZaLoFal5U7b4OErPGa8vepWCq4fyRzb2e+hibp4coWiBiw7
	fXJf3fYjtcZmwVfRVFnR2ZLtvg==
X-Google-Smtp-Source: AGHT+IHvJRlSE9rLXuTs8KamcZydWqt0EnB34IkJRlIRX76ozZnhif74wiG08n7mVNlW6EcEL6wbKA==
X-Received: by 2002:a7b:c8d6:0:b0:409:7900:f3d0 with SMTP id f22-20020a7bc8d6000000b004097900f3d0mr5798594wml.34.1700480021452;
        Mon, 20 Nov 2023 03:33:41 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w8-20020a05600c474800b0040836519dd9sm13320664wmo.25.2023.11.20.03.33.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 03:33:41 -0800 (PST)
From: Dan Carpenter <dan.carpenter@linaro.org>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 20 Nov 2023 06:33:38 -0500
To: oe-kbuild@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>
Subject: [cifs:for-next 8/13] fs/smb/client/sess.c:323
 cifs_disable_secondary_channels() error: dereferencing freed memory 'iface'
Message-ID: <539918b1-f4bb-4637-8bb4-057e5f1290f8@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   fd2bd7c0539e28f267a84da8d68f9378511b50a7
commit: aa52cd09620b0ebd34ccae0e7f9f5b773497a499 [8/13] cifs: handle when server stops supporting multichannel
config: i386-randconfig-141-20231108 (https://download.01.org/0day-ci/archive/20231111/202311110815.UJaeU3Tt-lkp@intel.com/config)
compiler: gcc-9 (Debian 9.3.0-22) 9.3.0
reproduce: (https://download.01.org/0day-ci/archive/20231111/202311110815.UJaeU3Tt-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202311110815.UJaeU3Tt-lkp@intel.com/

smatch warnings:
fs/smb/client/sess.c:323 cifs_disable_secondary_channels() error: dereferencing freed memory 'iface'

vim +/iface +323 fs/smb/client/sess.c

aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  298  void
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  299  cifs_disable_secondary_channels(struct cifs_ses *ses)
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  300  {
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  301  	int i, chan_count;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  302  	struct TCP_Server_Info *server;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  303  	struct cifs_server_iface *iface;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  304  
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  305  	spin_lock(&ses->chan_lock);
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  306  	chan_count = ses->chan_count;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  307  	if (chan_count == 1)
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  308  		goto done;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  309  
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  310  	ses->chan_count = 1;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  311  
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  312  	/* for all secondary channels reset the need reconnect bit */
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  313  	ses->chans_need_reconnect &= 1;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  314  
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  315  	for (i = 1; i < chan_count; i++) {
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  316  		iface = ses->chans[i].iface;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  317  		server = ses->chans[i].server;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  318  
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  319  		if (iface) {
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  320  			spin_lock(&ses->iface_lock);
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  321  			kref_put(&iface->refcount, release_iface);
                                                                                                                   ^^^^^^^^^^^^^
Freed if last reference.

aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  322  			ses->chans[i].iface = NULL;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13 @323  			iface->num_channels--;
                                                                                        ^^^^^
Dereference after free.

aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  324  			if (iface->weight_fulfilled)
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  325  				iface->weight_fulfilled--;
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  326  			spin_unlock(&ses->iface_lock);
aa52cd09620b0e fs/smb/client/sess.c Shyam Prasad N 2023-10-13  327  		}

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


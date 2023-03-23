Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C8DC6FD1C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 09:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjCWJky (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 05:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbjCWJkv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 05:40:51 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D451723
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 02:40:50 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id l15-20020a05600c4f0f00b003ed58a9a15eso653625wmq.5
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 02:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679564449;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1dc71n6w+9AtXwX5pmfSAmpwLU8+6HzhreJnHCiNOl8=;
        b=LpwYyvVRlpx2YviORmEEynV/lkdNjscom47lUIw72AmtLtD2yLdk3LC5tm3f7orYR4
         g/4Qj+0QMOkUn1agFDxdAGur3PaQs3MXyWKIc+SJniiZbJs3TseNiExiysfIthgDG6DU
         464uIQkXK781/x32Ryds40ayR+RfA0M+YtGlfj5zI7O4LJandJzwBKrpBnmyBRsDE+YH
         95pZgj58QMsh+Dq9k3Tj5D7D5sk5snr2Jw13aZVFbYf3LA+Hxi/E5M+qLOrhmOk1O4rx
         EgzXRD3ITDqjFqgl+GOjzKXY3BAJPLViUwckbX82Dzom9Ile9MQFf0+tbSOskK7tlF/g
         sIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679564449;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1dc71n6w+9AtXwX5pmfSAmpwLU8+6HzhreJnHCiNOl8=;
        b=SNc9153m6mvTqZ6EVH2sf3dkshxPVz1Fp1Z6tuTWtNEjU/IKwWK5WZ4h4q+ypPLfyc
         xCDLv9R/XSPinN3AIqg8VZoydZVgda/lbR6oKCAX2naVIqIr8ZvmdE3UFuwzb2jjA7Nb
         HUlZFaXimbcllgp97P1Gu4c8PNVP/FCi+5IoyuRopbBD9FwWo/KkG9SHkTgbkzWoYBCi
         aZ+pxOzwvCOTcudtKHqNNBiHtjPXQjSGuN/B2AVCR9NWRvYC9pauiz/0Hp22As+RLNCl
         I2lwM1PpiXo9l8Qt0Sa6WgLjZlGJbqTCDPnuf7Z1EziCXeQHaLd7AqluZXbVESqRN6+z
         pRFg==
X-Gm-Message-State: AO0yUKVth+F0h8t5jBO50es1Dg3PoYa4mfnCWmrwjmB2li9tpdXfSHQs
        CLA3+7iHDKUD/6Dik6l1Le4kAPE1GoA=
X-Google-Smtp-Source: AK7set+z9Ru9H1vQo7mn/7dqfLJ3GZKc/ihGqVjV6GE7VqDuvOO+r2UZ4eTj1lsv/azheLhF+UQaTw==
X-Received: by 2002:a1c:f418:0:b0:3e2:2467:d3f5 with SMTP id z24-20020a1cf418000000b003e22467d3f5mr1735229wma.25.1679564448781;
        Thu, 23 Mar 2023 02:40:48 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 14-20020a05600c024e00b003ed2384566fsm1354616wmj.21.2023.03.23.02.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:40:48 -0700 (PDT)
Date:   Thu, 23 Mar 2023 12:40:44 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>,
        "Paulo Alcantara (SUSE)" <pc@manguebit.com>
Subject: [cifs:for-next 3/8] fs/cifs/connect.c:1303 cifs_ipaddr_cmp() error:
 memcmp() '&saddr4->sin_addr.s_addr' too small (4 vs 16)
Message-ID: <13de0bf0-aa74-46a3-8389-3c70fe77be1f@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   96114df697dfaef2ce29c14089a83e4a5777e915
commit: 010c4e0a894e6a3dee3176aa2f654fce632d0346 [3/8] cifs: fix sockaddr comparison in iface_cmp
config: i386-randconfig-m021 (https://download.01.org/0day-ci/archive/20230323/202303230210.ufS9gVzi-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202303230210.ufS9gVzi-lkp@intel.com/

New smatch warnings:
fs/cifs/connect.c:1303 cifs_ipaddr_cmp() error: memcmp() '&saddr4->sin_addr.s_addr' too small (4 vs 16)
fs/cifs/connect.c:1318 cifs_ipaddr_cmp() error: memcmp() '&saddr6->sin6_addr' too small (16 vs 28)

Old smatch warnings:
fs/cifs/connect.c:1303 cifs_ipaddr_cmp() error: memcmp() '&vaddr4->sin_addr.s_addr' too small (4 vs 16)
fs/cifs/connect.c:1318 cifs_ipaddr_cmp() error: memcmp() '&vaddr6->sin6_addr' too small (16 vs 28)
fs/cifs/connect.c:2937 generic_ip_connect() error: we previously assumed 'socket' could be null (see line 2925)

vim +1303 fs/cifs/connect.c

010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1279  int
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1280  cifs_ipaddr_cmp(struct sockaddr *srcaddr, struct sockaddr *rhs)
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1281  {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1282  	struct sockaddr_in *saddr4 = (struct sockaddr_in *)srcaddr;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1283  	struct sockaddr_in *vaddr4 = (struct sockaddr_in *)rhs;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1284  	struct sockaddr_in6 *saddr6 = (struct sockaddr_in6 *)srcaddr;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1285  	struct sockaddr_in6 *vaddr6 = (struct sockaddr_in6 *)rhs;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1286  
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1287  	switch (srcaddr->sa_family) {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1288  	case AF_UNSPEC:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1289  		switch (rhs->sa_family) {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1290  		case AF_UNSPEC:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1291  			return 0;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1292  		case AF_INET:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1293  		case AF_INET6:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1294  			return 1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1295  		default:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1296  			return -1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1297  		}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1298  	case AF_INET: {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1299  		switch (rhs->sa_family) {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1300  		case AF_UNSPEC:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1301  			return -1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1302  		case AF_INET:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27 @1303  			return memcmp(&saddr4->sin_addr.s_addr,
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1304  			       &vaddr4->sin_addr.s_addr,
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1305  			       sizeof(struct sockaddr_in));

saddr4 and vaddr4 are type sockaddr_in.  But sin_addr.s_addr is an
offset into the struct.  This looks like a read overflow.  I would think
it should be sizeof(struct in_addr).

010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1306  		case AF_INET6:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1307  			return 1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1308  		default:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1309  			return -1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1310  		}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1311  	}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1312  	case AF_INET6: {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1313  		switch (rhs->sa_family) {
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1314  		case AF_UNSPEC:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1315  		case AF_INET:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1316  			return -1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1317  		case AF_INET6:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27 @1318  			return memcmp(&saddr6->sin6_addr,
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1319  				      &vaddr6->sin6_addr,
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1320  				      sizeof(struct sockaddr_in6));

Same.

010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1321  		default:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1322  			return -1;
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1323  		}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1324  	}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1325  	default:
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1326  		return -1; /* don't expect to be here */
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1327  	}
010c4e0a894e6a3 Shyam Prasad N 2022-12-27  1328  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


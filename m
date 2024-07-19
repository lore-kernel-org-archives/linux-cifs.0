Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DA71362
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 22:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721426739; cv=none; b=aUa+v5TAj6LzXUzURNr4rlpTKtFDT9N4tOc6DxSRznoATrg/p1pSW2KjtTensYJp1HOi/q0d85kGchTU534TQNlVBmDCOyuV0FA0QvZB6L1TSBdi0kRrJpv4BQDwnhSP07SwHzLg3KDd2gRxlzRRT+hLiO4Us7mgJAMKF9Xdapw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721426739; c=relaxed/simple;
	bh=i4IgO4dZxLaGn/wIWIKM89ZlkpDgFFAw3kuSbaXe0Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=WuUjH+ThAQaxlN8diPvknlm1Bf86r7LK/RZIQkS2I2Jzz01HNHeY2acjEyOlK8lR4t1xhBYNfk2+8y2lfYvRqe2HCbNJA+5/+/uEGK3vPq54bSIRLV+0ipYsgpCjzck2WlFtMHptKt/L7ypxP9BIomBZhhNF3mAIL8u+mmxR9Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tmayeN+m; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tmayeN+m"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-708bf659898so1137315a34.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Jul 2024 15:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721426737; x=1722031537; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mz+2X+Iu8sLofT7vRkRYhGDZJPtbZIuNDm+XurWvdtI=;
        b=tmayeN+mn2fbSkb88oco/aW2i0gyDhFSuzBWuEJ/ptYIIixP8TFCTRZsmUOtwr5gra
         C7d79aRedTrw4iHvJvuDHHgDlGeUUg68sVb3MAYCFYS9/rgo0rYx0lEXhkYpC+ilcwsB
         9w+GxH9uy5cT8gh26TD/sZyG+mbZAjiZt3BhCO2m9DGTpPPRzAE6Ke1tTuKQlIuw349z
         +eIxH8FiOSsT5rQxS2XYt+SbNibjBi2tbcfJz8G1Sn/BjMScba3qqJfrztYuJWayBVoo
         0BRb1NRIoVTTjvHIzRNXYFlNtaK2ie7dVc4gZ/LFKOcXkISg2htKcc0L1R6iO4zUxxej
         Iswg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721426737; x=1722031537;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mz+2X+Iu8sLofT7vRkRYhGDZJPtbZIuNDm+XurWvdtI=;
        b=SxsRH4s1gXFnpP1p9f5Wic1KEUjUhNXViLciD2EJGqTxNcNi3YkaKBbr22lFLmftIc
         g0zcr41qhfezhESaoKFfMA+jMWXRgIStVn93RvncKxndCCXTtYcrWvfryC7SPflgKD2F
         AmKGQnUVcAuuZsZ4cVt2c7vJ8T5DJo3Bd+YCARi4FZIWdCsoRTR2+hh0tGqePTYGsvV1
         pZ7XcWlcTEQT10WyRBb4Ps5fzztcyZ+V8CJZC1lgp1C45d79IuCZBbV2eOTpS5zptaLC
         G5xCF//1twQlX8kizfVftqwCtXohmYNXvU8RmiqxQj6RzOBaKWqMU4GPhg3utdbPWMw3
         xMxg==
X-Gm-Message-State: AOJu0YyMGQwQZBMRCrQZs6b4gAZMOJoFiBYFQZzEjdKa5sCGblnql/k+
	YjkzeyUwRmbH971SNfWav4RFs786kcErCct6Yb6/votWc3g2XNGmtJTwMKJjrxIo1y5REgsQf/M
	4
X-Google-Smtp-Source: AGHT+IHkwnFOWkq1c8dp6dau7x32jVeuoFMrArwTXFx7262Dvm1fDbKL5XwJBXL+P8HR7KAcAIFoLA==
X-Received: by 2002:a05:6830:4121:b0:703:6a50:9097 with SMTP id 46e09a7af769-708e3795bc7mr12232259a34.8.1721426736850;
        Fri, 19 Jul 2024 15:05:36 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:739a:b665:7f57:d340])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-708f60c3ba0sm476386a34.27.2024.07.19.15.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jul 2024 15:05:36 -0700 (PDT)
Date: Fri, 19 Jul 2024 17:05:33 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Subject: [bug report] smb3: retrying on failed server close
Message-ID: <6487f3bc-102c-40a0-96ec-dd97dc00c49c@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Ritvik Budhiraja,

Commit 173217bd7336 ("smb3: retrying on failed server close") from
Apr 2, 2024 (linux-next), leads to the following Smatch static
checker warning:

	fs/smb/client/cifsfs.c:1981 init_cifs()
	error: we previously assumed 'serverclose_wq' could be null (see line 1895)

I've written a blog about best practices for how kernel unwind ladders are
normally written.

https://staticthinking.wordpress.com/2022/04/28/free-the-last-thing-style/

fs/smb/client/cifsfs.c
  1800	static int __init
  1801	init_cifs(void)
  1802	{
  1803		int rc = 0;
  1804		cifs_proc_init();

This creates proc files.

  1805		INIT_LIST_HEAD(&cifs_tcp_ses_list);
  1806	/*
  1807	 *  Initialize Global counters
  1808	 */
  1809		atomic_set(&sesInfoAllocCount, 0);
  1810		atomic_set(&tconInfoAllocCount, 0);
  1811		atomic_set(&tcpSesNextId, 0);
  1812		atomic_set(&tcpSesAllocCount, 0);
  1813		atomic_set(&tcpSesReconnectCount, 0);
  1814		atomic_set(&tconInfoReconnectCount, 0);
  1815	
  1816		atomic_set(&buf_alloc_count, 0);
  1817		atomic_set(&small_buf_alloc_count, 0);
  1818	#ifdef CONFIG_CIFS_STATS2
  1819		atomic_set(&total_buf_alloc_count, 0);
  1820		atomic_set(&total_small_buf_alloc_count, 0);
  1821		if (slow_rsp_threshold < 1)
  1822			cifs_dbg(FYI, "slow_response_threshold msgs disabled\n");
  1823		else if (slow_rsp_threshold > 32767)
  1824			cifs_dbg(VFS,
  1825			       "slow response threshold set higher than recommended (0 to 32767)\n");
  1826	#endif /* CONFIG_CIFS_STATS2 */
  1827	
  1828		atomic_set(&mid_count, 0);
  1829		GlobalCurrentXid = 0;
  1830		GlobalTotalActiveXid = 0;
  1831		GlobalMaxActiveXid = 0;
  1832		spin_lock_init(&cifs_tcp_ses_lock);
  1833		spin_lock_init(&GlobalMid_Lock);
  1834	
  1835		cifs_lock_secret = get_random_u32();
  1836	
  1837		if (cifs_max_pending < 2) {
  1838			cifs_max_pending = 2;
  1839			cifs_dbg(FYI, "cifs_max_pending set to min of 2\n");
  1840		} else if (cifs_max_pending > CIFS_MAX_REQ) {
  1841			cifs_max_pending = CIFS_MAX_REQ;
  1842			cifs_dbg(FYI, "cifs_max_pending set to max of %u\n",
  1843				 CIFS_MAX_REQ);
  1844		}
  1845	
  1846		/* Limit max to about 18 hours, and setting to zero disables directory entry caching */
  1847		if (dir_cache_timeout > 65000) {
  1848			dir_cache_timeout = 65000;
  1849			cifs_dbg(VFS, "dir_cache_timeout set to max of 65000 seconds\n");
  1850		}
  1851	
  1852		cifsiod_wq = alloc_workqueue("cifsiod", WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1853		if (!cifsiod_wq) {
  1854			rc = -ENOMEM;
  1855			goto out_clean_proc;

Generally I can tell from these gotos that they free the last resource.  This
one deletes the proc files.

  1856		}
  1857	
  1858		/*
  1859		 * Consider in future setting limit!=0 maybe to min(num_of_cores - 1, 3)
  1860		 * so that we don't launch too many worker threads but
  1861		 * Documentation/core-api/workqueue.rst recommends setting it to 0
  1862		 */
  1863	
  1864		/* WQ_UNBOUND allows decrypt tasks to run on any CPU */
  1865		decrypt_wq = alloc_workqueue("smb3decryptd",
  1866					     WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1867		if (!decrypt_wq) {
  1868			rc = -ENOMEM;
  1869			goto out_destroy_cifsiod_wq;

cifsiod_wq alloc and destroyed.  Fine.

  1870		}
  1871	
  1872		fileinfo_put_wq = alloc_workqueue("cifsfileinfoput",
  1873					     WQ_UNBOUND|WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1874		if (!fileinfo_put_wq) {
  1875			rc = -ENOMEM;
  1876			goto out_destroy_decrypt_wq;
  1877		}
  1878	
  1879		cifsoplockd_wq = alloc_workqueue("cifsoplockd",
  1880						 WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1881		if (!cifsoplockd_wq) {
  1882			rc = -ENOMEM;
  1883			goto out_destroy_fileinfo_put_wq;
  1884		}
  1885	
  1886		deferredclose_wq = alloc_workqueue("deferredclose",
  1887						   WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1888		if (!deferredclose_wq) {
  1889			rc = -ENOMEM;
  1890			goto out_destroy_cifsoplockd_wq;
  1891		}
  1892	
  1893		serverclose_wq = alloc_workqueue("serverclose",
  1894						   WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
  1895		if (!serverclose_wq) {
  1896			rc = -ENOMEM;
  1897			goto out_destroy_serverclose_wq;

This should be goto out_destroy_deferredclose_wq.

  1898		}
  1899	
  1900		rc = cifs_init_inodecache();
  1901		if (rc)
  1902			goto out_destroy_deferredclose_wq;

This should be out_destroy_serverclose_wq.

  1903	
  1904		rc = cifs_init_netfs();
  1905		if (rc)
  1906			goto out_destroy_inodecache;
  1907	
  1908		rc = init_mids();
  1909		if (rc)
  1910			goto out_destroy_netfs;
  1911	
  1912		rc = cifs_init_request_bufs();
  1913		if (rc)
  1914			goto out_destroy_mids;
  1915	
  1916	#ifdef CONFIG_CIFS_DFS_UPCALL
  1917		rc = dfs_cache_init();
  1918		if (rc)
  1919			goto out_destroy_request_bufs;
  1920	#endif /* CONFIG_CIFS_DFS_UPCALL */
  1921	#ifdef CONFIG_CIFS_UPCALL
  1922		rc = init_cifs_spnego();
  1923		if (rc)
  1924			goto out_destroy_dfs_cache;
  1925	#endif /* CONFIG_CIFS_UPCALL */
  1926	#ifdef CONFIG_CIFS_SWN_UPCALL
  1927		rc = cifs_genl_init();
  1928		if (rc)
  1929			goto out_register_key_type;

This goto has a confusing name.  It calls exit_cifs_spnego().  It used to
unregister the spegno key type.  #HistoricalReasons

  1930	#endif /* CONFIG_CIFS_SWN_UPCALL */
  1931	
  1932		rc = init_cifs_idmap();
  1933		if (rc)
  1934			goto out_cifs_swn_init;
  1935	
  1936		rc = register_filesystem(&cifs_fs_type);
  1937		if (rc)
  1938			goto out_init_cifs_idmap;
  1939	
  1940		rc = register_filesystem(&smb3_fs_type);
  1941		if (rc) {
  1942			unregister_filesystem(&cifs_fs_type);

Do this in the unwind ladder, not before the goto.

  1943			goto out_init_cifs_idmap;
  1944		}
  1945	
  1946		return 0;
  1947	
  1948	out_init_cifs_idmap:
  1949		exit_cifs_idmap();
  1950	out_cifs_swn_init:
  1951	#ifdef CONFIG_CIFS_SWN_UPCALL
  1952		cifs_genl_exit();
  1953	out_register_key_type:
  1954	#endif
  1955	#ifdef CONFIG_CIFS_UPCALL
  1956		exit_cifs_spnego();
  1957	out_destroy_dfs_cache:
  1958	#endif
  1959	#ifdef CONFIG_CIFS_DFS_UPCALL
  1960		dfs_cache_destroy();
  1961	out_destroy_request_bufs:
  1962	#endif

These ifdef are a bit complicated.  It might be nicer to write it as:

out_cifs_swn_init:
	if (IS_ENABLED(CONFIG_CIFS_SWN_UPCALL))
		cifs_genl_exit();

  1963		cifs_destroy_request_bufs();
  1964	out_destroy_mids:
  1965		destroy_mids();
  1966	out_destroy_netfs:
  1967		cifs_destroy_netfs();
  1968	out_destroy_inodecache:
  1969		cifs_destroy_inodecache();
  1970	out_destroy_deferredclose_wq:
  1971		destroy_workqueue(deferredclose_wq);
  1972	out_destroy_cifsoplockd_wq:
  1973		destroy_workqueue(cifsoplockd_wq);
  1974	out_destroy_fileinfo_put_wq:
  1975		destroy_workqueue(fileinfo_put_wq);
  1976	out_destroy_decrypt_wq:
  1977		destroy_workqueue(decrypt_wq);
  1978	out_destroy_cifsiod_wq:
  1979		destroy_workqueue(cifsiod_wq);
  1980	out_destroy_serverclose_wq:
  1981		destroy_workqueue(serverclose_wq);
  1982	out_clean_proc:
  1983		cifs_proc_clean();

These need to be in mirror order from how they are allocated.  The last step is
to cut and paste the cleanup into exit_cifs(), add an
unregister_filesystem(&smb3_fs_type); and delete the labels.  There is an extra
step of cifs_release_automount_timer() which kills the timer.  I would have
expected that to be the first thing in the function, but maybe the ordering
doesn't matter or maybe I haven't understood how the ordering works.

  1984		return rc;
  1985	}

regards,
dan carpenter

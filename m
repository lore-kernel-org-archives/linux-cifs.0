Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33282C21C7
	for <linux-cifs@vger.kernel.org>; Fri,  3 Oct 2025 17:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759512059; cv=none; b=JT08i0rtCa5knkjVRRArS9pNvu4N/VnqzEIL3thdIcR0JYJMGGYqiHZq3COvNbkPc2yn7nIT2dAZVOYzQK6N+cw8/WmoVcONpcGf85ISU4KwOXSb51F+1Lb0ZSxFfZp+NTxIQSdT5pK8EL4LZD+zjWz3s7cuHRqMhCTnYyzumDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759512059; c=relaxed/simple;
	bh=C9CpBLzw1pO3vtP9TOCHCa6fzRdReKRfq65D5kQW2jE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=VmjpfJy16qpcA0IbipGt5eB6Mn7EGXXbkzQyrIUCbmso/m8nnuXfW+Y7qndMhLXYJCkHjrEulaZus5fNFtOZTtittCZvHk6KCvlv3Jz0Cv9F3cgh73n3K1Y6OSckRxgfVO9bpaFmSwCQgsk56TumQCnekUJfC1lSa8FiyNi6HWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tXb/WJ1U; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tXb/WJ1U"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e504975dbso15741695e9.1
        for <linux-cifs@vger.kernel.org>; Fri, 03 Oct 2025 10:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759512055; x=1760116855; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=K1jUhJGkvuXEQLZn2ZvNWi0i88zQ8eeDqvcxRlddFH8=;
        b=tXb/WJ1UPhgyM6TXeF4M3vm1aXevCHCOi7E2pPgqq6l6r4j9vInIZZ65iwIX/jVDCt
         uWHs3Esi8t2fUVTK0igT7WtE7uQrOitg3t4yNYBImOQZFgT/cRAgHf9Mch8/RsXZj8Bt
         Big74EtKvqGIH1lB2Q3LCyfTAvXPgGz9ZGHPO6HyJlQ6oCu2uzT5drlA0NFuzUl4tHSu
         jgVRx5sGvlo4CjHW78QhzR2/n6P6tgSvph+eHG4w914p9Pt+PqrZrufz/t/JvPBjWUVS
         IQglgIhfbvbRP8kbAFlPx5C7K8Ue7h1t72EE0A85GJgQJEvD+NL1HWKhRCBC7csys34O
         uD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512055; x=1760116855;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K1jUhJGkvuXEQLZn2ZvNWi0i88zQ8eeDqvcxRlddFH8=;
        b=qYZcZM3lVctrrKvZOCnnYOeUDLIZUu2ePCNcjvMqXP7OnrXoIsNWuH7sK3jh9JMYRc
         s+YXsa+9k6FzZVC84MuotxRP/FpqVAemMHodtgdQ80Wrs/sbZdtTOaishKp89bLlqyUE
         REbq7iD4Mcv+J16w8RgGRiYZ/PR9jRelPBEmn29nkvzkpyZBUztlLdRWW3EIIQO1UZvu
         vZ1n4EwOFZTuOVXhJ/YT21Nfx/G9pd40COoCHkvXa/pGwQUI/XyNu/DZMiczT0VD9WOr
         qmZpmySdfsV2nXZxVw7tVxkreM8F9nb4atz7vtz7tNwRYQB6at/k5K29dRER9M06ahhX
         K9NA==
X-Forwarded-Encrypted: i=1; AJvYcCULRw4PPLQ0Q0oHejucNNyneTiie9hS/9o5z/w3RZtiAEb9yqR2BZG4AwJ1As3zUVAza01Zhxl6G2nm@vger.kernel.org
X-Gm-Message-State: AOJu0YxvMchWd49bCYZKgWAv/2cv8bfBrP91Alfho5M1wKkjoWaSHrzM
	qQRYx8s6apMw50RxqcPa71xN70OqLhSlJ3xE6ZXNMQd0my6xErWQHqDRqMbbXoKlhEI=
X-Gm-Gg: ASbGnctuFnVw8KlikWQaEjW4t9TpYs6aGKqFfa5UoLHXTfBZqTOngEUyTJJk5GKE/t6
	WSgRWSckBvCsG1rFHHZY48thq82NBbhdBJAEfTqBsomLzG8plWZOhB6YEjLHe7w9kBRASpuBHOO
	Et0dT6M9KRzhevVpWBnrvl0kg19fSD7BArQ5SQmJqaNI7wRl3GiQ0qNXeySSY9AnlHlXiK5Arbh
	lXVWZIBcHehqoggU4wgD5/d/Av7TTXE+uIRkTOs+2UmgG32hTVL9sYZNzg342sVZQHdmZ1ZBLvA
	tsPCMgivAe62cY54M73DHwB8mDnLTr0Zh2hFxI1zk/7V2Ix7n1lJ3M1OpQiXVT3Xu+VivZV2QIK
	uLbMTZ0Upo5sXintnXUBDFolCE7irXCm+EX9zzyj3AJ7YXl3mty++OpCfjP24HWqpCV0=
X-Google-Smtp-Source: AGHT+IE9qXd8T2vmx1DiEYO/pYDUzvVktkgheDcwQex8b4BwN0UphaLhZk2mruoWTzAaN8uZMCOdzA==
X-Received: by 2002:a05:6000:2086:b0:3ee:15c6:9a55 with SMTP id ffacd0b85a97d-425671c0c88mr2523518f8f.34.1759512054900;
        Fri, 03 Oct 2025 10:20:54 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-4255d8e980dsm9487329f8f.36.2025.10.03.10.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 10:20:54 -0700 (PDT)
Date: Fri, 3 Oct 2025 20:20:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, smfrench@gmail.com,
	pc@manguebit.com, ronniesahlberg@gmail.com, sprasad@microsoft.com,
	tom@talpey.com, bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH 16/20] smb: client: add is_dir argument to query_path_info
Message-ID: <202510032329.NN83GCga-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250929132805.220558-17-ematsumiya@suse.de>

Hi Enzo,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/smb-client-remove-cfids_invalidation_worker/20250929-213155
base:   v6.17
patch link:    https://lore.kernel.org/r/20250929132805.220558-17-ematsumiya%40suse.de
patch subject: [PATCH 16/20] smb: client: add is_dir argument to query_path_info
config: i386-randconfig-141-20251003 (https://download.01.org/0day-ci/archive/20251003/202510032329.NN83GCga-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510032329.NN83GCga-lkp@intel.com/

New smatch warnings:
fs/smb/client/inode.c:1313 cifs_get_fattr() error: we previously assumed 'inode' could be null (see line 1288)

vim +/inode +1313 fs/smb/client/inode.c

a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1259  static int cifs_get_fattr(struct cifs_open_info_data *data,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1260  			  struct super_block *sb, int xid,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1261  			  const struct cifs_fid *fid,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1262  			  struct cifs_fattr *fattr,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1263  			  struct inode **inode,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1264  			  const char *full_path)
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1265  {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1266  	struct cifs_open_info_data tmp_data = {};
1208ef1f76540b fs/cifs/inode.c       Pavel Shilovsky                   2012-05-27  1267  	struct cifs_tcon *tcon;
1208ef1f76540b fs/cifs/inode.c       Pavel Shilovsky                   2012-05-27  1268  	struct TCP_Server_Info *server;
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1269  	struct tcon_link *tlink;
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1270  	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1271  	void *smb1_backup_rsp_buf = NULL;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1272  	int rc = 0;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1273  	int tmprc = 0;
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1274  
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1275  	tlink = cifs_sb_tlink(cifs_sb);
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1276  	if (IS_ERR(tlink))
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1277  		return PTR_ERR(tlink);
1208ef1f76540b fs/cifs/inode.c       Pavel Shilovsky                   2012-05-27  1278  	tcon = tlink_tcon(tlink);
1208ef1f76540b fs/cifs/inode.c       Pavel Shilovsky                   2012-05-27  1279  	server = tcon->ses->server;
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1280  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1281  	/*
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1282  	 * 1. Fetch file metadata if not provided (data)
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1283  	 */
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1284  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1285  	if (!data) {
65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29  1286  		bool is_dir = false;
65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29  1287  
65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29 @1288  		if (inode && *inode)

The check implies that "inode" can be NULL.  Pretty sure this
check can be removed unless something changed out of tree.

65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29  1289  			is_dir = S_ISDIR((*inode)->i_mode);
65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29  1290  
8b4e285d8ce3c6 fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1291  		rc = server->ops->query_path_info(xid, tcon, cifs_sb,
65e58ef1dafb0c fs/smb/client/inode.c Enzo Matsumiya                    2025-09-29  1292  						  full_path, &tmp_data, is_dir);
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1293  		data = &tmp_data;
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1294  	}
0b8f18e358384a fs/cifs/inode.c       Jeff Layton                       2009-07-09  1295  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1296  	/*
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1297  	 * 2. Convert it to internal cifs metadata (fattr)
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1298  	 */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1299  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1300  	switch (rc) {
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1301  	case 0:
2e4564b31b645f fs/cifs/inode.c       Steve French                      2020-10-22  1302  		/*
2e4564b31b645f fs/cifs/inode.c       Steve French                      2020-10-22  1303  		 * If the file is a reparse point, it is more complicated
2e4564b31b645f fs/cifs/inode.c       Steve French                      2020-10-22  1304  		 * since we have to check if its reparse tag matches a known
2e4564b31b645f fs/cifs/inode.c       Steve French                      2020-10-22  1305  		 * special file type e.g. symlink or fifo or char etc.
2e4564b31b645f fs/cifs/inode.c       Steve French                      2020-10-22  1306  		 */
5f71ebc4129449 fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1307  		if (cifs_open_data_reparse(data)) {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1308  			rc = reparse_info_to_fattr(data, sb, xid, tcon,
858e74876c5cbf fs/smb/client/inode.c Paulo Alcantara                   2024-01-19  1309  						   full_path, fattr);
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1310  		} else {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1311  			cifs_open_info_to_fattr(fattr, data, sb);
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1312  		}
ec4535b2a1d709 fs/smb/client/inode.c Paulo Alcantara                   2024-04-08 @1313  		if (!rc && *inode &&
                                                                                                                   ^^^^^^

The rest of the function assumes inode is a valid pointer.

regards,
dan carpenter

ec4535b2a1d709 fs/smb/client/inode.c Paulo Alcantara                   2024-04-08  1314  		    (fattr->cf_flags & CIFS_FATTR_DELETE_PENDING))
fc20c523211a38 fs/smb/client/inode.c Meetakshi Setiya                  2024-03-14  1315  			cifs_mark_open_handles_for_deleted_file(*inode, full_path);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1316  		break;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1317  	case -EREMOTE:
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1318  		/* DFS link, no metadata available on this server */
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1319  		cifs_create_junction_fattr(fattr, sb);
b9a3260f25ab5d fs/cifs/inode.c       Steve French                      2008-05-20  1320  		rc = 0;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1321  		break;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1322  	case -EACCES:
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1323  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
1e77a8c204c9d1 fs/cifs/inode.c       Steve French                      2018-10-19  1324  		/*
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1325  		 * perm errors, try again with backup flags if possible
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1326  		 *
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1327  		 * For SMB2 and later the backup intent flag
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1328  		 * is already sent if needed on open and there
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1329  		 * is no path based FindFirst operation to use
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1330  		 * to retry with
1e77a8c204c9d1 fs/cifs/inode.c       Steve French                      2018-10-19  1331  		 */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1332  		if (backup_cred(cifs_sb) && is_smb1_server(server)) {
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1333  			/* for easier reading */
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1334  			FILE_ALL_INFO *fi;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1335  			FILE_DIRECTORY_INFO *fdi;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1336  			SEARCH_ID_FULL_DIR_INFO *si;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1337  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1338  			rc = cifs_backup_query_path_info(xid, tcon, sb,
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1339  							 full_path,
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1340  							 &smb1_backup_rsp_buf,
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1341  							 &fi);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1342  			if (rc)
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1343  				goto out;
1e77a8c204c9d1 fs/cifs/inode.c       Steve French                      2018-10-19  1344  
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1345  			move_cifs_info_to_smb2(&data->fi, fi);
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1346  			fdi = (FILE_DIRECTORY_INFO *)fi;
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1347  			si = (SEARCH_ID_FULL_DIR_INFO *)fi;
c052e2b423f3ea fs/cifs/inode.c       Shirish Pargaonkar                2012-09-28  1348  
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1349  			cifs_dir_info_to_fattr(fattr, fdi, cifs_sb);
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1350  			fattr->cf_uniqueid = le64_to_cpu(si->UniqueId);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1351  			/* uniqueid set, skip get inum step */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1352  			goto handle_mnt_opt;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1353  		} else {
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1354  			/* nothing we can do, bail out */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1355  			goto out;
c052e2b423f3ea fs/cifs/inode.c       Shirish Pargaonkar                2012-09-28  1356  		}
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1357  #else
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1358  		goto out;
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1359  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1360  		break;
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1361  	default:
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1362  		cifs_dbg(FYI, "%s: unhandled err rc %d\n", __func__, rc);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1363  		goto out;
132ac7b77cc95a fs/cifs/inode.c       Jeff Layton                       2009-02-10  1364  	}
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1365  
a108471b5730b5 fs/cifs/inode.c       Ross Lagerwall                    2015-12-02  1366  	/*
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1367  	 * 3. Get or update inode number (fattr->cf_uniqueid)
a108471b5730b5 fs/cifs/inode.c       Ross Lagerwall                    2015-12-02  1368  	 */
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1369  
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1370  	cifs_set_fattr_ino(xid, tcon, sb, inode, full_path, data, fattr);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1371  
7ea884c77e5c97 fs/cifs/inode.c       Steve French                      2018-03-31  1372  	/*
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1373  	 * 4. Tweak fattr based on mount options
7ea884c77e5c97 fs/cifs/inode.c       Steve French                      2018-03-31  1374  	 */
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1375  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1376  handle_mnt_opt:
fb157ed226d225 fs/cifs/inode.c       Steve French                      2022-08-01  1377  #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
0b8f18e358384a fs/cifs/inode.c       Jeff Layton                       2009-07-09  1378  	/* query for SFU type info if supported and needed */
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1379  	if ((fattr->cf_cifsattrs & ATTR_SYSTEM) &&
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1380  	    (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)) {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1381  		tmprc = cifs_sfu_type(fattr, full_path, cifs_sb, xid);
0b8f18e358384a fs/cifs/inode.c       Jeff Layton                       2009-07-09  1382  		if (tmprc)
f96637be081141 fs/cifs/inode.c       Joe Perches                       2013-05-04  1383  			cifs_dbg(FYI, "cifs_sfu_type failed: %d\n", tmprc);
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1384  	}
^1da177e4c3f41 fs/cifs/inode.c       Linus Torvalds                    2005-04-16  1385  
953f868138dbf4 fs/cifs/inode.c       Steve French                      2007-10-31  1386  	/* fill in 0777 bits from ACL */
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1387  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MODE_FROM_SID) {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1388  		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1389  				       true, full_path, fid);
01ec372cef1e5a fs/cifs/inode.c       Ronnie Sahlberg                   2020-09-03  1390  		if (rc == -EREMOTE)
01ec372cef1e5a fs/cifs/inode.c       Ronnie Sahlberg                   2020-09-03  1391  			rc = 0;
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1392  		if (rc) {
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1393  			cifs_dbg(FYI, "%s: Get mode from SID failed. rc=%d\n",
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1394  				 __func__, rc);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1395  			goto out;
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1396  		}
e2f8fbfb8d09c0 fs/cifs/inode.c       Steve French                      2019-07-19  1397  	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1398  		rc = cifs_acl_to_fattr(cifs_sb, fattr, *inode,
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1399  				       false, full_path, fid);
01ec372cef1e5a fs/cifs/inode.c       Ronnie Sahlberg                   2020-09-03  1400  		if (rc == -EREMOTE)
01ec372cef1e5a fs/cifs/inode.c       Ronnie Sahlberg                   2020-09-03  1401  			rc = 0;
68464b88cc0a73 fs/cifs/inode.c       Dan Carpenter via samba-technical 2019-11-26  1402  		if (rc) {
f96637be081141 fs/cifs/inode.c       Joe Perches                       2013-05-04  1403  			cifs_dbg(FYI, "%s: Getting ACL failed with error: %d\n",
78415d2d306bfe fs/cifs/inode.c       Shirish Pargaonkar                2010-11-27  1404  				 __func__, rc);
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1405  			goto out;
78415d2d306bfe fs/cifs/inode.c       Shirish Pargaonkar                2010-11-27  1406  		}
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1407  	} else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL)
0b8f18e358384a fs/cifs/inode.c       Jeff Layton                       2009-07-09  1408  		/* fill in remaining high mode bits e.g. SUID, VTX */
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1409  		cifs_sfu_mode(fattr, full_path, cifs_sb, xid);
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1410  	else if (!(tcon->posix_extensions))
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1411  		/* clear write bits if ATTR_READONLY is set */
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1412  		if (fattr->cf_cifsattrs & ATTR_READONLY)
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1413  			fattr->cf_mode &= ~(S_IWUGO);
2f3017e7cc7515 fs/smb/client/inode.c Steve French                      2024-09-21  1414  
b9a3260f25ab5d fs/cifs/inode.c       Steve French                      2008-05-20  1415  
1b12b9c15b4371 fs/cifs/inode.c       Stefan Metzmacher                 2010-08-05  1416  	/* check for Minshall+French symlinks */
1b12b9c15b4371 fs/cifs/inode.c       Stefan Metzmacher                 2010-08-05  1417  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1418  		tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
cb084b1a9be347 fs/cifs/inode.c       Sachin Prabhu                     2013-11-25  1419  		cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
1b12b9c15b4371 fs/cifs/inode.c       Stefan Metzmacher                 2010-08-05  1420  	}
1b12b9c15b4371 fs/cifs/inode.c       Stefan Metzmacher                 2010-08-05  1421  
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1422  out:
b8f7442bc46e48 fs/cifs/inode.c       Aurelien Aptel                    2019-11-18  1423  	cifs_buf_release(smb1_backup_rsp_buf);
7ffec372458d16 fs/cifs/inode.c       Jeff Layton                       2010-09-29  1424  	cifs_put_tlink(tlink);
76894f3e2f7117 fs/cifs/inode.c       Paulo Alcantara                   2022-10-03  1425  	cifs_free_open_info(&tmp_data);
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1426  	return rc;
a18280e7fdea1f fs/smb/client/inode.c Paulo Alcantara                   2023-08-17  1427  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


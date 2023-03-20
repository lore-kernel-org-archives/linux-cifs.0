Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 513C0C76195
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Mar 2023 05:57:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjCTF5s (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Mar 2023 01:57:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCTF5r (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Mar 2023 01:57:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02A61C7C1
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 22:57:45 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j2so9176188wrh.9
        for <linux-cifs@vger.kernel.org>; Sun, 19 Mar 2023 22:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679291864;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qbg38UI5KVdEKx+KRq8dQdKCq0U8r0lUrbsZ9T//vGY=;
        b=ACtjxju/9DB+4FxNemTwsBGJIV5gf3r/uvyvKIX8JbAiG3Py4zsYm7OJFpLLtIOQkZ
         HfN8c6or1uJ26c78UlkTuXtzZVSLTZG3V2IyJ9fPfC4xcIwzdjacbtMC87PaN6fSVa64
         ROgabRPdtGEiTnHHU4qu34iStT2aHJUTKPbOCxDLUOLZJNBOxvxc92CKJnMMTnRLQb+E
         4hcwumd+DB4EmVfd8Of+3RZxjBdeQTBWN0l3d3dJe3/gS05q/A66TRnsc5ib8BwA+a3z
         9TgDErhFvjKBj/9kVLvGtiPBBIIxHz21ZnPWdbYL1HXcEpfjz+kdR5lOtb7my6btz68n
         EoBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679291864;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qbg38UI5KVdEKx+KRq8dQdKCq0U8r0lUrbsZ9T//vGY=;
        b=bOWMkzSjVVzQgtZ7tWNAlhuJSP9LpceAOt8nYXeJ8IhCspDgZWN8FWTYFadZIjtSfT
         e/7L5GDPD8dcqTfhFEOLcIHctXb3DbONGasbYuG5YPRBRFUcXEory4r7VGAW2IUB4OUn
         5VJyLWEn6En5/eOtzhXVLMIhy/oYlhaIvnvj7siwahv/A3uwrAO5gbK4rjAyVmG1yLzF
         DFZH8oCc2hjeV8e3FrGXkOiXxYiwhT7DSBrfM00reK8RFxoA8BhmfzAW5bmn3iSivbe5
         ZBX0F/4dqk/nysCBN8uwV5IJB5wIGpIRqoVJGH3QfAfwiUL+UWwIsL7w6g8SzLKpfxiF
         a4jg==
X-Gm-Message-State: AO0yUKX/NC13PuhfoeIL7pWtCKCWZceVw9CqQmzvGjiGnO9Cn8CvK44P
        CfVHrJsebvLAd1rHs8j62A4=
X-Google-Smtp-Source: AK7set/WBfJIoDSl0NLHCe8duFNZTKMOp1bGRMu5G512DBrixD5skVRVUVOESNONHhjKviL7jfrEqA==
X-Received: by 2002:adf:e102:0:b0:2cf:f4cc:cbac with SMTP id t2-20020adfe102000000b002cff4cccbacmr13057488wrz.23.1679291864170;
        Sun, 19 Mar 2023 22:57:44 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id j10-20020adff00a000000b002d1bfe3269esm8018489wro.59.2023.03.19.22.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 22:57:43 -0700 (PDT)
Date:   Mon, 20 Mar 2023 08:57:32 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     oe-kbuild@lists.linux.dev, Volker Lendecke <vl@samba.org>,
        linux-cifs@vger.kernel.org
Cc:     lkp@intel.com, oe-kbuild-all@lists.linux.dev,
        Volker Lendecke <vl@samba.org>
Subject: Re: [PATCH 02/10] cifs: Make "resp_buf_type" initialization
 consistent
Message-ID: <0c9a0f8e-dfbb-4778-92f7-e9f3b63680af@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Volker,

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Volker-Lendecke/cifs-Simplify-some-callers-of-compound_send_recv/20230315-212751
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl%40samba.org
patch subject: [PATCH 02/10] cifs: Make "resp_buf_type" initialization consistent
config: x86_64-randconfig-m001 (https://download.01.org/0day-ci/archive/20230316/202303160920.kX2EmZmU-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-8) 11.3.0

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Link: https://lore.kernel.org/r/202303160920.kX2EmZmU-lkp@intel.com/

New smatch warnings:
fs/cifs/smb2pdu.c:3031 SMB2_open() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:3258 SMB2_ioctl() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:3385 __SMB2_close() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:3590 query_info() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:3756 SMB2_change_notify() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:4021 SMB2_flush() error: uninitialized symbol 'resp_buftype'.
fs/cifs/smb2pdu.c:5077 SMB2_query_directory() error: uninitialized symbol 'resp_buftype'.
fs/cifs/cifssmb.c:2079 CIFSSMBPosixLock() error: uninitialized symbol 'resp_buf_type'.

Old smatch warnings:
fs/cifs/smb2pdu.c:3750 SMB2_change_notify() error: we previously assumed 'plen' could be null (see line 3709)
fs/cifs/cifssmb.c:4082 CIFSFindFirst() warn: missing error code? 'rc'
fs/cifs/cifssmb.c:4209 CIFSFindNext() warn: missing error code? 'rc'

vim +/resp_buftype +3031 fs/cifs/smb2pdu.c

f0df737ee820ec Pavel Shilovsky 2012-09-18  3013  
f0df737ee820ec Pavel Shilovsky 2012-09-18  3014  	if (buf) {
fbcff33d4204cb Kees Cook       2021-06-21  3015  		buf->CreationTime = rsp->CreationTime;
fbcff33d4204cb Kees Cook       2021-06-21  3016  		buf->LastAccessTime = rsp->LastAccessTime;
fbcff33d4204cb Kees Cook       2021-06-21  3017  		buf->LastWriteTime = rsp->LastWriteTime;
fbcff33d4204cb Kees Cook       2021-06-21  3018  		buf->ChangeTime = rsp->ChangeTime;
f0df737ee820ec Pavel Shilovsky 2012-09-18  3019  		buf->AllocationSize = rsp->AllocationSize;
f0df737ee820ec Pavel Shilovsky 2012-09-18  3020  		buf->EndOfFile = rsp->EndofFile;
f0df737ee820ec Pavel Shilovsky 2012-09-18  3021  		buf->Attributes = rsp->FileAttributes;
f0df737ee820ec Pavel Shilovsky 2012-09-18  3022  		buf->NumberOfLinks = cpu_to_le32(1);
f0df737ee820ec Pavel Shilovsky 2012-09-18  3023  		buf->DeletePending = 0;
f0df737ee820ec Pavel Shilovsky 2012-09-18  3024  	}
2e44b288788213 Pavel Shilovsky 2012-09-18  3025  
89a5bfa350faf8 Steve French    2019-07-18  3026  
89a5bfa350faf8 Steve French    2019-07-18  3027  	smb2_parse_contexts(server, rsp, &oparms->fid->epoch,
69dda3059e7a4d Aurelien Aptel  2020-03-02  3028  			    oparms->fid->lease_key, oplock, buf, posix);
2503a0dba98948 Pavel Shilovsky 2011-12-26  3029  creat_exit:
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  3030  	SMB2_open_free(&rqst);
2503a0dba98948 Pavel Shilovsky 2011-12-26 @3031  	free_rsp_buf(resp_buftype, rsp);

Hard to tell if this is a false positive without more context, but it
looks properly sus.

2503a0dba98948 Pavel Shilovsky 2011-12-26  3032  	return rc;
2503a0dba98948 Pavel Shilovsky 2011-12-26  3033  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests


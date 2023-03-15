Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 242F6C61DA4
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 19:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjCOTdO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 15:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCOTdN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 15:33:13 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5A23B0C7
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 12:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678908791; x=1710444791;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0mvvVBTqRabqwe9y+6r+ODj4vwHvU8D+Hfv1BfLdewU=;
  b=Mu8Kefk/YRAHNXapjYGbalYsUnFbMfaCaIPAy5xipkiMn0yOMQWsomsW
   UVp5eKEVD92YHYXlvgFsGmX+FXc6cwbzBcmw3uIrzOGUE6Mst8RsghgtE
   E1wHjbEyjqsWe8sEXSMJsKRcSNOvDAosw6kfc0gGPNr1XdwE1rE1m6boz
   wE+ed1y/PsAksC9fPWkaIL9FohZhXQ8ECSo5oChwlx6eOuEYXmav9s/xT
   ZvZjAjbIblHfHO1S64ak4tnfaDKspnlFyeemmI5WSGa2XhZXMqdpiP3ER
   HKSR/qYS2pKVziTeOz7e6uO5IhzsscIvbdELd/DL/plWck/WIPSxTJw9u
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="340165939"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="340165939"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 12:33:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="672852067"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="672852067"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2023 12:33:09 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcWrv-0007z7-0O;
        Wed, 15 Mar 2023 19:33:03 +0000
Date:   Thu, 16 Mar 2023 03:33:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Volker Lendecke <vl@samba.org>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        Volker Lendecke <vl@samba.org>
Subject: Re: [PATCH 02/10] cifs: Make "resp_buf_type" initialization
 consistent
Message-ID: <202303160346.ieaQ1aHI-lkp@intel.com>
References: <715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Volker,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v6.3-rc2 next-20230315]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Volker-Lendecke/cifs-Simplify-some-callers-of-compound_send_recv/20230315-212751
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/715459412f19853c56156b8c0ce39fe74f148860.1678885349.git.vl%40samba.org
patch subject: [PATCH 02/10] cifs: Make "resp_buf_type" initialization consistent
config: i386-randconfig-a013-20230313 (https://download.01.org/0day-ci/archive/20230316/202303160346.ieaQ1aHI-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1bf099b09d9dddfff9f129b27e1a6b1df42f9ec2
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Volker-Lendecke/cifs-Simplify-some-callers-of-compound_send_recv/20230315-212751
        git checkout 1bf099b09d9dddfff9f129b27e1a6b1df42f9ec2
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/cifs/ fs/xfs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303160346.ieaQ1aHI-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/cifs/smb2pdu.c:2973:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:3031:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:2973:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:2955:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:3187:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:3258:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:3187:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:3152:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:3359:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:3385:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:3359:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:3333:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:3543:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:3590:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:3543:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:3517:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:3718:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:3756:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp_iov.iov_base);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:3718:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:3696:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:4004:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:4021:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp_iov.iov_base);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:4004:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:3986:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   fs/cifs/smb2pdu.c:5041:6: warning: variable 'resp_buftype' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (rc)
               ^~
   fs/cifs/smb2pdu.c:5077:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buftype, rsp);
                        ^~~~~~~~~~~~
   fs/cifs/smb2pdu.c:5041:2: note: remove the 'if' if its condition is always false
           if (rc)
           ^~~~~~~
   fs/cifs/smb2pdu.c:5019:18: note: initialize the variable 'resp_buftype' to silence this warning
           int resp_buftype;
                           ^
                            = 0
   7 warnings generated.
--
>> fs/cifs/cifssmb.c:2028:6: warning: variable 'resp_buf_type' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (waitFlag) {
               ^~~~~~~~
   fs/cifs/cifssmb.c:2079:15: note: uninitialized use occurs here
           free_rsp_buf(resp_buf_type, rsp_iov.iov_base);
                        ^~~~~~~~~~~~~
   fs/cifs/cifssmb.c:2028:2: note: remove the 'if' if its condition is always false
           if (waitFlag) {
           ^~~~~~~~~~~~~~~
   fs/cifs/cifssmb.c:1969:19: note: initialize the variable 'resp_buf_type' to silence this warning
           int resp_buf_type;
                            ^
                             = 0
   1 warning generated.


vim +2973 fs/cifs/smb2pdu.c

1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2941  
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2942  int
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2943  SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2944  	  __u8 *oplock, struct smb2_file_all_info *buf,
69dda3059e7a4d Aurelien Aptel  2020-03-02  2945  	  struct create_posix_rsp *posix,
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2946  	  struct kvec *err_iov, int *buftype)
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2947  {
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2948  	struct smb_rqst rqst;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2949  	struct smb2_create_rsp *rsp = NULL;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2950  	struct cifs_tcon *tcon = oparms->tcon;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2951  	struct cifs_ses *ses = tcon->ses;
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2952  	struct TCP_Server_Info *server = cifs_pick_channel(ses);
4d8dfafc5cb88f Ronnie Sahlberg 2018-08-21  2953  	struct kvec iov[SMB2_CREATE_IOV_SIZE];
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2954  	struct kvec rsp_iov = {NULL, 0};
1bf099b09d9ddd Volker Lendecke 2023-03-15  2955  	int resp_buftype;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2956  	int rc = 0;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2957  	int flags = 0;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2958  
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2959  	cifs_dbg(FYI, "create/open\n");
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2960  	if (!ses || !server)
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2961  		return -EIO;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2962  
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2963  	if (smb3_encryption_required(tcon))
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2964  		flags |= CIFS_TRANSFORM_REQ;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2965  
40eff45b5dc7df Ronnie Sahlberg 2018-06-12  2966  	memset(&rqst, 0, sizeof(struct smb_rqst));
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2967  	memset(&iov, 0, sizeof(iov));
40eff45b5dc7df Ronnie Sahlberg 2018-06-12  2968  	rqst.rq_iov = iov;
4d8dfafc5cb88f Ronnie Sahlberg 2018-08-21  2969  	rqst.rq_nvec = SMB2_CREATE_IOV_SIZE;
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2970  
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2971  	rc = SMB2_open_init(tcon, server,
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2972  			    &rqst, oplock, oparms, path);
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08 @2973  	if (rc)
1eb9fb52040fc6 Ronnie Sahlberg 2018-08-08  2974  		goto creat_exit;
40eff45b5dc7df Ronnie Sahlberg 2018-06-12  2975  
efe2e9f369c72b Steve French    2019-02-26  2976  	trace_smb3_open_enter(xid, tcon->tid, tcon->ses->Suid,
efe2e9f369c72b Steve French    2019-02-26  2977  		oparms->create_options, oparms->desired_access);
efe2e9f369c72b Steve French    2019-02-26  2978  
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2979  	rc = cifs_send_recv(xid, ses, server,
352d96f3acc6e0 Aurelien Aptel  2020-05-31  2980  			    &rqst, &resp_buftype, flags,
4f33bc35875ae6 Ronnie Sahlberg 2017-11-20  2981  			    &rsp_iov);
da502f7df03d2d Pavel Shilovsky 2016-10-25  2982  	rsp = (struct smb2_create_rsp *)rsp_iov.iov_base;
2503a0dba98948 Pavel Shilovsky 2011-12-26  2983  
2503a0dba98948 Pavel Shilovsky 2011-12-26  2984  	if (rc != 0) {
2503a0dba98948 Pavel Shilovsky 2011-12-26  2985  		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
91cb74f5142c14 Ronnie Sahlberg 2018-04-13  2986  		if (err_iov && rsp) {
91cb74f5142c14 Ronnie Sahlberg 2018-04-13  2987  			*err_iov = rsp_iov;
9d874c36552afb Ronnie Sahlberg 2018-06-08  2988  			*buftype = resp_buftype;
91cb74f5142c14 Ronnie Sahlberg 2018-04-13  2989  			resp_buftype = CIFS_NO_BUFFER;
91cb74f5142c14 Ronnie Sahlberg 2018-04-13  2990  			rsp = NULL;
91cb74f5142c14 Ronnie Sahlberg 2018-04-13  2991  		}
28d59363ae746d Steve French    2018-05-30  2992  		trace_smb3_open_err(xid, tcon->tid, ses->Suid,
28d59363ae746d Steve French    2018-05-30  2993  				    oparms->create_options, oparms->desired_access, rc);
7dcc82c2dfd5f1 Steve French    2019-09-11  2994  		if (rc == -EREMCHG) {
a0a3036b81f1f6 Joe Perches     2020-04-14  2995  			pr_warn_once("server share %s deleted\n",
68e14569d7e5a1 Steve French    2022-09-21  2996  				     tcon->tree_name);
7dcc82c2dfd5f1 Steve French    2019-09-11  2997  			tcon->need_reconnect = true;
7dcc82c2dfd5f1 Steve French    2019-09-11  2998  		}
2503a0dba98948 Pavel Shilovsky 2011-12-26  2999  		goto creat_exit;
6b7895182ce398 Steve French    2021-11-11  3000  	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
6b7895182ce398 Steve French    2021-11-11  3001  		goto creat_exit;
6b7895182ce398 Steve French    2021-11-11  3002  	else
351a59dace0e0e Paulo Alcantara 2022-03-21  3003  		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
351a59dace0e0e Paulo Alcantara 2022-03-21  3004  				     oparms->create_options, oparms->desired_access);
2503a0dba98948 Pavel Shilovsky 2011-12-26  3005  
fae8044c03c3c0 Steve French    2018-10-19  3006  	atomic_inc(&tcon->num_remote_opens);
351a59dace0e0e Paulo Alcantara 2022-03-21  3007  	oparms->fid->persistent_fid = rsp->PersistentFileId;
351a59dace0e0e Paulo Alcantara 2022-03-21  3008  	oparms->fid->volatile_fid = rsp->VolatileFileId;
86f740f2aed5ea Aurelien Aptel  2020-02-21  3009  	oparms->fid->access = oparms->desired_access;
dfe33f9abc0899 Steve French    2018-10-30  3010  #ifdef CONFIG_CIFS_DEBUG2
0d35e382e4e96a Ronnie Sahlberg 2021-11-05  3011  	oparms->fid->mid = le64_to_cpu(rsp->hdr.MessageId);
dfe33f9abc0899 Steve French    2018-10-30  3012  #endif /* CIFS_DEBUG2 */
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
2503a0dba98948 Pavel Shilovsky 2011-12-26  3031  	free_rsp_buf(resp_buftype, rsp);
2503a0dba98948 Pavel Shilovsky 2011-12-26  3032  	return rc;
2503a0dba98948 Pavel Shilovsky 2011-12-26  3033  }
2503a0dba98948 Pavel Shilovsky 2011-12-26  3034  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

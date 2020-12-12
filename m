Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1833EC4361B
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 15:27:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C6122240
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Dec 2020 15:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389170AbgLLP1q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Dec 2020 10:27:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:55218 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgLLP1q (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 12 Dec 2020 10:27:46 -0500
IronPort-SDR: 4/SgZL1DZJ/shRIVqydxpAjbvYWkjhTTGUgwOyhWPvG69aFlEpwkEECH2S52399R+4fmc7FbXR
 2yByvBTXzDug==
X-IronPort-AV: E=McAfee;i="6000,8403,9832"; a="154367833"
X-IronPort-AV: E=Sophos;i="5.78,414,1599548400"; 
   d="gz'50?scan'50,208,50";a="154367833"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2020 07:27:04 -0800
IronPort-SDR: E4w3qcpmzvC9BxmY3LML5n5QA7dd0YMcn2g1/T+moFyMoTF3ESGfAsRPDwcTy6ZR3Fn2I21aJd
 M+Fm3hwu8a2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,414,1599548400"; 
   d="gz'50?scan'50,208,50";a="350157046"
Received: from lkp-server01.sh.intel.com (HELO ecc0cebe68d1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 12 Dec 2020 07:27:02 -0800
Received: from kbuild by ecc0cebe68d1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1ko6nV-0001OX-SM; Sat, 12 Dec 2020 15:27:01 +0000
Date:   Sat, 12 Dec 2020 23:26:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Steve French <stfrench@microsoft.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [cifs:for-next 19/27] fs/cifs/cifsproto.h:96:4: error: unknown type
 name 'mid_receive_t'
Message-ID: <202012122315.zC0NqLRC-lkp@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   git://git.samba.org/sfrench/cifs-2.6.git for-next
head:   0993a0c9c281b516fe97dc77646b87d45c3fbf17
commit: b69c063066231af65879321fd53cd371c106fa82 [19/27] cifs: cleanup misc.c
config: x86_64-randconfig-s021-20201209 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-15) 9.3.0
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.3-179-ga00755aa-dirty
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs for-next
        git checkout b69c063066231af65879321fd53cd371c106fa82
        # save the attached .config to linux build tree
        make W=1 C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' ARCH=x86_64 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   In file included from fs/cifs/unc.c:11:
>> fs/cifs/cifsproto.h:44:28: warning: 'struct TCP_Server_Info' declared inside parameter list will not be visible outside of this definition or declaration
      44 | extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
         |                            ^~~~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:77:17: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
      77 |          struct cifs_tcon *tcon,
         |                 ^~~~~~~~~
>> fs/cifs/cifsproto.h:76:17: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
      76 |          struct cifs_sb_info *cifs_sb,
         |                 ^~~~~~~~~~~~
>> fs/cifs/cifsproto.h:81:38: warning: 'struct dfs_info3_param' declared inside parameter list will not be visible outside of this definition or declaration
      81 |   const char *fullpath, const struct dfs_info3_param *ref);
         |                                      ^~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:84:13: warning: 'struct TCP_Server_Info' declared inside parameter list will not be visible outside of this definition or declaration
      84 |      struct TCP_Server_Info *server);
         |             ^~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:89:40: warning: 'struct TCP_Server_Info' declared inside parameter list will not be visible outside of this definition or declaration
      89 | extern int cifs_handle_standard(struct TCP_Server_Info *server,
         |                                        ^~~~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:92:38: warning: 'struct sockaddr' declared inside parameter list will not be visible outside of this definition or declaration
      92 | extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
         |                                      ^~~~~~~~
   fs/cifs/cifsproto.h:93:47: warning: 'struct TCP_Server_Info' declared inside parameter list will not be visible outside of this definition or declaration
      93 | extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
         |                                               ^~~~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:96:4: error: unknown type name 'mid_receive_t'
      96 |    mid_receive_t *receive, mid_callback_t *callback,
         |    ^~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:96:28: error: unknown type name 'mid_callback_t'; did you mean 'rcu_callback_t'?
      96 |    mid_receive_t *receive, mid_callback_t *callback,
         |                            ^~~~~~~~~~~~~~
         |                            rcu_callback_t
>> fs/cifs/cifsproto.h:97:4: error: unknown type name 'mid_handle_t'
      97 |    mid_handle_t *handle, void *cbdata, const int flags,
         |    ^~~~~~~~~~~~
>> fs/cifs/cifsproto.h:99:57: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
      99 | extern struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
         |                                                         ^~~~~~~~
>> fs/cifs/cifsproto.h:103:30: warning: 'struct kvec' declared inside parameter list will not be visible outside of this definition or declaration
     103 |      const int flags, struct kvec *resp_iov);
         |                              ^~~~
   fs/cifs/cifsproto.h:100:58: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     100 | extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
         |                                                          ^~~~~~~~
   fs/cifs/cifsproto.h:108:17: warning: 'struct kvec' declared inside parameter list will not be visible outside of this definition or declaration
     108 |          struct kvec *resp_iov);
         |                 ^~~~
   fs/cifs/cifsproto.h:104:62: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     104 | extern int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
         |                                                              ^~~~~~~~
   fs/cifs/cifsproto.h:109:62: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     109 | extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
         |                                                              ^~~~~~~~
   fs/cifs/cifsproto.h:113:60: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     113 | extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
         |                                                            ^~~~~~~~
   fs/cifs/cifsproto.h:115:54: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     115 | extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
         |                                                      ^~~~~~~~
>> fs/cifs/cifsproto.h:124:13: warning: 'struct cifs_credits' declared inside parameter list will not be visible outside of this definition or declaration
     124 |      struct cifs_credits *credits);
         |             ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:126:11: warning: 'struct kvec' declared inside parameter list will not be visible outside of this definition or declaration
     126 |    struct kvec *, int /* nvec to send */,
         |           ^~~~
   fs/cifs/cifsproto.h:125:63: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     125 | extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
         |                                                               ^~~~~~~~
   fs/cifs/cifsproto.h:130:11: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     130 |    struct cifs_tcon *ptcon,
         |           ^~~~~~~~~
   fs/cifs/cifsproto.h:137:32: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     137 | extern bool backup_cred(struct cifs_sb_info *);
         |                                ^~~~~~~~~~~~
>> fs/cifs/cifsproto.h:138:43: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     138 | extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
         |                                           ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:139:36: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     139 | extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
         |                                    ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:141:55: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     141 | extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
         |                                                       ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:142:42: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     142 | extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
         |                                          ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:145:42: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     145 | extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
         |                                          ^~~~~~~~~
   fs/cifs/cifsproto.h:148:55: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     148 | extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
         |                                                       ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:149:42: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     149 | extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
         |                                          ^~~~~~~~~
   fs/cifs/cifsproto.h:154:40: warning: 'struct sockaddr' declared inside parameter list will not be visible outside of this definition or declaration
     154 | extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
         |                                        ^~~~~~~~
   fs/cifs/cifsproto.h:155:34: warning: 'struct sockaddr' declared inside parameter list will not be visible outside of this definition or declaration
     155 | extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
         |                                  ^~~~~~~~
   fs/cifs/cifsproto.h:159:21: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     159 |        const struct cifs_tcon *, int /* length of
         |                     ^~~~~~~~~
   fs/cifs/cifsproto.h:162:12: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     162 |     struct cifs_ses *ses,
         |            ^~~~~~~~
   fs/cifs/cifsproto.h:166:58: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     166 | extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
         |                                                          ^~~~~~~~
   fs/cifs/cifsproto.h:172:42: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     172 | extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
         |                                          ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:173:35: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     173 | extern int cifs_get_writer(struct cifsInodeInfo *cinode);
         |                                   ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:174:36: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     174 | extern void cifs_put_writer(struct cifsInodeInfo *cinode);
         |                                    ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:175:43: warning: 'struct cifsInodeInfo' declared inside parameter list will not be visible outside of this definition or declaration
     175 | extern void cifs_done_oplock_break(struct cifsInodeInfo *cinode);
         |                                           ^~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:177:16: warning: 'struct file_lock' declared inside parameter list will not be visible outside of this definition or declaration
     177 |         struct file_lock *flock, const unsigned int xid);
         |                ^~~~~~~~~
>> fs/cifs/cifsproto.h:183:19: warning: 'struct tcon_link' declared inside parameter list will not be visible outside of this definition or declaration
     183 |            struct tcon_link *tlink,
         |                   ^~~~~~~~~
>> fs/cifs/cifsproto.h:181:54: warning: 'struct cifs_fid' declared inside parameter list will not be visible outside of this definition or declaration
     181 | extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
         |                                                      ^~~~~~~~
>> fs/cifs/cifsproto.h:189:56: warning: 'struct cifs_fattr' declared inside parameter list will not be visible outside of this definition or declaration
     189 | void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
         |                                                        ^~~~~~~~~~
>> fs/cifs/cifsproto.h:191:10: error: unknown type name 'FILE_UNIX_BASIC_INFO'
     191 |          FILE_UNIX_BASIC_INFO *info,
         |          ^~~~~~~~~~~~~~~~~~~~
>> fs/cifs/cifsproto.h:193:57: error: unknown type name 'FILE_DIRECTORY_INFO'
     193 | extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
         |                                                         ^~~~~~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:195:61: warning: 'struct cifs_fattr' declared inside parameter list will not be visible outside of this definition or declaration
     195 | extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
         |                                                             ^~~~~~~~~~
   fs/cifs/cifsproto.h:197:18: warning: 'struct cifs_fattr' declared inside parameter list will not be visible outside of this definition or declaration
     197 |           struct cifs_fattr *fattr);
         |                  ^~~~~~~~~~
>> fs/cifs/cifsproto.h:200:11: error: unknown type name 'FILE_ALL_INFO'
     200 |           FILE_ALL_INFO *data, struct super_block *sb,
         |           ^~~~~~~~~~~~~
   fs/cifs/cifsproto.h:213:12: warning: 'struct cifs_fattr' declared inside parameter list will not be visible outside of this definition or declaration
     213 |     struct cifs_fattr *fattr, uint sidtype);
         |            ^~~~~~~~~~
>> fs/cifs/cifsproto.h:212:59: warning: 'struct cifs_sid' declared inside parameter list will not be visible outside of this definition or declaration
     212 | extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
         |                                                           ^~~~~~~~
   fs/cifs/cifsproto.h:212:29: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     212 | extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
         |                             ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:217:41: warning: 'struct cifs_fid' declared inside parameter list will not be visible outside of this definition or declaration
     217 |          const char *path, const struct cifs_fid *pfid);
         |                                         ^~~~~~~~
   fs/cifs/cifsproto.h:215:17: warning: 'struct cifs_fattr' declared inside parameter list will not be visible outside of this definition or declaration
     215 |          struct cifs_fattr *fattr, struct inode *inode,
         |                 ^~~~~~~~~~
   fs/cifs/cifsproto.h:214:37: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     214 | extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
         |                                     ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:220:46: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     220 | extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
         |                                              ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:223:20: warning: 'struct cifs_fid' declared inside parameter list will not be visible outside of this definition or declaration
     223 |       const struct cifs_fid *, u32 *);
         |                    ^~~~~~~~
   fs/cifs/cifsproto.h:222:53: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     222 | extern struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *,
         |                                                     ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:226:48: warning: 'struct cifs_ace' declared inside parameter list will not be visible outside of this definition or declaration
     226 | extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
         |                                                ^~~~~~~~
   fs/cifs/cifsproto.h:227:51: warning: 'struct cifs_ace' declared inside parameter list will not be visible outside of this definition or declaration
     227 | extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
         |                                                   ^~~~~~~~
   fs/cifs/cifsproto.h:228:57: warning: 'struct cifs_ace' declared inside parameter list will not be visible outside of this definition or declaration
     228 | extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
         |                                                         ^~~~~~~~
   fs/cifs/cifsproto.h:238:18: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     238 |           struct cifs_sb_info *cifs_sb);
         |                  ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:241:30: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     241 | extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
         |                              ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:242:32: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     242 | extern void cifs_umount(struct cifs_sb_info *);
         |                                ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:243:49: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     243 | extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
         |                                                 ^~~~~~~~~
   fs/cifs/cifsproto.h:244:51: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     244 | extern void cifs_reopen_persistent_handles(struct cifs_tcon *tcon);
         |                                                   ^~~~~~~~~
   fs/cifs/cifsproto.h:248:16: warning: 'struct cifsLockInfo' declared inside parameter list will not be visible outside of this definition or declaration
     248 |         struct cifsLockInfo **conf_lock,
         |                ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:252:14: warning: 'struct cifs_pending_open' declared inside parameter list will not be visible outside of this definition or declaration
     252 |       struct cifs_pending_open *open);
         |              ^~~~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:251:14: warning: 'struct tcon_link' declared inside parameter list will not be visible outside of this definition or declaration
     251 |       struct tcon_link *tlink,
         |              ^~~~~~~~~
   fs/cifs/cifsproto.h:250:42: warning: 'struct cifs_fid' declared inside parameter list will not be visible outside of this definition or declaration
     250 | extern void cifs_add_pending_open(struct cifs_fid *fid,
         |                                          ^~~~~~~~
   fs/cifs/cifsproto.h:255:14: warning: 'struct cifs_pending_open' declared inside parameter list will not be visible outside of this definition or declaration
     255 |       struct cifs_pending_open *open);
         |              ^~~~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:254:14: warning: 'struct tcon_link' declared inside parameter list will not be visible outside of this definition or declaration
     254 |       struct tcon_link *tlink,
         |              ^~~~~~~~~
   fs/cifs/cifsproto.h:253:49: warning: 'struct cifs_fid' declared inside parameter list will not be visible outside of this definition or declaration
     253 | extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
         |                                                 ^~~~~~~~
   fs/cifs/cifsproto.h:256:42: warning: 'struct cifs_pending_open' declared inside parameter list will not be visible outside of this definition or declaration
     256 | extern void cifs_del_pending_open(struct cifs_pending_open *open);
         |                                          ^~~~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:260:34: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     260 | extern void cifs_put_tcon(struct cifs_tcon *tcon);
         |                                  ^~~~~~~~~
   fs/cifs/cifsproto.h:273:42: warning: 'struct cifsLockInfo' declared inside parameter list will not be visible outside of this definition or declaration
     273 | extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
         |                                          ^~~~~~~~~~~~
   fs/cifs/cifsproto.h:275:61: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     275 | extern int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon,
         |                                                             ^~~~~~~~~
   fs/cifs/cifsproto.h:279:15: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     279 |        struct cifs_ses *ses);
         |               ^~~~~~~~
   fs/cifs/cifsproto.h:280:62: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     280 | extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
         |                                                              ^~~~~~~~
   fs/cifs/cifsproto.h:283:60: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     283 | extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
         |                                                            ^~~~~~~~
   fs/cifs/cifsproto.h:286:32: warning: 'struct cifs_tcon' declared inside parameter list will not be visible outside of this definition or declaration
     286 |       const char *tree, struct cifs_tcon *tcon,
         |                                ^~~~~~~~~
   fs/cifs/cifsproto.h:285:52: warning: 'struct cifs_ses' declared inside parameter list will not be visible outside of this definition or declaration
     285 | extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
         |                                                    ^~~~~~~~
   fs/cifs/cifsproto.h:292:10: warning: 'struct cifs_search_info' declared inside parameter list will not be visible outside of this definition or declaration
     292 |   struct cifs_search_info *psrch_inf,
         |          ^~~~~~~~~~~~~~~~
   fs/cifs/cifsproto.h:290:34: warning: 'struct cifs_sb_info' declared inside parameter list will not be visible outside of this definition or declaration
     290 |   const char *searchName, struct cifs_sb_info *cifs_sb,

vim +/mid_receive_t +96 fs/cifs/cifsproto.h

^1da177e4c3f415 Linus Torvalds             2005-04-16   32  
^1da177e4c3f415 Linus Torvalds             2005-04-16   33  /*
^1da177e4c3f415 Linus Torvalds             2005-04-16   34   *****************************************************************
^1da177e4c3f415 Linus Torvalds             2005-04-16   35   * All Prototypes
^1da177e4c3f415 Linus Torvalds             2005-04-16   36   *****************************************************************
^1da177e4c3f415 Linus Torvalds             2005-04-16   37   */
^1da177e4c3f415 Linus Torvalds             2005-04-16   38  
^1da177e4c3f415 Linus Torvalds             2005-04-16   39  extern struct smb_hdr *cifs_buf_get(void);
^1da177e4c3f415 Linus Torvalds             2005-04-16   40  extern void cifs_buf_release(void *);
^1da177e4c3f415 Linus Torvalds             2005-04-16   41  extern struct smb_hdr *cifs_small_buf_get(void);
^1da177e4c3f415 Linus Torvalds             2005-04-16   42  extern void cifs_small_buf_release(void *);
6d81ed1ec22dbe9 Sachin Prabhu              2014-06-16   43  extern void free_rsp_buf(int, void *);
0496e02d8791e7f Jeff Layton                2008-12-30  @44  extern int smb_send(struct TCP_Server_Info *, struct smb_hdr *,
0496e02d8791e7f Jeff Layton                2008-12-30   45  			unsigned int /* length */);
6d5786a34d98bff Pavel Shilovsky            2012-06-20   46  extern unsigned int _get_xid(void);
6d5786a34d98bff Pavel Shilovsky            2012-06-20   47  extern void _free_xid(unsigned int);
6d5786a34d98bff Pavel Shilovsky            2012-06-20   48  #define get_xid()							\
b6b38f704a8193d Joe Perches                2010-04-21   49  ({									\
6d5786a34d98bff Pavel Shilovsky            2012-06-20   50  	unsigned int __xid = _get_xid();				\
a0a3036b81f1f66 Joe Perches                2020-04-14   51  	cifs_dbg(FYI, "VFS: in %s as Xid: %u with uid: %d\n",		\
dbfb98af18194cf Eric W. Biederman          2013-02-06   52  		 __func__, __xid,					\
dbfb98af18194cf Eric W. Biederman          2013-02-06   53  		 from_kuid(&init_user_ns, current_fsuid()));		\
d683bcd3e5d1575 Steve French               2018-05-19   54  	trace_smb3_enter(__xid, __func__);				\
b6b38f704a8193d Joe Perches                2010-04-21   55  	__xid;								\
b6b38f704a8193d Joe Perches                2010-04-21   56  })
b6b38f704a8193d Joe Perches                2010-04-21   57  
6d5786a34d98bff Pavel Shilovsky            2012-06-20   58  #define free_xid(curr_xid)						\
b6b38f704a8193d Joe Perches                2010-04-21   59  do {									\
6d5786a34d98bff Pavel Shilovsky            2012-06-20   60  	_free_xid(curr_xid);						\
a0a3036b81f1f66 Joe Perches                2020-04-14   61  	cifs_dbg(FYI, "VFS: leaving %s (xid = %u) rc = %d\n",		\
b6b38f704a8193d Joe Perches                2010-04-21   62  		 __func__, curr_xid, (int)rc);				\
d683bcd3e5d1575 Steve French               2018-05-19   63  	if (rc)								\
d683bcd3e5d1575 Steve French               2018-05-19   64  		trace_smb3_exit_err(curr_xid, __func__, (int)rc);	\
d683bcd3e5d1575 Steve French               2018-05-19   65  	else								\
d683bcd3e5d1575 Steve French               2018-05-19   66  		trace_smb3_exit_done(curr_xid, __func__);		\
b6b38f704a8193d Joe Perches                2010-04-21   67  } while (0)
4d79dba0e00749f Shirish Pargaonkar         2011-04-27   68  extern int init_cifs_idmap(void);
4d79dba0e00749f Shirish Pargaonkar         2011-04-27   69  extern void exit_cifs_idmap(void);
b74cb9a80268be5 Sachin Prabhu              2016-05-17   70  extern int init_cifs_spnego(void);
b74cb9a80268be5 Sachin Prabhu              2016-05-17   71  extern void exit_cifs_spnego(void);
7f57356b70dda01 Steve French               2005-08-30   72  extern char *build_path_from_dentry(struct dentry *);
268a635d414df45 Aurelien Aptel             2017-02-13   73  extern char *build_path_from_dentry_optional_prefix(struct dentry *direntry,
268a635d414df45 Aurelien Aptel             2017-02-13   74  						    bool prefix);
2727ef44ea4615d Ronnie Sahlberg            2020-12-09   75  extern char *cifs_build_path_to_root(struct smb3_fs_context *ctx,
6d3ea7e4975aed4 Steve French               2012-11-28  @76  				     struct cifs_sb_info *cifs_sb,
374402a2a1dfbbe Sachin Prabhu              2016-12-15  @77  				     struct cifs_tcon *tcon,
374402a2a1dfbbe Sachin Prabhu              2016-12-15   78  				     int add_treename);
^1da177e4c3f415 Linus Torvalds             2005-04-16   79  extern char *build_wildcard_path_from_dentry(struct dentry *direntry);
c6c00919ab16717 Steve French               2009-03-18   80  extern char *cifs_compose_mount_options(const char *sb_mountdata,
75df213664c3e17 Ronnie Sahlberg            2020-12-10  @81  		const char *fullpath, const struct dfs_info3_param *ref);
99ee4dbd7c99c27 Steve French               2007-02-27   82  /* extern void renew_parental_timestamps(struct dentry *direntry);*/
a6827c184ea9f54 Jeff Layton                2011-01-11   83  extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
a6827c184ea9f54 Jeff Layton                2011-01-11   84  					struct TCP_Server_Info *server);
766fdbb57fdb1e5 Jeff Layton                2011-01-11   85  extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
3c1bf7e48e9e463 Pavel Shilovsky            2012-09-18   86  extern void cifs_delete_mid(struct mid_q_entry *mid);
696e420bb2a6624 Lars Persson               2018-06-25   87  extern void cifs_mid_q_entry_release(struct mid_q_entry *midEntry);
2dc7e1c03316940 Pavel Shilovsky            2011-12-26   88  extern void cifs_wake_up_task(struct mid_q_entry *mid);
4326ed2f6a16ae9 Pavel Shilovsky            2016-11-17   89  extern int cifs_handle_standard(struct TCP_Server_Info *server,
4326ed2f6a16ae9 Pavel Shilovsky            2016-11-17   90  				struct mid_q_entry *mid);
46711d0f0e67bd0 Ronnie Sahlberg            2020-11-05   91  extern int smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx);
e4af35fa55b0721 Paulo Alcantara            2020-05-19  @92  extern bool cifs_match_ipaddr(struct sockaddr *srcaddr, struct sockaddr *rhs);
350be257ea83029 Pavel Shilovsky            2017-04-10   93  extern int cifs_discard_remaining_data(struct TCP_Server_Info *server);
fec344e3f31aa91 Jeff Layton                2012-09-18   94  extern int cifs_call_async(struct TCP_Server_Info *server,
fec344e3f31aa91 Jeff Layton                2012-09-18   95  			struct smb_rqst *rqst,
fec344e3f31aa91 Jeff Layton                2012-09-18  @96  			mid_receive_t *receive, mid_callback_t *callback,
3349c3a79fb5d76 Pavel Shilovsky            2019-01-15  @97  			mid_handle_t *handle, void *cbdata, const int flags,
3349c3a79fb5d76 Pavel Shilovsky            2019-01-15   98  			const struct cifs_credits *exist_credits);
5f68ea4aa98bcdd Aurelien Aptel             2020-04-22  @99  extern struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses);
b8f57ee8aad414a Pavel Shilovsky            2016-11-23  100  extern int cifs_send_recv(const unsigned int xid, struct cifs_ses *ses,
352d96f3acc6e02 Aurelien Aptel             2020-05-31  101  			  struct TCP_Server_Info *server,
b8f57ee8aad414a Pavel Shilovsky            2016-11-23  102  			  struct smb_rqst *rqst, int *resp_buf_type,
b8f57ee8aad414a Pavel Shilovsky            2016-11-23 @103  			  const int flags, struct kvec *resp_iov);
e0bba0b8548179b Ronnie Sahlberg            2018-08-01  104  extern int compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
352d96f3acc6e02 Aurelien Aptel             2020-05-31  105  			      struct TCP_Server_Info *server,
e0bba0b8548179b Ronnie Sahlberg            2018-08-01  106  			      const int flags, const int num_rqst,
e0bba0b8548179b Ronnie Sahlberg            2018-08-01  107  			      struct smb_rqst *rqst, int *resp_buf_type,
e0bba0b8548179b Ronnie Sahlberg            2018-08-01  108  			      struct kvec *resp_iov);
96daf2b09178d8e Steve French               2011-05-27  109  extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
^1da177e4c3f415 Linus Torvalds             2005-04-16  110  			struct smb_hdr * /* input */ ,
^1da177e4c3f415 Linus Torvalds             2005-04-16  111  			struct smb_hdr * /* out */ ,
a891f0f895f4a76 Pavel Shilovsky            2012-05-23  112  			int * /* bytes returned */ , const int);
96daf2b09178d8e Steve French               2011-05-27  113  extern int SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
792af7b05b8a78d Pavel Shilovsky            2012-03-23  114  			    char *in_buf, int flags);
fec344e3f31aa91 Jeff Layton                2012-09-18  115  extern struct mid_q_entry *cifs_setup_request(struct cifs_ses *,
f780bd3fef17c4f Aurelien Aptel             2019-09-20  116  				struct TCP_Server_Info *,
fec344e3f31aa91 Jeff Layton                2012-09-18  117  				struct smb_rqst *);
fec344e3f31aa91 Jeff Layton                2012-09-18  118  extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
fec344e3f31aa91 Jeff Layton                2012-09-18  119  						struct smb_rqst *);
2c8f981d93f830c Jeff Layton                2011-05-19  120  extern int cifs_check_receive(struct mid_q_entry *mid,
2c8f981d93f830c Jeff Layton                2011-05-19  121  			struct TCP_Server_Info *server, bool log_error);
cb7e9eabb2b5848 Pavel Shilovsky            2014-06-05  122  extern int cifs_wait_mtu_credits(struct TCP_Server_Info *server,
cb7e9eabb2b5848 Pavel Shilovsky            2014-06-05  123  				 unsigned int size, unsigned int *num,
335b7b62ffb69d1 Pavel Shilovsky            2019-01-16 @124  				 struct cifs_credits *credits);
96daf2b09178d8e Steve French               2011-05-27  125  extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
84afc29b185334f Steve French               2005-12-02  126  			struct kvec *, int /* nvec to send */,
da502f7df03d2d0 Pavel Shilovsky            2016-10-25  127  			int * /* type of buf returned */, const int flags,
da502f7df03d2d0 Pavel Shilovsky            2016-10-25  128  			struct kvec * /* resp vec */);
ad7a2926b9e53cf Steve French               2008-02-07  129  extern int SendReceiveBlockingLock(const unsigned int xid,
96daf2b09178d8e Steve French               2011-05-27  130  			struct cifs_tcon *ptcon,
ad7a2926b9e53cf Steve French               2008-02-07  131  			struct smb_hdr *in_buf ,
ad7a2926b9e53cf Steve French               2008-02-07  132  			struct smb_hdr *out_buf,
ad7a2926b9e53cf Steve French               2008-02-07  133  			int *bytes_returned);
28ea5290d78a7fc Pavel Shilovsky            2012-05-23  134  extern int cifs_reconnect(struct TCP_Server_Info *server);
373512ec5c105ed Steve French               2015-12-18  135  extern int checkSMB(char *buf, unsigned int len, struct TCP_Server_Info *srvr);
d4e4854fd1c85ac Pavel Shilovsky            2012-03-23  136  extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
3d3ea8e64efbeb3 Shirish Pargaonkar         2011-09-26  137  extern bool backup_cred(struct cifs_sb_info *);
4b18f2a9c3964f7 Steve French               2008-04-29 @138  extern bool is_size_safe_to_change(struct cifsInodeInfo *, __u64 eof);
72432ffcf555dec Pavel Shilovsky            2011-01-24  139  extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
72432ffcf555dec Pavel Shilovsky            2011-01-24  140  			    unsigned int bytes_written);
86f740f2aed5ea7 Aurelien Aptel             2020-02-21  141  extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, int);
fe768d51c832ebd Pavel Shilovsky            2019-01-29  142  extern int cifs_get_writable_file(struct cifsInodeInfo *cifs_inode,
86f740f2aed5ea7 Aurelien Aptel             2020-02-21  143  				  int flags,
fe768d51c832ebd Pavel Shilovsky            2019-01-29  144  				  struct cifsFileInfo **ret_file);
8de9e86c67baa71 Ronnie Sahlberg            2019-08-30  145  extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
86f740f2aed5ea7 Aurelien Aptel             2020-02-21  146  				  int flags,
8de9e86c67baa71 Ronnie Sahlberg            2019-08-30  147  				  struct cifsFileInfo **ret_file);
6508d904e6fb66c Jeff Layton                2010-09-29  148  extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
496902dc173dead Ronnie Sahlberg            2019-09-09  149  extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
496902dc173dead Ronnie Sahlberg            2019-09-09  150  				  struct cifsFileInfo **ret_file);
9ec672bd17131fe Ronnie Sahlberg            2018-04-22  151  extern unsigned int smbCalcSize(void *buf, struct TCP_Server_Info *server);
^1da177e4c3f415 Linus Torvalds             2005-04-16  152  extern int decode_negTokenInit(unsigned char *security_blob, int length,
26efa0bac9dc358 Jeff Layton                2010-04-24  153  			struct TCP_Server_Info *server);
67b7626a0512d12 David Howells              2010-07-22  154  extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
b979aaa17772593 Jeff Layton                2012-11-26  155  extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
5ffef7bf1dd582e Pavel Shilovsky            2012-03-23  156  extern int map_smb_to_linux_error(char *buf, bool logErr);
a3713ec3d775ff9 Roberto Bergantinos Corpas 2020-07-03  157  extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
^1da177e4c3f415 Linus Torvalds             2005-04-16  158  extern void header_assemble(struct smb_hdr *, char /* command */ ,
96daf2b09178d8e Steve French               2011-05-27  159  			    const struct cifs_tcon *, int /* length of
1982c344f1bf081 Steve French               2005-08-17  160  			    fixed section (word count) in two byte units */);
5815449d1bfcb22 Steve French               2006-02-14  161  extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
96daf2b09178d8e Steve French               2011-05-27  162  				struct cifs_ses *ses,
12b3b8ffb5fd591 Steve French               2006-02-09  163  				void **request_buf);
3f618223dc0bdcb Jeff Layton                2013-06-12  164  extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
3f618223dc0bdcb Jeff Layton                2013-06-12  165  				enum securityEnum requested);
58c45c58a1cbc8d Pavel Shilovsky            2012-05-25  166  extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
5815449d1bfcb22 Steve French               2006-02-14  167  			  const struct nls_table *nls_cp);
95390201e7d8dd1 Arnd Bergmann              2018-06-19  168  extern struct timespec64 cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
95390201e7d8dd1 Arnd Bergmann              2018-06-19  169  extern u64 cifs_UnixTimeToNT(struct timespec64);
95390201e7d8dd1 Arnd Bergmann              2018-06-19  170  extern struct timespec64 cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
c4a2c08db7d976c Jeff Layton                2009-05-27  171  				      int offset);
c67236281c5d749 Pavel Shilovsky            2010-11-03  172  extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
c11f1df5003d534 Sachin Prabhu              2014-03-11  173  extern int cifs_get_writer(struct cifsInodeInfo *cinode);
c11f1df5003d534 Sachin Prabhu              2014-03-11  174  extern void cifs_put_writer(struct cifsInodeInfo *cinode);
c11f1df5003d534 Sachin Prabhu              2014-03-11  175  extern void cifs_done_oplock_break(struct cifsInodeInfo *cinode);
d39a4f710b7a7be Pavel Shilovsky            2012-09-19  176  extern int cifs_unlock_range(struct cifsFileInfo *cfile,
d39a4f710b7a7be Pavel Shilovsky            2012-09-19 @177  			     struct file_lock *flock, const unsigned int xid);
d39a4f710b7a7be Pavel Shilovsky            2012-09-19  178  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
1bd5bbcb6531776 Steve French               2006-09-28  179  
d46b0da7a33dd8c Dave Wysochanski           2019-10-23  180  extern void cifs_down_write(struct rw_semaphore *sem);
fb1214e48f735cd Pavel Shilovsky            2012-09-18 @181  extern struct cifsFileInfo *cifs_new_fileinfo(struct cifs_fid *fid,
fb1214e48f735cd Pavel Shilovsky            2012-09-18  182  					      struct file *file,
fb1214e48f735cd Pavel Shilovsky            2012-09-18 @183  					      struct tcon_link *tlink,
7a16f1961a5c61d Steve French               2010-10-18  184  					      __u32 oplock);
6d5786a34d98bff Pavel Shilovsky            2012-06-20  185  extern int cifs_posix_open(char *full_path, struct inode **inode,
6d5786a34d98bff Pavel Shilovsky            2012-06-20  186  			   struct super_block *sb, int mode,
6d5786a34d98bff Pavel Shilovsky            2012-06-20  187  			   unsigned int f_flags, __u32 *oplock, __u16 *netfid,
6d5786a34d98bff Pavel Shilovsky            2012-06-20  188  			   unsigned int xid);
4065c802da7484f Jeff Layton                2010-05-17 @189  void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
cc0bad7552308e8 Jeff Layton                2009-06-25  190  extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
cc0bad7552308e8 Jeff Layton                2009-06-25 @191  				     FILE_UNIX_BASIC_INFO *info,
cc0bad7552308e8 Jeff Layton                2009-06-25  192  				     struct cifs_sb_info *cifs_sb);
c052e2b423f3eab Shirish Pargaonkar         2012-09-28 @193  extern void cifs_dir_info_to_fattr(struct cifs_fattr *, FILE_DIRECTORY_INFO *,
c052e2b423f3eab Shirish Pargaonkar         2012-09-28  194  					struct cifs_sb_info *);
cc0bad7552308e8 Jeff Layton                2009-06-25  195  extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
cc0bad7552308e8 Jeff Layton                2009-06-25  196  extern struct inode *cifs_iget(struct super_block *sb,
cc0bad7552308e8 Jeff Layton                2009-06-25  197  			       struct cifs_fattr *fattr);
cc0bad7552308e8 Jeff Layton                2009-06-25  198  
1208ef1f76540b6 Pavel Shilovsky            2012-05-27  199  extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
1208ef1f76540b6 Pavel Shilovsky            2012-05-27 @200  			       FILE_ALL_INFO *data, struct super_block *sb,
42eacf9e57b65ff Steve French               2014-02-10  201  			       int xid, const struct cifs_fid *fid);
6a5f6592a0b606e Steve French               2020-06-11  202  extern int smb311_posix_get_inode_info(struct inode **pinode, const char *search_path,
6a5f6592a0b606e Steve French               2020-06-11  203  			struct super_block *sb, unsigned int xid);
^1da177e4c3f415 Linus Torvalds             2005-04-16  204  extern int cifs_get_inode_info_unix(struct inode **pinode,
^1da177e4c3f415 Linus Torvalds             2005-04-16  205  			const unsigned char *search_path,
6d5786a34d98bff Pavel Shilovsky            2012-06-20  206  			struct super_block *sb, unsigned int xid);
ed6875e0d6c28e4 Pavel Shilovsky            2012-09-18  207  extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
ed6875e0d6c28e4 Pavel Shilovsky            2012-09-18  208  			      unsigned int xid, char *full_path, __u32 dosattr);
ed6875e0d6c28e4 Pavel Shilovsky            2012-09-18  209  extern int cifs_rename_pending_delete(const char *full_path,
ed6875e0d6c28e4 Pavel Shilovsky            2012-09-18  210  				      struct dentry *dentry,
ed6875e0d6c28e4 Pavel Shilovsky            2012-09-18  211  				      const unsigned int xid);
9934430e2178d51 Steve French               2020-10-20 @212  extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
9934430e2178d51 Steve French               2020-10-20  213  				struct cifs_fattr *fattr, uint sidtype);
987b21d7d91d033 Shirish Pargaonkar         2010-11-10  214  extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
0b8f18e358384a5 Jeff Layton                2009-07-09  215  			      struct cifs_fattr *fattr, struct inode *inode,
e2f8fbfb8d09c06 Steve French               2019-07-19  216  			      bool get_mode_from_special_sid,
42eacf9e57b65ff Steve French               2014-02-10  217  			      const char *path, const struct cifs_fid *pfid);
672f807bec7d793 Shyam Prasad N             2020-08-17  218  extern int id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 *pnmode,
672f807bec7d793 Shyam Prasad N             2020-08-17  219  					kuid_t uid, kgid_t gid);
fbeba8bb16d7c50 Shirish Pargaonkar         2010-11-27  220  extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
fbeba8bb16d7c50 Shirish Pargaonkar         2010-11-27  221  					const char *, u32 *);
42eacf9e57b65ff Steve French               2014-02-10  222  extern struct cifs_ntsd *get_cifs_acl_by_fid(struct cifs_sb_info *,
42eacf9e57b65ff Steve French               2014-02-10  223  						const struct cifs_fid *, u32 *);
b73b9a4ba753dfd Steve French               2011-04-19  224  extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
a5ff376966c079b Shirish Pargaonkar         2011-10-13  225  				const char *, int);
643fbceef48e5b2 Steve French               2020-01-16 @226  extern unsigned int setup_authusers_ACE(struct cifs_ace *pace);
fdef665ba44ad5e Steve French               2019-12-06  227  extern unsigned int setup_special_mode_ACE(struct cifs_ace *pace, __u64 nmode);
975221eca5fbfdb Steve French               2020-06-12  228  extern unsigned int setup_special_user_owner_ACE(struct cifs_ace *pace);
953f868138dbf43 Steve French               2007-10-31  229  
e28bc5b1fdbd6e8 Jeff Layton                2011-10-19  230  extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
e28bc5b1fdbd6e8 Jeff Layton                2011-10-19  231  extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
e28bc5b1fdbd6e8 Jeff Layton                2011-10-19  232  			         unsigned int to_read);
71335664c38f03d Al Viro                    2016-01-09  233  extern int cifs_read_page_from_socket(struct TCP_Server_Info *server,
1dbe3466b4d2607 Long Li                    2018-05-30  234  					struct page *page,
1dbe3466b4d2607 Long Li                    2018-05-30  235  					unsigned int page_offset,
1dbe3466b4d2607 Long Li                    2018-05-30  236  					unsigned int to_read);
2727ef44ea4615d Ronnie Sahlberg            2020-12-09  237  extern int cifs_setup_cifs_sb(struct smb3_fs_context *ctx,
724d9f1cfba0cb1 Pavel Shilovsky            2011-05-05  238  			       struct cifs_sb_info *cifs_sb);
724d9f1cfba0cb1 Pavel Shilovsky            2011-05-05  239  extern int cifs_match_super(struct super_block *, void *);
2727ef44ea4615d Ronnie Sahlberg            2020-12-09  240  extern void cifs_cleanup_volume_info(struct smb3_fs_context *ctx);
2727ef44ea4615d Ronnie Sahlberg            2020-12-09  241  extern int cifs_mount(struct cifs_sb_info *cifs_sb, struct smb3_fs_context *ctx);
2a9b99516c662d1 Al Viro                    2011-06-17  242  extern void cifs_umount(struct cifs_sb_info *);
aa24d1e9692411e Pavel Shilovsky            2011-12-27  243  extern void cifs_mark_open_files_invalid(struct cifs_tcon *tcon);
52ace1ef1259e11 Steve French               2016-09-22  244  extern void cifs_reopen_persistent_handles(struct cifs_tcon *tcon);
52ace1ef1259e11 Steve French               2016-09-22  245  
579f9053236c796 Pavel Shilovsky            2012-09-19  246  extern bool cifs_find_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
9645759ce6b3901 Ronnie Sahlberg            2018-10-04  247  				    __u64 length, __u8 type, __u16 flags,
579f9053236c796 Pavel Shilovsky            2012-09-19 @248  				    struct cifsLockInfo **conf_lock,
081c0414dcdfd13 Pavel Shilovsky            2012-11-27  249  				    int rw_check);
233839b1df65a24 Pavel Shilovsky            2012-09-19  250  extern void cifs_add_pending_open(struct cifs_fid *fid,
233839b1df65a24 Pavel Shilovsky            2012-09-19  251  				  struct tcon_link *tlink,
233839b1df65a24 Pavel Shilovsky            2012-09-19 @252  				  struct cifs_pending_open *open);
233839b1df65a24 Pavel Shilovsky            2012-09-19  253  extern void cifs_add_pending_open_locked(struct cifs_fid *fid,
233839b1df65a24 Pavel Shilovsky            2012-09-19  254  					 struct tcon_link *tlink,
233839b1df65a24 Pavel Shilovsky            2012-09-19  255  					 struct cifs_pending_open *open);
233839b1df65a24 Pavel Shilovsky            2012-09-19  256  extern void cifs_del_pending_open(struct cifs_pending_open *open);
2727ef44ea4615d Ronnie Sahlberg            2020-12-09  257  extern struct TCP_Server_Info *cifs_get_tcp_session(struct smb3_fs_context *ctx);
53e0e11efe92895 Pavel Shilovsky            2016-11-04  258  extern void cifs_put_tcp_session(struct TCP_Server_Info *server,
53e0e11efe92895 Pavel Shilovsky            2016-11-04  259  				 int from_reconnect);
53e0e11efe92895 Pavel Shilovsky            2016-11-04  260  extern void cifs_put_tcon(struct cifs_tcon *tcon);
815465c4d724e85 Jeff Layton                2012-03-21  261  
815465c4d724e85 Jeff Layton                2012-03-21  262  #if IS_ENABLED(CONFIG_CIFS_DFS_UPCALL)
78d31a3a87f84cf Igor Mammedov              2008-04-24  263  extern void cifs_dfs_release_automount_timer(void);
815465c4d724e85 Jeff Layton                2012-03-21  264  #else /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
815465c4d724e85 Jeff Layton                2012-03-21  265  #define cifs_dfs_release_automount_timer()	do { } while (0)
815465c4d724e85 Jeff Layton                2012-03-21  266  #endif /* ! IS_ENABLED(CONFIG_CIFS_DFS_UPCALL) */
815465c4d724e85 Jeff Layton                2012-03-21  267  
^1da177e4c3f415 Linus Torvalds             2005-04-16  268  void cifs_proc_init(void);
^1da177e4c3f415 Linus Torvalds             2005-04-16  269  void cifs_proc_clean(void);
^1da177e4c3f415 Linus Torvalds             2005-04-16  270  
f7ba7fe685bc3ed Pavel Shilovsky            2012-09-19  271  extern void cifs_move_llist(struct list_head *source, struct list_head *dest);
f7ba7fe685bc3ed Pavel Shilovsky            2012-09-19  272  extern void cifs_free_llist(struct list_head *llist);
f7ba7fe685bc3ed Pavel Shilovsky            2012-09-19  273  extern void cifs_del_lock_waiters(struct cifsLockInfo *lock);
f7ba7fe685bc3ed Pavel Shilovsky            2012-09-19  274  
565674d613d7f45 Stefan Metzmacher          2020-07-21  275  extern int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon,
565674d613d7f45 Stefan Metzmacher          2020-07-21  276  			     const struct nls_table *nlsc);
565674d613d7f45 Stefan Metzmacher          2020-07-21  277  
286170aa241819f Pavel Shilovsky            2012-05-25  278  extern int cifs_negotiate_protocol(const unsigned int xid,
96daf2b09178d8e Steve French               2011-05-27  279  				   struct cifs_ses *ses);
58c45c58a1cbc8d Pavel Shilovsky            2012-05-25  280  extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
^1da177e4c3f415 Linus Torvalds             2005-04-16  281  			      struct nls_table *nls_info);
38d77c50b4f4e3e Jeff Layton                2013-05-26  282  extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
286170aa241819f Pavel Shilovsky            2012-05-25  283  extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
^1da177e4c3f415 Linus Torvalds             2005-04-16  284  
2e6e02ab6ddbd53 Pavel Shilovsky            2012-05-25  285  extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
96daf2b09178d8e Steve French               2011-05-27  286  		    const char *tree, struct cifs_tcon *tcon,
^1da177e4c3f415 Linus Torvalds             2005-04-16  287  		    const struct nls_table *);
^1da177e4c3f415 Linus Torvalds             2005-04-16  288  
6d5786a34d98bff Pavel Shilovsky            2012-06-20  289  extern int CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
c052e2b423f3eab Shirish Pargaonkar         2012-09-28  290  		const char *searchName, struct cifs_sb_info *cifs_sb,
2608bee744a92d6 Shirish Pargaonkar         2012-05-15  291  		__u16 *searchHandle, __u16 search_flags,
2608bee744a92d6 Shirish Pargaonkar         2012-05-15 @292  		struct cifs_search_info *psrch_inf,
c052e2b423f3eab Shirish Pargaonkar         2012-09-28  293  		bool msearch);
^1da177e4c3f415 Linus Torvalds             2005-04-16  294  

:::::: The code at line 96 was first introduced by commit
:::::: fec344e3f31aa911297cd3a4639432d983b1f324 cifs: change cifs_call_async to use smb_rqst structs

:::::: TO: Jeff Layton <jlayton@redhat.com>
:::::: CC: Steve French <smfrench@gmail.com>

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--+QahgC5+KEYLbs62
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--+QahgC5+KEYLbs62--

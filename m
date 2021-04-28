Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88360C433B4
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 03:37:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F37A613EF
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Apr 2021 03:37:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhD1Die (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Apr 2021 23:38:34 -0400
Received: from mga17.intel.com ([192.55.52.151]:44856 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230012AbhD1Die (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 27 Apr 2021 23:38:34 -0400
IronPort-SDR: ZDBerw1ri7O5zI81bjWSR+c4H2FJHeHOECUiGmuILu5iFiD/eAPz3t3eCcwTwe+35EusGDBlEB
 Sb8/s3ouBSSg==
X-IronPort-AV: E=McAfee;i="6200,9189,9967"; a="176765118"
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="176765118"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2021 20:37:49 -0700
IronPort-SDR: x4oPvsj3uFcvLGBRocjrPq6An4idP2mL79CIsgfSGZjiQYOmr7BlFigZRUS8cAkgOJgIzJx7rh
 l4PDbkjltaow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,257,1613462400"; 
   d="scan'208";a="454897897"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Apr 2021 20:37:47 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lbb1G-0006un-Mm; Wed, 28 Apr 2021 03:37:46 +0000
Date:   Wed, 28 Apr 2021 11:37:14 +0800
From:   kernel test robot <lkp@intel.com>
To:     Shyam Prasad N <sprasad@microsoft.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org,
        Steve French <stfrench@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH cifs] cifs: smb2_query_info_compound_final can be static
Message-ID: <20210428033714.GA62842@ef09cc136aa1>
References: <202104281139.5F0W4c8s-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202104281139.5F0W4c8s-lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fs/cifs/smb2ops.c:2671:1: warning: symbol 'smb2_query_info_compound_final' was not declared. Should it be static?
fs/cifs/smb2ops.c:3284:1: warning: symbol 'smb2_query_reparse_tag_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:2478:5: warning: symbol 'smb311_posix_mkdir_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:2842:1: warning: symbol 'SMB2_open_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:3056:1: warning: symbol 'SMB2_ioctl_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:3247:1: warning: symbol '__SMB2_close_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:3641:1: warning: symbol 'SMB2_change_notify_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:3870:1: warning: symbol 'SMB2_flush_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:4118:1: warning: symbol 'smb2_async_readv_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:4205:1: warning: symbol 'SMB2_read_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:4388:1: warning: symbol 'smb2_async_writev_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:4542:1: warning: symbol 'SMB2_write_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:4946:1: warning: symbol 'SMB2_query_directory_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5200:1: warning: symbol 'SMB2_oplock_break_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5333:1: warning: symbol 'SMB311_posix_qfs_info_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5398:1: warning: symbol 'SMB2_QFS_info_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5463:1: warning: symbol 'SMB2_QFS_attr_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5562:1: warning: symbol 'smb2_lockv_final' was not declared. Should it be static?
fs/cifs/smb2pdu.c:5654:1: warning: symbol 'SMB2_lease_break_final' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 smb2ops.c |    4 ++--
 smb2pdu.c |   34 +++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 19d2e746d7802..3a224f91fc87e 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2667,7 +2667,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
  * Passes the query info response back to the caller on success.
  * Caller need to free this with free_rsp_buf().
  */
-int
+static int
 smb2_query_info_compound_final(const unsigned int xid, struct cifs_tcon *tcon,
 			 __le16 *utf16_path, u32 desired_access,
 			 u32 class, u32 type, u32 output_len,
@@ -3280,7 +3280,7 @@ smb2_query_symlink(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int
+static int
 smb2_query_reparse_tag_final(const unsigned int xid, struct cifs_tcon *tcon,
 		   struct cifs_sb_info *cifs_sb, const char *full_path,
 		   __u32 *tag)
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dbf679a5da6cf..992a2faedd652 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2475,7 +2475,7 @@ alloc_path_with_tree_prefix(__le16 **out_path, int *out_size, int *out_len,
 	return 0;
 }
 
-int smb311_posix_mkdir_final(const unsigned int xid, struct inode *inode,
+static int smb311_posix_mkdir_final(const unsigned int xid, struct inode *inode,
 			       umode_t mode, struct cifs_tcon *tcon,
 			       const char *full_path,
 			       struct cifs_sb_info *cifs_sb)
@@ -2839,7 +2839,7 @@ SMB2_open_free(struct smb_rqst *rqst)
 }
 
 int
-SMB2_open_final(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
+static SMB2_open_final(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	  __u8 *oplock, struct smb2_file_all_info *buf,
 	  struct create_posix_rsp *posix,
 	  struct kvec *err_iov, int *buftype)
@@ -3053,7 +3053,7 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
  *	SMB2 IOCTL is used for both IOCTLs and FSCTLs
  */
 int
-SMB2_ioctl_final(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+static SMB2_ioctl_final(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	   u64 volatile_fid, u32 opcode, bool is_fsctl,
 	   char *in_data, u32 indatalen, u32 max_out_data_len,
 	   char **out_data, u32 *plen /* returned data len */)
@@ -3244,7 +3244,7 @@ SMB2_close_free(struct smb_rqst *rqst)
 }
 
 int
-__SMB2_close_final(const unsigned int xid, struct cifs_tcon *tcon,
+static __SMB2_close_final(const unsigned int xid, struct cifs_tcon *tcon,
 	     u64 persistent_fid, u64 volatile_fid,
 	     struct smb2_file_network_open_info *pbuf)
 {
@@ -3638,7 +3638,7 @@ SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
 }
 
 int
-SMB2_change_notify_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_change_notify_final(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid, bool watch_tree,
 		u32 completion_filter)
 {
@@ -3867,7 +3867,7 @@ SMB2_flush_init(const unsigned int xid, struct smb_rqst *rqst,
 }
 
 int
-SMB2_flush_final(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
+static SMB2_flush_final(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	   u64 volatile_fid)
 {
 	struct cifs_ses *ses = tcon->ses;
@@ -4114,7 +4114,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	add_credits(server, &credits, 0);
 }
 
-int
+static int
 smb2_async_readv_final(struct cifs_readdata *rdata)
 {
 	int rc, flags = 0;
@@ -4202,7 +4202,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 }
 
 int
-SMB2_read_final(const unsigned int xid, struct cifs_io_parms *io_parms,
+static SMB2_read_final(const unsigned int xid, struct cifs_io_parms *io_parms,
 	  unsigned int *nbytes, char **buf, int *buf_type)
 {
 	struct smb_rqst rqst;
@@ -4384,7 +4384,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 	add_credits(server, &credits, 0);
 }
 
-int
+static int
 smb2_async_writev_final(struct cifs_writedata *wdata,
 		  void (*release)(struct kref *kref))
 {
@@ -4539,7 +4539,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 }
 
 int
-SMB2_write_final(const unsigned int xid, struct cifs_io_parms *io_parms,
+static SMB2_write_final(const unsigned int xid, struct cifs_io_parms *io_parms,
 	   unsigned int *nbytes, struct kvec *iov, int n_vec)
 {
 	struct smb_rqst rqst;
@@ -4943,7 +4943,7 @@ smb2_parse_query_directory(struct cifs_tcon *tcon,
 }
 
 int
-SMB2_query_directory_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_query_directory_final(const unsigned int xid, struct cifs_tcon *tcon,
 		     u64 persistent_fid, u64 volatile_fid, int index,
 		     struct cifs_search_info *srch_inf)
 {
@@ -5197,7 +5197,7 @@ SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-SMB2_oplock_break_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_oplock_break_final(const unsigned int xid, struct cifs_tcon *tcon,
 		  const u64 persistent_fid, const u64 volatile_fid,
 		  __u8 oplock_level)
 {
@@ -5330,7 +5330,7 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon,
 }
 
 int
-SMB311_posix_qfs_info_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB311_posix_qfs_info_final(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
 {
 	struct smb_rqst rqst;
@@ -5395,7 +5395,7 @@ SMB311_posix_qfs_info(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-SMB2_QFS_info_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_QFS_info_final(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, struct kstatfs *fsdata)
 {
 	struct smb_rqst rqst;
@@ -5460,7 +5460,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-SMB2_QFS_attr_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_QFS_attr_final(const unsigned int xid, struct cifs_tcon *tcon,
 	      u64 persistent_fid, u64 volatile_fid, int level)
 {
 	struct smb_rqst rqst;
@@ -5558,7 +5558,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
-int
+static int
 smb2_lockv_final(const unsigned int xid, struct cifs_tcon *tcon,
 	   const __u64 persist_fid, const __u64 volatile_fid, const __u32 pid,
 	   const __u32 num_lock, struct smb2_lock_element *buf)
@@ -5651,7 +5651,7 @@ SMB2_lock(const unsigned int xid, struct cifs_tcon *tcon,
 }
 
 int
-SMB2_lease_break_final(const unsigned int xid, struct cifs_tcon *tcon,
+static SMB2_lease_break_final(const unsigned int xid, struct cifs_tcon *tcon,
 		 __u8 *lease_key, const __le32 lease_state)
 {
 	struct smb_rqst rqst;

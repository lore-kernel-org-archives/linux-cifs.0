Return-Path: <SRS0=BNow=DM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42BBC4363A
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 07:40:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6264920756
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Oct 2020 07:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbgJEHkP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Oct 2020 03:40:15 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:44252 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgJEHkO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Oct 2020 03:40:14 -0400
X-IronPort-AV: E=Sophos;i="5.77,338,1596492000"; 
   d="gz'50?scan'50,208,50";a="470921918"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 09:39:59 +0200
Date:   Mon, 5 Oct 2020 09:39:58 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
cc:     Steve French <smfrench@gmail.com>, kbuild-all@lists.01.org
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot (fwd)
Message-ID: <alpine.DEB.2.22.394.2010050939080.4774@hadrien>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="u3/rZRmxL6MmkK24"
Content-ID: <alpine.DEB.2.22.394.2010050939081.4774@hadrien>
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=US-ASCII
Content-ID: <alpine.DEB.2.22.394.2010050939082.4774@hadrien>
Content-Disposition: inline

Hello,

It looks like an unlock may be needed on line 1056.

julia

---------- Forwarded message ----------
Date: Mon, 5 Oct 2020 14:47:01 +0800
From: kernel test robot <lkp@intel.com>
To: kbuild@lists.01.org
Cc: lkp@intel.com, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 3/3] cifs: cache the directory content for shroot

CC: kbuild-all@lists.01.org
In-Reply-To: <20201005023754.13604-4-lsahlber@redhat.com>
References: <20201005023754.13604-4-lsahlber@redhat.com>
TO: Ronnie Sahlberg <lsahlber@redhat.com>
TO: "linux-cifs" <linux-cifs@vger.kernel.org>
CC: Steve French <smfrench@gmail.com>

Hi Ronnie,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on v5.9-rc8 next-20201002]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Ronnie-Sahlberg/cifs-cache-the-directory-content-for-shroot/20201005-104037
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
:::::: branch date: 4 hours ago
:::::: commit date: 4 hours ago
config: i386-randconfig-c001-20201005 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-15) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@lip6.fr>

	echo
	echo "coccinelle warnings: (new ones prefixed by >>)"
	echo
>> fs/cifs/readdir.c:1184:1-7: preceding lock on line 1040

vim +1184 fs/cifs/readdir.c

^1da177e4c3f415 Linus Torvalds   2005-04-16  1010
be4ccdcc2575ae1 Al Viro          2013-05-22  1011  int cifs_readdir(struct file *file, struct dir_context *ctx)
^1da177e4c3f415 Linus Torvalds   2005-04-16  1012  {
^1da177e4c3f415 Linus Torvalds   2005-04-16  1013  	int rc = 0;
6d5786a34d98bff Pavel Shilovsky  2012-06-20  1014  	unsigned int xid;
6d5786a34d98bff Pavel Shilovsky  2012-06-20  1015  	int i;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1016  	struct cifs_tcon *tcon, *mtcon;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1017  	struct cifsFileInfo *cifsFile = NULL;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1018  	char *current_entry;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1019  	int num_to_fill = 0;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1020  	char *tmp_buf = NULL;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1021  	char *end_of_smb;
18295796a30cada Jeff Layton      2009-04-30  1022  	unsigned int max_len;
010d984773e7614 Ronnie Sahlberg  2020-10-05  1023  	char *full_path = NULL;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1024  	struct cached_fid *cfid = NULL;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1025  	struct cifs_sb_info *cifs_sb = CIFS_FILE_SB(file);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1026
6d5786a34d98bff Pavel Shilovsky  2012-06-20  1027  	xid = get_xid();
010d984773e7614 Ronnie Sahlberg  2020-10-05  1028  	full_path = build_path_from_dentry(file_dentry(file));
010d984773e7614 Ronnie Sahlberg  2020-10-05  1029  	if (full_path == NULL) {
010d984773e7614 Ronnie Sahlberg  2020-10-05  1030  		rc = -ENOMEM;
010d984773e7614 Ronnie Sahlberg  2020-10-05  1031  		goto rddir2_exit;
010d984773e7614 Ronnie Sahlberg  2020-10-05  1032  	}
010d984773e7614 Ronnie Sahlberg  2020-10-05  1033
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1034  	mtcon = cifs_sb_master_tcon(cifs_sb);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1035  	if (!is_smb1_server(mtcon->ses->server) && !strcmp(full_path, "")) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1036  		rc = open_shroot(xid, mtcon, cifs_sb, &cfid);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1037  		if (rc)
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1038  			goto cache_not_found;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1039
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05 @1040  		mutex_lock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1041  		/*
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1042  		 * If this was reading from the start of the directory
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1043  		 * we need to initialize scanning and storing the
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1044  		 * directory content.
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1045  		 */
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1046  		if (ctx->pos == 0 && cfid->dirents.ctx == NULL) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1047  			cfid->dirents.ctx = ctx;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1048  			cfid->dirents.pos = 2;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1049  		}
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1050  		/*
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1051  		 * If we already have the entire directory cached then
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1052  		 * we can just serve the cache.
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1053  		 */
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1054  		if (cfid->dirents.is_valid) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1055  			if (!dir_emit_dots(file, ctx))
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1056  				goto rddir2_exit;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1057  			emit_cached_dirents(&cfid->dirents, ctx);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1058  			mutex_unlock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1059  			goto rddir2_exit;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1060  		}
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1061  		mutex_unlock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1062  	}
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1063   cache_not_found:
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1064
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1065  	/* Drop the cache while calling initiate_cifs_search and
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1066  	 * find_cifs_entry in case there will be reconnects during
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1067  	 * query_directory.
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1068  	 */
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1069  	if (cfid) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1070  		close_shroot(cfid);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1071  		cfid = NULL;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1072  	}
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1073
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1074
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1075  	/*
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1076  	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1077  	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1078  	 */
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1079  	if (file->private_data == NULL) {
010d984773e7614 Ronnie Sahlberg  2020-10-05  1080  		rc = initiate_cifs_search(xid, file, full_path);
f96637be081141d Joe Perches      2013-05-04  1081  		cifs_dbg(FYI, "initiate cifs search rc %d\n", rc);
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1082  		if (rc)
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1083  			goto rddir2_exit;
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1084  	}
6221ddd0f5e2ddc Suresh Jayaraman 2010-10-01  1085
be4ccdcc2575ae1 Al Viro          2013-05-22  1086  	if (!dir_emit_dots(file, ctx))
be4ccdcc2575ae1 Al Viro          2013-05-22  1087  		goto rddir2_exit;
be4ccdcc2575ae1 Al Viro          2013-05-22  1088
^1da177e4c3f415 Linus Torvalds   2005-04-16  1089  	/* 1) If search is active,
^1da177e4c3f415 Linus Torvalds   2005-04-16  1090  		is in current search buffer?
^1da177e4c3f415 Linus Torvalds   2005-04-16  1091  		if it before then restart search
^1da177e4c3f415 Linus Torvalds   2005-04-16  1092  		if after then keep searching till find it */
^1da177e4c3f415 Linus Torvalds   2005-04-16  1093
^1da177e4c3f415 Linus Torvalds   2005-04-16  1094  	cifsFile = file->private_data;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1095  	tcon = tlink_tcon(cifsFile->tlink);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1096  	if (cifsFile->srch_inf.endOfSearch) {
^1da177e4c3f415 Linus Torvalds   2005-04-16  1097  		if (cifsFile->srch_inf.emptyDir) {
f96637be081141d Joe Perches      2013-05-04  1098  			cifs_dbg(FYI, "End of search, empty dir\n");
^1da177e4c3f415 Linus Torvalds   2005-04-16  1099  			rc = 0;
be4ccdcc2575ae1 Al Viro          2013-05-22  1100  			goto rddir2_exit;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1101  		}
^1da177e4c3f415 Linus Torvalds   2005-04-16  1102  	} /* else {
4b18f2a9c3964f7 Steve French     2008-04-29  1103  		cifsFile->invalidHandle = true;
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1104  		tcon->ses->server->close(xid, tcon, &cifsFile->fid);
aaa9bbe039febf1 Steve French     2008-05-23  1105  	} */
^1da177e4c3f415 Linus Torvalds   2005-04-16  1106
010d984773e7614 Ronnie Sahlberg  2020-10-05  1107  	rc = find_cifs_entry(xid, tcon, ctx->pos, file, full_path,
010d984773e7614 Ronnie Sahlberg  2020-10-05  1108  			     &current_entry, &num_to_fill);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1109  	if (!is_smb1_server(tcon->ses->server) && !strcmp(full_path, "")) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1110  		open_shroot(xid, mtcon, cifs_sb, &cfid);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1111  	}
^1da177e4c3f415 Linus Torvalds   2005-04-16  1112  	if (rc) {
f96637be081141d Joe Perches      2013-05-04  1113  		cifs_dbg(FYI, "fce error %d\n", rc);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1114  		goto rddir2_exit;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1115  	} else if (current_entry != NULL) {
be4ccdcc2575ae1 Al Viro          2013-05-22  1116  		cifs_dbg(FYI, "entry %lld found\n", ctx->pos);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1117  	} else {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1118  		if (cfid) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1119  			mutex_lock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1120  			finished_cached_dirents_count(&cfid->dirents, ctx);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1121  			mutex_unlock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1122  		}
a0a3036b81f1f66 Joe Perches      2020-04-14  1123  		cifs_dbg(FYI, "Could not find entry\n");
^1da177e4c3f415 Linus Torvalds   2005-04-16  1124  		goto rddir2_exit;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1125  	}
f96637be081141d Joe Perches      2013-05-04  1126  	cifs_dbg(FYI, "loop through %d times filling dir for net buf %p\n",
b6b38f704a8193d Joe Perches      2010-04-21  1127  		 num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1128  	max_len = tcon->ses->server->ops->calc_smb_size(
9ec672bd17131fe Ronnie Sahlberg  2018-04-22  1129  			cifsFile->srch_inf.ntwrk_buf_start,
9ec672bd17131fe Ronnie Sahlberg  2018-04-22  1130  			tcon->ses->server);
5bafd76593f0605 Steve French     2006-06-07  1131  	end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
5bafd76593f0605 Steve French     2006-06-07  1132
f58841666bc22e8 Jeff Layton      2009-04-30  1133  	tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
f55fdcca6bf1c17 Kulikov Vasiliy  2010-07-16  1134  	if (tmp_buf == NULL) {
f55fdcca6bf1c17 Kulikov Vasiliy  2010-07-16  1135  		rc = -ENOMEM;
be4ccdcc2575ae1 Al Viro          2013-05-22  1136  		goto rddir2_exit;
f55fdcca6bf1c17 Kulikov Vasiliy  2010-07-16  1137  	}
f55fdcca6bf1c17 Kulikov Vasiliy  2010-07-16  1138
be4ccdcc2575ae1 Al Viro          2013-05-22  1139  	for (i = 0; i < num_to_fill; i++) {
^1da177e4c3f415 Linus Torvalds   2005-04-16  1140  		if (current_entry == NULL) {
^1da177e4c3f415 Linus Torvalds   2005-04-16  1141  			/* evaluate whether this case is an error */
f96637be081141d Joe Perches      2013-05-04  1142  			cifs_dbg(VFS, "past SMB end,  num to fill %d i %d\n",
b6b38f704a8193d Joe Perches      2010-04-21  1143  				 num_to_fill, i);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1144  			break;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1145  		}
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1146  		/*
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1147  		 * if buggy server returns . and .. late do we want to
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1148  		 * check for that here?
92fc65a74a2be13 Pavel Shilovsky  2012-09-18  1149  		 */
01b9b0b28626db4 Vasily Averin    2016-01-14  1150  		*tmp_buf = 0;
be4ccdcc2575ae1 Al Viro          2013-05-22  1151  		rc = cifs_filldir(current_entry, file, ctx,
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1152  				  tmp_buf, max_len, cfid);
be4ccdcc2575ae1 Al Viro          2013-05-22  1153  		if (rc) {
be4ccdcc2575ae1 Al Viro          2013-05-22  1154  			if (rc > 0)
7ca85ba752e521f Steve French     2006-10-30  1155  				rc = 0;
7ca85ba752e521f Steve French     2006-10-30  1156  			break;
7ca85ba752e521f Steve French     2006-10-30  1157  		}
7ca85ba752e521f Steve French     2006-10-30  1158
be4ccdcc2575ae1 Al Viro          2013-05-22  1159  		ctx->pos++;
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1160  		if (cfid) {
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1161  			mutex_lock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1162  			update_cached_dirents_count(&cfid->dirents, ctx);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1163  			mutex_unlock(&cfid->dirents.de_mutex);
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1164  		}
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1165
be4ccdcc2575ae1 Al Viro          2013-05-22  1166  		if (ctx->pos ==
3979877e5606ecc Steve French     2006-05-31  1167  			cifsFile->srch_inf.index_of_last_entry) {
f96637be081141d Joe Perches      2013-05-04  1168  			cifs_dbg(FYI, "last entry in buf at pos %lld %s\n",
be4ccdcc2575ae1 Al Viro          2013-05-22  1169  				 ctx->pos, tmp_buf);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1170  			cifs_save_resume_key(current_entry, cifsFile);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1171  			break;
^1da177e4c3f415 Linus Torvalds   2005-04-16  1172  		} else
5bafd76593f0605 Steve French     2006-06-07  1173  			current_entry =
5bafd76593f0605 Steve French     2006-06-07  1174  				nxt_dir_entry(current_entry, end_of_smb,
5bafd76593f0605 Steve French     2006-06-07  1175  					cifsFile->srch_inf.info_level);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1176  	}
^1da177e4c3f415 Linus Torvalds   2005-04-16  1177  	kfree(tmp_buf);
^1da177e4c3f415 Linus Torvalds   2005-04-16  1178
^1da177e4c3f415 Linus Torvalds   2005-04-16  1179  rddir2_exit:
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1180  	if (cfid)
7975d587dc0ef40 Ronnie Sahlberg  2020-10-05  1181  		close_shroot(cfid);
010d984773e7614 Ronnie Sahlberg  2020-10-05  1182  	kfree(full_path);
6d5786a34d98bff Pavel Shilovsky  2012-06-20  1183  	free_xid(xid);
^1da177e4c3f415 Linus Torvalds   2005-04-16 @1184  	return rc;

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
--u3/rZRmxL6MmkK24
Content-Type: application/gzip; CHARSET=US-ASCII
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.22.394.2010050939083.4774@hadrien>
Content-Description: 
Content-Disposition: attachment; filename=.config.gz

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
AQA=

--u3/rZRmxL6MmkK24--
